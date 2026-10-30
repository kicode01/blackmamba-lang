"""
Unit and Integration Tests for Black Mamba Phase 5 & v2.0 Production Milestone:
"The Global Cloud & Enterprise Dominance — v2.0"

Verifies:
1. Zero-Base Container & OCI Image Builder (ContainerBuilder, ELF64, manifest.json, layer.tar)
2. Native Edge AI & Local LLM (create_demo_gguf, GGUFModel, LocalLLM streaming token generation)
3. Centralized Package Publishing & Registry (cmd_pkg_publish, index.json, integrity verification)
4. Top-level CLI integration (container, chat, add, publish)
"""

import os
import sys
import json
import tarfile
import tempfile
import unittest
from mamba.container import ContainerBuilder
from mamba.llm import create_demo_gguf, GGUFModel, LocalLLM
from mamba.pkg.manifest import PackageManifest
from mamba.pkg.cli import cmd_pkg_init, cmd_pkg_publish
from mamba.cli import main as cli_main
import argparse


class TestPhase5EnterpriseV2(unittest.TestCase):

    def test_container_builder_elf_and_tarball(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            src_file = os.path.join(tmpdir, "service.bmb")
            with open(src_file, "w", encoding="utf-8") as f:
                f.write("""
def main() -> i64:
    print("Zero-base container running on Linux!")
    return 0
""")
            builder = ContainerBuilder(src_file, image_tag="mamba-test:v2")
            
            # 1. Compile static ELF
            elf_bytes = builder.compile_static_elf()
            self.assertTrue(elf_bytes.startswith(b"\x7fELF"))
            self.assertGreater(len(elf_bytes), 1024)

            # 2. Export bundle directory
            bundle_dir = os.path.join(tmpdir, "bundle")
            builder.export_bundle_dir(bundle_dir)
            self.assertTrue(os.path.exists(os.path.join(bundle_dir, "Dockerfile")))
            self.assertTrue(os.path.exists(os.path.join(bundle_dir, "app")))

            with open(os.path.join(bundle_dir, "Dockerfile"), "r", encoding="utf-8") as f:
                dockerfile = f.read()
            self.assertIn("FROM scratch", dockerfile)
            self.assertIn('ENTRYPOINT ["/app"]', dockerfile)

            # 3. Export OCI tarball
            tar_path = os.path.join(tmpdir, "image.tar")
            out_tar, size = builder.export_oci_tarball(tar_path)
            self.assertTrue(os.path.exists(out_tar))
            self.assertGreater(size, 2048)

            # Inspect tar contents
            with tarfile.open(out_tar, "r") as tf:
                names = tf.getnames()
                self.assertIn("manifest.json", names)
                manifest_data = json.loads(tf.extractfile("manifest.json").read().decode("utf-8"))
                self.assertEqual(manifest_data[0]["RepoTags"], ["mamba-test:v2"])
                layer_name = manifest_data[0]["Layers"][0]
                self.assertIn(layer_name, names)

                # Inspect layer tarball to ensure /app is present
                layer_f = tf.extractfile(layer_name)
                with tarfile.open(fileobj=layer_f, mode="r") as l_tf:
                    layer_files = l_tf.getnames()
                    self.assertIn("app", layer_files)

    def test_local_llm_gguf_and_streaming(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            gguf_path = os.path.join(tmpdir, "tiny_test.gguf")
            custom_vocab = ["<unk>", "<s>", "</s>", "Black", "Mamba", "AI", "Engine", "Native"]
            create_demo_gguf(gguf_path, vocab=custom_vocab)
            self.assertTrue(os.path.exists(gguf_path))

            # 1. Test GGUFModel loader
            model = GGUFModel(gguf_path)
            self.assertEqual(model.version, 3)
            self.assertEqual(model.tensor_count, 1)
            self.assertIn("general.architecture", model.metadata)
            self.assertEqual(model.metadata["general.architecture"], "llama")
            self.assertIn("token_embd.weight", model.tensors)
            self.assertEqual(model.tokens, custom_vocab)

            # 2. Test LocalLLM streaming token generation
            llm = LocalLLM(gguf_path)
            self.assertEqual(llm.vocab_size, len(custom_vocab))
            stream_tokens = list(llm.generate_stream("AI Query", max_tokens=6))
            self.assertGreater(len(stream_tokens), 0)
            text_out = "".join(stream_tokens)
            self.assertIsInstance(text_out, str)

    def test_pkg_publish_and_registry_index(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            proj_dir = os.path.join(tmpdir, "mypkg")
            reg_dir = os.path.join(tmpdir, "registry")
            os.makedirs(proj_dir, exist_ok=True)
            os.makedirs(reg_dir, exist_ok=True)

            # Initialize package
            old_cwd = os.getcwd()
            try:
                os.chdir(proj_dir)
                init_args = argparse.Namespace(directory=proj_dir, name="mypkg", lib=True, bin=False)
                cmd_pkg_init(init_args)
                self.assertTrue(os.path.exists(os.path.join(proj_dir, "mamba.toml")))

                # Publish package to local registry
                pub_args = argparse.Namespace(registry=reg_dir)
                res = cmd_pkg_publish(pub_args)
                self.assertEqual(res, 0)

                # Verify registry contents
                index_path = os.path.join(reg_dir, "index.json")
                self.assertTrue(os.path.exists(index_path))
                with open(index_path, "r", encoding="utf-8") as f:
                    index_data = json.load(f)

                self.assertIn("mypkg", index_data["packages"])
                pkg_info = index_data["packages"]["mypkg"]["0.1.0"]
                self.assertEqual(pkg_info["version"], "0.1.0")
                self.assertTrue(pkg_info["integrity"].startswith("sha256-"))
                archive_name = pkg_info["archive"]
                self.assertTrue(os.path.exists(os.path.join(reg_dir, archive_name)))
            finally:
                os.chdir(old_cwd)

    def test_cli_container_command(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            src_file = os.path.join(tmpdir, "app.bmb")
            with open(src_file, "w", encoding="utf-8") as f:
                f.write("def main() -> i64:\n    return 42\n")

            tar_out = os.path.join(tmpdir, "app_container.tar")
            ret = cli_main(["container", src_file, "-o", tar_out, "-t", "app:v2"])
            self.assertEqual(ret, 0)
            self.assertTrue(os.path.exists(tar_out))


if __name__ == "__main__":
    unittest.main()
