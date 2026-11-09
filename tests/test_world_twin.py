"""
Test Suite and Adversarial Ground Plane Fuzzer for TinyTalk Phase 16C: World Twin.
"""

import unittest
import random
import math
from tinytalk.world_twin import WorldTwinEnvironment

class TestWorldTwin(unittest.TestCase):
    def test_spring_cloth_relaxation(self):
        env = WorldTwinEnvironment(gravity=0.0) # Zero gravity
        # Fixed particle at origin, stretched particle at x=2.0 (rest_len=1.0)
        p1 = env.add_particle(0.0, 0.0, 0.0, is_fixed=True)
        p2 = env.add_particle(1.0, 0.0, 0.0, is_fixed=False)
        env.add_spring(p1, p2, stiffness=50.0, damping=1.0)
        # Manually stretch p2 to 2.0 after spring creation (rest_len = 1.0)
        p2.pos[0] = 2.0

        # Step forward
        env.step(0.01)
        # Force on p2 should be negative (pulled back toward p1)
        self.assertLess(p2.vel[0], 0.0)

    def test_adversarial_ground_plane_fuzzer_100_runs(self):
        """Fuzz particle ground plane penetration invariant: z >= 0.0 across 100 random drops."""
        rng = random.Random(9999)
        for trial in range(100):
            env = WorldTwinEnvironment(gravity=-9.81)
            init_z = rng.uniform(1.0, 20.0)
            p = env.add_particle(0.0, 0.0, init_z, mass=rng.uniform(0.5, 5.0))

            # Simulate fall for 50 steps
            for _ in range(50):
                env.step(0.02)
                # Invariant: Particle position z must never penetrate below ground (z >= 0.0)
                self.assertGreaterEqual(
                    p.pos[2],
                    0.0,
                    f"Trial {trial}: Ground penetration detected! z={p.pos[2]}"
                )

if __name__ == "__main__":
    unittest.main()
