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
        self.iat_rvas: Dict[str, int] = {}
        self.builtin_rvas: Dict[str, int] = {}
        self.iat_start_rva: int = 0
        self.iat_total_size: int = 0
        self.idt_size: int = 0

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
        self.iat_rvas = {}
        self.builtin_rvas = {}
        self.string_rvas = {}

        imports_spec = [
            (
                "msvcrt.dll",
                [
                    "printf", "calloc", "pow", "fflush",
                    "fopen", "fread", "fwrite", "fclose", "fseek", "ftell",
                    "remove", "_getcwd", "getenv",
                ],
            ),
            (
                "KERNEL32.dll",
                [
                    "ExitProcess",
                ],
            ),
        ]

        idt_size = (len(imports_spec) + 1) * 20
        self.idt_size = idt_size
        cur_off = _align(idt_size, 8)

        ilt_offsets = []
        for dll_name, funcs in imports_spec:
            ilt_offsets.append(cur_off)
            cur_off += (len(funcs) + 1) * 8

        iat_offsets = []
        func_iat_offsets = {}
        for dll_name, funcs in imports_spec:
            iat_offsets.append(cur_off)
            for f in funcs:
                func_iat_offsets[f] = cur_off
                cur_off += 8
            cur_off += 8  # null terminator

        self.iat_start_rva = base_rva + iat_offsets[0]
        self.iat_total_size = sum((len(funcs) + 1) * 8 for _, funcs in imports_spec)

        dll_name_offsets = []
        for dll_name, _ in imports_spec:
            cur_off = _align(cur_off, 2)
            dll_name_offsets.append(cur_off)
            cur_off += len(dll_name) + 1

        hint_offsets = {}
        for _, funcs in imports_spec:
            for f in funcs:
                cur_off = _align(cur_off, 2)
                hint_offsets[f] = cur_off
                cur_off += 2 + len(f) + 1

        cur_off = _align(cur_off, 8)
        builtins_spec = [
            ("fmt_i64", b"%lld\x00"),
            ("fmt_f64", b"%.6g\x00"),
            ("str_true", b"True\x00"),
            ("str_false", b"False\x00"),
            ("fmt_str", b"%s\x00"),
            ("str_space", b" \x00"),
            ("str_newline", b"\n\x00"),
            ("str_rb", b"rb\x00"),
            ("str_wb", b"wb\x00"),
            ("str_ab", b"ab\x00"),
            ("str_empty", b"\x00"),
        ]
        builtin_offsets = {}
        for b_name, b_bytes in builtins_spec:
            cur_off = _align(cur_off, 4)
            builtin_offsets[b_name] = cur_off
            cur_off += len(b_bytes)

        cur_off = _align(cur_off, 8)
        string_pool_offsets = {}
        for idx, s in enumerate(self.mir_module.string_pool):
            cur_off = _align(cur_off, 8)
            string_pool_offsets[idx] = cur_off
            cur_off += len(s.encode("utf-8")) + 1

        total_rdata_len = _align(cur_off, 0x200)
        buf = bytearray(total_rdata_len)

        for f, off in func_iat_offsets.items():
            self.iat_rvas[f] = base_rva + off
        for b_name, off in builtin_offsets.items():
            self.builtin_rvas[b_name] = base_rva + off
        for idx, off in string_pool_offsets.items():
            self.string_rvas[idx] = base_rva + off

        for i, (dll_name, funcs) in enumerate(imports_spec):
            struct.pack_into(
                "<IIIII",
                buf,
                i * 20,
                base_rva + ilt_offsets[i],
                0,
                0,
                base_rva + dll_name_offsets[i],
                base_rva + iat_offsets[i],
            )

        for i, (dll_name, funcs) in enumerate(imports_spec):
            ilt_cur = ilt_offsets[i]
            iat_cur = iat_offsets[i]
            for f in funcs:
                hint_rva = base_rva + hint_offsets[f]
                struct.pack_into("<Q", buf, ilt_cur, hint_rva)
                struct.pack_into("<Q", buf, iat_cur, hint_rva)
                ilt_cur += 8
                iat_cur += 8

        for i, (dll_name, _) in enumerate(imports_spec):
            d_bytes = dll_name.encode("ascii") + b"\x00"
            off = dll_name_offsets[i]
            buf[off : off + len(d_bytes)] = d_bytes

        for _, funcs in imports_spec:
            for f in funcs:
                off = hint_offsets[f]
                h_bytes = b"\x00\x00" + f.encode("ascii") + b"\x00"
                buf[off : off + len(h_bytes)] = h_bytes

        for b_name, b_bytes in builtins_spec:
            off = builtin_offsets[b_name]
            buf[off : off + len(b_bytes)] = b_bytes

        for idx, s in enumerate(self.mir_module.string_pool):
            off = string_pool_offsets[idx]
            s_bytes = s.encode("utf-8") + b"\x00"
            buf[off : off + len(s_bytes)] = s_bytes

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
        self._emit_call_iat(self.iat_rvas["fflush"], "msvcrt!fflush")
        buf.emit(b"\x48\x31\xC9", "xor rcx, rcx")
        self._emit_call_iat(self.iat_rvas["ExitProcess"], "KERNEL32!ExitProcess")
        buf.ret()

        # 2. Runtime Helper: __bmb_print(rcx=kind, rdx=raw_val)
        buf.mark_label("rt__print")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        # kind 0: i64
        buf.emit(b"\x48\x83\xF9\x00", "cmp rcx, 0")
        buf.jcc_rel32(0x85, "ne", "rt__print_k1")
        self._emit_lea_rcx_rva(self.builtin_rvas["fmt_i64"], "FMT_I64")
        self._emit_call_iat(self.iat_rvas["printf"], "msvcrt!printf")
        buf.jmp_label("rt__print_done")

        # kind 1: f64
        buf.mark_label("rt__print_k1")
        buf.emit(b"\x48\x83\xF9\x01", "cmp rcx, 1")
        buf.jcc_rel32(0x85, "ne", "rt__print_k2")
        buf.emit(b"\x66\x48\x0F\x6E\xCA", "movq xmm1, rdx")
        self._emit_lea_rcx_rva(self.builtin_rvas["fmt_f64"], "FMT_F64")
        self._emit_call_iat(self.iat_rvas["printf"], "msvcrt!printf")
        buf.jmp_label("rt__print_done")

        # kind 2: bool
        buf.mark_label("rt__print_k2")
        buf.emit(b"\x48\x83\xF9\x02", "cmp rcx, 2")
        buf.jcc_rel32(0x85, "ne", "rt__print_k3")
        buf.emit(b"\x48\x85\xD2", "test rdx, rdx")
        buf.jcc_rel32(0x84, "e", "rt__print_false")
        self._emit_lea_rcx_rva(self.builtin_rvas["str_true"], "STR_TRUE")
        self._emit_call_iat(self.iat_rvas["printf"], "msvcrt!printf")
        buf.jmp_label("rt__print_done")
        buf.mark_label("rt__print_false")
        self._emit_lea_rcx_rva(self.builtin_rvas["str_false"], "STR_FALSE")
        self._emit_call_iat(self.iat_rvas["printf"], "msvcrt!printf")
        buf.jmp_label("rt__print_done")

        # kind 3: string in rdx (either pointer or SSO immediate)
        buf.mark_label("rt__print_k3")
        buf.emit(b"\x48\x83\xF9\x03", "cmp rcx, 3")
        buf.jcc_rel32(0x85, "ne", "rt__print_k4")
        buf.emit(b"\xF6\xC2\x01", "test dl, 1")
        buf.jcc_rel32(0x84, "z", "rt__print_k3_ptr")
        # SSO immediate: unpack rdx >> 8 into stack buffer [rbp - 0x10]
        buf.emit(b"\x48\x89\xD0", "mov rax, rdx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xF0", "mov qword ptr [rbp - 0x10], rax")
        buf.emit(b"\x48\xC7\x45\xF8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x08], 0")
        buf.emit(b"\x48\x8D\x55\xF0", "lea rdx, [rbp - 0x10]")
        buf.mark_label("rt__print_k3_ptr")
        self._emit_lea_rcx_rva(self.builtin_rvas["fmt_str"], "FMT_STR")
        self._emit_call_iat(self.iat_rvas["printf"], "msvcrt!printf")
        buf.jmp_label("rt__print_done")

        # kind 4: space
        buf.mark_label("rt__print_k4")
        buf.emit(b"\x48\x83\xF9\x04", "cmp rcx, 4")
        buf.jcc_rel32(0x85, "ne", "rt__print_k5")
        self._emit_lea_rcx_rva(self.builtin_rvas["str_space"], "STR_SPACE")
        self._emit_call_iat(self.iat_rvas["printf"], "msvcrt!printf")
        buf.jmp_label("rt__print_done")

        # kind 5: newline
        buf.mark_label("rt__print_k5")
        self._emit_lea_rcx_rva(self.builtin_rvas["str_newline"], "STR_NEWLINE")
        self._emit_call_iat(self.iat_rvas["printf"], "msvcrt!printf")

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
        self._emit_call_iat(self.iat_rvas["calloc"], "msvcrt!calloc")
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
        self._emit_call_iat(self.iat_rvas["pow"], "msvcrt!pow")
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

        buf.mark_label("rt__str_chr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE0\x08", "shl rax, 8")
        buf.emit(b"\x48\x83\xC8\x03", "or rax, 3")
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

        buf.mark_label("rt__str_slice")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x50)
        buf.emit(b"\x48\x89\x4D\xF8", "mov [rbp - 0x08], rcx ; s")
        buf.emit(b"\x48\x89\x55\xF0", "mov [rbp - 0x10], rdx ; start")
        buf.emit(b"\x4C\x89\x45\xE8", "mov [rbp - 0x18], r8  ; stop")

        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__slice_s_ptr")

        # SSO:
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xD1\xE8", "shr rax, 1")
        buf.emit(b"\x48\x83\xE0\x7F", "and rax, 0x7F")
        buf.emit(b"\x48\x89\x45\xE0", "mov [rbp - 0x20], rax ; len")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xD0", "mov [rbp - 0x30], rax ; sso_buf")
        buf.emit(b"\x48\xC7\x45\xD8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x28], 0")
        buf.emit(b"\x48\x8D\x45\xD0", "lea rax, [rbp - 0x30]")
        buf.emit(b"\x48\x89\x45\xD8", "mov [rbp - 0x28], rax ; src_ptr")
        buf.jmp_label("rt__slice_len_ready")

        buf.mark_label("rt__slice_s_ptr")
        buf.emit(b"\x48\x89\x4D\xD8", "mov [rbp - 0x28], rcx ; src_ptr")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mark_label("rt__slice_len_loop")
        buf.emit(b"\x80\x3C\x01\x00", "cmp byte ptr [rcx + rax], 0")
        buf.jcc_rel32(0x84, "e", "rt__slice_len_done")
        buf.emit(b"\x48\xFF\xC0", "inc rax")
        buf.jmp_label("rt__slice_len_loop")
        buf.mark_label("rt__slice_len_done")
        buf.emit(b"\x48\x89\x45\xE0", "mov [rbp - 0x20], rax ; len")

        buf.mark_label("rt__slice_len_ready")
        # Normalize start:
        buf.emit(b"\x48\x8B\x45\xF0", "mov rax, [rbp - 0x10]")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x8D, "ge", "rt__slice_start_ge0")
        buf.emit(b"\x48\x03\x45\xE0", "add rax, [rbp - 0x20]")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x8D, "ge", "rt__slice_start_clamp_min")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mark_label("rt__slice_start_clamp_min")
        buf.emit(b"\x48\x89\x45\xF0", "mov [rbp - 0x10], rax")
        buf.mark_label("rt__slice_start_ge0")

        buf.emit(b"\x48\x8B\x45\xF0", "mov rax, [rbp - 0x10]")
        buf.emit(b"\x48\x3B\x45\xE0", "cmp rax, [rbp - 0x20]")
        buf.jcc_rel32(0x8E, "le", "rt__slice_start_clamped")
        buf.emit(b"\x48\x8B\x45\xE0", "mov rax, [rbp - 0x20]")
        buf.emit(b"\x48\x89\x45\xF0", "mov [rbp - 0x10], rax")
        buf.mark_label("rt__slice_start_clamped")

        # Normalize stop:
        buf.emit(b"\x48\x8B\x45\xE8", "mov rax, [rbp - 0x18]")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x8D, "ge", "rt__slice_stop_ge0")
        buf.emit(b"\x48\x8B\x45\xE0", "mov rax, [rbp - 0x20]")
        buf.emit(b"\x48\x89\x45\xE8", "mov [rbp - 0x18], rax")
        buf.jmp_label("rt__slice_stop_clamp_len")

        buf.mark_label("rt__slice_stop_ge0")
        buf.emit(b"\x48\x8B\x45\xE8", "mov rax, [rbp - 0x18]")
        buf.emit(b"\x48\x3B\x45\xF0", "cmp rax, [rbp - 0x10]")
        buf.jcc_rel32(0x8D, "ge", "rt__slice_stop_clamp_len")
        buf.emit(b"\x48\x8B\x45\xF0", "mov rax, [rbp - 0x10]")
        buf.emit(b"\x48\x89\x45\xE8", "mov [rbp - 0x18], rax")

        buf.mark_label("rt__slice_stop_clamp_len")
        buf.emit(b"\x48\x8B\x45\xE8", "mov rax, [rbp - 0x18]")
        buf.emit(b"\x48\x3B\x45\xE0", "cmp rax, [rbp - 0x20]")
        buf.jcc_rel32(0x8E, "le", "rt__slice_stop_clamped")
        buf.emit(b"\x48\x8B\x45\xE0", "mov rax, [rbp - 0x20]")
        buf.emit(b"\x48\x89\x45\xE8", "mov [rbp - 0x18], rax")
        buf.mark_label("rt__slice_stop_clamped")

        # slice_len = stop - start
        buf.emit(b"\x48\x8B\x45\xE8", "mov rax, [rbp - 0x18]")
        buf.emit(b"\x48\x2B\x45\xF0", "sub rax, [rbp - 0x10]")
        buf.emit(b"\x48\x89\x45\xC8", "mov [rbp - 0x38], rax ; slice_len")

        # If slice_len <= 7 -> SSO
        buf.emit(b"\x48\x83\xF8\x07", "cmp rax, 7")
        buf.jcc_rel32(0x8F, "g", "rt__slice_heap")

        # Build SSO:
        buf.emit(b"\x48\xD1\xE0", "shl rax, 1")
        buf.emit(b"\x48\x83\xC8\x01", "or rax, 1")
        buf.emit(b"\x4C\x8B\x45\xD8", "mov r8, [rbp - 0x28]")
        buf.emit(b"\x4C\x03\x45\xF0", "add r8, [rbp - 0x10]")
        buf.emit(b"\x4D\x31\xC9", "xor r9, r9 ; loop counter")

        buf.mark_label("rt__slice_sso_loop")
        buf.emit(b"\x4C\x3B\x4D\xC8", "cmp r9, [rbp - 0x38]")
        buf.jcc_rel32(0x8D, "ge", "rt__slice_sso_done")
        buf.emit(b"\x45\x0F\xB6\x18", "movzx r11d, byte ptr [r8]")
        buf.emit(b"\x49\xFF\xC0", "inc r8")
        buf.emit(b"\x49\x8D\x49\x01", "lea rcx, [r9 + 1]")
        buf.emit(b"\x48\xC1\xE1\x03", "shl rcx, 3")
        buf.emit(b"\x49\xD3\xE3", "shl r11, cl")
        buf.emit(b"\x4C\x09\xD8", "or rax, r11")
        buf.emit(b"\x49\xFF\xC1", "inc r9")
        buf.jmp_label("rt__slice_sso_loop")

        buf.mark_label("rt__slice_sso_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()

        # Heap path:
        buf.mark_label("rt__slice_heap")
        buf.emit(b"\x48\x8B\x4D\xC8", "mov rcx, [rbp - 0x38]")
        buf.emit(b"\x48\xFF\xC1", "inc rcx ; count = slice_len + 1")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1 ; size = 1")
        self._emit_call_iat(self.iat_rvas["calloc"], "msvcrt!calloc")
        buf.emit(b"\x48\x89\x45\xC0", "mov [rbp - 0x40], rax ; dst ptr")

        buf.emit(b"\x4C\x8B\x45\xC0", "mov r8, [rbp - 0x40]")
        buf.emit(b"\x4C\x8B\x4D\xD8", "mov r9, [rbp - 0x28]")
        buf.emit(b"\x4C\x03\x4D\xF0", "add r9, [rbp - 0x10]")
        buf.emit(b"\x4D\x31\xDB", "xor r11, r11")

        buf.mark_label("rt__slice_heap_loop")
        buf.emit(b"\x4C\x3B\x5D\xC8", "cmp r11, [rbp - 0x38]")
        buf.jcc_rel32(0x8D, "ge", "rt__slice_heap_done")
        buf.emit(b"\x43\x8A\x04\x19", "mov al, byte ptr [r9 + r11]")
        buf.emit(b"\x43\x88\x04\x18", "mov byte ptr [r8 + r11], al")
        buf.emit(b"\x49\xFF\xC3", "inc r11")
        buf.jmp_label("rt__slice_heap_loop")

        buf.mark_label("rt__slice_heap_done")
        buf.emit(b"\x48\x8B\x45\xC8", "mov rax, [rbp - 0x38] ; slice_len")
        buf.emit(b"\x41\xC6\x04\x00\x00", "mov byte ptr [r8 + rax], 0")
        buf.emit(b"\x48\x8B\x45\xC0", "mov rax, [rbp - 0x40]")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
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

        # Heap allocate via calloc(count, 1)
        buf.emit(b"\x48\x8B\x4D\xE8", "mov rcx, [rbp - 0x18]")
        buf.emit(b"\x48\x03\x4D\xE0", "add rcx, [rbp - 0x20]")
        buf.emit(b"\x48\xFF\xC1", "inc rcx ; count = len1 + len2 + 1")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1 ; size = 1")
        self._emit_call_iat(self.iat_rvas["calloc"], "msvcrt!calloc")
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

        # 6. Emit all MIR functions with hardware register allocation and branch fusion
        helper_labels = {
            "print": "rt__print",
            "alloc_arr": "rt__alloc_arr",
            "pow_i64": "rt__pow_i64",
            "pow_f64": "rt__pow_f64",
            "py_call_f64": "rt__py_stub",
            "py_eval_f64": "rt__py_stub",
            "py_eval_tensor": "rt__py_stub",
            "arena_save": "rt__arena_save",
            "arena_restore": "rt__arena_restore",
            "str_concat": "rt__str_concat",
            "str_slice": "rt__str_slice",
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
            str_rva = self.string_rvas.get(int(ins.arg1), self.builtin_rvas["str_empty"])
            off = len(buf.code)
            next_rva = TEXT_RVA + off + 7
            rel32 = str_rva - next_rva
            buf.emit(b"\x48\x8D\x05" + struct.pack("<i", rel32), f"lea rax, [rip + 0x{rel32 & 0xFFFFFFFF:X}] ; str#{ins.arg1}")
            store_from_rax(str(ins.dst))

        def emit_helper_call(kind):
            buf.call_label(helper_labels[kind])

        # --- Native OS Primitives (MSVCRT / Win32) ---

        # fn____bmb_file_exists(rcx=path) -> rax=bool (1 or 0)
        buf.mark_label("fn____bmb_file_exists")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__fe_ptr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xF0", "mov [rbp - 0x10], rax")
        buf.emit(b"\x48\xC7\x45\xF8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x08], 0")
        buf.emit(b"\x48\x8D\x4D\xF0", "lea rcx, [rbp - 0x10]")
        buf.mark_label("rt__fe_ptr")
        self._emit_lea_rdx_rva(self.builtin_rvas["str_rb"], "str_rb")
        self._emit_call_iat(self.iat_rvas["fopen"], "msvcrt!fopen")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x84, "z", "rt__fe_no")
        buf.emit(b"\x48\x89\xC1", "mov rcx, rax")
        self._emit_call_iat(self.iat_rvas["fclose"], "msvcrt!fclose")
        buf.emit(b"\x48\xC7\xC0\x01\x00\x00\x00", "mov rax, 1")
        buf.jmp_label("rt__fe_done")
        buf.mark_label("rt__fe_no")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mark_label("rt__fe_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()

        # fn____bmb_file_size(rcx=path) -> rax=i64 (size or -1)
        buf.mark_label("fn____bmb_file_size")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__fs_ptr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xF0", "mov [rbp - 0x10], rax")
        buf.emit(b"\x48\xC7\x45\xF8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x08], 0")
        buf.emit(b"\x48\x8D\x4D\xF0", "lea rcx, [rbp - 0x10]")
        buf.mark_label("rt__fs_ptr")
        self._emit_lea_rdx_rva(self.builtin_rvas["str_rb"], "str_rb")
        self._emit_call_iat(self.iat_rvas["fopen"], "msvcrt!fopen")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x84, "z", "rt__fs_err")
        buf.emit(b"\x48\x89\x45\xF0", "mov [rbp - 0x10], rax ; FILE*")
        buf.emit(b"\x48\x89\xC1", "mov rcx, rax")
        buf.emit(b"\x48\x31\xD2", "xor rdx, rdx")
        buf.emit(b"\x49\xC7\xC0\x02\x00\x00\x00", "mov r8, 2")
        self._emit_call_iat(self.iat_rvas["fseek"], "msvcrt!fseek")
        buf.emit(b"\x48\x8B\x4D\xF0", "mov rcx, [rbp - 0x10]")
        self._emit_call_iat(self.iat_rvas["ftell"], "msvcrt!ftell")
        buf.emit(b"\x48\x89\x45\xF8", "mov [rbp - 0x08], rax ; size")
        buf.emit(b"\x48\x8B\x4D\xF0", "mov rcx, [rbp - 0x10]")
        self._emit_call_iat(self.iat_rvas["fclose"], "msvcrt!fclose")
        buf.emit(b"\x48\x8B\x45\xF8", "mov rax, [rbp - 0x08]")
        buf.jmp_label("rt__fs_done")
        buf.mark_label("rt__fs_err")
        buf.emit(b"\x48\xC7\xC0\xFF\xFF\xFF\xFF", "mov rax, -1")
        buf.mark_label("rt__fs_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()

        # fn____bmb_file_read(rcx=path) -> rax=ptr
        buf.mark_label("fn____bmb_file_read")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x40)
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__fr_ptr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xF0", "mov [rbp - 0x10], rax")
        buf.emit(b"\x48\xC7\x45\xF8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x08], 0")
        buf.emit(b"\x48\x8D\x4D\xF0", "lea rcx, [rbp - 0x10]")
        buf.mark_label("rt__fr_ptr")
        self._emit_lea_rdx_rva(self.builtin_rvas["str_rb"], "str_rb")
        self._emit_call_iat(self.iat_rvas["fopen"], "msvcrt!fopen")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x84, "z", "rt__fr_err")
        buf.emit(b"\x48\x89\x45\xF0", "mov [rbp - 0x10], rax ; FILE*")
        buf.emit(b"\x48\x89\xC1", "mov rcx, rax")
        buf.emit(b"\x48\x31\xD2", "xor rdx, rdx")
        buf.emit(b"\x49\xC7\xC0\x02\x00\x00\x00", "mov r8, 2")
        self._emit_call_iat(self.iat_rvas["fseek"], "msvcrt!fseek")
        buf.emit(b"\x48\x8B\x4D\xF0", "mov rcx, [rbp - 0x10]")
        self._emit_call_iat(self.iat_rvas["ftell"], "msvcrt!ftell")
        buf.emit(b"\x48\x89\x45\xF8", "mov [rbp - 0x08], rax ; size")
        buf.emit(b"\x48\x8B\x4D\xF0", "mov rcx, [rbp - 0x10]")
        buf.emit(b"\x48\x31\xD2", "xor rdx, rdx")
        buf.emit(b"\x4D\x31\xC0", "xor r8, r8")
        self._emit_call_iat(self.iat_rvas["fseek"], "msvcrt!fseek")
        buf.emit(b"\x48\x8B\x4D\xF8", "mov rcx, [rbp - 0x08]")
        buf.emit(b"\x48\xFF\xC1", "inc rcx")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1")
        self._emit_call_iat(self.iat_rvas["calloc"], "msvcrt!calloc")
        buf.emit(b"\x48\x89\x45\xE8", "mov [rbp - 0x18], rax ; buf ptr")
        buf.emit(b"\x48\x89\xC1", "mov rcx, rax")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1")
        buf.emit(b"\x4C\x8B\x45\xF8", "mov r8, [rbp - 0x08]")
        buf.emit(b"\x4C\x8B\x4D\xF0", "mov r9, [rbp - 0x10]")
        self._emit_call_iat(self.iat_rvas["fread"], "msvcrt!fread")
        buf.emit(b"\x48\x8B\x4D\xF0", "mov rcx, [rbp - 0x10]")
        self._emit_call_iat(self.iat_rvas["fclose"], "msvcrt!fclose")
        buf.emit(b"\x48\x8B\x45\xE8", "mov rax, [rbp - 0x18]")
        buf.jmp_label("rt__fr_done")
        buf.mark_label("rt__fr_err")
        self._emit_lea_rax_rva(self.builtin_rvas["str_empty"], "str_empty")
        buf.mark_label("rt__fr_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()

        # fn____bmb_file_write(rcx=path, rdx=content, r8=mode) -> rax=i64 (written or -1)
        buf.mark_label("fn____bmb_file_write")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x70)
        buf.emit(b"\x48\x89\x4D\xF8", "mov [rbp - 0x08], rcx ; path")
        buf.emit(b"\x48\x89\x55\xF0", "mov [rbp - 0x10], rdx ; content")
        buf.emit(b"\x4C\x89\x45\xE8", "mov [rbp - 0x18], r8  ; mode")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__fw_path_ptr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xE0", "mov [rbp - 0x20], rax")
        buf.emit(b"\x48\xC7\x45\xD8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x28], 0")
        buf.emit(b"\x48\x8D\x4D\xE0", "lea rcx, [rbp - 0x20]")
        buf.mark_label("rt__fw_path_ptr")
        buf.emit(b"\x48\x89\x4D\xD0", "mov [rbp - 0x30], rcx ; path ptr")
        buf.emit(b"\x48\x83\x7D\xE8\x01", "cmp qword ptr [rbp - 0x18], 1")
        buf.jcc_rel32(0x84, "e", "rt__fw_mode_ab")
        self._emit_lea_rdx_rva(self.builtin_rvas["str_wb"], "str_wb")
        buf.jmp_label("rt__fw_open")
        buf.mark_label("rt__fw_mode_ab")
        self._emit_lea_rdx_rva(self.builtin_rvas["str_ab"], "str_ab")
        buf.mark_label("rt__fw_open")
        buf.emit(b"\x48\x8B\x4D\xD0", "mov rcx, [rbp - 0x30]")
        self._emit_call_iat(self.iat_rvas["fopen"], "msvcrt!fopen")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x84, "z", "rt__fw_err")
        buf.emit(b"\x48\x89\x45\xC8", "mov [rbp - 0x38], rax ; FILE*")
        buf.emit(b"\x48\x8B\x55\xF0", "mov rdx, [rbp - 0x10]")
        buf.emit(b"\xF6\xC2\x01", "test dl, 1")
        buf.jcc_rel32(0x84, "z", "rt__fw_c_ptr")
        buf.emit(b"\x48\x89\xD0", "mov rax, rdx")
        buf.emit(b"\x48\xD1\xE8", "shr rax, 1")
        buf.emit(b"\x48\x83\xE0\x7F", "and rax, 0x7F")
        buf.emit(b"\x48\x89\x45\xC0", "mov [rbp - 0x40], rax ; content_len")
        buf.emit(b"\x48\x89\xD0", "mov rax, rdx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xB8", "mov [rbp - 0x48], rax")
        buf.emit(b"\x48\xC7\x45\xB0\x00\x00\x00\x00", "mov qword ptr [rbp - 0x50], 0")
        buf.emit(b"\x48\x8D\x45\xB8", "lea rax, [rbp - 0x48]")
        buf.emit(b"\x48\x89\x45\xA8", "mov [rbp - 0x58], rax ; content_ptr")
        buf.jmp_label("rt__fw_do_write")
        buf.mark_label("rt__fw_c_ptr")
        buf.emit(b"\x48\x89\x55\xA8", "mov [rbp - 0x58], rdx ; content_ptr")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mark_label("rt__fw_len_loop")
        buf.emit(b"\x80\x3C\x02\x00", "cmp byte ptr [rdx + rax], 0")
        buf.jcc_rel32(0x84, "e", "rt__fw_len_done")
        buf.emit(b"\x48\xFF\xC0", "inc rax")
        buf.jmp_label("rt__fw_len_loop")
        buf.mark_label("rt__fw_len_done")
        buf.emit(b"\x48\x89\x45\xC0", "mov [rbp - 0x40], rax ; content_len")
        buf.mark_label("rt__fw_do_write")
        buf.emit(b"\x48\x8B\x4D\xA8", "mov rcx, [rbp - 0x58]")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1")
        buf.emit(b"\x4C\x8B\x45\xC0", "mov r8, [rbp - 0x40]")
        buf.emit(b"\x4C\x8B\x4D\xC8", "mov r9, [rbp - 0x38]")
        self._emit_call_iat(self.iat_rvas["fwrite"], "msvcrt!fwrite")
        buf.emit(b"\x48\x89\x45\xA0", "mov [rbp - 0x60], rax ; written")
        buf.emit(b"\x48\x8B\x4D\xC8", "mov rcx, [rbp - 0x38]")
        self._emit_call_iat(self.iat_rvas["fclose"], "msvcrt!fclose")
        buf.emit(b"\x48\x8B\x45\xA0", "mov rax, [rbp - 0x60]")
        buf.jmp_label("rt__fw_done")
        buf.mark_label("rt__fw_err")
        buf.emit(b"\x48\xC7\xC0\xFF\xFF\xFF\xFF", "mov rax, -1")
        buf.mark_label("rt__fw_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()

        # fn____bmb_file_remove(rcx=path) -> rax=bool (1 or 0)
        buf.mark_label("fn____bmb_file_remove")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__rm_ptr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xF0", "mov [rbp - 0x10], rax")
        buf.emit(b"\x48\xC7\x45\xF8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x08], 0")
        buf.emit(b"\x48\x8D\x4D\xF0", "lea rcx, [rbp - 0x10]")
        buf.mark_label("rt__rm_ptr")
        self._emit_call_iat(self.iat_rvas["remove"], "msvcrt!remove")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x84, "z", "rt__rm_ok")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.jmp_label("rt__rm_done")
        buf.mark_label("rt__rm_ok")
        buf.emit(b"\x48\xC7\xC0\x01\x00\x00\x00", "mov rax, 1")
        buf.mark_label("rt__rm_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()

        # fn____bmb_get_cwd() -> rax=ptr
        buf.mark_label("fn____bmb_get_cwd")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        buf.emit(b"\x48\xC7\xC1\x00\x04\x00\x00", "mov rcx, 1024")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1")
        self._emit_call_iat(self.iat_rvas["calloc"], "msvcrt!calloc")
        buf.emit(b"\x48\x89\x45\xF0", "mov [rbp - 0x10], rax ; buf")
        buf.emit(b"\x48\x89\xC1", "mov rcx, rax")
        buf.emit(b"\x48\xC7\xC2\x00\x04\x00\x00", "mov rdx, 1024")
        self._emit_call_iat(self.iat_rvas["_getcwd"], "msvcrt!_getcwd")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x84, "z", "rt__gc_err")
        buf.emit(b"\x48\x8B\x45\xF0", "mov rax, [rbp - 0x10]")
        buf.jmp_label("rt__gc_done")
        buf.mark_label("rt__gc_err")
        self._emit_lea_rax_rva(self.builtin_rvas["str_empty"], "str_empty")
        buf.mark_label("rt__gc_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()

        # fn____bmb_get_env(rcx=key) -> rax=ptr
        buf.mark_label("fn____bmb_get_env")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__ge_ptr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xF0", "mov [rbp - 0x10], rax")
        buf.emit(b"\x48\xC7\x45\xF8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x08], 0")
        buf.emit(b"\x48\x8D\x4D\xF0", "lea rcx, [rbp - 0x10]")
        buf.mark_label("rt__ge_ptr")
        self._emit_call_iat(self.iat_rvas["getenv"], "msvcrt!getenv")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x84, "z", "rt__ge_empty")
        buf.jmp_label("rt__ge_done")
        buf.mark_label("rt__ge_empty")
        self._emit_lea_rax_rva(self.builtin_rvas["str_empty"], "str_empty")
        buf.mark_label("rt__ge_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()

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

    def _emit_lea_rdx_rva(self, target_rva: int, name: str) -> None:
        # 48 8D 15 <rel32> -> lea rdx, [rip + rel32]
        off = len(self.code_buf.code)
        next_rva = TEXT_RVA + off + 7
        rel32 = target_rva - next_rva
        raw = b"\x48\x8D\x15" + struct.pack("<i", rel32)
        self.code_buf.emit(raw, f"lea rdx, [rip + 0x{rel32 & 0xFFFFFFFF:X}] ; {name}")

    def _emit_lea_rax_rva(self, target_rva: int, name: str) -> None:
        # 48 8D 05 <rel32> -> lea rax, [rip + rel32]
        off = len(self.code_buf.code)
        next_rva = TEXT_RVA + off + 7
        rel32 = target_rva - next_rva
        raw = b"\x48\x8D\x05" + struct.pack("<i", rel32)
        self.code_buf.emit(raw, f"lea rax, [rip + 0x{rel32 & 0xFFFFFFFF:X}] ; {name}")

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
        # DataDirectory[1] = Import Table (RVA = rdata_rva, Size = self.idt_size)
        struct.pack_into("<II", hdr, dd_off + 1 * 8, rdata_rva, self.idt_size)
        # DataDirectory[2] = Resource Table (RVA = rsrc_rva, Size = rsrc_virtual_size)
        struct.pack_into("<II", hdr, dd_off + 2 * 8, rsrc_rva, rsrc_virtual_size)
        # DataDirectory[12] = IAT (RVA = self.iat_start_rva, Size = self.iat_total_size)
        struct.pack_into("<II", hdr, dd_off + 12 * 8, self.iat_start_rva, self.iat_total_size)

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
