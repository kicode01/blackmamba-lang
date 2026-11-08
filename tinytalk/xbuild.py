# Black Mamba Pure Native Multi-Arch Cross-Toolchain Engine
# Phase 9F (v3.4.5): Zero-Dependency Cross-Target Binary Emission
# Compiles to Windows PE32+, Linux ELF64, macOS Mach-O, WASI, and Unikernel with 0 external C toolchains.

import os
import time
from dataclasses import dataclass
from typing import Dict, List, Optional, Any

from .backends.pe_exe import PE32PlusExecutableBuilder
from .backends.elf_exe import ELF64ExecutableBuilder
from .backends.arm64_macho import MachOARM64ExecutableBuilder
from .backends.wasm_emitter import WasmBackend
from .backends.c_emitter import C11Backend
from .unikernel import UnikernelBuilder
from .mir import MIRModule


@dataclass
class TargetPlatform:
    name: str
    os_name: str
    arch: str
    format_name: str
    output_ext: str
    pointer_width: int
    description: str


SUPPORTED_TARGETS: Dict[str, TargetPlatform] = {
    "windows-x64": TargetPlatform(
        name="windows-x64",
        os_name="Windows",
        arch="x86_64",
        format_name="PE32+",
        output_ext=".exe",
        pointer_width=8,
        description="Standalone Windows 64-bit PE32+ Executable",
    ),
    "linux-x64": TargetPlatform(
        name="linux-x64",
        os_name="Linux",
        arch="x86_64",
        format_name="ELF64",
        output_ext=".elf",
        pointer_width=8,
        description="Static Linux 64-bit ELF Executable (System V ABI)",
    ),
    "macos-arm64": TargetPlatform(
        name="macos-arm64",
        os_name="Darwin",
        arch="arm64",
        format_name="Mach-O",
        output_ext=".macho",
        pointer_width=8,
        description="Apple Silicon macOS 64-bit Mach-O Executable",
    ),
    "wasi": TargetPlatform(
        name="wasi",
        os_name="WASI",
        arch="wasm32",
        format_name="WebAssembly",
        output_ext=".wasm",
        pointer_width=4,
        description="Standard WebAssembly 1.0 Binary (WASI runtime)",
    ),
    "c11": TargetPlatform(
        name="c11",
        os_name="Portable",
        arch="any",
        format_name="C11 Source",
        output_ext=".c",
        pointer_width=8,
        description="Portable ISO C11 Source with OpenMP/SIMD",
    ),
    "unikernel": TargetPlatform(
        name="unikernel",
        os_name="BareMetal",
        arch="x86_64",
        format_name="Raw Image",
        output_ext=".raw",
        pointer_width=8,
        description="Bare-Metal Cloud Unikernel for KVM & Firecracker",
    ),
}


class CrossCompiler:
    """
    Host-independent native cross-compiler.
    Emits standalone executables and binaries for all major platforms
    without requiring external C/C++ cross-compilers or system linkers.
    """

    def __init__(self):
        self.targets = SUPPORTED_TARGETS

    def build_target(self, mir: MIRModule, target_key: str, output_path: str, source_code: Optional[str] = None) -> Dict[str, Any]:
        key = target_key.lower().strip()
        if key not in self.targets:
            # Match aliases
            if key in ("windows", "win", "exe", "win64"): key = "windows-x64"
            elif key in ("linux", "elf", "elf64"): key = "linux-x64"
            elif key in ("macos", "macho", "arm64", "apple"): key = "macos-arm64"
            elif key in ("wasm", "wat", "webassembly"): key = "wasi"
            elif key in ("c", "c-source"): key = "c11"
            elif key in ("vm", "firecracker"): key = "unikernel"
            else:
                raise ValueError(f"Unknown cross-compilation target: '{target_key}'. Supported: {list(self.targets.keys())}")

        target_info = self.targets[key]
        t0 = time.perf_counter()

        # Ensure directory exists
        out_dir = os.path.dirname(output_path)
        if out_dir:
            os.makedirs(out_dir, exist_ok=True)

        size_bytes = 0

        if key == "windows-x64":
            builder = PE32PlusExecutableBuilder(mir)
            builder.write_executable(output_path)
            size_bytes = os.path.getsize(output_path)

        elif key == "linux-x64":
            builder = ELF64ExecutableBuilder(mir)
            builder.write_executable(output_path)
            size_bytes = os.path.getsize(output_path)

        elif key == "macos-arm64":
            builder = MachOARM64ExecutableBuilder(mir)
            builder.write_executable(output_path)
            size_bytes = os.path.getsize(output_path)

        elif key == "wasi":
            builder = WasmBackend(mir)
            builder.write_wasm(output_path)
            size_bytes = os.path.getsize(output_path)

        elif key == "c11":
            builder = C11Backend(mir)
            builder.write_c(output_path)
            size_bytes = os.path.getsize(output_path)

        elif key == "unikernel":
            uni_builder = UnikernelBuilder(memory_mb=128)
            src = source_code or "def main() -> i64:\n    return 0\n"
            res = uni_builder.build_unikernel_image(src, output_path)
            size_bytes = res["image_bytes"]

        elapsed_ms = (time.perf_counter() - t0) * 1000.0

        return {
            "target": target_info.name,
            "format": target_info.format_name,
            "output_path": output_path,
            "size_bytes": size_bytes,
            "elapsed_ms": round(elapsed_ms, 2),
            "zero_external_dependencies": True,
        }

    def build_source_file(self, source_path: str, target_keys: Optional[List[str]] = None, base_out_dir: str = "dist/bin") -> List[Dict[str, Any]]:
        from .cli import compile_source_to_mir
        with open(source_path, "r", encoding="utf-8") as f:
            src = f.read()
        mir = compile_source_to_mir(src)
        base_name = os.path.splitext(os.path.basename(source_path))[0]
        keys = target_keys or list(self.targets.keys())
        results = []
        os.makedirs(base_out_dir, exist_ok=True)

        for key in keys:
            norm_key = key.lower().strip()
            if norm_key in ("windows", "win", "exe", "win64"): norm_key = "windows-x64"
            elif norm_key in ("linux", "elf", "elf64"): norm_key = "linux-x64"
            elif norm_key in ("macos", "macho", "arm64", "apple"): norm_key = "macos-arm64"
            elif norm_key in ("wasm", "wat", "webassembly"): norm_key = "wasi"
            elif norm_key in ("c", "c-source"): norm_key = "c11"
            elif norm_key in ("vm", "firecracker"): norm_key = "unikernel"

            t_info = self.targets.get(norm_key)
            if not t_info:
                continue
            out_file = os.path.join(base_out_dir, f"{base_name}_{t_info.name}{t_info.output_ext}")
            res = self.build_target(mir, norm_key, out_file, source_code=src)
            results.append(res)
        return results

    def build_matrix(self, mir: MIRModule, target_keys: Optional[List[str]] = None, base_out_dir: str = "dist/xbuild") -> List[Dict[str, Any]]:
        keys = target_keys or list(self.targets.keys())
        results = []
        os.makedirs(base_out_dir, exist_ok=True)

        for key in keys:
            t_info = self.targets.get(key)
            if not t_info:
                continue
            out_file = os.path.join(base_out_dir, f"app_{t_info.name}{t_info.output_ext}")
            res = self.build_target(mir, key, out_file)
            results.append(res)

        return results


def benchmark_xbuild_matrix(iterations: int = 20) -> Dict[str, Any]:
    from .cli import compile_source_to_mir
    sample_src = "def add(a: i64, b: i64) -> i64:\n    return a + b\ndef main() -> i64:\n    return add(40, 2)\n"
    mir = compile_source_to_mir(sample_src)
    compiler = CrossCompiler()

    import tempfile
    t0 = time.perf_counter()
    with tempfile.TemporaryDirectory() as tmpdir:
        for _ in range(iterations):
            # Test PE, ELF, Mach-O, WASM cross-emission
            compiler.build_target(mir, "windows-x64", os.path.join(tmpdir, "test.exe"))
            compiler.build_target(mir, "linux-x64", os.path.join(tmpdir, "test.elf"))
            compiler.build_target(mir, "macos-arm64", os.path.join(tmpdir, "test.macho"))
            compiler.build_target(mir, "wasi", os.path.join(tmpdir, "test.wasm"))
    total_time = time.perf_counter() - t0

    total_builds = iterations * 4
    builds_per_sec = total_builds / total_time if total_time > 0 else 0.0

    return {
        "targets": ["windows-x64", "linux-x64", "macos-arm64", "wasi"],
        "iterations": iterations,
        "total_targets_built": total_builds,
        "total_elapsed_seconds": round(total_time, 4),
        "builds_per_second": round(builds_per_sec, 1),
        "ms_per_cross_build": round((total_time / total_builds) * 1000.0, 2),
    }
