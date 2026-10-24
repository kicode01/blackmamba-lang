# Black Mamba (`.bmb`) — Comprehensive Limitations & Known Flaws

> **Transparency Statement**: Black Mamba achieves 18x–27.5x speedups, 5.5 KB standalone executables, and 1.7 KB WebAssembly modules by eliminating Python's 2,112-byte stack frame debt. However, it is an evolving compiler. This document outlines **every current architectural flaw, missing feature, and trade-off** in the compiler today, along with current workarounds and planned fixes.

---

## 1. Memory Management: Ephemeral Allocations Resolved; Long-Lived Cyclic Graphs

* **Current Status**:
  * **Ephemeral Allocations (RESOLVED in Phase 3)**: Function-scoped allocations (`ALLOC_ARR` / local structs) are now automatically managed by **Compile-Time Lexical Arena Lifetimes**. The compiler runs whole-program escape analysis and emits `arena_save` and `arena_restore` checkpoints. Local allocations within loops and functions rewind instantly upon return with **0 bytes leaked** and **0.000 ms GC pause latency**. Verified with 1,000,000 ephemeral struct allocations in 580 ms.
  * **Long-Lived Objects**: Objects that escape the creating function (e.g., returned arrays or structures linked to global data) are allocated in the global persistent bump arena.
  * **Remaining Flaw**: If a program builds complex *cyclic reference graphs* (`node.next = prev; prev.next = node`) that escape into long-lived global scope inside an infinite server daemon, Black Mamba will not reclaim those cyclic references until process termination.
* **Why It Exists**:
  * We deliberately rejected bundling a heavy tracing garbage collector (like Go's or CPython's) to maintain **5.5 KB standalone binary sizes** and ensure **0.0 ms GC pause spikes** for 60/120 FPS game physics.
* **Current Workaround**:
  * Use unboxed value structs (`struct`) and function-scoped data (which are 100% leak-free via lexical arenas).
  * Avoid building long-lived cyclic heap graphs, or periodically recycle worker processes in server environments.
* **Planned Future Work**:
  * Implement reference counting with cycle-detection backup or generational region inference for escaping graphs.

---

## 2. Platform Architecture: macOS Apple Silicon (ARM64)

* **Current Status**:
  * **Windows x86-64**: Full native support via PE32+ linker (`bmb build --target exe`, 5.5 KB).
  * **Linux x86-64**: Full native support via direct ELF64 linker (`bmb build --target elf`, 3.9 KB static binary using direct `sys_write` and `sys_exit` syscalls).
  * **macOS / Apple Silicon**: Native standalone binary generation (`.dylib` / Mach-O ARM64) is currently in progress.
* **Current Workaround on macOS**:
  * Compile via the portable C11 backend (`bmb build script.bmb --target c` and `clang -O3 script.c`), or compile to WebAssembly (`--target wasm`) and run via Node.js / Wasmtime.
* **Planned Fix (Phase 2)**:
  * Implement an AArch64 machine-code emitter and 64-bit Mach-O binary packaging for Apple Silicon M1/M2/M3/M4 chips.

---

## 3. Strings & Unicode: Dynamic Slicing & SSO (RESOLVED); Complex Unicode / Regex Remaining

* **Current Status**:
  * **SSO & Dynamic Strings (RESOLVED in Phase 3)**:
    - Small String Optimization (SSO): strings $\le$ 7 bytes live directly inside 64-bit CPU registers as immediate tagged integers with **zero memory allocations** and **zero pointer dereferences**.
    - Strings $\le$ 15 bytes are stored in inline contiguous descriptors without secondary heap buffers.
    - Zero-copy slicing: `s[start:stop]`, `s[:stop]`, `s[start:]` return fat pointers or register SSOs directly into parent buffers without copying data bytes.
    - Dynamic operations: String concatenation (`+`), single-character indexing (`s[i]`), length (`len(s)`), fast comparisons (`==`, `!=`), and arbitrary dynamic f-string interpolation (`f"hello {x}"`) now execute natively.
  * **Remaining Limitation**:
    - Regular expressions (`re`) and complex variable-width Unicode normalization (PEP 393 wide codepoint transcoding, e.g. UTF-16 surrogate pairs and full locale collations) currently rely on standard Python text routines via the CPython Host Bridge (`py_call`).
* **Current Workaround**:
  * For heavy regex pattern matching or complex locale-sensitive string transforms, use the CPython Host Bridge (`py_call("re", "sub", ...)`).
* **Planned Future Work (Phase 4)**:
  * Pure `.bmb` native DFA regular expression engine and UTF-8 grapheme cluster iterator.

---

## 4. Exception Handling: Lack of Zero-Cost Unwind Tables

* **The Limitation**:
  * Errors are currently handled via structured control-flow jumps (`JZ`/`JNZ`) and return status codes.
  * The direct PE32+ binary linker does not yet generate full Windows Structured Exception Handling (SEH) `.pdata` and `.xdata` unwinding tables.
  * If a native executable encounters a hardware trap (e.g. division by zero or invalid memory access), the operating system terminates the process immediately rather than raising a catchable Python `ZeroDivisionError`.
* **Current Workaround**:
  * Validate inputs explicitly before division or array indexing.
  * Use the C11 backend (`--target c`) which leverages standard C error handling.
* **Planned Fix (Phase 3)**:
  * Emit native `.pdata` and `.xdata` unwind bytecode sequences directly into the PE32+ header.

---

## 5. Standard Library Completeness: Pure Native Core (RESOLVED); I/O & Networking Remaining

* **Current Status**:
  * **Core Modules (RESOLVED in Phase 4)**:
    - `math.bmb`: Pure native 7-term Chebyshev/Taylor minimax trigonometry (`sin`, `cos`, `tan`, `atan`, `atan2`, `asin`, `acos`), hyperbolic functions (`sinh`, `cosh`, `tanh`), exponential/logarithmic functions (`exp`, `log`, `log10`, `log2`), and geometry/utility routines (`hypot`, `floor`, `ceil`, `clamp`, `lerp`, `gcd`, `factorial`) with zero CPython dependencies.
    - `time.bmb`: Nanosecond-precision monotonic hardware clock (`clock_ns`), high-precision float seconds (`clock_sec`), and micro/nanosecond sleep primitives (`sleep_ms`, `sleep_ns`).
    - `random.bmb`: Hardware-seeded Xoshiro256++ PRNG ($2^{256} - 1$ period, BigCrush validated) with 53-bit uniform double generator (`rng_random_f64`), bounded integer ranges (`rng_randint`), continuous distributions (`rng_uniform`), and array sampling (`rng_choice`).
    - `mamba/module_loader.py`: Module import resolution engine supporting `import <mod>`, `from <mod> import <names>`, `from <mod> import *`, and compile-time module constant inlining.
  * **Remaining Limitation**:
    - High-level I/O, serialization, and networking modules (`json`, `socket`, `os`, `sqlite3`, `http`) still require native implementations or CPython Host Bridge fallback (`mamba/interop.py`).
* **Current Workaround**:
  * Use pure `.bmb` modules (`math`, `time`, `random`) for compute and timing.
  * For complex JSON parsing or raw socket operations, call `py_call("json", "loads", ...)` via the CPython Host Bridge.
* **Planned Future Work (Phase 4)**:
  * Pure `.bmb` SIMD JSON parser and serializer, zero-copy file I/O in `os.bmb`, and non-blocking networking in `socket.bmb`.

---

## 6. Dynamic OOP: No C3 MRO or Dynamic Monkey-Patching

* **The Limitation**:
  * Black Mamba supports `struct` with typed fields, default values, and methods (`fn method(self)`).
  * However, Black Mamba does **not** support Python's dynamic multiple-inheritance diamond resolution (C3 Method Resolution Order algorithm), dynamic runtime class creation (`type("Foo", (), {})`), or dynamic method monkey-patching (`setattr(MyClass, "foo", new_fn)`).
* **Why It Exists**:
  * Dynamic multiple inheritance and monkey-patching force dictionary lookups on every method call, which is the primary reason CPython OOP is so slow. Black Mamba intentionally compiles methods into direct, 1-cycle function pointers.
* **Current Workaround**:
  * Use composition over inheritance and struct value types.
* **Planned Fix (Phase 4)**:
  * Implement V8-style Hidden Classes / Shape Tables for code that explicitly demands runtime attribute mutation.

---

## 7. Concurrency & Multithreading Primitives in Syntax

* **The Limitation**:
  * Black Mamba has no Global Interpreter Lock (GIL), meaning threads can execute with true hardware parallelism.
  * However, the `.bmb` frontend syntax does not yet have built-in keywords for spawning native threads, mutex locks, or atomic primitives in pure JIT mode (multithreading is currently supported via `par for` in the C11/OpenMP emitter).
* **Current Workaround**:
  * Use `bmb build --target c` with OpenMP compiler flags (`-fopenmp`) for multi-core parallel loops.
* **Planned Fix (Phase 4)**:
  * Add first-class `spawn`, `channel`, and atomic intrinsics (`atomic_add`, `compare_and_swap`) directly into the JIT and PE linker.

---

## 8. Tooling: No Language Server Protocol (LSP) or Package Registry

* **The Limitation**:
  * Developers currently edit `.bmb` files using standard Python syntax highlighting in VS Code.
  * There is no dedicated VS Code extension, inline diagnostic squiggles, or auto-complete for struct fields.
  * There is no official package manager CLI (`bmb install <pkg>`) or central package registry yet.
* **Current Workaround**:
  * Use Python language mode in your IDE.
  * Manage dependencies via Git submodules or local files.
* **Planned Fix (Phase 5)**:
  * Wrap `mamba/types.py` into a Language Server Protocol daemon (`bmb-lsp`) and build the `bmb pkg` decentralized package manager.

---

### Summary Checklist of All Flaws

| Category | Flaw | Severity | Status |
| :--- | :--- | :--- | :--- |
| **Memory** | Linear arena leaks on cyclic heap graphs | Medium | Phase 3 Target |
| **Platform** | Linux ELF64 shipped (3.9KB); macOS ARM64 in progress | Medium | Phase 2 In Progress |
| **Strings** | Static interned string pool; no dynamic slicing/concatenation in JIT | Medium | Phase 3 Target |
| **Exceptions** | Process termination on hardware fault; no `.xdata` unwinding tables | Low | Phase 3 Target |
| **Stdlib** | Core (math, time, random) pure native; JSON, OS, Socket remaining | Medium | Phase 4 Core Done |
| **OOP** | No dynamic multiple inheritance (C3 MRO) or runtime monkey-patching | Low | By Design (Fast Path) |
| **Concurrency**| No native `spawn` / `mutex` keywords in JIT (requires C11/OpenMP) | Medium | Phase 4 Target |
| **Tooling** | No dedicated VS Code extension or LSP daemon | Medium | Phase 5 Target |
