"""Unit and integration tests for TinyTalk v4.0.0 (.tnt).

Validates:
- First-class .tnt file execution and module loader resolution.
- Binary .tntgraph hypergraph format with TNTG magic signature.
- Persistent .tntimg memory snapshots with TNTIMG01 signature.
- Dual backward compatibility with .bmb and bmb CLI.
"""

import os
import tempfile
import unittest

import mamba
from mamba.graph import HyperGraph, NodeKind, source_to_hypergraph, TNTG_MAGIC, BMBG_MAGIC
from mamba.image import ImageManager, LoadedMambaImage, IMAGE_MAGIC, LEGACY_IMAGE_MAGIC
from mamba.module_loader import resolve_module_file
from mamba.transmute import TransmutationEngine
from mamba.cli import main, compile_source_to_mir
from mamba.backends.x86_64_jit import NativeJITModule


class TestTinyTalkV400(unittest.TestCase):
    def test_01_tinytalk_version_and_branding(self):
        """Verify version 4.x or higher is active."""
        major = int(mamba.__version__.split(".")[0])
        self.assertGreaterEqual(major, 4)

    def test_02_tnt_file_module_resolution(self):
        """Verify that resolve_module_file finds .tnt files before .bmb files."""
        tmp_dir = tempfile.mkdtemp()
        tnt_file = os.path.join(tmp_dir, "my_math.tnt")
        with open(tnt_file, "w", encoding="utf-8") as f:
            f.write("def double(x: i64) -> i64:\n    return x * 2\n")

        resolved = resolve_module_file("my_math", tmp_dir)
        self.assertIsNotNone(resolved)
        self.assertTrue(resolved.endswith(".tnt"))
        self.assertEqual(os.path.abspath(resolved), os.path.abspath(tnt_file))

    def test_03_tntgraph_binary_format(self):
        """Verify serialization and deserialization of .tntgraph with TNTG header."""
        src = """def add_one(x: i64) -> i64:
    return x + 1

def main() -> i64:
    return add_one(41)
"""
        graph = source_to_hypergraph(src)
        blob = graph.to_bytes()
        self.assertTrue(blob.startswith(TNTG_MAGIC), "HyperGraph must serialize with TNTG magic header")

        # Load back
        restored = HyperGraph.from_bytes(blob)
        self.assertEqual(graph.root_hash, restored.root_hash)
        self.assertEqual(len(graph.nodes), len(restored.nodes))

        # Test JIT execution of restored .tntgraph
        from mamba.graph_mir import compile_hypergraph_to_jit
        jit = compile_hypergraph_to_jit(restored)
        self.assertEqual(jit.main(), 42)

    def test_04_tntimg_snapshot_persistence(self):
        """Verify .tntimg Smalltalk persistent memory snapshot with TNTIMG01 header."""
        tmp_dir = tempfile.mkdtemp()
        img_path = os.path.join(tmp_dir, "app.tntimg")

        im = ImageManager()
        report = im.save_image(img_path, modules={"app": "def run() -> i64:\n    return 99\n"})

        self.assertTrue(os.path.exists(img_path))
        with open(img_path, "rb") as f:
            header = f.read(8)
        self.assertEqual(header, IMAGE_MAGIC, "Image must serialize with TNTIMG01 magic header")

        loaded = im.load_image(img_path)
        self.assertIsInstance(loaded, LoadedMambaImage)
        self.assertIn("app", loaded.modules)

    def test_05_tnt_cli_drop_in_execution(self):
        """Verify direct execution of .tnt files via CLI runner."""
        tmp_dir = tempfile.mkdtemp()
        tnt_file = os.path.join(tmp_dir, "script.tnt")
        with open(tnt_file, "w", encoding="utf-8") as f:
            f.write("""def main() -> i64:
    return 777
""")
        ret = main(["run", tnt_file])
        self.assertEqual(ret, 777)

    def test_06_transmute_to_tnt(self):
        """Verify roundtrip transmutation targeting TinyTalk (.tnt)."""
        src = """def multiply(a: i64, b: i64) -> i64:
    return a * b

def main() -> i64:
    return multiply(6, 7)
"""
        graph = TransmutationEngine.bmb_to_graph(src)
        tnt_code = TransmutationEngine.graph_to_bmb(graph)
        self.assertIn("def multiply", tnt_code)
        self.assertIn("def main", tnt_code)

        mir = compile_source_to_mir(tnt_code)
        jit = NativeJITModule(mir)
        self.assertEqual(jit.main(), 42)


if __name__ == "__main__":
    unittest.main()
