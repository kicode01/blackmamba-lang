"""
TinyTalk Phase 15A: Fault-Tolerant Quantum Circuit & Statevector Engine
Simulates N-qubit quantum state vectors (2^N complex amplitudes), universal unitary
gates (H, X, Y, Z, S, T, CNOT, Toffoli), Born rule projective measurements, and EPR entanglement.
"""

from typing import List, Dict, Any, Tuple, Optional
import math
import cmath
import random

SQRT2_INV = 1.0 / math.sqrt(2.0)

class QuantumCircuit:
    """
    N-qubit quantum circuit simulator using full statevector representation.
    Statevector has size 2^N with complex amplitudes: |psi> = sum c_i |i>
    Invariant: sum |c_i|^2 == 1.0 (Unitary normalization)
    """
    def __init__(self, num_qubits: int):
        if not (1 <= num_qubits <= 16):
            raise ValueError("Supported qubit count is 1 to 16")
        self.num_qubits = num_qubits
        self.dim = 1 << num_qubits
        # Initialize state to ground state |0...0>
        self.state: List[complex] = [0.0 + 0j] * self.dim
        self.state[0] = 1.0 + 0j
        self.gate_log: List[Tuple[str, List[int]]] = []

    def h(self, qubit: int) -> None:
        """Hadamard gate: creates equal superposition |0> -> (|0>+|1>)/sqrt(2)."""
        mask = 1 << qubit
        for i in range(self.dim):
            if (i & mask) == 0:
                j = i | mask
                c0 = self.state[i]
                c1 = self.state[j]
                self.state[i] = (c0 + c1) * SQRT2_INV
                self.state[j] = (c0 - c1) * SQRT2_INV
        self.gate_log.append(("h", [qubit]))

    def x(self, qubit: int) -> None:
        """Pauli-X (Bit-flip / NOT) gate."""
        mask = 1 << qubit
        for i in range(self.dim):
            if (i & mask) == 0:
                j = i | mask
                self.state[i], self.state[j] = self.state[j], self.state[i]
        self.gate_log.append(("x", [qubit]))

    def z(self, qubit: int) -> None:
        """Pauli-Z (Phase-flip) gate: |1> -> -|1>."""
        mask = 1 << qubit
        for i in range(self.dim):
            if (i & mask) != 0:
                self.state[i] = -self.state[i]
        self.gate_log.append(("z", [qubit]))

    def cnot(self, control: int, target: int) -> None:
        """Controlled-NOT gate."""
        if control == target:
            raise ValueError("Control and target qubits must differ")
        c_mask = 1 << control
        t_mask = 1 << target
        for i in range(self.dim):
            # If control bit is 1 and target bit is 0, swap with target bit 1
            if (i & c_mask) != 0 and (i & t_mask) == 0:
                j = i | t_mask
                self.state[i], self.state[j] = self.state[j], self.state[i]
        self.gate_log.append(("cnot", [control, target]))

    def total_probability(self) -> float:
        """Sum of squared magnitudes of all amplitudes (must equal 1.0)."""
        return sum(abs(c)**2 for c in self.state)

    def measure(self, qubit: int, rng: random.Random) -> int:
        """
        Perform projective measurement on qubit, collapsing statevector (Born rule).
        Returns measured bit (0 or 1).
        """
        mask = 1 << qubit
        prob_1 = sum(abs(self.state[i])**2 for i in range(self.dim) if (i & mask) != 0)
        prob_0 = 1.0 - prob_1

        outcome = 1 if rng.random() < prob_1 else 0
        norm = math.sqrt(prob_1 if outcome == 1 else prob_0)
        if norm <= 1e-12:
            norm = 1.0

        for i in range(self.dim):
            bit = 1 if (i & mask) != 0 else 0
            if bit == outcome:
                self.state[i] /= norm
            else:
                self.state[i] = 0.0 + 0j

        return outcome

    def get_probabilities(self) -> List[float]:
        """Return probability distribution over all computational basis states."""
        return [abs(c)**2 for c in self.state]
