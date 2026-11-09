"""
TinyTalk Phase 13C: Coherent Optical Matrix Multiplier & MZI Photonic Mesh
Simulates Mach-Zehnder Interferometer (MZI) programmable photonic meshes,
unitary matrix optical decomposition, and sub-femtojoule optical MAC computing.
"""

from typing import List, Dict, Any, Tuple, Optional
import math
import cmath
import random

class MachZehnderInterferometer:
    """
    2x2 Mach-Zehnder Interferometer (MZI) optical phase shifter.
    Transfer Matrix:
      [ e^(i*phi) * cos(theta),  -e^(i*phi) * sin(theta) ]
      [ sin(theta),              cos(theta)             ]
    """
    def __init__(self, theta: float = 0.0, phi: float = 0.0):
        self.theta = theta
        self.phi = phi

    def transfer_matrix(self) -> List[List[complex]]:
        cos_t = math.cos(self.theta)
        sin_t = math.sin(self.theta)
        phase = cmath.exp(1j * self.phi)
        return [
            [phase * cos_t, -phase * sin_t],
            [sin_t, cos_t]
        ]

    def propagate(self, e1: complex, e2: complex) -> Tuple[complex, complex]:
        """Propagate coherent optical electric field inputs (E1, E2) through MZI."""
        mat = self.transfer_matrix()
        out1 = mat[0][0] * e1 + mat[0][1] * e2
        out2 = mat[1][0] * e1 + mat[1][1] * e2
        return (out1, out2)


class OpticalPhotonicMesh:
    """
    N x N Triangular/Rectangular Coherent Optical Photonic Mesh (Clements/Reck architecture).
    Realizes arbitrary unitary linear transformations Y = U * X optically at speed-of-light.
    """
    def __init__(self, dimension: int):
        if dimension < 2:
            raise ValueError("Photonic mesh dimension must be >= 2")
        self.dim = dimension
        # Store MZI phase shifters indexed by (layer, pair_index)
        self.mzis: Dict[str, MachZehnderInterferometer] = {}
        # Clements mesh structure has N layers
        for layer in range(dimension):
            start = 0 if (layer % 2 == 0) else 1
            for i in range(start, dimension - 1, 2):
                self.mzis[f"L{layer}_P{i}"] = MachZehnderInterferometer(theta=0.0, phi=0.0)

    def set_phase(self, layer: int, pair_idx: int, theta: float, phi: float) -> None:
        key = f"L{layer}_P{pair_idx}"
        if key in self.mzis:
            self.mzis[key].theta = theta
            self.mzis[key].phi = phi

    def propagate_vector(self, optical_input: List[complex]) -> List[complex]:
        """Propagate complex optical vector through the entire photonic mesh."""
        if len(optical_input) != self.dim:
            raise ValueError(f"Input size {len(optical_input)} != mesh dimension {self.dim}")

        state = list(optical_input)
        for layer in range(self.dim):
            start = 0 if (layer % 2 == 0) else 1
            for i in range(start, self.dim - 1, 2):
                key = f"L{layer}_P{i}"
                if key in self.mzis:
                    out1, out2 = self.mzis[key].propagate(state[i], state[i + 1])
                    state[i] = out1
                    state[i + 1] = out2
        return state

    def estimate_energy_joules(self, mac_operations: int) -> float:
        """
        Estimate photonic energy dissipation (sub-femtojoule efficiency: ~10^-16 to 10^-18 J/MAC).
        """
        energy_per_mac = 1.5e-17 # 15 attojoules per optical multiply-accumulate
        return mac_operations * energy_per_mac
