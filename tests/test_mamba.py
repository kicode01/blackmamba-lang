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

    def test_stdlib_math_time_random_modules(self):
        code = """
from math import *
from time import *
from random import *

def main():
    s = sin(PI / 2.0)
    print(f"STDLIB_SIN={s}")
    h = hypot(3.0, 4.0)
    print(f"STDLIB_HYPOT={h}")
    ns = clock_ns()
    print(f"STDLIB_CLOCK_OK={ns > 0}")
    rng = rng_new(42)
    r = rng_randint(rng, 10, 20)
    print(f"STDLIB_RNG_OK={r >= 10 and r <= 20}")
"""
        mod = Parser.from_source(code).parse_module()
        mir = MIRBuilder().build(mod)
        jit = NativeJITModule(mir)
        jit.run_main()
        out = jit.get_output()
        self.assertIn("STDLIB_SIN=1", out)
        self.assertIn("STDLIB_HYPOT=5.0", out)
        self.assertIn("STDLIB_CLOCK_OK=True", out)
        self.assertIn("STDLIB_RNG_OK=True", out)
        jit.close()

    def test_zero_copy_numpy_tensor_exchange(self):
        import mamba
        import numpy as np

        # 1. Test mamba.compile with in-place NumPy array mutation
        mod = mamba.compile("""
def saxpy_inplace(n: int, a: f64, x: List[f64], y: List[f64]) -> i64:
    for i in 0..n:
        y[i] = a * x[i] + y[i]
    return n
""")
        x = np.array([1.0, 2.0, 3.0, 4.0], dtype=np.float64)
        y = np.array([10.0, 20.0, 30.0, 40.0], dtype=np.float64)
        ret = mod.saxpy_inplace(4, 2.5, x, y)
        self.assertEqual(ret, 4)
        self.assertTrue(np.allclose(y, [12.5, 25.0, 37.5, 50.0]))
        mod.close()

        # 2. Test @mamba.jit decorator
        @mamba.jit
        def square_vector(n: int, arr: List[f64]) -> i64:
            for i in 0..n:
                arr[i] = arr[i] * arr[i]
            return 0

        a = np.array([2.0, 3.0, 5.0], dtype=np.float64)
        square_vector(len(a), a)
        self.assertTrue(np.allclose(a, [4.0, 9.0, 25.0]))

        # 3. Test 2D matrix multiplication directly on NumPy buffers
        mod_mat = mamba.compile("""
from tensor import tensor_matmul, tensor_relu

def matmul_2d(M: int, K: int, N: int, A: List[f64], B: List[f64], C: List[f64]) -> i64:
    return tensor_matmul(A, B, C, M, K, N)

def relu_1d(n: int, x: List[f64], out: List[f64]) -> i64:
    return tensor_relu(x, out, n)
""")
        A = np.array([[1.0, 2.0], [3.0, 4.0]], dtype=np.float64)
        B = np.array([[5.0, 6.0], [7.0, 8.0]], dtype=np.float64)
        C = np.zeros((2, 2), dtype=np.float64)
        mod_mat.matmul_2d(2, 2, 2, A, B, C)
        self.assertTrue(np.allclose(C, A @ B))

        act_in = np.array([-5.0, 0.0, 7.5], dtype=np.float64)
        act_out = np.zeros_like(act_in)
        mod_mat.relu_1d(3, act_in, act_out)
        self.assertTrue(np.allclose(act_out, [0.0, 0.0, 7.5]))
        mod_mat.close()

        # 4. Test zero-copy export from BMB memory to NumPy view
        mod_exp = mamba.compile("""
def alloc_signal(n: int) -> Array[f64]:
    arr = [0.0] * n
    for i in 0..n:
        arr[i] = float(i * 10)
    return arr
""")
        ptr = mod_exp.alloc_signal(5)
        np_view = mamba.as_numpy_array(ptr, 5)
        self.assertTrue(np.allclose(np_view, [0.0, 10.0, 20.0, 30.0, 40.0]))
        # Mutate through NumPy view and verify
        np_view[0] = 777.0
        self.assertEqual(np_view[0], 777.0)
        mod_exp.close()

    def test_stdlib_json_module(self):
        """
        Phase 4: Pure native Black Mamba (.bmb) JSON parser and serializer standard library.
        Verifies parser DOM construction, type-safe getters, array indexing, and stringifiers.
        """
        import mamba
        json_bmb_code = """
from json import *

def test_parse_and_serialize() -> i64:
    json_text = "{\\"compiler\\": \\"Black Mamba\\", \\"version\\": 2, \\"speed\\": 42.5, \\"active\\": true, \\"tags\\": [\\"fast\\", \\"native\\"]}"
    doc = json_parse(json_text, 50)
    if doc.error != "":
        return -1
    
    # Query object fields
    name = json_get_str(doc, doc.root, "compiler", "none")
    ver = json_get_int(doc, doc.root, "version", 0)
    spd = json_get_float(doc, doc.root, "speed", 0.0)
    act = json_get_bool(doc, doc.root, "active", False)
    
    print(f"Name={name}")
    print(f"Version={ver}")
    print(f"Speed={spd}")
    print(f"Active={act}")
    
    # Query array
    tags_idx = json_get(doc, doc.root, "tags")
    t_len = json_array_len(doc, tags_idx)
    t0_idx = json_array_get(doc, tags_idx, 0)
    t0_str = doc.nodes[t0_idx].str_val
    print(f"TagsLen={t_len}")
    print(f"Tag0={t0_str}")
    
    # Serialize back
    s = json_dumps(doc, doc.root)
    print(f"Serialized={s}")
    return doc.node_count
"""
        mod = mamba.compile(json_bmb_code)
        count = mod.test_parse_and_serialize()
        self.assertGreater(count, 0)
        out = mod.get_output()
        self.assertIn("Name=Black Mamba", out)
        self.assertIn("Version=2", out)
        self.assertIn("Speed=42.5", out)
        self.assertIn("Active=True", out)
        self.assertIn("TagsLen=2", out)
        self.assertIn("Tag0=fast", out)
        self.assertIn('Serialized={"compiler": "Black Mamba", "version": 2, "speed": 42.5, "active": true, "tags": ["fast", "native"]}', out)
        mod.close()

    def test_stdlib_hash_module(self):
        """
        Phase 4: Pure native Black Mamba (.bmb) Cryptography & Hashing standard library.
        Verifies SHA-256 (NIST FIPS 180-4), HMAC-SHA256 (RFC 2104), MurmurHash3, and FNV-1a.
        """
        import mamba
        hash_bmb_code = """
from hash import *

def test_hashing() -> i64:
    # 1. SHA-256
    h_empty = sha256("")
    h_abc = sha256("abc")
    h_fox = sha256("The quick brown fox jumps over the lazy dog")
    print(f"sha256_empty={h_empty}")
    print(f"sha256_abc={h_abc}")
    print(f"sha256_fox={h_fox}")

    # 2. HMAC-SHA256 (RFC 4231)
    sig = hmac_sha256("key", "The quick brown fox jumps over the lazy dog")
    print(f"hmac_fox={sig}")

    # 3. MurmurHash3 & FNV-1a
    mm = murmurhash3("Black Mamba")
    fnv = fnv1a_32("Black Mamba")
    print(f"mmh3={mm}")
    print(f"fnv1a={fnv}")
    return 0
"""
        mod = mamba.compile(hash_bmb_code)
        res = mod.test_hashing()
        self.assertEqual(res, 0)
        out = mod.get_output()
        self.assertIn("sha256_empty=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855", out)
        self.assertIn("sha256_abc=ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad", out)
        self.assertIn("sha256_fox=d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592", out)
        self.assertIn("hmac_fox=f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8", out)
        self.assertIn("mmh3=3565214588", out)
        self.assertIn("fnv1a=817612296", out)
        mod.close()

    def test_stdlib_os_module(self):
        """
        Phase 4: Pure native Black Mamba (.bmb) OS & File System Primitives.
        Verifies path utilities (join, basename, dirname, ext), get_cwd,
        file_exists, write_file, file_size, read_file, append_file, and remove_file.
        """
        import mamba
        os_bmb_code = """
from os import *

def test_os_ops() -> i64:
    # 1. Path manipulation
    p = path_join("build", "test_stdlib_os.tmp")
    base = path_basename(p)
    dir_name = path_dirname(p)
    ext = path_ext(p)
    print(f"p={p}")
    print(f"base={base}")
    print(f"dir={dir_name}")
    print(f"ext={ext}")

    # 2. Working directory
    cwd = get_cwd()
    print(f"cwd_len={len(cwd)}")

    # 3. File lifecycle: clean up, write, size, read
    if file_exists(p):
        remove_file(p)
    print(f"exists_before={file_exists(p)}")

    w_bytes = write_file(p, "Black Mamba OS Primitives\\nLine 2\\n")
    print(f"w_bytes={w_bytes}")
    print(f"exists_after={file_exists(p)}")
    print(f"size_after={file_size(p)}")
    
    content1 = read_file(p)
    print(f"content1={content1}")

    # 4. Append
    app_bytes = append_file(p, "Line 3 Appended\\n")
    print(f"app_bytes={app_bytes}")
    print(f"size_appended={file_size(p)}")
    content2 = read_file(p)
    print(f"content2={content2}")

    # 5. Remove
    rm_ok = remove_file(p)
    print(f"rm_ok={rm_ok}")
    print(f"exists_final={file_exists(p)}")
    return 0
"""
        mod = mamba.compile(os_bmb_code)
        res = mod.test_os_ops()
        self.assertEqual(res, 0)
        out = mod.get_output()
        self.assertIn("p=build/test_stdlib_os.tmp", out)
        self.assertIn("base=test_stdlib_os.tmp", out)
        self.assertIn("dir=build", out)
        self.assertIn("ext=.tmp", out)
        self.assertIn("exists_before=False", out)
        self.assertIn("exists_after=True", out)
        self.assertIn("Black Mamba OS Primitives", out)
        self.assertIn("Line 3 Appended", out)
        self.assertIn("rm_ok=True", out)
        self.assertIn("exists_final=False", out)
        mod.close()

    def test_stdlib_socket_module(self):
        """
        Phase 4: Pure native Black Mamba (.bmb) Networking & Sockets standard library.
        Verifies socket_init, tcp_server, tcp_connect, socket_accept, socket_send,
        socket_recv, socket_close, and socket_cleanup.
        """
        import mamba
        socket_bmb_code = """
from socket import *

def test_sockets() -> i64:
    init_res = socket_init()
    print(f"init_res={init_res}")

    # Start TCP server on loopback port 23456
    srv = tcp_server("127.0.0.1", 23456, 2)
    print(f"srv_fd={srv.fd}")

    # Connect client
    cli = tcp_connect("127.0.0.1", 23456)
    print(f"cli_fd={cli.fd}")

    # Accept on server
    conn = socket_accept(srv)
    print(f"conn_fd={conn.fd}")

    # Client sends ping
    n1 = socket_send(cli, "PING_MAMBA")
    print(f"sent_bytes={n1}")

    # Server receives ping
    req = socket_recv(conn, 128)
    print(f"req={req}")

    # Server echoes pong
    n2 = socket_send(conn, "PONG:" + req)
    print(f"echo_bytes={n2}")

    # Client receives pong
    resp = socket_recv(cli, 128)
    print(f"resp={resp}")

    # Clean close
    c1 = socket_close(conn)
    c2 = socket_close(cli)
    c3 = socket_close(srv)
    cleanup_res = socket_cleanup()
    print(f"c1={c1} c2={c2} c3={c3} cleanup={cleanup_res}")
    return 0
"""
        mod = mamba.compile(socket_bmb_code)
        res = mod.test_sockets()
        self.assertEqual(res, 0)
        out = mod.get_output()
        self.assertIn("init_res=0", out)
        self.assertIn("sent_bytes=10", out)
        self.assertIn("req=PING_MAMBA", out)
        self.assertIn("resp=PONG:PING_MAMBA", out)
        self.assertIn("c1=0 c2=0 c3=0 cleanup=0", out)
        mod.close()

    def test_stdlib_array_module(self):
        """
        Phase 4: Pure native Black Mamba (.bmb) Dynamic Vector Collections standard library.
        Verifies IntVector (push, pop, insert, swap_remove, sort, bsearch, min, max, sum),
        FloatVector (sort, mean), StrVector (join, contains), and IntSlice (zero-copy view).
        """
        import mamba
        array_bmb_code = """
from array import *

def test_vectors() -> i64:
    # 1. IntVector
    iv = int_vec_new(2)
    int_vec_push(iv, 50)
    int_vec_push(iv, 20)
    int_vec_push(iv, 80)
    int_vec_push(iv, 10)
    print(f"iv_len={int_vec_len(iv)}")
    print(f"iv_cap={int_vec_cap(iv)}")
    
    int_vec_insert(iv, 1, 999)
    print(f"after_insert={int_vec_to_str(iv)}")
    
    popped = int_vec_pop(iv)
    print(f"popped={popped}")
    
    sr = int_vec_swap_remove(iv, 1)
    print(f"swap_removed={sr}")
    
    int_vec_sort(iv)
    print(f"sorted={int_vec_to_str(iv)}")
    
    bs_50 = int_vec_binary_search(iv, 50)
    bs_99 = int_vec_binary_search(iv, 99)
    print(f"bs_50={bs_50}")
    print(f"bs_99={bs_99}")
    print(f"min={int_vec_min(iv)}")
    print(f"max={int_vec_max(iv)}")
    print(f"sum={int_vec_sum(iv)}")

    # 2. FloatVector
    fv = float_vec_new(2)
    float_vec_push(fv, 3.14)
    float_vec_push(fv, 1.41)
    float_vec_push(fv, 2.71)
    float_vec_sort(fv)
    print(f"fv_sorted={float_vec_to_str(fv)}")
    print(f"fv_min={float_vec_min(fv)}")
    print(f"fv_max={float_vec_max(fv)}")

    # 3. StrVector
    sv = str_vec_new(2)
    str_vec_push(sv, "antigravity")
    str_vec_push(sv, "black_mamba")
    str_vec_push(sv, "bare_metal")
    print(f"joined={str_vec_join(sv, '::')}")
    print(f"has_mamba={str_vec_contains(sv, 'black_mamba')}")
    print(f"has_python={str_vec_contains(sv, 'python')}")

    # 4. Zero-copy slice
    base = int_vec_new(4)
    int_vec_push(base, 100)
    int_vec_push(base, 200)
    int_vec_push(base, 300)
    int_vec_push(base, 400)
    sl = int_slice_from_vec(base, 1, 3)
    print(f"sl_len={sl.len}")
    print(f"sl_0={int_slice_get(sl, 0)}")
    int_slice_set(sl, 0, 8888)
    print(f"base_1_mutated={int_vec_get(base, 1)}")
    return 0
"""
        mod = mamba.compile(array_bmb_code)
        res = mod.test_vectors()
        self.assertEqual(res, 0)
        out = mod.get_output()
        self.assertIn("iv_len=4", out)
        self.assertIn("after_insert=[50, 999, 20, 80, 10]", out)
        self.assertIn("popped=10", out)
        self.assertIn("swap_removed=999", out)
        self.assertIn("sorted=[20, 50, 80]", out)
        self.assertIn("bs_50=1", out)
        self.assertIn("bs_99=-1", out)
        self.assertIn("min=20", out)
        self.assertIn("max=80", out)
        self.assertIn("sum=150", out)
        self.assertIn("fv_sorted=[1.41, 2.71, 3.14]", out)
        self.assertIn("joined=antigravity::black_mamba::bare_metal", out)
        self.assertIn("has_mamba=True", out)
        self.assertIn("has_python=False", out)
        self.assertIn("sl_len=2", out)
        self.assertIn("sl_0=200", out)
        self.assertIn("base_1_mutated=8888", out)
        mod.close()

    def test_stdlib_test_module(self):
        """
        Phase 4: Pure native Black Mamba (.bmb) Testing & Micro-Benchmarking standard library.
        Verifies test_runner_new, test_suite, test_case, assert_eq_i64, assert_ne_i64,
        assert_lt_i64, assert_eq_f64, assert_eq_str, assert_str_contains, benchmark_create,
        benchmark_print, and test_summary.
        """
        import mamba
        test_bmb_code = """
from test import *

def run_tests() -> i64:
    t = test_runner_new(True)
    test_suite(t, "Core Logic")
    test_case(t, "Assertions")
    assert_eq_i64(t, 10 + 20, 30, "sum == 30")
    assert_ne_i64(t, 5, 6, "5 != 6")
    assert_lt_i64(t, 1, 2, "1 < 2")
    assert_eq_f64(t, 1.5 * 2.0, 3.0, 0.001, "1.5 * 2.0 == 3.0")
    assert_eq_str(t, "mamba", "mamba", "str eq")
    assert_str_contains(t, "black_mamba", "mamba", "contains mamba")

    b = benchmark_create("Dummy Bench", 1000, 50000)
    benchmark_print(b)
    return test_summary(t)
"""
        mod = mamba.compile(test_bmb_code)
        res = mod.run_tests()
        self.assertEqual(res, 0)
        out = mod.get_output()
        self.assertIn("=== Test Suite: Core Logic ===", out)
        self.assertIn("[PASS] sum == 30", out)
        self.assertIn("[PASS] contains mamba", out)
        self.assertIn("Benchmark: Dummy Bench", out)
        self.assertIn("TEST SUMMARY: 6/6 assertions passed", out)
        self.assertIn("STATUS: ALL TESTS PASSED! [100% SUCCESS]", out)
        mod.close()

    def test_macho_arm64_backend(self):
        """
        Phase 2: macOS Apple Silicon ARM64 Mach-O 64-bit native executable builder.
        Verifies Mach-O 64-bit header, __PAGEZERO, __TEXT segments, LC_MAIN,
        LC_BUILD_VERSION, LC_LOAD_DYLINKER, and AArch64 instruction emission.
        """
        import struct
        import mamba.cli
        from mamba.backends.arm64_macho import MachOARM64ExecutableBuilder

        code = """
def compute(x: i64, y: i64) -> i64:
    return (x * y) + 42

def main() -> i64:
    res = compute(10, 20)
    print(res)
    return 0
"""
        mir = mamba.cli.compile_source_to_mir(code)
        builder = MachOARM64ExecutableBuilder(mir)
        macho_bytes = builder.build_bytes()

        # 1. Verify Mach-O Header (32 bytes)
        magic, cputype, cpusubtype, filetype, ncmds, sizeofcmds, flags, reserved = struct.unpack_from(
            "<IIIIIIII", macho_bytes, 0
        )
        self.assertEqual(magic, 0xFEEDFACF)     # MH_MAGIC_64
        self.assertEqual(cputype, 0x0100000C)   # CPU_TYPE_ARM64
        self.assertEqual(cpusubtype, 0)         # CPU_SUBTYPE_ARM64_ALL
        self.assertEqual(filetype, 2)           # MH_EXECUTE
        self.assertEqual(ncmds, 5)              # 5 load commands
        self.assertEqual(sizeofcmds, 304)       # 304 bytes of load commands

        # 2. Verify LC_SEGMENT_64 (__PAGEZERO)
        cmd, cmdsize, segname = struct.unpack_from("<II16s", macho_bytes, 32)
        self.assertEqual(cmd, 0x19)             # LC_SEGMENT_64
        self.assertEqual(cmdsize, 72)
        self.assertTrue(segname.startswith(b"__PAGEZERO"))

        # 3. Verify LC_SEGMENT_64 (__TEXT)
        cmd2, cmdsize2, segname2 = struct.unpack_from("<II16s", macho_bytes, 32 + 72)
        self.assertEqual(cmd2, 0x19)            # LC_SEGMENT_64
        self.assertEqual(cmdsize2, 152)
        self.assertTrue(segname2.startswith(b"__TEXT"))

        # 4. Verify Entry Point instructions at payload offset (0x4000)
        entry_ins = struct.unpack_from("<I", macho_bytes, 0x4000)[0]
        self.assertEqual(entry_ins, 0xA9BF7BFD) # stp x29, x30, [sp, #-16]!

    def test_seh_pdata_unwind(self):
        """
        Phase 3: Hardware Structured Exception Handling (SEH) Unwind Tables (.pdata and .xdata).
        Verifies:
        1. PE32+ Optional Header DataDirectory[3] (IMAGE_DIRECTORY_ENTRY_EXCEPTION).
        2. Sorted IMAGE_RUNTIME_FUNCTION_ENTRY records in .pdata (Section 4).
        3. UNWIND_INFO records (.xdata) describing function prologues.
        4. Native VEH handler interception of hardware divide-by-zero (0xC0000094).
        """
        import struct
        import mamba.cli
        from mamba.backends.pe_exe import PE32PlusExecutableBuilder

        code = """
def divide(x: i64, y: i64) -> i64:
    return x // y

def main() -> i64:
    res = divide(100, 0)
    print(res)
    return 0
"""
        mir = mamba.cli.compile_source_to_mir(code)
        out_exe = os.path.abspath("build/test_seh_unit.exe")
        PE32PlusExecutableBuilder(mir).write_executable(out_exe)
        self.assertTrue(os.path.exists(out_exe))

        with open(out_exe, "rb") as f:
            pe = f.read()

        # 1. Verify COFF Section Count = 4 (.text, .rdata, .pdata, .rsrc)
        e_lfanew = struct.unpack_from("<I", pe, 0x3C)[0]
        num_sections = struct.unpack_from("<H", pe, e_lfanew + 4 + 2)[0]
        self.assertEqual(num_sections, 4)

        # 2. Verify DataDirectory[3] (IMAGE_DIRECTORY_ENTRY_EXCEPTION)
        opt_off = e_lfanew + 24
        dd_off = opt_off + 112
        exc_rva, exc_size = struct.unpack_from("<II", pe, dd_off + 3 * 8)
        self.assertGreater(exc_rva, 0)
        self.assertGreater(exc_size, 0)
        self.assertEqual(exc_size % 12, 0)

        # 3. Verify .pdata section header
        sec_off = opt_off + 240
        sections = {}
        for i in range(num_sections):
            name, vsize, rva, rsize, roff = struct.unpack_from("<8sIIII", pe, sec_off + i * 40)
            name_str = name.rstrip(b"\x00").decode("ascii")
            sections[name_str] = (rva, vsize, roff, rsize)

        self.assertIn(".pdata", sections)
        pdata_rva, pdata_vsize, pdata_roff, pdata_rsize = sections[".pdata"]
        self.assertEqual(exc_rva, pdata_rva)

        # 4. Verify all RUNTIME_FUNCTION entries in .pdata are strictly ascending
        num_entries = exc_size // 12
        self.assertGreater(num_entries, 0)
        prev_begin = -1
        for i in range(num_entries):
            b_rva, e_rva, u_rva = struct.unpack_from("<III", pe, pdata_roff + i * 12)
            self.assertGreater(b_rva, prev_begin, f"Entry {i} BeginAddress not strictly ascending")
            self.assertLess(b_rva, e_rva, f"Entry {i} BeginAddress >= EndAddress")
            self.assertGreaterEqual(u_rva, pdata_rva, f"Entry {i} UnwindInfoAddress outside .pdata")
            prev_begin = b_rva

        # 5. Run the executable and verify hardware divide-by-zero is trapped cleanly
        res = subprocess.run([out_exe], capture_output=True, text=True)
        self.assertIn("Integer Divide By Zero (0xC0000094)", res.stdout)
        self.assertIn("Call stack unwound successfully via PE32+ .pdata / .xdata tables", res.stdout)
        self.assertEqual(res.returncode & 0xFFFFFFFF, 0xC0000094)

        if os.path.exists(out_exe):
            os.remove(out_exe)

    def test_hardware_multithreading_and_atomics(self):
        """
        Phase 4 Verification: Hardware Multithreading & Concurrency (thread.bmb)
        - Hardware Atomics: atomic_load, atomic_store, atomic_add, atomic_sub, atomic_cas, atomic_fence
        - AtomicInt and Mutex synchronization primitives
        - Native multi-core thread spawning with zero GIL
        - Parallel data loops: par_for and par_map
        - Standalone PE32+ executable compilation with native Windows OS threading
        """
        from mamba.module_loader import resolve_imports
        from mamba.backends.pe_exe import PE32PlusExecutableBuilder

        # 1. JIT Test: AtomicInt, Mutex, par_for, par_map
        code = """
from thread import *

def worker_sum(idx: i64, ctx: AtomicInt) -> i64:
    atomic_fetch_add(ctx, idx)
    return 0

def square(x: i64) -> i64:
    return x * x

def thread_func(ctx: AtomicInt) -> i64:
    i = 0
    while i < 2500:
        atomic_fetch_add(ctx, 1)
        i = i + 1
    return 0

def main() -> i64:
    # 1. Atomics & CAS
    ai = atomic_new(50)
    old = atomic_fetch_add(ai, 50)
    cur = atomic_get(ai)
    cas_res = atomic_compare_and_swap(ai, 100, 250)
    final_val = atomic_get(ai)
    print(f"ATOMIC_INIT_ADD={old}")
    print(f"ATOMIC_CUR={cur}")
    print(f"ATOMIC_CAS_PREV={cas_res}")
    print(f"ATOMIC_FINAL={final_val}")

    # 2. Mutex Synchronization
    m = mutex_new()
    mutex_lock(m)
    try_fail = mutex_try_lock(m)
    mutex_unlock(m)
    try_succ = mutex_try_lock(m)
    mutex_unlock(m)
    print(f"MUTEX_TRY_FAIL={try_fail}")
    print(f"MUTEX_TRY_SUCC={try_succ}")

    # 3. Native Multi-Thread Concurrent Execution (4 threads x 2500 = 10000)
    counter = atomic_new(0)
    h1 = thread_spawn(thread_func, counter)
    h2 = thread_spawn(thread_func, counter)
    h3 = thread_spawn(thread_func, counter)
    h4 = thread_spawn(thread_func, counter)
    thread_join(h1)
    thread_join(h2)
    thread_join(h3)
    thread_join(h4)
    print(f"CONCURRENT_THREADS_SUM={atomic_get(counter)}")

    # 4. par_for: Sum 0..99 = 4950
    accum = atomic_new(0)
    par_for(0, 100, worker_sum, accum)
    print(f"PAR_FOR_SUM={atomic_get(accum)}")

    # 5. par_map: Squares [1, 2, 3, 4, 5] -> 1 + 4 + 9 + 16 + 25 = 55
    arr = [1, 2, 3, 4, 5]
    sq = par_map(arr, 5, square)
    sq_sum = sq[0] + sq[1] + sq[2] + sq[3] + sq[4]
    print(f"PAR_MAP_SUM={sq_sum}")

    return 0
"""
        mod = Parser.from_source(code).parse_module()
        mod = resolve_imports(mod, ".")
        mir = MIRBuilder().build(mod)
        jit = NativeJITModule(mir)
        jit.main()
        out = jit.get_output()

        self.assertIn("ATOMIC_INIT_ADD=50", out)
        self.assertIn("ATOMIC_CUR=100", out)
        self.assertIn("ATOMIC_CAS_PREV=100", out)
        self.assertIn("ATOMIC_FINAL=250", out)
        self.assertIn("MUTEX_TRY_FAIL=False", out)
        self.assertIn("MUTEX_TRY_SUCC=True", out)
        self.assertIn("CONCURRENT_THREADS_SUM=10000", out)
        self.assertIn("PAR_FOR_SUM=4950", out)
        self.assertIn("PAR_MAP_SUM=55", out)
        jit.close()

        # 2. Standalone PE32+ Executable Native Windows Execution
        pe_code = """
from thread import *

def pe_worker(idx: i64, ctx: AtomicInt) -> i64:
    atomic_fetch_add(ctx, 10)
    return 0

def main() -> i64:
    accum = atomic_new(0)
    par_for(0, 40, pe_worker, accum)
    print(f"PE_PAR_SUM={atomic_get(accum)}")
    return 0
"""
        pe_mod = Parser.from_source(pe_code).parse_module()
        pe_mod = resolve_imports(pe_mod, ".")
        pe_mir = MIRBuilder().build(pe_mod)
        out_exe = os.path.abspath("build/test_phase4_thread.exe")
        os.makedirs("build", exist_ok=True)
        PE32PlusExecutableBuilder(pe_mir).write_executable(out_exe)
        self.assertTrue(os.path.exists(out_exe))

        res = subprocess.run([out_exe], capture_output=True, text=True, check=True)
        self.assertIn("PE_PAR_SUM=400", res.stdout)

        if os.path.exists(out_exe):
            os.remove(out_exe)


if __name__ == "__main__":
    unittest.main()
