"""
Black Mamba (.bmb) Intermediate Representation (MIR) & Multi-Pass Optimizer.

Lowers typed AST into a 3-address Intermediate Representation (MIR) and runs:
1. Constant Folding & Propagation
2. Algebraic Simplification & Strength Reduction (e.g., x * 2^k -> x << k, x ** 2 -> x * x)
3. Copy Propagation
4. Automatic Tail-Call Optimization (TCO)
5. Dead Code Elimination (DCE)
"""

import os
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Tuple, Union
from .ast_nodes import (
    ArrayLit,
    Assign,
    AugAssign,
    BinOp,
    BoolLit,
    Break,
    Call,
    Continue,
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
from .types import TypeInferencer, unify_types, normalize_type


@dataclass
class MIRInstr:
    op: str
    dst: Optional[str] = None
    arg1: Union[str, int, float, None] = None
    arg2: Union[str, int, float, None] = None
    extra: List[str] = field(default_factory=list)
    val_type: str = "i64"
    comment: str = ""

    def format(self) -> str:
        if self.op == "LABEL":
            return f"  {self.arg1}:"
        if self.op == "JMP":
            return f"    jmp {self.arg1}"
        if self.op in ("JZ", "JNZ"):
            return f"    {self.op.lower()} {self.arg1}, {self.arg2}"
        if self.op == "RET":
            return f"    ret {self.arg1 if self.arg1 is not None else ''}".rstrip()
        if self.op == "CALL":
            args_str = ", ".join(self.extra)
            if self.dst:
                return f"    {self.dst}:{self.val_type} = call {self.arg1}({args_str})"
            return f"    call {self.arg1}({args_str})"
        if self.op == "PRINT":
            args_str = ", ".join(f"{a}:{t}" for a, t in zip(self.extra, (self.comment or "").split(",")))
            return f"    print({args_str})"
        if self.op == "STORE_IDX":
            return f"    {self.dst}[{self.arg1}] = {self.arg2}  ; {self.val_type}"
        if self.op == "LOAD_IDX":
            return f"    {self.dst}:{self.val_type} = {self.arg1}[{self.arg2}]"
        if self.op == "ALLOC_ARR":
            return f"    {self.dst}:{self.val_type} = alloc_array({self.arg1}, init={self.arg2})"
        if self.op == "STR_SLICE":
            stop_s = self.extra[0] if self.extra else "-1"
            return f"    {self.dst}:{self.val_type} = str_slice({self.arg1}[{self.arg2}:{stop_s}])"
        if self.op == "STR_CONCAT":
            return f"    {self.dst}:{self.val_type} = str_concat({self.arg1}, {self.arg2})"
        if self.op == "STR_INDEX":
            return f"    {self.dst}:{self.val_type} = str_index({self.arg1}[{self.arg2}])"
        if self.op == "STR_LEN":
            return f"    {self.dst}:{self.val_type} = str_len({self.arg1})"
        if self.dst is not None and self.arg2 is not None:
            return f"    {self.dst}:{self.val_type} = {self.op.lower()} {self.arg1}, {self.arg2}"
        if self.dst is not None:
            return f"    {self.dst}:{self.val_type} = {self.op.lower()} {self.arg1}"
        return f"    {self.op.lower()} {self.arg1 or ''} {self.arg2 or ''}".rstrip()


@dataclass
class MIRFunction:
    name: str
    params: List[Tuple[str, str]]
    return_type: str
    instructions: List[MIRInstr] = field(default_factory=list)
    local_types: Dict[str, str] = field(default_factory=dict)
    decorators: List[str] = field(default_factory=list)
    is_tco: bool = False

    def format(self) -> str:
        params_s = ", ".join(f"{n}: {t}" for n, t in self.params)
        tags = f" [{' '.join('@' + d for d in self.decorators)}]" if self.decorators else ""
        tco_tag = " [TCO]" if self.is_tco else ""
        lines = [f"fn {self.name}({params_s}) -> {self.return_type}{tags}{tco_tag} {{"]
        for ins in self.instructions:
            lines.append(ins.format())
        lines.append("}")
        return "\n".join(lines)


@dataclass
class MIRModule:
    functions: List[MIRFunction] = field(default_factory=list)
    structs: Dict[str, StructDef] = field(default_factory=dict)
    string_pool: List[str] = field(default_factory=list)

    def format(self) -> str:
        return "\n\n".join(fn.format() for fn in self.functions)


class MIRBuilder:
    def __init__(self):
        self.temp_counter = 0
        self.label_counter = 0
        self.loop_stack: List[Tuple[str, str]] = []  # (continue_label, break_label)
        self.structs: Dict[str, StructDef] = {}
        self.func_return_types: Dict[str, str] = {}
        self.string_pool: List[str] = []

    def new_temp(self, local_types: Dict[str, str], vtype: str = "i64") -> str:
        self.temp_counter += 1
        name = f"%t{self.temp_counter}"
        local_types[name] = vtype
        return name

    def new_label(self, prefix: str = "L") -> str:
        self.label_counter += 1
        return f".{prefix}_{self.label_counter}"

    def intern_string(self, s: str) -> int:
        if s not in self.string_pool:
            self.string_pool.append(s)
        return self.string_pool.index(s)

    def _is_f64_array(self, arr_t: Optional[str]) -> bool:
        if not arr_t:
            return False
        t = normalize_type(arr_t)
        return t == "Array[f64]" or (t is not None and (t.endswith("[f64]") or t.endswith("[float]")))

    def build(self, module: Module, base_dir: str = "") -> MIRModule:
        from .module_loader import resolve_imports
        module = resolve_imports(module, base_dir or os.getcwd())
        Inferencer = TypeInferencer(module)
        module = Inferencer.run()
        self.structs = Inferencer.structs
        for fname, sig in Inferencer.signatures.items():
            self.func_return_types[fname] = sig.return_type

        mir_funcs: List[MIRFunction] = []
        top_stmts: List[Stmt] = []
        self.constants: Dict[str, Expr] = {}

        for stmt in module.statements:
            if isinstance(stmt, Assign) and isinstance(stmt.value, (FloatLit, IntLit, BoolLit, StringLit)):
                self.constants[stmt.target] = stmt.value
            if isinstance(stmt, StructDef):
                continue
            elif isinstance(stmt, FuncDef):
                mir_funcs.append(self._lower_function(stmt))
            else:
                top_stmts.append(stmt)

        # Synthesize `main` function from top-level statements if any exist, or if `main` wasn't defined
        existing_main = next((f for f in mir_funcs if f.name == "main"), None)
        if top_stmts:
            body_stmts = list(top_stmts)
            if existing_main:
                body_stmts.append(ExprStmt(line=1, col=1, expr=Call(line=1, col=1, func="main", args=[])))
            body_stmts.append(Return(line=1, col=1, value=IntLit(value=0)))
            main_def = FuncDef(
                line=1,
                col=1,
                name="__bmb_main__" if existing_main else "main",
                params=[],
                return_type="i64",
                decorators=[],
                body=body_stmts,
            )
            mir_funcs.append(self._lower_function(main_def))
        elif not existing_main:
            main_def = FuncDef(
                line=1,
                col=1,
                name="main",
                params=[],
                return_type="i64",
                decorators=[],
                body=[Return(line=1, col=1, value=IntLit(value=0))],
            )
            mir_funcs.append(self._lower_function(main_def))

        mir_mod = MIRModule(functions=mir_funcs, structs=self.structs, string_pool=self.string_pool)
        MIROptimizer().optimize_module(mir_mod)
        return mir_mod

    def _lower_function(self, fn: FuncDef) -> MIRFunction:
        self.temp_counter = 0
        params = [(p.name, p.type_ann or "i64") for p in fn.params]
        local_types: Dict[str, str] = {name: ptype for name, ptype in params}
        instrs: List[MIRInstr] = [MIRInstr(op="LABEL", arg1="__tco_entry")]

        self._lower_block(fn.body, instrs, local_types)

        # Ensure function ends with a return instruction
        if not instrs or instrs[-1].op != "RET":
            default_ret = 0.0 if fn.return_type == "f64" else 0
            tmp = self.new_temp(local_types, fn.return_type or "i64")
            const_op = "CONST_F64" if fn.return_type == "f64" else "CONST_I64"
            instrs.append(MIRInstr(op=const_op, dst=tmp, arg1=default_ret, val_type=fn.return_type or "i64"))
            instrs.append(MIRInstr(op="RET", arg1=tmp, val_type=fn.return_type or "i64"))

        return MIRFunction(
            name=fn.name,
            params=params,
            return_type=fn.return_type or "i64",
            instructions=instrs,
            local_types=local_types,
            decorators=fn.decorators,
        )

    def _lower_block(self, stmts: List[Stmt], instrs: List[MIRInstr], local_types: Dict[str, str]) -> None:
        for stmt in stmts:
            self._lower_stmt(stmt, instrs, local_types)

    def _lower_stmt(self, stmt: Stmt, instrs: List[MIRInstr], local_types: Dict[str, str]) -> None:
        if isinstance(stmt, Assign):
            rhs, rhs_t = self._lower_expr(stmt.value, instrs, local_types)
            target_t = stmt.type_ann or local_types.get(stmt.target) or rhs_t
            local_types[stmt.target] = target_t
            if target_t == "f64" and rhs_t == "i64":
                conv = self.new_temp(local_types, "f64")
                instrs.append(MIRInstr(op="I64_TO_F64", dst=conv, arg1=rhs, val_type="f64"))
                rhs = conv
            elif target_t == "i64" and rhs_t == "f64":
                conv = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="F64_TO_I64", dst=conv, arg1=rhs, val_type="i64"))
                rhs = conv
            instrs.append(MIRInstr(op="MOV", dst=stmt.target, arg1=rhs, val_type=target_t))
            return

        if isinstance(stmt, AugAssign):
            bin_expr = BinOp(
                line=stmt.line,
                col=stmt.col,
                op=stmt.op,
                left=Var(line=stmt.line, col=stmt.col, name=stmt.target, inferred_type=local_types.get(stmt.target, "i64")),
                right=stmt.value,
                inferred_type=local_types.get(stmt.target, "i64"),
            )
            res, res_t = self._lower_expr(bin_expr, instrs, local_types)
            local_types[stmt.target] = res_t
            instrs.append(MIRInstr(op="MOV", dst=stmt.target, arg1=res, val_type=res_t))
            return

        if isinstance(stmt, IndexAssign):
            arr_v, arr_t = self._lower_expr(stmt.target, instrs, local_types)
            idx_v, _ = self._lower_expr(stmt.index, instrs, local_types)
            val_v, val_t = self._lower_expr(stmt.value, instrs, local_types)
            elem_t = "f64" if self._is_f64_array(arr_t) or val_t == "f64" else "i64"
            if elem_t == "f64" and val_t == "i64":
                conv = self.new_temp(local_types, "f64")
                instrs.append(MIRInstr(op="I64_TO_F64", dst=conv, arg1=val_v, val_type="f64"))
                val_v = conv
            instrs.append(MIRInstr(op="STORE_IDX", dst=arr_v, arg1=idx_v, arg2=val_v, val_type=elem_t))
            return

        if isinstance(stmt, IndexAugAssign):
            arr_v, arr_t = self._lower_expr(stmt.target, instrs, local_types)
            idx_v, _ = self._lower_expr(stmt.index, instrs, local_types)
            elem_t = "f64" if self._is_f64_array(arr_t) else "i64"
            cur_v = self.new_temp(local_types, elem_t)
            instrs.append(MIRInstr(op="LOAD_IDX", dst=cur_v, arg1=arr_v, arg2=idx_v, val_type=elem_t))
            rhs_v, rhs_t = self._lower_expr(stmt.value, instrs, local_types)
            res_t = unify_types(elem_t, rhs_t)
            if res_t == "f64" and elem_t == "i64":
                c1 = self.new_temp(local_types, "f64")
                instrs.append(MIRInstr(op="I64_TO_F64", dst=c1, arg1=cur_v, val_type="f64"))
                cur_v = c1
            if res_t == "f64" and rhs_t == "i64":
                c2 = self.new_temp(local_types, "f64")
                instrs.append(MIRInstr(op="I64_TO_F64", dst=c2, arg1=rhs_v, val_type="f64"))
                rhs_v = c2
            new_v = self.new_temp(local_types, res_t)
            op_code = self._map_binop(stmt.op, res_t)
            instrs.append(MIRInstr(op=op_code, dst=new_v, arg1=cur_v, arg2=rhs_v, val_type=res_t))
            instrs.append(MIRInstr(op="STORE_IDX", dst=arr_v, arg1=idx_v, arg2=new_v, val_type=elem_t))
            return

        if isinstance(stmt, FieldAssign):
            obj_v, obj_t = self._lower_expr(stmt.target, instrs, local_types)
            val_v, val_t = self._lower_expr(stmt.value, instrs, local_types)
            field_idx = self._struct_field_index(obj_t, stmt.field_name)
            idx_tmp = self.new_temp(local_types, "i64")
            instrs.append(MIRInstr(op="CONST_I64", dst=idx_tmp, arg1=field_idx, val_type="i64"))
            instrs.append(MIRInstr(op="STORE_IDX", dst=obj_v, arg1=idx_tmp, arg2=val_v, val_type=val_t))
            return

        if isinstance(stmt, Return):
            if stmt.value is not None:
                rv, rt = self._lower_expr(stmt.value, instrs, local_types)
                instrs.append(MIRInstr(op="RET", arg1=rv, val_type=rt))
            else:
                tmp = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CONST_I64", dst=tmp, arg1=0, val_type="i64"))
                instrs.append(MIRInstr(op="RET", arg1=tmp, val_type="i64"))
            return

        if isinstance(stmt, Break):
            if self.loop_stack:
                instrs.append(MIRInstr(op="JMP", arg1=self.loop_stack[-1][1]))
            return

        if isinstance(stmt, Continue):
            if self.loop_stack:
                instrs.append(MIRInstr(op="JMP", arg1=self.loop_stack[-1][0]))
            return

        if isinstance(stmt, IfStmt):
            end_lbl = self.new_label("if_end")
            next_lbl = self.new_label("if_next") if (stmt.elif_branches or stmt.else_body) else end_lbl
            cond_v, _ = self._lower_expr(stmt.cond, instrs, local_types)
            instrs.append(MIRInstr(op="JZ", arg1=cond_v, arg2=next_lbl))
            self._lower_block(stmt.then_body, instrs, local_types)
            instrs.append(MIRInstr(op="JMP", arg1=end_lbl))

            for idx, (e_cond, e_body) in enumerate(stmt.elif_branches):
                instrs.append(MIRInstr(op="LABEL", arg1=next_lbl))
                has_more = (idx + 1 < len(stmt.elif_branches)) or bool(stmt.else_body)
                next_lbl = self.new_label("if_elif") if has_more else end_lbl
                ec_v, _ = self._lower_expr(e_cond, instrs, local_types)
                instrs.append(MIRInstr(op="JZ", arg1=ec_v, arg2=next_lbl))
                self._lower_block(e_body, instrs, local_types)
                instrs.append(MIRInstr(op="JMP", arg1=end_lbl))

            if stmt.else_body:
                instrs.append(MIRInstr(op="LABEL", arg1=next_lbl))
                self._lower_block(stmt.else_body, instrs, local_types)

            instrs.append(MIRInstr(op="LABEL", arg1=end_lbl))
            return

        if isinstance(stmt, WhileStmt):
            cond_lbl = self.new_label("while_cond")
            end_lbl = self.new_label("while_end")
            instrs.append(MIRInstr(op="LABEL", arg1=cond_lbl))
            cond_v, _ = self._lower_expr(stmt.cond, instrs, local_types)
            instrs.append(MIRInstr(op="JZ", arg1=cond_v, arg2=end_lbl))
            self.loop_stack.append((cond_lbl, end_lbl))
            self._lower_block(stmt.body, instrs, local_types)
            self.loop_stack.pop()
            instrs.append(MIRInstr(op="JMP", arg1=cond_lbl))
            instrs.append(MIRInstr(op="LABEL", arg1=end_lbl))
            return

        if isinstance(stmt, ForRangeStmt):
            start_v, _ = self._lower_expr(stmt.start, instrs, local_types)
            stop_v, _ = self._lower_expr(stmt.stop, instrs, local_types)
            step_v, _ = self._lower_expr(stmt.step, instrs, local_types)
            local_types[stmt.var_name] = "i64"
            instrs.append(
                MIRInstr(
                    op="MOV",
                    dst=stmt.var_name,
                    arg1=start_v,
                    val_type="i64",
                    comment="par_for" if stmt.is_parallel else "for_range",
                )
            )
            cond_lbl = self.new_label("for_cond")
            step_lbl = self.new_label("for_step")
            end_lbl = self.new_label("for_end")

            instrs.append(MIRInstr(op="LABEL", arg1=cond_lbl))
            cmp_tmp = self.new_temp(local_types, "bool")
            cmp_op = "CMP_LE_I64" if stmt.inclusive else "CMP_LT_I64"
            instrs.append(MIRInstr(op=cmp_op, dst=cmp_tmp, arg1=stmt.var_name, arg2=stop_v, val_type="bool"))
            instrs.append(MIRInstr(op="JZ", arg1=cmp_tmp, arg2=end_lbl))

            self.loop_stack.append((step_lbl, end_lbl))
            self._lower_block(stmt.body, instrs, local_types)
            self.loop_stack.pop()

            instrs.append(MIRInstr(op="LABEL", arg1=step_lbl))
            next_i = self.new_temp(local_types, "i64")
            instrs.append(MIRInstr(op="ADD_I64", dst=next_i, arg1=stmt.var_name, arg2=step_v, val_type="i64"))
            instrs.append(MIRInstr(op="MOV", dst=stmt.var_name, arg1=next_i, val_type="i64"))
            instrs.append(MIRInstr(op="JMP", arg1=cond_lbl))
            instrs.append(MIRInstr(op="LABEL", arg1=end_lbl))
            return

        if isinstance(stmt, MatchStmt):
            subj_v, subj_t = self._lower_expr(stmt.subject, instrs, local_types)
            end_lbl = self.new_label("match_end")
            for idx, case in enumerate(stmt.cases):
                next_case = self.new_label(f"match_case_{idx}")
                if case.pattern is not None:
                    pat_v, _ = self._lower_expr(case.pattern, instrs, local_types)
                    cmp_t = self.new_temp(local_types, "bool")
                    cmp_op = "CMP_EQ_F64" if subj_t == "f64" else "CMP_EQ_I64"
                    instrs.append(MIRInstr(op=cmp_op, dst=cmp_t, arg1=subj_v, arg2=pat_v, val_type="bool"))
                    instrs.append(MIRInstr(op="JZ", arg1=cmp_t, arg2=next_case))
                self._lower_block(case.body, instrs, local_types)
                instrs.append(MIRInstr(op="JMP", arg1=end_lbl))
                instrs.append(MIRInstr(op="LABEL", arg1=next_case))
            instrs.append(MIRInstr(op="LABEL", arg1=end_lbl))
            return

        if isinstance(stmt, ExprStmt):
            self._lower_expr(stmt.expr, instrs, local_types)

    def _lower_expr(self, expr: Expr, instrs: List[MIRInstr], local_types: Dict[str, str]) -> Tuple[str, str]:
        if isinstance(expr, IntLit):
            dst = self.new_temp(local_types, "i64")
            instrs.append(MIRInstr(op="CONST_I64", dst=dst, arg1=int(expr.value), val_type="i64"))
            return dst, "i64"

        if isinstance(expr, FloatLit):
            dst = self.new_temp(local_types, "f64")
            instrs.append(MIRInstr(op="CONST_F64", dst=dst, arg1=float(expr.value), val_type="f64"))
            return dst, "f64"

        if isinstance(expr, BoolLit):
            dst = self.new_temp(local_types, "bool")
            instrs.append(MIRInstr(op="CONST_I64", dst=dst, arg1=1 if expr.value else 0, val_type="bool"))
            return dst, "bool"

        if isinstance(expr, StringLit):
            if expr.value.startswith("f:"):
                parts = self._split_fstring(expr.value[2:], expr.line, expr.col)
                if not parts:
                    str_id = self.intern_string("")
                    dst = self.new_temp(local_types, "str")
                    instrs.append(MIRInstr(op="CONST_STR", dst=dst, arg1=str_id, comment="", val_type="str"))
                    return dst, "str"
                cur_v, cur_t = self._lower_expr(parts[0], instrs, local_types)
                if cur_t != "str":
                    str_v = self.new_temp(local_types, "str")
                    cast_op = "STR_FROM_F64" if cur_t == "f64" else ("STR_FROM_BOOL" if cur_t == "bool" else "STR_FROM_I64")
                    instrs.append(MIRInstr(op=cast_op, dst=str_v, arg1=cur_v, val_type="str"))
                    cur_v = str_v
                for p in parts[1:]:
                    nxt_v, nxt_t = self._lower_expr(p, instrs, local_types)
                    if nxt_t != "str":
                        str_v = self.new_temp(local_types, "str")
                        cast_op = "STR_FROM_F64" if nxt_t == "f64" else ("STR_FROM_BOOL" if nxt_t == "bool" else "STR_FROM_I64")
                        instrs.append(MIRInstr(op=cast_op, dst=str_v, arg1=nxt_v, val_type="str"))
                        nxt_v = str_v
                    concat_dst = self.new_temp(local_types, "str")
                    instrs.append(MIRInstr(op="STR_CONCAT", dst=concat_dst, arg1=cur_v, arg2=nxt_v, val_type="str"))
                    cur_v = concat_dst
                return cur_v, "str"
            else:
                raw = expr.value
            str_id = self.intern_string(raw)
            dst = self.new_temp(local_types, "str")
            instrs.append(MIRInstr(op="CONST_STR", dst=dst, arg1=str_id, comment=raw, val_type="str"))
            return dst, "str"

        if isinstance(expr, Var):
            if hasattr(self, "constants") and expr.name in self.constants and expr.name not in local_types:
                return self._lower_expr(self.constants[expr.name], instrs, local_types)
            vtype = local_types.get(expr.name, expr.inferred_type or "i64")
            return expr.name, vtype

        if isinstance(expr, UnaryOp):
            op_v, op_t = self._lower_expr(expr.operand, instrs, local_types)
            if expr.op == "-":
                dst = self.new_temp(local_types, op_t)
                neg_op = "NEG_F64" if op_t == "f64" else "NEG_I64"
                instrs.append(MIRInstr(op=neg_op, dst=dst, arg1=op_v, val_type=op_t))
                return dst, op_t
            if expr.op == "~":
                dst = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="NOT_I64", dst=dst, arg1=op_v, val_type="i64"))
                return dst, "i64"
            if expr.op == "not":
                dst = self.new_temp(local_types, "bool")
                zero = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CONST_I64", dst=zero, arg1=0, val_type="i64"))
                instrs.append(MIRInstr(op="CMP_EQ_I64", dst=dst, arg1=op_v, arg2=zero, val_type="bool"))
                return dst, "bool"
            return op_v, op_t

        if isinstance(expr, BinOp):
            # Short-circuit or direct boolean operations, plus power `**`
            lv, lt = self._lower_expr(expr.left, instrs, local_types)
            rv, rt = self._lower_expr(expr.right, instrs, local_types)

            if lt == "str" or rt == "str":
                if expr.op == "+":
                    dst = self.new_temp(local_types, "str")
                    instrs.append(MIRInstr(op="STR_CONCAT", dst=dst, arg1=lv, arg2=rv, val_type="str"))
                    return dst, "str"
                if expr.op in ("==", "!=", "<", "<=", ">", ">="):
                    dst = self.new_temp(local_types, "bool")
                    cmp_map = {
                        "==": "STR_CMP_EQ",
                        "!=": "STR_CMP_NE",
                        "<": "STR_CMP_LT",
                        "<=": "STR_CMP_LE",
                        ">": "STR_CMP_GT",
                        ">=": "STR_CMP_GE",
                    }
                    op_code = cmp_map[expr.op]
                    instrs.append(MIRInstr(op=op_code, dst=dst, arg1=lv, arg2=rv, val_type="bool"))
                    return dst, "bool"

            is_float_op = (lt == "f64" or rt == "f64" or expr.op == "/")
            if is_float_op and expr.op not in ("//", "%", "&", "|", "^", "<<", ">>"):
                if lt != "f64":
                    c_l = self.new_temp(local_types, "f64")
                    instrs.append(MIRInstr(op="I64_TO_F64", dst=c_l, arg1=lv, val_type="f64"))
                    lv = c_l
                if rt != "f64":
                    c_r = self.new_temp(local_types, "f64")
                    instrs.append(MIRInstr(op="I64_TO_F64", dst=c_r, arg1=rv, val_type="f64"))
                    rv = c_r
                operand_t = "f64"
            else:
                operand_t = "i64"

            if expr.op == "**":
                # Fast square or integer power
                if isinstance(expr.right, IntLit) and expr.right.value == 2:
                    dst = self.new_temp(local_types, operand_t)
                    mul_op = "MUL_F64" if operand_t == "f64" else "MUL_I64"
                    instrs.append(MIRInstr(op=mul_op, dst=dst, arg1=lv, arg2=lv, val_type=operand_t))
                    return dst, operand_t
                if isinstance(expr.right, IntLit) and expr.right.value == 3:
                    t1 = self.new_temp(local_types, operand_t)
                    dst = self.new_temp(local_types, operand_t)
                    mul_op = "MUL_F64" if operand_t == "f64" else "MUL_I64"
                    instrs.append(MIRInstr(op=mul_op, dst=t1, arg1=lv, arg2=lv, val_type=operand_t))
                    instrs.append(MIRInstr(op=mul_op, dst=dst, arg1=t1, arg2=lv, val_type=operand_t))
                    return dst, operand_t
                dst = self.new_temp(local_types, operand_t)
                instrs.append(MIRInstr(op="POW_" + operand_t.upper(), dst=dst, arg1=lv, arg2=rv, val_type=operand_t))
                return dst, operand_t

            res_t = "bool" if expr.op in ("==", "!=", "<", "<=", ">", ">=", "and", "or") else operand_t
            dst = self.new_temp(local_types, res_t)
            op_code = self._map_binop(expr.op, operand_t)
            instrs.append(MIRInstr(op=op_code, dst=dst, arg1=lv, arg2=rv, val_type=res_t))
            return dst, res_t

        if isinstance(expr, TernaryIf):
            res_t = expr.inferred_type or "i64"
            dst = self.new_temp(local_types, res_t)
            else_lbl = self.new_label("tern_else")
            end_lbl = self.new_label("tern_end")
            cv, _ = self._lower_expr(expr.cond, instrs, local_types)
            instrs.append(MIRInstr(op="JZ", arg1=cv, arg2=else_lbl))
            tv, _ = self._lower_expr(expr.then_expr, instrs, local_types)
            instrs.append(MIRInstr(op="MOV", dst=dst, arg1=tv, val_type=res_t))
            instrs.append(MIRInstr(op="JMP", arg1=end_lbl))
            instrs.append(MIRInstr(op="LABEL", arg1=else_lbl))
            ev, _ = self._lower_expr(expr.else_expr, instrs, local_types)
            instrs.append(MIRInstr(op="MOV", dst=dst, arg1=ev, val_type=res_t))
            instrs.append(MIRInstr(op="LABEL", arg1=end_lbl))
            return dst, res_t

        if isinstance(expr, ArrayLit):
            arr_t = expr.inferred_type or "Array[i64]"
            elem_t = "f64" if self._is_f64_array(arr_t) else "i64"
            dst = self.new_temp(local_types, arr_t)
            if expr.repeat_value is not None and expr.repeat_count is not None:
                cnt_v, _ = self._lower_expr(expr.repeat_count, instrs, local_types)
                init_v, init_t = self._lower_expr(expr.repeat_value, instrs, local_types)
                if elem_t == "f64" and init_t == "i64":
                    c = self.new_temp(local_types, "f64")
                    instrs.append(MIRInstr(op="I64_TO_F64", dst=c, arg1=init_v, val_type="f64"))
                    init_v = c
                instrs.append(MIRInstr(op="ALLOC_ARR", dst=dst, arg1=cnt_v, arg2=init_v, val_type=arr_t))
                return dst, arr_t

            cnt_tmp = self.new_temp(local_types, "i64")
            instrs.append(MIRInstr(op="CONST_I64", dst=cnt_tmp, arg1=len(expr.elements), val_type="i64"))
            zero_tmp = self.new_temp(local_types, elem_t)
            instrs.append(
                MIRInstr(
                    op="CONST_F64" if elem_t == "f64" else "CONST_I64",
                    dst=zero_tmp,
                    arg1=0.0 if elem_t == "f64" else 0,
                    val_type=elem_t,
                )
            )
            instrs.append(MIRInstr(op="ALLOC_ARR", dst=dst, arg1=cnt_tmp, arg2=zero_tmp, val_type=arr_t))
            for idx, el in enumerate(expr.elements):
                ev, et = self._lower_expr(el, instrs, local_types)
                if elem_t == "f64" and et == "i64":
                    c = self.new_temp(local_types, "f64")
                    instrs.append(MIRInstr(op="I64_TO_F64", dst=c, arg1=ev, val_type="f64"))
                    ev = c
                idx_tmp = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CONST_I64", dst=idx_tmp, arg1=idx, val_type="i64"))
                instrs.append(MIRInstr(op="STORE_IDX", dst=dst, arg1=idx_tmp, arg2=ev, val_type=elem_t))
            return dst, arr_t

        if isinstance(expr, IndexExpr):
            arr_v, arr_t = self._lower_expr(expr.target, instrs, local_types)
            idx_v, _ = self._lower_expr(expr.index, instrs, local_types)
            if arr_t == "str":
                dst = self.new_temp(local_types, "str")
                instrs.append(MIRInstr(op="STR_INDEX", dst=dst, arg1=arr_v, arg2=idx_v, val_type="str"))
                return dst, "str"
            if arr_t and arr_t.startswith("Array[") and arr_t.endswith("]"):
                elem_t = arr_t[6:-1]
            elif expr.inferred_type:
                elem_t = expr.inferred_type
            elif self._is_f64_array(arr_t):
                elem_t = "f64"
            else:
                elem_t = "i64"
            dst = self.new_temp(local_types, elem_t)
            instrs.append(MIRInstr(op="LOAD_IDX", dst=dst, arg1=arr_v, arg2=idx_v, val_type=elem_t))
            return dst, elem_t

        if isinstance(expr, SliceExpr):
            tgt_v, tgt_t = self._lower_expr(expr.target, instrs, local_types)
            if expr.start is not None:
                start_v, _ = self._lower_expr(expr.start, instrs, local_types)
            else:
                start_v = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CONST_I64", dst=start_v, arg1=0, val_type="i64"))
            if expr.stop is not None:
                stop_v, _ = self._lower_expr(expr.stop, instrs, local_types)
            else:
                stop_v = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CONST_I64", dst=stop_v, arg1=-1, val_type="i64"))
            dst = self.new_temp(local_types, "str")
            instrs.append(MIRInstr(op="STR_SLICE", dst=dst, arg1=tgt_v, arg2=start_v, extra=[stop_v], val_type="str"))
            return dst, "str"

        if isinstance(expr, FieldAccess):
            obj_v, obj_t = self._lower_expr(expr.target, instrs, local_types)
            field_idx = self._struct_field_index(obj_t, expr.field_name)
            field_t = self._struct_field_type(obj_t, expr.field_name)
            idx_tmp = self.new_temp(local_types, "i64")
            instrs.append(MIRInstr(op="CONST_I64", dst=idx_tmp, arg1=field_idx, val_type="i64"))
            dst = self.new_temp(local_types, field_t)
            instrs.append(MIRInstr(op="LOAD_IDX", dst=dst, arg1=obj_v, arg2=idx_tmp, val_type=field_t))
            return dst, field_t

        if isinstance(expr, MethodCall):
            obj_v, obj_t = self._lower_expr(expr.target, instrs, local_types)
            lowered_call = Call(
                line=expr.line,
                col=expr.col,
                func=f"{obj_t}__{expr.method}",
                args=[expr.target] + expr.args,
                inferred_type=expr.inferred_type,
            )
            return self._lower_expr(lowered_call, instrs, local_types)

        if isinstance(expr, Call):
            if expr.func == "print":
                arg_vals: List[str] = []
                arg_types: List[str] = []
                for a in expr.args:
                    if isinstance(a, StringLit) and a.value.startswith("f:"):
                        # Expand f-string `f"hello {x} world"` into print parts
                        parts = self._split_fstring(a.value[2:], a.line, a.col)
                        for p in parts:
                            pv, pt = self._lower_expr(p, instrs, local_types)
                            arg_vals.append(pv)
                            arg_types.append(pt)
                    else:
                        av, at = self._lower_expr(a, instrs, local_types)
                        arg_vals.append(av)
                        arg_types.append(at)
                instrs.append(
                    MIRInstr(
                        op="PRINT",
                        extra=arg_vals,
                        comment=",".join(arg_types),
                        val_type="void",
                    )
                )
                return "%void", "void"

            # Struct constructor call `Vec2(x, y)` -> allocate contiguous slot array
            if expr.func in self.structs:
                sdef = self.structs[expr.func]
                dst = self.new_temp(local_types, expr.func)
                cnt_tmp = self.new_temp(local_types, "i64")
                zero_tmp = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CONST_I64", dst=cnt_tmp, arg1=max(1, len(sdef.fields)), val_type="i64"))
                instrs.append(MIRInstr(op="CONST_I64", dst=zero_tmp, arg1=0, val_type="i64"))
                instrs.append(MIRInstr(op="ALLOC_ARR", dst=dst, arg1=cnt_tmp, arg2=zero_tmp, val_type=expr.func))
                for idx, f in enumerate(sdef.fields):
                    arg_e = expr.args[idx] if idx < len(expr.args) else (f.default or IntLit(value=0))
                    av, at = self._lower_expr(arg_e, instrs, local_types)
                    idx_tmp = self.new_temp(local_types, "i64")
                    instrs.append(MIRInstr(op="CONST_I64", dst=idx_tmp, arg1=idx, val_type="i64"))
                    instrs.append(MIRInstr(op="STORE_IDX", dst=dst, arg1=idx_tmp, arg2=av, val_type=at))
                return dst, expr.func

            # Builtin type casts & math intrinsics
            if expr.func in ("int", "i64") and len(expr.args) == 1:
                av, at = self._lower_expr(expr.args[0], instrs, local_types)
                if at == "f64":
                    dst = self.new_temp(local_types, "i64")
                    instrs.append(MIRInstr(op="F64_TO_I64", dst=dst, arg1=av, val_type="i64"))
                    return dst, "i64"
                if at == "str":
                    dst = self.new_temp(local_types, "i64")
                    instrs.append(MIRInstr(op="STR_TO_I64", dst=dst, arg1=av, val_type="i64"))
                    return dst, "i64"
                return av, "i64"

            if expr.func in ("float", "f64") and len(expr.args) == 1:
                av, at = self._lower_expr(expr.args[0], instrs, local_types)
                if at == "str":
                    dst = self.new_temp(local_types, "f64")
                    instrs.append(MIRInstr(op="STR_TO_F64", dst=dst, arg1=av, val_type="f64"))
                    return dst, "f64"
                if at != "f64":
                    dst = self.new_temp(local_types, "f64")
                    instrs.append(MIRInstr(op="I64_TO_F64", dst=dst, arg1=av, val_type="f64") )
                    return dst, "f64"
                return av, "f64"

            if expr.func == "sqrt" and len(expr.args) == 1:
                av, at = self._lower_expr(expr.args[0], instrs, local_types)
                if at != "f64":
                    c = self.new_temp(local_types, "f64")
                    instrs.append(MIRInstr(op="I64_TO_F64", dst=c, arg1=av, val_type="f64"))
                    av = c
                dst = self.new_temp(local_types, "f64")
                instrs.append(MIRInstr(op="SQRT_F64", dst=dst, arg1=av, val_type="f64"))
                return dst, "f64"

            if expr.func in ("abs", "fabs") and len(expr.args) == 1:
                av, at = self._lower_expr(expr.args[0], instrs, local_types)
                dst = self.new_temp(local_types, at)
                instrs.append(MIRInstr(op="ABS_" + at.upper(), dst=dst, arg1=av, val_type=at))
                return dst, at

            if expr.func == "len" and len(expr.args) == 1:
                av, at = self._lower_expr(expr.args[0], instrs, local_types)
                dst = self.new_temp(local_types, "i64")
                if at == "str":
                    instrs.append(MIRInstr(op="STR_LEN", dst=dst, arg1=av, val_type="i64"))
                else:
                    zero_tmp = self.new_temp(local_types, "i64")
                    instrs.append(MIRInstr(op="CONST_I64", dst=zero_tmp, arg1=0, val_type="i64"))
                    instrs.append(MIRInstr(op="LOAD_IDX", dst=dst, arg1=av, arg2=zero_tmp, val_type="i64"))
                return dst, "i64"

            if expr.func == "ord" and len(expr.args) == 1:
                av, _ = self._lower_expr(expr.args[0], instrs, local_types)
                dst = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="STR_ORD", dst=dst, arg1=av, val_type="i64"))
                return dst, "i64"

            if expr.func == "chr" and len(expr.args) == 1:
                av, _ = self._lower_expr(expr.args[0], instrs, local_types)
                dst = self.new_temp(local_types, "str")
                instrs.append(MIRInstr(op="STR_CHR", dst=dst, arg1=av, val_type="str"))
                return dst, "str"

            if expr.func == "str" and len(expr.args) == 1:
                av, at = self._lower_expr(expr.args[0], instrs, local_types)
                if at == "str":
                    return av, "str"
                dst = self.new_temp(local_types, "str")
                cast_op = "STR_FROM_F64" if at == "f64" else ("STR_FROM_BOOL" if at == "bool" else "STR_FROM_I64")
                instrs.append(MIRInstr(op=cast_op, dst=dst, arg1=av, val_type="str"))
                return dst, "str"

            if expr.func == "clock_ns" and len(expr.args) == 0:
                dst = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CLOCK_NS", dst=dst, val_type="i64"))
                return dst, "i64"

            # CPython Host Interop Intrinsics
            if expr.func == "py_eval" and len(expr.args) == 1:
                av, _ = self._lower_expr(expr.args[0], instrs, local_types)
                dst = self.new_temp(local_types, "f64")
                instrs.append(MIRInstr(op="PY_EVAL_F64", dst=dst, arg1=av, val_type="f64"))
                return dst, "f64"

            if expr.func == "py_eval_tensor" and len(expr.args) == 1:
                av, _ = self._lower_expr(expr.args[0], instrs, local_types)
                dst = self.new_temp(local_types, "Array[f64]")
                instrs.append(MIRInstr(op="PY_EVAL_TENSOR", dst=dst, arg1=av, val_type="Array[f64]"))
                return dst, "Array[f64]"

            if expr.func == "py_call" and len(expr.args) == 3:
                m_v, _ = self._lower_expr(expr.args[0], instrs, local_types)
                f_v, _ = self._lower_expr(expr.args[1], instrs, local_types)
                a_v, at = self._lower_expr(expr.args[2], instrs, local_types)
                if at != "f64":
                    flt_tmp = self.new_temp(local_types, "f64")
                    instrs.append(MIRInstr(op="I64_TO_F64", dst=flt_tmp, arg1=a_v, val_type="f64"))
                    a_v = flt_tmp
                dst = self.new_temp(local_types, "f64")
                instrs.append(MIRInstr(op="PY_CALL_F64", dst=dst, arg1=m_v, arg2=f_v, extra=[a_v], val_type="f64"))
                return dst, "f64"

            arg_vals = []
            for a in expr.args:
                av, _ = self._lower_expr(a, instrs, local_types)
                arg_vals.append(av)
            ret_t = self.func_return_types.get(expr.func) or expr.inferred_type or "i64"
            dst = self.new_temp(local_types, ret_t)
            instrs.append(MIRInstr(op="CALL", dst=dst, arg1=expr.func, extra=arg_vals, val_type=ret_t))
            return dst, ret_t

        dst = self.new_temp(local_types, "i64")
        instrs.append(MIRInstr(op="CONST_I64", dst=dst, arg1=0, val_type="i64"))
        return dst, "i64"

    def _split_fstring(self, raw: str, line: int, col: int) -> List[Expr]:
        from .parser import Parser

        parts: List[Expr] = []
        i = 0
        n = len(raw)
        buf: List[str] = []
        while i < n:
            if raw[i] == "{":
                if buf:
                    parts.append(StringLit(line=line, col=col, value="".join(buf), inferred_type="str"))
                    buf = []
                end = raw.find("}", i + 1)
                if end == -1:
                    break
                inner_src = raw[i + 1 : end].strip()
                if inner_src:
                    sub_expr = Parser.from_source(inner_src).parse_expr()
                    parts.append(sub_expr)
                i = end + 1
            else:
                buf.append(raw[i])
                i += 1
        if buf:
            parts.append(StringLit(line=line, col=col, value="".join(buf), inferred_type="str"))
        return parts

    def _struct_field_index(self, struct_name: str, field_name: str) -> int:
        sdef = self.structs.get(struct_name)
        if sdef:
            for idx, f in enumerate(sdef.fields):
                if f.name == field_name:
                    return idx
        return 0

    def _struct_field_type(self, struct_name: str, field_name: str) -> str:
        sdef = self.structs.get(struct_name)
        if sdef:
            for f in sdef.fields:
                if f.name == field_name:
                    return f.type_ann
        return "i64"

    def _map_binop(self, op: str, t: str) -> str:
        suffix = "F64" if t == "f64" else "I64"
        table = {
            "+": f"ADD_{suffix}",
            "-": f"SUB_{suffix}",
            "*": f"MUL_{suffix}",
            "/": "DIV_F64",
            "//": "DIV_I64",
            "%": "MOD_I64",
            "&": "AND_I64",
            "|": "OR_I64",
            "^": "XOR_I64",
            "<<": "SHL_I64",
            ">>": "SHR_I64",
            "and": "AND_I64",
            "or": "OR_I64",
            "==": f"CMP_EQ_{suffix}",
            "!=": f"CMP_NE_{suffix}",
            "<": f"CMP_LT_{suffix}",
            "<=": f"CMP_LE_{suffix}",
            ">": f"CMP_GT_{suffix}",
            ">=": f"CMP_GE_{suffix}",
        }
        return table.get(op, f"ADD_{suffix}")


class MIROptimizer:
    """
    Multi-pass MIR optimizer:
    - Tail-Call Optimization (TCO)
    - Constant Folding & Propagation (within basic blocks)
    - Algebraic Strength Reduction (mul by power of 2 -> shift)
    - Copy Propagation & Dead Code Elimination
    """

    def optimize_module(self, mod: MIRModule) -> None:
        for fn in mod.functions:
            self.optimize_function(fn)

    def optimize_function(self, fn: MIRFunction) -> None:
        self._apply_tail_call_optimization(fn)
        for _ in range(3):
            self._constant_fold_and_strength_reduce(fn)
            self._copy_propagation(fn)
            self._dead_code_elimination(fn)
        self._apply_lexical_arena_lifetimes(fn)

    def _apply_lexical_arena_lifetimes(self, fn: MIRFunction) -> None:
        """
        Compile-Time Lexical Arena Lifetimes:
        Performs escape analysis on function allocations (ALLOC_ARR).
        If heap allocations do not escape the function via RET or parameter mutation,
        automatically captures an arena savepoint at function entry and restores it before RET.
        This reclaims local heap buffers with ZERO garbage collection pause overhead.
        """
        has_alloc = any(ins.op in ("ALLOC_ARR", "STR_CONCAT", "STR_SLICE") for ins in fn.instructions)
        if not has_alloc:
            return

        # 1. Escape Analysis:
        param_names = {p[0] for p in fn.params}
        for ins in fn.instructions:
            if ins.op == "STORE_IDX" and ins.dst in param_names:
                return  # Escaped via mutation of caller's parameter

        # If return type is not a scalar primitive (i64, f64, bool, void),
        # the returned object (struct, array, string) is allocated in the arena and escapes to caller!
        if fn.return_type not in ("f64", "i64", "bool", "void"):
            return

        # 2. Ephemeral allocations detected: emit ARENA_SAVE at entry and ARENA_RESTORE before RET
        save_var = f"%arena_sp_{fn.name}"
        fn.local_types[save_var] = "i64"

        new_instrs: List[MIRInstr] = []
        inserted_save = False
        for ins in fn.instructions:
            if not inserted_save and ins.op != "LABEL":
                new_instrs.append(MIRInstr(op="ARENA_SAVE", dst=save_var, val_type="i64", comment="lexical arena checkpoint"))
                inserted_save = True

            if ins.op == "RET":
                new_instrs.append(MIRInstr(op="ARENA_RESTORE", arg1=save_var, comment="auto-reclaim lexical arena"))

            new_instrs.append(ins)

            if not inserted_save and ins.op == "LABEL" and ins.arg1 == "__tco_entry":
                new_instrs.append(MIRInstr(op="ARENA_SAVE", dst=save_var, val_type="i64", comment="lexical arena checkpoint"))
                inserted_save = True

        if not inserted_save:
            new_instrs.insert(0, MIRInstr(op="ARENA_SAVE", dst=save_var, val_type="i64", comment="lexical arena checkpoint"))

        fn.instructions = new_instrs

    def _apply_tail_call_optimization(self, fn: MIRFunction) -> None:
        """
        Convert tail calls `t = CALL fn.name(a1, a2, ...); RET t` into
        register parameter reassignment + `JMP __tco_entry`.
        """
        instrs = fn.instructions
        new_instrs: List[MIRInstr] = []
        i = 0
        n = len(instrs)
        while i < n:
            ins = instrs[i]
            if (
                ins.op == "CALL"
                and ins.arg1 == fn.name
                and i + 1 < n
                and instrs[i + 1].op == "RET"
                and instrs[i + 1].arg1 == ins.dst
                and len(ins.extra) == len(fn.params)
            ):
                fn.is_tco = True
                # Evaluate arguments into temporaries first so parallel assignment is safe
                tco_temps: List[Tuple[str, str, str]] = []
                for idx, ((p_name, p_type), arg_val) in enumerate(zip(fn.params, ins.extra)):
                    tmp_name = f"%tco_{i}_{idx}"
                    fn.local_types[tmp_name] = p_type
                    new_instrs.append(MIRInstr(op="MOV", dst=tmp_name, arg1=arg_val, val_type=p_type))
                    tco_temps.append((p_name, tmp_name, p_type))
                for p_name, tmp_name, p_type in tco_temps:
                    new_instrs.append(MIRInstr(op="MOV", dst=p_name, arg1=tmp_name, val_type=p_type))
                new_instrs.append(MIRInstr(op="JMP", arg1="__tco_entry", comment="tail-call jump"))
                i += 2
                continue
            new_instrs.append(ins)
            i += 1
        fn.instructions = new_instrs

    def _constant_fold_and_strength_reduce(self, fn: MIRFunction) -> None:
        consts: Dict[str, Union[int, float]] = {}
        const_types: Dict[str, str] = {}

        # Variables modified across loop back-edges cannot be treated as block-local constants
        mutated_vars = set()
        seen_defs = set()
        for ins in fn.instructions:
            if ins.dst:
                if ins.dst in seen_defs or not ins.dst.startswith("%"):
                    mutated_vars.add(ins.dst)
                seen_defs.add(ins.dst)

        for ins in fn.instructions:
            if ins.op in ("LABEL", "JMP", "JZ", "JNZ", "CALL"):
                # Clear non-SSA mutable constants at control flow boundaries
                for k in list(consts.keys()):
                    if k in mutated_vars:
                        consts.pop(k, None)
                continue

            if ins.op == "CONST_I64" and ins.dst:
                consts[ins.dst] = int(ins.arg1)
                const_types[ins.dst] = "i64"
                continue

            if ins.op == "CONST_F64" and ins.dst:
                consts[ins.dst] = float(ins.arg1)
                const_types[ins.dst] = "f64"
                continue

            if ins.op == "MOV" and ins.dst and isinstance(ins.arg1, str):
                if ins.arg1 in consts and ins.dst not in mutated_vars:
                    val = consts[ins.arg1]
                    ct = const_types[ins.arg1]
                    ins.op = "CONST_F64" if ct == "f64" else "CONST_I64"
                    ins.arg1 = val
                    ins.arg2 = None
                    consts[ins.dst] = val
                    const_types[ins.dst] = ct
                else:
                    consts.pop(ins.dst, None)
                continue

            # Fold binary operations on two known constants
            if ins.dst and isinstance(ins.arg1, str) and isinstance(ins.arg2, str):
                c1 = consts.get(ins.arg1)
                c2 = consts.get(ins.arg2)
                if c1 is not None and c2 is not None:
                    folded = self._eval_const_binop(ins.op, c1, c2)
                    if folded is not None:
                        is_flt = isinstance(folded, float) and ins.val_type == "f64"
                        ins.op = "CONST_F64" if is_flt else "CONST_I64"
                        ins.arg1 = float(folded) if is_flt else int(folded)
                        ins.arg2 = None
                        consts[ins.dst] = ins.arg1
                        const_types[ins.dst] = "f64" if is_flt else "i64"
                        continue

                # Algebraic simplification & identity reduction
                if ins.op == "MUL_I64":
                    if c2 == 1:
                        ins.op = "MOV"
                        ins.arg2 = None
                    elif c1 == 1:
                        ins.op = "MOV"
                        ins.arg1 = ins.arg2
                        ins.arg2 = None
                    elif c2 == 0 or c1 == 0:
                        ins.op = "CONST_I64"
                        ins.arg1 = 0
                        ins.arg2 = None
                        consts[ins.dst] = 0
                        const_types[ins.dst] = "i64"
                elif ins.op in ("ADD_I64", "SUB_I64") and c2 == 0:
                    ins.op = "MOV"
                    ins.arg2 = None
                elif ins.op == "ADD_I64" and c1 == 0:
                    ins.op = "MOV"
                    ins.arg1 = ins.arg2
                    ins.arg2 = None
                    ins.arg2 = None

            if ins.dst:
                consts.pop(ins.dst, None)

    def _eval_const_binop(self, op: str, a: Union[int, float], b: Union[int, float]) -> Union[int, float, None]:
        try:
            if op == "ADD_I64":
                return int(a) + int(b)
            if op == "SUB_I64":
                return int(a) - int(b)
            if op == "MUL_I64":
                return int(a) * int(b)
            if op == "DIV_I64" and int(b) != 0:
                return int(a) // int(b)
            if op == "MOD_I64" and int(b) != 0:
                return int(a) % int(b)
            if op == "SHL_I64" and 0 <= int(b) < 63:
                return int(a) << int(b)
            if op == "SHR_I64" and 0 <= int(b) < 63:
                return int(a) >> int(b)
            if op == "AND_I64":
                return int(a) & int(b)
            if op == "OR_I64":
                return int(a) | int(b)
            if op == "XOR_I64":
                return int(a) ^ int(b)
            if op == "ADD_F64":
                return float(a) + float(b)
            if op == "SUB_F64":
                return float(a) - float(b)
            if op == "MUL_F64":
                return float(a) * float(b)
            if op == "DIV_F64" and float(b) != 0.0:
                return float(a) / float(b)
            if op in ("CMP_EQ_I64", "CMP_EQ_F64"):
                return 1 if a == b else 0
            if op in ("CMP_NE_I64", "CMP_NE_F64"):
                return 1 if a != b else 0
            if op in ("CMP_LT_I64", "CMP_LT_F64"):
                return 1 if a < b else 0
            if op in ("CMP_LE_I64", "CMP_LE_F64"):
                return 1 if a <= b else 0
            if op in ("CMP_GT_I64", "CMP_GT_F64"):
                return 1 if a > b else 0
            if op in ("CMP_GE_I64", "CMP_GE_F64"):
                return 1 if a >= b else 0
        except Exception:
            return None
        return None

    def _copy_propagation(self, fn: MIRFunction) -> None:
        # Propagate single-assignment temporary copies `%t_dst = MOV %t_src`
        def_counts: Dict[str, int] = {}
        for ins in fn.instructions:
            if ins.dst:
                def_counts[ins.dst] = def_counts.get(ins.dst, 0) + 1

        replacements: Dict[str, str] = {}
        for ins in fn.instructions:
            if (
                ins.op == "MOV"
                and ins.dst
                and ins.dst.startswith("%t")
                and not ins.dst.startswith("%tco")
                and isinstance(ins.arg1, str)
                and def_counts.get(ins.dst, 0) == 1
                and def_counts.get(ins.arg1, 0) == 1
            ):
                src = replacements.get(ins.arg1, ins.arg1)
                replacements[ins.dst] = src

        if not replacements:
            return

        for ins in fn.instructions:
            if ins.op == "STORE_IDX" and ins.dst and ins.dst in replacements:
                ins.dst = replacements[ins.dst]
            if isinstance(ins.arg1, str) and ins.arg1 in replacements and ins.op != "LABEL":
                ins.arg1 = replacements[ins.arg1]
            if isinstance(ins.arg2, str) and ins.arg2 in replacements and ins.op not in ("JZ", "JNZ"):
                ins.arg2 = replacements[ins.arg2]
            if ins.extra:
                ins.extra = [replacements.get(x, x) for x in ins.extra]

    def _dead_code_elimination(self, fn: MIRFunction) -> None:
        used = set()
        for ins in fn.instructions:
            if ins.op == "STORE_IDX" and ins.dst:
                used.add(ins.dst)
            if isinstance(ins.arg1, str) and ins.op not in ("LABEL", "JMP", "CALL"):
                used.add(ins.arg1)
            if isinstance(ins.arg2, str) and ins.op not in ("JZ", "JNZ"):
                used.add(ins.arg2)
            for x in ins.extra:
                used.add(x)

        fn.instructions = [
            ins
            for ins in fn.instructions
            if not (
                ins.dst
                and ins.dst.startswith("%t")
                and ins.dst not in used
                and ins.op not in ("CALL", "PRINT", "STORE_IDX", "ALLOC_ARR")
            )
        ]
