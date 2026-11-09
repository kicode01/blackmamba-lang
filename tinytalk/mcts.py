"""
TinyTalk Monte-Carlo Tree Search (MCTS) Assembly Synthesizer (Phase 12B)
========================================================================
Combinatorial instruction synthesis engine inspired by AlphaDev.
Explores the graph of equivalent instruction sequences using UCB1 tree search
to discover hardware-optimal sequences that outperform standard compiler heuristics.
"""

from __future__ import annotations
import math
import random
from typing import List, Dict, Optional, Tuple, Any, Set
from dataclasses import dataclass, field
from tinytalk.superopt import CPUCostModel, SSAInstruction, InstructionLatency


@dataclass
class MCTSNode:
    """A search tree node representing a partial or candidate instruction sequence."""
    instructions: List[SSAInstruction]
    parent: Optional[MCTSNode] = None
    children: List[MCTSNode] = field(default_factory=list)
    visits: int = 0
    total_reward: float = 0.0
    action_taken: str = ""

    @property
    def q_value(self) -> float:
        """Average reward for this node."""
        if self.visits == 0:
            return 0.0
        return self.total_reward / self.visits

    def ucb1(self, exploration_constant: float = 1.414) -> float:
        """Calculate Upper Confidence Bound 1 (UCB1) score."""
        if self.visits == 0:
            return float("inf")
        if self.parent is None or self.parent.visits == 0:
            return self.q_value
        return self.q_value + exploration_constant * math.sqrt(
            math.log(self.parent.visits) / self.visits
        )


class MCTSSynthesizer:
    """
    Monte-Carlo Tree Search assembly and MIR kernel synthesizer.
    Discovers optimal instruction sequences by exploring transformations,
    instruction reordering, and equivalent bitwise/arithmetic replacements.
    """

    def __init__(
        self,
        cost_model: Optional[CPUCostModel] = None,
        exploration_constant: float = 1.414,
        max_iterations: int = 150,
        seed: int = 42
    ):
        self.cost_model = cost_model or CPUCostModel("zen4")
        self.c = exploration_constant
        self.max_iterations = max_iterations
        self.rng = random.Random(seed)

    def synthesize_optimal_sequence(
        self,
        baseline_instructions: List[SSAInstruction],
        target_evaluator: Optional[Any] = None
    ) -> Tuple[List[SSAInstruction], float]:
        """
        Run MCTS to synthesize an instruction sequence that minimizes CPU cycles
        while preserving exact semantic equivalence.
        Returns (best_sequence, estimated_cycle_cost).
        """
        base_ops = [i.op for i in baseline_instructions]
        base_cost, _, _ = self.cost_model.estimate_sequence_cost(base_ops)

        root = MCTSNode(instructions=list(baseline_instructions))
        best_instructions = list(baseline_instructions)
        min_cost = base_cost

        for _ in range(self.max_iterations):
            # 1. Selection
            leaf = self._select(root)

            # 2. Expansion
            child = self._expand(leaf)
            target_node = child if child is not None else leaf

            # 3. Simulation (Rollout)
            reward, simulated_cost = self._simulate(target_node, base_cost)

            # Track global best
            if simulated_cost < min_cost:
                min_cost = simulated_cost
                best_instructions = list(target_node.instructions)

            # 4. Backpropagation
            self._backpropagate(target_node, reward)

        return best_instructions, min_cost

    def _select(self, node: MCTSNode) -> MCTSNode:
        """Traverse tree using UCB1 until an unexpanded node is reached."""
        curr = node
        while curr.children:
            # Pick child with highest UCB1
            curr = max(curr.children, key=lambda c: c.ucb1(self.c))
        return curr

    def _expand(self, node: MCTSNode) -> Optional[MCTSNode]:
        """Generate candidate mutated instruction variations."""
        candidates = self._generate_candidate_variations(node.instructions)
        if not candidates:
            return None

        # Filter out sequences already in children
        existing = {self._sequence_key(c.instructions) for c in node.children}
        new_candidates = [c for c in candidates if self._sequence_key(c[0]) not in existing]

        if not new_candidates:
            return None

        chosen_instrs, action = self.rng.choice(new_candidates)
        child = MCTSNode(
            instructions=chosen_instrs,
            parent=node,
            action_taken=action
        )
        node.children.append(child)
        return child

    def _simulate(self, node: MCTSNode, baseline_cost: float) -> Tuple[float, float]:
        """
        Simulate cost and evaluate reward.
        Reward is higher for lower cycle latency and smaller code size.
        """
        ops = [i.op for i in node.instructions]
        cost, total_lat, bytes_sz = self.cost_model.estimate_sequence_cost(ops)

        # Baseline cost normalized reward
        if baseline_cost <= 0:
            reward = 1.0
        else:
            # Reward increases as cost drops below baseline
            reward = max(0.0, (baseline_cost - cost) / baseline_cost + 1.0)

        return reward, cost

    def _backpropagate(self, node: MCTSNode, reward: float) -> None:
        """Propagate reward up to the root."""
        curr: Optional[MCTSNode] = node
        while curr is not None:
            curr.visits += 1
            curr.total_reward += reward
            curr = curr.parent

    def _generate_candidate_variations(
        self, instrs: List[SSAInstruction]
    ) -> List[Tuple[List[SSAInstruction], str]]:
        """Generate valid semantic mutations and instruction schedules."""
        variations: List[Tuple[List[SSAInstruction], str]] = []

        # 1. Commutative argument swapping (a + b <-> b + a, a * b <-> b * a)
        for idx, instr in enumerate(instrs):
            if instr.op in ("add", "mul", "imul", "and", "or", "xor") and len(instr.args) == 2:
                swapped = list(instrs)
                swapped[idx] = SSAInstruction(
                    dest=instr.dest,
                    op=instr.op,
                    args=[instr.args[1], instr.args[0]]
                )
                variations.append((swapped, f"commute_{idx}"))

        # 2. Strength reduction mutations:
        # Replace imul by shl if power of 2
        for idx, instr in enumerate(instrs):
            if instr.op in ("mul", "imul") and len(instr.args) == 2:
                for arg_idx, arg in enumerate(instr.args):
                    if isinstance(arg, int) and arg > 0 and (arg & (arg - 1)) == 0:
                        shift = arg.bit_length() - 1
                        other_arg = instr.args[1 - arg_idx]
                        mutated = list(instrs)
                        mutated[idx] = SSAInstruction(
                            dest=instr.dest,
                            op="shl",
                            args=[other_arg, shift]
                        )
                        variations.append((mutated, f"strength_mul_shl_{idx}"))

        # 3. Instruction reordering (interleaving independent operations to hide latency)
        if len(instrs) >= 2:
            for i in range(len(instrs) - 1):
                i1, i2 = instrs[i], instrs[i + 1]
                # Can swap if i2 does not read i1.dest and i1 does not read i2.dest
                i2_reads_i1 = i1.dest in [a for a in i2.args if isinstance(a, str)]
                i1_reads_i2 = i2.dest in [a for a in i1.args if isinstance(a, str)]
                if not i2_reads_i1 and not i1_reads_i2 and i1.dest != i2.dest:
                    reordered = list(instrs)
                    reordered[i], reordered[i + 1] = reordered[i + 1], reordered[i]
                    variations.append((reordered, f"reorder_{i}_{i+1}"))

        return variations

    def _sequence_key(self, instrs: List[SSAInstruction]) -> str:
        return ";".join(f"{i.dest}={i.op}({i.args})" for i in instrs)
