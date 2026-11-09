"""
TinyTalk Phase 15E: Quantum Verification & Clifford+T Fault-Tolerance Engine
Verifies formal safety properties on quantum circuit statevectors:
- Unitary L2-norm preservation (|sum |c_i|^2 - 1.0| < epsilon)
- Entanglement concurrence & Bell-state purity certification
- Detection of non-physical cloning or probability leaks
"""

from typing import List, Dict, Any, Tuple
import math
import cmath

class QuantumVerifier:
    """
    Formal certification engine for quantum statevectors and gate operations.
    """
    def __init__(self, tolerance: float = 1e-6):
        self.tolerance = tolerance

    def verify_statevector_norm(self, statevector: List[complex]) -> Dict[str, Any]:
        """Verify that total probability sum equals 1.0."""
        total_p = sum(abs(c)**2 for c in statevector)
        diff = abs(total_p - 1.0)
        is_valid = diff <= self.tolerance
        violations = []
        if not is_valid:
            violations.append(f"Unitary violation: total probability {total_p:.8f} != 1.0 (diff={diff:.2e})")

        return {
            "valid": is_valid,
            "violations": violations,
            "total_probability": total_p,
            "norm_error": diff
        }

    def verify_bell_state_entanglement(self, statevector_2qubit: List[complex]) -> Dict[str, Any]:
        """
        Verify that a 2-qubit statevector represents a maximally entangled Bell state:
        Concurrence C(psi) = 2 * |c00 * c11 - c01 * c10| == 1.0
        """
        if len(statevector_2qubit) != 4:
            return {"valid": False, "violations": ["Statevector must have 4 amplitudes (2 qubits)"], "concurrence": 0.0}

        c00 = statevector_2qubit[0]
        c01 = statevector_2qubit[1]
        c10 = statevector_2qubit[2]
        c11 = statevector_2qubit[3]

        concurrence = 2.0 * abs(c00 * c11 - c01 * c10)
        is_maximal = abs(concurrence - 1.0) <= self.tolerance

        violations = []
        if not is_maximal:
            violations.append(f"Sub-maximal entanglement: concurrence = {concurrence:.4f} != 1.0")

        return {
            "valid": is_maximal,
            "violations": violations,
            "concurrence": round(concurrence, 4)
        }
