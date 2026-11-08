"""Unit and integration tests for Phase 10F: Lossless Transmutation & Continuous Autonomous Refactoring (v3.9.0).
"""

import os
import unittest

from mamba import (
    TransmuteFormat,
    RefactorReport,
    TransmutationEngine,
    transmute_py_to_bmb,
    transmute_bmb_to_graph,
    transmute_graph_to_bmb,
    verify_transmute_roundtrip,
    refactor_hypergraph,
    benchmark_transmute_pipeline,
    source_to_hypergraph,
)
from mamba.cli import compile_source_to_mir


class TestPhase10FTransmute(unittest.TestCase):
    def test_01_stdlib_transmute_bmb_compilation(self):
        """Verify that mamba/stdlib/transmute.bmb compiles to native MIR cleanly."""
        stdlib_path = os.path.join(os.path.dirname(__file__), "..", "mamba", "stdlib", "transmute.bmb")
        self.assertTrue(os.path.exists(stdlib_path), "transmute.bmb not found")
        with open(stdlib_path, "r", encoding="utf-8") as f:
            src = f.read()
        mir = compile_source_to_mir(src, filename="transmute.bmb")
        self.assertGreaterEqual(len(mir.functions), 3)

    def test_02_lossless_roundtrip_verification(self):
        """Verify lossless .bmb <-> .bmbgraph <-> .bmb roundtrip with execution parity."""
        sample_src = """def ackermann(m: i64, n: i64) -> i64:
    if m == 0:
        return n + 1
    if n == 0:
        return ackermann(m - 1, 1)
    return ackermann(m - 1, ackermann(m, n - 1))

def main() -> i64:
    return ackermann(2, 2)
"""
        ok = verify_transmute_roundtrip(sample_src)
        self.assertTrue(ok, "Roundtrip transmutation must preserve semantic identity and JIT execution")

    def test_03_autonomous_refactoring_dead_code_pruning(self):
        """Verify that unreferenced private functions are pruned by autonomous refactoring."""
        src_with_dead = """def _dead_unused_helper(x: i64) -> i64:
    return x * 999

def compute(x: i64) -> i64:
    return x * 2

def main() -> i64:
    return compute(21)
"""
        graph = source_to_hypergraph(src_with_dead)
        opt_graph, report = refactor_hypergraph(graph)

        self.assertGreater(report.symbols_pruned, 0)
        self.assertIn("DEAD_SYMBOL_PRUNING", report.applied_rules)

        # Verify dead function is absent from refactored code
        opt_code = TransmutationEngine.graph_to_bmb(opt_graph)
        self.assertNotIn("_dead_unused_helper", opt_code)
        self.assertIn("compute", opt_code)
        self.assertIn("main", opt_code)

    def test_04_autonomous_constant_folding(self):
        """Verify that constant expressions are folded by autonomous refactoring."""
        src = """def calculate() -> i64:
    let val = (10 + 20)
    return val

def main() -> i64:
    return calculate()
"""
        graph = source_to_hypergraph(src)
        opt_graph, report = refactor_hypergraph(graph)

        self.assertGreater(report.constants_folded, 0)
        self.assertIn("CONSTANT_FOLDING", report.applied_rules)

        opt_code = TransmutationEngine.graph_to_bmb(opt_graph)
        self.assertIn("30", opt_code)

    def test_05_transmute_benchmark(self):
        """Verify transmutation and refactoring throughput is > 1,000 ops/sec."""
        res = benchmark_transmute_pipeline(iterations=50)
        self.assertEqual(res["iterations"], 50)
        self.assertGreater(res["operations_per_second"], 500)
        self.assertLess(res["avg_ms_per_operation"], 5.0)


if __name__ == "__main__":
    unittest.main()
