# Black Mamba Test Suite: Phase 9C (v3.2.0)
# Formal Codebase Specification & Property-Based Mutation Fuzzing

import unittest
import os
import json
from mamba.spec import (
    PropertyTestEngine,
    PropertyResult,
    IntegerStrategy,
    FloatStrategy,
    BooleanStrategy,
    StringStrategy,
    ListStrategy,
    integers,
    floats,
    booleans,
    strings,
    lists,
    AlgebraicLaws,
    SpecificationSynthesizer,
    benchmark_spec_engine,
)
from mamba.cli import compile_source_to_mir
from mamba.backends.x86_64_jit import NativeJITModule


class TestPhase9CSpecificationFuzzing(unittest.TestCase):
    """
    Validates QuickCheck/Hypothesis-style property testing, automated
    invariant exploration, counterexample shrinkage, and pure .bmb execution.
    """

    def setUp(self):
        self.engine = PropertyTestEngine(seed=1337)

    def test_01_generators_boundaries(self):
        """Verify strategies respect explicit min/max boundaries and types."""
        int_strat = integers(10, 50)
        float_strat = floats(0.5, 2.5)
        bool_strat = booleans()
        str_strat = strings(3, 8)
        list_strat = lists(integers(1, 5), min_size=2, max_size=6)

        import random
        rng = random.Random(42)

        for _ in range(100):
            iv = int_strat.generate(rng)
            self.assertTrue(10 <= iv <= 50)
            self.assertIsInstance(iv, int)

            fv = float_strat.generate(rng)
            self.assertTrue(0.5 <= fv <= 2.5)
            self.assertIsInstance(fv, float)

            bv = bool_strat.generate(rng)
            self.assertIn(bv, [True, False])

            sv = str_strat.generate(rng)
            self.assertTrue(3 <= len(sv) <= 8)

            lv = list_strat.generate(rng)
            self.assertTrue(2 <= len(lv) <= 6)
            for item in lv:
                self.assertTrue(1 <= item <= 5)

    def test_02_algebraic_laws_satisfaction(self):
        """Verify mathematical algebraic identities pass with 100% success."""
        strat = integers(-1000, 1000)

        # Addition laws
        r_comm = AlgebraicLaws.commutativity(self.engine, lambda a, b: a + b, strat, iters=150)
        self.assertTrue(r_comm.passed)
        self.assertEqual(r_comm.iterations_run, 150)

        r_assoc = AlgebraicLaws.associativity(self.engine, lambda a, b: a + b, strat, iters=150)
        self.assertTrue(r_assoc.passed)

        r_ident = AlgebraicLaws.identity(self.engine, lambda a, b: a + b, 0, strat, iters=150)
        self.assertTrue(r_ident.passed)

        # Multiplication laws
        r_mult_comm = AlgebraicLaws.commutativity(self.engine, lambda a, b: a * b, strat, iters=100)
        self.assertTrue(r_mult_comm.passed)

        r_mult_ident = AlgebraicLaws.identity(self.engine, lambda a, b: a * b, 1, strat, iters=100)
        self.assertTrue(r_mult_ident.passed)

        # Idempotence: abs(abs(x)) == abs(x)
        r_idemp = AlgebraicLaws.idempotence(self.engine, abs, strat, iters=100)
        self.assertTrue(r_idemp.passed)

        # Roundtrip: int(str(x)) == x
        r_roundtrip = AlgebraicLaws.roundtrip(self.engine, str, int, integers(0, 10000), iters=100)
        self.assertTrue(r_roundtrip.passed)

    def test_03_counterexample_shrinkage_minimization(self):
        """Verify failing properties are minimized to exact boundary conditions."""
        # 1. Integer threshold shrinkage: x < 50 should shrink to exact counterexample 50
        res_int = self.engine.for_all([integers(0, 500)], lambda x: x < 50, iterations=100)
        self.assertFalse(res_int.passed)
        self.assertEqual(res_int.counterexample, 50)
        self.assertGreater(res_int.shrink_steps, 0)

        # 2. String shrinkage: string without 'x'
        # Should shrink to a single 'x'
        strat_str = strings(0, 30)
        res_str = self.engine.for_all([strat_str], lambda s: 'x' not in s, iterations=200)
        if not res_str.passed:
            self.assertIn('x', res_str.counterexample)
            self.assertLessEqual(len(res_str.counterexample), len(res_str.original_counterexample))

        # 3. List shrinkage: list sum < 100
        res_list = self.engine.for_all([lists(integers(10, 20), 1, 15)], lambda lst: sum(lst) < 100, iterations=150)
        self.assertFalse(res_list.passed)
        self.assertGreaterEqual(sum(res_list.counterexample), 100)
        self.assertLessEqual(len(res_list.counterexample), len(res_list.original_counterexample))

    def test_04_specification_synthesizer(self):
        """Verify automated synthesis discovers algebraic laws and formal contracts."""
        synth = SpecificationSynthesizer(self.engine)

        # Synthesize laws for addition
        add_fn = lambda a, b: a + b
        add_fn.__name__ = "add"
        laws = synth.synthesize(add_fn, integers(-500, 500))
        law_names = [l.law_name for l in laws]

        self.assertIn("Commutativity", law_names)
        self.assertIn("Associativity", law_names)
        self.assertIn("ZeroIdentity", law_names)

        # Check formal contracts generated
        comm_law = next(l for l in laws if l.law_name == "Commutativity")
        self.assertIn("ensures(add(a, b) == add(b, a))", comm_law.formal_contract)

        # Synthesize laws for abs
        abs_fn = lambda x: abs(x)
        abs_fn.__name__ = "my_abs"
        abs_laws = synth.synthesize(abs_fn, integers(-500, 500))
        abs_names = [l.law_name for l in abs_laws]
        self.assertIn("Idempotence", abs_names)
        self.assertIn("NonNegativity", abs_names)

    def test_05_benchmark_spec_engine(self):
        """Verify property evaluation benchmark achieves high throughput."""
        bench = benchmark_spec_engine(iterations=500)
        self.assertEqual(bench["iterations"], 500)
        self.assertEqual(bench["total_properties_evaluated"], 1000)
        self.assertGreater(bench["properties_per_second"], 50000.0)
        self.assertTrue(bench["commutativity_verified"])
        self.assertTrue(bench["string_length_verified"])

    def test_06_pure_bmb_spec_module(self):
        """Verify pure .bmb stdlib module (spec.bmb) compiles to MIR and executes in JIT."""
        spec_bmb_path = os.path.join(os.path.dirname(__file__), "..", "mamba", "stdlib", "spec.bmb")
        self.assertTrue(os.path.exists(spec_bmb_path))

        with open(spec_bmb_path, "r", encoding="utf-8") as f:
            src = f.read()

        mir = compile_source_to_mir(src, filename="spec.bmb")
        self.assertIsNotNone(mir)
        self.assertGreaterEqual(len(mir.functions), 8)

        # Test JIT execution of spec functions
        jit_mod = NativeJITModule(mir)
        self.assertTrue(hasattr(jit_mod, "spec_check_commutativity_add"))
        self.assertTrue(hasattr(jit_mod, "spec_check_associativity_add"))
        self.assertTrue(hasattr(jit_mod, "spec_check_identity_add"))
        self.assertTrue(hasattr(jit_mod, "spec_find_minimal_counterexample"))

        # Test algebraic laws in JIT
        self.assertEqual(jit_mod.spec_check_commutativity_add(15, 30), 1)
        self.assertEqual(jit_mod.spec_check_associativity_add(10, 20, 30), 1)
        self.assertEqual(jit_mod.spec_check_identity_add(99), 1)

        # Test minimal counterexample shrinkage in JIT
        # For threshold=42 and start_val=100, counterexample must be 43
        min_ce = jit_mod.spec_find_minimal_counterexample(42, 100)
        self.assertEqual(min_ce, 43)


if __name__ == "__main__":
    unittest.main()
