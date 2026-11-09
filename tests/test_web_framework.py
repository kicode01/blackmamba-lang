"""
Unit tests for TinyTalk Full-Stack Reactive Web Framework (tinytalk.web / bmb web).
Tests VNode, Style, Component primitives, render_page, WebApp, and CLI commands.
"""

import os
import sys
import tempfile
import unittest
import argparse
from tinytalk.web import (
    Style,
    VNode,
    Div,
    Container,
    Flex,
    Grid,
    Section,
    Card,
    H1,
    H2,
    H3,
    H4,
    Text,
    Paragraph,
    Link,
    CodeBlock,
    Button,
    Input,
    TextArea,
    Badge,
    Alert,
    ProgressBar,
    Divider,
    render_page,
    WebApp,
    scaffold_new_web_project,
    cmd_web,
)
from tinytalk.backends.html_backend import HtmlBackend
from tinytalk.cli import compile_source_to_mir


class TestMambaWebFramework(unittest.TestCase):

    def test_style_serialization(self):
        s = Style(
            display="flex",
            flex_direction="column",
            align_items="center",
            background_color="#0a0a0f",
            padding="24px",
            border_radius="12px",
            box_shadow="0 8px 32px rgba(0,0,0,0.4)",
        )
        css = s.to_css_string()
        self.assertIn("display: flex;", css)
        self.assertIn("flex-direction: column;", css)
        self.assertIn("align-items: center;", css)
        self.assertIn("background-color: #0a0a0f;", css)
        self.assertIn("padding: 24px;", css)
        self.assertIn("border-radius: 12px;", css)
        self.assertIn("box-shadow: 0 8px 32px rgba(0,0,0,0.4);", css)

    def test_vnode_basics_and_void_tags(self):
        # Normal tag without explicit style
        div = VNode("div", text="Hello BMB")
        html = div.render_html()
        self.assertEqual(html, "<div>Hello BMB</div>")

        # Void tag (input)
        inp = VNode("input", attrs={"type": "text", "placeholder": "Search..."})
        inp_html = inp.render_html()
        self.assertTrue(inp_html.startswith("<input") and inp_html.endswith("/>"))
        self.assertIn('placeholder="Search..."', inp_html)

        # Void tag (hr)
        hr = VNode("hr")
        self.assertEqual(hr.render_html(), "<hr />")

    def test_component_hierarchy(self):
        card = Card(padding=20, bg="#12121a", radius=8)
        title = H1("Cloud Metrics", color="#ffffff", font_size=24, font_weight="bold")
        badge = Badge("LIVE", background="rgba(0,255,136,0.15)", color="#00ff88")
        btn = Button("Refresh", bg="#00ff88", text_color="#041209", onclick="location.reload()")

        card.add_child(title)
        card.add_child(badge)
        card.add_child(btn)

        html = card.render_html()
        self.assertIn("Cloud Metrics", html)
        self.assertIn("LIVE", html)
        self.assertIn("Refresh", html)
        self.assertIn('onclick="location.reload()"', html)
        self.assertIn("background: #12121a;", html)

    def test_render_page_full_document(self):
        container = Container(max_width="1000px", padding=24)
        container.add_child(H1("Antigravity Portal"))
        container.add_child(Alert("Telemetry nominal", status="success"))
        container.add_child(ProgressBar(percent=75, color="#00ff88"))

        doc = render_page("System Status", container)
        self.assertIn("<!DOCTYPE html>", doc)
        self.assertIn("<title>System Status</title>", doc)
        self.assertIn("Antigravity Portal", doc)
        self.assertIn("Telemetry nominal", doc)
        self.assertIn("width: 75%;", doc)
        self.assertIn("Inter", doc)
        self.assertIn("Micro-Hydration Engine", doc)

    def test_web_app_routing_and_static_export(self):
        app = WebApp("My Multi-Page App")

        @app.page("/")
        def home_page():
            return Container(children=[H1("Home Screen"), Paragraph("Welcome home")])

        @app.page("/about")
        def about_page():
            return Container(children=[H1("About Us"), Paragraph("Zero-GC systems")])

        @app.api("/api/health")
        def health_api():
            return {"status": "ok", "uptime_ms": 12345}

        # Check in-memory route rendering
        home_html = app.render_route("/")
        self.assertIsNotNone(home_html)
        self.assertIn("Home Screen", home_html)

        about_html = app.render_route("/about")
        self.assertIsNotNone(about_html)
        self.assertIn("About Us", about_html)

        # Check static export to temp directory
        with tempfile.TemporaryDirectory() as tmp_dir:
            files = app.export_static(tmp_dir)
            self.assertEqual(len(files), 2)
            self.assertTrue(os.path.exists(os.path.join(tmp_dir, "index.html")))
            self.assertTrue(os.path.exists(os.path.join(tmp_dir, "about.html")))

    def test_scaffold_new_web_project(self):
        with tempfile.TemporaryDirectory() as tmp_dir:
            proj_path = os.path.join(tmp_dir, "test_proj")
            res = scaffold_new_web_project(proj_path)
            self.assertEqual(res, 0)
            app_bmb = os.path.join(proj_path, "app.tnt")
            self.assertTrue(os.path.exists(app_bmb))
            with open(app_bmb, "r", encoding="utf-8") as f:
                content = f.read()
            self.assertIn("from web import", content)
            self.assertIn("render_page", content)

    def test_fullstack_dashboard_compilation(self):
        dashboard_bmb = os.path.join(os.path.dirname(__file__), "..", "examples", "fullstack_dashboard.tnt")
        self.assertTrue(os.path.exists(dashboard_bmb), "examples/fullstack_dashboard.tnt must exist")

        with open(dashboard_bmb, "r", encoding="utf-8") as f:
            src = f.read()

        mir = compile_source_to_mir(src, dashboard_bmb)
        backend = HtmlBackend(mir, source=src)
        html = backend.render_to_html()

        self.assertIn("<!DOCTYPE html>", html)
        self.assertIn("Full-Stack Reactive Web Infrastructure", html)
        self.assertIn("8,209,363 req/s", html)
        self.assertIn("Hardware Telemetry & Slab Cache", html)
        self.assertIn("Deploy Microservice Now", html)
        self.assertIn("All 16 cores operating with 0.000 ms garbage-collection pause latency.", html)

    def test_cmd_web_build(self):
        dashboard_bmb = os.path.join(os.path.dirname(__file__), "..", "examples", "fullstack_dashboard.tnt")
        with tempfile.TemporaryDirectory() as tmp_dir:
            args = argparse.Namespace(
                action="build",
                file=dashboard_bmb,
                output=tmp_dir,
            )
            ret = cmd_web(args)
            self.assertEqual(ret, 0)
            out_file = os.path.join(tmp_dir, "index.html")
            self.assertTrue(os.path.exists(out_file))
            self.assertGreater(os.path.getsize(out_file), 5000)


if __name__ == "__main__":
    unittest.main()
