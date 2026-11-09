"""
TinyTalk Phase 13D: Hybrid Neuromorphic-Optical Electro-Photonic Pipeline
Bridges passive optical matrix multiplication (linear stage) with active SNN
spiking neuron dynamics (nonlinear activation) via photodiode transduction.
"""

from typing import List, Dict, Any, Tuple
import math
from tinytalk.optical import OpticalPhotonicMesh
from tinytalk.neuromorphic import LIFNeuron

class HybridNeuroOpticPipeline:
    """
    Coherent Electro-Photonic Neural Layer:
      Input (Optical Vector)
         -> Coherent Photonic MZI Mesh (Matrix multiplication at lightspeed)
         -> Photodiode Transduction (Optical power -> photocurrent: I = R * |E|^2)
         -> LIF Spiking Neurons (Event-driven asynchronous spiking activation)
    """
    def __init__(self, dimension: int, responsivity: float = 1.0, decay: float = 0.8, threshold: float = 0.5):
        self.dimension = dimension
        self.responsivity = responsivity
        self.photonic_mesh = OpticalPhotonicMesh(dimension)
        self.neurons = [
            LIFNeuron(decay=decay, v_threshold=threshold)
            for _ in range(dimension)
        ]

    def reset(self) -> None:
        for n in self.neurons:
            n.reset()

    def process_optical_frame(self, optical_inputs: List[complex]) -> Dict[str, Any]:
        """
        Execute one electro-photonic step:
        1. Photonic mesh propagation (ps latency)
        2. Photodiode power detection
        3. LIF neuron integration and spike output
        """
        optical_out = self.photonic_mesh.propagate_vector(optical_inputs)
        photocurrents = [self.responsivity * (abs(e)**2) for e in optical_out]

        spikes = []
        voltages = []
        for i, current in enumerate(photocurrents):
            spk, v = self.neurons[i].step(current)
            spikes.append(spk)
            voltages.append(v)

        return {
            "optical_out": optical_out,
            "photocurrents": photocurrents,
            "spikes": spikes,
            "voltages": voltages
        }
