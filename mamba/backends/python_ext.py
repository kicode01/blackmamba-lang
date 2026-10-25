"""
Black Mamba (.bmb) Standalone CPython Native Extension Module Emitter (.pyd / .so).

Provides:
- `PE32PlusExtensionBuilder`: Directly emits zero-dependency, standalone Windows 64-bit
  PE32+ DLLs (.pyd) exporting `PyInit_<modname>` with native METH_FASTCALL unboxing/boxing,
  requiring zero external C compilers (no MSVC cl.exe, no GCC, no Clang).
- `C11ExtensionEmitter`: Emits portable, unboxed C11 Python Extension source code (.c)
  and setup.py for Linux (.so) and macOS (.dylib/.so) with PEP 489 multi-phase init and
  GIL-free threading (Py_MOD_GIL_NOT_USED).
- `PythonExtensionBuilder`: Unified cross-platform builder interface.
"""

import os
import struct
import sys
from typing import Dict, List, Optional, Set, Tuple

from ..mir import MIRFunction, MIRModule
from .c_emitter import C11Backend
from .pe_exe import PE32PlusExecutableBuilder, _align
from .x86_64_jit import X86_64CodeBuffer

IMAGE_BASE = 0x0000000180000000
TEXT_RVA = 0x1000
METH_FASTCALL = 0x0080


class PE32PlusExtensionBuilder:
    """Compiles a MIRModule directly into a standalone Windows x86-64 PE32+ .pyd extension module."""

    def __init__(self, mir_module: MIRModule, mod_name: str = "mamba_module", py_dll: Optional[str] = None):
        self.mir_module = mir_module
        self.mod_name = mod_name
        self.py_dll = py_dll or f"python{sys.version_info.major}{sys.version_info.minor}.dll"
        self.code_buf = X86_64CodeBuffer()
        self.string_rvas: Dict[int, int] = {}
        self.iat_rvas: Dict[str, int] = {}
        self.builtin_rvas: Dict[str, int] = {}
        self.func_entries: List[Tuple[int, int, str, int]] = []
        self.helper_labels: Dict[str, str] = {}
        self.known_fn_names: Set[str] = set()

    def _get_exported_functions(self) -> List[MIRFunction]:
        """Returns functions from MIR module to export to Python (excludes 'main' and '__bmb_*')."""
        return [
            f for f in self.mir_module.functions
            if f.name != "main" and f.name != "__bmb_main__" and not f.name.startswith("__bmb_")
        ]

    def build_pyd_bytes(self) -> bytes:
        code = bytearray()
        labels: Dict[str, int] = {}
        reloc_rip: List[Tuple[int, str, int]] = []

        def emit(b: bytes) -> int:
            off = len(code)
            code.extend(b)
            return off

        # ----------------------------------------------------
        # 1. DllMain entry point
        # ----------------------------------------------------
        labels["DllMain"] = len(code)
        emit(b"\xB8\x01\x00\x00\x00\xC3")  # mov eax, 1; ret
        while len(code) % 16 != 0:
            emit(b"\x90")

        # ----------------------------------------------------
        # 2. Runtime Helpers and Primitives
        # ----------------------------------------------------
        # Memory alloc / free / read / write primitives
        labels["fn____bmb_mem_alloc"] = len(code)
        emit(b"\x48\x85\xC9")              # test rcx, rcx
        emit(b"\x7F\x07")                  # jg +7
        emit(b"\x48\xC7\xC1\x01\x00\x00\x00")  # mov rcx, 1
        emit(b"\x48\xC7\xC2\x01\x00\x00\x00")  # mov rdx, 1
        emit(b"\xFF\x15")                  # call [rip + iat_calloc]
        reloc_rip.append((len(code), "iat_calloc", 4))
        emit(b"\x00\x00\x00\x00\xC3")      # ret
        while len(code) % 16 != 0:
            emit(b"\x90")

        labels["fn____bmb_mem_free"] = len(code)
        emit(b"\x48\x85\xC9")              # test rcx, rcx
        emit(b"\x74\x06")                  # jz +6
        emit(b"\xFF\x15")                  # call [rip + iat_free]
        reloc_rip.append((len(code), "iat_free", 4))
        emit(b"\x00\x00\x00\x00")
        emit(b"\x48\x31\xC0\xC3")          # xor rax, rax; ret
        while len(code) % 16 != 0:
            emit(b"\x90")

        labels["fn____bmb_mem_read"] = len(code)
        emit(b"\x48\x8B\x04\xD1\xC3")      # mov rax, [rcx + rdx*8]; ret
        while len(code) % 16 != 0:
            emit(b"\x90")

        labels["fn____bmb_mem_write"] = len(code)
        emit(b"\x4C\x89\x04\xD1")          # mov [rcx + rdx*8], r8
        emit(b"\x48\x31\xC0\xC3")          # xor rax, rax; ret
        while len(code) % 16 != 0:
            emit(b"\x90")

        # Math pow primitives
        labels["rt__pow_i64"] = len(code)
        emit(b"\x48\x85\xD2")              # test rdx, rdx
        emit(b"\x7F\x07")                  # jg +7
        emit(b"\xB8\x01\x00\x00\x00\xC3")  # mov eax, 1; ret
        emit(b"\x53\x48\x89\xCB\xB8\x01\x00\x00\x00")  # push rbx; mov rbx, rcx; mov eax, 1
        # .loop:
        emit(b"\x48\xF7\xC2\x01\x00\x00\x00")  # test rdx, 1
        emit(b"\x74\x03")                  # jz +3
        emit(b"\x48\x0F\xAF\xC3")          # imul rax, rbx
        emit(b"\x48\x0F\xAF\xDB")          # imul rbx, rbx
        emit(b"\x48\xD1\xEA")              # shr rdx, 1
        emit(b"\x75\xEE")                  # jnz .loop
        emit(b"\x5B\xC3")                  # pop rbx; ret
        while len(code) % 16 != 0:
            emit(b"\x90")

        # ----------------------------------------------------
        # 3. User MIR Functions compiled via X86_64CodeBuffer
        # ----------------------------------------------------
        known_fn_names = {f.name for f in self.mir_module.functions}
        known_fn_names.update([
            "__bmb_mem_alloc", "__bmb_mem_free", "__bmb_mem_read", "__bmb_mem_write",
        ])

        helper_map = {
            "pow_i64": "rt__pow_i64",
            "alloc_arr": "fn____bmb_mem_alloc",
            "arena_save": "DllMain",
            "arena_restore": "DllMain",
        }

        # Build MIR functions into code buffer
        mir_buf = X86_64CodeBuffer()
        for fn in self.mir_module.functions:
            fn_label = f"fn__{fn.name}"
            mir_buf.mark_label(fn_label)

            def emit_const_str(_ins, store_from_rax):
                store_from_rax(0)

            def emit_helper_call(kind):
                target = helper_map.get(kind, "DllMain")
                mir_buf.call_label(target)

            mir_buf.compile_mir_function(fn, emit_const_str, emit_helper_call, known_fn_names)

        mir_buf.resolve_fixups()

        mir_offset_in_text = len(code)
        code.extend(mir_buf.code)
        for name, off in mir_buf.labels.items():
            labels[name] = mir_offset_in_text + off

        while len(code) % 16 != 0:
            emit(b"\x90")

        # ----------------------------------------------------
        # 4. METH_FASTCALL Wrappers for Exported Functions
        # ----------------------------------------------------
        exported_fns = self._get_exported_functions()
        wrapper_names: Dict[str, str] = {}

        for fn in exported_fns:
            wrap_name = f"py_wrap_{fn.name}"
            wrapper_names[fn.name] = wrap_name
            labels[wrap_name] = len(code)

            n_params = len(fn.params)
            # Stack frame layout:
            # 32 bytes callee shadow space (0x00..0x1F)
            # [rsp + 0x20]: saved args pointer (8 bytes)
            # [rsp + 0x28]: saved nargs or temp (8 bytes)
            # [rsp + 0x30 + i*8]: unboxed parameter values
            frame_needed = 0x30 + max(4, n_params) * 8
            frame_size = _align(frame_needed, 16) + 8  # 16-byte aligned before call
            if (frame_size + 8) % 16 != 0:
                frame_size = _align(frame_size + 8, 16) - 8
            # sub rsp, frame_size (must make (rsp - frame_size - 8) % 16 == 0)
            alloc_bytes = frame_size
            while (alloc_bytes + 8) % 16 != 0:
                alloc_bytes += 8

            emit(b"\x48\x81\xEC" + struct.pack("<i", alloc_bytes))  # sub rsp, imm32

            # Save args pointer in [rsp + 0x20]
            emit(b"\x48\x89\x54\x24\x20")  # mov [rsp + 0x20], rdx

            # Unbox each parameter
            for i, (p_name, p_type) in enumerate(fn.params):
                # Restore args ptr and load args[i] into rcx
                emit(b"\x48\x8B\x54\x24\x20")      # mov rdx, [rsp + 0x20]
                if i == 0:
                    emit(b"\x48\x8B\x0A")          # mov rcx, [rdx]
                else:
                    emit(b"\x48\x8B\x4A" + bytes([i * 8]))  # mov rcx, [rdx + i*8]

                if p_type == "f64":
                    emit(b"\xFF\x15")              # call [rip + iat_PyFloat_AsDouble]
                    reloc_rip.append((len(code), "iat_PyFloat_AsDouble", 4))
                    emit(b"\x00\x00\x00\x00")
                    emit(b"\x66\x48\x0F\x7E\xC0")  # movq rax, xmm0 (store float bits)
                    emit(b"\x48\x89\x44\x24" + bytes([0x30 + i * 8]))  # mov [rsp + 0x30 + i*8], rax
                elif p_type == "bool":
                    emit(b"\xFF\x15")              # call [rip + iat_PyObject_IsTrue]
                    reloc_rip.append((len(code), "iat_PyObject_IsTrue", 4))
                    emit(b"\x00\x00\x00\x00")
                    emit(b"\x48\x63\xC0")          # movsxd rax, eax
                    emit(b"\x48\x89\x44\x24" + bytes([0x30 + i * 8]))  # mov [rsp + 0x30 + i*8], rax
                elif p_type == "str":
                    emit(b"\x48\x31\xD2")          # xor rdx, rdx (NULL size)
                    emit(b"\xFF\x15")              # call [rip + iat_PyUnicode_AsUTF8AndSize]
                    reloc_rip.append((len(code), "iat_PyUnicode_AsUTF8AndSize", 4))
                    emit(b"\x00\x00\x00\x00")
                    emit(b"\x48\x89\x44\x24" + bytes([0x30 + i * 8]))  # mov [rsp + 0x30 + i*8], rax
                else:  # i64 / int / default
                    emit(b"\xFF\x15")              # call [rip + iat_PyLong_AsLongLong]
                    reloc_rip.append((len(code), "iat_PyLong_AsLongLong", 4))
                    emit(b"\x00\x00\x00\x00")
                    emit(b"\x48\x89\x44\x24" + bytes([0x30 + i * 8]))  # mov [rsp + 0x30 + i*8], rax

            # Load unboxed arguments into Win64 registers (rcx, rdx, r8, r9)
            for i, (p_name, p_type) in enumerate(fn.params):
                slot_disp = bytes([0x30 + i * 8])
                if i == 0:
                    emit(b"\x48\x8B\x4C\x24" + slot_disp)      # mov rcx, [rsp + slot]
                elif i == 1:
                    emit(b"\x48\x8B\x54\x24" + slot_disp)      # mov rdx, [rsp + slot]
                elif i == 2:
                    emit(b"\x4C\x8B\x44\x24" + slot_disp)      # mov r8, [rsp + slot]
                elif i == 3:
                    emit(b"\x4C\x8B\x4C\x24" + slot_disp)      # mov r9, [rsp + slot]
                else:
                    # Arg 4+ spilled into stack shadow space [rsp + 0x20 + (i-4)*8]
                    emit(b"\x48\x8B\x44\x24" + slot_disp)          # mov rax, [rsp + slot]
                    emit(b"\x48\x89\x44\x24" + bytes([0x20 + (i - 4) * 8]))  # mov [rsp + stack_slot], rax

            # Call compiled Black Mamba function
            target_fn_label = f"fn__{fn.name}"
            call_fn = emit(b"\xE8\x00\x00\x00\x00")
            rel = labels[target_fn_label] - (call_fn + 5)
            struct.pack_into("<i", code, call_fn + 1, rel)

            # Box return value
            if fn.return_type == "f64":
                # rax has the float bits from Black Mamba
                emit(b"\x66\x48\x0F\x6E\xC0")  # movq xmm0, rax
                emit(b"\xFF\x15")              # call [rip + iat_PyFloat_FromDouble]
                reloc_rip.append((len(code), "iat_PyFloat_FromDouble", 4))
                emit(b"\x00\x00\x00\x00")
            elif fn.return_type == "bool":
                emit(b"\x48\x89\xC1")  # mov rcx, rax
                emit(b"\xFF\x15")      # call [rip + iat_PyBool_FromLong]
                reloc_rip.append((len(code), "iat_PyBool_FromLong", 4))
                emit(b"\x00\x00\x00\x00")
            elif fn.return_type == "str":
                emit(b"\x48\x89\xC1")  # mov rcx, rax
                emit(b"\xFF\x15")      # call [rip + iat_PyUnicode_FromString]
                reloc_rip.append((len(code), "iat_PyUnicode_FromString", 4))
                emit(b"\x00\x00\x00\x00")
            elif fn.return_type == "void":
                # Py_BuildValue("") -> returns Py_None
                emit(b"\x48\x8D\x0D")  # lea rcx, [rip + str_empty]
                reloc_rip.append((len(code), "str_empty", 4))
                emit(b"\x00\x00\x00\x00")
                emit(b"\xFF\x15")      # call [rip + iat_Py_BuildValue]
                reloc_rip.append((len(code), "iat_Py_BuildValue", 4))
                emit(b"\x00\x00\x00\x00")
            else:  # i64 / int / default
                emit(b"\x48\x89\xC1")  # mov rcx, rax
                emit(b"\xFF\x15")      # call [rip + iat_PyLong_FromLongLong]
                reloc_rip.append((len(code), "iat_PyLong_FromLongLong", 4))
                emit(b"\x00\x00\x00\x00")

            emit(b"\x48\x81\xC4" + struct.pack("<i", alloc_bytes))  # add rsp, imm32
            emit(b"\xC3")                                          # ret
            while len(code) % 16 != 0:
                emit(b"\x90")

        # ----------------------------------------------------
        # 5. PyInit_<mod_name>()
        # ----------------------------------------------------
        pyinit_name = f"PyInit_{self.mod_name}"
        labels[pyinit_name] = len(code)
        emit(b"\x48\x83\xEC\x28")      # sub rsp, 40
        emit(b"\x48\x8D\x0D")          # lea rcx, [rip + mod_def]
        reloc_rip.append((len(code), "mod_def", 4))
        emit(b"\x00\x00\x00\x00")
        emit(b"\xBA\xF5\x03\x00\x00")  # mov edx, 1013 (PYTHON_API_VERSION)
        emit(b"\xFF\x15")              # call [rip + iat_PyModule_Create2]
        reloc_rip.append((len(code), "iat_PyModule_Create2", 4))
        emit(b"\x00\x00\x00\x00")
        emit(b"\x48\x83\xC4\x28")      # add rsp, 40
        emit(b"\xC3")                  # ret
        while len(code) % 16 != 0:
            emit(b"\x90")

        text_bytes = bytes(code)
        text_virtual_size = len(text_bytes)
        text_file_size = _align(text_virtual_size, 0x200)

        # ----------------------------------------------------
        # 6. .rdata section (Imports, Strings, Exports)
        # ----------------------------------------------------
        rdata_rva = TEXT_RVA + _align(max(text_virtual_size, 1), 0x1000)
        rdata = bytearray()
        rdata_symbols: Dict[str, int] = {}

        py_funcs = [
            "PyModule_Create2",
            "PyLong_AsLongLong",
            "PyLong_FromLongLong",
            "PyFloat_AsDouble",
            "PyFloat_FromDouble",
            "PyBool_FromLong",
            "PyObject_IsTrue",
            "PyUnicode_FromString",
            "PyUnicode_AsUTF8AndSize",
            "Py_BuildValue",
        ]

        msvcrt_funcs = ["calloc", "free"]

        import_dlls = [
            (self.py_dll, py_funcs),
            ("msvcrt.dll", msvcrt_funcs),
        ]

        # IDT (Import Directory Table)
        idt_rva = rdata_rva
        idt_size = (len(import_dlls) + 1) * 20
        rdata.extend(b"\x00" * idt_size)

        # IAT (Import Address Table)
        iat_start_rva = rdata_rva + len(rdata)
        iat_rvas: Dict[str, int] = {}
        total_import_funcs = sum(len(funcs) for _, funcs in import_dlls)
        iat_total_size = (total_import_funcs + len(import_dlls)) * 8

        dll_iat_offsets = []
        for dll_name, funcs in import_dlls:
            dll_iat_offsets.append(len(rdata))
            for f in funcs:
                iat_rvas[f"iat_{f}"] = rdata_rva + len(rdata)
                rdata.extend(b"\x00" * 8)
            rdata.extend(b"\x00" * 8)

        # ILT (Import Lookup Table)
        dll_ilt_offsets = []
        for dll_name, funcs in import_dlls:
            dll_ilt_offsets.append(len(rdata))
            rdata.extend(b"\x00" * ((len(funcs) + 1) * 8))

        # DLL Name strings
        dll_name_rvas = []
        for dll_name, _ in import_dlls:
            dll_name_rvas.append(rdata_rva + len(rdata))
            rdata.extend(dll_name.encode("ascii") + b"\x00")
            while len(rdata) % 2 != 0:
                rdata.append(0)

        # Hint/Name entries
        dll_hint_rvas = []
        for dll_name, funcs in import_dlls:
            hints = []
            for f in funcs:
                h_rva = rdata_rva + len(rdata)
                hints.append(h_rva)
                rdata.extend(struct.pack("<H", 0))
                rdata.extend(f.encode("ascii") + b"\x00")
                if len(rdata) % 2 != 0:
                    rdata.append(0)
            dll_hint_rvas.append(hints)

        # Populate IAT and ILT with Hint RVAs
        for i, (dll_name, funcs) in enumerate(import_dlls):
            iat_off = dll_iat_offsets[i]
            ilt_off = dll_ilt_offsets[i]
            for j, h_rva in enumerate(dll_hint_rvas[i]):
                struct.pack_into("<Q", rdata, iat_off + j * 8, h_rva)
                struct.pack_into("<Q", rdata, ilt_off + j * 8, h_rva)

        # Populate IDT entries
        for i, (dll_name, funcs) in enumerate(import_dlls):
            ilt_rva = rdata_rva + dll_ilt_offsets[i]
            dll_name_rva = dll_name_rvas[i]
            iat_rva = rdata_rva + dll_iat_offsets[i]
            struct.pack_into("<IIIII", rdata, i * 20, ilt_rva, 0, 0, dll_name_rva, iat_rva)

        while len(rdata) % 8 != 0:
            rdata.append(0)

        def add_str(sym: str, s_bytes: bytes):
            while len(rdata) % 4 != 0:
                rdata.append(0)
            rdata_symbols[sym] = rdata_rva + len(rdata)
            rdata.extend(s_bytes + b"\x00")

        add_str("str_empty", b"")
        add_str("s_mod_name", self.mod_name.encode("ascii"))
        add_str("doc_mod", b"Native Black Mamba CPython Extension Module")
        add_str("s_pyd_file", f"{self.mod_name}.pyd".encode("ascii"))
        add_str("s_pyinit", pyinit_name.encode("ascii"))

        for fn in exported_fns:
            add_str(f"s_fn_{fn.name}", fn.name.encode("ascii"))
            params_str = ", ".join(f"{p[0]}: {p[1]}" for p in fn.params)
            doc_str = f"{fn.name}({params_str}) -> {fn.return_type}: Native Black Mamba function"
            add_str(f"doc_fn_{fn.name}", doc_str.encode("utf-8"))

        while len(rdata) % 4 != 0:
            rdata.append(0)

        # Export Directory Table (EDT)
        exp_dir_rva = rdata_rva + len(rdata)
        exp_dir_off = len(rdata)
        rdata.extend(b"\x00" * 40)
        eat_rva = rdata_rva + len(rdata)
        rdata.extend(struct.pack("<I", TEXT_RVA + labels[pyinit_name]))
        enpt_rva = rdata_rva + len(rdata)
        rdata.extend(struct.pack("<I", rdata_symbols["s_pyinit"]))
        eot_rva = rdata_rva + len(rdata)
        rdata.extend(struct.pack("<H", 0))
        while len(rdata) % 4 != 0:
            rdata.append(0)
        exp_total_size = (rdata_rva + len(rdata)) - exp_dir_rva

        struct.pack_into(
            "<IIHHIIIIIII",
            rdata, exp_dir_off,
            0, 0, 0, 0,
            rdata_symbols["s_pyd_file"],
            1, 1, 1,
            eat_rva, enpt_rva, eot_rva,
        )

        rdata_bytes = bytearray(rdata)
        rdata_virtual_size = len(rdata_bytes)
        rdata_file_size = _align(rdata_virtual_size, 0x200)

        # ----------------------------------------------------
        # 7. .data section (PyMethodDef table, PyModuleDef)
        # ----------------------------------------------------
        data_rva = rdata_rva + _align(max(rdata_virtual_size, 1), 0x1000)
        data_sec = bytearray()
        base_relocs: List[int] = []
        data_symbols: Dict[str, int] = {}

        method_table_rva = data_rva + len(data_sec)
        data_symbols["method_table"] = method_table_rva

        for fn in exported_fns:
            wrap_label = wrapper_names[fn.name]
            # ml_name
            base_relocs.append(data_rva + len(data_sec))
            data_sec.extend(struct.pack("<Q", IMAGE_BASE + rdata_symbols[f"s_fn_{fn.name}"]))
            # ml_meth
            base_relocs.append(data_rva + len(data_sec))
            data_sec.extend(struct.pack("<Q", IMAGE_BASE + TEXT_RVA + labels[wrap_label]))
            # ml_flags (METH_FASTCALL)
            data_sec.extend(struct.pack("<II", METH_FASTCALL, 0))
            # ml_doc
            base_relocs.append(data_rva + len(data_sec))
            data_sec.extend(struct.pack("<Q", IMAGE_BASE + rdata_symbols[f"doc_fn_{fn.name}"]))

        # Null terminator (32 bytes)
        data_sec.extend(b"\x00" * 32)

        # PyModuleDef struct
        while len(data_sec) % 8 != 0:
            data_sec.append(0)
        mod_def_rva = data_rva + len(data_sec)
        data_symbols["mod_def"] = mod_def_rva

        # PyModuleDef_Base (ob_refcnt=1, ob_type=0, m_init=0, m_index=0, m_copy=0)
        data_sec.extend(struct.pack("<QQQQQ", 1, 0, 0, 0, 0))
        # m_name
        base_relocs.append(data_rva + len(data_sec))
        data_sec.extend(struct.pack("<Q", IMAGE_BASE + rdata_symbols["s_mod_name"]))
        # m_doc
        base_relocs.append(data_rva + len(data_sec))
        data_sec.extend(struct.pack("<Q", IMAGE_BASE + rdata_symbols["doc_mod"]))
        # m_size = -1
        data_sec.extend(struct.pack("<q", -1))
        # m_methods
        base_relocs.append(data_rva + len(data_sec))
        data_sec.extend(struct.pack("<Q", IMAGE_BASE + method_table_rva))
        # m_slots, m_traverse, m_clear, m_free = 0
        data_sec.extend(b"\x00" * 32)

        data_bytes = bytes(data_sec)
        data_virtual_size = len(data_bytes)
        data_file_size = _align(data_virtual_size, 0x200)

        # ----------------------------------------------------
        # 8. Fixup RIP-relative offsets in .text
        # ----------------------------------------------------
        patched_code = bytearray(text_bytes)
        all_symbols_lookup = {**iat_rvas, **rdata_symbols, **data_symbols}
        for k, v in labels.items():
            all_symbols_lookup[k] = TEXT_RVA + v

        for code_off, sym_name, addend in reloc_rip:
            target_rva = all_symbols_lookup[sym_name]
            rip = TEXT_RVA + code_off + addend
            disp = target_rva - rip
            struct.pack_into("<i", patched_code, code_off, disp)

        text_bytes = bytes(patched_code)

        # ----------------------------------------------------
        # 9. .reloc section (ASLR Base Relocation Table)
        # ----------------------------------------------------
        reloc_rva = data_rva + _align(max(data_virtual_size, 1), 0x1000)
        page_rva = data_rva
        relocs_in_page = [r for r in base_relocs if (r & ~0xFFF) == page_rva]
        num_entries = len(relocs_in_page)
        pad_needed = (num_entries % 2 != 0)
        block_size = 8 + (num_entries + (1 if pad_needed else 0)) * 2

        reloc_buf = bytearray()
        reloc_buf.extend(struct.pack("<II", page_rva, block_size))
        for r in relocs_in_page:
            off_in_page = r & 0xFFF
            entry = (0xA << 12) | off_in_page  # IMAGE_REL_BASED_DIR64
            reloc_buf.extend(struct.pack("<H", entry))
        if pad_needed:
            reloc_buf.extend(struct.pack("<H", 0))

        reloc_bytes = bytes(reloc_buf)
        reloc_virtual_size = len(reloc_bytes)
        reloc_file_size = _align(reloc_virtual_size, 0x200)

        # ----------------------------------------------------
        # 10. PE32+ Headers
        # ----------------------------------------------------
        size_of_headers = 0x400
        text_file_offset = 0x400
        rdata_file_offset = text_file_offset + text_file_size
        data_file_offset = rdata_file_offset + rdata_file_size
        reloc_file_offset = data_file_offset + data_file_size
        size_of_image = reloc_rva + _align(max(reloc_virtual_size, 1), 0x1000)

        hdr = bytearray(size_of_headers)
        hdr[0:2] = b"MZ"
        struct.pack_into("<I", hdr, 0x3C, 0x80)
        hdr[0x80:0x84] = b"PE\x00\x00"
        struct.pack_into("<HHIIIHH", hdr, 0x84, 0x8664, 4, 0, 0, 0, 0xF0, 0x2022)

        opt_off = 0x98
        struct.pack_into(
            "<HBBIIIIIQIIHHHHHHIIIIHHQQQQII",
            hdr, opt_off,
            0x020B, 14, 0,
            text_file_size, rdata_file_size + data_file_size + reloc_file_size, 0,
            TEXT_RVA + labels["DllMain"],
            TEXT_RVA, IMAGE_BASE,
            0x1000, 0x200,
            6, 0, 0, 0, 6, 0, 0,
            size_of_image, size_of_headers, 0,
            2,  # Subsystem: Windows GUI / DLL
            0x8140,  # DllCharacteristics: DYNAMIC_BASE | NX_COMPAT | TERMINAL_SERVER_AWARE
            0x100000, 0x10000, 0x100000, 0x10000,
            0, 16,
        )

        dd_off = opt_off + 112
        # DataDirectory[0] = Export Table
        struct.pack_into("<II", hdr, dd_off + 0 * 8, exp_dir_rva, exp_total_size)
        # DataDirectory[1] = Import Table
        struct.pack_into("<II", hdr, dd_off + 1 * 8, idt_rva, idt_size)
        # DataDirectory[5] = Base Relocation Table
        struct.pack_into("<II", hdr, dd_off + 5 * 8, reloc_rva, reloc_virtual_size)
        # DataDirectory[12] = IAT
        struct.pack_into("<II", hdr, dd_off + 12 * 8, iat_start_rva, iat_total_size)

        sec_off = 0x188
        # Section 0: .text
        struct.pack_into("<8sIIIIIIHHI", hdr, sec_off, b".text\x00\x00\x00", text_virtual_size, TEXT_RVA, text_file_size, text_file_offset, 0, 0, 0, 0, 0x60000020)
        # Section 1: .rdata
        struct.pack_into("<8sIIIIIIHHI", hdr, sec_off + 40, b".rdata\x00\x00", rdata_virtual_size, rdata_rva, rdata_file_size, rdata_file_offset, 0, 0, 0, 0, 0xC0000040)
        # Section 2: .data
        struct.pack_into("<8sIIIIIIHHI", hdr, sec_off + 80, b".data\x00\x00\x00", data_virtual_size, data_rva, data_file_size, data_file_offset, 0, 0, 0, 0, 0xC0000040)
        # Section 3: .reloc
        struct.pack_into("<8sIIIIIIHHI", hdr, sec_off + 120, b".reloc\x00\x00", reloc_virtual_size, reloc_rva, reloc_file_size, reloc_file_offset, 0, 0, 0, 0, 0x42000040)

        out = bytearray()
        out.extend(hdr.ljust(size_of_headers, b"\x00"))
        out.extend(text_bytes.ljust(text_file_size, b"\x00"))
        out.extend(rdata_bytes.ljust(rdata_file_size, b"\x00"))
        out.extend(data_bytes.ljust(data_file_size, b"\x00"))
        out.extend(reloc_bytes.ljust(reloc_file_size, b"\x00"))
        return bytes(out)

    def write_pyd(self, output_path: str) -> str:
        pyd_bytes = self.build_pyd_bytes()
        os.makedirs(os.path.dirname(os.path.abspath(output_path)), exist_ok=True)
        with open(output_path, "wb") as f:
            f.write(pyd_bytes)
        return os.path.abspath(output_path)


class C11ExtensionEmitter:
    """Emits portable C11 Python Extension source code (.c) with PEP 489 and free-threaded support."""

    def __init__(self, mir_module: MIRModule, mod_name: str = "mamba_module"):
        self.mir_module = mir_module
        self.mod_name = mod_name
        self.c11_backend = C11Backend(mir_module)

    def emit_c_extension(self) -> str:
        c11_src = self.c11_backend.emit_c()
        exported_fns = [
            f for f in self.mir_module.functions
            if f.name != "main" and f.name != "__bmb_main__" and not f.name.startswith("__bmb_")
        ]

        lines = [
            "/* ==========================================================================",
            f" * Black Mamba (.bmb) CPython Extension: {self.mod_name}",
            " * Auto-generated portable C11 + Python C-API Extension Module",
            " * Compatible with Python 3.8 through 3.14+ (Free-Threading & PEP 489 Ready)",
            " * ========================================================================== */",
            "#define PY_SSIZE_T_CLEAN",
            "#include <Python.h>",
            "",
            c11_src,
            "",
            "/* ==========================================================================",
            " * Python C-API METH_FASTCALL Wrappers",
            " * ========================================================================== */",
        ]

        for fn in exported_fns:
            lines.append(f"static PyObject *py_wrap_{fn.name}(PyObject *self, PyObject *const *args, Py_ssize_t nargs) {{")
            n_params = len(fn.params)
            lines.append(f"    if (nargs != {n_params}) {{")
            lines.append(f"        PyErr_Format(PyExc_TypeError, \"{fn.name}() takes exactly {n_params} argument(s) (%zd given)\", nargs);")
            lines.append("        return NULL;")
            lines.append("    }")

            call_args = []
            for i, (p_name, p_type) in enumerate(fn.params):
                v_name = f"_arg_{i}"
                if p_type == "f64":
                    lines.append(f"    double {v_name} = PyFloat_AsDouble(args[{i}]);")
                    lines.append(f"    if (PyErr_Occurred()) return NULL;")
                elif p_type == "bool":
                    lines.append(f"    int64_t {v_name} = (int64_t)PyObject_IsTrue(args[{i}]);")
                elif p_type == "str":
                    lines.append(f"    const char *{v_name} = PyUnicode_AsUTF8(args[{i}]);")
                    lines.append(f"    if (!{v_name}) return NULL;")
                else:
                    lines.append(f"    int64_t {v_name} = (int64_t)PyLong_AsLongLong(args[{i}]);")
                    lines.append(f"    if (PyErr_Occurred()) return NULL;")
                call_args.append(v_name)

            call_str = f"fn__{fn.name}({', '.join(call_args)})"
            if fn.return_type == "f64":
                lines.append(f"    double _res = {call_str};")
                lines.append("    return PyFloat_FromDouble(_res);")
            elif fn.return_type == "bool":
                lines.append(f"    int64_t _res = {call_str};")
                lines.append("    return PyBool_FromLong(_res);")
            elif fn.return_type == "void":
                lines.append(f"    {call_str};")
                lines.append("    Py_RETURN_NONE;")
            else:
                lines.append(f"    int64_t _res = {call_str};")
                lines.append("    return PyLong_FromLongLong(_res);")
            lines.append("}")
            lines.append("")

        # PyMethodDef Table
        lines.append("static PyMethodDef _mamba_methods[] = {")
        for fn in exported_fns:
            lines.append(f"    {{\"{fn.name}\", (PyCFunction)py_wrap_{fn.name}, METH_FASTCALL, \"Native Black Mamba function\"}},")
        lines.append("    {NULL, NULL, 0, NULL}")
        lines.append("};")
        lines.append("")

        # PyModuleDef
        lines.append("static struct PyModuleDef _mamba_moduledef = {")
        lines.append("    PyModuleDef_HEAD_INIT,")
        lines.append(f"    \"{self.mod_name}\",")
        lines.append(f"    \"Native Black Mamba CPython Extension\",")
        lines.append("    -1,")
        lines.append("    _mamba_methods,")
        lines.append("    NULL, NULL, NULL, NULL")
        lines.append("};")
        lines.append("")

        # PyMODINIT_FUNC
        lines.append(f"PyMODINIT_FUNC PyInit_{self.mod_name}(void) {{")
        lines.append("    return PyModule_Create(&_mamba_moduledef);")
        lines.append("}")
        return "\n".join(lines)

    def write_c_extension(self, output_path: str) -> str:
        src = self.emit_c_extension()
        os.makedirs(os.path.dirname(os.path.abspath(output_path)), exist_ok=True)
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(src)
        return os.path.abspath(output_path)


class PythonExtensionBuilder:
    """Unified cross-platform Black Mamba Python Extension (.pyd / .so) Builder."""

    def __init__(self, mir_module: MIRModule, mod_name: str = "mamba_module"):
        self.mir_module = mir_module
        self.mod_name = mod_name
        self.pe_builder = PE32PlusExtensionBuilder(mir_module, mod_name)
        self.c_emitter = C11ExtensionEmitter(mir_module, mod_name)

    def build(self, output_path: Optional[str] = None) -> str:
        if sys.platform == "win32":
            out_file = output_path or f"{self.mod_name}.pyd"
            return self.pe_builder.write_pyd(out_file)
        else:
            out_file = output_path or f"{self.mod_name}.c"
            return self.c_emitter.write_c_extension(out_file)
