"""
Black Mamba (bmb) Documentation Generator — AST & Docstring Extractor.
Extracts module descriptions, struct layouts, function signatures, and doc comments.
"""

import os
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional, Tuple

from ..ast_nodes import (
    Assign,
    ExprStmt,
    FuncDef,
    Module,
    StringLit,
    StructDef,
)
from ..parser import Parser


@dataclass
class FieldDoc:
    name: str
    type_ann: str
    doc: str = ""


@dataclass
class MethodDoc:
    name: str
    params: List[Tuple[str, str]]
    return_type: str
    doc: str = ""


@dataclass
class StructDoc:
    name: str
    fields: List[FieldDoc] = field(default_factory=list)
    methods: List[MethodDoc] = field(default_factory=list)
    doc: str = ""
    line: int = 1


@dataclass
class FuncDoc:
    name: str
    params: List[Tuple[str, str]]
    return_type: str
    doc: str = ""
    line: int = 1


@dataclass
class ConstDoc:
    name: str
    val: str
    type_ann: str = ""
    doc: str = ""
    line: int = 1


@dataclass
class ModuleDoc:
    name: str
    file_path: str
    doc: str = ""
    structs: List[StructDoc] = field(default_factory=list)
    funcs: List[FuncDoc] = field(default_factory=list)
    constants: List[ConstDoc] = field(default_factory=list)


@dataclass
class PackageDoc:
    name: str
    version: str = "0.1.0"
    description: str = ""
    modules: List[ModuleDoc] = field(default_factory=list)


def _extract_doc_for_node(lines: List[str], line_idx: int, body_stmts: Optional[List[Any]] = None) -> str:
    """
    Extracts documentation from comments inside body, string literal docstring,
    or preceding comment lines.
    """
    # 1. Check for string literal as first body statement
    if body_stmts and len(body_stmts) > 0:
        first = body_stmts[0]
        if isinstance(first, ExprStmt) and isinstance(first.expr, StringLit):
            return str(first.expr.value).strip()

    # 2. Check for comment lines inside body immediately following signature
    idx = line_idx + 1
    inside_comments = []
    while idx < len(lines):
        line = lines[idx].strip()
        if line.startswith("#"):
            inside_comments.append(line.lstrip("#").strip())
            idx += 1
        else:
            break
    if inside_comments:
        return " ".join(inside_comments)

    # 3. Check for preceding comment lines
    cur = line_idx - 1
    while cur >= 0 and not lines[cur].strip():
        cur -= 1
    prec_comments = []
    while cur >= 0 and lines[cur].strip().startswith("#"):
        prec_comments.insert(0, lines[cur].strip().lstrip("#").strip())
        cur -= 1
    if prec_comments:
        return " ".join(prec_comments)

    return ""


def extract_module_doc(file_path: str, source: Optional[str] = None) -> ModuleDoc:
    """Extracts structured documentation from a single .bmb source file."""
    if source is None:
        with open(file_path, "r", encoding="utf-8", errors="replace") as f:
            source = f.read()

    lines = source.splitlines()
    mod_name = os.path.splitext(os.path.basename(file_path))[0]

    # Module-level documentation from top comments
    top_comments = []
    for line in lines:
        sline = line.strip()
        if not sline:
            continue
        if sline.startswith("#"):
            top_comments.append(sline.lstrip("#").strip())
        else:
            break
    mod_doc = "\n".join(top_comments)

    # Parse AST
    try:
        mod = Parser.from_source(source, filename=file_path).parse_module()
    except Exception:
        # Graceful fallback on parse error
        return ModuleDoc(name=mod_name, file_path=file_path, doc=mod_doc)

    structs: List[StructDoc] = []
    funcs: List[FuncDoc] = []
    constants: List[ConstDoc] = []

    for stmt in mod.statements:
        line_idx = getattr(stmt, "line", 1) - 1

        if isinstance(stmt, StructDef):
            sdoc = _extract_doc_for_node(lines, line_idx)
            fields = [
                FieldDoc(name=f.name, type_ann=f.type_ann or "i64")
                for f in stmt.fields
            ]
            methods = []
            for m in getattr(stmt, "methods", []):
                mparams = [(p.name, p.type_ann or "i64") for p in m.params]
                mdoc = _extract_doc_for_node(lines, m.line - 1, m.body)
                methods.append(MethodDoc(
                    name=m.name,
                    params=mparams,
                    return_type=m.return_type or "i64",
                    doc=mdoc,
                ))
            structs.append(StructDoc(
                name=stmt.name,
                fields=fields,
                methods=methods,
                doc=sdoc,
                line=stmt.line,
            ))

        elif isinstance(stmt, FuncDef):
            fdoc = _extract_doc_for_node(lines, line_idx, stmt.body)
            fparams = [(p.name, p.type_ann or "i64") for p in stmt.params]
            funcs.append(FuncDoc(
                name=stmt.name,
                params=fparams,
                return_type=stmt.return_type or "i64",
                doc=fdoc,
                line=stmt.line,
            ))

        elif isinstance(stmt, Assign) and not getattr(stmt, "is_local", False):
            # Check for top-level constants
            if getattr(stmt, "target", "") and stmt.target.isupper():
                cdoc = _extract_doc_for_node(lines, line_idx)
                constants.append(ConstDoc(
                    name=stmt.target,
                    val=str(getattr(stmt.value, "value", "")),
                    type_ann=getattr(stmt, "type_ann", "") or "i64",
                    doc=cdoc,
                    line=stmt.line,
                ))

    return ModuleDoc(
        name=mod_name,
        file_path=file_path,
        doc=mod_doc,
        structs=structs,
        funcs=funcs,
        constants=constants,
    )


def extract_package_doc(project_dir: str) -> PackageDoc:
    """Extracts documentation for an entire package or directory of .bmb files."""
    proj_dir = os.path.abspath(project_dir)
    pkg_name = os.path.basename(proj_dir)
    version = "0.1.0"
    desc = ""

    # Check for mamba.toml
    manifest_file = os.path.join(proj_dir, "mamba.toml")
    if os.path.exists(manifest_file):
        try:
            from ..pkg.manifest import PackageManifest
            m = PackageManifest.load(manifest_file)
            pkg_name = m.name
            version = m.version
            desc = m.description
        except Exception:
            pass

    # Collect .bmb files
    bmb_files: List[str] = []
    src_dir = os.path.join(proj_dir, "src")
    scan_dir = src_dir if os.path.exists(src_dir) else proj_dir

    for root, _, files in os.walk(scan_dir):
        if ".mamba" in root or "build" in root:
            continue
        for fname in sorted(files):
            if fname.endswith(".bmb"):
                bmb_files.append(os.path.join(root, fname))

    # If no files found in src, look directly in project_dir
    if not bmb_files:
        for f in sorted(os.listdir(proj_dir)):
            if f.endswith(".bmb"):
                bmb_files.append(os.path.join(proj_dir, f))

    modules: List[ModuleDoc] = []
    for bfile in bmb_files:
        modules.append(extract_module_doc(bfile))

    return PackageDoc(
        name=pkg_name,
        version=version,
        description=desc,
        modules=modules,
    )
