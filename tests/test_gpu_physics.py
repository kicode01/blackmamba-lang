"""
Test Suite and Adversarial WGSL Syntax Fuzzer for TinyTalk Phase 16D: GPU Physics.
"""

import unittest
import random
from tinytalk.gpu_physics import GPUPhysicsShaderEmitter

class TestGPUPhysics(unittest.TestCase):
    def test_nbody_gravity_wgsl_structure(self):
        wgsl = GPUPhysicsShaderEmitter.emit_nbody_gravity_wgsl(num_particles=1024, workgroup_size=128)
        self.assertIn("@compute @workgroup_size(128)", wgsl)
        self.assertIn("struct Particle", wgsl)
        self.assertIn("if (idx >= 1024u)", wgsl)
        self.assertIn("inverseSqrt(dist_sq)", wgsl)

    def test_adversarial_wgsl_fuzzer_100_runs(self):
        """Fuzz particle counts and workgroup dimensions across 100 random configs."""
        rng = random.Random(4444)
        for trial in range(100):
            n_part = rng.randint(64, 65536)
            wg_size = rng.choice([32, 64, 128, 256])

            shader = GPUPhysicsShaderEmitter.emit_nbody_gravity_wgsl(n_part, wg_size)

            # Invariant 1: Proper workgroup declaration
            self.assertIn(f"@workgroup_size({wg_size})", shader)

            # Invariant 2: Proper particle bound check
            self.assertIn(f"if (idx >= {n_part}u)", shader)

            # Invariant 3: Balanced curly braces
            self.assertEqual(shader.count("{"), shader.count("}"))

if __name__ == "__main__":
    unittest.main()
