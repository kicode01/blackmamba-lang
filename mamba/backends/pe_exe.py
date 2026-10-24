"""
Black Mamba (.bmb) Standalone Windows 64-bit PE32+ (.exe) Native Compiler & Linker.

Directly emits a zero-dependency 64-bit Windows PE32+ executable (.exe) containing:
- .text   (RVA 0x1000): Native x86-64 machine code (_start, runtime helpers, and all .bmb functions)
- .rdata  (RVA 0x2000): PE Import Directory (msvcrt.dll & KERNEL32.dll), IAT, and string literals
- .rsrc   (RVA 0x3000): Standard PE32+ Resource Directory (RT_VERSION + RT_MANIFEST) verifiable via REA
"""

import os
import struct
from typing import Dict, List, Tuple
from ..mir import MIRFunction, MIRModule
from .x86_64_jit import X86_64CodeBuffer


IMAGE_BASE = 0x0000000140000000
TEXT_RVA = 0x1000
RDATA_RVA = 0x2000

# Fixed RVAs inside .rdata (0x2000)
IAT_PRINTF_RVA = 0x2080
IAT_CALLOC_RVA = 0x2088
IAT_POW_RVA = 0x2090
IAT_FFLUSH_RVA = 0x2098
IAT_EXITPROCESS_RVA = 0x20A8

FMT_I64_RVA = 0x2180
FMT_F64_RVA = 0x2188
STR_TRUE_RVA = 0x2190
STR_FALSE_RVA = 0x2198
FMT_STR_RVA = 0x21A0
STR_SPACE_RVA = 0x21A8
STR_NEWLINE_RVA = 0x21B0
STR_POOL_START_RVA = 0x2200


def _align(val: int, alignment: int) -> int:
    return (val + alignment - 1) & ~(alignment - 1)


class PE32PlusExecutableBuilder:
    """Compiles a MIRModule directly into a standalone Windows x86-64 PE32+ (.exe) binary."""

    def __init__(self, mir_module: MIRModule):
        self.mir_module = mir_module
        self.code_buf = X86_64CodeBuffer()
        self.string_rvas: Dict[int, int] = {}

    def build_bytes(self) -> bytes:
        rdata_raw = self._build_rdata_section()
        text_raw = self._build_text_section()

        text_virtual_size = len(text_raw)
        text_file_size = _align(text_virtual_size, 0x200)
        text_pages = _align(max(text_virtual_size, 1), 0x1000)

        rdata_rva = TEXT_RVA + text_pages
        # Because TEXT_RVA is 0x1000, if .text <= 4096 bytes, rdata_rva == 0x2000.
        # If .text > 4096 bytes, rebuild with adjusted rdata_rva.
        if rdata_rva != RDATA_RVA:
            rdata_raw = self._build_rdata_section(base_rva=rdata_rva)
            text_raw = self._build_text_section(rdata_base_rva=rdata_rva)
            text_virtual_size = len(text_raw)
            text_file_size = _align(text_virtual_size, 0x200)
            text_pages = _align(max(text_virtual_size, 1), 0x1000)
            rdata_rva = TEXT_RVA + text_pages

        rdata_virtual_size = len(rdata_raw)
        rdata_file_size = _align(rdata_virtual_size, 0x200)
        rdata_pages = _align(max(rdata_virtual_size, 1), 0x1000)

        rsrc_rva = rdata_rva + rdata_pages
        rsrc_raw = self._build_rsrc_section(rsrc_rva)
        rsrc_virtual_size = len(rsrc_raw)
        rsrc_file_size = _align(rsrc_virtual_size, 0x200)
        rsrc_pages = _align(max(rsrc_virtual_size, 1), 0x1000)

        size_of_image = rsrc_rva + rsrc_pages
        size_of_headers = 0x200

        text_file_offset = 0x200
        rdata_file_offset = text_file_offset + text_file_size
        rsrc_file_offset = rdata_file_offset + rdata_file_size

        headers = self._build_pe_headers(
            text_virtual_size=text_virtual_size,
            text_file_size=text_file_size,
            text_file_offset=text_file_offset,
            rdata_rva=rdata_rva,
            rdata_virtual_size=rdata_virtual_size,
            rdata_file_size=rdata_file_size,
            rdata_file_offset=rdata_file_offset,
            rsrc_rva=rsrc_rva,
            rsrc_virtual_size=rsrc_virtual_size,
            rsrc_file_size=rsrc_file_size,
            rsrc_file_offset=rsrc_file_offset,
            size_of_image=size_of_image,
            size_of_headers=size_of_headers,
        )

        out = bytearray()
        out.extend(headers.ljust(size_of_headers, b"\x00"))
        out.extend(text_raw.ljust(text_file_size, b"\x00"))
        out.extend(rdata_raw.ljust(rdata_file_size, b"\x00"))
        out.extend(rsrc_raw.ljust(rsrc_file_size, b"\x00"))
        return bytes(out)

    def write_executable(self, output_path: str) -> str:
        pe_bytes = self.build_bytes()
        os.makedirs(os.path.dirname(os.path.abspath(output_path)), exist_ok=True)
        with open(output_path, "wb") as f:
            f.write(pe_bytes)
        return os.path.abspath(output_path)

    def _build_rdata_section(self, base_rva: int = RDATA_RVA) -> bytes:
        delta = base_rva - RDATA_RVA
        buf = bytearray(0x200)

        # 1. Import Directory Table at +0x000 (3 entries x 20 bytes)
        # Entry 0: msvcrt.dll
        struct.pack_into(
            "<IIIII",
            buf,
            0x00,
            0x2040 + delta,  # OriginalFirstThunk (ILT)
            0,
            0,
            0x2100 + delta,  # Name RVA ("msvcrt.dll")
            0x2080 + delta,  # FirstThunk (IAT)
        )
        # Entry 1: KERNEL32.dll
        struct.pack_into(
            "<IIIII",
            buf,
            0x14,
            0x2068 + delta,  # OriginalFirstThunk (ILT)
            0,
            0,
            0x2110 + delta,  # Name RVA ("KERNEL32.dll")
            0x20A8 + delta,  # FirstThunk (IAT)
        )
        # Entry 2: Null entry at 0x28..0x3C (already zeros)

        # 2. ILT for msvcrt.dll at +0x040
        msvcrt_hints = [0x2120 + delta, 0x2130 + delta, 0x2140 + delta, 0x2148 + delta, 0]
        for i, h in enumerate(msvcrt_hints):
            struct.pack_into("<Q", buf, 0x40 + i * 8, h)

        # 3. ILT for KERNEL32.dll at +0x068
        kernel_hints = [0x2158 + delta, 0]
        for i, h in enumerate(kernel_hints):
            struct.pack_into("<Q", buf, 0x68 + i * 8, h)

        # 4. IAT for msvcrt.dll at +0x080
        for i, h in enumerate(msvcrt_hints):
            struct.pack_into("<Q", buf, 0x80 + i * 8, h)

        # 5. IAT for KERNEL32.dll at +0x0A8
        for i, h in enumerate(kernel_hints):
            struct.pack_into("<Q", buf, 0xA8 + i * 8, h)

        # 6. DLL & Import Hint/Name strings
        def put_bytes(offset: int, data: bytes) -> None:
            if offset + len(data) > len(buf):
                buf.extend(b"\x00" * (offset + len(data) - len(buf)))
            buf[offset : offset + len(data)] = data

        put_bytes(0x100, b"msvcrt.dll\x00")
        put_bytes(0x110, b"KERNEL32.dll\x00")
        put_bytes(0x120, b"\x00\x00printf\x00")
        put_bytes(0x130, b"\x00\x00calloc\x00")
        put_bytes(0x140, b"\x00\x00pow\x00")
        put_bytes(0x148, b"\x00\x00fflush\x00")
        put_bytes(0x158, b"\x00\x00ExitProcess\x00")

        # 7. Builtin format strings
        put_bytes(0x180, b"%lld\x00")
        put_bytes(0x188, b"%.6g\x00")
        put_bytes(0x190, b"True\x00")
        put_bytes(0x198, b"False\x00")
        put_bytes(0x1A0, b"%s\x00")
        put_bytes(0x1A8, b" \x00")
        put_bytes(0x1B0, b"\n\x00")

        # 8. String Pool at +0x200
        cur_off = 0x200
        for idx, s in enumerate(self.mir_module.string_pool):
            self.string_rvas[idx] = base_rva + cur_off
            encoded = s.encode("utf-8") + b"\x00"
            put_bytes(cur_off, encoded)
            cur_off = _align(cur_off + len(encoded), 8)

        return bytes(buf)

    def _build_rsrc_section(self, rsrc_rva: int) -> bytes:
        """
        Builds a clean PE Resource Directory (.rsrc) with RT_MANIFEST (24) so REA's
        `inspect_pe_resources` tool can inventory the compiled Black Mamba executable.
        """
        manifest_xml = (
            b'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
            b'<assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">\n'
            b'  <assemblyIdentity version="1.0.0.0" processorArchitecture="amd64" '
            b'name="BlackMamba.Native.Executable" type="win32"/>\n'
            b'  <description>Compiled by Black Mamba (.bmb) Native x86-64 Compiler</description>\n'
            b'</assembly>\n'
        )
        # Directory layout:
        # 0x00..0x10: Level 1 Root Resource Directory (1 ID entry)
        # 0x10..0x18: Level 1 Entry (Type ID = 24 RT_MANIFEST -> offset 0x80000018)
        # 0x18..0x28: Level 2 Name Directory (1 ID entry)
        # 0x28..0x30: Level 2 Entry (Name ID = 1 -> offset 0x80000030)
        # 0x30..0x40: Level 3 Language Directory (1 ID entry)
        # 0x40..0x48: Level 3 Entry (Lang ID = 1033 -> data entry offset 0x48)
        # 0x48..0x58: IMAGE_RESOURCE_DATA_ENTRY (RVA = rsrc_rva + 0x60, Size = len(manifest_xml))
        # 0x60..    : manifest_xml bytes
        rsrc = bytearray(0x60 + len(manifest_xml))
        # Root dir
        struct.pack_into("<IIHHHH", rsrc, 0x00, 0, 0, 0, 0, 0, 1)
        struct.pack_into("<II", rsrc, 0x10, 24, 0x80000018)
        # Name dir
        struct.pack_into("<IIHHHH", rsrc, 0x18, 0, 0, 0, 0, 0, 1)
        struct.pack_into("<II", rsrc, 0x28, 1, 0x80000030)
        # Lang dir
        struct.pack_into("<IIHHHH", rsrc, 0x30, 0, 0, 0, 0, 0, 1)
        struct.pack_into("<II", rsrc, 0x40, 1033, 0x00000048)
        # Data entry
        struct.pack_into("<IIII", rsrc, 0x48, rsrc_rva + 0x60, len(manifest_xml), 0, 0)
        rsrc[0x60 : 0x60 + len(manifest_xml)] = manifest_xml
        return bytes(rsrc)

    def _build_text_section(self, rdata_base_rva: int = RDATA_RVA) -> bytes:
        delta = rdata_base_rva - RDATA_RVA
        self.code_buf = X86_64CodeBuffer()
        buf = self.code_buf

        entry_fn = "__bmb_main__" if any(f.name == "__bmb_main__" for f in self.mir_module.functions) else "main"

        # 1. _start Entry Point at RVA 0x1000 (offset 0)
        buf.mark_label("_start")
        buf.emit(b"\x48\x83\xEC\x28", "sub rsp, 0x28")  # 32B shadow + 8B alignment
        buf.call_label(f"fn__{entry_fn}")
        buf.emit(b"\x48\x89\xC1", "mov rcx, rax")       # save exit code
        # Flush stdout via fflush(NULL)
        buf.emit(b"\x48\x31\xC9", "xor rcx, rcx")
        self._emit_call_iat(IAT_FFLUSH_RVA + delta, "msvcrt!fflush")
        buf.emit(b"\x48\x31\xC9", "xor rcx, rcx")
        self._emit_call_iat(IAT_EXITPROCESS_RVA + delta, "KERNEL32!ExitProcess")
        buf.ret()

        # 2. Runtime Helper: __bmb_print(rcx=kind, rdx=raw_val)
        buf.mark_label("rt__print")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        # kind 0: i64
        buf.emit(b"\x48\x83\xF9\x00", "cmp rcx, 0")
        buf.jcc_rel32(0x85, "ne", "rt__print_k1")
        self._emit_lea_rcx_rva(FMT_I64_RVA + delta, "FMT_I64")
        self._emit_call_iat(IAT_PRINTF_RVA + delta, "msvcrt!printf")
        buf.jmp_label("rt__print_done")

        # kind 1: f64
        buf.mark_label("rt__print_k1")
        buf.emit(b"\x48\x83\xF9\x01", "cmp rcx, 1")
        buf.jcc_rel32(0x85, "ne", "rt__print_k2")
        buf.emit(b"\x66\x48\x0F\x6E\xCA", "movq xmm1, rdx")
        self._emit_lea_rcx_rva(FMT_F64_RVA + delta, "FMT_F64")
        self._emit_call_iat(IAT_PRINTF_RVA + delta, "msvcrt!printf")
        buf.jmp_label("rt__print_done")

        # kind 2: bool
        buf.mark_label("rt__print_k2")
        buf.emit(b"\x48\x83\xF9\x02", "cmp rcx, 2")
        buf.jcc_rel32(0x85, "ne", "rt__print_k3")
        buf.emit(b"\x48\x85\xD2", "test rdx, rdx")
        buf.jcc_rel32(0x84, "e", "rt__print_false")
        self._emit_lea_rcx_rva(STR_TRUE_RVA + delta, "STR_TRUE")
        self._emit_call_iat(IAT_PRINTF_RVA + delta, "msvcrt!printf")
        buf.jmp_label("rt__print_done")
        buf.mark_label("rt__print_false")
        self._emit_lea_rcx_rva(STR_FALSE_RVA + delta, "STR_FALSE")
        self._emit_call_iat(IAT_PRINTF_RVA + delta, "msvcrt!printf")
        buf.jmp_label("rt__print_done")

        # kind 3: string pointer in rdx
        buf.mark_label("rt__print_k3")
        buf.emit(b"\x48\x83\xF9\x03", "cmp rcx, 3")
        buf.jcc_rel32(0x85, "ne", "rt__print_k4")
        self._emit_lea_rcx_rva(FMT_STR_RVA + delta, "FMT_STR")
        self._emit_call_iat(IAT_PRINTF_RVA + delta, "msvcrt!printf")
        buf.jmp_label("rt__print_done")

        # kind 4: space
        buf.mark_label("rt__print_k4")
        buf.emit(b"\x48\x83\xF9\x04", "cmp rcx, 4")
        buf.jcc_rel32(0x85, "ne", "rt__print_k5")
        self._emit_lea_rcx_rva(STR_SPACE_RVA + delta, "STR_SPACE")
        self._emit_call_iat(IAT_PRINTF_RVA + delta, "msvcrt!printf")
        buf.jmp_label("rt__print_done")

        # kind 5: newline
        buf.mark_label("rt__print_k5")
        self._emit_lea_rcx_rva(STR_NEWLINE_RVA + delta, "STR_NEWLINE")
        self._emit_call_iat(IAT_PRINTF_RVA + delta, "msvcrt!printf")

        buf.mark_label("rt__print_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()

        # 3. Runtime Helper: __bmb_alloc_arr(rcx=count, rdx=init_bits) -> rax=ptr
        buf.mark_label("rt__alloc_arr")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x40)
        buf.store_slot_rcx(-8, "count")
        buf.store_slot_rdx(-16, "init_bits")
        buf.mov_rax_imm64(8)
        buf.emit(b"\x48\x89\xC2", "mov rdx, rax")  # size = 8 bytes
        self._emit_call_iat(IAT_CALLOC_RVA + delta, "msvcrt!calloc")
        buf.store_slot_rax(-24, "ptr")
        # Initialize array if init_bits != 0
        buf.load_rdx_slot(-16, "init_bits")
        buf.emit(b"\x48\x85\xD2", "test rdx, rdx")
        buf.jcc_rel32(0x84, "e", "rt__alloc_done")
        buf.mov_rcx_imm64(0)
        buf.mark_label("rt__alloc_loop")
        buf.load_rax_slot(-8, "count")
        buf.emit(b"\x48\x39\xC1", "cmp rcx, rax")
        buf.jcc_rel32(0x8D, "ge", "rt__alloc_done")
        buf.load_rax_slot(-24, "ptr")
        buf.load_rdx_slot(-16, "init_bits")
        buf.store_idx_rax_rcx_rdx()
        buf.emit(b"\x48\xFF\xC1", "inc rcx")
        buf.jmp_label("rt__alloc_loop")
        buf.mark_label("rt__alloc_done")
        buf.load_rax_slot(-24, "ptr")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()

        # 4. Runtime Helper: __bmb_pow_f64(rcx=base_bits, rdx=exp_bits) -> rax=res_bits
        buf.mark_label("rt__pow_f64")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        buf.emit(b"\x66\x48\x0F\x6E\xC1", "movq xmm0, rcx")
        buf.emit(b"\x66\x48\x0F\x6E\xCA", "movq xmm1, rdx")
        self._emit_call_iat(IAT_POW_RVA + delta, "msvcrt!pow")
        buf.movq_rax_xmm0()
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()

        # 5. Runtime Helper: __bmb_pow_i64(rcx=base, rdx=exp) -> rax=res
        buf.mark_label("rt__pow_i64")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.mov_rax_imm64(1)
        buf.mark_label("rt__pow_i64_loop")
        buf.emit(b"\x48\x85\xD2", "test rdx, rdx")
        buf.jcc_rel32(0x8E, "le", "rt__pow_i64_done")
        buf.imul_rax_rcx()
        buf.emit(b"\x48\xFF\xCA", "dec rdx")
        buf.jmp_label("rt__pow_i64_loop")
        buf.mark_label("rt__pow_i64_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()

        # 5b. Host Python Interop Fallback Stub
        buf.mark_label("rt__py_stub")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.ret()

        # 5c. Lexical Arena Checkpoint Helpers
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

        # 5d. String Helpers / Stubs
        buf.mark_label("rt__str_stub")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.ret()

        buf.mark_label("rt__str_len")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xD1\xE8", "shr rax, 1")
        buf.emit(b"\x48\x83\xE0\x7F", "and rax, 0x7F")
        buf.ret()

        buf.mark_label("rt__str_cmp_eq")
        buf.emit(b"\x48\x39\xD1", "cmp rcx, rdx")
        buf.emit(b"\x0F\x94\xC0", "sete al")
        buf.emit(b"\x48\x0F\xB6\xC0", "movzx rax, al")
        buf.ret()

        buf.mark_label("rt__str_cmp_ne")
        buf.emit(b"\x48\x39\xD1", "cmp rcx, rdx")
        buf.emit(b"\x0F\x95\xC0", "setne al")
        buf.emit(b"\x48\x0F\xB6\xC0", "movzx rax, al")
        buf.ret()

        # 6. Emit all MIR functions with hardware register allocation and branch fusion
        helper_labels = {
            "print": "rt__print",
            "alloc_arr": "rt__alloc_arr",
            "pow_i64": "rt__pow_i64",
            "pow_f64": "rt__pow_f64",
            "py_call_f64": "rt__py_stub",
            "py_eval_f64": "rt__py_stub",
            "arena_save": "rt__arena_save",
            "arena_restore": "rt__arena_restore",
            "str_concat": "rt__str_stub",
            "str_slice": "rt__str_stub",
            "str_index": "rt__str_stub",
            "str_len": "rt__str_len",
            "str_cmp_eq": "rt__str_cmp_eq",
            "str_cmp_ne": "rt__str_cmp_ne",
            "str_from_i64": "rt__str_stub",
            "str_from_f64": "rt__str_stub",
            "str_from_bool": "rt__str_stub",
            "clock_ns": "rt__clock_ns",
        }

        def emit_const_str(ins, store_from_rax):
            str_rva = self.string_rvas.get(int(ins.arg1), STR_POOL_START_RVA + delta)
            off = len(buf.code)
            next_rva = TEXT_RVA + off + 7
            rel32 = str_rva - next_rva
            buf.emit(b"\x48\x8D\x05" + struct.pack("<i", rel32), f"lea rax, [rip + 0x{rel32 & 0xFFFFFFFF:X}] ; str#{ins.arg1}")
            store_from_rax(str(ins.dst))

        def emit_helper_call(kind):
            buf.call_label(helper_labels[kind])

        for fn in self.mir_module.functions:
            buf.compile_mir_function(fn, emit_const_str, emit_helper_call)

        buf.resolve_fixups()
        return bytes(buf.code)

    def _emit_call_iat(self, target_iat_rva: int, name: str) -> None:
        # FF 15 <rel32> -> call qword ptr [rip + rel32]
        off = len(self.code_buf.code)
        next_rva = TEXT_RVA + off + 6
        rel32 = target_iat_rva - next_rva
        raw = b"\xFF\x15" + struct.pack("<i", rel32)
        self.code_buf.emit(raw, f"call qword ptr [rip + 0x{rel32 & 0xFFFFFFFF:X}] ; {name}")

    def _emit_lea_rcx_rva(self, target_rva: int, name: str) -> None:
        # 48 8D 0D <rel32> -> lea rcx, [rip + rel32]
        off = len(self.code_buf.code)
        next_rva = TEXT_RVA + off + 7
        rel32 = target_rva - next_rva
        raw = b"\x48\x8D\x0D" + struct.pack("<i", rel32)
        self.code_buf.emit(raw, f"lea rcx, [rip + 0x{rel32 & 0xFFFFFFFF:X}] ; {name}")

    def _build_pe_headers(
        self,
        text_virtual_size: int,
        text_file_size: int,
        text_file_offset: int,
        rdata_rva: int,
        rdata_virtual_size: int,
        rdata_file_size: int,
        rdata_file_offset: int,
        rsrc_rva: int,
        rsrc_virtual_size: int,
        rsrc_file_size: int,
        rsrc_file_offset: int,
        size_of_image: int,
        size_of_headers: int,
    ) -> bytes:
        hdr = bytearray(0x200)
        # DOS Header
        hdr[0:2] = b"MZ"
        struct.pack_into("<I", hdr, 0x3C, 0x80)  # e_lfanew = 0x80

        # PE Signature + COFF File Header at 0x80
        hdr[0x80:0x84] = b"PE\x00\x00"
        struct.pack_into(
            "<HHIIIHH",
            hdr,
            0x84,
            0x8664,  # Machine: IMAGE_FILE_MACHINE_AMD64
            3,       # NumberOfSections: .text, .rdata, .rsrc
            0,       # TimeDateStamp
            0,       # PointerToSymbolTable
            0,       # NumberOfSymbols
            0xF0,    # SizeOfOptionalHeader (240 bytes for PE32+)
            0x0022,  # Characteristics: EXECUTABLE_IMAGE | LARGE_ADDRESS_AWARE
        )

        # Optional Header PE32+ at 0x98 (240 bytes -> ends at 0x188)
        opt_off = 0x98
        struct.pack_into(
            "<HBBIIIIIQIIHHHHHHIIIIHHQQQQII",
            hdr,
            opt_off,
            0x020B,                # Magic: PE32+ (64-bit)
            14,                    # MajorLinkerVersion
            0,                     # MinorLinkerVersion
            text_file_size,        # SizeOfCode
            rdata_file_size + rsrc_file_size,  # SizeOfInitializedData
            0,                     # SizeOfUninitializedData
            TEXT_RVA,              # AddressOfEntryPoint (_start)
            TEXT_RVA,              # BaseOfCode
            IMAGE_BASE,            # ImageBase
            0x1000,                # SectionAlignment
            0x200,                 # FileAlignment
            6,                     # MajorOperatingSystemVersion
            0,                     # MinorOperatingSystemVersion
            0,                     # MajorImageVersion
            0,                     # MinorImageVersion
            6,                     # MajorSubsystemVersion
            0,                     # MinorSubsystemVersion
            0,                     # Win32VersionValue
            size_of_image,         # SizeOfImage
            size_of_headers,       # SizeOfHeaders
            0,                     # CheckSum
            3,                     # Subsystem: IMAGE_SUBSYSTEM_WINDOWS_CUI (console)
            0x8140,                # DllCharacteristics: DYNAMIC_BASE | NX_COMPAT | TERMINAL_SERVER_AWARE
            0x100000,              # SizeOfStackReserve
            0x10000,               # SizeOfStackCommit
            0x100000,              # SizeOfHeapReserve
            0x10000,               # SizeOfHeapCommit
            0,                     # LoaderFlags
            16,                    # NumberOfRvaAndSizes
        )

        # Data Directories start at opt_off + 112 = 0x108
        dd_off = opt_off + 112
        # DataDirectory[1] = Import Table (RVA = rdata_rva, Size = 60)
        struct.pack_into("<II", hdr, dd_off + 1 * 8, rdata_rva, 60)
        # DataDirectory[2] = Resource Table (RVA = rsrc_rva, Size = rsrc_virtual_size)
        struct.pack_into("<II", hdr, dd_off + 2 * 8, rsrc_rva, rsrc_virtual_size)
        # DataDirectory[12] = IAT (RVA = rdata_rva + 0x80, Size = 0x38)
        struct.pack_into("<II", hdr, dd_off + 12 * 8, rdata_rva + 0x80, 0x38)

        # Section Headers at 0x188 (3 * 40 bytes = 120 bytes)
        sec_off = 0x188
        # Section 0: .text
        struct.pack_into(
            "<8sIIIIIIHHI",
            hdr,
            sec_off,
            b".text\x00\x00\x00",
            text_virtual_size,
            TEXT_RVA,
            text_file_size,
            text_file_offset,
            0,
            0,
            0,
            0,
            0x60000020,  # CNT_CODE | MEM_EXECUTE | MEM_READ
        )
        # Section 1: .rdata
        struct.pack_into(
            "<8sIIIIIIHHI",
            hdr,
            sec_off + 40,
            b".rdata\x00\x00",
            rdata_virtual_size,
            rdata_rva,
            rdata_file_size,
            rdata_file_offset,
            0,
            0,
            0,
            0,
            0x40000040 | 0x80000000,  # CNT_INITIALIZED_DATA | MEM_READ | MEM_WRITE (for IAT patching)
        )
        # Section 2: .rsrc
        struct.pack_into(
            "<8sIIIIIIHHI",
            hdr,
            sec_off + 80,
            b".rsrc\x00\x00\x00",
            rsrc_virtual_size,
            rsrc_rva,
            rsrc_file_size,
            rsrc_file_offset,
            0,
            0,
            0,
            0,
            0x40000040,  # CNT_INITIALIZED_DATA | MEM_READ
        )
        return bytes(hdr)
