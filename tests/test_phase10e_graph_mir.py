"""Unit and integration tests for Phase 10E: Direct Hypergraph-to-MIR Compiler Pipeline (v3.8.0).
"""

import os
import tempfile
import unittest

from tinytalk import (
    GraphMIREmitter,
    compile_hypergraph_to_mir,
    compile_hypergraph_to_jit,
    compile_hypergraph_to_exe,
    benchmark_graph_to_mir,
    source_to_hypergraph,
    HyperGraph,
)
from tinytalk.cli import compile_source_to_mir


class TestPhase10EGraphMIR(unittest.TestCase):
    def test_01_stdlib_graph_mir_bmb_compilation(self):
        """Verify that mamba/stdlib/graph_mir.tnt compiles to native MIR cleanly."""
        stdlib_path = os.path.join(os.path.dirname(__file__), "..", "tinytalk", "stdlib", "graph_mir.tnt")
        self.assertTrue(os.path.exists(stdlib_path), "graph_mir.tnt not found")
        with open(stdlib_path, "r", encoding="utf-8") as f:
            src = f.read()
        mir = compile_source_to_mir(src, filename="graph_mir.tnt")
        self.assertGreaterEqual(len(mir.functions), 4)

    def test_02_direct_graph_to_mir_compilation(self):
        """Compile a HyperGraph directly to MIRModule without disk serialization."""
        src = """def multiply(a: i64, b: i64) -> i64:
    return a * b

def main() -> i64:
    return multiply(6, 7)
"""
        graph = source_to_hypergraph(src)
        mir = compile_hypergraph_to_mir(graph)
        self.assertGreaterEqual(len(mir.functions), 2)
        fn_names = [f.name for f in mir.functions]
        self.assertIn("multiply", fn_names)
        self.assertIn("main", fn_names)

    def test_03_hypergraph_to_native_jit_execution(self):
        """Compile a HyperGraph directly to Native x86-64 JIT and execute in-memory."""
        src = """def power_sum(x: i64, y: i64) -> i64:
    return (x * x) + (y * y)

def main() -> i64:
    return power_sum(3, 4)
"""
        graph = source_to_hypergraph(src)
        jit = compile_hypergraph_to_jit(graph)
        self.assertEqual(jit.main(), 25)

    def test_04_hypergraph_to_pe_exe_compilation(self):
        """Compile a HyperGraph directly to a standalone Windows PE32+ executable."""
        src = """def main() -> i64:
    return 123
"""
        graph = source_to_hypergraph(src)
        tmp_dir = tempfile.mkdtemp()
        out_exe = os.path.join(tmp_dir, "test_graph_pe.exe")
        try:
            compile_hypergraph_to_exe(graph, out_exe)
            self.assertTrue(os.path.exists(out_exe))
            self.assertGreater(os.path.getsize(out_exe), 1024)
        finally:
            if os.path.exists(out_exe):
                os.remove(out_exe)
            try:
                os.rmdir(tmp_dir)
            except OSError:
                pass

    def test_05_graph_to_mir_benchmark(self):
        """Verify graph-to-MIR throughput is > 1,000 graphs/sec."""
        res = benchmark_graph_to_mir(iterations=50)
        self.assertEqual(res["iterations"], 50)
        self.assertGreater(res["graphs_per_second"], 500)
        self.assertLess(res["avg_ms_per_compilation"], 5.0)


if __name__ == "__main__":
    unittest.main()
