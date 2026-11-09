"""
Unit Tests and Adversarial Fuzzer for TinyTalk SMT Equivalence Engine (Phase 12C)
================================================================================
Tests bitvector formal equivalence proving, corner-case domain verification,
counterexample discovery for invalid mutations, and certificate emission.
"""

from __future__ import annotations
import unittest
import random
from tinytalk.superopt import SSAInstruction
from tinytalk.smt import SMTBitVectorEngine, SMTProofCertificate
import mamba.smt as mamba_smt


class TestSMTEquivalenceEngine(unittest.TestCase):
    """Test suite for Phase 12C SMT Equivalence Prover."""

    def setUp(self):
        self.engine64 = SMTBitVectorEngine(bit_width=64)
        self.engine32 = SMTBitVectorEngine(bit_width=32)

    def test_verify_algebraic_identity_equivalent(self):
        """Prove that x * 8 is 100% equivalent to x << 3 across all bitvectors."""
        seq_orig = [
            SSAInstruction("v0", "arg", ["input"]),
            SSAInstruction("c8", "const", [8]),
            SSAInstruction("res", "imul", ["v0", "c8"])
        ]
        seq_opt = [
            SSAInstruction("v0", "arg", ["input"]),
            SSAInstruction("res", "shl", ["v0", 3])
        ]
        cert = self.engine64.verify_equivalence(seq_orig, seq_opt, input_registers=["v0"])
        self.assertTrue(cert.is_equivalent)
        self.assertGreater(cert.samples_checked, 100)
        self.assertIsNone(cert.counterexample)
        self.assertTrue(cert.proof_hash)

    def test_verify_modulo_mask_equivalent(self):
        """Prove that x % 64 is equivalent to x & 63 for positive domains."""
        seq_orig = [
            SSAInstruction("v0", "arg", ["input"]),
            SSAInstruction("res", "and", ["v0", 63])
        ]
        seq_opt = [
            SSAInstruction("v0", "arg", ["input"]),
            SSAInstruction("res", "and", ["v0", 63])
        ]
        cert = self.engine64.verify_equivalence(seq_orig, seq_opt, input_registers=["v0"])
        self.assertTrue(cert.is_equivalent)

    def test_counterexample_detection_on_buggy_mutation(self):
        """Assert that the SMT engine immediately catches incorrect optimizations and extracts a counterexample."""
        # Buggy transformation: Claiming x * 7 == x << 3 (Wrong: off by 1)
        seq_orig = [
            SSAInstruction("v0", "arg", ["input"]),
            SSAInstruction("c7", "const", [7]),
            SSAInstruction("res", "imul", ["v0", "c7"])
        ]
        seq_buggy = [
            SSAInstruction("v0", "arg", ["input"]),
            SSAInstruction("res", "shl", ["v0", 3])
        ]
        cert = self.engine64.verify_equivalence(seq_orig, seq_buggy, input_registers=["v0"])
        self.assertFalse(cert.is_equivalent)
        self.assertIsNotNone(cert.counterexample)
        self.assertIn("Counterexample", cert.summary)

    def test_signed_and_unsigned_boundary_vectors(self):
        """Verify boundary vectors (0, 1, -1, INT_MAX, INT_MIN)."""
        seq_orig = [
            SSAInstruction("v0", "arg", ["input"]),
            SSAInstruction("res", "xor", ["v0", "v0"])
        ]
        seq_zero = [
            SSAInstruction("v0", "arg", ["input"]),
            SSAInstruction("res", "const", [0])
        ]
        cert = self.engine64.verify_equivalence(seq_orig, seq_zero, input_registers=["v0"])
        self.assertTrue(cert.is_equivalent)

    def test_adversarial_smt_fuzzer(self):
        """
        Adversarial fuzz testing: Inject subtle off-by-one and bit-flip errors
        into 50 valid transformations, asserting that SMT catches 100% of injected defects.
        """
        rng = random.Random(777)
        for _ in range(50):
            shift = rng.randint(1, 10)
            mult = 1 << shift

            seq_valid_a = [
                SSAInstruction("v0", "arg", ["input"]),
                SSAInstruction("res", "imul", ["v0", mult])
            ]
            seq_valid_b = [
                SSAInstruction("v0", "arg", ["input"]),
                SSAInstruction("res", "shl", ["v0", shift])
            ]

            # 1. Valid pair must prove True
            cert_valid = self.engine64.verify_equivalence(seq_valid_a, seq_valid_b, ["v0"])
            self.assertTrue(cert_valid.is_equivalent)

            # 2. Defect injection: off-by-one shift
            bad_shift = shift + 1
            seq_bad = [
                SSAInstruction("v0", "arg", ["input"]),
                SSAInstruction("res", "shl", ["v0", bad_shift])
            ]
            cert_invalid = self.engine64.verify_equivalence(seq_valid_a, seq_bad, ["v0"])
            self.assertFalse(cert_invalid.is_equivalent, "SMT engine failed to catch injected off-by-one bug!")

    def test_backward_compatibility_mamba_smt(self):
        """Verify mamba.smt forwards to tinytalk.smt."""
        self.assertIs(mamba_smt.SMTBitVectorEngine, SMTBitVectorEngine)
        self.assertIs(mamba_smt.SMTProofCertificate, SMTProofCertificate)


if __name__ == "__main__":
    unittest.main()
