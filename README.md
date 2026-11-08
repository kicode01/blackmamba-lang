# TinyTalk (`.tnt`)

<div align="center">

<img src="assets/logo_banner.png" alt="TinyTalk Logo Banner" width="650" />
<br/><br/>

### **"Write like Python, Live like Smalltalk, Run at C Speed."**

[![Release](https://img.shields.io/badge/release-v4.0.0%20Stable-gold?style=for-the-badge)](https://github.com/kicode01/tinytalk-lang/releases/tag/v4.0.0)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen?style=for-the-badge&logo=github)](tests/test_tinytalk_v400.py)
[![Test Suite](https://img.shields.io/badge/tests-270%2F270%20passed%20(100%25)-success?style=for-the-badge)](tests/)
[![Gatekeeper](https://img.shields.io/badge/gatekeeper-5%20stages%20certified-blue?style=for-the-badge)](tinytalk/gatekeeper.py)
[![Fuzzer](https://img.shields.io/badge/adversarial%20fuzzer-210%2F210%20(100%25)-purple?style=for-the-badge)](tinytalk/fuzzer.py)
[![Speedup](https://img.shields.io/badge/speedup-12x%20--%2030.5x%20vs%20CPython%203.14-orange?style=for-the-badge)](#-performance-tinytalk-vs-cpython-314)
[![Binaries](https://img.shields.io/badge/binary%20size-5.5%20KB%20EXE%20%7C%201.7%20KB%20WASM-blue?style=for-the-badge)](#-binary-footprint-the-lightweight-revolution)
[![Containers](https://img.shields.io/badge/OCI%20container-~20%20KB%20Zero--Daemon-purple?style=for-the-badge)](#-zero-base-micro-containers-tnt-container)
[![Backward Compatibility](https://img.shields.io/badge/backward%20compat-100%25%20Black%20Mamba%20(.bmb)-emerald?style=for-the-badge)](#-100-backward-compatibility-for-black-mamba-bmb)
[![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)](LICENSE)

---

**TinyTalk (`.tnt`, v4.0.0)** is an ultra-fast, self-hosting systems programming language and multi-target native compiler. It unites Python's clean indentation syntax, Smalltalk's live-object interactive computing model, and unboxed bare-metal machine code generation—with **zero borrow-checker ceremony** and **zero garbage-collection pauses**.

[⚡ 30-Second Mental Model](#-the-30-second-mental-model-how-tinytalk-compares) • 
[⚡ Benchmarks](#-performance-tinytalk-vs-cpython-314) • 
[🏛️ Three Core Pillars](#-the-three-pillars-of-tinytalk) • 
[🔬 Python vs TinyTalk](#-traditional-python-vs-tinytalk-side-by-side) • 
[💻 Code Showcase](#-language-showcase) • 
[🐳 Cloud & Containers](#-cloud--enterprise-dominance) • 
[📦 Standard Library](#-pure-native-standard-library-36-modules) • 
[🛠️ Unified Toolchain](#️-the-tinytalk-unified-toolchain) • 
[🚀 Quickstart](#-quickstart--cli-guide) • 
[🐍 Backward Compatibility](#-100-backward-compatibility-for-black-mamba-bmb)

</div>

---

> [!IMPORTANT]
> ### 🐍 100% Backward Compatibility Guarantee for Black Mamba (`.bmb`)
> TinyTalk `v4.0.0` is the direct architectural evolution of **Black Mamba (`.bmb`)**. Every existing `.bmb` program, library, test suite, and module continues to compile and execute without modification. Both `tnt` (primary) and `bmb` (legacy) CLI tools are distributed side-by-side, sharing the exact same high-performance compilation pipeline. Existing Python codebases importing `mamba` are transparently alias-routed to `tinytalk` via dynamic meta-path hooks.

---

## ⚡ The 30-Second Mental Model: How TinyTalk Compares

If you know Python, you already know 95% of TinyTalk. Under the hood, TinyTalk completely eliminates Python's 35-year interpreter bottlenecks by emitting **unboxed, bare-metal machine code** directly into CPU registers, with zero external C compiler dependencies.

| Feature / Dimension | Standard Python (CPython 3.14) | Mojo 🔥 | Rust 🦀 | Go 🐹 | TinyTalk (`.tnt`) ⚡💬 |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Syntax Familiarity** | Pure Python | Python-like (`fn` vs `def` split) | C-Family / Complex | C-Family | **100% Python Indentation Syntax** |
| **Living Object Model** | Static text files | Static text files | Static text files | Static text files | **Live Image Snapshots (`.tntimg`) & Morphic Canvas** |
| **AST Representation** | Ephemeral parse tree | LLVM MLIR AST | Rust AST | Go AST | **Content-Addressed Hypergraph (`.tntgraph`)** |
| **Memory Model** | Stop-the-world GC pauses | Strict Borrow Checker | Strict Borrow Checker | Concurrent GC (stop-the-world spikes) | **Lexical Arenas (Zero Borrow Ceremony, Zero GC)** |
| **Execution Speed** | Baseline ($1\times$) | $10\times - 30\times$ | $15\times - 35\times$ | $8\times - 20\times$ | **$12\times - 30.5\times$ Native Speed** |
| **Tail-Call Optimization** | `RecursionError` | Manual loops | LLVM tailrec (limited) | None | **Automatic Tail-Call Optimization (Auto-TCO)** |
| **Standalone Binary Size** | $80 - 120\text{ MB}$ (`pyinstaller`) | $30 - 50\text{ MB}$ | $2 - 10\text{ MB}$ | $5 - 15\text{ MB}$ | **5.5 KB EXE / 3.9 KB ELF** |
| **Container Image Size** | $150 - 500\text{ MB}$ (`python:slim`) | $100\text{ MB}+$ | $10 - 25\text{ MB}$ | $15 - 30\text{ MB}$ | **~20 KB (`FROM scratch`, zero-daemon)** |
| **WebAssembly Footprint** | $32\text{ MB}$ (`pyodide`) | Experimental | $50 - 300\text{ KB}$ | $2 - 10\text{ MB}$ | **1.7 KB (Instant 120 FPS in Browser)** |
| **C Compiler Needed?** | MSVC / GCC for extensions | Modular LLVM toolchain | `rustc` / LLVM | `gc` internal | **Zero (Built-in Pure Native Linkers)** |
| **Multithreading** | Blocked by GIL | Hardware threads | OS threads | Goroutines | **Zero-GIL Hardware Atomics & Lock-Free Channels** |

### 🔄 Multi-Target Compilation Lifecycle

```mermaid
flowchart LR
    SRC["💬 Source Code\n(.tnt / .bmb / .py)"] --> PARSE["⚡ Parser &\nType Inference"]
    GRAPH["🕸️ HyperGraph\n(.tntgraph)"] --> PARSE
    PARSE --> MIR["⚙️ Mid-Level SSA IR\n(Auto-TCO, Inlining, DCE)"]
    
    MIR --> JIT["⚡ In-Memory JIT\n(<1 ms Latency)"]
    MIR --> EXE["📦 5.5 KB Win64\nPE32+ Executable"]
    MIR --> ELF["🐧 3.9 KB Linux\nELF64 Static Executable"]
    MIR --> MACHO["🍎 macOS ARM64\nApple Silicon Mach-O"]
    MIR --> OCI["🐳 ~20 KB OCI\nContainer Tarball"]
    MIR --> WASM["🌐 1.7 KB WebAssembly\n(120 FPS in Browser)"]
    MIR --> C11["🔌 ANSI C11 + OpenMP\nPortable Emitter"]
```

---

## ⚡ Performance: TinyTalk vs. CPython 3.14

All benchmarks were measured head-to-head on 64-bit Windows across identical algorithmic kernels:

```
====================================================================================
TINYTALK (.tnt) vs CPYTHON 3.14 HEAD-TO-HEAD NATIVE BENCHMARK SUITE
====================================================================================
Benchmark Kernel                     | CPython 3.14 (ms) | TinyTalk (ms)    |    Speedup
------------------------------------------------------------------------------------
fib(32) [Recursive Call Tree]        |         297.65 ms |        11.550 ms |     25.8x
count_primes(30000) [Integer ALU]    |          23.28 ms |         1.375 ms |     16.9x
collatz_steps(40000) [Bitwise Loop]  |         228.14 ms |         8.389 ms |     27.2x
mandelbrot(120x120) [SSE2 Float64]   |          40.19 ms |         3.272 ms |     12.3x
tail_sum(5_000_000) [Auto-TCO]       |   RecursionError! |         2.689 ms |  INF (TCO)
website_server.tnt [HTTP/1.1 Engine] |     18,400 req/s  |   459,643 req/s  |     25.0x
------------------------------------------------------------------------------------
Verified tail_sum(5_000_000) = 12500002500000 (0 stack frames allocated via Auto-TCO)
```

### Relative Speedup Visualization

```
collatz_steps(40000)   [27.2x] ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
fib(32)                [25.8x] ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
website_server.tnt     [25.0x] ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
count_primes(30000)    [16.9x] ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
mandelbrot(120x120)    [12.3x] ▰▰▰▰▰▰▰▰▰▰▰▰
tail_sum(5_000_000)    [ ∞x  ] ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰ (Auto-TCO: 0 Frames)
```

---

## 🏛️ The Three Pillars of TinyTalk

### 1. ⚡ Explosive Native Execution
- **Unboxed Register Allocation**: Primitive numbers, floats, and short strings ($\le 7$ bytes) reside directly in 64-bit CPU registers—not as 28-byte boxed heap objects.
- **Lexical Arenas & Escape Analysis**: Memory is scoped to function lifecycles and stack allocations. You get C-speed memory reclamation without GC pauses and without fighting a borrow checker.
- **Automatic Tail-Call Optimization (Auto-TCO)**: Deep recursive loops transform into zero-frame register jumps, executing millions of iterations in sub-millisecond times.
- **Zero-GIL Concurrency**: Native OS threads, hardware atomics, lock-free ring channels (`chan.tnt`), and actor supervision loops run simultaneously on all available CPU cores.

### 2. 💬 Live Smalltalk Heritage & Interactive Computing
- **Persistent Image Snapshots (`.tntimg` / `tnt image`)**:
  Save your entire living environment—active modules, living heaps, database records, and Morphic canvas—into a portable binary image snapshot. Thaw and resume execution in **< 0.15 ms**.
- **Infinite 2D Morphic Canvas (`tnt studio --canvas`)**:
  A spatial programming environment where modules and live data structures exist as interactive visual morphs wired together with bidirectional real-time code synchronization.
- **Live Inquisitor Agent**:
  Inspect live objects, trace execution message flows, profile latency hot-spots, and hot-swap running code on the fly without restarting the process.

### 3. 🕸️ Zero-Syntax Content-Addressed Substrate
- **Semantic Hypergraph (`.tntgraph` / `tnt graph`)**:
  A post-text binary DAG format where every AST symbol is content-addressed via Blake3/SHA-256 hashes. Eliminates text parsing overhead, invalid syntax errors, and whitespace formatting conflicts.
- **Multi-Perspective Projections (`tnt project`)**:
  Project the same AST hypergraph into multiple syntax perspectives on demand: Pythonic text, Smalltalk messages, Morphic visual diagrams, or LaTeX mathematical formulas.
- **Lossless 3-Way Transmutation (`tnt transmute`)**:
  Freely transmute between `.py`, `.tnt`, `.bmb`, and `.tntgraph` with mathematically verified, bit-for-bit JIT execution parity.

---

## 🔬 Traditional Python vs. TinyTalk (Side-by-Side)

### 1. Memory Layout: Heap Boxing vs. Unboxed CPU Registers

```
Traditional CPython 3.14 (Every variable is a 28+ byte heap object)
┌────────────────────────────────────────────────────────┐
│  x = 42                                                │
│  [Pointer: 8 bytes] ──> PyLongObject [Heap: 28 bytes]  │
│                         ├─ ob_refcnt (8 bytes)         │
│                         ├─ ob_type   (8 bytes)         │
│                         └─ ob_digit  (8 bytes)         │
└────────────────────────────────────────────────────────┘

TinyTalk (.tnt) (Unboxed values live directly in CPU registers)
┌────────────────────────────────────────────────────────┐
│  x = 42                                                │
│  Register RAX: [ 0x000000000000002A ] (0 bytes on heap)│
└────────────────────────────────────────────────────────┘
```

| Feature | Traditional Python (CPython) | TinyTalk (`.tnt`) |
| :--- | :--- | :--- |
| **Object Overhead** | 28 bytes for an integer, 152 bytes for a small class | **0 bytes** (unboxed in CPU registers or stack) |
| **Small Strings ($\le$ 7 bytes)** | 48–56 bytes heap allocated (`PyUnicodeObject`) | **0 heap allocations** (SSO tagged in 64-bit register) |
| **Garbage Collection** | Stop-the-world cyclic GC pauses (millisecond spikes) | **0.000 ms GC pauses** (Compile-time Lexical Arenas) |
| **Method Calls** | Dynamic `__dict__` hash table lookups | **Direct 1-cycle function pointers** / compile-time dispatch |

---

### 2. Deep Recursion: Stack Overflow vs. Auto-TCO

In traditional Python, every function call incurs a massive **2,112-byte** stack frame (`_PyEval_EvalFrameDefault`). Deep recursion quickly crashes with `RecursionError`. TinyTalk automatically detects tail recursion and compiles it into a **zero-stack-frame register jump loop**:

```python
# In TinyTalk, this executes 5,000,000 recursive calls in 2.6 ms with 0 stack growth!
def tail_sum(n: i64, acc: i64) -> i64:
    if n <= 0:
        return acc
    return tail_sum(n - 1, acc + n)
```

---

### 3. Concurrency: GIL Lock Contention vs. Zero-GIL Hardware Multithreading

```mermaid
flowchart TD
    subgraph CPython["Traditional Python (GIL Contention)"]
        T1["Thread 1"] -->|Requests Lock| GIL["Global Interpreter Lock (GIL)"]
        T2["Thread 2 (BLOCKED)"] -.->|Waiting| GIL
        T3["Thread 3 (BLOCKED)"] -.->|Waiting| GIL
        GIL --> CPU1["1 CPU Core Active (Multi-core Wasted)"]
    end

    subgraph TinyTalk["TinyTalk (Zero-GIL Multi-Core)"]
        M1["Thread 1"] --> Core1["CPU Core 1 (100% Native)"]
        M2["Thread 2"] --> Core2["CPU Core 2 (100% Native)"]
        M3["Thread 3"] --> Core3["CPU Core 3 (100% Native)"]
        M1 <==>|"Lock-Free MPMC (chan.tnt)"| M2
        M2 <==>|"Atomic Hardware CAS"| M3
    end
```

---

## 💻 Language Showcase

TinyTalk blends expressive Python syntax with systems-level power and Smalltalk dynamism:

```python
# 1. Unboxed Value Structs (Stored directly in CPU registers, 0 GC overhead)
struct Vec3:
    x: f64
    y: f64
    z: f64

    fn norm_sq(self) -> f64:
        return self.x * self.x + self.y * self.y + self.z * self.z

# 2. Hardware 64-bit SSE2 / AVX Float Math
def distance_3d(v1: Vec3, v2: Vec3) -> f64:
    dx = v1.x - v2.x
    dy = v1.y - v2.y
    dz = v1.z - v2.z
    return sqrt(dx * dx + dy * dy + dz * dz)

# 3. Whole-Program Cartesian Type Inference (No redundant type annotations needed)
def is_prime(n):
    if n <= 1: return False
    d = 2
    while d * d <= n:
        if n % d == 0: return False
        d += 1
    return True

# 4. Pipeline Dataflow Operator (|>) for Clean Composition
def step_double(x: i64) -> i64: return x * 2
def step_add_const(x: i64) -> i64: return x + 42
def step_square(x: i64) -> i64: return x * x

# 5. Pattern Matching (Compiled to single-cycle CPU jump tables)
def evaluate_status_code(code: i64) -> str:
    match code:
        case 200: return "OK: Explosive Performance"
        case 201: return "Created: Zero Overhead"
        case 404: return "Error: GIL Not Found"
        case _:   return "Active: Bare-Metal Speed"

# 6. Automatic Tail-Call Optimization (Auto-TCO)
def tail_accumulator(n, acc):
    if n <= 0: return acc
    return tail_accumulator(n - 1, acc + n)

def main() -> i64:
    p1 = Vec3(0.0, 3.0, 4.0)
    p2 = Vec3(3.0, 7.0, 4.0)
    print(f"3D Vector Distance: {distance_3d(p1, p2)}")

    # Clean functional pipeline: (7 * 2 + 42)^2 = 3136
    pipe_val = 7 |> step_double |> step_add_const |> step_square
    print(f"Pipeline Result: {pipe_val}")

    print(f"Status: {evaluate_status_code(200)}")
    print(f"Auto-TCO Sum (1,000,000 frames): {tail_accumulator(1000000, 0)}")
    return 0
```

---

## 🐳 Cloud & Enterprise Dominance

### 1. 📦 Zero-Base Micro-Containers (`tnt container`)

Traditional Python Docker containers weigh **150 MB to 500 MB** and require building on Linux with a Docker daemon. TinyTalk generates **~20 KB pure-Python OCI/Docker container image tarballs** from `FROM scratch` with **zero Docker daemon required**:

```mermaid
flowchart LR
    SRC["service.tnt\n(Source Code)"] --> ELF["ELF64 Executable\n(Direct Linux Syscalls)"]
    ELF --> OCI["Pure OCI Tarball\n(manifest.json + config + /app)"]
    OCI --> RUN["docker load -i image.tar\ndocker run --rm service:v4\n(Starts in 0.4 ms, Size: 20 KB)"]
```

```bash
# Build a minimal, production-ready Linux OCI container directly on Windows/macOS/Linux:
tnt container examples/tinytalk_flagship.tnt -t tinytalk-app:v4 --tar dist/app.tar

# Instantly load and run without any build step:
docker load -i dist/app.tar
docker run --rm tinytalk-app:v4
```

---

### 2. ⚡ Ultra-High-Speed Web Server (`website_server.tnt`)

TinyTalk includes an embedded pure-native HTTP/1.1 engine capable of **over 450,000 requests per second** on a single core:

```bash
# Start the production web application server:
tnt run website_server.tnt
```

---

### 3. 🧠 Native Edge AI & Local LLM Chat CLI (`tnt chat`)

Deploy and chat with large language models locally without PyTorch, CUDA toolkits, or heavy dependencies. TinyTalk features a built-in GGUF parser and quantized matrix-vector arithmetic (`q4_0` / `q8_0` GEMV):

```bash
# Start an interactive local streaming chat session:
tnt chat --model models/default_v2.gguf
```

---

## 📦 Binary Footprint: The Lightweight Revolution

TinyTalk emits **pure, self-contained binaries with zero runtime dependencies**:

```
CPython + PyInstaller Bundle   [85.0 MB] ▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰▰
Pyodide WebAssembly Bundle     [32.0 MB] ▰▰▰▰▰▰▰▰▰▰▰
------------------------------------------------------------------------------------
TinyTalk Standalone EXE        [0.005 MB] ▍ (5.5 KB - Starts in 0.001 ms)
TinyTalk Linux ELF64           [0.003 MB] ▍ (3.9 KB - Direct Linux Syscalls)
TinyTalk OCI Container         [0.020 MB] ▍ (20.0 KB - Full Scratch Docker Image)
TinyTalk WebAssembly (.wasm)   [0.001 MB] ▍ (1.7 KB - Over 18,000x smaller than Pyodide!)
```

| Deployment Target | Traditional Python | TinyTalk (`.tnt`) | Reduction Ratio |
| :--- | :--- | :--- | :--- |
| **Windows Executable** | 80 MB – 120 MB (`pyinstaller`) | **5.5 KB – 12 KB** (`tnt build --target exe`) | **~10,000x smaller** |
| **Linux Executable** | 40 MB – 100 MB (`docker` / `nuitka`) | **3.9 KB – 7.4 KB** (`tnt build --target elf`) | **~15,000x smaller** |
| **Cloud Container** | 150 MB – 500 MB (`python:slim`) | **~20 KB** (`tnt container`) | **~15,000x smaller** |
| **WebAssembly** | 32 MB (`pyodide` download) | **1.7 KB – 2.7 KB** (`tnt build --target wasm`) | **~18,000x smaller** |
| **Cold Boot Latency** | 1.2s – 2.5s (unpacking zip archives) | **< 0.001 ms** (direct OS memory map) | **Instant** |

---

## 📦 Pure Native Standard Library (36 Modules)

TinyTalk includes an extensive pure-native standard library in `tinytalk/stdlib/` compiling directly to unboxed native machine code with **zero CPython runtime dependencies**. All standard libraries can be imported seamlessly from `.tnt` or `.bmb` files:

| Category | Modules | Key Capabilities |
| :--- | :--- | :--- |
| **Web & Networking** | `http`, `fastapi`, `socket`, `tls`, `requests` | HTTP/1.1 (450k+ req/s), RFC 6455 WebSockets, parameterized routing, pure-native TLS 1.3. |
| **AI & High-Performance Math** | `tensor`, `llama`, `simd`, `series`, `autograd` | 2D GEMM, GGUF local LLM inference, 512-bit AVX-512, Arrow columnar data (79.2M rows/s). |
| **Concurrency & Systems** | `thread`, `chan`, `alloc`, `embedded`, `cluster`, `shm`, `fiber` | Zero-GIL threads, lock-free MPMC channels, slab allocator, No-OS embedded HAL, distributed RPC. |
| **Data Formats & Storage** | `sql`, `db`, `kv`, `json`, `csv`, `hash` | ACID SQLite/SQL engine, append-only WAL KV store, DOM JSON, tabular CSV, SHA-256/Murmur3. |
| **Collections & Utilities** | `collections`, `heap`, `iter`, `array`, `math`, `random`, `time`, `regex`, `unicode` | Deque/Counter, binary min-heap, Xoshiro256++ PRNG, Thompson NFA regex, Unicode UAX #29. |
| **Compiler & Metaprogramming** | `compiler`, `codegen`, `image`, `graph`, `transmute`, `vcs` | Pratt parser, PE32+ assembler, Smalltalk `.tntimg`, semantic `.tntgraph`, 3-way VCS. |

---

## 🛠️ The TinyTalk Unified Toolchain

The TinyTalk CLI (`tnt` or `bmb`) provides a unified command center for development, compilation, debugging, and live-object exploration:

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│                                 THE TINYTALK 4.0 SUITE                                 │
├──────────────┬──────────────┬──────────────┬──────────────┬──────────────┬─────────────┤
│   tnt run    │  tnt build   │tnt container │  tnt studio  │  tnt image   │  tnt fuzz   │
│  Native JIT  │ Multi-Target │  ~20KB OCI   │  2D Morphic  │ Live Snapshot│ Adversarial │
│ <1ms Startup │ Static Bin   │  No Docker!  │ Live Canvas  │ < 0.15ms Res │ 210 Vectors │
└──────────────┴──────────────┴──────────────┴──────────────┴─────────────┴─────────────┘
```

| Command | Purpose | Example |
| :--- | :--- | :--- |
| `tnt run` (or `bmb run`) | Instant native execution via in-memory JIT | `tnt run app.tnt --stats` |
| `tnt build` | Build standalone binary across all targets | `tnt build app.tnt --target all --debug` |
| `tnt container` | Build ~20 KB zero-base OCI image tarball | `tnt container app.tnt -t app:v4 --tar app.tar` |
| `tnt studio` | Smalltalk live interactive object studio & 2D Morphic Canvas | `tnt studio --canvas --open` |
| `tnt image` | Freeze/resume Smalltalk `.tntimg` heap snapshots (< 0.15 ms) | `tnt image save app.tnt -o app.tntimg` |
| `tnt graph` | Zero-syntax content-addressed AST hypergraph (`.tntgraph`) | `tnt graph build app.tnt -o app.tntgraph` |
| `tnt project` | Multi-perspective projections (Python, Morphic, Math, Sexpr) | `tnt project view app.tntgraph --format python` |
| `tnt vcs` | Semantic 3-way graph VCS and structural merge | `tnt vcs diff base.tntgraph feature.tntgraph` |
| `tnt transmute` | Lossless 3-way transmutation (`.py` $\leftrightarrow$ `.tnt` $\leftrightarrow$ `.tntgraph`) | `tnt transmute roundtrip app.py` |
| `tnt chat` | Local streaming LLM conversational AI | `tnt chat --model models/default_v2.gguf` |
| `tnt test` | Discover and run all project test suites | `tnt test` |
| `tnt gatekeeper` | 5-stage zero-defect pre-release quality gatekeeper | `tnt gatekeeper` |
| `tnt fuzz` | 9-vector adversarial compiler fuzzer & differential oracle | `tnt fuzz --diff 80 --pe 20` |
| `tnt profile` | Nanosecond call profiling & SVG flamegraphs | `tnt profile app.tnt -o flamegraph.svg` |
| `tnt repl` | Interactive bare-metal JIT REPL | `tnt repl` |
| `tnt doc` | Generate static HTML API documentation | `tnt doc tinytalk/stdlib -o docs/api --open` |

---

## 🚀 Quickstart & CLI Guide

### 1. Installation

#### Standalone Binaries (Windows x86-64)
Download [`tinytalk-v4.0.0-win64.zip`](https://github.com/kicode01/tinytalk-lang/releases/tag/v4.0.0) from GitHub Releases and add `tnt.exe` to your `PATH`. Both `tnt.exe` and `bmb.exe` are bundled.

#### Python Package via Wheel
```bash
pip install dist/tinytalk_lang-4.0.0-py3-none-any.whl
```
*(Or install in editable mode for local development: `pip install -e .`)*

#### Clone & Run Test Suite
```bash
git clone https://github.com/kicode01/tinytalk-lang.git
cd tinytalk-lang

# Run 5-Stage Zero-Defect Pre-Release Gatekeeper
python -m tinytalk.cli gatekeeper
```

### 2. Run Instantly via JIT
```bash
tnt run examples/tinytalk_flagship.tnt --stats
```

### 3. Build Standalone Binaries Across All Targets
```bash
tnt build app.tnt --target all --debug
```
* Generates:
  * `build/app.exe` (Standalone Windows x86-64 executable with SEH unwind tables, CodeView `RSDS`, COFF symbols)
  * `build/app.elf` (Static Linux x86-64 binary with `.symtab` and DWARF v4 `.debug_line` tables)
  * `build/app.macho` (Standalone macOS Apple Silicon ARM64 binary)
  * `build/app.wasm` (WebAssembly 1.0 binary module for browser / node)
  * `build/app.c` (Portable ANSI C11 + `#line` source mappings + OpenMP SIMD)
  * `build/app.ll` (Standard LLVM IR)

### 4. Build Zero-Base Containers (No Docker Needed!)
```bash
tnt container app.tnt -t tinytalk-app:v4 --tar dist/app.tar
docker load -i dist/app.tar
docker run --rm tinytalk-app:v4
```

### 5. Launch Smalltalk Live Studio & Morphic Canvas
```bash
tnt studio --canvas --open
```

### 6. VS Code Extension
Install the official TinyTalk VS Code extension in [`editors/vscode/`](editors/vscode) for full syntax highlighting, grammar definitions, snippets, and Language Server Protocol (LSP 3.17) integration for both `.tnt` and `.bmb` files.

---

## 🐍 100% Backward Compatibility for Black Mamba (`.bmb`)

TinyTalk guarantees uninterrupted continuity for the entire Black Mamba ecosystem:

- **Source Code Parity**: Any `.bmb` source file can be run directly using `tnt run app.bmb` or `bmb run app.bmb`.
- **Command Alias**: Running `bmb` invokes the exact same compiler binary as `tnt`.
- **Package Imports**: Existing Python scripts importing `import mamba` or `from mamba.cli import main` are automatically resolved via `_MambaCompatFinder` to `tinytalk`.
- **Image Compatibility**: Existing `.bmbimg` memory images can be inspected, loaded, and resumed seamlessly.

---

## 🗺️ Architectural Transparency & Documentation

We believe in 100% engineering honesty. Every design trade-off, hardware boundary, and roadmap milestone is documented:

* 📋 [**`ROADMAP.md`**](ROADMAP.md): Detailed engineering roadmap from v0.1 to v4.0.0 and beyond.
* ⚠️ [**`docs/LIMITATIONS.md`**](docs/LIMITATIONS.md): Transparent inventory of current architectural trade-offs and memory model details.
* 🔍 [**`docs/REVERSE_ENGINEERING_REPORT.md`**](docs/REVERSE_ENGINEERING_REPORT.md): Deep-dive technical analysis of CPython 3.14 evaluation frame disassembly vs. TinyTalk JIT machine code.

---

## 📄 License & Heritage Notice

TinyTalk is licensed under the [MIT License](LICENSE). Contributions, issues, and discussions are welcome!

> **Heritage Notice**: *TinyTalk (`.tnt`) is the evolution of Black Mamba (`.bmb`). All `.bmb` files, tools, and specifications remain first-class citizens with permanent backward compatibility.*  
> **Disclaimer**: *TinyTalk is an independent open-source programming language and native compiler. It is not affiliated with, endorsed by, or sponsored by the Python Software Foundation (PSF). Python is a registered trademark of the Python Software Foundation.*
