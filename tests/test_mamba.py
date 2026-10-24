"""
Black Mamba (.bmb) Comprehensive Compiler & Runtime Test Suite.
"""

import os
import subprocess
import unittest
from mamba.lexer import Lexer, TokenType
from mamba.parser import Parser
from mamba.types import TypeInferencer
from mamba.mir import MIRBuilder
from mamba.backends.x86_64_jit import NativeJITModule
from mamba.backends.pe_exe import PE32PlusExecutableBuilder
from mamba.backends.wasm_emitter import WasmBackend
from mamba.backends.c_emitter import C11Backend, LLVMIRBackend


class TestBlackMamba(unittest.TestCase):

    def test_lexer_indentation_and_operators(self):
        code = """
def test():
    if True:
        x = 5 |> f()
        for i in 1..=10:
            pass
"""
        tokens = Lexer(code).tokenize()
        types = [t.type for t in tokens]
        self.assertIn(TokenType.DEF, types)
        self.assertIn(TokenType.INDENT, types)
        self.assertIn(TokenType.PIPE_GT, types)
        self.assertIn(TokenType.RANGE_INC, types)
        self.assertIn(TokenType.DEDENT, types)

    def test_parser_and_ast(self):
        code = """
struct Vector:
    x: f64
    y: f64

def compute(v: Vector) -> f64:
    return v.x * v.x + v.y * v.y
"""
        mod = Parser.from_source(code).parse_module()
        self.assertEqual(len(mod.statements), 2)

    def test_type_inference_and_specialization(self):
        code = """
def square(x):
    return x * x

def main():
    a = square(10)
    b = square(2.5)
"""
        mod = Parser.from_source(code).parse_module()
        inferred_mod = TypeInferencer(mod).run()
        func_names = [s.name for s in inferred_mod.statements if hasattr(s, "name")]
        self.assertIn("square", func_names)
        self.assertIn("square__f64", func_names)

    def test_mir_optimizer_and_tco(self):
        code = """
def tail_sum(n, acc):
    if n <= 0:
        return acc
    return tail_sum(n - 1, acc + n)
"""
        mod = Parser.from_source(code).parse_module()
        mir = MIRBuilder().build(mod)
        fn = next(f for f in mir.functions if f.name == "tail_sum")
        self.assertTrue(fn.is_tco)
        # Verify a jump to __tco_entry was generated instead of recursive call
        op_list = [ins.op for ins in fn.instructions]
        self.assertIn("JMP", op_list)

    def test_native_x86_64_jit_execution(self):
        code = """
def gcd(a, b):
    while b != 0:
        t = b
        b = a % b
        a = t
    return a

def test_floats(x: f64, y: f64) -> f64:
    return sqrt(x * x + y * y)

def main():
    print(f"gcd(48, 18) = {gcd(48, 18)}")
    print(f"hypot(3, 4) = {test_floats(3.0, 4.0)}")
"""
        mod = Parser.from_source(code).parse_module()
        mir = MIRBuilder().build(mod)
        jit = NativeJITModule(mir)
        jit.run_main()
        out = jit.get_output()
        self.assertIn("gcd(48, 18) = 6", out)
        self.assertIn("hypot(3, 4) = 5.0", out)
        self.assertEqual(jit.call_function("gcd", 48, 18), 6)
        self.assertAlmostEqual(jit.call_function("test_floats", 3.0, 4.0), 5.0, places=4)
        jit.close()

    def test_standalone_pe32_exe_generation(self):
        code = """
def fib(n):
    if n <= 1:
        return n
    return fib(n - 1) + fib(n - 2)

print(f"PE_TEST_FIB_15={fib(15)}")
"""
        mod = Parser.from_source(code).parse_module()
        mir = MIRBuilder().build(mod)
        out_exe = os.path.abspath("build/test_unit.exe")
        PE32PlusExecutableBuilder(mir).write_executable(out_exe)
        self.assertTrue(os.path.exists(out_exe))
        res = subprocess.run([out_exe], capture_output=True, text=True, check=True)
        self.assertIn("PE_TEST_FIB_15=610", res.stdout)

    def test_wasm_backend_and_v8_execution(self):
        code = """
def multiply_add(a: i64, b: i64, c: i64) -> i64:
    return a * b + c

def float_calc(x: f64) -> f64:
    return x * 1.5 + 2.25
"""
        mod = Parser.from_source(code).parse_module()
        mir = MIRBuilder().build(mod)
        wasm_file = os.path.abspath("build/test_unit.wasm")
        WasmBackend(mir).write_wasm(wasm_file)
        self.assertTrue(os.path.exists(wasm_file))

        # Run inside Node.js V8 WebAssembly engine
        js_cmd = (
            f"const fs = require('fs'); "
            f"const buf = fs.readFileSync('{wasm_file.replace(os.sep, '/')}'); "
            f"WebAssembly.instantiate(buf).then(({{instance}}) => {{ "
            f"  const res1 = instance.exports.multiply_add(6n, 7n, 8n); "
            f"  const res2 = instance.exports.float_calc(4.0); "
            f"  console.log(`WASM_RES1=${{res1}} WASM_RES2=${{res2}}`); "
            f"}});"
        )
        res = subprocess.run(["node", "-e", js_cmd], capture_output=True, text=True, check=True)
        self.assertIn("WASM_RES1=50", res.stdout)
        self.assertIn("WASM_RES2=8.25", res.stdout)

    def test_c11_and_llvm_backend_emission(self):
        code = """
def sum_array(n: i64) -> i64:
    arr = [10] * n
    total = 0
    for i in 0..n:
        total += arr[i]
    return total
"""
        mod = Parser.from_source(code).parse_module()
        mir = MIRBuilder().build(mod)
        c_code = C11Backend(mir).emit_c()
        self.assertIn("int64_t bmb_sum_array", c_code)
        self.assertIn("__bmb_alloc_i64", c_code)

        llvm_code = LLVMIRBackend(mir).emit_llvm()
        self.assertIn("define dso_local i64 @sum_array", llvm_code)

    def test_elf64_backend_emission(self):
        code = """
def main():
    print("Linux ELF64 Test")
    return 42
"""
        mod = Parser.from_source(code).parse_module()
        mir = MIRBuilder().build(mod)
        from mamba.backends.elf_exe import ELF64ExecutableBuilder
        raw = ELF64ExecutableBuilder(mir).build_bytes()
        # Verify ELF64 header magic
        self.assertEqual(raw[:4], b"\x7fELF")
        self.assertEqual(raw[4], 2)       # 64-bit
        self.assertEqual(raw[5], 1)       # Little-endian
        # Verify machine is EM_X86_64
        import struct
        machine = struct.unpack_from("<H", raw, 18)[0]
        self.assertEqual(machine, 0x3E)
        # Verify PT_LOAD program header
        p_type = struct.unpack_from("<I", raw, 64)[0]
        self.assertEqual(p_type, 1)

    def test_lexical_arena_lifetimes_and_escape_analysis(self):
        code = """
struct Point:
    x: f64
    y: f64

def compute_point(x: f64, y: f64) -> f64:
    p = Point(x, y)
    return p.x * p.y

def main():
    total = 0.0
    for i in 1..=1000:
        total += compute_point(2.0, 3.0)
    print(f"ARENA_TOTAL={total}")
"""
        mod = Parser.from_source(code).parse_module()
        mir = MIRBuilder().build(mod)
        fn_cp = next(f for f in mir.functions if f.name == "compute_point")
        ops = [ins.op for ins in fn_cp.instructions]
        self.assertIn("ARENA_SAVE", ops)
        self.assertIn("ARENA_RESTORE", ops)

        jit = NativeJITModule(mir)
        jit.run_main()
        out = jit.get_output()
        self.assertIn("ARENA_TOTAL=6000.0", out)
        jit.close()

    def test_sso_string_slicing_and_concatenation(self):
        code = """
def process_strings(prefix: str, suffix: str) -> str:
    full = prefix + " " + suffix
    sub = full[0:5]
    return sub

def main():
    s = process_strings("Black", "Mamba")
    print(f"RES_STR={s}")
    full = "Black Mamba"
    sub2 = full[6:11]
    print(f"SUB2={sub2}")
    ch0 = full[0]
    print(f"CH0={ch0}")
    print(f"LEN={len(full)}")
    eq_test = (sub2 == "Mamba")
    print(f"EQ={eq_test}")
"""
        mod = Parser.from_source(code).parse_module()
        mir = MIRBuilder().build(mod)
        fn_ps = next(f for f in mir.functions if f.name == "process_strings")
        ops = [ins.op for ins in fn_ps.instructions]
        self.assertIn("STR_CONCAT", ops)
        self.assertIn("STR_SLICE", ops)

        jit = NativeJITModule(mir)
        jit.run_main()
        out = jit.get_output()
        self.assertIn("RES_STR=Black", out)
        self.assertIn("SUB2=Mamba", out)
        self.assertIn("CH0=B", out)
        self.assertIn("LEN=11", out)
        self.assertIn("EQ=True", out)
        jit.close()


if __name__ == "__main__":
    unittest.main()
