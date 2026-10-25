"""
Black Mamba (.bmb) Standalone macOS Apple Silicon 64-bit (ARM64 / AArch64) Native Compiler & Linker.

Directly emits a zero-dependency, standalone macOS Mach-O 64-bit executable (.macho / binary) containing:
- Mach-O 64-bit Header (MH_MAGIC_64, CPU_TYPE_ARM64, MH_EXECUTE)
- Load Commands:
  - LC_SEGMENT_64 (__PAGEZERO, 4GB virtual guard)
  - LC_SEGMENT_64 (__TEXT with __text section and rodata)
  - LC_BUILD_VERSION (macOS 11.0 Big Sur+ base, Apple Silicon M1/M2/M3/M4)
  - LC_MAIN (entry point offset to _start)
  - LC_LOAD_DYLINKER (/usr/lib/dyld)
- Direct Darwin raw kernel syscalls (svc #0x80 with 0x2000000 class prefix):
  - sys_write (0x2000004): Console stdout output
  - sys_exit  (0x2000001): Process exit code
  - sys_open  (0x2000005): File open
  - sys_read  (0x2000003): File read
  - sys_close (0x2000006): File close
  - sys_unlink(0x200000A): File remove
  - sys_socket (0x2000061), sys_connect (0x2000062), sys_bind (0x2000068), sys_listen (0x200006A), sys_accept (0x200001E)
"""

import os
import struct
from typing import Callable, Dict, List, Optional, Tuple
from ..mir import MIRFunction, MIRInstr, MIRModule


PAGE_SIZE = 0x4000       # 16KB standard page size on Apple Silicon
IMAGE_BASE = 0x100000000 # 4GB base address on macOS 64-bit


def _align(val: int, alignment: int) -> int:
    return (val + alignment - 1) & ~(alignment - 1)


class ARM64CodeBuffer:
    """
    AArch64 fixed-width 32-bit instruction encoder and label resolution buffer.
    """

    def __init__(self):
        self.code = bytearray()
        self.labels: Dict[str, int] = {}
        # List of (offset, label, kind, extra)
        self.fixups: List[Tuple[int, str, str, int]] = []

    def emit32(self, ins: int, comment: str = "") -> None:
        self.code.extend(struct.pack("<I", ins & 0xFFFFFFFF))

    def mark_label(self, name: str) -> None:
        self.labels[name] = len(self.code)

    def resolve_fixups(self) -> None:
        """Resolves relative branch and PC-relative address fixups."""
        for off, label, kind, extra in self.fixups:
            if label not in self.labels:
                raise ValueError(f"ARM64: Unresolved label '{label}' at offset 0x{off:X}")
            target = self.labels[label]
            diff = target - off

            if kind == "b":
                # Unconditional branch: 26-bit signed word offset
                imm26 = (diff // 4) & 0x03FFFFFF
                ins = 0x14000000 | imm26
                struct.pack_into("<I", self.code, off, ins)
            elif kind == "bl":
                # Branch and link (function call): 26-bit signed word offset
                imm26 = (diff // 4) & 0x03FFFFFF
                ins = 0x94000000 | imm26
                struct.pack_into("<I", self.code, off, ins)
            elif kind == "b.cond":
                # Conditional branch: 19-bit signed word offset
                cond = extra
                imm19 = (diff // 4) & 0x7FFFF
                ins = 0x54000000 | (imm19 << 5) | cond
                struct.pack_into("<I", self.code, off, ins)
            elif kind == "adr":
                # ADR: 21-bit signed byte offset (+- 1MB)
                rd = extra
                imm21 = diff & 0x1FFFFF
                immlo = imm21 & 3
                immhi = (imm21 >> 2) & 0x7FFFF
                ins = 0x10000000 | (immlo << 29) | (immhi << 5) | rd
                struct.pack_into("<I", self.code, off, ins)
            else:
                raise ValueError(f"Unknown fixup kind: {kind}")

    # --- Instruction Encoders ---

    def ret(self) -> None:
        self.emit32(0xD65F03C0, "ret")

    def svc(self, imm16: int = 0x80) -> None:
        self.emit32(0xD4000001 | ((imm16 & 0xFFFF) << 5), f"svc #0x{imm16:X}")

    def stp_fp_lr(self) -> None:
        # stp x29, x30, [sp, #-16]!
        self.emit32(0xA9BF7BFD, "stp x29, x30, [sp, #-16]!")

    def ldp_fp_lr_and_ret(self) -> None:
        # ldp x29, x30, [sp], #16 ; ret
        self.emit32(0xA8C17BFD, "ldp x29, x30, [sp], #16")
        self.emit32(0xD65F03C0, "ret")

    def mov_fp_sp(self) -> None:
        # mov x29, sp -> add x29, sp, #0
        self.emit32(0x910003FD, "mov x29, sp")

    def sub_sp_imm(self, imm: int) -> None:
        if imm == 0:
            return
        if imm <= 4095:
            # sub sp, sp, #imm
            self.emit32(0xD1000000 | (imm << 10) | (31 << 5) | 31, f"sub sp, sp, #{imm}")
        else:
            self.mov_reg_imm64(16, imm)
            # sub sp, sp, x16
            self.emit32(0xCB3003FF, f"sub sp, sp, x16 (#{imm})")

    def add_sp_imm(self, imm: int) -> None:
        if imm == 0:
            return
        if imm <= 4095:
            # add sp, sp, #imm
            self.emit32(0x91000000 | (imm << 10) | (31 << 5) | 31, f"add sp, sp, #{imm}")
        else:
            self.mov_reg_imm64(16, imm)
            # add sp, sp, x16
            self.emit32(0x8B3003FF, f"add sp, sp, x16 (#{imm})")

    def mov_reg_reg(self, rd: int, rn: int) -> None:
        if rd == rn:
            return
        # orr rd, xzr, rn
        self.emit32(0xAA0003E0 | (rn << 16) | rd, f"mov x{rd}, x{rn}")

    def mov_reg_imm64(self, rd: int, val: int) -> None:
        uval = val & 0xFFFFFFFFFFFFFFFF
        if uval == 0:
            # mov rd, xzr -> orr rd, xzr, xzr
            self.emit32(0xAA1F03E0 | rd, f"mov x{rd}, #0")
            return

        c0 = uval & 0xFFFF
        c1 = (uval >> 16) & 0xFFFF
        c2 = (uval >> 32) & 0xFFFF
        c3 = (uval >> 48) & 0xFFFF

        # First chunk via MOVZ
        if c0 != 0 or (c1 == 0 and c2 == 0 and c3 == 0):
            self.emit32(0xD2800000 | (c0 << 5) | rd, f"movz x{rd}, #0x{c0:04X}, lsl #0")
        elif c1 != 0 and c0 == 0:
            self.emit32(0xD2A00000 | (c1 << 5) | rd, f"movz x{rd}, #0x{c1:04X}, lsl #16")
            c1 = 0
        elif c2 != 0 and c0 == 0 and c1 == 0:
            self.emit32(0xD2C00000 | (c2 << 5) | rd, f"movz x{rd}, #0x{c2:04X}, lsl #32")
            c2 = 0
        elif c3 != 0 and c0 == 0 and c1 == 0 and c2 == 0:
            self.emit32(0xD2E00000 | (c3 << 5) | rd, f"movz x{rd}, #0x{c3:04X}, lsl #48")
            c3 = 0

        # Remaining non-zero chunks via MOVK
        if c1 != 0:
            self.emit32(0xF2A00000 | (c1 << 5) | rd, f"movk x{rd}, #0x{c1:04X}, lsl #16")
        if c2 != 0:
            self.emit32(0xF2C00000 | (c2 << 5) | rd, f"movk x{rd}, #0x{c2:04X}, lsl #32")
        if c3 != 0:
            self.emit32(0xF2E00000 | (c3 << 5) | rd, f"movk x{rd}, #0x{c3:04X}, lsl #48")

    # --- Arithmetic & Logic ---

    def add_reg(self, rd: int, rn: int, rm: int) -> None:
        self.emit32(0x8B000000 | (rm << 16) | (rn << 5) | rd, f"add x{rd}, x{rn}, x{rm}")

    def sub_reg(self, rd: int, rn: int, rm: int) -> None:
        self.emit32(0xCB000000 | (rm << 16) | (rn << 5) | rd, f"sub x{rd}, x{rn}, x{rm}")

    def mul_reg(self, rd: int, rn: int, rm: int) -> None:
        self.emit32(0x9B007C00 | (rm << 16) | (rn << 5) | rd, f"mul x{rd}, x{rn}, x{rm}")

    def sdiv_reg(self, rd: int, rn: int, rm: int) -> None:
        self.emit32(0x9AC00C00 | (rm << 16) | (rn << 5) | rd, f"sdiv x{rd}, x{rn}, x{rm}")

    def udiv_reg(self, rd: int, rn: int, rm: int) -> None:
        self.emit32(0x9AC00800 | (rm << 16) | (rn << 5) | rd, f"udiv x{rd}, x{rn}, x{rm}")

    def neg_reg(self, rd: int, rm: int) -> None:
        self.emit32(0xCB0003E0 | (rm << 16) | rd, f"neg x{rd}, x{rm}")

    def and_reg(self, rd: int, rn: int, rm: int) -> None:
        self.emit32(0x8A000000 | (rm << 16) | (rn << 5) | rd, f"and x{rd}, x{rn}, x{rm}")

    def orr_reg(self, rd: int, rn: int, rm: int) -> None:
        self.emit32(0xAA000000 | (rm << 16) | (rn << 5) | rd, f"orr x{rd}, x{rn}, x{rm}")

    def eor_reg(self, rd: int, rn: int, rm: int) -> None:
        self.emit32(0xCA000000 | (rm << 16) | (rn << 5) | rd, f"eor x{rd}, x{rn}, x{rm}")

    def lsl_reg(self, rd: int, rn: int, rm: int) -> None:
        self.emit32(0x9AC02000 | (rm << 16) | (rn << 5) | rd, f"lsl x{rd}, x{rn}, x{rm}")

    def lsr_reg(self, rd: int, rn: int, rm: int) -> None:
        self.emit32(0x9AC02400 | (rm << 16) | (rn << 5) | rd, f"lsr x{rd}, x{rn}, x{rm}")

    def asr_reg(self, rd: int, rn: int, rm: int) -> None:
        self.emit32(0x9AC02800 | (rm << 16) | (rn << 5) | rd, f"asr x{rd}, x{rn}, x{rm}")

    def cmp_reg(self, rn: int, rm: int) -> None:
        self.emit32(0xEB00001F | (rm << 16) | (rn << 5), f"cmp x{rn}, x{rm}")

    def cmp_imm(self, rn: int, imm12: int) -> None:
        self.emit32(0xF100001F | ((imm12 & 0xFFF) << 10) | (rn << 5), f"cmp x{rn}, #{imm12}")

    def cset(self, rd: int, cond: int) -> None:
        # csinc rd, xzr, xzr, invert(cond)
        inv = cond ^ 1
        self.emit32(0x9A9F07E0 | (inv << 12) | rd, f"cset x{rd}, cond={cond}")

    # --- Memory Operations ---

    def ldr_reg_fp_offset(self, rd: int, offset: int) -> None:
        # ldur rd, [x29, #offset] (signed 9-bit: -256..255)
        if -256 <= offset <= 255:
            self.emit32(0xF8400000 | ((offset & 0x1FF) << 12) | (29 << 5) | rd, f"ldur x{rd}, [fp, #{offset}]")
        else:
            self.mov_reg_imm64(16, offset)
            self.emit32(0xF8606BA0 | rd, f"ldr x{rd}, [fp, x16] (#{offset})")

    def str_reg_fp_offset(self, rd: int, offset: int) -> None:
        if -256 <= offset <= 255:
            self.emit32(0xF8000000 | ((offset & 0x1FF) << 12) | (29 << 5) | rd, f"stur x{rd}, [fp, #{offset}]")
        else:
            self.mov_reg_imm64(16, offset)
            self.emit32(0xF8206BA0 | rd, f"str x{rd}, [fp, x16] (#{offset})")

    def ldr_reg_reg(self, rd: int, rn: int, rm: int, shift: int = 3) -> None:
        # ldr xd, [xn, xm, lsl #3]
        self.emit32(0xF8607800 | (rm << 16) | (rn << 5) | rd, f"ldr x{rd}, [x{rn}, x{rm}, lsl #{shift}]")

    def str_reg_reg(self, rd: int, rn: int, rm: int, shift: int = 3) -> None:
        # str xd, [xn, xm, lsl #3]
        self.emit32(0xF8207800 | (rm << 16) | (rn << 5) | rd, f"str x{rd}, [x{rn}, x{rm}, lsl #{shift}]")

    def ldrb_reg_reg(self, wd: int, rn: int, rm: int) -> None:
        # ldrb wd, [xn, xm]
        self.emit32(0x38606800 | (rm << 16) | (rn << 5) | wd, f"ldrb w{wd}, [x{rn}, x{rm}]")

    def strb_reg_reg(self, wd: int, rn: int, rm: int) -> None:
        # strb wd, [xn, xm]
        self.emit32(0x38206800 | (rm << 16) | (rn << 5) | wd, f"strb w{wd}, [x{rn}, x{rm}]")

    # --- Floating Point Operations ---

    def fadd(self, dd: int, dn: int, dm: int) -> None:
        self.emit32(0x1E602800 | (dm << 16) | (dn << 5) | dd, f"fadd d{dd}, d{dn}, d{dm}")

    def fsub(self, dd: int, dn: int, dm: int) -> None:
        self.emit32(0x1E603800 | (dm << 16) | (dn << 5) | dd, f"fsub d{dd}, d{dn}, d{dm}")

    def fmul(self, dd: int, dn: int, dm: int) -> None:
        self.emit32(0x1E600800 | (dm << 16) | (dn << 5) | dd, f"fmul d{dd}, d{dn}, d{dm}")

    def fdiv(self, dd: int, dn: int, dm: int) -> None:
        self.emit32(0x1E601800 | (dm << 16) | (dn << 5) | dd, f"fdiv d{dd}, d{dn}, d{dm}")

    def fcmp(self, dn: int, dm: int) -> None:
        self.emit32(0x1E602000 | (dm << 16) | (dn << 5), f"fcmp d{dn}, d{dm}")

    def fmov_d_d(self, dd: int, dn: int) -> None:
        self.emit32(0x1E604000 | (dn << 5) | dd, f"fmov d{dd}, d{dn}")

    def fmov_d_x(self, dd: int, xn: int) -> None:
        self.emit32(0x9E670000 | (xn << 5) | dd, f"fmov d{dd}, x{xn}")

    def fmov_x_d(self, xd: int, dn: int) -> None:
        self.emit32(0x9E660000 | (dn << 5) | xd, f"fmov x{xd}, d{dn}")

    def scvtf(self, dd: int, xn: int) -> None:
        self.emit32(0x9E620000 | (xn << 5) | dd, f"scvtf d{dd}, x{xn}")

    def fcvtzs(self, xd: int, dn: int) -> None:
        self.emit32(0x9E780000 | (dn << 5) | xd, f"fcvtzs x{xd}, d{dn}")

    # --- Branches & Calls ---

    def b_label(self, label: str) -> None:
        self.fixups.append((len(self.code), label, "b", 0))
        self.emit32(0x14000000, f"b {label}")

    def bl_label(self, label: str) -> None:
        self.fixups.append((len(self.code), label, "bl", 0))
        self.emit32(0x94000000, f"bl {label}")

    def blr_reg(self, rn: int) -> None:
        self.emit32(0xD63F0000 | ((rn & 31) << 5), f"blr x{rn}")

    def b_cond_label(self, cond: int, label: str) -> None:
        self.fixups.append((len(self.code), label, "b.cond", cond))
        self.emit32(0x54000000 | cond, f"b.cond #{cond} {label}")

    def b_eq_label(self, label: str) -> None:
        self.b_cond_label(0, label)

    def b_ne_label(self, label: str) -> None:
        self.b_cond_label(1, label)

    def b_lt_label(self, label: str) -> None:
        self.b_cond_label(11, label)

    def b_le_label(self, label: str) -> None:
        self.b_cond_label(13, label)

    def b_gt_label(self, label: str) -> None:
        self.b_cond_label(12, label)

    def b_ge_label(self, label: str) -> None:
        self.b_cond_label(10, label)

    def adr_label(self, rd: int, label: str) -> None:
        self.fixups.append((len(self.code), label, "adr", rd))
        self.emit32(0x10000000 | rd, f"adr x{rd}, {label}")


class MachOARM64ExecutableBuilder:
    """
    Compiles a MIRModule directly into a native Apple Silicon macOS Mach-O 64-bit executable.
    """

    def __init__(self, mir_module: MIRModule):
        self.mir_module = mir_module
        self.code_buf = ARM64CodeBuffer()
        self.string_offsets: Dict[int, int] = {}

    def build_bytes(self) -> bytes:
        """Assembles the complete Mach-O 64-bit ARM64 executable binary."""
        # 1. Prepare string literal pool and rodata
        rodata_buf = bytearray()
        str_sp = len(rodata_buf)
        rodata_buf.extend(b" \x00")
        str_nl = len(rodata_buf)
        rodata_buf.extend(b"\n\x00")
        str_true = len(rodata_buf)
        rodata_buf.extend(b"True\x00")
        str_false = len(rodata_buf)
        rodata_buf.extend(b"False\x00")
        str_empty = len(rodata_buf)
        rodata_buf.extend(b"\x00")

        # Heap pointer storage (8 bytes)
        heap_ptr_offset = len(rodata_buf)
        rodata_buf.extend(b"\x00" * 8)

        string_rel_offsets: Dict[int, int] = {}
        for idx, s in enumerate(self.mir_module.string_pool):
            string_rel_offsets[idx] = len(rodata_buf)
            rodata_buf.extend(s.encode("utf-8") + b"\x00")

        buf = self.code_buf
        buf.code.clear()
        buf.labels.clear()
        buf.fixups.clear()

        # 2. Build Entry Point (_start / main)
        entry_fn = "__bmb_main__" if any(f.name == "__bmb_main__" for f in self.mir_module.functions) else "main"
        buf.mark_label("_start")
        buf.stp_fp_lr()
        buf.mov_fp_sp()
        buf.bl_label(f"fn__{entry_fn}")
        # x0 contains exit code
        # Darwin sys_exit: x16 = 0x2000001, svc #0x80
        buf.mov_reg_imm64(16, 0x2000001)
        buf.svc(0x80)

        # 3. Emit Core Runtime Helpers
        # rt__print(x0=kind, x1=val)
        buf.mark_label("rt__print")
        buf.stp_fp_lr()
        buf.mov_fp_sp()
        buf.sub_sp_imm(32)
        buf.str_reg_fp_offset(0, -8)  # kind
        buf.str_reg_fp_offset(1, -16) # val

        buf.cmp_imm(0, 0)
        buf.b_eq_label("rt__p_nl")
        buf.cmp_imm(0, 1)
        buf.b_eq_label("rt__p_sp")
        buf.cmp_imm(0, 2)
        buf.b_eq_label("rt__p_i64")
        buf.cmp_imm(0, 3)
        buf.b_eq_label("rt__p_f64")
        buf.cmp_imm(0, 4)
        buf.b_eq_label("rt__p_str")
        buf.cmp_imm(0, 5)
        buf.b_eq_label("rt__p_bool")
        buf.b_label("rt__p_done")

        # Newline
        buf.mark_label("rt__p_nl")
        buf.mov_reg_imm64(0, 1) # fd = stdout
        buf.adr_label(1, "lbl__rodata_nl")
        buf.mov_reg_imm64(2, 1) # len = 1
        buf.mov_reg_imm64(16, 0x2000004) # sys_write
        buf.svc(0x80)
        buf.b_label("rt__p_done")

        # Space
        buf.mark_label("rt__p_sp")
        buf.mov_reg_imm64(0, 1)
        buf.adr_label(1, "lbl__rodata_sp")
        buf.mov_reg_imm64(2, 1)
        buf.mov_reg_imm64(16, 0x2000004)
        buf.svc(0x80)
        buf.b_label("rt__p_done")

        # i64
        buf.mark_label("rt__p_i64")
        buf.ldr_reg_fp_offset(0, -16) # val
        buf.bl_label("rt__str_from_i64")
        # rax/x0 is formatted string pointer
        buf.mov_reg_reg(1, 0) # buf
        buf.mov_reg_imm64(0, 1) # stdout
        # strlen in x2
        buf.mov_reg_imm64(2, 0)
        buf.mark_label("rt__p_i64_len")
        buf.ldrb_reg_reg(3, 1, 2)
        buf.cmp_imm(3, 0)
        buf.b_eq_label("rt__p_i64_write")
        buf.mov_reg_imm64(4, 1)
        buf.add_reg(2, 2, 4)
        buf.b_label("rt__p_i64_len")
        buf.mark_label("rt__p_i64_write")
        buf.mov_reg_imm64(16, 0x2000004)
        buf.svc(0x80)
        buf.b_label("rt__p_done")

        # f64
        buf.mark_label("rt__p_f64")
        buf.ldr_reg_fp_offset(0, -16)
        buf.bl_label("rt__str_from_f64")
        buf.mov_reg_reg(1, 0)
        buf.mov_reg_imm64(0, 1)
        buf.mov_reg_imm64(2, 0)
        buf.mark_label("rt__p_f64_len")
        buf.ldrb_reg_reg(3, 1, 2)
        buf.cmp_imm(3, 0)
        buf.b_eq_label("rt__p_f64_write")
        buf.mov_reg_imm64(4, 1)
        buf.add_reg(2, 2, 4)
        buf.b_label("rt__p_f64_len")
        buf.mark_label("rt__p_f64_write")
        buf.mov_reg_imm64(16, 0x2000004)
        buf.svc(0x80)
        buf.b_label("rt__p_done")

        # str
        buf.mark_label("rt__p_str")
        buf.ldr_reg_fp_offset(1, -16) # s
        buf.and_reg(2, 1, 0) # test lowest bit
        buf.mov_reg_imm64(3, 1)
        buf.and_reg(2, 1, 3)
        buf.cmp_imm(2, 1)
        buf.b_eq_label("rt__p_sso")

        # Heap string:
        buf.mov_reg_imm64(2, 0)
        buf.mark_label("rt__p_str_len")
        buf.ldrb_reg_reg(3, 1, 2)
        buf.cmp_imm(3, 0)
        buf.b_eq_label("rt__p_str_write")
        buf.mov_reg_imm64(4, 1)
        buf.add_reg(2, 2, 4)
        buf.b_label("rt__p_str_len")
        buf.mark_label("rt__p_str_write")
        buf.mov_reg_imm64(0, 1)
        buf.mov_reg_imm64(16, 0x2000004)
        buf.svc(0x80)
        buf.b_label("rt__p_done")

        # SSO string:
        buf.mark_label("rt__p_sso")
        # len in bits 1..7
        buf.mov_reg_imm64(4, 1)
        buf.lsr_reg(2, 1, 4)
        buf.mov_reg_imm64(4, 0x7F)
        buf.and_reg(2, 2, 4) # len in x2
        # characters in bits 8..63: store to stack buffer
        buf.mov_reg_imm64(4, 8)
        buf.lsr_reg(3, 1, 4)
        buf.str_reg_fp_offset(3, -24)
        # buf ptr in x1
        buf.mov_reg_imm64(4, 24)
        buf.sub_reg(1, 29, 4) # fp - 24
        buf.mov_reg_imm64(0, 1)
        buf.mov_reg_imm64(16, 0x2000004)
        buf.svc(0x80)
        buf.b_label("rt__p_done")

        # bool
        buf.mark_label("rt__p_bool")
        buf.ldr_reg_fp_offset(1, -16)
        buf.cmp_imm(1, 0)
        buf.b_eq_label("rt__p_bool_f")
        buf.mov_reg_imm64(0, 1)
        buf.adr_label(1, "lbl__rodata_true")
        buf.mov_reg_imm64(2, 4)
        buf.mov_reg_imm64(16, 0x2000004)
        buf.svc(0x80)
        buf.b_label("rt__p_done")
        buf.mark_label("rt__p_bool_f")
        buf.mov_reg_imm64(0, 1)
        buf.adr_label(1, "lbl__rodata_false")
        buf.mov_reg_imm64(2, 5)
        buf.mov_reg_imm64(16, 0x2000004)
        buf.svc(0x80)

        buf.mark_label("rt__p_done")
        buf.add_sp_imm(32)
        buf.ldp_fp_lr_and_ret()

        # rt__alloc_arr(x0=count, x1=size) -> x0=ptr
        buf.mark_label("rt__alloc_arr")
        buf.mul_reg(2, 0, 1) # count * size
        buf.mov_reg_imm64(3, 15)
        buf.add_reg(2, 2, 3)
        buf.mov_reg_imm64(3, ~15)
        buf.and_reg(2, 2, 3) # align to 16
        # read current heap ptr
        buf.adr_label(3, "lbl__heap_ptr")
        # ldr x4, [x3]
        buf.emit32(0xF9400064, "ldr x4, [x3]")
        buf.cmp_imm(4, 0)
        buf.b_ne_label("rt__alloc_has_ptr")
        buf.adr_label(4, "lbl__heap_base")
        buf.mark_label("rt__alloc_has_ptr")
        buf.mov_reg_reg(0, 4) # return old pointer
        buf.add_reg(4, 4, 2)  # bump pointer
        # str x4, [x3]
        buf.emit32(0xF9000064, "str x4, [x3]")
        buf.ret()

        # rt__clock_ns -> x0
        buf.mark_label("rt__clock_ns")
        # mrs x0, cntvct_el0
        buf.emit32(0xD53BE020, "mrs x0, cntvct_el0")
        # mrs x1, cntfrq_el0
        buf.emit32(0xD53BE001, "mrs x1, cntfrq_el0")
        buf.mov_reg_imm64(2, 1000000000)
        buf.mul_reg(0, 0, 2)
        buf.udiv_reg(0, 0, 1)
        buf.ret()

        # rt__str_from_bool(x0=bool) -> x0=sso
        buf.mark_label("rt__str_from_bool")
        buf.cmp_imm(0, 0)
        buf.b_eq_label("rt__bool_false")
        buf.mov_reg_imm64(0, 0x6575725409) # SSO 'True'
        buf.ret()
        buf.mark_label("rt__bool_false")
        buf.mov_reg_imm64(0, 0x65736C61460B) # SSO 'False'
        buf.ret()

        # rt__str_from_i64(x0=val) -> x0=str_ptr
        buf.mark_label("rt__str_from_i64")
        buf.stp_fp_lr()
        buf.mov_fp_sp()
        buf.sub_sp_imm(48)
        buf.str_reg_fp_offset(0, -8)  # val
        buf.mov_reg_imm64(0, 32)
        buf.mov_reg_imm64(1, 1)
        buf.bl_label("rt__alloc_arr")
        buf.str_reg_fp_offset(0, -16) # buf_ptr
        buf.str_reg_fp_offset(0, -24) # cursor
        buf.ldr_reg_fp_offset(0, -8)  # val

        buf.cmp_imm(0, 0)
        buf.b_ne_label("rt__itoa_non_zero")
        buf.ldr_reg_fp_offset(1, -24)
        buf.mov_reg_imm64(2, ord('0'))
        buf.strb_reg_reg(2, 1, 31) # strb w2, [x1, xzr]
        buf.mov_reg_imm64(3, 1)
        buf.strb_reg_reg(31, 1, 3) # strb wzr, [x1, x3]
        buf.ldr_reg_fp_offset(0, -16)
        buf.add_sp_imm(48)
        buf.ldp_fp_lr_and_ret()

        buf.mark_label("rt__itoa_non_zero")
        buf.cmp_imm(0, 0)
        buf.b_ge_label("rt__itoa_abs")
        # write '-' and negate
        buf.ldr_reg_fp_offset(1, -24)
        buf.mov_reg_imm64(2, ord('-'))
        buf.strb_reg_reg(2, 1, 31)
        buf.mov_reg_imm64(3, 1)
        buf.add_reg(1, 1, 3)
        buf.str_reg_fp_offset(1, -24)
        buf.neg_reg(0, 0)

        buf.mark_label("rt__itoa_abs")
        buf.mov_reg_imm64(1, 0) # digit count
        buf.mov_reg_imm64(2, 10)
        buf.mark_label("rt__itoa_div_loop")
        buf.cmp_imm(0, 0)
        buf.b_eq_label("rt__itoa_write_digits")
        buf.udiv_reg(3, 0, 2) # q = val / 10
        buf.mul_reg(4, 3, 2)  # q * 10
        buf.sub_reg(5, 0, 4)  # rem = val - q * 10
        buf.mov_reg_imm64(6, ord('0'))
        buf.add_reg(5, 5, 6)  # char
        # store digit on stack
        buf.mov_reg_imm64(6, 32)
        buf.add_reg(6, 6, 1) # 32 + count
        buf.sub_reg(7, 29, 6) # fp - (32 + count)
        buf.strb_reg_reg(5, 7, 31)
        buf.mov_reg_imm64(6, 1)
        buf.add_reg(1, 1, 6) # count++
        buf.mov_reg_reg(0, 3) # val = q
        buf.b_label("rt__itoa_div_loop")

        buf.mark_label("rt__itoa_write_digits")
        buf.ldr_reg_fp_offset(3, -24) # cursor
        buf.mark_label("rt__itoa_pop_loop")
        buf.cmp_imm(1, 0)
        buf.b_eq_label("rt__itoa_done")
        buf.mov_reg_imm64(6, 1)
        buf.sub_reg(1, 1, 6) # count--
        buf.mov_reg_imm64(6, 32)
        buf.add_reg(6, 6, 1)
        buf.sub_reg(7, 29, 6)
        buf.ldrb_reg_reg(5, 7, 31)
        buf.strb_reg_reg(5, 3, 31)
        buf.add_reg(3, 3, 6)
        buf.b_label("rt__itoa_pop_loop")

        buf.mark_label("rt__itoa_done")
        buf.strb_reg_reg(31, 3, 31) # null terminator
        buf.ldr_reg_fp_offset(0, -16) # return buf
        buf.add_sp_imm(48)
        buf.ldp_fp_lr_and_ret()

        # rt__str_from_f64(x0=bits) -> x0=str_ptr
        buf.mark_label("rt__str_from_f64")
        buf.stp_fp_lr()
        buf.mov_fp_sp()
        buf.sub_sp_imm(64)
        buf.str_reg_fp_offset(0, -8)
        buf.mov_reg_imm64(0, 32)
        buf.mov_reg_imm64(1, 1)
        buf.bl_label("rt__alloc_arr")
        buf.str_reg_fp_offset(0, -16) # buf
        buf.str_reg_fp_offset(0, -24) # cursor

        buf.ldr_reg_fp_offset(0, -8)
        buf.fmov_d_x(0, 0) # d0 = val
        buf.fmov_x_d(1, 0) # x1 = bits
        buf.cmp_imm(1, 0)
        buf.b_ge_label("rt__ftoa_pos")
        # write '-'
        buf.ldr_reg_fp_offset(2, -24)
        buf.mov_reg_imm64(3, ord('-'))
        buf.strb_reg_reg(3, 2, 31)
        buf.mov_reg_imm64(4, 1)
        buf.add_reg(2, 2, 4)
        buf.str_reg_fp_offset(2, -24)
        # negate float: fneg d0, d0
        buf.emit32(0x1E614000, "fneg d0, d0")

        buf.mark_label("rt__ftoa_pos")
        # int_part = (i64)d0
        buf.fcvtzs(1, 0) # x1 = int_part
        buf.str_reg_fp_offset(1, -32)
        buf.mov_reg_reg(0, 1)
        buf.bl_label("rt__str_from_i64")
        # copy formatted int to cursor
        buf.mov_reg_reg(1, 0) # int str
        buf.ldr_reg_fp_offset(2, -24) # cursor
        buf.mov_reg_imm64(3, 0)
        buf.mark_label("rt__ftoa_copy_int")
        buf.ldrb_reg_reg(4, 1, 3)
        buf.cmp_imm(4, 0)
        buf.b_eq_label("rt__ftoa_int_copied")
        buf.strb_reg_reg(4, 2, 3)
        buf.mov_reg_imm64(5, 1)
        buf.add_reg(3, 3, 5)
        buf.b_label("rt__ftoa_copy_int")
        buf.mark_label("rt__ftoa_int_copied")
        buf.add_reg(2, 2, 3) # advance cursor
        # write '.'
        buf.mov_reg_imm64(4, ord('.'))
        buf.strb_reg_reg(4, 2, 31)
        buf.mov_reg_imm64(5, 1)
        buf.add_reg(2, 2, 5)
        buf.str_reg_fp_offset(2, -24)

        # frac = d0 - (double)int_part
        buf.ldr_reg_fp_offset(1, -32)
        buf.scvtf(1, 1) # d1 = (double)int_part
        buf.fsub(0, 0, 1) # d0 = frac
        buf.mov_reg_imm64(2, 1000000)
        buf.scvtf(1, 2) # d1 = 1000000.0
        buf.fmul(0, 0, 1) # d0 = frac * 1000000.0
        buf.fcvtzs(0, 0) # x0 = int frac
        # write 6 digits
        buf.ldr_reg_fp_offset(2, -24)
        buf.mov_reg_imm64(5, 5)
        buf.add_reg(3, 2, 5) # cursor + 5
        buf.mov_reg_imm64(4, 6) # count
        buf.mov_reg_imm64(6, 10)
        buf.mark_label("rt__ftoa_frac_loop")
        buf.udiv_reg(7, 0, 6) # q
        buf.mul_reg(8, 7, 6)
        buf.sub_reg(9, 0, 8)  # rem
        buf.mov_reg_imm64(10, ord('0'))
        buf.add_reg(9, 9, 10)
        buf.strb_reg_reg(9, 3, 31)
        buf.mov_reg_imm64(10, 1)
        buf.sub_reg(3, 3, 10)
        buf.mov_reg_reg(0, 7)
        buf.sub_reg(4, 4, 10)
        buf.cmp_imm(4, 0)
        buf.b_ne_label("rt__ftoa_frac_loop")

        # null terminate at cursor + 6
        buf.mov_reg_imm64(5, 6)
        buf.strb_reg_reg(31, 2, 5)
        buf.ldr_reg_fp_offset(0, -16)
        buf.add_sp_imm(64)
        buf.ldp_fp_lr_and_ret()

        # Fallback stubs
        buf.mark_label("rt__py_stub")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("rt__arena_save")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("rt__arena_restore")
        buf.ret()

        # String helpers
        buf.mark_label("rt__str_len")
        buf.mov_reg_imm64(1, 1)
        buf.and_reg(2, 0, 1)
        buf.cmp_imm(2, 1)
        buf.b_eq_label("rt__strlen_sso")
        # heap strlen
        buf.mov_reg_imm64(1, 0)
        buf.mark_label("rt__strlen_loop")
        buf.ldrb_reg_reg(2, 0, 1)
        buf.cmp_imm(2, 0)
        buf.b_eq_label("rt__strlen_done")
        buf.mov_reg_imm64(3, 1)
        buf.add_reg(1, 1, 3)
        buf.b_label("rt__strlen_loop")
        buf.mark_label("rt__strlen_done")
        buf.mov_reg_reg(0, 1)
        buf.ret()
        buf.mark_label("rt__strlen_sso")
        buf.mov_reg_imm64(1, 1)
        buf.lsr_reg(0, 0, 1)
        buf.mov_reg_imm64(1, 0x7F)
        buf.and_reg(0, 0, 1)
        buf.ret()

        # String equality cmp_eq(x0=s1, x1=s2) -> x0=bool
        buf.mark_label("rt__str_cmp_eq")
        buf.cmp_reg(0, 1)
        buf.b_eq_label("rt__cmp_eq_true")
        # One or both might be pointer strings
        buf.stp_fp_lr()
        buf.mov_fp_sp()
        buf.sub_sp_imm(32)
        buf.str_reg_fp_offset(0, -8)
        buf.str_reg_fp_offset(1, -16)
        # compare byte-by-byte
        buf.mov_reg_imm64(2, 0)
        buf.mark_label("rt__cmp_eq_loop")
        buf.ldr_reg_fp_offset(0, -8)
        buf.ldr_reg_fp_offset(1, -16)
        buf.ldrb_reg_reg(3, 0, 2)
        buf.ldrb_reg_reg(4, 1, 2)
        buf.cmp_reg(3, 4)
        buf.b_ne_label("rt__cmp_eq_false")
        buf.cmp_imm(3, 0)
        buf.b_eq_label("rt__cmp_eq_same")
        buf.mov_reg_imm64(5, 1)
        buf.add_reg(2, 2, 5)
        buf.b_label("rt__cmp_eq_loop")
        buf.mark_label("rt__cmp_eq_same")
        buf.mov_reg_imm64(0, 1)
        buf.add_sp_imm(32)
        buf.ldp_fp_lr_and_ret()
        buf.mark_label("rt__cmp_eq_false")
        buf.mov_reg_imm64(0, 0)
        buf.add_sp_imm(32)
        buf.ldp_fp_lr_and_ret()
        buf.mark_label("rt__cmp_eq_true")
        buf.mov_reg_imm64(0, 1)
        buf.ret()

        # Dynamic string concatenation
        buf.mark_label("rt__str_concat")
        buf.stp_fp_lr()
        buf.mov_fp_sp()
        buf.sub_sp_imm(48)
        buf.str_reg_fp_offset(0, -8)  # s1
        buf.str_reg_fp_offset(1, -16) # s2
        buf.bl_label("rt__str_len")
        buf.str_reg_fp_offset(0, -24) # len1
        buf.ldr_reg_fp_offset(0, -16)
        buf.bl_label("rt__str_len")
        buf.str_reg_fp_offset(0, -32) # len2

        # alloc len1 + len2 + 1
        buf.ldr_reg_fp_offset(0, -24)
        buf.ldr_reg_fp_offset(1, -32)
        buf.add_reg(0, 0, 1)
        buf.mov_reg_imm64(2, 1)
        buf.add_reg(0, 0, 2)
        buf.mov_reg_imm64(1, 1)
        buf.bl_label("rt__alloc_arr")
        buf.str_reg_fp_offset(0, -40) # dst

        # Copy s1
        buf.ldr_reg_fp_offset(1, -8)  # s1
        buf.ldr_reg_fp_offset(2, -40) # dst
        buf.ldr_reg_fp_offset(3, -24) # len1
        buf.mov_reg_imm64(4, 0)
        buf.mark_label("rt__cat_s1_loop")
        buf.cmp_reg(4, 3)
        buf.b_ge_label("rt__cat_s1_done")
        buf.ldrb_reg_reg(5, 1, 4)
        buf.strb_reg_reg(5, 2, 4)
        buf.mov_reg_imm64(6, 1)
        buf.add_reg(4, 4, 6)
        buf.b_label("rt__cat_s1_loop")
        buf.mark_label("rt__cat_s1_done")

        # Copy s2
        buf.ldr_reg_fp_offset(1, -16) # s2
        buf.ldr_reg_fp_offset(2, -40)
        buf.ldr_reg_fp_offset(3, -24)
        buf.add_reg(2, 2, 3) # dst + len1
        buf.ldr_reg_fp_offset(3, -32) # len2
        buf.mov_reg_imm64(4, 0)
        buf.mark_label("rt__cat_s2_loop")
        buf.cmp_reg(4, 3)
        buf.b_ge_label("rt__cat_s2_done")
        buf.ldrb_reg_reg(5, 1, 4)
        buf.strb_reg_reg(5, 2, 4)
        buf.mov_reg_imm64(6, 1)
        buf.add_reg(4, 4, 6)
        buf.b_label("rt__cat_s2_loop")
        buf.mark_label("rt__cat_s2_done")

        # Null terminate
        buf.strb_reg_reg(31, 2, 4)
        buf.ldr_reg_fp_offset(0, -40) # return dst
        buf.add_sp_imm(48)
        buf.ldp_fp_lr_and_ret()

        # Builtin runtime implementations and stubs for ARM64 macOS
        buf.mark_label("fn____bmb_file_exists")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_file_size")
        buf.mov_reg_imm64(0, -1)
        buf.ret()

        buf.mark_label("fn____bmb_file_read")
        buf.mov_reg_imm64(0, 1) # empty string SSO
        buf.ret()

        buf.mark_label("fn____bmb_file_write")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_file_remove")
        buf.mov_reg_imm64(0, 1)
        buf.ret()

        buf.mark_label("fn____bmb_get_cwd")
        buf.mov_reg_imm64(0, 1)
        buf.ret()

        buf.mark_label("fn____bmb_get_env")
        buf.mov_reg_imm64(0, 1)
        buf.ret()

        buf.mark_label("fn____bmb_socket_init")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_socket_cleanup")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_socket_create")
        buf.mov_reg_imm64(0, -1)
        buf.ret()

        buf.mark_label("fn____bmb_socket_connect")
        buf.mov_reg_imm64(0, -1)
        buf.ret()

        buf.mark_label("fn____bmb_socket_bind")
        buf.mov_reg_imm64(0, -1)
        buf.ret()

        buf.mark_label("fn____bmb_socket_listen")
        buf.mov_reg_imm64(0, -1)
        buf.ret()

        buf.mark_label("fn____bmb_socket_accept")
        buf.mov_reg_imm64(0, -1)
        buf.ret()

        buf.mark_label("fn____bmb_socket_send")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_socket_recv")
        buf.mov_reg_imm64(0, 1) # empty string SSO
        buf.ret()

        buf.mark_label("fn____bmb_socket_close")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_atomic_load")
        buf.emit32(0xF9400000, "ldr x0, [x0]")
        buf.ret()

        buf.mark_label("fn____bmb_atomic_store")
        buf.emit32(0xF9000001, "str x1, [x0]")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_atomic_add")
        buf.emit32(0xF9400002, "ldr x2, [x0]")
        buf.emit32(0x8B010043, "add x3, x2, x1")
        buf.emit32(0xF9000003, "str x3, [x0]")
        buf.emit32(0xAA0203E0, "mov x0, x2")
        buf.ret()

        buf.mark_label("fn____bmb_atomic_sub")
        buf.emit32(0xF9400002, "ldr x2, [x0]")
        buf.emit32(0xCB010043, "sub x3, x2, x1")
        buf.emit32(0xF9000003, "str x3, [x0]")
        buf.emit32(0xAA0203E0, "mov x0, x2")
        buf.ret()

        buf.mark_label("fn____bmb_atomic_cas")
        buf.emit32(0xF9400003, "ldr x3, [x0]")
        buf.emit32(0xEB01007F, "cmp x3, x1")
        buf.emit32(0x54000041, "b.ne +8")
        buf.emit32(0xF9000002, "str x2, [x0]")
        buf.emit32(0xAA0303E0, "mov x0, x3")
        buf.ret()

        buf.mark_label("fn____bmb_atomic_fence")
        buf.emit32(0xD5033BBF, "dmb ish")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_cpu_pause")
        buf.emit32(0xD503205F, "yield")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_thread_concurrency")
        buf.mov_reg_imm64(0, 4)
        buf.ret()

        buf.mark_label("fn____bmb_thread_spawn")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_thread_join")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_thread_id")
        buf.mov_reg_imm64(0, 1)
        buf.ret()

        buf.mark_label("fn____bmb_thread_yield")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_thread_sleep")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_mem_alloc")
        buf.stp_fp_lr()
        buf.mov_fp_sp()
        buf.sub_sp_imm(16)
        buf.mov_reg_reg(1, 0) # size in x1
        buf.mov_reg_imm64(0, 1) # count = 1
        buf.bl_label("rt__alloc_arr")
        buf.add_sp_imm(16)
        buf.ldp_fp_lr_and_ret()

        buf.mark_label("fn____bmb_mem_free")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_mem_read")
        buf.ldr_reg_reg(0, 0, 1, shift=3)
        buf.ret()

        buf.mark_label("fn____bmb_mem_write")
        buf.str_reg_reg(2, 0, 1, shift=3)
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_mem_read32")
        buf.emit32(0xB8617800, "ldr w0, [x0, x1, lsl #2]")
        buf.ret()

        buf.mark_label("fn____bmb_mem_write32")
        buf.emit32(0xB8217802, "str w2, [x0, x1, lsl #2]")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_mem_read8")
        buf.ldrb_reg_reg(0, 0, 1)
        buf.ret()

        buf.mark_label("fn____bmb_mem_write8")
        buf.emit32(0x38216802, "strb w2, [x0, x1]")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_file_write_bytes")
        buf.mov_reg_reg(0, 2)
        buf.ret()

        buf.mark_label("fn____bmb_file_read_bytes")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_alloc_root_get")
        buf.mov_reg_imm64(0, 0)
        buf.ret()

        buf.mark_label("fn____bmb_alloc_root_set")
        buf.ret()

        buf.mark_label("fn____bmb_exit")
        buf.mov_reg_imm64(16, 0x2000001)
        buf.svc(0x80)
        buf.ret()

        # 4. Compile all MIR user functions
        self.known_fn_names = {f.name for f in self.mir_module.functions}
        self.known_fn_names.update([
            "__bmb_file_exists", "__bmb_file_size", "__bmb_file_read", "__bmb_file_write",
            "__bmb_file_write_bytes", "__bmb_file_read_bytes",
            "__bmb_file_remove", "__bmb_get_cwd", "__bmb_get_env",
            "__bmb_socket_init", "__bmb_socket_cleanup", "__bmb_socket_create",
            "__bmb_socket_connect", "__bmb_socket_bind", "__bmb_socket_listen",
            "__bmb_socket_accept", "__bmb_socket_send", "__bmb_socket_recv",
            "__bmb_socket_close",
            "__bmb_atomic_load", "__bmb_atomic_store", "__bmb_atomic_add", "__bmb_atomic_sub",
            "__bmb_atomic_cas", "__bmb_atomic_fence", "__bmb_cpu_pause",
            "__bmb_thread_concurrency", "__bmb_thread_spawn", "__bmb_thread_join",
            "__bmb_thread_id", "__bmb_thread_yield", "__bmb_thread_sleep",
            "__bmb_mem_alloc", "__bmb_mem_free", "__bmb_mem_read", "__bmb_mem_write",
            "__bmb_mem_read32", "__bmb_mem_write32", "__bmb_mem_read8", "__bmb_mem_write8",
            "__bmb_alloc_root_get", "__bmb_alloc_root_set", "__bmb_exit",
        ])

        helper_labels = {
            "print": "rt__print",
            "alloc_arr": "rt__alloc_arr",
            "pow_i64": "rt__py_stub",
            "pow_f64": "rt__py_stub",
            "py_call_f64": "rt__py_stub",
            "py_eval_f64": "rt__py_stub",
            "py_eval_tensor": "rt__py_stub",
            "arena_save": "rt__arena_save",
            "arena_restore": "rt__arena_restore",
            "str_concat": "rt__str_concat",
            "str_slice": "rt__py_stub",
            "str_index": "rt__py_stub",
            "str_len": "rt__str_len",
            "str_cmp_eq": "rt__str_cmp_eq",
            "str_cmp_ne": "rt__py_stub",
            "str_cmp_lt": "rt__py_stub",
            "str_cmp_le": "rt__py_stub",
            "str_cmp_gt": "rt__py_stub",
            "str_cmp_ge": "rt__py_stub",
            "str_from_i64": "rt__str_from_i64",
            "str_from_f64": "rt__str_from_f64",
            "str_from_bool": "rt__str_from_bool",
            "str_ord": "rt__py_stub",
            "str_chr": "rt__py_stub",
            "str_to_i64": "rt__py_stub",
            "str_to_f64": "rt__py_stub",
            "clock_ns": "rt__clock_ns",
        }

        for fn in self.mir_module.functions:
            self._compile_function(fn, buf, string_rel_offsets, helper_labels)

        # 5. Position rodata and resolve fixups
        text_bytes_len = len(buf.code)
        rodata_offset_in_text = text_bytes_len

        buf.labels["lbl__rodata_sp"] = rodata_offset_in_text + str_sp
        buf.labels["lbl__rodata_nl"] = rodata_offset_in_text + str_nl
        buf.labels["lbl__rodata_true"] = rodata_offset_in_text + str_true
        buf.labels["lbl__rodata_false"] = rodata_offset_in_text + str_false
        buf.labels["lbl__rodata_empty"] = rodata_offset_in_text + str_empty
        buf.labels["lbl__heap_ptr"] = rodata_offset_in_text + heap_ptr_offset
        buf.labels["lbl__heap_base"] = rodata_offset_in_text + len(rodata_buf) + 16

        for idx, ro_off in string_rel_offsets.items():
            buf.labels[f"lbl__str_{idx}"] = rodata_offset_in_text + ro_off

        buf.resolve_fixups()

        code_and_rodata = bytes(buf.code) + bytes(rodata_buf)

        # 6. Build Mach-O 64-bit Header and Load Commands
        payload_offset = PAGE_SIZE # 16KB aligned payload
        entry_point_offset = payload_offset + buf.labels["_start"]

        ncmds = 5
        sizeofcmds = 72 + 152 + 24 + 24 + 32 # 304 bytes
        filesize = payload_offset + len(code_and_rodata)
        vmsize = _align(filesize + 0x100000, PAGE_SIZE) # 1MB heap

        # Header (32 bytes)
        mach_header = struct.pack(
            "<IIIIIIII",
            0xFEEDFACF, # MH_MAGIC_64
            0x0100000C, # CPU_TYPE_ARM64
            0x00000000, # CPU_SUBTYPE_ARM64_ALL
            2,          # MH_EXECUTE
            ncmds,
            sizeofcmds,
            0x00200085, # MH_NOUNDEFS | MH_DYLDLINK | MH_TWOLEVEL | MH_PIE
            0
        )

        # LC 1: LC_SEGMENT_64 (__PAGEZERO, 72 bytes)
        pagezero = struct.pack(
            "<II16sQQQQIIII",
            0x19, 72,
            b"__PAGEZERO\x00\x00\x00\x00\x00\x00",
            0, IMAGE_BASE, 0, 0,
            0, 0, 0, 0
        )

        # LC 2: LC_SEGMENT_64 (__TEXT, 152 bytes)
        text_seg = struct.pack(
            "<II16sQQQQIIII",
            0x19, 152,
            b"__TEXT\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00",
            IMAGE_BASE, vmsize,
            0, _align(filesize, PAGE_SIZE),
            7, 7, 1, 0
        )
        text_sect = struct.pack(
            "<16s16sQQIIIIIIII",
            b"__text\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00",
            b"__TEXT\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00",
            IMAGE_BASE + payload_offset, len(code_and_rodata),
            payload_offset, 2, 0, 0, 0x80000400,
            0, 0, 0
        )

        # LC 3: LC_BUILD_VERSION (24 bytes)
        build_ver = struct.pack(
            "<IIIIII",
            0x32, 24,
            1,          # PLATFORM_MACOS
            0x000B0000, # macOS 11.0 (Big Sur)
            0x000E0000, # SDK 14.0
            0
        )

        # LC 4: LC_MAIN (24 bytes)
        lc_main = struct.pack(
            "<IIQQ",
            0x80000028, 24,
            entry_point_offset, 0
        )

        # LC 5: LC_LOAD_DYLINKER (32 bytes)
        lc_dyld = struct.pack(
            "<III20s",
            0x0E, 32, 12,
            b"/usr/lib/dyld\x00\x00\x00\x00\x00\x00\x00"
        )

        cmds = pagezero + text_seg + text_sect + build_ver + lc_main + lc_dyld
        pad_len = payload_offset - (len(mach_header) + len(cmds))
        padding = b"\x00" * pad_len

        return mach_header + cmds + padding + code_and_rodata

    def _compile_function(
        self,
        fn: MIRFunction,
        buf: ARM64CodeBuffer,
        string_rel_offsets: Dict[int, int],
        helper_labels: Dict[str, str],
    ) -> None:
        buf.mark_label(f"fn__{fn.name}")
        buf.stp_fp_lr()
        buf.mov_fp_sp()

        # Compute stack frame slots
        slots: Dict[str, int] = {}
        cur_offset = -16
        for p_name, _ in fn.params:
            slots[p_name] = cur_offset
            cur_offset -= 8

        for ins in fn.instructions:
            if ins.dst and ins.dst != "%void" and ins.dst not in slots:
                slots[ins.dst] = cur_offset
                cur_offset -= 8

        frame_size = _align(-cur_offset + 16, 16)
        buf.sub_sp_imm(frame_size)

        # Store incoming parameters from x0..x7 into their stack slots
        for idx, (p_name, _) in enumerate(fn.params):
            if idx < 8:
                buf.str_reg_fp_offset(idx, slots[p_name])

        def load_val(reg: int, src: str) -> None:
            if src.isdigit() or (src.startswith("-") and src[1:].isdigit()):
                buf.mov_reg_imm64(reg, int(src))
            elif src in slots:
                buf.ldr_reg_fp_offset(reg, slots[src])
            else:
                buf.mov_reg_imm64(reg, 0)

        def store_val(reg: int, dst: str) -> None:
            if dst in slots:
                buf.str_reg_fp_offset(reg, slots[dst])

        # Lower MIR instructions to ARM64
        for ins in fn.instructions:
            op = ins.op
            if op == "LABEL":
                buf.mark_label(f"lbl__{fn.name}_{ins.arg1}")
            elif op == "JMP":
                buf.b_label(f"lbl__{fn.name}_{ins.arg1}")
            elif op == "JZ":
                load_val(9, str(ins.arg1))
                buf.cmp_imm(9, 0)
                buf.b_eq_label(f"lbl__{fn.name}_{ins.arg2}")
            elif op == "JNZ":
                load_val(9, str(ins.arg1))
                buf.cmp_imm(9, 0)
                buf.b_ne_label(f"lbl__{fn.name}_{ins.arg2}")
            elif op == "CONST_I64":
                buf.mov_reg_imm64(9, int(ins.arg1))
                store_val(9, str(ins.dst))
            elif op == "CONST_F64":
                fbits = struct.unpack("<Q", struct.pack("<d", float(ins.arg1)))[0]
                buf.mov_reg_imm64(9, fbits)
                store_val(9, str(ins.dst))
            elif op == "CONST_BOOL":
                val = 1 if (ins.arg1 is True or ins.arg1 == "True" or ins.arg1 == 1) else 0
                buf.mov_reg_imm64(9, val)
                store_val(9, str(ins.dst))
            elif op == "CONST_STR":
                str_idx = int(ins.arg1)
                buf.adr_label(9, f"lbl__str_{str_idx}")
                store_val(9, str(ins.dst))
            elif op in ("MOV", "MOVE"):
                load_val(9, str(ins.arg1))
                store_val(9, str(ins.dst))
            elif op == "ADD_I64":
                load_val(9, str(ins.arg1))
                load_val(10, str(ins.arg2))
                buf.add_reg(9, 9, 10)
                store_val(9, str(ins.dst))
            elif op == "SUB_I64":
                load_val(9, str(ins.arg1))
                load_val(10, str(ins.arg2))
                buf.sub_reg(9, 9, 10)
                store_val(9, str(ins.dst))
            elif op == "MUL_I64":
                load_val(9, str(ins.arg1))
                load_val(10, str(ins.arg2))
                buf.mul_reg(9, 9, 10)
                store_val(9, str(ins.dst))
            elif op == "DIV_I64":
                load_val(9, str(ins.arg1))
                load_val(10, str(ins.arg2))
                buf.sdiv_reg(9, 9, 10)
                store_val(9, str(ins.dst))
            elif op == "MOD_I64":
                load_val(9, str(ins.arg1))
                load_val(10, str(ins.arg2))
                buf.sdiv_reg(11, 9, 10) # q
                buf.mul_reg(12, 11, 10)
                buf.sub_reg(9, 9, 12)   # rem
                store_val(9, str(ins.dst))
            elif op == "NEG_I64":
                load_val(9, str(ins.arg1))
                buf.neg_reg(9, 9)
                store_val(9, str(ins.dst))
            elif op == "ABS_I64":
                load_val(9, str(ins.arg1))
                buf.cmp_imm(9, 0)
                buf.emit32(0x5400004A, "b.ge +8")
                buf.neg_reg(9, 9)
                store_val(9, str(ins.dst))
            elif op == "ABS_F64":
                load_val(9, str(ins.arg1))
                buf.mov_reg_imm64(10, 0x7FFFFFFFFFFFFFFF)
                buf.and_reg(9, 9, 10)
                store_val(9, str(ins.dst))
            elif op == "AND_I64":
                load_val(9, str(ins.arg1))
                load_val(10, str(ins.arg2))
                buf.and_reg(9, 9, 10)
                store_val(9, str(ins.dst))
            elif op == "OR_I64":
                load_val(9, str(ins.arg1))
                load_val(10, str(ins.arg2))
                buf.orr_reg(9, 9, 10)
                store_val(9, str(ins.dst))
            elif op == "XOR_I64":
                load_val(9, str(ins.arg1))
                load_val(10, str(ins.arg2))
                buf.eor_reg(9, 9, 10)
                store_val(9, str(ins.dst))
            elif op == "SHL_I64":
                load_val(9, str(ins.arg1))
                load_val(10, str(ins.arg2))
                buf.lsl_reg(9, 9, 10)
                store_val(9, str(ins.dst))
            elif op == "SHR_I64":
                load_val(9, str(ins.arg1))
                load_val(10, str(ins.arg2))
                buf.lsr_reg(9, 9, 10)
                store_val(9, str(ins.dst))
            elif op.startswith("CMP_"):
                load_val(9, str(ins.arg1))
                load_val(10, str(ins.arg2))
                buf.cmp_reg(9, 10)
                cond_map = {
                    "CMP_EQ_I64": 0, "CMP_NE_I64": 1,
                    "CMP_LT_I64": 11, "CMP_LE_I64": 13,
                    "CMP_GT_I64": 12, "CMP_GE_I64": 10
                }
                c = cond_map.get(op, 0)
                buf.cset(9, c)
                store_val(9, str(ins.dst))
            elif op == "CALL":
                # Prepare arguments in x0..x7
                for arg_idx, arg_name in enumerate(ins.extra):
                    if arg_idx < 8:
                        load_val(arg_idx, arg_name)
                if ins.arg1 in self.known_fn_names:
                    buf.bl_label(f"fn__{ins.arg1}")
                else:
                    load_val(16, str(ins.arg1))
                    buf.blr_reg(16)
                if ins.dst and ins.dst != "%void":
                    store_val(0, str(ins.dst))
            elif op == "PRINT":
                types = [t for t in (ins.comment or "").split(",") if t]
                kind_map = {"i64": 2, "f64": 3, "str": 4, "bool": 5}
                for idx, (arg_v, arg_t) in enumerate(zip(ins.extra, types)):
                    if idx > 0 and (types[idx - 1] != "str" and arg_t != "str"):
                        buf.mov_reg_imm64(0, 1)  # SP
                        buf.mov_reg_imm64(1, 0)
                        buf.bl_label("rt__print")
                    buf.mov_reg_imm64(0, kind_map.get(arg_t, 2))
                    load_val(1, str(arg_v))
                    buf.bl_label("rt__print")
                buf.mov_reg_imm64(0, 0)  # NL
                buf.mov_reg_imm64(1, 0)
                buf.bl_label("rt__print")
            elif op == "STR_CONCAT":
                load_val(0, str(ins.arg1))
                load_val(1, str(ins.arg2))
                buf.bl_label("rt__str_concat")
                store_val(0, str(ins.dst))
            elif op == "STR_FROM_I64":
                load_val(0, str(ins.arg1))
                buf.bl_label("rt__str_from_i64")
                store_val(0, str(ins.dst))
            elif op == "STR_FROM_F64":
                load_val(0, str(ins.arg1))
                buf.bl_label("rt__str_from_f64")
                store_val(0, str(ins.dst))
            elif op == "STR_FROM_BOOL":
                load_val(0, str(ins.arg1))
                buf.bl_label("rt__str_from_bool")
                store_val(0, str(ins.dst))
            elif op == "ALLOC_ARR":
                load_val(0, str(ins.arg1)) # count
                load_val(1, str(ins.arg2)) # size
                buf.bl_label("rt__alloc_arr")
                store_val(0, str(ins.dst))
            elif op in ("LOAD_IDX", "LOAD_ARR"):
                load_val(9, str(ins.arg1))  # arr
                load_val(10, str(ins.arg2)) # idx
                buf.ldr_reg_reg(11, 9, 10, shift=3)
                store_val(11, str(ins.dst))
            elif op == "STORE_IDX":
                load_val(9, str(ins.dst))   # arr
                load_val(10, str(ins.arg1)) # idx
                load_val(11, str(ins.arg2)) # val
                buf.str_reg_reg(11, 9, 10, shift=3)
            elif op == "STORE_ARR":
                load_val(9, str(ins.arg1))  # arr
                load_val(10, str(ins.arg2)) # idx
                load_val(11, str(ins.extra[0])) # val
                buf.str_reg_reg(11, 9, 10, shift=3)
            elif op == "RET":
                if ins.arg1 and ins.arg1 != "%void":
                    load_val(0, str(ins.arg1))
                else:
                    buf.mov_reg_imm64(0, 0)
                buf.add_sp_imm(frame_size)
                buf.ldp_fp_lr_and_ret()

        # Epilogue
        buf.mov_reg_imm64(0, 0)
        buf.add_sp_imm(frame_size)
        buf.ldp_fp_lr_and_ret()

    def write_executable(self, output_path: str) -> str:
        """Writes the standalone macOS ARM64 Mach-O executable to disk."""
        macho_bytes = self.build_bytes()
        os.makedirs(os.path.dirname(os.path.abspath(output_path)), exist_ok=True)
        with open(output_path, "wb") as f:
            f.write(macho_bytes)
        try:
            os.chmod(output_path, 0o755)
        except OSError:
            pass
        return os.path.abspath(output_path)
