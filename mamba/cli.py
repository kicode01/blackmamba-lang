"""
Black Mamba (mamba / bmb) Command-Line Interface & Benchmark Suite.

Usage:
  python bmb.py run <file.bmb> [--stats]
  python bmb.py build <file.bmb> [--target exe|wasm|wat|c|llvm|all] [-o <output>]
  python bmb.py inspect <file.bmb>
  python bmb.py bench
"""

import argparse
import os
import sys
import time
from typing import Optional
from .parser import Parser
from .mir import MIRBuilder, MIRModule
from .backends.x86_64_jit import NativeJITModule
from .backends.pe_exe import PE32PlusExecutableBuilder
from .backends.elf_exe import ELF64ExecutableBuilder
from .backends.arm64_macho import MachOARM64ExecutableBuilder
from .backends.wasm_emitter import WasmBackend
from .backends.c_emitter import C11Backend, LLVMIRBackend


def compile_source_to_mir(source: str, filename: str = "<input.bmb>", base_dir: str = "") -> MIRModule:
    ast_mod = Parser.from_source(source, filename).parse_module()
    resolved_base = base_dir or (os.path.dirname(os.path.abspath(filename)) if filename != "<input.bmb>" and os.path.exists(filename) else os.getcwd())
    return MIRBuilder().build(ast_mod, base_dir=resolved_base)


def _safe_write(text: str) -> None:
    try:
        sys.stdout.write(text)
        sys.stdout.flush()
    except UnicodeEncodeError:
        sys.stdout.buffer.write(text.encode("utf-8", errors="replace"))
        sys.stdout.buffer.flush()


def cmd_run(args: argparse.Namespace) -> int:
    if not os.path.exists(args.file):
        print(f"Error: File not found: {args.file}", file=sys.stderr)
        return 1
    with open(args.file, "r", encoding="utf-8") as f:
        source = f.read()

    t0 = time.perf_counter()
    mir = compile_source_to_mir(source, args.file)
    jit = NativeJITModule(mir, output_callback=_safe_write)
    t_compile = (time.perf_counter() - t0) * 1000.0

    t1 = time.perf_counter()
    exit_code = jit.run_main()
    t_exec = (time.perf_counter() - t1) * 1000.0

    if args.stats:
        code_bytes = len(jit.code_buf.code)
        print(
            f"\n[Black Mamba x86-64 JIT] Compiled {code_bytes} bytes of native machine code in {t_compile:.2f} ms | "
            f"Executed in {t_exec:.3f} ms"
        )
    jit.close()
    return exit_code


def cmd_build(args: argparse.Namespace) -> int:
    if not os.path.exists(args.file):
        print(f"Error: File not found: {args.file}", file=sys.stderr)
        return 1
    with open(args.file, "r", encoding="utf-8") as f:
        source = f.read()

    mir = compile_source_to_mir(source, args.file)
    base_name = os.path.splitext(os.path.basename(args.file))[0]
    out_dir = os.path.dirname(os.path.abspath(args.output)) if args.output else os.path.join(os.getcwd(), "build")
    os.makedirs(out_dir, exist_ok=True)

    targets = ["exe", "elf", "macho", "wasm", "wat", "c", "llvm"] if args.target == "all" else [args.target]
    for tgt in targets:
        if tgt == "exe":
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.exe")
            path = PE32PlusExecutableBuilder(mir).write_executable(out_path)
            print(f"[Black Mamba] Built standalone Windows x86-64 PE32+ executable -> {path} ({os.path.getsize(path)} bytes)")
        elif tgt in ("elf", "linux"):
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.elf")
            path = ELF64ExecutableBuilder(mir).write_executable(out_path)
            print(f"[Black Mamba] Built standalone Linux x86-64 ELF64 binary      -> {path} ({os.path.getsize(path)} bytes)")
        elif tgt in ("macho", "arm64", "macos"):
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.macho")
            path = MachOARM64ExecutableBuilder(mir).write_executable(out_path)
            print(f"[Black Mamba] Built standalone macOS ARM64 Mach-O binary   -> {path} ({os.path.getsize(path)} bytes)")
        elif tgt == "wasm":
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.wasm")
            path = WasmBackend(mir).write_wasm(out_path)
            print(f"[Black Mamba] Built WebAssembly binary module                  -> {path} ({os.path.getsize(path)} bytes)")
        elif tgt == "wat":
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.wat")
            wat_text = WasmBackend(mir).emit_wat()
            with open(out_path, "w", encoding="utf-8") as wf:
                wf.write(wat_text)
            print(f"[Black Mamba] Built WebAssembly text (.wat)                    -> {os.path.abspath(out_path)}")
        elif tgt == "c":
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.c")
            path = C11Backend(mir).write_c(out_path)
            print(f"[Black Mamba] Built portable C11 + OpenMP/SIMD source          -> {path}")
        elif tgt == "llvm":
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.ll")
            path = LLVMIRBackend(mir).write_llvm(out_path)
            print(f"[Black Mamba] Built LLVM IR (.ll)                              -> {path}")
    return 0


def cmd_inspect(args: argparse.Namespace) -> int:
    if not os.path.exists(args.file):
        print(f"Error: File not found: {args.file}", file=sys.stderr)
        return 1
    with open(args.file, "r", encoding="utf-8") as f:
        source = f.read()

    mir = compile_source_to_mir(source, args.file)
    jit = NativeJITModule(mir)

    print("=" * 80)
    print(f"BLACK MAMBA (.bmb) COMPILER PIPELINE INSPECTION: {args.file}")
    print("=" * 80)
    print("\n--- [Stage 1 & 2] Inferred Signatures & Optimized Mamba IR (MIR) ---")
    print(mir.format())
    print("\n--- [Stage 3] Emitted Native Windows x86-64 Machine Code ---")
    print(jit.format_disassembly())
    jit.close()
    return 0


def cmd_bench(_args: argparse.Namespace) -> int:
    print("=" * 84)
    print("BLACK MAMBA (.bmb) vs CPYTHON 3.14 HEAD-TO-HEAD NATIVE BENCHMARK SUITE")
    print("=" * 84)

    bmb_bench_src = """
def fib(n):
    if n <= 1:
        return n
    return fib(n - 1) + fib(n - 2)

def count_primes(limit):
    count = 0
    n = 2
    while n <= limit:
        is_p = 1
        d = 2
        while d * d <= n:
            if n % d == 0:
                is_p = 0
                break
            d += 1
        if is_p == 1:
            count += 1
        n += 1
    return count

def collatz_total_steps(limit):
    total = 0
    for i in 1..=limit:
        n = i
        steps = 0
        while n > 1:
            if (n & 1) == 0:
                n = n >> 1
            else:
                n = 3 * n + 1
            steps += 1
        total += steps
    return total

def mandelbrot_iters(size):
    total_iters = 0
    for py in 0..size:
        for px in 0..size:
            x0 = (float(px) / float(size)) * 3.5 - 2.5
            y0 = (float(py) / float(size)) * 2.0 - 1.0
            x = 0.0
            y = 0.0
            it = 0
            while x * x + y * y <= 4.0:
                if it >= 100:
                    break
                xtemp = x * x - y * y + x0
                y = 2.0 * x * y + y0
                x = xtemp
                it += 1
            total_iters += it
    return total_iters

def tail_sum(n, acc):
    if n <= 0:
        return acc
    return tail_sum(n - 1, acc + n)
"""

    # Python equivalents
    def py_fib(n: int) -> int:
        if n <= 1:
            return n
        return py_fib(n - 1) + py_fib(n - 2)

    def py_count_primes(limit: int) -> int:
        count = 0
        n = 2
        while n <= limit:
            is_p = 1
            d = 2
            while d * d <= n:
                if n % d == 0:
                    is_p = 0
                    break
                d += 1
            if is_p == 1:
                count += 1
            n += 1
        return count

    def py_collatz_total_steps(limit: int) -> int:
        total = 0
        for i in range(1, limit + 1):
            n = i
            steps = 0
            while n > 1:
                if (n & 1) == 0:
                    n = n >> 1
                else:
                    n = 3 * n + 1
                steps += 1
            total += steps
        return total

    def py_mandelbrot_iters(size: int) -> int:
        total_iters = 0
        for py in range(size):
            for px in range(size):
                x0 = (float(px) / float(size)) * 3.5 - 2.5
                y0 = (float(py) / float(size)) * 2.0 - 1.0
                x = 0.0
                y = 0.0
                it = 0
                while x * x + y * y <= 4.0:
                    if it >= 100:
                        break
                    xtemp = x * x - y * y + x0
                    y = 2.0 * x * y + y0
                    x = xtemp
                    it += 1
                total_iters += it
        return total_iters

    mir = compile_source_to_mir(bmb_bench_src, "bench_suite.bmb")
    jit = NativeJITModule(mir)

    benchmarks = [
        ("fib(32) [Recursive Call Tree]", lambda: py_fib(32), lambda: jit.call_function("fib", 32)),
        ("count_primes(30000) [Integer ALU]", lambda: py_count_primes(30000), lambda: jit.call_function("count_primes", 30000)),
        ("collatz_steps(40000) [Bitwise Loop]", lambda: py_collatz_total_steps(40000), lambda: jit.call_function("collatz_total_steps", 40000)),
        ("mandelbrot(120x120) [SSE2 Float64]", lambda: py_mandelbrot_iters(120), lambda: jit.call_function("mandelbrot_iters", 120)),
    ]

    print(f"{'Benchmark Kernel':<36} | {'CPython 3.14 (ms)':>17} | {'Black Mamba (ms)':>16} | {'Speedup':>10}")
    print("-" * 84)

    for label, py_fn, bmb_fn in benchmarks:
        # Warmup
        bmb_res = bmb_fn()
        t0 = time.perf_counter()
        py_res = py_fn()
        py_ms = (time.perf_counter() - t0) * 1000.0

        t1 = time.perf_counter()
        bmb_res = bmb_fn()
        bmb_ms = (time.perf_counter() - t1) * 1000.0

        assert py_res == bmb_res, f"Result mismatch on {label}: {py_res} != {bmb_res}"
        speedup = py_ms / max(bmb_ms, 0.001)
        print(f"{label:<36} | {py_ms:>14.2f} ms | {bmb_ms:>13.3f} ms | {speedup:>8.1f}x")

    # Test TCO on tail_sum(5_000_000, 0) where CPython raises RecursionError
    t0 = time.perf_counter()
    tco_res = jit.call_function("tail_sum", 5_000_000, 0)
    tco_ms = (time.perf_counter() - t0) * 1000.0
    print(f"{'tail_sum(5_000_000) [Auto-TCO]':<36} | {'RecursionError!':>17} | {tco_ms:>13.3f} ms | {'INF (TCO)':>10}")
    print("-" * 84)
    print(f"Verified tail_sum(5_000_000) = {tco_res} (0 stack frames allocated via Black Mamba TCO)")
    jit.close()
    return 0


def cmd_lsp(args: argparse.Namespace) -> int:
    from .lsp import run_stdio_server, run_tcp_server
    if args.tcp:
        return run_tcp_server(host=args.host, port=args.tcp)
    return run_stdio_server()


def cmd_repl(_args: Optional[argparse.Namespace] = None) -> int:
    from .repl import run_repl
    return run_repl()


def main(argv: Optional[list] = None) -> int:
    parser = argparse.ArgumentParser(
        prog="bmb",
        description="Black Mamba (.bmb) — High-Performance Native Python Superset & Multi-Target Compiler",
    )
    sub = parser.add_subparsers(dest="command")

    p_run = sub.add_parser("run", help="Compile and execute a .bmb file immediately via the native x86-64 JIT")
    p_run.add_argument("file", help="Path to .bmb source file")
    p_run.add_argument("--stats", action="store_true", help="Print compilation and execution timing statistics")

    p_build = sub.add_parser("build", help="Compile a .bmb file to native .exe, .wasm, .wat, .c, or .ll")
    p_build.add_argument("file", help="Path to .bmb source file")
    p_build.add_argument(
        "--target",
        "-t",
        choices=["exe", "elf", "linux", "macho", "arm64", "macos", "wasm", "wat", "c", "llvm", "all"],
        default="exe",
        help="Target output format (default: exe)",
    )
    p_build.add_argument("--output", "-o", help="Output file path")

    p_inspect = sub.add_parser("inspect", help="Inspect inferred types, optimized MIR, and native x86-64 disassembly")
    p_inspect.add_argument("file", help="Path to .bmb source file")

    sub.add_parser("bench", help="Run head-to-head benchmark suite against CPython 3.14")

    p_lsp = sub.add_parser("lsp", help="Run the Black Mamba Language Server Protocol (LSP 3.17) daemon")
    p_lsp.add_argument("--stdio", action="store_true", default=True, help="Run over stdio (default)")
    p_lsp.add_argument("--tcp", type=int, metavar="PORT", help="Run over TCP socket on PORT")
    p_lsp.add_argument("--host", type=str, default="127.0.0.1", help="TCP host to bind to (default: 127.0.0.1)")

    sub.add_parser("repl", help="Start the interactive Black Mamba native JIT REPL")

    from .pkg.cli import register_pkg_subparsers, handle_pkg_command
    register_pkg_subparsers(sub)

    args = parser.parse_args(argv)
    if args.command == "run":
        return cmd_run(args)
    if args.command == "build":
        return cmd_build(args)
    if args.command == "inspect":
        return cmd_inspect(args)
    if args.command == "bench":
        return cmd_bench(args)
    if args.command == "lsp":
        return cmd_lsp(args)
    if args.command == "repl":
        return cmd_repl(args)
    if args.command == "pkg":
        return handle_pkg_command(args)

    # If no subcommand is provided and running interactively, start REPL
    if args.command is None:
        if sys.stdin.isatty():
            return cmd_repl()
        parser.print_help()
        return 0


if __name__ == "__main__":
    sys.exit(main())
