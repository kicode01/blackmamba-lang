"""Unit and integration tests for Phase 10A: Zero-Syntax Content-Addressed Semantic Hypergraph (v3.5.0).
"""

import os
import tempfile
import unittest

from mamba import (
    NodeKind,
    HyperNode,
    HyperGraph,
    source_to_hypergraph,
    benchmark_hypergraph_engine,
)
from mamba.cli import compile_source_to_mir
from mamba.backends.x86_64_jit import NativeJITModule


class TestPhase10AGraph(unittest.TestCase):
    def setUp(self):
        self.sample_src = """
struct Vec2:
    x: f64
    y: f64

def magnitude_sq(v: Vec2) -> f64:
    return v.x * v.x + v.y * v.y

def main() -> i64:
    let pt = Vec2(3.0, 4.0)
    return 0
"""

    def test_01_hypergraph_node_creation_and_hashing(self):
        """Test structural node creation and bottom-up content-addressed hashing."""
        graph = HyperGraph()
        root_id = graph.add_node(NodeKind.MODULE, {"name": "math_mod"})
        fn_id = graph.add_node(NodeKind.FN, {"name": "add", "return_type": "i64"})
        stmt_id = graph.add_node(NodeKind.STMT, {"type": "Return", "raw": "return 42"})

        graph.nodes[fn_id].children.append(stmt_id)
        graph.nodes[root_id].children.append(fn_id)
        graph.root_id = root_id

        root_hash = graph.compute_hashes()
        self.assertEqual(len(root_hash), 64)
        self.assertEqual(len(graph.nodes[stmt_id].node_hash), 64)
        self.assertEqual(len(graph.nodes[fn_id].node_hash), 64)

        # Mutating a leaf must change the root hash deterministically
        graph.nodes[stmt_id].payload["raw"] = "return 100"
        new_root_hash = graph.compute_hashes()
        self.assertNotEqual(root_hash, new_root_hash)

    def test_02_binary_serialization_and_deserialization(self):
        """Test serializing HyperGraph to binary .bmbgraph format and deserializing."""
        graph = source_to_hypergraph(self.sample_src, module_name="test_pkg")
        data = graph.to_bytes()

        self.assertTrue(data.startswith(b"TNTG") or data.startswith(b"BMBG"))

        with tempfile.TemporaryDirectory() as tmpdir:
            file_path = os.path.join(tmpdir, "test.bmbgraph")
            graph.save(file_path)
            self.assertTrue(os.path.exists(file_path))

            restored = HyperGraph.load(file_path)
            self.assertEqual(len(restored.nodes), len(graph.nodes))
            self.assertEqual(restored.metadata.get("root_hash"), graph.metadata.get("root_hash"))

    def test_03_source_to_hypergraph_parsing(self):
        """Test compiling code directly into an AST HyperGraph without syntax ambiguities."""
        graph = source_to_hypergraph(self.sample_src)
        self.assertGreater(len(graph.nodes), 4)

        root = graph.nodes[graph.root_id]
        self.assertEqual(root.kind, NodeKind.MODULE)

        kinds = [graph.nodes[cid].kind for cid in root.children]
        self.assertIn(NodeKind.STRUCT, kinds)
        self.assertIn(NodeKind.FN, kinds)

    def test_04_benchmark_hypergraph_throughput(self):
        """Test hypergraph creation, hashing, and binary serialization benchmark."""
        bench = benchmark_hypergraph_engine(iterations=200)
        self.assertGreater(bench["total_nodes_processed"], 500)
        self.assertGreater(bench["graphs_per_second"], 500.0)
        self.assertTrue(bench["zero_syntax_verified"])

    def test_05_pure_bmb_graph_compilation(self):
        """Test pure .bmb graph.bmb standard library compilation and JIT execution."""
        stdlib_path = os.path.join(os.path.dirname(__file__), "..", "mamba", "stdlib", "graph.bmb")
        self.assertTrue(os.path.exists(stdlib_path))

        with open(stdlib_path, "r", encoding="utf-8") as f:
            bmb_src = f.read()

        mir = compile_source_to_mir(bmb_src, filename="graph.bmb")
        self.assertGreaterEqual(len(mir.functions), 5)

        jit_mod = NativeJITModule(mir)
        self.assertTrue(hasattr(jit_mod, "graph_benchmark_traversal"))
        valid_count = jit_mod.graph_benchmark_traversal(1000)
        self.assertEqual(valid_count, 1000)


if __name__ == "__main__":
    unittest.main()
