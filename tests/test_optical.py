"""
Test Suite and Adversarial Unitary Energy Conservation Fuzzer for TinyTalk Phase 13C: Coherent Optical Photonic Mesh.
"""

import unittest
import random
import math
import cmath
from tinytalk.optical import MachZehnderInterferometer, OpticalPhotonicMesh

class TestOptical(unittest.TestCase):
    def test_single_mzi_propagation(self):
        mzi = MachZehnderInterferometer(theta=math.pi / 4, phi=0.0) # 50:50 beam splitter
        e1 = 1.0 + 0j
        e2 = 0.0 + 0j
        out1, out2 = mzi.propagate(e1, e2)

        # 50:50 power split
        p_in = abs(e1)**2 + abs(e2)**2
        p_out = abs(out1)**2 + abs(out2)**2
        self.assertAlmostEqual(p_in, p_out, places=6)

    def test_photonic_mesh_energy_estimation(self):
        mesh = OpticalPhotonicMesh(dimension=4)
        joules = mesh.estimate_energy_joules(1000)
        self.assertAlmostEqual(joules, 1.5e-14)

    def test_adversarial_optical_unitarity_fuzzer_100_runs(self):
        """Fuzz unitary energy conservation ||U * X|| == ||X|| across 100 random meshes."""
        rng = random.Random(101)
        dim = 4
        mesh = OpticalPhotonicMesh(dimension=dim)

        for trial in range(100):
            # Randomize all phase angles
            for layer in range(dim):
                start = 0 if (layer % 2 == 0) else 1
                for i in range(start, dim - 1, 2):
                    theta = rng.uniform(-math.pi, math.pi)
                    phi = rng.uniform(-math.pi, math.pi)
                    mesh.set_phase(layer, i, theta, phi)

            # Random complex input vector
            inp = [
                complex(rng.uniform(-1.0, 1.0), rng.uniform(-1.0, 1.0))
                for _ in range(dim)
            ]
            total_input_power = sum(abs(x)**2 for x in inp)

            # Optical propagation
            out = mesh.propagate_vector(inp)
            total_output_power = sum(abs(y)**2 for y in out)

            # Optical Power Conservation Invariant (Speed-of-light Unitary Physics)
            self.assertAlmostEqual(
                total_input_power,
                total_output_power,
                places=5,
                msg=f"Trial {trial}: Optical power violated! {total_input_power} != {total_output_power}"
            )

if __name__ == "__main__":
    unittest.main()
