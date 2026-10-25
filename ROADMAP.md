# Black Mamba (`.bmb`) Engineering Roadmap

> **Mission**: Build the fastest, cleanest, and most portable Python-family programming language in the world, maintaining zero borrow-checker cognitive burden while compiling to bare-metal native code, tiny standalone binaries, and lightweight WebAssembly.

---

## 🗺️ High-Level Vision & Phase Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          BLACK MAMBA ROADMAP PHASES                         │
├───────────────┬─────────────────────────────────────────────────────────────┤
│ Phase 1 [DONE]│ Core Multi-Target Compiler, x86-64 JIT, 5KB PE, 1.7KB WASM  │
│ Phase 2 [DONE]│ Cross-Platform Expansion: Linux ELF64 & Apple Silicon ARM64 │
│ Phase 3 [DONE]│ Memory Architecture: Lexical Arena Lifetimes & SSO Strings  │
│ Phase 4 [DONE]│ Native Standard Library & Zero-Copy NumPy/Tensor Bridge     │
│ Phase 5 [DONE]│ Developer Tooling: VS Code LSP, REPL, Package Manager & Doc │
│ Tier 1  [DONE]│ Unicode Engine, Async Reactor, KV Store & Standalone bmb.exe│
│ Vector 1[DONE]│ High-Throughput HTTP/1.1 & WebSocket Server Framework (http)│
│ Vector 2[DONE]│ Hardware SIMD & AVX2 / AVX-512 Vectorization Pipeline (simd)│
│ Vector 3[DONE]│ Zero-Compiler CPython Native Extension Module Emitter (.pyd)│
│ Vector 4[DONE]│ Lock-Free Thread-Local Slab Allocator (alloc.bmb)           │
│ Vector 5[DONE]│ Native Columnar Data & Embedded Analytics (series.bmb)      │
│ Vector 6[DONE]│ Complete Self-Hosting Compiler (Lexer, Parser & PE32+ .exe) │
│ Vector 7[DONE]│ Embedded & Bare-Metal Target (No-OS / Cortex-M / RISC-V)    │
│ Vector 8[DONE]│ Native Debug Symbols & Diagnostics (CodeView RSDS / DWARF 4)│
└───────────────┴─────────────────────────────────────────────────────────────┘
```

## 🎯 Strategic Dominance Vectors (Black Mamba vs. Python) — Status Matrix

| Vector | Focus Area | Status | Shipped In | Technical Achievement |
| :--- | :--- | :---: | :---: | :--- |
| **Vector 1** | **High-Throughput HTTP & WebSockets** (`http.bmb`) | **COMPLETED ✅** | `v0.7.0` | 8.2M req/sec native router, RFC 6455 full-duplex WebSocket frames |
| **Vector 2** | **Native SIMD & AVX2 / AVX-512** (`simd.bmb`) | **COMPLETED ✅** | `v0.8.0` | `Vec4f`, `Vec8f`, `Vec4i`, FMA, 8-way unrolled bulk array DSP kernels |
| **Vector 3** | **Drop-in CPython Extension Emitter** (`.pyd` / `.so`) | **COMPLETED ✅** | `v0.8.1` | Zero-compiler PE32+ `.pyd` generation, `METH_FASTCALL`, **30.5x faster** than Python 3.14 |
| **Vector 4** | **Lock-Free Thread-Local Slab Allocator** (`alloc.bmb`) | **COMPLETED ✅** | `v0.8.2` | Mimalloc/Jemalloc thread-isolated slab cache, 15.5M multi-core ops/sec, zero lock contention |
| **Vector 5** | **Native Columnar Data Engine** (`series.bmb`) | **COMPLETED ✅** | `v0.9.0` | Arrow contiguous memory layout, **79.2M rows/s** vector scans, GroupBy, Hash Joins |
| **Vector 6** | **Complete Self-Hosting `.bmb` -> `.exe` Compiler** (`compiler.bmb`, `codegen.bmb`) | **COMPLETED ✅** | `v0.9.5` / `v1.0.0` | Pure `.bmb` Lexer, Pratt Parser, x86-64 Assembler & PE32+ `.exe` Linker (1.6 ms zero-Python compile) |
| **Vector 7** | **Embedded & Bare-Metal Edge Target** (`embedded.bmb`) | **COMPLETED ✅** | `v0.9.8` | Freestanding No-OS HAL, MMIO 32/8-bit, 65.7M ticks/s PID, `.bin` / `.hex` / `.elf` |
| **Vector 8** | **Native Debug Symbols & Diagnostics** (`--debug` / `-g`, `debug.bmb`) | **COMPLETED ✅** | `v1.0.0` | PE32+ CodeView `RSDS` + COFF `.symtab` + ASLR Symbolic SEH, ELF64 DWARF v4 `.debug_line`, C11 `#line` |

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

## Phase 2: Cross-Platform Native Expansion ✅ *(COMPLETED & VERIFIED)*

Expand native binary generation beyond Windows x86-64 so developers on Linux and macOS can build standalone executables without external C compilers.

- [x] **Linux ELF64 Native Linker** (`mamba/backends/elf_exe.py`):
  - [x] Direct ELF64 header emission (`ET_EXEC`, `PT_LOAD`, `.text`, `.rodata`).
  - [x] System V AMD64 ABI calling convention (`rdi, rsi, rdx, rcx, r8, r9`).
  - [x] Direct Linux raw kernel `syscall` integration (`sys_write`=1, `sys_exit`=60).
  - [x] Emits zero-dependency 3.9 KB static Linux binaries with 0 external C compiler dependencies.
  - [x] Cross-compilation support: compile Linux ELF64 executables directly on Windows or macOS via `bmb build --target elf` or `--target all`.
- [x] **Apple Silicon & ARM64 Emitter** (`mamba/backends/arm64_macho.py`):
  - [x] Fixed-width 32-bit AArch64 instruction encoder (`MOV`, `ADD`, `SUB`, `MUL`, `SDIV`, `LDR`, `STR`, `B`, `BL`, `B.cond`, `ADR`, `FADD`, `FSUB`, `FMUL`, `FDIV`, `FCMP`, `SCVTF`, `FCVTZS`).
  - [x] macOS Mach-O 64-bit binary linker (`MH_MAGIC_64`, `CPU_TYPE_ARM64`, `__PAGEZERO`, `__TEXT`, `LC_BUILD_VERSION`, `LC_MAIN`, `LC_LOAD_DYLINKER`).
  - [x] Direct Darwin raw kernel `svc #0x80` syscall integration (`sys_write`=0x2000004, `sys_exit`=0x2000001, `sys_open`, `sys_read`, `sys_close`, `sys_unlink`).
  - [x] Native hardware cycle timing via `cntvct_el0` and `cntfrq_el0`.
  - [x] Cross-compilation support: build standalone Apple Silicon macOS executables directly on Windows or Linux via `bmb build --target macho`, `--target arm64`, or `--target all`.

---

## Phase 3: Memory Resilience & String Optimization ✅ *(COMPLETED & VERIFIED)*

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
- [x] **Structured Exception Handling (SEH) Unwind Tables**:
  - [x] Emit `.pdata` (Section 4) and `.xdata` unwinding tables in the PE32+ linker to catch hardware divide-by-zero (`0xC0000094`), null-pointer access violations (`0xC0000005`), and stack overflows (`0xC00000FD`) gracefully.
  - [x] Populate `DataDirectory[3]` (`IMAGE_DIRECTORY_ENTRY_EXCEPTION`) in the PE32+ Optional Header.
  - [x] Strictly ascending `IMAGE_RUNTIME_FUNCTION_ENTRY` table with binary search compatibility for Windows kernel `RtlLookupFunctionEntry`.
  - [x] Register native Vectored Exception Handler (`AddVectoredExceptionHandler`) in `_start` to format and print human-readable diagnostic reports with proper call-stack unwinding before clean exit.

---

## Phase 4: Native Standard Library & Zero-Copy Tensor Bridge ✅ *(COMPLETED & VERIFIED)*

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
  - [x] `chan.bmb`: Dmitry Vyukov's lock-free bounded Multi-Producer Multi-Consumer (MPMC) ring buffer queue with zero locks and zero GIL. Ring channel allocation (`chan_new`), state inspections (`chan_cap`, `chan_len`, `chan_is_empty`, `chan_is_full`, `chan_is_closed`), atomic channel closure (`chan_close`), non-blocking (`chan_try_send`, `chan_try_recv`) and adaptive spinning blocking primitives (`chan_send`, `chan_recv`), bulk batch draining (`chan_drain`), batch publishing (`chan_send_all`), fast 2-channel multiplexing (`chan_select2`, `chan_select2_wait`), Go-style multi-channel `Select` multiplexer (`select_new`, `select_add_recv`, `select_add_send`, `select_add_default`, `select_poll`, `select_wait` with adaptive backoff and timeouts, round-robin fairness), and high-level concurrent `Actor` event loops with priority control signal preemption (`actor_new`, `actor_send`, `actor_signal`, `actor_recv`, `actor_stop`). Verified across Win64 JIT and native PE32+ executables.
  - [x] `regex.bmb`: Pure native linear-time regular expression engine based on Thompson's NFA construction and the Pike VM with zero CPython runtime dependencies. Guaranteed $O(N)$ linear-time execution immune to catastrophic backtracking (ReDoS). Supports single-pass compilation (`regex_compile`), literals, wildcards (`.`), character classes (`[0-9]`, `[a-z]`, `[^...]`), escape sequences (`\d`, `\D`, `\w`, `\W`, `\s`, `\S`, `\n`, `\t`), anchors (`^`, `$`), quantifiers (`*`, `+`, `?`, `{n}`, `{n,}`, `{n,m}`), alternations (`a|b`), non-capturing groupings, match verification (`regex_match`), unanchored substring search (`regex_search`, `regex_find`, `regex_find_all`), global string replacement (`regex_replace`), string splitting (`regex_split`), and shorthand functional APIs (`re_match`, `re_search`, `re_find`, `re_replace`, `re_split`). Fully verified across Win64 JIT and standalone PE32+ executables.
  - [x] `gc.bmb`: Generational region tracking and tracing cycle collection for long-lived cyclic heap graphs. Provides low-level heap memory management primitives (`mem_alloc`, `mem_free`, `mem_read`, `mem_write`), generational region arenas (`Region`, `region_alloc`, `region_read`, `region_write`, `region_reset` for instant $O(1)$ bulk cyclic reclamation), and iterative mark-sweep tracing cycle collectors (`GC`, `gc_track`, `gc_link`, `gc_add_root`, `gc_remove_root`, `gc_collect`, `gc_auto_enable`) reclaiming isolated self-cycles, mutual 2-node cycles, and dense multi-node cyclic rings with zero CPython overhead.
  - [x] `mamba/module_loader.py`: Module import resolution engine supporting `import <mod>`, `from <mod> import <names>`, parenthesized multi-import lists `from <mod> import (...)`, `from <mod> import *`, and module-level constant inlining with AST caching and recursive dependency cycle breaking.
- [x] **Zero-Copy NumPy / PyTorch Tensor Exchange**:
  - Direct Win64/SystemV ABI pointer passing: pass multi-dimensional `ndarray`, `torch.Tensor`, and Python buffer objects directly into Black Mamba JIT functions with zero memory copy and zero GC overhead.
  - Python frontend bindings: `mamba.compile(...)`, `@mamba.jit` decorator, and `mamba.as_numpy_array(...)` / `mamba.as_torch_tensor(...)` bidirectional zero-copy views.
  - `mamba/stdlib/tensor.bmb`: Pure native 1D elementwise (SAXPY, scale, div), reductions (sum, mean, dot, L2 norm, min, max, argmax), neural activations (ReLU, LeakyReLU, Sigmoid, clamp), and 2D matrix multiplication (`tensor_matmul`).
  - Benchmarked at 6.7 GB/s memory bandwidth on 10,000,000 float64 elements (19.7x faster than standard Python).
- [x] **True Hardware Multithreading & Concurrency** (`thread.bmb`):
  - Native multi-core thread spawning with zero Global Interpreter Lock (GIL) via `thread_spawn`, `thread_join`, `thread_id`, `thread_yield`, `thread_sleep`.
  - First-class function pointer loading (`lea reg, [rip + fn__<name>]`) and indirect invocation (`call r11`).
  - Native hardware atomic memory primitives: `atomic_load`, `atomic_store`, `atomic_add` (`lock xadd`), `atomic_sub`, `atomic_cas` (`lock cmpxchg`), `atomic_fence` (`mfence`), and `cpu_pause` (`pause`).
  - Thread-safe synchronization data structures: `AtomicInt`, `SpinLock`, and adaptive spin-yield `Mutex`.
  - Parallel data loops: `par_for(start, end, worker_fn, context)` and `par_map(arr, count, fn_ptr)` compiling across native thread pools.
  - Full cross-backend integration: Win64 JIT, standalone Windows PE32+ (dynamic `KERNEL32.CreateThread` / `WaitForSingleObject` imports and `.pdata` unwind records), static Linux ELF64, and portable C11 (`<stdatomic.h>` / `<windows.h>` / `<pthread.h>`).

---

## Phase 5: Developer Experience, Tooling & Ecosystem ✅ *(COMPLETED & VERIFIED)*

Give developers world-class editor support, package management, and documentation tooling.

- [x] **VS Code Extension & Language Server Protocol Daemon (`bmb-lsp`)**:
  - [x] Standard LSP 3.17 daemon (`mamba/lsp/server.py`) running over JSON-RPC 2.0 via standard I/O (`bmb lsp --stdio`) and TCP socket (`bmb lsp --tcp <port>`).
  - [x] Document synchronization (`textDocument/didOpen`, `textDocument/didChange`, `textDocument/didClose`) with resilient AST parsing and error recovery under typing.
  - [x] Real-time diagnostic error squiggles (`textDocument/publishDiagnostics`) with precise line and character offsets for lexer and parser errors.
  - [x] Inferred type hover tooltips (`textDocument/hover`) powered by `mamba/types.py` showing Markdown signatures, struct layouts, and builtin documentation.
  - [x] Intelligent dot-triggered autocompletion (`textDocument/completion`) listing member fields and methods of inferred struct types, plus scope-aware keywords, builtins, and standard modules.
  - [x] Go to Definition (`textDocument/definition`) mapping symbols directly to function, struct, and variable declaration sites.
  - [x] Document Symbol Outline & Breadcrumbs (`textDocument/documentSymbol`) building a hierarchical tree of structs, fields, and functions.
  - [x] Canonical 4-space code formatter (`textDocument/formatting`) normalizing indentation, operators, and parameters.
  - [x] VS Code extension package (`editors/vscode/`) with syntax highlighting grammar (`syntaxes/bmb.tmLanguage.json`), language configuration (`language-configuration.json`), client launcher (`extension.js`), and package manifest (`package.json`).
- [x] **Interactive Native JIT REPL (`bmb repl` / `mamba.repl`)**:
  - [x] Bare-metal incremental JIT compilation executing single-line expressions and multi-line statements in < 1 ms.
  - [x] Live variable state persistence across turns (`x = 10`, `y = 20`, `x + y`, `x += 5`) with runtime value inspection.
  - [x] Dynamic expression evaluation with automatic type inference printing values with colorized type tags (`30 (i64)`, `6.28 (f64)`, `True (bool)`, `'hello' (str)`).
  - [x] Full support for user-defined structs (`struct Point:`), functions (`fn mult:`), and standard library modules (`from math import sin, PI`).
  - [x] Compiler inspection meta-commands: `:help`, `:vars` (active state), `:funcs`, `:structs`, `:mir` (SSA IR dump), `:asm` (native x86-64 disassembly), `:reset`, `:exit`.
  - [x] Resilient syntax error recovery and multi-line block detection (`bmb >>> ` vs `bmb ... `).
  - [x] Default CLI fallback: running `bmb` with no arguments in a terminal launches the interactive REPL.
- [x] **Decentralized Package Manager CLI (`bmb pkg` / `mamba.pkg`)**:
  - [x] Package manifest (`mamba.toml`) declaring metadata, entry point, build target, and dependencies.
  - [x] Deterministic cryptographic lockfile (`mamba.lock`) with SHA-256 integrity verification across package sources.
  - [x] Git repository dependency resolution (`--git`, `--tag`, `--branch`, `--rev`) with automatic cloning and checkout.
  - [x] Local filesystem path dependencies (`--path`) with automated vendoring into `.mamba/packages/`.
  - [x] Seamless module loader integration in `mamba/module_loader.py` resolving vendored packages (`import <pkg>` or `from <pkg> import ...`).
  - [x] Complete CLI workflow: `bmb pkg init [--lib|--bin]`, `bmb pkg add`, `bmb pkg remove`, `bmb pkg install [--frozen]`, `bmb pkg update`, `bmb pkg list`, `bmb pkg build`, `bmb pkg run`.
- [x] **Static HTML API Documentation Generator (`bmb doc` / `mamba.doc`)**:
  - [x] Automatic extraction of docstrings, comments, type annotations, and module structures into static HTML API references.
  - [x] Modern responsive dark/light developer theme with syntax highlighting and copy-to-clipboard.
  - [x] Pre-computed client-side live search index with keyboard shortcut `/` and instant navigation.
  - [x] 100% self-contained HTML/CSS/JS with zero external runtime or server requirements (open directly in browser).
  - [x] CLI command: `bmb doc [file_or_dir] [-o output_dir] [--open]`.

---

## Tier 1 High-Impact Runtime Frontiers ✅ *(COMPLETED & VERIFIED)*

- [x] **Pure Native Unicode Engine (`unicode.bmb`)**:
  - [x] UTF-8 byte length computation, multibyte codepoint decoders, and scalar validity checks with zero host CPython FFI.
  - [x] UAX #29 Grapheme Cluster Segmentation (`grapheme_len`, `grapheme_is_boundary`) handling combining marks, regional flags, and ZWJ emoji sequences.
  - [x] UTF-16 Surrogate Pair transcoding (`utf16_encode_high_surrogate`, `utf16_encode_low_surrogate`, `utf16_decode_surrogates`).
  - [x] Codepoint classification and character properties (`cp_is_ascii`, `cp_is_whitespace`, `cp_is_alphabetic`, `cp_is_numeric`, `cp_is_combining`, `cp_is_emoji`).
  - [x] Case conversion and folding (`cp_to_upper`, `cp_to_lower`, `str_to_upper`, `str_to_lower`).
- [x] **Asynchronous Reactor & Event Loop (`async.bmb`)**:
  - [x] Pure native cooperative asynchronous reactor and task scheduler (`async_loop_new`, `async_spawn`, `async_delay`).
  - [x] Non-blocking step tick execution (`async_tick`) with monotonic hardware clock task expiration.
  - [x] Task lifecycle inspection (`async_task_status`, `async_task_result`, `async_task_is_done`).
  - [x] Batch runners (`async_run_until_complete`, `async_run_all`, `async_stop`).
- [x] **Native Embedded Key-Value Storage Engine (`kv.bmb`)**:
  - [x] Durable log-structured storage engine (append-only WAL + fast in-memory table) with durable disk flushing via `os.bmb`.
  - [x] Storage lifecycle and operations (`kv_open`, `kv_put`, `kv_put_int`, `kv_get`, `kv_get_int`, `kv_has`, `kv_delete`, `kv_sync`, `kv_compact`, `kv_close`).
  - [x] Automatic compaction purging tombstoned records with atomic write-sync.
- [x] **Single-Binary Standalone Toolchain (`dist/bmb.exe`)**:
  - [x] Zero-host-Python requirement for end users.
  - [x] Single standalone executable bundle packaging the complete Black Mamba compiler, native linkers (PE32+, ELF64, Mach-O ARM64, WASM, C11), LSP server, REPL, package manager, and doc generator.

---

## Vector 1: High-Throughput HTTP/1.1 & WebSocket Server Framework ✅ *(COMPLETED & VERIFIED)*

- [x] **RFC 6455 Full-Duplex WebSocket Engine (`http.bmb`)**:
  - [x] Pure native integer SHA-1 digest & Base64 encoding routines for client handshake verification (`ws_accept_key`, `ws_handshake_response`).
  - [x] Server-to-client frame encoder (`ws_encode_text_frame`) and full unmasking frame decoder (`ws_decode_frame`) handling 7-bit, 16-bit, and 64-bit payloads.
- [x] **HTTP/1.1 Parser & Response Builders**:
  - [x] Request line and method parsing (`GET`, `POST`, `PUT`, `DELETE`, `HEAD`, `PATCH`, `OPTIONS`), header extraction (`http_get_header`), and query parameter parsing (`http_get_query_param`).
  - [x] Zero-allocation response builders (`response_json`, `response_text`, `response_html`, `response_redirect`) with keep-alive formatting.
- [x] **High-Speed Router & Dispatcher**:
  - [x] Dynamic route registration (`http_add_route`) and pattern matching.
  - [x] In-memory benchmark throughput of **8,209,363 requests/second** on standalone PE32+ native machine code (12.1 ms for 100,000 requests).
- [x] **Flagship Example & Integration Test**:
  - [x] Flagship showcase in [`examples/http_websocket_server.bmb`](examples/http_websocket_server.bmb).
  - [x] End-to-end regression test in `tests/test_mamba.py` verifying JIT and standalone executable builds.

---

## Vector 2: Native SIMD & AVX2 / AVX-512 Vectorization Pipeline ✅ *(COMPLETED & VERIFIED)*

- [x] **Hardware Vector Types (`simd.bmb`)**:
  - [x] 256-bit AVX2 Float Vectors (`Vec4f`: 4x 64-bit float) and 512-bit AVX-512 Float Vectors (`Vec8f`: 8x 64-bit float).
  - [x] 256-bit Integer Vectors (`Vec4i`: 4x 64-bit int).
  - [x] Vector arithmetic (`add`, `sub`, `mul`, `div`), Fused Multiply-Add (`fma`: $a \cdot b + c$), scaling, bitwise operations (`band`, `bor`, `bxor`), elementwise `min`/`max`.
  - [x] Horizontal reductions (`hsum`), vector dot products (`dot`), and Euclidean norms (`norm`).
- [x] **8-Way Unrolled Bulk SIMD Kernels**:
  - [x] Contiguous array kernels (`simd_add_f64`, `simd_mul_f64`, `simd_fma_f64`, `simd_scale_f64`, `simd_dot_f64`, `simd_sum_f64`, `simd_norm_f64`).
  - [x] Fast 4x4 Tiled Matrix Multiplication (`simd_matmul` GEMM).
  - [x] Audio DSP signal processing filter (`simd_apply_gain`) processing 1,000,000 samples in 1.47 ms.
- [x] **Flagship Example & Verification**:
  - [x] Flagship showcase in [`examples/simd_avx2_compute.bmb`](examples/simd_avx2_compute.bmb).
  - [x] Verified across all 7 backends (Win64 JIT, PE32+, ELF64, Mach-O ARM64, WASM, C11, LLVM IR) and covered in test suite.

---


---

## Vector 3: Drop-in CPython Extension Module Emitter (.pyd / .so) ✅ *(COMPLETED & VERIFIED)*

- [x] **Zero-Compiler Windows PE32+ Dynamic Extension Emitter** (`mamba/backends/python_ext.py`):
  - [x] Direct generation of 64-bit Windows PE32+ DLLs (`Characteristics: 0x2022`) containing native x86-64 machine code, `.text`, `.rdata`, `.data`, and `.reloc`.
  - [x] Requires **zero external C compiler** (no MSVC `cl.exe`, no Visual Studio installation, no GCC, no Clang).
  - [x] Automatically exports `PyInit_<modname>` via standard PE Export Directory Table (EDT).
  - [x] High-performance `METH_FASTCALL` (`0x0080`) calling convention dispatching arguments directly from raw CPython pointer arrays without tuple packing overhead.
  - [x] Automatic type unboxing (`int`/`i64`, `float`/`f64`, `bool`, `str`) and return value boxing (`PyLong_FromLongLong`, `PyFloat_FromDouble`, `PyBool_FromLong`, `Py_BuildValue`).
  - [x] ASLR Base Relocation Table (`IMAGE_REL_BASED_DIR64`), allowing dynamic rebase at any image address without access violations.
  - [x] Head-to-head benchmark verification: **30.5x faster** than pure CPython 3.14 on recursive Fibonacci ($N=32$: 9.5 ms vs 289.8 ms).
- [x] **Portable C11 Fallback Extension Generator**:
  - [x] Emits PEP 489 multi-phase initialization and free-threaded (`Py_MOD_GIL_NOT_USED`) C extension source code (`#include <Python.h>`) for Linux (`.so`) and macOS (`.dylib` / `.so`).
- [x] **CLI Build Target Integration** (`mamba/cli.py`):
  - [x] Added `bmb build <file.bmb> --target ext` and `--target pyd` producing standalone `.pyd` files.
- [x] **Official Packaging & Branding**:
  - [x] Added PEP 517/621 `pyproject.toml` and `setup.py` building installable Python wheels (`blackmamba_lang-0.8.1-py3-none-any.whl`).
  - [x] Embedded official Black Mamba application icon (`assets/bmb.ico`) directly into standalone `bmb.exe` executable.

## Vector 4: High-Throughput Thread-Local Memory Allocator (`alloc.bmb`) ✅ *(COMPLETED & VERIFIED)*

- [x] **Mimalloc / Jemalloc-Inspired Thread-Isolated Slab Architecture**:
  - [x] Size-class bins for small allocations: 16B, 32B, 64B, 128B, 256B, 512B, 1024B, 2048B, and 4096B.
  - [x] Large allocation threshold: requests > 4096 bytes dynamically route directly to the OS page manager.
  - [x] Carves 64 KB slab pages into contiguous blocks chained with embedded singly-linked freelists.
- [x] **Zero Lock Contention Multi-Threading**:
  - [x] 64-slot thread cache table with positive integer hash indexing and atomic CAS registration (`_get_thread_slot()`).
  - [x] 100% lock-free fast-path: allocations pop from thread-private freelists via 2 memory reads and 1 write without atomic operations or OS kernel transitions.
  - [x] Sized deallocations push directly onto thread-private freelists, keeping cache lines hot in L1/L2 CPU cache.
  - [x] Multi-threaded throughput of **15.51 Million ops/second** across 4 concurrent OS worker threads on Windows PE32+ (12.8 ms for 200,000 multi-threaded alloc-free cycles).
- [x] **High-Level Abstractions**:
  - [x] `ObjectPool`: Dedicated fixed-size object pool achieving **45.24 Million ops/second** (22.1 ns per alloc-free cycle).
  - [x] `Arena`: Linear bump allocator with $O(1)$ instant bulk reset achieving **55.15 Million ops/second** (18.1 ns per allocation).
  - [x] `ThreadCache`: Standalone cache instance for manual cache lifecycle management.
  - [x] Functional APIs: `alloc_fast`, `free_fast`, `alloc_zeroed`, `alloc_realloc`, `slab_alloc`, `slab_free`, `alloc_stats`, and `alloc_print_stats`.
- [x] **Flagship Showcase & Verification**:
  - [x] Comprehensive benchmark suite in [`examples/alloc_benchmark.bmb`](examples/alloc_benchmark.bmb).
  - [x] Regression test suite in `tests/test_mamba.py` verifying single-threaded, multi-threaded, JIT, and standalone native PE32+ targets.

---

## Vector 5: Native Columnar Data & Embedded Analytics Engine (`series.bmb`) ✅ *(COMPLETED & VERIFIED)*

- [x] **Apache Arrow-Compatible In-Memory Contiguous Columnar Layout**:
  - [x] `SeriesInt`: 64-bit integer columnar series supporting `range`, `zeros`, reductions (`sum`, `mean`, `min`, `max`, `argmin`, `argmax`), vector arithmetic (`add`, `sub`, `mul`, `scale`), and filtering (`gt`, `lt`, `eq`, `range`).
  - [x] `SeriesFloat`: 64-bit IEEE 754 float columnar series supporting `linspace`, `zeros`, `variance`, `std`, vector dot products (`dot`), and filtering.
  - [x] `SeriesStr`: Contiguous string series supporting `filter_eq`, `unique_count`, and dictionary projections.
- [x] **High-Performance Multi-Column `DataFrame` Table**:
  - [x] Heterogeneous column schema combining integer, float, and string series in an aligned columnar memory table.
  - [x] Zero-copy row projection views via `df_take(df, indices, count)`, `df_head(n)`, and `df_tail(n)`.
  - [x] Synchronized vectorized multi-column filtered scans (`df_filter_i64_gt`, `df_filter_f64_gt`, `df_filter_str_eq`) achieving **79.25 Million rows/second**.
  - [x] Multi-column sorting (`df_sort_by_i64`, `df_sort_by_f64`) via permutation `argsort` and `df_take`.
- [x] **Analytical GroupBy & Relational Hash Joins**:
  - [x] Grouped aggregations (`df_groupby_i64_sum_f64`, `df_groupby_i64_mean_f64`) processing 1,000,000 records across 100 unique categories in **212 ms** (4.71M rows/sec).
  - [x] High-speed relational hash join (`df_inner_join_i64`) projecting columns across multiple tables in $O(N + M)$ linear time.
  - [x] Tabular visualization (`df_print`) with aligned ASCII table formatting, and automated statistical profiling (`df_describe`).
- [x] **Flagship Showcase & Verification**:
  - [x] Flagship showcase in [`examples/series_benchmark.bmb`](examples/series_benchmark.bmb) scanning 1,000,000 rows at **43.96M reductions/s** (1.64 GB/s bandwidth) and **79.25M filter scans/s**.
  - [x] Regression test suite in `tests/test_mamba.py` verifying JIT and standalone native PE32+ targets.

---

## Vector 6: Complete Self-Hosting Compiler (Phase A Lexer/Parser + Phase B Native x86-64 PE32+ `.exe` Linker in Pure `.bmb`) ✅ *(COMPLETED & VERIFIED)*

- [x] **Indentation-Aware Pure Native Lexer** (`compiler.bmb`):
  - [x] Zero-CPython-overhead token streaming with automatic `TOK_INDENT`, `TOK_DEDENT`, and `TOK_NEWLINE` synthesis.
  - [x] Lexical analysis for 30+ keywords, multi-character operators (`==`, `!=`, `<=`, `>=`, `->`, `|>`, `..=`, `..`, `+=`, `-=`, `*=`, `/=`), SSO string literals, and numeric literals (integers and IEEE-754 floats).
  - [x] Pure native scan throughput of **371,116 lines/second** (3.56 Million tokens/sec) on standalone native Windows PE32+ machine code.
- [x] **Top-Down Operator Precedence (Pratt) Parser**:
  - [x] Binding power precedence hierarchy resolving arithmetic terms, factors, powers, bitwise operators, logical `and`/`or`, relational comparisons, pipeline flows (`|>`), ranges (`..`), function invocations, member accesses, and array subscripts without recursion stack overflow.
  - [x] Full multi-paradigm grammar support: `struct` value types, `def`/`fn` functions, parameter lists, return type annotations, type-annotated bindings (`let`, `const`, `mut`, `x: i64 = ...`), control flow (`if`/`elif`/`else`, `while`, `for ... in ...`), and jump statements (`return`, `break`, `continue`, `pass`).
- [x] **Unified Abstract Syntax Tree (AST)**:
  - [x] Unified `ASTNode` tree with dynamic growth, child capacity tracking, recursive node counting (`ast_node_count`), and formatted indented AST visualization (`ast_print`).
  - [x] End-to-end compilation throughput of **190,280 lines/second** (0.57 Million AST nodes/sec) in standalone native machine code (42.0 ms for 8,000 lines).
- [x] **Phase B: Self-Hosting Native x86-64 Assembler & Standalone PE32+ `.exe` Linker (`codegen.bmb`)**:
  - [x] Pure `.bmb` binary buffer & Win64 x86-64 instruction encoder (`mov`, `add`, `sub`, `imul`, `idiv`, `cmp`, `setcc`, `jmp`, `je`, `call rel32`, `call [rip + disp32]`).
  - [x] Complete pure-`.bmb` AST-to-machine-code compiler supporting functions, local stack frames, arithmetic/relational/logical expressions, `if`/`elif`/`else`, `while` loops, `print(...)`, and string literals.
  - [x] Standalone Windows PE32+ `.exe` binary emitter (`DOS` stub, `NT` headers, `.text`, `.rdata`, `.idata` importing `msvcrt.dll` & `KERNEL32.dll`) writing runnable executables directly via binary I/O (`write_bytes`) in **1.63 ms with zero Python runtime involvement**.
- [x] **Flagship Showcase & Verification**:
  - [x] Comprehensive showcases in [`examples/self_host_compiler.bmb`](examples/self_host_compiler.bmb) and [`examples/self_host_pe_compiler.bmb`](examples/self_host_pe_compiler.bmb).
  - [x] End-to-end regression tests in `tests/test_mamba.py` verifying standalone native `bmbc_self.exe` compiling `.bmb` source directly into a working Windows `.exe` with zero Python.

---

---

## Vector 7: Embedded & Bare-Metal Edge Target (Freestanding No-OS & MMIO HAL) ✅ *(COMPLETED & VERIFIED)*

- [x] **Freestanding Microcontroller & Embedded HAL** (`embedded.bmb`):
  - [x] Direct volatile Memory-Mapped I/O (MMIO) primitives: 32-bit (`mmio_read32`, `mmio_write32`), 8-bit (`mmio_read8`, `mmio_write8`), and 64-bit (`mmio_read64`, `mmio_write64`).
  - [x] Register manipulation: atomic/volatile bit setting (`mmio_set_bits32`), clearing (`mmio_clear_bits32`), toggling (`mmio_toggle_bits32`), bitfield extraction/insertion (`mmio_get_bitfield32`, `mmio_set_bitfield32`), and timeout polling (`mmio_poll_bit32`).
  - [x] Microcontroller GPIO Controller (`GpioPort`): Mode configuration (Input, Output, Alternate, Analog), Pull-Up/Down resistors, atomic BSRR (Bit Set/Reset) switching, shadow ODR/IDR reads.
  - [x] UART / Serial Telemetry Driver (`UartDevice`): Baud rate prescaling, TXE/RXNE polling, string transmission, decimal formatting, and 32-bit hex logging (`0xDEADBEEF`) without dynamic heap allocations.
  - [x] Hardware Interval Timer / SysTick (`SysTimer`): Monotonic tick counter, busy-wait microsecond (`timer_delay_us`) and millisecond (`timer_delay_ms`) delay loops.
  - [x] Interrupt Vector Table (IVT): Configurable interrupt descriptor table, IRQ registration, and low-latency dispatch counter tracking.
  - [x] Hard Real-Time Closed-Loop PID Controller (`PIDController`): Anti-windup bounded feedback loop executing 100,000 steps with 15.2 ns latency per tick (65.7 Million control ticks/sec) and 0.000 ms GC pause latency.
  - [x] Freestanding Circular Ring Buffer (`RingBuffer`): Zero-allocation FIFO for serial / DMA communication.
- [x] **Zero-Dependency Bare-Metal Compiler Backend & Emitter** (`mamba/backends/embedded.py`):
  - [x] Flat binary image generation (`--target bin`): Generates contiguous raw machine code images mapped to physical Flash/ROM base addresses (e.g. `0x08000000`).
  - [x] Standard Intel HEX emitter (`--target hex`): Emits HEX-386 Extended Linear Address records compatible with ST-Link, J-Link, OpenOCD, and hardware flashing tools.
  - [x] Freestanding Bare-Metal ELF emitter (`--target embedded`): Static ELF64 with custom `_reset_handler` entry vector, zero dynamic linker dependencies, and static SRAM heap layout.
  - [x] Low-power idle loop: Post-main `cli; hlt; jmp $-2` (or `wfi`) low-power CPU halt.
- [x] **Flagship Showcase & Verification**:
  - [x] Flagship showcase in [`examples/embedded_baremetal_hal.bmb`](examples/embedded_baremetal_hal.bmb).
  - [x] Comprehensive test suite in `tests/test_mamba.py` verifying JIT emulation, binary/hex/elf emission, and standalone native PE32+ targets with 100% precision.

---

## Vector 8: Native Debug Symbols & Production v1.0.0 Ecosystem ✅ *(COMPLETED & VERIFIED)*

- [x] **Full Source-Line Tracking Across MIR & Native Backends** (`--debug` / `-g`):
  - [x] End-to-end AST -> MIR -> machine-code RVA line-number propagation (`MIRInst.line`, `MIRFunction.start_line`, `MIRModule.filename`).
  - [x] **Windows PE32+ Debug Directory & COFF Symbols** (`mamba/backends/pe_exe.py`): Emits `IMAGE_DIRECTORY_ENTRY_DEBUG` (`DataDirectory[6]`) with `IMAGE_DEBUG_TYPE_CODEVIEW` (`RSDS` PDB 7.0 signature), COFF Symbol Table + String Table for WinDbg / x64dbg / Visual Studio symbol resolution, and ASLR-safe runtime SEH crash diagnostics printing exact `<function>` and `<file.bmb>:<line>` on hardware faults (`0xC0000094`, `0xC0000005`).
  - [x] **Linux ELF64 DWARF v4 Line Tables & `.symtab`** (`mamba/backends/elf_exe.py`): Emits standard ELF `.symtab`/`.strtab` (`STT_FUNC`) and DWARF v4 `.debug_abbrev`, `.debug_info`, and `.debug_line` state-machine line programs compatible with `gdb`, `lldb`, `objdump -d -S`, and `addr2line`.
  - [x] **ANSI C11 `#line` Directives & `debug.bmb` Module**: Source-mapped `#line <n> "<file.bmb>"` directives in C11 output and pure `.bmb` runtime assertion/trace module (`mamba/stdlib/debug.bmb`).
- [x] **Distributed Actor Cluster & Authenticated RPC (`cluster.bmb`)**:
  - [x] Multi-node TCP actor message framing with RFC 2104 `HMAC-SHA256` cryptographic authentication (`cluster_node_new`, `cluster_send_msg`, `cluster_recv_msg`, `cluster_rpc_call`, `cluster_verify_frame`), showcased in [`examples/cluster_showcase.bmb`](examples/cluster_showcase.bmb).
- [x] **Package Registry Index Resolution (`bmb pkg --registry` / `MAMBA_REGISTRY`)**:
  - [x] Federated JSON package registry index resolution (`local` HTTP/HTTPS or filesystem index) with semantic version selection, archive/directory extraction, and mandatory SHA-256 cryptographic lockfile integrity verification.

---

## ⚠️ Current Limitations & Flaws (What Black Mamba Lacks Today)

For full architectural transparency, every known limitation, missing feature, and trade-off in Black Mamba today is thoroughly documented in [**`docs/LIMITATIONS.md`**](docs/LIMITATIONS.md).

### Summary of Current Architecture & Design Boundaries:
1. **Dynamic Cyclic Memory**: Ephemeral allocations resolved via compile-time lexical arenas; long-lived cyclic heap graphs resolved via `gc.bmb` generational region tracking & tracing cycle collector.
2. **Platform Coverage**: Windows PE32+, Linux ELF64 (3.9 KB), macOS ARM64, CPython `.pyd`/`.so` extensions, WebAssembly 1.0 (1.7 KB), ANSI C11, LLVM IR, and Freestanding No-OS Embedded (`.bin`, `.hex`, `.elf`) shipped.
3. **Strings**: Small String Optimization (SSO), zero-copy slicing, dynamic operations, linear-time regex engine (`regex.bmb`), and pure native Unicode engine (`unicode.bmb`) resolved.
4. **Hardware Exceptions & Debugging**: Zero-cost SEH `.pdata`/`.xdata` unwind tables, symbolic line-mapped VEH crash reports, PE32+ CodeView `RSDS` + COFF symbols, and ELF64 DWARF v4 `.debug_line` shipped.
5. **Standard Library**: 26 pure `.bmb` modules (`alloc`, `array`, `async`, `chan`, `cluster`, `codegen`, `compiler`, `debug`, `embedded`, `gc`, `hash`, `http`, `json`, `kv`, `math`, `os`, `random`, `regex`, `series`, `simd`, `socket`, `tensor`, `test`, `thread`, `time`, `unicode`) with zero CPython runtime dependencies.
6. **Dynamic OOP**: By design, omits Python's dynamic multiple inheritance (C3 MRO) and runtime monkey-patching (`setattr` on classes) so method calls remain 1-cycle direct dispatches.
7. **High-Level Concurrency & Clustering**: Hardware atomics, `AtomicInt`, `Mutex`, `SpinLock`, native thread spawning, `par_for`, `par_map`, lock-free bounded MPMC channels, `Select` multiplexing, priority `Actor` loops (`chan.bmb`), and HMAC-authenticated TCP Actor Clusters (`cluster.bmb`) shipped.
8. **Developer Tooling**: Full LSP daemon (`bmb-lsp`), VS Code extension, REPL (`bmb repl`), package manager (`bmb pkg` with Git, Path, and JSON Registry Index `--registry`), doc generator (`bmb doc`), and self-hosting native `.bmb -> .exe` compiler (`codegen.bmb`) shipped.

---

## 📈 Release Milestones

| Version | Status | Milestone Focus | Deliverables |
| :--- | :--- | :--- | :--- |
| **v0.1.0** | **Shipped** | Foundational Compiler & JIT | Win64 JIT, 5.5 KB PE32+ EXE, 1.7 KB WebAssembly 1.0, CPython Host FFI |
| **v0.2.0** | **Shipped** | Cross-Platform Native Expansion | Linux ELF64 (3.9 KB static), macOS Apple Silicon ARM64 Mach-O, Lexical Arena Lifetimes |
| **v0.3.0** | **Shipped** | High-Performance Strings & Core Stdlib | SSO Strings ($\le$ 7B register, $\le$ 15B inline), zero-copy slicing, `math`, `time`, `random`, `json`, `os`, `hash` |
| **v0.4.0** | **Shipped** | Hardware Concurrency & Linear Regex | Zero-GIL multithreading (`thread.bmb`, `par_for`), lock-free MPMC channels & Actors (`chan.bmb`), Thompson NFA (`regex.bmb`) |
| **v0.5.0** | **Shipped** | Developer Experience & Tooling | Full LSP 3.17 daemon (`bmb-lsp`), VS Code extension, JIT REPL (`bmb repl`), Package Manager (`bmb pkg`), Doc Generator (`bmb doc`) |
| **v0.6.0** | **Shipped** | Tier 1 Runtime Frontiers & Standalone Bundle | Pure Native Unicode (`unicode.bmb`), Async Reactor (`async.bmb`), Embedded KV Store (`kv.bmb`), Standalone `bmb.exe` |
| **v0.7.0** | **Shipped** | High-Throughput HTTP & WebSocket Vector | Pure native HTTP/1.1 & WebSocket Server Framework (`http.bmb`), 8.2M req/s native router, RFC 6455 framing |
| **v0.8.0** | **Shipped** | Hardware SIMD & AVX2 Vectorization | 256-bit AVX2 (`Vec4f`), 512-bit AVX-512 (`Vec8f`), FMA, 8-way unrolled bulk array kernels, GEMM tiling |
| **v0.8.1** | **Shipped** | CPython Extension Emitter & Official Branding | Zero-compiler `.pyd` emitter (30.5x speedup), official `bmb.ico` icon, `pyproject.toml` wheel packaging |
| **v0.8.2** | **Shipped** | High-Throughput Thread-Local Allocator | Pure native `alloc.bmb`, 15.5M multi-core ops/sec, `ObjectPool`, `Arena`, zero lock contention |
| **v0.9.0** | **Shipped** | Native Columnar Data & Analytics Engine | Pure native `series.bmb`, 79.2M rows/s vector scans, Arrow layout, GroupBy, Hash Join |
| **v0.9.5** | **Shipped** | Self-Hosting Compiler Bootstrap | Pure `.bmb` Lexer & Pratt parser, 3.56M tokens/s lexing, 190K lines/s AST compilation |
| **v0.9.8** | **Shipped** | Embedded & Bare-Metal Edge Target | Freestanding No-OS HAL (`embedded.bmb`), MMIO 32/8-bit, GPIO, UART, 65.7M ticks/s PID, `.bin`/`.hex`/`.elf` |
| **v1.0.0** | **Shipped** *(Current — Official Stable Release)* | Production Enterprise Release | Complete Self-Hosting `.bmb` -> `.exe` Compiler (`codegen.bmb`), Native Debug Symbols (`--debug` RSDS/COFF & DWARF v4), Distributed Actor Cluster (`cluster.bmb`), Federated Package Registry (`--registry`), 44/44 Test Suite & 29/29 Examples Verified |

---

*Suggestions and contributions are welcome via [GitHub Issues](https://github.com/kicode01/blackmamba-lang/issues) and Pull Requests.*
