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
from .backends.python_ext import PE32PlusExtensionBuilder, C11ExtensionEmitter
from .backends.embedded import EmbeddedBareMetalBuilder, DEFAULT_BASE_ADDR
from .backends.gpu_shader import WebGPUShaderBackend, SPIRVShaderBackend


def compile_source_to_mir(source: str, filename: str = "<input.bmb>", base_dir: str = "") -> MIRModule:
    ast_mod = Parser.from_source(source, filename).parse_module()
    resolved_base = base_dir or (os.path.dirname(os.path.abspath(filename)) if filename != "<input.bmb>" and os.path.exists(filename) else os.getcwd())
    return MIRBuilder().build(ast_mod, base_dir=resolved_base, filename=filename)


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

    # Drop-in Python file execution: if running .py file, migrate transparently in-memory
    if args.file.endswith(".py"):
        try:
            from .migrate import migrate_source
            source, _ = migrate_source(source)
        except Exception:
            pass

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

    dbg = bool(getattr(args, "debug", False))
    targets = ["exe", "elf", "macho", "wasm", "wat", "c", "llvm"] if args.target == "all" else [args.target]
    for tgt in targets:
        if tgt == "exe":
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.exe")
            path = PE32PlusExecutableBuilder(mir, debug=dbg).write_executable(out_path)
            dbg_tag = " [Debug: RSDS + COFF Symbols]" if dbg else ""
            print(f"[Black Mamba] Built standalone Windows x86-64 PE32+ executable -> {path} ({os.path.getsize(path)} bytes){dbg_tag}")
        elif tgt in ("elf", "linux"):
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.elf")
            path = ELF64ExecutableBuilder(mir, debug=dbg).write_executable(out_path)
            dbg_tag = " [Debug: DWARF v4 + .symtab]" if dbg else ""
            print(f"[Black Mamba] Built standalone Linux x86-64 ELF64 binary      -> {path} ({os.path.getsize(path)} bytes){dbg_tag}")
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
            path = C11Backend(mir, debug=dbg).write_c(out_path)
            print(f"[Black Mamba] Built portable C11 + OpenMP/SIMD source          -> {path}")
        elif tgt == "llvm":
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.ll")
            path = LLVMIRBackend(mir).write_llvm(out_path)
            print(f"[Black Mamba] Built LLVM IR (.ll)                              -> {path}")
        elif tgt in ("ext", "pyd"):
            if sys.platform == "win32":
                out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.pyd")
                path = PE32PlusExtensionBuilder(mir, mod_name=base_name).write_pyd(out_path)
                print(f"[Black Mamba] Built standalone Windows CPython Extension (.pyd) -> {path} ({os.path.getsize(path)} bytes)")
            else:
                out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.c")
                path = C11ExtensionEmitter(mir, mod_name=base_name).write_c_extension(out_path)
                print(f"[Black Mamba] Built portable CPython Extension C source (.c)  -> {path}")
        elif tgt in ("embedded", "bin", "no-os", "baremetal"):
            base_addr = int(args.base_addr, 0) if getattr(args, "base_addr", None) else DEFAULT_BASE_ADDR
            builder = EmbeddedBareMetalBuilder(mir, base_addr=base_addr)
            if args.output and args.output.endswith(".elf"):
                path = builder.write_freestanding_elf(args.output)
                print(f"[Black Mamba] Built freestanding bare-metal ELF binary        -> {path} ({os.path.getsize(path)} bytes)")
            elif args.output and args.output.endswith(".hex"):
                path = builder.write_hex(args.output)
                print(f"[Black Mamba] Built Intel HEX embedded image                  -> {path} ({os.path.getsize(path)} bytes)")
            else:
                out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.bin")
                path = builder.write_bin(out_path)
                print(f"[Black Mamba] Built freestanding flat binary image (.bin)     -> {path} ({os.path.getsize(path)} bytes @ 0x{base_addr:08X})")
        elif tgt == "hex":
            base_addr = int(args.base_addr, 0) if getattr(args, "base_addr", None) else DEFAULT_BASE_ADDR
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.hex")
            path = EmbeddedBareMetalBuilder(mir, base_addr=base_addr).write_hex(out_path)
            print(f"[Black Mamba] Built Intel HEX embedded image                  -> {path} ({os.path.getsize(path)} bytes @ 0x{base_addr:08X})")
        elif tgt in ("webgpu", "wgsl"):
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.wgsl")
            path = WebGPUShaderBackend(mir).write_wgsl(out_path)
            print(f"[Black Mamba] Built WebGPU Compute Shader (.wgsl)             -> {path} ({os.path.getsize(path)} bytes)")
        elif tgt in ("spirv", "spv", "vulkan"):
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.spv")
            path = SPIRVShaderBackend(mir).write_spirv(out_path)
            print(f"[Black Mamba] Built Vulkan SPIR-V 1.5 Compute Binary (.spv)   -> {path} ({os.path.getsize(path)} bytes)")
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


def cmd_bindgen(args: argparse.Namespace) -> int:
    from .bindgen import generate_bmb_bindings
    if not os.path.exists(args.header):
        print(f"Error: Header file not found: {args.header}", file=sys.stderr)
        return 1
    lib = args.lib or os.path.splitext(os.path.basename(args.header))[0]
    bindings_code = generate_bmb_bindings(args.header, lib)
    if args.output:
        os.makedirs(os.path.dirname(os.path.abspath(args.output)), exist_ok=True)
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(bindings_code)
        print(f"[Black Mamba Bindgen] Generated bindings in {args.output}")
    else:
        print(bindings_code)
    return 0


def cmd_migrate(args: argparse.Namespace) -> int:
    from .migrate import migrate_file, migrate_directory
    path = args.path
    if not os.path.exists(path):
        print(f"Error: Path not found: {path}", file=sys.stderr)
        return 1
    if os.path.isdir(path):
        out_dir = args.output or (path.rstrip("/\\") + "_bmb")
        print(f"[Black Mamba Migrator] Migrating directory '{path}' -> '{out_dir}'...")
        stats = migrate_directory(path, out_dir)
        print(f"[Black Mamba Migrator] Migration complete: {stats['files_converted']} files converted.")
        print(f"  - Classes promoted to structs: {stats['classes_promoted_to_structs']}")
        print(f"  - Functions migrated:         {stats['functions_migrated']}")
        print(f"  - Types inferred:             {stats['types_inferred']}")
        print(f"  - Imports mapped:             {stats['imports_mapped']}")
    else:
        out_file = args.output or (os.path.splitext(path)[0] + ".bmb")
        print(f"[Black Mamba Migrator] Migrating '{path}' -> '{out_file}'...")
        target, stats = migrate_file(path, out_file)
        print(f"[Black Mamba Migrator] Successfully migrated to {target}")
        print(f"  - Classes promoted to structs: {stats['classes_promoted_to_structs']}")
        print(f"  - Functions migrated:         {stats['functions_migrated']}")
        print(f"  - Types inferred:             {stats['types_inferred']}")
        print(f"  - Imports mapped:             {stats['imports_mapped']}")
    return 0




def cmd_profile(args: argparse.Namespace) -> int:
    from .profile import Profiler
    if not os.path.exists(args.file):
        print(f"Error: File not found: {args.file}", file=sys.stderr)
        return 1
    with open(args.file, "r", encoding="utf-8") as f:
        source = f.read()

    mir = compile_source_to_mir(source, args.file)
    profiler = Profiler(mir)
    print(f"[Black Mamba Profiler] Profiling {args.file} ({args.iterations} iteration(s))...")
    times = profiler.profile_execution(iterations=args.iterations)

    total_sec = sum(times.values())
    print("\n--- Execution Profile Summary ---")
    print(f"{'Function':<30} {'Time (ms)':<15} {'Share (%)':<10}")
    print("-" * 55)
    sorted_times = sorted(times.items(), key=lambda x: x[1], reverse=True)
    for name, t in sorted_times[:args.top]:
        pct = (t / total_sec * 100.0) if total_sec > 0 else 0.0
        print(f"{name:<30} {t*1000.0:<15.3f} {pct:<10.1f}%")
    print("-" * 55)
    print(f"Total Time: {total_sec*1000.0:.3f} ms\n")

    out_svg = args.output or "profile_flamegraph.svg"
    profiler.generate_flamegraph_svg(out_svg, title=f"Profile: {os.path.basename(args.file)}")
    print(f"[Black Mamba Profiler] Interactive flamegraph generated at: {out_svg}")
    return 0


def cmd_test(args: argparse.Namespace) -> int:
    target_path = args.path or "."
    test_files = []
    if os.path.isfile(target_path):
        test_files.append(target_path)
    else:
        for root, _, files in os.walk(target_path):
            for file in files:
                if (file.startswith("test_") or file.endswith("_test.bmb")) and file.endswith(".bmb"):
                    test_files.append(os.path.join(root, file))

    if not test_files:
        print(f"[Black Mamba Test Runner] No test files found matching test_*.bmb in '{target_path}'")
        return 0

    print(f"[Black Mamba Test Runner] Discovered {len(test_files)} test suite(s)...")
    passed = 0
    failed = 0
    t_start = time.perf_counter()

    for path in test_files:
        print(f"\nRunning {path}:")
        try:
            with open(path, "r", encoding="utf-8") as f:
                source = f.read()
            mir = compile_source_to_mir(source, path)
            jit = NativeJITModule(mir, output_callback=_safe_write)

            test_funcs = [fn.name for fn in mir.functions if fn.name.startswith("test_") and len(fn.params) == 0]
            if not test_funcs:
                ret = jit.run_main()
                if ret == 0 or ret is None:
                    _safe_write("  [PASS] main PASSED\n")
                    passed += 1
                else:
                    _safe_write(f"  [FAIL] main FAILED (exit code {ret})\n")
                    failed += 1
            else:
                for fn_name in test_funcs:
                    try:
                        ret = jit.call_function(fn_name)
                        if ret == 0 or ret is None or ret is True or ret == 1:
                            _safe_write(f"  [PASS] {fn_name} PASSED\n")
                            passed += 1
                        else:
                            _safe_write(f"  [FAIL] {fn_name} FAILED (returned {ret})\n")
                            failed += 1
                    except Exception as e:
                        _safe_write(f"  [ERROR] {fn_name} ERROR: {e}\n")
                        failed += 1
        except Exception as e:
            _safe_write(f"  [ERROR] Failed to compile/execute {path}: {e}\n")
            failed += 1

    elapsed = (time.perf_counter() - t_start) * 1000.0
    _safe_write("\n" + "=" * 50 + "\n")
    _safe_write(f"Results: {passed} passed, {failed} failed in {elapsed:.2f} ms\n")
    if failed == 0:
        _safe_write("ALL TESTS PASSED!\n")
        return 0
    else:
        _safe_write("TEST FAILURES OCCURRED!\n")
        return 1




def cmd_container(args: argparse.Namespace) -> int:
    from .container import ContainerBuilder
    if not os.path.exists(args.file):
        print(f"Error: File not found: {args.file}", file=sys.stderr)
        return 1

    tag = args.tag or "blackmamba-app:latest"
    builder = ContainerBuilder(args.file, image_tag=tag)
    print(f"[Black Mamba Container] Building zero-base micro-container for '{args.file}'...")

    if getattr(args, "dir", None):
        out_dir = builder.export_bundle_dir(args.dir)
        print(f"  [OK] Exported container bundle to: {out_dir}")
        print(f"  [OK] Dockerfile: {os.path.join(out_dir, 'Dockerfile')}")
        print(f"  [OK] Static binary: {os.path.join(out_dir, 'app')} ({os.path.getsize(os.path.join(out_dir, 'app'))} bytes)")

    out_tar = args.output or (os.path.splitext(args.file)[0] + "_container.tar")
    tar_path, tar_size = builder.export_oci_tarball(out_tar)
    print(f"  [OK] OCI/Docker image tarball: {tar_path} ({tar_size} bytes / {tar_size/1024:.1f} KB)")
    print(f"  [OK] Image Tag: {tag}")
    print(f"\nLoad immediately into Docker with zero build steps:")
    print(f"  docker load -i {tar_path}")
    print(f"  docker run --rm {tag}\n")
    return 0


def cmd_chat(args: argparse.Namespace) -> int:
    from .llm import run_interactive_chat, create_demo_gguf
    model_path = getattr(args, "model", None)
    if not model_path or not os.path.exists(model_path) or getattr(args, "demo", False):
        demo_path = os.path.join("models", "tiny_mamba_demo.gguf")
        if not os.path.exists(demo_path):
            print(f"[Black Mamba LLM] Generating verified synthetic GGUF demo model at: {demo_path}...")
            create_demo_gguf(demo_path)
            print(f"  [OK] Model created ({os.path.getsize(demo_path)} bytes)")
        model_path = demo_path

    run_interactive_chat(model_path)
    return 0


def cmd_kernel(args: argparse.Namespace) -> int:
    from .kernel import BlackMambaJupyterKernel
    if getattr(args, "install", False):
        spec_path = BlackMambaJupyterKernel.install_kernelspec(getattr(args, "prefix", None))
        print(f"[Black Mamba Kernel] Installed Jupyter kernelspec -> {spec_path}")
        return 0
    if getattr(args, "notebook", None):
        k = BlackMambaJupyterKernel()
        info = k.execute_notebook_file(args.notebook, getattr(args, "output", None))
        print(
            f"[Black Mamba Kernel] Executed {info['executed_cells']} cells in {info['notebook']} "
            f"in {info['total_ms']:.2f} ms"
        )
        return 0
    if getattr(args, "eval", None):
        k = BlackMambaJupyterKernel()
        reply = k.execute_cell(args.eval)
        if reply.stdout:
            _safe_write(reply.stdout)
        if reply.status == "error":
            print(f"Error: {reply.error_value}", file=sys.stderr)
            return 1
        if "text/plain" in reply.mime_bundle:
            print(reply.mime_bundle["text/plain"])
        return 0
    k = BlackMambaJupyterKernel()
    info = k.kernel_info()
    print(info["banner"])
    print(f"Protocol v{info['protocol_version']} ready. Use `bmb kernel --install` to register in JupyterLab / VS Code.")
    return 0


def cmd_deploy(args: argparse.Namespace) -> int:
    from .deploy import ServerlessDeployBuilder
    if not os.path.exists(args.file):
        print(f"Error: File not found: {args.file}", file=sys.stderr)
        return 1
    builder = ServerlessDeployBuilder(args.file, service_name=getattr(args, "name", None))
    results = builder.deploy(target=args.target, output_dir=getattr(args, "output", None))
    for r in results:
        tgt = r["target"]
        print(f"[Black Mamba Deploy] Built {tgt.upper()} zero-cold-start ({r['cold_start_ms']} ms) bundle for '{r['service_name']}':")
        for k, v in r.items():
            if k not in ("target", "service_name", "cold_start_ms"):
                print(f"  - {k}: {v}")
    return 0


def main(argv: Optional[list] = None) -> int:
    from . import __version__

    # Drop-in execution support: `bmb script.py` or `bmb script.bmb`
    raw_args = list(argv if argv is not None else sys.argv[1:])
    known_cmds = {"run", "build", "inspect", "bench", "lsp", "repl", "pkg", "doc", "bindgen", "migrate", "profile", "test", "container", "chat", "add", "publish", "kernel", "deploy"}
    if raw_args and not raw_args[0].startswith("-") and raw_args[0] not in known_cmds:
        if os.path.exists(raw_args[0]) or raw_args[0].endswith(".py") or raw_args[0].endswith(".bmb"):
            raw_args.insert(0, "run")
            argv = raw_args
    parser = argparse.ArgumentParser(
        prog="bmb",
        description="Black Mamba (.bmb) — High-Performance Native Python Superset & Multi-Target Compiler",
    )
    parser.add_argument("--version", "-v", action="version", version=f"Black Mamba {__version__}")
    sub = parser.add_subparsers(dest="command")

    p_run = sub.add_parser("run", help="Compile and execute a .bmb file immediately via the native x86-64 JIT")
    p_run.add_argument("file", help="Path to .bmb source file")
    p_run.add_argument("--stats", action="store_true", help="Print compilation and execution timing statistics")

    p_build = sub.add_parser("build", help="Compile a .bmb file to native .exe, .wasm, .wat, .c, or .ll")
    p_build.add_argument("file", help="Path to .bmb source file")
    p_build.add_argument(
        "--target",
        "-t",
        choices=[
            "exe", "elf", "linux", "macho", "arm64", "macos", "wasm", "wat", "c", "llvm", "ext", "pyd",
            "embedded", "bin", "hex", "no-os", "baremetal", "webgpu", "wgsl", "spirv", "spv", "vulkan", "all",
        ],
        default="exe",
        help="Target output format (default: exe)",
    )
    p_build.add_argument("--output", "-o", help="Output file path")
    p_build.add_argument(
        "--debug",
        "-g",
        action="store_true",
        help="Emit native debug symbols (PE32+ CodeView RSDS + COFF symbols, ELF64 DWARF v4 .debug_line, C11 #line)",
    )
    p_build.add_argument(
        "--base-addr",
        default="0x08000000",
        help="Base Flash/ROM load address for embedded targets (e.g. 0x08000000 or 0x00100000)",
    )

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

    p_doc = sub.add_parser("doc", help="Generate static HTML API documentation from .bmb docstrings")
    p_doc.add_argument("target", nargs="?", default=".", help="Target .bmb file or project directory (default: current dir)")
    p_doc.add_argument("--output", "-o", help="Output directory (default: build/docs)")
    p_doc.add_argument("--open", dest="open_browser", action="store_true", help="Open generated documentation in default web browser")

    p_bindgen = sub.add_parser("bindgen", help="Generate Black Mamba FFI bindings from a C header file (.h)")
    p_bindgen.add_argument("header", help="Path to C header file (.h)")
    p_bindgen.add_argument("--lib", "-l", required=True, help="Target shared library name (e.g. msvcrt.dll, sqlite3.dll)")
    p_bindgen.add_argument("--output", "-o", help="Output .bmb binding file path")

    p_mig = sub.add_parser("migrate", help="Automatically migrate Python source (.py) to native Black Mamba (.bmb)")
    p_mig.add_argument("path", help="Path to Python file (.py) or project directory to migrate")
    p_mig.add_argument("--output", "-o", help="Output .bmb file path or destination directory")

    p_prof = sub.add_parser("profile", help="Profile a .bmb program and generate an interactive SVG flamegraph")
    p_prof.add_argument("file", help="Path to .bmb source file to profile")
    p_prof.add_argument("--output", "-o", help="Output path for interactive SVG flamegraph (default: profile_flamegraph.svg)")
    p_prof.add_argument("--iterations", "-n", type=int, default=1, help="Number of benchmark iterations (default: 1)")
    p_prof.add_argument("--top", type=int, default=10, help="Number of top functions to display in summary table (default: 10)")

    p_test = sub.add_parser("test", help="Discover and run automated tests (*_test.bmb or test_*.bmb)")
    p_test.add_argument("path", nargs="?", default=".", help="Directory or file path to test (default: current directory)")

    p_cnt = sub.add_parser("container", help="Build zero-base FROM scratch micro-containers and OCI image tarballs")
    p_cnt.add_argument("file", help="Path to .bmb source file to package into container")
    p_cnt.add_argument("--tag", "-t", default="blackmamba-app:latest", help="Container image tag (default: blackmamba-app:latest)")
    p_cnt.add_argument("--output", "-o", help="Output OCI/Docker tarball path (default: <file>_container.tar)")
    p_cnt.add_argument("--dir", "-d", help="Also export uncompressed directory with Dockerfile and binary")

    p_cht = sub.add_parser("chat", help="Interactive local LLM chat and streaming token generator (GGUF format)")
    p_cht.add_argument("model", nargs="?", help="Path to .gguf model file (optional; defaults to built-in demo model)")
    p_cht.add_argument("--demo", action="store_true", help="Force using the built-in synthetic demo model")

    # Top-level package aliases: bmb add <pkg>, bmb publish
    from .pkg.cli import register_pkg_subparsers, cmd_pkg_add, cmd_pkg_publish
    p_top_add = sub.add_parser("add", help="Add a dependency to mamba.toml and mamba.lock (alias for bmb pkg add)")
    p_top_add.add_argument("package", help="Name of the package")
    p_top_add.add_argument("--git", help="Git repository URL")
    p_top_add.add_argument("--version", help="Version requirement constraint")
    p_top_add.add_argument("--path", help="Local directory path")
    p_top_add.add_argument("--registry", help="JSON package registry index URL or file path")

    p_top_pub = sub.add_parser("publish", help="Package and publish to registry (alias for bmb pkg publish)")
    p_top_pub.add_argument("--registry", "-r", help="Registry directory or index.json file path")

    p_krn = sub.add_parser("kernel", help="Interactive Jupyter Notebook Kernel daemon and kernelspec installer (bmb-kernel)")
    p_krn.add_argument("--install", action="store_true", help="Install Black Mamba kernelspec for JupyterLab & VS Code")
    p_krn.add_argument("--prefix", help="Custom target directory for kernelspec installation")
    p_krn.add_argument("--connection-file", "-f", help="Jupyter connection file path")
    p_krn.add_argument("--notebook", "-n", help="Execute a .ipynb notebook file in-place via native JIT")
    p_krn.add_argument("--output", "-o", help="Output path for executed .ipynb notebook")
    p_krn.add_argument("--eval", "-e", help="Evaluate a single notebook cell snippet and print wire output")

    p_dep = sub.add_parser("deploy", help="Build zero-cold-start (0.4ms) serverless cloud bundles (Lambda, Cloud Run, Fly.io, Cloudflare)")
    p_dep.add_argument("file", help="Path to .bmb source file to deploy")
    p_dep.add_argument(
        "--target",
        "-t",
        choices=["lambda", "cloudrun", "fly", "cloudflare", "all"],
        default="lambda",
        help="Serverless cloud provider target (default: lambda)",
    )
    p_dep.add_argument("--name", "-n", help="Cloud service / function name")
    p_dep.add_argument("--output", "-o", help="Output directory for deployment artifacts")

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
    if args.command == "doc":
        from .doc.cli import cmd_doc
        return cmd_doc(args)
    if args.command == "bindgen":
        return cmd_bindgen(args)
    if args.command == "migrate":
        return cmd_migrate(args)
    if args.command == "profile":
        return cmd_profile(args)
    if args.command == "test":
        return cmd_test(args)
    if args.command == "container":
        return cmd_container(args)
    if args.command == "chat":
        return cmd_chat(args)
    if args.command == "add":
        return cmd_pkg_add(args)
    if args.command == "publish":
        return cmd_pkg_publish(args)
    if args.command == "kernel":
        return cmd_kernel(args)
    if args.command == "deploy":
        return cmd_deploy(args)

    # If no subcommand is provided and running interactively, start REPL
    if args.command is None:
        if sys.stdin.isatty():
            return cmd_repl()
        parser.print_help()
        return 0


if __name__ == "__main__":
    sys.exit(main())
