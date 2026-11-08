"""
Black Mamba (bmb) Documentation Generator — HTML / CSS / JS Renderer.
Generates self-contained, responsive, searchable static documentation sites.
"""

import html
import json
import os
from typing import List
from .extractor import ConstDoc, FuncDoc, ModuleDoc, PackageDoc, StructDoc


def _escape(text: str) -> str:
    """HTML escapes string content."""
    return html.escape(text or "")


def _format_markdown_like(text: str) -> str:
    """Simple parser turning backticks into code tags and paragraphs into <p>."""
    if not text:
        return ""
    escaped = _escape(text)
    # Simple backtick replacement `code` -> <code>code</code>
    import re
    formatted = re.sub(r"`([^`]+)`", r"<code>\1</code>", escaped)
    lines = [l.strip() for l in formatted.splitlines() if l.strip()]
    return "".join(f"<p>{l}</p>" for l in lines)


def render_html_documentation(package_doc: PackageDoc) -> str:
    """Renders complete standalone HTML page for a package and its modules."""

    # Build client-side search index
    search_index = []
    for mod in package_doc.modules:
        search_index.append({
            "name": mod.name,
            "kind": "module",
            "module": mod.name,
            "doc": mod.doc[:120],
            "href": f"#mod-{mod.name}",
        })
        for s in mod.structs:
            search_index.append({
                "name": s.name,
                "kind": "struct",
                "module": mod.name,
                "doc": s.doc[:120],
                "href": f"#struct-{mod.name}-{s.name}",
            })
        for fn in mod.funcs:
            search_index.append({
                "name": fn.name,
                "kind": "function",
                "module": mod.name,
                "doc": fn.doc[:120],
                "href": f"#fn-{mod.name}-{fn.name}",
            })
        for c in mod.constants:
            search_index.append({
                "name": c.name,
                "kind": "constant",
                "module": mod.name,
                "doc": c.doc[:120],
                "href": f"#const-{mod.name}-{c.name}",
            })

    search_json = json.dumps(search_index)

    css = """
:root {
    --bg-main: #0d1117;
    --bg-card: #161b22;
    --bg-header: #161b22;
    --border: #30363d;
    --text-main: #c9d1d9;
    --text-muted: #8b949e;
    --accent: #58a6ff;
    --keyword: #ff7b72;
    --type: #79c0ff;
    --func: #d2a8ff;
    --string: #a5d6ff;
    --badge-bg: #21262d;
    --font-mono: ui-monospace, SFMono-Regular, SF Mono, Menlo, Consolas, Liberation Mono, monospace;
    --font-sans: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
}
* { box-sizing: border-box; margin: 0; padding: 0; }
body {
    background: var(--bg-main);
    color: var(--text-main);
    font-family: var(--font-sans);
    line-height: 1.6;
    display: flex;
    flex-direction: column;
    min-height: 100vh;
}
header {
    background: var(--bg-header);
    border-bottom: 1px solid var(--border);
    padding: 1rem 2rem;
    display: flex;
    align-items: center;
    justify-content: space-between;
    position: sticky;
    top: 0;
    z-index: 100;
}
.brand {
    display: flex;
    align-items: center;
    gap: 0.75rem;
}
.brand h1 {
    font-size: 1.25rem;
    font-weight: 600;
    color: #f0f6fc;
}
.badge {
    background: var(--badge-bg);
    border: 1px solid var(--border);
    padding: 0.15rem 0.5rem;
    border-radius: 9999px;
    font-size: 0.75rem;
    font-family: var(--font-mono);
    color: var(--accent);
}
.search-box {
    position: relative;
    width: 320px;
}
.search-box input {
    width: 100%;
    background: var(--bg-main);
    border: 1px solid var(--border);
    border-radius: 6px;
    padding: 0.5rem 0.75rem;
    color: var(--text-main);
    font-family: var(--font-sans);
    font-size: 0.875rem;
    outline: none;
}
.search-box input:focus {
    border-color: var(--accent);
}
.container {
    display: flex;
    flex: 1;
}
sidebar {
    width: 280px;
    background: var(--bg-header);
    border-right: 1px solid var(--border);
    padding: 1.5rem 1rem;
    overflow-y: auto;
    position: sticky;
    top: 65px;
    height: calc(100vh - 65px);
}
sidebar h3 {
    font-size: 0.75rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
    color: var(--text-muted);
    margin: 1rem 0 0.5rem 0.5rem;
}
sidebar ul {
    list-style: none;
}
sidebar li a {
    display: block;
    padding: 0.35rem 0.5rem;
    border-radius: 4px;
    color: var(--text-main);
    text-decoration: none;
    font-size: 0.875rem;
    font-family: var(--font-mono);
}
sidebar li a:hover {
    background: rgba(88, 166, 255, 0.1);
    color: var(--accent);
}
main {
    flex: 1;
    padding: 2rem 3rem;
    max-width: 1000px;
}
.module-section {
    margin-bottom: 3rem;
    padding-bottom: 2rem;
    border-bottom: 1px solid var(--border);
}
.module-header {
    margin-bottom: 1.5rem;
}
.module-title {
    font-size: 1.75rem;
    color: #f0f6fc;
    margin-bottom: 0.5rem;
}
.doc-text {
    color: var(--text-muted);
    font-size: 0.95rem;
    margin-bottom: 1rem;
}
.doc-text p {
    margin-bottom: 0.5rem;
}
.card {
    background: var(--bg-card);
    border: 1px solid var(--border);
    border-radius: 6px;
    padding: 1.25rem;
    margin-bottom: 1.5rem;
}
.card-title {
    display: flex;
    align-items: baseline;
    justify-content: space-between;
    margin-bottom: 0.75rem;
}
.card-title h3 {
    font-family: var(--font-mono);
    font-size: 1.1rem;
    color: #f0f6fc;
}
.kind-tag {
    font-size: 0.75rem;
    padding: 0.15rem 0.4rem;
    border-radius: 4px;
    font-family: var(--font-mono);
    text-transform: uppercase;
}
.kind-fn { background: rgba(210, 168, 255, 0.15); color: var(--func); }
.kind-struct { background: rgba(121, 192, 255, 0.15); color: var(--type); }
.kind-const { background: rgba(240, 136, 62, 0.15); color: #f0883e; }
.signature {
    background: var(--bg-main);
    border: 1px solid var(--border);
    border-radius: 6px;
    padding: 0.75rem 1rem;
    font-family: var(--font-mono);
    font-size: 0.9rem;
    overflow-x: auto;
    margin-bottom: 1rem;
}
.kw { color: var(--keyword); }
.typ { color: var(--type); }
.fnm { color: var(--func); }
.param-table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 0.75rem;
    font-size: 0.875rem;
}
.param-table th, .param-table td {
    padding: 0.5rem 0.75rem;
    text-align: left;
    border-bottom: 1px solid var(--border);
}
.param-table th {
    color: var(--text-muted);
    font-weight: 500;
}
.param-name {
    font-family: var(--font-mono);
    color: #f0f6fc;
}
.param-type {
    font-family: var(--font-mono);
    color: var(--type);
}
"""

    js = f"""
const SEARCH_INDEX = {search_json};

function initSearch() {{
    const input = document.getElementById('search-input');
    const resultsContainer = document.getElementById('sidebar-search-results');
    const defaultNav = document.getElementById('sidebar-default-nav');

    if (!input) return;

    input.addEventListener('input', (e) => {{
        const q = e.target.value.trim().toLowerCase();
        if (!q) {{
            resultsContainer.style.display = 'none';
            defaultNav.style.display = 'block';
            return;
        }}

        const matches = SEARCH_INDEX.filter(item => 
            item.name.toLowerCase().includes(q) ||
            item.module.toLowerCase().includes(q) ||
            item.doc.toLowerCase().includes(q)
        ).slice(0, 20);

        resultsContainer.innerHTML = '';
        if (matches.length === 0) {{
            resultsContainer.innerHTML = '<li style="padding: 0.5rem; color: var(--text-muted);">No matches found</li>';
        }} else {{
            matches.forEach(item => {{
                const li = document.createElement('li');
                li.innerHTML = `<a href="${{item.href}}"><span>${{item.name}}</span> <small style="color: var(--text-muted);">(${{item.kind}})</small></a>`;
                resultsContainer.appendChild(li);
            }});
        }}

        defaultNav.style.display = 'none';
        resultsContainer.style.display = 'block';
    }});

    // Shortcut: Press '/' to focus search box
    window.addEventListener('keydown', (e) => {{
        if (e.key === '/' && document.activeElement !== input) {{
            e.preventDefault();
            input.focus();
        }}
    }});
}}

window.addEventListener('DOMContentLoaded', initSearch);
"""

    # Build Module Sections
    module_sections = []
    sidebar_modules = []
    sidebar_structs = []
    sidebar_funcs = []

    for mod in package_doc.modules:
        sidebar_modules.append(f'<li><a href="#mod-{mod.name}">{mod.name}</a></li>')

        mod_structs_html = []
        for s in mod.structs:
            sidebar_structs.append(f'<li><a href="#struct-{mod.name}-{s.name}">{s.name}</a></li>')

            fields_rows = []
            for f in s.fields:
                fields_rows.append(f"""
                <tr>
                    <td class="param-name">{_escape(f.name)}</td>
                    <td class="param-type">{_escape(f.type_ann)}</td>
                    <td>{_escape(f.doc)}</td>
                </tr>
                """)

            methods_html = []
            for m in s.methods:
                m_params_str = ", ".join(f"{p[0]}: {p[1]}" for p in m.params)
                methods_html.append(f"""
                <div style="margin-top: 1rem; padding-left: 1rem; border-left: 2px solid var(--border);">
                    <div class="signature">
                        <span class="kw">fn</span> <span class="fnm">{_escape(m.name)}</span>({_escape(m_params_str)}) -&gt; <span class="typ">{_escape(m.return_type)}</span>
                    </div>
                    {f'<div class="doc-text">{_format_markdown_like(m.doc)}</div>' if m.doc else ''}
                </div>
                """)

            mod_structs_html.append(f"""
            <div class="card" id="struct-{mod.name}-{s.name}">
                <div class="card-title">
                    <h3>struct {_escape(s.name)}</h3>
                    <span class="kind-tag kind-struct">struct</span>
                </div>
                {f'<div class="doc-text">{_format_markdown_like(s.doc)}</div>' if s.doc else ''}
                {f'<table class="param-table"><thead><tr><th>Field</th><th>Type</th><th>Notes</th></tr></thead><tbody>{"".join(fields_rows)}</tbody></table>' if fields_rows else ''}
                {"".join(methods_html)}
            </div>
            """)

        mod_funcs_html = []
        for fn in mod.funcs:
            sidebar_funcs.append(f'<li><a href="#fn-{mod.name}-{fn.name}">{fn.name}</a></li>')

            params_sig = ", ".join(f"{p[0]}: {p[1]}" for p in fn.params)
            params_rows = []
            for p in fn.params:
                params_rows.append(f"""
                <tr>
                    <td class="param-name">{_escape(p[0])}</td>
                    <td class="param-type">{_escape(p[1])}</td>
                </tr>
                """)

            mod_funcs_html.append(f"""
            <div class="card" id="fn-{mod.name}-{fn.name}">
                <div class="card-title">
                    <h3>fn {_escape(fn.name)}</h3>
                    <span class="kind-tag kind-fn">function</span>
                </div>
                <div class="signature">
                    <span class="kw">fn</span> <span class="fnm">{_escape(fn.name)}</span>({_escape(params_sig)}) -&gt; <span class="typ">{_escape(fn.return_type)}</span>
                </div>
                {f'<div class="doc-text">{_format_markdown_like(fn.doc)}</div>' if fn.doc else ''}
                {f'<table class="param-table"><thead><tr><th>Parameter</th><th>Type</th></tr></thead><tbody>{"".join(params_rows)}</tbody></table>' if params_rows else ''}
            </div>
            """)

        mod_consts_html = []
        if mod.constants:
            const_rows = []
            for c in mod.constants:
                const_rows.append(f"""
                <tr>
                    <td class="param-name">{_escape(c.name)}</td>
                    <td class="param-type">{_escape(c.type_ann)}</td>
                    <td><code>{_escape(c.val)}</code></td>
                    <td>{_escape(c.doc)}</td>
                </tr>
                """)
            mod_consts_html.append(f"""
            <div class="card">
                <div class="card-title">
                    <h3>Constants</h3>
                    <span class="kind-tag kind-const">constants</span>
                </div>
                <table class="param-table">
                    <thead><tr><th>Constant</th><th>Type</th><th>Value</th><th>Notes</th></tr></thead>
                    <tbody>{"".join(const_rows)}</tbody>
                </table>
            </div>
            """)

        module_sections.append(f"""
        <section class="module-section" id="mod-{mod.name}">
            <div class="module-header">
                <h2 class="module-title">Module {_escape(mod.name)}</h2>
                {f'<div class="doc-text">{_format_markdown_like(mod.doc)}</div>' if mod.doc else ''}
            </div>
            {"".join(mod_consts_html)}
            {"".join(mod_structs_html)}
            {"".join(mod_funcs_html)}
        </section>
        """)

    html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{_escape(package_doc.name)} — Black Mamba Documentation</title>
    <style>{css}</style>
</head>
<body>
    <header>
        <div class="brand">
            <h1>{_escape(package_doc.name)}</h1>
            <span class="badge">v{_escape(package_doc.version)}</span>
            <span class="badge" style="color: #bc8cff;">Black Mamba</span>
        </div>
        <div class="search-box">
            <input type="text" id="search-input" placeholder="Search functions, structs... (Press '/' to focus)" autocomplete="off">
        </div>
    </header>
    <div class="container">
        <sidebar>
            <ul id="sidebar-search-results" style="display: none;"></ul>
            <div id="sidebar-default-nav">
                <h3>Modules ({len(package_doc.modules)})</h3>
                <ul>{"".join(sidebar_modules)}</ul>
                {f'<h3>Structs ({len(sidebar_structs)})</h3><ul>{"".join(sidebar_structs)}</ul>' if sidebar_structs else ''}
                {f'<h3>Functions ({len(sidebar_funcs)})</h3><ul>{"".join(sidebar_funcs)}</ul>' if sidebar_funcs else ''}
            </div>
        </sidebar>
        <main>
            {"".join(module_sections)}
        </main>
    </div>
    <script>{js}</script>
</body>
</html>
"""
    return html_content
