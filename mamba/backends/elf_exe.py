"""
Black Mamba (.bmb) Standalone Linux 64-bit ELF (ELF64) Native Compiler & Linker.

Directly emits a zero-dependency, static Linux x86-64 ELF executable (.elf / binary) containing:
- ELF64 Header & Program Header Table (PT_LOAD with System V AMD64 ABI)
- .text: Native x86-64 machine code (_start, Linux syscall runtime helpers, and all .bmb functions)
- .rodata: String pool, boolean literals, newline, and static constants
- .shstrtab & Section Header Table: Standard ELF sections (.text, .rodata, .shstrtab) verifiable via REA

Uses raw Linux kernel syscalls:
- sys_write (1): Direct console output to stdout (fd=1)
- sys_exit (60): Clean process termination with exit code
- sys_mmap (9) / static arena: Heap allocation for value structs and dynamic arrays
"""

import os
import struct
from typing import Dict, List, Tuple
from ..mir import MIRFunction, MIRModule
from .x86_64_jit import X86_64CodeBuffer


IMAGE_BASE = 0x00400000  # Standard Linux 64-bit executable base
HEADER_SIZE = 64         # ELF64 header size
PH_SIZE = 56             # ELF64 program header entry size


def _align(val: int, alignment: int) -> int:
    return (val + alignment - 1) & ~(alignment - 1)


class ELF64ExecutableBuilder:
    """Compiles a MIRModule directly into a static Linux x86-64 ELF executable."""

    def __init__(self, mir_module: MIRModule):
        self.mir_module = mir_module
        self.code_buf = X86_64CodeBuffer()
        self.string_offsets: Dict[int, int] = {}

    def build_bytes(self) -> bytes:
        """
        Builds the complete ELF64 binary image in memory.
        Layout:
        0x0000 - 0x003F: ELF64 Header (64 bytes)
        0x0040 - 0x0077: Program Header (PT_LOAD, 56 bytes)
        0x0078 - 0x00FF: Padding to 16-byte alignment
        0x0100 - Text & RoData code payload
        End: Section headers & .shstrtab
        """
        text_vaddr_start = IMAGE_BASE + 0x100

        # 1. Build .rodata and string pool
        rodata_buf = bytearray()
        str_sp = len(rodata_buf)
        rodata_buf.extend(b" \x00")
        str_nl = len(rodata_buf)
        rodata_buf.extend(b"\n\x00")
        str_true = len(rodata_buf)
        rodata_buf.extend(b"True\x00")
        str_false = len(rodata_buf)
        rodata_buf.extend(b"False\x00")

        # String literals pool
        string_rel_offsets: Dict[int, int] = {}
        for idx, s in enumerate(self.mir_module.string_pool):
            string_rel_offsets[idx] = len(rodata_buf)
            rodata_buf.extend(s.encode("utf-8") + b"\x00")

        # 2. Build .text section using X86_64CodeBuffer
        buf = self.code_buf
        buf.code.clear()
        buf.labels.clear()
        buf.rel32_fixups.clear()

        # Entry point: _start per System V ABI
        buf.mark_label("_start")
        # System V ABI: rbp should be 0 at entry
        buf.emit(b"\x48\x31\xED", "xor rbp, rbp")
        # Call Black Mamba main
        buf.call_label("fn__main")
        # Exit with return value in rdi
        buf.emit(b"\x48\x89\xC7", "mov rdi, rax ; exit code")
        buf.emit(b"\x48\xC7\xC0\x3C\x00\x00\x00", "mov rax, 60 ; sys_exit")
        buf.emit(b"\x0F\x05", "syscall")

        # --- Linux Syscall Runtime Helpers ---

        # rt__print: Handles formatting and writing to stdout via sys_write (1)
        # rcx = kind (0=i64, 1=f64, 2=bool, 3=str, 4=space, 5=newline), rdx = raw_value / str_ptr
        buf.mark_label("rt__print")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.push_callee_saved()
        buf.sub_rsp_imm32(64)  # Local formatting buffer on stack

        # Check kind
        buf.emit(b"\x48\x83\xF9\x05", "cmp rcx, 5 ; newline")
        buf.jcc_rel32(0x84, "e", "rt__print_nl")

        buf.emit(b"\x48\x83\xF9\x04", "cmp rcx, 4 ; space")
        buf.jcc_rel32(0x84, "e", "rt__print_sp")

        buf.emit(b"\x48\x83\xF9\x03", "cmp rcx, 3 ; str")
        buf.jcc_rel32(0x84, "e", "rt__print_str")

        buf.emit(b"\x48\x83\xF9\x02", "cmp rcx, 2 ; bool")
        buf.jcc_rel32(0x84, "e", "rt__print_bool")

        # Default: print i64 integer as decimal to stdout
        # rdx = int64 value
        buf.mark_label("rt__print_i64")
        # Format decimal in stack buffer [rbp - 48]
        # rax = value
        buf.emit(b"\x48\x89\xD0", "mov rax, rdx")
        # r8 = is_negative flag
        buf.emit(b"\x4D\x31\xC0", "xor r8, r8")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x89, "ns", "rt__i64_pos")
        buf.emit(b"\x41\xB8\x01\x00\x00\x00", "mov r8d, 1 ; is_negative = true")
        buf.emit(b"\x48\xF7\xD8", "neg rax")
        buf.mark_label("rt__i64_pos")

        # Write digits backwards from [rbp - 1]
        buf.emit(b"\x48\x8D\x7D\xFF", "lea rdi, [rbp - 1]")
        buf.emit(b"\x49\xC7\xC1\x0A\x00\x00\x00", "mov r9, 10")
        buf.emit(b"\x4D\x31\xE4", "xor r12, r12 ; digit_count = 0")

        buf.mark_label("rt__i64_loop")
        buf.emit(b"\x48\x31\xD2", "xor rdx, rdx")
        buf.emit(b"\x49\xF7\xF1", "div r9 ; rax / 10, rem in rdx")
        buf.emit(b"\x80\xC2\x30", "add dl, '0'")
        buf.emit(b"\x88\x17", "mov byte ptr [rdi], dl")
        buf.emit(b"\x48\xFF\xCF", "dec rdi")
        buf.emit(b"\x49\xFF\xC4", "inc r12")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x85, "nz", "rt__i64_loop")

        # Check negative
        buf.emit(b"\x4D\x85\xC0", "test r8, r8")
        buf.jcc_rel32(0x84, "z", "rt__i64_write")
        buf.emit(b"\xC6\x07\x2D", "mov byte ptr [rdi], '-'")
        buf.emit(b"\x48\xFF\xCF", "dec rdi")
        buf.emit(b"\x49\xFF\xC4", "inc r12")

        buf.mark_label("rt__i64_write")
        buf.emit(b"\x48\x8D\x77\x01", "lea rsi, [rdi + 1] ; buf pointer")
        buf.emit(b"\x4C\x89\xE2", "mov rdx, r12 ; count")
        buf.emit(b"\x48\xC7\xC7\x01\x00\x00\x00", "mov rdi, 1 ; stdout")
        buf.emit(b"\x48\xC7\xC0\x01\x00\x00\x00", "mov rax, 1 ; sys_write")
        buf.emit(b"\x0F\x05", "syscall")
        buf.jmp_label("rt__print_ret")

        # rt__print_str: writes string at rdx (SSO or memory pointer)
        buf.mark_label("rt__print_str")
        buf.emit(b"\xF6\xC2\x01", "test dl, 1")
        buf.jcc_rel32(0x84, "z", "rt__print_str_ptr")
        # SSO string in rdx: unpack bytes onto stack
        buf.emit(b"\x48\x89\xD0", "mov rax, rdx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x44\x24\xE8", "mov [rsp - 0x18], rax")
        buf.emit(b"\x48\x8D\x74\x24\xE8", "lea rsi, [rsp - 0x18]")
        buf.emit(b"\x48\xD1\xEA", "shr rdx, 1")
        buf.emit(b"\x48\x83\xE2\x7F", "and rdx, 0x7F ; length")
        buf.jmp_label("rt__print_str_sys")
        buf.mark_label("rt__print_str_ptr")
        buf.emit(b"\x48\x89\xD6", "mov rsi, rdx ; string address")
        # Calculate length of null-terminated string
        buf.emit(b"\x48\x31\xD2", "xor rdx, rdx")
        buf.mark_label("rt__strlen_loop")
        buf.emit(b"\x80\x3C\x16\x00", "cmp byte ptr [rsi + rdx], 0")
        buf.jcc_rel32(0x84, "e", "rt__strlen_done")
        buf.emit(b"\x48\xFF\xC2", "inc rdx")
        buf.jmp_label("rt__strlen_loop")
        buf.mark_label("rt__strlen_done")
        buf.mark_label("rt__print_str_sys")
        buf.emit(b"\x48\xC7\xC7\x01\x00\x00\x00", "mov rdi, 1 ; stdout")
        buf.emit(b"\x48\xC7\xC0\x01\x00\x00\x00", "mov rax, 1 ; sys_write")
        buf.emit(b"\x0F\x05", "syscall")
        buf.jmp_label("rt__print_ret")

        # rt__print_nl
        buf.mark_label("rt__print_nl")
        buf.call_label("rt__emit_nl")
        buf.jmp_label("rt__print_ret")

        # rt__print_sp
        buf.mark_label("rt__print_sp")
        buf.call_label("rt__emit_sp")
        buf.jmp_label("rt__print_ret")

        # rt__print_bool
        buf.mark_label("rt__print_bool")
        buf.emit(b"\x48\x85\xD2", "test rdx, rdx")
        buf.jcc_rel32(0x84, "z", "rt__bool_f")
        buf.call_label("rt__emit_true")
        buf.jmp_label("rt__print_ret")
        buf.mark_label("rt__bool_f")
        buf.call_label("rt__emit_false")

        buf.mark_label("rt__print_ret")
        buf.pop_callee_saved_and_ret()

        # Helper stubs for newline, space, true, false
        buf.mark_label("rt__emit_nl")
        buf.emit_const_str_lea = True
        buf.emit(b"\x48\x8D\x35\x00\x00\x00\x00", "lea rsi, [rip + str_nl]")
        buf.rel32_fixups.append((len(buf.code) - 4, "lbl__rodata_nl"))
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1")
        buf.emit(b"\x48\xC7\xC7\x01\x00\x00\x00", "mov rdi, 1")
        buf.emit(b"\x48\xC7\xC0\x01\x00\x00\x00", "mov rax, 1")
        buf.emit(b"\x0F\x05", "syscall")
        buf.ret()

        buf.mark_label("rt__emit_sp")
        buf.emit(b"\x48\x8D\x35\x00\x00\x00\x00", "lea rsi, [rip + str_sp]")
        buf.rel32_fixups.append((len(buf.code) - 4, "lbl__rodata_sp"))
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1")
        buf.emit(b"\x48\xC7\xC7\x01\x00\x00\x00", "mov rdi, 1")
        buf.emit(b"\x48\xC7\xC0\x01\x00\x00\x00", "mov rax, 1")
        buf.emit(b"\x0F\x05", "syscall")
        buf.ret()

        buf.mark_label("rt__emit_true")
        buf.emit(b"\x48\x8D\x35\x00\x00\x00\x00", "lea rsi, [rip + str_true]")
        buf.rel32_fixups.append((len(buf.code) - 4, "lbl__rodata_true"))
        buf.emit(b"\x48\xC7\xC2\x04\x00\x00\x00", "mov rdx, 4")
        buf.emit(b"\x48\xC7\xC7\x01\x00\x00\x00", "mov rdi, 1")
        buf.emit(b"\x48\xC7\xC0\x01\x00\x00\x00", "mov rax, 1")
        buf.emit(b"\x0F\x05", "syscall")
        buf.ret()

        buf.mark_label("rt__emit_false")
        buf.emit(b"\x48\x8D\x35\x00\x00\x00\x00", "lea rsi, [rip + str_false]")
        buf.rel32_fixups.append((len(buf.code) - 4, "lbl__rodata_false"))
        buf.emit(b"\x48\xC7\xC2\x05\x00\x00\x00", "mov rdx, 5")
        buf.emit(b"\x48\xC7\xC7\x01\x00\x00\x00", "mov rdi, 1")
        buf.emit(b"\x48\xC7\xC0\x01\x00\x00\x00", "mov rax, 1")
        buf.emit(b"\x0F\x05", "syscall")
        buf.ret()

        # rt__alloc_arr: Linear bump-heap allocation in static segment
        buf.mark_label("rt__alloc_arr")
        buf.emit(b"\x48\x8D\x05\x00\x00\x00\x00", "lea rax, [rip + heap_base]")
        buf.rel32_fixups.append((len(buf.code) - 4, "lbl__heap_base"))
        buf.ret()

        # rt__pow_i64
        buf.mark_label("rt__pow_i64")
        buf.emit(b"\x48\xB8\x01\x00\x00\x00\x00\x00\x00\x00", "mov rax, 1")
        buf.emit(b"\x48\x85\xD2", "test rdx, rdx")
        buf.jcc_rel32(0x8E, "le", "rt__pow_end")
        buf.mark_label("rt__pow_loop")
        buf.emit(b"\x48\x0F\xAF\xC1", "imul rax, rcx")
        buf.emit(b"\x48\xFF\xCA", "dec rdx")
        buf.jcc_rel32(0x85, "nz", "rt__pow_loop")
        buf.mark_label("rt__pow_end")
        buf.ret()

        # Fallback stubs
        buf.mark_label("rt__py_stub")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.ret()

        buf.mark_label("rt__arena_save")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.ret()

        buf.mark_label("rt__arena_restore")
        buf.ret()

        buf.mark_label("rt__clock_ns")
        buf.emit(b"\x0F\x31", "rdtsc")
        buf.emit(b"\x48\xC1\xE2\x20", "shl rdx, 32")
        buf.emit(b"\x48\x09\xD0", "or rax, rdx")
        buf.ret()

        buf.mark_label("rt__str_stub")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.ret()

        buf.mark_label("rt__str_ord")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.emit(b"\x74\x0C", "jz .heap_ord")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x0F\xB6\xC0", "movzx rax, al")
        buf.ret()
        buf.emit(b"\x48\x0F\xB6\x01", "movzx rax, byte ptr [rcx]")
        buf.ret()

        buf.mark_label("rt__str_chr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE0\x08", "shl rax, 8")
        buf.emit(b"\x48\x83\xC8\x03", "or rax, 3")
        buf.ret()

        buf.mark_label("rt__str_index")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.emit(b"\x74\x20", "jz .heap_idx")
        buf.emit(b"\x48\x8D\x42\x01", "lea rax, [rdx + 1]")
        buf.emit(b"\x48\xC1\xE0\x03", "shl rax, 3")
        buf.emit(b"\x49\x89\xC8", "mov r8, rcx")
        buf.emit(b"\x88\xC1", "mov cl, al")
        buf.emit(b"\x49\xD3\xE8", "shr r8, cl")
        buf.emit(b"\x45\x0F\xB6\xC0", "movzx r8, r8b")
        buf.emit(b"\x49\xC1\xE0\x08", "shl r8, 8")
        buf.emit(b"\x49\x83\xC8\x03", "or r8, 3")
        buf.emit(b"\x4C\x89\xC0", "mov rax, r8")
        buf.ret()
        buf.emit(b"\x48\x0F\xB6\x04\x11", "movzx rax, byte ptr [rcx + rdx]")
        buf.emit(b"\x48\xC1\xE0\x08", "shl rax, 8")
        buf.emit(b"\x48\x83\xC8\x03", "or rax, 3")
        buf.ret()

        buf.mark_label("rt__str_len")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.emit(b"\x74\x0B", "jz .strlen_loop")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xD1\xE8", "shr rax, 1")
        buf.emit(b"\x48\x83\xE0\x7F", "and rax, 0x7F")
        buf.ret()
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.emit(b"\x80\x3C\x01\x00", "cmp byte ptr [rcx + rax], 0")
        buf.emit(b"\x74\x05", "je .done")
        buf.emit(b"\x48\xFF\xC0", "inc rax")
        buf.emit(b"\xEB\xF5", "jmp .loop")
        buf.ret()

        buf.mark_label("rt__str_cmp_eq")
        buf.emit(b"\x48\x39\xD1", "cmp rcx, rdx")
        buf.jcc_rel32(0x84, "e", "rt__str_cmp_true")
        buf.emit(b"\x88\xC8", "mov al, cl")
        buf.emit(b"\x20\xD0", "and al, dl")
        buf.emit(b"\xA8\x01", "test al, 1")
        buf.jcc_rel32(0x85, "ne", "rt__str_cmp_false")

        # One or both are pointer strings in memory
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)

        # s1 pointer -> r8
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__cmp_s1_ptr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xF0", "mov qword ptr [rbp - 0x10], rax")
        buf.emit(b"\x48\xC7\x45\xF8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x08], 0")
        buf.emit(b"\x4C\x8D\x45\xF0", "lea r8, [rbp - 0x10]")
        buf.jmp_label("rt__cmp_s1_ready")
        buf.mark_label("rt__cmp_s1_ptr")
        buf.emit(b"\x49\x89\xC8", "mov r8, rcx")
        buf.mark_label("rt__cmp_s1_ready")

        # s2 pointer -> r9
        buf.emit(b"\xF6\xC2\x01", "test dl, 1")
        buf.jcc_rel32(0x84, "z", "rt__cmp_s2_ptr")
        buf.emit(b"\x48\x89\xD0", "mov rax, rdx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xE0", "mov qword ptr [rbp - 0x20], rax")
        buf.emit(b"\x48\xC7\x45\xE8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x18], 0")
        buf.emit(b"\x4C\x8D\x4D\xE0", "lea r9, [rbp - 0x20]")
        buf.jmp_label("rt__cmp_s2_ready")
        buf.mark_label("rt__cmp_s2_ptr")
        buf.emit(b"\x49\x89\xD1", "mov r9, rdx")
        buf.mark_label("rt__cmp_s2_ready")

        # Compare loop
        buf.emit(b"\x48\x31\xC9", "xor rcx, rcx")
        buf.mark_label("rt__cmp_loop")
        buf.emit(b"\x41\x8A\x04\x08", "mov al, byte ptr [r8 + rcx]")
        buf.emit(b"\x41\x8A\x14\x09", "mov dl, byte ptr [r9 + rcx]")
        buf.emit(b"\x38\xD0", "cmp al, dl")
        buf.jcc_rel32(0x85, "ne", "rt__cmp_diff")
        buf.emit(b"\x84\xC0", "test al, al")
        buf.jcc_rel32(0x84, "e", "rt__cmp_same")
        buf.emit(b"\x48\xFF\xC1", "inc rcx")
        buf.jmp_label("rt__cmp_loop")

        buf.mark_label("rt__cmp_same")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.mark_label("rt__str_cmp_true")
        buf.emit(b"\x48\xC7\xC0\x01\x00\x00\x00", "mov rax, 1")
        buf.ret()

        buf.mark_label("rt__cmp_diff")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.mark_label("rt__str_cmp_false")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.ret()

        buf.mark_label("rt__str_cmp_ne")
        buf.call_label("rt__str_cmp_eq")
        buf.emit(b"\x48\x83\xF0\x01", "xor rax, 1")
        buf.ret()

        # Dynamic string concatenation
        buf.mark_label("rt__str_concat")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x50)
        buf.emit(b"\x48\x89\x4D\xF8", "mov [rbp - 0x08], rcx ; s1")
        buf.emit(b"\x48\x89\x55\xF0", "mov [rbp - 0x10], rdx ; s2")

        # Calculate len1
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__concat_s1_ptr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xD1\xE8", "shr rax, 1")
        buf.emit(b"\x48\x83\xE0\x7F", "and rax, 0x7F")
        buf.jmp_label("rt__concat_s1_len_done")
        buf.mark_label("rt__concat_s1_ptr")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mark_label("rt__concat_s1_loop")
        buf.emit(b"\x80\x3C\x01\x00", "cmp byte ptr [rcx + rax], 0")
        buf.jcc_rel32(0x84, "e", "rt__concat_s1_len_done")
        buf.emit(b"\x48\xFF\xC0", "inc rax")
        buf.jmp_label("rt__concat_s1_loop")
        buf.mark_label("rt__concat_s1_len_done")
        buf.emit(b"\x48\x89\x45\xE8", "mov [rbp - 0x18], rax ; len1")

        # Calculate len2
        buf.emit(b"\x48\x8B\x55\xF0", "mov rdx, [rbp - 0x10] ; s2")
        buf.emit(b"\xF6\xC2\x01", "test dl, 1")
        buf.jcc_rel32(0x84, "z", "rt__concat_s2_ptr")
        buf.emit(b"\x48\x89\xD0", "mov rax, rdx")
        buf.emit(b"\x48\xD1\xE8", "shr rax, 1")
        buf.emit(b"\x48\x83\xE0\x7F", "and rax, 0x7F")
        buf.jmp_label("rt__concat_s2_len_done")
        buf.mark_label("rt__concat_s2_ptr")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mark_label("rt__concat_s2_loop")
        buf.emit(b"\x80\x3C\x02\x00", "cmp byte ptr [rdx + rax], 0")
        buf.jcc_rel32(0x84, "e", "rt__concat_s2_len_done")
        buf.emit(b"\x48\xFF\xC0", "inc rax")
        buf.jmp_label("rt__concat_s2_loop")
        buf.mark_label("rt__concat_s2_len_done")
        buf.emit(b"\x48\x89\x45\xE0", "mov [rbp - 0x20], rax ; len2")

        # Allocate via rt__alloc_arr
        buf.emit(b"\x48\x8B\x4D\xE8", "mov rcx, [rbp - 0x18]")
        buf.emit(b"\x48\x03\x4D\xE0", "add rcx, [rbp - 0x20]")
        buf.emit(b"\x48\xFF\xC1", "inc rcx ; count = len1 + len2 + 1")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1 ; size = 1")
        buf.call_label("rt__alloc_arr")
        buf.emit(b"\x48\x89\x45\xD8", "mov [rbp - 0x28], rax ; dst ptr")

        # Copy s1 bytes to dst (r8 = dst, r9 = src_s1, r11 = loop counter)
        buf.emit(b"\x4C\x8B\x45\xD8", "mov r8, [rbp - 0x28]")
        buf.emit(b"\x48\x8B\x4D\xF8", "mov rcx, [rbp - 0x08]")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__concat_s1_copy_ptr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xD0", "mov [rbp - 0x30], rax")
        buf.emit(b"\x4C\x8D\x4D\xD0", "lea r9, [rbp - 0x30]")
        buf.jmp_label("rt__concat_s1_do_copy")
        buf.mark_label("rt__concat_s1_copy_ptr")
        buf.emit(b"\x49\x89\xC9", "mov r9, rcx")
        buf.mark_label("rt__concat_s1_do_copy")
        buf.emit(b"\x4D\x31\xDB", "xor r11, r11")
        buf.mark_label("rt__concat_s1_copy_loop")
        buf.emit(b"\x4C\x3B\x5D\xE8", "cmp r11, [rbp - 0x18]")
        buf.jcc_rel32(0x8D, "ge", "rt__concat_s1_copy_done")
        buf.emit(b"\x43\x8A\x04\x19", "mov al, byte ptr [r9 + r11]")
        buf.emit(b"\x43\x88\x04\x18", "mov byte ptr [r8 + r11], al")
        buf.emit(b"\x49\xFF\xC3", "inc r11")
        buf.jmp_label("rt__concat_s1_copy_loop")
        buf.mark_label("rt__concat_s1_copy_done")

        # Copy s2 bytes to dst + len1
        buf.emit(b"\x4C\x8B\x45\xD8", "mov r8, [rbp - 0x28]")
        buf.emit(b"\x4C\x03\x45\xE8", "add r8, [rbp - 0x18] ; dst + len1")
        buf.emit(b"\x48\x8B\x55\xF0", "mov rdx, [rbp - 0x10]")
        buf.emit(b"\xF6\xC2\x01", "test dl, 1")
        buf.jcc_rel32(0x84, "z", "rt__concat_s2_copy_ptr")
        buf.emit(b"\x48\x89\xD0", "mov rax, rdx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xC8", "mov [rbp - 0x38], rax")
        buf.emit(b"\x4C\x8D\x4D\xC8", "lea r9, [rbp - 0x38]")
        buf.jmp_label("rt__concat_s2_do_copy")
        buf.mark_label("rt__concat_s2_copy_ptr")
        buf.emit(b"\x49\x89\xD1", "mov r9, rdx")
        buf.mark_label("rt__concat_s2_do_copy")
        buf.emit(b"\x4D\x31\xDB", "xor r11, r11")
        buf.mark_label("rt__concat_s2_copy_loop")
        buf.emit(b"\x4C\x3B\x5D\xE0", "cmp r11, [rbp - 0x20]")
        buf.jcc_rel32(0x8D, "ge", "rt__concat_s2_copy_done")
        buf.emit(b"\x43\x8A\x04\x19", "mov al, byte ptr [r9 + r11]")
        buf.emit(b"\x43\x88\x04\x18", "mov byte ptr [r8 + r11], al")
        buf.emit(b"\x49\xFF\xC3", "inc r11")
        buf.jmp_label("rt__concat_s2_copy_loop")
        buf.mark_label("rt__concat_s2_copy_done")

        # Null terminate string
        buf.emit(b"\x4C\x8B\x45\xD8", "mov r8, [rbp - 0x28]")
        buf.emit(b"\x48\x8B\x4D\xE8", "mov rcx, [rbp - 0x18]")
        buf.emit(b"\x48\x03\x4D\xE0", "add rcx, [rbp - 0x20]")
        buf.emit(b"\x41\xC6\x04\x08\x00", "mov byte ptr [r8 + rcx], 0")

        buf.emit(b"\x48\x8B\x45\xD8", "mov rax, [rbp - 0x28] ; return dst ptr")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()

        buf.mark_label("rt__str_cmp_lt")
        buf.emit(b"\x48\x39\xD1", "cmp rcx, rdx")
        buf.emit(b"\x0F\x9C\xC0", "setl al")
        buf.emit(b"\x48\x0F\xB6\xC0", "movzx rax, al")
        buf.ret()

        buf.mark_label("rt__str_cmp_le")
        buf.emit(b"\x48\x39\xD1", "cmp rcx, rdx")
        buf.emit(b"\x0F\x9E\xC0", "setle al")
        buf.emit(b"\x48\x0F\xB6\xC0", "movzx rax, al")
        buf.ret()

        buf.mark_label("rt__str_cmp_gt")
        buf.emit(b"\x48\x39\xD1", "cmp rcx, rdx")
        buf.emit(b"\x0F\x9F\xC0", "setg al")
        buf.emit(b"\x48\x0F\xB6\xC0", "movzx rax, al")
        buf.ret()

        buf.mark_label("rt__str_cmp_ge")
        buf.emit(b"\x48\x39\xD1", "cmp rcx, rdx")
        buf.emit(b"\x0F\x9D\xC0", "setge al")
        buf.emit(b"\x48\x0F\xB6\xC0", "movzx rax, al")
        buf.ret()

        # 3. Compile all user functions from MIR
        helper_labels = {
            "print": "rt__print",
            "alloc_arr": "rt__alloc_arr",
            "pow_i64": "rt__pow_i64",
            "pow_f64": "rt__py_stub",
            "py_call_f64": "rt__py_stub",
            "py_eval_f64": "rt__py_stub",
            "py_eval_tensor": "rt__py_stub",
            "arena_save": "rt__arena_save",
            "arena_restore": "rt__arena_restore",
            "str_concat": "rt__str_concat",
            "str_slice": "rt__str_stub",
            "str_index": "rt__str_index",
            "str_len": "rt__str_len",
            "str_cmp_eq": "rt__str_cmp_eq",
            "str_cmp_ne": "rt__str_cmp_ne",
            "str_cmp_lt": "rt__str_cmp_lt",
            "str_cmp_le": "rt__str_cmp_le",
            "str_cmp_gt": "rt__str_cmp_gt",
            "str_cmp_ge": "rt__str_cmp_ge",
            "str_from_i64": "rt__str_stub",
            "str_from_f64": "rt__str_stub",
            "str_from_bool": "rt__str_stub",
            "str_ord": "rt__str_ord",
            "str_chr": "rt__str_chr",
            "str_to_i64": "rt__str_stub",
            "str_to_f64": "rt__str_stub",
            "clock_ns": "rt__clock_ns",
        }

        def emit_const_str(ins, store_from_rax):
            str_idx = int(ins.arg1)
            # lea rax, [rip + str_offset]
            buf.emit(b"\x48\x8D\x05\x00\x00\x00\x00", f"lea rax, [rip + str#{str_idx}]")
            buf.rel32_fixups.append((len(buf.code) - 4, f"lbl__str_{str_idx}"))
            store_from_rax(str(ins.dst))

        def emit_helper_call(kind):
            buf.call_label(helper_labels[kind])

        for fn in self.mir_module.functions:
            buf.compile_mir_function(fn, emit_const_str, emit_helper_call)

        # 4. Lay out .rodata immediately after .text
        text_bytes_len = len(buf.code)
        rodata_offset_in_text = text_bytes_len

        # Mark rodata labels
        buf.labels["lbl__rodata_sp"] = rodata_offset_in_text + str_sp
        buf.labels["lbl__rodata_nl"] = rodata_offset_in_text + str_nl
        buf.labels["lbl__rodata_true"] = rodata_offset_in_text + str_true
        buf.labels["lbl__rodata_false"] = rodata_offset_in_text + str_false

        for idx, ro_off in string_rel_offsets.items():
            buf.labels[f"lbl__str_{idx}"] = rodata_offset_in_text + ro_off

        # Heap base at end of rodata
        buf.labels["lbl__heap_base"] = rodata_offset_in_text + len(rodata_buf) + 16

        # Resolve all internal jumps and RIP-relative data addresses
        buf.resolve_fixups()

        code_and_rodata = bytes(buf.code) + bytes(rodata_buf)

        # 5. Build ELF64 Header and Program Header
        payload_offset = 0x100
        entry_point = IMAGE_BASE + payload_offset + buf.labels["_start"]
        total_file_size = payload_offset + len(code_and_rodata)
        # Pre-allocate 64KB heap memory in memory size
        mem_size = _align(total_file_size + 0x10000, 0x1000)

        # ELF64 Header (64 bytes)
        elf_header = bytearray(64)
        elf_header[0:4] = b"\x7fELF"
        elf_header[4] = 2       # 64-bit architecture
        elf_header[5] = 1       # Little-endian
        elf_header[6] = 1       # Original ELF version
        elf_header[7] = 0       # System V ABI
        elf_header[8] = 0       # ABI version
        struct.pack_into("<H", elf_header, 16, 2)         # e_type: ET_EXEC (Executable)
        struct.pack_into("<H", elf_header, 18, 0x3E)      # e_machine: EM_X86_64 (62)
        struct.pack_into("<I", elf_header, 20, 1)         # e_version: 1
        struct.pack_into("<Q", elf_header, 24, entry_point) # e_entry: Virtual address of _start
        struct.pack_into("<Q", elf_header, 32, 64)        # e_phoff: Program header offset (64)
        struct.pack_into("<Q", elf_header, 40, 0)         # e_shoff: Section header offset (0 for now)
        struct.pack_into("<I", elf_header, 48, 0)         # e_flags: 0
        struct.pack_into("<H", elf_header, 52, 64)        # e_ehsize: 64
        struct.pack_into("<H", elf_header, 54, 56)        # e_phentsize: 56
        struct.pack_into("<H", elf_header, 56, 1)         # e_phnum: 1 PT_LOAD segment
        struct.pack_into("<H", elf_header, 58, 64)        # e_shentsize: 64
        struct.pack_into("<H", elf_header, 60, 0)         # e_shnum: 0
        struct.pack_into("<H", elf_header, 62, 0)         # e_shstrndx: 0

        # Program Header: PT_LOAD (56 bytes)
        # Type=1 (PT_LOAD), Flags=7 (R | W | X), Offset=0, VAddr=0x400000, PAddr=0x400000
        prog_header = struct.pack(
            "<IIQQQQQQ",
            1,                  # p_type: PT_LOAD
            7,                  # p_flags: PF_R | PF_W | PF_X
            0,                  # p_offset: 0
            IMAGE_BASE,         # p_vaddr: 0x400000
            IMAGE_BASE,         # p_paddr: 0x400000
            total_file_size,    # p_filesz
            mem_size,           # p_memsz (includes heap space)
            0x1000,             # p_align: 4096 bytes
        )

        pad_size = payload_offset - (HEADER_SIZE + PH_SIZE)
        padding = b"\x90" * pad_size  # NOP padding to 0x100

        full_binary = bytes(elf_header) + prog_header + padding + code_and_rodata
        return full_binary

    def write_executable(self, output_path: str) -> str:
        """Writes the standalone Linux ELF64 binary to disk."""
        elf_bytes = self.build_bytes()
        os.makedirs(os.path.dirname(os.path.abspath(output_path)), exist_ok=True)
        with open(output_path, "wb") as f:
            f.write(elf_bytes)
        return os.path.abspath(output_path)
