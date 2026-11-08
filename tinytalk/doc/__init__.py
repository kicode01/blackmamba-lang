"""
Black Mamba (bmb) Documentation Generator Package.
Provides AST docstring extraction, metadata indexing, and static HTML rendering.
"""

from .extractor import ConstDoc, FieldDoc, FuncDoc, MethodDoc, ModuleDoc, PackageDoc, extract_module_doc, extract_package_doc
from .generator import DocGenerator
from .html_renderer import render_html_documentation

__all__ = [
    "DocGenerator",
    "extract_module_doc",
    "extract_package_doc",
    "render_html_documentation",
    "PackageDoc",
    "ModuleDoc",
    "StructDoc",
    "FuncDoc",
    "FieldDoc",
    "MethodDoc",
    "ConstDoc",
]
