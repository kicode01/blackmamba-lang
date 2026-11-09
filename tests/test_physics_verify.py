"""
Test Suite and Adversarial Momentum Conservation Fuzzer for TinyTalk Phase 16E: Physics Verifier.
"""

import unittest
import random
import math
from tinytalk.physics_verify import PhysicsConservationVerifier

class TestPhysicsVerify(unittest.TestCase):
    def test_linear_momentum_conservation_pass_and_fail(self):
        verifier = PhysicsConservationVerifier()
        # Initial 2-particle system: p1=(2, 0, 0), p2=(-2, 0, 0) -> Total = (0, 0, 0)
        p_init = [(2.0, 0.0, 0.0), (-2.0, 0.0, 0.0)]
        # Perfectly conserved elastic collision: p1'=(0, 2, 0), p2'=(0, -2, 0) -> Total = (0, 0, 0)
        p_fin_good = [(0.0, 2.0, 0.0), (0.0, -2.0, 0.0)]
        res_good = verifier.verify_linear_momentum_conservation(p_init, p_fin_good)
        self.assertTrue(res_good["valid"])

        # Non-conserved collision: p1'=(1, 0, 0), p2'=(0, 0, 0) -> Total = (1, 0, 0) != 0
        p_fin_bad = [(1.0, 0.0, 0.0), (0.0, 0.0, 0.0)]
        res_bad = verifier.verify_linear_momentum_conservation(p_init, p_fin_bad)
        self.assertFalse(res_bad["valid"])

    def test_energy_drift_verification(self):
        verifier = PhysicsConservationVerifier(energy_drift_tolerance=0.02) # 2% tolerance
        e0 = 100.0
        # Safe trajectory within 1%
        traj_safe = [100.0, 100.5, 99.8, 100.2]
        res_safe = verifier.verify_energy_conservation(e0, traj_safe)
        self.assertTrue(res_safe["valid"])

        # Leaking trajectory with 5% drift
        traj_leaking = [100.0, 102.0, 105.5]
        res_leak = verifier.verify_energy_conservation(e0, traj_leaking)
        self.assertFalse(res_leak["valid"])

    def test_adversarial_isolated_momentum_fuzzer_100_runs(self):
        """Fuzz closed multi-particle internal collisions: sum delta_p_ij == 0 invariant."""
        rng = random.Random(1687) # Newton's Principia publication year
        verifier = PhysicsConservationVerifier()

        for trial in range(100):
            n_particles = rng.randint(2, 6)
            init_momenta = [
                (rng.uniform(-10.0, 10.0), rng.uniform(-10.0, 10.0), rng.uniform(-10.0, 10.0))
                for _ in range(n_particles)
            ]

            # Simulate pairwise internal collision impulse (Newton's 3rd law: F_ij = -F_ji => delta_p_i = -delta_p_j)
            fin_momenta = [list(p) for p in init_momenta]
            for _ in range(10):
                i = rng.randint(0, n_particles - 1)
                j = rng.randint(0, n_particles - 1)
                if i != j:
                    impulse = (rng.uniform(-2.0, 2.0), rng.uniform(-2.0, 2.0), rng.uniform(-2.0, 2.0))
                    for k in range(3):
                        fin_momenta[i][k] += impulse[k]
                        fin_momenta[j][k] -= impulse[k]

            fin_tuples = [tuple(p) for p in fin_momenta]

            # Invariant: Conservation of Linear Momentum in Closed Isolated System
            res = verifier.verify_linear_momentum_conservation(init_momenta, fin_tuples)
            self.assertTrue(
                res["valid"],
                f"Trial {trial}: Linear momentum was not conserved! error={res['momentum_error']}"
            )

if __name__ == "__main__":
    unittest.main()
