# Black Mamba Test Suite: Phase 9E (v3.4.0)
# Native Asynchronous Fiber Runtime & M:N Work-Stealing Scheduler

import unittest
import os
import time
from mamba.fiber import (
    Fiber,
    FiberState,
    WorkStealingScheduler,
    benchmark_fiber_scheduler,
)
from mamba.cli import compile_source_to_mir
from mamba.backends.x86_64_jit import NativeJITModule


class TestPhase9EFiberRuntime(unittest.TestCase):
    """
    Validates cooperative green fibers, Chase-Lev work stealing,
    M:N multithreaded scheduling, and pure .bmb fiber execution.
    """

    def test_01_fiber_lifecycle(self):
        """Verify lifecycle state transitions: CREATED -> RUNNABLE -> WAITING -> TERMINATED."""
        def simple_task():
            yield 1
            yield 2
            return 42

        fib = Fiber(fiber_id=1, target=simple_task)
        self.assertEqual(fib.state, FiberState.CREATED)

        fib.initialize()
        self.assertEqual(fib.state, FiberState.RUNNABLE)

        st1 = fib.resume()
        self.assertEqual(st1, FiberState.WAITING)
        self.assertEqual(fib.yield_count, 1)

        st2 = fib.resume()
        self.assertEqual(st2, FiberState.WAITING)
        self.assertEqual(fib.yield_count, 2)

        st3 = fib.resume()
        self.assertEqual(st3, FiberState.TERMINATED)
        self.assertEqual(fib.result, 42)

    def test_02_work_stealing_scheduler(self):
        """Verify M:N scheduler completes concurrent fibers across worker deques."""
        sched = WorkStealingScheduler(num_workers=4)
        results = []

        def worker_fiber(idx: int):
            for i in range(3):
                yield i
            results.append(idx * 10)
            return idx * 10

        for i in range(20):
            sched.spawn(worker_fiber, i)

        sched.run_all()
        self.assertEqual(len(results), 20)
        self.assertEqual(sched.total_fibers_spawned, 20)
        self.assertEqual(sched.total_context_switches, 80)  # 20 * (3 yields + 1 term)

    def test_03_work_stealing_balance(self):
        """Verify worker queues steal from busy queues when starved."""
        sched = WorkStealingScheduler(num_workers=4)

        # Force all fibers into queue 0
        def busy_fiber():
            yield 1
            yield 2
            return "done"

        for _ in range(12):
            fib = Fiber(fiber_id=sched.total_fibers_spawned + 1, target=busy_fiber)
            sched.total_fibers_spawned += 1
            sched.active_fibers[fib.fiber_id] = fib
            sched.queues[0].append(fib)

        self.assertEqual(len(sched.queues[0]), 12)
        self.assertEqual(len(sched.queues[1]), 0)

        # Step worker 1: should steal from worker 0
        stealth = sched.step(1)
        self.assertTrue(stealth)
        self.assertLess(len(sched.queues[0]), 12)

    def test_04_benchmark_fiber_scheduler(self):
        """Verify fiber benchmark throughput and latency bounds."""
        res = benchmark_fiber_scheduler(fiber_count=1000, context_switches=5000)
        self.assertEqual(res["fibers_spawned"], 1000)
        self.assertTrue(res["all_terminated"])
        self.assertGreater(res["context_switches_per_second"], 50000.0)

    def test_05_pure_bmb_fiber_module(self):
        """Verify pure .bmb stdlib module compiles to MIR and executes in native JIT."""
        fiber_path = os.path.join(os.path.dirname(__file__), "..", "mamba", "stdlib", "fiber.bmb")
        self.assertTrue(os.path.exists(fiber_path))

        with open(fiber_path, "r", encoding="utf-8") as f:
            src = f.read()

        mir = compile_source_to_mir(src, filename="fiber.bmb")
        self.assertIsNotNone(mir)
        self.assertGreaterEqual(len(mir.functions), 6)

        jit_mod = NativeJITModule(mir)
        self.assertTrue(hasattr(jit_mod, "fiber_benchmark_switches"))
        self.assertTrue(hasattr(jit_mod, "fiber_new"))

        # Run 1000 cooperative context switches in JIT
        switches = jit_mod.fiber_benchmark_switches(1000)
        self.assertEqual(switches, 2000)  # 2 fibers * 1000 iterations


if __name__ == "__main__":
    unittest.main()
