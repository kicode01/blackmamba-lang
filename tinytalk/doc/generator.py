"""
Black Mamba (bmb) Documentation Generator — Core Orchestrator.
Coordinates AST extraction, metadata indexing, and static HTML compilation.
"""

import os
from typing import Optional

from .extractor import ModuleDoc, PackageDoc, extract_module_doc, extract_package_doc
from .html_renderer import render_html_documentation


class DocGenerator:
    """Generates static HTML documentation sites for Black Mamba packages and files."""

    def __init__(self, output_dir: Optional[str] = None):
        self.output_dir = output_dir or "build/docs"

    def generate_package(self, project_dir: str = ".") -> str:
        """Extracts documentation for an entire project and writes index.html."""
        pkg_doc = extract_package_doc(project_dir)
        html = render_html_documentation(pkg_doc)

        os.makedirs(self.output_dir, exist_ok=True)
        out_file = os.path.join(self.output_dir, "index.html")
        with open(out_file, "w", encoding="utf-8") as f:
            f.write(html)

        return os.path.abspath(out_file)

    def generate_file(self, file_path: str) -> str:
        """Extracts documentation for a single .bmb file and writes index.html."""
        mod_doc = extract_module_doc(file_path)
        pkg_doc = PackageDoc(
            name=mod_doc.name,
            version="0.1.0",
            description=f"Documentation for {os.path.basename(file_path)}",
            modules=[mod_doc],
        )
        html = render_html_documentation(pkg_doc)

        os.makedirs(self.output_dir, exist_ok=True)
        out_file = os.path.join(self.output_dir, "index.html")
        with open(out_file, "w", encoding="utf-8") as f:
            f.write(html)

        return os.path.abspath(out_file)
