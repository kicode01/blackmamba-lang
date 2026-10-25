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
    ArrayLit,
    Assign,
    BinOp,
    Call,
    Expr,
    ExprStmt,
    FieldAccess,
    FieldAssign,
    ForRangeStmt,
    FromImportStmt,
    FuncDef,
    IfStmt,
    ImportStmt,
    IndexAssign,
    IndexAugAssign,
    IndexExpr,
    MethodCall,
    Module,
    Return,
    SliceExpr,
    Stmt,
    StructDef,
    TernaryIf,
    UnaryOp,
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

    # 4. Package Manager Vendor Directories (.mamba/packages/<pkg>/)
    search_dirs = [base_dir, os.path.dirname(base_dir), os.getcwd()]
    for sdir in search_dirs:
        pkg_dir = os.path.join(sdir, ".mamba", "packages", module_name)
        if os.path.exists(pkg_dir):
            candidates = [
                os.path.join(pkg_dir, f"{module_name}.bmb"),
                os.path.join(pkg_dir, "src", f"{module_name}.bmb"),
                os.path.join(pkg_dir, "src", "lib.bmb"),
                os.path.join(pkg_dir, "src", "main.bmb"),
            ]
            for cand in candidates:
                if os.path.exists(cand):
                    return cand

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
    elif isinstance(stmt, FieldAssign):
        stmt.target = _rewrite_module_calls(stmt.target, imported_mods)
        stmt.value = _rewrite_module_calls(stmt.value, imported_mods)
    elif isinstance(stmt, (IndexAssign, IndexAugAssign)):
        stmt.target = _rewrite_module_calls(stmt.target, imported_mods)
        stmt.index = _rewrite_module_calls(stmt.index, imported_mods)
        stmt.value = _rewrite_module_calls(stmt.value, imported_mods)
    elif isinstance(stmt, Return) and stmt.value:
        stmt.value = _rewrite_module_calls(stmt.value, imported_mods)
    elif isinstance(stmt, IfStmt):
        stmt.cond = _rewrite_module_calls(stmt.cond, imported_mods)
        for s in stmt.then_body:
            _rewrite_stmt(s, imported_mods)
        for idx, (c, body) in enumerate(stmt.elif_branches):
            rewritten_c = _rewrite_module_calls(c, imported_mods)
            for s in body:
                _rewrite_stmt(s, imported_mods)
            stmt.elif_branches[idx] = (rewritten_c, body)
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


def _collect_callees(fn: FuncDef) -> Set[str]:
    callees: Set[str] = set()

    def scan_expr(e: Expr) -> None:
        if isinstance(e, Call):
            callees.add(e.func)
            for a in e.args:
                scan_expr(a)
        elif isinstance(e, MethodCall):
            for a in e.args:
                scan_expr(a)
        elif isinstance(e, BinOp):
            scan_expr(e.left)
            scan_expr(e.right)
        elif isinstance(e, UnaryOp):
            scan_expr(e.operand)
        elif isinstance(e, IndexExpr):
            scan_expr(e.target)
            scan_expr(e.index)
        elif isinstance(e, SliceExpr):
            scan_expr(e.target)
            if e.start:
                scan_expr(e.start)
            if e.stop:
                scan_expr(e.stop)
            if e.step:
                scan_expr(e.step)
        elif isinstance(e, TernaryIf):
            scan_expr(e.cond)
            scan_expr(e.then_expr)
            scan_expr(e.else_expr)
        elif isinstance(e, ArrayLit):
            for el in e.elements:
                scan_expr(el)
            if e.repeat_value:
                scan_expr(e.repeat_value)
            if e.repeat_count:
                scan_expr(e.repeat_count)

    def scan_stmt(s: Stmt) -> None:
        if isinstance(s, ExprStmt):
            scan_expr(s.expr)
        elif isinstance(s, Assign):
            scan_expr(s.value)
        elif isinstance(s, FieldAssign):
            scan_expr(s.target)
            scan_expr(s.value)
        elif isinstance(s, (IndexAssign, IndexAugAssign)):
            scan_expr(s.target)
            scan_expr(s.index)
            scan_expr(s.value)
        elif isinstance(s, Return) and s.value:
            scan_expr(s.value)
        elif isinstance(s, IfStmt):
            scan_expr(s.cond)
            for b in s.then_body:
                scan_stmt(b)
            for cond, body in s.elif_branches:
                scan_expr(cond)
                for b in body:
                    scan_stmt(b)
            for b in s.else_body:
                scan_stmt(b)
        elif isinstance(s, WhileStmt):
            scan_expr(s.cond)
            for b in s.body:
                scan_stmt(b)
        elif isinstance(s, ForRangeStmt):
            scan_expr(s.start)
            scan_expr(s.stop)
            scan_expr(s.step)
            for b in s.body:
                scan_stmt(b)

    for s in fn.body:
        scan_stmt(s)
    return callees


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
                    # Transitive dependency closure
                    func_map = {s.name: s for s in imported_ast.statements if isinstance(s, FuncDef)}
                    changed = True
                    while changed:
                        changed = False
                        new_callees = set()
                        for name in list(wanted):
                            if name in func_map:
                                for c in _collect_callees(func_map[name]):
                                    if c in func_map and c not in wanted:
                                        new_callees.add(c)
                        if new_callees:
                            wanted.update(new_callees)
                            changed = True

                    for s in imported_ast.statements:
                        if isinstance(s, FuncDef) and s.name in wanted:
                            prepended_stmts.append(s)
                        elif isinstance(s, StructDef):
                            prepended_stmts.append(s)
                        elif isinstance(s, Assign):
                            prepended_stmts.append(s)
            elif isinstance(stmt, ImportStmt):
                prepended_stmts.extend(imported_ast.statements)
        else:
            new_stmts.append(stmt)

    unified_stmts = prepended_stmts + new_stmts
    for s in unified_stmts:
        _rewrite_stmt(s, imported_mods)

    return Module(statements=unified_stmts)
