"""
Black Mamba (.bmb) Native x86-64 Machine Code Assembler & JIT Execution Engine.

Translates Mamba IR (MIR) directly into raw x86-64 machine code bytes following the
Windows x64 Calling Convention (Win64 ABI) with:
- Frequency-ranked hardware register allocation across Win64 non-volatile registers (r12..r15, rbx, rsi, rdi)
- Macro-op compare-and-branch fusion (`CMP_*_I64` + `JZ` -> `cmp` + `jcc`)
- Immediate operand folding (`add/sub/cmp/and/shl/sar rax, imm`)
- SSE2 hardware floating-point instructions (`addsd`, `subsd`, `mulsd`, `divsd`, `sqrtsd`, `ucomisd`)
"""

import ctypes
import math
import os
import socket
import struct
import sys
import time
from dataclasses import dataclass
from typing import Any, Callable, Dict, List, Optional, Set, Tuple, Union
from ..mir import MIRFunction, MIRInstr, MIRModule


# x86-64 Register Encoding Table: name -> (reg_num 0..7, is_extended 0..1)
REG_ENCODING: Dict[str, Tuple[int, int]] = {
    "rax": (0, 0),
    "rcx": (1, 0),
    "rdx": (2, 0),
    "rbx": (3, 0),
    "rsp": (4, 0),
    "rbp": (5, 0),
    "rsi": (6, 0),
    "rdi": (7, 0),
    "r8": (0, 1),
    "r9": (1, 1),
    "r10": (2, 1),
    "r11": (3, 1),
    "r12": (4, 1),
    "r13": (5, 1),
    "r14": (6, 1),
    "r15": (7, 1),
}

# 7 Win64 callee-saved (non-volatile) general-purpose registers available for local variables
CALLEE_SAVED_REGS = ["r12", "r13", "r14", "r15", "rbx", "rsi", "rdi"]


@dataclass
class AsmLine:
    offset: int
    raw_bytes: bytes
    mnemonic: str

    def format(self) -> str:
        hex_str = " ".join(f"{b:02X}" for b in self.raw_bytes)
        return f"  0x{self.offset:04X}:  {hex_str:<26} {self.mnemonic}"


class X86_64CodeBuffer:
    """Low-level x86-64 instruction encoder with register allocation, branch fusion, and disassembly."""

    def __init__(self):
        self.code = bytearray()
        self.asm_lines: List[AsmLine] = []
        self.labels: Dict[str, int] = {}
        self.rel32_fixups: List[Tuple[int, str]] = []
        self.line_map: List[Tuple[int, str, int]] = []
        self.func_ranges: List[Tuple[int, int, str, int]] = []

    def mark_label(self, name: str) -> None:
        self.labels[name] = len(self.code)
        self.asm_lines.append(AsmLine(offset=len(self.code), raw_bytes=b"", mnemonic=f"{name}:"))

    def emit(self, raw: bytes, mnemonic: str) -> None:
        off = len(self.code)
        self.code.extend(raw)
        self.asm_lines.append(AsmLine(offset=off, raw_bytes=bytes(raw), mnemonic=mnemonic))

    # --- Prologue / Epilogue ---

    def push_rbp(self) -> None:
        self.emit(b"\x55", "push rbp")

    def mov_rbp_rsp(self) -> None:
        self.emit(b"\x48\x89\xE5", "mov rbp, rsp")

    def push_callee_saved(self) -> None:
        self.emit(b"\x53", "push rbx")
        self.emit(b"\x56", "push rsi")
        self.emit(b"\x57", "push rdi")
        self.emit(b"\x41\x54", "push r12")
        self.emit(b"\x41\x55", "push r13")
        self.emit(b"\x41\x56", "push r14")
        self.emit(b"\x41\x57", "push r15")

    def pop_callee_saved_and_ret(self) -> None:
        self.emit(b"\x48\x8D\x65\xC8", "lea rsp, [rbp - 56]")
        self.emit(b"\x41\x5F", "pop r15")
        self.emit(b"\x41\x5E", "pop r14")
        self.emit(b"\x41\x5D", "pop r13")
        self.emit(b"\x41\x5C", "pop r12")
        self.emit(b"\x5F", "pop rdi")
        self.emit(b"\x5E", "pop rsi")
        self.emit(b"\x5B", "pop rbx")
        self.emit(b"\x5D", "pop rbp")
        self.emit(b"\xC3", "ret")

    def sub_rsp_imm32(self, imm: int) -> None:
        if imm <= 127:
            self.emit(b"\x48\x83\xEC" + struct.pack("<b", imm), f"sub rsp, 0x{imm:X}")
        else:
            self.emit(b"\x48\x81\xEC" + struct.pack("<i", imm), f"sub rsp, 0x{imm:X}")

    def add_rsp_imm32(self, imm: int) -> None:
        if imm <= 127:
            self.emit(b"\x48\x83\xC4" + struct.pack("<b", imm), f"add rsp, 0x{imm:X}")
        else:
            self.emit(b"\x48\x81\xC4" + struct.pack("<i", imm), f"add rsp, 0x{imm:X}")

    def mov_rsp_rbp(self) -> None:
        self.emit(b"\x48\x89\xEC", "mov rsp, rbp")

    def pop_rbp(self) -> None:
        self.emit(b"\x5D", "pop rbp")

    def ret(self) -> None:
        self.emit(b"\xC3", "ret")

    # --- General Register Moves ---

    def mov_reg_reg(self, dst: str, src: str, comment: str = "") -> None:
        if dst == src:
            return
        d_num, d_ext = REG_ENCODING[dst]
        s_num, s_ext = REG_ENCODING[src]
        rex = 0x48 | (s_ext << 2) | d_ext
        modrm = 0xC0 | (s_num << 3) | d_num
        sfx = f" ; {comment}" if comment else ""
        self.emit(bytes([rex, 0x89, modrm]), f"mov {dst}, {src}{sfx}")

    def mov_reg_imm64(self, reg: str, val: int, comment: str = "") -> None:
        r_num, r_ext = REG_ENCODING[reg]
        uval = val & 0xFFFFFFFFFFFFFFFF
        sfx = f" ; {comment}" if comment else ""
        if val == 0:
            rex = 0x48 | (r_ext << 2) | r_ext
            modrm = 0xC0 | (r_num << 3) | r_num
            self.emit(bytes([rex, 0x31, modrm]), f"xor {reg}, {reg}{sfx}")
        elif -0x80000000 <= val <= 0x7FFFFFFF:
            rex = 0x48 | r_ext
            modrm = 0xC0 | r_num
            self.emit(bytes([rex, 0xC7, modrm]) + struct.pack("<i", val), f"mov {reg}, {val}{sfx}")
        else:
            rex = 0x48 | r_ext
            op = 0xB8 + r_num
            self.emit(bytes([rex, op]) + struct.pack("<Q", uval), f"movabs {reg}, 0x{uval:016X}{sfx}")

    def mov_rax_imm64(self, val: int, comment: str = "") -> None:
        self.mov_reg_imm64("rax", val, comment.lstrip(" ;"))

    def mov_rcx_imm64(self, val: int) -> None:
        self.mov_reg_imm64("rcx", val)

    # --- Stack Slot Access ---

    def load_reg_slot(self, reg: str, disp: int, var_name: str = "") -> None:
        r_num, r_ext = REG_ENCODING[reg]
        rex = 0x48 | (r_ext << 2)
        lbl = f" [{var_name}]" if var_name else ""
        if -128 <= disp <= 127:
            modrm = 0x45 | (r_num << 3)
            self.emit(bytes([rex, 0x8B, modrm]) + struct.pack("<b", disp), f"mov {reg}, qword ptr [rbp - {abs(disp)}]{lbl}")
        else:
            modrm = 0x85 | (r_num << 3)
            self.emit(bytes([rex, 0x8B, modrm]) + struct.pack("<i", disp), f"mov {reg}, qword ptr [rbp - {abs(disp)}]{lbl}")

    def store_slot_reg(self, disp: int, reg: str, var_name: str = "") -> None:
        r_num, r_ext = REG_ENCODING[reg]
        rex = 0x48 | (r_ext << 2)
        lbl = f" [{var_name}]" if var_name else ""
        if -128 <= disp <= 127:
            modrm = 0x45 | (r_num << 3)
            self.emit(bytes([rex, 0x89, modrm]) + struct.pack("<b", disp), f"mov qword ptr [rbp - {abs(disp)}], {reg}{lbl}")
        else:
            modrm = 0x85 | (r_num << 3)
            self.emit(bytes([rex, 0x89, modrm]) + struct.pack("<i", disp), f"mov qword ptr [rbp - {abs(disp)}], {reg}{lbl}")

    def load_rax_slot(self, disp: int, var_name: str = "") -> None:
        self.load_reg_slot("rax", disp, var_name)

    def load_rcx_slot(self, disp: int, var_name: str = "") -> None:
        self.load_reg_slot("rcx", disp, var_name)

    def load_rdx_slot(self, disp: int, var_name: str = "") -> None:
        self.load_reg_slot("rdx", disp, var_name)

    def load_r8_slot(self, disp: int, var_name: str = "") -> None:
        self.load_reg_slot("r8", disp, var_name)

    def load_r9_slot(self, disp: int, var_name: str = "") -> None:
        self.load_reg_slot("r9", disp, var_name)

    def store_slot_rax(self, disp: int, var_name: str = "") -> None:
        self.store_slot_reg(disp, "rax", var_name)

    def store_slot_rcx(self, disp: int, var_name: str = "") -> None:
        self.store_slot_reg(disp, "rcx", var_name)

    def store_slot_rdx(self, disp: int, var_name: str = "") -> None:
        self.store_slot_reg(disp, "rdx", var_name)

    def store_slot_r8(self, disp: int, var_name: str = "") -> None:
        self.store_slot_reg(disp, "r8", var_name)

    def store_slot_r9(self, disp: int, var_name: str = "") -> None:
        self.store_slot_reg(disp, "r9", var_name)

    # --- 64-bit Integer ALU ---

    def add_rax_rcx(self) -> None:
        self.emit(b"\x48\x01\xC8", "add rax, rcx")

    def add_rax_imm32(self, imm: int) -> None:
        if -128 <= imm <= 127:
            self.emit(b"\x48\x83\xC0" + struct.pack("<b", imm), f"add rax, {imm}")
        else:
            self.emit(b"\x48\x05" + struct.pack("<i", imm), f"add rax, {imm}")

    def sub_rax_rcx(self) -> None:
        self.emit(b"\x48\x29\xC8", "sub rax, rcx")

    def sub_rax_imm32(self, imm: int) -> None:
        if -128 <= imm <= 127:
            self.emit(b"\x48\x83\xE8" + struct.pack("<b", imm), f"sub rax, {imm}")
        else:
            self.emit(b"\x48\x2D" + struct.pack("<i", imm), f"sub rax, {imm}")

    def imul_rax_rcx(self) -> None:
        self.emit(b"\x48\x0F\xAF\xC1", "imul rax, rcx")

    def imul_rax_imm32(self, imm: int) -> None:
        if -128 <= imm <= 127:
            self.emit(b"\x48\x6B\xC0" + struct.pack("<b", imm), f"imul rax, rax, {imm}")
        else:
            self.emit(b"\x48\x69\xC0" + struct.pack("<i", imm), f"imul rax, rax, {imm}")

    def idiv_rcx(self) -> None:
        self.emit(b"\x48\x99", "cqo")
        self.emit(b"\x48\xF7\xF9", "idiv rcx")

    def mov_rax_rdx(self) -> None:
        self.emit(b"\x48\x89\xD0", "mov rax, rdx")

    def and_rax_rcx(self) -> None:
        self.emit(b"\x48\x21\xC8", "and rax, rcx")

    def and_rax_imm32(self, imm: int) -> None:
        if -128 <= imm <= 127:
            self.emit(b"\x48\x83\xE0" + struct.pack("<b", imm), f"and rax, {imm}")
        else:
            self.emit(b"\x48\x25" + struct.pack("<i", imm), f"and rax, {imm}")

    def or_rax_rcx(self) -> None:
        self.emit(b"\x48\x09\xC8", "or rax, rcx")

    def xor_rax_rcx(self) -> None:
        self.emit(b"\x48\x31\xC8", "xor rax, rcx")

    def shl_rax_cl(self) -> None:
        self.emit(b"\x48\xD3\xE0", "shl rax, cl")

    def shl_rax_imm8(self, imm: int) -> None:
        self.emit(b"\x48\xC1\xE0" + struct.pack("<B", imm & 0x3F), f"shl rax, {imm & 0x3F}")

    def sar_rax_cl(self) -> None:
        self.emit(b"\x48\xD3\xF8", "sar rax, cl")

    def sar_rax_imm8(self, imm: int) -> None:
        self.emit(b"\x48\xC1\xF8" + struct.pack("<B", imm & 0x3F), f"sar rax, {imm & 0x3F}")

    def neg_rax(self) -> None:
        self.emit(b"\x48\xF7\xD8", "neg rax")

    def not_rax(self) -> None:
        self.emit(b"\x48\xF7\xD0", "not rax")

    def abs_rax(self) -> None:
        self.emit(b"\x48\x89\xC1", "mov rcx, rax")
        self.emit(b"\x48\xF7\xD9", "neg rcx")
        self.emit(b"\x48\x85\xC0", "test rax, rax")
        self.emit(b"\x48\x0F\x48\xC1", "cmovs rax, rcx")

    def cmp_rax_rcx(self) -> None:
        self.emit(b"\x48\x39\xC8", "cmp rax, rcx")

    def cmp_rax_imm32(self, imm: int) -> None:
        if -128 <= imm <= 127:
            self.emit(b"\x48\x83\xF8" + struct.pack("<b", imm), f"cmp rax, {imm}")
        else:
            self.emit(b"\x48\x3D" + struct.pack("<i", imm), f"cmp rax, {imm}")

    def cmp_i64_setcc(self, setcc_byte: int, cc_name: str) -> None:
        self.cmp_rax_rcx()
        self.emit(bytes([0x0F, setcc_byte, 0xC0]), f"set{cc_name} al")
        self.emit(b"\x48\x0F\xB6\xC0", "movzx rax, al")

    # --- 64-bit IEEE-754 Float (SSE2) ---

    def movq_xmm0_rax(self) -> None:
        self.emit(b"\x66\x48\x0F\x6E\xC0", "movq xmm0, rax")

    def movq_xmm1_rcx(self) -> None:
        self.emit(b"\x66\x48\x0F\x6E\xC9", "movq xmm1, rcx")

    def movq_rax_xmm0(self) -> None:
        self.emit(b"\x66\x48\x0F\x7E\xC0", "movq rax, xmm0")

    def addsd_xmm0_xmm1(self) -> None:
        self.emit(b"\xF2\x0F\x58\xC1", "addsd xmm0, xmm1")

    def subsd_xmm0_xmm1(self) -> None:
        self.emit(b"\xF2\x0F\x5C\xC1", "subsd xmm0, xmm1")

    def mulsd_xmm0_xmm1(self) -> None:
        self.emit(b"\xF2\x0F\x59\xC1", "mulsd xmm0, xmm1")

    def divsd_xmm0_xmm1(self) -> None:
        self.emit(b"\xF2\x0F\x5E\xC1", "divsd xmm0, xmm1")

    def sqrtsd_xmm0_xmm0(self) -> None:
        self.emit(b"\xF2\x0F\x51\xC0", "sqrtsd xmm0, xmm0")

    def cvtsi2sd_xmm0_rax(self) -> None:
        self.emit(b"\xF2\x48\x0F\x2A\xC0", "cvtsi2sd xmm0, rax")

    def cvttsd2si_rax_xmm0(self) -> None:
        self.emit(b"\xF2\x48\x0F\x2C\xC0", "cvttsd2si rax, xmm0")

    def cmp_f64_setcc(self, op: str) -> None:
        self.movq_xmm0_rax()
        self.movq_xmm1_rcx()
        self.emit(b"\x66\x0F\x2E\xC1", "ucomisd xmm0, xmm1")
        cc_map = {
            "CMP_EQ_F64": (0x94, "e"),
            "CMP_NE_F64": (0x95, "ne"),
            "CMP_GT_F64": (0x97, "a"),
            "CMP_GE_F64": (0x93, "ae"),
            "CMP_LT_F64": (0x92, "b"),
            "CMP_LE_F64": (0x96, "be"),
        }
        code, name = cc_map[op]
        self.emit(bytes([0x0F, code, 0xC0]), f"set{name} al")
        self.emit(b"\x48\x0F\xB6\xC0", "movzx rax, al")

    def load_idx_rax_rcx(self) -> None:
        self.emit(b"\x48\x8B\x04\xC8", "mov rax, qword ptr [rax + rcx*8]")

    def store_idx_rax_rcx_rdx(self) -> None:
        self.emit(b"\x48\x89\x14\xC8", "mov qword ptr [rax + rcx*8], rdx")

    # --- Branches & Calls ---

    def jmp_label(self, label: str) -> None:
        off = len(self.code)
        self.code.extend(b"\xE9\x00\x00\x00\x00")
        self.rel32_fixups.append((off + 1, label))
        self.asm_lines.append(AsmLine(offset=off, raw_bytes=b"\xE9\x00\x00\x00\x00", mnemonic=f"jmp {label}"))

    def jz_rax_label(self, label: str) -> None:
        self.emit(b"\x48\x85\xC0", "test rax, rax")
        self.jcc_rel32(0x84, "z", label)

    def jnz_rax_label(self, label: str) -> None:
        self.emit(b"\x48\x85\xC0", "test rax, rax")
        self.jcc_rel32(0x85, "nz", label)

    def jcc_rel32(self, cc_byte: int, cc_name: str, label: str) -> None:
        off = len(self.code)
        raw = bytes([0x0F, cc_byte, 0, 0, 0, 0])
        self.code.extend(raw)
        self.rel32_fixups.append((off + 2, label))
        self.asm_lines.append(AsmLine(offset=off, raw_bytes=raw, mnemonic=f"j{cc_name} {label}"))

    def call_label(self, label: str) -> None:
        off = len(self.code)
        self.code.extend(b"\xE8\x00\x00\x00\x00")
        self.rel32_fixups.append((off + 1, label))
        self.asm_lines.append(AsmLine(offset=off, raw_bytes=b"\xE8\x00\x00\x00\x00", mnemonic=f"call {label}"))

    def lea_reg_label(self, reg: str, label: str) -> None:
        table = {
            "rax": (0x48, 0x05), "rcx": (0x48, 0x0D), "rdx": (0x48, 0x15), "rbx": (0x48, 0x1D),
            "rsp": (0x48, 0x25), "rbp": (0x48, 0x2D), "rsi": (0x48, 0x35), "rdi": (0x48, 0x3D),
            "r8":  (0x4C, 0x05), "r9":  (0x4C, 0x0D), "r10": (0x4C, 0x15), "r11": (0x4C, 0x1D),
            "r12": (0x4C, 0x25), "r13": (0x4C, 0x2D), "r14": (0x4C, 0x35), "r15": (0x4C, 0x3D),
        }
        rex, modrm = table.get(reg, (0x48, 0x05))
        off = len(self.code)
        self.code.extend(bytes([rex, 0x8D, modrm, 0, 0, 0, 0]))
        self.rel32_fixups.append((off + 3, label))
        self.asm_lines.append(AsmLine(offset=off, raw_bytes=bytes([rex, 0x8D, modrm, 0, 0, 0, 0]), mnemonic=f"lea {reg}, [rip + {label}]"))

    def lea_rdx_label(self, label: str) -> None:
        self.lea_reg_label("rdx", label)

    def lea_rcx_label(self, label: str) -> None:
        self.lea_reg_label("rcx", label)

    def call_abs_addr(self, addr: int, name: str = "") -> None:
        self.mov_rax_imm64(addr, f" ; &{name}" if name else "")
        self.emit(b"\xFF\xD0", f"call rax ; {name}")

    def resolve_fixups(self) -> None:
        for patch_pos, label in self.rel32_fixups:
            if label not in self.labels:
                raise RuntimeError(f"Unresolved assembly label: {label}")
            target_off = self.labels[label]
            next_ip = patch_pos + 4
            rel32 = target_off - next_ip
            self.code[patch_pos : patch_pos + 4] = struct.pack("<i", rel32)

    # --- Shared Optimizing Function Compiler (Used by both JIT and PE32+ EXE) ---

    def compile_mir_function(
        self,
        fn: MIRFunction,
        emit_const_str: Callable[[MIRInstr, Callable[[str], None]], None],
        emit_helper_call: Callable[[str], None],
        fn_names: Optional[Set[str]] = None,
    ) -> int:
        """
        Compiles a MIRFunction into register-allocated, branch-fused x86-64 machine code.
        """
        fn_code_start = len(self.code)
        last_recorded_line = fn.start_line or 1
        self.line_map.append((fn_code_start, fn.name, last_recorded_line))
        self.mark_label(f"fn__{fn.name}")

        # 1. Analyze single-definition constant temporaries for immediate folding
        def_counts: Dict[str, int] = {}
        use_counts: Dict[str, int] = {}
        for p_name, _ in fn.params:
            def_counts[p_name] = 1
            use_counts[p_name] = 5

        for ins in fn.instructions:
            if ins.dst and ins.dst != "%void":
                def_counts[ins.dst] = def_counts.get(ins.dst, 0) + 1
            if isinstance(ins.arg1, str) and ins.op not in ("LABEL", "JMP", "CALL"):
                use_counts[ins.arg1] = use_counts.get(ins.arg1, 0) + 1
            if isinstance(ins.arg2, str) and ins.op not in ("JZ", "JNZ"):
                use_counts[ins.arg2] = use_counts.get(ins.arg2, 0) + 1
            for ex in ins.extra:
                use_counts[ex] = use_counts.get(ex, 0) + 1

        imm_i64: Dict[str, int] = {}
        for ins in fn.instructions:
            if (
                ins.op == "CONST_I64"
                and ins.dst
                and ins.dst.startswith("%t")
                and def_counts.get(ins.dst, 0) == 1
                and -0x80000000 <= int(ins.arg1) <= 0x7FFFFFFF
            ):
                imm_i64[ins.dst] = int(ins.arg1)

        # 2. Identify fused compare+branch pairs (CMP_*_I64 followed immediately by JZ on same temp)
        fused_indices: Set[int] = set()
        instrs = fn.instructions
        for idx in range(len(instrs) - 1):
            cur = instrs[idx]
            nxt = instrs[idx + 1]
            if (
                cur.op in ("CMP_EQ_I64", "CMP_NE_I64", "CMP_LT_I64", "CMP_LE_I64", "CMP_GT_I64", "CMP_GE_I64")
                and nxt.op == "JZ"
                and cur.dst == nxt.arg1
                and use_counts.get(str(cur.dst), 0) == 1
            ):
                fused_indices.add(idx)

        # 3. Frequency-ranked hardware register allocation into CALLEE_SAVED_REGS (r12..r15, rbx, rsi, rdi)
        local_names: Set[str] = set()
        for p_name, _ in fn.params:
            local_names.add(p_name)
        for ins in instrs:
            if ins.dst and ins.dst != "%void":
                local_names.add(ins.dst)

        all_vars: List[str] = []
        seen_v: Set[str] = set()
        for p_name, _ in fn.params:
            all_vars.append(p_name)
            seen_v.add(p_name)
        for idx, ins in enumerate(instrs):
            if idx in fused_indices:
                pass
            elif ins.dst and ins.dst != "%void" and ins.dst not in seen_v:
                all_vars.append(ins.dst)
                seen_v.add(ins.dst)
            for opnd in (ins.arg1, ins.arg2):
                if isinstance(opnd, str) and ins.op not in ("LABEL", "JMP", "CALL", "JZ", "JNZ") and opnd not in seen_v:
                    if opnd in local_names:
                        all_vars.append(opnd)
                        seen_v.add(opnd)
            for ex in ins.extra:
                if ex not in seen_v and ex in local_names:
                    all_vars.append(ex)
                    seen_v.add(ex)

        # Prioritize named variables & parameters first, then highest-use temporaries
        ranked_vars = sorted(
            [v for v in all_vars if v not in imm_i64],
            key=lambda v: (0 if not v.startswith("%") else 1, -use_counts.get(v, 0)),
        )
        reg_map: Dict[str, str] = {}
        for v, hreg in zip(ranked_vars[: len(CALLEE_SAVED_REGS)], CALLEE_SAVED_REGS):
            reg_map[v] = hreg

        # Remaining variables get stack slots starting below the 7 saved registers ([rbp - 64], [rbp - 72], ...)
        var_slots: Dict[str, int] = {}
        for v in all_vars:
            if v not in reg_map and v not in imm_i64:
                slot_idx = len(var_slots) + 1
                var_slots[v] = -56 - 8 * slot_idx

        def load_into(target_reg: str, vname: str) -> None:
            if vname in imm_i64:
                self.mov_reg_imm64(target_reg, imm_i64[vname], vname)
            elif vname in reg_map:
                self.mov_reg_reg(target_reg, reg_map[vname], vname)
            elif vname in var_slots:
                self.load_reg_slot(target_reg, var_slots[vname], vname)
            elif fn_names and vname in fn_names:
                self.lea_reg_label(target_reg, f"fn__{vname}")
            else:
                self.mov_reg_imm64(target_reg, 0, vname)

        def store_from_rax(vname: str) -> None:
            if vname in reg_map:
                self.mov_reg_reg(reg_map[vname], "rax", vname)
            else:
                self.store_slot_rax(var_slots[vname], vname)

        # Frame size must satisfy (56 + frame_size) % 16 == 0 so rsp is 16-byte aligned before `call`
        max_call_args = 4
        for ins in instrs:
            if ins.op == "CALL":
                max_call_args = max(max_call_args, len(ins.extra))
        outgoing_arg_space = max(32, max_call_args * 8)
        spilled_bytes = 8 * len(var_slots)
        min_sub = outgoing_arg_space + 8 + spilled_bytes  # Win64 outgoing arg space + spilled locals
        # Make (56 + frame_size) a multiple of 16 -> frame_size % 16 == 8
        aligned_16 = (min_sub + 15) & ~15
        frame_size = aligned_16 + 8

        # Prologue
        self.push_rbp()
        self.mov_rbp_rsp()
        self.push_callee_saved()
        self.sub_rsp_imm32(frame_size)

        # Move incoming Win64 register parameters (rcx, rdx, r8, r9) to their allocated registers/slots
        win64_arg_regs = ["rcx", "rdx", "r8", "r9"]
        for idx, (p_name, _) in enumerate(fn.params):
            if idx < 4:
                src_r = win64_arg_regs[idx]
                if p_name in reg_map:
                    self.mov_reg_reg(reg_map[p_name], src_r, p_name)
                else:
                    self.store_slot_reg(var_slots[p_name], src_r, p_name)
            else:
                caller_disp = 16 + 8 * idx
                self.emit(b"\x48\x8B\x85" + struct.pack("<i", caller_disp), f"mov rax, qword ptr [rbp + {caller_disp}]")
                store_from_rax(p_name)

        # Main instruction emission loop
        i = 0
        n = len(instrs)
        while i < n:
            ins = instrs[i]
            op = ins.op
            if getattr(ins, "line", 0) > 0 and ins.line != last_recorded_line:
                last_recorded_line = ins.line
                self.line_map.append((len(self.code), fn.name, last_recorded_line))

            # Skip standalone CONST_I64 if folded into immediate operands and never read via slot
            if op == "CONST_I64" and ins.dst in imm_i64:
                i += 1
                continue

            # Fused Compare + Conditional Branch (`CMP_*_I64` + `JZ`)
            if i in fused_indices:
                nxt = instrs[i + 1]
                target_lbl = f"{fn.name}__{nxt.arg2}"
                load_into("rax", str(ins.arg1))
                rhs_name = str(ins.arg2)
                if rhs_name in imm_i64:
                    self.cmp_rax_imm32(imm_i64[rhs_name])
                else:
                    load_into("rcx", rhs_name)
                    self.cmp_rax_rcx()
                # Inverted condition code because JZ jumps when comparison is FALSE
                inv_cc = {
                    "CMP_EQ_I64": (0x85, "ne"),
                    "CMP_NE_I64": (0x84, "e"),
                    "CMP_LT_I64": (0x8D, "ge"),
                    "CMP_LE_I64": (0x8F, "g"),
                    "CMP_GT_I64": (0x8E, "le"),
                    "CMP_GE_I64": (0x8C, "l"),
                }[op]
                self.jcc_rel32(inv_cc[0], inv_cc[1], target_lbl)
                i += 2
                continue

            if op == "LABEL":
                self.mark_label(f"{fn.name}__{ins.arg1}")
            elif op == "JMP":
                self.jmp_label(f"{fn.name}__{ins.arg1}")
            elif op == "JZ":
                load_into("rax", str(ins.arg1))
                self.jz_rax_label(f"{fn.name}__{ins.arg2}")
            elif op == "JNZ":
                load_into("rax", str(ins.arg1))
                self.jnz_rax_label(f"{fn.name}__{ins.arg2}")
            elif op == "RET":
                if ins.arg1 is not None and str(ins.arg1) != "%void":
                    load_into("rax", str(ins.arg1))
                else:
                    self.mov_rax_imm64(0)
                self.pop_callee_saved_and_ret()
            elif op == "CONST_I64":
                self.mov_rax_imm64(int(ins.arg1))
                store_from_rax(str(ins.dst))
            elif op == "CONST_F64":
                flt_val = float(ins.arg1)
                bits = struct.unpack("<q", struct.pack("<d", flt_val))[0]
                self.mov_rax_imm64(bits, f"f64({flt_val})")
                store_from_rax(str(ins.dst))
            elif op == "CONST_STR":
                emit_const_str(ins, store_from_rax)
            elif op == "MOV":
                src_v = str(ins.arg1)
                dst_v = str(ins.dst)
                if src_v in reg_map and dst_v in reg_map:
                    self.mov_reg_reg(reg_map[dst_v], reg_map[src_v], f"{dst_v} = {src_v}")
                elif src_v in imm_i64 and dst_v in reg_map:
                    self.mov_reg_imm64(reg_map[dst_v], imm_i64[src_v], f"{dst_v} = {imm_i64[src_v]}")
                else:
                    load_into("rax", src_v)
                    store_from_rax(dst_v)
            elif op == "NEG_I64":
                load_into("rax", str(ins.arg1))
                self.neg_rax()
                store_from_rax(str(ins.dst))
            elif op == "NOT_I64":
                load_into("rax", str(ins.arg1))
                self.not_rax()
                store_from_rax(str(ins.dst))
            elif op == "ABS_I64":
                load_into("rax", str(ins.arg1))
                self.abs_rax()
                store_from_rax(str(ins.dst))
            elif op == "NEG_F64":
                load_into("rax", str(ins.arg1))
                self.mov_rcx_imm64(-0x8000000000000000)
                self.xor_rax_rcx()
                store_from_rax(str(ins.dst))
            elif op == "ABS_F64":
                load_into("rax", str(ins.arg1))
                self.mov_rcx_imm64(0x7FFFFFFFFFFFFFFF)
                self.and_rax_rcx()
                store_from_rax(str(ins.dst))
            elif op == "SQRT_F64":
                load_into("rax", str(ins.arg1))
                self.movq_xmm0_rax()
                self.sqrtsd_xmm0_xmm0()
                self.movq_rax_xmm0()
                store_from_rax(str(ins.dst))
            elif op == "I64_TO_F64":
                load_into("rax", str(ins.arg1))
                self.cvtsi2sd_xmm0_rax()
                self.movq_rax_xmm0()
                store_from_rax(str(ins.dst))
            elif op == "F64_TO_I64":
                load_into("rax", str(ins.arg1))
                self.movq_xmm0_rax()
                self.cvttsd2si_rax_xmm0()
                store_from_rax(str(ins.dst))
            elif op in (
                "ADD_I64",
                "SUB_I64",
                "MUL_I64",
                "DIV_I64",
                "MOD_I64",
                "AND_I64",
                "OR_I64",
                "XOR_I64",
                "SHL_I64",
                "SHR_I64",
                "CMP_EQ_I64",
                "CMP_NE_I64",
                "CMP_LT_I64",
                "CMP_LE_I64",
                "CMP_GT_I64",
                "CMP_GE_I64",
            ):
                lhs_v = str(ins.arg1)
                rhs_v = str(ins.arg2)
                load_into("rax", lhs_v)
                if rhs_v in imm_i64 and op in ("ADD_I64", "SUB_I64", "MUL_I64", "AND_I64", "SHL_I64", "SHR_I64"):
                    imm_val = imm_i64[rhs_v]
                    if op == "ADD_I64":
                        self.add_rax_imm32(imm_val)
                    elif op == "SUB_I64":
                        self.sub_rax_imm32(imm_val)
                    elif op == "MUL_I64":
                        self.imul_rax_imm32(imm_val)
                    elif op == "AND_I64":
                        self.and_rax_imm32(imm_val)
                    elif op == "SHL_I64":
                        self.shl_rax_imm8(imm_val)
                    elif op == "SHR_I64":
                        self.sar_rax_imm8(imm_val)
                else:
                    load_into("rcx", rhs_v)
                    if op == "ADD_I64":
                        self.add_rax_rcx()
                    elif op == "SUB_I64":
                        self.sub_rax_rcx()
                    elif op == "MUL_I64":
                        self.imul_rax_rcx()
                    elif op == "DIV_I64":
                        self.idiv_rcx()
                    elif op == "MOD_I64":
                        self.idiv_rcx()
                        self.mov_rax_rdx()
                    elif op == "AND_I64":
                        self.and_rax_rcx()
                    elif op == "OR_I64":
                        self.or_rax_rcx()
                    elif op == "XOR_I64":
                        self.xor_rax_rcx()
                    elif op == "SHL_I64":
                        self.shl_rax_cl()
                    elif op == "SHR_I64":
                        self.sar_rax_cl()
                    elif op == "CMP_EQ_I64":
                        self.cmp_i64_setcc(0x94, "e")
                    elif op == "CMP_NE_I64":
                        self.cmp_i64_setcc(0x95, "ne")
                    elif op == "CMP_LT_I64":
                        self.cmp_i64_setcc(0x9C, "l")
                    elif op == "CMP_LE_I64":
                        self.cmp_i64_setcc(0x9E, "le")
                    elif op == "CMP_GT_I64":
                        self.cmp_i64_setcc(0x9F, "g")
                    elif op == "CMP_GE_I64":
                        self.cmp_i64_setcc(0x9D, "ge")
                store_from_rax(str(ins.dst))
            elif op in ("ADD_F64", "SUB_F64", "MUL_F64", "DIV_F64"):
                load_into("rax", str(ins.arg1))
                load_into("rcx", str(ins.arg2))
                self.movq_xmm0_rax()
                self.movq_xmm1_rcx()
                if op == "ADD_F64":
                    self.addsd_xmm0_xmm1()
                elif op == "SUB_F64":
                    self.subsd_xmm0_xmm1()
                elif op == "MUL_F64":
                    self.mulsd_xmm0_xmm1()
                elif op == "DIV_F64":
                    self.divsd_xmm0_xmm1()
                self.movq_rax_xmm0()
                store_from_rax(str(ins.dst))
            elif op in ("CMP_EQ_F64", "CMP_NE_F64", "CMP_LT_F64", "CMP_LE_F64", "CMP_GT_F64", "CMP_GE_F64"):
                load_into("rax", str(ins.arg1))
                load_into("rcx", str(ins.arg2))
                self.cmp_f64_setcc(op)
                store_from_rax(str(ins.dst))
            elif op == "POW_I64":
                load_into("rcx", str(ins.arg1))
                load_into("rdx", str(ins.arg2))
                emit_helper_call("pow_i64")
                store_from_rax(str(ins.dst))
            elif op == "POW_F64":
                load_into("rcx", str(ins.arg1))
                load_into("rdx", str(ins.arg2))
                emit_helper_call("pow_f64")
                store_from_rax(str(ins.dst))
            elif op == "ALLOC_ARR":
                load_into("rcx", str(ins.arg1))
                load_into("rdx", str(ins.arg2))
                emit_helper_call("alloc_arr")
                store_from_rax(str(ins.dst))
            elif op == "ARENA_SAVE":
                emit_helper_call("arena_save")
                store_from_rax(str(ins.dst))
            elif op == "ARENA_RESTORE":
                load_into("rcx", str(ins.arg1))
                emit_helper_call("arena_restore")
            elif op == "STR_CONCAT":
                load_into("rcx", str(ins.arg1))
                load_into("rdx", str(ins.arg2))
                emit_helper_call("str_concat")
                store_from_rax(str(ins.dst))
            elif op == "STR_SLICE":
                load_into("rcx", str(ins.arg1))
                load_into("rdx", str(ins.arg2))
                stop_arg = ins.extra[0] if ins.extra else -1
                load_into("r8", str(stop_arg))
                emit_helper_call("str_slice")
                store_from_rax(str(ins.dst))
            elif op == "STR_INDEX":
                load_into("rcx", str(ins.arg1))
                load_into("rdx", str(ins.arg2))
                emit_helper_call("str_index")
                store_from_rax(str(ins.dst))
            elif op == "STR_LEN":
                load_into("rcx", str(ins.arg1))
                emit_helper_call("str_len")
                store_from_rax(str(ins.dst))
            elif op == "STR_CMP_EQ":
                load_into("rcx", str(ins.arg1))
                load_into("rdx", str(ins.arg2))
                emit_helper_call("str_cmp_eq")
                store_from_rax(str(ins.dst))
            elif op == "STR_CMP_NE":
                load_into("rcx", str(ins.arg1))
                load_into("rdx", str(ins.arg2))
                emit_helper_call("str_cmp_ne")
                store_from_rax(str(ins.dst))
            elif op in ("STR_CMP_LT", "STR_CMP_LE", "STR_CMP_GT", "STR_CMP_GE"):
                load_into("rcx", str(ins.arg1))
                load_into("rdx", str(ins.arg2))
                emit_helper_call(op.lower())
                store_from_rax(str(ins.dst))
            elif op == "STR_FROM_I64":
                load_into("rcx", str(ins.arg1))
                emit_helper_call("str_from_i64")
                store_from_rax(str(ins.dst))
            elif op == "STR_FROM_F64":
                load_into("rcx", str(ins.arg1))
                emit_helper_call("str_from_f64")
                store_from_rax(str(ins.dst))
            elif op == "STR_FROM_BOOL":
                load_into("rcx", str(ins.arg1))
                emit_helper_call("str_from_bool")
                store_from_rax(str(ins.dst))
            elif op == "STR_ORD":
                load_into("rcx", str(ins.arg1))
                emit_helper_call("str_ord")
                store_from_rax(str(ins.dst))
            elif op == "STR_CHR":
                load_into("rcx", str(ins.arg1))
                emit_helper_call("str_chr")
                store_from_rax(str(ins.dst))
            elif op == "STR_TO_I64":
                load_into("rcx", str(ins.arg1))
                emit_helper_call("str_to_i64")
                store_from_rax(str(ins.dst))
            elif op == "STR_TO_F64":
                load_into("rcx", str(ins.arg1))
                emit_helper_call("str_to_f64")
                store_from_rax(str(ins.dst))
            elif op == "CLOCK_NS":
                emit_helper_call("clock_ns")
                store_from_rax(str(ins.dst))
            elif op == "PY_EVAL_F64":
                load_into("rcx", str(ins.arg1))
                emit_helper_call("py_eval_f64")
                store_from_rax(str(ins.dst))
            elif op == "PY_EVAL_TENSOR":
                load_into("rcx", str(ins.arg1))
                emit_helper_call("py_eval_tensor")
                store_from_rax(str(ins.dst))
            elif op == "PY_CALL_F64":
                load_into("rcx", str(ins.arg1))
                load_into("rdx", str(ins.arg2))
                load_into("r8", str(ins.extra[0]))
                emit_helper_call("py_call_f64")
                store_from_rax(str(ins.dst))
            elif op == "LOAD_IDX":
                load_into("rax", str(ins.arg1))
                load_into("rcx", str(ins.arg2))
                self.load_idx_rax_rcx()
                store_from_rax(str(ins.dst))
            elif op == "STORE_IDX":
                load_into("rax", str(ins.dst))
                load_into("rcx", str(ins.arg1))
                load_into("rdx", str(ins.arg2))
                self.store_idx_rax_rcx_rdx()
            elif op == "PRINT":
                types = [t for t in (ins.comment or "").split(",") if t]
                for idx, (arg_v, arg_t) in enumerate(zip(ins.extra, types)):
                    if idx > 0 and (types[idx - 1] != "str" and arg_t != "str"):
                        self.mov_rcx_imm64(4)
                        self.emit(b"\x48\x31\xD2", "xor rdx, rdx")
                        emit_helper_call("print")
                    kind_map = {"i64": 0, "f64": 1, "bool": 2, "str": 3}
                    k = kind_map.get(arg_t, 0)
                    self.mov_rcx_imm64(k)
                    load_into("rdx", arg_v)
                    emit_helper_call("print")
                self.mov_rcx_imm64(5)
                self.emit(b"\x48\x31\xD2", "xor rdx, rdx")
                emit_helper_call("print")
            elif op == "CALL":
                for idx, arg_v in enumerate(ins.extra):
                    if idx == 0:
                        load_into("rcx", arg_v)
                    elif idx == 1:
                        load_into("rdx", arg_v)
                    elif idx == 2:
                        load_into("r8", arg_v)
                    elif idx == 3:
                        load_into("r9", arg_v)
                    else:
                        load_into("rax", arg_v)
                        sp_off = 8 * idx
                        self.emit(b"\x48\x89\x84\x24" + struct.pack("<i", sp_off), f"mov qword ptr [rsp + {sp_off}], rax")
                if fn_names and str(ins.arg1) in fn_names:
                    self.call_label(f"fn__{ins.arg1}")
                else:
                    load_into("r11", str(ins.arg1))
                    self.emit(b"\x41\xFF\xD3", f"call r11 ; indirect call *{ins.arg1}")
                if ins.dst and ins.dst != "%void":
                    store_from_rax(str(ins.dst))

            i += 1

        self.func_ranges.append((fn_code_start, len(self.code), fn.name, fn.start_line or 1))
        return frame_size


# --- Windows VirtualAlloc Native Memory Manager ---

MEM_COMMIT = 0x1000
MEM_RESERVE = 0x2000
MEM_RELEASE = 0x8000
PAGE_EXECUTE_READWRITE = 0x40


class NativeJITModule:
    """
    Compiles a MIRModule into a single contiguous executable x86-64 code page on Windows,
    allowing all functions in the module to call each other via direct 5-byte `call rel32`
    machine instructions with zero CPython overhead!
    """

    def __init__(self, mir_module: MIRModule, output_callback: Optional[Callable[[str], None]] = None):
        self.mir_module = mir_module
        self.output_callback = output_callback
        self.printed_lines: List[str] = []
        self._allocated_arrays: List[ctypes.Array] = []
        self._callbacks = []
        self.code_buf = X86_64CodeBuffer()
        self.func_offsets: Dict[str, int] = {}
        self._active_sockets: Dict[int, socket.socket] = {}
        self.exec_ptr: Optional[int] = None
        self.exec_size: int = 0

        self._setup_runtime_helpers()
        self._assemble_module()
        self._allocate_executable_memory()

    def _setup_runtime_helpers(self) -> None:
        import threading
        alloc_lock = threading.Lock()
        print_lock = threading.Lock()

        # Pre-allocated 64 MiB execution arena
        self.arena_mem = (ctypes.c_uint8 * (64 * 1024 * 1024))()
        self.arena_offset = 0

        # Small String Optimization (SSO) & Heap String Helpers
        def make_sso_immediate(b: bytes) -> int:
            n = len(b)
            val = (n << 1) | 1
            for i in range(n):
                val |= (b[i] << (8 * (i + 1)))
            return val

        def decode_sso_immediate(val: int) -> bytes:
            n = (val >> 1) & 0x7F
            return bytes((val >> (8 * (i + 1))) & 0xFF for i in range(n))

        def alloc_str_in_arena(n_bytes: int) -> int:
            with alloc_lock:
                alloc_bytes = (n_bytes + 15) & ~15
                old_off = self.arena_offset
                self.arena_offset = (old_off + alloc_bytes) % (64 * 1024 * 1024)
                return ctypes.addressof(self.arena_mem) + old_off

        def make_str_handle(b: bytes) -> int:
            n = len(b)
            if n <= 7:
                return make_sso_immediate(b)
            total_alloc = 16 + n + 1
            desc_addr = alloc_str_in_arena(total_alloc)
            p_desc = ctypes.cast(desc_addr, ctypes.POINTER(ctypes.c_int64))
            data_addr = desc_addr + 16
            p_desc[0] = n
            p_desc[1] = data_addr
            ctypes.memmove(data_addr, b, n)
            ctypes.memset(data_addr + n, 0, 1)
            return desc_addr

        def get_str_bytes(val: int) -> bytes:
            if val & 1 == 1:
                return decode_sso_immediate(val)
            if 0 <= val < len(self.mir_module.string_pool):
                return self.mir_module.string_pool[val].encode("utf-8")
            p_desc = ctypes.cast(val, ctypes.POINTER(ctypes.c_int64))
            n = p_desc[0]
            data_addr = p_desc[1]
            if n <= 0 or data_addr == 0:
                return b""
            raw = (ctypes.c_char * n).from_address(data_addr)
            return bytes(raw)

        self._get_str_bytes = get_str_bytes
        self._make_str_handle = make_str_handle

        # Pre-allocate static string descriptors for string pool entries > 7 bytes
        self.static_str_descs = {}
        for idx, s in enumerate(self.mir_module.string_pool):
            b = s.encode("utf-8")
            if len(b) > 7:
                buf = (ctypes.c_uint8 * (16 + len(b) + 1))()
                p_desc = ctypes.cast(ctypes.addressof(buf), ctypes.POINTER(ctypes.c_int64))
                data_addr = ctypes.addressof(buf) + 16
                p_desc[0] = len(b)
                p_desc[1] = data_addr
                ctypes.memmove(data_addr, b, len(b))
                ctypes.memset(data_addr + len(b), 0, 1)
                self.static_str_descs[idx] = (buf, ctypes.addressof(buf))

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_print_item(kind: int, raw_val: int) -> int:
            with print_lock:
                if kind == 0:
                    self._write_out(str(raw_val))
                elif kind == 1:
                    flt = struct.unpack("<d", struct.pack("<q", raw_val))[0]
                    if flt == int(flt) and abs(flt) < 1e15:
                        self._write_out(f"{flt:.1f}")
                    else:
                        self._write_out(f"{flt:.6g}")
                elif kind == 2:
                    self._write_out("True" if raw_val != 0 else "False")
                elif kind == 3:
                    s_bytes = get_str_bytes(raw_val)
                    self._write_out(s_bytes.decode("utf-8", errors="replace"))
                elif kind == 4:
                    self._write_out(" ")
                elif kind == 5:
                    self._write_out("\n")
            return 0

        @ctypes.CFUNCTYPE(ctypes.c_int64)
        def rt_arena_save() -> int:
            return self.arena_offset

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_arena_restore(saved_offset: int) -> int:
            with alloc_lock:
                self.arena_offset = max(0, int(saved_offset))
            return 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_alloc_arr(count: int, init_bits: int) -> int:
            n = max(0, int(count))
            alloc_bytes = ((n + 1) * 8 + 15) & ~15
            with alloc_lock:
                if self.arena_offset + alloc_bytes > (64 * 1024 * 1024 - 1024):
                    self.arena_offset = 0
                old_off = self.arena_offset
                self.arena_offset += alloc_bytes
                addr = ctypes.addressof(self.arena_mem) + old_off
            p_i64 = ctypes.cast(addr, ctypes.POINTER(ctypes.c_int64))
            p_i64[0] = n
            data_addr = addr + 8
            if init_bits != 0:
                p_data = ctypes.cast(data_addr, ctypes.POINTER(ctypes.c_int64))
                for i in range(n):
                    p_data[i] = init_bits
            return data_addr

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_pow_i64(base: int, exp: int) -> int:
            if exp < 0:
                return 0
            return int(base ** exp)

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_pow_f64(base_bits: int, exp_bits: int) -> int:
            b = struct.unpack("<d", struct.pack("<q", base_bits))[0]
            e = struct.unpack("<d", struct.pack("<q", exp_bits))[0]
            res = math.pow(b, e)
            return struct.unpack("<q", struct.pack("<d", res))[0]

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_str_len(val: int) -> int:
            if val & 1 == 1:
                return (val >> 1) & 0x7F
            if 0 <= val < len(self.mir_module.string_pool):
                return len(self.mir_module.string_pool[val].encode("utf-8"))
            p_desc = ctypes.cast(val, ctypes.POINTER(ctypes.c_int64))
            return int(p_desc[0])

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_str_concat(s1: int, s2: int) -> int:
            b1 = get_str_bytes(s1)
            b2 = get_str_bytes(s2)
            return make_str_handle(b1 + b2)

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_str_slice(s: int, start: int, stop: int) -> int:
            if s & 1 == 0 and s >= len(self.mir_module.string_pool):
                p_desc = ctypes.cast(s, ctypes.POINTER(ctypes.c_int64))
                orig_len = p_desc[0]
                data_addr = p_desc[1]
                if start < 0:
                    start = max(0, orig_len + start)
                if stop < 0:
                    stop = orig_len
                start = min(start, orig_len)
                stop = min(max(stop, start), orig_len)
                slice_len = stop - start
                if slice_len <= 7:
                    raw = (ctypes.c_char * slice_len).from_address(data_addr + start)
                    return make_sso_immediate(bytes(raw))
                # Zero-copy fat pointer descriptor pointing into original data buffer
                desc_addr = alloc_str_in_arena(16)
                p_slice = ctypes.cast(desc_addr, ctypes.POINTER(ctypes.c_int64))
                p_slice[0] = slice_len
                p_slice[1] = data_addr + start
                return desc_addr
            else:
                b = get_str_bytes(s)
                orig_len = len(b)
                if start < 0:
                    start = max(0, orig_len + start)
                if stop < 0:
                    stop = orig_len
                start = min(start, orig_len)
                stop = min(max(stop, start), orig_len)
                return make_str_handle(b[start:stop])

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_str_index(s: int, idx: int) -> int:
            # print(f"DEBUG index(s={s}, idx={idx})", flush=True)
            b = get_str_bytes(s)
            if idx < 0:
                idx += len(b)
            if 0 <= idx < len(b):
                return make_sso_immediate(bytes([b[idx]]))
            return make_sso_immediate(b"")

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_str_cmp_eq(s1: int, s2: int) -> int:
            if s1 == s2:
                return 1
            return 1 if get_str_bytes(s1) == get_str_bytes(s2) else 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_str_cmp_ne(s1: int, s2: int) -> int:
            if s1 == s2:
                return 0
            return 0 if get_str_bytes(s1) == get_str_bytes(s2) else 1

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_str_cmp_lt(s1: int, s2: int) -> int:
            return 1 if get_str_bytes(s1) < get_str_bytes(s2) else 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_str_cmp_le(s1: int, s2: int) -> int:
            return 1 if get_str_bytes(s1) <= get_str_bytes(s2) else 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_str_cmp_gt(s1: int, s2: int) -> int:
            return 1 if get_str_bytes(s1) > get_str_bytes(s2) else 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_str_cmp_ge(s1: int, s2: int) -> int:
            return 1 if get_str_bytes(s1) >= get_str_bytes(s2) else 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_str_from_i64(val: int) -> int:
            return make_str_handle(str(val).encode("utf-8"))

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_str_from_f64(val_bits: int) -> int:
            flt = struct.unpack("<d", struct.pack("<q", val_bits))[0]
            if flt == int(flt) and abs(flt) < 1e15:
                s = f"{flt:.1f}"
            else:
                s = f"{flt:.6g}"
            return make_str_handle(s.encode("utf-8"))

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_str_from_bool(val: int) -> int:
            return make_sso_immediate(b"True" if val != 0 else b"False")

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_str_ord(val: int) -> int:
            b = get_str_bytes(val)
            return b[0] if b else 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_str_chr(code: int) -> int:
            c = max(0, min(255, int(code)))
            return make_str_handle(bytes([c]))

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_str_to_i64(val: int) -> int:
            s = get_str_bytes(val).decode("utf-8", errors="ignore").strip()
            try:
                return int(s)
            except Exception:
                return 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_str_to_f64(val: int) -> int:
            s = get_str_bytes(val).decode("utf-8", errors="ignore").strip()
            try:
                res = float(s)
            except Exception:
                res = 0.0
            return struct.unpack("<q", struct.pack("<d", res))[0]

        @ctypes.CFUNCTYPE(ctypes.c_int64)
        def rt_clock_ns() -> int:
            return time.perf_counter_ns()

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_file_exists(path_val: int) -> int:
            p = get_str_bytes(path_val).decode("utf-8", errors="replace")
            return 1 if os.path.exists(p) else 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_file_size(path_val: int) -> int:
            p = get_str_bytes(path_val).decode("utf-8", errors="replace")
            if not os.path.exists(p):
                return -1
            try:
                return os.path.getsize(p)
            except Exception:
                return -1

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_file_read(path_val: int) -> int:
            p = get_str_bytes(path_val).decode("utf-8", errors="replace")
            try:
                with open(p, "rb") as f:
                    data = f.read()
            except Exception:
                data = b""
            return make_str_handle(data)

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_file_write(path_val: int, content_val: int, mode: int) -> int:
            p = get_str_bytes(path_val).decode("utf-8", errors="replace")
            c = get_str_bytes(content_val)
            m = "ab" if mode == 1 else "wb"
            try:
                with open(p, m) as f:
                    f.write(c)
                return len(c)
            except Exception:
                return -1

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_file_write_bytes(path_val: int, buf_ptr: int, length: int) -> int:
            p = get_str_bytes(path_val).decode("utf-8", errors="replace")
            n_bytes = max(0, int(length))
            try:
                raw_data = ctypes.string_at(buf_ptr, n_bytes) if (buf_ptr and n_bytes > 0) else b""
                os.makedirs(os.path.dirname(os.path.abspath(p)), exist_ok=True)
                with open(p, "wb") as f:
                    f.write(raw_data)
                return len(raw_data)
            except Exception:
                return -1

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_file_read_bytes(path_val: int, buf_ptr: int, max_len: int) -> int:
            p = get_str_bytes(path_val).decode("utf-8", errors="replace")
            n_max = max(0, int(max_len))
            try:
                with open(p, "rb") as f:
                    raw_data = f.read(n_max)
                if buf_ptr and raw_data:
                    ctypes.memmove(buf_ptr, raw_data, len(raw_data))
                return len(raw_data)
            except Exception:
                return -1

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_file_remove(path_val: int) -> int:
            p = get_str_bytes(path_val).decode("utf-8", errors="replace")
            try:
                os.remove(p)
                return 1
            except Exception:
                return 0

        @ctypes.CFUNCTYPE(ctypes.c_int64)
        def rt_bmb_get_cwd() -> int:
            try:
                cwd = os.getcwd().encode("utf-8")
            except Exception:
                cwd = b""
            return make_str_handle(cwd)

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_get_env(key_val: int) -> int:
            k = get_str_bytes(key_val).decode("utf-8", errors="replace")
            v = os.environ.get(k, "").encode("utf-8")
            return make_str_handle(v)

        @ctypes.CFUNCTYPE(ctypes.c_int64)
        def rt_bmb_socket_init() -> int:
            return 0

        @ctypes.CFUNCTYPE(ctypes.c_int64)
        def rt_bmb_socket_cleanup() -> int:
            for s in list(self._active_sockets.values()):
                try:
                    s.close()
                except Exception:
                    pass
            self._active_sockets.clear()
            return 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_socket_create(family: int, sock_type: int, proto: int) -> int:
            try:
                s = socket.socket(int(family), int(sock_type), int(proto))
                fd = s.fileno()
                self._active_sockets[fd] = s
                return fd
            except Exception:
                return -1

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_socket_connect(sockfd: int, host_val: int, port: int) -> int:
            s = self._active_sockets.get(sockfd)
            if not s:
                return -1
            try:
                host = get_str_bytes(host_val).decode("utf-8", errors="replace")
                s.connect((host, int(port)))
                return 0
            except Exception:
                return -1

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_socket_bind(sockfd: int, host_val: int, port: int) -> int:
            s = self._active_sockets.get(sockfd)
            if not s:
                return -1
            try:
                host = get_str_bytes(host_val).decode("utf-8", errors="replace")
                if not host or host == "0.0.0.0":
                    host = ""
                s.bind((host, int(port)))
                return 0
            except Exception:
                return -1

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_socket_listen(sockfd: int, backlog: int) -> int:
            s = self._active_sockets.get(sockfd)
            if not s:
                return -1
            try:
                s.listen(int(backlog))
                return 0
            except Exception:
                return -1

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_socket_accept(sockfd: int) -> int:
            s = self._active_sockets.get(sockfd)
            if not s:
                return -1
            try:
                conn, _ = s.accept()
                cfd = conn.fileno()
                self._active_sockets[cfd] = conn
                return cfd
            except Exception:
                return -1

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_socket_send(sockfd: int, data_val: int) -> int:
            s = self._active_sockets.get(sockfd)
            if not s:
                return -1
            try:
                data = get_str_bytes(data_val)
                return s.send(data)
            except Exception:
                return -1

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_socket_recv(sockfd: int, max_bytes: int) -> int:
            s = self._active_sockets.get(sockfd)
            if not s:
                return make_str_handle(b"")
            try:
                data = s.recv(int(max_bytes))
                return make_str_handle(data)
            except Exception:
                return make_str_handle(b"")

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_socket_close(sockfd: int) -> int:
            s = self._active_sockets.pop(sockfd, None)
            if s:
                try:
                    s.close()
                except Exception:
                    pass
            return 0

        # Native Threading & Concurrency Callbacks
        @ctypes.CFUNCTYPE(ctypes.c_int64)
        def rt_bmb_thread_concurrency() -> int:
            return os.cpu_count() or 1

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_thread_spawn(func_ptr: int, arg: int) -> int:
            kernel32 = ctypes.windll.kernel32
            kernel32.CreateThread.restype = ctypes.c_void_p
            kernel32.CreateThread.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint32, ctypes.c_void_p]
            h = kernel32.CreateThread(None, 0, ctypes.c_void_p(func_ptr), ctypes.c_void_p(arg), 0, None)
            return int(h) if h else 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_thread_join(handle: int) -> int:
            if not handle:
                return -1
            kernel32 = ctypes.windll.kernel32
            kernel32.WaitForSingleObject.argtypes = [ctypes.c_void_p, ctypes.c_uint32]
            kernel32.WaitForSingleObject(ctypes.c_void_p(handle), 0xFFFFFFFF)
            exit_code = ctypes.c_uint32()
            kernel32.GetExitCodeThread.argtypes = [ctypes.c_void_p, ctypes.POINTER(ctypes.c_uint32)]
            kernel32.GetExitCodeThread(ctypes.c_void_p(handle), ctypes.byref(exit_code))
            kernel32.CloseHandle.argtypes = [ctypes.c_void_p]
            kernel32.CloseHandle(ctypes.c_void_p(handle))
            return int(exit_code.value)

        @ctypes.CFUNCTYPE(ctypes.c_int64)
        def rt_bmb_thread_id() -> int:
            return int(ctypes.windll.kernel32.GetCurrentThreadId())

        @ctypes.CFUNCTYPE(ctypes.c_int64)
        def rt_bmb_thread_yield() -> int:
            ctypes.windll.kernel32.Sleep(0)
            return 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_thread_sleep(ms: int) -> int:
            ctypes.windll.kernel32.Sleep(int(ms))
            return 0

        # Native Heap Allocation Primitives
        if sys.platform == "win32":
            _c_alloc = ctypes.cdll.msvcrt.calloc
            _c_free = ctypes.cdll.msvcrt.free
        else:
            _libc = ctypes.CDLL(None)
            _c_alloc = _libc.calloc
            _c_free = _libc.free
        _c_alloc.restype = ctypes.c_void_p
        _c_alloc.argtypes = [ctypes.c_size_t, ctypes.c_size_t]
        _c_free.argtypes = [ctypes.c_void_p]

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_mem_alloc(size_bytes: int) -> int:
            sz = max(1, int(size_bytes))
            ptr = _c_alloc(sz, 1)
            return int(ptr) if ptr else 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_mem_free(ptr: int) -> int:
            if ptr:
                _c_free(ctypes.c_void_p(ptr))
            return 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_mem_read(ptr: int, offset: int) -> int:
            if not ptr:
                return 0
            addr = ptr + int(offset) * 8
            return int(ctypes.c_int64.from_address(addr).value)

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_mem_write(ptr: int, offset: int, val: int) -> int:
            if ptr:
                addr = ptr + int(offset) * 8
                ctypes.c_int64.from_address(addr).value = int(val)
            return 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_mem_read32(ptr: int, offset: int) -> int:
            if not ptr:
                return 0
            addr = ptr + int(offset) * 4
            return int(ctypes.c_uint32.from_address(addr).value)

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_mem_write32(ptr: int, offset: int, val: int) -> int:
            if ptr:
                addr = ptr + int(offset) * 4
                ctypes.c_uint32.from_address(addr).value = int(val) & 0xFFFFFFFF
            return 0

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_mem_read8(ptr: int, offset: int) -> int:
            if not ptr:
                return 0
            addr = ptr + int(offset)
            return int(ctypes.c_uint8.from_address(addr).value)

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_mem_write8(ptr: int, offset: int, val: int) -> int:
            if ptr:
                addr = ptr + int(offset)
                ctypes.c_uint8.from_address(addr).value = int(val) & 0xFF
            return 0

        _alloc_root_holder = [0]

        @ctypes.CFUNCTYPE(ctypes.c_int64)
        def rt_bmb_alloc_root_get() -> int:
            return _alloc_root_holder[0]

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_alloc_root_set(val: int) -> int:
            _alloc_root_holder[0] = int(val)
            return int(val)

        self._callbacks.extend([
            rt_print_item, rt_alloc_arr, rt_pow_i64, rt_pow_f64, rt_arena_save, rt_arena_restore,
            rt_str_len, rt_str_concat, rt_str_slice, rt_str_index, rt_str_cmp_eq, rt_str_cmp_ne,
            rt_str_cmp_lt, rt_str_cmp_le, rt_str_cmp_gt, rt_str_cmp_ge,
            rt_str_from_i64, rt_str_from_f64, rt_str_from_bool, rt_clock_ns,
            rt_str_ord, rt_str_chr, rt_str_to_i64, rt_str_to_f64,
            rt_bmb_file_exists, rt_bmb_file_size, rt_bmb_file_read, rt_bmb_file_write,
            rt_bmb_file_write_bytes, rt_bmb_file_read_bytes,
            rt_bmb_file_remove, rt_bmb_get_cwd, rt_bmb_get_env,
            rt_bmb_socket_init, rt_bmb_socket_cleanup, rt_bmb_socket_create,
            rt_bmb_socket_connect, rt_bmb_socket_bind, rt_bmb_socket_listen,
            rt_bmb_socket_accept, rt_bmb_socket_send, rt_bmb_socket_recv,
            rt_bmb_socket_close,
            rt_bmb_thread_concurrency, rt_bmb_thread_spawn, rt_bmb_thread_join,
            rt_bmb_thread_id, rt_bmb_thread_yield, rt_bmb_thread_sleep,
            rt_bmb_mem_alloc, rt_bmb_mem_free, rt_bmb_mem_read, rt_bmb_mem_write,
            rt_bmb_mem_read32, rt_bmb_mem_write32, rt_bmb_mem_read8, rt_bmb_mem_write8,
            rt_bmb_alloc_root_get, rt_bmb_alloc_root_set,
        ])
        self.addr_print_item = ctypes.cast(rt_print_item, ctypes.c_void_p).value
        self.addr_alloc_arr = ctypes.cast(rt_alloc_arr, ctypes.c_void_p).value
        self.addr_pow_i64 = ctypes.cast(rt_pow_i64, ctypes.c_void_p).value
        self.addr_pow_f64 = ctypes.cast(rt_pow_f64, ctypes.c_void_p).value
        self.addr_arena_save = ctypes.cast(rt_arena_save, ctypes.c_void_p).value
        self.addr_arena_restore = ctypes.cast(rt_arena_restore, ctypes.c_void_p).value
        self.addr_str_len = ctypes.cast(rt_str_len, ctypes.c_void_p).value
        self.addr_str_concat = ctypes.cast(rt_str_concat, ctypes.c_void_p).value
        self.addr_str_slice = ctypes.cast(rt_str_slice, ctypes.c_void_p).value
        self.addr_str_index = ctypes.cast(rt_str_index, ctypes.c_void_p).value
        self.addr_str_cmp_eq = ctypes.cast(rt_str_cmp_eq, ctypes.c_void_p).value
        self.addr_str_cmp_ne = ctypes.cast(rt_str_cmp_ne, ctypes.c_void_p).value
        self.addr_str_cmp_lt = ctypes.cast(rt_str_cmp_lt, ctypes.c_void_p).value
        self.addr_str_cmp_le = ctypes.cast(rt_str_cmp_le, ctypes.c_void_p).value
        self.addr_str_cmp_gt = ctypes.cast(rt_str_cmp_gt, ctypes.c_void_p).value
        self.addr_str_cmp_ge = ctypes.cast(rt_str_cmp_ge, ctypes.c_void_p).value
        self.addr_str_from_i64 = ctypes.cast(rt_str_from_i64, ctypes.c_void_p).value
        self.addr_str_from_f64 = ctypes.cast(rt_str_from_f64, ctypes.c_void_p).value
        self.addr_str_from_bool = ctypes.cast(rt_str_from_bool, ctypes.c_void_p).value
        self.addr_str_ord = ctypes.cast(rt_str_ord, ctypes.c_void_p).value
        self.addr_str_chr = ctypes.cast(rt_str_chr, ctypes.c_void_p).value
        self.addr_str_to_i64 = ctypes.cast(rt_str_to_i64, ctypes.c_void_p).value
        self.addr_str_to_f64 = ctypes.cast(rt_str_to_f64, ctypes.c_void_p).value
        self.addr_clock_ns = ctypes.cast(rt_clock_ns, ctypes.c_void_p).value
        self.addr_bmb_file_exists = ctypes.cast(rt_bmb_file_exists, ctypes.c_void_p).value
        self.addr_bmb_file_size = ctypes.cast(rt_bmb_file_size, ctypes.c_void_p).value
        self.addr_bmb_file_read = ctypes.cast(rt_bmb_file_read, ctypes.c_void_p).value
        self.addr_bmb_file_write = ctypes.cast(rt_bmb_file_write, ctypes.c_void_p).value
        self.addr_bmb_file_write_bytes = ctypes.cast(rt_bmb_file_write_bytes, ctypes.c_void_p).value
        self.addr_bmb_file_read_bytes = ctypes.cast(rt_bmb_file_read_bytes, ctypes.c_void_p).value
        self.addr_bmb_file_remove = ctypes.cast(rt_bmb_file_remove, ctypes.c_void_p).value
        self.addr_bmb_get_cwd = ctypes.cast(rt_bmb_get_cwd, ctypes.c_void_p).value
        self.addr_bmb_get_env = ctypes.cast(rt_bmb_get_env, ctypes.c_void_p).value
        self.addr_bmb_socket_init = ctypes.cast(rt_bmb_socket_init, ctypes.c_void_p).value
        self.addr_bmb_socket_cleanup = ctypes.cast(rt_bmb_socket_cleanup, ctypes.c_void_p).value
        self.addr_bmb_socket_create = ctypes.cast(rt_bmb_socket_create, ctypes.c_void_p).value
        self.addr_bmb_socket_connect = ctypes.cast(rt_bmb_socket_connect, ctypes.c_void_p).value
        self.addr_bmb_socket_bind = ctypes.cast(rt_bmb_socket_bind, ctypes.c_void_p).value
        self.addr_bmb_socket_listen = ctypes.cast(rt_bmb_socket_listen, ctypes.c_void_p).value
        self.addr_bmb_socket_accept = ctypes.cast(rt_bmb_socket_accept, ctypes.c_void_p).value
        self.addr_bmb_socket_send = ctypes.cast(rt_bmb_socket_send, ctypes.c_void_p).value
        self.addr_bmb_socket_recv = ctypes.cast(rt_bmb_socket_recv, ctypes.c_void_p).value
        self.addr_bmb_socket_close = ctypes.cast(rt_bmb_socket_close, ctypes.c_void_p).value
        self.addr_bmb_thread_concurrency = ctypes.cast(rt_bmb_thread_concurrency, ctypes.c_void_p).value
        self.addr_bmb_thread_spawn = ctypes.cast(rt_bmb_thread_spawn, ctypes.c_void_p).value
        self.addr_bmb_thread_join = ctypes.cast(rt_bmb_thread_join, ctypes.c_void_p).value
        self.addr_bmb_thread_id = ctypes.cast(rt_bmb_thread_id, ctypes.c_void_p).value
        self.addr_bmb_thread_yield = ctypes.cast(rt_bmb_thread_yield, ctypes.c_void_p).value
        self.addr_bmb_thread_sleep = ctypes.cast(rt_bmb_thread_sleep, ctypes.c_void_p).value
        self.addr_bmb_mem_alloc = ctypes.cast(rt_bmb_mem_alloc, ctypes.c_void_p).value
        self.addr_bmb_mem_free = ctypes.cast(rt_bmb_mem_free, ctypes.c_void_p).value
        self.addr_bmb_mem_read = ctypes.cast(rt_bmb_mem_read, ctypes.c_void_p).value
        self.addr_bmb_mem_write = ctypes.cast(rt_bmb_mem_write, ctypes.c_void_p).value
        self.addr_bmb_mem_read32 = ctypes.cast(rt_bmb_mem_read32, ctypes.c_void_p).value
        self.addr_bmb_mem_write32 = ctypes.cast(rt_bmb_mem_write32, ctypes.c_void_p).value
        self.addr_bmb_mem_read8 = ctypes.cast(rt_bmb_mem_read8, ctypes.c_void_p).value
        self.addr_bmb_mem_write8 = ctypes.cast(rt_bmb_mem_write8, ctypes.c_void_p).value
        self.addr_bmb_alloc_root_get = ctypes.cast(rt_bmb_alloc_root_get, ctypes.c_void_p).value
        self.addr_bmb_alloc_root_set = ctypes.cast(rt_bmb_alloc_root_set, ctypes.c_void_p).value

        # Host CPython C-API Bridge Callbacks
        from ..interop import CPythonHostBridge
        bridge = CPythonHostBridge.get_instance()

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64, ctypes.c_int64, ctypes.c_int64)
        def rt_py_call_f64(mod_val: int, func_val: int, arg_bits: int) -> int:
            mod_s = get_str_bytes(mod_val).decode("utf-8")
            func_s = get_str_bytes(func_val).decode("utf-8")
            arg_f = struct.unpack("<d", struct.pack("<q", arg_bits))[0]
            res_f = bridge.call_func_f64_1(mod_s, func_s, arg_f)
            return struct.unpack("<q", struct.pack("<d", res_f))[0]

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_py_eval_f64(val: int) -> int:
            expr_s = get_str_bytes(val).decode("utf-8")
            res = float(bridge.eval_code(expr_s))
            return struct.unpack("<q", struct.pack("<d", res))[0]

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_py_eval_tensor(val: int) -> int:
            expr_s = get_str_bytes(val).decode("utf-8")
            ptr, _, _ = bridge.eval_tensor(expr_s)
            return ptr

        self._exit_code_override: Optional[int] = None

        @ctypes.CFUNCTYPE(ctypes.c_int64, ctypes.c_int64)
        def rt_bmb_exit(code: int) -> int:
            self._exit_code_override = int(code)
            return int(code)

        self._callbacks.extend([rt_py_call_f64, rt_py_eval_f64, rt_py_eval_tensor, rt_bmb_exit])
        self.addr_py_call_f64 = ctypes.cast(rt_py_call_f64, ctypes.c_void_p).value
        self.addr_py_eval_f64 = ctypes.cast(rt_py_eval_f64, ctypes.c_void_p).value
        self.addr_py_eval_tensor = ctypes.cast(rt_py_eval_tensor, ctypes.c_void_p).value
        self.addr_bmb_exit = ctypes.cast(rt_bmb_exit, ctypes.c_void_p).value

    def _write_out(self, text: str) -> None:
        self.printed_lines.append(text)
        if self.output_callback is not None:
            self.output_callback(text)

    def get_output(self) -> str:
        return "".join(self.printed_lines)

    def _assemble_module(self) -> None:
        helper_addrs = {
            "print": (self.addr_print_item, "__bmb_print"),
            "alloc_arr": (self.addr_alloc_arr, "__bmb_alloc_arr"),
            "pow_i64": (self.addr_pow_i64, "__bmb_pow_i64"),
            "pow_f64": (self.addr_pow_f64, "__bmb_pow_f64"),
            "py_call_f64": (self.addr_py_call_f64, "__bmb_py_call_f64"),
            "py_eval_f64": (self.addr_py_eval_f64, "__bmb_py_eval_f64"),
            "py_eval_tensor": (self.addr_py_eval_tensor, "__bmb_py_eval_tensor"),
            "arena_save": (self.addr_arena_save, "__bmb_arena_save"),
            "arena_restore": (self.addr_arena_restore, "__bmb_arena_restore"),
            "str_concat": (self.addr_str_concat, "__bmb_str_concat"),
            "str_slice": (self.addr_str_slice, "__bmb_str_slice"),
            "str_index": (self.addr_str_index, "__bmb_str_index"),
            "str_len": (self.addr_str_len, "__bmb_str_len"),
            "str_cmp_eq": (self.addr_str_cmp_eq, "__bmb_str_cmp_eq"),
            "str_cmp_ne": (self.addr_str_cmp_ne, "__bmb_str_cmp_ne"),
            "str_cmp_lt": (self.addr_str_cmp_lt, "__bmb_str_cmp_lt"),
            "str_cmp_le": (self.addr_str_cmp_le, "__bmb_str_cmp_le"),
            "str_cmp_gt": (self.addr_str_cmp_gt, "__bmb_str_cmp_gt"),
            "str_cmp_ge": (self.addr_str_cmp_ge, "__bmb_str_cmp_ge"),
            "str_from_i64": (self.addr_str_from_i64, "__bmb_str_from_i64"),
            "str_from_f64": (self.addr_str_from_f64, "__bmb_str_from_f64"),
            "str_from_bool": (self.addr_str_from_bool, "__bmb_str_from_bool"),
            "str_ord": (self.addr_str_ord, "__bmb_str_ord"),
            "str_chr": (self.addr_str_chr, "__bmb_str_chr"),
            "str_to_i64": (self.addr_str_to_i64, "__bmb_str_to_i64"),
            "str_to_f64": (self.addr_str_to_f64, "__bmb_str_to_f64"),
            "clock_ns": (self.addr_clock_ns, "__bmb_clock_ns"),
        }

        def emit_const_str(ins: MIRInstr, store_from_rax: Callable[[str], None]) -> None:
            raw_s = self.mir_module.string_pool[int(ins.arg1)]
            b = raw_s.encode("utf-8")
            if len(b) <= 7:
                sso_val = (len(b) << 1) | 1
                for i, byte in enumerate(b):
                    sso_val |= (byte << (8 * (i + 1)))
                self.code_buf.mov_rax_imm64(sso_val, f"sso_str('{raw_s}')")
            else:
                desc_addr = self.static_str_descs[int(ins.arg1)][1]
                self.code_buf.mov_rax_imm64(desc_addr, f"str_desc#{ins.arg1}('{raw_s}')")
            store_from_rax(str(ins.dst))

        def emit_helper_call(kind: str) -> None:
            addr, name = helper_addrs[kind]
            self.code_buf.call_abs_addr(addr, name)

        os_trampolines = [
            ("__bmb_file_exists", self.addr_bmb_file_exists),
            ("__bmb_file_size", self.addr_bmb_file_size),
            ("__bmb_file_read", self.addr_bmb_file_read),
            ("__bmb_file_write", self.addr_bmb_file_write),
            ("__bmb_file_write_bytes", self.addr_bmb_file_write_bytes),
            ("__bmb_file_read_bytes", self.addr_bmb_file_read_bytes),
            ("__bmb_file_remove", self.addr_bmb_file_remove),
            ("__bmb_get_cwd", self.addr_bmb_get_cwd),
            ("__bmb_get_env", self.addr_bmb_get_env),
            ("__bmb_socket_init", self.addr_bmb_socket_init),
            ("__bmb_socket_cleanup", self.addr_bmb_socket_cleanup),
            ("__bmb_socket_create", self.addr_bmb_socket_create),
            ("__bmb_socket_connect", self.addr_bmb_socket_connect),
            ("__bmb_socket_bind", self.addr_bmb_socket_bind),
            ("__bmb_socket_listen", self.addr_bmb_socket_listen),
            ("__bmb_socket_accept", self.addr_bmb_socket_accept),
            ("__bmb_socket_send", self.addr_bmb_socket_send),
            ("__bmb_socket_recv", self.addr_bmb_socket_recv),
            ("__bmb_socket_close", self.addr_bmb_socket_close),
            ("__bmb_thread_concurrency", self.addr_bmb_thread_concurrency),
            ("__bmb_thread_spawn", self.addr_bmb_thread_spawn),
            ("__bmb_thread_join", self.addr_bmb_thread_join),
            ("__bmb_thread_yield", self.addr_bmb_thread_yield),
            ("__bmb_thread_sleep", self.addr_bmb_thread_sleep),
            ("__bmb_mem_alloc", self.addr_bmb_mem_alloc),
            ("__bmb_mem_free", self.addr_bmb_mem_free),
            ("__bmb_exit", self.addr_bmb_exit),
        ]
        for name, addr in os_trampolines:
            self.code_buf.mark_label(f"fn__{name}")
            self.code_buf.emit(b"\x48\x83\xEC\x28", "sub rsp, 0x28")
            self.code_buf.call_abs_addr(addr, name)
            self.code_buf.emit(b"\x48\x83\xC4\x28", "add rsp, 0x28")
            self.code_buf.ret()

        # Zero-GIL Native Hardware Memory & Thread-ID Trampolines
        self._alloc_root_cell = ctypes.c_int64(0)
        alloc_root_addr = ctypes.addressof(self._alloc_root_cell)
        self._rt_slots_arr = (ctypes.c_int64 * 16)()
        rt_slots_addr = ctypes.addressof(self._rt_slots_arr)

        self.code_buf.mark_label("fn____bmb_thread_id")
        self.code_buf.emit(b"\x65\x8B\x04\x25\x48\x00\x00\x00\xC3", "mov eax, dword ptr gs:[0x48]; ret")

        self.code_buf.mark_label("fn____bmb_mem_read")
        self.code_buf.emit(b"\x48\x8B\x04\xD1\xC3", "mov rax, [rcx + rdx*8]; ret")

        self.code_buf.mark_label("fn____bmb_mem_write")
        self.code_buf.emit(b"\x4C\x89\x04\xD1\x48\x31\xC0\xC3", "mov [rcx + rdx*8], r8; xor rax, rax; ret")

        self.code_buf.mark_label("fn____bmb_mem_read32")
        self.code_buf.emit(b"\x8B\x04\x91\xC3", "mov eax, [rcx + rdx*4]; ret")

        self.code_buf.mark_label("fn____bmb_mem_write32")
        self.code_buf.emit(b"\x44\x89\x04\x91\x48\x31\xC0\xC3", "mov [rcx + rdx*4], r8d; xor rax, rax; ret")

        self.code_buf.mark_label("fn____bmb_mem_read8")
        self.code_buf.emit(b"\x0F\xB6\x04\x11\xC3", "movzx eax, byte ptr [rcx + rdx]; ret")

        self.code_buf.mark_label("fn____bmb_mem_write8")
        self.code_buf.emit(b"\x44\x88\x04\x11\x48\x31\xC0\xC3", "mov [rcx + rdx], r8b; xor rax, rax; ret")

        self.code_buf.mark_label("fn____bmb_alloc_root_get")
        self.code_buf.emit(b"\x48\xB8" + struct.pack("<Q", alloc_root_addr) + b"\x48\x8B\x00\xC3", "movabs rax, alloc_root; mov rax, [rax]; ret")

        self.code_buf.mark_label("fn____bmb_alloc_root_set")
        self.code_buf.emit(b"\x48\xB8" + struct.pack("<Q", alloc_root_addr) + b"\x48\x89\x08\x48\x89\xC8\xC3", "movabs rax, alloc_root; mov [rax], rcx; mov rax, rcx; ret")

        self.code_buf.mark_label("fn____bmb_rt_slot_get")
        self.code_buf.emit(
            b"\x83\xE1\x0F\x48\xB8" + struct.pack("<Q", rt_slots_addr) + b"\x48\x8B\x04\xC8\xC3",
            "and ecx, 15; movabs rax, rt_slots; mov rax, [rax + rcx*8]; ret",
        )

        self.code_buf.mark_label("fn____bmb_rt_slot_set")
        self.code_buf.emit(
            b"\x83\xE1\x0F\x48\xB8" + struct.pack("<Q", rt_slots_addr) + b"\x48\x89\x14\xC8\x48\x89\xD0\xC3",
            "and ecx, 15; movabs rax, rt_slots; mov [rax + rcx*8], rdx; mov rax, rdx; ret",
        )

        # Native Hardware Atomic Trampolines
        self.code_buf.mark_label("fn____bmb_atomic_load")
        self.code_buf.emit(b"\x48\x8B\x01\xC3", "mov rax, [rcx]; ret")

        self.code_buf.mark_label("fn____bmb_atomic_store")
        self.code_buf.emit(b"\x48\x87\x11\x48\x89\xD0\xC3", "xchg [rcx], rdx; mov rax, rdx; ret")

        self.code_buf.mark_label("fn____bmb_atomic_add")
        self.code_buf.emit(b"\x48\x89\xD0\xF0\x48\x0F\xC1\x01\xC3", "mov rax, rdx; lock xadd [rcx], rax; ret")

        self.code_buf.mark_label("fn____bmb_atomic_sub")
        self.code_buf.emit(b"\x48\xF7\xDA\x48\x89\xD0\xF0\x48\x0F\xC1\x01\xC3", "neg rdx; mov rax, rdx; lock xadd [rcx], rax; ret")

        self.code_buf.mark_label("fn____bmb_atomic_cas")
        self.code_buf.emit(b"\x48\x89\xD0\xF0\x4C\x0F\xB1\x01\xC3", "mov rax, rdx; lock cmpxchg [rcx], r8; ret")

        self.code_buf.mark_label("fn____bmb_atomic_fence")
        self.code_buf.emit(b"\x0F\xAE\xF0\x48\x31\xC0\xC3", "mfence; xor rax, rax; ret")

        self.code_buf.mark_label("fn____bmb_cpu_pause")
        self.code_buf.emit(b"\xF3\x90\x48\x31\xC0\xC3", "pause; xor rax, rax; ret")

        known_fn_names = {f.name for f in self.mir_module.functions}
        for name, _ in os_trampolines:
            known_fn_names.add(name)
        known_fn_names.update([
            "__bmb_atomic_load", "__bmb_atomic_store", "__bmb_atomic_add", "__bmb_atomic_sub",
            "__bmb_atomic_cas", "__bmb_atomic_fence", "__bmb_cpu_pause",
            "__bmb_thread_concurrency", "__bmb_thread_spawn", "__bmb_thread_join",
            "__bmb_thread_id", "__bmb_thread_yield", "__bmb_thread_sleep",
            "__bmb_mem_read", "__bmb_mem_write", "__bmb_mem_read32", "__bmb_mem_write32",
            "__bmb_mem_read8", "__bmb_mem_write8", "__bmb_alloc_root_get", "__bmb_alloc_root_set",
            "__bmb_rt_slot_get", "__bmb_rt_slot_set",
        ])

        # Resolve foreign C-ABI symbols and emit trampolines
        loaded_libs: Dict[str, Any] = {}
        for fn_name, (abi, lib_name, params, ret_type, lib_sym) in getattr(self.mir_module, "extern_functions", {}).items():
            sym_name = lib_sym or fn_name
            target_lib = None
            norm_lib = (lib_name or "").lower().replace("\\", "/").split("/")[-1]
            if not norm_lib or "msvcrt" in norm_lib or "libc" in norm_lib:
                target_lib = ctypes.cdll.msvcrt if sys.platform == "win32" else ctypes.CDLL(None)
            elif "kernel32" in norm_lib:
                target_lib = ctypes.windll.kernel32 if sys.platform == "win32" else ctypes.CDLL(None)
            elif "user32" in norm_lib:
                target_lib = ctypes.windll.user32 if sys.platform == "win32" else ctypes.CDLL(None)
            else:
                if norm_lib not in loaded_libs:
                    try:
                        loaded_libs[norm_lib] = ctypes.cdll.LoadLibrary(lib_name)
                    except Exception:
                        try:
                            loaded_libs[norm_lib] = ctypes.windll.LoadLibrary(lib_name)
                        except Exception as e:
                            raise RuntimeError(f"Failed to load foreign library '{lib_name}': {e}")
                target_lib = loaded_libs[norm_lib]

            try:
                foreign_fn = getattr(target_lib, sym_name)
            except AttributeError:
                raise RuntimeError(f"Foreign symbol '{sym_name}' not found in library '{lib_name}'")

            def _map_c_type(t: str):
                t_norm = (t or "i64").strip()
                if t_norm in ("f64", "float", "double"):
                    return ctypes.c_double
                if t_norm == "str":
                    return ctypes.c_char_p
                if t_norm == "void":
                    return None
                return ctypes.c_int64

            c_argtypes = [_map_c_type(pt) for _, pt in params]
            c_restype = _map_c_type(ret_type)
            try:
                foreign_fn.argtypes = c_argtypes
                foreign_fn.restype = c_restype
            except Exception:
                pass

            has_str_params = any(pt == "str" for _, pt in params)
            has_str_ret = ret_type == "str"
            has_f64_params = any(pt in ("f64", "float", "double") for _, pt in params)
            has_f64_ret = ret_type in ("f64", "float", "double")

            cb_argtypes = [ctypes.c_int64] * len(params)
            cb_restype = ctypes.c_int64

            def make_wrapper(fn_to_call, p_specs, r_spec, has_str_p, has_str_r, has_f64_p, has_f64_r):
                get_str = self._get_str_bytes
                make_str = self._make_str_handle

                def wrapper(*raw_args):
                    converted_args = []
                    for (pn, pt), arg in zip(p_specs, raw_args):
                        if pt == "str":
                            converted_args.append(get_str(arg))
                        elif pt in ("f64", "float", "double"):
                            flt = struct.unpack("<d", struct.pack("<q", arg))[0]
                            converted_args.append(flt)
                        else:
                            converted_args.append(int(arg))
                    res = fn_to_call(*converted_args)
                    if has_str_r:
                        if isinstance(res, (bytes, bytearray)):
                            return make_str(res)
                        elif isinstance(res, str):
                            return make_str(res.encode("utf-8"))
                        elif res:
                            return make_str(ctypes.string_at(res))
                        return make_str(b"")
                    elif has_f64_r:
                        flt_val = float(res) if res is not None else 0.0
                        return struct.unpack("<q", struct.pack("<d", flt_val))[0]
                    elif r_spec == "void":
                        return 0
                    else:
                        return int(res) if res is not None else 0
                return wrapper

            py_wrapper = make_wrapper(foreign_fn, params, ret_type, has_str_params, has_str_ret, has_f64_params, has_f64_ret)
            c_cb_type = ctypes.CFUNCTYPE(cb_restype, *cb_argtypes)
            c_cb = c_cb_type(py_wrapper)
            self._callbacks.append(c_cb)
            cb_addr = ctypes.cast(c_cb, ctypes.c_void_p).value

            self.code_buf.mark_label(f"fn__{fn_name}")
            self.code_buf.emit(b"\x48\x83\xEC\x28", "sub rsp, 0x28")
            self.code_buf.call_abs_addr(cb_addr, f"extern_{fn_name}")
            self.code_buf.emit(b"\x48\x83\xC4\x28", "add rsp, 0x28")
            self.code_buf.ret()
            known_fn_names.add(fn_name)

        for fn in self.mir_module.functions:
            self.func_offsets[fn.name] = len(self.code_buf.code)
            self.code_buf.compile_mir_function(fn, emit_const_str, emit_helper_call, known_fn_names)

        self.code_buf.resolve_fixups()

    def _allocate_executable_memory(self) -> None:
        raw_code = bytes(self.code_buf.code)
        self.exec_size = max(4096, len(raw_code))
        kernel32 = ctypes.windll.kernel32
        kernel32.VirtualAlloc.restype = ctypes.c_void_p
        kernel32.VirtualAlloc.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.c_ulong, ctypes.c_ulong]

        ptr = kernel32.VirtualAlloc(None, self.exec_size, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE)
        if not ptr:
            raise MemoryError("VirtualAlloc failed to allocate executable x86-64 memory")
        self.exec_ptr = ptr
        ctypes.memmove(self.exec_ptr, raw_code, len(raw_code))

    def __getattr__(self, name: str) -> Any:
        if name in self.func_offsets:
            return lambda *args: self.call_function(name, *args)
        raise AttributeError(f"'NativeJITModule' object has no attribute '{name}'")

    def call_function(self, func_name: str, *args: Any) -> Any:
        if func_name not in self.func_offsets:
            raise KeyError(f"Function {func_name!r} not found in compiled module")
        fn_mir = next(f for f in self.mir_module.functions if f.name == func_name)
        fn_addr = self.exec_ptr + self.func_offsets[func_name]

        from ..interop import try_extract_buffer

        c_arg_types = [ctypes.c_int64] * len(args)
        proto = ctypes.CFUNCTYPE(ctypes.c_int64, *c_arg_types)
        native_fn = proto(fn_addr)

        keepalive = []
        packed_args: List[int] = []
        for idx, a in enumerate(args):
            p_type = fn_mir.params[idx][1] if idx < len(fn_mir.params) else "i64"
            buf_info = try_extract_buffer(a)
            if buf_info is not None:
                ptr, _, _, _ = buf_info
                keepalive.append(a)
                packed_args.append(ptr)
            elif p_type == "f64" or isinstance(a, float):
                bits = struct.unpack("<q", struct.pack("<d", float(a)))[0]
                packed_args.append(bits)
            elif isinstance(a, bool):
                packed_args.append(1 if a else 0)
            elif isinstance(a, int):
                packed_args.append(int(a))
            elif isinstance(a, str):
                s_bytes = a.encode("utf-8")
                packed_args.append(self._make_str_handle(s_bytes))
            else:
                packed_args.append(int(a))

        raw_ret = native_fn(*packed_args)
        del keepalive

        if fn_mir.return_type == "f64":
            return struct.unpack("<d", struct.pack("<q", raw_ret))[0]
        if fn_mir.return_type == "bool":
            return bool(raw_ret)
        if fn_mir.return_type == "str":
            return self._get_str_bytes(raw_ret).decode("utf-8", errors="replace")
        return int(raw_ret)

    def run_main(self) -> int:
        self._exit_code_override = None
        for _k in range(16):
            self._rt_slots_arr[_k] = 0
        if "__bmb_main__" in self.func_offsets:
            res = int(self.call_function("__bmb_main__"))
            return self._exit_code_override if self._exit_code_override is not None else res
        if "main" in self.func_offsets:
            res = int(self.call_function("main"))
            return self._exit_code_override if self._exit_code_override is not None else res
        return self._exit_code_override if self._exit_code_override is not None else 0

    def format_disassembly(self) -> str:
        lines = [
            f"; Black Mamba (.bmb) Native x86-64 Disassembly ({len(self.code_buf.code)} bytes total)",
            "; Target ABI: Windows x86_64 (Win64: rcx, rdx, r8, r9 -> rax | Callee-saved: r12..r15, rbx, rsi, rdi)",
            "",
        ]
        for al in self.code_buf.asm_lines:
            if not al.raw_bytes:
                lines.append(f"\n{al.mnemonic}")
            else:
                lines.append(al.format())
        return "\n".join(lines)

    def close(self) -> None:
        for s in list(self._active_sockets.values()):
            try:
                s.close()
            except Exception:
                pass
        self._active_sockets.clear()
        if self.exec_ptr:
            kernel32 = ctypes.windll.kernel32
            kernel32.VirtualFree.argtypes = [ctypes.c_void_p, ctypes.c_size_t, ctypes.c_ulong]
            kernel32.VirtualFree(self.exec_ptr, 0, MEM_RELEASE)
            self.exec_ptr = None
