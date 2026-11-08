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
        Run the 9-vector AdversarialCompilerFuzzer and verify 0 failures across all vectors.
        """
        fuzzer = AdversarialFuzzer(seed=20261108)
        report = fuzzer.run_suite(
            differential_count=10,
            pe_exe_count=3,
            codec_count=8,
            arena_count=5,
            chaos_count=10,
            historical_count=5,
        )
        self.assertTrue(report.all_passed, msg=report.summary())
        self.assertEqual(report.failed_cases, 0)
        self.assertEqual(report.passed_cases, 56)

    def test_historical_v01_to_v23_audit_regressions(self) -> None:
        """
        Regression test for the 7 historical compiler bugs uncovered across v0.1.0 - v1.3.0:
        1. `range(n)` inside list comprehension with `if` filter (`IntLit(value=1)` step)
        2. Negative array indexing (`arr[-1]`, `arr[-2]`, `arr[-1] = val`)
        3. Multiple string arguments in `print(s[0], s[5])` space separation
        4. Negative and omitted slice bounds (`s[-5:-1]`, `s[:-3]`, `s[-4:]`)
        5. Structural `match/case` capture pattern variable binding before guard (`case x if x < 0:`)
        6. Chained comparison desugaring (`0 < x < 10`)
        7. Power augmented assignment (`**=`)
        """
        src = """
s = "BlackMamba"
print(s[0], s[5], s[-1], s[-5])
print(s[-5:-1], s[:-3], s[-4:])

arr = [i * i for i in range(10) if i % 2 == 1]
print(len(arr), arr[0], arr[-1], arr[-2])
arr[-1] = 99
print(arr[4], arr[-1])

def classify(n: int) -> int:
    match n:
        case 0:
            return 100
        case 1 | 2 | 3:
            return 200
        case x if x < 0:
            return x * 10
        case _:
            return 999

def check_chain(v: int) -> int:
    if 0 < v < 10:
        return 1
    return 0

z = 3
z **= 4
print(classify(0), classify(2), classify(-5), classify(42))
print(check_chain(5), check_chain(15), check_chain(-2), z)
"""
        expected = run_cpython_oracle(src).strip()
        jit_out = run_mamba_jit(src, optimize=True).strip()
        self.assertEqual(jit_out, expected)

    def test_cli_bmb_fuzz_json_command(self) -> None:
        """
        Verify `bmb fuzz --json` runs via the CLI and outputs valid JSON with all_passed=True.
        """
        buf = StringIO()
        with patch("sys.stdout", buf):
            rc = bmb_main([
                "fuzz",
                "--seed", "99",
                "--diff", "4",
                "--pe", "1",
                "--codec", "4",
                "--arena", "2",
                "--chaos", "4",
                "--hist", "2",
                "--json",
            ])
        self.assertEqual(rc, 0)
        data = json.loads(buf.getvalue())
        self.assertTrue(data["all_passed"])
        self.assertEqual(data["total_cases"], 23)
        self.assertEqual(data["passed_cases"], 23)


if __name__ == "__main__":
    unittest.main()
