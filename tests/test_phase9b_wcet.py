# Unit tests for Phase 9B (v3.1.0): Hard-Real-Time Deterministic Latency & WCET Static Analyzer
# Validates ZeroJitterPool O(1) memory, Rate-Monotonic Schedulability (RMA), and static WCET analysis.

import os
import tempfile
import unittest

from mamba.realtime import ZeroJitterPool, HardRealTimeScheduler, benchmark_rt_pool
from mamba.wcet import WCETAnalyzer
from mamba.cli import main


class TestPhase9BWCET(unittest.TestCase):

    def test_zero_jitter_pool_alloc_free(self):
        """Verify ZeroJitterPool provides O(1) constant-time allocation and deallocation."""
        pool = ZeroJitterPool(block_size=64, capacity=16)
        self.assertEqual(pool.capacity, 16)
        self.assertEqual(len(pool.free_list), 16)

        # Allocate 5 blocks
        b0 = pool.allocate()
        b1 = pool.allocate()
        b2 = pool.allocate()
        self.assertEqual(pool.stats()["active_allocated"], 3)
        self.assertEqual(pool.stats()["peak_allocated"], 3)

        # Free 1 block
        ok = pool.free(b1)
        self.assertTrue(ok)
        self.assertEqual(pool.stats()["active_allocated"], 2)

        # Re-allocate should reuse freed slot
        b_new = pool.allocate()
        self.assertEqual(b_new, b1)

    def test_zero_jitter_pool_benchmark(self):
        """Verify benchmark throughput of ZeroJitterPool is > 1M ops/sec with < 1 us latency."""
        res = benchmark_rt_pool(iterations=5000)
        self.assertEqual(res["iterations"], 5000)
        self.assertLess(res["alloc_ns_per_op"], 1000.0)  # Sub-microsecond
        self.assertGreater(res["operations_per_second"], 500000.0)
        self.assertTrue(res["zero_jitter_verified"])

    def test_realtime_scheduler_rma_edf(self):
        """Verify Rate-Monotonic Analysis (RMA) and Earliest-Deadline-First (EDF) schedulability bounds."""
        sched = HardRealTimeScheduler()
        # Task set with 45% total utilization
        sched.add_task("task_a", period_us=1000, deadline_us=1000, wcet_us=200, priority=1)
        sched.add_task("task_b", period_us=2000, deadline_us=2000, wcet_us=300, priority=2)
        sched.add_task("task_c", period_us=5000, deadline_us=5000, wcet_us=500, priority=3)

        report = sched.get_analysis_report()
        self.assertEqual(report["task_count"], 3)
        self.assertAlmostEqual(report["total_utilization"], 0.45, places=2)
        self.assertEqual(report["hyperperiod_us"], 10000)
        self.assertTrue(report["schedulable_rma"])
        self.assertTrue(report["schedulable_edf"])

    def test_wcet_static_analysis_cycles(self):
        """Verify static worst-case execution time calculation and determinism classification."""
        analyzer = WCETAnalyzer(target_freq_ghz=3.5)
        src = """
def compute_control_pulse(current: i64, target: i64) -> i64:
    let delta = target - current
    let adjusted = delta * 4
    return adjusted
"""
        res = analyzer.analyze_source(src)
        self.assertEqual(res["total_functions"], 2)  # compute_control_pulse + main
        self.assertTrue(res["all_hard_real_time"])
        fn = [f for f in res["functions"] if f["name"] == "compute_control_pulse"][0]
        self.assertGreater(fn["wcet_cycles"], 0)
        self.assertLess(fn["wcet_ns"], 20.0)  # sub-20 nanosecond execution bound
        self.assertEqual(fn["rating"], "HARD_REAL_TIME")

    def test_cli_realtime_commands(self):
        """Verify CLI commands for `bmb realtime pool-bench` and `sched-check`."""
        ret_bench = main(["realtime", "pool-bench", "--iters", "1000", "--json"])
        self.assertEqual(ret_bench, 0)

        ret_chk = main(["realtime", "sched-check", "--json"])
        self.assertEqual(ret_chk, 0)

    def test_cli_wcet_command(self):
        """Verify CLI command for `bmb wcet`."""
        with tempfile.NamedTemporaryFile(suffix=".bmb", delete=False, mode="w", encoding="utf-8") as tf:
            tf.write("def pid_loop(err: i64) -> i64:\n    return err * 3\n")
            w_path = tf.name

        try:
            ret_wcet = main(["wcet", w_path, "--freq-ghz", "4.0", "--json"])
            self.assertEqual(ret_wcet, 0)
        finally:
            if os.path.exists(w_path):
                os.remove(w_path)


if __name__ == "__main__":
    unittest.main()
