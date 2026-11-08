# Black Mamba Specification & Property-Based Mutation Fuzzing Engine
# Phase 9C (v3.2.0): Automated Algebraic Invariant Exploration & Counterexample Minimization
# Provides QuickCheck/Hypothesis-style property testing with zero external dependencies.

import random
import time
import inspect
import string
from dataclasses import dataclass, field
from typing import Callable, Any, List, Dict, Optional, Tuple, Union


# ==============================================================================
# 1. Generators & Strategies
# ==============================================================================

class Strategy:
    """Base class for property-based generation strategies."""
    def generate(self, rng: random.Random) -> Any:
        raise NotImplementedError

    def shrink(self, failing_val: Any, test_fn: Callable[[Any], bool]) -> Any:
        """Shrink a failing value towards a minimal counterexample."""
        return failing_val


class IntegerStrategy(Strategy):
    def __init__(self, min_val: int = -1000, max_val: int = 1000):
        self.min_val = min_val
        self.max_val = max_val

    def generate(self, rng: random.Random) -> int:
        # Bias generation slightly towards boundary values (0, min, max, -1, 1)
        choice = rng.random()
        if choice < 0.05 and self.min_val <= 0 <= self.max_val:
            return 0
        elif choice < 0.08 and self.min_val <= 1 <= self.max_val:
            return 1
        elif choice < 0.11 and self.min_val <= -1 <= self.max_val:
            return -1
        elif choice < 0.14:
            return self.min_val
        elif choice < 0.17:
            return self.max_val
        return rng.randint(self.min_val, self.max_val)

    def shrink(self, failing_val: int, test_fn: Callable[[int], bool]) -> int:
        curr = failing_val
        # 1. Try 0 if in range
        if self.min_val <= 0 <= self.max_val and not test_fn(0):
            return 0

        # 2. Binary shrink towards 0 or boundary
        target = 0 if self.min_val <= 0 <= self.max_val else self.min_val
        while abs(curr - target) > 1:
            mid = (curr + target) // 2
            if not test_fn(mid):
                curr = mid
            else:
                # Step one unit closer
                step = -1 if curr > target else 1
                if not test_fn(curr + step):
                    curr = curr + step
                else:
                    break
        return curr


class FloatStrategy(Strategy):
    def __init__(self, min_val: float = -1000.0, max_val: float = 1000.0):
        self.min_val = min_val
        self.max_val = max_val

    def generate(self, rng: random.Random) -> float:
        choice = rng.random()
        if choice < 0.05 and self.min_val <= 0.0 <= self.max_val:
            return 0.0
        return round(rng.uniform(self.min_val, self.max_val), 6)

    def shrink(self, failing_val: float, test_fn: Callable[[float], bool]) -> float:
        if self.min_val <= 0.0 <= self.max_val and not test_fn(0.0):
            return 0.0
        curr = failing_val
        target = 0.0
        for _ in range(32):
            mid = (curr + target) / 2.0
            if not test_fn(mid):
                curr = mid
            else:
                target = mid
        return round(curr, 4)


class BooleanStrategy(Strategy):
    def generate(self, rng: random.Random) -> bool:
        return rng.choice([True, False])

    def shrink(self, failing_val: bool, test_fn: Callable[[bool], bool]) -> bool:
        if not test_fn(False):
            return False
        return failing_val


class StringStrategy(Strategy):
    def __init__(self, min_len: int = 0, max_len: int = 30, alphabet: Optional[str] = None):
        self.min_len = min_len
        self.max_len = max_len
        self.alphabet = alphabet or string.ascii_letters + string.digits

    def generate(self, rng: random.Random) -> str:
        length = rng.randint(self.min_len, self.max_len)
        return "".join(rng.choice(self.alphabet) for _ in range(length))

    def shrink(self, failing_val: str, test_fn: Callable[[str], bool]) -> str:
        if self.min_len == 0 and not test_fn(""):
            return ""
        curr = failing_val
        # Try binary halving
        while len(curr) > self.min_len:
            half = curr[:len(curr)//2]
            if len(half) >= self.min_len and not test_fn(half):
                curr = half
                continue
            # Try removing single characters from end
            shrunk = curr[:-1]
            if len(shrunk) >= self.min_len and not test_fn(shrunk):
                curr = shrunk
            else:
                break
        return curr


class ListStrategy(Strategy):
    def __init__(self, element_strat: Strategy, min_size: int = 0, max_size: int = 20):
        self.element_strat = element_strat
        self.min_size = min_size
        self.max_size = max_size

    def generate(self, rng: random.Random) -> list:
        size = rng.randint(self.min_size, self.max_size)
        return [self.element_strat.generate(rng) for _ in range(size)]

    def shrink(self, failing_val: list, test_fn: Callable[[list], bool]) -> list:
        if self.min_size == 0 and not test_fn([]):
            return []
        curr = list(failing_val)
        # Try halving list length
        while len(curr) > self.min_size:
            half = curr[:len(curr)//2]
            if len(half) >= self.min_size and not test_fn(half):
                curr = half
                continue
            # Try removing elements one by one
            improved = False
            for i in range(len(curr)):
                candidate = curr[:i] + curr[i+1:]
                if len(candidate) >= self.min_size and not test_fn(candidate):
                    curr = candidate
                    improved = True
                    break
            if not improved:
                break
        return curr


# Strategy factory functions
def integers(min_val: int = -1000, max_val: int = 1000) -> IntegerStrategy:
    return IntegerStrategy(min_val, max_val)

def floats(min_val: float = -1000.0, max_val: float = 1000.0) -> FloatStrategy:
    return FloatStrategy(min_val, max_val)

def booleans() -> BooleanStrategy:
    return BooleanStrategy()

def strings(min_len: int = 0, max_len: int = 30) -> StringStrategy:
    return StringStrategy(min_len, max_len)

def lists(elements: Strategy, min_size: int = 0, max_size: int = 20) -> ListStrategy:
    return ListStrategy(elements, min_size, max_size)


# ==============================================================================
# 2. Property Test Execution & Results
# ==============================================================================

@dataclass
class PropertyResult:
    passed: bool
    iterations_run: int
    property_name: str
    counterexample: Optional[Any] = None
    original_counterexample: Optional[Any] = None
    shrink_steps: int = 0
    elapsed_ms: float = 0.0
    error_message: Optional[str] = None

    def to_dict(self) -> Dict[str, Any]:
        return {
            "property": self.property_name,
            "passed": self.passed,
            "iterations_run": self.iterations_run,
            "counterexample": self.counterexample,
            "original_counterexample": self.original_counterexample,
            "shrink_steps": self.shrink_steps,
            "elapsed_ms": round(self.elapsed_ms, 3),
            "error_message": self.error_message,
        }


class PropertyTestEngine:
    """
    Executes randomized property tests, intercepts failures, and applies
    automatic counterexample shrinkage.
    """
    def __init__(self, seed: Optional[int] = None):
        self.seed = seed or int(time.time() * 1000) % 1000000
        self.rng = random.Random(self.seed)

    def for_all(
        self,
        strategies: List[Strategy],
        prop_fn: Callable[..., bool],
        iterations: int = 100,
        name: Optional[str] = None,
    ) -> PropertyResult:
        prop_name = name or getattr(prop_fn, "__name__", "anonymous_property")
        t0 = time.perf_counter()

        for i in range(iterations):
            args = [strat.generate(self.rng) for strat in strategies]
            try:
                success = prop_fn(*args)
            except Exception as e:
                success = False

            if not success:
                # Failure detected: start shrinkage
                orig_args = list(args)
                shrunk_args = list(args)
                steps = 0

                # Minimize each argument sequentially
                for idx, strat in enumerate(strategies):
                    def test_arg(candidate_val: Any) -> bool:
                        test_inputs = list(shrunk_args)
                        test_inputs[idx] = candidate_val
                        try:
                            return bool(prop_fn(*test_inputs))
                        except Exception:
                            return False

                    old_val = shrunk_args[idx]
                    new_val = strat.shrink(old_val, test_arg)
                    if new_val != old_val:
                        steps += 1
                        shrunk_args[idx] = new_val

                elapsed = (time.perf_counter() - t0) * 1000.0
                counter_val = shrunk_args[0] if len(shrunk_args) == 1 else tuple(shrunk_args)
                orig_val = orig_args[0] if len(orig_args) == 1 else tuple(orig_args)

                return PropertyResult(
                    passed=False,
                    iterations_run=i + 1,
                    property_name=prop_name,
                    counterexample=counter_val,
                    original_counterexample=orig_val,
                    shrink_steps=steps,
                    elapsed_ms=elapsed,
                    error_message=f"Property violated at iteration {i+1}",
                )

        elapsed = (time.perf_counter() - t0) * 1000.0
        return PropertyResult(
            passed=True,
            iterations_run=iterations,
            property_name=prop_name,
            elapsed_ms=elapsed,
        )


# ==============================================================================
# 3. Algebraic Invariants Verification Suite
# ==============================================================================

class AlgebraicLaws:
    """Verifies fundamental algebraic identities and structural invariants."""

    @staticmethod
    def commutativity(engine: PropertyTestEngine, fn: Callable[[Any, Any], Any], strat: Strategy, iters: int = 100) -> PropertyResult:
        def prop(a: Any, b: Any) -> bool:
            return fn(a, b) == fn(b, a)
        return engine.for_all([strat, strat], prop, iterations=iters, name=f"commutativity({fn.__name__})")

    @staticmethod
    def associativity(engine: PropertyTestEngine, fn: Callable[[Any, Any], Any], strat: Strategy, iters: int = 100) -> PropertyResult:
        def prop(a: Any, b: Any, c: Any) -> bool:
            return fn(fn(a, b), c) == fn(a, fn(b, c))
        return engine.for_all([strat, strat, strat], prop, iterations=iters, name=f"associativity({fn.__name__})")

    @staticmethod
    def identity(engine: PropertyTestEngine, fn: Callable[[Any, Any], Any], identity_elem: Any, strat: Strategy, iters: int = 100) -> PropertyResult:
        def prop(a: Any) -> bool:
            return fn(a, identity_elem) == a
        return engine.for_all([strat], prop, iterations=iters, name=f"identity({fn.__name__}, e={identity_elem})")

    @staticmethod
    def idempotence(engine: PropertyTestEngine, fn: Callable[[Any], Any], strat: Strategy, iters: int = 100) -> PropertyResult:
        def prop(a: Any) -> bool:
            return fn(fn(a)) == fn(a)
        return engine.for_all([strat], prop, iterations=iters, name=f"idempotence({fn.__name__})")

    @staticmethod
    def roundtrip(engine: PropertyTestEngine, encode_fn: Callable[[Any], Any], decode_fn: Callable[[Any], Any], strat: Strategy, iters: int = 100) -> PropertyResult:
        def prop(a: Any) -> bool:
            return decode_fn(encode_fn(a)) == a
        return engine.for_all([strat], prop, iterations=iters, name=f"roundtrip({encode_fn.__name__} <-> {decode_fn.__name__})")


# ==============================================================================
# 4. Automated Specification Synthesizer
# ==============================================================================

@dataclass
class SynthesizedLaw:
    law_name: str
    verified: bool
    description: str
    formal_contract: str


class SpecificationSynthesizer:
    """
    Synthesizes algebraic laws and formal contracts from functions through
    automated invariant discovery.
    """
    def __init__(self, engine: Optional[PropertyTestEngine] = None):
        self.engine = engine or PropertyTestEngine()

    def synthesize(self, fn: Callable, strat: Optional[Strategy] = None) -> List[SynthesizedLaw]:
        strat = strat or integers(-500, 500)
        sig = inspect.signature(fn)
        param_count = len(sig.parameters)
        fn_name = fn.__name__
        laws: List[SynthesizedLaw] = []

        if param_count == 1:
            # Check Idempotence: f(f(x)) == f(x)
            res_idemp = AlgebraicLaws.idempotence(self.engine, fn, strat, iters=80)
            if res_idemp.passed:
                laws.append(SynthesizedLaw(
                    law_name="Idempotence",
                    verified=True,
                    description=f"{fn_name}({fn_name}(x)) == {fn_name}(x)",
                    formal_contract=f"ensures({fn_name}(result) == result)",
                ))

            # Check Non-negative output
            res_nonneg = self.engine.for_all([strat], lambda x: fn(x) >= 0, iterations=80, name="non_negative")
            if res_nonneg.passed:
                laws.append(SynthesizedLaw(
                    law_name="NonNegativity",
                    verified=True,
                    description=f"{fn_name}(x) >= 0 for all x",
                    formal_contract="ensures(result >= 0)",
                ))

        elif param_count == 2:
            # Check Commutativity: f(a, b) == f(b, a)
            res_comm = AlgebraicLaws.commutativity(self.engine, fn, strat, iters=80)
            if res_comm.passed:
                laws.append(SynthesizedLaw(
                    law_name="Commutativity",
                    verified=True,
                    description=f"{fn_name}(a, b) == {fn_name}(b, a)",
                    formal_contract=f"ensures({fn_name}(a, b) == {fn_name}(b, a))",
                ))

            # Check Associativity: f(f(a, b), c) == f(a, f(b, c))
            res_assoc = AlgebraicLaws.associativity(self.engine, fn, strat, iters=80)
            if res_assoc.passed:
                laws.append(SynthesizedLaw(
                    law_name="Associativity",
                    verified=True,
                    description=f"{fn_name}({fn_name}(a, b), c) == {fn_name}(a, {fn_name}(b, c))",
                    formal_contract=f"ensures({fn_name}({fn_name}(a, b), c) == {fn_name}(a, {fn_name}(b, c)))",
                ))

            # Check Identity with 0
            res_ident0 = AlgebraicLaws.identity(self.engine, fn, 0, strat, iters=80)
            if res_ident0.passed:
                laws.append(SynthesizedLaw(
                    law_name="ZeroIdentity",
                    verified=True,
                    description=f"{fn_name}(a, 0) == a",
                    formal_contract=f"ensures({fn_name}(a, 0) == a)",
                ))

            # Check Identity with 1
            res_ident1 = AlgebraicLaws.identity(self.engine, fn, 1, strat, iters=80)
            if res_ident1.passed:
                laws.append(SynthesizedLaw(
                    law_name="UnitIdentity",
                    verified=True,
                    description=f"{fn_name}(a, 1) == a",
                    formal_contract=f"ensures({fn_name}(a, 1) == a)",
                ))

        return laws


# ==============================================================================
# 5. Benchmarking & Stress Testing
# ==============================================================================

def benchmark_spec_engine(iterations: int = 1000) -> Dict[str, Any]:
    engine = PropertyTestEngine(seed=42)
    strat_int = integers(-10000, 10000)
    strat_str = strings(0, 20)

    t0 = time.perf_counter()
    res1 = engine.for_all([strat_int, strat_int], lambda a, b: (a + b) == (b + a), iterations=iterations)
    res2 = engine.for_all([strat_str], lambda s: len(s) >= 0, iterations=iterations)
    total_time = time.perf_counter() - t0

    total_props_run = iterations * 2
    ops_per_sec = total_props_run / total_time if total_time > 0 else 0.0

    return {
        "iterations": iterations,
        "total_properties_evaluated": total_props_run,
        "total_elapsed_seconds": round(total_time, 6),
        "properties_per_second": round(ops_per_sec, 1),
        "commutativity_verified": res1.passed,
        "string_length_verified": res2.passed,
    }
