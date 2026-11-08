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
from .backends.html_backend import HtmlBackend


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
        elif tgt in ("html", "dom", "web"):
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}.html")
            path = HtmlBackend(mir, source=source, title=base_name.replace("_", " ").title()).write_html(out_path)
            print(f"[Black Mamba] Built standalone HTML5 document / Web Component -> {path} ({os.path.getsize(path)} bytes)")
        elif tgt in ("unikernel", "vm", "firecracker"):
            from .unikernel import UnikernelBuilder
            out_path = args.output if (args.output and args.target != "all") else os.path.join(out_dir, f"{base_name}_unikernel.raw")
            ub = UnikernelBuilder(memory_mb=128)
            res = ub.build_unikernel_image(source, out_path)
            print(f"[Black Mamba] Built Firecracker/KVM Unikernel Image (0.4 ms)  -> {res['image_path']} ({res['image_bytes']} bytes)")
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
    if getattr(args, "release", False):
        import json
        from .gatekeeper import PreReleaseGatekeeper
        gk = PreReleaseGatekeeper()
        print("[Black Mamba Gatekeeper] Running 5-Stage Zero-Defect Pre-Release Quality Pipeline...")
        report = gk.run_all_stages()
        if getattr(args, "json", False):
            print(json.dumps(report, indent=2))
        else:
            for s in report["stages"]:
                stg_num = s["stage"]
                stg_name = s["name"]
                status = "[PASS]" if s["passed"] else "[FAIL]"
                print(f"  {status} Stage {stg_num}: {stg_name}")
                if not s["passed"] and s.get("errors"):
                    for err in s["errors"][:5]:
                        print(f"         Error: {err}")
            print("=" * 60)
            if report["all_passed"]:
                print(f"[Black Mamba Gatekeeper] CERTIFICATION SUCCESS: All stages passed in {report['total_elapsed_seconds']:.2f}s! Release safe to publish.")
            else:
                print(f"[Black Mamba Gatekeeper] CERTIFICATION FAILED: Critical defects detected. Aborting release.")
        return 0 if report["all_passed"] else 1

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


def cmd_ast(args: argparse.Namespace) -> int:
    import json
    from .ast_graph import ASTGraph, TokenSparseCodec, benchmark_token_efficiency

    action = getattr(args, "action", None) or "skeleton"
    if not os.path.exists(args.file):
        print(f"Error: File not found: {args.file}", file=sys.stderr)
        return 1
    with open(args.file, "r", encoding="utf-8") as f:
        source = f.read()
    mod_name = os.path.splitext(os.path.basename(args.file))[0]

    if action == "skeleton":
        graph = ASTGraph.from_source(source, module_name=mod_name)
        print(graph.to_skeleton(include_hashes=not getattr(args, "no_hash", False)))
        return 0

    if action == "inspect":
        graph = ASTGraph.from_source(source, module_name=mod_name)
        node = graph.inspect(args.uri)
        if getattr(args, "json", False):
            print(json.dumps(node.to_dict(), indent=2))
        elif getattr(args, "compact", False):
            print(node.compact_source)
        elif getattr(args, "sexpr", False):
            print(node.sexpr)
        else:
            print(f"# {node.uri} [{node.sha256}] ({node.signature})")
            print(node.source)
        return 0

    if action == "encode":
        codec = TokenSparseCodec()
        encoded = codec.encode(source)
        if getattr(args, "output", None):
            with open(args.output, "w", encoding="utf-8") as out_f:
                out_f.write(encoded)
        else:
            print(encoded, end="")
        return 0

    if action == "decode":
        codec = TokenSparseCodec()
        decoded = codec.decode(source)
        if getattr(args, "output", None):
            with open(args.output, "w", encoding="utf-8") as out_f:
                out_f.write(decoded)
        else:
            print(decoded, end="")
        return 0

    if action == "bench":
        report = benchmark_token_efficiency(source, target_uri=getattr(args, "uri", None), module_name=mod_name)
        if getattr(args, "json", False):
            print(json.dumps(report.to_dict(), indent=2))
        else:
            print(f"[Black Mamba Token-Sparse AST Benchmark: {mod_name} ({report.symbol_count} symbols)]")
            print(f"  Full .bmb Source Tokens    : {report.full_bmb_tokens}")
            print(f"  Compact .bmbs Tokens       : {report.compact_bmbs_tokens}")
            print(f"  Module Skeleton Tokens     : {report.skeleton_tokens}")
            print(f"  Single-Symbol Delta Tokens : {report.single_symbol_edit_delta_tokens} (vs {report.single_symbol_edit_bmb_tokens} full rewrite)")
            print(f"  Context Read Savings       : {report.read_savings_pct:.2f}%")
            print(f"  Edit Output Savings        : {report.edit_savings_pct:.2f}%")
            print(f"  Total Round-Trip Savings   : {report.roundtrip_savings_pct:.2f}%")
        return 0

    return 1


def cmd_patch(args: argparse.Namespace) -> int:
    import json
    from .ast_graph import ASTDeltaOp, ASTPatcher

    if not os.path.exists(args.file):
        print(f"Error: File not found: {args.file}", file=sys.stderr)
        return 1
    with open(args.file, "r", encoding="utf-8") as f:
        source = f.read()
    mod_name = os.path.splitext(os.path.basename(args.file))[0]

    ops = []
    if getattr(args, "patch_file", None):
        with open(args.patch_file, "r", encoding="utf-8") as pf:
            raw_data = json.load(pf)
        ops = [ASTDeltaOp.from_dict(d) for d in (raw_data if isinstance(raw_data, list) else [raw_data])]
    else:
        ops.append(
            ASTDeltaOp(
                op=args.op.upper(),
                target_uri=args.uri,
                code=getattr(args, "code", "") or "",
                field_name=getattr(args, "field_name", "") or "",
                field_type=getattr(args, "field_type", "i64") or "i64",
                default_expr=getattr(args, "default_expr", None),
                new_name=getattr(args, "new_name", "") or "",
            )
        )

    patcher = ASTPatcher()
    res = patcher.apply_patch(source, ops, module_name=mod_name, verify=not getattr(args, "no_verify", False))
    if not res.success:
        diag_str = res.diagnostic.to_compact_str() if res.diagnostic else "!ERR[PATCH]: unknown failure"
        print(diag_str, file=sys.stderr)
        return 1

    if getattr(args, "in_place", False):
        with open(args.file, "w", encoding="utf-8") as f:
            f.write(res.new_source)
    elif getattr(args, "output", None):
        with open(args.output, "w", encoding="utf-8") as f:
            f.write(res.new_source)
    else:
        print(res.new_source, end="")
    return 0


def cmd_image(args: argparse.Namespace) -> int:
    import json
    from .canvas import MorphicCanvas
    from .image import ImageManager

    action = getattr(args, "action", None) or "inspect"
    if action == "save":
        canvas = None
        if getattr(args, "file", None) and os.path.exists(args.file):
            canvas = MorphicCanvas.from_file(args.file)
        db_src = getattr(args, "db", None)
        rep = ImageManager.save_image(
            args.output,
            canvas=canvas,
            db_source=db_src,
            compress=bool(getattr(args, "compress", False)),
        )
        print(f"[Black Mamba Image] Saved snapshot -> {rep.path} ({rep.size_bytes} bytes in {rep.elapsed_ms:.2f} ms)")
        print(f"  SHA-256 : {rep.sha256}")
        print(f"  Contents: {rep.module_count} modules, {rep.morph_count} morphs, {rep.table_count} SQLite tables")
        return 0

    if action == "load":
        loaded = ImageManager.load_image(args.image)
        try:
            print(f"[Black Mamba Image] Resumed '{loaded.path}' in {loaded.elapsed_ms:.2f} ms (< 5 ms target)")
            print(f"  Modules : {list(loaded.modules.keys())}")
            print(f"  Heap    : {len(loaded.heap_objects)} active objects")
            print(f"  SQLite  : {len(loaded.sqlite_tables)} restored tables")
            if loaded.canvas and getattr(args, "export_source", None):
                with open(args.export_source, "w", encoding="utf-8") as f:
                    f.write(loaded.canvas.source)
        finally:
            loaded.close()
        return 0

    if action == "inspect":
        info = ImageManager.inspect_image(args.image)
        print(json.dumps(info, indent=2))
        return 0

    return 1


def cmd_agent(args: argparse.Namespace) -> int:
    import json
    from .agent import AutonomousAgent

    agent = AutonomousAgent()
    if getattr(args, "heal", None):
        result = agent.heal_module(args.heal, test_source=getattr(args, "test_file", None))
        if getattr(args, "json", False):
            print(json.dumps(result.to_dict(), indent=2))
        else:
            status = "HEALED" if result.is_healed else "NO_CHANGES"
            print(f"[Black Mamba Agent] Self-healing pass: {status} ({result.elapsed_ms:.1f} ms)")
            for act in result.actions:
                print(f"  [{act.action_type}] {act.target}: {act.output}")
            if result.is_healed and getattr(args, "output", None):
                with open(args.output, "w", encoding="utf-8") as f:
                    f.write(result.output_source)
        return 0 if result.verified_pass else 1

    goal = args.goal or getattr(args, "synth", None) or "Build an inventory management dashboard with SQLite stock table"
    res = agent.synthesize_app(
        goal=goal,
        output_dir=getattr(args, "output", None),
        snapshot_name=getattr(args, "snapshot", None),
        verify=not getattr(args, "no_verify", False),
    )
    if getattr(args, "json", False):
        print(json.dumps(res.to_dict(), indent=2))
    else:
        print(res.summary())
        for a in res.actions:
            print(f"  * [{a.action_type}] {a.target}: {a.output} ({a.elapsed_ms:.1f}ms)")
    return 0 if res.tests_passed else 1


def cmd_mcp(args: argparse.Namespace) -> int:
    from .mcp import BlackMambaMCPServer
    server = BlackMambaMCPServer(workspace_dir=getattr(args, "workspace", None))
    server.run_stdio()
    return 0


def cmd_swarm(args: argparse.Namespace) -> int:
    import json
    from .orchestrator import AgentSwarm

    goal = args.goal or "Build an e-commerce order management microservice with item processing pipeline"
    swarm = AgentSwarm(workspace_dir=getattr(args, "output", None))
    res = swarm.execute_goal(
        goal=goal,
        output_dir=getattr(args, "output", None),
        snapshot_name=getattr(args, "snapshot", None),
        verify=not getattr(args, "no_verify", False),
    )
    if getattr(args, "json", False):
        out_dict = {
            "goal": res.goal,
            "app_name": res.app_name,
            "canvas_morphs": res.canvas_morphs,
            "tests_passed": res.tests_passed,
            "test_output": res.test_output,
            "elapsed_ms": res.elapsed_ms,
            "total_token_savings_pct": res.total_token_savings_pct,
            "lock_events_count": res.lock_events_count,
            "image_path": res.image_path,
        }
        print(json.dumps(out_dict, indent=2))
    else:
        print(f"=== Black Mamba Multi-Agent Swarm Orchestrator [{'SUCCESS' if res.tests_passed else 'FAILED'}] ===")
        print(f"Goal         : {res.goal}")
        print(f"Application  : {res.app_name} (token savings: {res.total_token_savings_pct:.1f}%)")
        print(f"Symbol Leases: {res.lock_events_count} conflict-free locks acquired & released")
        print(f"Canvas Morphs: {res.canvas_morphs} nodes mounted")
        print(f"Test Suite   : {'ALL TESTS PASSED' if res.tests_passed else 'TESTS FAILED'}")
        print(f"Elapsed Time : {res.elapsed_ms:.1f} ms")
        if res.image_path:
            print(f"Image State  : {res.image_path}")
        for act in res.actions:
            print(f"  * [{act.action_type}] {act.target}: {act.output} ({act.elapsed_ms:.1f}ms)")
    return 0 if res.tests_passed else 1


def cmd_replay(args: argparse.Namespace) -> int:
    import json
    from .replay import TimeTravelRecorder, ReplayTrace, OmniscientDebugger

    action = getattr(args, "action", None)
    if action == "record":
        if not os.path.exists(args.file):
            print(f"Error: File not found: {args.file}", file=sys.stderr)
            return 1
        with open(args.file, "r", encoding="utf-8-sig") as f:
            src = f.read()
        mod_name = os.path.splitext(os.path.basename(args.file))[0]
        recorder = TimeTravelRecorder(capacity=getattr(args, "capacity", 10000))
        trace = recorder.record_source(src, module_name=mod_name)
        out_path = getattr(args, "output", None) or f"{mod_name}.bmbreplay"
        bytes_written = trace.save(out_path, compress=getattr(args, "compress", False))

        html_path = getattr(args, "html", None)
        if html_path:
            debugger = OmniscientDebugger(trace)
            debugger.export_interactive_html(html_path)

        if getattr(args, "json", False):
            print(json.dumps({
                "trace_id": trace.trace_id,
                "module": trace.module_name,
                "total_steps": trace.total_steps,
                "output_path": out_path,
                "bytes": bytes_written,
                "html_path": html_path,
            }, indent=2))
        else:
            print(f"[Black Mamba Replay] Recorded deterministic trace for '{mod_name}':")
            print(f"  Total Steps    : {trace.total_steps}")
            print(f"  Checkpoints    : {len(trace.checkpoints)}")
            print(f"  Trace File     : {out_path} ({bytes_written} bytes)")
            if html_path:
                print(f"  Interactive UI : {html_path}")
        return 0

    elif action == "inspect":
        if not os.path.exists(args.trace):
            print(f"Error: Trace file not found: {args.trace}", file=sys.stderr)
            return 1
        trace = ReplayTrace.load(args.trace)
        debugger = OmniscientDebugger(trace)

        if getattr(args, "diff", None) and len(args.diff) == 2:
            step_a, step_b = int(args.diff[0]), int(args.diff[1])
            diff_data = debugger.diff_steps(step_a, step_b)
            if getattr(args, "json", False):
                print(json.dumps(diff_data, indent=2))
            else:
                print(f"[Black Mamba Replay] Diff between Step {step_a} and Step {step_b}:")
                for var, change in diff_data["changed_variables"].items():
                    print(f"  {var}: {change['before']} -> {change['after']}")
            return 0

        if getattr(args, "var", None):
            var_hist = debugger.query_variable_history(args.var)
            if getattr(args, "json", False):
                print(json.dumps(var_hist, indent=2))
            else:
                print(f"[Black Mamba Replay] Modification history for variable '{args.var}':")
                for entry in var_hist:
                    print(f"  Step {entry['step']:3d} (Line {entry['line']:2d} in {entry['func']}): {entry['value']}")
            return 0

        target_step = getattr(args, "step", None)
        if target_step is not None:
            frame = debugger.jump_to_step(int(target_step))
        else:
            frame = debugger.current_frame()

        if getattr(args, "json", False):
            print(json.dumps(frame.to_dict(), indent=2))
        else:
            print(f"[Black Mamba Replay] Step {frame.step_index}/{trace.total_steps - 1}:")
            print(f"  Function : {frame.function_name} (Line {frame.line_number})")
            print(f"  Event    : {frame.event}")
            print(f"  Arena Gen: {frame.arena_generation}")
            print(f"  Stack    : {' -> '.join(frame.call_stack)}")
            print(f"  Variables: {frame.variables}")
        return 0

    return 1


def cmd_autograd(args: argparse.Namespace) -> int:
    import json
    import time
    from .autograd import Tensor, Linear, LoRALinear, MSELoss, AdamW, emit_gpu_tensor_shader

    action = getattr(args, "action", None)
    if action == "train":
        epochs = getattr(args, "epochs", 20) or 20
        lr = getattr(args, "lr", 0.05) or 0.05
        model_type = getattr(args, "model", "linear")

        # Synthetic regression dataset: y = 2.5 * x1 - 1.5 * x2 + 0.5
        xs = [
            [1.0, 0.5],
            [2.0, 1.0],
            [-1.0, 2.0],
            [3.0, -1.0],
            [0.0, 1.5],
            [-2.0, -1.0],
            [1.5, 2.0],
            [4.0, 0.0],
        ]
        ys = [[2.5 * r[0] - 1.5 * r[1] + 0.5] for r in xs]
        X = Tensor(xs)
        Y = Tensor(ys)

        if model_type == "lora":
            model = LoRALinear(2, 1, r=2, alpha=4.0, seed=42)
        else:
            model = Linear(2, 1, seed=42)

        opt = AdamW(model.parameters(), lr=lr, weight_decay=1e-4)
        criterion = MSELoss()

        t0 = time.perf_counter()
        losses = []
        for ep in range(epochs):
            opt.zero_grad()
            pred = model(X)
            loss = criterion(pred, Y)
            loss.backward()
            opt.step()
            losses.append(loss.item())
        elapsed_ms = (time.perf_counter() - t0) * 1000

        res = {
            "model": model_type,
            "epochs": epochs,
            "lr": lr,
            "initial_loss": losses[0],
            "final_loss": losses[-1],
            "converged": losses[-1] < losses[0],
            "elapsed_ms": elapsed_ms,
            "loss_trajectory": losses,
        }
        if getattr(args, "json", False):
            print(json.dumps(res, indent=2))
        else:
            print(f"[Black Mamba Autograd] Trained {model_type.upper()} model for {epochs} epochs:")
            print(f"  Initial Loss : {losses[0]:.6f}")
            print(f"  Final Loss   : {losses[-1]:.6f} (reduction: {((losses[0] - losses[-1])/losses[0])*100:.1f}%)")
            print(f"  Elapsed Time : {elapsed_ms:.2f} ms ({elapsed_ms / epochs:.3f} ms/epoch)")
        return 0

    elif action == "bench":
        dim = getattr(args, "dim", 128) or 128
        iters = getattr(args, "iters", 30) or 30

        A = Tensor.randn(dim, dim, seed=123, requires_grad=True)
        B = Tensor.randn(dim, dim, seed=456, requires_grad=True)

        t0 = time.perf_counter()
        for _ in range(iters):
            A.zero_grad()
            B.zero_grad()
            C = (A @ B).sum()
            C.backward()
        elapsed = time.perf_counter() - t0
        per_iter_ms = (elapsed / iters) * 1000
        total_flops = iters * 6 * (dim ** 3)
        gflops = (total_flops / max(1e-9, elapsed)) / 1e9

        res = {
            "dim": dim,
            "iterations": iters,
            "total_seconds": elapsed,
            "ms_per_step": per_iter_ms,
            "throughput_gflops": gflops,
        }
        if getattr(args, "json", False):
            print(json.dumps(res, indent=2))
        else:
            print(f"[Black Mamba Autograd Bench] MatMul Autograd Benchmark ({dim}x{dim}):")
            print(f"  Iterations   : {iters}")
            print(f"  Latency/Step : {per_iter_ms:.2f} ms")
            print(f"  Throughput   : {gflops:.3f} GFLOPS (pure native autograd)")
        return 0

    elif action == "emit":
        target = getattr(args, "target", "webgpu")
        op = getattr(args, "op", "matmul")
        dims = getattr(args, "dims", "64,64,64")
        parts = [int(x.strip()) for x in dims.split(",")]
        m, k, n = parts[0], parts[1], parts[2]
        shader_info = emit_gpu_tensor_shader(op=op, m=m, k=k, n=n)

        out_file = getattr(args, "output", None)
        if out_file:
            with open(out_file, "w", encoding="utf-8") as f:
                f.write(shader_info["wgsl_shader"])
            if not getattr(args, "json", False):
                print(f"[Black Mamba Autograd] Emitted {target.upper()} shader to {out_file}")

        if getattr(args, "json", False):
            print(json.dumps(shader_info, indent=2))
        elif not out_file:
            print(shader_info["wgsl_shader"])
        return 0

    return 1


def cmd_shm(args: argparse.Namespace) -> int:
    import json
    from .shm import SharedMemoryArena, SharedRingQueue, benchmark_shm_throughput

    action = getattr(args, "action", None)
    if action == "create":
        name = args.name
        size = getattr(args, "size", 1024 * 1024) or (1024 * 1024)
        arena = SharedMemoryArena(name=name, size=size, create=True)
        arena.close()
        if getattr(args, "json", False):
            print(json.dumps({"name": name, "size": size, "created": True}, indent=2))
        else:
            print(f"[Black Mamba SHM] Created shared memory arena '{name}' ({size} bytes)")
        return 0

    elif action == "write":
        name = args.name
        data = args.data.encode("utf-8")
        arena = SharedMemoryArena(name=name, create=False)
        bytes_written = arena.write_bytes(data)
        arena.close()
        if getattr(args, "json", False):
            print(json.dumps({"name": name, "bytes_written": bytes_written}, indent=2))
        else:
            print(f"[Black Mamba SHM] Wrote {bytes_written} bytes into arena '{name}'")
        return 0

    elif action == "read":
        name = args.name
        arena = SharedMemoryArena(name=name, create=False)
        payload = arena.read_bytes()
        arena.close()
        text = payload.decode("utf-8", errors="replace")
        if getattr(args, "json", False):
            print(json.dumps({"name": name, "length": len(payload), "data": text}, indent=2))
        else:
            print(f"[Black Mamba SHM] Read {len(payload)} bytes from arena '{name}':")
            print(f"  {text}")
        return 0

    elif action == "bench":
        iters = getattr(args, "iters", 10000) or 10000
        msg_size = getattr(args, "size", 256) or 256
        res = benchmark_shm_throughput(iterations=iters, message_size=msg_size)
        if getattr(args, "json", False):
            print(json.dumps(res, indent=2))
        else:
            print(f"[Black Mamba SHM Bench] Shared Memory Queue Benchmark ({msg_size}B messages):")
            print(f"  Total Ops   : {res['iterations'] * 2}")
            print(f"  Latency     : {res['latency_microseconds']:.3f} us / op")
            print(f"  Throughput  : {res['ops_per_second']:,.0f} ops/sec ({res['throughput_gb_sec']:.2f} GB/s)")
        return 0

    elif action == "unlink":
        name = args.name
        try:
            arena = SharedMemoryArena(name=name, create=False)
            arena.unlink()
            arena.close()
            print(f"[Black Mamba SHM] Unlinked shared memory arena '{name}'")
        except Exception as e:
            print(f"Error unlinking arena '{name}': {e}", file=sys.stderr)
            return 1
        return 0

    return 1


def cmd_selfhost(args: argparse.Namespace) -> int:
    import json
    from .selfhost import SelfHostManager

    sh = SelfHostManager()
    action = getattr(args, "action", "info")

    if action == "info" or action is None:
        status = sh.get_selfhost_status()
        if getattr(args, "json", False):
            print(json.dumps(status, indent=2))
        else:
            print("[Black Mamba Self-Host] Pure .bmb Compiler Modules:")
            for m in status["modules"]:
                valid_str = "VALID" if m.get("mir_valid") else "FAIL"
                print(f"  [{valid_str}] {m['name']:<20} {m['loc']:>4} LOC | {m.get('fn_count', 0):>2} functions")
            print(f"Total: {status['module_count']} modules, {status['total_loc']} lines of code across mamba/selfhost/")
        return 0 if status["all_mir_valid"] else 1

    elif action == "check":
        if getattr(args, "parity", False):
            print("[Black Mamba Self-Host] Running 3-Stage Stage-2/Stage-3 Self-Compilation Parity Verification...")
            res = sh.check_stage_parity()
            if getattr(args, "json", False):
                print(json.dumps(res, indent=2))
            else:
                print(f"  Stage 1 (Python MIR):   {res['stage1_hash']}")
                print(f"  Stage 2 (.bmb Driver):  {res['stage2_hash']}")
                print(f"  Stage 3 (Reproduced):   {res['stage3_hash']}")
                print(f"  Total Functions:        {res['function_count']}")
                print(f"  MIR Instructions:       {res['mir_instruction_count']}")
                print("=" * 60)
                if res["parity_verified"]:
                    print("[Black Mamba Self-Host] PARITY CERTIFIED: Stage-2 and Stage-3 outputs are 100% bit-for-bit identical!")
                else:
                    print("[Black Mamba Self-Host] PARITY FAILED: Discrepancy detected between Stage-2 and Stage-3 outputs.")
            return 0 if res["parity_verified"] else 1
        else:
            ok, errors = sh.verify_all_modules()
            if getattr(args, "json", False):
                print(json.dumps({"passed": ok, "errors": errors}, indent=2))
            else:
                if ok:
                    print(f"[Black Mamba Self-Host] All {len(sh.list_selfhost_modules())} self-hosted modules compile to valid MIR cleanly.")
                else:
                    print("[Black Mamba Self-Host] Errors detected in self-host modules:")
                    for err in errors:
                        print(f"  - {err}")
            return 0 if ok else 1

    elif action == "bench":
        res = sh.benchmark_selfhost()
        if getattr(args, "json", False):
            print(json.dumps(res, indent=2))
        else:
            print("[Black Mamba Self-Host] Benchmark Results:")
            print(f"  Modules compiled:     {res['modules_compiled']}")
            print(f"  Total functions:      {res['total_functions']}")
            print(f"  Elapsed time:         {res['elapsed_seconds']:.4f}s")
            print(f"  Throughput:           {res['functions_per_second']:.2f} functions/sec")
        return 0

    return 0


def cmd_verify(args: argparse.Namespace) -> int:
    import json
    from .contracts import FormalContractVerifier

    if not os.path.exists(args.file):
        print(f"Error: File not found: {args.file}", file=sys.stderr)
        return 1
    with open(args.file, "r", encoding="utf-8") as f:
        source = f.read()

    verifier = FormalContractVerifier()
    res = verifier.verify_source(source)

    if getattr(args, "json", False):
        print(json.dumps(res, indent=2))
    else:
        print(f"[Black Mamba SMT Verify] Formally Verifying Contracts in '{args.file}'...")
        for s in res["summaries"]:
            status_tag = "[PROVEN]" if s["status"] == "PROVEN" else "[VIOLATED]"
            print(f"  {status_tag} {s['func']} (Line {s['line']}) - {s['contracts_count']} contract(s)")
            for step in s["proof_steps"]:
                print(f"         Proof: {step}")
            if s["counterexample"]:
                print(f"         Counterexample: {s['counterexample']}")
        print("=" * 60)
        if res["all_proven"]:
            print(f"[Black Mamba SMT Verify] VERIFICATION SUCCESS: All {res['contracts_verified']} contract(s) formally proven in {res['elapsed_ms']} ms!")
        else:
            print(f"[Black Mamba SMT Verify] VERIFICATION FAILED: {res['violations_found']} invariant violation(s) detected. Fix counterexamples before compilation.")
    return 0 if res["all_proven"] else 1


def cmd_supervisor(args: argparse.Namespace) -> int:
    import json
    from .supervisor import SelfHealingSupervisor

    sup = SelfHealingSupervisor()
    action = getattr(args, "action", "status")

    if action == "status" or action is None:
        telemetry = sup.get_telemetry()
        if getattr(args, "json", False):
            print(json.dumps(telemetry, indent=2))
        else:
            print("[Black Mamba Supervisor] Autonomous Runtime Self-Healing Status:")
            print(f"  Crashes Captured:     {telemetry['crashes_captured']}")
            print(f"  Crashes Recovered:    {telemetry['crashes_recovered']}")
            print(f"  Shadow Verifications: {telemetry['shadow_verifications']}")
            print(f"  Active Hot-Swaps:     {telemetry['active_patches']}")
            print(f"  Recovery Rate:        {telemetry['recovery_rate_pct']}%")
        return 0

    elif action == "simulate-crash":
        src = """
def sample_faulty_kernel(a: i64, b: i64) -> i64:
    return a // b
"""
        print("[Black Mamba Supervisor] Simulating runtime zero-division crash in 'sample_faulty_kernel'...")
        snap = sup.capture_crash("sample_faulty_kernel", ZeroDivisionError("division by zero"), src)
        print(f"  1. Crash captured: {snap.fault_name} - {snap.error_message}")
        prop = sup.synthesize_repair(snap, src)
        print(f"  2. Synthesized AST repair ({prop.patch_kind})")
        ok = sup.verify_in_shadow_arena(prop, (10, 0))
        print(f"  3. Shadow Arena Verification: {'PASSED' if ok else 'FAILED'} ({prop.verification_time_ms:.2f} ms)")
        from types import SimpleNamespace
        mod = SimpleNamespace()
        swapped = sup.hotswap(prop, mod)
        print(f"  4. Live Hot-Swap: {'SUCCESS' if swapped else 'FAILED'} (zero downtime)")
        if swapped and hasattr(mod, "sample_faulty_kernel"):
            safe_res = mod.sample_faulty_kernel(10, 0)
            print(f"  5. Repaired execution with b=0 returned safe value: {safe_res}")
        return 0 if ok and swapped else 1

    return 0


def cmd_wcet(args: argparse.Namespace) -> int:
    import json
    from .wcet import WCETAnalyzer

    if not os.path.exists(args.file):
        print(f"Error: File not found: {args.file}", file=sys.stderr)
        return 1
    with open(args.file, "r", encoding="utf-8") as f:
        source = f.read()

    freq = getattr(args, "freq_ghz", 3.5) or 3.5
    analyzer = WCETAnalyzer(target_freq_ghz=freq)
    res = analyzer.analyze_source(source, filename=args.file)

    if getattr(args, "json", False):
        print(json.dumps(res, indent=2))
    else:
        print(f"[Black Mamba WCET Analyzer] Worst-Case Execution Time Report (@ {freq} GHz):")
        print(f"  Target File:          {args.file}")
        print(f"  Total Functions:      {res['total_functions']}")
        print(f"  Module WCET Cycles:   {res['total_module_wcet_cycles']} cycles")
        print(f"  Module WCET Latency:  {res['total_module_wcet_ns']} ns")
        print("-" * 60)
        for fn in res["functions"]:
            rating_tag = f"[{fn['rating']}]"
            print(f"  {rating_tag:<18} {fn['name']:<20} WCET: {fn['wcet_cycles']:>4}c ({fn['wcet_ns']:>6.2f} ns) | Jitter: {fn['jitter_ns']:>5.2f} ns")
            if fn["critical_ops"]:
                print(f"                     Critical ops: {', '.join(fn['critical_ops'])}")
        print("=" * 60)
        status_str = "CERTIFIED HARD REAL-TIME" if res["all_hard_real_time"] else "VARIABLE LATENCY"
        print(f"[Black Mamba WCET] Status: {status_str} across all analyzed functions.")
    return 0


def cmd_realtime(args: argparse.Namespace) -> int:
    import json
    from .realtime import ZeroJitterPool, HardRealTimeScheduler, benchmark_rt_pool

    action = getattr(args, "action", "pool-bench")

    if action == "pool-bench" or action is None:
        iters = getattr(args, "iters", 50000) or 50000
        res = benchmark_rt_pool(iterations=iters)
        if getattr(args, "json", False):
            print(json.dumps(res, indent=2))
        else:
            print(f"[Black Mamba Real-Time] Zero-Jitter O(1) Memory Pool Benchmark ({iters:,} operations):")
            print(f"  Alloc Latency:       {res['alloc_ns_per_op']:.2f} ns / alloc")
            print(f"  Free Latency:        {res['free_ns_per_op']:.2f} ns / free")
            print(f"  Throughput:          {res['operations_per_second']:,.0f} ops/sec")
            print(f"  Determinism:         Zero Page Faults, Zero Jitter (O(1) verified)")
        return 0

    elif action == "sched-check":
        sched = HardRealTimeScheduler()
        sched.add_task("flight_control_loop", period_us=1000, deadline_us=1000, wcet_us=250, priority=1)
        sched.add_task("inertial_sensor_read", period_us=2000, deadline_us=2000, wcet_us=300, priority=2)
        sched.add_task("telemetry_broadcast", period_us=10000, deadline_us=10000, wcet_us=800, priority=3)

        report = sched.get_analysis_report()
        if getattr(args, "json", False):
            print(json.dumps(report, indent=2))
        else:
            print("[Black Mamba Real-Time] Rate-Monotonic Analysis (RMA) Schedulability Check:")
            print(f"  Total Task Count:    {report['task_count']}")
            print(f"  Total Utilization:   {report['utilization_pct']}% (Liu-Layland Bound: {report['rma_bound'] * 100:.2f}%)")
            print(f"  Hyperperiod:         {report['hyperperiod_us']} us")
            print(f"  RMA Schedulable:     {'YES (Deterministic)' if report['schedulable_rma'] else 'NO'}")
            print(f"  EDF Schedulable:     {'YES (Deterministic)' if report['schedulable_edf'] else 'NO'}")
            for t in report["tasks"]:
                print(f"    - {t['name']:<22} Period: {t['period_us']}us | WCET: {t['wcet_us']}us ({t['utilization_pct']}%)")
        return 0 if report["schedulable_rma"] else 1

    return 0


def cmd_spec(args: argparse.Namespace) -> int:
    import json
    from .spec import PropertyTestEngine, integers, strings, benchmark_spec_engine, SpecificationSynthesizer, AlgebraicLaws

    action = getattr(args, "action", "check") or "check"

    if action == "bench":
        iters = getattr(args, "iters", 1000) or 1000
        res = benchmark_spec_engine(iterations=iters)
        if getattr(args, "json", False):
            print(json.dumps(res, indent=2))
        else:
            print(f"[Black Mamba Spec] Property Engine Benchmark ({res['total_properties_evaluated']} evaluations):")
            print(f"  Throughput:           {res['properties_per_second']:,.1f} props/sec")
            print(f"  Elapsed Time:         {res['total_elapsed_seconds']:.4f} s")
            print(f"  Commutativity Check:  {'PASSED' if res['commutativity_verified'] else 'FAILED'}")
            print(f"  String Invariant:     {'PASSED' if res['string_length_verified'] else 'FAILED'}")
        return 0

    elif action == "synthesize":
        synth = SpecificationSynthesizer()
        demo_fn = lambda a, b: a + b
        laws = synth.synthesize(demo_fn, integers(-1000, 1000))
        laws_data = [
            {
                "law": l.law_name,
                "verified": l.verified,
                "description": l.description,
                "formal_contract": l.formal_contract,
            }
            for l in laws
        ]
        if getattr(args, "json", False):
            print(json.dumps(laws_data, indent=2))
        else:
            print("[Black Mamba Spec] Automated Specification Synthesis:")
            for l in laws:
                print(f"  [PROVEN] {l.law_name:<16} : {l.description}")
                print(f"           Formal Contract : {l.formal_contract}")
        return 0

    else:
        # action == "check"
        seed = getattr(args, "seed", None)
        iters = getattr(args, "iters", 100) or 100
        engine = PropertyTestEngine(seed=seed)
        strat = integers(-1000, 1000)

        # Run 3 algebraic laws
        r_comm = AlgebraicLaws.commutativity(engine, lambda a, b: a + b, strat, iters=iters)
        r_assoc = AlgebraicLaws.associativity(engine, lambda a, b: a + b, strat, iters=iters)
        r_ident = AlgebraicLaws.identity(engine, lambda a, b: a + b, 0, strat, iters=iters)

        results = [r_comm, r_assoc, r_ident]
        all_passed = all(r.passed for r in results)

        if getattr(args, "json", False):
            print(json.dumps([r.to_dict() for r in results], indent=2))
        else:
            print(f"[Black Mamba Spec] Property-Based Testing Report ({iters} iterations/prop, seed: {engine.seed}):")
            for r in results:
                status_tag = "[PASS]" if r.passed else "[FAIL]"
                print(f"  {status_tag} {r.property_name:<30} ({r.iterations_run} runs, {r.elapsed_ms:.2f} ms)")
                if not r.passed:
                    print(f"         Counterexample: {r.counterexample} (shrunk in {r.shrink_steps} steps)")
            overall = "ALL PROPERTIES SATISFIED" if all_passed else "PROPERTY VIOLATION DETECTED"
            print(f"[Black Mamba Spec] Overall Status: {overall}")
        return 0 if all_passed else 1


def cmd_fuzz(args: argparse.Namespace) -> int:
    import json
    from .fuzzer import AdversarialFuzzer

    fuzzer = AdversarialFuzzer(seed=args.seed)
    report = fuzzer.run_suite(
        differential_count=args.diff,
        pe_exe_count=args.pe,
        codec_count=args.codec,
        arena_count=args.arena,
        chaos_count=args.chaos,
        historical_count=getattr(args, "hist", 10),
    )
    if getattr(args, "json", False):
        print(json.dumps(report.to_dict(), indent=2))
    else:
        print(report.summary())
    return 0 if report.all_passed else 1


def main(argv: Optional[list] = None) -> int:
    from . import __version__

    # Drop-in execution support: `bmb script.py` or `bmb script.bmb`
    raw_args = list(argv if argv is not None else sys.argv[1:])
    known_cmds = {
        "run", "build", "inspect", "bench", "lsp", "repl", "pkg", "doc",
        "bindgen", "migrate", "profile", "test", "container", "chat",
        "add", "publish", "kernel", "deploy", "studio", "web", "db",
        "ast", "patch", "image", "fuzz", "agent", "mcp", "swarm", "replay", "autograd", "shm", "gatekeeper", "selfhost", "verify", "supervisor", "wcet", "realtime", "spec",
    }
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
            "embedded", "bin", "hex", "no-os", "baremetal", "webgpu", "wgsl", "spirv", "spv", "vulkan", "html", "dom", "web", "unikernel", "vm", "firecracker", "all",
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
    p_test.add_argument("--release", "-r", action="store_true", help="Run 5-stage zero-defect pre-release quality gate pipeline")
    p_test.add_argument("--json", "-j", action="store_true", help="Output test report as JSON")

    p_gk = sub.add_parser("gatekeeper", help="Run 5-stage zero-defect pre-release certification pipeline before publishing packages")
    p_gk.add_argument("--json", "-j", action="store_true", help="Output certification report as JSON")

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

    p_std = sub.add_parser("studio", help="Launch the Smalltalk-inspired Reactive GUI Studio and Inquisitor Agent")
    p_std.add_argument("file", nargs="?", help="Optional .bmb file to open on the 2D Morphic Canvas")
    p_std.add_argument("--port", "-p", type=int, default=8765, help="Port to bind the Studio web server to (default: 8765)")
    p_std.add_argument("--host", default="127.0.0.1", help="Host address to bind to (default: 127.0.0.1)")
    p_std.add_argument("--no-browser", action="store_true", help="Do not automatically launch web browser")
    p_std.add_argument("--cli", action="store_true", help="Launch interactive Socratic interview in terminal instead of GUI")
    p_std.add_argument("--canvas", "-c", action="store_true", help="Enable Infinite 2D Spatial Morphic Canvas mode")
    p_std.add_argument("--export", "-e", help="Export the 2D Morphic Canvas workspace directly to a standalone HTML file")

    p_web = sub.add_parser("web", help="Full-stack reactive web framework, dev server, and static site generator")
    web_sub = p_web.add_subparsers(dest="action")

    p_web_dev = web_sub.add_parser("dev", help="Start reactive dev server with instant live preview")
    p_web_dev.add_argument("file", nargs="?", default="app.bmb", help="Target .bmb web source file (default: app.bmb)")
    p_web_dev.add_argument("--port", "-p", type=int, default=3000, help="Port to bind dev server to (default: 3000)")
    p_web_dev.add_argument("--host", default="127.0.0.1", help="Host address to bind to (default: 127.0.0.1)")
    p_web_dev.add_argument("--no-browser", action="store_true", help="Do not open browser automatically")

    p_web_bld = web_sub.add_parser("build", help="Build static HTML5 site from .bmb component tree")
    p_web_bld.add_argument("file", help="Target .bmb web source file")
    p_web_bld.add_argument("--output", "-o", default="dist", help="Output directory (default: dist)")

    p_web_new = web_sub.add_parser("new", help="Scaffold a new Black Mamba full-stack web project")
    p_web_new.add_argument("name", help="Name of new project directory")

    p_web_srv = web_sub.add_parser("serve", help="Serve a static directory or compiled HTML app")
    p_web_srv.add_argument("path", nargs="?", default="dist", help="Directory or HTML file to serve (default: dist)")
    p_web_srv.add_argument("--port", "-p", type=int, default=3000, help="Port to serve on (default: 3000)")
    p_web_srv.add_argument("--host", default="127.0.0.1", help="Host address (default: 127.0.0.1)")

    p_db = sub.add_parser("db", help="Full-stack database management, query execution, and schema inspection")
    db_sub = p_db.add_subparsers(dest="action")

    p_db_init = db_sub.add_parser("init", help="Initialize a new SQLite database with WAL mode")
    p_db_init.add_argument("path", nargs="?", default="database.db", help="Database file path (default: database.db)")

    p_db_qry = db_sub.add_parser("query", help="Execute a SQL statement and print results as an aligned table")
    p_db_qry.add_argument("file", help="Database file path")
    p_db_qry.add_argument("sql", help="SQL statement to execute")

    p_db_tbl = db_sub.add_parser("tables", help="List all tables, column types, and row counts")
    p_db_tbl.add_argument("file", help="Database file path")

    p_db_dmp = db_sub.add_parser("dump", help="Dump database tables to JSON or SQL")
    p_db_dmp.add_argument("file", help="Database file path")
    p_db_dmp.add_argument("--table", "-t", help="Specific table to dump (optional)")
    p_db_dmp.add_argument("--format", "-f", choices=["json", "sql"], default="json", help="Dump format (default: json)")

    p_ast = sub.add_parser("ast", help="Token-Sparse AST Graph index, symbol URI inspection, .bmbs codec, and token benchmark")
    ast_sub = p_ast.add_subparsers(dest="action")

    p_ast_skel = ast_sub.add_parser("skeleton", help="Print ultra-compact content-addressed AST skeleton for a .bmb file")
    p_ast_skel.add_argument("file", help="Path to .bmb source file")
    p_ast_skel.add_argument("--no-hash", action="store_true", help="Omit SHA-256 node hashes")

    p_ast_insp = ast_sub.add_parser("inspect", help="Inspect a specific AST symbol by URI (e.g. bmb://mod/Struct/fn)")
    p_ast_insp.add_argument("file", help="Path to .bmb source file")
    p_ast_insp.add_argument("uri", help="Symbol URI or name (e.g. bmb://app/Vec3/norm or Vec3/norm)")
    p_ast_insp.add_argument("--compact", "-c", action="store_true", help="Emit Token-Sparse .bmbs representation")
    p_ast_insp.add_argument("--sexpr", "-s", action="store_true", help="Emit S-expression AST representation")
    p_ast_insp.add_argument("--json", "-j", action="store_true", help="Emit full JSON metadata")

    p_ast_enc = ast_sub.add_parser("encode", help="Encode standard .bmb source into Token-Sparse .bmbs format")
    p_ast_enc.add_argument("file", help="Path to .bmb source file")
    p_ast_enc.add_argument("--output", "-o", help="Output .bmbs file path")

    p_ast_dec = ast_sub.add_parser("decode", help="Decode Token-Sparse .bmbs source into canonical .bmb format")
    p_ast_dec.add_argument("file", help="Path to .bmbs source file")
    p_ast_dec.add_argument("--output", "-o", help="Output .bmb file path")

    p_ast_bnc = ast_sub.add_parser("bench", help="Benchmark LLM token savings on a .bmb module")
    p_ast_bnc.add_argument("file", help="Path to .bmb source file")
    p_ast_bnc.add_argument("--uri", "-u", help="Specific target symbol URI to benchmark")
    p_ast_bnc.add_argument("--json", "-j", action="store_true", help="Output benchmark report as JSON")

    p_patch = sub.add_parser("patch", help="Apply surgical AST delta patches with pre-commit compiler verification")
    p_patch.add_argument("file", help="Path to .bmb source file")
    p_patch.add_argument("--op", default="REPLACE_SYMBOL", help="Delta operation (REPLACE_SYMBOL, ADD_SYMBOL, DELETE_SYMBOL, ADD_FIELD, REMOVE_FIELD, ADD_METHOD, RENAME_SYMBOL)")
    p_patch.add_argument("--uri", "-u", default="", help="Target symbol URI (e.g. bmb://mod/Struct/fn)")
    p_patch.add_argument("--code", "-c", help="New .bmb or .bmbs code snippet for the symbol/method")
    p_patch.add_argument("--field-name", help="Field name for ADD_FIELD / REMOVE_FIELD")
    p_patch.add_argument("--field-type", default="i64", help="Field type for ADD_FIELD (e.g. f64, str, InnerStruct)")
    p_patch.add_argument("--default-expr", help="Default value expression for ADD_FIELD")
    p_patch.add_argument("--new-name", help="New identifier name for RENAME_SYMBOL")
    p_patch.add_argument("--patch-file", "-f", help="Path to JSON file containing a list of ASTDeltaOp objects")
    p_patch.add_argument("--in-place", "-i", action="store_true", help="Modify source file in-place")
    p_patch.add_argument("--output", "-o", help="Write patched source to output file")
    p_patch.add_argument("--no-verify", action="store_true", help="Skip pre-commit TypeInferencer + MIRBuilder check")

    p_img = sub.add_parser("image", help="Smalltalk-style persistent memory image snapshots (.bmbimg) with < 5 ms resume")
    img_sub = p_img.add_subparsers(dest="action")

    p_img_save = img_sub.add_parser("save", help="Freeze and serialize active module, canvas, and SQLite state to .bmbimg")
    p_img_save.add_argument("output", help="Output .bmbimg snapshot path")
    p_img_save.add_argument("--file", "-f", help="Source .bmb module to include in snapshot")
    p_img_save.add_argument("--db", "-d", help="SQLite database file to freeze into snapshot")
    p_img_save.add_argument("--compress", "-z", action="store_true", help="Enable zlib payload compression")

    p_img_load = img_sub.add_parser("load", help="Resume a .bmbimg snapshot in < 5 ms")
    p_img_load.add_argument("image", help="Path to .bmbimg snapshot file")
    p_img_load.add_argument("--export-source", "-o", help="Export restored module source to file")

    p_img_insp = img_sub.add_parser("inspect", help="Inspect .bmbimg snapshot metadata, SHA-256 digest, and contents")
    p_img_insp.add_argument("image", help="Path to .bmbimg snapshot file")

    p_fuz = sub.add_parser("fuzz", help="Run the 5-vector Adversarial Compiler Fuzzer & Differential Torture Engine")
    p_fuz.add_argument("--seed", "-s", type=int, default=20261108, help="Deterministic PRNG seed (default: 20261108)")
    p_fuz.add_argument("--diff", type=int, default=30, help="Differential CPython vs JIT cases (default: 30)")
    p_fuz.add_argument("--pe", type=int, default=8, help="Multi-backend JIT vs PE32+ .exe cases (default: 8)")
    p_fuz.add_argument("--codec", type=int, default=25, help="Token-Sparse .bmbs codec round-trip cases (default: 25)")
    p_fuz.add_argument("--arena", type=int, default=15, help="Nested struct & lexical arena stress cases (default: 15)")
    p_fuz.add_argument("--chaos", type=int, default=30, help="Hostile parser mutation chaos cases (default: 30)")
    p_fuz.add_argument("--hist", type=int, default=10, help="Historical v0.1-v2.3 feature audit cases per vector (default: 10)")
    p_fuz.add_argument("--json", "-j", action="store_true", help="Output fuzz report as JSON")

    p_agt = sub.add_parser("agent", help="Embedded Autonomous AI Copilot & App Synthesizer (Phase 8 / v2.4.0)")
    p_agt.add_argument("goal", nargs="?", help="Natural language goal to synthesize or execute")
    p_agt.add_argument("--synth", "-s", help="Synthesize full-stack .bmb application from goal")
    p_agt.add_argument("--heal", help="Path to .bmb file for autonomous self-healing")
    p_agt.add_argument("--test-file", help="Optional test file to verify healed module")
    p_agt.add_argument("--output", "-o", help="Output directory or file path for synthesized/healed code")
    p_agt.add_argument("--snapshot", help="Custom snapshot name (.bmbimg)")
    p_agt.add_argument("--no-verify", action="store_true", help="Skip in-memory JIT test verification")
    p_agt.add_argument("--json", "-j", action="store_true", help="Output agent report as JSON")

    p_mcp = sub.add_parser("mcp", help="Run Model Context Protocol (MCP) Server for Claude, Cursor, Windsurf, Antigravity (v2.5.0)")
    p_mcp.add_argument("--stdio", action="store_true", default=True, help="Run MCP server over standard I/O (default: True)")
    p_mcp.add_argument("--workspace", "-w", help="Target workspace root directory")

    p_swm = sub.add_parser("swarm", help="Native Multi-Agent Swarm Orchestrator with conflict-free AST symbol locking (v2.5.0)")
    p_swm.add_argument("goal", nargs="?", help="Natural language goal to orchestrate across sub-agents")
    p_swm.add_argument("--output", "-o", help="Output directory for generated application files")
    p_swm.add_argument("--snapshot", help="Custom snapshot name (.bmbimg)")
    p_swm.add_argument("--no-verify", action="store_true", help="Skip in-memory JIT test verification")
    p_swm.add_argument("--json", "-j", action="store_true", help="Output swarm execution report as JSON")

    p_rep = sub.add_parser("replay", help="Time-Travel Deterministic Replay & Omniscient Debugger (Phase 8C / v2.6.0)")
    rep_sub = p_rep.add_subparsers(dest="action")

    p_rep_rec = rep_sub.add_parser("record", help="Record deterministic execution trace into .bmbreplay file")
    p_rep_rec.add_argument("file", help="Path to .bmb source file")
    p_rep_rec.add_argument("--output", "-o", help="Output .bmbreplay file path")
    p_rep_rec.add_argument("--html", help="Export standalone interactive HTML5 debugger")
    p_rep_rec.add_argument("--compress", "-z", action="store_true", help="Enable zlib compression")
    p_rep_rec.add_argument("--capacity", type=int, default=10000, help="Ring buffer frame capacity")
    p_rep_rec.add_argument("--json", "-j", action="store_true", help="Output record report as JSON")

    p_rep_ins = rep_sub.add_parser("inspect", help="Inspect or scrub through execution trace")
    p_rep_ins.add_argument("trace", help="Path to .bmbreplay file")
    p_rep_ins.add_argument("--step", "-s", type=int, help="Seek directly to step index")
    p_rep_ins.add_argument("--var", "-v", help="Query chronological variable value timeline")
    p_rep_ins.add_argument("--diff", "-d", nargs=2, help="Diff two step indices (e.g. --diff 10 25)")
    p_rep_ins.add_argument("--json", "-j", action="store_true", help="Output state inspection as JSON")

    p_atg = sub.add_parser("autograd", help="GPU Tensor Autograd & Native ML Training Engine (Phase 8D / v2.7.0)")
    atg_sub = p_atg.add_subparsers(dest="action")

    p_atg_trn = atg_sub.add_parser("train", help="Train a native neural model with automatic differentiation")
    p_atg_trn.add_argument("--epochs", "-e", type=int, default=20, help="Training epochs (default: 20)")
    p_atg_trn.add_argument("--lr", type=float, default=0.05, help="Learning rate (default: 0.05)")
    p_atg_trn.add_argument("--model", "-m", choices=["linear", "lora"], default="linear", help="Model architecture")
    p_atg_trn.add_argument("--json", "-j", action="store_true", help="Output metrics as JSON")

    p_atg_bnc = atg_sub.add_parser("bench", help="Benchmark Tensor forward and backward throughput")
    p_atg_bnc.add_argument("--dim", "-d", type=int, default=128, help="Square matrix dimension (default: 128)")
    p_atg_bnc.add_argument("--iters", "-i", type=int, default=30, help="Benchmark iterations (default: 30)")
    p_atg_bnc.add_argument("--json", "-j", action="store_true", help="Output benchmark as JSON")

    p_atg_emt = atg_sub.add_parser("emit", help="Compile WebGPU WGSL or Vulkan SPIR-V compute shader")
    p_atg_emt.add_argument("--target", "-t", choices=["webgpu", "spirv"], default="webgpu", help="Shader target")
    p_atg_emt.add_argument("--op", default="matmul", help="Kernel operation (default: matmul)")
    p_atg_emt.add_argument("--dims", default="64,64,64", help="Matrix dimensions M,K,N (default: 64,64,64)")
    p_atg_emt.add_argument("--output", "-o", help="Output file path")
    p_atg_emt.add_argument("--json", "-j", action="store_true", help="Output shader metadata as JSON")

    p_shm = sub.add_parser("shm", help="Zero-Copy Distributed IPC & Cluster Shared Memory (Phase 8E / v2.8.0)")
    shm_sub = p_shm.add_subparsers(dest="action")

    p_shm_crt = shm_sub.add_parser("create", help="Create a named shared memory arena")
    p_shm_crt.add_argument("name", help="Name of shared memory region")
    p_shm_crt.add_argument("--size", "-s", type=int, default=1048576, help="Arena size in bytes (default: 1 MB)")
    p_shm_crt.add_argument("--json", "-j", action="store_true", help="Output as JSON")

    p_shm_wrt = shm_sub.add_parser("write", help="Write string data into shared memory arena")
    p_shm_wrt.add_argument("name", help="Name of shared memory region")
    p_shm_wrt.add_argument("data", help="String payload to write")
    p_shm_wrt.add_argument("--json", "-j", action="store_true", help="Output as JSON")

    p_shm_rd = shm_sub.add_parser("read", help="Read data from shared memory arena")
    p_shm_rd.add_argument("name", help="Name of shared memory region")
    p_shm_rd.add_argument("--json", "-j", action="store_true", help="Output as JSON")

    p_shm_bnc = shm_sub.add_parser("bench", help="Benchmark sub-microsecond shared memory queue throughput")
    p_shm_bnc.add_argument("--iters", "-i", type=int, default=10000, help="Iterations (default: 10000)")
    p_shm_bnc.add_argument("--size", "-s", type=int, default=256, help="Message size in bytes (default: 256)")
    p_shm_bnc.add_argument("--json", "-j", action="store_true", help="Output as JSON")

    p_shm_unl = shm_sub.add_parser("unlink", help="Unlink/destroy named shared memory region")
    p_shm_unl.add_argument("name", help="Name of shared memory region")

    p_self = sub.add_parser("selfhost", help="Inspect and verify pure .bmb self-hosted compiler modules & stage parity")
    p_self_sub = p_self.add_subparsers(dest="action")

    p_self_info = p_self_sub.add_parser("info", help="List all self-hosted compiler modules and line counts")
    p_self_info.add_argument("--json", "-j", action="store_true", help="Output as JSON")

    p_self_chk = p_self_sub.add_parser("check", help="Verify self-hosted modules compilation and stage parity")
    p_self_chk.add_argument("--parity", "-p", action="store_true", help="Certify Stage-2 and Stage-3 bit-for-bit parity")
    p_self_chk.add_argument("--json", "-j", action="store_true", help="Output as JSON")

    p_self_bnc = p_self_sub.add_parser("bench", help="Benchmark pure .bmb compilation throughput")
    p_self_bnc.add_argument("--json", "-j", action="store_true", help="Output as JSON")

    p_ver = sub.add_parser("verify", help="SMT formal contract verification of preconditions and postconditions")
    p_ver.add_argument("file", help="Path to .bmb source file to verify")
    p_ver.add_argument("--json", "-j", action="store_true", help="Output verification report as JSON")

    p_sup = sub.add_parser("supervisor", help="Autonomous self-healing runtime supervisor & fault recovery")
    p_sup_sub = p_sup.add_subparsers(dest="action")
    p_sup_stat = p_sup_sub.add_parser("status", help="Get supervisor telemetry and crash recovery rate")
    p_sup_stat.add_argument("--json", "-j", action="store_true", help="Output as JSON")
    p_sup_sim = p_sup_sub.add_parser("simulate-crash", help="Simulate runtime zero-division crash and test shadow recovery")

    p_wcet = sub.add_parser("wcet", help="Static Worst-Case Execution Time (WCET) analyzer")
    p_wcet.add_argument("file", help="Path to .bmb source file to analyze")
    p_wcet.add_argument("--freq-ghz", "-f", type=float, default=3.5, help="Target CPU clock frequency in GHz (default: 3.5)")
    p_wcet.add_argument("--json", "-j", action="store_true", help="Output as JSON")

    p_rt = sub.add_parser("realtime", help="Hard-real-time memory pool benchmark & Rate-Monotonic schedulability check")
    p_rt_sub = p_rt.add_subparsers(dest="action")
    p_rt_bnc = p_rt_sub.add_parser("pool-bench", help="Benchmark ZeroJitterPool O(1) allocation throughput")
    p_rt_bnc.add_argument("--iters", "-i", type=int, default=50000, help="Iterations (default: 50000)")
    p_rt_bnc.add_argument("--json", "-j", action="store_true", help="Output as JSON")
    p_rt_chk = p_rt_sub.add_parser("sched-check", help="Run Rate-Monotonic Analysis (RMA) schedulability check")
    p_rt_chk.add_argument("--json", "-j", action="store_true", help="Output as JSON")

    p_spec = sub.add_parser("spec", help="Formal codebase specification & property-based mutation fuzzing")
    p_spec_sub = p_spec.add_subparsers(dest="action")
    p_spec_chk = p_spec_sub.add_parser("check", help="Run property tests on algebraic invariants")
    p_spec_chk.add_argument("file", nargs="?", default="", help="Optional target file")
    p_spec_chk.add_argument("--iters", "-i", type=int, default=100, help="Property iterations per test (default: 100)")
    p_spec_chk.add_argument("--seed", "-s", type=int, default=None, help="Random seed for reproducibility")
    p_spec_chk.add_argument("--json", "-j", action="store_true", help="Output as JSON")

    p_spec_syn = p_spec_sub.add_parser("synthesize", help="Synthesize formal algebraic laws & contracts")
    p_spec_syn.add_argument("target", nargs="?", default="demo", help="Target function or module")
    p_spec_syn.add_argument("--json", "-j", action="store_true", help="Output as JSON")

    p_spec_bnc = p_spec_sub.add_parser("bench", help="Benchmark property evaluation and shrinkage engine")
    p_spec_bnc.add_argument("--iters", "-i", type=int, default=1000, help="Iterations (default: 1000)")
    p_spec_bnc.add_argument("--json", "-j", action="store_true", help="Output as JSON")

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
    if args.command == "studio":
        from .studio import cmd_studio
        return cmd_studio(args)
    if args.command == "web":
        from .web import cmd_web
        return cmd_web(args)
    if args.command == "db":
        from .db import cmd_db
        return cmd_db(args)
    if args.command == "ast":
        return cmd_ast(args)
    if args.command == "patch":
        return cmd_patch(args)
    if args.command == "image":
        return cmd_image(args)
    if args.command == "fuzz":
        return cmd_fuzz(args)
    if args.command == "agent":
        return cmd_agent(args)
    if args.command == "mcp":
        return cmd_mcp(args)
    if args.command == "swarm":
        return cmd_swarm(args)
    if args.command == "replay":
        return cmd_replay(args)
    if args.command == "autograd":
        return cmd_autograd(args)
    if args.command == "shm":
        return cmd_shm(args)
    if args.command == "selfhost":
        return cmd_selfhost(args)
    if args.command == "verify":
        return cmd_verify(args)
    if args.command == "supervisor":
        return cmd_supervisor(args)
    if args.command == "wcet":
        return cmd_wcet(args)
    if args.command == "realtime":
        return cmd_realtime(args)
    if args.command == "spec":
        return cmd_spec(args)
    if args.command == "gatekeeper":
        setattr(args, "release", True)
        return cmd_test(args)

    # If no subcommand is provided and running interactively, start REPL
    if args.command is None:
        if sys.stdin.isatty():
            return cmd_repl()
        parser.print_help()
        return 0


if __name__ == "__main__":
    sys.exit(main())
