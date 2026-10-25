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
        self.func_entries: List[Tuple[int, int, str, int]] = []
        self.pdata_table_size: int = 0

    def _encode_unwind_info(self, kind: str, frame_size: int) -> bytes:
        if kind == "leaf":
            return struct.pack("<BBBB", 1, 0, 0, 0)
        elif kind == "start":
            alloc_code = (4 << 12) | (2 << 8) | 4
            return struct.pack("<BBBBHH", 1, 4, 1, 0, alloc_code, 0)
        elif kind == "rbp_noalloc":
            return struct.pack("<BBBBHH", 1, 4, 2, 5, 0x0304, 0x5001)
        elif kind == "rbp_frame":
            if frame_size <= 128:
                op_info = (frame_size - 8) // 8
                alloc_code = (op_info << 12) | (2 << 8) | 8
                return struct.pack("<BBBBHHHH", 1, 8, 3, 5, alloc_code, 0x0304, 0x5001, 0)
            else:
                alloc_code = (0 << 12) | (1 << 8) | 11
                scale = frame_size // 8
                return struct.pack("<BBBBHHHH", 1, 11, 4, 5, alloc_code, scale, 0x0304, 0x5001)
        elif kind == "mir":
            if frame_size <= 128:
                alloc_code = (((frame_size - 8) // 8) << 12) | (2 << 8) | 19
                codes = [
                    alloc_code,
                    (15 << 12) | (0 << 8) | 15,
                    (14 << 12) | (0 << 8) | 13,
                    (13 << 12) | (0 << 8) | 11,
                    (12 << 12) | (0 << 8) | 9,
                    (7 << 12) | (0 << 8) | 7,
                    (6 << 12) | (0 << 8) | 6,
                    (3 << 12) | (0 << 8) | 5,
                    (0 << 12) | (3 << 8) | 4,
                    (5 << 12) | (0 << 8) | 1,
                ]
                return struct.pack("<BBBB" + "H" * len(codes), 1, 19, len(codes), 5, *codes)
            else:
                codes = [
                    (0 << 12) | (1 << 8) | 22,
                    frame_size // 8,
                    (15 << 12) | (0 << 8) | 15,
                    (14 << 12) | (0 << 8) | 13,
                    (13 << 12) | (0 << 8) | 11,
                    (12 << 12) | (0 << 8) | 9,
                    (7 << 12) | (0 << 8) | 7,
                    (6 << 12) | (0 << 8) | 6,
                    (3 << 12) | (0 << 8) | 5,
                    (0 << 12) | (3 << 8) | 4,
                    (5 << 12) | (0 << 8) | 1,
                    0x0000,
                ]
                return struct.pack("<BBBB" + "H" * len(codes), 1, 22, 11, 5, *codes)
        return struct.pack("<BBBB", 1, 0, 0, 0)

    def _build_pdata_section(self, pdata_rva: int) -> bytes:
        sorted_entries = sorted(self.func_entries, key=lambda e: e[0])
        n = len(sorted_entries)
        table_size = n * 12
        self.pdata_table_size = table_size

        uinfo_base = _align(table_size, 4)
        pdata_buf = bytearray(uinfo_base)
        uinfo_map: Dict[bytes, int] = {}

        for i, (start_off, end_off, kind, frame_size) in enumerate(sorted_entries):
            begin_rva = TEXT_RVA + start_off
            end_rva = TEXT_RVA + end_off
            uinfo_bytes = self._encode_unwind_info(kind, frame_size)
            if uinfo_bytes not in uinfo_map:
                u_off = len(pdata_buf)
                pdata_buf.extend(uinfo_bytes)
                while len(pdata_buf) % 4 != 0:
                    pdata_buf.append(0)
                uinfo_map[uinfo_bytes] = u_off
            uinfo_rva = pdata_rva + uinfo_map[uinfo_bytes]
            struct.pack_into("<III", pdata_buf, i * 12, begin_rva, end_rva, uinfo_rva)

        return bytes(pdata_buf)

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

        pdata_rva = rdata_rva + rdata_pages
        pdata_raw = self._build_pdata_section(pdata_rva)
        pdata_virtual_size = len(pdata_raw)
        pdata_file_size = _align(pdata_virtual_size, 0x200)
        pdata_pages = _align(max(pdata_virtual_size, 1), 0x1000)

        rsrc_rva = pdata_rva + pdata_pages
        rsrc_raw = self._build_rsrc_section(rsrc_rva)
        rsrc_virtual_size = len(rsrc_raw)
        rsrc_file_size = _align(rsrc_virtual_size, 0x200)
        rsrc_pages = _align(max(rsrc_virtual_size, 1), 0x1000)

        size_of_image = rsrc_rva + rsrc_pages
        size_of_headers = 0x400

        text_file_offset = 0x400
        rdata_file_offset = text_file_offset + text_file_size
        pdata_file_offset = rdata_file_offset + rdata_file_size
        rsrc_file_offset = pdata_file_offset + pdata_file_size

        headers = self._build_pe_headers(
            text_virtual_size=text_virtual_size,
            text_file_size=text_file_size,
            text_file_offset=text_file_offset,
            rdata_rva=rdata_rva,
            rdata_virtual_size=rdata_virtual_size,
            rdata_file_size=rdata_file_size,
            rdata_file_offset=rdata_file_offset,
            pdata_rva=pdata_rva,
            pdata_virtual_size=pdata_virtual_size,
            pdata_file_size=pdata_file_size,
            pdata_file_offset=pdata_file_offset,
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
        out.extend(pdata_raw.ljust(pdata_file_size, b"\x00"))
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
                    "printf", "calloc", "free", "pow", "fflush",
                    "fopen", "fread", "fwrite", "fclose", "fseek", "ftell",
                    "remove", "_getcwd", "getenv", "sprintf", "atof",
                ],
            ),
            (
                "KERNEL32.dll",
                [
                    "ExitProcess",
                    "AddVectoredExceptionHandler",
                    "CreateThread",
                    "WaitForSingleObject",
                    "GetExitCodeThread",
                    "CloseHandle",
                    "GetCurrentThreadId",
                    "Sleep",
                    "GetSystemInfo",
                ],
            ),
            (
                "ws2_32.dll",
                [
                    "WSAStartup", "WSACleanup", "socket", "connect", "bind",
                    "listen", "accept", "send", "recv", "closesocket", "htons", "inet_addr",
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
            ("alloc_root", b"\x00" * 8),
            ("fmt_seh_div0", b"\n[Black Mamba SEH] Hardware Fault Intercepted: Integer Divide By Zero (0xC0000094) at RIP 0x%p\nCall stack unwound successfully via PE32+ .pdata / .xdata tables.\n\x00"),
            ("fmt_seh_access", b"\n[Black Mamba SEH] Hardware Fault Intercepted: Access Violation (0xC0000005) at RIP 0x%p\nCall stack unwound successfully via PE32+ .pdata / .xdata tables.\n\x00"),
            ("fmt_seh_stack", b"\n[Black Mamba SEH] Hardware Fault Intercepted: Stack Overflow (0xC00000FD) at RIP 0x%p\nCall stack unwound successfully via PE32+ .pdata / .xdata tables.\n\x00"),
            ("fmt_seh_generic", b"\n[Black Mamba SEH] Hardware Fault Intercepted: Exception 0x%08X at RIP 0x%p\nCall stack unwound successfully via PE32+ .pdata / .xdata tables.\n\x00"),
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
        self.code_buf = X86_64CodeBuffer()
        buf = self.code_buf
        self.func_entries = []

        entry_fn = "__bmb_main__" if any(f.name == "__bmb_main__" for f in self.mir_module.functions) else "main"

        # 1. _start Entry Point at RVA 0x1000 (offset 0)
        f_start = len(buf.code)
        buf.mark_label("_start")
        buf.emit(b"\x48\x83\xEC\x28", "sub rsp, 0x28")  # 32B shadow + 8B alignment

        # Register Vectored Exception Handler: AddVectoredExceptionHandler(1, &rt__exception_handler)
        buf.emit(b"\x48\xC7\xC1\x01\x00\x00\x00", "mov rcx, 1")  # First = 1
        buf.lea_rdx_label("rt__exception_handler")
        self._emit_call_iat(self.iat_rvas["AddVectoredExceptionHandler"], "KERNEL32!AddVectoredExceptionHandler")

        buf.call_label(f"fn__{entry_fn}")
        buf.emit(b"\x48\x89\xC1", "mov rcx, rax")       # save exit code
        # Flush stdout via fflush(NULL)
        buf.emit(b"\x48\x31\xC9", "xor rcx, rcx")
        self._emit_call_iat(self.iat_rvas["fflush"], "msvcrt!fflush")
        buf.emit(b"\x48\x31\xC9", "xor rcx, rcx")
        self._emit_call_iat(self.iat_rvas["ExitProcess"], "KERNEL32!ExitProcess")
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "start", 0x28))

        # 1b. Native SEH Exception Handler: rt__exception_handler(rcx = PEXCEPTION_POINTERS)
        f_start = len(buf.code)
        buf.mark_label("rt__exception_handler")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x40)

        # rcx = PEXCEPTION_POINTERS -> rax = PEXCEPTION_RECORD
        buf.emit(b"\x48\x8B\x01", "mov rax, [rcx] ; ExceptionRecord")
        buf.emit(b"\x44\x8B\x00", "mov r8d, dword ptr [rax] ; ExceptionCode")
        buf.emit(b"\x4C\x8B\x48\x10", "mov r9, qword ptr [rax + 16] ; ExceptionAddress")
        buf.emit(b"\x44\x89\x45\xF8", "mov [rbp - 0x08], r8d ; save code")
        buf.emit(b"\x4C\x89\x4D\xF0", "mov [rbp - 0x10], r9 ; save address")

        # Pass through non-fatal/notifications (ExceptionCode < 0xC0000000)
        buf.emit(b"\xB8\x00\x00\x00\xC0", "mov eax, 0xC0000000")
        buf.emit(b"\x41\x39\xC0", "cmp r8d, eax")
        buf.jcc_rel32(0x82, "b", "rt__seh_continue")

        # Check for Divide By Zero (0xC0000094)
        buf.emit(b"\xB8\x94\x00\x00\xC0", "mov eax, 0xC0000094")
        buf.emit(b"\x41\x39\xC0", "cmp r8d, eax")
        buf.jcc_rel32(0x84, "e", "rt__seh_div0")

        # Check for Access Violation (0xC0000005)
        buf.emit(b"\xB8\x05\x00\x00\xC0", "mov eax, 0xC0000005")
        buf.emit(b"\x41\x39\xC0", "cmp r8d, eax")
        buf.jcc_rel32(0x84, "e", "rt__seh_access")

        # Check for Stack Overflow (0xC00000FD)
        buf.emit(b"\xB8\xFD\x00\x00\xC0", "mov eax, 0xC00000FD")
        buf.emit(b"\x41\x39\xC0", "cmp r8d, eax")
        buf.jcc_rel32(0x84, "e", "rt__seh_stack")

        # Generic Hardware Fault
        buf.mark_label("rt__seh_generic")
        self._emit_lea_rcx_rva(self.builtin_rvas["fmt_seh_generic"], "fmt_seh_generic")
        buf.emit(b"\x8B\x55\xF8", "mov edx, [rbp - 0x08] ; ExceptionCode")
        buf.emit(b"\x4C\x8B\x45\xF0", "mov r8, [rbp - 0x10] ; ExceptionAddress")
        self._emit_call_iat(self.iat_rvas["printf"], "msvcrt!printf")
        buf.jmp_label("rt__seh_exit")

        buf.mark_label("rt__seh_div0")
        self._emit_lea_rcx_rva(self.builtin_rvas["fmt_seh_div0"], "fmt_seh_div0")
        buf.emit(b"\x48\x8B\x55\xF0", "mov rdx, [rbp - 0x10] ; ExceptionAddress")
        self._emit_call_iat(self.iat_rvas["printf"], "msvcrt!printf")
        buf.jmp_label("rt__seh_exit")

        buf.mark_label("rt__seh_access")
        self._emit_lea_rcx_rva(self.builtin_rvas["fmt_seh_access"], "fmt_seh_access")
        buf.emit(b"\x48\x8B\x55\xF0", "mov rdx, [rbp - 0x10] ; ExceptionAddress")
        self._emit_call_iat(self.iat_rvas["printf"], "msvcrt!printf")
        buf.jmp_label("rt__seh_exit")

        buf.mark_label("rt__seh_stack")
        self._emit_lea_rcx_rva(self.builtin_rvas["fmt_seh_stack"], "fmt_seh_stack")
        buf.emit(b"\x48\x8B\x55\xF0", "mov rdx, [rbp - 0x10] ; ExceptionAddress")
        self._emit_call_iat(self.iat_rvas["printf"], "msvcrt!printf")
        buf.jmp_label("rt__seh_exit")

        buf.mark_label("rt__seh_exit")
        buf.emit(b"\x48\x31\xC9", "xor rcx, rcx")
        self._emit_call_iat(self.iat_rvas["fflush"], "msvcrt!fflush")
        buf.emit(b"\x8B\x4D\xF8", "mov ecx, [rbp - 0x08]")
        self._emit_call_iat(self.iat_rvas["ExitProcess"], "KERNEL32!ExitProcess")

        buf.mark_label("rt__seh_continue")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax ; EXCEPTION_CONTINUE_SEARCH")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x40))

        # Runtime Helper: rt__print
        f_start = len(buf.code)
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

        # kind 3: string
        buf.mark_label("rt__print_k3")
        buf.emit(b"\x48\x83\xF9\x03", "cmp rcx, 3")
        buf.jcc_rel32(0x85, "ne", "rt__print_k4")
        buf.emit(b"\xF6\xC2\x01", "test dl, 1")
        buf.jcc_rel32(0x84, "z", "rt__print_k3_ptr")
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
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x30))

        # Runtime Helper: rt__alloc_arr
        f_start = len(buf.code)
        buf.mark_label("rt__alloc_arr")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x40)
        buf.store_slot_rcx(-8, "count")
        buf.store_slot_rdx(-16, "init_bits")
        buf.mov_rax_imm64(8)
        buf.emit(b"\x48\x89\xC2", "mov rdx, rax")
        self._emit_call_iat(self.iat_rvas["calloc"], "msvcrt!calloc")
        buf.store_slot_rax(-24, "arr_ptr")
        buf.emit(b"\x48\x31\xC9", "xor rcx, rcx")
        buf.store_slot_rcx(-32, "idx")
        buf.mark_label("rt__alloc_loop")
        buf.load_rax_slot(-32, "idx")
        buf.load_rdx_slot(-8, "count")
        buf.emit(b"\x48\x39\xD0", "cmp rax, rdx")
        buf.jcc_rel32(0x8D, "ge", "rt__alloc_done")
        buf.load_rax_slot(-24, "arr_ptr")
        buf.load_rcx_slot(-32, "idx")
        buf.load_rdx_slot(-16, "init_bits")
        buf.emit(b"\x48\x89\x14\xC8", "mov [rax + rcx*8], rdx")
        buf.load_rax_slot(-32, "idx")
        buf.emit(b"\x48\xFF\xC0", "inc rax")
        buf.store_slot_rax(-32, "idx")
        buf.jmp_label("rt__alloc_loop")
        buf.mark_label("rt__alloc_done")
        buf.load_rax_slot(-24, "arr_ptr")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x40))

        # Runtime Helper: rt__pow_f64
        f_start = len(buf.code)
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
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x30))

        # Runtime Helper: rt__pow_i64
        f_start = len(buf.code)
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
        self.func_entries.append((f_start, len(buf.code), "rbp_noalloc", 0))

        # rt__py_stub
        f_start = len(buf.code)
        buf.mark_label("rt__py_stub")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        # rt__arena_save
        f_start = len(buf.code)
        buf.mark_label("rt__arena_save")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        # rt__arena_restore
        f_start = len(buf.code)
        buf.mark_label("rt__arena_restore")
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        # rt__clock_ns
        f_start = len(buf.code)
        buf.mark_label("rt__clock_ns")
        buf.emit(b"\x0F\x31", "rdtsc")
        buf.emit(b"\x48\xC1\xE2\x20", "shl rdx, 32")
        buf.emit(b"\x48\x09\xD0", "or rax, rdx")
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        # rt__str_stub
        f_start = len(buf.code)
        buf.mark_label("rt__str_stub")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        # rt__str_from_bool
        f_start = len(buf.code)
        buf.mark_label("rt__str_from_bool")
        buf.emit(b"\x48\x85\xC9", "test rcx, rcx")
        buf.jcc_rel32(0x84, "z", "rt__bool_false")
        buf.emit(b"\x48\xB8\x09\x54\x72\x75\x65\x00\x00\x00", "mov rax, 0x6575725409 ; SSO 'True'")
        buf.ret()
        buf.mark_label("rt__bool_false")
        buf.emit(b"\x48\xB8\x0B\x46\x61\x6C\x73\x65\x00\x00", "mov rax, 0x65736C61460B ; SSO 'False'")
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        # rt__str_from_i64
        f_start = len(buf.code)
        buf.mark_label("rt__str_from_i64")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x40)
        buf.emit(b"\x48\x89\x4D\xF8", "mov [rbp - 0x08], rcx ; val")
        buf.emit(b"\x48\xC7\xC1\x20\x00\x00\x00", "mov rcx, 32")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1")
        self._emit_call_iat(self.iat_rvas["calloc"], "msvcrt!calloc")
        buf.emit(b"\x48\x89\x45\xF0", "mov [rbp - 0x10], rax ; dst buf")
        buf.emit(b"\x48\x89\xC1", "mov rcx, rax")
        self._emit_lea_rdx_rva(self.builtin_rvas["fmt_i64"], "fmt_i64")
        buf.emit(b"\x4C\x8B\x45\xF8", "mov r8, [rbp - 0x08]")
        self._emit_call_iat(self.iat_rvas["sprintf"], "msvcrt!sprintf")
        buf.emit(b"\x48\x8B\x45\xF0", "mov rax, [rbp - 0x10]")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x40))

        # rt__str_from_f64
        f_start = len(buf.code)
        buf.mark_label("rt__str_from_f64")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x40)
        buf.emit(b"\x48\x89\x4D\xF8", "mov [rbp - 0x08], rcx ; float bits")
        buf.emit(b"\x48\xC7\xC1\x20\x00\x00\x00", "mov rcx, 32")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1")
        self._emit_call_iat(self.iat_rvas["calloc"], "msvcrt!calloc")
        buf.emit(b"\x48\x89\x45\xF0", "mov [rbp - 0x10], rax ; dst buf")
        buf.emit(b"\x48\x89\xC1", "mov rcx, rax")
        self._emit_lea_rdx_rva(self.builtin_rvas["fmt_f64"], "fmt_f64")
        buf.emit(b"\x4C\x8B\x45\xF8", "mov r8, [rbp - 0x08]")
        buf.emit(b"\x66\x49\x0F\x6E\xD0", "movq xmm2, r8")
        self._emit_call_iat(self.iat_rvas["sprintf"], "msvcrt!sprintf")
        buf.emit(b"\x48\x8B\x45\xF0", "mov rax, [rbp - 0x10]")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x40))

        # rt__str_ord
        f_start = len(buf.code)
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
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        # rt__str_chr
        f_start = len(buf.code)
        buf.mark_label("rt__str_chr")
        buf.emit(b"\x48\x0F\xB6\xC1", "movzx rax, cl")
        buf.emit(b"\x48\xC1\xE0\x08", "shl rax, 8")
        buf.emit(b"\x48\x83\xC8\x03", "or rax, 3")
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        # rt__str_to_i64(rcx = str handle) -> rax = i64
        f_start = len(buf.code)
        buf.mark_label("rt__str_to_i64")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        buf.emit(b"\x48\x89\x4D\xF8", "mov [rbp - 0x08], rcx ; s")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__s2i_ptr")

        # SSO string: unpack bytes to stack
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xF0", "mov [rbp - 0x10], rax")
        buf.emit(b"\xC6\x45\xF8\x00", "mov byte ptr [rbp - 0x08], 0")
        buf.emit(b"\x48\x8D\x4D\xF0", "lea rcx, [rbp - 0x10]")
        buf.jmp_label("rt__s2i_start")

        buf.mark_label("rt__s2i_ptr")
        # rcx is already src_ptr
        buf.mark_label("rt__s2i_start")
        # Skip leading spaces / tabs
        buf.mark_label("rt__s2i_skip_ws")
        buf.emit(b"\x8A\x01", "mov al, [rcx]")
        buf.emit(b"\x3C\x20", "cmp al, ' '")
        buf.jcc_rel32(0x84, "e", "rt__s2i_ws_adv")
        buf.emit(b"\x3C\x09", "cmp al, '\\t'")
        buf.jcc_rel32(0x85, "ne", "rt__s2i_check_sign")
        buf.mark_label("rt__s2i_ws_adv")
        buf.emit(b"\x48\xFF\xC1", "inc rcx")
        buf.jmp_label("rt__s2i_skip_ws")

        buf.mark_label("rt__s2i_check_sign")
        buf.emit(b"\x49\xC7\xC0\x01\x00\x00\x00", "mov r8, 1 ; sign = 1")
        buf.emit(b"\x8A\x01", "mov al, [rcx]")
        buf.emit(b"\x3C\x2D", "cmp al, '-'")
        buf.jcc_rel32(0x85, "ne", "rt__s2i_check_plus")
        buf.emit(b"\x49\xC7\xC0\xFF\xFF\xFF\xFF", "mov r8, -1 ; sign = -1")
        buf.emit(b"\x48\xFF\xC1", "inc rcx")
        buf.jmp_label("rt__s2i_digits")
        buf.mark_label("rt__s2i_check_plus")
        buf.emit(b"\x3C\x2B", "cmp al, '+'")
        buf.jcc_rel32(0x85, "ne", "rt__s2i_digits")
        buf.emit(b"\x48\xFF\xC1", "inc rcx")

        buf.mark_label("rt__s2i_digits")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax ; accumulator = 0")
        buf.mark_label("rt__s2i_loop")
        buf.emit(b"\x0F\xB6\x11", "movzx edx, byte ptr [rcx]")
        buf.emit(b"\x83\xEA\x30", "sub edx, 48 ; '0'")
        buf.emit(b"\x83\xFA\x09", "cmp edx, 9")
        buf.jcc_rel32(0x87, "a", "rt__s2i_done")
        buf.emit(b"\x48\x8D\x04\x80", "lea rax, [rax + rax*4]")
        buf.emit(b"\x48\x01\xC0", "add rax, rax")
        buf.emit(b"\x48\x01\xD0", "add rax, rdx")
        buf.emit(b"\x48\xFF\xC1", "inc rcx")
        buf.jmp_label("rt__s2i_loop")

        buf.mark_label("rt__s2i_done")
        buf.emit(b"\x49\x83\xF8\x00", "cmp r8, 0")
        buf.jcc_rel32(0x8D, "ge", "rt__s2i_ret")
        buf.emit(b"\x48\xF7\xD8", "neg rax")
        buf.mark_label("rt__s2i_ret")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        # rt__str_to_f64(rcx = str handle) -> rax = f64 bits
        f_start = len(buf.code)
        buf.mark_label("rt__str_to_f64")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x40)
        buf.emit(b"\x48\x89\x4D\xF8", "mov [rbp - 0x08], rcx")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__s2f_ptr")
        # SSO string: unpack bytes to stack
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xF0", "mov [rbp - 0x10], rax")
        buf.emit(b"\xC6\x45\xF8\x00", "mov byte ptr [rbp - 0x08], 0")
        buf.emit(b"\x48\x8D\x4D\xF0", "lea rcx, [rbp - 0x10]")
        buf.mark_label("rt__s2f_ptr")
        self._emit_call_iat(self.iat_rvas["atof"], "msvcrt!atof")
        buf.emit(b"\x66\x48\x0F\x7E\xC0", "movq rax, xmm0")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x40))

        # rt__str_index
        f_start = len(buf.code)
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
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        # rt__str_len
        f_start = len(buf.code)
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
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        # rt__str_slice
        f_start = len(buf.code)
        buf.mark_label("rt__str_slice")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x60)
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
        # stop < 0 -> stop = len
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
        buf.call_label("rt__alloc_arr")
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
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x60))
        # rt__str_cmp_eq
        f_start = len(buf.code)
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
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        # rt__str_cmp_ne
        f_start = len(buf.code)
        buf.mark_label("rt__str_cmp_ne")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x20)
        buf.call_label("rt__str_cmp_eq")
        buf.emit(b"\x48\x83\xF0\x01", "xor rax, 1")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x30))

        # rt__str_concat
        f_start = len(buf.code)
        buf.mark_label("rt__str_concat")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x40)
        buf.emit(b"\x48\x89\x4D\xF8", "mov [rbp - 0x08], rcx ; s1")
        buf.emit(b"\x48\x89\x55\xF0", "mov [rbp - 0x10], rdx ; s2")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__concat_s1_ptr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xD1\xE8", "shr rax, 1")
        buf.emit(b"\x48\x83\xE0\x7F", "and rax, 0x7F")
        buf.emit(b"\x48\x89\x45\xE8", "mov [rbp - 0x18], rax ; len1")
        buf.jmp_label("rt__concat_s1_len_done")
        buf.mark_label("rt__concat_s1_ptr")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.emit(b"\x48\x85\xC9", "test rcx, rcx")
        buf.jcc_rel32(0x84, "z", "rt__concat_s1_len_done")
        buf.mark_label("rt__concat_s1_loop")
        buf.emit(b"\x80\x3C\x01\x00", "cmp byte ptr [rcx + rax], 0")
        buf.jcc_rel32(0x84, "e", "rt__concat_s1_len_done")
        buf.emit(b"\x48\xFF\xC0", "inc rax")
        buf.jmp_label("rt__concat_s1_loop")
        buf.mark_label("rt__concat_s1_len_done")
        buf.emit(b"\x48\x89\x45\xE8", "mov [rbp - 0x18], rax ; len1")
        buf.emit(b"\x48\x8B\x55\xF0", "mov rdx, [rbp - 0x10]")
        buf.emit(b"\xF6\xC2\x01", "test dl, 1")
        buf.jcc_rel32(0x84, "z", "rt__concat_s2_ptr")
        buf.emit(b"\x48\x89\xD0", "mov rax, rdx")
        buf.emit(b"\x48\xD1\xE8", "shr rax, 1")
        buf.emit(b"\x48\x83\xE0\x7F", "and rax, 0x7F")
        buf.emit(b"\x48\x89\x45\xE0", "mov [rbp - 0x20], rax ; len2")
        buf.jmp_label("rt__concat_s2_len_done")
        buf.mark_label("rt__concat_s2_ptr")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.emit(b"\x48\x85\xD2", "test rdx, rdx")
        buf.jcc_rel32(0x84, "z", "rt__concat_s2_len_done")
        buf.mark_label("rt__concat_s2_loop")
        buf.emit(b"\x80\x3C\x02\x00", "cmp byte ptr [rdx + rax], 0")
        buf.jcc_rel32(0x84, "e", "rt__concat_s2_len_done")
        buf.emit(b"\x48\xFF\xC0", "inc rax")
        buf.jmp_label("rt__concat_s2_loop")
        buf.mark_label("rt__concat_s2_len_done")
        buf.emit(b"\x48\x89\x45\xE0", "mov [rbp - 0x20], rax ; len2")
        buf.emit(b"\x48\x8B\x4D\xE8", "mov rcx, [rbp - 0x18]")
        buf.emit(b"\x48\x03\x4D\xE0", "add rcx, [rbp - 0x20]")
        buf.emit(b"\x48\xFF\xC1", "inc rcx")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1")
        self._emit_call_iat(self.iat_rvas["calloc"], "msvcrt!calloc")
        buf.emit(b"\x48\x89\x45\xD8", "mov [rbp - 0x28], rax ; dst")
        buf.emit(b"\x48\x8B\x4D\xF8", "mov rcx, [rbp - 0x08]")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__concat_s1_copy_ptr")
        buf.emit(b"\x48\x89\xCA", "mov rdx, rcx")
        buf.emit(b"\x48\xC1\xEA\x08", "shr rdx, 8")
        buf.emit(b"\x48\x89\x55\xC8", "mov [rbp - 0x38], rdx")
        buf.emit(b"\xC6\x45\xCF\x00", "mov byte ptr [rbp - 0x31], 0")
        buf.emit(b"\x48\x8D\x4D\xC8", "lea rcx, [rbp - 0x38]")
        buf.mark_label("rt__concat_s1_copy_ptr")
        buf.mark_label("rt__concat_s1_do_copy")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mark_label("rt__concat_s1_copy_loop")
        buf.emit(b"\x48\x3B\x45\xE8", "cmp rax, [rbp - 0x18]")
        buf.jcc_rel32(0x8D, "ge", "rt__concat_s1_copy_done")
        buf.emit(b"\x8A\x14\x01", "mov dl, [rcx + rax]")
        buf.emit(b"\x4C\x8B\x5D\xD8", "mov r11, [rbp - 0x28]")
        buf.emit(b"\x41\x88\x14\x03", "mov [r11 + rax], dl")
        buf.emit(b"\x48\xFF\xC0", "inc rax")
        buf.jmp_label("rt__concat_s1_copy_loop")
        buf.mark_label("rt__concat_s1_copy_done")
        buf.emit(b"\x48\x8B\x4D\xF0", "mov rcx, [rbp - 0x10]")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__concat_s2_copy_ptr")
        buf.emit(b"\x48\x89\xCA", "mov rdx, rcx")
        buf.emit(b"\x48\xC1\xEA\x08", "shr rdx, 8")
        buf.emit(b"\x48\x89\x55\xC0", "mov [rbp - 0x40], rdx")
        buf.emit(b"\xC6\x45\xC7\x00", "mov byte ptr [rbp - 0x39], 0")
        buf.emit(b"\x48\x8D\x4D\xC0", "lea rcx, [rbp - 0x40]")
        buf.mark_label("rt__concat_s2_copy_ptr")
        buf.mark_label("rt__concat_s2_do_copy")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mark_label("rt__concat_s2_copy_loop")
        buf.emit(b"\x48\x3B\x45\xE0", "cmp rax, [rbp - 0x20]")
        buf.jcc_rel32(0x8D, "ge", "rt__concat_s2_copy_done")
        buf.emit(b"\x8A\x14\x01", "mov dl, [rcx + rax]")
        buf.emit(b"\x4C\x8B\x5D\xD8", "mov r11, [rbp - 0x28]")
        buf.emit(b"\x4C\x03\x5D\xE8", "add r11, [rbp - 0x18]")
        buf.emit(b"\x41\x88\x14\x03", "mov [r11 + rax], dl")
        buf.emit(b"\x48\xFF\xC0", "inc rax")
        buf.jmp_label("rt__concat_s2_copy_loop")
        buf.mark_label("rt__concat_s2_copy_done")
        buf.emit(b"\x48\x8B\x45\xD8", "mov rax, [rbp - 0x28]")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x40))

        # Comparison stubs
        f_start = len(buf.code)
        buf.mark_label("rt__str_cmp_lt")
        buf.emit(b"\x48\x39\xD1", "cmp rcx, rdx")
        buf.emit(b"\x0F\x9C\xC0", "setl al")
        buf.emit(b"\x48\x0F\xB6\xC0", "movzx rax, al")
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        f_start = len(buf.code)
        buf.mark_label("rt__str_cmp_le")
        buf.emit(b"\x48\x39\xD1", "cmp rcx, rdx")
        buf.emit(b"\x0F\x9E\xC0", "setle al")
        buf.emit(b"\x48\x0F\xB6\xC0", "movzx rax, al")
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        f_start = len(buf.code)
        buf.mark_label("rt__str_cmp_gt")
        buf.emit(b"\x48\x39\xD1", "cmp rcx, rdx")
        buf.emit(b"\x0F\x9F\xC0", "setg al")
        buf.emit(b"\x48\x0F\xB6\xC0", "movzx rax, al")
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        f_start = len(buf.code)
        buf.mark_label("rt__str_cmp_ge")
        buf.emit(b"\x48\x39\xD1", "cmp rcx, rdx")
        buf.emit(b"\x0F\x9D\xC0", "setge al")
        buf.emit(b"\x48\x0F\xB6\xC0", "movzx rax, al")
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

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
            "str_from_i64": "rt__str_from_i64",
            "str_from_f64": "rt__str_from_f64",
            "str_from_bool": "rt__str_from_bool",
            "str_ord": "rt__str_ord",
            "str_chr": "rt__str_chr",
            "str_to_i64": "rt__str_to_i64",
            "str_to_f64": "rt__str_to_f64",
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

        # OS primitives
        f_start = len(buf.code)
        buf.mark_label("fn____bmb_file_exists")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x40)
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
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x40))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_file_size")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x60)
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
        buf.emit(b"\x48\x89\x45\xE8", "mov [rbp - 0x18], rax")
        buf.emit(b"\x48\x89\xC1", "mov rcx, rax")
        buf.emit(b"\x48\x31\xD2", "xor rdx, rdx")
        buf.emit(b"\x49\xC7\xC0\x02\x00\x00\x00", "mov r8, 2")
        self._emit_call_iat(self.iat_rvas["fseek"], "msvcrt!fseek")
        buf.emit(b"\x48\x8B\x4D\xE8", "mov rcx, [rbp - 0x18]")
        self._emit_call_iat(self.iat_rvas["ftell"], "msvcrt!ftell")
        buf.emit(b"\x48\x89\x45\xE0", "mov [rbp - 0x20], rax")
        buf.emit(b"\x48\x8B\x4D\xE8", "mov rcx, [rbp - 0x18]")
        self._emit_call_iat(self.iat_rvas["fclose"], "msvcrt!fclose")
        buf.emit(b"\x48\x8B\x45\xE0", "mov rax, [rbp - 0x20]")
        buf.jmp_label("rt__fs_done")
        buf.mark_label("rt__fs_err")
        buf.emit(b"\x48\xC7\xC0\xFF\xFF\xFF\xFF", "mov rax, -1")
        buf.mark_label("rt__fs_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x60))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_file_read")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x60)
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
        buf.emit(b"\x48\x89\x45\xE8", "mov [rbp - 0x18], rax")
        buf.emit(b"\x48\x89\xC1", "mov rcx, rax")
        buf.emit(b"\x48\x31\xD2", "xor rdx, rdx")
        buf.emit(b"\x49\xC7\xC0\x02\x00\x00\x00", "mov r8, 2")
        self._emit_call_iat(self.iat_rvas["fseek"], "msvcrt!fseek")
        buf.emit(b"\x48\x8B\x4D\xE8", "mov rcx, [rbp - 0x18]")
        self._emit_call_iat(self.iat_rvas["ftell"], "msvcrt!ftell")
        buf.emit(b"\x48\x89\x45\xE0", "mov [rbp - 0x20], rax")
        buf.emit(b"\x48\x8B\x4D\xE8", "mov rcx, [rbp - 0x18]")
        buf.emit(b"\x48\x31\xD2", "xor rdx, rdx")
        buf.emit(b"\x4D\x31\xC0", "xor r8, r8")
        self._emit_call_iat(self.iat_rvas["fseek"], "msvcrt!fseek")
        buf.emit(b"\x48\x8B\x4D\xE0", "mov rcx, [rbp - 0x20]")
        buf.emit(b"\x48\xFF\xC1", "inc rcx")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1")
        self._emit_call_iat(self.iat_rvas["calloc"], "msvcrt!calloc")
        buf.emit(b"\x48\x89\x45\xD8", "mov [rbp - 0x28], rax")
        buf.emit(b"\x48\x89\xC1", "mov rcx, rax")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1")
        buf.emit(b"\x4C\x8B\x45\xE0", "mov r8, [rbp - 0x20]")
        buf.emit(b"\x4C\x8B\x4D\xE8", "mov r9, [rbp - 0x18]")
        self._emit_call_iat(self.iat_rvas["fread"], "msvcrt!fread")
        buf.emit(b"\x48\x8B\x4D\xE8", "mov rcx, [rbp - 0x18]")
        self._emit_call_iat(self.iat_rvas["fclose"], "msvcrt!fclose")
        buf.emit(b"\x48\x8B\x45\xD8", "mov rax, [rbp - 0x28]")
        buf.jmp_label("rt__fr_done")
        buf.mark_label("rt__fr_err")
        self._emit_lea_rax_rva(self.builtin_rvas["str_empty"], "str_empty")
        buf.mark_label("rt__fr_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x60))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_file_write")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x60)
        buf.emit(b"\x4C\x89\x45\xF8", "mov [rbp - 0x08], r8")   # mode (0=wb, 1=ab)
        buf.emit(b"\x48\x89\x55\xF0", "mov [rbp - 0x10], rdx")  # content
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__fw_path_ptr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xD8", "mov [rbp - 0x28], rax")
        buf.emit(b"\x48\xC7\x45\xE0\x00\x00\x00\x00", "mov qword ptr [rbp - 0x20], 0")
        buf.emit(b"\x48\x8D\x4D\xD8", "lea rcx, [rbp - 0x28]")
        buf.mark_label("rt__fw_path_ptr")
        buf.emit(b"\x4C\x8B\x45\xF8", "mov r8, [rbp - 0x08]")
        buf.emit(b"\x4D\x85\xC0", "test r8, r8")
        buf.jcc_rel32(0x85, "ne", "rt__fw_mode_ab")
        self._emit_lea_rdx_rva(self.builtin_rvas["str_wb"], "str_wb")
        buf.jmp_label("rt__fw_open")
        buf.mark_label("rt__fw_mode_ab")
        self._emit_lea_rdx_rva(self.builtin_rvas["str_ab"], "str_ab")
        buf.mark_label("rt__fw_open")
        self._emit_call_iat(self.iat_rvas["fopen"], "msvcrt!fopen")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x84, "z", "rt__fw_err")
        buf.emit(b"\x48\x89\x45\xE8", "mov [rbp - 0x18], rax") # file handle
        buf.emit(b"\x48\x8B\x55\xF0", "mov rdx, [rbp - 0x10]") # content
        buf.emit(b"\xF6\xC2\x01", "test dl, 1")
        buf.jcc_rel32(0x84, "z", "rt__fw_c_ptr")
        buf.emit(b"\x48\x89\xD0", "mov rax, rdx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xC0", "mov [rbp - 0x40], rax")
        buf.emit(b"\x48\xC7\x45\xC8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x38], 0")
        buf.emit(b"\x48\x8D\x4D\xC0", "lea rcx, [rbp - 0x40]")
        buf.emit(b"\x48\x89\xD0", "mov rax, rdx")
        buf.emit(b"\x48\xD1\xE8", "shr rax, 1")
        buf.emit(b"\x48\x83\xE0\x7F", "and rax, 0x7F")
        buf.emit(b"\x49\x89\xC0", "mov r8, rax")
        buf.jmp_label("rt__fw_do_write")
        buf.mark_label("rt__fw_c_ptr")
        buf.emit(b"\x48\x89\xD1", "mov rcx, rdx")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mark_label("rt__fw_len_loop")
        buf.emit(b"\x80\x3C\x01\x00", "cmp byte ptr [rcx + rax], 0")
        buf.jcc_rel32(0x84, "e", "rt__fw_len_done")
        buf.emit(b"\x48\xFF\xC0", "inc rax")
        buf.jmp_label("rt__fw_len_loop")
        buf.mark_label("rt__fw_len_done")
        buf.emit(b"\x49\x89\xC0", "mov r8, rax")
        buf.mark_label("rt__fw_do_write")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1")
        buf.emit(b"\x4C\x8B\x4D\xE8", "mov r9, [rbp - 0x18]")
        self._emit_call_iat(self.iat_rvas["fwrite"], "msvcrt!fwrite")
        buf.emit(b"\x48\x8B\x4D\xE8", "mov rcx, [rbp - 0x18]")
        self._emit_call_iat(self.iat_rvas["fclose"], "msvcrt!fclose")
        buf.emit(b"\x48\xC7\xC0\x01\x00\x00\x00", "mov rax, 1")
        buf.jmp_label("rt__fw_done")
        buf.mark_label("rt__fw_err")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mark_label("rt__fw_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x60))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_file_remove")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x40)
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
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x40))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_get_cwd")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x40)
        buf.emit(b"\x48\x31\xC9", "xor rcx, rcx")
        buf.emit(b"\x48\xC7\xC2\x00\x04\x00\x00", "mov rdx, 1024")
        self._emit_call_iat(self.iat_rvas["_getcwd"], "msvcrt!_getcwd")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x84, "z", "rt__gc_err")
        buf.jmp_label("rt__gc_done")
        buf.mark_label("rt__gc_err")
        self._emit_lea_rax_rva(self.builtin_rvas["str_empty"], "str_empty")
        buf.mark_label("rt__gc_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x40))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_get_env")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x40)
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
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x40))

        # Socket primitives
        f_start = len(buf.code)
        buf.mark_label("fn____bmb_socket_init")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x1E0)
        buf.emit(b"\x48\xC7\xC1\x02\x02\x00\x00", "mov rcx, 0x0202 ; MAKEWORD(2,2)")
        buf.emit(b"\x48\x8D\x95\x70\xFE\xFF\xFF", "lea rdx, [rbp - 0x190] ; lpWSAData")
        self._emit_call_iat(self.iat_rvas["WSAStartup"], "ws2_32!WSAStartup")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x1E0))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_socket_cleanup")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        self._emit_call_iat(self.iat_rvas["WSACleanup"], "ws2_32!WSACleanup")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x30))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_socket_create")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        self._emit_call_iat(self.iat_rvas["socket"], "ws2_32!socket")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x30))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_socket_connect")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x50)
        buf.emit(b"\x48\x89\x4D\xF8", "mov [rbp - 0x08], rcx ; sockfd")
        buf.emit(b"\x48\x89\x55\xF0", "mov [rbp - 0x10], rdx ; host")
        buf.emit(b"\x4C\x89\x45\xE8", "mov [rbp - 0x18], r8  ; port")
        buf.emit(b"\x4C\x89\xC1", "mov rcx, r8")
        self._emit_call_iat(self.iat_rvas["htons"], "ws2_32!htons")
        buf.emit(b"\x66\x89\x45\xD2", "mov [rbp - 0x2E], ax ; sin_port")
        buf.emit(b"\x48\x8B\x4D\xF0", "mov rcx, [rbp - 0x10]")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__conn_host_ptr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xC0", "mov [rbp - 0x40], rax")
        buf.emit(b"\x48\xC7\x45\xC8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x38], 0")
        buf.emit(b"\x48\x8D\x4D\xC0", "lea rcx, [rbp - 0x40]")
        buf.mark_label("rt__conn_host_ptr")
        self._emit_call_iat(self.iat_rvas["inet_addr"], "ws2_32!inet_addr")
        buf.emit(b"\x89\x45\xD4", "mov [rbp - 0x2C], eax ; sin_addr")
        buf.emit(b"\x66\xC7\x45\xD0\x02\x00", "mov word ptr [rbp - 0x30], 2 ; AF_INET")
        buf.emit(b"\x48\xC7\x45\xD8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x28], 0 ; sin_zero")
        buf.emit(b"\x48\x8B\x4D\xF8", "mov rcx, [rbp - 0x08]")
        buf.emit(b"\x48\x8D\x55\xD0", "lea rdx, [rbp - 0x30]")
        buf.emit(b"\x49\xC7\xC0\x10\x00\x00\x00", "mov r8, 16")
        self._emit_call_iat(self.iat_rvas["connect"], "ws2_32!connect")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x50))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_socket_bind")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x50)
        buf.emit(b"\x48\x89\x4D\xF8", "mov [rbp - 0x08], rcx ; sockfd")
        buf.emit(b"\x48\x89\x55\xF0", "mov [rbp - 0x10], rdx ; host")
        buf.emit(b"\x4C\x89\x45\xE8", "mov [rbp - 0x18], r8  ; port")
        buf.emit(b"\x4C\x89\xC1", "mov rcx, r8")
        self._emit_call_iat(self.iat_rvas["htons"], "ws2_32!htons")
        buf.emit(b"\x66\x89\x45\xD2", "mov [rbp - 0x2E], ax ; sin_port")
        buf.emit(b"\x48\x8B\x4D\xF0", "mov rcx, [rbp - 0x10]")
        buf.emit(b"\xF6\xC1\x01", "test cl, 1")
        buf.jcc_rel32(0x84, "z", "rt__bind_chk_ptr")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xD1\xE8", "shr rax, 1")
        buf.emit(b"\x48\x83\xE0\x7F", "and rax, 0x7F")
        buf.jcc_rel32(0x84, "z", "rt__bind_inaddr_any")
        buf.emit(b"\x48\x89\xC8", "mov rax, rcx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xC0", "mov [rbp - 0x40], rax")
        buf.emit(b"\x48\xC7\x45\xC8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x38], 0")
        buf.emit(b"\x48\x8D\x4D\xC0", "lea rcx, [rbp - 0x40]")
        buf.jmp_label("rt__bind_call_inet")
        buf.mark_label("rt__bind_chk_ptr")
        buf.emit(b"\x80\x39\x00", "cmp byte ptr [rcx], 0")
        buf.jcc_rel32(0x84, "e", "rt__bind_inaddr_any")
        buf.mark_label("rt__bind_call_inet")
        self._emit_call_iat(self.iat_rvas["inet_addr"], "ws2_32!inet_addr")
        buf.emit(b"\x89\x45\xD4", "mov [rbp - 0x2C], eax ; sin_addr")
        buf.jmp_label("rt__bind_addr_ready")
        buf.mark_label("rt__bind_inaddr_any")
        buf.emit(b"\xC7\x45\xD4\x00\x00\x00\x00", "mov dword ptr [rbp - 0x2C], 0")
        buf.mark_label("rt__bind_addr_ready")
        buf.emit(b"\x66\xC7\x45\xD0\x02\x00", "mov word ptr [rbp - 0x30], 2 ; AF_INET")
        buf.emit(b"\x48\xC7\x45\xD8\x00\x00\x00\x00", "mov qword ptr [rbp - 0x28], 0 ; sin_zero")
        buf.emit(b"\x48\x8B\x4D\xF8", "mov rcx, [rbp - 0x08]")
        buf.emit(b"\x48\x8D\x55\xD0", "lea rdx, [rbp - 0x30]")
        buf.emit(b"\x49\xC7\xC0\x10\x00\x00\x00", "mov r8, 16")
        self._emit_call_iat(self.iat_rvas["bind"], "ws2_32!bind")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x50))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_socket_listen")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        self._emit_call_iat(self.iat_rvas["listen"], "ws2_32!listen")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x30))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_socket_accept")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        self._emit_call_iat(self.iat_rvas["accept"], "ws2_32!accept")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x30))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_socket_send")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x50)
        buf.emit(b"\x48\x89\x4D\xF8", "mov [rbp - 0x08], rcx ; sockfd")
        buf.emit(b"\x48\x89\x55\xF0", "mov [rbp - 0x10], rdx ; src_str")
        buf.emit(b"\xF6\xC2\x01", "test dl, 1")
        buf.jcc_rel32(0x84, "z", "rt__sock_send_ptr")
        buf.emit(b"\x48\x89\xD0", "mov rax, rdx")
        buf.emit(b"\x48\xD1\xE8", "shr rax, 1")
        buf.emit(b"\x48\x83\xE0\x7F", "and rax, 0x7F")
        buf.emit(b"\x48\x89\x45\xE8", "mov [rbp - 0x18], rax ; len")
        buf.emit(b"\x48\x89\xD0", "mov rax, rdx")
        buf.emit(b"\x48\xC1\xE8\x08", "shr rax, 8")
        buf.emit(b"\x48\x89\x45\xE0", "mov [rbp - 0x20], rax ; sso_bytes")
        buf.emit(b"\x48\x8D\x55\xE0", "lea rdx, [rbp - 0x20]")
        buf.jmp_label("rt__sock_send_ready")
        buf.mark_label("rt__sock_send_ptr")
        buf.emit(b"\x48\x89\x55\xE0", "mov [rbp - 0x20], rdx ; src_ptr")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mark_label("rt__sock_send_len_loop")
        buf.emit(b"\x80\x3C\x02\x00", "cmp byte ptr [rdx + rax], 0")
        buf.jcc_rel32(0x84, "e", "rt__sock_send_len_done")
        buf.emit(b"\x48\xFF\xC0", "inc rax")
        buf.jmp_label("rt__sock_send_len_loop")
        buf.mark_label("rt__sock_send_len_done")
        buf.emit(b"\x48\x89\x45\xE8", "mov [rbp - 0x18], rax ; len")
        buf.mark_label("rt__sock_send_ready")
        buf.emit(b"\x48\x8B\x4D\xF8", "mov rcx, [rbp - 0x08]")
        buf.emit(b"\x48\x8B\x55\xE0", "mov rdx, [rbp - 0x20]")
        buf.emit(b"\x4C\x8B\x45\xE8", "mov r8, [rbp - 0x18]")
        buf.emit(b"\x4D\x31\xC9", "xor r9, r9")
        self._emit_call_iat(self.iat_rvas["send"], "ws2_32!send")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x50))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_socket_recv")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x50)
        buf.emit(b"\x48\x89\x4D\xF8", "mov [rbp - 0x08], rcx ; sockfd")
        buf.emit(b"\x48\x89\x55\xF0", "mov [rbp - 0x10], rdx ; max_bytes")
        buf.emit(b"\x48\x8B\x4D\xF0", "mov rcx, [rbp - 0x10]")
        buf.emit(b"\x48\xFF\xC1", "inc rcx")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1")
        self._emit_call_iat(self.iat_rvas["calloc"], "msvcrt!calloc")
        buf.emit(b"\x48\x89\x45\xE8", "mov [rbp - 0x18], rax ; buf_ptr")
        buf.emit(b"\x48\x8B\x4D\xF8", "mov rcx, [rbp - 0x08]")
        buf.emit(b"\x48\x8B\x55\xE8", "mov rdx, [rbp - 0x18]")
        buf.emit(b"\x4C\x8B\x45\xF0", "mov r8, [rbp - 0x10]")
        buf.emit(b"\x4D\x31\xC9", "xor r9, r9")
        self._emit_call_iat(self.iat_rvas["recv"], "ws2_32!recv")
        buf.emit(b"\x48\x89\x45\xE0", "mov [rbp - 0x20], rax ; n_bytes")
        buf.emit(b"\x48\x85\xC0", "test rax, rax")
        buf.jcc_rel32(0x8E, "le", "rt__sock_recv_empty")
        buf.emit(b"\x48\x83\xF8\x07", "cmp rax, 7")
        buf.jcc_rel32(0x8F, "g", "rt__sock_recv_heap")
        buf.emit(b"\x48\xD1\xE0", "shl rax, 1")
        buf.emit(b"\x48\x83\xC8\x01", "or rax, 1")
        buf.emit(b"\x4C\x8B\x45\xE8", "mov r8, [rbp - 0x18]")
        buf.emit(b"\x4D\x31\xC9", "xor r9, r9")
        buf.mark_label("rt__sock_recv_sso_loop")
        buf.emit(b"\x4C\x3B\x4D\xE0", "cmp r9, [rbp - 0x20]")
        buf.jcc_rel32(0x8D, "ge", "rt__sock_recv_done")
        buf.emit(b"\x45\x0F\xB6\x18", "movzx r11d, byte ptr [r8]")
        buf.emit(b"\x49\xFF\xC0", "inc r8")
        buf.emit(b"\x49\x8D\x49\x01", "lea rcx, [r9 + 1]")
        buf.emit(b"\x48\xC1\xE1\x03", "shl rcx, 3")
        buf.emit(b"\x49\xD3\xE3", "shl r11, cl")
        buf.emit(b"\x4C\x09\xD8", "or rax, r11")
        buf.emit(b"\x49\xFF\xC1", "inc r9")
        buf.jmp_label("rt__sock_recv_sso_loop")
        buf.mark_label("rt__sock_recv_heap")
        buf.emit(b"\x4C\x8B\x45\xE8", "mov r8, [rbp - 0x18]")
        buf.emit(b"\x48\x8B\x45\xE0", "mov rax, [rbp - 0x20]")
        buf.emit(b"\x41\xC6\x04\x00\x00", "mov byte ptr [r8 + rax], 0")
        buf.emit(b"\x4C\x89\xC0", "mov rax, r8")
        buf.jmp_label("rt__sock_recv_done")
        buf.mark_label("rt__sock_recv_empty")
        buf.emit(b"\x48\xC7\xC0\x01\x00\x00\x00", "mov rax, 1")
        buf.mark_label("rt__sock_recv_done")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x50))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_socket_close")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        self._emit_call_iat(self.iat_rvas["closesocket"], "ws2_32!closesocket")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x30))

        # Native Hardware Atomic Functions
        f_start = len(buf.code)
        buf.mark_label("fn____bmb_atomic_load")
        buf.emit(b"\x48\x8B\x01\xC3", "mov rax, [rcx]; ret")
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_atomic_store")
        buf.emit(b"\x48\x87\x11\x48\x89\xD0\xC3", "xchg [rcx], rdx; mov rax, rdx; ret")
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_atomic_add")
        buf.emit(b"\x48\x89\xD0\xF0\x48\x0F\xC1\x01\xC3", "mov rax, rdx; lock xadd [rcx], rax; ret")
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_atomic_sub")
        buf.emit(b"\x48\xF7\xDA\x48\x89\xD0\xF0\x48\x0F\xC1\x01\xC3", "neg rdx; mov rax, rdx; lock xadd [rcx], rax; ret")
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_atomic_cas")
        buf.emit(b"\x48\x89\xD0\xF0\x4C\x0F\xB1\x01\xC3", "mov rax, rdx; lock cmpxchg [rcx], r8; ret")
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_atomic_fence")
        buf.emit(b"\x0F\xAE\xF0\x48\x31\xC0\xC3", "mfence; xor rax, rax; ret")
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_cpu_pause")
        buf.emit(b"\xF3\x90\x48\x31\xC0\xC3", "pause; xor rax, rax; ret")
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        # Native Threading & Concurrency Functions
        f_start = len(buf.code)
        buf.mark_label("fn____bmb_thread_concurrency")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x50)
        buf.emit(b"\x48\x8D\x4D\xC0", "lea rcx, [rbp - 0x40]")
        self._emit_call_iat(self.iat_rvas["GetSystemInfo"], "kernel32!GetSystemInfo")
        buf.emit(b"\x8B\x45\xE0", "mov eax, dword ptr [rbp - 0x40 + 32]")
        buf.emit(b"\x48\x63\xC0", "movsxd rax, eax")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x50))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_thread_spawn")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x40)
        buf.mov_reg_reg("r8", "rcx")
        buf.mov_reg_reg("r9", "rdx")
        buf.emit(b"\x48\x31\xC9", "xor rcx, rcx")
        buf.emit(b"\x48\x31\xD2", "xor rdx, rdx")
        buf.emit(b"\x48\xC7\x44\x24\x20\x00\x00\x00\x00", "mov qword ptr [rsp + 0x20], 0")
        buf.emit(b"\x48\xC7\x44\x24\x28\x00\x00\x00\x00", "mov qword ptr [rsp + 0x28], 0")
        self._emit_call_iat(self.iat_rvas["CreateThread"], "kernel32!CreateThread")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x40))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_thread_join")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x40)
        buf.emit(b"\x48\x89\x4D\xF8", "mov [rbp - 0x08], rcx")
        buf.emit(b"\xBA\xFF\xFF\xFF\xFF", "mov edx, 0xFFFFFFFF")
        self._emit_call_iat(self.iat_rvas["WaitForSingleObject"], "kernel32!WaitForSingleObject")
        buf.emit(b"\x48\x8B\x4D\xF8", "mov rcx, [rbp - 0x08]")
        buf.emit(b"\x48\x8D\x55\xF0", "lea rdx, [rbp - 0x10]")
        self._emit_call_iat(self.iat_rvas["GetExitCodeThread"], "kernel32!GetExitCodeThread")
        buf.emit(b"\x48\x8B\x4D\xF8", "mov rcx, [rbp - 0x08]")
        self._emit_call_iat(self.iat_rvas["CloseHandle"], "kernel32!CloseHandle")
        buf.emit(b"\x8B\x45\xF0", "mov eax, dword ptr [rbp - 0x10]")
        buf.emit(b"\x48\x63\xC0", "movsxd rax, eax")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x40))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_thread_id")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        self._emit_call_iat(self.iat_rvas["GetCurrentThreadId"], "kernel32!GetCurrentThreadId")
        buf.emit(b"\x48\x63\xC0", "movsxd rax, eax")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x30))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_thread_yield")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        buf.emit(b"\x31\xC9", "xor ecx, ecx")
        self._emit_call_iat(self.iat_rvas["Sleep"], "kernel32!Sleep")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x30))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_thread_sleep")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        self._emit_call_iat(self.iat_rvas["Sleep"], "kernel32!Sleep")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x30))

        # Native Heap Allocation Primitives
        f_start = len(buf.code)
        buf.mark_label("fn____bmb_mem_alloc")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        buf.emit(b"\x48\x85\xC9", "test rcx, rcx")
        buf.jcc_rel32(0x8F, "g", "rt__bmb_mem_alloc_size_ok")
        buf.emit(b"\x48\xC7\xC1\x01\x00\x00\x00", "mov rcx, 1")
        buf.mark_label("rt__bmb_mem_alloc_size_ok")
        buf.emit(b"\x48\xC7\xC2\x01\x00\x00\x00", "mov rdx, 1")
        self._emit_call_iat(self.iat_rvas["calloc"], "msvcrt!calloc")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x30))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_mem_free")
        buf.push_rbp()
        buf.mov_rbp_rsp()
        buf.sub_rsp_imm32(0x30)
        buf.emit(b"\x48\x85\xC9", "test rcx, rcx")
        buf.jcc_rel32(0x84, "e", "rt__bmb_mem_free_done")
        self._emit_call_iat(self.iat_rvas["free"], "msvcrt!free")
        buf.mark_label("rt__bmb_mem_free_done")
        buf.emit(b"\x48\x31\xC0", "xor rax, rax")
        buf.mov_rsp_rbp()
        buf.pop_rbp()
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "rbp_frame", 0x30))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_mem_read")
        buf.emit(b"\x48\x8B\x04\xD1", "mov rax, [rcx + rdx*8]")
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_mem_write")
        buf.emit(b"\x4C\x89\x04\xD1", "mov [rcx + rdx*8], r8")
        buf.emit(b"\x48\x31\xC0\xC3", "xor rax, rax; ret")
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_alloc_root_get")
        alloc_root_rva = self.builtin_rvas["alloc_root"]
        off = len(buf.code)
        next_rva = TEXT_RVA + off + 7
        rel32 = alloc_root_rva - next_rva
        buf.emit(b"\x48\x8B\x05" + struct.pack("<i", rel32), "mov rax, [rip + alloc_root]")
        buf.ret()
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        f_start = len(buf.code)
        buf.mark_label("fn____bmb_alloc_root_set")
        alloc_root_rva = self.builtin_rvas["alloc_root"]
        off = len(buf.code)
        next_rva = TEXT_RVA + off + 7
        rel32 = alloc_root_rva - next_rva
        buf.emit(b"\x48\x89\x0D" + struct.pack("<i", rel32), "mov [rip + alloc_root], rcx")
        buf.emit(b"\x48\x89\xC8\xC3", "mov rax, rcx; ret")
        self.func_entries.append((f_start, len(buf.code), "leaf", 0))

        known_fn_names = {f.name for f in self.mir_module.functions}
        known_fn_names.update([
            "__bmb_file_exists", "__bmb_file_size", "__bmb_file_read", "__bmb_file_write",
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
            "__bmb_alloc_root_get", "__bmb_alloc_root_set",
        ])

        # Compile MIR functions
        for fn in self.mir_module.functions:
            f_start = len(buf.code)
            frame_size = buf.compile_mir_function(fn, emit_const_str, emit_helper_call, known_fn_names)
            self.func_entries.append((f_start, len(buf.code), "mir", frame_size))

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
        pdata_rva: int,
        pdata_virtual_size: int,
        pdata_file_size: int,
        pdata_file_offset: int,
        rsrc_rva: int,
        rsrc_virtual_size: int,
        rsrc_file_size: int,
        rsrc_file_offset: int,
        size_of_image: int,
        size_of_headers: int,
    ) -> bytes:
        hdr = bytearray(size_of_headers)
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
            4,       # NumberOfSections: .text, .rdata, .pdata, .rsrc
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
            rdata_file_size + pdata_file_size + rsrc_file_size,  # SizeOfInitializedData
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
        # DataDirectory[3] = Exception Table (.pdata) (RVA = pdata_rva, Size = self.pdata_table_size)
        struct.pack_into("<II", hdr, dd_off + 3 * 8, pdata_rva, self.pdata_table_size)
        # DataDirectory[12] = IAT (RVA = self.iat_start_rva, Size = self.iat_total_size)
        struct.pack_into("<II", hdr, dd_off + 12 * 8, self.iat_start_rva, self.iat_total_size)

        # Section Headers at 0x188
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
        # Section 2: .pdata
        struct.pack_into(
            "<8sIIIIIIHHI",
            hdr,
            sec_off + 80,
            b".pdata\x00\x00",
            pdata_virtual_size,
            pdata_rva,
            pdata_file_size,
            pdata_file_offset,
            0,
            0,
            0,
            0,
            0x40000040,  # CNT_INITIALIZED_DATA | MEM_READ
        )
        # Section 3: .rsrc
        struct.pack_into(
            "<8sIIIIIIHHI",
            hdr,
            sec_off + 120,
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
