"""
Unit and Integration Tests for Black Mamba Smalltalk Studio & Inquisitor Agent
File: tests/test_studio.py

Verifies:
1. Smalltalk System Browser AST Introspection (Categories, Structs, Methods, Source extraction)
2. Live Object Inspector & Memory Map Reflection (Offsets, Register Unboxing, 0B Heap)
3. Socratic Inquisitor Agent (Offline questionnaire, multi-domain code synthesis, AST verification)
4. Scratchpad Workspace Evaluator
5. Studio HTTP REST API Endpoints (/api/system, /api/eval, /api/inquisitor/synthesize, /api/inspect)
6. Frontend Artifact Integrity (website/studio.html & website/studio_client.js)
"""

import json
import os
import subprocess
import threading
import time
import unittest
import urllib.request
import urllib.error
import http.server

from mamba.studio import (
    StudioSystemModel,
    StudioInspector,
    StudioWorkspace,
    StudioRequestHandler,
)
from mamba.inquisitor import InquisitorEngine
from mamba.parser import Parser


class TestStudioAndInquisitor(unittest.TestCase):

    def setUp(self):
        self.workspace_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
        self.studio_html_path = os.path.join(self.workspace_dir, "website", "studio.html")
        self.studio_js_path = os.path.join(self.workspace_dir, "website", "studio_client.js")

    def test_system_browser_hierarchy(self):
        """Verifies 4-column Smalltalk system hierarchy extracts categories, structs, and methods."""
        model = StudioSystemModel(self.workspace_dir)
        hierarchy = model.get_system_hierarchy()

        self.assertIn("Kernel & Core", hierarchy)
        self.assertIn("GUI & Smalltalk Morphic", hierarchy)
        self.assertIn("Data Science & Series", hierarchy)
        self.assertIn("Networking & Web", hierarchy)

        # Verify GUI structs
        gui_structs = hierarchy["GUI & Smalltalk Morphic"]
        struct_names = [s["name"] for s in gui_structs]
        self.assertTrue(any("GuiWindow" in name or "GuiWidget" in name for name in struct_names),
                        f"Expected GuiWindow in {struct_names}")

        # Check method extraction
        for s in gui_structs:
            if s["methods"]:
                first_m = s["methods"][0]
                self.assertIn("name", first_m)
                self.assertIn("source", first_m)
                self.assertIn("line", first_m)
                self.assertGreater(first_m["line"], 0)
                break

    def test_live_object_inspector(self):
        """Verifies field offsets, unboxed registers, and memory calculations."""
        fields = [
            {"name": "id", "type": "i64"},
            {"name": "x", "type": "f64"},
            {"name": "y", "type": "f64"},
            {"name": "tag", "type": "str"}
        ]
        insp = StudioInspector.inspect_struct("Particle", fields)

        self.assertEqual(insp["struct_name"], "Particle")
        self.assertGreaterEqual(insp["total_bytes"], 32)
        self.assertEqual(insp["heap_allocation"], "0 Bytes (Unboxed In-Register or Lexical Arena)")
        self.assertTrue(insp["sso_eligible"])

        inspected_fields = insp["fields"]
        self.assertEqual(len(inspected_fields), 4)
        self.assertEqual(inspected_fields[0]["register_storage"], "RAX/RCX")
        self.assertEqual(inspected_fields[1]["register_storage"], "XMM")

    def test_scratchpad_workspace_eval(self):
        """Verifies syntax check and AST statement counting in workspace evaluator."""
        code_valid = """
struct Point:
    x: f64
    y: f64

def main() -> i64:
    let p = Point(10.0, 20.0)
    return 0
"""
        res = StudioWorkspace.eval_snippet(code_valid)
        self.assertTrue(res["ok"])
        self.assertIsNone(res["error"])
        self.assertGreater(res["statements_count"], 0)
        self.assertGreater(res["elapsed_ms"], 0.0)

        code_invalid = "def broken(:"
        res_err = StudioWorkspace.eval_snippet(code_invalid)
        self.assertFalse(res_err["ok"])
        self.assertIn("Syntax Error", res_err["error"])

    def test_inquisitor_engine_all_domains(self):
        """Verifies Socratic questionnaire and deterministic synthesis across all domains."""
        q = InquisitorEngine.get_questionnaire()
        self.assertGreaterEqual(len(q), 4)

        domains = ["gui_app", "data_pipeline", "game_physics", "network_api"]
        themes = ["emerald", "titanium", "amber"]

        for d in domains:
            for t in themes:
                synth = InquisitorEngine.synthesize_app({
                    "domain": d,
                    "state_model": "counter_state",
                    "interactions": "button_clicks",
                    "theme": t
                })
                self.assertTrue(synth["valid"], f"Synthesis failed for domain {d}: {synth.get('error')}")
                self.assertIsNotNone(synth["bmb"])
                self.assertIn("BLACK MAMBA", synth["bmb"])
                self.assertGreater(len(synth["invariants"]), 0)

                # Verify clean parsing into AST module
                mod = Parser.from_source(synth["bmb"]).parse_module()
                self.assertIsNotNone(mod)

    def test_studio_rest_api_server(self):
        """Spins up a lightweight local Studio server on ephemeral port and tests endpoints."""
        port = 8991
        httpd = http.server.HTTPServer(("127.0.0.1", port), StudioRequestHandler)
        t = threading.Thread(target=httpd.serve_forever, daemon=True)
        t.start()
        time.sleep(0.3)

        base_url = f"http://127.0.0.1:{port}"

        try:
            # 1. GET /api/system
            req = urllib.request.Request(f"{base_url}/api/system")
            with urllib.request.urlopen(req, timeout=10.0) as resp:
                self.assertEqual(resp.status, 200)
                data = json.loads(resp.read().decode("utf-8"))
                self.assertIn("Kernel & Core", data)

            # 2. GET /api/inquisitor/questions
            req = urllib.request.Request(f"{base_url}/api/inquisitor/questions")
            with urllib.request.urlopen(req, timeout=10.0) as resp:
                self.assertEqual(resp.status, 200)
                data = json.loads(resp.read().decode("utf-8"))
                self.assertEqual(data["status"], "ok")
                self.assertGreater(len(data["questions"]), 0)

            # 3. POST /api/inspect
            post_body = json.dumps({
                "struct_name": "Vec3",
                "fields": [{"name": "x", "type": "f64"}, {"name": "y", "type": "f64"}]
            }).encode("utf-8")
            req = urllib.request.Request(f"{base_url}/api/inspect", data=post_body, headers={"Content-Type": "application/json"})
            with urllib.request.urlopen(req, timeout=10.0) as resp:
                self.assertEqual(resp.status, 200)
                data = json.loads(resp.read().decode("utf-8"))
                self.assertEqual(data["struct_name"], "Vec3")
                self.assertEqual(data["total_bytes"], 16)

            # 4. POST /api/inquisitor/synthesize
            post_body = json.dumps({"answers": {"domain": "gui_app", "theme": "emerald"}}).encode("utf-8")
            req = urllib.request.Request(f"{base_url}/api/inquisitor/synthesize", data=post_body, headers={"Content-Type": "application/json"})
            with urllib.request.urlopen(req, timeout=10.0) as resp:
                self.assertEqual(resp.status, 200)
                data = json.loads(resp.read().decode("utf-8"))
                self.assertTrue(data["valid"])
                self.assertIn("Smalltalk", data["title"])

        finally:
            httpd.shutdown()
            httpd.server_close()

    def test_studio_frontend_files_and_syntax(self):
        """Verifies website/studio.html and website/studio_client.js integrity and Node syntax."""
        self.assertTrue(os.path.exists(self.studio_html_path), "website/studio.html must exist")
        self.assertTrue(os.path.exists(self.studio_js_path), "website/studio_client.js must exist")

        self.assertGreater(os.path.getsize(self.studio_html_path), 5000, "studio.html should be substantial")
        self.assertGreater(os.path.getsize(self.studio_js_path), 5000, "studio_client.js should be substantial")

        # Verify Node syntax check
        proc = subprocess.run(["node", "-c", self.studio_js_path], capture_output=True, text=True)
        self.assertEqual(proc.returncode, 0, f"studio_client.js has syntax error: {proc.stderr}")


if __name__ == "__main__":
    unittest.main()
