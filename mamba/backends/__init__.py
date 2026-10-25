"""
Black Mamba (.bmb) Multi-Target Code Generation Backends:
- x86_64_jit: Native Win64 x86-64 Machine Code Assembler & VirtualAlloc JIT
- pe_exe: Standalone Windows 64-bit PE32+ (.exe) Native Linker & Binary Emitter
- elf_exe: Standalone Linux 64-bit ELF (ELF64) Native Linker & Binary Emitter
- wasm_emitter: WebAssembly Binary (.wasm) & Text (.wat) Emitter
- c_emitter: Portable C11 + OpenMP/SIMD (.c) & LLVM IR (.ll) Emitter
"""

from .x86_64_jit import NativeJITModule, X86_64CodeBuffer
from .pe_exe import PE32PlusExecutableBuilder
from .elf_exe import ELF64ExecutableBuilder
from .wasm_emitter import WasmBackend
from .c_emitter import C11Backend, LLVMIRBackend
from .python_ext import PythonExtensionBuilder, PE32PlusExtensionBuilder, C11ExtensionEmitter

__all__ = [
    "NativeJITModule",
    "X86_64CodeBuffer",
    "PE32PlusExecutableBuilder",
    "ELF64ExecutableBuilder",
    "WasmBackend",
    "C11Backend",
    "LLVMIRBackend",
    "PythonExtensionBuilder",
    "PE32PlusExtensionBuilder",
    "C11ExtensionEmitter",
]
