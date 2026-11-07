import os
import unittest
import subprocess
from mamba.parser import Parser
from mamba.lexer import Lexer
from mamba.ast_nodes import StructDef, FuncDef

class TestDeclarativeWebAndInquisitor(unittest.TestCase):
    """
    Tests for Black Mamba Declarative Web & CSS Engine (web.bmb)
    and the Offline Inquisitor Symbolic App Architect.
    """

    def setUp(self):
        self.workspace_dir = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
        self.web_bmb_path = os.path.join(self.workspace_dir, "mamba", "stdlib", "web.bmb")
        self.bmbc_wasm_path = os.path.join(self.workspace_dir, "website", "bmbc_wasm.js")

    def test_web_bmb_stdlib_syntax_and_ast(self):
        """Verifies that mamba/stdlib/web.bmb is syntactically valid and parses into an AST."""
        self.assertTrue(os.path.exists(self.web_bmb_path), "web.bmb must exist")
        with open(self.web_bmb_path, "r", encoding="utf-8") as f:
            source = f.read()

        tokens = list(Lexer(source).tokenize())
        self.assertGreater(len(tokens), 50, "Should have lexed tokens from web.bmb")

        # Verify Parser constructs AST module cleanly
        mod = Parser.from_source(source).parse_module()
        self.assertIsNotNone(mod, "Parsed module should not be None")
        class_names = [s.name for s in mod.statements if isinstance(s, StructDef)]
        self.assertIn("Style", class_names)
        self.assertIn("VNode", class_names)

        fn_names = [s.name for s in mod.statements if isinstance(s, FuncDef)]
        self.assertIn("Div", fn_names)
        self.assertIn("Flex", fn_names)
        self.assertIn("Card", fn_names)
        self.assertIn("H1", fn_names)
        self.assertIn("Text", fn_names)
        self.assertIn("Button", fn_names)
        self.assertIn("Badge", fn_names)

    def test_inquisitor_offline_synthesis_all_domains(self):
        """Executes Node test verifying all 4 Inquisitor app domains synthesize and run offline."""
        test_script = f"""
        const path = require('path');
        const bmbcPath = {repr(self.bmbc_wasm_path.replace(os.sep, '/'))};
        require(bmbcPath);
        const compiler = globalThis.MambaCompiler;
        if (!compiler || !compiler.Inquisitor) {{
            process.exit(1);
        }}
        const domains = ['web_dashboard', 'quant_terminal', 'edge_ai', 'serverless_api'];
        for (const d of domains) {{
            const synth = compiler.Inquisitor.synthesizeApp({{ domain: d }});
            if (!synth || !synth.bmb) process.exit(2);
            const res = compiler.executeBmbSourceInBrowser(synth.bmb);
            if (!res.ok || res.returnValue !== 0 || !res.htmlOutput) {{
                console.error("Failed on domain:", d, res.error);
                process.exit(3);
            }}
        }}
        console.log("ALL_INQUISITOR_TESTS_OK");
        """
        proc = subprocess.run(["node", "-e", test_script], capture_output=True, text=True)
        self.assertEqual(proc.returncode, 0, f"Inquisitor node test failed: {proc.stderr}\n{proc.stdout}")
        self.assertIn("ALL_INQUISITOR_TESTS_OK", proc.stdout)

    def test_web_component_preset_in_arena(self):
        """Verifies arena.html includes preset 11 and inquisitor inspector tab."""
        arena_path = os.path.join(self.workspace_dir, "website", "arena.html")
        with open(arena_path, "r", encoding="utf-8") as f:
            arena_html = f.read()

        self.assertIn('value="web_component"', arena_html)
        self.assertIn('tabViewWebPreview', arena_html)
        self.assertIn('tabViewInquisitor', arena_html)
        self.assertIn('viewWebPreview', arena_html)
        self.assertIn('viewInquisitor', arena_html)
        self.assertIn('runInquisitorSynthesis', arena_html)

if __name__ == "__main__":
    unittest.main()
