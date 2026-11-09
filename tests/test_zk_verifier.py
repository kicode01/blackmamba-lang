"""
Tests for Phase 11E Zero-Knowledge State Verifier Engine (zk.py)
"""

import unittest
from tinytalk.zk import (
    FIELD_PRIME,
    R1CSConstraint,
    ZKProof,
    R1CSCircuit,
    ZKProver,
    ZKVerifier
)
import mamba.zk as m_zk


class TestZKVerifier(unittest.TestCase):
    def test_simple_multiplication_circuit(self):
        # Proves knowledge of factors: x * y = z
        circuit = R1CSCircuit()
        vx = circuit.alloc_var("x")
        vy = circuit.alloc_var("y")
        vz = circuit.alloc_var("z")

        # Constraint: 1*x * 1*y = 1*z
        circuit.add_constraint({vx: 1}, {vy: 1}, {vz: 1})

        # Witness: [ONE=1, x=6, y=7, z=42]
        witness = [1, 6, 7, 42]
        self.assertTrue(circuit.is_satisfied(witness))

        # Invalid witness: [ONE=1, x=6, y=7, z=43]
        bad_witness = [1, 6, 7, 43]
        self.assertFalse(circuit.is_satisfied(bad_witness))

    def test_polynomial_circuit_and_proof(self):
        # x^3 + x + 5 = out
        # sym_1 = x * x
        # y = sym_1 * x
        # sym_2 = y + x
        # ~out = sym_2 + 5
        circuit = R1CSCircuit()
        vx = circuit.alloc_var("x")
        vsym1 = circuit.alloc_var("sym_1")
        vy = circuit.alloc_var("y")
        vsym2 = circuit.alloc_var("sym_2")
        vout = circuit.alloc_var("out")

        # 1. x * x = sym_1
        circuit.add_constraint({vx: 1}, {vx: 1}, {vsym1: 1})
        # 2. sym_1 * x = y
        circuit.add_constraint({vsym1: 1}, {vx: 1}, {vy: 1})
        # 3. (y + x) * 1 = sym_2
        circuit.add_constraint({vy: 1, vx: 1}, {0: 1}, {vsym2: 1})
        # 4. (sym_2 + 5) * 1 = out
        circuit.add_constraint({vsym2: 1, 0: 5}, {0: 1}, {vout: 1})

        # For x = 3:
        # sym_1 = 9
        # y = 27
        # sym_2 = 30
        # out = 35
        witness = [1, 3, 9, 27, 30, 35]
        self.assertTrue(circuit.is_satisfied(witness))

        prover = ZKProver(circuit)
        verifier = ZKVerifier(circuit)

        # Public input is `out` (index 5)
        proof = prover.prove(witness, public_indices=[5])
        self.assertIsNotNone(proof)
        self.assertEqual(proof.public_inputs, [35])

        # Verify
        is_valid = verifier.verify(proof, public_indices=[5])
        self.assertTrue(is_valid)

    def test_tampered_proof_rejected(self):
        circuit = R1CSCircuit()
        vx = circuit.alloc_var("x")
        vy = circuit.alloc_var("y")
        circuit.add_constraint({vx: 1}, {vx: 1}, {vy: 1})
        witness = [1, 5, 25]

        prover = ZKProver(circuit)
        verifier = ZKVerifier(circuit)
        proof = prover.prove(witness, public_indices=[2])

        # Tamper response
        proof.response = 12345
        self.assertFalse(verifier.verify(proof, public_indices=[2]))

    def test_backward_compatibility_shim(self):
        self.assertIs(m_zk.R1CSCircuit, R1CSCircuit)
        self.assertIs(m_zk.ZKProver, ZKProver)
        self.assertIs(m_zk.ZKVerifier, ZKVerifier)


if __name__ == "__main__":
    unittest.main()
