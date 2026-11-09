"""
Test Suite and Adversarial Symplectic Energy Fuzzer for TinyTalk Phase 16B: Hamiltonian Dynamics.
"""

import unittest
import random
import math
from tinytalk.hamiltonian import HamiltonianSystem

class TestHamiltonian(unittest.TestCase):
    def test_harmonic_oscillator_energy_boundedness(self):
        sys = HamiltonianSystem(mass=1.0)
        q0, p0 = 1.0, 0.0
        e0 = sys.total_energy(q0, p0) # 0.5 * 1.0^2 = 0.5

        traj = sys.simulate_trajectory(q0, p0, dt=0.01, steps=200)
        # Check energy throughout trajectory
        for _, q, p in traj:
            e = sys.total_energy(q, p)
            # Symplectic Verlet guarantees energy oscillates closely around e0 without drift
            self.assertAlmostEqual(e, e0, places=2)

    def test_adversarial_symplectic_fuzzer_100_runs(self):
        """Fuzz Hamiltonian energy conservation across 100 randomized masses, step sizes, and initial conditions."""
        rng = random.Random(1788) # Lagrange year
        for trial in range(100):
            m = rng.uniform(0.1, 5.0)
            sys = HamiltonianSystem(mass=m)

            q0 = rng.uniform(-2.0, 2.0)
            p0 = rng.uniform(-2.0, 2.0)
            dt = rng.uniform(0.001, 0.02)
            e0 = sys.total_energy(q0, p0)

            # Advance 50 symplectic steps
            q, p = q0, p0
            for _ in range(50):
                q, p = sys.step_verlet(q, p, dt)

            e_final = sys.total_energy(q, p)

            # Invariant: Energy error must remain bounded by O(dt^2)
            delta_e = abs(e_final - e0)
            max_tolerated_error = (dt ** 2) * 50.0 * (abs(e0) + 1.0)
            self.assertLess(
                delta_e,
                max_tolerated_error,
                f"Trial {trial}: Energy drift exceeded! delta_E={delta_e}, bound={max_tolerated_error}"
            )

if __name__ == "__main__":
    unittest.main()
