"""
Black Mamba (.bmb) Intermediate Representation (MIR), Dynamic OOP Lowering & Multi-Pass Optimizer.

Lowers typed AST into a 3-address Intermediate Representation (MIR) supporting:
- 0-header value `struct`s with 1-cycle direct calls
- Dynamic OOP `class`es with C3 diamond MRO, `super()`, virtual vtables, `isinstance`,
  and runtime monkey-patching (`setattr`, `getattr`, `hasattr`)
- Pay-what-you-use multi-frame stack-unwinding structured exceptions (`try`/`except`/`else`/`finally` & `raise`)
- Multi-pass optimization (TCO, Constant Folding, Strength Reduction, Copy Propagation, DCE, Lexical Arena Lifetimes)
"""

import os
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Set, Tuple, Union
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
    MatchStmt,
    MethodCall,
    Module,
    Param,
    RaiseStmt,
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
    line: int = 0

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
    start_line: int = 1

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
    filename: str = "<input.bmb>"
    extern_functions: Dict[str, Tuple[str, Optional[str], List[Tuple[str, str]], str, str]] = field(default_factory=dict)

    def format(self) -> str:
        return "\n\n".join(fn.format() for fn in self.functions)


@dataclass
class _TryContext:
    catch_target: str
    finally_body: List[Stmt]
    loop_depth: int


class MIRBuilder:
    def __init__(self):
        self.temp_counter = 0
        self.label_counter = 0
        self.loop_stack: List[Tuple[str, str]] = []  # (continue_label, break_label)
        self.structs: Dict[str, StructDef] = {}
        self.func_return_types: Dict[str, str] = {}
        self.func_params: Dict[str, List[Param]] = {}
        self.string_pool: List[str] = []
        self.extern_functions: Dict[str, Tuple[str, Optional[str], List[Tuple[str, str]], str, str]] = {}

        # Dynamic OOP & Exception state
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

        self.try_stack: List[_TryContext] = []
        self.active_caught_exc_vars: List[str] = []
        self.cur_fn_name: str = ""
        self.cur_fn_return_type: str = "i64"
        self.cur_fn_unwind_label: str = ""
        self.cur_fn_needs_unwind_pad: bool = False
        self.entry_fn_name: str = "main"

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

    def build(self, module: Module, base_dir: str = "", filename: str = "<input.bmb>") -> MIRModule:
        from .module_loader import resolve_imports
        self.filename = filename
        module = resolve_imports(module, base_dir or os.getcwd())
        Inferencer = TypeInferencer(module)
        module = Inferencer.run()

        self.structs = Inferencer.structs
        self.has_exceptions = Inferencer.has_exceptions
        self.dynamic_classes = Inferencer.dynamic_classes
        self.mro = Inferencer.mro
        self.class_ids = Inferencer.class_ids
        self.mro_masks = Inferencer.mro_masks
        self.class_field_offsets = Inferencer.class_field_offsets
        self.class_alloc_slots = Inferencer.class_alloc_slots
        self.vtable_indices = Inferencer.vtable_indices
        self.vtable_methods = Inferencer.vtable_methods
        self.vtable_method_owners = Inferencer.vtable_method_owners
        self.dyn_attr_types = Inferencer.dyn_attr_types
        self.extern_functions = Inferencer.extern_funcs

        for fname, sig in Inferencer.signatures.items():
            self.func_return_types[fname] = sig.return_type
        for fname, fn_def in Inferencer.funcs.items():
            self.func_params[fname] = fn_def.params

        mir_funcs: List[MIRFunction] = []
        top_stmts: List[Stmt] = []
        self.constants: Dict[str, Expr] = {}

        # Synthesize dynamic OOP runtime helpers when dynamic classes are used
        if self.dynamic_classes:
            mir_funcs.extend(self._synthesize_oop_helpers())

        # Pre-check whether top-level statements exist so we know the exact entry function name
        has_user_main = any(isinstance(s, FuncDef) and s.name == "main" for s in module.statements)
        has_top_exec = any(
            not isinstance(s, (StructDef, FuncDef, ExternBlock))
            and not (isinstance(s, ExprStmt) and isinstance(s.expr, StringLit) and not s.expr.value.startswith("f:"))
            for s in module.statements
        )
        self.entry_fn_name = "__bmb_main__" if (has_top_exec and has_user_main) else "main"

        for stmt in module.statements:
            if isinstance(stmt, Assign) and isinstance(stmt.value, (FloatLit, IntLit, BoolLit, StringLit)):
                self.constants[stmt.target] = stmt.value
            if isinstance(stmt, (StructDef, ExternBlock)):
                continue
            elif isinstance(stmt, FuncDef):
                mir_funcs.append(self._lower_function(stmt))
            elif isinstance(stmt, ExprStmt) and isinstance(stmt.expr, StringLit) and not stmt.expr.value.startswith("f:"):
                # Pure module-level docstring: no runtime effect
                continue
            else:
                top_stmts.append(stmt)

        # Synthesize `main` function from top-level statements if any exist, or if `main` wasn't defined
        existing_main = next((f for f in mir_funcs if f.name == "main"), None)
        if top_stmts:
            body_stmts = list(top_stmts)
            calls_main = any(
                isinstance(s, ExprStmt) and isinstance(s.expr, Call) and s.expr.func == "main"
                for s in top_stmts
            )
            if existing_main and not calls_main:
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

        mir_mod = MIRModule(
            functions=mir_funcs,
            structs=self.structs,
            string_pool=self.string_pool,
            filename=filename,
            extern_functions=self.extern_functions,
        )
        MIROptimizer().optimize_module(mir_mod)
        return mir_mod

    def _synthesize_oop_helpers(self) -> List[MIRFunction]:
        """
        Synthesize pure-MIR helpers for:
        1. `__bmb_ensure_vtables() -> i64`: lazily populates global vtable directory in `rt_slot[1]`
        2. `__bmb_dyn_set(obj: i64, key: str, val: i64) -> i64`: sets per-instance dynamic attribute
        3. `__bmb_dyn_get(obj: i64, key: str, default_val: i64) -> i64`: gets per-instance dynamic attribute
        4. `__bmb_dyn_has(obj: i64, key: str) -> bool`: checks per-instance dynamic attribute existence
        """
        helpers: List[MIRFunction] = []

        # 1. __bmb_ensure_vtables
        self.temp_counter = 0
        lt_vt: Dict[str, str] = {}
        ins_vt: List[MIRInstr] = [MIRInstr(op="LABEL", arg1="__tco_entry", line=1)]
        c1 = self.new_temp(lt_vt, "i64")
        dir_ptr = self.new_temp(lt_vt, "i64")
        done_lbl = self.new_label("vt_ready")
        ins_vt.append(MIRInstr(op="CONST_I64", dst=c1, arg1=1, val_type="i64"))
        ins_vt.append(MIRInstr(op="CALL", dst=dir_ptr, arg1="__bmb_rt_slot_get", extra=[c1], val_type="i64"))
        ins_vt.append(MIRInstr(op="JNZ", arg1=dir_ptr, arg2=done_lbl))

        max_cid = max(self.class_ids.values(), default=0)
        dir_bytes = self.new_temp(lt_vt, "i64")
        ins_vt.append(MIRInstr(op="CONST_I64", dst=dir_bytes, arg1=(max_cid + 1) * 8, val_type="i64"))
        ins_vt.append(MIRInstr(op="CALL", dst=dir_ptr, arg1="__bmb_mem_alloc", extra=[dir_bytes], val_type="i64"))

        for cls_name in self.dynamic_classes:
            cid = self.class_ids[cls_name]
            v_methods = self.vtable_methods.get(cls_name, [])
            vt_bytes = self.new_temp(lt_vt, "i64")
            vt_ptr = self.new_temp(lt_vt, "i64")
            ins_vt.append(MIRInstr(op="CONST_I64", dst=vt_bytes, arg1=max(1, len(v_methods)) * 8, val_type="i64"))
            ins_vt.append(MIRInstr(op="CALL", dst=vt_ptr, arg1="__bmb_mem_alloc", extra=[vt_bytes], val_type="i64"))
            for m_idx, fn_target in enumerate(v_methods):
                if fn_target and fn_target in self.func_return_types:
                    idx_t = self.new_temp(lt_vt, "i64")
                    fn_ptr_t = self.new_temp(lt_vt, "i64")
                    ign = self.new_temp(lt_vt, "i64")
                    ins_vt.append(MIRInstr(op="CONST_I64", dst=idx_t, arg1=m_idx, val_type="i64"))
                    ins_vt.append(MIRInstr(op="MOV", dst=fn_ptr_t, arg1=fn_target, val_type="i64"))
                    ins_vt.append(MIRInstr(op="CALL", dst=ign, arg1="__bmb_mem_write", extra=[vt_ptr, idx_t, fn_ptr_t], val_type="i64"))
            cid_t = self.new_temp(lt_vt, "i64")
            ign2 = self.new_temp(lt_vt, "i64")
            ins_vt.append(MIRInstr(op="CONST_I64", dst=cid_t, arg1=cid, val_type="i64"))
            ins_vt.append(MIRInstr(op="CALL", dst=ign2, arg1="__bmb_mem_write", extra=[dir_ptr, cid_t, vt_ptr], val_type="i64"))

        ign_s = self.new_temp(lt_vt, "i64")
        ins_vt.append(MIRInstr(op="CALL", dst=ign_s, arg1="__bmb_rt_slot_set", extra=[c1, dir_ptr], val_type="i64"))
        ins_vt.append(MIRInstr(op="LABEL", arg1=done_lbl))
        ins_vt.append(MIRInstr(op="RET", arg1=dir_ptr, val_type="i64"))
        helpers.append(MIRFunction(name="__bmb_ensure_vtables", params=[], return_type="i64", instructions=ins_vt, local_types=lt_vt, start_line=1))
        self.func_return_types["__bmb_ensure_vtables"] = "i64"

        # 2. __bmb_dyn_set(obj: i64, key: str, val: i64) -> i64
        self.temp_counter = 0
        lt_ds: Dict[str, str] = {"obj": "i64", "key": "str", "val": "i64", "props": "i64", "i": "i64"}
        ins_ds: List[MIRInstr] = [MIRInstr(op="LABEL", arg1="__tco_entry", line=1)]
        c2 = self.new_temp(lt_ds, "i64")
        ins_ds.append(MIRInstr(op="CONST_I64", dst=c2, arg1=2, val_type="i64"))
        p_init = self.new_temp(lt_ds, "i64")
        ins_ds.append(MIRInstr(op="CALL", dst=p_init, arg1="__bmb_mem_read", extra=["obj", c2], val_type="i64"))
        ins_ds.append(MIRInstr(op="MOV", dst="props", arg1=p_init, val_type="i64"))
        has_p_lbl = self.new_label("dyn_has_p")
        ins_ds.append(MIRInstr(op="JNZ", arg1="props", arg2=has_p_lbl))
        sz_t = self.new_temp(lt_ds, "i64")
        new_p = self.new_temp(lt_ds, "i64")
        ign_w = self.new_temp(lt_ds, "i64")
        ins_ds.append(MIRInstr(op="CONST_I64", dst=sz_t, arg1=520, val_type="i64"))
        ins_ds.append(MIRInstr(op="CALL", dst=new_p, arg1="__bmb_mem_alloc", extra=[sz_t], val_type="i64"))
        ins_ds.append(MIRInstr(op="MOV", dst="props", arg1=new_p, val_type="i64"))
        ins_ds.append(MIRInstr(op="CALL", dst=ign_w, arg1="__bmb_mem_write", extra=["obj", c2, "props"], val_type="i64"))
        ins_ds.append(MIRInstr(op="LABEL", arg1=has_p_lbl))

        c0 = self.new_temp(lt_ds, "i64")
        cnt_v = self.new_temp(lt_ds, "i64")
        ins_ds.append(MIRInstr(op="CONST_I64", dst=c0, arg1=0, val_type="i64"))
        ins_ds.append(MIRInstr(op="CALL", dst=cnt_v, arg1="__bmb_mem_read", extra=["props", c0], val_type="i64"))
        ins_ds.append(MIRInstr(op="MOV", dst="i", arg1=c0, val_type="i64"))

        loop_lbl = self.new_label("dyn_s_loop")
        end_lbl = self.new_label("dyn_s_append")
        next_lbl = self.new_label("dyn_s_next")
        ins_ds.append(MIRInstr(op="LABEL", arg1=loop_lbl))
        cmp_i = self.new_temp(lt_ds, "bool")
        ins_ds.append(MIRInstr(op="CMP_LT_I64", dst=cmp_i, arg1="i", arg2=cnt_v, val_type="bool"))
        ins_ds.append(MIRInstr(op="JZ", arg1=cmp_i, arg2=end_lbl))
        two_t = self.new_temp(lt_ds, "i64")
        one_t = self.new_temp(lt_ds, "i64")
        mul_t = self.new_temp(lt_ds, "i64")
        k_off = self.new_temp(lt_ds, "i64")
        v_off = self.new_temp(lt_ds, "i64")
        cur_k = self.new_temp(lt_ds, "str")
        eq_k = self.new_temp(lt_ds, "bool")
        ins_ds.append(MIRInstr(op="CONST_I64", dst=two_t, arg1=2, val_type="i64"))
        ins_ds.append(MIRInstr(op="CONST_I64", dst=one_t, arg1=1, val_type="i64"))
        ins_ds.append(MIRInstr(op="MUL_I64", dst=mul_t, arg1="i", arg2=two_t, val_type="i64"))
        ins_ds.append(MIRInstr(op="ADD_I64", dst=k_off, arg1=mul_t, arg2=one_t, val_type="i64"))
        ins_ds.append(MIRInstr(op="CALL", dst=cur_k, arg1="__bmb_mem_read", extra=["props", k_off], val_type="str"))
        ins_ds.append(MIRInstr(op="STR_CMP_EQ", dst=eq_k, arg1=cur_k, arg2="key", val_type="bool"))
        ins_ds.append(MIRInstr(op="JZ", arg1=eq_k, arg2=next_lbl))
        ins_ds.append(MIRInstr(op="ADD_I64", dst=v_off, arg1=k_off, arg2=one_t, val_type="i64"))
        ign_u = self.new_temp(lt_ds, "i64")
        ins_ds.append(MIRInstr(op="CALL", dst=ign_u, arg1="__bmb_mem_write", extra=["props", v_off, "val"], val_type="i64"))
        ins_ds.append(MIRInstr(op="RET", arg1="val", val_type="i64"))
        ins_ds.append(MIRInstr(op="LABEL", arg1=next_lbl))
        nxt_i = self.new_temp(lt_ds, "i64")
        ins_ds.append(MIRInstr(op="ADD_I64", dst=nxt_i, arg1="i", arg2=one_t, val_type="i64"))
        ins_ds.append(MIRInstr(op="MOV", dst="i", arg1=nxt_i, val_type="i64"))
        ins_ds.append(MIRInstr(op="JMP", arg1=loop_lbl))

        ins_ds.append(MIRInstr(op="LABEL", arg1=end_lbl))
        cap_t = self.new_temp(lt_ds, "i64")
        can_add = self.new_temp(lt_ds, "bool")
        full_lbl = self.new_label("dyn_s_full")
        ins_ds.append(MIRInstr(op="CONST_I64", dst=cap_t, arg1=32, val_type="i64"))
        ins_ds.append(MIRInstr(op="CMP_LT_I64", dst=can_add, arg1=cnt_v, arg2=cap_t, val_type="bool"))
        ins_ds.append(MIRInstr(op="JZ", arg1=can_add, arg2=full_lbl))
        two_a = self.new_temp(lt_ds, "i64")
        one_a = self.new_temp(lt_ds, "i64")
        mul_a = self.new_temp(lt_ds, "i64")
        ak_off = self.new_temp(lt_ds, "i64")
        av_off = self.new_temp(lt_ds, "i64")
        new_cnt = self.new_temp(lt_ds, "i64")
        w1 = self.new_temp(lt_ds, "i64")
        w2 = self.new_temp(lt_ds, "i64")
        w3 = self.new_temp(lt_ds, "i64")
        ins_ds.append(MIRInstr(op="CONST_I64", dst=two_a, arg1=2, val_type="i64"))
        ins_ds.append(MIRInstr(op="CONST_I64", dst=one_a, arg1=1, val_type="i64"))
        ins_ds.append(MIRInstr(op="MUL_I64", dst=mul_a, arg1=cnt_v, arg2=two_a, val_type="i64"))
        ins_ds.append(MIRInstr(op="ADD_I64", dst=ak_off, arg1=mul_a, arg2=one_a, val_type="i64"))
        ins_ds.append(MIRInstr(op="ADD_I64", dst=av_off, arg1=ak_off, arg2=one_a, val_type="i64"))
        ins_ds.append(MIRInstr(op="ADD_I64", dst=new_cnt, arg1=cnt_v, arg2=one_a, val_type="i64"))
        ins_ds.append(MIRInstr(op="CALL", dst=w1, arg1="__bmb_mem_write", extra=["props", ak_off, "key"], val_type="i64"))
        ins_ds.append(MIRInstr(op="CALL", dst=w2, arg1="__bmb_mem_write", extra=["props", av_off, "val"], val_type="i64"))
        ins_ds.append(MIRInstr(op="CALL", dst=w3, arg1="__bmb_mem_write", extra=["props", c0, new_cnt], val_type="i64"))
        ins_ds.append(MIRInstr(op="LABEL", arg1=full_lbl))
        ins_ds.append(MIRInstr(op="RET", arg1="val", val_type="i64"))
        helpers.append(
            MIRFunction(
                name="__bmb_dyn_set",
                params=[("obj", "i64"), ("key", "str"), ("val", "i64")],
                return_type="i64",
                instructions=ins_ds,
                local_types=lt_ds,
                start_line=1,
            )
        )
        self.func_return_types["__bmb_dyn_set"] = "i64"

        # 3. __bmb_dyn_get(obj: i64, key: str, default_val: i64) -> i64
        self.temp_counter = 0
        lt_dg: Dict[str, str] = {"obj": "i64", "key": "str", "default_val": "i64", "i": "i64"}
        ins_dg: List[MIRInstr] = [MIRInstr(op="LABEL", arg1="__tco_entry", line=1)]
        g_c2 = self.new_temp(lt_dg, "i64")
        g_props = self.new_temp(lt_dg, "i64")
        g_miss = self.new_label("dyn_g_miss")
        ins_dg.append(MIRInstr(op="CONST_I64", dst=g_c2, arg1=2, val_type="i64"))
        ins_dg.append(MIRInstr(op="CALL", dst=g_props, arg1="__bmb_mem_read", extra=["obj", g_c2], val_type="i64"))
        ins_dg.append(MIRInstr(op="JZ", arg1=g_props, arg2=g_miss))
        g_c0 = self.new_temp(lt_dg, "i64")
        g_cnt = self.new_temp(lt_dg, "i64")
        ins_dg.append(MIRInstr(op="CONST_I64", dst=g_c0, arg1=0, val_type="i64"))
        ins_dg.append(MIRInstr(op="CALL", dst=g_cnt, arg1="__bmb_mem_read", extra=[g_props, g_c0], val_type="i64"))
        ins_dg.append(MIRInstr(op="MOV", dst="i", arg1=g_c0, val_type="i64"))
        g_loop = self.new_label("dyn_g_loop")
        g_next = self.new_label("dyn_g_next")
        ins_dg.append(MIRInstr(op="LABEL", arg1=g_loop))
        g_cmp = self.new_temp(lt_dg, "bool")
        ins_dg.append(MIRInstr(op="CMP_LT_I64", dst=g_cmp, arg1="i", arg2=g_cnt, val_type="bool"))
        ins_dg.append(MIRInstr(op="JZ", arg1=g_cmp, arg2=g_miss))
        g_two = self.new_temp(lt_dg, "i64")
        g_one = self.new_temp(lt_dg, "i64")
        g_mul = self.new_temp(lt_dg, "i64")
        gk_off = self.new_temp(lt_dg, "i64")
        gv_off = self.new_temp(lt_dg, "i64")
        g_curk = self.new_temp(lt_dg, "str")
        g_eq = self.new_temp(lt_dg, "bool")
        g_res = self.new_temp(lt_dg, "i64")
        ins_dg.append(MIRInstr(op="CONST_I64", dst=g_two, arg1=2, val_type="i64"))
        ins_dg.append(MIRInstr(op="CONST_I64", dst=g_one, arg1=1, val_type="i64"))
        ins_dg.append(MIRInstr(op="MUL_I64", dst=g_mul, arg1="i", arg2=g_two, val_type="i64"))
        ins_dg.append(MIRInstr(op="ADD_I64", dst=gk_off, arg1=g_mul, arg2=g_one, val_type="i64"))
        ins_dg.append(MIRInstr(op="CALL", dst=g_curk, arg1="__bmb_mem_read", extra=[g_props, gk_off], val_type="str"))
        ins_dg.append(MIRInstr(op="STR_CMP_EQ", dst=g_eq, arg1=g_curk, arg2="key", val_type="bool"))
        ins_dg.append(MIRInstr(op="JZ", arg1=g_eq, arg2=g_next))
        ins_dg.append(MIRInstr(op="ADD_I64", dst=gv_off, arg1=gk_off, arg2=g_one, val_type="i64"))
        ins_dg.append(MIRInstr(op="CALL", dst=g_res, arg1="__bmb_mem_read", extra=[g_props, gv_off], val_type="i64"))
        ins_dg.append(MIRInstr(op="RET", arg1=g_res, val_type="i64"))
        ins_dg.append(MIRInstr(op="LABEL", arg1=g_next))
        g_ni = self.new_temp(lt_dg, "i64")
        ins_dg.append(MIRInstr(op="ADD_I64", dst=g_ni, arg1="i", arg2=g_one, val_type="i64"))
        ins_dg.append(MIRInstr(op="MOV", dst="i", arg1=g_ni, val_type="i64"))
        ins_dg.append(MIRInstr(op="JMP", arg1=g_loop))
        ins_dg.append(MIRInstr(op="LABEL", arg1=g_miss))
        ins_dg.append(MIRInstr(op="RET", arg1="default_val", val_type="i64"))
        helpers.append(
            MIRFunction(
                name="__bmb_dyn_get",
                params=[("obj", "i64"), ("key", "str"), ("default_val", "i64")],
                return_type="i64",
                instructions=ins_dg,
                local_types=lt_dg,
                start_line=1,
            )
        )
        self.func_return_types["__bmb_dyn_get"] = "i64"

        # 4. __bmb_dyn_has(obj: i64, key: str) -> bool
        self.temp_counter = 0
        lt_dh: Dict[str, str] = {"obj": "i64", "key": "str", "i": "i64"}
        ins_dh: List[MIRInstr] = [MIRInstr(op="LABEL", arg1="__tco_entry", line=1)]
        h_c2 = self.new_temp(lt_dh, "i64")
        h_props = self.new_temp(lt_dh, "i64")
        h_miss = self.new_label("dyn_h_miss")
        ins_dh.append(MIRInstr(op="CONST_I64", dst=h_c2, arg1=2, val_type="i64"))
        ins_dh.append(MIRInstr(op="CALL", dst=h_props, arg1="__bmb_mem_read", extra=["obj", h_c2], val_type="i64"))
        ins_dh.append(MIRInstr(op="JZ", arg1=h_props, arg2=h_miss))
        h_c0 = self.new_temp(lt_dh, "i64")
        h_cnt = self.new_temp(lt_dh, "i64")
        ins_dh.append(MIRInstr(op="CONST_I64", dst=h_c0, arg1=0, val_type="i64"))
        ins_dh.append(MIRInstr(op="CALL", dst=h_cnt, arg1="__bmb_mem_read", extra=[h_props, h_c0], val_type="i64"))
        ins_dh.append(MIRInstr(op="MOV", dst="i", arg1=h_c0, val_type="i64"))
        h_loop = self.new_label("dyn_h_loop")
        h_next = self.new_label("dyn_h_next")
        ins_dh.append(MIRInstr(op="LABEL", arg1=h_loop))
        h_cmp = self.new_temp(lt_dh, "bool")
        ins_dh.append(MIRInstr(op="CMP_LT_I64", dst=h_cmp, arg1="i", arg2=h_cnt, val_type="bool"))
        ins_dh.append(MIRInstr(op="JZ", arg1=h_cmp, arg2=h_miss))
        h_two = self.new_temp(lt_dh, "i64")
        h_one = self.new_temp(lt_dh, "i64")
        h_mul = self.new_temp(lt_dh, "i64")
        hk_off = self.new_temp(lt_dh, "i64")
        h_curk = self.new_temp(lt_dh, "str")
        h_eq = self.new_temp(lt_dh, "bool")
        ins_dh.append(MIRInstr(op="CONST_I64", dst=h_two, arg1=2, val_type="i64"))
        ins_dh.append(MIRInstr(op="CONST_I64", dst=h_one, arg1=1, val_type="i64"))
        ins_dh.append(MIRInstr(op="MUL_I64", dst=h_mul, arg1="i", arg2=h_two, val_type="i64"))
        ins_dh.append(MIRInstr(op="ADD_I64", dst=hk_off, arg1=h_mul, arg2=h_one, val_type="i64"))
        ins_dh.append(MIRInstr(op="CALL", dst=h_curk, arg1="__bmb_mem_read", extra=[h_props, hk_off], val_type="str"))
        ins_dh.append(MIRInstr(op="STR_CMP_EQ", dst=h_eq, arg1=h_curk, arg2="key", val_type="bool"))
        ins_dh.append(MIRInstr(op="JZ", arg1=h_eq, arg2=h_next))
        ins_dh.append(MIRInstr(op="RET", arg1=h_one, val_type="bool"))
        ins_dh.append(MIRInstr(op="LABEL", arg1=h_next))
        h_ni = self.new_temp(lt_dh, "i64")
        ins_dh.append(MIRInstr(op="ADD_I64", dst=h_ni, arg1="i", arg2=h_one, val_type="i64"))
        ins_dh.append(MIRInstr(op="MOV", dst="i", arg1=h_ni, val_type="i64"))
        ins_dh.append(MIRInstr(op="JMP", arg1=h_loop))
        ins_dh.append(MIRInstr(op="LABEL", arg1=h_miss))
        h_zero = self.new_temp(lt_dh, "bool")
        ins_dh.append(MIRInstr(op="CONST_I64", dst=h_zero, arg1=0, val_type="bool"))
        ins_dh.append(MIRInstr(op="RET", arg1=h_zero, val_type="bool"))
        helpers.append(
            MIRFunction(
                name="__bmb_dyn_has",
                params=[("obj", "i64"), ("key", "str")],
                return_type="bool",
                instructions=ins_dh,
                local_types=lt_dh,
                start_line=1,
            )
        )
        self.func_return_types["__bmb_dyn_has"] = "bool"

        return helpers

    def _emit_post_call_unwind_check(self, instrs: List[MIRInstr], local_types: Dict[str, str]) -> None:
        if not self.has_exceptions:
            return
        slot0 = self.new_temp(local_types, "i64")
        exc_p = self.new_temp(local_types, "i64")
        instrs.append(MIRInstr(op="CONST_I64", dst=slot0, arg1=0, val_type="i64"))
        instrs.append(MIRInstr(op="CALL", dst=exc_p, arg1="__bmb_rt_slot_get", extra=[slot0], val_type="i64"))
        if self.try_stack:
            instrs.append(MIRInstr(op="JNZ", arg1=exc_p, arg2=self.try_stack[-1].catch_target))
        else:
            self.cur_fn_needs_unwind_pad = True
            instrs.append(MIRInstr(op="JNZ", arg1=exc_p, arg2=self.cur_fn_unwind_label))

    def _lower_function(self, fn: FuncDef) -> MIRFunction:
        self.temp_counter = 0
        self.try_stack = []
        self.active_caught_exc_vars = []
        self.cur_fn_name = fn.name
        self.cur_fn_return_type = fn.return_type or "i64"
        self.cur_fn_unwind_label = self.new_label("fn_unwind")
        self.cur_fn_needs_unwind_pad = False

        params = [(p.name, p.type_ann or "i64") for p in fn.params]
        local_types: Dict[str, str] = {name: ptype for name, ptype in params}
        instrs: List[MIRInstr] = [MIRInstr(op="LABEL", arg1="__tco_entry", line=fn.line or 1)]

        self._lower_block(fn.body, instrs, local_types)

        # Ensure function ends with a return instruction
        if not instrs or instrs[-1].op != "RET":
            default_ret = 0.0 if fn.return_type == "f64" else 0
            tmp = self.new_temp(local_types, fn.return_type or "i64")
            const_op = "CONST_F64" if fn.return_type == "f64" else "CONST_I64"
            instrs.append(MIRInstr(op=const_op, dst=tmp, arg1=default_ret, val_type=fn.return_type or "i64", line=fn.line or 1))
            instrs.append(MIRInstr(op="RET", arg1=tmp, val_type=fn.return_type or "i64", line=fn.line or 1))

        # Emit multi-frame stack-unwind landing pad if any nested call or `raise` can unwind out of `fn`
        if self.cur_fn_needs_unwind_pad:
            instrs.append(MIRInstr(op="LABEL", arg1=self.cur_fn_unwind_label, line=fn.line or 1))
            if fn.name == self.entry_fn_name:
                # Top-level uncaught exception handler: print Pythonic traceback and exit(1)
                c0 = self.new_temp(local_types, "i64")
                exc_v = self.new_temp(local_types, "BaseException")
                ign_clr = self.new_temp(local_types, "i64")
                msg_idx = self.class_field_offsets.get(("BaseException", "message"), 3)
                line_idx = self.class_field_offsets.get(("BaseException", "line"), 5)
                m_off = self.new_temp(local_types, "i64")
                l_off = self.new_temp(local_types, "i64")
                msg_v = self.new_temp(local_types, "str")
                line_v = self.new_temp(local_types, "i64")
                p1_id = self.intern_string("[Unhandled Exception L")
                p2_id = self.intern_string("] ")
                p1_s = self.new_temp(local_types, "str")
                p2_s = self.new_temp(local_types, "str")
                one_code = self.new_temp(local_types, "i64")
                ign_ex = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CONST_I64", dst=c0, arg1=0, val_type="i64"))
                instrs.append(MIRInstr(op="CALL", dst=exc_v, arg1="__bmb_rt_slot_get", extra=[c0], val_type="BaseException"))
                instrs.append(MIRInstr(op="CALL", dst=ign_clr, arg1="__bmb_rt_slot_set", extra=[c0, c0], val_type="i64"))
                instrs.append(MIRInstr(op="CONST_I64", dst=m_off, arg1=msg_idx, val_type="i64"))
                instrs.append(MIRInstr(op="CONST_I64", dst=l_off, arg1=line_idx, val_type="i64"))
                instrs.append(MIRInstr(op="LOAD_IDX", dst=msg_v, arg1=exc_v, arg2=m_off, val_type="str"))
                instrs.append(MIRInstr(op="LOAD_IDX", dst=line_v, arg1=exc_v, arg2=l_off, val_type="i64"))
                instrs.append(MIRInstr(op="CONST_STR", dst=p1_s, arg1=p1_id, val_type="str"))
                instrs.append(MIRInstr(op="CONST_STR", dst=p2_s, arg1=p2_id, val_type="str"))
                instrs.append(MIRInstr(op="PRINT", extra=[p1_s, line_v, p2_s, msg_v], comment="str,i64,str,str", val_type="void"))
                instrs.append(MIRInstr(op="CONST_I64", dst=one_code, arg1=1, val_type="i64"))
                instrs.append(MIRInstr(op="CALL", dst=ign_ex, arg1="__bmb_exit", extra=[one_code], val_type="i64"))
                instrs.append(MIRInstr(op="RET", arg1=one_code, val_type="i64", comment="unwind_ret"))
            else:
                u_ret = 0.0 if fn.return_type == "f64" else 0
                u_tmp = self.new_temp(local_types, fn.return_type or "i64")
                u_op = "CONST_F64" if fn.return_type == "f64" else "CONST_I64"
                instrs.append(MIRInstr(op=u_op, dst=u_tmp, arg1=u_ret, val_type=fn.return_type or "i64"))
                instrs.append(MIRInstr(op="RET", arg1=u_tmp, val_type=fn.return_type or "i64", comment="unwind_ret"))

        return MIRFunction(
            name=fn.name,
            params=params,
            return_type=fn.return_type or "i64",
            instructions=instrs,
            local_types=local_types,
            decorators=fn.decorators,
            start_line=fn.line or 1,
        )

    def _lower_block(self, stmts: List[Stmt], instrs: List[MIRInstr], local_types: Dict[str, str]) -> None:
        for stmt in stmts:
            start_idx = len(instrs)
            self._lower_stmt(stmt, instrs, local_types)
            stmt_line = getattr(stmt, "line", 0) or 0
            if stmt_line > 0:
                for k in range(start_idx, len(instrs)):
                    if instrs[k].line == 0:
                        instrs[k].line = stmt_line

    def _run_enclosing_finally_for_exit(self, min_try_idx: int, instrs: List[MIRInstr], local_types: Dict[str, str]) -> None:
        """Execute enclosing `finally:` suites in LIFO order before early `return` / `break` / `continue`."""
        saved_stack = list(self.try_stack)
        for idx in range(len(saved_stack) - 1, min_try_idx - 1, -1):
            ctx = saved_stack[idx]
            if ctx.finally_body:
                self.try_stack = saved_stack[:idx]
                self._lower_block(ctx.finally_body, instrs, local_types)
        self.try_stack = saved_stack

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
            if field_idx >= 0:
                idx_tmp = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CONST_I64", dst=idx_tmp, arg1=field_idx, val_type="i64"))
                instrs.append(MIRInstr(op="STORE_IDX", dst=obj_v, arg1=idx_tmp, arg2=val_v, val_type=val_t))
            elif obj_t in self.dynamic_classes:
                key_id = self.intern_string(stmt.field_name)
                key_v = self.new_temp(local_types, "str")
                ign = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CONST_STR", dst=key_v, arg1=key_id, comment=stmt.field_name, val_type="str"))
                instrs.append(MIRInstr(op="CALL", dst=ign, arg1="__bmb_dyn_set", extra=[obj_v, key_v, val_v], val_type="i64"))
            return

        if isinstance(stmt, Return):
            if stmt.value is not None:
                rv, rt = self._lower_expr(stmt.value, instrs, local_types)
                self._run_enclosing_finally_for_exit(0, instrs, local_types)
                instrs.append(MIRInstr(op="RET", arg1=rv, val_type=rt))
            else:
                self._run_enclosing_finally_for_exit(0, instrs, local_types)
                tmp = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CONST_I64", dst=tmp, arg1=0, val_type="i64"))
                instrs.append(MIRInstr(op="RET", arg1=tmp, val_type="i64"))
            return

        if isinstance(stmt, RaiseStmt):
            stmt_line = stmt.line or 1
            if stmt.exc is None:
                if self.active_caught_exc_vars:
                    exc_v = self.active_caught_exc_vars[-1]
                else:
                    c0_r = self.new_temp(local_types, "i64")
                    exc_v = self.new_temp(local_types, "i64")
                    instrs.append(MIRInstr(op="CONST_I64", dst=c0_r, arg1=0, val_type="i64"))
                    instrs.append(MIRInstr(op="CALL", dst=exc_v, arg1="__bmb_rt_slot_get", extra=[c0_r], val_type="i64"))
            elif isinstance(stmt.exc, Var) and stmt.exc.name in self.structs and stmt.exc.name not in local_types:
                ctor_call = Call(
                    line=stmt_line,
                    col=stmt.col,
                    func=stmt.exc.name,
                    args=[StringLit(line=stmt_line, col=stmt.col, value=stmt.exc.name), IntLit(value=0), IntLit(value=stmt_line)],
                    inferred_type=stmt.exc.name,
                )
                exc_v, _ = self._lower_expr(ctor_call, instrs, local_types)
            else:
                ev, et = self._lower_expr(stmt.exc, instrs, local_types)
                if et == "str":
                    ctor_call = Call(
                        line=stmt_line,
                        col=stmt.col,
                        func="RuntimeError",
                        args=[stmt.exc, IntLit(value=0), IntLit(value=stmt_line)],
                        inferred_type="RuntimeError",
                    )
                    exc_v, _ = self._lower_expr(ctor_call, instrs, local_types)
                else:
                    exc_v = ev
                    if (et, "line") in self.class_field_offsets and (
                        not isinstance(stmt.exc, Call) or len(stmt.exc.args) < 3
                    ):
                        l_slot = self._class_or_base_offset(et, "line")
                        l_idx_t = self.new_temp(local_types, "i64")
                        l_val_t = self.new_temp(local_types, "i64")
                        instrs.append(MIRInstr(op="CONST_I64", dst=l_idx_t, arg1=l_slot, val_type="i64"))
                        instrs.append(MIRInstr(op="CONST_I64", dst=l_val_t, arg1=stmt_line, val_type="i64"))
                        instrs.append(MIRInstr(op="STORE_IDX", dst=exc_v, arg1=l_idx_t, arg2=l_val_t, val_type="i64"))

            c0_set = self.new_temp(local_types, "i64")
            ign_set = self.new_temp(local_types, "i64")
            instrs.append(MIRInstr(op="CONST_I64", dst=c0_set, arg1=0, val_type="i64"))
            instrs.append(MIRInstr(op="CALL", dst=ign_set, arg1="__bmb_rt_slot_set", extra=[c0_set, exc_v], val_type="i64"))
            if self.try_stack:
                instrs.append(MIRInstr(op="JMP", arg1=self.try_stack[-1].catch_target))
            else:
                self.cur_fn_needs_unwind_pad = True
                instrs.append(MIRInstr(op="JMP", arg1=self.cur_fn_unwind_label))
            return

        if isinstance(stmt, TryStmt):
            dispatch_lbl = self.new_label("try_catch")
            else_lbl = self.new_label("try_else")
            fin_ok_lbl = self.new_label("try_fin_ok")
            fin_unw_lbl = self.new_label("try_fin_unw")
            end_lbl = self.new_label("try_end")
            cur_loop_depth = len(self.loop_stack)

            # 1. `try:` body
            catch_entry = dispatch_lbl if stmt.handlers else fin_unw_lbl
            self.try_stack.append(_TryContext(catch_target=catch_entry, finally_body=stmt.finally_body, loop_depth=cur_loop_depth))
            self._lower_block(stmt.body, instrs, local_types)
            self.try_stack.pop()
            instrs.append(MIRInstr(op="JMP", arg1=else_lbl))

            # 2. `else:` body (runs iff `try:` did not raise; protected only by `finally:`)
            instrs.append(MIRInstr(op="LABEL", arg1=else_lbl))
            if stmt.else_body:
                if stmt.finally_body:
                    self.try_stack.append(_TryContext(catch_target=fin_unw_lbl, finally_body=stmt.finally_body, loop_depth=cur_loop_depth))
                self._lower_block(stmt.else_body, instrs, local_types)
                if stmt.finally_body:
                    self.try_stack.pop()
            instrs.append(MIRInstr(op="JMP", arg1=fin_ok_lbl))

            # 3. `except:` handler chain
            if stmt.handlers:
                instrs.append(MIRInstr(op="LABEL", arg1=dispatch_lbl))
                c0_e = self.new_temp(local_types, "i64")
                exc_ptr = self.new_temp(local_types, "BaseException")
                exc_mask = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CONST_I64", dst=c0_e, arg1=0, val_type="i64"))
                instrs.append(MIRInstr(op="CALL", dst=exc_ptr, arg1="__bmb_rt_slot_get", extra=[c0_e], val_type="BaseException"))
                instrs.append(MIRInstr(op="LOAD_IDX", dst=exc_mask, arg1=exc_ptr, arg2=c0_e, val_type="i64"))

                if stmt.finally_body:
                    self.try_stack.append(_TryContext(catch_target=fin_unw_lbl, finally_body=stmt.finally_body, loop_depth=cur_loop_depth))

                for h_idx, h in enumerate(stmt.handlers):
                    next_h_lbl = self.new_label(f"except_next_{h_idx}")
                    if h.exc_types:
                        h_mask_val = 0
                        for et_name in h.exc_types:
                            if et_name in self.class_ids:
                                h_mask_val |= 1 << self.class_ids[et_name]
                        m_const = self.new_temp(local_types, "i64")
                        anded = self.new_temp(local_types, "i64")
                        instrs.append(MIRInstr(op="CONST_I64", dst=m_const, arg1=h_mask_val, val_type="i64"))
                        instrs.append(MIRInstr(op="AND_I64", dst=anded, arg1=exc_mask, arg2=m_const, val_type="i64"))
                        instrs.append(MIRInstr(op="JZ", arg1=anded, arg2=next_h_lbl))

                    # Handler matched! Clear active unwinding slot and save caught exception for bare `raise`
                    ign_clr = self.new_temp(local_types, "i64")
                    caught_hold = self.new_temp(local_types, "BaseException")
                    instrs.append(MIRInstr(op="CALL", dst=ign_clr, arg1="__bmb_rt_slot_set", extra=[c0_e, c0_e], val_type="i64"))
                    instrs.append(MIRInstr(op="MOV", dst=caught_hold, arg1=exc_ptr, val_type="BaseException"))
                    if h.var_name:
                        v_t = h.exc_types[0] if len(h.exc_types) == 1 and h.exc_types[0] in self.structs else "Exception"
                        local_types[h.var_name] = v_t
                        instrs.append(MIRInstr(op="MOV", dst=h.var_name, arg1=exc_ptr, val_type=v_t))

                    self.active_caught_exc_vars.append(caught_hold)
                    self._lower_block(h.body, instrs, local_types)
                    self.active_caught_exc_vars.pop()
                    instrs.append(MIRInstr(op="JMP", arg1=fin_ok_lbl))
                    instrs.append(MIRInstr(op="LABEL", arg1=next_h_lbl))

                if stmt.finally_body:
                    self.try_stack.pop()

                # Unmatched by all `except:` clauses -> run `finally:` on unwind path
                instrs.append(MIRInstr(op="JMP", arg1=fin_unw_lbl))

            # 4. Normal `finally:` path
            instrs.append(MIRInstr(op="LABEL", arg1=fin_ok_lbl))
            if stmt.finally_body:
                self._lower_block(stmt.finally_body, instrs, local_types)
            instrs.append(MIRInstr(op="JMP", arg1=end_lbl))

            # 5. Unwinding `finally:` path (saves & temporarily clears rt_slot[0] so calls inside `finally` don't false-unwind!)
            instrs.append(MIRInstr(op="LABEL", arg1=fin_unw_lbl))
            if stmt.finally_body:
                c0_u = self.new_temp(local_types, "i64")
                saved_u = self.new_temp(local_types, "i64")
                ign_u1 = self.new_temp(local_types, "i64")
                ign_u2 = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CONST_I64", dst=c0_u, arg1=0, val_type="i64"))
                instrs.append(MIRInstr(op="CALL", dst=saved_u, arg1="__bmb_rt_slot_get", extra=[c0_u], val_type="i64"))
                instrs.append(MIRInstr(op="CALL", dst=ign_u1, arg1="__bmb_rt_slot_set", extra=[c0_u, c0_u], val_type="i64"))
                self._lower_block(stmt.finally_body, instrs, local_types)
                instrs.append(MIRInstr(op="CALL", dst=ign_u2, arg1="__bmb_rt_slot_set", extra=[c0_u, saved_u], val_type="i64"))

            if self.try_stack:
                instrs.append(MIRInstr(op="JMP", arg1=self.try_stack[-1].catch_target))
            else:
                self.cur_fn_needs_unwind_pad = True
                instrs.append(MIRInstr(op="JMP", arg1=self.cur_fn_unwind_label))

            instrs.append(MIRInstr(op="LABEL", arg1=end_lbl))
            return

        if isinstance(stmt, Break):
            if self.loop_stack:
                cur_depth = len(self.loop_stack)
                min_idx = len(self.try_stack)
                while min_idx > 0 and self.try_stack[min_idx - 1].loop_depth == cur_depth:
                    min_idx -= 1
                if min_idx < len(self.try_stack):
                    self._run_enclosing_finally_for_exit(min_idx, instrs, local_types)
                instrs.append(MIRInstr(op="JMP", arg1=self.loop_stack[-1][1]))
            return

        if isinstance(stmt, Continue):
            if self.loop_stack:
                cur_depth = len(self.loop_stack)
                min_idx = len(self.try_stack)
                while min_idx > 0 and self.try_stack[min_idx - 1].loop_depth == cur_depth:
                    min_idx -= 1
                if min_idx < len(self.try_stack):
                    self._run_enclosing_finally_for_exit(min_idx, instrs, local_types)
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
            def _flatten_match_alts(pat_expr: Expr) -> List[Expr]:
                if isinstance(pat_expr, BinOp) and pat_expr.op == "|":
                    return _flatten_match_alts(pat_expr.left) + _flatten_match_alts(pat_expr.right)
                return [pat_expr]

            subj_v, subj_t = self._lower_expr(stmt.subject, instrs, local_types)
            end_lbl = self.new_label("match_end")
            for idx, case in enumerate(stmt.cases):
                next_case = self.new_label(f"match_case_{idx}")
                if case.pattern is not None:
                    alts = _flatten_match_alts(case.pattern)
                    cmp_op = "STR_CMP_EQ" if subj_t == "str" else ("CMP_EQ_F64" if subj_t == "f64" else "CMP_EQ_I64")
                    if len(alts) == 1:
                        pat_v, _ = self._lower_expr(alts[0], instrs, local_types)
                        cmp_t = self.new_temp(local_types, "bool")
                        instrs.append(MIRInstr(op=cmp_op, dst=cmp_t, arg1=subj_v, arg2=pat_v, val_type="bool"))
                        instrs.append(MIRInstr(op="JZ", arg1=cmp_t, arg2=next_case))
                    else:
                        body_lbl = self.new_label(f"match_body_{idx}")
                        for a_idx, alt in enumerate(alts):
                            pat_v, _ = self._lower_expr(alt, instrs, local_types)
                            cmp_t = self.new_temp(local_types, "bool")
                            instrs.append(MIRInstr(op=cmp_op, dst=cmp_t, arg1=subj_v, arg2=pat_v, val_type="bool"))
                            if a_idx < len(alts) - 1:
                                instrs.append(MIRInstr(op="JNZ", arg1=cmp_t, arg2=body_lbl))
                            else:
                                instrs.append(MIRInstr(op="JZ", arg1=cmp_t, arg2=next_case))
                        instrs.append(MIRInstr(op="LABEL", arg1=body_lbl))
                self._lower_block(case.body, instrs, local_types)
                instrs.append(MIRInstr(op="JMP", arg1=end_lbl))
                instrs.append(MIRInstr(op="LABEL", arg1=next_case))
            instrs.append(MIRInstr(op="LABEL", arg1=end_lbl))
            return

        if isinstance(stmt, ExprStmt):
            self._lower_expr(stmt.expr, instrs, local_types)

    def _coerce_exc_or_scalar_to_str(self, val: str, vtype: str, instrs: List[MIRInstr], local_types: Dict[str, str]) -> str:
        if vtype == "str":
            return val
        if vtype in self.mro and "BaseException" in self.mro[vtype]:
            m_off = self.new_temp(local_types, "i64")
            m_dst = self.new_temp(local_types, "str")
            m_slot = self._class_or_base_offset(vtype, "message")
            instrs.append(MIRInstr(op="CONST_I64", dst=m_off, arg1=m_slot, val_type="i64"))
            instrs.append(MIRInstr(op="LOAD_IDX", dst=m_dst, arg1=val, arg2=m_off, val_type="str"))
            return m_dst
        str_v = self.new_temp(local_types, "str")
        cast_op = "STR_FROM_F64" if vtype == "f64" else ("STR_FROM_BOOL" if vtype == "bool" else "STR_FROM_I64")
        instrs.append(MIRInstr(op=cast_op, dst=str_v, arg1=val, val_type="str"))
        return str_v

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
                cur_v = self._coerce_exc_or_scalar_to_str(cur_v, cur_t, instrs, local_types)
                for p in parts[1:]:
                    nxt_v, nxt_t = self._lower_expr(p, instrs, local_types)
                    nxt_v = self._coerce_exc_or_scalar_to_str(nxt_v, nxt_t, instrs, local_types)
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
            if expr.name == "__name__" and "__name__" not in local_types:
                str_id = self.intern_string("__main__")
                dst = self.new_temp(local_types, "str")
                instrs.append(MIRInstr(op="CONST_STR", dst=dst, arg1=str_id, comment="__main__", val_type="str"))
                return dst, "str"
            if expr.name == "__file__" and "__file__" not in local_types:
                fname = getattr(self, "filename", "<input.bmb>")
                str_id = self.intern_string(fname)
                dst = self.new_temp(local_types, "str")
                instrs.append(MIRInstr(op="CONST_STR", dst=dst, arg1=str_id, comment=fname, val_type="str"))
                return dst, "str"
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
                if op_t == "str":
                    slen = self.new_temp(local_types, "i64")
                    zero = self.new_temp(local_types, "i64")
                    instrs.append(MIRInstr(op="STR_LEN", dst=slen, arg1=op_v, val_type="i64"))
                    instrs.append(MIRInstr(op="CONST_I64", dst=zero, arg1=0, val_type="i64"))
                    instrs.append(MIRInstr(op="CMP_EQ_I64", dst=dst, arg1=slen, arg2=zero, val_type="bool"))
                elif op_t == "f64":
                    zflt = self.new_temp(local_types, "f64")
                    instrs.append(MIRInstr(op="CONST_F64", dst=zflt, arg1=0.0, val_type="f64"))
                    instrs.append(MIRInstr(op="CMP_EQ_F64", dst=dst, arg1=op_v, arg2=zflt, val_type="bool"))
                else:
                    zero = self.new_temp(local_types, "i64")
                    instrs.append(MIRInstr(op="CONST_I64", dst=zero, arg1=0, val_type="i64"))
                    instrs.append(MIRInstr(op="CMP_EQ_I64", dst=dst, arg1=op_v, arg2=zero, val_type="bool"))
                return dst, "bool"
            return op_v, op_t

        if isinstance(expr, BinOp):
            # Genuine short-circuit logical `and` / `or`
            if expr.op == "and":
                dst = self.new_temp(local_types, "bool")
                false_lbl = self.new_label("and_false")
                end_lbl = self.new_label("and_end")
                lv, lt = self._lower_expr(expr.left, instrs, local_types)
                lv_cond = self._coerce_to_cond(lv, lt, instrs, local_types)
                instrs.append(MIRInstr(op="JZ", arg1=lv_cond, arg2=false_lbl))
                rv, rt = self._lower_expr(expr.right, instrs, local_types)
                rv_cond = self._coerce_to_cond(rv, rt, instrs, local_types)
                instrs.append(MIRInstr(op="JZ", arg1=rv_cond, arg2=false_lbl))
                instrs.append(MIRInstr(op="CONST_I64", dst=dst, arg1=1, val_type="bool"))
                instrs.append(MIRInstr(op="JMP", arg1=end_lbl))
                instrs.append(MIRInstr(op="LABEL", arg1=false_lbl))
                instrs.append(MIRInstr(op="CONST_I64", dst=dst, arg1=0, val_type="bool"))
                instrs.append(MIRInstr(op="LABEL", arg1=end_lbl))
                return dst, "bool"

            if expr.op == "or":
                dst = self.new_temp(local_types, "bool")
                true_lbl = self.new_label("or_true")
                end_lbl = self.new_label("or_end")
                lv, lt = self._lower_expr(expr.left, instrs, local_types)
                lv_cond = self._coerce_to_cond(lv, lt, instrs, local_types)
                instrs.append(MIRInstr(op="JNZ", arg1=lv_cond, arg2=true_lbl))
                rv, rt = self._lower_expr(expr.right, instrs, local_types)
                rv_cond = self._coerce_to_cond(rv, rt, instrs, local_types)
                instrs.append(MIRInstr(op="JNZ", arg1=rv_cond, arg2=true_lbl))
                instrs.append(MIRInstr(op="CONST_I64", dst=dst, arg1=0, val_type="bool"))
                instrs.append(MIRInstr(op="JMP", arg1=end_lbl))
                instrs.append(MIRInstr(op="LABEL", arg1=true_lbl))
                instrs.append(MIRInstr(op="CONST_I64", dst=dst, arg1=1, val_type="bool"))
                instrs.append(MIRInstr(op="LABEL", arg1=end_lbl))
                return dst, "bool"

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
            cv, ct = self._lower_expr(expr.cond, instrs, local_types)
            cv_cond = self._coerce_to_cond(cv, ct, instrs, local_types)
            instrs.append(MIRInstr(op="JZ", arg1=cv_cond, arg2=else_lbl))
            tv, tt = self._lower_expr(expr.then_expr, instrs, local_types)
            instrs.append(MIRInstr(op="MOV", dst=dst, arg1=tv, val_type=tt))
            instrs.append(MIRInstr(op="JMP", arg1=end_lbl))
            instrs.append(MIRInstr(op="LABEL", arg1=else_lbl))
            ev, et = self._lower_expr(expr.else_expr, instrs, local_types)
            final_t = expr.inferred_type or unify_types(tt, et, self.mro)
            local_types[dst] = final_t
            instrs.append(MIRInstr(op="MOV", dst=dst, arg1=ev, val_type=final_t))
            instrs.append(MIRInstr(op="LABEL", arg1=end_lbl))
            return dst, final_t

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
            if field_idx >= 0:
                field_t = self._struct_field_type(obj_t, expr.field_name)
                idx_tmp = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CONST_I64", dst=idx_tmp, arg1=field_idx, val_type="i64"))
                dst = self.new_temp(local_types, field_t)
                instrs.append(MIRInstr(op="LOAD_IDX", dst=dst, arg1=obj_v, arg2=idx_tmp, val_type=field_t))
                return dst, field_t
            if obj_t in self.dynamic_classes:
                dyn_t = self.dyn_attr_types.get((obj_t, expr.field_name), expr.inferred_type or "i64")
                key_id = self.intern_string(expr.field_name)
                key_v = self.new_temp(local_types, "str")
                def_v = self.new_temp(local_types, "i64")
                dst = self.new_temp(local_types, dyn_t)
                instrs.append(MIRInstr(op="CONST_STR", dst=key_v, arg1=key_id, comment=expr.field_name, val_type="str"))
                instrs.append(MIRInstr(op="CONST_I64", dst=def_v, arg1=0, val_type="i64"))
                instrs.append(MIRInstr(op="CALL", dst=dst, arg1="__bmb_dyn_get", extra=[obj_v, key_v, def_v], val_type=dyn_t))
                return dst, dyn_t
            idx_tmp = self.new_temp(local_types, "i64")
            instrs.append(MIRInstr(op="CONST_I64", dst=idx_tmp, arg1=0, val_type="i64"))
            dst = self.new_temp(local_types, "i64")
            instrs.append(MIRInstr(op="LOAD_IDX", dst=dst, arg1=obj_v, arg2=idx_tmp, val_type="i64"))
            return dst, "i64"

        if isinstance(expr, MethodCall):
            obj_v, obj_t = self._lower_expr(expr.target, instrs, local_types)
            m_full = f"{obj_t}__{expr.method}"
            # Dynamic OOP virtual vtable dispatch (supports polymorphism + runtime monkey-patching!)
            if obj_t in self.dynamic_classes and (obj_t, expr.method) in self.vtable_indices:
                v_idx = self.vtable_indices[(obj_t, expr.method)]
                arg_vals = [obj_v]
                for a in expr.args:
                    av, _ = self._lower_expr(a, instrs, local_types)
                    arg_vals.append(av)
                # Fill omitted default parameters if method declared defaults
                decl_params = self.func_params.get(m_full, [])
                for p_idx in range(len(arg_vals), len(decl_params)):
                    def_e = decl_params[p_idx].default or IntLit(value=0)
                    dv, _ = self._lower_expr(def_e, instrs, local_types)
                    arg_vals.append(dv)

                one_idx = self.new_temp(local_types, "i64")
                vt_ptr = self.new_temp(local_types, "i64")
                m_idx_t = self.new_temp(local_types, "i64")
                fn_ptr = self.new_temp(local_types, "i64")
                ret_t = self.func_return_types.get(m_full) or expr.inferred_type or "i64"
                dst = self.new_temp(local_types, ret_t)
                instrs.append(MIRInstr(op="CONST_I64", dst=one_idx, arg1=1, val_type="i64"))
                instrs.append(MIRInstr(op="LOAD_IDX", dst=vt_ptr, arg1=obj_v, arg2=one_idx, val_type="i64"))
                instrs.append(MIRInstr(op="CONST_I64", dst=m_idx_t, arg1=v_idx, val_type="i64"))
                instrs.append(MIRInstr(op="CALL", dst=fn_ptr, arg1="__bmb_mem_read", extra=[vt_ptr, m_idx_t], val_type="i64"))
                instrs.append(MIRInstr(op="CALL", dst=dst, arg1=fn_ptr, extra=arg_vals, val_type=ret_t))
                self._emit_post_call_unwind_check(instrs, local_types)
                return dst, ret_t

            # Plain 0-header struct direct static call (evaluate receiver once!)
            arg_vals = [obj_v]
            for a in expr.args:
                av, _ = self._lower_expr(a, instrs, local_types)
                arg_vals.append(av)
            decl_params = self.func_params.get(m_full, [])
            for p_idx in range(len(arg_vals), len(decl_params)):
                def_e = decl_params[p_idx].default or IntLit(value=0)
                dv, _ = self._lower_expr(def_e, instrs, local_types)
                arg_vals.append(dv)
            ret_t = self.func_return_types.get(m_full) or expr.inferred_type or "i64"
            dst = self.new_temp(local_types, ret_t)
            instrs.append(MIRInstr(op="CALL", dst=dst, arg1=m_full, extra=arg_vals, val_type=ret_t))
            self._emit_post_call_unwind_check(instrs, local_types)
            return dst, ret_t

        if isinstance(expr, Call):
            if expr.func == "print":
                arg_vals: List[str] = []
                arg_types: List[str] = []
                for a in expr.args:
                    if isinstance(a, StringLit) and a.value.startswith("f:"):
                        parts = self._split_fstring(a.value[2:], a.line, a.col)
                        for p in parts:
                            pv, pt = self._lower_expr(p, instrs, local_types)
                            if pt in self.mro and "BaseException" in self.mro[pt]:
                                pv = self._coerce_exc_or_scalar_to_str(pv, pt, instrs, local_types)
                                pt = "str"
                            arg_vals.append(pv)
                            arg_types.append(pt)
                    else:
                        av, at = self._lower_expr(a, instrs, local_types)
                        if at in self.mro and "BaseException" in self.mro[at]:
                            av = self._coerce_exc_or_scalar_to_str(av, at, instrs, local_types)
                            at = "str"
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

            # Dynamic OOP Reflection & Monkey-Patching Intrinsics: isinstance, setattr, getattr, hasattr
            if expr.func == "isinstance" and len(expr.args) == 2:
                obj_v, obj_t = self._lower_expr(expr.args[0], instrs, local_types)
                target_names: List[str] = []
                if isinstance(expr.args[1], Var):
                    target_names.append(expr.args[1].name)
                elif isinstance(expr.args[1], ArrayLit):
                    for el in expr.args[1].elements:
                        if isinstance(el, Var):
                            target_names.append(el.name)
                if obj_t in self.dynamic_classes:
                    mask_val = 0
                    for tn in target_names:
                        if tn in self.class_ids:
                            mask_val |= 1 << self.class_ids[tn]
                    c0_i = self.new_temp(local_types, "i64")
                    obj_mask = self.new_temp(local_types, "i64")
                    t_mask = self.new_temp(local_types, "i64")
                    anded = self.new_temp(local_types, "i64")
                    dst = self.new_temp(local_types, "bool")
                    instrs.append(MIRInstr(op="CONST_I64", dst=c0_i, arg1=0, val_type="i64"))
                    instrs.append(MIRInstr(op="LOAD_IDX", dst=obj_mask, arg1=obj_v, arg2=c0_i, val_type="i64"))
                    instrs.append(MIRInstr(op="CONST_I64", dst=t_mask, arg1=mask_val, val_type="i64"))
                    instrs.append(MIRInstr(op="AND_I64", dst=anded, arg1=obj_mask, arg2=t_mask, val_type="i64"))
                    instrs.append(MIRInstr(op="CMP_NE_I64", dst=dst, arg1=anded, arg2=c0_i, val_type="bool"))
                    return dst, "bool"
                is_static_match = 1 if obj_t in target_names else 0
                dst = self.new_temp(local_types, "bool")
                instrs.append(MIRInstr(op="CONST_I64", dst=dst, arg1=is_static_match, val_type="bool"))
                return dst, "bool"

            if expr.func == "setattr" and len(expr.args) == 3:
                # 1. Class-level runtime method monkey-patching: `setattr(MyClass, "method", new_fn)`
                if (
                    isinstance(expr.args[0], Var)
                    and expr.args[0].name in self.dynamic_classes
                    and expr.args[0].name not in local_types
                    and isinstance(expr.args[1], StringLit)
                ):
                    cls_name = expr.args[0].name
                    m_name = expr.args[1].value
                    fn_v, _ = self._lower_expr(expr.args[2], instrs, local_types)
                    if (cls_name, m_name) in self.vtable_indices:
                        v_idx = self.vtable_indices[(cls_name, m_name)]
                        dir_ptr = self.new_temp(local_types, "i64")
                        instrs.append(MIRInstr(op="CALL", dst=dir_ptr, arg1="__bmb_ensure_vtables", extra=[], val_type="i64"))
                        orig_owner = self.vtable_method_owners.get((cls_name, m_name), cls_name)
                        for sub_c in self.dynamic_classes:
                            if cls_name in self.mro.get(sub_c, []):
                                sub_owner = self.vtable_method_owners.get((sub_c, m_name))
                                if sub_c == cls_name or sub_owner in (None, cls_name, orig_owner):
                                    cid_t = self.new_temp(local_types, "i64")
                                    vt_p = self.new_temp(local_types, "i64")
                                    vidx_t = self.new_temp(local_types, "i64")
                                    ign_w = self.new_temp(local_types, "i64")
                                    instrs.append(MIRInstr(op="CONST_I64", dst=cid_t, arg1=self.class_ids[sub_c], val_type="i64"))
                                    instrs.append(MIRInstr(op="CALL", dst=vt_p, arg1="__bmb_mem_read", extra=[dir_ptr, cid_t], val_type="i64"))
                                    instrs.append(MIRInstr(op="CONST_I64", dst=vidx_t, arg1=v_idx, val_type="i64"))
                                    instrs.append(MIRInstr(op="CALL", dst=ign_w, arg1="__bmb_mem_write", extra=[vt_p, vidx_t, fn_v], val_type="i64"))
                    return fn_v, "i64"

                # 2. Instance-level attribute mutation: `setattr(obj, attr_name, val)`
                obj_v, obj_t = self._lower_expr(expr.args[0], instrs, local_types)
                key_v, _ = self._lower_expr(expr.args[1], instrs, local_types)
                val_v, val_t = self._lower_expr(expr.args[2], instrs, local_types)
                if isinstance(expr.args[1], StringLit):
                    f_idx = self._struct_field_index(obj_t, expr.args[1].value)
                    if f_idx >= 0:
                        idx_t = self.new_temp(local_types, "i64")
                        instrs.append(MIRInstr(op="CONST_I64", dst=idx_t, arg1=f_idx, val_type="i64"))
                        instrs.append(MIRInstr(op="STORE_IDX", dst=obj_v, arg1=idx_t, arg2=val_v, val_type=val_t))
                        return val_v, "i64"
                elif obj_t in self.structs:
                    end_s_lbl = self.new_label("setattr_end")
                    for sf in self.structs[obj_t].fields:
                        nxt_sf = self.new_label("setattr_nxt")
                        sf_id = self.intern_string(sf.name)
                        sf_k = self.new_temp(local_types, "str")
                        sf_eq = self.new_temp(local_types, "bool")
                        sf_idx_t = self.new_temp(local_types, "i64")
                        instrs.append(MIRInstr(op="CONST_STR", dst=sf_k, arg1=sf_id, val_type="str"))
                        instrs.append(MIRInstr(op="STR_CMP_EQ", dst=sf_eq, arg1=key_v, arg2=sf_k, val_type="bool"))
                        instrs.append(MIRInstr(op="JZ", arg1=sf_eq, arg2=nxt_sf))
                        instrs.append(MIRInstr(op="CONST_I64", dst=sf_idx_t, arg1=self._struct_field_index(obj_t, sf.name), val_type="i64"))
                        instrs.append(MIRInstr(op="STORE_IDX", dst=obj_v, arg1=sf_idx_t, arg2=val_v, val_type=val_t))
                        instrs.append(MIRInstr(op="JMP", arg1=end_s_lbl))
                        instrs.append(MIRInstr(op="LABEL", arg1=nxt_sf))
                    if obj_t in self.dynamic_classes:
                        ign_d = self.new_temp(local_types, "i64")
                        instrs.append(MIRInstr(op="CALL", dst=ign_d, arg1="__bmb_dyn_set", extra=[obj_v, key_v, val_v], val_type="i64"))
                    instrs.append(MIRInstr(op="LABEL", arg1=end_s_lbl))
                    return val_v, "i64"

                dst = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CALL", dst=dst, arg1="__bmb_dyn_set", extra=[obj_v, key_v, val_v], val_type="i64"))
                return dst, "i64"

            if expr.func == "getattr" and len(expr.args) in (2, 3):
                obj_v, obj_t = self._lower_expr(expr.args[0], instrs, local_types)
                key_v, _ = self._lower_expr(expr.args[1], instrs, local_types)
                if len(expr.args) == 3:
                    def_v, def_t = self._lower_expr(expr.args[2], instrs, local_types)
                else:
                    def_t = expr.inferred_type or "i64"
                    def_v = self.new_temp(local_types, "i64")
                    instrs.append(MIRInstr(op="CONST_I64", dst=def_v, arg1=0, val_type="i64"))
                res_t = expr.inferred_type or def_t or "i64"
                if isinstance(expr.args[1], StringLit):
                    f_idx = self._struct_field_index(obj_t, expr.args[1].value)
                    if f_idx >= 0:
                        ft = self._struct_field_type(obj_t, expr.args[1].value)
                        idx_t = self.new_temp(local_types, "i64")
                        dst = self.new_temp(local_types, ft)
                        instrs.append(MIRInstr(op="CONST_I64", dst=idx_t, arg1=f_idx, val_type="i64"))
                        instrs.append(MIRInstr(op="LOAD_IDX", dst=dst, arg1=obj_v, arg2=idx_t, val_type=ft))
                        return dst, ft
                elif obj_t in self.structs:
                    dst = self.new_temp(local_types, res_t)
                    end_g_lbl = self.new_label("getattr_end")
                    for sf in self.structs[obj_t].fields:
                        nxt_gf = self.new_label("getattr_nxt")
                        sf_id = self.intern_string(sf.name)
                        sf_k = self.new_temp(local_types, "str")
                        sf_eq = self.new_temp(local_types, "bool")
                        sf_idx_t = self.new_temp(local_types, "i64")
                        sf_val = self.new_temp(local_types, res_t)
                        instrs.append(MIRInstr(op="CONST_STR", dst=sf_k, arg1=sf_id, val_type="str"))
                        instrs.append(MIRInstr(op="STR_CMP_EQ", dst=sf_eq, arg1=key_v, arg2=sf_k, val_type="bool"))
                        instrs.append(MIRInstr(op="JZ", arg1=sf_eq, arg2=nxt_gf))
                        instrs.append(MIRInstr(op="CONST_I64", dst=sf_idx_t, arg1=self._struct_field_index(obj_t, sf.name), val_type="i64"))
                        instrs.append(MIRInstr(op="LOAD_IDX", dst=sf_val, arg1=obj_v, arg2=sf_idx_t, val_type=res_t))
                        instrs.append(MIRInstr(op="MOV", dst=dst, arg1=sf_val, val_type=res_t))
                        instrs.append(MIRInstr(op="JMP", arg1=end_g_lbl))
                        instrs.append(MIRInstr(op="LABEL", arg1=nxt_gf))
                    if obj_t in self.dynamic_classes:
                        dyn_g = self.new_temp(local_types, res_t)
                        instrs.append(MIRInstr(op="CALL", dst=dyn_g, arg1="__bmb_dyn_get", extra=[obj_v, key_v, def_v], val_type=res_t))
                        instrs.append(MIRInstr(op="MOV", dst=dst, arg1=dyn_g, val_type=res_t))
                    else:
                        instrs.append(MIRInstr(op="MOV", dst=dst, arg1=def_v, val_type=res_t))
                    instrs.append(MIRInstr(op="LABEL", arg1=end_g_lbl))
                    return dst, res_t

                dst = self.new_temp(local_types, res_t)
                instrs.append(MIRInstr(op="CALL", dst=dst, arg1="__bmb_dyn_get", extra=[obj_v, key_v, def_v], val_type=res_t))
                return dst, res_t

            if expr.func == "hasattr" and len(expr.args) == 2:
                obj_v, obj_t = self._lower_expr(expr.args[0], instrs, local_types)
                key_v, _ = self._lower_expr(expr.args[1], instrs, local_types)
                if isinstance(expr.args[1], StringLit):
                    attr_s = expr.args[1].value
                    if self._struct_field_index(obj_t, attr_s) >= 0 or (obj_t, attr_s) in self.vtable_indices:
                        dst = self.new_temp(local_types, "bool")
                        instrs.append(MIRInstr(op="CONST_I64", dst=dst, arg1=1, val_type="bool"))
                        return dst, "bool"
                if obj_t in self.dynamic_classes:
                    dst = self.new_temp(local_types, "bool")
                    instrs.append(MIRInstr(op="CALL", dst=dst, arg1="__bmb_dyn_has", extra=[obj_v, key_v], val_type="bool"))
                    return dst, "bool"
                dst = self.new_temp(local_types, "bool")
                instrs.append(MIRInstr(op="CONST_I64", dst=dst, arg1=0, val_type="bool"))
                return dst, "bool"

            # Struct / Class constructor call `Vec2(x, y)` or `Dog("Rex")`
            if expr.func in self.structs:
                sdef = self.structs[expr.func]
                dst = self.new_temp(local_types, expr.func)
                if expr.func in self.dynamic_classes:
                    total_slots = self.class_alloc_slots.get(expr.func, 3 + len(sdef.fields))
                    cnt_tmp = self.new_temp(local_types, "i64")
                    zero_tmp = self.new_temp(local_types, "i64")
                    instrs.append(MIRInstr(op="CONST_I64", dst=cnt_tmp, arg1=max(3, total_slots), val_type="i64"))
                    instrs.append(MIRInstr(op="CONST_I64", dst=zero_tmp, arg1=0, val_type="i64"))
                    instrs.append(MIRInstr(op="ALLOC_ARR", dst=dst, arg1=cnt_tmp, arg2=zero_tmp, val_type=expr.func))

                    # Initialize header: [0] = __type_mask__, [1] = __vtable_ptr__, [2] = __dyn_props__ (0)
                    dir_ptr = self.new_temp(local_types, "i64")
                    cid_t = self.new_temp(local_types, "i64")
                    vt_ptr = self.new_temp(local_types, "i64")
                    mask_t = self.new_temp(local_types, "i64")
                    one_t = self.new_temp(local_types, "i64")
                    instrs.append(MIRInstr(op="CALL", dst=dir_ptr, arg1="__bmb_ensure_vtables", extra=[], val_type="i64"))
                    instrs.append(MIRInstr(op="CONST_I64", dst=cid_t, arg1=self.class_ids[expr.func], val_type="i64"))
                    instrs.append(MIRInstr(op="CALL", dst=vt_ptr, arg1="__bmb_mem_read", extra=[dir_ptr, cid_t], val_type="i64"))
                    instrs.append(MIRInstr(op="CONST_I64", dst=mask_t, arg1=self.mro_masks[expr.func], val_type="i64"))
                    instrs.append(MIRInstr(op="STORE_IDX", dst=dst, arg1=zero_tmp, arg2=mask_t, val_type="i64"))
                    instrs.append(MIRInstr(op="CONST_I64", dst=one_t, arg1=1, val_type="i64"))
                    instrs.append(MIRInstr(op="STORE_IDX", dst=dst, arg1=one_t, arg2=vt_ptr, val_type="i64"))

                    init_fn_name = f"{expr.func}____init__"
                    if init_fn_name in self.func_return_types:
                        # Initialize fields to defaults first, then invoke `Cls____init__(dst, *args)`
                        for f in sdef.fields:
                            def_e = f.default if f.default is not None else self._default_expr_for_type(f.type_ann)
                            av, at = self._lower_expr(def_e, instrs, local_types)
                            f_slot = self.class_field_offsets[(expr.func, f.name)]
                            idx_tmp = self.new_temp(local_types, "i64")
                            instrs.append(MIRInstr(op="CONST_I64", dst=idx_tmp, arg1=f_slot, val_type="i64"))
                            instrs.append(MIRInstr(op="STORE_IDX", dst=dst, arg1=idx_tmp, arg2=av, val_type=at))
                        init_args = [dst]
                        for a in expr.args:
                            av, _ = self._lower_expr(a, instrs, local_types)
                            init_args.append(av)
                        decl_p = self.func_params.get(init_fn_name, [])
                        for p_idx in range(len(init_args), len(decl_p)):
                            def_p = decl_p[p_idx].default or self._default_expr_for_type(decl_p[p_idx].type_ann or "i64")
                            dv, _ = self._lower_expr(def_p, instrs, local_types)
                            init_args.append(dv)
                        ign_init = self.new_temp(local_types, "i64")
                        instrs.append(MIRInstr(op="CALL", dst=ign_init, arg1=init_fn_name, extra=init_args, val_type="i64"))
                        self._emit_post_call_unwind_check(instrs, local_types)
                    else:
                        for idx, f in enumerate(sdef.fields):
                            arg_e = (
                                expr.args[idx]
                                if idx < len(expr.args)
                                else (f.default if f.default is not None else self._default_expr_for_type(f.type_ann))
                            )
                            av, at = self._lower_expr(arg_e, instrs, local_types)
                            f_slot = self.class_field_offsets[(expr.func, f.name)]
                            idx_tmp = self.new_temp(local_types, "i64")
                            instrs.append(MIRInstr(op="CONST_I64", dst=idx_tmp, arg1=f_slot, val_type="i64"))
                            instrs.append(MIRInstr(op="STORE_IDX", dst=dst, arg1=idx_tmp, arg2=av, val_type=at))
                    return dst, expr.func

                # Plain 0-header struct allocation (0..K-1)
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
                    instrs.append(MIRInstr(op="I64_TO_F64", dst=dst, arg1=av, val_type="f64"))
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
                return self._coerce_exc_or_scalar_to_str(av, at, instrs, local_types), "str"

            if expr.func == "bool" and len(expr.args) == 1 and "bool" not in self.func_return_types:
                av, at = self._lower_expr(expr.args[0], instrs, local_types)
                cond_v = self._coerce_to_cond(av, at, instrs, local_types)
                dst = self.new_temp(local_types, "bool")
                zero = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CONST_I64", dst=zero, arg1=0, val_type="i64"))
                instrs.append(MIRInstr(op="CMP_NE_I64", dst=dst, arg1=cond_v, arg2=zero, val_type="bool"))
                return dst, "bool"

            if expr.func == "exit" and len(expr.args) <= 1 and "exit" not in self.func_return_types:
                if expr.args:
                    code_v, _ = self._lower_expr(expr.args[0], instrs, local_types)
                else:
                    code_v = self.new_temp(local_types, "i64")
                    instrs.append(MIRInstr(op="CONST_I64", dst=code_v, arg1=0, val_type="i64"))
                dst = self.new_temp(local_types, "i64")
                instrs.append(MIRInstr(op="CALL", dst=dst, arg1="__bmb_exit", extra=[code_v], val_type="i64"))
                return dst, "i64"

            if expr.func in ("min", "max") and len(expr.args) == 2 and expr.func not in self.func_return_types:
                lv, lt = self._lower_expr(expr.args[0], instrs, local_types)
                rv, rt = self._lower_expr(expr.args[1], instrs, local_types)
                is_flt = (lt == "f64" or rt == "f64")
                if is_flt:
                    if lt != "f64":
                        cl = self.new_temp(local_types, "f64")
                        instrs.append(MIRInstr(op="I64_TO_F64", dst=cl, arg1=lv, val_type="f64"))
                        lv = cl
                    if rt != "f64":
                        cr = self.new_temp(local_types, "f64")
                        instrs.append(MIRInstr(op="I64_TO_F64", dst=cr, arg1=rv, val_type="f64"))
                        rv = cr
                    res_t = "f64"
                    cmp_op = "CMP_LT_F64" if expr.func == "min" else "CMP_GT_F64"
                else:
                    res_t = "i64"
                    cmp_op = "CMP_LT_I64" if expr.func == "min" else "CMP_GT_I64"
                dst = self.new_temp(local_types, res_t)
                cmp_v = self.new_temp(local_types, "bool")
                else_lbl = self.new_label(f"{expr.func}_else")
                end_lbl = self.new_label(f"{expr.func}_end")
                instrs.append(MIRInstr(op=cmp_op, dst=cmp_v, arg1=lv, arg2=rv, val_type="bool"))
                instrs.append(MIRInstr(op="JZ", arg1=cmp_v, arg2=else_lbl))
                instrs.append(MIRInstr(op="MOV", dst=dst, arg1=lv, val_type=res_t))
                instrs.append(MIRInstr(op="JMP", arg1=end_lbl))
                instrs.append(MIRInstr(op="LABEL", arg1=else_lbl))
                instrs.append(MIRInstr(op="MOV", dst=dst, arg1=rv, val_type=res_t))
                instrs.append(MIRInstr(op="LABEL", arg1=end_lbl))
                return dst, res_t

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
            decl_params = self.func_params.get(expr.func, [])
            for p_idx in range(len(arg_vals), len(decl_params)):
                def_e = decl_params[p_idx].default or self._default_expr_for_type(decl_params[p_idx].type_ann or "i64")
                dv, _ = self._lower_expr(def_e, instrs, local_types)
                arg_vals.append(dv)

            ret_t = self.func_return_types.get(expr.func) or expr.inferred_type or "i64"
            dst = self.new_temp(local_types, ret_t)
            if (
                expr.super_target is not None
                and expr.super_target[0] in self.dynamic_classes
                and expr.super_target in self.vtable_indices
                and expr.super_target[1] != "__init__"
                and f"{expr.super_target[0]}__{expr.super_target[1]}" in self.func_return_types
            ):
                next_owner, sup_m = expr.super_target
                orig_owner_fn = f"{next_owner}__{sup_m}"
                v_idx = self.vtable_indices[(next_owner, sup_m)]
                dir_ptr = self.new_temp(local_types, "i64")
                cid_t = self.new_temp(local_types, "i64")
                vt_ptr = self.new_temp(local_types, "i64")
                vidx_t = self.new_temp(local_types, "i64")
                cur_fn = self.new_temp(local_types, "i64")
                orig_fn_v = self.new_temp(local_types, "i64")
                is_same = self.new_temp(local_types, "bool")
                patched_lbl = self.new_label("super_patched")
                done_lbl = self.new_label("super_done")
                instrs.append(MIRInstr(op="CALL", dst=dir_ptr, arg1="__bmb_ensure_vtables", extra=[], val_type="i64"))
                instrs.append(MIRInstr(op="CONST_I64", dst=cid_t, arg1=self.class_ids[next_owner], val_type="i64"))
                instrs.append(MIRInstr(op="CALL", dst=vt_ptr, arg1="__bmb_mem_read", extra=[dir_ptr, cid_t], val_type="i64"))
                instrs.append(MIRInstr(op="CONST_I64", dst=vidx_t, arg1=v_idx, val_type="i64"))
                instrs.append(MIRInstr(op="CALL", dst=cur_fn, arg1="__bmb_mem_read", extra=[vt_ptr, vidx_t], val_type="i64"))
                instrs.append(MIRInstr(op="MOV", dst=orig_fn_v, arg1=orig_owner_fn, val_type="i64"))
                instrs.append(MIRInstr(op="CMP_EQ_I64", dst=is_same, arg1=cur_fn, arg2=orig_fn_v, val_type="bool"))
                instrs.append(MIRInstr(op="JZ", arg1=is_same, arg2=patched_lbl))
                instrs.append(MIRInstr(op="CALL", dst=dst, arg1=expr.func, extra=arg_vals, val_type=ret_t))
                instrs.append(MIRInstr(op="JMP", arg1=done_lbl))
                instrs.append(MIRInstr(op="LABEL", arg1=patched_lbl))
                instrs.append(MIRInstr(op="CALL", dst=dst, arg1=cur_fn, extra=arg_vals, val_type=ret_t))
                instrs.append(MIRInstr(op="LABEL", arg1=done_lbl))
                self._emit_post_call_unwind_check(instrs, local_types)
                return dst, ret_t

            instrs.append(MIRInstr(op="CALL", dst=dst, arg1=expr.func, extra=arg_vals, val_type=ret_t))
            if not expr.func.startswith("__bmb_"):
                self._emit_post_call_unwind_check(instrs, local_types)
            return dst, ret_t

        dst = self.new_temp(local_types, "i64")
        instrs.append(MIRInstr(op="CONST_I64", dst=dst, arg1=0, val_type="i64"))
        return dst, "i64"

    def _default_expr_for_type(self, t: str) -> Expr:
        if t == "str":
            return StringLit(value="")
        if t == "f64":
            return FloatLit(value=0.0)
        return IntLit(value=0)

    def _class_or_base_offset(self, cls_name: str, field_name: str) -> int:
        if (cls_name, field_name) in self.class_field_offsets:
            return self.class_field_offsets[(cls_name, field_name)]
        return self.class_field_offsets.get(("BaseException", field_name), 3)

    def _coerce_to_cond(self, val: str, vtype: str, instrs: List[MIRInstr], local_types: Dict[str, str]) -> str:
        """Convert non-integer values (str, f64) into an i64 truthiness flag for JZ/JNZ."""
        if vtype == "str":
            slen = self.new_temp(local_types, "i64")
            instrs.append(MIRInstr(op="STR_LEN", dst=slen, arg1=val, val_type="i64"))
            return slen
        if vtype == "f64":
            zflt = self.new_temp(local_types, "f64")
            cmp_t = self.new_temp(local_types, "bool")
            instrs.append(MIRInstr(op="CONST_F64", dst=zflt, arg1=0.0, val_type="f64"))
            instrs.append(MIRInstr(op="CMP_NE_F64", dst=cmp_t, arg1=val, arg2=zflt, val_type="bool"))
            return cmp_t
        return val

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
        if struct_name in self.dynamic_classes:
            return self.class_field_offsets.get((struct_name, field_name), -1)
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
        automatically captures an arena savepoint at function entry and restores it before normal RET
        (never on exception `unwind_ret`, preserving unwinding `ExcObj` allocations up the call stack!).
        """
        has_alloc = any(ins.op in ("ALLOC_ARR", "STR_CONCAT", "STR_SLICE") for ins in fn.instructions)
        if not has_alloc:
            return

        if fn.return_type not in ("f64", "i64", "bool", "void"):
            return

        param_derived = {p[0] for p in fn.params}
        for _ in range(2):
            for ins in fn.instructions:
                if ins.op == "MOV" and ins.dst and isinstance(ins.arg1, str) and ins.arg1 in param_derived:
                    param_derived.add(ins.dst)
                elif ins.op == "LOAD_IDX" and ins.dst and isinstance(ins.arg1, str) and ins.arg1 in param_derived:
                    param_derived.add(ins.dst)

        for ins in fn.instructions:
            if ins.op == "RET" and ins.val_type not in ("f64", "i64", "bool", "void"):
                return
            if ins.op == "CALL" and ins.arg1 in ("__bmb_alloc_root_set", "__bmb_rt_slot_set"):
                return
            if ins.op == "STORE_IDX" and ins.dst in param_derived:
                return

        save_var = f"%arena_sp_{fn.name}"
        fn.local_types[save_var] = "i64"

        new_instrs: List[MIRInstr] = [
            MIRInstr(op="ARENA_SAVE", dst=save_var, val_type="i64", comment="lexical arena checkpoint", line=fn.start_line)
        ]
        for ins in fn.instructions:
            if ins.op == "RET" and ins.comment != "unwind_ret":
                new_instrs.append(MIRInstr(op="ARENA_RESTORE", arg1=save_var, comment="auto-reclaim lexical arena", line=ins.line))
            new_instrs.append(ins)

        fn.instructions = new_instrs

    def _apply_tail_call_optimization(self, fn: MIRFunction) -> None:
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

        mutated_vars = set()
        seen_defs = set()
        for ins in fn.instructions:
            if ins.dst:
                if ins.dst in seen_defs or not ins.dst.startswith("%"):
                    mutated_vars.add(ins.dst)
                seen_defs.add(ins.dst)

        for ins in fn.instructions:
            if ins.op in ("LABEL", "JMP", "JZ", "JNZ", "CALL"):
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
            if isinstance(ins.arg1, str) and ins.op not in ("LABEL", "JMP"):
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
