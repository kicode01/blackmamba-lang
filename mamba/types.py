"""
Black Mamba (.bmb) Cartesian Type Inference, Unification & Monomorphization Engine.

Bridges standard Python types (`int`, `float`, `bool`, `str`, `list`) and systems types
(`i64`, `i32`, `u64`, `f64`, `Array[i64]`, `Array[f64]`, `void`) without Mojo's `fn`/`def`
schism or Nim's mandatory `proc` signatures.
"""

import copy
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple
from .ast_nodes import (
    ArrayLit,
    Assign,
    AugAssign,
    BinOp,
    BoolLit,
    Call,
    Expr,
    ExprStmt,
    FieldAccess,
    FieldAssign,
    FloatLit,
    ForRangeStmt,
    FuncDef,
    IfStmt,
    IndexAssign,
    IndexAugAssign,
    IndexExpr,
    IntLit,
    MatchStmt,
    MethodCall,
    Module,
    Param,
    RangeExpr,
    Return,
    SliceExpr,
    Stmt,
    StringLit,
    StructDef,
    TernaryIf,
    UnaryOp,
    Var,
    WhileStmt,
)


TYPE_ALIASES = {
    "int": "i64",
    "i64": "i64",
    "int64": "i64",
    "isize": "i64",
    "i32": "i64",
    "u64": "i64",
    "uint64": "i64",
    "float": "f64",
    "f64": "f64",
    "float64": "f64",
    "f32": "f64",
    "bool": "bool",
    "str": "str",
    "string": "str",
    "None": "void",
    "void": "void",
    "list[int]": "Array[i64]",
    "list[i64]": "Array[i64]",
    "List[int]": "Array[i64]",
    "Array[int]": "Array[i64]",
    "Array[i64]": "Array[i64]",
    "list[float]": "Array[f64]",
    "list[f64]": "Array[f64]",
    "List[float]": "Array[f64]",
    "Array[float]": "Array[f64]",
    "Array[f64]": "Array[f64]",
}


def normalize_type(t: Optional[str]) -> Optional[str]:
    if t is None:
        return None
    return TYPE_ALIASES.get(t, t)


def unify_types(t1: Optional[str], t2: Optional[str]) -> str:
    t1 = normalize_type(t1)
    t2 = normalize_type(t2)
    if t1 is None and t2 is None:
        return "i64"
    if t1 is None or t1 == "void":
        return t2 or "i64"
    if t2 is None or t2 == "void":
        return t1 or "i64"
    if t1 == t2:
        return t1
    if "str" in (t1, t2):
        return "str"
    if {t1, t2} <= {"i64", "f64", "bool"}:
        if "f64" in (t1, t2):
            return "f64"
        if "i64" in (t1, t2):
            return "i64"
        return "bool"
    return t1


@dataclass
class FunctionSignature:
    name: str
    param_types: List[str]
    return_type: str
    var_types: Dict[str, str] = field(default_factory=dict)


class TypeInferencer:
    """
    Whole-program flow-sensitive + call-site Cartesian type inference and monomorphization pass.
    """

    def __init__(self, module: Module):
        self.module = module
        self.structs: Dict[str, StructDef] = {}
        self.funcs: Dict[str, FuncDef] = {}
        self.signatures: Dict[str, FunctionSignature] = {}
        self.specialized_funcs: List[FuncDef] = []
        self.global_vars: Dict[str, str] = {}

    def run(self) -> Module:
        # Collect top-level constants first
        for stmt in self.module.statements:
            if isinstance(stmt, Assign):
                if isinstance(stmt.value, FloatLit):
                    self.global_vars[stmt.target] = "f64"
                elif isinstance(stmt.value, IntLit):
                    self.global_vars[stmt.target] = "i64"
                elif isinstance(stmt.value, BoolLit):
                    self.global_vars[stmt.target] = "bool"
                elif isinstance(stmt.value, StringLit):
                    self.global_vars[stmt.target] = "str"

        # 1. Collect structs & functions
        top_stmts: List[Stmt] = []
        for stmt in self.module.statements:
            if isinstance(stmt, StructDef):
                for f in stmt.fields:
                    f.type_ann = normalize_type(f.type_ann) or "i64"
                self.structs[stmt.name] = stmt
                # Lower struct methods into free functions `<StructName>__<method>(self, ...)`
                for m in stmt.methods:
                    lowered = copy.deepcopy(m)
                    lowered.name = f"{stmt.name}__{m.name}"
                    if lowered.params and lowered.params[0].name == "self":
                        lowered.params[0].type_ann = stmt.name
                    self.funcs[lowered.name] = lowered
                top_stmts.append(stmt)
            elif isinstance(stmt, FuncDef):
                self.funcs[stmt.name] = stmt
                top_stmts.append(stmt)
            else:
                top_stmts.append(stmt)

        # 2. Initial default signatures for declared functions
        for name, fn in self.funcs.items():
            p_types = [normalize_type(p.type_ann) or self._infer_param_from_body(fn, p.name) for p in fn.params]
            r_type = normalize_type(fn.return_type) or "i64"
            self.signatures[name] = FunctionSignature(name=name, param_types=p_types, return_type=r_type)

        # 3. Fixed-point iteration across functions and top-level statements
        for _ in range(3):
            for name, fn in list(self.funcs.items()):
                sig = self.signatures[name]
                env: Dict[str, str] = {}
                for p, pt in zip(fn.params, sig.param_types):
                    env[p.name] = pt
                    p.type_ann = pt
                ret_candidates: List[str] = []
                self._infer_block(fn.body, env, ret_candidates)
                if fn.return_type is not None:
                    sig.return_type = normalize_type(fn.return_type) or "i64"
                elif ret_candidates:
                    rt = ret_candidates[0]
                    for rc in ret_candidates[1:]:
                        rt = unify_types(rt, rc)
                    sig.return_type = rt
                else:
                    sig.return_type = "void"
                fn.return_type = sig.return_type
                sig.var_types = env

            # Infer top-level statements (and synthesize specializations if polymorphic calls occur)
            top_ret: List[str] = []
            self._infer_block(top_stmts, self.global_vars, top_ret)

        # Append any synthesized specialized functions or struct methods before top-level execution
        final_stmts: List[Stmt] = []
        seen_funcs = set()
        for stmt in top_stmts:
            if isinstance(stmt, StructDef):
                final_stmts.append(stmt)
                for m in stmt.methods:
                    m_name = f"{stmt.name}__{m.name}"
                    if m_name in self.funcs and m_name not in seen_funcs:
                        final_stmts.append(self.funcs[m_name])
                        seen_funcs.add(m_name)
            elif isinstance(stmt, FuncDef):
                final_stmts.append(stmt)
                seen_funcs.add(stmt.name)
                for sp in self.specialized_funcs:
                    if sp.name not in seen_funcs:
                        final_stmts.append(sp)
                        seen_funcs.add(sp.name)
            else:
                final_stmts.append(stmt)

        for sp in self.specialized_funcs:
            if sp.name not in seen_funcs:
                final_stmts.insert(0, sp)
                seen_funcs.add(sp.name)

        self.module.statements = final_stmts
        return self.module

    def _infer_param_from_body(self, fn: FuncDef, param_name: str) -> str:
        """Scan function body for float operations involving param_name."""
        def scan_expr(e: Expr) -> Optional[str]:
            if isinstance(e, BinOp):
                if isinstance(e.left, Var) and e.left.name == param_name and isinstance(e.right, FloatLit):
                    return "f64"
                if isinstance(e.right, Var) and e.right.name == param_name and isinstance(e.left, FloatLit):
                    return "f64"
                return scan_expr(e.left) or scan_expr(e.right)
            if isinstance(e, IndexExpr) and isinstance(e.target, Var) and e.target.name == param_name:
                return "Array[i64]"
            return None

        def scan_stmts(stmts: List[Stmt]) -> Optional[str]:
            for s in stmts:
                if isinstance(s, Return) and s.value:
                    r = scan_expr(s.value)
                    if r:
                        return r
                elif isinstance(s, Assign):
                    r = scan_expr(s.value)
                    if r:
                        return r
                elif isinstance(s, IndexAssign) and isinstance(s.target, Var) and s.target.name == param_name:
                    return "Array[i64]"
                elif isinstance(s, IfStmt):
                    r = scan_expr(s.cond) or scan_stmts(s.then_body) or scan_stmts(s.else_body)
                    if r:
                        return r
                elif isinstance(s, (WhileStmt, ForRangeStmt)):
                    r = scan_stmts(s.body)
                    if r:
                        return r
            return None

        return scan_stmts(fn.body) or "i64"

    def _infer_block(self, stmts: List[Stmt], env: Dict[str, str], ret_candidates: List[str]) -> None:
        for stmt in stmts:
            if isinstance(stmt, Assign):
                val_t = self._infer_expr(stmt.value, env)
                ann_t = normalize_type(stmt.type_ann)
                final_t = ann_t or val_t
                if stmt.target in env and ann_t is None:
                    final_t = unify_types(env[stmt.target], val_t)
                env[stmt.target] = final_t
                stmt.type_ann = final_t
            elif isinstance(stmt, AugAssign):
                val_t = self._infer_expr(stmt.value, env)
                cur_t = env.get(stmt.target, "i64")
                res_t = "f64" if stmt.op == "/" else unify_types(cur_t, val_t)
                env[stmt.target] = res_t
            elif isinstance(stmt, IndexAssign):
                arr_t = self._infer_expr(stmt.target, env)
                self._infer_expr(stmt.index, env)
                val_t = self._infer_expr(stmt.value, env)
                if isinstance(stmt.target, Var) and val_t == "f64" and arr_t == "Array[i64]":
                    env[stmt.target.name] = "Array[f64]"
            elif isinstance(stmt, IndexAugAssign):
                self._infer_expr(stmt.target, env)
                self._infer_expr(stmt.index, env)
                self._infer_expr(stmt.value, env)
            elif isinstance(stmt, FieldAssign):
                self._infer_expr(stmt.target, env)
                self._infer_expr(stmt.value, env)
            elif isinstance(stmt, Return):
                if stmt.value is not None:
                    rt = self._infer_expr(stmt.value, env)
                    ret_candidates.append(rt)
                else:
                    ret_candidates.append("void")
            elif isinstance(stmt, IfStmt):
                self._infer_expr(stmt.cond, env)
                self._infer_block(stmt.then_body, env, ret_candidates)
                for e_cond, e_body in stmt.elif_branches:
                    self._infer_expr(e_cond, env)
                    self._infer_block(e_body, env, ret_candidates)
                self._infer_block(stmt.else_body, env, ret_candidates)
            elif isinstance(stmt, WhileStmt):
                self._infer_expr(stmt.cond, env)
                self._infer_block(stmt.body, env, ret_candidates)
            elif isinstance(stmt, ForRangeStmt):
                self._infer_expr(stmt.start, env)
                self._infer_expr(stmt.stop, env)
                self._infer_expr(stmt.step, env)
                env[stmt.var_name] = "i64"
                self._infer_block(stmt.body, env, ret_candidates)
            elif isinstance(stmt, MatchStmt):
                self._infer_expr(stmt.subject, env)
                for c in stmt.cases:
                    if c.pattern is not None:
                        self._infer_expr(c.pattern, env)
                    self._infer_block(c.body, env, ret_candidates)
            elif isinstance(stmt, ExprStmt):
                self._infer_expr(stmt.expr, env)

    def _infer_expr(self, expr: Expr, env: Dict[str, str]) -> str:
        if isinstance(expr, IntLit):
            expr.inferred_type = "i64"
            return "i64"
        if isinstance(expr, FloatLit):
            expr.inferred_type = "f64"
            return "f64"
        if isinstance(expr, BoolLit):
            expr.inferred_type = "bool"
            return "bool"
        if isinstance(expr, StringLit):
            expr.inferred_type = "str"
            return "str"
        if isinstance(expr, Var):
            t = env.get(expr.name) or self.global_vars.get(expr.name, "i64")
            expr.inferred_type = t
            return t
        if isinstance(expr, UnaryOp):
            ot = self._infer_expr(expr.operand, env)
            if expr.op == "not":
                expr.inferred_type = "bool"
                return "bool"
            expr.inferred_type = ot
            return ot
        if isinstance(expr, BinOp):
            lt = self._infer_expr(expr.left, env)
            rt = self._infer_expr(expr.right, env)
            if expr.op in ("==", "!=", "<", "<=", ">", ">=", "and", "or"):
                expr.inferred_type = "bool"
                return "bool"
            if expr.op == "+" and (lt == "str" or rt == "str"):
                expr.inferred_type = "str"
                return "str"
            if expr.op == "/":
                expr.inferred_type = "f64"
                return "f64"
            if expr.op in ("//", "%", "&", "|", "^", "<<", ">>"):
                expr.inferred_type = "i64"
                return "i64"
            ut = unify_types(lt, rt)
            expr.inferred_type = ut
            return ut
        if isinstance(expr, TernaryIf):
            self._infer_expr(expr.cond, env)
            tt = self._infer_expr(expr.then_expr, env)
            et = self._infer_expr(expr.else_expr, env)
            ut = unify_types(tt, et)
            expr.inferred_type = ut
            return ut
        if isinstance(expr, ArrayLit):
            if expr.repeat_value is not None and expr.repeat_count is not None:
                vt = self._infer_expr(expr.repeat_value, env)
                self._infer_expr(expr.repeat_count, env)
                elem_t = "f64" if vt == "f64" else "i64"
                expr.inferred_type = f"Array[{elem_t}]"
                return expr.inferred_type
            elem_t = "i64"
            for el in expr.elements:
                et = self._infer_expr(el, env)
                if et == "f64":
                    elem_t = "f64"
            expr.inferred_type = f"Array[{elem_t}]"
            return expr.inferred_type
        if isinstance(expr, IndexExpr):
            tt = self._infer_expr(expr.target, env)
            self._infer_expr(expr.index, env)
            if tt == "Array[f64]":
                expr.inferred_type = "f64"
                return "f64"
            if tt == "str":
                expr.inferred_type = "str"
                return "str"
            expr.inferred_type = "i64"
            return "i64"
        if isinstance(expr, SliceExpr):
            tt = self._infer_expr(expr.target, env)
            if expr.start is not None:
                self._infer_expr(expr.start, env)
            if expr.stop is not None:
                self._infer_expr(expr.stop, env)
            if expr.step is not None:
                self._infer_expr(expr.step, env)
            expr.inferred_type = tt
            return tt
        if isinstance(expr, FieldAccess):
            tt = self._infer_expr(expr.target, env)
            if tt in self.structs:
                sdef = self.structs[tt]
                for f in sdef.fields:
                    if f.name == expr.field_name:
                        expr.inferred_type = f.type_ann
                        return f.type_ann
            expr.inferred_type = "i64"
            return "i64"
        if isinstance(expr, MethodCall):
            tt = self._infer_expr(expr.target, env)
            for a in expr.args:
                self._infer_expr(a, env)
            m_name = f"{tt}__{expr.method}"
            if m_name in self.signatures:
                rt = self.signatures[m_name].return_type
                expr.inferred_type = rt
                return rt
            expr.inferred_type = "i64"
            return "i64"
        if isinstance(expr, RangeExpr):
            self._infer_expr(expr.start, env)
            self._infer_expr(expr.stop, env)
            self._infer_expr(expr.step, env)
            expr.inferred_type = "Range"
            return "Range"
        if isinstance(expr, Call):
            arg_types = [self._infer_expr(a, env) for a in expr.args]
            # Built-in functions
            if expr.func in ("int", "i64", "abs", "len", "ord", "min", "max", "clock_ns"):
                if expr.func in ("abs", "min", "max") and any(t == "f64" for t in arg_types):
                    expr.inferred_type = "f64"
                    return "f64"
                expr.inferred_type = "i64"
                return "i64"
            if expr.func in ("float", "f64", "sqrt", "sin", "cos", "exp", "log", "fabs", "clock_sec"):
                expr.inferred_type = "f64"
                return "f64"
            if expr.func == "bool":
                expr.inferred_type = "bool"
                return "bool"
            if expr.func in ("str", "chr"):
                expr.inferred_type = "str"
                return "str"
            if expr.func == "print":
                expr.inferred_type = "void"
                return "void"
            if expr.func in self.structs:
                expr.inferred_type = expr.func
                return expr.func

            # User-defined function call: check if specialization is needed
            if expr.func in self.funcs:
                fn = self.funcs[expr.func]
                sig = self.signatures[expr.func]
                if len(arg_types) == len(sig.param_types) and arg_types != sig.param_types:
                    # If original function had unannotated params and is called with f64, specialize!
                    has_unannotated = any(p.type_ann in (None, "i64", "f64") for p in fn.params)
                    if has_unannotated and any(t == "f64" for t in arg_types):
                        spec_suffix = "_".join(t.replace("[", "_").replace("]", "") for t in arg_types)
                        spec_name = f"{expr.func}__{spec_suffix}"
                        if spec_name not in self.funcs:
                            spec_fn = copy.deepcopy(fn)
                            spec_fn.name = spec_name
                            for p, at in zip(spec_fn.params, arg_types):
                                p.type_ann = at
                            spec_env = {p.name: at for p, at in zip(spec_fn.params, arg_types)}
                            spec_rets: List[str] = []
                            self._infer_block(spec_fn.body, spec_env, spec_rets)
                            spec_rt = spec_rets[0] if spec_rets else "i64"
                            for r in spec_rets[1:]:
                                spec_rt = unify_types(spec_rt, r)
                            spec_fn.return_type = spec_rt
                            self.funcs[spec_name] = spec_fn
                            self.signatures[spec_name] = FunctionSignature(
                                name=spec_name,
                                param_types=list(arg_types),
                                return_type=spec_rt,
                                var_types=spec_env,
                            )
                            self.specialized_funcs.append(spec_fn)
                        expr.func = spec_name
                        expr.inferred_type = self.signatures[spec_name].return_type
                        return expr.inferred_type

                expr.inferred_type = sig.return_type
                return sig.return_type

            expr.inferred_type = "i64"
            return "i64"

        expr.inferred_type = "i64"
        return "i64"
