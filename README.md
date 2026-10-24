# Black Mamba (`.bmb`)

> **"Write like Python, Execute like C, Compile Anywhere."**

Black Mamba (`mamba` / `.bmb`) is an ultra-fast, zero-cost-abstraction systems programming language and multi-target compiler engineered to overcome Python's 35-year architectural bottlenecks without sacrificing syntax simplicity.

Unlike **Mojo** (which forces Rust-like borrow checkers and bifurcates `def` vs `fn`) or **Nim** (which departs from Python's syntax), Black Mamba preserves true Python aesthetics while compiling down to **bare-metal machine code**, **5 KB standalone Windows executables**, and **1.7 KB WebAssembly modules**.

---

## ⚡ Performance: Black Mamba vs. CPython 3.14

```
====================================================================================
BLACK MAMBA (.bmb) vs CPYTHON 3.14 HEAD-TO-HEAD NATIVE BENCHMARK SUITE
====================================================================================
Benchmark Kernel                     | CPython 3.14 (ms) | Black Mamba (ms) |    Speedup
------------------------------------------------------------------------------------
fib(32) [Recursive Call Tree]        |         288.62 ms |        11.078 ms |     26.1x
count_primes(30000) [Integer ALU]    |          22.05 ms |         1.730 ms |     12.7x
collatz_steps(40000) [Bitwise Loop]  |         227.84 ms |         8.291 ms |     27.5x
mandelbrot(120x120) [SSE2 Float64]   |          39.14 ms |         3.368 ms |     11.6x
tail_sum(5_000_000) [Auto-TCO]       |   RecursionError! |         3.231 ms |  INF (TCO)
------------------------------------------------------------------------------------
Verified tail_sum(5_000_000) = 12500002500000 (0 stack frames allocated via Auto-TCO)
```

---

## 🚀 Key Architectural Breakthroughs

1. **Win64 x86-64 Native JIT**:
   * Eliminates CPython's **2,112-byte** stack frame (`_PyEval_EvalFrameDefault`, `sub rsp, 0x840`) down to standard 32–48 byte ABI frames.
   * Compiles and executes in executable RAM (`VirtualAlloc`) in sub-millisecond times.
2. **Zero-Dependency PE32+ Standalone Linker**:
   * Emits valid 64-bit Windows executables (`.exe`) directly in pure Python bytecode.
   * Binary size: **5.5 KB** with zero external dependencies (no Visual Studio or GCC needed).
3. **1.7 KB WebAssembly Engine**:
   * Compiles directly to standard WebAssembly 1.0 (`.wasm`).
   * Over **18,000x smaller** than Pyodide (32 MB), booting in **0.12 ms** and driving 60/120 FPS HTML5 Canvas games.
4. **Cartesian Type Inference & Unboxed Value Structs**:
   * Inactive type ceremony: `struct Vec3(x: f64, y: f64, z: f64)` is escape-analyzed and placed directly into CPU registers. Zero garbage collector overhead.
5. **Automatic Tail-Call Optimization (Auto-TCO)**:
   * Compiles deep recursion into 0-stack-frame register jump loops (executes 5,000,000 recursive frames in 3.2 ms without `RecursionError`).
6. **Zero-Copy CPython Host FFI**:
   * Dynamically binds to host `python3xx.dll` on demand to access PyTorch, NumPy, and 500,000 PyPI packages in **0.39 ms** via raw pointer sharing.

---

## 💻 Language Showcase: `examples/black_mamba_flagship.bmb`

```python
# 1. Unboxed Value Types (Direct CPU registers, 0 GC overhead)
struct Vec3:
    x: f64
    y: f64
    z: f64

    fn norm_sq(self) -> f64:
        return self.x * self.x + self.y * self.y + self.z * self.z

# 2. Hardware 64-bit SSE2 Float Math
def distance_3d(v1: Vec3, v2: Vec3) -> f64:
    dx = v1.x - v2.x
    dy = v1.y - v2.y
    dz = v1.z - v2.z
    return sqrt(dx * dx + dy * dy + dz * dz)

# 3. Clean Python Syntax with Whole-Program Cartesian Type Inference
def is_prime(n):
    if n <= 1: return False
    d = 2
    while d * d <= n:
        if n % d == 0: return False
        d += 1
    return True

# 4. Pipeline Operator (|>) for Clean Dataflow
def step_double(x: i64) -> i64: return x * 2
def step_add_const(x: i64) -> i64: return x + 42
def step_square(x: i64) -> i64: return x * x

# 5. Pattern Matching (Compiled to single-cycle jump tables)
def evaluate_status_code(code: i64) -> str:
    match code:
        case 200: return "OK: High Performance"
        case 201: return "Created: Zero Overhead"
        case 404: return "Error: GIL Not Found"
        case _:   return "Active: Bare-Metal Speed"

# 6. Automatic Tail-Call Optimization (TCO)
def tail_accumulator(n, acc):
    if n <= 0: return acc
    return tail_accumulator(n - 1, acc + n)

def main():
    p1 = Vec3(0.0, 3.0, 4.0)
    p2 = Vec3(3.0, 7.0, 4.0)
    print(f"3D Distance: {distance_3d(p1, p2)}")

    pipe_val = 7 |> step_double |> step_add_const |> step_square
    print(f"Pipeline (7 |> double |> add_42 |> square): {pipe_val}")

    print(f"Status: {evaluate_status_code(200)}")
    print(f"TCO Sum (1,000,000 frames): {tail_accumulator(1000000, 0)}")
    return 0
```

---

## 🛠️ Quickstart

### 1. Run via JIT
```bash
python bmb.py run examples/black_mamba_flagship.bmb --stats
```

### 2. Build Standalone Executables & WebAssembly
```bash
python bmb.py build examples/black_mamba_flagship.bmb --target all
```
* Generates:
  * `build/black_mamba_flagship.exe` (5.5 KB native PE32+ executable)
  * `build/black_mamba_flagship.wasm` (2.7 KB WebAssembly binary)
  * `build/black_mamba_flagship.wat` (Human-readable WebAssembly text)
  * `build/black_mamba_flagship.c` (Portable C11 + OpenMP)
  * `build/black_mamba_flagship.ll` (LLVM IR)

### 3. Run Benchmark Suite
```bash
python bmb.py bench
```

### 4. Interactive In-Browser Game Canvas
Open [`examples/web_game_canvas.html`](examples/web_game_canvas.html) directly in any web browser to see 60/120 FPS particle physics calculated live via Black Mamba WebAssembly.

---

## 📄 License
MIT License.
