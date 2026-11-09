"""
TinyTalk Superoptimizer & Hardware CPU Cost Model (Phase 12A)
=============================================================
Provides precise hardware CPU cycle cost modeling, latency estimation,
and SSA MIR peephole optimization with algebraic and bitwise reduction patterns.
"""

from __future__ import annotations
from typing import Dict, List, Optional, Tuple, Any, Callable
from dataclasses import dataclass, field
import sys

# ---------------------------------------------------------------------------
# Hardware Architecture Cost Models
# ---------------------------------------------------------------------------

@dataclass(frozen=True)
class InstructionLatency:
    """Latency and reciprocal throughput (cycles) for an instruction."""
    latency_cycles: float
    reciprocal_throughput: float
    code_size_bytes: int


# Hardware-calibrated latency profiles (cycles)
CPU_ARCH_PROFILES: Dict[str, Dict[str, InstructionLatency]] = {
    "zen4": {
        "nop": InstructionLatency(0.0, 0.25, 1),
        "mov": InstructionLatency(0.0, 0.25, 2),
        "add": InstructionLatency(1.0, 0.25, 3),
        "sub": InstructionLatency(1.0, 0.25, 3),
        "and": InstructionLatency(1.0, 0.25, 3),
        "or":  InstructionLatency(1.0, 0.25, 3),
        "xor": InstructionLatency(0.0, 0.25, 3),   # Zeroing idioms are 0-latency on Zen
        "shl": InstructionLatency(1.0, 0.50, 3),
        "shr": InstructionLatency(1.0, 0.50, 3),
        "sar": InstructionLatency(1.0, 0.50, 3),
        "imul": InstructionLatency(3.0, 1.00, 4),
        "idiv": InstructionLatency(14.0, 10.0, 4),
        "load": InstructionLatency(4.0, 0.50, 5),
        "store": InstructionLatency(1.0, 0.50, 5),
        "call": InstructionLatency(2.0, 1.00, 5),
        "ret": InstructionLatency(1.0, 1.00, 1),
        "jmp": InstructionLatency(1.0, 0.50, 2),
        "jcc": InstructionLatency(1.0, 0.50, 2),
    },
    "skylake": {
        "nop": InstructionLatency(0.0, 0.25, 1),
        "mov": InstructionLatency(0.0, 0.25, 2),
        "add": InstructionLatency(1.0, 0.25, 3),
        "sub": InstructionLatency(1.0, 0.25, 3),
        "and": InstructionLatency(1.0, 0.25, 3),
        "or":  InstructionLatency(1.0, 0.25, 3),
        "xor": InstructionLatency(0.0, 0.25, 3),
        "shl": InstructionLatency(1.0, 0.50, 3),
        "shr": InstructionLatency(1.0, 0.50, 3),
        "sar": InstructionLatency(1.0, 0.50, 3),
        "imul": InstructionLatency(3.0, 1.00, 4),
        "idiv": InstructionLatency(24.0, 18.0, 4),
        "load": InstructionLatency(4.0, 0.50, 5),
        "store": InstructionLatency(1.0, 0.50, 5),
        "call": InstructionLatency(2.0, 1.00, 5),
        "ret": InstructionLatency(1.0, 1.00, 1),
        "jmp": InstructionLatency(1.0, 0.50, 2),
        "jcc": InstructionLatency(1.0, 0.50, 2),
    },
    "apple_m": {
        "nop": InstructionLatency(0.0, 0.125, 4),
        "mov": InstructionLatency(0.0, 0.125, 4),
        "add": InstructionLatency(1.0, 0.125, 4),
        "sub": InstructionLatency(1.0, 0.125, 4),
        "and": InstructionLatency(1.0, 0.125, 4),
        "or":  InstructionLatency(1.0, 0.125, 4),
        "xor": InstructionLatency(1.0, 0.125, 4),
        "shl": InstructionLatency(1.0, 0.25, 4),
        "shr": InstructionLatency(1.0, 0.25, 4),
        "sar": InstructionLatency(1.0, 0.25, 4),
        "imul": InstructionLatency(3.0, 0.50, 4),
        "idiv": InstructionLatency(12.0, 8.0, 4),
        "load": InstructionLatency(3.0, 0.33, 4),
        "store": InstructionLatency(1.0, 0.33, 4),
        "call": InstructionLatency(1.0, 0.50, 4),
        "ret": InstructionLatency(1.0, 0.50, 4),
        "jmp": InstructionLatency(1.0, 0.25, 4),
        "jcc": InstructionLatency(1.0, 0.25, 4),
    },
    "generic": {
        "nop": InstructionLatency(0.0, 1.0, 1),
        "mov": InstructionLatency(1.0, 1.0, 2),
        "add": InstructionLatency(1.0, 1.0, 3),
        "sub": InstructionLatency(1.0, 1.0, 3),
        "and": InstructionLatency(1.0, 1.0, 3),
        "or":  InstructionLatency(1.0, 1.0, 3),
        "xor": InstructionLatency(1.0, 1.0, 3),
        "shl": InstructionLatency(1.0, 1.0, 3),
        "shr": InstructionLatency(1.0, 1.0, 3),
        "sar": InstructionLatency(1.0, 1.0, 3),
        "imul": InstructionLatency(4.0, 1.0, 4),
        "idiv": InstructionLatency(20.0, 15.0, 4),
        "load": InstructionLatency(4.0, 1.0, 5),
        "store": InstructionLatency(1.0, 1.0, 5),
        "call": InstructionLatency(2.0, 1.0, 5),
        "ret": InstructionLatency(1.0, 1.0, 1),
        "jmp": InstructionLatency(1.0, 1.0, 2),
        "jcc": InstructionLatency(1.0, 1.0, 2),
    }
}


class CPUCostModel:
    """Hardware cycle and code-size estimation engine."""

    def __init__(self, architecture: str = "zen4"):
        self.architecture = architecture if architecture in CPU_ARCH_PROFILES else "generic"
        self.profile = CPU_ARCH_PROFILES[self.architecture]

    def instruction_cost(self, opcode: str) -> InstructionLatency:
        op = opcode.lower()
        return self.profile.get(op, self.profile.get("nop", InstructionLatency(1.0, 1.0, 3)))

    def estimate_sequence_cost(self, opcodes: List[str]) -> Tuple[float, float, int]:
        """
        Estimate total latency, critical-path execution cycles, and code size.
        Returns (total_latency, throughput_bound, total_bytes).
        """
        total_latency = 0.0
        total_recip_throughput = 0.0
        total_bytes = 0

        for op in opcodes:
            cost = self.instruction_cost(op)
            total_latency += cost.latency_cycles
            total_recip_throughput += cost.reciprocal_throughput
            total_bytes += cost.code_size_bytes

        # Execution time is bounded below by maximum of dependency latency and throughput
        estimated_cycles = max(total_latency, total_recip_throughput)
        return estimated_cycles, total_latency, total_bytes


# ---------------------------------------------------------------------------
# SSA MIR Instruction Abstraction
# ---------------------------------------------------------------------------

@dataclass
class SSAInstruction:
    """Single Static Assignment (SSA) instruction."""
    dest: str
    op: str
    args: List[Any]  # Strings (registers) or ints/floats (constants)

    def is_constant(self) -> bool:
        return self.op == "const" and len(self.args) == 1

    def const_val(self) -> Optional[int]:
        if self.is_constant() and isinstance(self.args[0], int):
            return self.args[0]
        return None

    def __repr__(self) -> str:
        args_str = ", ".join(str(a) for a in self.args)
        return f"{self.dest} = {self.op}({args_str})"


# ---------------------------------------------------------------------------
# Peephole Optimizer & Pattern Database
# ---------------------------------------------------------------------------

class PeepholeOptimizer:
    """
    Algebraic and bitwise strength reduction superoptimizer.
    Transforms expensive arithmetic instructions (mul, div, mod) into
    single-cycle shifts, masks, and zero-latency identity operations.
    """

    def __init__(self, cost_model: Optional[CPUCostModel] = None):
        self.cost_model = cost_model or CPUCostModel("zen4")
        self.rewrites_performed = 0

    def optimize_instructions(self, instrs: List[SSAInstruction]) -> List[SSAInstruction]:
        """Iteratively apply peephole rewrites until convergence."""
        current = list(instrs)
        changed = True
        iterations = 0
        max_iterations = 20

        while changed and iterations < max_iterations:
            changed = False
            iterations += 1
            new_instrs, did_rewrite = self._apply_pass(current)
            if did_rewrite:
                current = new_instrs
                changed = True

        # Perform dead code elimination
        return self.eliminate_dead_code(current)

    def _apply_pass(self, instrs: List[SSAInstruction]) -> Tuple[List[SSAInstruction], bool]:
        """Single optimization pass across instructions."""
        optimized: List[SSAInstruction] = []
        any_change = False
        const_map: Dict[str, int] = {}

        for instr in instrs:
            # Track constant definitions
            if instr.is_constant():
                val = instr.const_val()
                if val is not None:
                    const_map[instr.dest] = val
                optimized.append(instr)
                continue

            rewritten = self._try_rewrite(instr, const_map)
            if rewritten is not None:
                any_change = True
                self.rewrites_performed += 1
                for r in rewritten:
                    if r.is_constant():
                        val = r.const_val()
                        if val is not None:
                            const_map[r.dest] = val
                    optimized.append(r)
            else:
                optimized.append(instr)

        return optimized, any_change

    def _try_rewrite(
        self, instr: SSAInstruction, const_map: Dict[str, int]
    ) -> Optional[List[SSAInstruction]]:
        """Try applying algebraic and bitwise simplification patterns."""
        op = instr.op.lower()
        args = instr.args
        dest = instr.dest

        # Unary operations
        if len(args) == 1:
            arg = args[0]
            val = const_map.get(arg) if isinstance(arg, str) else arg

            # Constant folding for unary neg
            if op == "neg" and isinstance(val, int):
                return [SSAInstruction(dest, "const", [-val])]
            if op == "not" and isinstance(val, int):
                return [SSAInstruction(dest, "const", [~val])]

        # Binary operations
        elif len(args) == 2:
            left, right = args[0], args[1]
            left_val = const_map.get(left) if isinstance(left, str) else (left if isinstance(left, int) else None)
            right_val = const_map.get(right) if isinstance(right, str) else (right if isinstance(right, int) else None)

            # 1. Full Constant Folding
            if left_val is not None and right_val is not None:
                res = self._fold_binary(op, left_val, right_val)
                if res is not None:
                    return [SSAInstruction(dest, "const", [res])]

            # 2. Identity Elimination: x + 0 -> x, x - 0 -> x
            if op == "add":
                if right_val == 0:
                    return [SSAInstruction(dest, "mov", [left])]
                if left_val == 0:
                    return [SSAInstruction(dest, "mov", [right])]
            if op == "sub":
                if right_val == 0:
                    return [SSAInstruction(dest, "mov", [left])]
                if left == right:
                    # x - x -> 0
                    return [SSAInstruction(dest, "const", [0])]

            # 3. Multiplication Strength Reduction:
            # x * 0 -> 0
            if op == "mul" or op == "imul":
                if left_val == 0 or right_val == 0:
                    return [SSAInstruction(dest, "const", [0])]
                # x * 1 -> x
                if right_val == 1:
                    return [SSAInstruction(dest, "mov", [left])]
                if left_val == 1:
                    return [SSAInstruction(dest, "mov", [right])]
                # x * 2^k -> x << k
                if right_val is not None and right_val > 0 and (right_val & (right_val - 1)) == 0:
                    shift = right_val.bit_length() - 1
                    return [SSAInstruction(dest, "shl", [left, shift])]
                if left_val is not None and left_val > 0 and (left_val & (left_val - 1)) == 0:
                    shift = left_val.bit_length() - 1
                    return [SSAInstruction(dest, "shl", [right, shift])]

            # 4. Division Strength Reduction:
            # x / 1 -> x
            if op in ("div", "idiv"):
                if right_val == 1:
                    return [SSAInstruction(dest, "mov", [left])]
                # x / 2^k -> x >> k (for positive power-of-two denominators)
                if right_val is not None and right_val > 0 and (right_val & (right_val - 1)) == 0:
                    shift = right_val.bit_length() - 1
                    return [SSAInstruction(dest, "shr", [left, shift])]

            # 5. Modulo Reduction:
            # x % 2^k -> x & (2^k - 1)
            if op in ("mod", "rem"):
                if right_val is not None and right_val > 0 and (right_val & (right_val - 1)) == 0:
                    mask = right_val - 1
                    return [SSAInstruction(dest, "and", [left, mask])]

            # 6. Bitwise Identity Laws:
            # x & x -> x, x | x -> x
            if left == right:
                if op in ("and", "or"):
                    return [SSAInstruction(dest, "mov", [left])]
                if op == "xor":
                    # x ^ x -> 0 (zero-latency idiom)
                    return [SSAInstruction(dest, "const", [0])]

            # x & 0 -> 0
            if op == "and":
                if left_val == 0 or right_val == 0:
                    return [SSAInstruction(dest, "const", [0])]
                if right_val == -1:
                    return [SSAInstruction(dest, "mov", [left])]
                if left_val == -1:
                    return [SSAInstruction(dest, "mov", [right])]

            # x | 0 -> x
            if op == "or":
                if right_val == 0:
                    return [SSAInstruction(dest, "mov", [left])]
                if left_val == 0:
                    return [SSAInstruction(dest, "mov", [right])]

            # x ^ 0 -> x
            if op == "xor":
                if right_val == 0:
                    return [SSAInstruction(dest, "mov", [left])]
                if left_val == 0:
                    return [SSAInstruction(dest, "mov", [right])]

        return None

    def _fold_binary(self, op: str, a: int, b: int) -> Optional[int]:
        """Safely compute constant folding result."""
        try:
            if op in ("add", "+"):
                return a + b
            elif op in ("sub", "-"):
                return a - b
            elif op in ("mul", "*", "imul"):
                return a * b
            elif op in ("div", "/", "idiv"):
                return a // b if b != 0 else None
            elif op in ("mod", "%", "rem"):
                return a % b if b != 0 else None
            elif op in ("and", "&"):
                return a & b
            elif op in ("or", "|"):
                return a | b
            elif op in ("xor", "^"):
                return a ^ b
            elif op in ("shl", "<<"):
                return a << b if 0 <= b < 64 else None
            elif op in ("shr", ">>", "sar"):
                return a >> b if 0 <= b < 64 else None
        except Exception:
            return None
        return None

    def eliminate_dead_code(self, instrs: List[SSAInstruction]) -> List[SSAInstruction]:
        """Remove instructions whose destination register is never used, preserving side effects."""
        used_registers: set[str] = set()
        for instr in instrs:
            for arg in instr.args:
                if isinstance(arg, str):
                    used_registers.add(arg)

        # Retain instructions whose destination is read or is a root return/store/call
        retained: List[SSAInstruction] = []
        for i, instr in enumerate(instrs):
            # The last instruction is typically the return value or live sink
            is_sink = (i == len(instrs) - 1) or instr.op in ("ret", "store", "call")
            if is_sink or instr.dest in used_registers:
                retained.append(instr)

        return retained

    def calculate_cycle_speedup(
        self, original: List[SSAInstruction], optimized: List[SSAInstruction]
    ) -> float:
        """Calculate theoretical speedup (old_cycles / new_cycles)."""
        orig_ops = [i.op for i in original]
        opt_ops = [i.op for i in optimized]

        orig_cycles, _, _ = self.cost_model.estimate_sequence_cost(orig_ops)
        opt_cycles, _, _ = self.cost_model.estimate_sequence_cost(opt_ops)

        if opt_cycles <= 0.0:
            return 1.0 if orig_cycles <= 0.0 else float("inf")
        return round(orig_cycles / opt_cycles, 2)
