"""
Unit Tests and Adversarial Fuzzer for TinyTalk Superoptimizer (Phase 12A)
========================================================================
Tests CPU cost model latency calculations, SSA peephole optimizations,
dead code elimination, and adversarial randomized expression equivalence.
"""

from __future__ import annotations
import unittest
import random
from tinytalk.superopt import (
    CPUCostModel,
    PeepholeOptimizer,
    SSAInstruction,
    CPU_ARCH_PROFILES
)
import tinytalk.superopt as mamba_superopt


class TestSuperoptimizer(unittest.TestCase):
    """Test suite for Phase 12A Superoptimizer and Hardware Cost Modeling."""

    def setUp(self):
        self.zen4_model = CPUCostModel("zen4")
        self.skylake_model = CPUCostModel("skylake")
        self.apple_model = CPUCostModel("apple_m")
        self.optimizer = PeepholeOptimizer(self.zen4_model)

    def test_cpu_cost_model_profiles(self):
        """Test CPU latency and throughput tables across microarchitectures."""
        # Zen 4
        zen_div = self.zen4_model.instruction_cost("idiv")
        self.assertEqual(zen_div.latency_cycles, 14.0)
        self.assertEqual(zen_div.reciprocal_throughput, 10.0)

        # Skylake division is significantly slower (24 cycles)
        sky_div = self.skylake_model.instruction_cost("idiv")
        self.assertEqual(sky_div.latency_cycles, 24.0)

        # Apple M series
        apple_add = self.apple_model.instruction_cost("add")
        self.assertEqual(apple_add.latency_cycles, 1.0)
        self.assertEqual(apple_add.reciprocal_throughput, 0.125)

        # Sequence cost estimation
        seq = ["mov", "add", "imul", "ret"]
        est_cycles, total_lat, total_bytes = self.zen4_model.estimate_sequence_cost(seq)
        self.assertGreater(est_cycles, 0.0)
        self.assertEqual(total_bytes, 2 + 3 + 4 + 1)

    def test_algebraic_identities(self):
        """Test basic arithmetic identities (x + 0, x - x, x * 0, x * 1)."""
        # x + 0 -> x
        instrs = [
            SSAInstruction("v0", "arg", [0]),
            SSAInstruction("c0", "const", [0]),
            SSAInstruction("v1", "add", ["v0", "c0"])
        ]
        opt = self.optimizer.optimize_instructions(instrs)
        self.assertEqual(opt[-1].op, "mov")
        self.assertEqual(opt[-1].args, ["v0"])

        # x - x -> 0
        instrs = [
            SSAInstruction("v0", "arg", [0]),
            SSAInstruction("v1", "sub", ["v0", "v0"])
        ]
        opt = self.optimizer.optimize_instructions(instrs)
        self.assertEqual(opt[-1].op, "const")
        self.assertEqual(opt[-1].args, [0])

        # x * 0 -> 0
        instrs = [
            SSAInstruction("v0", "arg", [0]),
            SSAInstruction("c0", "const", [0]),
            SSAInstruction("v1", "mul", ["v0", "c0"])
        ]
        opt = self.optimizer.optimize_instructions(instrs)
        self.assertEqual(opt[-1].op, "const")
        self.assertEqual(opt[-1].args, [0])

    def test_strength_reduction_multiplication(self):
        """Test reduction of multiplication by powers of 2 to bitwise shifts (x * 8 -> x << 3)."""
        instrs = [
            SSAInstruction("v0", "arg", [0]),
            SSAInstruction("c8", "const", [8]),
            SSAInstruction("v1", "imul", ["v0", "c8"])
        ]
        opt = self.optimizer.optimize_instructions(instrs)
        self.assertEqual(opt[-1].op, "shl")
        self.assertEqual(opt[-1].args, ["v0", 3])

        # Multiplication by 64 -> shift left 6
        instrs64 = [
            SSAInstruction("v0", "arg", [0]),
            SSAInstruction("c64", "const", [64]),
            SSAInstruction("v1", "imul", ["c64", "v0"])
        ]
        opt64 = self.optimizer.optimize_instructions(instrs64)
        self.assertEqual(opt64[-1].op, "shl")
        self.assertEqual(opt64[-1].args, ["v0", 6])

    def test_strength_reduction_division_and_modulo(self):
        """Test reduction of division and modulo by powers of 2 to shifts and bitwise masks."""
        # x / 16 -> x >> 4
        instrs_div = [
            SSAInstruction("v0", "arg", [0]),
            SSAInstruction("c16", "const", [16]),
            SSAInstruction("v1", "idiv", ["v0", "c16"])
        ]
        opt_div = self.optimizer.optimize_instructions(instrs_div)
        self.assertEqual(opt_div[-1].op, "shr")
        self.assertEqual(opt_div[-1].args, ["v0", 4])

        # x % 32 -> x & 31
        instrs_mod = [
            SSAInstruction("v0", "arg", [0]),
            SSAInstruction("c32", "const", [32]),
            SSAInstruction("v1", "mod", ["v0", "c32"])
        ]
        opt_mod = self.optimizer.optimize_instructions(instrs_mod)
        self.assertEqual(opt_mod[-1].op, "and")
        self.assertEqual(opt_mod[-1].args, ["v0", 31])

    def test_bitwise_identities(self):
        """Test bitwise simplification rules (x ^ x -> 0, x & x -> x, x | x -> x)."""
        # x ^ x -> 0
        instrs_xor = [
            SSAInstruction("v0", "arg", [0]),
            SSAInstruction("v1", "xor", ["v0", "v0"])
        ]
        opt_xor = self.optimizer.optimize_instructions(instrs_xor)
        self.assertEqual(opt_xor[-1].op, "const")
        self.assertEqual(opt_xor[-1].args, [0])

        # x & x -> x
        instrs_and = [
            SSAInstruction("v0", "arg", [0]),
            SSAInstruction("v1", "and", ["v0", "v0"])
        ]
        opt_and = self.optimizer.optimize_instructions(instrs_and)
        self.assertEqual(opt_and[-1].op, "mov")
        self.assertEqual(opt_and[-1].args, ["v0"])

    def test_constant_folding(self):
        """Test multi-step constant propagation and folding."""
        instrs = [
            SSAInstruction("c1", "const", [15]),
            SSAInstruction("c2", "const", [25]),
            SSAInstruction("v0", "add", ["c1", "c2"]),     # 40
            SSAInstruction("c3", "const", [2]),
            SSAInstruction("v1", "mul", ["v0", "c3"])       # 80
        ]
        opt = self.optimizer.optimize_instructions(instrs)
        self.assertEqual(opt[-1].op, "const")
        self.assertEqual(opt[-1].args, [80])

    def test_dead_code_elimination(self):
        """Test removal of unreferenced intermediate instructions."""
        instrs = [
            SSAInstruction("dead1", "const", [999]),
            SSAInstruction("dead2", "imul", ["dead1", "dead1"]),
            SSAInstruction("live_arg", "arg", [0]),
            SSAInstruction("c10", "const", [10]),
            SSAInstruction("res", "add", ["live_arg", "c10"])
        ]
        opt = self.optimizer.optimize_instructions(instrs)
        dests = [i.dest for i in opt]
        self.assertNotIn("dead1", dests)
        self.assertNotIn("dead2", dests)
        self.assertIn("res", dests)

    def test_cycle_speedup_calculation(self):
        """Verify cycle speedup calculation for division strength reduction."""
        orig = [
            SSAInstruction("v0", "arg", [0]),
            SSAInstruction("c16", "const", [16]),
            SSAInstruction("v1", "idiv", ["v0", "c16"])
        ]
        opt = self.optimizer.optimize_instructions(orig)
        speedup = self.optimizer.calculate_cycle_speedup(orig, opt)
        # idiv takes 14 cycles, shr takes 1 cycle -> > 5x speedup
        self.assertGreater(speedup, 3.0)

    def test_adversarial_fuzzer(self):
        """
        Adversarial fuzz testing: Generate 100 randomized arithmetic & bitwise graphs,
        optimize them, and verify semantic equivalence against original evaluation.
        """
        rng = random.Random(42)

        def eval_instrs(instructions: list[SSAInstruction], input_val: int) -> int:
            env: dict[str, int] = {"arg0": input_val}
            for instr in instructions:
                op = instr.op
                if op == "const":
                    env[instr.dest] = instr.args[0]
                elif op == "arg":
                    env[instr.dest] = env["arg0"]
                elif op == "mov":
                    src = instr.args[0]
                    env[instr.dest] = env.get(src, src if isinstance(src, int) else 0)
                elif op == "add":
                    a = env[instr.args[0]]
                    b = env[instr.args[1]] if isinstance(instr.args[1], str) else instr.args[1]
                    env[instr.dest] = a + b
                elif op == "sub":
                    a = env[instr.args[0]]
                    b = env[instr.args[1]] if isinstance(instr.args[1], str) else instr.args[1]
                    env[instr.dest] = a - b
                elif op in ("mul", "imul"):
                    a = env[instr.args[0]]
                    b = env[instr.args[1]] if isinstance(instr.args[1], str) else instr.args[1]
                    env[instr.dest] = a * b
                elif op == "shl":
                    a = env[instr.args[0]]
                    shift = instr.args[1] if isinstance(instr.args[1], int) else env[instr.args[1]]
                    env[instr.dest] = a << (shift & 63)
                elif op in ("shr", "idiv"):
                    a = env[instr.args[0]]
                    b = instr.args[1] if isinstance(instr.args[1], int) else env[instr.args[1]]
                    if op == "shr":
                        env[instr.dest] = a >> (b & 63)
                    else:
                        env[instr.dest] = a // b if b != 0 else 0
                elif op in ("and", "or", "xor"):
                    a = env[instr.args[0]]
                    b = env[instr.args[1]] if isinstance(instr.args[1], str) else instr.args[1]
                    if op == "and":
                        env[instr.dest] = a & b
                    elif op == "or":
                        env[instr.dest] = a | b
                    elif op == "xor":
                        env[instr.dest] = a ^ b
            return env[instructions[-1].dest]

        powers_of_two = [1, 2, 4, 8, 16, 32, 64]

        for _ in range(100):
            # Generate random instruction sequence
            instrs = [SSAInstruction("v0", "arg", [0])]
            curr_reg = "v0"

            steps = rng.randint(2, 6)
            for s in range(steps):
                target_reg = f"v{s+1}"
                op_type = rng.choice(["mul_pow2", "add_zero", "xor_self", "add_const", "sub_self"])

                if op_type == "mul_pow2":
                    p = rng.choice(powers_of_two)
                    c_name = f"c_{s}_{p}"
                    instrs.append(SSAInstruction(c_name, "const", [p]))
                    instrs.append(SSAInstruction(target_reg, "imul", [curr_reg, c_name]))
                elif op_type == "add_zero":
                    c_name = f"c_zero_{s}"
                    instrs.append(SSAInstruction(c_name, "const", [0]))
                    instrs.append(SSAInstruction(target_reg, "add", [curr_reg, c_name]))
                elif op_type == "xor_self":
                    instrs.append(SSAInstruction(target_reg, "xor", [curr_reg, curr_reg]))
                elif op_type == "add_const":
                    val = rng.randint(1, 100)
                    c_name = f"c_val_{s}"
                    instrs.append(SSAInstruction(c_name, "const", [val]))
                    instrs.append(SSAInstruction(target_reg, "add", [curr_reg, c_name]))
                elif op_type == "sub_self":
                    instrs.append(SSAInstruction(target_reg, "sub", [curr_reg, curr_reg]))

                curr_reg = target_reg

            # Optimize with Superoptimizer
            opt_instrs = self.optimizer.optimize_instructions(instrs)

            # Assert execution cost is strictly non-increasing
            orig_cost, _, _ = self.zen4_model.estimate_sequence_cost([i.op for i in instrs])
            opt_cost, _, _ = self.zen4_model.estimate_sequence_cost([i.op for i in opt_instrs])
            self.assertLessEqual(opt_cost, orig_cost + 1e-6)

            # Test semantic equivalence across random test inputs
            for test_val in [0, 1, 7, 16, 42, 255]:
                orig_res = eval_instrs(instrs, test_val)
                opt_res = eval_instrs(opt_instrs, test_val)
                self.assertEqual(orig_res, opt_res, f"Fuzzer mismatch for input {test_val} on {instrs}")

    def test_backward_compatibility_shim(self):
        """Verify tinytalk.superopt forwards cleanly to tinytalk.superopt."""
        self.assertIs(mamba_superopt.CPUCostModel, CPUCostModel)
        self.assertIs(mamba_superopt.PeepholeOptimizer, PeepholeOptimizer)
        self.assertIs(mamba_superopt.SSAInstruction, SSAInstruction)


if __name__ == "__main__":
    unittest.main()
