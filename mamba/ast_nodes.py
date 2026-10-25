"""
Abstract Syntax Tree (AST) nodes for Black Mamba (.bmb).
"""

from dataclasses import dataclass, field
from typing import List, Optional, Tuple


@dataclass
class Node:
    line: int = 0
    col: int = 0


# --- Expressions ---

@dataclass
class Expr(Node):
    inferred_type: Optional[str] = None


@dataclass
class IntLit(Expr):
    value: int = 0


@dataclass
class FloatLit(Expr):
    value: float = 0.0


@dataclass
class BoolLit(Expr):
    value: bool = False


@dataclass
class StringLit(Expr):
    value: str = ""


@dataclass
class Var(Expr):
    name: str = ""


@dataclass
class UnaryOp(Expr):
    op: str = ""
    operand: Expr = field(default_factory=Expr)


@dataclass
class BinOp(Expr):
    op: str = ""
    left: Expr = field(default_factory=Expr)
    right: Expr = field(default_factory=Expr)


@dataclass
class TernaryIf(Expr):
    cond: Expr = field(default_factory=Expr)
    then_expr: Expr = field(default_factory=Expr)
    else_expr: Expr = field(default_factory=Expr)


@dataclass
class Call(Expr):
    func: str = ""
    args: List[Expr] = field(default_factory=list)
    super_target: Optional[Tuple[str, str]] = None


@dataclass
class ArrayLit(Expr):
    elements: List[Expr] = field(default_factory=list)
    repeat_value: Optional[Expr] = None
    repeat_count: Optional[Expr] = None


@dataclass
class IndexExpr(Expr):
    target: Expr = field(default_factory=Expr)
    index: Expr = field(default_factory=Expr)


@dataclass
class SliceExpr(Expr):
    target: Expr = field(default_factory=Expr)
    start: Optional[Expr] = None
    stop: Optional[Expr] = None
    step: Optional[Expr] = None


@dataclass
class FieldAccess(Expr):
    target: Expr = field(default_factory=Expr)
    field_name: str = ""


@dataclass
class MethodCall(Expr):
    target: Expr = field(default_factory=Expr)
    method: str = ""
    args: List[Expr] = field(default_factory=list)


@dataclass
class RangeExpr(Expr):
    start: Expr = field(default_factory=Expr)
    stop: Expr = field(default_factory=Expr)
    step: Expr = field(default_factory=lambda: IntLit(value=1))
    inclusive: bool = False


# --- Statements ---

@dataclass
class Stmt(Node):
    pass


@dataclass
class ExprStmt(Stmt):
    expr: Expr = field(default_factory=Expr)


@dataclass
class Assign(Stmt):
    target: str = ""
    value: Expr = field(default_factory=Expr)
    type_ann: Optional[str] = None
    is_const: bool = False


@dataclass
class IndexAssign(Stmt):
    target: Expr = field(default_factory=Expr)
    index: Expr = field(default_factory=Expr)
    value: Expr = field(default_factory=Expr)


@dataclass
class FieldAssign(Stmt):
    target: Expr = field(default_factory=Expr)
    field_name: str = ""
    value: Expr = field(default_factory=Expr)


@dataclass
class AugAssign(Stmt):
    target: str = ""
    op: str = ""
    value: Expr = field(default_factory=Expr)


@dataclass
class IndexAugAssign(Stmt):
    target: Expr = field(default_factory=Expr)
    index: Expr = field(default_factory=Expr)
    op: str = ""
    value: Expr = field(default_factory=Expr)


@dataclass
class Return(Stmt):
    value: Optional[Expr] = None


@dataclass
class Break(Stmt):
    pass


@dataclass
class Continue(Stmt):
    pass


@dataclass
class PassStmt(Stmt):
    pass


@dataclass
class IfStmt(Stmt):
    cond: Expr = field(default_factory=Expr)
    then_body: List[Stmt] = field(default_factory=list)
    elif_branches: List[Tuple[Expr, List[Stmt]]] = field(default_factory=list)
    else_body: List[Stmt] = field(default_factory=list)


@dataclass
class WhileStmt(Stmt):
    cond: Expr = field(default_factory=Expr)
    body: List[Stmt] = field(default_factory=list)


@dataclass
class ForRangeStmt(Stmt):
    var_name: str = ""
    start: Expr = field(default_factory=Expr)
    stop: Expr = field(default_factory=Expr)
    step: Expr = field(default_factory=lambda: IntLit(value=1))
    inclusive: bool = False
    is_parallel: bool = False
    body: List[Stmt] = field(default_factory=list)


@dataclass
class MatchCase:
    pattern: Optional[Expr]  # None represents wildcard `case _:`
    body: List[Stmt]


@dataclass
class MatchStmt(Stmt):
    subject: Expr = field(default_factory=Expr)
    cases: List[MatchCase] = field(default_factory=list)


@dataclass
class Param:
    name: str
    type_ann: Optional[str] = None
    default: Optional[Expr] = None


@dataclass
class ImportStmt(Stmt):
    module_name: str = ""
    alias: Optional[str] = None


@dataclass
class FromImportStmt(Stmt):
    module_name: str = ""
    names: List[str] = field(default_factory=list)


@dataclass
class FuncDef(Stmt):
    name: str = ""
    params: List[Param] = field(default_factory=list)
    return_type: Optional[str] = None
    decorators: List[str] = field(default_factory=list)
    body: List[Stmt] = field(default_factory=list)


@dataclass
class StructField:
    name: str
    type_ann: str = "i64"
    default: Optional[Expr] = None


@dataclass
class StructDef(Stmt):
    name: str = ""
    fields: List[StructField] = field(default_factory=list)
    methods: List[FuncDef] = field(default_factory=list)
    bases: List[str] = field(default_factory=list)
    is_class: bool = False


@dataclass
class ExceptHandler(Node):
    exc_types: List[str] = field(default_factory=list)
    var_name: Optional[str] = None
    body: List[Stmt] = field(default_factory=list)


@dataclass
class TryStmt(Stmt):
    body: List[Stmt] = field(default_factory=list)
    handlers: List[ExceptHandler] = field(default_factory=list)
    else_body: List[Stmt] = field(default_factory=list)
    finally_body: List[Stmt] = field(default_factory=list)


@dataclass
class RaiseStmt(Stmt):
    exc: Optional[Expr] = None


@dataclass
class Module(Node):
    statements: List[Stmt] = field(default_factory=list)
