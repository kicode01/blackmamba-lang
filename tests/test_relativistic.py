"""
Test Suite and Adversarial CRDT Lattice Convergence Fuzzer for TinyTalk Phase 15D: Relativistic CRDTs.
"""

import unittest
import random
from tinytalk.relativistic import RelativisticPNCounter, RelativisticLWWRegister

class TestRelativistic(unittest.TestCase):
    def test_pn_counter_basic_and_merge(self):
        c_earth = RelativisticPNCounter("Earth")
        c_mars = RelativisticPNCounter("Mars")

        c_earth.increment(10)
        c_earth.decrement(2) # Earth value: 8

        c_mars.increment(5)
        c_mars.decrement(1) # Mars value: 4

        # Two-way sync across interplanetary network
        c_earth.merge(c_mars)
        c_mars.merge(c_earth)

        self.assertEqual(c_earth.value(), 12)
        self.assertEqual(c_mars.value(), 12)

    def test_lww_register_convergence(self):
        r_earth = RelativisticLWWRegister("Earth", "v0")
        r_mars = RelativisticLWWRegister("Mars", "v0")

        r_earth.write("earth_update", timestamp=100.5)
        r_mars.write("mars_update", timestamp=105.2) # Higher timestamp

        r_earth.merge(r_mars)
        self.assertEqual(r_earth.value, "mars_update")

    def test_adversarial_crdt_commutativity_fuzzer_100_runs(self):
        """Fuzz CRN lattice join commutativity: A merge B == B merge A under 100 randomized operations."""
        rng = random.Random(9876)
        for trial in range(100):
            c1 = RelativisticPNCounter("Node_1")
            c2 = RelativisticPNCounter("Node_2")

            # Random sequence of increments and decrements
            for _ in range(15):
                c1.increment(rng.randint(1, 10))
                c1.decrement(rng.randint(1, 5))
                c2.increment(rng.randint(1, 10))
                c2.decrement(rng.randint(1, 5))

            # Merge clone 1: c1 <- c2
            clone1 = RelativisticPNCounter("Node_1")
            clone1.p_matrix = dict(c1.p_matrix)
            clone1.n_matrix = dict(c1.n_matrix)
            clone1.merge(c2)

            # Merge clone 2: c2 <- c1
            clone2 = RelativisticPNCounter("Node_2")
            clone2.p_matrix = dict(c2.p_matrix)
            clone2.n_matrix = dict(c2.n_matrix)
            clone2.merge(c1)

            # Invariant: Commutative Convergence
            self.assertEqual(
                clone1.value(),
                clone2.value(),
                f"Trial {trial}: CRDT commutativity failed! {clone1.value()} != {clone2.value()}"
            )

if __name__ == "__main__":
    unittest.main()
