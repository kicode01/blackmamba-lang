"""
Test Suite and Adversarial Base Pairing Fuzzer for TinyTalk Phase 14A: DNA Origami Synthesizer.
"""

import unittest
import random
from tinytalk.bio import DNAOrigamiSynthesizer

class TestDNAOrigami(unittest.TestCase):
    def test_reverse_complement_and_thermodynamics(self):
        seq = "ATGCGATC"
        rev_comp = DNAOrigamiSynthesizer.reverse_complement(seq)
        # 5'-ATGCGATC-3' -> reverse complement is 5'-GATCGCAT-3'
        self.assertEqual(rev_comp, "GATCGCAT")

        gc = DNAOrigamiSynthesizer.calculate_gc_content(seq)
        self.assertEqual(gc, 50.0)

        tm = DNAOrigamiSynthesizer.calculate_melting_temp(seq)
        self.assertGreater(tm, 20.0)

    def test_staple_synthesis_and_fasta(self):
        synth = DNAOrigamiSynthesizer()
        staples = synth.synthesize_staples(target_helix_count=3, staple_length=32)
        self.assertGreater(len(staples), 0)
        for s in staples:
            self.assertEqual(s["length"], 32)
            self.assertTrue(30.0 <= s["tm_celsius"] <= 90.0)

        fasta = synth.export_fasta(staples)
        self.assertIn(">STAPLE_", fasta)

    def test_adversarial_base_pairing_fuzzer_100_runs(self):
        """Fuzz Watson-Crick double reverse-complement identity across 100 random oligonucleotides."""
        rng = random.Random(999)
        bases = ['A', 'T', 'G', 'C']

        for trial in range(100):
            length = rng.randint(10, 100)
            seq = "".join(rng.choice(bases) for _ in range(length))

            # Invariant 1: Double reverse-complement must return original sequence exactly
            double_rev = DNAOrigamiSynthesizer.reverse_complement(
                DNAOrigamiSynthesizer.reverse_complement(seq)
            )
            self.assertEqual(seq, double_rev)

            # Invariant 2: GC content + AT content == 100%
            gc = DNAOrigamiSynthesizer.calculate_gc_content(seq)
            at = (seq.count('A') + seq.count('T')) / len(seq) * 100.0
            self.assertAlmostEqual(gc + at, 100.0)

            # Invariant 3: Tm must be finite and positive
            tm = DNAOrigamiSynthesizer.calculate_melting_temp(seq)
            self.assertGreater(tm, 0.0)

if __name__ == "__main__":
    unittest.main()
