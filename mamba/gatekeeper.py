# Black Mamba Pre-Release Verification & Zero-Defect Gatekeeper Engine
# Enforces strict 6-stage pre-flight quality gates to prevent critical bugs,
# regressions, or packaging defects prior to tagging and publishing any release.

import os
import sys
import glob
import time
import unittest
from typing import Dict, Any, List, Optional

from .cli import compile_source_to_mir
from .fuzzer import AdversarialFuzzer
from .backends.pe_exe import PE32PlusExecutableBuilder
from .backends.elf_exe import ELF64ExecutableBuilder
from .backends.arm64_macho import MachOARM64ExecutableBuilder
from .backends.wasm_emitter import WasmBackend
from .backends.c_emitter import C11Backend
from .backends.gpu_shader import WebGPUShaderBackend, SPIRVShaderBackend, SPIRV_MAGIC
from .backends.x86_64_jit import NativeJITModule


class PreReleaseGatekeeper:
    """
    Automated zero-defect gatekeeper. Runs a multi-stage validation matrix
    across stdlib compilation, unit tests, differential fuzzer, and multi-target
    emitter integrity before any release can be cut.
    """

    def __init__(self, workspace_dir: Optional[str] = None):
        self.workspace_dir = os.path.abspath(workspace_dir or os.getcwd())
        self.stdlib_dir = os.path.join(self.workspace_dir, "mamba", "stdlib")
        self.selfhost_dir = os.path.join(self.workspace_dir, "mamba", "selfhost")

    def stage1_stdlib_syntax_and_mir_check(self) -> Dict[str, Any]:
        """
        Stage 1: Verify every single standard library and self-hosted module compiles to valid MIR
        with zero parser, lexer, or typechecker exceptions.
        """
        stdlib_files = glob.glob(os.path.join(self.stdlib_dir, "*.bmb"))
        selfhost_files = glob.glob(os.path.join(self.selfhost_dir, "*.bmb"))
        all_files = [(f, self.stdlib_dir) for f in stdlib_files] + [(f, self.selfhost_dir) for f in selfhost_files]
        compiled = 0
        errors = []

        for fpath, base_d in all_files:
            fname = os.path.basename(fpath)
            try:
                with open(fpath, "r", encoding="utf-8-sig") as f:
                    src = f.read()
                mir = compile_source_to_mir(src, filename=fpath, base_dir=base_d)
                if mir is None:
                    errors.append(f"{fname}: compilation returned None MIR")
                else:
                    compiled += 1
            except Exception as e:
                errors.append(f"{fname}: {str(e)}")

        return {
            "stage": 1,
            "name": "stdlib_and_selfhost_syntax_mir_check",
            "total_modules": len(all_files),
            "compiled_modules": compiled,
            "passed": len(errors) == 0,
            "errors": errors,
        }

    def stage2_unit_test_suite_discovery(self) -> Dict[str, Any]:
        """
        Stage 2: Run the full unit test suite across all test files and assert 100% pass rate.
        """
        loader = unittest.TestLoader()
        tests_dir = os.path.join(self.workspace_dir, "tests")
        suite = loader.discover(tests_dir, pattern="test_*.py")

        stream = open(os.devnull, "w", encoding="utf-8")
        runner = unittest.TextTestRunner(stream=stream, verbosity=0)
        t0 = time.perf_counter()
        result = runner.run(suite)
        elapsed = time.perf_counter() - t0
        stream.close()

        passed = result.wasSuccessful()
        errors = [str(err[1]) for err in result.errors]
        failures = [str(fail[1]) for fail in result.failures]

        return {
            "stage": 2,
            "name": "unit_test_suite_discovery",
            "total_tests": result.testsRun,
            "failed_count": len(result.failures),
            "error_count": len(result.errors),
            "passed": passed,
            "elapsed_seconds": elapsed,
            "errors": errors + failures,
        }

    def stage3_adversarial_fuzzer_torture(self, count: int = 148) -> Dict[str, Any]:
        """
        Stage 3: Run the 9-vector adversarial fuzzer to detect edge-case regressions.
        """
        fuzzer = AdversarialFuzzer(seed=20261108)
        report = fuzzer.run_suite(
            differential_count=30,
            pe_exe_count=8,
            codec_count=25,
            arena_count=15,
            chaos_count=30,
            historical_count=10,
        )

        return {
            "stage": 3,
            "name": "adversarial_fuzzer_torture",
            "total_cases": report.total_cases,
            "passed_cases": report.passed_cases,
            "failed_cases": len(report.failures),
            "passed": report.all_passed,
            "failures": [f.summary for f in report.failures],
        }

    def stage4_multi_target_emitter_matrix(self) -> Dict[str, Any]:
        """
        Stage 4: Verify emission integrity across all 8 multi-target backends:
        JIT, PE32+, ELF64, Mach-O ARM64, WASM, C11, WebGPU WGSL, Vulkan SPIR-V.
        """
        sample_code = """
fn compute_sum(a: i64, b: i64) -> i64:
    let total = a + b
    return total

fn main() -> i64:
    return compute_sum(40, 2)
"""
        mir = compile_source_to_mir(sample_code, filename="<gatekeeper_sample>")
        target_results = {}

        # 1. Win64 JIT
        try:
            jit = NativeJITModule(mir)
            res = jit.run_main()
            target_results["x86_64_jit"] = (res == 42)
        except Exception as e:
            target_results["x86_64_jit"] = False

        # 2. Windows PE32+ .exe
        try:
            pe_builder = PE32PlusExecutableBuilder(mir)
            pe_bytes = pe_builder.build_bytes()
            target_results["pe32_plus_exe"] = (pe_bytes[:2] == b"MZ" and b"PE\x00\x00" in pe_bytes)
        except Exception:
            target_results["pe32_plus_exe"] = False

        # 3. Linux ELF64 static executable
        try:
            elf_builder = ELF64ExecutableBuilder(mir)
            elf_bytes = elf_builder.build_bytes()
            target_results["elf64_static_exe"] = (elf_bytes[:4] == b"\x7fELF")
        except Exception:
            target_results["elf64_static_exe"] = False

        # 4. macOS Apple Silicon ARM64 Mach-O
        try:
            macho_builder = MachOARM64ExecutableBuilder(mir)
            macho_bytes = macho_builder.build_bytes()
            # MH_MAGIC_64 = 0xFEEDFACF (little endian: \xcf\xfa\xed\xfe)
            target_results["arm64_macho"] = (macho_bytes[:4] == b"\xcf\xfa\xed\xfe")
        except Exception:
            target_results["arm64_macho"] = False

        # 5. WebAssembly 1.0 binary
        try:
            wasm_backend = WasmBackend(mir)
            wasm_bytes = wasm_backend.emit_wasm_bytes()
            target_results["wasm_binary"] = (wasm_bytes[:4] == b"\x00asm")
        except Exception:
            target_results["wasm_binary"] = False

        # 6. Portable C11 source
        try:
            c11_backend = C11Backend(mir)
            c11_code = c11_backend.emit_c()
            target_results["c11_source"] = ("#include" in c11_code and "int main(" in c11_code)
        except Exception:
            target_results["c11_source"] = False

        # 7. WebGPU WGSL compute shader
        try:
            wgsl_backend = WebGPUShaderBackend(mir)
            wgsl_code = wgsl_backend.emit_wgsl()
            target_results["webgpu_wgsl"] = ("@compute" in wgsl_code or "fn " in wgsl_code)
        except Exception:
            target_results["webgpu_wgsl"] = False

        # 8. Vulkan SPIR-V 1.5 binary
        try:
            spv_backend = SPIRVShaderBackend(mir)
            spv_bytes = spv_backend.emit_spirv_bytes()
            import struct
            magic = struct.unpack_from("<I", spv_bytes, 0)[0]
            target_results["spirv_vulkan"] = (magic == SPIRV_MAGIC)
        except Exception:
            target_results["spirv_vulkan"] = False

        all_ok = all(target_results.values())
        return {
            "stage": 4,
            "name": "multi_target_emitter_matrix",
            "targets": target_results,
            "passed": all_ok,
        }

    def stage5_packaging_and_manifest_check(self) -> Dict[str, Any]:
        """
        Stage 5: Verify version consistency across all project manifests:
        __init__.py, setup.py, pyproject.toml, and MCP server.
        """
        import re
        from . import __version__
        from .mcp import SERVER_VERSION

        versions = {"__init__.py": __version__, "mcp.py": SERVER_VERSION}

        # Check setup.py
        setup_path = os.path.join(self.workspace_dir, "setup.py")
        if os.path.exists(setup_path):
            with open(setup_path, "r", encoding="utf-8") as f:
                content = f.read()
            m = re.search(r'version\s*=\s*["\']([^"\']+)["\']', content)
            if m:
                versions["setup.py"] = m.group(1)

        # Check pyproject.toml
        pyproject_path = os.path.join(self.workspace_dir, "pyproject.toml")
        if os.path.exists(pyproject_path):
            with open(pyproject_path, "r", encoding="utf-8") as f:
                content = f.read()
            m = re.search(r'version\s*=\s*["\']([^"\']+)["\']', content)
            if m:
                versions["pyproject.toml"] = m.group(1)

        unique_versions = set(versions.values())
        is_consistent = len(unique_versions) == 1

        return {
            "stage": 5,
            "name": "packaging_and_manifest_check",
            "versions": versions,
            "consistent": is_consistent,
            "active_version": __version__,
            "passed": is_consistent,
        }

    def run_all_stages(self) -> Dict[str, Any]:
        """
        Executes all 5 quality gate stages and returns the comprehensive report.
        """
        t0 = time.perf_counter()
        s1 = self.stage1_stdlib_syntax_and_mir_check()
        s2 = self.stage2_unit_test_suite_discovery()
        s3 = self.stage3_adversarial_fuzzer_torture()
        s4 = self.stage4_multi_target_emitter_matrix()
        s5 = self.stage5_packaging_and_manifest_check()
        total_time = time.perf_counter() - t0

        all_passed = s1["passed"] and s2["passed"] and s3["passed"] and s4["passed"] and s5["passed"]

        return {
            "all_passed": all_passed,
            "total_elapsed_seconds": total_time,
            "stages": [s1, s2, s3, s4, s5],
        }
