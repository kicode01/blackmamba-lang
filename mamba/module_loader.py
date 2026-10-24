"""
Black Mamba (.bmb) Module Loader & Standard Library Linker.

Resolves `import <mod>` and `from <mod> import <names>` by loading
standard library modules (mamba/stdlib/<mod>.bmb) or workspace files (<mod>.bmb)
and unifying their declarations into the target compilation unit.
"""

import copy
import os
from typing import Dict, List, Optional, Set
from .ast_nodes import (
    Assign,
    Call,
    Expr,
    ExprStmt,
    FieldAccess,
    ForRangeStmt,
    FromImportStmt,
    FuncDef,
    IfStmt,
    ImportStmt,
    MethodCall,
    Module,
    Return,
    Stmt,
    StructDef,
    Var,
    WhileStmt,
)
from .parser import Parser

STDLIB_DIR = os.path.join(os.path.dirname(__file__), "stdlib")


def resolve_module_file(module_name: str, base_dir: str) -> Optional[str]:
    # 1. Standard Library
    stdlib_path = os.path.join(STDLIB_DIR, f"{module_name}.bmb")
    if os.path.exists(stdlib_path):
        return stdlib_path
    # 2. Local directory
    local_path = os.path.join(base_dir, f"{module_name}.bmb")
    if os.path.exists(local_path):
        return local_path
    # 3. Current working directory
    cwd_path = os.path.join(os.getcwd(), f"{module_name}.bmb")
    if os.path.exists(cwd_path):
        return cwd_path
    return None


def _rewrite_module_calls(expr: Expr, imported_mods: Set[str]) -> Expr:
    """Rewrite `math.sin(x)` -> `sin(x)` and `math.PI` -> `PI`."""
    if isinstance(expr, MethodCall):
        if isinstance(expr.target, Var) and expr.target.name in imported_mods:
            return Call(
                line=expr.line,
                col=expr.col,
                func=expr.method,
                args=[_rewrite_module_calls(a, imported_mods) for a in expr.args],
            )
        expr.args = [_rewrite_module_calls(a, imported_mods) for a in expr.args]
        return expr
    if isinstance(expr, FieldAccess):
        if isinstance(expr.target, Var) and expr.target.name in imported_mods:
            return Var(line=expr.line, col=expr.col, name=expr.field_name)
        return expr
    if isinstance(expr, Call):
        expr.args = [_rewrite_module_calls(a, imported_mods) for a in expr.args]
        return expr
    return expr


def _rewrite_stmt(stmt: Stmt, imported_mods: Set[str]) -> None:
    if isinstance(stmt, ExprStmt):
        stmt.expr = _rewrite_module_calls(stmt.expr, imported_mods)
    elif isinstance(stmt, Assign):
        stmt.value = _rewrite_module_calls(stmt.value, imported_mods)
    elif isinstance(stmt, Return) and stmt.value:
        stmt.value = _rewrite_module_calls(stmt.value, imported_mods)
    elif isinstance(stmt, IfStmt):
        stmt.cond = _rewrite_module_calls(stmt.cond, imported_mods)
        for s in stmt.then_body:
            _rewrite_stmt(s, imported_mods)
        for s in stmt.else_body:
            _rewrite_stmt(s, imported_mods)
    elif isinstance(stmt, WhileStmt):
        stmt.cond = _rewrite_module_calls(stmt.cond, imported_mods)
        for s in stmt.body:
            _rewrite_stmt(s, imported_mods)
    elif isinstance(stmt, ForRangeStmt):
        stmt.start = _rewrite_module_calls(stmt.start, imported_mods)
        stmt.stop = _rewrite_module_calls(stmt.stop, imported_mods)
        stmt.step = _rewrite_module_calls(stmt.step, imported_mods)
        for s in stmt.body:
            _rewrite_stmt(s, imported_mods)
    elif isinstance(stmt, FuncDef):
        for s in stmt.body:
            _rewrite_stmt(s, imported_mods)


def resolve_imports(mod: Module, base_dir: str, loaded_modules: Optional[Set[str]] = None) -> Module:
    if loaded_modules is None:
        loaded_modules = set()

    imported_mods: Set[str] = set()
    new_stmts: List[Stmt] = []
    prepended_stmts: List[Stmt] = []

    for stmt in mod.statements:
        if isinstance(stmt, (ImportStmt, FromImportStmt)):
            mod_name = stmt.module_name
            imported_mods.add(mod_name)
            if isinstance(stmt, ImportStmt) and stmt.alias:
                imported_mods.add(stmt.alias)

            if mod_name in loaded_modules:
                continue

            file_path = resolve_module_file(mod_name, base_dir)
            if not file_path:
                continue

            loaded_modules.add(mod_name)
            with open(file_path, "r", encoding="utf-8") as f:
                mod_src = f.read()

            imported_ast = Parser.from_source(mod_src, file_path).parse_module()
            imported_ast = resolve_imports(imported_ast, os.path.dirname(file_path), loaded_modules)

            if isinstance(stmt, FromImportStmt):
                if stmt.names == ["*"]:
                    prepended_stmts.extend(imported_ast.statements)
                else:
                    wanted = set(stmt.names)
                    for s in imported_ast.statements:
                        if isinstance(s, FuncDef) and s.name in wanted:
                            prepended_stmts.append(s)
                        elif isinstance(s, StructDef) and s.name in wanted:
                            prepended_stmts.append(s)
                        elif isinstance(s, Assign) and s.target in wanted:
                            prepended_stmts.append(s)
            elif isinstance(stmt, ImportStmt):
                prepended_stmts.extend(imported_ast.statements)
        else:
            new_stmts.append(stmt)

    unified_stmts = prepended_stmts + new_stmts
    for s in unified_stmts:
        _rewrite_stmt(s, imported_mods)

    return Module(statements=unified_stmts)
