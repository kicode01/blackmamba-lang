"""
Black Mamba (.bmb) WebAssembly Binary (.wasm) & Text (.wat) Backend.

Emits standard WebAssembly 1.0 binary modules (`\0asm\x01\0\0\0`) and human-readable
WAT text directly from Mamba IR (MIR), enabling `.bmb` programs to run natively inside
browsers, Node.js V8, Wasmtime, or Cloudflare Workers.
"""

import os
import struct
from typing import Dict, List, Tuple
from ..mir import MIRFunction, MIRInstr, MIRModule


# WebAssembly Value Types
WASM_I32 = 0x7F
WASM_I64 = 0x7E
WASM_F64 = 0x7C
WASM_VOID = 0x40


def _uleb128(value: int) -> bytes:
    out = bytearray()
    while True:
        byte = value & 0x7F
        value >>= 7
        if value != 0:
            byte |= 0x80
        out.append(byte)
        if value == 0:
            break
    return bytes(out)


def _sleb128(value: int) -> bytes:
    out = bytearray()
    more = True
    while more:
        byte = value & 0x7F
        value >>= 7
        if (value == 0 and (byte & 0x40) == 0) or (value == -1 and (byte & 0x40) != 0):
            more = False
        else:
            byte |= 0x80
        out.append(byte)
    return bytes(out)


def _encode_vec(items: List[bytes]) -> bytes:
    return _uleb128(len(items)) + b"".join(items)


def _encode_str(s: str) -> bytes:
    raw = s.encode("utf-8")
    return _uleb128(len(raw)) + raw


def _encode_section(sec_id: int, payload: bytes) -> bytes:
    return bytes([sec_id]) + _uleb128(len(payload)) + payload


class WasmBackend:
    """Compiles a MIRModule to both binary .wasm and textual .wat formats."""

    def __init__(self, mir_module: MIRModule):
        self.mir_module = mir_module
        self.func_indices: Dict[str, int] = {
            fn.name: idx for idx, fn in enumerate(self.mir_module.functions)
        }

    def emit_wat(self) -> str:
        lines = [
            "(module",
            "  ;; Compiled by Black Mamba (.bmb) WebAssembly Backend",
            '  (memory (export "memory") 1)',
        ]
        for fn in self.mir_module.functions:
            params_s = " ".join(
                f"(param ${p_name} {'f64' if p_t == 'f64' else 'i64'})" for p_name, p_t in fn.params
            )
            ret_w = "f64" if fn.return_type == "f64" else "i64"
            lines.append(f'  (func ${fn.name} (export "{fn.name}") {params_s} (result {ret_w})')
            # Collect locals
            param_names = {p[0] for p in fn.params}
            for vname, vtype in fn.local_types.items():
                if vname not in param_names and vname != "%void":
                    wt = "f64" if vtype == "f64" else "i64"
                    clean = vname.replace("%", "t_")
                    lines.append(f"    (local ${clean} {wt})")
            lines.append("    (local $__pc i32)")
            for ins in fn.instructions:
                lines.append(f"    ;; {ins.format().strip()}")
            lines.append(f"    ({'f64.const 0.0' if ret_w == 'f64' else 'i64.const 0'})")
            lines.append("  )")
        lines.append(")")
        return "\n".join(lines)

    def emit_wasm_bytes(self) -> bytes:
        # 1. Type Section (id = 1)
        type_entries: List[bytes] = []
        for fn in self.mir_module.functions:
            p_bytes = bytes(WASM_F64 if pt == "f64" else WASM_I64 for _, pt in fn.params)
            r_byte = WASM_F64 if fn.return_type == "f64" else WASM_I64
            entry = (
                b"\x60"
                + _uleb128(len(p_bytes))
                + p_bytes
                + _uleb128(1)
                + bytes([r_byte])
            )
            type_entries.append(entry)
        sec_type = _encode_section(1, _encode_vec(type_entries))

        # 2. Function Section (id = 3)
        func_type_idxs = [_uleb128(i) for i in range(len(self.mir_module.functions))]
        sec_func = _encode_section(3, _encode_vec(func_type_idxs))

        # 3. Memory Section (id = 5) — 512 pages (32 MiB) linear memory for arrays/structs
        sec_mem = _encode_section(5, _encode_vec([b"\x00" + _uleb128(512)]))

        # 4. Global Section (id = 6) — global $heap_ptr: mut i32 = 1024
        global_entry = bytes([WASM_I32, 0x01, 0x41]) + _sleb128(1024) + b"\x0B"
        sec_global = _encode_section(6, _encode_vec([global_entry]))

        # 5. Export Section (id = 7)
        export_entries: List[bytes] = [
            _encode_str("memory") + bytes([0x02]) + _uleb128(0)
        ]
        for idx, fn in enumerate(self.mir_module.functions):
            export_entries.append(_encode_str(fn.name) + bytes([0x00]) + _uleb128(idx))
        sec_export = _encode_section(7, _encode_vec(export_entries))

        # 6. Code Section (id = 10)
        code_bodies = [self._encode_function_body(fn) for fn in self.mir_module.functions]
        sec_code = _encode_section(10, _encode_vec(code_bodies))

        return (
            b"\x00asm\x01\x00\x00\x00"
            + sec_type
            + sec_func
            + sec_mem
            + sec_global
            + sec_export
            + sec_code
        )

    def write_wasm(self, output_path: str) -> str:
        raw = self.emit_wasm_bytes()
        os.makedirs(os.path.dirname(os.path.abspath(output_path)), exist_ok=True)
        with open(output_path, "wb") as f:
            f.write(raw)
        return os.path.abspath(output_path)

    def _encode_function_body(self, fn: MIRFunction) -> bytes:
        # Map parameters and locals to indices
        local_idx: Dict[str, int] = {}
        local_wasm_type: Dict[str, int] = {}

        for p_name, p_t in fn.params:
            idx = len(local_idx)
            local_idx[p_name] = idx
            local_wasm_type[p_name] = WASM_F64 if p_t == "f64" else WASM_I64

        extra_locals: List[int] = []

        def ensure_local(vname: str, vtype: str = "i64") -> int:
            if vname not in local_idx:
                idx = len(local_idx)
                wt = WASM_F64 if vtype == "f64" else WASM_I64
                local_idx[vname] = idx
                local_wasm_type[vname] = wt
                extra_locals.append(wt)
            return local_idx[vname]

        for vname, vt in fn.local_types.items():
            if vname != "%void":
                ensure_local(vname, vt)

        for ins in fn.instructions:
            if ins.dst and ins.dst != "%void":
                ensure_local(ins.dst, ins.val_type)
            if isinstance(ins.arg1, str) and ins.op not in ("LABEL", "JMP", "CALL"):
                ensure_local(ins.arg1, fn.local_types.get(ins.arg1, "i64"))
            if isinstance(ins.arg2, str) and ins.op not in ("JZ", "JNZ"):
                ensure_local(ins.arg2, fn.local_types.get(ins.arg2, "i64"))
            for ex in ins.extra:
                ensure_local(ex, fn.local_types.get(ex, "i64"))

        # Add internal dispatch `$pc` (i32) and `$tmp_i32` (i32)
        pc_idx = len(local_idx)
        extra_locals.append(WASM_I32)
        tmp_i32_idx = pc_idx + 1
        extra_locals.append(WASM_I32)

        # Split instructions into basic blocks at LABELs and after terminators
        blocks: List[Tuple[str, List[MIRInstr]]] = []
        label_to_bb: Dict[str, int] = {}
        cur_lbl = "__entry"
        cur_ins: List[MIRInstr] = []

        for ins in fn.instructions:
            if ins.op == "LABEL":
                if cur_ins or cur_lbl not in label_to_bb:
                    label_to_bb[cur_lbl] = len(blocks)
                    blocks.append((cur_lbl, cur_ins))
                    cur_ins = []
                cur_lbl = str(ins.arg1)
            else:
                cur_ins.append(ins)
                if ins.op in ("JMP", "JZ", "JNZ", "RET"):
                    if cur_lbl not in label_to_bb:
                        label_to_bb[cur_lbl] = len(blocks)
                    blocks.append((cur_lbl, cur_ins))
                    cur_ins = []
                    cur_lbl = f"__cont_{len(blocks)}"

        if cur_ins or cur_lbl not in label_to_bb:
            if cur_lbl not in label_to_bb:
                label_to_bb[cur_lbl] = len(blocks)
            blocks.append((cur_lbl, cur_ins))

        code = bytearray()
        # Initialize $pc = 0
        code.extend(b"\x41" + _sleb128(0))
        code.extend(b"\x21" + _uleb128(pc_idx))

        # loop $dispatch (blocktype void = 0x40)
        code.extend(b"\x03\x40")

        for bb_idx, (_, bb_instrs) in enumerate(blocks):
            # local.get $pc; i32.const bb_idx; i32.eq; if (void)
            code.extend(b"\x20" + _uleb128(pc_idx))
            code.extend(b"\x41" + _sleb128(bb_idx))
            code.extend(b"\x46")  # i32.eq
            code.extend(b"\x04\x40")  # if void

            terminated = False
            for ins in bb_instrs:
                op = ins.op
                if op == "JMP":
                    target_bb = label_to_bb.get(str(ins.arg1), bb_idx + 1)
                    code.extend(b"\x41" + _sleb128(target_bb))
                    code.extend(b"\x21" + _uleb128(pc_idx))
                    code.extend(b"\x0C" + _uleb128(1))  # br 1 (to loop $dispatch)
                    terminated = True
                    break

                if op in ("JZ", "JNZ"):
                    cond_l = local_idx[str(ins.arg1)]
                    target_bb = label_to_bb.get(str(ins.arg2), bb_idx + 1)
                    fallthrough_bb = bb_idx + 1
                    code.extend(b"\x20" + _uleb128(cond_l))
                    if op == "JZ":
                        code.extend(b"\x50")  # i64.eqz
                    else:
                        code.extend(b"\x42\x00\x52")  # i64.const 0; i64.ne
                    code.extend(b"\x04\x40")  # if (branch taken)
                    code.extend(b"\x41" + _sleb128(target_bb))
                    code.extend(b"\x21" + _uleb128(pc_idx))
                    code.extend(b"\x0C" + _uleb128(2))  # br 2 (to loop $dispatch)
                    code.extend(b"\x0B")  # end if
                    code.extend(b"\x41" + _sleb128(fallthrough_bb))
                    code.extend(b"\x21" + _uleb128(pc_idx))
                    code.extend(b"\x0C" + _uleb128(1))  # br 1 (to loop $dispatch)
                    terminated = True
                    break

                if op == "RET":
                    if ins.arg1 is not None and str(ins.arg1) in local_idx:
                        rl = local_idx[str(ins.arg1)]
                        code.extend(b"\x20" + _uleb128(rl))
                        # Coerce if return local type differs from function return type
                        ret_wt = WASM_F64 if fn.return_type == "f64" else WASM_I64
                        if local_wasm_type[str(ins.arg1)] != ret_wt:
                            code.extend(b"\xB7" if ret_wt == WASM_F64 else b"\xAA")
                    else:
                        if fn.return_type == "f64":
                            code.extend(b"\x44" + struct.pack("<d", 0.0))
                        else:
                            code.extend(b"\x42" + _sleb128(0))
                    code.extend(b"\x0F")  # return
                    terminated = True
                    break

                self._emit_wasm_instr(ins, code, local_idx, local_wasm_type, tmp_i32_idx)

            if not terminated:
                next_bb = bb_idx + 1
                if next_bb < len(blocks):
                    code.extend(b"\x41" + _sleb128(next_bb))
                    code.extend(b"\x21" + _uleb128(pc_idx))
                    code.extend(b"\x0C" + _uleb128(1))  # br 1 (to loop $dispatch)

            code.extend(b"\x0B")  # end if

        code.extend(b"\x0B")  # end loop

        # Default return value at end of function
        if fn.return_type == "f64":
            code.extend(b"\x44" + struct.pack("<d", 0.0))
        else:
            code.extend(b"\x42" + _sleb128(0))
        code.extend(b"\x0B")  # end func

        # Encode locals declarations
        local_decls = [ _uleb128(1) + bytes([wt]) for wt in extra_locals ]
        body = _encode_vec(local_decls) + bytes(code)
        return _uleb128(len(body)) + body

    def _emit_wasm_instr(
        self,
        ins: MIRInstr,
        code: bytearray,
        local_idx: Dict[str, int],
        local_wasm_type: Dict[str, int],
        tmp_i32_idx: int,
    ) -> None:
        op = ins.op
        dst_l = local_idx.get(str(ins.dst), 0) if ins.dst and ins.dst != "%void" else None

        def load_as(vname: str, target_wt: int) -> None:
            l_id = local_idx[vname]
            cur_wt = local_wasm_type[vname]
            code.extend(b"\x20" + _uleb128(l_id))
            if cur_wt != target_wt:
                if target_wt == WASM_F64:
                    code.extend(b"\xB9")  # f64.convert_i64_s
                else:
                    code.extend(b"\xAA")  # i64.trunc_f64_s

        if op == "CONST_I64" and dst_l is not None:
            if local_wasm_type[str(ins.dst)] == WASM_F64:
                code.extend(b"\x44" + struct.pack("<d", float(ins.arg1)))
            else:
                code.extend(b"\x42" + _sleb128(int(ins.arg1)))
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        if op == "CONST_F64" and dst_l is not None:
            if local_wasm_type[str(ins.dst)] == WASM_I64:
                code.extend(b"\x42" + _sleb128(int(float(ins.arg1))))
            else:
                code.extend(b"\x44" + struct.pack("<d", float(ins.arg1)))
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        if op == "CONST_STR" and dst_l is not None:
            code.extend(b"\x42" + _sleb128(int(ins.arg1)))
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        if op == "MOV" and dst_l is not None:
            load_as(str(ins.arg1), local_wasm_type[str(ins.dst)])
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        if op == "I64_TO_F64" and dst_l is not None:
            load_as(str(ins.arg1), WASM_F64)
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        if op == "F64_TO_I64" and dst_l is not None:
            load_as(str(ins.arg1), WASM_I64)
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        if op == "NEG_I64" and dst_l is not None:
            code.extend(b"\x42" + _sleb128(0))
            load_as(str(ins.arg1), WASM_I64)
            code.extend(b"\x7D")  # i64.sub
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        if op == "NEG_F64" and dst_l is not None:
            load_as(str(ins.arg1), WASM_F64)
            code.extend(b"\x9A")  # f64.neg
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        if op == "ABS_F64" and dst_l is not None:
            load_as(str(ins.arg1), WASM_F64)
            code.extend(b"\x99")  # f64.abs
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        if op == "SQRT_F64" and dst_l is not None:
            load_as(str(ins.arg1), WASM_F64)
            code.extend(b"\x9F")  # f64.sqrt
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        # Binary i64 operations
        i64_ops = {
            "ADD_I64": 0x7C,
            "SUB_I64": 0x7D,
            "MUL_I64": 0x7E,
            "DIV_I64": 0x7F,
            "MOD_I64": 0x81,
            "AND_I64": 0x83,
            "OR_I64": 0x84,
            "XOR_I64": 0x85,
            "SHL_I64": 0x86,
            "SHR_I64": 0x87,
        }
        if op in i64_ops and dst_l is not None:
            load_as(str(ins.arg1), WASM_I64)
            load_as(str(ins.arg2), WASM_I64)
            code.append(i64_ops[op])
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        # Binary f64 operations
        f64_ops = {
            "ADD_F64": 0xA0,
            "SUB_F64": 0xA1,
            "MUL_F64": 0xA2,
            "DIV_F64": 0xA3,
        }
        if op in f64_ops and dst_l is not None:
            load_as(str(ins.arg1), WASM_F64)
            load_as(str(ins.arg2), WASM_F64)
            code.append(f64_ops[op])
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        # Comparisons (WASM comparisons push i32 0/1; extend to i64 via i64.extend_i32_u = 0xAD)
        cmp_i64_ops = {
            "CMP_EQ_I64": 0x51,
            "CMP_NE_I64": 0x52,
            "CMP_LT_I64": 0x53,
            "CMP_GT_I64": 0x55,
            "CMP_LE_I64": 0x57,
            "CMP_GE_I64": 0x59,
        }
        if op in cmp_i64_ops and dst_l is not None:
            load_as(str(ins.arg1), WASM_I64)
            load_as(str(ins.arg2), WASM_I64)
            code.append(cmp_i64_ops[op])
            code.append(0xAD)  # i64.extend_i32_u
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        cmp_f64_ops = {
            "CMP_EQ_F64": 0x61,
            "CMP_NE_F64": 0x62,
            "CMP_LT_F64": 0x63,
            "CMP_GT_F64": 0x64,
            "CMP_LE_F64": 0x65,
            "CMP_GE_F64": 0x66,
        }
        if op in cmp_f64_ops and dst_l is not None:
            load_as(str(ins.arg1), WASM_F64)
            load_as(str(ins.arg2), WASM_F64)
            code.append(cmp_f64_ops[op])
            code.append(0xAD)  # i64.extend_i32_u
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        # Linear memory array bump allocation & indexing
        if op == "ARENA_SAVE" and dst_l is not None:
            code.extend(b"\x23\x00")  # global.get 0
            code.append(0xAD)         # i64.extend_i32_u
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        if op == "ARENA_RESTORE":
            load_as(str(ins.arg1), WASM_I64)
            code.append(0xA7)         # i32.wrap_i64
            code.extend(b"\x24\x00")  # global.set 0
            return

        if op in ("PY_CALL_F64", "PY_EVAL_F64") and dst_l is not None:
            code.extend(b"\x44" + struct.pack("<d", 0.0))
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        if op == "ALLOC_ARR" and dst_l is not None:
            # Return current $heap_ptr (global 0) as i64, then advance $heap_ptr += count * 8
            code.extend(b"\x23\x00")  # global.get 0 (i32)
            code.append(0xAD)         # i64.extend_i32_u
            code.extend(b"\x21" + _uleb128(dst_l))

            code.extend(b"\x23\x00")  # global.get 0
            load_as(str(ins.arg1), WASM_I64)
            code.append(0xA7)         # i32.wrap_i64
            code.extend(b"\x41\x08\x6C")  # i32.const 8; i32.mul
            code.append(0x6A)         # i32.add
            code.extend(b"\x24\x00")  # global.set 0
            return

        if op == "LOAD_IDX" and dst_l is not None:
            # addr = i32.wrap_i64(base) + i32.wrap_i64(idx) * 8
            load_as(str(ins.arg1), WASM_I64)
            code.append(0xA7)
            load_as(str(ins.arg2), WASM_I64)
            code.append(0xA7)
            code.extend(b"\x41\x08\x6C\x6A")
            if local_wasm_type[str(ins.dst)] == WASM_F64:
                code.extend(b"\x2B\x03\x00")  # f64.load align=8 offset=0
            else:
                code.extend(b"\x29\x03\x00")  # i64.load align=8 offset=0
            code.extend(b"\x21" + _uleb128(dst_l))
            return

        if op == "STORE_IDX" and ins.dst:
            load_as(str(ins.dst), WASM_I64)
            code.append(0xA7)
            load_as(str(ins.arg1), WASM_I64)
            code.append(0xA7)
            code.extend(b"\x41\x08\x6C\x6A")
            val_wt = local_wasm_type[str(ins.arg2)]
            load_as(str(ins.arg2), val_wt)
            if val_wt == WASM_F64:
                code.extend(b"\x39\x03\x00")  # f64.store align=8 offset=0
            else:
                code.extend(b"\x37\x03\x00")  # i64.store align=8 offset=0
            return

        if op == "CALL":
            callee_name = str(ins.arg1)
            if callee_name in self.func_indices:
                callee_fn = self.mir_module.functions[self.func_indices[callee_name]]
                for arg_v, (_, p_t) in zip(ins.extra, callee_fn.params):
                    load_as(arg_v, WASM_F64 if p_t == "f64" else WASM_I64)
                code.extend(b"\x10" + _uleb128(self.func_indices[callee_name]))
                if dst_l is not None:
                    code.extend(b"\x21" + _uleb128(dst_l))
                else:
                    code.append(0x1A)  # drop
            return
