"""
Black Mamba (.bmb) Cartesian Type Inference, Unification, C3 MRO & Monomorphization Engine.

Bridges standard Python types (`int`, `float`, `bool`, `str`, `list`), systems types
(`i64`, `i32`, `u64`, `f64`, `Array[i64]`, `Array[f64]`, `void`), and full dynamic OOP
classes (C3 diamond multiple inheritance, `super()`, virtual vtables, monkey-patching,
and hierarchical exceptions) without Mojo's `fn`/`def` schism or Nim's mandatory `proc` signatures.
"""

import copy
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Set, Tuple
from .ast_nodes import (
    ArrayLit,
    Assign,
    AugAssign,
    BinOp,
    BoolLit,
    Call,
    DictComp,
    DictLit,
    Expr,
    ExprStmt,
    ExternBlock,
    ExternFuncDecl,
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
    ListComp,
    MatchStmt,
    MethodCall,
    Module,
    Param,
    RaiseStmt,
    RangeExpr,
    Return,
    SliceExpr,
    Stmt,
    StringLit,
    StructDef,
    StructField,
    TernaryIf,
    TryStmt,
    UnaryOp,
    Var,
    WhileStmt,
    WithItem,
    WithStmt,
    YieldExpr,
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
    "ptr": "i64",
    "pointer": "i64",
    "void*": "i64",
    "char*": "str",
    "cstring": "str",
    "c_char_p": "str",
    "size_t": "i64",
    "usize": "i64",
    "uintptr": "i64",
    "intptr": "i64",
    "i8": "i64",
    "u8": "i64",
    "i16": "i64",
    "u16": "i64",
    "u32": "i64",
    "uint32": "i64",
    "int32": "i64",
    "c_int": "i64",
    "c_uint": "i64",
    "c_long": "i64",
    "c_ulong": "i64",
    "double": "f64",
    "c_float": "f64",
    "c_double": "f64",
    "list[int]": "Array[i64]",
    "list[i64]": "Array[i64]",
    "List[int]": "Array[i64]",
    "List[i64]": "Array[i64]",
    "Array[int]": "Array[i64]",
    "Array[i64]": "Array[i64]",
    "list[float]": "Array[f64]",
    "list[f64]": "Array[f64]",
    "List[float]": "Array[f64]",
    "List[f64]": "Array[f64]",
    "Array[float]": "Array[f64]",
    "Array[f64]": "Array[f64]",
    "Tensor": "Array[f64]",
    "Tensor[f64]": "Array[f64]",
    "Tensor[float]": "Array[f64]",
    "Tensor[i64]": "Array[i64]",
    "Tensor[int]": "Array[i64]",
    "ndarray": "Array[f64]",
    "ndarray[f64]": "Array[f64]",
    "ndarray[float]": "Array[f64]",
    "ndarray[i64]": "Array[i64]",
    "ndarray[int]": "Array[i64]",
    "dict": "Dict",
    "Dict": "Dict",
}

OP_TO_DUNDER = {
    "+": "__add__",
    "-": "__sub__",
    "*": "__mul__",
    "/": "__truediv__",
    "//": "__floordiv__",
    "%": "__mod__",
    "&": "__and__",
    "|": "__or__",
    "^": "__xor__",
    "<<": "__lshift__",
    ">>": "__rshift__",
    "==": "__eq__",
    "!=": "__ne__",
    "<": "__lt__",
    "<=": "__le__",
    ">": "__gt__",
    ">=": "__ge__",
}

BUILTIN_EXCEPTION_SPECS: List[Tuple[str, List[str]]] = [
    ("BaseException", []),
    ("Exception", ["BaseException"]),
    ("RuntimeError", ["Exception"]),
    ("ValueError", ["Exception"]),
    ("TypeError", ["Exception"]),
    ("KeyError", ["Exception"]),
    ("IndexError", ["Exception"]),
    ("ZeroDivisionError", ["Exception"]),
    ("IOError", ["Exception"]),
    ("OSError", ["IOError"]),
    ("AssertionError", ["Exception"]),
]
BUILTIN_EXCEPTION_NAMES: Set[str] = {name for name, _ in BUILTIN_EXCEPTION_SPECS}


def normalize_type(t: Optional[str]) -> Optional[str]:
    if t is None:
        return None
    if t in TYPE_ALIASES:
        return TYPE_ALIASES[t]
    if t.startswith(("List[", "list[", "Array[", "Tensor[", "ndarray[")) and t.endswith("]"):
        inner = t[t.index("[") + 1 : -1].strip()
        inner_norm = normalize_type(inner)
        if inner_norm in ("f64", "float"):
            return "Array[f64]"
        elif inner_norm in ("i64", "int", "bool"):
            return "Array[i64]"
    return TYPE_ALIASES.get(t, t)


def unify_types(
    t1: Optional[str],
    t2: Optional[str],
    mro_map: Optional[Dict[str, List[str]]] = None,
) -> str:
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
    if mro_map and t1 in mro_map and t2 in mro_map:
        m2 = set(mro_map[t2])
        for anc in mro_map[t1]:
            if anc in m2:
                return anc
    if "str" in (t1, t2):
        return "str"
    if {t1, t2} <= {"i64", "f64", "bool"}:
        if "f64" in (t1, t2):
            return "f64"
        if "i64" in (t1, t2):
            return "i64"
        return "bool"
    return t1


def compute_c3_mro(cls_name: str, bases_map: Dict[str, List[str]], memo: Optional[Dict[str, List[str]]] = None) -> List[str]:
    """Exact Python 3 C3 Linearization algorithm for single and diamond multiple inheritance."""
    if memo is None:
        memo = {}
    if cls_name in memo:
        return list(memo[cls_name])

    bases = [b for b in bases_map.get(cls_name, []) if b in bases_map]
    if not bases:
        memo[cls_name] = [cls_name]
        return [cls_name]

    seqs: List[List[str]] = [compute_c3_mro(b, bases_map, memo) for b in bases] + [list(bases)]
    res: List[str] = [cls_name]

    while True:
        non_empty = [s for s in seqs if s]
        if not non_empty:
            break
        candidate: Optional[str] = None
        for seq in non_empty:
            head = seq[0]
            if not any(head in other[1:] for other in non_empty):
                candidate = head
                break
        if candidate is None:
            raise TypeError(
                f"Cannot create a consistent method resolution order (MRO) for class '{cls_name}' with bases {bases}"
            )
        res.append(candidate)
        for seq in non_empty:
            if seq[0] == candidate:
                seq.pop(0)

    memo[cls_name] = res
    return list(res)


@dataclass
class FunctionSignature:
    name: str
    param_types: List[str]
    return_type: str
    var_types: Dict[str, str] = field(default_factory=dict)


class TypeInferencer:
    """
    Whole-program flow-sensitive + call-site Cartesian type inference, C3 MRO linearization,
    and monomorphization pass.
    """

    def __init__(self, module: Module):
        self.module = module
        self.structs: Dict[str, StructDef] = {}
        self.funcs: Dict[str, FuncDef] = {}
        self.signatures: Dict[str, FunctionSignature] = {}
        self.extern_blocks: List[ExternBlock] = []
        self.extern_funcs: Dict[str, Tuple[str, Optional[str], List[Tuple[str, str]], str, str]] = {}
        self.specialized_funcs: List[FuncDef] = []
        self.global_vars: Dict[str, str] = {}

        # Dynamic OOP & Exception metadata passed to MIRBuilder
        self.has_exceptions: bool = False
        self.dynamic_classes: Set[str] = set()
        self.mro: Dict[str, List[str]] = {}
        self.class_ids: Dict[str, int] = {}
        self.mro_masks: Dict[str, int] = {}
        self.class_field_offsets: Dict[Tuple[str, str], int] = {}
        self.class_alloc_slots: Dict[str, int] = {}
        self.vtable_indices: Dict[Tuple[str, str], int] = {}
        self.vtable_methods: Dict[str, List[str]] = {}
        self.vtable_method_owners: Dict[Tuple[str, str], str] = {}
        self.dyn_attr_types: Dict[Tuple[str, str], str] = {}

    def _scan_features(self) -> Tuple[bool, bool, Set[str], List[Tuple[str, str, Optional[str]]]]:
        """
        Scan AST for:
        1. `has_exc_flow`: True iff any `TryStmt` or `RaiseStmt` exists
        2. `needs_exc_classes`: True iff `has_exc_flow` or any built-in exception class is referenced
        3. `dyn_op_targets`: struct/class names explicitly referenced in `setattr`/`getattr`/`hasattr`/`isinstance`
        4. `monkey_methods`: `(cls_name, method_name, target_fn_name)` from `setattr(Cls, "m", fn)`
        """
        has_exc_flow = False
        needs_exc_classes = False
        dyn_op_targets: Set[str] = set()
        monkey_methods: List[Tuple[str, str, Optional[str]]] = []

        def scan_expr(e: Optional[Expr]) -> None:
            nonlocal needs_exc_classes
            if e is None:
                return
            if isinstance(e, Var):
                if e.name in BUILTIN_EXCEPTION_NAMES:
                    needs_exc_classes = True
            elif isinstance(e, Call):
                if e.func in BUILTIN_EXCEPTION_NAMES:
                    needs_exc_classes = True
                if e.func == "setattr" and len(e.args) == 3:
                    if isinstance(e.args[0], Var):
                        dyn_op_targets.add(e.args[0].name)
                        if isinstance(e.args[1], StringLit):
                            fn_ref = e.args[2].name if isinstance(e.args[2], Var) else None
                            monkey_methods.append((e.args[0].name, e.args[1].value, fn_ref))
                elif e.func == "isinstance" and len(e.args) == 2:
                    if isinstance(e.args[1], Var):
                        dyn_op_targets.add(e.args[1].name)
                        if e.args[1].name in BUILTIN_EXCEPTION_NAMES:
                            needs_exc_classes = True
                    elif isinstance(e.args[1], ArrayLit):
                        for el in e.args[1].elements:
                            if isinstance(el, Var):
                                dyn_op_targets.add(el.name)
                                if el.name in BUILTIN_EXCEPTION_NAMES:
                                    needs_exc_classes = True
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
            elif isinstance(e, TernaryIf):
                scan_expr(e.cond)
                scan_expr(e.then_expr)
                scan_expr(e.else_expr)
            elif isinstance(e, FieldAccess):
                scan_expr(e.target)
            elif isinstance(e, IndexExpr):
                scan_expr(e.target)
                scan_expr(e.index)
            elif isinstance(e, SliceExpr):
                scan_expr(e.target)
                scan_expr(e.start)
                scan_expr(e.stop)
                scan_expr(e.step)
            elif isinstance(e, ArrayLit):
                for el in e.elements:
                    scan_expr(el)
                scan_expr(e.repeat_value)
                scan_expr(e.repeat_count)
            elif isinstance(e, RangeExpr):
                scan_expr(e.start)
                scan_expr(e.stop)
                scan_expr(e.step)

        def scan_stmt(s: Stmt) -> None:
            nonlocal has_exc_flow, needs_exc_classes
            if isinstance(s, TryStmt):
                has_exc_flow = True
                needs_exc_classes = True
                for b in s.body:
                    scan_stmt(b)
                for h in s.handlers:
                    for et in h.exc_types:
                        dyn_op_targets.add(et)
                    for b in h.body:
                        scan_stmt(b)
                for b in s.else_body:
                    scan_stmt(b)
                for b in s.finally_body:
                    scan_stmt(b)
            elif isinstance(s, RaiseStmt):
                has_exc_flow = True
                needs_exc_classes = True
                scan_expr(s.exc)
            elif isinstance(s, StructDef):
                for b_name in s.bases:
                    if b_name in BUILTIN_EXCEPTION_NAMES:
                        needs_exc_classes = True
                for f in s.fields:
                    scan_expr(f.default)
                for m in s.methods:
                    scan_stmt(m)
            elif isinstance(s, FuncDef):
                for p in s.params:
                    scan_expr(p.default)
                for b in s.body:
                    scan_stmt(b)
            elif isinstance(s, ExprStmt):
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
            elif isinstance(s, Return):
                scan_expr(s.value)
            elif isinstance(s, IfStmt):
                scan_expr(s.cond)
                for b in s.then_body:
                    scan_stmt(b)
                for c, body in s.elif_branches:
                    scan_expr(c)
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
                    scan_expr(c.pattern)
                    for b in c.body:
                        scan_stmt(b)

        for st in self.module.statements:
            scan_stmt(st)
        return has_exc_flow, needs_exc_classes, dyn_op_targets, monkey_methods

    def _mro_fn_name(self, cls_name: str, owner_cls: str, method_name: str, winner_cls: str) -> str:
        if owner_cls == winner_cls:
            return f"{cls_name}__{method_name}"
        return f"{cls_name}__super_{owner_cls}__{method_name}"

    def _rewrite_super_in_stmts(
        self,
        stmts: List[Stmt],
        cls_name: str,
        owner_cls: str,
        mro_list: List[str],
        raw_methods: Dict[Tuple[str, str], FuncDef],
        winner_map: Dict[str, str],
    ) -> None:
        owner_idx = mro_list.index(owner_cls)

        def rw_expr(e: Optional[Expr]) -> Optional[Expr]:
            if e is None:
                return None
            if isinstance(e, MethodCall) and isinstance(e.target, Call) and e.target.func == "super":
                new_args = [rw_expr(a) for a in e.args]
                # Cooperative C3 super() resolution: find next class after `owner_cls` in `mro_list` defining `e.method`
                search_start = owner_idx + 1
                if len(e.target.args) >= 1 and isinstance(e.target.args[0], Var) and e.target.args[0].name in mro_list:
                    search_start = mro_list.index(e.target.args[0].name) + 1
                next_owner: Optional[str] = None
                for cand in mro_list[search_start:]:
                    if (cand, e.method) in raw_methods:
                        next_owner = cand
                        break
                if next_owner is not None:
                    target_fn = self._mro_fn_name(cls_name, next_owner, e.method, winner_map[e.method])
                    return Call(
                        line=e.line,
                        col=e.col,
                        func=target_fn,
                        args=[Var(line=e.line, col=e.col, name="self", inferred_type=cls_name)] + new_args,
                        super_target=(next_owner, e.method),
                    )
                return IntLit(line=e.line, col=e.col, value=0)
            if isinstance(e, MethodCall):
                e.target = rw_expr(e.target)
                e.args = [rw_expr(a) for a in e.args]
                return e
            if isinstance(e, Call):
                e.args = [rw_expr(a) for a in e.args]
                return e
            if isinstance(e, BinOp):
                e.left = rw_expr(e.left)
                e.right = rw_expr(e.right)
                return e
            if isinstance(e, UnaryOp):
                e.operand = rw_expr(e.operand)
                return e
            if isinstance(e, TernaryIf):
                e.cond = rw_expr(e.cond)
                e.then_expr = rw_expr(e.then_expr)
                e.else_expr = rw_expr(e.else_expr)
                return e
            if isinstance(e, FieldAccess):
                e.target = rw_expr(e.target)
                return e
            if isinstance(e, IndexExpr):
                e.target = rw_expr(e.target)
                e.index = rw_expr(e.index)
                return e
            if isinstance(e, SliceExpr):
                e.target = rw_expr(e.target)
                e.start = rw_expr(e.start)
                e.stop = rw_expr(e.stop)
                e.step = rw_expr(e.step)
                return e
            if isinstance(e, ArrayLit):
                e.elements = [rw_expr(el) for el in e.elements]
                e.repeat_value = rw_expr(e.repeat_value)
                e.repeat_count = rw_expr(e.repeat_count)
                return e
            if isinstance(e, RangeExpr):
                e.start = rw_expr(e.start)
                e.stop = rw_expr(e.stop)
                e.step = rw_expr(e.step)
                return e
            return e

        for s in stmts:
            if isinstance(s, ExprStmt):
                s.expr = rw_expr(s.expr)
            elif isinstance(s, (Assign, AugAssign)):
                s.value = rw_expr(s.value)
            elif isinstance(s, FieldAssign):
                s.target = rw_expr(s.target)
                s.value = rw_expr(s.value)
            elif isinstance(s, (IndexAssign, IndexAugAssign)):
                s.target = rw_expr(s.target)
                s.index = rw_expr(s.index)
                s.value = rw_expr(s.value)
            elif isinstance(s, Return) and s.value is not None:
                s.value = rw_expr(s.value)
            elif isinstance(s, RaiseStmt) and s.exc is not None:
                s.exc = rw_expr(s.exc)
            elif isinstance(s, IfStmt):
                s.cond = rw_expr(s.cond)
                self._rewrite_super_in_stmts(s.then_body, cls_name, owner_cls, mro_list, raw_methods, winner_map)
                for idx, (ec, eb) in enumerate(s.elif_branches):
                    self._rewrite_super_in_stmts(eb, cls_name, owner_cls, mro_list, raw_methods, winner_map)
                    s.elif_branches[idx] = (rw_expr(ec), eb)
                self._rewrite_super_in_stmts(s.else_body, cls_name, owner_cls, mro_list, raw_methods, winner_map)
            elif isinstance(s, WhileStmt):
                s.cond = rw_expr(s.cond)
                self._rewrite_super_in_stmts(s.body, cls_name, owner_cls, mro_list, raw_methods, winner_map)
            elif isinstance(s, ForRangeStmt):
                s.start = rw_expr(s.start)
                s.stop = rw_expr(s.stop)
                s.step = rw_expr(s.step)
                self._rewrite_super_in_stmts(s.body, cls_name, owner_cls, mro_list, raw_methods, winner_map)
            elif isinstance(s, MatchStmt):
                s.subject = rw_expr(s.subject)
                for c in s.cases:
                    c.pattern = rw_expr(c.pattern)
                    self._rewrite_super_in_stmts(c.body, cls_name, owner_cls, mro_list, raw_methods, winner_map)
            elif isinstance(s, TryStmt):
                self._rewrite_super_in_stmts(s.body, cls_name, owner_cls, mro_list, raw_methods, winner_map)
                for h in s.handlers:
                    self._rewrite_super_in_stmts(h.body, cls_name, owner_cls, mro_list, raw_methods, winner_map)
                self._rewrite_super_in_stmts(s.else_body, cls_name, owner_cls, mro_list, raw_methods, winner_map)
                self._rewrite_super_in_stmts(s.finally_body, cls_name, owner_cls, mro_list, raw_methods, winner_map)

    def run(self) -> Module:
        has_exc_flow, needs_exc_classes, dyn_op_targets, monkey_methods = self._scan_features()
        self.has_exceptions = has_exc_flow

        # Prepend built-in exception hierarchy if exceptions or built-in exception classes are used
        defined_struct_names = {s.name for s in self.module.statements if isinstance(s, StructDef)}
        if needs_exc_classes:
            builtin_defs: List[Stmt] = []
            for exc_name, exc_bases in BUILTIN_EXCEPTION_SPECS:
                if exc_name not in defined_struct_names:
                    fields = (
                        [
                            StructField(name="message", type_ann="str", default=StringLit(value="")),
                            StructField(name="code", type_ann="i64", default=IntLit(value=0)),
                            StructField(name="line", type_ann="i64", default=IntLit(value=0)),
                        ]
                        if exc_name == "BaseException"
                        else []
                    )
                    builtin_defs.append(
                        StructDef(line=1, col=1, name=exc_name, fields=fields, methods=[], bases=list(exc_bases), is_class=True)
                    )
            self.module.statements = builtin_defs + self.module.statements

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

        # 1. Collect structs/classes & free functions
        raw_own_fields: Dict[str, List[StructField]] = {}
        raw_methods: Dict[Tuple[str, str], FuncDef] = {}
        top_stmts: List[Stmt] = []

        for stmt in self.module.statements:
            if isinstance(stmt, StructDef):
                for f in stmt.fields:
                    f.type_ann = normalize_type(f.type_ann) or "i64"
                self.structs[stmt.name] = stmt
                raw_own_fields[stmt.name] = copy.deepcopy(stmt.fields)
                for m in stmt.methods:
                    raw_methods[(stmt.name, m.name)] = copy.deepcopy(m)
                top_stmts.append(stmt)
            elif isinstance(stmt, FuncDef):
                self.funcs[stmt.name] = stmt
                top_stmts.append(stmt)
            elif isinstance(stmt, ExternBlock):
                self.extern_blocks.append(stmt)
                for fn in stmt.functions:
                    p_types = [(p.name, normalize_type(p.type_ann) or "i64") for p in fn.params]
                    r_type = normalize_type(fn.return_type) or "void"
                    lib_sym = fn.lib_symbol or fn.name
                    self.extern_funcs[fn.name] = (stmt.abi, stmt.lib_name, p_types, r_type, lib_sym)
                    self.signatures[fn.name] = FunctionSignature(
                        name=fn.name,
                        param_types=[pt for _, pt in p_types],
                        return_type=r_type,
                    )
                    dummy_params = [Param(name=pn, type_ann=pt) for pn, pt in p_types]
                    self.funcs[fn.name] = FuncDef(
                        line=fn.line,
                        col=fn.col,
                        name=fn.name,
                        params=dummy_params,
                        return_type=r_type,
                        body=[],
                    )
                top_stmts.append(stmt)
            else:
                top_stmts.append(stmt)

        # 1b. Compute C3 MRO & identify dynamic OOP classes vs 0-header value structs
        bases_map = {name: list(s.bases) for name, s in self.structs.items()}
        mro_memo: Dict[str, List[str]] = {}
        for name in self.structs:
            self.mro[name] = compute_c3_mro(name, bases_map, mro_memo)

        referenced_as_base = {b for s in self.structs.values() for b in s.bases}
        for name, sdef in self.structs.items():
            if sdef.is_class or sdef.bases or name in referenced_as_base or name in dyn_op_targets:
                for anc in self.mro[name]:
                    if anc in self.structs:
                        self.dynamic_classes.add(anc)
        # Also propagate downward to any subclass of a dynamic class
        for name in self.structs:
            if any(anc in self.dynamic_classes for anc in self.mro[name]):
                self.dynamic_classes.add(name)

        # Assign class IDs and 64-bit MRO bitmasks for 1-cycle `isinstance` & `except` matching
        for idx, cls_name in enumerate(self.dynamic_classes):
            self.class_ids[cls_name] = idx % 62
        for cls_name in self.dynamic_classes:
            mask = 0
            for anc in self.mro[cls_name]:
                if anc in self.class_ids:
                    mask |= 1 << self.class_ids[anc]
            self.mro_masks[cls_name] = mask

        # Build connected inheritance components for dynamic classes so diamond fields & vtables
        # share exact fixed slot offsets across all upcasts/downcasts!
        adj: Dict[str, Set[str]] = {c: set() for c in self.dynamic_classes}
        for c in self.dynamic_classes:
            for b in self.structs[c].bases:
                if b in self.dynamic_classes:
                    adj[c].add(b)
                    adj[b].add(c)

        visited_comp: Set[str] = set()
        class_lowered_methods: Dict[str, List[str]] = {c: [] for c in self.structs}

        for start_c in self.structs:
            if start_c not in self.dynamic_classes:
                # Plain 0-header value struct: direct method lowering
                sdef = self.structs[start_c]
                for m in sdef.methods:
                    lowered = copy.deepcopy(m)
                    lowered.name = f"{start_c}__{m.name}"
                    if lowered.params and lowered.params[0].name == "self":
                        lowered.params[0].type_ann = start_c
                    self.funcs[lowered.name] = lowered
                    class_lowered_methods[start_c].append(lowered.name)
                continue

            if start_c in visited_comp:
                continue

            # BFS connected component, then sort in topological order (ancestors before subclasses)
            comp_set: Set[str] = set()
            queue = [start_c]
            while queue:
                cur = queue.pop()
                if cur in comp_set:
                    continue
                comp_set.add(cur)
                visited_comp.add(cur)
                for nb in adj[cur]:
                    if nb not in comp_set:
                        queue.append(nb)

            comp_ordered = sorted(comp_set, key=lambda c: len(self.mro[c]))

            # Assign fixed component-wide field slot offsets starting at slot 3
            # (slot 0 = __type_mask__, slot 1 = __vtable_ptr__, slot 2 = __dyn_props__)
            comp_field_slot: Dict[str, int] = {}
            for c in comp_ordered:
                for anc in reversed(self.mro[c]):
                    for f in raw_own_fields.get(anc, []):
                        if f.name not in comp_field_slot:
                            comp_field_slot[f.name] = 3 + len(comp_field_slot)

            total_slots = 3 + len(comp_field_slot)

            # Collect all virtual method names in component (excluding __init__), including monkey-patched methods!
            comp_method_names: List[str] = []
            for c in comp_ordered:
                for m in self.structs[c].methods:
                    if m.name != "__init__" and m.name not in comp_method_names:
                        comp_method_names.append(m.name)
            for m_cls, m_name, _ in monkey_methods:
                if m_cls in comp_set and m_name != "__init__" and m_name not in comp_method_names:
                    comp_method_names.append(m_name)

            for c in comp_ordered:
                self.class_alloc_slots[c] = total_slots
                # Merge fields along MRO (root -> leaf) for constructor order
                merged_fields: List[StructField] = []
                field_by_name: Dict[str, StructField] = {}
                for anc in reversed(self.mro[c]):
                    for f in raw_own_fields.get(anc, []):
                        fc = copy.deepcopy(f)
                        if fc.name in field_by_name:
                            existing = field_by_name[fc.name]
                            existing.type_ann = fc.type_ann or existing.type_ann
                            if fc.default is not None:
                                existing.default = fc.default
                        else:
                            field_by_name[fc.name] = fc
                            merged_fields.append(fc)
                        self.class_field_offsets[(c, fc.name)] = comp_field_slot[fc.name]
                self.structs[c].fields = merged_fields

                # Determine MRO winner for each method reachable on `c`
                reachable_m_names: List[str] = []
                winner_map: Dict[str, str] = {}
                for anc in self.mro[c]:
                    for m in self.structs[anc].methods:
                        if m.name not in winner_map:
                            winner_map[m.name] = anc
                            reachable_m_names.append(m.name)

                # Specialize every (anc, m) in `mro[c]` with `self: c` and cooperative `super()`
                for anc in self.mro[c]:
                    for m in self.structs[anc].methods:
                        spec_m = copy.deepcopy(raw_methods[(anc, m.name)])
                        spec_m.name = self._mro_fn_name(c, anc, m.name, winner_map[m.name])
                        if spec_m.params and spec_m.params[0].name == "self":
                            spec_m.params[0].type_ann = c
                        self._rewrite_super_in_stmts(spec_m.body, c, anc, self.mro[c], raw_methods, winner_map)
                        self.funcs[spec_m.name] = spec_m
                        class_lowered_methods[c].append(spec_m.name)

                # Populate vtable layout for `c`
                vt_list: List[str] = []
                for v_idx, vm_name in enumerate(comp_method_names):
                    self.vtable_indices[(c, vm_name)] = v_idx
                    if vm_name in winner_map:
                        vt_list.append(f"{c}__{vm_name}")
                        self.vtable_method_owners[(c, vm_name)] = winner_map[vm_name]
                    else:
                        vt_list.append("")
                self.vtable_methods[c] = vt_list

        # 2. Initial default signatures for declared functions
        for name, fn in self.funcs.items():
            if name in self.signatures:
                continue
            p_types = [normalize_type(p.type_ann) or self._infer_param_from_body(fn, p.name) for p in fn.params]
            r_type = normalize_type(fn.return_type) or "i64"
            self.signatures[name] = FunctionSignature(name=name, param_types=p_types, return_type=r_type)

        # Register synthetic signatures for brand-new monkey-patched methods `setattr(Cls, "new_m", fn)`
        for m_cls, m_name, fn_ref in monkey_methods:
            if m_cls in self.dynamic_classes:
                for sub_c in self.dynamic_classes:
                    if m_cls in self.mro.get(sub_c, []):
                        synth_key = f"{sub_c}__{m_name}"
                        if synth_key not in self.signatures and fn_ref and fn_ref in self.signatures:
                            ref_sig = self.signatures[fn_ref]
                            self.signatures[synth_key] = FunctionSignature(
                                name=synth_key,
                                param_types=[sub_c] + list(ref_sig.param_types[1:]),
                                return_type=ref_sig.return_type,
                            )

        # 3. Fixed-point iteration across functions and top-level statements
        for _ in range(3):
            for name, fn in list(self.funcs.items()):
                if name in self.extern_funcs:
                    continue
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
                        rt = unify_types(rt, rc, self.mro)
                    sig.return_type = rt
                else:
                    sig.return_type = "void"
                fn.return_type = sig.return_type
                sig.var_types = env

            # Update synthetic monkey-patched signatures if target function's return type refined
            for m_cls, m_name, fn_ref in monkey_methods:
                if m_cls in self.dynamic_classes and fn_ref and fn_ref in self.signatures:
                    for sub_c in self.dynamic_classes:
                        if m_cls in self.mro.get(sub_c, []):
                            synth_key = f"{sub_c}__{m_name}"
                            if synth_key not in self.funcs:
                                self.signatures[synth_key] = FunctionSignature(
                                    name=synth_key,
                                    param_types=[sub_c] + list(self.signatures[fn_ref].param_types[1:]),
                                    return_type=self.signatures[fn_ref].return_type,
                                )

            # Infer top-level statements (and synthesize specializations if polymorphic calls occur)
            top_ret: List[str] = []
            self._infer_block(top_stmts, self.global_vars, top_ret)

        # Append any synthesized specialized functions or struct/class methods before top-level execution
        final_stmts: List[Stmt] = []
        seen_funcs = set()
        for stmt in top_stmts:
            if isinstance(stmt, StructDef):
                final_stmts.append(stmt)
                for m_name in class_lowered_methods.get(stmt.name, []):
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
                elif isinstance(s, TryStmt):
                    r = scan_stmts(s.body) or scan_stmts(s.else_body) or scan_stmts(s.finally_body)
                    if r:
                        return r
                    for h in s.handlers:
                        rh = scan_stmts(h.body)
                        if rh:
                            return rh
            return None

        return scan_stmts(fn.body) or "i64"

    def _infer_block(self, stmts: List[Stmt], env: Dict[str, str], ret_candidates: List[str]) -> None:
        for stmt in stmts:
            if isinstance(stmt, Assign):
                val_t = self._infer_expr(stmt.value, env)
                ann_t = normalize_type(stmt.type_ann)
                final_t = ann_t or val_t
                if stmt.target in env and ann_t is None:
                    final_t = unify_types(env[stmt.target], val_t, self.mro)
                env[stmt.target] = final_t
                stmt.type_ann = final_t
            elif isinstance(stmt, AugAssign):
                val_t = self._infer_expr(stmt.value, env)
                cur_t = env.get(stmt.target, "i64")
                res_t = "f64" if stmt.op == "/" else unify_types(cur_t, val_t, self.mro)
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
                obj_t = self._infer_expr(stmt.target, env)
                val_t = self._infer_expr(stmt.value, env)
                if obj_t in self.dynamic_classes:
                    has_static = any(f.name == stmt.field_name for f in self.structs[obj_t].fields)
                    if not has_static:
                        for sub_c in self.dynamic_classes:
                            if obj_t in self.mro.get(sub_c, []):
                                self.dyn_attr_types[(sub_c, stmt.field_name)] = val_t
            elif isinstance(stmt, Return):
                if stmt.value is not None:
                    rt = self._infer_expr(stmt.value, env)
                    ret_candidates.append(rt)
                else:
                    ret_candidates.append("void")
            elif isinstance(stmt, RaiseStmt):
                if stmt.exc is not None:
                    self._infer_expr(stmt.exc, env)
            elif isinstance(stmt, TryStmt):
                self._infer_block(stmt.body, env, ret_candidates)
                for h in stmt.handlers:
                    if h.var_name:
                        exc_t = h.exc_types[0] if len(h.exc_types) == 1 and h.exc_types[0] in self.structs else "Exception"
                        env[h.var_name] = exc_t
                    self._infer_block(h.body, env, ret_candidates)
                self._infer_block(stmt.else_body, env, ret_candidates)
                self._infer_block(stmt.finally_body, env, ret_candidates)
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
                    if c.guard is not None:
                        self._infer_expr(c.guard, env)
                    self._infer_block(c.body, env, ret_candidates)
            elif isinstance(stmt, WithStmt):
                for it in stmt.items:
                    ctx_t = self._infer_expr(it.context_expr, env)
                    if it.optional_vars:
                        enter_m = f"{ctx_t}____enter__"
                        ret_t = self.signatures[enter_m].return_type if enter_m in self.signatures else ctx_t
                        env[it.optional_vars] = ret_t
                self._infer_block(stmt.body, env, ret_candidates)
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
            if expr.name in ("__name__", "__file__"):
                expr.inferred_type = "str"
                return "str"
            if expr.name in self.structs and expr.name not in env:
                expr.inferred_type = expr.name
                return expr.name
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
            dunder = OP_TO_DUNDER.get(expr.op)
            if dunder and lt in self.structs:
                m_name = f"{lt}__{dunder}"
                if m_name in self.signatures:
                    expr.inferred_type = self.signatures[m_name].return_type
                    return expr.inferred_type
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
            ut = unify_types(lt, rt, self.mro)
            expr.inferred_type = ut
            return ut
        if isinstance(expr, TernaryIf):
            self._infer_expr(expr.cond, env)
            tt = self._infer_expr(expr.then_expr, env)
            et = self._infer_expr(expr.else_expr, env)
            ut = unify_types(tt, et, self.mro)
            expr.inferred_type = ut
            return ut
        if isinstance(expr, ArrayLit):
            if expr.repeat_value is not None and expr.repeat_count is not None:
                vt = self._infer_expr(expr.repeat_value, env)
                self._infer_expr(expr.repeat_count, env)
                elem_t = vt if (vt in self.structs or vt in ("f64", "str", "bool")) else "i64"
                expr.inferred_type = f"Array[{elem_t}]"
                return expr.inferred_type
            elem_t = "i64"
            if expr.elements:
                first_t = self._infer_expr(expr.elements[0], env)
                if first_t in self.structs or first_t in ("f64", "str", "bool"):
                    elem_t = first_t
            for el in expr.elements[1:]:
                self._infer_expr(el, env)
            expr.inferred_type = f"Array[{elem_t}]"
            return expr.inferred_type
        if isinstance(expr, IndexExpr):
            tt = self._infer_expr(expr.target, env)
            self._infer_expr(expr.index, env)
            if tt in self.structs and f"{tt}____getitem__" in self.signatures:
                expr.inferred_type = self.signatures[f"{tt}____getitem__"].return_type
                return expr.inferred_type
            if tt == "Dict":
                expr.inferred_type = "i64"
                return "i64"
            if tt and tt.startswith("Array[") and tt.endswith("]"):
                inner = tt[6:-1]
                expr.inferred_type = inner
                return inner
            if tt == "str":
                expr.inferred_type = "str"
                return "str"
            expr.inferred_type = "i64"
            return "i64"
        if isinstance(expr, ListComp):
            iter_t = self._infer_expr(expr.iter_expr, env)
            sub_env = dict(env)
            elem_var_t = "i64"
            if iter_t and iter_t.startswith("Array[") and iter_t.endswith("]"):
                elem_var_t = iter_t[6:-1]
            elif iter_t == "str":
                elem_var_t = "str"
            sub_env[expr.for_var] = elem_var_t
            if expr.cond:
                self._infer_expr(expr.cond, sub_env)
            elt_t = self._infer_expr(expr.elt, sub_env)
            res_t = f"Array[{elt_t}]"
            expr.inferred_type = res_t
            return res_t
        if isinstance(expr, DictLit):
            for k in expr.keys:
                self._infer_expr(k, env)
            for v in expr.values:
                self._infer_expr(v, env)
            expr.inferred_type = "Dict"
            return "Dict"
        if isinstance(expr, DictComp):
            iter_t = self._infer_expr(expr.iter_expr, env)
            sub_env = dict(env)
            elem_var_t = "i64"
            if iter_t and iter_t.startswith("Array[") and iter_t.endswith("]"):
                elem_var_t = iter_t[6:-1]
            elif iter_t == "str":
                elem_var_t = "str"
            sub_env[expr.for_var] = elem_var_t
            if expr.cond:
                self._infer_expr(expr.cond, sub_env)
            self._infer_expr(expr.key_expr, sub_env)
            self._infer_expr(expr.value_expr, sub_env)
            expr.inferred_type = "Dict"
            return "Dict"
        if isinstance(expr, YieldExpr):
            if expr.value:
                yt = self._infer_expr(expr.value, env)
                expr.inferred_type = yt
                return yt
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
                if (tt, expr.field_name) in self.dyn_attr_types:
                    dt = self.dyn_attr_types[(tt, expr.field_name)]
                    expr.inferred_type = dt
                    return dt
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

            # Dynamic OOP reflection & monkey-patching built-ins
            if expr.func in ("isinstance", "hasattr"):
                expr.inferred_type = "bool"
                return "bool"
            if expr.func == "setattr" and len(expr.args) == 3:
                tgt_t = arg_types[0]
                val_t = arg_types[2]
                if tgt_t in self.dynamic_classes and isinstance(expr.args[1], StringLit):
                    attr_name = expr.args[1].value
                    is_class_lit = isinstance(expr.args[0], Var) and expr.args[0].name == tgt_t and tgt_t not in env
                    if not is_class_lit:
                        has_static = any(f.name == attr_name for f in self.structs[tgt_t].fields)
                        if not has_static:
                            for sub_c in self.dynamic_classes:
                                if tgt_t in self.mro.get(sub_c, []):
                                    self.dyn_attr_types[(sub_c, attr_name)] = val_t
                expr.inferred_type = "i64"
                return "i64"
            if expr.func == "getattr" and len(expr.args) in (2, 3):
                tgt_t = arg_types[0]
                if tgt_t in self.structs and isinstance(expr.args[1], StringLit):
                    attr_name = expr.args[1].value
                    for f in self.structs[tgt_t].fields:
                        if f.name == attr_name:
                            expr.inferred_type = f.type_ann
                            return f.type_ann
                    if (tgt_t, attr_name) in self.dyn_attr_types:
                        dt = self.dyn_attr_types[(tgt_t, attr_name)]
                        expr.inferred_type = dt
                        return dt
                res_t = arg_types[2] if len(expr.args) == 3 else "i64"
                expr.inferred_type = res_t
                return res_t

            # Built-in functions
            if expr.func in (
                "int", "i64", "abs", "len", "ord", "min", "max", "clock_ns", "exit", "__bmb_exit",
                "__bmb_file_size", "__bmb_file_write", "__bmb_file_write_bytes", "__bmb_file_read_bytes",
                "__bmb_socket_init", "__bmb_socket_create", "__bmb_socket_connect",
                "__bmb_socket_bind", "__bmb_socket_listen", "__bmb_socket_accept",
                "__bmb_socket_send", "__bmb_socket_close", "__bmb_socket_cleanup",
                "__bmb_atomic_load", "__bmb_atomic_store", "__bmb_atomic_add", "__bmb_atomic_sub",
                "__bmb_atomic_cas", "__bmb_atomic_fence", "__bmb_cpu_pause",
                "__bmb_thread_concurrency", "__bmb_thread_spawn", "__bmb_thread_join",
                "__bmb_thread_id", "__bmb_thread_yield", "__bmb_thread_sleep",
                "__bmb_mem_alloc", "__bmb_mem_free", "__bmb_mem_read", "__bmb_mem_write",
                "__bmb_mem_read32", "__bmb_mem_write32", "__bmb_mem_read8", "__bmb_mem_write8",
                "__bmb_alloc_root_get", "__bmb_alloc_root_set",
                "__bmb_rt_slot_get", "__bmb_rt_slot_set",
            ):
                if expr.func in ("abs", "min", "max") and any(t == "f64" for t in arg_types):
                    expr.inferred_type = "f64"
                    return "f64"
                expr.inferred_type = "i64"
                return "i64"
            if expr.func in ("float", "f64", "sqrt", "sin", "cos", "exp", "log", "fabs", "clock_sec", "py_eval", "py_call"):
                expr.inferred_type = "f64"
                return "f64"
            if expr.func in ("py_eval_tensor", "as_tensor"):
                expr.inferred_type = "Array[f64]"
                return "Array[f64]"
            if expr.func in ("bool", "__bmb_file_exists", "__bmb_file_remove"):
                expr.inferred_type = "bool"
                return "bool"
            if expr.func in ("str", "chr", "__bmb_file_read", "__bmb_get_cwd", "__bmb_get_env", "__bmb_socket_recv"):
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
                    # Only specialize scalar f64 polymorphism, NOT polymorphic class upcasts (Dog -> Animal)!
                    is_class_upcast = all(
                        (at == pt) or (at in self.mro and pt in self.mro.get(at, []))
                        for at, pt in zip(arg_types, sig.param_types)
                    )
                    has_unannotated = any(p.type_ann in (None, "i64", "f64") for p in fn.params)
                    if not is_class_upcast and has_unannotated and any(t == "f64" for t in arg_types):
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
                                spec_rt = unify_types(spec_rt, r, self.mro)
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
