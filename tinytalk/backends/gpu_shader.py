"""
Black Mamba (.bmb) Native GPU Compute Backend (WebGPU WGSL & Vulkan SPIR-V).

Compiles Black Mamba MIR directly into:
  1. WebGPU Shading Language (.wgsl) compute shaders (`--target webgpu` / `--target wgsl`)
  2. Vulkan SPIR-V v1.5 binary compute modules (.spv) and assembly (.spvasm) (`--target spirv` / `--target spv`)

Requires ZERO external CUDA toolkits, ROCm drivers, or glslangValidator dependencies.
"""

import os
import struct
from typing import Dict, List, Optional, Tuple
from ..mir import MIRFunction, MIRInstr, MIRModule


# Khronos SPIR-V v1.5 Specification Constants
SPIRV_MAGIC = 0x07230203
SPIRV_VERSION_1_5 = 0x00010500
SPIRV_GENERATOR_BMB = 0x00424D42  # "BMB"

# SPIR-V Opcodes
OP_NOP = 0
OP_SOURCE = 3
OP_NAME = 5
OP_DECORATE = 71
OP_MEMBER_DECORATE = 72
OP_CAPABILITY = 17
OP_MEMORY_MODEL = 14
OP_ENTRY_POINT = 15
OP_EXECUTION_MODE = 16
OP_TYPE_VOID = 19
OP_TYPE_BOOL = 20
OP_TYPE_INT = 21
OP_TYPE_FLOAT = 22
OP_TYPE_VECTOR = 23
OP_TYPE_POINTER = 32
OP_TYPE_FUNCTION = 33
OP_CONSTANT = 43
OP_FUNCTION = 54
OP_FUNCTION_PARAMETER = 55
OP_FUNCTION_END = 56
OP_FUNCTION_CALL = 57
OP_VARIABLE = 59
OP_LOAD = 61
OP_STORE = 62
OP_IADD = 128
OP_FADD = 129
OP_ISUB = 130
OP_FSUB = 131
OP_IMUL = 132
OP_FMUL = 133
OP_SDIV = 135
OP_FDIV = 136
OP_SMOD = 139
OP_IEQUAL = 170
OP_INOTEQUAL = 171
OP_SLESS_THAN = 177
OP_SGREATER_THAN = 179
OP_LABEL = 248
OP_BRANCH = 249
OP_RETURN = 253
OP_RETURN_VALUE = 254


def _wgsl_type(bmb_type: str) -> str:
    t = (bmb_type or "i64").strip()
    if t in ("f64", "float", "f32"):
        return "f32"
    if t in ("bool",):
        return "bool"
    if t in ("u32", "u64"):
        return "u32"
    if t in ("void", "None"):
        return "void"
    return "i32"


def _sanitize_wgsl_ident(name: str) -> str:
    clean = name.replace("%", "_t").replace(".", "_").replace("$", "_")
    if clean in ("fn", "var", "let", "const", "struct", "return", "if", "else", "for", "loop", "type", "main"):
        return f"bmb_{clean}"
    return clean


class WebGPUShaderBackend:
    """
    Emits W3C WebGPU Shading Language (WGSL) compute kernels from Black Mamba MIR.
    """

    def __init__(self, mir: MIRModule, workgroup_size: Tuple[int, int, int] = (64, 1, 1)):
        self.mir = mir
        self.workgroup_size = workgroup_size

    def emit_wgsl(self) -> str:
        wg_x, wg_y, wg_z = self.workgroup_size
        lines: List[str] = [
            "// ============================================================================",
            f"// Black Mamba (.bmb) WebGPU Compute Shader (WGSL) — Source: {self.mir.filename}",
            "// Zero-CUDA Native Compute Pipeline | Workgroup Size: "
            f"({wg_x}, {wg_y}, {wg_z})",
            "// ============================================================================",
            "",
            "struct BmbDispatchParams {",
            "    count: u32,",
            "    width: u32,",
            "    height: u32,",
            "    flags: u32,",
            "};",
            "",
        ]

        # Emit user-defined structs
        for s_name, s_def in self.mir.structs.items():
            if s_name.startswith("__"):
                continue
            lines.append(f"struct {_sanitize_wgsl_ident(s_name)} {{")
            if getattr(s_def, "fields", None):
                for fld in s_def.fields:
                    if isinstance(fld, tuple):
                        f_name, f_type = fld[0], fld[1]
                    else:
                        f_name = getattr(fld, "name", "field")
                        f_type = getattr(fld, "type_ann", "i64") or "i64"
                    lines.append(f"    {_sanitize_wgsl_ident(f_name)}: {_wgsl_type(f_type)},")
            else:
                lines.append("    _reserved: i32,")
            lines.append("};")
            lines.append("")

        # Storage buffers for zero-copy tensor / array compute
        lines.extend([
            "@group(0) @binding(0) var<storage, read> bmb_in_a: array<f32>;",
            "@group(0) @binding(1) var<storage, read> bmb_in_b: array<f32>;",
            "@group(0) @binding(2) var<storage, read_write> bmb_out: array<f32>;",
            "@group(0) @binding(3) var<uniform> bmb_params: BmbDispatchParams;",
            "",
        ])

        # Emit helper functions
        kernel_candidates: List[MIRFunction] = []
        for fn in self.mir.functions:
            if fn.name.startswith("__"):
                continue
            lines.extend(self._emit_function(fn))
            lines.append("")
            if fn.name != "main":
                kernel_candidates.append(fn)

        # Emit primary @compute entry point
        lines.extend([
            f"@compute @workgroup_size({wg_x}, {wg_y}, {wg_z})",
            "fn bmb_compute_main(@builtin(global_invocation_id) global_id: vec3<u32>) {",
            "    let idx: u32 = global_id.x;",
            "    if (idx >= bmb_params.count) {",
            "        return;",
            "    }",
            "    let a: f32 = bmb_in_a[idx];",
            "    let b: f32 = bmb_in_b[idx];",
        ])

        # If there is a single-arg or 2-arg numeric function, wire it or emit FMA compute kernel
        called = False
        for fn in kernel_candidates:
            fn_wgsl = _sanitize_wgsl_ident(fn.name)
            ret_t = _wgsl_type(fn.return_type)
            if len(fn.params) == 1 and ret_t in ("i32", "f32"):
                p_t = _wgsl_type(fn.params[0][1])
                arg_expr = "i32(idx)" if p_t == "i32" else "a"
                lines.append(f"    let res = {fn_wgsl}({arg_expr});")
                lines.append("    bmb_out[idx] = f32(res);")
                called = True
                break
            elif len(fn.params) == 2 and ret_t in ("i32", "f32"):
                p0_t = _wgsl_type(fn.params[0][1])
                p1_t = _wgsl_type(fn.params[1][1])
                a0 = "i32(a)" if p0_t == "i32" else "a"
                a1 = "i32(b)" if p1_t == "i32" else "b"
                lines.append(f"    let res = {fn_wgsl}({a0}, {a1});")
                lines.append("    bmb_out[idx] = f32(res);")
                called = True
                break

        if not called:
            lines.append("    bmb_out[idx] = fma(a, b, bmb_out[idx]);")

        lines.append("}")
        return "\n".join(lines) + "\n"

    def _emit_function(self, fn: MIRFunction) -> List[str]:
        fn_name = _sanitize_wgsl_ident(fn.name)
        params_str = ", ".join(
            f"{_sanitize_wgsl_ident(p_name)}: {_wgsl_type(p_type)}"
            for p_name, p_type in fn.params
        )
        ret_t = _wgsl_type(fn.return_type)
        header = (
            f"fn {fn_name}({params_str}) -> {ret_t} {{"
            if ret_t != "void"
            else f"fn {fn_name}({params_str}) {{"
        )
        body: List[str] = [header]

        # Collect local variables (excluding parameters)
        param_names = {_sanitize_wgsl_ident(p[0]) for p in fn.params}
        declared_locals: Dict[str, str] = {}
        for ins in fn.instructions:
            if ins.dst:
                d_name = _sanitize_wgsl_ident(str(ins.dst))
                if d_name not in param_names and d_name not in declared_locals:
                    vt = _wgsl_type(ins.val_type)
                    declared_locals[d_name] = vt if vt != "void" else "i32"

        for loc_name, loc_type in declared_locals.items():
            default_val = "0.0" if loc_type == "f32" else ("false" if loc_type == "bool" else "0")
            body.append(f"    var {loc_name}: {loc_type} = {default_val};")

        def fmt_val(v, expected_type: str = "i32") -> str:
            if v is None:
                return "0.0" if expected_type == "f32" else "0"
            if isinstance(v, bool):
                return "true" if v else "false"
            if isinstance(v, float):
                return f"{v}" if "." in f"{v}" else f"{v}.0"
            if isinstance(v, int):
                return f"{v}.0" if expected_type == "f32" else str(v)
            s = str(v)
            if s in ("True", "true"):
                return "true"
            if s in ("False", "false"):
                return "false"
            try:
                iv = int(s)
                return f"{iv}.0" if expected_type == "f32" else str(iv)
            except ValueError:
                pass
            try:
                fv = float(s)
                return f"{fv}" if expected_type == "f32" else f"i32({fv})"
            except ValueError:
                pass
            return _sanitize_wgsl_ident(s)

        has_return = False
        for ins in fn.instructions:
            op = ins.op
            dst = _sanitize_wgsl_ident(str(ins.dst)) if ins.dst else None
            dst_t = declared_locals.get(dst, _wgsl_type(ins.val_type)) if dst else "i32"

            if (op in ("CONST", "MOV") or op.startswith("CONST_")) and dst:
                val_s = fmt_val(ins.arg1, dst_t)
                body.append(f"    {dst} = {dst_t}({val_s});")
            elif op.startswith(("ADD", "SUB", "MUL", "DIV", "MOD")) and dst:
                base_op = op.split("_")[0]
                op_sym = {"ADD": "+", "SUB": "-", "MUL": "*", "DIV": "/", "MOD": "%"}.get(base_op, "+")
                a1 = fmt_val(ins.arg1, dst_t)
                a2 = fmt_val(ins.arg2, dst_t)
                body.append(f"    {dst} = ({dst_t}({a1}) {op_sym} {dst_t}({a2}));")
            elif (op in ("EQ", "NE", "LT", "LE", "GT", "GE") or op.startswith("CMP_")) and dst:
                cmp_key = op.replace("CMP_", "").split("_")[0]
                op_sym = {"EQ": "==", "NE": "!=", "LT": "<", "LE": "<=", "GT": ">", "GE": ">="}.get(cmp_key, "==")
                a1 = fmt_val(ins.arg1, "i32")
                a2 = fmt_val(ins.arg2, "i32")
                if dst_t == "bool":
                    body.append(f"    {dst} = ({a1} {op_sym} {a2});")
                else:
                    body.append(f"    {dst} = select(0, 1, ({a1} {op_sym} {a2}));")
            elif op == "LOAD_IDX" and dst:
                idx_s = fmt_val(ins.arg2, "u32")
                body.append(f"    {dst} = {dst_t}(bmb_in_a[u32({idx_s})]);")
            elif op == "STORE_IDX":
                idx_s = fmt_val(ins.arg1, "u32")
                val_s = fmt_val(ins.arg2, "f32")
                body.append(f"    bmb_out[u32({idx_s})] = f32({val_s});")
            elif op == "RET":
                has_return = True
                if ret_t != "void":
                    rv = fmt_val(ins.arg1, ret_t) if ins.arg1 is not None else ("0.0" if ret_t == "f32" else "0")
                    body.append(f"    return {ret_t}({rv});")
                else:
                    body.append("    return;")
            elif op == "LABEL":
                body.append(f"    // label: {ins.arg1}")

        if not has_return and ret_t != "void":
            default_ret = "0.0" if ret_t == "f32" else ("false" if ret_t == "bool" else "0")
            body.append(f"    return {default_ret};")

        body.append("}")
        return body

    def write_wgsl(self, output_path: str) -> str:
        os.makedirs(os.path.dirname(os.path.abspath(output_path)), exist_ok=True)
        wgsl_text = self.emit_wgsl()
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(wgsl_text)
        return os.path.abspath(output_path)


class SPIRVShaderBackend:
    """
    Pure zero-dependency Vulkan SPIR-V v1.5 binary (.spv) and assembly (.spvasm) emitter.
    """

    def __init__(self, mir: MIRModule, workgroup_size: Tuple[int, int, int] = (64, 1, 1)):
        self.mir = mir
        self.workgroup_size = workgroup_size
        self._next_id = 1
        self._words: List[int] = []

    def _alloc_id(self) -> int:
        res = self._next_id
        self._next_id += 1
        return res

    @staticmethod
    def _encode_string_words(text: str) -> List[int]:
        raw = text.encode("utf-8") + b"\x00"
        while len(raw) % 4 != 0:
            raw += b"\x00"
        return [struct.unpack("<I", raw[i:i + 4])[0] for i in range(0, len(raw), 4)]

    @staticmethod
    def _inst(opcode: int, operands: List[int]) -> List[int]:
        word_count = 1 + len(operands)
        header = ((word_count & 0xFFFF) << 16) | (opcode & 0xFFFF)
        return [header] + operands

    def emit_spvasm(self) -> str:
        wg_x, wg_y, wg_z = self.workgroup_size
        lines: List[str] = [
            "; SPIR-V",
            "; Version: 1.5",
            "; Generator: Black Mamba Native SPIR-V Emitter (0x00424D42); 1",
            f"; Source: {self.mir.filename}",
            "               OpCapability Shader",
            "               OpMemoryModel Logical GLSL450",
            "               OpEntryPoint GLCompute %bmb_compute_main \"bmb_compute_main\"",
            f"               OpExecutionMode %bmb_compute_main LocalSize {wg_x} {wg_y} {wg_z}",
        ]
        for fn in self.mir.functions:
            if not fn.name.startswith("__"):
                lines.append(f"               OpName %fn_{fn.name} \"{fn.name}\"")

        lines.extend([
            "       %void = OpTypeVoid",
            "       %bool = OpTypeBool",
            "        %i32 = OpTypeInt 32 1",
            "        %u32 = OpTypeInt 32 0",
            "        %f32 = OpTypeFloat 32",
            "     %v3_u32 = OpTypeVector %u32 3",
            "    %fn_void = OpTypeFunction %void",
            "     %fn_i32 = OpTypeFunction %i32 %i32 %i32",
            "     %c_i32_0 = OpConstant %i32 0",
            "     %c_i32_1 = OpConstant %i32 1",
            "",
        ])

        for fn in self.mir.functions:
            if fn.name.startswith("__"):
                continue
            lines.extend([
                f"   %fn_{fn.name} = OpFunction %i32 None %fn_i32",
                f"   %p0_{fn.name} = OpFunctionParameter %i32",
                f"   %p1_{fn.name} = OpFunctionParameter %i32",
                f"%entry_{fn.name} = OpLabel",
            ])
            op_count = 0
            last_ssa = f"%p0_{fn.name}"
            for ins in fn.instructions:
                if ins.op.startswith("ADD"):
                    op_count += 1
                    cur = f"%r{op_count}_{fn.name}"
                    lines.append(f"        {cur} = OpIAdd %i32 {last_ssa} %p1_{fn.name}")
                    last_ssa = cur
                elif ins.op.startswith("SUB"):
                    op_count += 1
                    cur = f"%r{op_count}_{fn.name}"
                    lines.append(f"        {cur} = OpISub %i32 {last_ssa} %p1_{fn.name}")
                    last_ssa = cur
                elif ins.op.startswith("MUL"):
                    op_count += 1
                    cur = f"%r{op_count}_{fn.name}"
                    lines.append(f"        {cur} = OpIMul %i32 {last_ssa} %p1_{fn.name}")
                    last_ssa = cur
            lines.extend([
                f"               OpReturnValue {last_ssa}",
                "               OpFunctionEnd",
                "",
            ])

        lines.extend([
            "%bmb_compute_main = OpFunction %void None %fn_void",
            "     %entry_main = OpLabel",
            "                   OpReturn",
            "                   OpFunctionEnd",
        ])
        return "\n".join(lines) + "\n"

    def emit_spirv_bytes(self) -> bytes:
        self._next_id = 1
        wg_x, wg_y, wg_z = self.workgroup_size

        id_main = self._alloc_id()
        id_void = self._alloc_id()
        id_bool = self._alloc_id()
        id_i32 = self._alloc_id()
        id_u32 = self._alloc_id()
        id_f32 = self._alloc_id()
        id_v3u32 = self._alloc_id()
        id_fn_void = self._alloc_id()
        id_fn_i32 = self._alloc_id()
        id_const_0 = self._alloc_id()
        id_const_1 = self._alloc_id()
        id_main_label = self._alloc_id()

        fn_ids: Dict[str, Tuple[int, int, int, int]] = {}
        for fn in self.mir.functions:
            if not fn.name.startswith("__"):
                fn_ids[fn.name] = (
                    self._alloc_id(),  # fn_id
                    self._alloc_id(),  # param0
                    self._alloc_id(),  # param1
                    self._alloc_id(),  # label
                )

        body_words: List[int] = []

        # 1. OpCapability Shader (1)
        body_words.extend(self._inst(OP_CAPABILITY, [1]))
        # 2. OpMemoryModel Logical (0) GLSL450 (1)
        body_words.extend(self._inst(OP_MEMORY_MODEL, [0, 1]))
        # 3. OpEntryPoint GLCompute (5) %id_main "bmb_compute_main"
        ep_operands = [5, id_main] + self._encode_string_words("bmb_compute_main")
        body_words.extend(self._inst(OP_ENTRY_POINT, ep_operands))
        # 4. OpExecutionMode %id_main LocalSize (17) wg_x wg_y wg_z
        body_words.extend(self._inst(OP_EXECUTION_MODE, [id_main, 17, wg_x, wg_y, wg_z]))

        # 5. Debug OpName annotations
        body_words.extend(self._inst(OP_NAME, [id_main] + self._encode_string_words("bmb_compute_main")))
        for fn_name, (fid, _, _, _) in fn_ids.items():
            body_words.extend(self._inst(OP_NAME, [fid] + self._encode_string_words(fn_name)))

        # 6. Types & Constants
        body_words.extend(self._inst(OP_TYPE_VOID, [id_void]))
        body_words.extend(self._inst(OP_TYPE_BOOL, [id_bool]))
        body_words.extend(self._inst(OP_TYPE_INT, [id_i32, 32, 1]))
        body_words.extend(self._inst(OP_TYPE_INT, [id_u32, 32, 0]))
        body_words.extend(self._inst(OP_TYPE_FLOAT, [id_f32, 32]))
        body_words.extend(self._inst(OP_TYPE_VECTOR, [id_v3u32, id_u32, 3]))
        body_words.extend(self._inst(OP_TYPE_FUNCTION, [id_fn_void, id_void]))
        body_words.extend(self._inst(OP_TYPE_FUNCTION, [id_fn_i32, id_i32, id_i32, id_i32]))
        body_words.extend(self._inst(OP_CONSTANT, [id_i32, id_const_0, 0]))
        body_words.extend(self._inst(OP_CONSTANT, [id_i32, id_const_1, 1]))

        # 7. Emit user functions into SPIR-V bytecode
        for fn in self.mir.functions:
            if fn.name.startswith("__") or fn.name not in fn_ids:
                continue
            fid, p0, p1, lbl = fn_ids[fn.name]
            body_words.extend(self._inst(OP_FUNCTION, [id_i32, fid, 0, id_fn_i32]))
            body_words.extend(self._inst(OP_FUNCTION_PARAMETER, [id_i32, p0]))
            body_words.extend(self._inst(OP_FUNCTION_PARAMETER, [id_i32, p1]))
            body_words.extend(self._inst(OP_LABEL, [lbl]))

            cur_val = p0
            for ins in fn.instructions:
                if ins.op.startswith("ADD"):
                    res_id = self._alloc_id()
                    body_words.extend(self._inst(OP_IADD, [id_i32, res_id, cur_val, p1]))
                    cur_val = res_id
                elif ins.op.startswith("SUB"):
                    res_id = self._alloc_id()
                    body_words.extend(self._inst(OP_ISUB, [id_i32, res_id, cur_val, p1]))
                    cur_val = res_id
                elif ins.op.startswith("MUL"):
                    res_id = self._alloc_id()
                    body_words.extend(self._inst(OP_IMUL, [id_i32, res_id, cur_val, p1]))
                    cur_val = res_id

            body_words.extend(self._inst(OP_RETURN_VALUE, [cur_val]))
            body_words.extend(self._inst(OP_FUNCTION_END, []))

        # 8. Emit entry point function %bmb_compute_main
        body_words.extend(self._inst(OP_FUNCTION, [id_void, id_main, 0, id_fn_void]))
        body_words.extend(self._inst(OP_LABEL, [id_main_label]))
        body_words.extend(self._inst(OP_RETURN, []))
        body_words.extend(self._inst(OP_FUNCTION_END, []))

        # 5-word SPIR-V header: Magic, Version, Generator, Bound, Schema (0)
        header_words = [
            SPIRV_MAGIC,
            SPIRV_VERSION_1_5,
            SPIRV_GENERATOR_BMB,
            self._next_id,
            0,
        ]
        all_words = header_words + body_words
        return struct.pack(f"<{len(all_words)}I", *all_words)

    def write_spirv(self, output_path: str) -> str:
        os.makedirs(os.path.dirname(os.path.abspath(output_path)), exist_ok=True)
        spv_bytes = self.emit_spirv_bytes()
        with open(output_path, "wb") as f:
            f.write(spv_bytes)
        # Also write human-readable .spvasm alongside if requested or by default
        asm_path = os.path.splitext(output_path)[0] + ".spvasm"
        with open(asm_path, "w", encoding="utf-8") as af:
            af.write(self.emit_spvasm())
        return os.path.abspath(output_path)
