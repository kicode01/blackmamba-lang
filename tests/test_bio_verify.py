"""
Test Suite and Adversarial Oligo Synthesis Fuzzer for TinyTalk Phase 14E: Bio Verifier.
"""

import unittest
import random
from tinytalk.bio_verify import BioThermodynamicVerifier

class TestBioVerify(unittest.TestCase):
    def test_ideal_oligo(self):
        verifier = BioThermodynamicVerifier()
        # 20 nt balanced sequence with no long runs
        seq = "ATGCGTACGTATGCTAGCTA"
        res = verifier.verify_oligonucleotide(seq)
        self.assertTrue(res["valid"])
        self.assertLess(res["delta_g_kcal_mol"], 0.0)
        self.assertEqual(len(res["violations"]), 0)

    def test_homopolymer_violation(self):
        verifier = BioThermodynamicVerifier()
        # Sequence with AAAAA
        seq = "ATGCGAAAAACTAGCTACGA"
        res = verifier.verify_oligonucleotide(seq)
        self.assertFalse(res["valid"])
        self.assertTrue(any("homopolymer" in v for v in res["violations"]))

    def test_adversarial_free_energy_fuzzer_100_runs(self):
        """Fuzz thermodynamic stability across 100 random oligonucleotides."""
        rng = random.Random(321)
        verifier = BioThermodynamicVerifier()
        bases = ['A', 'T', 'G', 'C']

        for trial in range(100):
            length = rng.randint(8, 40)
            seq = "".join(rng.choice(bases) for _ in range(length))
            res = verifier.verify_oligonucleotide(seq)

            # Invariant: For length >= 8, Delta G must be negative (thermodynamically spontaneous hybridization)
            self.assertLess(
                res["delta_g_kcal_mol"],
                0.0,
                f"Trial {trial}: Delta G was non-negative! {res['delta_g_kcal_mol']}"
            )

            # Invariant: If homopolymer >= 5 occurs, valid cannot be True
            has_poly = any(b * 5 in seq for b in bases)
            if has_poly:
                self.assertFalse(res["valid"])

if __name__ == "__main__":
    unittest.main()
