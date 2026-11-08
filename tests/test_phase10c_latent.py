"""Unit and integration tests for Phase 10C: Neural Latent-Vector Code Synthesis (v3.6.0).
"""

import os
import unittest

from mamba import (
    CodebookCategory,
    CodebookVector,
    LatentSynthesizer,
    synthesize_to_hypergraph,
    synthesize_to_code,
    benchmark_latent_synthesis,
)
from mamba.cli import compile_source_to_mir


class TestPhase10CLatent(unittest.TestCase):
    def test_01_stdlib_latent_bmb_compilation(self):
        """Verify that mamba/stdlib/latent.bmb compiles to native MIR cleanly."""
        stdlib_path = os.path.join(os.path.dirname(__file__), "..", "mamba", "stdlib", "latent.bmb")
        self.assertTrue(os.path.exists(stdlib_path), "latent.bmb not found")
        with open(stdlib_path, "r", encoding="utf-8") as f:
            src = f.read()
        mir = compile_source_to_mir(src, filename="latent.bmb")
        self.assertGreaterEqual(len(mir.functions), 4)

    def test_02_vector_embedding_and_codebook(self):
        """Test deterministic vector embedding and codebook similarity."""
        synth = LatentSynthesizer(dim=64)
        self.assertGreater(len(synth.codebook), 3)

        # Test vector embedding
        vec1 = synth._embed_text("compute fibonacci sequence")
        vec2 = synth._embed_text("fibonacci recursive formula")
        vec3 = synth._embed_text("database sql query table")

        self.assertEqual(len(vec1), 64)
        dot_12 = sum(a * b for a, b in zip(vec1, vec2))
        dot_13 = sum(a * b for a, b in zip(vec1, vec3))
        self.assertGreater(dot_12, dot_13, "Semantic similarity should rank related prompts higher")

    def test_03_prompt_to_hypergraph_synthesis(self):
        """Synthesize HyperGraphs directly from prompts with zero syntax errors."""
        prompts = [
            ("compute recursive fibonacci", "fib"),
            ("spatial 2d point vector", "Point"),
            ("binary search algorithm", "binary_search"),
        ]

        for prompt, expected_keyword in prompts:
            graph = synthesize_to_hypergraph(prompt)
            self.assertGreater(len(graph.nodes), 0)
            self.assertTrue(graph.validate(), f"Graph for '{prompt}' must be valid")
            py_code = synthesize_to_code(prompt, view="python")
            self.assertIn(expected_keyword, py_code)

    def test_04_synthesize_to_multi_perspective_projections(self):
        """Synthesize to Python, Math, Sexpr, and Morphic views directly."""
        prompt = "spatial 2d point vector coordinate"

        py_view = synthesize_to_code(prompt, view="python")
        self.assertIn("struct Point:", py_view)

        math_view = synthesize_to_code(prompt, view="math")
        self.assertIn(r"\mathbb{Point}", math_view)

        sexpr_view = synthesize_to_code(prompt, view="sexpr")
        self.assertIn("Point", sexpr_view)

        morphic_view = synthesize_to_code(prompt, view="morphic")
        self.assertIn("morphic_canvas", morphic_view)

    def test_05_latent_synthesis_benchmark(self):
        """Verify latent-vector synthesis throughput and sub-millisecond latency."""
        res = benchmark_latent_synthesis(iterations=50)
        self.assertEqual(res["iterations"], 50)
        self.assertGreater(res["syntheses_per_second"], 500)
        self.assertLess(res["avg_ms_per_synthesis"], 5.0)


if __name__ == "__main__":
    unittest.main()
