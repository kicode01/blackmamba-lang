"""
Test Suite and Adversarial Safety Fuzzer for TinyTalk Phase 13E: Neuromorphic Verifier.
"""

import unittest
import random
from tinytalk.neuro_verify import NeuromorphicVerifier

class TestNeuroVerify(unittest.TestCase):
    def test_verifier_normal_circuit(self):
        verifier = NeuromorphicVerifier(energy_per_spike_pj=1.5, max_firing_rate=0.4)
        # 10 steps, 3 neurons, sparse firing
        raster = [
            [1, 0, 0],
            [0, 0, 0],
            [0, 1, 0],
            [0, 0, 0],
            [0, 0, 1],
            [0, 0, 0],
            [1, 0, 0],
            [0, 0, 0],
            [0, 1, 0],
            [0, 0, 0],
        ]
        res = verifier.verify_spike_raster(raster, energy_budget_pj=50.0)
        self.assertTrue(res["valid"])
        self.assertEqual(res["total_spikes"], 5)
        self.assertAlmostEqual(res["total_energy_pj"], 7.5)

    def test_verifier_detects_violations(self):
        verifier = NeuromorphicVerifier(energy_per_spike_pj=2.0, max_firing_rate=0.3)
        # Runaway excitation: neuron 0 fires every step
        raster = [[1, 0] for _ in range(10)]
        res = verifier.verify_spike_raster(raster, energy_budget_pj=10.0)
        self.assertFalse(res["valid"])
        self.assertTrue(any("budget exceeded" in v for v in res["violations"]))
        self.assertTrue(any("max firing rate" in v for v in res["violations"]))

    def test_adversarial_verifier_fuzzer_100_runs(self):
        """Fuzz verifier invariant detection across 100 randomized rasters."""
        rng = random.Random(404)
        verifier = NeuromorphicVerifier(energy_per_spike_pj=1.0, max_firing_rate=0.5)

        for trial in range(100):
            timesteps = rng.randint(5, 20)
            neurons = rng.randint(2, 8)
            density = rng.uniform(0.0, 1.0)

            raster = [
                [1 if rng.random() < density else 0 for _ in range(neurons)]
                for _ in range(timesteps)
            ]
            budget = rng.uniform(0.0, timesteps * neurons * 2.0)

            res = verifier.verify_spike_raster(raster, energy_budget_pj=budget)

            # Invariant: Total energy must equal total_spikes * pj_per_spike
            self.assertAlmostEqual(res["total_energy_pj"], res["total_spikes"] * 1.0)

            # Invariant: If total energy exceeds budget, it cannot be valid
            if res["total_energy_pj"] > budget:
                self.assertFalse(res["valid"])

if __name__ == "__main__":
    unittest.main()
