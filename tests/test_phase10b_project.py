"""Unit and integration tests for Phase 10B: Multi-Perspective Projections & Virtual LSP (v3.5.5).
"""

import os
import unittest

from mamba import (
    ViewType,
    ProjectionEngine,
    VirtualDocumentProvider,
    benchmark_projections,
    source_to_hypergraph,
)
from mamba.cli import compile_source_to_mir
from mamba.backends.x86_64_jit import NativeJITModule


class TestPhase10BProject(unittest.TestCase):
    def setUp(self):
        self.sample_src = """
struct Complex:
    real: f64
    imag: f64

def add_complex(a: Complex, b: Complex) -> Complex:
    return Complex(a.real + b.real, a.imag + b.imag)

def main() -> i64:
    return 0
"""
        self.graph = source_to_hypergraph(self.sample_src)

    def test_01_projection_views(self):
        """Test rendering 4 distinct multi-perspective views from a single HyperGraph."""
        # 1. Pythonic View
        py_view = ProjectionEngine.project_python(self.graph)
        self.assertIn("struct Complex:", py_view)
        self.assertIn("def add_complex", py_view)

        # 2. 2D Morphic Canvas View
        mo_view = ProjectionEngine.project_morphic(self.graph)
        self.assertEqual(mo_view["view"], "morphic_canvas")
        self.assertGreater(mo_view["morph_count"], 0)
        self.assertGreater(len(mo_view["morphs"]), 0)

        # 3. Mathematical Notation View
        math_view = ProjectionEngine.project_math(self.graph)
        self.assertIn("\\mathbb{Complex}", math_view)
        self.assertIn("add_complex(a, b)", math_view)

        # 4. S-Expression AST View
        sexpr_view = ProjectionEngine.project_sexpr(self.graph)
        self.assertTrue(sexpr_view.startswith("(module"))
        self.assertIn(":add_complex", sexpr_view)

    def test_02_virtual_document_provider(self):
        """Test VirtualDocumentProvider for LSP live buffer synchronization."""
        provider = VirtualDocumentProvider()
        uri = "bmb-virtual://workspace/complex.bmb"

        doc = provider.get_document(uri, self.graph, ViewType.PYTHON)
        self.assertIn("struct Complex:", doc)
        self.assertEqual(provider.documents[uri], doc)

        math_uri = "bmb-virtual://workspace/complex.math.tex"
        math_doc = provider.get_document(math_uri, self.graph, ViewType.MATH)
        self.assertIn("\\begin{equation}", math_doc)

    def test_03_benchmark_projections(self):
        """Test throughput benchmark of the multi-perspective projection engine."""
        bench = benchmark_projections(iterations=200)
        self.assertEqual(bench["total_projections_rendered"], 800)
        self.assertGreater(bench["views_per_second"], 10000.0)
        self.assertEqual(len(bench["supported_views"]), 4)

    def test_04_pure_bmb_project_compilation(self):
        """Test pure .bmb project.bmb standard library compilation and JIT execution."""
        stdlib_path = os.path.join(os.path.dirname(__file__), "..", "mamba", "stdlib", "project.bmb")
        self.assertTrue(os.path.exists(stdlib_path))

        with open(stdlib_path, "r", encoding="utf-8") as f:
            bmb_src = f.read()

        mir = compile_source_to_mir(bmb_src, filename="project.bmb")
        self.assertGreaterEqual(len(mir.functions), 3)

        jit_mod = NativeJITModule(mir)
        self.assertTrue(hasattr(jit_mod, "project_benchmark_views"))
        rendered_bytes = jit_mod.project_benchmark_views(100)
        self.assertGreater(rendered_bytes, 0)


if __name__ == "__main__":
    unittest.main()
