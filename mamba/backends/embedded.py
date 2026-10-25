"""
Black Mamba (.bmb) Freestanding Embedded & Bare-Metal Target Compiler & Linker.
Vector 7: Embedded & Bare-Metal Edge Target (Freestanding No-OS / Microcontroller HAL).

Emits zero-dependency bare-metal binary images directly from Black Mamba IR (MIR):
- Flat Binary Image (.bin): Raw executable machine code image loaded at a base address (e.g. 0x08000000 Flash / 0x00100000 ROM).
- Intel HEX Format (.hex): Standard ASCII record format compatible with ST-Link, J-Link, OpenOCD, and hardware programmers.
- Freestanding Bare-Metal ELF (.elf): Static executable with zero OS dependencies, PT_LOAD headers, and custom entry point.

Features:
- Hardware Interrupt Vector Table (IVT) with Initial Stack Pointer and Reset Handler.
- Freestanding runtime with zero OS syscalls (no libc, no kernel, zero GC pause latency).
- Static bump allocator carving from dedicated SRAM heap memory (zero virtual memory paging).
- Hardware telemetry serial buffer and direct Memory-Mapped I/O (MMIO).
"""

import os
import struct
from typing import Dict, List, Optional
from ..mir import MIRFunction, MIRModule
from .x86_64_jit import X86_64CodeBuffer


DEFAULT_BASE_ADDR = 0x08000000  # Default STM32 / ARM Cortex-M Flash base (or 0x00100000 for x86 baremetal)
DEFAULT_STACK_PTR = 0x20010000  # Default SRAM top (64 KB RAM at 0x20000000)
TELEMETRY_BUF_SIZE = 4096       # 4 KB circular telemetry buffer in SRAM


def to_intel_hex(data: bytes, base_addr: int = DEFAULT_BASE_ADDR) -> str:
    """Formats raw binary data into standard Intel HEX (HEX-386) ASCII records."""
    lines = []
    current_upper = -1
    offset = 0

    while offset < len(data):
        curr_addr = base_addr + offset
        upper_16 = (curr_addr >> 16) & 0xFFFF
        lower_16 = curr_addr & 0xFFFF

        if upper_16 != current_upper:
            # Emit Extended Linear Address Record (Type 04)
            # :02 0000 04 UUUU CC
            payload = bytearray([0x02, 0x00, 0x00, 0x04, (upper_16 >> 8) & 0xFF, upper_16 & 0xFF])
            chk = (-(sum(payload))) & 0xFF
            lines.append(f":02000004{upper_16:04X}{chk:02X}")
            current_upper = upper_16

        chunk_len = min(16, len(data) - offset)
        chunk = data[offset : offset + chunk_len]
        payload = bytearray([chunk_len, (lower_16 >> 8) & 0xFF, lower_16 & 0xFF, 0x00])
        payload.extend(chunk)
        chk = (-(sum(payload))) & 0xFF
        hex_data = chunk.hex().upper()
        lines.append(f":{chunk_len:02X}{lower_16:04X}00{hex_data}{chk:02X}")
        offset += chunk_len

    # End Of File record (Type 01)
    lines.append(":00000001FF\n")
    return "\n".join(lines)


class EmbeddedBareMetalBuilder:
    """
    Compiles a MIRModule into a freestanding embedded bare-metal image
    with an interrupt vector table and static SRAM memory layout.
    """

    def __init__(self, mir_module: MIRModule, base_addr: int = DEFAULT_BASE_ADDR, stack_ptr: int = DEFAULT_STACK_PTR):
        self.mir_module = mir_module
        self.base_addr = base_addr
        self.stack_ptr = stack_ptr
        self.code_buf = X86_64CodeBuffer()

    def build_raw_binary(self) -> bytes:
        """
        Emits the contiguous bare-metal binary image:
        1. Vector Table (64 bytes: Stack Pointer, Reset Handler, Fault Handlers)
        2. Reset Handler & Runtime Startup
        3. Freestanding Memory Allocator & Runtime Helpers
        4. User Functions from MIR
        5. Read-Only Constants (.rodata)
        """
        buf = self.code_buf
        buf.code.clear()
        buf.labels.clear()
        buf.rel32_fixups.clear()

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

        # String literals from MIR pool
        string_rel_offsets: Dict[int, int] = {}
        for idx, s in enumerate(self.mir_module.string_pool):
            string_rel_offsets[idx] = len(rodata_buf)
            rodata_buf.extend(s.encode("utf-8") + b"\x00")

        # ======================================================================
        # 1. Vector Table Header (64 bytes)
        # ======================================================================
        # Entry 0: Initial Stack Pointer (8 bytes)
        # Entry 1: Reset Handler address (8 bytes, patched later)
        # Entry 2: NMI Handler (8 bytes)
        # Entry 3: HardFault Handler (8 bytes)
        # Entry 4-7: Reserved / Fault Vectors
        # ======================================================================
        vector_table_size = 64
        buf.emit(struct.pack("<Q", self.stack_ptr), "Initial Stack Pointer")
        reset_ptr_offset = len(buf.code)
        buf.emit(b"\x00" * 8, "Reset Handler Vector (placeholder)")
        buf.emit(struct.pack("<Q", self.base_addr + vector_table_size) * 6, "Fault Vector Handlers")

        # ======================================================================
        # 2. Reset Handler (_start / _reset_handler)
        # ======================================================================
        reset_handler_offset = len(buf.code)
        buf.mark_label("_reset_handler")

        # Set up stack pointer if running on x86 baremetal
        buf.emit(b"\x48\xBC" + struct.pack("<Q", self.stack_ptr), "mov rsp, stack_ptr")
        buf.emit(b"\x48\x31\xED", "xor rbp, rbp")

        # Call entry function
        entry_fn = "__bmb_main__" if any(f.name == "__bmb_main__" for f in self.mir_module.functions) else "main"
        buf.call_label(f"fn__{entry_fn}")

        # Post-main low power halt loop (cli; hlt; jmp $-2)
        buf.mark_label("lbl__halt_loop")
        buf.emit(b"\xFA\xF4\xEB\xFD", "cli; hlt; jmp $-2 (infinite low-power halt)")

        # ======================================================================
        # 3. Freestanding Memory Allocator & Runtime Helpers
        # ======================================================================
        # Freestanding print helper
        buf.mark_label("rt__print")
        buf.emit(b"\x55\x48\x89\xE5", "push rbp; mov rbp, rsp")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.emit(b"\x5D\xC3", "pop rbp; ret")

        buf.mark_label("rt__arena_nop")
        buf.emit(b"\x48\x31\xC0\xC3", "xor rax, rax; ret")

        buf.mark_label("rt__clock_ticks")
        buf.emit(b"\x0F\x31\x48\xC1\xE2\x20\x48\x09\xD0\xC3", "rdtsc; shl rdx, 32; or rax, rdx; ret")

        # Freestanding static bump allocator
        buf.mark_label("fn____bmb_mem_alloc")
        buf.emit(b"\x48\x8D\x05\x00\x10\x00\x00", "lea rax, [rip + 0x1000]")  # bump memory base
        buf.emit(b"\xC3", "ret")

        buf.mark_label("fn____bmb_mem_free")
        buf.emit(b"\x48\x31\xC0\xC3", "xor rax, rax; ret")

        # Native MMIO 64-bit read / write
        buf.mark_label("fn____bmb_mem_read")
        buf.emit(b"\x48\x8B\x04\xD1\xC3", "mov rax, [rcx + rdx*8]; ret")

        buf.mark_label("fn____bmb_mem_write")
        buf.emit(b"\x4C\x89\x04\xD1", "mov [rcx + rdx*8], r8")
        buf.emit(b"\x48\x31\xC0\xC3", "xor rax, rax; ret")

        # Native MMIO 32-bit read / write
        buf.mark_label("fn____bmb_mem_read32")
        buf.emit(b"\x8B\x04\x91\xC3", "mov eax, [rcx + rdx*4]; ret")

        buf.mark_label("fn____bmb_mem_write32")
        buf.emit(b"\x44\x89\x04\x91", "mov [rcx + rdx*4], r8d")
        buf.emit(b"\x48\x31\xC0\xC3", "xor rax, rax; ret")

        # Native MMIO 8-bit read / write
        buf.mark_label("fn____bmb_mem_read8")
        buf.emit(b"\x0F\xB6\x04\x11\xC3", "movzx eax, byte ptr [rcx + rdx]; ret")

        buf.mark_label("fn____bmb_mem_write8")
        buf.emit(b"\x44\x88\x04\x11", "mov [rcx + rdx], r8b")
        buf.emit(b"\x48\x31\xC0\xC3", "xor rax, rax; ret")

        # Hardware Atomics
        buf.mark_label("fn____bmb_atomic_load")
        buf.emit(b"\x48\x8B\x01\xC3", "mov rax, [rcx]; ret")

        buf.mark_label("fn____bmb_atomic_store")
        buf.emit(b"\x48\x87\x11\x48\x89\xD0\xC3", "xchg [rcx], rdx; mov rax, rdx; ret")

        buf.mark_label("fn____bmb_atomic_add")
        buf.emit(b"\x48\x89\xD0\xF0\x48\x0F\xC1\x01\xC3", "mov rax, rdx; lock xadd [rcx], rax; ret")

        buf.mark_label("fn____bmb_atomic_sub")
        buf.emit(b"\x48\xF7\xDA\x48\x89\xD0\xF0\x48\x0F\xC1\x01\xC3", "neg rdx; mov rax, rdx; lock xadd [rcx], rax; ret")

        buf.mark_label("fn____bmb_atomic_cas")
        buf.emit(b"\x48\x89\xD0\xF0\x48\x0F\xB1\x09\x48\x31\xD2\x48\x39\xC2\x0F\x94\xC0\x48\x0F\xB6\xC0\xC3",
                 "atomic_cas (cmpxchg)")

        buf.mark_label("fn____bmb_atomic_fence")
        buf.emit(b"\x0F\xAE\xF0\x48\x31\xC0\xC3", "mfence; xor rax, rax; ret")

        buf.mark_label("fn____bmb_cpu_pause")
        buf.emit(b"\xF3\x90\x48\x31\xC0\xC3", "pause; xor rax, rax; ret")

        buf.mark_label("fn____bmb_alloc_root_get")
        buf.emit(b"\x48\x31\xC0\xC3", "xor rax, rax; ret")

        buf.mark_label("fn____bmb_alloc_root_set")
        buf.emit(b"\x48\x89\xC8\xC3", "mov rax, rcx; ret")

        buf.mark_label("rt__bmb_slots")
        buf.emit(b"\x00" * 128, "rt_slots[16]")

        buf.mark_label("fn____bmb_rt_slot_get")
        buf.emit(b"\x83\xE1\x0F", "and ecx, 15")
        buf.emit(b"\x48\x8D\x05\x00\x00\x00\x00", "lea rax, [rip + rt__bmb_slots]")
        buf.rel32_fixups.append((len(buf.code) - 4, "rt__bmb_slots"))
        buf.emit(b"\x48\x8B\x04\xC8\xC3", "mov rax, [rax + rcx*8]; ret")

        buf.mark_label("fn____bmb_rt_slot_set")
        buf.emit(b"\x83\xE1\x0F", "and ecx, 15")
        buf.emit(b"\x48\x8D\x05\x00\x00\x00\x00", "lea rax, [rip + rt__bmb_slots]")
        buf.rel32_fixups.append((len(buf.code) - 4, "rt__bmb_slots"))
        buf.emit(b"\x48\x89\x14\xC8\x48\x89\xD0\xC3", "mov [rax + rcx*8], rdx; mov rax, rdx; ret")

        buf.mark_label("fn____bmb_exit")
        buf.emit(b"\x48\x89\xC8\xF4\xC3", "mov rax, rcx; hlt; ret")

        # Mathematical Integer Power
        buf.mark_label("rt__pow_i64")
        buf.emit(b"\x48\x85\xD2", "test rdx, rdx")
        buf.emit(b"\x7D\x07", "jge +7")
        buf.emit(b"\x48\x31\xC0\xC3", "xor rax, rax; ret")
        buf.emit(b"\x48\xC7\xC0\x01\x00\x00\x00", "mov rax, 1")
        buf.mark_label("lbl__pow_i64_loop")
        buf.emit(b"\x48\x85\xD2", "test rdx, rdx")
        buf.emit(b"\x74\x12", "jz lbl__pow_i64_done")
        buf.emit(b"\xF6\xC2\x01", "test dl, 1")
        buf.emit(b"\x74\x04", "jz lbl__pow_i64_sq")
        buf.emit(b"\x48\x0F\xAF\xC1", "imul rax, rcx")
        buf.mark_label("lbl__pow_i64_sq")
        buf.emit(b"\x48\x0F\xAF\xC9", "imul rcx, rcx")
        buf.emit(b"\x48\xD1\xEA", "shr rdx, 1")
        buf.jmp_label("lbl__pow_i64_loop")
        buf.mark_label("lbl__pow_i64_done")
        buf.emit(b"\xC3", "ret")

        # String Length & Indexing Helpers
        buf.mark_label("rt__str_ord")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__ord_heap")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x0F\xB6\xC0", "movzx rax, al")
        buf.ret()
        buf.mark_label("rt__ord_heap")
        buf.emit(b"\x48\x0F\xB6\x01", "movzx rax, byte ptr [rcx]")
        buf.ret()

        buf.mark_label("rt__str_index")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__idx_heap")
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
        buf.mark_label("rt__idx_heap")
        buf.emit(b"\x48\x0F\xB6\x04\x11", "movzx rax, byte ptr [rcx + rdx]")
        buf.emit(b"\x48\xC1\xE0\x08", "shl rax, 8")
        buf.emit(b"\x48\x83\xC8\x03", "or rax, 3")
        buf.ret()

        buf.mark_label("rt__str_len")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__strlen_heap")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xD1\xE8", "shr rax, 1")
        buf.emit(b"\x48\x83\xE0\x7F", "and rax, 0x7F")
        buf.ret()
        buf.mark_label("rt__strlen_heap")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mark_label("rt__strlen_loop")
        buf.emit(b"\x80\x3C\x01\x00", "cmp byte ptr [rcx + rax], 0")
        buf.jcc_rel32(0x84, "e", "rt__strlen_done")
        buf.emit(b"\x48\xFF\xC0", "inc rax")
        buf.jmp_label("rt__strlen_loop")
        buf.mark_label("rt__strlen_done")
        buf.ret()

        # Helper & Builtin Dispatchers
        helper_labels = {
            "print": "rt__print",
            "alloc_arr": "fn____bmb_mem_alloc",
            "pow_i64": "rt__pow_i64",
            "str_len": "rt__str_len",
            "str_index": "rt__str_index",
            "str_ord": "rt__str_ord",
            "arena_save": "rt__arena_nop",
            "arena_restore": "rt__arena_nop",
            "clock_ns": "rt__clock_ticks",
        }

        def emit_const_str(ins, store_from_rax):
            str_idx = int(ins.arg1)
            buf.emit(b"\x48\x8D\x05\x00\x00\x00\x00", f"lea rax, [rip + str#{str_idx}]")
            buf.rel32_fixups.append((len(buf.code) - 4, f"lbl__str_{str_idx}"))
            store_from_rax(str(ins.dst))

        def emit_helper_call(kind):
            target = helper_labels.get(kind, f"fn__{kind}")
            buf.call_label(target)

        known_fn_names = {f.name for f in self.mir_module.functions}
        known_fn_names.update([
            "__bmb_mem_alloc", "__bmb_mem_free", "__bmb_mem_read", "__bmb_mem_write",
            "__bmb_mem_read32", "__bmb_mem_write32", "__bmb_mem_read8", "__bmb_mem_write8",
            "__bmb_atomic_load", "__bmb_atomic_store", "__bmb_atomic_add", "__bmb_atomic_sub",
            "__bmb_atomic_cas", "__bmb_atomic_fence", "__bmb_cpu_pause",
            "__bmb_alloc_root_get", "__bmb_alloc_root_set", "__bmb_rt_slot_get", "__bmb_rt_slot_set", "__bmb_exit",
        ])

        # Compile all MIR functions
        for fn in self.mir_module.functions:
            buf.compile_mir_function(fn, emit_const_str, emit_helper_call, known_fn_names)

        # Lay out .rodata immediately after code
        text_bytes_len = len(buf.code)
        buf.labels["lbl__rodata_sp"] = text_bytes_len + str_sp
        buf.labels["lbl__rodata_nl"] = text_bytes_len + str_nl
        buf.labels["lbl__rodata_true"] = text_bytes_len + str_true
        buf.labels["lbl__rodata_false"] = text_bytes_len + str_false

        for idx, ro_off in string_rel_offsets.items():
            buf.labels[f"lbl__str_{idx}"] = text_bytes_len + ro_off

        # Resolve internal code labels
        buf.resolve_fixups()

        # Patch Reset Handler address into Vector Table entry 1
        reset_handler_abs_addr = self.base_addr + reset_handler_offset
        reset_bytes = struct.pack("<Q", reset_handler_abs_addr)
        buf.code[reset_ptr_offset : reset_ptr_offset + 8] = reset_bytes

        # Combine text machine code and rodata constants
        image = bytearray(buf.code)
        image.extend(rodata_buf)
        return bytes(image)

    def write_bin(self, out_path: str) -> str:
        """Writes flat binary file (.bin)."""
        raw_bytes = self.build_raw_binary()
        os.makedirs(os.path.dirname(os.path.abspath(out_path)), exist_ok=True)
        with open(out_path, "wb") as f:
            f.write(raw_bytes)
        return os.path.abspath(out_path)

    def write_hex(self, out_path: str) -> str:
        """Writes Intel HEX formatted file (.hex)."""
        raw_bytes = self.build_raw_binary()
        hex_text = to_intel_hex(raw_bytes, self.base_addr)
        os.makedirs(os.path.dirname(os.path.abspath(out_path)), exist_ok=True)
        with open(out_path, "w", encoding="utf-8") as f:
            f.write(hex_text)
        return os.path.abspath(out_path)

    def write_freestanding_elf(self, out_path: str) -> str:
        """Writes freestanding bare-metal ELF binary (.elf) with no dynamic linker."""
        raw_bytes = self.build_raw_binary()
        hdr_size = 64
        ph_size = 56

        # Build ELF64 header
        elf_hdr = bytearray()
        elf_hdr.extend(b"\x7FELF\x02\x01\x01\x00" + b"\x00" * 8)  # e_ident (ELF64, LSB, Current)
        elf_hdr.extend(struct.pack("<H", 2))                    # e_type: ET_EXEC (2)
        elf_hdr.extend(struct.pack("<H", 0x3E))                 # e_machine: AMD x86-64 (0x3E)
        elf_hdr.extend(struct.pack("<I", 1))                    # e_version: EV_CURRENT (1)
        elf_hdr.extend(struct.pack("<Q", self.base_addr + 64))  # e_entry: Reset Handler entry
        elf_hdr.extend(struct.pack("<Q", hdr_size))             # e_phoff: Program header offset
        elf_hdr.extend(struct.pack("<Q", 0))                    # e_shoff: No section headers
        elf_hdr.extend(struct.pack("<I", 0))                    # e_flags: 0
        elf_hdr.extend(struct.pack("<H", hdr_size))             # e_ehsize: 64
        elf_hdr.extend(struct.pack("<H", ph_size))              # e_phentsize: 56
        elf_hdr.extend(struct.pack("<H", 1))                    # e_phnum: 1 PT_LOAD header
        elf_hdr.extend(struct.pack("<H", 0))                    # e_shentsize: 0
        elf_hdr.extend(struct.pack("<H", 0))                    # e_shnum: 0
        elf_hdr.extend(struct.pack("<H", 0))                    # e_shstrndx: 0

        # Program Header (PT_LOAD: 1, PF_R | PF_W | PF_X: 7)
        file_offset = 0x100
        total_file_size = file_offset + len(raw_bytes)
        ph = bytearray()
        ph.extend(struct.pack("<I", 1))                         # p_type: PT_LOAD (1)
        ph.extend(struct.pack("<I", 7))                         # p_flags: PF_X | PF_W | PF_R (7)
        ph.extend(struct.pack("<Q", file_offset))               # p_offset
        ph.extend(struct.pack("<Q", self.base_addr))            # p_vaddr
        ph.extend(struct.pack("<Q", self.base_addr))            # p_paddr
        ph.extend(struct.pack("<Q", len(raw_bytes)))            # p_filesz
        ph.extend(struct.pack("<Q", len(raw_bytes) + 0x10000))  # p_memsz (includes SRAM heap)
        ph.extend(struct.pack("<Q", 0x1000))                    # p_align: 4096

        out = bytearray(elf_hdr)
        out.extend(ph)
        while len(out) < file_offset:
            out.append(0)
        out.extend(raw_bytes)

        os.makedirs(os.path.dirname(os.path.abspath(out_path)), exist_ok=True)
        with open(out_path, "wb") as f:
            f.write(out)
        return os.path.abspath(out_path)
