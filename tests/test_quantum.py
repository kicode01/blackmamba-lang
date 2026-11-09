"""
Test Suite and Adversarial Unitary Normalization Fuzzer for TinyTalk Phase 15A: Quantum Engine.
"""

import unittest
import random
import math
from tinytalk.quantum import QuantumCircuit

class TestQuantum(unittest.TestCase):
    def test_bell_state_epr_entanglement(self):
        # 2-qubit Bell pair: (|00> + |11>) / sqrt(2)
        qc = QuantumCircuit(2)
        qc.h(0)
        qc.cnot(0, 1)

        probs = qc.get_probabilities()
        # State 0 (|00>): 0.5, State 3 (|11>): 0.5, States 1 & 2: 0.0
        self.assertAlmostEqual(probs[0], 0.5, places=5)
        self.assertAlmostEqual(probs[1], 0.0, places=5)
        self.assertAlmostEqual(probs[2], 0.0, places=5)
        self.assertAlmostEqual(probs[3], 0.5, places=5)

        # Measurement correlation: measuring qubit 0 determines qubit 1
        rng = random.Random(42)
        m0 = qc.measure(0, rng)
        m1 = qc.measure(1, rng)
        self.assertEqual(m0, m1)

    def test_adversarial_unitary_fuzzer_100_runs(self):
        """Fuzz unitary normalization invariant: sum |c_i|^2 == 1.0 across random gate depths."""
        rng = random.Random(2026)
        for trial in range(100):
            n_qubits = rng.randint(2, 5)
            qc = QuantumCircuit(n_qubits)

            # Apply 20 random gates
            for _ in range(20):
                gate = rng.choice(["h", "x", "z", "cnot"])
                if gate in ("h", "x", "z"):
                    q = rng.randint(0, n_qubits - 1)
                    if gate == "h":
                        qc.h(q)
                    elif gate == "x":
                        qc.x(q)
                    else:
                        qc.z(q)
                elif gate == "cnot":
                    c = rng.randint(0, n_qubits - 1)
                    t = rng.randint(0, n_qubits - 1)
                    if c != t:
                        qc.cnot(c, t)

            # Invariant: Total probability must strictly equal 1.0
            self.assertAlmostEqual(
                qc.total_probability(),
                1.0,
                places=5,
                msg=f"Trial {trial}: Unitary normalization violated! {qc.total_probability()}"
            )

if __name__ == "__main__":
    unittest.main()
