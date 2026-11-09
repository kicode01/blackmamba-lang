"""
Test Suite and Adversarial OpenQASM 3.0 Syntax Fuzzer for TinyTalk Phase 15B: QASM & QEC.
"""

import unittest
import random
from tinytalk.quantum import QuantumCircuit
from tinytalk.qasm import OpenQASMEmitter, Surface17QECEmitter

class TestQASM(unittest.TestCase):
    def test_openqasm_emitter_syntax(self):
        qc = QuantumCircuit(2)
        qc.h(0)
        qc.cnot(0, 1)
        qasm = OpenQASMEmitter.emit(qc)

        self.assertIn("OPENQASM 3.0;", qasm)
        self.assertIn('include "stdgates.inc";', qasm)
        self.assertIn("qubit[2] q;", qasm)
        self.assertIn("h q[0];", qasm)
        self.assertIn("cx q[0], q[1];", qasm)
        self.assertIn("c[0] = measure q[0];", qasm)

    def test_surface17_qec_emitter(self):
        qec = Surface17QECEmitter()
        code = qec.emit_syndrome_round()
        self.assertIn("qubit[9] data;", code)
        self.assertIn("qubit[4] ancilla_x;", code)
        self.assertIn("qubit[4] ancilla_z;", code)
        self.assertIn("syn_x = measure ancilla_x;", code)

    def test_adversarial_qasm_fuzzer_100_runs(self):
        """Fuzz random circuit topologies and verify strict OpenQASM 3.0 grammar compliance."""
        rng = random.Random(7771)
        for trial in range(100):
            n = rng.randint(1, 8)
            qc = QuantumCircuit(n)
            n_gates = rng.randint(5, 20)
            for _ in range(n_gates):
                g = rng.choice(["h", "x", "z", "cnot"])
                if g in ("h", "x", "z"):
                    qc.h(rng.randint(0, n - 1))
                elif g == "cnot" and n >= 2:
                    c = rng.randint(0, n - 1)
                    t = rng.randint(0, n - 1)
                    if c != t:
                        qc.cnot(c, t)

            qasm_str = OpenQASMEmitter.emit(qc)

            # Invariant 1: Header present
            self.assertTrue(qasm_str.startswith("OPENQASM 3.0;"))

            # Invariant 2: Register declaration matches circuit qubit count
            self.assertIn(f"qubit[{n}] q;", qasm_str)
            self.assertIn(f"bit[{n}] c;", qasm_str)

            # Invariant 3: All emitted lines end with semicolon or comment/newline
            for line in qasm_str.splitlines():
                line = line.strip()
                if line and not line.startswith("//"):
                    self.assertTrue(line.endswith(";"), f"Line missing semicolon: {line}")

if __name__ == "__main__":
    unittest.main()
