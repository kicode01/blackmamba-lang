"""
Adversarial Fuzzer and Test Suite for TinyTalk Phase 13A: Neuromorphic Silicon & SNN.
"""

import unittest
import random
import math
from tinytalk.neuromorphic import LIFNeuron, SpikingNeuralLayer, SNNNetwork

class TestNeuromorphicLIF(unittest.TestCase):
    def test_lif_subthreshold_integration_and_decay(self):
        neuron = LIFNeuron(decay=0.5, v_threshold=1.0, v_reset=0.0)
        # Step 1: inject 0.4 -> v = 0.4
        spk, v = neuron.step(0.4)
        self.assertEqual(spk, 0)
        self.assertAlmostEqual(v, 0.4)

        # Step 2: inject 0.1 -> v = 0.4*0.5 + 0.1 = 0.3
        spk, v = neuron.step(0.1)
        self.assertEqual(spk, 0)
        self.assertAlmostEqual(v, 0.3)

    def test_lif_spike_generation_and_reset(self):
        neuron = LIFNeuron(decay=0.9, v_threshold=1.0, v_reset=0.0, refractory_steps=1)
        # Inject current exceeding threshold
        spk, v = neuron.step(1.5)
        self.assertEqual(spk, 1)
        self.assertEqual(v, 0.0)

        # Refractory step should suppress spikes even under massive current
        spk, v = neuron.step(10.0)
        self.assertEqual(spk, 0)
        self.assertEqual(v, 0.0)

        # Next step out of refractory window
        spk, v = neuron.step(1.2)
        self.assertEqual(spk, 1)

    def test_spiking_neural_layer(self):
        # 2 inputs -> 2 neurons
        layer = SpikingNeuralLayer(
            num_inputs=2,
            num_neurons=2,
            decay=0.5,
            v_threshold=1.0,
            weights=[[1.0, 0.0], [0.0, 1.0]]
        )
        # Inputs: [1.2, 0.2]
        spk, v = layer.forward_step([1.2, 0.2])
        self.assertEqual(spk, [1, 0])
        self.assertEqual(v[0], 0.0) # Reset after spike
        self.assertAlmostEqual(v[1], 0.2)

    def test_snn_network_simulation_and_raster(self):
        net = SNNNetwork(layer_sizes=[2, 3, 1], decay=0.8, v_threshold=0.5)
        # 10 timesteps of constant input
        inputs = [[1.0, 1.0] for _ in range(10)]
        res = net.simulate(inputs)

        self.assertEqual(res["timesteps"], 10)
        self.assertEqual(len(res["output_spikes"]), 10)
        self.assertEqual(len(res["output_counts"]), 1)
        self.assertTrue(0 <= res["firing_rates"][0] <= 1.0)

        raster = net.generate_raster_ascii(res)
        self.assertIn("Spike Raster", raster)
        self.assertIn("Neuron 00", raster)

    def test_adversarial_lif_fuzzer_100_runs(self):
        """Fuzz LIF neuron invariants over 100 randomized parameter configurations."""
        rng = random.Random(1337)
        for trial in range(100):
            decay = rng.uniform(0.01, 0.99)
            threshold = rng.uniform(0.1, 5.0)
            reset_v = rng.uniform(-1.0, 0.0)
            refractory = rng.randint(0, 5)

            neuron = LIFNeuron(
                decay=decay,
                v_threshold=threshold,
                v_reset=reset_v,
                refractory_steps=refractory
            )

            # Generate random current train with bursts
            timesteps = 50
            total_spikes = 0
            for t in range(timesteps):
                current = rng.uniform(-2.0, 10.0)
                spk, v = neuron.step(current)

                # Invariant 1: Spikes must be binary
                self.assertIn(spk, (0, 1), f"Trial {trial} step {t}: invalid spike {spk}")

                if spk == 1:
                    total_spikes += 1
                    # Invariant 2: After spike, membrane potential must be reset
                    self.assertEqual(v, reset_v)

                # Invariant 3: Membrane potential should never be NaN or Inf
                self.assertFalse(math.isnan(v))
                self.assertFalse(math.isinf(v))

            # Invariant 4: Total spikes cannot exceed timesteps
            self.assertLessEqual(total_spikes, timesteps)

if __name__ == "__main__":
    unittest.main()
