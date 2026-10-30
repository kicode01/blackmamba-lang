"""
Unit and Integration Tests for Black Mamba v2.1 (Pillar 0 & Part 1 Interactive Web Playground):

Verifies:
1. Pillar 0.1 & Part 1: In-Browser WebAssembly Compiler (`website/bmbc_wasm.js`) & Interactive Playground (`website/arena.html`)
2. Pillar 0.2: Interactive Jupyter Notebook Kernel (`mamba/kernel.py`, `kernel.bmb`, `bmb kernel`)
3. Pillar 0.3: Native GPU Compute Backend (`mamba/backends/gpu_shader.py`, `gpu.bmb`, `--target webgpu` & `--target spirv`)
4. Pillar 0.4: Zero-Cold-Start Serverless Cloud Engine (`mamba/deploy.py`, `cloud.bmb`, `bmb deploy --target all`)
"""

import json
import os
import struct
import subprocess
import tempfile
import unittest
import zipfile

from mamba.backends.gpu_shader import (
    SPIRV_GENERATOR_BMB,
    SPIRV_MAGIC,
    SPIRV_VERSION_1_5,
    SPIRVShaderBackend,
    WebGPUShaderBackend,
)
from mamba.cli import compile_source_to_mir, main as cli_main
from mamba.deploy import ServerlessDeployBuilder
from mamba.kernel import BlackMambaJupyterKernel


class TestPillar0AndPlaygroundV21(unittest.TestCase):

    def test_pillar0_2_jupyter_kernel_and_magics(self):
        kernel = BlackMambaJupyterKernel()
        info = kernel.kernel_info()
        self.assertEqual(info["status"], "ok")
        self.assertEqual(info["language_info"]["name"], "blackmamba")

        # 1. Stateful multi-cell evaluation
        r1 = kernel.execute_cell("x = 21\ny = 2")
        self.assertEqual(r1.status, "ok")
        self.assertEqual(r1.execution_count, 1)

        r2 = kernel.execute_cell("x * y")
        self.assertEqual(r2.status, "ok")
        self.assertEqual(r2.execution_count, 2)
        self.assertEqual(r2.result, 42)
        self.assertIn("42", r2.mime_bundle.get("text/plain", ""))
        self.assertIn("Out[2]:", r2.mime_bundle.get("text/html", ""))

        # 2. Cell magics: %time, %wgsl, %spirv, %mir, %reset
        r_time = kernel.execute_cell("%time\nprint(x + y)")
        self.assertEqual(r_time.status, "ok")
        self.assertIn("23", r_time.stdout)
        self.assertIn("[%time]", r_time.stdout)

        r_wgsl = kernel.execute_cell("%wgsl\ndef add_gpu(a: i64, b: i64) -> i64:\n    return a + b")
        self.assertEqual(r_wgsl.status, "ok")
        self.assertIn("@compute @workgroup_size", r_wgsl.mime_bundle.get("text/plain", ""))

        r_spirv = kernel.execute_cell("%spirv")
        self.assertEqual(r_spirv.status, "ok")
        self.assertIn("OpCapability Shader", r_spirv.mime_bundle.get("text/plain", ""))

        r_reset = kernel.execute_cell("%reset")
        self.assertEqual(r_reset.status, "ok")
        self.assertIn("Session state reset", r_reset.stdout)

        # 3. Kernelspec installation & .ipynb notebook execution
        with tempfile.TemporaryDirectory() as tmpdir:
            spec_path = BlackMambaJupyterKernel.install_kernelspec(tmpdir)
            self.assertTrue(os.path.exists(spec_path))
            with open(spec_path, "r", encoding="utf-8") as f:
                spec_data = json.load(f)
            self.assertEqual(spec_data["language"], "blackmamba")
            self.assertIn("kernel", spec_data["argv"])

            nb_path = os.path.join(tmpdir, "test_notebook.ipynb")
            sample_nb = {
                "cells": [
                    {"cell_type": "markdown", "metadata": {}, "source": ["# Black Mamba Notebook"]},
                    {"cell_type": "code", "metadata": {}, "source": ["a = 100\n", "b = 200\n", "print(a + b)"], "outputs": [], "execution_count": None},
                    {"cell_type": "code", "metadata": {}, "source": ["a * 3"], "outputs": [], "execution_count": None},
                ],
                "metadata": {},
                "nbformat": 4,
                "nbformat_minor": 5,
            }
            with open(nb_path, "w", encoding="utf-8") as nf:
                json.dump(sample_nb, nf)

            exec_info = kernel.execute_notebook_file(nb_path)
            self.assertEqual(exec_info["executed_cells"], 2)
            with open(nb_path, "r", encoding="utf-8") as nf:
                updated_nb = json.load(nf)
            self.assertEqual(updated_nb["cells"][1]["outputs"][0]["text"], ["300\n"])
            self.assertIn("300", updated_nb["cells"][2]["outputs"][0]["data"]["text/plain"])

    def test_pillar0_3_webgpu_and_spirv_backends(self):
        src = """
struct Particle:
    x: f64
    y: f64

def kernel_mad(a: i64, b: i64) -> i64:
    return a * b + 10

def main() -> i64:
    return kernel_mad(3, 4)
"""
        mir = compile_source_to_mir(src, "gpu_test.bmb")

        # 1. WebGPU WGSL Shader verification
        wgsl_backend = WebGPUShaderBackend(mir, workgroup_size=(64, 1, 1))
        wgsl_code = wgsl_backend.emit_wgsl()
        self.assertIn("@compute @workgroup_size(64, 1, 1)", wgsl_code)
        self.assertIn("fn bmb_compute_main(@builtin(global_invocation_id) global_id: vec3<u32>)", wgsl_code)
        self.assertIn("struct Particle {", wgsl_code)
        self.assertIn("fn kernel_mad(", wgsl_code)

        # 2. Vulkan SPIR-V 1.5 Binary & Assembly verification
        spirv_backend = SPIRVShaderBackend(mir, workgroup_size=(64, 1, 1))
        spv_bytes = spirv_backend.emit_spirv_bytes()
        self.assertEqual(len(spv_bytes) % 4, 0)
        magic, version, gen_id, bound, schema = struct.unpack("<5I", spv_bytes[:20])
        self.assertEqual(magic, SPIRV_MAGIC)
        self.assertEqual(version, SPIRV_VERSION_1_5)
        self.assertEqual(gen_id, SPIRV_GENERATOR_BMB)
        self.assertGreater(bound, 10)
        self.assertEqual(schema, 0)

        spvasm = spirv_backend.emit_spvasm()
        self.assertIn("OpCapability Shader", spvasm)
        self.assertIn('OpEntryPoint GLCompute %bmb_compute_main "bmb_compute_main"', spvasm)
        self.assertIn("OpIMul", spvasm)
        self.assertIn("OpIAdd", spvasm)

        # 3. CLI build --target webgpu and --target spirv
        with tempfile.TemporaryDirectory() as tmpdir:
            bmb_file = os.path.join(tmpdir, "shader.bmb")
            with open(bmb_file, "w", encoding="utf-8") as f:
                f.write(src)
            wgsl_out = os.path.join(tmpdir, "shader.wgsl")
            spv_out = os.path.join(tmpdir, "shader.spv")

            self.assertEqual(cli_main(["build", bmb_file, "--target", "webgpu", "-o", wgsl_out]), 0)
            self.assertTrue(os.path.exists(wgsl_out))

            self.assertEqual(cli_main(["build", bmb_file, "--target", "spirv", "-o", spv_out]), 0)
            self.assertTrue(os.path.exists(spv_out))
            self.assertTrue(os.path.exists(os.path.join(tmpdir, "shader.spvasm")))

    def test_pillar0_4_serverless_cloud_deploy(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            src_file = os.path.join(tmpdir, "edge_fn.bmb")
            with open(src_file, "w", encoding="utf-8") as f:
                f.write("""
from cloud import cloud_event_new, cloud_response_json

def main() -> i64:
    ev = cloud_event_new("req-1", "GET", "/ping", "")
    resp = cloud_response_json(200, "{\\"pong\\":true}")
    print(resp.status_code)
    return 0
""")
            out_dir = os.path.join(tmpdir, "deploy_out")
            ret = cli_main(["deploy", src_file, "--target", "all", "--name", "mamba-edge", "-o", out_dir])
            self.assertEqual(ret, 0)

            # 1. Verify AWS Lambda bundle
            lambda_zip = os.path.join(out_dir, "lambda", "mamba-edge_lambda.zip")
            self.assertTrue(os.path.exists(lambda_zip))
            with zipfile.ZipFile(lambda_zip, "r") as zf:
                info = zf.getinfo("bootstrap")
                self.assertEqual((info.external_attr >> 16) & 0o777, 0o755)
                elf_data = zf.read("bootstrap")
                self.assertTrue(elf_data.startswith(b"\x7fELF"))

            # 2. Verify Google Cloud Run bundle
            self.assertTrue(os.path.exists(os.path.join(out_dir, "cloudrun", "mamba-edge_oci.tar")))
            self.assertTrue(os.path.exists(os.path.join(out_dir, "cloudrun", "service.yaml")))

            # 3. Verify Fly.io bundle
            self.assertTrue(os.path.exists(os.path.join(out_dir, "fly", "fly.toml")))
            self.assertTrue(os.path.exists(os.path.join(out_dir, "fly", "Dockerfile")))

            # 4. Verify Cloudflare Workers WASM bundle
            wasm_mod = os.path.join(out_dir, "cloudflare", "module.wasm")
            self.assertTrue(os.path.exists(wasm_mod))
            with open(wasm_mod, "rb") as wf:
                self.assertTrue(wf.read(4) == b"\x00asm")
            self.assertTrue(os.path.exists(os.path.join(out_dir, "cloudflare", "worker.js")))
            self.assertTrue(os.path.exists(os.path.join(out_dir, "cloudflare", "wrangler.toml")))

    def test_pillar0_1_and_part1_in_browser_wasm_compiler_and_arena(self):
        arena_path = os.path.abspath("website/arena.html")
        wasm_js_path = os.path.abspath("website/bmbc_wasm.js")
        self.assertTrue(os.path.exists(arena_path))
        self.assertTrue(os.path.exists(wasm_js_path))

        with open(arena_path, "r", encoding="utf-8") as f:
            arena_html = f.read()

        # Verify all 10 presets & Part 1 interactive features are present in arena.html
        for preset_key in ("tco", "unboxed", "redos", "particles", "primes", "fastapi", "gguf", "webgpu", "jupyter", "serverless"):
            self.assertIn(f'value="{preset_key}"', arena_html)
        self.assertIn("runSpeedDuel()", arena_html)
        self.assertIn("downloadCompiledWasm()", arena_html)
        self.assertIn("downloadCompiledExe()", arena_html)
        self.assertIn("shareCurrentPlayground()", arena_html)
        self.assertIn('src="bmbc_wasm.js"', arena_html)


if __name__ == "__main__":
    unittest.main()
