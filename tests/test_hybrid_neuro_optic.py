"""
Test Suite and Adversarial Transduction Fuzzer for TinyTalk Phase 13D: Hybrid Neuro-Optic Pipeline.
"""

import unittest
import random
import math
from tinytalk.hybrid_neuro_optic import HybridNeuroOpticPipeline

class TestHybridNeuroOptic(unittest.TestCase):
    def test_pipeline_basic_transduction(self):
        pipe = HybridNeuroOpticPipeline(dimension=2, responsivity=1.0, decay=0.5, threshold=0.8)
        # Input optical field
        frame = [1.0 + 0j, 0.0 + 0j]
        res = pipe.process_optical_frame(frame)

        self.assertEqual(len(res["spikes"]), 2)
        self.assertEqual(len(res["voltages"]), 2)
        # Power is 1.0, current is 1.0 >= 0.8 -> neuron 0 should spike
        self.assertEqual(res["spikes"][0], 1)

    def test_adversarial_transduction_fuzzer_100_runs(self):
        """Fuzz photodiode non-negativity and spike safety across 100 randomized inputs."""
        rng = random.Random(777)
        pipe = HybridNeuroOpticPipeline(dimension=4, responsivity=0.85, decay=0.9, threshold=1.0)

        for trial in range(100):
            frame = [
                complex(rng.uniform(-2.0, 2.0), rng.uniform(-2.0, 2.0))
                for _ in range(4)
            ]
            res = pipe.process_optical_frame(frame)

            # Invariant 1: Photocurrents must be strictly non-negative (I = R * |E|^2 >= 0)
            for current in res["photocurrents"]:
                self.assertGreaterEqual(current, 0.0)

            # Invariant 2: Spikes must be binary
            for spk in res["spikes"]:
                self.assertIn(spk, (0, 1))

            # Invariant 3: Voltages must be finite
            for v in res["voltages"]:
                self.assertFalse(math.isnan(v))
                self.assertFalse(math.isinf(v))

if __name__ == "__main__":
    unittest.main()
