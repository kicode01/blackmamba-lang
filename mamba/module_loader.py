"""
Black Mamba (.bmb) Module Loader & Standard Library Linker.

Resolves `import <mod>` and `from <mod> import <names>` by loading
standard library modules (mamba/stdlib/<mod>.bmb) or workspace files (<mod>.bmb)
and unifying their declarations into the target compilation unit.
"""

import os
import sys
from typing import Dict, List, Optional, Set
from .ast_nodes import (
    ArrayLit,
    Assign,
    AugAssign,
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
    MatchStmt,
    MethodCall,
    Module,
    RaiseStmt,
    RangeExpr,
    Return,
    SliceExpr,
    Stmt,
    StringLit,
    StructDef,
    TernaryIf,
    TryStmt,
    UnaryOp,
    Var,
    WhileStmt,
)
from .parser import Parser


def _get_stdlib_dir() -> str:
    if getattr(sys, "frozen", False) and hasattr(sys, "_MEIPASS"):
        p = os.path.join(sys._MEIPASS, "mamba", "stdlib")
        if os.path.exists(p):
            return p
    p1 = os.path.join(os.path.dirname(__file__), "stdlib")
    if os.path.exists(p1):
        return p1
    if getattr(sys, "frozen", False):
        p2 = os.path.join(os.path.dirname(sys.executable), "stdlib")
        if os.path.exists(p2):
            return p2
    return p1


STDLIB_DIR = _get_stdlib_dir()


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


def _is_main_guard(stmt: Stmt) -> bool:
    """Detect top-level `if __name__ == "__main__":` guard in imported modules."""
    if not isinstance(stmt, IfStmt):
        return False
    cond = stmt.cond
    if isinstance(cond, BinOp) and cond.op == "==":
        l_is_name = isinstance(cond.left, Var) and cond.left.name == "__name__"
        r_is_main = isinstance(cond.right, StringLit) and cond.right.value == "__main__"
        r_is_name = isinstance(cond.right, Var) and cond.right.name == "__name__"
        l_is_main = isinstance(cond.left, StringLit) and cond.left.value == "__main__"
        if (l_is_name and r_is_main) or (r_is_name and l_is_main):
            return True
    return False


def _bind_dunder_name_expr(expr: Expr, mod_name: str, file_path: str) -> Expr:
    if isinstance(expr, Var):
        if expr.name == "__name__":
            return StringLit(line=expr.line, col=expr.col, value=mod_name)
        if expr.name == "__file__":
            return StringLit(line=expr.line, col=expr.col, value=file_path)
        return expr
    if isinstance(expr, BinOp):
        expr.left = _bind_dunder_name_expr(expr.left, mod_name, file_path)
        expr.right = _bind_dunder_name_expr(expr.right, mod_name, file_path)
    elif isinstance(expr, UnaryOp):
        expr.operand = _bind_dunder_name_expr(expr.operand, mod_name, file_path)
    elif isinstance(expr, TernaryIf):
        expr.cond = _bind_dunder_name_expr(expr.cond, mod_name, file_path)
        expr.then_expr = _bind_dunder_name_expr(expr.then_expr, mod_name, file_path)
        expr.else_expr = _bind_dunder_name_expr(expr.else_expr, mod_name, file_path)
    elif isinstance(expr, Call):
        expr.args = [_bind_dunder_name_expr(a, mod_name, file_path) for a in expr.args]
    elif isinstance(expr, MethodCall):
        expr.target = _bind_dunder_name_expr(expr.target, mod_name, file_path)
        expr.args = [_bind_dunder_name_expr(a, mod_name, file_path) for a in expr.args]
    elif isinstance(expr, FieldAccess):
        expr.target = _bind_dunder_name_expr(expr.target, mod_name, file_path)
    elif isinstance(expr, IndexExpr):
        expr.target = _bind_dunder_name_expr(expr.target, mod_name, file_path)
        expr.index = _bind_dunder_name_expr(expr.index, mod_name, file_path)
    elif isinstance(expr, SliceExpr):
        expr.target = _bind_dunder_name_expr(expr.target, mod_name, file_path)
        if expr.start:
            expr.start = _bind_dunder_name_expr(expr.start, mod_name, file_path)
        if expr.stop:
            expr.stop = _bind_dunder_name_expr(expr.stop, mod_name, file_path)
        if expr.step:
            expr.step = _bind_dunder_name_expr(expr.step, mod_name, file_path)
    elif isinstance(expr, ArrayLit):
        expr.elements = [_bind_dunder_name_expr(e, mod_name, file_path) for e in expr.elements]
        if expr.repeat_value:
            expr.repeat_value = _bind_dunder_name_expr(expr.repeat_value, mod_name, file_path)
        if expr.repeat_count:
            expr.repeat_count = _bind_dunder_name_expr(expr.repeat_count, mod_name, file_path)
    elif isinstance(expr, RangeExpr):
        expr.start = _bind_dunder_name_expr(expr.start, mod_name, file_path)
        expr.stop = _bind_dunder_name_expr(expr.stop, mod_name, file_path)
        expr.step = _bind_dunder_name_expr(expr.step, mod_name, file_path)
    return expr


def _bind_dunder_name_stmt(stmt: Stmt, mod_name: str, file_path: str) -> None:
    if isinstance(stmt, ExprStmt):
        stmt.expr = _bind_dunder_name_expr(stmt.expr, mod_name, file_path)
    elif isinstance(stmt, (Assign, AugAssign)):
        stmt.value = _bind_dunder_name_expr(stmt.value, mod_name, file_path)
    elif isinstance(stmt, FieldAssign):
        stmt.target = _bind_dunder_name_expr(stmt.target, mod_name, file_path)
        stmt.value = _bind_dunder_name_expr(stmt.value, mod_name, file_path)
    elif isinstance(stmt, (IndexAssign, IndexAugAssign)):
        stmt.target = _bind_dunder_name_expr(stmt.target, mod_name, file_path)
        stmt.index = _bind_dunder_name_expr(stmt.index, mod_name, file_path)
        stmt.value = _bind_dunder_name_expr(stmt.value, mod_name, file_path)
    elif isinstance(stmt, Return) and stmt.value:
        stmt.value = _bind_dunder_name_expr(stmt.value, mod_name, file_path)
    elif isinstance(stmt, IfStmt):
        stmt.cond = _bind_dunder_name_expr(stmt.cond, mod_name, file_path)
        for s in stmt.then_body:
            _bind_dunder_name_stmt(s, mod_name, file_path)
        for idx, (c, body) in enumerate(stmt.elif_branches):
            rc = _bind_dunder_name_expr(c, mod_name, file_path)
            for s in body:
                _bind_dunder_name_stmt(s, mod_name, file_path)
            stmt.elif_branches[idx] = (rc, body)
        for s in stmt.else_body:
            _bind_dunder_name_stmt(s, mod_name, file_path)
    elif isinstance(stmt, WhileStmt):
        stmt.cond = _bind_dunder_name_expr(stmt.cond, mod_name, file_path)
        for s in stmt.body:
            _bind_dunder_name_stmt(s, mod_name, file_path)
    elif isinstance(stmt, ForRangeStmt):
        stmt.start = _bind_dunder_name_expr(stmt.start, mod_name, file_path)
        stmt.stop = _bind_dunder_name_expr(stmt.stop, mod_name, file_path)
        stmt.step = _bind_dunder_name_expr(stmt.step, mod_name, file_path)
        for s in stmt.body:
            _bind_dunder_name_stmt(s, mod_name, file_path)
    elif isinstance(stmt, MatchStmt):
        stmt.subject = _bind_dunder_name_expr(stmt.subject, mod_name, file_path)
        for c in stmt.cases:
            if c.pattern:
                c.pattern = _bind_dunder_name_expr(c.pattern, mod_name, file_path)
            for s in c.body:
                _bind_dunder_name_stmt(s, mod_name, file_path)
    elif isinstance(stmt, FuncDef):
        for s in stmt.body:
            _bind_dunder_name_stmt(s, mod_name, file_path)
    elif isinstance(stmt, StructDef):
        for m in stmt.methods:
            _bind_dunder_name_stmt(m, mod_name, file_path)
    elif isinstance(stmt, TryStmt):
        for s in stmt.body:
            _bind_dunder_name_stmt(s, mod_name, file_path)
        for h in stmt.handlers:
            for s in h.body:
                _bind_dunder_name_stmt(s, mod_name, file_path)
        for s in stmt.else_body:
            _bind_dunder_name_stmt(s, mod_name, file_path)
        for s in stmt.finally_body:
            _bind_dunder_name_stmt(s, mod_name, file_path)
    elif isinstance(stmt, RaiseStmt) and stmt.exc:
        stmt.exc = _bind_dunder_name_expr(stmt.exc, mod_name, file_path)


def _rewrite_module_calls(expr: Expr, imported_mods: Set[str], local_vars: Optional[Set[str]] = None) -> Expr:
    """Rewrite `math.sin(x)` -> `sin(x)` and `math.PI` -> `PI` across all expression forms."""
    locals_set = local_vars or set()
    if isinstance(expr, MethodCall):
        if isinstance(expr.target, Var) and expr.target.name in imported_mods and expr.target.name not in locals_set:
            return Call(
                line=expr.line,
                col=expr.col,
                func=expr.method,
                args=[_rewrite_module_calls(a, imported_mods, locals_set) for a in expr.args],
            )
        expr.target = _rewrite_module_calls(expr.target, imported_mods, locals_set)
        expr.args = [_rewrite_module_calls(a, imported_mods, locals_set) for a in expr.args]
        return expr
    if isinstance(expr, FieldAccess):
        if isinstance(expr.target, Var) and expr.target.name in imported_mods and expr.target.name not in locals_set:
            return Var(line=expr.line, col=expr.col, name=expr.field_name)
        expr.target = _rewrite_module_calls(expr.target, imported_mods, locals_set)
        return expr
    if isinstance(expr, Call):
        expr.args = [_rewrite_module_calls(a, imported_mods, locals_set) for a in expr.args]
        return expr
    if isinstance(expr, BinOp):
        expr.left = _rewrite_module_calls(expr.left, imported_mods, locals_set)
        expr.right = _rewrite_module_calls(expr.right, imported_mods, locals_set)
        return expr
    if isinstance(expr, UnaryOp):
        expr.operand = _rewrite_module_calls(expr.operand, imported_mods, locals_set)
        return expr
    if isinstance(expr, TernaryIf):
        expr.cond = _rewrite_module_calls(expr.cond, imported_mods, locals_set)
        expr.then_expr = _rewrite_module_calls(expr.then_expr, imported_mods, locals_set)
        expr.else_expr = _rewrite_module_calls(expr.else_expr, imported_mods, locals_set)
        return expr
    if isinstance(expr, IndexExpr):
        expr.target = _rewrite_module_calls(expr.target, imported_mods, locals_set)
        expr.index = _rewrite_module_calls(expr.index, imported_mods, locals_set)
        return expr
    if isinstance(expr, SliceExpr):
        expr.target = _rewrite_module_calls(expr.target, imported_mods, locals_set)
        if expr.start is not None:
            expr.start = _rewrite_module_calls(expr.start, imported_mods, locals_set)
        if expr.stop is not None:
            expr.stop = _rewrite_module_calls(expr.stop, imported_mods, locals_set)
        if expr.step is not None:
            expr.step = _rewrite_module_calls(expr.step, imported_mods, locals_set)
        return expr
    if isinstance(expr, ArrayLit):
        expr.elements = [_rewrite_module_calls(e, imported_mods, locals_set) for e in expr.elements]
        if expr.repeat_value is not None:
            expr.repeat_value = _rewrite_module_calls(expr.repeat_value, imported_mods, locals_set)
        if expr.repeat_count is not None:
            expr.repeat_count = _rewrite_module_calls(expr.repeat_count, imported_mods, locals_set)
        return expr
    if isinstance(expr, RangeExpr):
        expr.start = _rewrite_module_calls(expr.start, imported_mods, locals_set)
        expr.stop = _rewrite_module_calls(expr.stop, imported_mods, locals_set)
        expr.step = _rewrite_module_calls(expr.step, imported_mods, locals_set)
        return expr
    return expr


def _rewrite_stmt(stmt: Stmt, imported_mods: Set[str], local_vars: Optional[Set[str]] = None) -> None:
    locals_set = local_vars or set()
    if isinstance(stmt, ExprStmt):
        stmt.expr = _rewrite_module_calls(stmt.expr, imported_mods, locals_set)
    elif isinstance(stmt, (Assign, AugAssign)):
        stmt.value = _rewrite_module_calls(stmt.value, imported_mods, locals_set)
    elif isinstance(stmt, FieldAssign):
        stmt.target = _rewrite_module_calls(stmt.target, imported_mods, locals_set)
        stmt.value = _rewrite_module_calls(stmt.value, imported_mods, locals_set)
    elif isinstance(stmt, (IndexAssign, IndexAugAssign)):
        stmt.target = _rewrite_module_calls(stmt.target, imported_mods, locals_set)
        stmt.index = _rewrite_module_calls(stmt.index, imported_mods, locals_set)
        stmt.value = _rewrite_module_calls(stmt.value, imported_mods, locals_set)
    elif isinstance(stmt, Return) and stmt.value:
        stmt.value = _rewrite_module_calls(stmt.value, imported_mods, locals_set)
    elif isinstance(stmt, IfStmt):
        stmt.cond = _rewrite_module_calls(stmt.cond, imported_mods, locals_set)
        for s in stmt.then_body:
            _rewrite_stmt(s, imported_mods, locals_set)
        for idx, (c, body) in enumerate(stmt.elif_branches):
            rewritten_c = _rewrite_module_calls(c, imported_mods, locals_set)
            for s in body:
                _rewrite_stmt(s, imported_mods, locals_set)
            stmt.elif_branches[idx] = (rewritten_c, body)
        for s in stmt.else_body:
            _rewrite_stmt(s, imported_mods, locals_set)
    elif isinstance(stmt, WhileStmt):
        stmt.cond = _rewrite_module_calls(stmt.cond, imported_mods, locals_set)
        for s in stmt.body:
            _rewrite_stmt(s, imported_mods, locals_set)
    elif isinstance(stmt, ForRangeStmt):
        stmt.start = _rewrite_module_calls(stmt.start, imported_mods, locals_set)
        stmt.stop = _rewrite_module_calls(stmt.stop, imported_mods, locals_set)
        stmt.step = _rewrite_module_calls(stmt.step, imported_mods, locals_set)
        sub_locals = set(locals_set)
        sub_locals.add(stmt.var_name)
        for s in stmt.body:
            _rewrite_stmt(s, imported_mods, sub_locals)
    elif isinstance(stmt, MatchStmt):
        stmt.subject = _rewrite_module_calls(stmt.subject, imported_mods, locals_set)
        for c in stmt.cases:
            if c.pattern is not None:
                c.pattern = _rewrite_module_calls(c.pattern, imported_mods, locals_set)
            for s in c.body:
                _rewrite_stmt(s, imported_mods, locals_set)
    elif isinstance(stmt, FuncDef):
        fn_locals = set(locals_set)
        for p in stmt.params:
            fn_locals.add(p.name if hasattr(p, "name") else p[0])
        for s in stmt.body:
            if isinstance(s, Assign) and isinstance(s.target, str):
                fn_locals.add(s.target)
            elif isinstance(s, ForRangeStmt):
                fn_locals.add(s.var_name)
            _rewrite_stmt(s, imported_mods, fn_locals)
    elif isinstance(stmt, StructDef):
        for m in stmt.methods:
            _rewrite_stmt(m, imported_mods, locals_set)
    elif isinstance(stmt, TryStmt):
        for s in stmt.body:
            _rewrite_stmt(s, imported_mods, locals_set)
        for h in stmt.handlers:
            h_locals = set(locals_set)
            if h.var_name:
                h_locals.add(h.var_name)
            for s in h.body:
                _rewrite_stmt(s, imported_mods, h_locals)
        for s in stmt.else_body:
            _rewrite_stmt(s, imported_mods, locals_set)
        for s in stmt.finally_body:
            _rewrite_stmt(s, imported_mods, locals_set)
    elif isinstance(stmt, RaiseStmt) and stmt.exc is not None:
        stmt.exc = _rewrite_module_calls(stmt.exc, imported_mods, locals_set)


def _collect_callees(fn: FuncDef) -> Set[str]:
    callees: Set[str] = set()

    def scan_expr(e: Expr) -> None:
        if isinstance(e, Call):
            callees.add(e.func)
            for a in e.args:
                scan_expr(a)
        elif isinstance(e, MethodCall):
            scan_expr(e.target)
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
        elif isinstance(e, FieldAccess):
            scan_expr(e.target)
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
        elif isinstance(s, (Assign, AugAssign)):
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
        elif isinstance(s, MatchStmt):
            scan_expr(s.subject)
            for c in s.cases:
                if c.pattern:
                    scan_expr(c.pattern)
                for b in c.body:
                    scan_stmt(b)
        elif isinstance(s, TryStmt):
            for b in s.body:
                scan_stmt(b)
            for h in s.handlers:
                for b in h.body:
                    scan_stmt(b)
            for b in s.else_body:
                scan_stmt(b)
            for b in s.finally_body:
                scan_stmt(b)
        elif isinstance(s, RaiseStmt) and s.exc:
            scan_expr(s.exc)

    for s in fn.body:
        scan_stmt(s)
    return callees


def resolve_imports(
    mod: Module,
    base_dir: str,
    loaded_modules: Optional[Set[str]] = None,
    ast_cache: Optional[Dict[str, Module]] = None,
    in_progress: Optional[Set[str]] = None,
) -> Module:
    if ast_cache is None:
        ast_cache = {}
    if in_progress is None:
        in_progress = set()

    imported_mods: Set[str] = set()
    new_stmts: List[Stmt] = []
    prepended_stmts: List[Stmt] = []
    seen_defs: Set[str] = set()

    for stmt in mod.statements:
        if isinstance(stmt, (ImportStmt, FromImportStmt)):
            mod_name = stmt.module_name
            alias_map: Dict[str, str] = {}
            if isinstance(stmt, ImportStmt):
                imported_mods.add(mod_name)
                if stmt.alias:
                    imported_mods.add(stmt.alias)
                    alias_map[stmt.alias] = mod_name

            file_path = resolve_module_file(mod_name, base_dir)
            if not file_path:
                continue

            if file_path in in_progress:
                continue

            if file_path in ast_cache:
                imported_ast = ast_cache[file_path]
            else:
                in_progress.add(file_path)
                with open(file_path, "r", encoding="utf-8") as f:
                    mod_src = f.read()

                parsed_mod = Parser.from_source(mod_src, file_path).parse_module()
                # Strip top-level `if __name__ == "__main__":` guards in imported modules
                # and bind `__name__` -> module_name inside imported module bodies.
                filtered_stmts: List[Stmt] = []
                for s in parsed_mod.statements:
                    if _is_main_guard(s):
                        continue
                    _bind_dunder_name_stmt(s, mod_name, file_path)
                    filtered_stmts.append(s)
                parsed_mod.statements = filtered_stmts

                imported_ast = resolve_imports(
                    parsed_mod,
                    os.path.dirname(file_path),
                    ast_cache=ast_cache,
                    in_progress=in_progress,
                )
                in_progress.remove(file_path)
                ast_cache[file_path] = imported_ast

            if isinstance(stmt, FromImportStmt):
                if stmt.names == ["*"]:
                    for s in imported_ast.statements:
                        name = getattr(s, "name", None)
                        if name:
                            if name not in seen_defs:
                                seen_defs.add(name)
                                prepended_stmts.append(s)
                        else:
                            prepended_stmts.append(s)
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
                            if s.name not in seen_defs:
                                seen_defs.add(s.name)
                                prepended_stmts.append(s)
                        elif isinstance(s, StructDef):
                            if s.name not in seen_defs:
                                seen_defs.add(s.name)
                                prepended_stmts.append(s)
                        elif isinstance(s, Assign):
                            prepended_stmts.append(s)
            elif isinstance(stmt, ImportStmt):
                for s in imported_ast.statements:
                    name = getattr(s, "name", None)
                    if name:
                        if name not in seen_defs:
                            seen_defs.add(name)
                            prepended_stmts.append(s)
                    else:
                        prepended_stmts.append(s)
        else:
            new_stmts.append(stmt)

    unified_stmts = prepended_stmts + new_stmts
    for s in unified_stmts:
        _rewrite_stmt(s, imported_mods)

    return Module(statements=unified_stmts)
