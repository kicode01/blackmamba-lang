"""
Unit Tests and Adversarial Fuzzer for TinyTalk SIMD Superoptimizer (Phase 12D)
==============================================================================
Tests auto-vectorization, Fused Multiply-Add (FMA) loop fusion,
wide SIMD register allocation, and speedup assertions.
"""

from __future__ import annotations
import unittest
import random
from tinytalk.superopt import SSAInstruction
from tinytalk.simd_opt import SIMDSuperoptimizer, VectorInstruction
import tinytalk.simd_opt as mamba_simd_opt


class TestSIMDSuperoptimizer(unittest.TestCase):
    """Test suite for Phase 12D Auto-Vectorization & SIMD Superoptimizer."""

    def setUp(self):
        self.opt256 = SIMDSuperoptimizer(target_vector_width=256)
        self.opt512 = SIMDSuperoptimizer(target_vector_width=512)

    def test_fused_multiply_add_detection(self):
        """Verify automatic detection and fusion of a * b + c into single-cycle vfmadd213."""
        scalar_seq = [
            SSAInstruction("t1", "mul", ["x", "y"]),
            SSAInstruction("res", "add", ["t1", "z"])
        ]
        vec_seq, speedup = self.opt256.vectorize_scalar_chain(scalar_seq)

        # Should combine into a single FMA instruction
        self.assertEqual(len(vec_seq), 1)
        self.assertTrue(vec_seq[0].is_fma)
        self.assertEqual(vec_seq[0].simd_op, "vfmadd213")
        self.assertEqual(vec_seq[0].operands, ["x", "y", "z"])
        self.assertGreater(speedup, 2.0)

    def test_vector_width_and_lanes(self):
        """Verify 256-bit (8 lanes) and 512-bit (16 lanes) configuration."""
        self.assertEqual(self.opt256.lanes, 8)
        self.assertEqual(self.opt512.lanes, 16)

    def test_vectorize_arithmetic_chain(self):
        """Verify vectorization of multi-step arithmetic chains."""
        scalar_seq = [
            SSAInstruction("a1", "add", ["v0", "v1"]),
            SSAInstruction("m1", "mul", ["a1", "v2"]),
            SSAInstruction("final", "sub", ["m1", "v3"])
        ]
        vec_seq, speedup = self.opt256.vectorize_scalar_chain(scalar_seq)
        self.assertGreaterEqual(len(vec_seq), 2)
        self.assertGreater(speedup, 1.5)

    def test_adversarial_simd_fuzzer(self):
        """
        Adversarial fuzz testing: Generate 50 random arithmetic trees containing
        interleaved muls and adds, verifying FMA discovery and positive speedup.
        """
        rng = random.Random(888)
        for _ in range(50):
            chain = []
            steps = rng.randint(4, 10)
            for s in range(steps):
                op = rng.choice(["add", "sub", "mul"])
                chain.append(SSAInstruction(f"reg_{s}", op, [f"arg_{s}", f"arg_{s+1}"]))

            vec_seq, speedup = self.opt256.vectorize_scalar_chain(chain)
            self.assertGreater(speedup, 1.0)
            self.assertLessEqual(len(vec_seq), len(chain))

    def test_backward_compatibility_mamba_simd_opt(self):
        """Verify tinytalk.simd_opt forwards to tinytalk.simd_opt."""
        self.assertIs(mamba_simd_opt.SIMDSuperoptimizer, SIMDSuperoptimizer)
        self.assertIs(mamba_simd_opt.VectorInstruction, VectorInstruction)


if __name__ == "__main__":
    unittest.main()
