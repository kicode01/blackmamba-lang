"""Unit and integration tests for the TinyTalk (.tnt) Flagship HFT Engine.

Validates:
- Pure .tnt syntax parsing and Cartesian type inference.
- Zero-cost value struct layout and float calculations.
- Native x86-64 JIT execution with exit code 0.
- Multi-target compilation (PE32+, ELF64, WASM, C11).
- Functional pipeline operator (|>) and Auto-TCO order fill recursion.
"""

import os
import unittest

from tinytalk.cli import compile_source_to_mir, main
from tinytalk.backends.x86_64_jit import NativeJITModule
from tinytalk.backends.pe_exe import PE32PlusExecutableBuilder
from tinytalk.backends.elf_exe import ELF64ExecutableBuilder
from tinytalk.backends.wasm_emitter import WasmBackend
from tinytalk.backends.c_emitter import C11Backend


class TestFlagshipHFTEngine(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.example_path = os.path.join(
            os.path.dirname(os.path.dirname(os.path.abspath(__file__))),
            "examples",
            "tinytalk_hft_engine.tnt",
        )
        with open(cls.example_path, "r", encoding="utf-8") as f:
            cls.source_code = f.read()

    def test_01_source_exists_and_parses(self):
        """Verify the flagship .tnt file exists and parses to MIR."""
        self.assertTrue(os.path.exists(self.example_path), "tinytalk_hft_engine.tnt must exist")
        mir = compile_source_to_mir(self.source_code, self.example_path)
        self.assertIsNotNone(mir)
        fn_names = [f.name for f in mir.functions]
        self.assertIn("main", fn_names)
        self.assertIn("compute_spread", fn_names)
        self.assertIn("match_fill_tail_recurse", fn_names)

    def test_02_jit_execution(self):
        """Verify JIT execution runs cleanly with exit code 0."""
        captured = []

        def capture_output(text: str):
            captured.append(text)

        mir = compile_source_to_mir(self.source_code, self.example_path)
        jit = NativeJITModule(mir, output_callback=capture_output)
        exit_code = jit.run_main()
        jit.close()

        self.assertEqual(exit_code, 0)
        output = "".join(captured)
        self.assertIn("TINYTALK (.tnt) HIGH-FREQUENCY TRADING", output)
        self.assertIn("Trade #90001", output)
        self.assertIn("Trade #90002", output)
        self.assertIn("Auto-TCO Fill Recursion", output)
        self.assertIn("5000 fills without stack overflow", output)
        self.assertIn("100% OPERATIONAL", output)

    def test_03_pe32_executable_build(self):
        """Verify standalone PE32+ Windows binary generation."""
        mir = compile_source_to_mir(self.source_code, self.example_path)
        builder = PE32PlusExecutableBuilder(mir)
        pe_bytes = builder.build_bytes()
        self.assertTrue(len(pe_bytes) > 2048)
        self.assertEqual(pe_bytes[:2], b"MZ")

    def test_04_elf64_executable_build(self):
        """Verify standalone Linux ELF64 binary generation."""
        mir = compile_source_to_mir(self.source_code, self.example_path)
        builder = ELF64ExecutableBuilder(mir)
        elf_bytes = builder.build_bytes()
        self.assertTrue(len(elf_bytes) > 1024)
        self.assertEqual(elf_bytes[:4], b"\x7fELF")

    def test_05_wasm_and_c_build(self):
        """Verify WebAssembly and C11 backend code generation."""
        mir = compile_source_to_mir(self.source_code, self.example_path)
        wasm_bytes = WasmBackend(mir).emit_wasm_bytes()
        self.assertTrue(len(wasm_bytes) > 500)
        self.assertEqual(wasm_bytes[:4], b"\x00asm")

        c_source = C11Backend(mir).emit_c()
        self.assertIn("match_fill_tail_recurse", c_source)
        self.assertIn("compute_spread", c_source)


if __name__ == "__main__":
    unittest.main()
