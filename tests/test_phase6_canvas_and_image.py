import os
import sqlite3
import tempfile
import unittest

from tinytalk.backends.x86_64_jit import NativeJITModule
from tinytalk.canvas import MorphicCanvas
from tinytalk.cli import compile_source_to_mir, main as cli_main
from tinytalk.image import ImageManager


def run_jit_captured(source: str) -> str:
    outputs = []
    mir = compile_source_to_mir(source)
    jit = NativeJITModule(mir, output_callback=lambda s: outputs.append(s))
    try:
        jit.run_main()
    finally:
        jit.close()
    return "".join(outputs)


class TestPhase6MorphicCanvasAndPersistentImage(unittest.TestCase):
    SAMPLE_APP = """
struct Thermostat:
    target_temp: f64 = 21.5
    current_temp: f64 = 19.0

fn compute_heating_power(target: f64, current: f64) -> f64:
    diff = target - current
    if diff <= 0.0:
        return 0.0
    return diff * 10.0
"""

    def test_morphic_canvas_graph_and_bidirectional_visual_ast_binding(self):
        canvas = MorphicCanvas.from_source(self.SAMPLE_APP, module_name="hvac")
        try:
            self.assertIn("inspector:Thermostat", canvas.morphs)
            self.assertIn("code:compute_heating_power", canvas.morphs)
            self.assertIn("widget:Thermostat.target_temp", canvas.morphs)

            # Pan/zoom & move morph
            canvas.set_viewport(120.0, -40.0, 1.25)
            self.assertEqual(canvas.zoom, 1.25)
            moved = canvas.move_morph("code:compute_heating_power", 450.0, 90.0)
            self.assertEqual((moved.x, moved.y), (450.0, 90.0))

            # Add DatabaseTableMorph
            db_morph = canvas.add_database_table_morph(
                "sensor_logs",
                [("id", "INTEGER"), ("temp", "REAL")],
                [{"id": 1, "temp": 20.1}, {"id": 2, "temp": 21.4}],
            )
            self.assertEqual(db_morph.kind, "db_table")

            # 1. Bidirectional Visual -> AST binding: drag UIWidgetMorph slider to 25.75
            sync_res = canvas.mutate_widget_to_ast("widget:Thermostat.target_temp", 25.75)
            self.assertTrue(sync_res.success)
            self.assertIn("target_temp: f64 = 25.75", canvas.source)
            self.assertEqual(canvas.live_app_state["Thermostat.target_temp"], 25.75)

            # 2. Live CodeMorph Hot-Swap: call live JIT function before & after hot-swapping
            canvas.live_app_state["session_id"] = "live_session_42"
            before_val = canvas.call_live_function("compute_heating_power", 25.0, 20.0)
            self.assertAlmostEqual(before_val, 50.0)

            swap_res = canvas.hot_swap_code_morph(
                "code:compute_heating_power",
                "@F compute_heating_power(target:f,current:f)->f:\n ^ (target - current) * 20.0",
            )
            self.assertTrue(swap_res.success)
            after_val = canvas.call_live_function("compute_heating_power", 25.0, 20.0)
            self.assertAlmostEqual(after_val, 100.0)
            # Verify live application state was preserved across the function hot-swap
            self.assertEqual(canvas.live_app_state["session_id"], "live_session_42")
            self.assertEqual(canvas.live_app_state["Thermostat.target_temp"], 25.75)

            html_doc = canvas.render_html()
            self.assertIn("TinyTalk Morphic Canvas", html_doc)
            self.assertIn("Thermostat", html_doc)
        finally:
            canvas.close()

    def test_smalltalk_persistent_image_save_and_sub_5ms_resume(self):
        canvas = MorphicCanvas.from_source(self.SAMPLE_APP, module_name="hvac")
        canvas.set_viewport(80.0, 40.0, 1.5)
        canvas.live_app_state["active_zone"] = "penthouse"
        canvas.live_app_state["setpoint"] = 23.5

        mem_db = sqlite3.connect(":memory:")
        mem_db.execute("CREATE TABLE telemetry (id INTEGER PRIMARY KEY, zone TEXT, temp REAL)")
        mem_db.execute("INSERT INTO telemetry VALUES (1, 'penthouse', 22.8)")
        mem_db.execute("INSERT INTO telemetry VALUES (2, 'lobby', 20.4)")
        mem_db.commit()

        try:
            with tempfile.TemporaryDirectory() as tmpdir:
                img_path = os.path.join(tmpdir, "workspace.tntimg")
                save_rep = ImageManager.save_image(
                    img_path,
                    canvas=canvas,
                    heap_objects={"controller_gain": 12.5, "online": True},
                    db_source=mem_db,
                    compress=False,
                )
                self.assertTrue(os.path.exists(img_path))
                self.assertGreater(save_rep.size_bytes, 100)
                self.assertEqual(save_rep.table_count, 1)

                # Resume snapshot and verify < 5 ms instant resume + 100% state fidelity
                loaded = ImageManager.load_image(img_path)
                try:
                    self.assertLess(loaded.elapsed_ms, 5.0)
                    self.assertEqual(loaded.heap_objects["controller_gain"], 12.5)
                    self.assertEqual(loaded.heap_objects["active_zone"], "penthouse")
                    self.assertIsNotNone(loaded.canvas)
                    self.assertEqual(loaded.canvas.zoom, 1.5)
                    self.assertIn("inspector:Thermostat", loaded.canvas.morphs)

                    # Verify SQLite table rows were restored into in-memory DB
                    cur = loaded.sqlite_conn.cursor()
                    cur.execute("SELECT zone, temp FROM telemetry ORDER BY id")
                    rows = cur.fetchall()
                    self.assertEqual(rows, [("penthouse", 22.8), ("lobby", 20.4)])
                finally:
                    loaded.close()

                # Verify SHA-256 tamper detection
                with open(img_path, "r+b") as f:
                    f.seek(-4, os.SEEK_END)
                    f.write(b"XXXX")
                with self.assertRaises(ValueError):
                    ImageManager.load_image(img_path)
        finally:
            canvas.close()
            mem_db.close()

    def test_cli_studio_canvas_and_image_subcommands(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            src_path = os.path.join(tmpdir, "app.tnt")
            html_path = os.path.join(tmpdir, "canvas.html")
            img_path = os.path.join(tmpdir, "app.tntimg")
            restored_src = os.path.join(tmpdir, "restored.tnt")
            with open(src_path, "w", encoding="utf-8") as f:
                f.write(self.SAMPLE_APP)

            self.assertEqual(cli_main(["studio", src_path, "--canvas", "--export", html_path]), 0)
            self.assertTrue(os.path.exists(html_path))

            self.assertEqual(cli_main(["image", "save", img_path, "--file", src_path]), 0)
            self.assertTrue(os.path.exists(img_path))
            self.assertEqual(cli_main(["image", "inspect", img_path]), 0)
            self.assertEqual(cli_main(["image", "load", img_path, "--export-source", restored_src]), 0)
            self.assertTrue(os.path.exists(restored_src))

    def test_native_stdlib_canvas_and_image_bmb(self):
        src = """
import canvas
import image

card = canvas.make_morph_card("c1", "code", "tnt://app/step", 10.0, 20.0, 300.0, 180.0)
canvas.translate_morph(card, 15.5, 4.5)
vp = canvas.CanvasViewport(50.0, 50.0, 2.0)
wx = canvas.screen_to_world_x(vp, 150.0)

meta = image.make_image_meta(2, 8, 1, 5, 0.42)
print(card.bounds.x)
print(card.bounds.y)
print(wx)
print(meta.header.magic)
print(image.is_valid_image_magic(meta.header.magic))
"""
        out = run_jit_captured(src).strip().splitlines()
        self.assertEqual(out, ["25.5", "24.5", "50.0", "BMBIMG01", "True"])


if __name__ == "__main__":
    unittest.main()
