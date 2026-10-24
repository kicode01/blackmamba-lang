"""
Black Mamba (mamba / .bmb) — A High-Performance, Zero-Ceremony Python Superset & Multi-Target Native Compiler.

Synthesizes the best ideas of Mojo, Nim, and Codon while eliminating where they overreached:
- 100% clean Python indentation syntax (plus ergonomic .bmb extensions: `fn`/`def` unified, `struct`, `par for`, `|>`, `..`).
- Whole-program Cartesian type inference & specialization (write unannotated Python or explicit `i64`/`f64` hints).
- Zero borrow-checker ceremony and zero garbage-collector pauses via escape-analyzed stack/arena memory.
- Multi-target compilation:
  1. Direct in-memory x86-64 Native JIT (Win64 ABI via VirtualAlloc)
  2. Standalone Windows x86-64 PE32+ Executable (.exe) with zero external compiler dependencies
  3. WebAssembly binary (.wasm) & text (.wat)
  4. Portable C11 + OpenMP/SIMD (.c) & LLVM IR (.ll)
"""

__version__ = "1.0.0"
__author__ = "Black Mamba Compiler Team"
