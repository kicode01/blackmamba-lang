"""
Test Suite and Adversarial Cooperative Binding Fuzzer for TinyTalk Phase 14C: Molecular Lattice.
"""

import unittest
import random
from tinytalk.molecular import WangTile, MolecularLattice

class TestMolecular(unittest.TestCase):
    def test_seed_and_binding(self):
        lattice = MolecularLattice(temperature=1)
        seed = WangTile("SEED", north="glueA", east="null", south="null", west="null")
        lattice.place_seed(0, 0, seed)

        # Candidate tile with South matching seed North ("glueA")
        candidate = WangTile("TILE_1", north="null", east="null", south="glueA", west="null")
        # Should be able to attach at (0, 1)
        self.assertTrue(lattice.can_attach(0, 1, candidate))
        # Cannot attach at (1, 0)
        self.assertFalse(lattice.can_attach(1, 0, candidate))

    def test_assembly_step(self):
        lattice = MolecularLattice(temperature=1)
        seed = WangTile("SEED", north="g1", east="g2", south="null", west="null")
        lattice.place_seed(0, 0, seed)

        tile_set = [
            WangTile("T_N", north="null", east="null", south="g1", west="null"),
            WangTile("T_E", north="null", east="null", south="null", west="g2")
        ]

        # First attachment
        attached1 = lattice.assemble_step(tile_set)
        self.assertIsNotNone(attached1)
        # Second attachment
        attached2 = lattice.assemble_step(tile_set)
        self.assertIsNotNone(attached2)
        self.assertEqual(len(lattice.grid), 3)

    def test_adversarial_tau_threshold_fuzzer_100_runs(self):
        """Fuzz aTAM temperature threshold invariant across 100 randomized tile bindings."""
        rng = random.Random(1234)
        for trial in range(100):
            tau = rng.randint(1, 4)
            lattice = MolecularLattice(temperature=tau)

            # Random seed
            gN = f"glue_{rng.randint(1, 5)}"
            seed = WangTile("SEED", north=gN, east="null", south="null", west="null")
            lattice.place_seed(0, 0, seed)

            # Random glue strength
            str_val = rng.randint(1, 3)
            lattice.set_glue_strength(gN, str_val)

            candidate = WangTile("CAND", north="null", east="null", south=gN, west="null")
            can_bind = lattice.can_attach(0, 1, candidate)

            # Invariant: can_attach == (str_val >= tau)
            self.assertEqual(
                can_bind,
                (str_val >= tau),
                f"Trial {trial}: tau threshold invariant failed! str={str_val}, tau={tau}"
            )

if __name__ == "__main__":
    unittest.main()
