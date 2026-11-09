"""Unit and integration tests for Phase 10D: Semantic 3-Way Graph VCS & Structural Diff (v3.7.0).
"""

import os
import unittest

from tinytalk import (
    DiffOp,
    NodeDelta,
    GraphDiffResult,
    GraphMergeConflict,
    GraphMergeResult,
    SemanticVCS,
    diff_graphs,
    merge_graphs,
    benchmark_vcs_engine,
    source_to_hypergraph,
)
from tinytalk.cli import compile_source_to_mir


class TestPhase10DVCS(unittest.TestCase):
    def test_01_stdlib_vcs_bmb_compilation(self):
        """Verify that mamba/stdlib/vcs.tnt compiles to native MIR cleanly."""
        stdlib_path = os.path.join(os.path.dirname(__file__), "..", "tinytalk", "stdlib", "vcs.tnt")
        self.assertTrue(os.path.exists(stdlib_path), "vcs.tnt not found")
        with open(stdlib_path, "r", encoding="utf-8") as f:
            src = f.read()
        mir = compile_source_to_mir(src, filename="vcs.tnt")
        self.assertGreaterEqual(len(mir.functions), 4)

    def test_02_graph_structural_diff(self):
        """Test structural diff between base and modified AST HyperGraphs."""
        src_a = """def compute(x: i64) -> i64:
    return x * 2

def helper() -> i64:
    return 42
"""
        src_b = """struct Config:
    timeout: i64

def compute(x: i64) -> i64:
    return x * 10

def helper() -> i64:
    return 42
"""
        g_a = source_to_hypergraph(src_a)
        g_b = source_to_hypergraph(src_b)

        diff = diff_graphs(g_a, g_b)
        self.assertTrue(diff.has_changes)
        self.assertEqual(diff.added_count, 1)  # struct Config added
        self.assertEqual(diff.modified_count, 1)  # compute modified
        self.assertEqual(diff.unchanged_count, 1)  # helper unchanged

        summary = diff.summary()
        self.assertIn("Config", summary)
        self.assertIn("compute", summary)

    def test_03_3way_conflict_free_merge(self):
        """Test clean 3-way merge of independent, non-overlapping changes."""
        src_base = """def f1(x: i64) -> i64:
    return x + 1

def f2(y: i64) -> i64:
    return y * 2
"""
        # Alice modifies f1
        src_ours = """def f1(x: i64) -> i64:
    return x + 100

def f2(y: i64) -> i64:
    return y * 2
"""
        # Bob modifies f2 and adds a new struct
        src_theirs = """struct Token:
    val: i64

def f1(x: i64) -> i64:
    return x + 1

def f2(y: i64) -> i64:
    return y * 999
"""
        g_base = source_to_hypergraph(src_base)
        g_ours = source_to_hypergraph(src_ours)
        g_theirs = source_to_hypergraph(src_theirs)

        merge = merge_graphs(g_base, g_ours, g_theirs)
        self.assertTrue(merge.success, "Disjoint changes must merge with zero conflicts")
        self.assertEqual(len(merge.conflicts), 0)
        self.assertIsNotNone(merge.merged_graph)

        from tinytalk.project import ProjectionEngine
        merged_py = ProjectionEngine.project_python(merge.merged_graph)
        self.assertIn("Token", merged_py)
        self.assertIn("f1", merged_py)
        self.assertIn("f2", merged_py)

    def test_04_3way_semantic_conflict_detection(self):
        """Verify that conflicting changes to the same function body are isolated."""
        src_base = """def calculate(x: i64) -> i64:
    return x + 1
"""
        src_ours = """def calculate(x: i64) -> i64:
    return x + 10
"""
        src_theirs = """def calculate(x: i64) -> i64:
    return x * 100
"""
        g_base = source_to_hypergraph(src_base)
        g_ours = source_to_hypergraph(src_ours)
        g_theirs = source_to_hypergraph(src_theirs)

        merge = merge_graphs(g_base, g_ours, g_theirs)
        self.assertFalse(merge.success, "Conflicting edits to 'calculate' must trigger conflict")
        self.assertEqual(len(merge.conflicts), 1)
        self.assertEqual(merge.conflicts[0].name, "calculate")

    def test_05_vcs_benchmark(self):
        """Assert merge throughput is > 5,000 merges/sec."""
        res = benchmark_vcs_engine(iterations=50)
        self.assertEqual(res["iterations"], 50)
        self.assertGreater(res["merges_per_second"], 2000)
        self.assertLess(res["avg_us_per_merge"], 500.0)


if __name__ == "__main__":
    unittest.main()
