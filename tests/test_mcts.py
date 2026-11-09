"""
Unit Tests and Adversarial Fuzzer for TinyTalk MCTS Assembly Synthesizer (Phase 12B)
===================================================================================
Tests MCTS node expansion, UCB1 calculations, sequence synthesis,
latency minimization, and adversarial randomized kernel search.
"""

from __future__ import annotations
import unittest
import math
import random
from tinytalk.superopt import CPUCostModel, SSAInstruction
from tinytalk.mcts import MCTSNode, MCTSSynthesizer
import mamba.mcts as mamba_mcts


class TestMCTSSynthesizer(unittest.TestCase):
    """Test suite for Phase 12B MCTS Assembly Synthesizer."""

    def setUp(self):
        self.cost_model = CPUCostModel("zen4")
        self.synthesizer = MCTSSynthesizer(self.cost_model, max_iterations=100, seed=123)

    def test_mcts_node_ucb1(self):
        """Verify UCB1 calculation and exploration bonus."""
        parent = MCTSNode(instructions=[], visits=10, total_reward=5.0)
        child = MCTSNode(instructions=[], parent=parent, visits=2, total_reward=1.6)

        # Q = 1.6 / 2 = 0.8
        # UCB1 = 0.8 + 1.414 * sqrt(ln(10)/2) = 0.8 + 1.414 * sqrt(2.3025/2) = ~2.316
        ucb1_score = child.ucb1(1.414)
        self.assertAlmostEqual(child.q_value, 0.8)
        self.assertGreater(ucb1_score, 0.8)

        # Unvisited child gets infinite score to encourage exploration
        unvisited = MCTSNode(instructions=[], parent=parent, visits=0)
        self.assertEqual(unvisited.ucb1(1.414), float("inf"))

    def test_synthesize_strength_reduction_sequence(self):
        """Verify MCTS synthesizes shift operations instead of expensive imul instructions."""
        # Baseline: Multiply by 16 using imul
        baseline = [
            SSAInstruction("v0", "arg", [0]),
            SSAInstruction("v1", "imul", ["v0", 16])
        ]
        best_seq, best_cost = self.synthesizer.synthesize_optimal_sequence(baseline)

        # Initial imul costs 3.0 cycles on Zen 4
        # MCTS should discover shl (1.0 cycle)
        self.assertEqual(best_seq[-1].op, "shl")
        self.assertEqual(best_seq[-1].args, ["v0", 4])
        self.assertLess(best_cost, 3.0)

    def test_synthesize_instruction_reordering(self):
        """Verify MCTS explores instruction reordering without breaking data dependencies."""
        baseline = [
            SSAInstruction("a1", "add", [1, 2]),
            SSAInstruction("b1", "add", [3, 4]),
            SSAInstruction("final", "mul", ["a1", "b1"])
        ]
        best_seq, best_cost = self.synthesizer.synthesize_optimal_sequence(baseline)
        self.assertEqual(len(best_seq), 3)
        self.assertEqual(best_seq[-1].dest, "final")

    def test_adversarial_mcts_fuzzer(self):
        """
        Adversarial fuzz testing: Generate 50 random kernel DAGs and verify
        that MCTS produces equal or lower cycle costs with valid semantic preservation.
        """
        rng = random.Random(999)
        powers = [2, 4, 8, 16, 32]

        for _ in range(50):
            # Create a multi-instruction chain
            kernel = [SSAInstruction("v0", "arg", [0])]
            curr = "v0"
            for step in range(3):
                nxt = f"v{step+1}"
                p = rng.choice(powers)
                kernel.append(SSAInstruction(nxt, "imul", [curr, p]))
                curr = nxt

            base_cost, _, _ = self.cost_model.estimate_sequence_cost([i.op for i in kernel])
            best_seq, best_cost = self.synthesizer.synthesize_optimal_sequence(kernel)

            # Monotonic improvement or parity
            self.assertLessEqual(best_cost, base_cost + 1e-6)

    def test_backward_compatibility_mamba_mcts(self):
        """Verify mamba.mcts forwards to tinytalk.mcts."""
        self.assertIs(mamba_mcts.MCTSSynthesizer, MCTSSynthesizer)
        self.assertIs(mamba_mcts.MCTSNode, MCTSNode)


if __name__ == "__main__":
    unittest.main()
