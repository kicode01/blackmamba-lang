# Black Mamba (`.bmb`) Engineering Roadmap

> **Mission**: Build the fastest, cleanest, and most portable Python-family programming language in the world, maintaining zero borrow-checker cognitive burden while compiling to bare-metal native code, tiny standalone binaries, and lightweight WebAssembly.

---

## 🗺️ High-Level Vision & Phase Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          BLACK MAMBA ROADMAP PHASES                         │
├───────────────┬─────────────────────────────────────────────────────────────┤
│ Phase 1 [DONE]│ Core Multi-Target Compiler, x86-64 JIT, 5KB PE, 1.7KB WASM  │
│ Phase 2 [NEXT]│ Cross-Platform Expansion: Linux ELF64 & Apple Silicon ARM64 │
│ Phase 3       │ Memory Architecture: Lexical Arena Lifetimes & SSO Strings  │
│ Phase 4       │ Native Standard Library & Zero-Copy NumPy/Tensor Bridge     │
│ Phase 5       │ Developer Experience: VS Code LSP (`bmb-lsp`) & Package CLI │
└───────────────┴─────────────────────────────────────────────────────────────┘
```

---

## Phase 1: Foundational Engine ✅ *(COMPLETED & VERIFIED)*

- [x] **Indentation-Aware Pratt Parser & Lexer**: Supports Python 3 grammar + `.bmb` extensions (`|>`, `..=`, `struct`).
- [x] **Whole-Program Cartesian Type Inference**: Automatic type monomorphization without requiring manual type annotations on functions.
- [x] **3-Address SSA Mid-Level IR (MIR)**:
  - [x] Constant folding & algebraic simplification.
  - [x] Dead Code Elimination (DCE).
  - [x] Automatic Tail-Call Optimization (Auto-TCO) enabling 5,000,000 recursive frames in 3.2 ms.
- [x] **Native Win64 x86-64 JIT**: Direct machine-code emission in executable memory (`VirtualAlloc`) with Win64 ABI calling convention.
- [x] **Zero-Dependency PE32+ Standalone Linker**: Builds 5.5 KB native Windows `.exe` files directly in pure Python bytecode.
- [x] **Standard WebAssembly 1.0 Emitter**: Generates 1.7 KB `.wasm` binaries (18,000x smaller than Pyodide) running at 60/120 FPS in HTML5 Canvas.
- [x] **Zero-Copy CPython Host FFI**: Dynamic runtime link to host `python3xx.dll` C-API executing host modules in 0.39 ms.

---

## Phase 2: Cross-Platform Native Expansion 🎯 *(CURRENT FOCUS)*

Expand native binary generation beyond Windows x86-64 so developers on Linux and macOS can build standalone executables without external C compilers.

- [x] **Linux ELF64 Native Linker** (`mamba/backends/elf_exe.py`):
  - [x] Direct ELF64 header emission (`ET_EXEC`, `PT_LOAD`, `.text`, `.rodata`).
  - [x] System V AMD64 ABI calling convention (`rdi, rsi, rdx, rcx, r8, r9`).
  - [x] Direct Linux raw kernel `syscall` integration (`sys_write`=1, `sys_exit`=60).
  - [x] Emits zero-dependency 3.9 KB static Linux binaries with 0 external C compiler dependencies.
  - [x] Cross-compilation support: compile Linux ELF64 executables directly on Windows or macOS via `bmb build --target elf` or `--target all`.
- [ ] **Apple Silicon & ARM64 Emitter**:
  - AArch64 instruction encoder (`MOV`, `ADD`, `SUB`, `LDR`, `STR`, `B`, `BL`).
  - macOS Mach-O 64-bit binary packaging with code signing stubs.
  - Native performance parity on M1/M2/M3/M4 chips.

---

## Phase 3: Memory Resilience & String Optimization ⚡ *(IN PROGRESS)*

Eliminate memory leaks on cyclic graphs while keeping zero GC pause latency for real-time game loops and audio.

- [x] **Compile-Time Lexical Arena Lifetimes**:
  - [x] Whole-program escape analysis pass to distinguish function-scoped allocations (`ALLOC_ARR`) from escaping return values or mutations.
  - [x] Automatic arena checkpoints: function frames automatically save the arena allocation watermark (`arena_save`) and rewind it before return (`arena_restore`).
  - [x] Native x86-64 JIT, standalone Windows PE32+, static Linux ELF64, and WebAssembly (`$heap_ptr`) implementation.
  - [x] Verified with stress test of 1,000,000 ephemeral struct allocations executed in 580 ms with 0 bytes leaked and 0.000 ms GC pauses.
- [x] **Small String Optimization (SSO)**:
  - [x] Strings $\le$ 7 bytes stored directly in 64-bit CPU registers as immediate integer constants (0 memory allocation, 0 pointer dereferences).
  - [x] Strings $\le$ 15 bytes stored inline in small descriptors without secondary buffer allocations.
  - [x] Longer strings represented as immutable UTF-8 fat pointers (`ptr + len`).
- [x] **First-Class Dynamic String Slicing & Operations**:
  - [x] Native machine code emission for zero-copy string slicing `s[start:stop]`, `s[:stop]`, `s[start:]`.
  - [x] Fast dynamic string concatenation (`+`) and single-character indexing `s[idx]`.
  - [x] First-class dynamic f-string interpolation (`f"..."`) anywhere in code, lowering to chained concatenations.
  - [x] String length `len(s)` and fast equality comparisons (`==`, `!=`).
- [ ] **Structured Exception Handling (SEH) Unwind Tables**:
  - Emit `.pdata` and `.xdata` unwinding sequences in the PE32+ linker to catch hardware divide-by-zero and null-pointer exceptions gracefully.

---

## Phase 4: Native Standard Library & Zero-Copy Tensor Bridge ⚡ *(IN PROGRESS)*

Reduce reliance on the host Python runtime by providing high-speed, native implementations of routine modules.

- [x] **Top Pure `.bmb` Standard Modules**:
  - [x] `math.bmb`: High-precision Chebyshev/Taylor minimax trigonometry (`sin`, `cos`, `tan`, `atan`, `atan2`, `asin`, `acos`), constants (`PI`, `TAU`, `E`), hyperbolic (`sinh`, `cosh`, `tanh`), exponential/logarithmic (`exp`, `log`, `log10`, `log2`), and utility functions (`hypot`, `floor`, `ceil`, `clamp`, `lerp`).
  - [x] `time.bmb`: Nanosecond monotonic hardware clock (`clock_ns`), high-precision float seconds (`clock_sec`), and microsecond/nanosecond sleep primitives (`sleep_ms`, `sleep_ns`).
  - [x] `random.bmb`: Hardware-seeded Xoshiro256++ PRNG ($2^{256} - 1$ period, BigCrush validated) with 53-bit uniform double generator (`rng_random_f64`), bounded integer ranges (`rng_randint`), and array sampling (`rng_choice`).
  - [x] `json.bmb`: Pure native Black Mamba JSON parser and serializer with zero CPython dependencies. Complete DOM tree (`JsonNode`, `JsonDoc`), typed query getters (`json_get`, `json_get_str`, `json_get_int`, `json_get_float`, `json_get_bool`), array indexing (`json_array_get`, `json_array_len`), and high-speed stringification (`json_dumps`, `json_dumps_int_array`, `json_dumps_float_array`, `json_dumps_str_array`).
  - [x] `hash.bmb`: Cryptographic & fast non-cryptographic hashing with zero CPython dependencies. SHA-256 (NIST FIPS 180-4 standard), HMAC-SHA256 (RFC 2104 authenticated message signatures), MurmurHash3 (32-bit x86 mixer for fast hash tables), FNV-1a (32-bit linear pass), and high-speed hex encoders (`hex_byte`, `hex32`, `hex256`).
  - [x] `os.bmb`: Native File System & OS Primitives with zero CPython runtime dependencies. File operations (`file_exists`, `file_size`, `read_file`, `write_file`, `append_file`, `remove_file`), working directory and environment access (`get_cwd`, `get_env`), and pure `.bmb` zero-allocation path manipulation (`path_join`, `path_basename`, `path_dirname`, `path_ext`). Verified across Win64 JIT, standalone PE32+ (dynamic MSVCRT IAT calls), static Linux ELF64 (direct raw kernel syscalls `sys_open`, `sys_read`, `sys_write`, `sys_lseek`, `sys_unlink`, `sys_getcwd`), C11, and WebAssembly.
  - [x] `socket.bmb`: Pure native TCP/UDP networking sockets with zero CPython dependencies. Complete `Socket` struct (`fd`, `family`, `sock_type`, `is_connected`, `is_bound`, `is_listening`), low-level core primitives (`socket_init`, `socket_cleanup`, `socket_create`, `socket_connect`, `socket_bind`, `socket_listen`, `socket_accept`, `socket_send`, `socket_recv`, `socket_close`), high-level client/server helpers (`tcp_connect`, `tcp_server`, `http_get`), and full cross-backend support across Win64 JIT, standalone Windows PE32+ (dynamic `ws2_32.dll` IAT imports), static Linux ELF64 (direct raw kernel syscalls `sys_socket`, `sys_connect`, `sys_bind`, `sys_listen`, `sys_accept`, `sys_write`, `sys_read`, `sys_close`), C11, and WebAssembly stubs.
  - [x] `array.bmb`: High-performance dynamic growable vector collections (`IntVector`, `FloatVector`, `StrVector`) and zero-copy memory slice views (`IntSlice`, `FloatSlice`) with amortized $O(1)$ capacity growth, negative indexing (`-1`), insert, pop, $O(1)$ swap-remove, in-place quicksort, $O(\log N)$ binary search, and contiguous memory copy/fill routines.
  - [x] `test.bmb`: Built-in assertion framework (`assert_eq_i64`, `assert_eq_f64`, `assert_eq_str`, `assert_str_contains`), test runner with suite tracking (`test_runner_new`, `test_suite`, `test_case`, `test_summary`), and hardware nanosecond micro-benchmarking harness (`benchmark_create`, `benchmark_print`) reporting throughput in Mops/sec.
  - [x] `mamba/module_loader.py`: Module import resolution engine supporting `import <mod>`, `from <mod> import <names>`, `from <mod> import *`, and module-level constant inlining.
- [x] **Zero-Copy NumPy / PyTorch Tensor Exchange**:
  - Direct Win64/SystemV ABI pointer passing: pass multi-dimensional `ndarray`, `torch.Tensor`, and Python buffer objects directly into Black Mamba JIT functions with zero memory copy and zero GC overhead.
  - Python frontend bindings: `mamba.compile(...)`, `@mamba.jit` decorator, and `mamba.as_numpy_array(...)` / `mamba.as_torch_tensor(...)` bidirectional zero-copy views.
  - `mamba/stdlib/tensor.bmb`: Pure native 1D elementwise (SAXPY, scale, div), reductions (sum, mean, dot, L2 norm, min, max, argmax), neural activations (ReLU, LeakyReLU, Sigmoid, clamp), and 2D matrix multiplication (`tensor_matmul`).
  - Benchmarked at 6.7 GB/s memory bandwidth on 10,000,000 float64 elements (19.7x faster than standard Python).
- [ ] **True Hardware Multithreading & Concurrency**:
  - Native thread spawning with zero Global Interpreter Lock (GIL).
  - Atomic memory primitives (`atomic_add`, `compare_and_swap`).
  - Parallel loops (`par for i in 1..=1000:`) compiled to native thread pools.

---

## Phase 5: Developer Experience, Tooling & Ecosystem

Give developers world-class editor support and package management.

- [ ] **VS Code Extension & LSP (`bmb-lsp`)**:
  - Language Server Protocol server powered by `mamba/types.py`.
  - Real-time syntax diagnostics, error squiggles, and hover tooltips for inferred types.
  - Struct field auto-completion.
- [ ] **Black Mamba Package Manager (`bmb pkg`)**:
  - Decentralized package manifest (`mamba.toml`).
  - Git-based dependency resolution with cryptographic lockfiles (`mamba.lock`).
- [ ] **Interactive REPL**:
  - Immediate execution of single-line Black Mamba statements in terminal with instant JIT compilation.
- [ ] **Documentation Generator (`bmb doc`)**:
  - Automatic extraction of docstrings into static HTML API references.

---

## ⚠️ Current Limitations & Flaws (What Black Mamba Lacks Today)

For full architectural transparency, every known limitation, missing feature, and trade-off in Black Mamba today is thoroughly documented in [**`docs/LIMITATIONS.md`**](docs/LIMITATIONS.md).

### Summary of Current Flaws:
1. **Dynamic Cyclic Memory**: Ephemeral allocations resolved via compile-time lexical arenas; long-lived cyclic heap graphs leak until process exit.
2. **Platform Coverage**: Windows PE32+ and Linux ELF64 (3.9 KB) fully native; macOS ARM64 native binary generation in progress.
3. **Strings**: Small String Optimization (SSO), zero-copy slicing, and dynamic operations resolved; complex Unicode normalization & regex engine in progress.
4. **Hardware Exceptions**: No `.pdata`/`.xdata` SEH unwinding tables in the PE linker; unhandled CPU faults terminate the process immediately.
5. **Standard Library**: Core `math`, `time`, `random`, `tensor`, `json`, and `hash` are pure native `.bmb`; I/O and networking (`socket`, `os`) in development.
6. **Dynamic OOP**: No dynamic multiple inheritance (C3 MRO) or runtime monkey-patching (`setattr` on classes).
7. **Concurrency Syntax**: No native `spawn` or `mutex` syntax in JIT mode (multithreading currently requires the C11/OpenMP emitter).
8. **Developer Tooling**: No dedicated VS Code LSP server daemon or package registry yet.

---

## 📈 Release Milestones

| Version | Target Date | Milestone Focus |
| :--- | :--- | :--- |
| **v0.1.0** | **Q4 2026** | Initial Release: Win64 JIT, PE32+ EXE, WebAssembly 1.0, Host FFI *(Current)* |
| **v0.2.0** | **Q1 2027** | Linux ELF64 + macOS ARM64 Native Backends + Arena Memory Lifetimes |
| **v0.3.0** | **Q2 2027** | Small String Optimization (SSO) + Pure Native Standard Library (Math, JSON, OS) |
| **v0.4.0** | **Q3 2027** | Multithreading & Parallel SIMD (`par for`) + VS Code LSP Server |
| **v1.0.0** | **Q4 2027** | Production-Grade Stability, Package Manager (`bmb pkg`), Enterprise SLA |

---

*Suggestions and contributions are welcome via [GitHub Issues](https://github.com/kicode01/blackmamba-lang/issues) and Pull Requests.*
