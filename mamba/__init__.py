"""
Black Mamba (mamba / .bmb) — A High-Performance, Zero-Ceremony Python Superset & Multi-Target Native Compiler.

Synthesizes the best ideas of Mojo, Nim, and Codon while eliminating where they overreached:
- 100% clean Python indentation syntax (plus ergonomic .bmb extensions: `fn`/`def` unified, `struct`, `par for`, `|>`, `..`).
- Whole-program Cartesian type inference & specialization (write unannotated Python or explicit `i64`/`f64` hints).
- Zero borrow-checker ceremony and zero garbage-collector pauses via escape-analyzed stack/arena memory.
- Multi-target compilation:
  1. Direct in-memory x86-64 Native JIT (Win64 ABI via VirtualAlloc) with Zero-Copy Tensor Exchange
  2. Standalone Windows x86-64 PE32+ Executable (.exe) with zero external compiler dependencies
  3. Standalone Linux ELF64 Executable (.elf) with direct kernel syscalls
  4. WebAssembly binary (.wasm) & text (.wat)
  5. Portable C11 + OpenMP/SIMD (.c) & LLVM IR (.ll)
"""

import inspect
import textwrap
from typing import Any, Callable, Optional, Union

from .cli import compile_source_to_mir
from .backends.x86_64_jit import NativeJITModule
from .interop import (
    CPythonHostBridge,
    try_extract_buffer,
    as_numpy_array,
    as_torch_tensor,
)

__version__ = "0.9.8"
__author__ = "Black Mamba Compiler Team"


def compile(source: str, filename: str = "<jit>", base_dir: str = "") -> NativeJITModule:
    """
    Compiles Black Mamba source code into a native x86-64 executable module in memory.
    The returned module can be invoked directly from Python:
        mod = mamba.compile("def saxpy(n: int, a: f64, x: Array[f64], y: Array[f64]): ...")
        mod.saxpy(100, 2.5, np_x, np_y)  # Zero copy!
    """
    mir = compile_source_to_mir(source, filename=filename, base_dir=base_dir)
    return NativeJITModule(mir)


def jit(fn_or_source: Union[Callable, str, None] = None) -> Any:
    """
    JIT compiler decorator or function for Black Mamba with zero-copy NumPy / PyTorch tensor exchange.
    
    Usage as decorator:
        @mamba.jit
        def fast_calc(n: int, x: List[f64], y: List[f64]):
            for i in 0..n:
                y[i] = x[i] * 2.0

    Usage on code string:
        kernel = mamba.jit('''
            def square(n: int, arr: Array[f64]):
                for i in 0..n:
                    arr[i] = arr[i] * arr[i]
        ''')
        kernel(len(x), x)
    """
    if fn_or_source is None:
        return lambda f: jit(f)

    if isinstance(fn_or_source, str):
        mod = compile(fn_or_source)
        user_funcs = [fn for fn in mod.mir_module.functions if fn.name not in ("main", "__bmb_main__")]
        if len(user_funcs) == 1:
            fn_name = user_funcs[0].name
            return getattr(mod, fn_name)
        return mod

    if callable(fn_or_source):
        try:
            src = inspect.getsource(fn_or_source)
            src = textwrap.dedent(src)
            # Filter out decorators from source line before parsing
            lines = src.splitlines()
            cleaned_lines = [l for l in lines if not l.strip().startswith("@mamba.jit") and not l.strip().startswith("@jit")]
            cleaned_src = "\n".join(cleaned_lines)
            mod = compile(cleaned_src, filename=fn_or_source.__name__)
            return getattr(mod, fn_or_source.__name__)
        except Exception as e:
            raise RuntimeError(f"Failed to JIT-compile function {fn_or_source.__name__!r}: {e}")

    raise TypeError(f"Expected callable function or source string, got {type(fn_or_source)}")


__all__ = [
    "compile",
    "jit",
    "NativeJITModule",
    "CPythonHostBridge",
    "try_extract_buffer",
    "as_numpy_array",
    "as_torch_tensor",
]

