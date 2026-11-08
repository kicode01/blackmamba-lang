"""
Unit & Regression Tests for v2.3.1 Hotfix:
- Python Floor Division (//) & Floor Modulo (%) Sign Semantics in x86-64 JIT & PE32+ .exe (`idiv_rcx`)
- Unary Constant Folding (`NEG_I64`, `NEG_F64`, `NOT_I64`, `ABS_I64`, `ABS_F64`) in `MIROptimizer`
- 5-Vector Adversarial Compiler Fuzzer (`AdversarialFuzzer` & `bmb fuzz`)
"""

import json
import unittest
from io import StringIO
from unittest.mock import patch

from mamba.cli import main as bmb_main
from mamba.fuzzer import AdversarialFuzzer, run_cpython_oracle, run_mamba_jit, run_mamba_pe_exe
from mamba.mir import MIRBuilder, MIROptimizer
from mamba.parser import Parser


class TestFloorDivAndFuzzerHotfix(unittest.TestCase):
    def test_floor_division_and_modulo_all_sign_quadrants_jit_and_pe(self) -> None:
        """
        Verify that x86-64 hardware `idiv_rcx` matches Python 3.14 floor division (`//`)
        and floor modulo (`%`) across all 4 sign quadrants for both runtime variables and constants.
        """
        src = """
fn test_quadrants(a: i64, b: i64) -> void:
    print(a // b, a % b)

fn main() -> i64:
    test_quadrants(17, 5)
    test_quadrants(-17, 5)
    test_quadrants(17, -5)
    test_quadrants(-17, -5)
    test_quadrants(-15, 5)
    test_quadrants(15, -5)
    print((-17) // 5, (-17) % 5)
    return 0
"""
        py_src = (
            src.replace("fn ", "def ")
            .replace(" -> void:", ":")
            .replace(" -> i64:", ":")
            .replace(": i64", "")
            + "\nmain()\n"
        )
        expected = run_cpython_oracle(py_src)
        jit_out = run_mamba_jit(src, optimize=True)
        jit_unopt_out = run_mamba_jit(src, optimize=False)
        pe_out = run_mamba_pe_exe(src)

        self.assertEqual(jit_out, expected)
        self.assertEqual(jit_unopt_out, expected)
        self.assertEqual(pe_out, expected)

    def test_unary_constant_folding_in_mir_optimizer(self) -> None:
        """
        Verify that MIROptimizer folds NEG_I64, NEG_F64, NOT_I64, and ABS_I64 at compile time
        so downstream binary constant folding folds expressions like `(-17) // 5` into `-4`.
        """
        src = """
fn compute() -> i64:
    x = (-17) // 5
    y = abs(-42) + 8
    z = ((-17) // 5) + (abs(-42) + 8)
    return x + y + z
"""
        mod = Parser.from_source(src).parse_module()
        mir = MIRBuilder().build(mod)
        MIROptimizer().optimize_module(mir)

        fn = [f for f in mir.functions if f.name == "compute"][0]
        const_vals = [ins.arg1 for ins in fn.instructions if ins.op == "CONST_I64"]
        # (-17) // 5 folds to -4, abs(-42) + 8 folds to 50, ((-17) // 5) + (abs(-42) + 8) folds to 46
        self.assertIn(-4, const_vals)
        self.assertIn(50, const_vals)
        self.assertIn(46, const_vals)

    def test_adversarial_fuzzer_suite_passes_100_percent(self) -> None:
        """
        Run the 5-vector AdversarialCompilerFuzzer and verify 0 failures across all vectors.
        """
        fuzzer = AdversarialFuzzer(seed=20261108)
        report = fuzzer.run_suite(
            differential_count=15,
            pe_exe_count=4,
            codec_count=12,
            arena_count=8,
            chaos_count=15,
        )
        self.assertTrue(report.all_passed, msg=report.summary())
        self.assertEqual(report.failed_cases, 0)
        self.assertEqual(report.passed_cases, 54)

    def test_cli_bmb_fuzz_json_command(self) -> None:
        """
        Verify `bmb fuzz --json` runs via the CLI and outputs valid JSON with all_passed=True.
        """
        buf = StringIO()
        with patch("sys.stdout", buf):
            rc = bmb_main([
                "fuzz",
                "--seed", "99",
                "--diff", "5",
                "--pe", "2",
                "--codec", "5",
                "--arena", "3",
                "--chaos", "5",
                "--json",
            ])
        self.assertEqual(rc, 0)
        data = json.loads(buf.getvalue())
        self.assertTrue(data["all_passed"])
        self.assertEqual(data["total_cases"], 20)
        self.assertEqual(data["passed_cases"], 20)


if __name__ == "__main__":
    unittest.main()
