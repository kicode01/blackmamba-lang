"""
Test Suite and Adversarial Concurrence Fuzzer for TinyTalk Phase 15E: Quantum Verifier.
"""

import unittest
import random
import math
from tinytalk.quantum import QuantumCircuit
from tinytalk.quantum_verify import QuantumVerifier

class TestQuantumVerify(unittest.TestCase):
    def test_bell_state_concurrence_verification(self):
        verifier = QuantumVerifier()
        # Create Phi+ Bell state: (|00> + |11>) / sqrt(2)
        qc = QuantumCircuit(2)
        qc.h(0)
        qc.cnot(0, 1)

        res = verifier.verify_bell_state_entanglement(qc.state)
        self.assertTrue(res["valid"])
        self.assertEqual(res["concurrence"], 1.0)

    def test_separable_product_state_fails_concurrence(self):
        verifier = QuantumVerifier()
        # Product state |00> (unentangled)
        qc = QuantumCircuit(2)
        res = verifier.verify_bell_state_entanglement(qc.state)
        self.assertFalse(res["valid"])
        self.assertEqual(res["concurrence"], 0.0)

    def test_adversarial_norm_verification_fuzzer_100_runs(self):
        """Fuzz verifier detection of norm violations and valid quantum statevectors."""
        rng = random.Random(8888)
        verifier = QuantumVerifier()

        for trial in range(100):
            # Generate random normalized 4-amplitude statevector
            raw = [complex(rng.uniform(-1, 1), rng.uniform(-1, 1)) for _ in range(4)]
            mag = math.sqrt(sum(abs(c)**2 for c in raw))
            norm_state = [c / mag for c in raw]

            # Invariant 1: Correctly normalized statevector must pass verification
            res = verifier.verify_statevector_norm(norm_state)
            self.assertTrue(res["valid"])

            # Invariant 2: Artificially scaled statevector must fail verification
            bad_state = [c * 1.5 for c in norm_state]
            bad_res = verifier.verify_statevector_norm(bad_state)
            self.assertFalse(bad_res["valid"])

if __name__ == "__main__":
    unittest.main()
