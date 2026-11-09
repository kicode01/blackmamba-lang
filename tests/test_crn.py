"""
Test Suite and Adversarial Stoichiometry Conservation Fuzzer for TinyTalk Phase 14D: CRN Simulator.
"""

import unittest
import random
from tinytalk.crn import ChemicalReaction, CRNSimulator

class TestCRN(unittest.TestCase):
    def test_bimolecular_annihilation(self):
        # A + B -> C (k = 0.1)
        sim = CRNSimulator({"A": 10, "B": 10, "C": 0})
        rxn = ChemicalReaction(reactants={"A": 1, "B": 1}, products={"C": 1}, rate_k=0.1)
        sim.add_reaction(rxn)

        traj = sim.simulate(steps=10, seed=42)
        final_state = sim.state
        # C must have increased, A and B must have decreased by same amount
        self.assertGreater(final_state["C"], 0)
        self.assertEqual(final_state["A"], 10 - final_state["C"])
        self.assertEqual(final_state["B"], 10 - final_state["C"])

    def test_adversarial_mass_action_fuzzer_100_runs(self):
        """Fuzz CRN stoichiometry: in closed isomer system A <-> B, total (A + B) is invariant."""
        rng = random.Random(555)
        for trial in range(100):
            init_A = rng.randint(5, 50)
            init_B = rng.randint(5, 50)
            total_mass = init_A + init_B

            sim = CRNSimulator({"A": init_A, "B": init_B})
            # Forward: A -> B, Backward: B -> A
            k_fwd = rng.uniform(0.01, 1.0)
            k_rev = rng.uniform(0.01, 1.0)
            sim.add_reaction(ChemicalReaction({"A": 1}, {"B": 1}, rate_k=k_fwd, name="fwd"))
            sim.add_reaction(ChemicalReaction({"B": 1}, {"A": 1}, rate_k=k_rev, name="rev"))

            sim.simulate(steps=30, seed=trial)

            # Invariant: Closed Isomerization Conservation
            current_mass = sim.state["A"] + sim.state["B"]
            self.assertEqual(
                total_mass,
                current_mass,
                f"Trial {trial}: Stoichiometric mass violated! {total_mass} != {current_mass}"
            )

            # Invariant: Populations must never be negative
            self.assertGreaterEqual(sim.state["A"], 0)
            self.assertGreaterEqual(sim.state["B"], 0)

if __name__ == "__main__":
    unittest.main()
