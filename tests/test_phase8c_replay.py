import os
import sys
import json
import tempfile
import unittest
from io import StringIO
from unittest.mock import patch

from mamba.replay import TimeTravelRecorder, ReplayTrace, OmniscientDebugger
from mamba.cli import main as bmb_main


class TestPhase8CTimeTravelReplay(unittest.TestCase):
    def setUp(self):
        self.tmpdir_obj = tempfile.TemporaryDirectory()
        self.tmpdir = self.tmpdir_obj.name

    def tearDown(self):
        self.tmpdir_obj.cleanup()

    def test_record_simple_math_and_loop(self):
        src = """
fn compute_sum(n: i64) -> i64:
    total = 0
    for i in 0..n:
        total = total + i
    return total

fn main() -> i64:
    res = compute_sum(5)
    return res
"""
        recorder = TimeTravelRecorder(capacity=5000, checkpoint_interval=5)
        trace = recorder.record_source(src, module_name="sum_test")

        self.assertEqual(trace.module_name, "sum_test")
        self.assertTrue(trace.total_steps > 15)
        self.assertTrue(len(trace.checkpoints) >= 2)
        self.assertTrue(trace.metadata.get("jit_verified", False))

        # Check final frame has total = 10 (0+1+2+3+4)
        debugger = OmniscientDebugger(trace)
        last_frame = debugger.jump_to_step(trace.total_steps - 1)
        self.assertEqual(last_frame.variables.get("total"), 10)
        self.assertEqual(last_frame.variables.get("res"), 10)

    def test_omniscient_debugger_stepping(self):
        src = """
fn main() -> i64:
    a = 1
    b = 2
    c = a + b
    return c
"""
        recorder = TimeTravelRecorder()
        trace = recorder.record_source(src)
        debugger = OmniscientDebugger(trace)

        self.assertEqual(debugger.cursor, 0)
        f0 = debugger.current_frame()
        self.assertEqual(f0.step_index, 0)

        # Step forward
        f1 = debugger.step_forward(1)
        self.assertEqual(f1.step_index, 1)

        f_end = debugger.step_forward(100)
        self.assertEqual(f_end.step_index, trace.total_steps - 1)

        # Step backward
        f_prev = debugger.step_backward(2)
        self.assertEqual(f_prev.step_index, trace.total_steps - 3)

        f_start = debugger.step_backward(100)
        self.assertEqual(f_start.step_index, 0)

    def test_omniscient_debugger_jump_to_step(self):
        src = """
fn main() -> i64:
    x = 100
    x = x + 50
    x = x * 2
    return x
"""
        recorder = TimeTravelRecorder()
        trace = recorder.record_source(src)
        debugger = OmniscientDebugger(trace)

        mid_step = trace.total_steps // 2
        frame = debugger.jump_to_step(mid_step)
        self.assertEqual(frame.step_index, mid_step)

        with self.assertRaises(IndexError):
            debugger.jump_to_step(trace.total_steps + 10)

    def test_omniscient_debugger_jump_to_line(self):
        src = """
fn main() -> i64:
    x = 1
    y = 2
    z = 3
    return z
"""
        recorder = TimeTravelRecorder()
        trace = recorder.record_source(src)
        debugger = OmniscientDebugger(trace)

        # Seek to line 5 (z = 3)
        frame = debugger.jump_to_line(5)
        self.assertIsNotNone(frame)
        self.assertEqual(frame.line_number, 5)

        # Seek backward to line 3 (x = 1)
        frame_back = debugger.jump_to_line(3, reverse=True)
        self.assertIsNotNone(frame_back)
        self.assertEqual(frame_back.line_number, 3)

    def test_variable_mutation_history(self):
        src = """
fn main() -> i64:
    count = 0
    count = 10
    count = 20
    count = 30
    return count
"""
        recorder = TimeTravelRecorder()
        trace = recorder.record_source(src)
        debugger = OmniscientDebugger(trace)

        history = debugger.query_variable_history("count")
        values = [h["value"] for h in history]
        self.assertEqual(values, [0, 10, 20, 30])

    def test_diff_steps(self):
        src = """
fn main() -> i64:
    val = 5
    multiplier = 10
    val = val * multiplier
    return val
"""
        recorder = TimeTravelRecorder()
        trace = recorder.record_source(src)
        debugger = OmniscientDebugger(trace)

        # Diff step 1 and last step
        diff = debugger.diff_steps(1, trace.total_steps - 1)
        self.assertTrue(diff["step_delta"] > 0)
        self.assertIn("val", diff["changed_variables"])
        self.assertEqual(diff["changed_variables"]["val"]["after"], 50)

    def test_arena_allocation_tracking(self):
        src = """
struct Point:
    x: i64 = 0
    y: i64 = 0

fn main() -> i64:
    p1 = Point(1, 2)
    p2 = Point(3, 4)
    return p1.x + p2.y
"""
        recorder = TimeTravelRecorder()
        trace = recorder.record_source(src)
        debugger = OmniscientDebugger(trace)

        # Should record arena allocations for p1 and p2
        alloc_frames = [f for f in trace.frames if f.event == "ARENA_ALLOC"]
        self.assertEqual(len(alloc_frames), 2)
        last_frame = debugger.jump_to_step(trace.total_steps - 1)
        self.assertEqual(last_frame.arena_generation, 2)

    def test_trace_save_and_load_roundtrip(self):
        src = """
fn main() -> i64:
    a = 42
    return a
"""
        recorder = TimeTravelRecorder()
        trace = recorder.record_source(src, module_name="test_rt")

        trace_file = os.path.join(self.tmpdir, "test.bmbreplay")
        bytes_written = trace.save(trace_file, compress=True)
        self.assertTrue(bytes_written > 0)

        loaded_trace = ReplayTrace.load(trace_file)
        self.assertEqual(loaded_trace.module_name, "test_rt")
        self.assertEqual(loaded_trace.total_steps, trace.total_steps)
        self.assertEqual(len(loaded_trace.frames), len(trace.frames))

    def test_export_interactive_html(self):
        src = """
fn main() -> i64:
    msg = 100
    return msg
"""
        recorder = TimeTravelRecorder()
        trace = recorder.record_source(src)
        debugger = OmniscientDebugger(trace)

        html_file = os.path.join(self.tmpdir, "debugger.html")
        out = debugger.export_interactive_html(html_file)
        self.assertTrue(os.path.exists(out))

        with open(html_file, "r", encoding="utf-8") as f:
            content = f.read()
        self.assertIn("Black Mamba Omniscient Debugger", content)
        self.assertIn("timelineSlider", content)
        self.assertIn("updateView", content)

    def test_cli_replay_record_and_inspect_json(self):
        src_path = os.path.join(self.tmpdir, "app.bmb")
        with open(src_path, "w", encoding="utf-8") as f:
            f.write("""
fn main() -> i64:
    counter = 1
    counter += 5
    return counter
""")
        trace_path = os.path.join(self.tmpdir, "app.bmbreplay")
        html_path = os.path.join(self.tmpdir, "app.html")

        # 1. Test CLI Record
        buf1 = StringIO()
        with patch("sys.stdout", buf1):
            rc1 = bmb_main([
                "replay", "record", src_path,
                "-o", trace_path,
                "--html", html_path,
                "--json",
            ])
        self.assertEqual(rc1, 0)
        rec_data = json.loads(buf1.getvalue())
        self.assertEqual(rec_data["module"], "app")
        self.assertTrue(rec_data["total_steps"] > 0)
        self.assertTrue(os.path.exists(trace_path))
        self.assertTrue(os.path.exists(html_path))

        # 2. Test CLI Inspect
        buf2 = StringIO()
        with patch("sys.stdout", buf2):
            rc2 = bmb_main([
                "replay", "inspect", trace_path,
                "--var", "counter",
                "--json",
            ])
        self.assertEqual(rc2, 0)
        hist_data = json.loads(buf2.getvalue())
        vals = [h["value"] for h in hist_data]
        self.assertEqual(vals, [1, 6])


if __name__ == "__main__":
    unittest.main()
