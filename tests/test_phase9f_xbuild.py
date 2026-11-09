"""Unit and integration tests for Phase 9F: Pure Native Multi-Arch Cross-Toolchain (v3.4.5).
"""

import os
import tempfile
import unittest

from mamba import (
    TargetPlatform,
    SUPPORTED_TARGETS,
    CrossCompiler,
    benchmark_xbuild_matrix,
)
from mamba.cli import compile_source_to_mir
from mamba.backends.x86_64_jit import NativeJITModule


class TestPhase9FXBuild(unittest.TestCase):
    def setUp(self):
        self.sample_src = """
def compute(x: i64) -> i64:
    return x * 2 + 10

def main() -> i64:
    return compute(16)
"""

    def test_01_target_platform_metadata(self):
        """Test supported target platform definitions, architectures, and extensions."""
        self.assertIn("windows-x64", SUPPORTED_TARGETS)
        self.assertIn("linux-x64", SUPPORTED_TARGETS)
        self.assertIn("macos-arm64", SUPPORTED_TARGETS)
        self.assertIn("wasi", SUPPORTED_TARGETS)
        self.assertIn("c11", SUPPORTED_TARGETS)
        self.assertIn("unikernel", SUPPORTED_TARGETS)

        win = SUPPORTED_TARGETS["windows-x64"]
        self.assertEqual(win.arch, "x86_64")
        self.assertEqual(win.output_ext, ".exe")

        linux = SUPPORTED_TARGETS["linux-x64"]
        self.assertEqual(linux.arch, "x86_64")
        self.assertEqual(linux.output_ext, ".elf")

        macos = SUPPORTED_TARGETS["macos-arm64"]
        self.assertEqual(macos.arch, "arm64")
        self.assertEqual(macos.output_ext, ".macho")

        wasm = SUPPORTED_TARGETS["wasi"]
        self.assertEqual(wasm.arch, "wasm32")
        self.assertEqual(wasm.output_ext, ".wasm")

    def test_02_pe_and_elf_cross_emission(self):
        """Test zero-dependency cross-compilation to Windows PE32+ and Linux ELF64."""
        mir = compile_source_to_mir(self.sample_src)
        compiler = CrossCompiler()

        with tempfile.TemporaryDirectory() as tmpdir:
            exe_path = os.path.join(tmpdir, "test.exe")
            elf_path = os.path.join(tmpdir, "test.elf")

            res_exe = compiler.build_target(mir, "windows-x64", exe_path)
            res_elf = compiler.build_target(mir, "linux-x64", elf_path)

            self.assertTrue(os.path.exists(exe_path))
            self.assertGreater(res_exe["size_bytes"], 1000)
            self.assertTrue(res_exe["zero_external_dependencies"])

            self.assertTrue(os.path.exists(elf_path))
            self.assertGreater(res_elf["size_bytes"], 1000)
            self.assertTrue(res_elf["zero_external_dependencies"])

    def test_03_macho_and_wasm_cross_emission(self):
        """Test zero-dependency cross-compilation to macOS ARM64 Mach-O and WebAssembly."""
        mir = compile_source_to_mir(self.sample_src)
        compiler = CrossCompiler()

        with tempfile.TemporaryDirectory() as tmpdir:
            macho_path = os.path.join(tmpdir, "test.macho")
            wasm_path = os.path.join(tmpdir, "test.wasm")

            res_macho = compiler.build_target(mir, "macos-arm64", macho_path)
            res_wasm = compiler.build_target(mir, "wasi", wasm_path)

            self.assertTrue(os.path.exists(macho_path))
            self.assertGreater(res_macho["size_bytes"], 500)
            self.assertTrue(res_macho["zero_external_dependencies"])

            self.assertTrue(os.path.exists(wasm_path))
            self.assertGreater(res_wasm["size_bytes"], 100)
            self.assertTrue(res_wasm["zero_external_dependencies"])

    def test_04_c11_and_unikernel_cross_emission(self):
        """Test zero-dependency cross-compilation to ANSI C11 source and Bare-Metal Unikernel."""
        mir = compile_source_to_mir(self.sample_src)
        compiler = CrossCompiler()

        with tempfile.TemporaryDirectory() as tmpdir:
            c_path = os.path.join(tmpdir, "test.c")
            raw_path = os.path.join(tmpdir, "test.raw")

            res_c = compiler.build_target(mir, "c11", c_path)
            res_raw = compiler.build_target(mir, "unikernel", raw_path, source_code=self.sample_src)

            self.assertTrue(os.path.exists(c_path))
            self.assertGreater(res_c["size_bytes"], 200)

            self.assertTrue(os.path.exists(raw_path))
            self.assertGreater(res_raw["size_bytes"], 500000)

    def test_05_matrix_source_build_and_benchmark(self):
        """Test full multi-target matrix compilation and throughput benchmark."""
        compiler = CrossCompiler()

        with tempfile.TemporaryDirectory() as tmpdir:
            src_file = os.path.join(tmpdir, "app.bmb")
            with open(src_file, "w", encoding="utf-8") as f:
                f.write(self.sample_src)

            results = compiler.build_source_file(src_file, base_out_dir=tmpdir)
            self.assertEqual(len(results), 6)

            for res in results:
                self.assertTrue(os.path.exists(res["output_path"]))
                self.assertGreater(res["size_bytes"], 0)
                self.assertTrue(res["zero_external_dependencies"])

        bench = benchmark_xbuild_matrix(iterations=5)
        self.assertGreater(bench["total_targets_built"], 0)
        self.assertGreater(bench["builds_per_second"], 10.0)

    def test_06_pure_bmb_xbuild_compilation(self):
        """Test compiling and running pure .bmb xbuild.bmb standard library."""
        stdlib_path = os.path.join(os.path.dirname(__file__), "..", "mamba", "stdlib", "xbuild.bmb")
        self.assertTrue(os.path.exists(stdlib_path))

        with open(stdlib_path, "r", encoding="utf-8") as f:
            bmb_src = f.read()

        mir = compile_source_to_mir(bmb_src)
        self.assertGreater(len(mir.functions), 0)

        jit_mod = NativeJITModule(mir)
        self.assertTrue(hasattr(jit_mod, "xbuild_compute_header_size"))
        self.assertEqual(jit_mod.xbuild_compute_header_size(1), 512)
        self.assertEqual(jit_mod.xbuild_compute_header_size(2), 120)

        # Matrix simulation across 10 iterations: (512 + 120 + 4096 + 8) * 10 = 47360
        self.assertEqual(jit_mod.xbuild_simulate_matrix(10), 47360)


if __name__ == "__main__":
    unittest.main()
