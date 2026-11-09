"""
Unit & Integration Tests for TinyTalk Phase 8A (v2.4.0):
- Fine-Grained Reactive Signals (Signal, Computed, Effect, batch)
- Reactive UI & WASM DOM Bindings (ReactiveNode, DOMPatch, compile_reactive_wasm_bundle)
- Embedded Autonomous Copilot & App Synthesizer (AutonomousAgent, bmb agent)
- Self-Healing AST Loop (AutonomousAgent.heal_module)
"""

import json
import os
import tempfile
import unittest
from io import StringIO
from unittest.mock import patch

from tinytalk.agent import AgentAction, AutonomousAgent, HealResult, SynthesisResult
from tinytalk.cli import main as bmb_main
from tinytalk.image import ImageManager
from tinytalk.reactive import (
    Computed,
    DOMPatch,
    Effect,
    ReactiveNode,
    ReactiveStore,
    Signal,
    batch,
    compile_reactive_wasm_bundle,
)


class TestPhase8AgentAndReactive(unittest.TestCase):
    def test_signal_basic_get_set_update(self) -> None:
        s = Signal(10, name="counter")
        self.assertEqual(s.get(), 10)
        self.assertEqual(s(), 10)
        self.assertEqual(s.value, 10)

        s.set(25)
        self.assertEqual(s.get(), 25)

        s.update(lambda v: v * 2)
        self.assertEqual(s.get(), 50)

    def test_computed_caching_and_invalidation(self) -> None:
        count = Signal(5, name="count")
        eval_counter = [0]

        def compute_squared():
            eval_counter[0] += 1
            return count.get() * count.get()

        sq = Computed(compute_squared, name="squared")
        self.assertEqual(sq.get(), 25)
        self.assertEqual(eval_counter[0], 1)

        # Accessing again without signal change uses cached value
        self.assertEqual(sq.get(), 25)
        self.assertEqual(eval_counter[0], 1)

        # Changing count invalidates computed
        count.set(10)
        self.assertEqual(sq.get(), 100)
        self.assertEqual(eval_counter[0], 2)

    def test_effect_auto_subscription_and_cleanup(self) -> None:
        s1 = Signal(2)
        s2 = Signal(3)
        runs: list[int] = []
        cleanups: list[int] = []

        def my_effect():
            val = s1.get() + s2.get()
            runs.append(val)
            def _cleanup():
                cleanups.append(val)
            return _cleanup

        eff = Effect(my_effect, name="sum_tracker")
        self.assertEqual(runs, [5])
        self.assertEqual(cleanups, [])

        # Update s1 triggers effect and previous cleanup
        s1.set(10)
        self.assertEqual(runs, [5, 13])
        self.assertEqual(cleanups, [5])

        # Dispose unbinds effect
        eff.dispose()
        s2.set(100)
        self.assertEqual(runs, [5, 13])
        self.assertEqual(cleanups, [5, 13])

    def test_batch_deferrals(self) -> None:
        a = Signal(1)
        b = Signal(2)
        results: list[int] = []

        Effect(lambda: results.append(a.get() + b.get()))
        self.assertEqual(results, [3])

        with batch():
            a.set(10)
            b.set(20)
            # Intermediate updates are deferred
            self.assertEqual(results, [3])

        # Runs exactly once after batch with final state
        self.assertEqual(results, [3, 30])

    def test_reactive_node_and_dom_patches(self) -> None:
        title_sig = Signal("Dashboard", name="title")
        count_sig = Signal(42, name="active_items")
        patches: list[DOMPatch] = []

        card = ReactiveNode(tag="div", id="card_1", classes=["bmb-card"])
        card.bind_text(count_sig, on_patch=lambda p: patches.append(p))

        html_out = card.render_html()
        self.assertIn('id="card_1"', html_out)
        self.assertIn('class="bmb-card"', html_out)

        count_sig.set(99)
        self.assertTrue(len(patches) > 0)
        self.assertEqual(patches[-1].action, "setText")
        self.assertEqual(patches[-1].value, "99")

    def test_reactive_store_and_wasm_bundle(self) -> None:
        store = ReactiveStore({"user": "Alice", "points": 100})
        self.assertEqual(store.get("user"), "Alice")
        self.assertEqual(store.get("points"), 100)

        store.set_signal("points", 150)
        self.assertEqual(store.get("points"), 150)

        bundle = compile_reactive_wasm_bundle(
            store=store,
            app_html="<h1 data-bmb-text='user'></h1><span data-bmb-text='points'></span>",
            title="Mamba Reactive App",
        )
        self.assertIn("<!DOCTYPE html>", bundle)
        self.assertIn("BmbState", bundle)
        self.assertIn('"user": "Alice"', bundle)
        self.assertIn('"points": 150', bundle)

    def test_autonomous_agent_synthesis_inventory_domain(self) -> None:
        with tempfile.TemporaryDirectory() as tmpdir:
            agent = AutonomousAgent(workspace_dir=tmpdir)
            res = agent.synthesize_app(
                goal="Build an inventory management dashboard with stock alerts",
                output_dir=tmpdir,
                snapshot_name="inventory_test.tntimg",
                verify=True,
            )
            self.assertTrue(res.tests_passed, msg=res.test_output)
            self.assertEqual(res.app_name, "inventory_hub")
            self.assertTrue(res.canvas_morphs > 0)
            self.assertIsNotNone(res.image_path)
            self.assertTrue(os.path.exists(res.image_path))

            # Verify saved snapshot rehydrates in < 5 ms
            loaded = ImageManager.load_image(res.image_path)
            try:
                self.assertIn("inventory_hub", loaded.modules)
                self.assertTrue(loaded.elapsed_ms < 5.0)
            finally:
                loaded.close()

    def test_autonomous_agent_synthesis_chat_domain(self) -> None:
        with tempfile.TemporaryDirectory() as tmpdir:
            agent = AutonomousAgent(workspace_dir=tmpdir)
            res = agent.synthesize_app(
                goal="Real-time live chat room with message counter",
                output_dir=tmpdir,
                snapshot_name="chat_test.tntimg",
                verify=True,
            )
            self.assertTrue(res.tests_passed, msg=res.test_output)
            self.assertEqual(res.app_name, "live_chat")
            self.assertIn("ChatMessage", res.source_bmb)

    def test_autonomous_agent_self_healing_pass(self) -> None:
        with tempfile.TemporaryDirectory() as tmpdir:
            src_file = os.path.join(tmpdir, "math_mod.tnt")
            with open(src_file, "w", encoding="utf-8") as f:
                f.write("""
fn compute(x: i64) -> i64:
    return x + 1
""")
            test_src = """
fn test_compute() -> void:
    res = compute(10)
    if res != 20:
        raise ValueError("compute did not return 20")

fn main() -> i64:
    test_compute()
    return 0
"""
            agent = AutonomousAgent(workspace_dir=tmpdir)
            heal_res = agent.heal_module(src_file, test_source=test_src)
            self.assertTrue(heal_res.is_healed)
            self.assertTrue(heal_res.verified_pass)
            self.assertIn("return x * 2", heal_res.output_source)

    def test_cli_bmb_agent_synthesis_json(self) -> None:
        with tempfile.TemporaryDirectory() as tmpdir:
            buf = StringIO()
            with patch("sys.stdout", buf):
                rc = bmb_main([
                    "agent",
                    "Build telemetry sensor monitor",
                    "--output", tmpdir,
                    "--json",
                ])
            self.assertEqual(rc, 0)
            data = json.loads(buf.getvalue())
            self.assertEqual(data["app_name"], "sensor_monitor")
            self.assertTrue(data["tests_passed"])
            self.assertTrue(data["canvas_morphs"] > 0)


if __name__ == "__main__":
    unittest.main()
