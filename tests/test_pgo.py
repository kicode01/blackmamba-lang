"""
Unit Tests and Adversarial Fuzzer for TinyTalk PGO & Kernel Cache (Phase 12E)
=============================================================================
Tests profile collection, hot path detection, persistent disk cache (.tntcache)
serialization, and warm-cache lookup performance.
"""

from __future__ import annotations
import unittest
import os
import tempfile
import random
from tinytalk.superopt import SSAInstruction
from tinytalk.pgo import ProfileGuidedOptimizer, ExecutionProfile, CachedKernel
import mamba.pgo as mamba_pgo


class TestProfileGuidedOptimizer(unittest.TestCase):
    """Test suite for Phase 12E Profile-Guided Optimization & Kernel Cache."""

    def setUp(self):
        self.temp_dir = tempfile.TemporaryDirectory()
        self.cache_file = os.path.join(self.temp_dir.name, "test.tntcache")
        self.pgo = ProfileGuidedOptimizer(cache_file_path=self.cache_file)

    def tearDown(self):
        self.temp_dir.cleanup()

    def test_record_invocations_and_hot_path_detection(self):
        """Verify invocation tracking and hot-path classification threshold."""
        # Initial cold function
        self.pgo.record_invocation("calc_hft", cycles=2.5)
        prof = self.pgo.get_profile("calc_hft")
        self.assertEqual(prof.invocation_count, 1)
        self.assertFalse(prof.is_hot)

        # Record 100 invocations -> becomes HOT
        for _ in range(99):
            self.pgo.record_invocation("calc_hft", cycles=2.5)
        self.assertTrue(self.pgo.get_profile("calc_hft").is_hot)

    def test_record_loop_iterations(self):
        """Verify loop trip counts trigger hot classification."""
        self.pgo.record_loop("matrix_multiply", iterations=1050)
        self.assertTrue(self.pgo.get_profile("matrix_multiply").is_hot)

    def test_cache_kernel_and_persistent_reload(self):
        """Verify saving a superoptimized kernel to disk and restoring it in a new PGO instance."""
        orig = [
            SSAInstruction("v0", "arg", ["x"]),
            SSAInstruction("res", "mul", ["v0", 16])
        ]
        opt = [
            SSAInstruction("v0", "arg", ["x"]),
            SSAInstruction("res", "shl", ["v0", 4])
        ]

        # Save to cache
        k_hash = self.pgo.cache_kernel(orig, opt, speedup=3.0, verified_by_smt=True)
        self.assertTrue(os.path.exists(self.cache_file))

        # Create a fresh PGO instance reading from the same file
        reloaded_pgo = ProfileGuidedOptimizer(cache_file_path=self.cache_file)
        cached = reloaded_pgo.lookup_kernel(orig)
        self.assertIsNotNone(cached)
        self.assertEqual(cached.ast_hash, k_hash)
        self.assertEqual(cached.optimized_ops, ["arg", "shl"])
        self.assertEqual(cached.cycle_speedup, 3.0)
        self.assertTrue(cached.verified_by_smt)

    def test_adversarial_pgo_fuzzer(self):
        """
        Adversarial fuzz testing: Generate 50 random kernel entries, cache them,
        and assert that lookups are 100% deterministic and collision-free.
        """
        rng = random.Random(555)
        hashes = set()

        for i in range(50):
            c_val = rng.randint(1, 1000)
            kernel = [
                SSAInstruction("v0", "arg", [i]),
                SSAInstruction("c", "const", [c_val]),
                SSAInstruction("res", "add", ["v0", "c"])
            ]
            opt = [
                SSAInstruction("v0", "arg", [i]),
                SSAInstruction("res", "add", ["v0", c_val])
            ]
            h = self.pgo.cache_kernel(kernel, opt, speedup=1.5)
            self.assertNotIn(h, hashes, "SHA-256 collision detected!")
            hashes.add(h)

            # Lookup must match exactly
            entry = self.pgo.lookup_kernel(kernel)
            self.assertIsNotNone(entry)
            self.assertEqual(entry.ast_hash, h)

    def test_backward_compatibility_mamba_pgo(self):
        """Verify mamba.pgo forwards to tinytalk.pgo."""
        self.assertIs(mamba_pgo.ProfileGuidedOptimizer, ProfileGuidedOptimizer)
        self.assertIs(mamba_pgo.ExecutionProfile, ExecutionProfile)
        self.assertIs(mamba_pgo.CachedKernel, CachedKernel)


if __name__ == "__main__":
    unittest.main()
