"""Unit and integration tests for Phase 9G: Cryptographic Software Supply Chain & Deterministic Provenance (v3.4.8).
"""

import os
import json
import tempfile
import unittest

from tinytalk import (
    ArtifactSigner,
    SLSAProvenanceBuilder,
    benchmark_provenance_signing,
)
from tinytalk.provenance import compute_file_sha256
from tinytalk.cli import compile_source_to_mir
from tinytalk.backends.x86_64_jit import NativeJITModule


class TestPhase9GProvenance(unittest.TestCase):
    def setUp(self):
        self.signer = ArtifactSigner(key="test-signing-key-9g")
        self.builder = SLSAProvenanceBuilder(compiler_version="3.4.8")

    def test_01_artifact_signer_hashing_and_signing(self):
        """Test SHA-256 digest calculation, detached signature creation, and verification."""
        with tempfile.TemporaryDirectory() as tmpdir:
            artifact_file = os.path.join(tmpdir, "app.exe")
            with open(artifact_file, "wb") as f:
                f.write(b"MAMBA_BINARY_PAYLOAD_TEST_DATA")

            sig_file = os.path.join(tmpdir, "app.exe.sig")
            sig_info = self.signer.sign_file(artifact_file, sig_file)

            self.assertTrue(os.path.exists(sig_file))
            self.assertEqual(sig_info["artifact"], "app.exe")
            self.assertEqual(sig_info["algorithm"], "HMAC-SHA256")
            self.assertEqual(len(sig_info["sha256"]), 64)
            self.assertEqual(len(sig_info["signature"]), 64)

            # Verification
            res = self.signer.verify_file(artifact_file, sig_file)
            self.assertTrue(res["verified"])
            self.assertIsNone(res["error"])

    def test_02_signature_tamper_detection(self):
        """Test that modifying payload or signature causes verification failure."""
        with tempfile.TemporaryDirectory() as tmpdir:
            artifact_file = os.path.join(tmpdir, "package.tar")
            with open(artifact_file, "wb") as f:
                f.write(b"ORIGINAL_IMMUTABLE_PACKAGE_BYTES")

            sig_file = os.path.join(tmpdir, "package.tar.sig")
            self.signer.sign_file(artifact_file, sig_file)

            # 1. Tamper with artifact
            with open(artifact_file, "wb") as f:
                f.write(b"TAMPERED_MALICIOUS_BYTES")

            res_tampered = self.signer.verify_file(artifact_file, sig_file)
            self.assertFalse(res_tampered["verified"])
            self.assertIn("Checksum mismatch", res_tampered["error"])

            # 2. Restore artifact but tamper with signature
            with open(artifact_file, "wb") as f:
                f.write(b"ORIGINAL_IMMUTABLE_PACKAGE_BYTES")

            with open(sig_file, "r", encoding="utf-8") as f:
                sig_data = json.load(f)
            sig_data["signature"] = "0" * 64
            with open(sig_file, "w", encoding="utf-8") as f:
                json.dump(sig_data, f)

            res_tampered_sig = self.signer.verify_file(artifact_file, sig_file)
            self.assertFalse(res_tampered_sig["verified"])
            self.assertIn("verification failed", res_tampered_sig["error"])

    def test_03_slsa_level_3_attestation_schema(self):
        """Test generating in-toto SLSA Level 3 provenance statements."""
        with tempfile.TemporaryDirectory() as tmpdir:
            src_file = os.path.join(tmpdir, "app.tnt")
            bin_file = os.path.join(tmpdir, "app.exe")
            prov_file = os.path.join(tmpdir, "app.exe.provenance.json")

            with open(src_file, "w", encoding="utf-8") as f:
                f.write("def main() -> i64:\n    return 42\n")

            with open(bin_file, "wb") as f:
                f.write(b"MZ_PE32_MAMBA_BINARY")

            stmt = self.builder.generate_attestation(
                bin_file, src_file, target_platform="windows-x64", reproducible=True
            )

            self.assertEqual(stmt["_type"], "https://in-toto.io/Statement/v1")
            self.assertEqual(stmt["predicateType"], "https://slsa.dev/provenance/v1")
            self.assertEqual(stmt["subject"][0]["name"], "app.exe")
            self.assertEqual(len(stmt["subject"][0]["digest"]["sha256"]), 64)
            self.assertEqual(stmt["predicate"]["buildDefinition"]["internalParameters"]["slsaLevel"], 3)
            self.assertTrue(stmt["predicate"]["buildDefinition"]["internalParameters"]["reproducible"])

            self.builder.save_attestation(stmt, prov_file)
            self.assertTrue(os.path.exists(prov_file))

    def test_04_provenance_signing_benchmark(self):
        """Test in-memory signing and verification throughput benchmark."""
        bench = benchmark_provenance_signing(iterations=1000)
        self.assertGreater(bench["total_cryptographic_ops"], 1000)
        self.assertGreater(bench["ops_per_second"], 10000.0)
        self.assertEqual(bench["slsa_level"], 3)
        self.assertTrue(bench["reproducible_certified"])

    def test_05_pure_bmb_provenance_compilation(self):
        """Test compiling pure .tnt provenance.tnt standard library to MIR and JIT execution."""
        stdlib_path = os.path.join(os.path.dirname(__file__), "..", "tinytalk", "stdlib", "provenance.tnt")
        self.assertTrue(os.path.exists(stdlib_path))

        with open(stdlib_path, "r", encoding="utf-8") as f:
            bmb_src = f.read()

        mir = compile_source_to_mir(bmb_src, filename="provenance.tnt")
        self.assertGreaterEqual(len(mir.functions), 5)

        jit_mod = NativeJITModule(mir)
        self.assertTrue(hasattr(jit_mod, "provenance_benchmark_verifications"))
        valid_runs = jit_mod.provenance_benchmark_verifications(1000)
        self.assertEqual(valid_runs, 1000)


if __name__ == "__main__":
    unittest.main()
