import os
import unittest
import tempfile
import subprocess
from mamba.backends.html_backend import HtmlBackend
from mamba.cli import compile_source_to_mir


class TestHtmlBackendAndSelfHostedSite(unittest.TestCase):
    """
    Tests for the Black Mamba HTML5 compiler backend (--target html)
    and the self-hosted .bmb website source files.
    """

    def setUp(self):
        self.workspace_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
        self.landing_bmb = os.path.join(self.workspace_dir, "website_src", "landing.bmb")
        self.arena_bmb = os.path.join(self.workspace_dir, "website_src", "arena.bmb")

    def test_html_backend_basic_emission(self):
        """Verifies HtmlBackend can take a .bmb MIR module and emit an HTML5 file."""
        src = """
def main() -> i64:
    print("<div class='mamba-test'>Black Mamba SSR Running</div>")
    return 0
"""
        mir = compile_source_to_mir(src, "ssr_test.bmb")
        backend = HtmlBackend(mir, source=src, title="Test SSR Page")
        html = backend.render_to_html()

        self.assertIn("<!DOCTYPE html>", html)
        self.assertIn("<div class='mamba-test'>Black Mamba SSR Running</div>", html)
        self.assertIn("Test SSR Page", html)

    def test_landing_bmb_compilation_and_content(self):
        """Verifies website_src/landing.bmb compiles to valid HTML5 with self-hosted dogfood badge."""
        self.assertTrue(os.path.exists(self.landing_bmb), "website_src/landing.bmb must exist")
        with open(self.landing_bmb, "r", encoding="utf-8") as f:
            src = f.read()

        mir = compile_source_to_mir(src, self.landing_bmb)
        backend = HtmlBackend(mir, source=src)
        html = backend.render_to_html()

        self.assertIn("<!DOCTYPE html>", html)
        self.assertIn("Black Mamba", html)
        self.assertIn("SELF-HOSTED .BMB", html)
        self.assertIn("dogfood-banner", html)

    def test_arena_bmb_compilation_and_content(self):
        """Verifies website_src/arena.bmb compiles to valid HTML5 with arena features."""
        self.assertTrue(os.path.exists(self.arena_bmb), "website_src/arena.bmb must exist")
        with open(self.arena_bmb, "r", encoding="utf-8") as f:
            src = f.read()

        mir = compile_source_to_mir(src, self.arena_bmb)
        backend = HtmlBackend(mir, source=src)
        html = backend.render_to_html()

        self.assertIn("<!DOCTYPE html>", html)
        self.assertIn("bmbEditor", html)
        self.assertIn("tabViewWebPreview", html)
        self.assertIn("tabViewInquisitor", html)

    def test_cli_build_target_html(self):
        """Verifies that running `python bmb.py build <file.bmb> --target html` succeeds."""
        with tempfile.NamedTemporaryFile("w", suffix=".bmb", delete=False, encoding="utf-8") as tf:
            tf.write("""
def main() -> i64:
    print("<h1>CLI HTML Target Verified</h1>")
    return 0
""")
            tf_path = tf.name

        out_html = tf_path.replace(".bmb", ".html")
        try:
            cmd = ["python", "bmb.py", "build", tf_path, "--target", "html", "-o", out_html]
            res = subprocess.run(cmd, cwd=self.workspace_dir, capture_output=True, text=True)
            self.assertEqual(res.returncode, 0, f"CLI build failed: {res.stderr}\n{res.stdout}")
            self.assertTrue(os.path.exists(out_html), "Output HTML file should exist")
            with open(out_html, "r", encoding="utf-8") as f:
                content = f.read()
            self.assertIn("CLI HTML Target Verified", content)
        finally:
            if os.path.exists(tf_path):
                os.remove(tf_path)
            if os.path.exists(out_html):
                os.remove(out_html)


if __name__ == "__main__":
    unittest.main()
