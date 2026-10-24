# Black Mamba (`.bmb`) — Comprehensive Limitations & Known Flaws

> **Transparency Statement**: Black Mamba achieves 18x–27.5x speedups, 5.5 KB standalone executables, and 1.7 KB WebAssembly modules by eliminating Python's 2,112-byte stack frame debt. However, it is an evolving compiler. This document outlines **every current architectural flaw, missing feature, and trade-off** in the compiler today, along with current workarounds and planned fixes.

---

## 1. Memory Management: No Tracing GC for Dynamic Cyclic Graphs

* **The Limitation**:
  * Value types (`struct Vec3`, `struct Particle`) are unboxed directly on the CPU stack or registers with **zero GC overhead**.
  * However, dynamic heap allocations (`ALLOC_ARR` / `alloc_arr`) currently use an **arena bump-allocator**.
  * If a program creates cyclic reference graphs on the heap (`node.next = prev_node; prev_node.next = node`) inside a long-running daemon, Black Mamba will not reclaim those cyclic references until process exit.
* **Why It Exists**:
  * We deliberately rejected bundling a heavy tracing garbage collector (like Go's or CPython's) to maintain **5.5 KB standalone binary sizes** and ensure **0.0 ms GC pause spikes** for 60/120 FPS game physics.
* **Current Workaround**:
  * Use unboxed value structs (`struct`) and stack-allocated data.
  * Avoid building long-lived cyclic heap graphs, or periodically recycle worker processes in server environments.
* **Planned Fix (Phase 3)**:
  * Compile-time lexical arena lifetime inference: the compiler automatically inserts arena resets and `free()` calls at the boundaries of lexical function scopes without runtime GC pauses.

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

## 3. Strings & Unicode: Static Interning vs. Dynamic Mutation

* **The Limitation**:
  * String literals are pooled in a static read-only string pool (`string_pool`) and referenced by integer IDs.
  * Dynamic string manipulation—such as arbitrary runtime slicing (`s[2:7]`), string concatenation (`s1 + s2` with dynamically generated strings), regular expressions (`re`), and full variable-width Unicode decoding (PEP 393)—is not yet implemented as native machine code.
* **Current Workaround**:
  * Use string formatting for console output (`print(f"...")`).
  * For heavy text and regex processing, call standard Python text modules through the CPython Host Bridge (`py_call`).
* **Planned Fix (Phase 3)**:
  * Implement Small String Optimization (SSO): strings $\le$ 15 bytes live directly in two 64-bit CPU registers; longer strings point to immutable UTF-8 fat pointers (`ptr + len`).

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

## 5. Standard Library Completeness ("The Breadth Deficit")

* **The Limitation**:
  * Standard Python includes 30 years of built-in libraries: `sqlite3`, `datetime`, `asyncio`, `urllib`, `csv`, `json`, `hashlib`, etc.
  * In pure standalone mode (5 KB `.exe`), Black Mamba only includes intrinsics for math, arrays, vector structs, console I/O, and string printing.
  * Routines like parsing JSON or opening sockets currently require the CPython Host Bridge (`mamba/interop.py`).
* **Current Workaround**:
  * Use `py_call("json", "loads", ...)` or `py_call("math", "sin", ...)` via the CPython Host Bridge when running on machines with Python installed.
* **Planned Fix (Phase 4)**:
  * Incrementally rewrite the top 10 most essential standard modules (`math`, `json`, `os`, `time`, `socket`, `random`, `hash`, `array`, `path`, `test`) in pure `.bmb` bytecode.

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
| **Stdlib** | Missing native implementations of heavy standard libraries (JSON, OS) | High | Phase 4 Target |
| **OOP** | No dynamic multiple inheritance (C3 MRO) or runtime monkey-patching | Low | By Design (Fast Path) |
| **Concurrency**| No native `spawn` / `mutex` keywords in JIT (requires C11/OpenMP) | Medium | Phase 4 Target |
| **Tooling** | No dedicated VS Code extension or LSP daemon | Medium | Phase 5 Target |
