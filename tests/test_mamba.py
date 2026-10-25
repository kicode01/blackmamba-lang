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
import io
from mamba.repl import ReplSession, ReplResult
import tempfile
import shutil
from mamba.pkg import PackageManager, PackageManifest, PackageLock, Dependency
from mamba.module_loader import resolve_imports
from mamba.doc import DocGenerator, extract_module_doc, extract_package_doc
from mamba.lsp import (
    LanguageServer,
    DocumentAnalyzer,
    format_source,
    read_message,
    write_message,
    DiagnosticSeverity,
    CompletionItemKind,
    SymbolKind,
)


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

    def test_language_server_protocol(self):
        # 1. Framing: read_message and write_message
        buf = io.BytesIO()
        test_payload = {"jsonrpc": "2.0", "id": 42, "result": {"ready": True}}
        write_message(buf, test_payload)
        buf.seek(0)
        raw_bytes = buf.getvalue()
        self.assertTrue(raw_bytes.startswith(b"Content-Length: "))
        self.assertIn(b"\r\n\r\n", raw_bytes)
        decoded = read_message(buf)
        self.assertEqual(decoded, test_payload)

        # 2. Formatter
        messy_code = "fn   add(a:i64,b:i64)->i64:\n  return   a+b\n"
        formatted = format_source(messy_code)
        self.assertIn("fn add(a: i64, b: i64) -> i64:", formatted)
        self.assertIn("    return a + b", formatted)

        # 3. DocumentAnalyzer direct unit tests
        doc_uri = "file:///sample.bmb"
        doc_src = """struct Vector:
    x: f64
    y: f64

fn norm_sq(v: Vector) -> f64:
    return v.x * v.x + v.y * v.y

fn main() -> i64:
    vec = Vector(3.0, 4.0)
    ans = norm_sq(vec)
    return 0
"""
        analyzer = DocumentAnalyzer(doc_uri, doc_src)
        diags = analyzer.analyze()
        self.assertEqual(len(diags), 0, "Clean document should have 0 diagnostics")

        # Hover on function name 'norm_sq'
        hover = analyzer.get_hover(4, 5)
        self.assertIsNotNone(hover)
        self.assertIn("def norm_sq(v: Vector) -> f64", hover["contents"]["value"])

        # Hover on struct name 'Vector'
        hover_struct = analyzer.get_hover(0, 8)
        self.assertIsNotNone(hover_struct)
        self.assertIn("struct Vector", hover_struct["contents"]["value"])

        # Completion on dot 'vec.' at line 11
        analyzer.update_source(doc_src + "    vec.\n")
        analyzer.analyze()
        dot_items = analyzer.get_completions(11, 8)["items"]
        labels = [item["label"] for item in dot_items]
        self.assertIn("x", labels)
        self.assertIn("y", labels)
        analyzer.update_source(doc_src)
        analyzer.analyze()

        # Definition of 'norm_sq' called on line 9
        defn = analyzer.get_definition(9, 12)
        self.assertIsNotNone(defn)
        self.assertEqual(defn["range"]["start"]["line"], 4)

        # Document symbols
        symbols = analyzer.get_document_symbols()
        sym_names = [s["name"] for s in symbols]
        self.assertIn("Vector", sym_names)
        self.assertIn("norm_sq", sym_names)
        self.assertIn("main", sym_names)

        # 4. Full LanguageServer JSON-RPC Daemon Session
        in_stream = io.BytesIO()
        out_stream = io.BytesIO()

        # Step 4a: initialize request
        write_message(in_stream, {
            "jsonrpc": "2.0",
            "id": 1,
            "method": "initialize",
            "params": {"capabilities": {}},
        })
        # Step 4b: initialized notification
        write_message(in_stream, {
            "jsonrpc": "2.0",
            "method": "initialized",
            "params": {},
        })
        # Step 4c: didOpen notification
        write_message(in_stream, {
            "jsonrpc": "2.0",
            "method": "textDocument/didOpen",
            "params": {
                "textDocument": {
                    "uri": doc_uri,
                    "languageId": "bmb",
                    "version": 1,
                    "text": doc_src,
                }
            },
        })
        # Step 4d: hover request
        write_message(in_stream, {
            "jsonrpc": "2.0",
            "id": 2,
            "method": "textDocument/hover",
            "params": {"textDocument": {"uri": doc_uri}, "position": {"line": 4, "character": 4}},
        })
        # Step 4e: completion request
        write_message(in_stream, {
            "jsonrpc": "2.0",
            "id": 3,
            "method": "textDocument/completion",
            "params": {"textDocument": {"uri": doc_uri}, "position": {"line": 5, "character": 13}},
        })
        # Step 4f: definition request
        write_message(in_stream, {
            "jsonrpc": "2.0",
            "id": 4,
            "method": "textDocument/definition",
            "params": {"textDocument": {"uri": doc_uri}, "position": {"line": 9, "character": 11}},
        })
        # Step 4g: documentSymbol request
        write_message(in_stream, {
            "jsonrpc": "2.0",
            "id": 5,
            "method": "textDocument/documentSymbol",
            "params": {"textDocument": {"uri": doc_uri}},
        })
        # Step 4h: formatting request
        write_message(in_stream, {
            "jsonrpc": "2.0",
            "id": 6,
            "method": "textDocument/formatting",
            "params": {"textDocument": {"uri": doc_uri}, "options": {"tabSize": 4, "insertSpaces": True}},
        })
        # Step 4i: didChange with syntax error -> trigger diagnostic publication
        bad_uri = "file:///syntax_err.bmb"
        write_message(in_stream, {
            "jsonrpc": "2.0",
            "method": "textDocument/didOpen",
            "params": {
                "textDocument": {
                    "uri": bad_uri,
                    "languageId": "bmb",
                    "version": 1,
                    "text": "fn broken_fn(x:\n    return x\n",
                }
            },
        })
        # Step 4j: shutdown request
        write_message(in_stream, {
            "jsonrpc": "2.0",
            "id": 7,
            "method": "shutdown",
            "params": {},
        })
        # Step 4k: exit notification
        write_message(in_stream, {
            "jsonrpc": "2.0",
            "method": "exit",
            "params": {},
        })

        in_stream.seek(0)
        server = LanguageServer(in_stream, out_stream)
        server.run()

        out_stream.seek(0)
        responses = {}
        notifications = []
        while True:
            msg = read_message(out_stream)
            if msg is None:
                break
            if "id" in msg and msg["id"] is not None:
                responses[msg["id"]] = msg
            elif "method" in msg:
                notifications.append(msg)

        # Verify initialize response capabilities
        init_res = responses.get(1, {}).get("result", {})
        caps = init_res.get("capabilities", {})
        self.assertTrue(caps.get("hoverProvider"))
        self.assertTrue(caps.get("definitionProvider"))
        self.assertTrue(caps.get("documentSymbolProvider"))
        self.assertTrue(caps.get("documentFormattingProvider"))
        self.assertIn(".", caps.get("completionProvider", {}).get("triggerCharacters", []))

        # Verify didOpen clean diagnostics (empty list)
        clean_diag_notifs = [n for n in notifications if n.get("params", {}).get("uri") == doc_uri]
        self.assertTrue(len(clean_diag_notifs) >= 1)
        self.assertEqual(len(clean_diag_notifs[0]["params"]["diagnostics"]), 0)

        # Verify syntax error diagnostics notification
        err_diag_notifs = [n for n in notifications if n.get("params", {}).get("uri") == bad_uri]
        self.assertTrue(len(err_diag_notifs) >= 1)
        err_diags = err_diag_notifs[0]["params"]["diagnostics"]
        self.assertTrue(len(err_diags) >= 1)
        self.assertEqual(err_diags[0]["severity"], DiagnosticSeverity.Error)
        self.assertIn("ParseError", err_diags[0]["message"])

        # Verify hover response
        hover_res = responses.get(2, {}).get("result", {})
        self.assertIn("norm_sq", hover_res.get("contents", {}).get("value", ""))

        # Verify completion response
        comp_res = responses.get(3, {}).get("result", {})
        items = comp_res.get("items", [])
        field_labels = [it["label"] for it in items]
        self.assertTrue("x" in field_labels and "y" in field_labels)

        # Verify definition response
        def_res = responses.get(4, {}).get("result", {})
        self.assertEqual(def_res.get("range", {}).get("start", {}).get("line"), 4)

        # Verify documentSymbol response
        sym_res = responses.get(5, {}).get("result", [])
        top_names = [s["name"] for s in sym_res]
        self.assertIn("Vector", top_names)
        self.assertIn("norm_sq", top_names)
        self.assertIn("main", top_names)

        # Verify formatting response
        fmt_res = responses.get(6, {}).get("result", [])
        self.assertTrue(len(fmt_res) > 0)
        self.assertIn("newText", fmt_res[0])

        # Verify shutdown response
        shut_res = responses.get(7, {})
        self.assertIn("result", shut_res)
        self.assertIsNone(shut_res["result"])

    def test_interactive_repl(self):
        sess = ReplSession()

        # 1. Expression evaluation across types
        r_i64 = sess.execute("10 + 20")
        self.assertEqual(r_i64.result, 30)
        self.assertEqual(r_i64.result_type, "i64")
        self.assertTrue(r_i64.is_expression)

        r_f64 = sess.execute("3.14 * 2.0")
        self.assertAlmostEqual(r_f64.result, 6.28, places=4)
        self.assertEqual(r_f64.result_type, "f64")

        r_bool = sess.execute("10 > 5")
        self.assertEqual(r_bool.result, True)
        self.assertEqual(r_bool.result_type, "bool")

        r_str = sess.execute("'Black ' + 'Mamba'")
        self.assertEqual(r_str.result, "Black Mamba")
        self.assertEqual(r_str.result_type, "str")

        # 2. Variable assignments & persistent state across turns
        sess.execute("x = 10")
        sess.execute("y = 20")
        r_sum = sess.execute("x + y")
        self.assertEqual(r_sum.result, 30)

        sess.execute("x += 5")
        r_sum2 = sess.execute("x + y")
        self.assertEqual(r_sum2.result, 35)

        # 3. User function declaration and invocation
        fn_code = "fn power(base: i64, exp: i64) -> i64:\n    res = 1\n    for i in 0..exp:\n        res *= base\n    return res"
        r_def = sess.execute(fn_code)
        self.assertIn("Defined function power", r_def.message)

        r_pow = sess.execute("power(2, 8)")
        self.assertEqual(r_pow.result, 256)
        self.assertEqual(r_pow.result_type, "i64")

        # 4. User struct definition and field access
        st_code = "struct Vector2D:\n    x: f64\n    y: f64"
        r_st = sess.execute(st_code)
        self.assertIn("Defined struct Vector2D", r_st.message)

        sess.execute("v = Vector2D(3.0, 4.0)")
        r_norm = sess.execute("v.x * v.x + v.y * v.y")
        self.assertAlmostEqual(r_norm.result, 25.0, places=4)
        self.assertEqual(r_norm.result_type, "f64")

        # 5. Standard library import
        r_imp = sess.execute("from math import sin, PI")
        self.assertIn("Imported", r_imp.message)
        r_sin = sess.execute("sin(PI / 2.0)")
        self.assertAlmostEqual(r_sin.result, 1.0, places=4)

        # 6. Meta commands
        r_help = sess.execute(":help")
        self.assertIn("Black Mamba (.bmb) Interactive REPL Commands", r_help.message)

        r_vars = sess.execute(":vars")
        self.assertIn("x: i64 = 15", r_vars.message)
        self.assertIn("y: i64 = 20", r_vars.message)

        r_funcs = sess.execute(":funcs")
        self.assertIn("power", r_funcs.message)

        r_structs = sess.execute(":structs")
        self.assertIn("Vector2D", r_structs.message)

        r_mir = sess.execute(":mir")
        self.assertIn("MIR", r_mir.message)

        r_asm = sess.execute(":asm")
        self.assertIn("x86-64", r_asm.message)

        r_exit = sess.execute(":exit")
        self.assertEqual(r_exit.message, "EXIT")

        # 7. Syntax error recovery
        r_err = sess.execute("10 + * 5")
        self.assertIsNotNone(r_err.error)
        # Verify subsequent statement still works cleanly without corruption
        r_ok = sess.execute("x + 1")
        self.assertEqual(r_ok.result, 16)

        # 8. Reset command
        r_reset = sess.execute(":reset")
        self.assertIn("reset", r_reset.message)
        self.assertEqual(len(sess.assigned_vars), 0)

    def test_package_manager(self):
        # 1. Manifest serialization & parsing
        manifest = PackageManifest(
            name="demo-math",
            version="1.2.3",
            description="Math utilities",
            authors=["Alice <alice@example.com>"],
            license="Apache-2.0",
            entry="src/lib.bmb",
            dependencies={"core": Dependency(name="core", version="^1.0.0")},
            build_target="wasm",
            opt_level="speed",
        )
        toml_str = manifest.to_toml()
        self.assertIn('name = "demo-math"', toml_str)
        self.assertIn('version = "1.2.3"', toml_str)
        self.assertIn('target = "wasm"', toml_str)

        tmp_dir = tempfile.mkdtemp(prefix="bmb_pkg_unit_")
        try:
            m_path = os.path.join(tmp_dir, "mamba.toml")
            manifest.save(m_path)
            loaded_manifest = PackageManifest.load(m_path)
            self.assertEqual(loaded_manifest.name, "demo-math")
            self.assertEqual(loaded_manifest.version, "1.2.3")
            self.assertEqual(loaded_manifest.build_target, "wasm")

            # 2. Project initialization
            app_dir = os.path.join(tmp_dir, "myapp")
            lib_dir = os.path.join(tmp_dir, "mylib")

            mgr_lib = PackageManager(lib_dir)
            m_lib = mgr_lib.init_project(lib_dir, name="mylib", is_lib=True)
            self.assertTrue(os.path.exists(os.path.join(lib_dir, "mamba.toml")))
            self.assertTrue(os.path.exists(os.path.join(lib_dir, "src", "lib.bmb")))
            self.assertTrue(os.path.exists(os.path.join(lib_dir, ".gitignore")))

            # Custom library function
            with open(os.path.join(lib_dir, "src", "lib.bmb"), "w", encoding="utf-8") as f:
                f.write("fn calc_sum(a: i64, b: i64) -> i64:\n    return a + b\n")

            mgr_app = PackageManager(app_dir)
            m_app = mgr_app.init_project(app_dir, name="myapp", is_lib=False)
            self.assertTrue(os.path.exists(os.path.join(app_dir, "src", "main.bmb")))

            # 3. Add path dependency
            locked = mgr_app.add_dependency(name="mylib", path="../mylib")
            self.assertEqual(locked.name, "mylib")
            self.assertEqual(locked.source, "path")
            self.assertTrue(locked.integrity.startswith("sha256-"))

            # Verify lockfile on disk
            lock = PackageLock.load(mgr_app.lock_path)
            self.assertIn("mylib", lock.packages)
            self.assertEqual(lock.packages["mylib"].integrity, locked.integrity)

            # 4. Compile and execute application with vendored dependency
            app_src = """from mylib import calc_sum

fn main() -> i64:
    ans = calc_sum(100, 250)
    print(f"CALC_SUM_RESULT={ans}")
    return 0
"""
            main_path = os.path.join(app_dir, "src", "main.bmb")
            mod = Parser.from_source(app_src, main_path).parse_module()
            mod = resolve_imports(mod, os.path.join(app_dir, "src"))
            mir = MIRBuilder().build(mod)
            jit = NativeJITModule(mir)
            jit.run_main()
            out = "".join(jit.printed_lines)
            self.assertIn("CALC_SUM_RESULT=350", out)
            jit.close()

            # 5. List dependencies
            recs = mgr_app.list_dependencies()
            self.assertEqual(len(recs), 1)
            self.assertEqual(recs[0]["name"], "mylib")
            self.assertEqual(recs[0]["installed"], "yes")

            # 6. Frozen install verification
            lock_installed = mgr_app.install(frozen=True)
            self.assertIn("mylib", lock_installed.packages)

            # 7. Remove dependency
            removed = mgr_app.remove_dependency("mylib")
            self.assertTrue(removed)
            recs_empty = mgr_app.list_dependencies()
            self.assertEqual(len(recs_empty), 0)
            self.assertFalse(os.path.exists(os.path.join(mgr_app.vendor_dir, "mylib")))
        finally:
            shutil.rmtree(tmp_dir, ignore_errors=True)

    def test_documentation_generator(self):
        tmp_dir = tempfile.mkdtemp(prefix="bmb_doc_test_")
        try:
            # 1. Create a documented .bmb file
            mod_file = os.path.join(tmp_dir, "geometry.bmb")
            with open(mod_file, "w", encoding="utf-8") as f:
                f.write("""# 2D and 3D Geometry Utilities for Black Mamba.
# Provides point, vector, and polygon transformation routines.

# Golden ratio constant
PHI = 1.618033988749895

# 2D Point structure
struct Point2D:
    x: f64
    y: f64

    fn distance_to(other: Point2D) -> f64:
        # Computes Euclidean distance to another point.
        dx = other.x - self.x
        dy = other.y - self.y
        return dx * dx + dy * dy

def make_origin() -> Point2D:
    # Constructs a Point2D initialized at the coordinate origin (0, 0).
    return Point2D(0.0, 0.0)

def dot_product(x1: f64, y1: f64, x2: f64, y2: f64) -> f64:
    # Computes 2D vector dot product.
    return x1 * x2 + y1 * y2
""")

            # 2. Extract documentation metadata
            doc = extract_module_doc(mod_file)
            self.assertEqual(doc.name, "geometry")
            self.assertIn("Geometry Utilities", doc.doc)
            self.assertEqual(len(doc.structs), 1)
            self.assertEqual(doc.structs[0].name, "Point2D")
            self.assertEqual(len(doc.structs[0].fields), 2)
            self.assertEqual(len(doc.structs[0].methods), 1)
            self.assertEqual(doc.structs[0].methods[0].name, "distance_to")
            self.assertEqual(len(doc.funcs), 2)
            fn_names = [fn.name for fn in doc.funcs]
            self.assertIn("make_origin", fn_names)
            self.assertIn("dot_product", fn_names)
            self.assertEqual(len(doc.constants), 1)
            self.assertEqual(doc.constants[0].name, "PHI")

            # 3. Generate static HTML documentation site
            out_docs_dir = os.path.join(tmp_dir, "docs")
            gen = DocGenerator(output_dir=out_docs_dir)
            index_path = gen.generate_file(mod_file)

            self.assertTrue(os.path.exists(index_path))
            with open(index_path, "r", encoding="utf-8") as hf:
                html_text = hf.read()

            # 4. Verify HTML contents and client-side search index
            self.assertIn("geometry", html_text)
            self.assertIn("Point2D", html_text)
            self.assertIn("distance_to", html_text)
            self.assertIn("make_origin", html_text)
            self.assertIn("dot_product", html_text)
            self.assertIn("PHI", html_text)
            self.assertIn("SEARCH_INDEX", html_text)
            self.assertIn("initSearch", html_text)
            self.assertIn("<style>", html_text)

            # 5. CLI invocation test via bmb doc
            cli_res = subprocess.run(
                ["python", "bmb.py", "doc", mod_file, "-o", os.path.join(tmp_dir, "cli_docs")],
                capture_output=True,
                text=True,
                check=True,
            )
            self.assertIn("[bmb doc] Generated static HTML documentation", cli_res.stdout)
            self.assertTrue(os.path.exists(os.path.join(tmp_dir, "cli_docs", "index.html")))
        finally:
            shutil.rmtree(tmp_dir, ignore_errors=True)

    def test_lock_free_channels(self):
        # 1. Single-Threaded Bounded Channel FIFO & State Inspection
        chan_code = """
from chan import *

fn main() -> i64:
    ch = chan_new(4)
    out = atomic_new(0)

    # Initial state
    print(f"INIT_CAP={chan_cap(ch)} EMPTY={chan_is_empty(ch)} FULL={chan_is_full(ch)}")

    # Send 4 items
    chan_send(ch, 11)
    chan_send(ch, 22)
    chan_send(ch, 33)
    chan_send(ch, 44)
    print(f"LEN={chan_len(ch)} FULL={chan_is_full(ch)}")

    # Overfill test (non-blocking try_send should return 0)
    overfill = chan_try_send(ch, 55)
    print(f"OVERFILL={overfill}")

    # Receive in FIFO order
    chan_recv(ch, out)
    v1 = atomic_get(out)
    chan_recv(ch, out)
    v2 = atomic_get(out)
    chan_recv(ch, out)
    v3 = atomic_get(out)
    chan_recv(ch, out)
    v4 = atomic_get(out)
    print(f"FIFO={v1},{v2},{v3},{v4}")

    # Channel should be empty now
    empty_try = chan_try_recv(ch, out)
    print(f"EMPTY_RECV={empty_try} IS_EMPTY={chan_is_empty(ch)}")

    # Close channel
    chan_close(ch)
    print(f"IS_CLOSED={chan_is_closed(ch)}")
    recv_closed = chan_recv(ch, out)
    print(f"RECV_CLOSED={recv_closed}")

    return 0
"""
        mod = Parser.from_source(chan_code).parse_module()
        mod = resolve_imports(mod, ".")
        mir = MIRBuilder().build(mod)
        jit = NativeJITModule(mir)
        jit.run_main()
        out = "".join(jit.printed_lines)
        jit.close()

        self.assertIn("INIT_CAP=4 EMPTY=True FULL=False", out)
        self.assertIn("LEN=4 FULL=True", out)
        self.assertIn("OVERFILL=0", out)
        self.assertIn("FIFO=11,22,33,44", out)
        self.assertIn("EMPTY_RECV=0 IS_EMPTY=True", out)
        self.assertIn("IS_CLOSED=True", out)
        self.assertIn("RECV_CLOSED=-1", out)

        # 2. Multi-Threaded Concurrent Producer-Consumer Pipeline
        concurrent_code = """
from chan import *
from thread import thread_spawn, thread_join

struct WorkerCtx:
    ch: Channel
    total: AtomicInt
    count: i64

fn producer_thread(ctx_ptr: i64) -> i64:
    ctx: WorkerCtx = ctx_ptr
    for i in 1..=ctx.count:
        chan_send(ctx.ch, i)
    chan_close(ctx.ch)
    return 0

fn consumer_thread(ctx_ptr: i64) -> i64:
    ctx: WorkerCtx = ctx_ptr
    box = atomic_new(0)
    acc = 0
    while True:
        r = chan_recv(ctx.ch, box)
        if r == -1:
            break
        acc += atomic_get(box)
    atomic_set(ctx.total, acc)
    return 0

fn main() -> i64:
    ch = chan_new(16)
    accum = atomic_new(0)
    ctx = WorkerCtx(ch, accum, 500)

    t_prod = thread_spawn(producer_thread, ctx)
    t_cons = thread_spawn(consumer_thread, ctx)

    thread_join(t_prod)
    thread_join(t_cons)

    final_sum = atomic_get(accum)
    print(f"CONCURRENT_PIPELINE_SUM={final_sum}")
    return 0
"""
        c_mod = Parser.from_source(concurrent_code).parse_module()
        c_mod = resolve_imports(c_mod, ".")
        c_mir = MIRBuilder().build(c_mod)
        c_jit = NativeJITModule(c_mir)
        c_jit.run_main()
        c_out = "".join(c_jit.printed_lines)
        c_jit.close()

        # sum(1..500) = 500 * 501 / 2 = 125250
        self.assertIn("CONCURRENT_PIPELINE_SUM=125250", c_out)

        # 3. Standalone PE32+ Executable Compilation & Execution
        pe_exe_path = os.path.abspath("build/test_phase4_chan.exe")
        os.makedirs("build", exist_ok=True)
        PE32PlusExecutableBuilder(c_mir).write_executable(pe_exe_path)
        self.assertTrue(os.path.exists(pe_exe_path))

        pe_res = subprocess.run([pe_exe_path], capture_output=True, text=True, check=True)
        self.assertIn("CONCURRENT_PIPELINE_SUM=125250", pe_res.stdout)

        if os.path.exists(pe_exe_path):
            os.remove(pe_exe_path)

    def test_channel_select_and_actors(self):
        sel_code = """
from chan import (
    Channel,
    chan_new,
    chan_send,
    chan_recv,
    chan_try_send,
    chan_try_recv,
    chan_select2,
    Select,
    select_new,
    select_add_recv,
    select_add_send,
    select_add_default,
    select_poll,
    select_wait,
    select_recv_value,
    Actor,
    actor_new,
    actor_send,
    actor_signal,
    actor_recv,
    actor_stop,
    actor_is_alive,
)
from thread import (
    AtomicInt,
    atomic_new,
    atomic_get,
    atomic_set,
    thread_spawn,
    thread_sleep,
)

def delayed_worker(ch_ptr: i64) -> i64:
    thread_sleep(15)
    chan_send(ch_ptr, 777)
    return 0

fn main() -> i64:
    out = atomic_new(0)

    # 1. Multi-Channel Select Poll & Default Fallback
    ch_a = chan_new(4)
    ch_b = chan_new(4)
    sel = select_new()
    c_a = select_add_recv(sel, ch_a)
    c_b = select_add_recv(sel, ch_b)
    select_add_default(sel)

    p_empty = select_poll(sel, out)
    chan_send(ch_b, 42)
    p_b = select_poll(sel, out)
    v_b = atomic_get(out)
    chan_send(ch_a, 100)
    p_a = select_poll(sel, out)
    v_a = atomic_get(out)
    print(f"SEL_POLL: empty={p_empty} b_idx={p_b} b_val={v_b} a_idx={p_a} a_val={v_a}")

    # 2. Select Send Case on Full vs Ready Channel
    ch_send = chan_new(2)
    chan_send(ch_send, 1)
    chan_send(ch_send, 2)
    sel_snd = select_new()
    s_idx = select_add_send(sel_snd, ch_send, 999)
    select_add_default(sel_snd)
    p_full = select_poll(sel_snd, out)
    
    b_drain = atomic_new(0)
    chan_recv(ch_send, b_drain)
    p_ready = select_poll(sel_snd, out)
    v_sent = atomic_get(out)
    print(f"SEL_SEND: full={p_full} ready={p_ready} sent={v_sent}")

    # 3. Thread-Safe Select Wait with Timeout & Background Delivery
    ch_bg = chan_new(4)
    sel_bg = select_new()
    select_add_recv(sel_bg, ch_bg)
    thread_spawn(delayed_worker, ch_bg)
    w_idx = select_wait(sel_bg, 500, out)
    w_val = atomic_get(out)
    print(f"SEL_WAIT: idx={w_idx} val={w_val}")

    # 4. Ultra-Fast 2-Channel Select
    c1 = chan_new(2)
    c2 = chan_new(2)
    s2_none = chan_select2(c1, c2, out)
    chan_send(c2, 555)
    s2_hit = chan_select2(c1, c2, out)
    s2_val = atomic_get(out)
    print(f"SEL2: none={s2_none} hit={s2_hit} val={s2_val}")

    # 5. Concurrent Actor Event Loop & Priority Signals
    act = actor_new(10, 16)
    actor_send(act, 201)
    actor_signal(act, 999)
    
    t0 = actor_recv(act, 0, out)
    v0 = atomic_get(out)
    t1 = actor_recv(act, 0, out)
    v1 = atomic_get(out)
    t2 = actor_recv(act, 0, out)
    
    alive_before = 1 if actor_is_alive(act) else 0
    actor_stop(act)
    alive_after = 1 if actor_is_alive(act) else 0
    print(f"ACTOR: t0={t0} v0={v0} t1={t1} v1={v1} t2={t2} alive={alive_before}->{alive_after}")

    return 0
"""
        mod = Parser.from_source(sel_code).parse_module()
        mod = resolve_imports(mod, ".")
        mir = MIRBuilder().build(mod)
        jit = NativeJITModule(mir)
        jit.run_main()
        out = "".join(jit.printed_lines)
        jit.close()

        self.assertIn("SEL_POLL: empty=-2 b_idx=1 b_val=42 a_idx=0 a_val=100", out)
        self.assertIn("SEL_SEND: full=-2 ready=0 sent=999", out)
        self.assertIn("SEL_WAIT: idx=0 val=777", out)
        self.assertIn("SEL2: none=0 hit=2 val=555", out)
        self.assertIn("ACTOR: t0=100 v0=999 t1=1 v1=201 t2=0 alive=1->0", out)

        # Standalone PE32+ Executable Compilation & Execution
        pe_exe_path = os.path.abspath("build/test_phase4_select.exe")
        os.makedirs("build", exist_ok=True)
        PE32PlusExecutableBuilder(mir).write_executable(pe_exe_path)
        self.assertTrue(os.path.exists(pe_exe_path))

        pe_res = subprocess.run([pe_exe_path], capture_output=True, text=True, check=True)
        self.assertIn("SEL_POLL: empty=-2 b_idx=1 b_val=42 a_idx=0 a_val=100", pe_res.stdout)
        self.assertIn("SEL_SEND: full=-2 ready=0 sent=999", pe_res.stdout)
        self.assertIn("SEL_WAIT: idx=0 val=777", pe_res.stdout)
        self.assertIn("SEL2: none=0 hit=2 val=555", pe_res.stdout)
        self.assertIn("ACTOR: t0=100 v0=999 t1=1 v1=201 t2=0 alive=1->0", pe_res.stdout)

        if os.path.exists(pe_exe_path):
            os.remove(pe_exe_path)

    def test_stdlib_regex_module(self):
        regex_code = """
from regex import *

fn main() -> i64:
    # 1. Literals, Wildcard, Alternation & Quantifiers
    r1 = regex_compile("cat|dog")
    print(f"LIT: cat={regex_match(r1, 'cat')} dog={regex_match(r1, 'dog')} cow={regex_match(r1, 'cow')}")

    r_dot = regex_compile("c.t")
    print(f"DOT: cat={regex_match(r_dot, 'cat')} cut={regex_match(r_dot, 'cut')} ct={regex_match(r_dot, 'ct')}")

    r_star = regex_compile("ab*c")
    print(f"STAR: ac={regex_match(r_star, 'ac')} abc={regex_match(r_star, 'abc')} abbbc={regex_match(r_star, 'abbbc')}")

    r_rep = regex_compile("^a{2,4}$")
    print(f"REP: a={regex_match(r_rep, 'a')} aa={regex_match(r_rep, 'aa')} aaaa={regex_match(r_rep, 'aaaa')} aaaaa={regex_match(r_rep, 'aaaaa')}")

    # 2. Character Classes & Escape Shorthands
    r_cls = regex_compile(r"\\d+")
    print(f"DIGIT: 99={regex_search(r_cls, 'Price is 99 dollars')} none={regex_search(r_cls, 'No numbers here')}")

    r_neg = regex_compile("[^0-9]+")
    print(f"NEG_CLS: abc={regex_match(r_neg, 'abc')} 123={regex_match(r_neg, '123')}")

    # 3. Anchors & Structural Pattern
    r_mail = regex_compile(r"^[a-z]+@[a-z]+\\.[a-z]+$")
    print(f"EMAIL: valid={regex_match(r_mail, 'alice@example.com')} invalid={regex_match(r_mail, 'not-an-email')}")

    # 4. Global Replacement
    r_sub = regex_compile(r"\\d+")
    rep = regex_replace(r_sub, "Route 66 to Area 51", "XXX")
    print(f"REPLACE: {rep}")

    # 5. String Splitting
    r_sp = regex_compile("[,;]+")
    parts = regex_split(r_sp, "apple,banana;;cherry,dates")
    print(f"SPLIT: 0={parts[0]} 1={parts[1]} 2={parts[2]} 3={parts[3]}")

    # 6. Shorthand Functional API
    sh_m = re_match("[a-z]+", "mamba")
    sh_s = re_search(r"\\d+", "Agent 007")
    sh_r = re_replace(r"\\s+", "hello   world   fast", " ")
    print(f"SHORTHAND: match={sh_m} search={sh_s} replace={sh_r}")

    return 0
"""
        mod = Parser.from_source(regex_code).parse_module()
        mod = resolve_imports(mod, ".")
        mir = MIRBuilder().build(mod)
        jit = NativeJITModule(mir)
        jit.run_main()
        out = "".join(jit.printed_lines)
        jit.close()

        self.assertIn("LIT: cat=1 dog=1 cow=0", out)
        self.assertIn("DOT: cat=1 cut=1 ct=0", out)
        self.assertIn("STAR: ac=1 abc=1 abbbc=1", out)
        self.assertIn("REP: a=0 aa=1 aaaa=1 aaaaa=0", out)
        self.assertIn("DIGIT: 99=1 none=0", out)
        self.assertIn("NEG_CLS: abc=1 123=0", out)
        self.assertIn("EMAIL: valid=1 invalid=0", out)
        self.assertIn("REPLACE: Route XXX to Area XXX", out)
        self.assertIn("SPLIT: 0=apple 1=banana 2=cherry 3=dates", out)
        self.assertIn("SHORTHAND: match=1 search=1 replace=hello world fast", out)

        # Standalone PE32+ Executable Compilation & Execution
        pe_exe_path = os.path.abspath("build/test_phase4_regex.exe")
        os.makedirs("build", exist_ok=True)
        PE32PlusExecutableBuilder(mir).write_executable(pe_exe_path)
        self.assertTrue(os.path.exists(pe_exe_path))

        pe_res = subprocess.run([pe_exe_path], capture_output=True, text=True, check=True)
        self.assertIn("LIT: cat=1 dog=1 cow=0", pe_res.stdout)
        self.assertIn("REPLACE: Route XXX to Area XXX", pe_res.stdout)
        self.assertIn("SPLIT: 0=apple 1=banana 2=cherry 3=dates", pe_res.stdout)
        self.assertIn("SHORTHAND: match=1 search=1 replace=hello world fast", pe_res.stdout)

        if os.path.exists(pe_exe_path):
            os.remove(pe_exe_path)

    def test_stdlib_gc_module(self):
        gc_code = """
from gc import *

fn main() -> i64:
    # 1. Low-Level Heap Allocation & Quadword Memory Access
    raw = mem_alloc(32)
    mem_write(raw, 0, 777)
    mem_write(raw, 1, 888)
    v0 = mem_read(raw, 0)
    v1 = mem_read(raw, 1)
    mem_free(raw)
    print(f"RAW_MEM: v0={v0} v1={v1}")

    # 2. Generational Region Arena: Fast Allocation & O(1) Instant Bulk Reclamation
    r = region_new(1024)
    p1 = region_alloc(r, 4)
    p2 = region_alloc(r, 4)
    region_write(r, p1, 0, 100)
    region_write(r, p2, 0, 200)
    region_write(r, p1, 1, p2)
    region_write(r, p2, 1, p1)
    rv1 = region_read(r, p1, 0)
    rv2 = region_read(r, p2, 0)
    used_before = region_used(r)
    allocs = region_count(r)
    region_reset(r)
    used_after = region_used(r)
    region_free(r)
    print(f"REGION: rv1={rv1} rv2={rv2} used_before={used_before} allocs={allocs} used_after={used_after}")

    # 3. Tracing Cycle Collector: Mutual 2-Node Cyclic Graph (A <-> B)
    g = gc_new()
    a = mem_alloc(16)
    b = mem_alloc(16)
    mem_write(a, 0, 11)
    mem_write(b, 0, 22)
    gc_track(g, a)
    gc_track(g, b)
    gc_link(g, a, b)
    gc_link(g, b, a)
    gc_add_root(g, a)
    
    r_live = gc_collect(g)
    cnt_live = gc_count(g)
    
    gc_remove_root(g, a)
    r_dead = gc_collect(g)
    cnt_dead = gc_count(g)
    total_reclaimed = gc_total_reclaimed(g)
    print(f"GC_MUTUAL: r_live={r_live} cnt_live={cnt_live} r_dead={r_dead} cnt_dead={cnt_dead} total={total_reclaimed}")

    # 4. Dense Multi-Node Cyclic Ring & Entanglement (5 nodes)
    g2 = gc_new()
    n1 = mem_alloc(16)
    n2 = mem_alloc(16)
    n3 = mem_alloc(16)
    n4 = mem_alloc(16)
    n5 = mem_alloc(16)
    gc_track(g2, n1)
    gc_track(g2, n2)
    gc_track(g2, n3)
    gc_track(g2, n4)
    gc_track(g2, n5)
    gc_link(g2, n1, n2)
    gc_link(g2, n2, n3)
    gc_link(g2, n3, n4)
    gc_link(g2, n4, n5)
    gc_link(g2, n5, n2)
    gc_link(g2, n3, n1)
    
    gc_add_root(g2, n1)
    r2_live = gc_collect(g2)
    cnt2_live = gc_count(g2)
    
    gc_remove_root(g2, n1)
    r2_dead = gc_collect(g2)
    cnt2_dead = gc_count(g2)
    gc_free(g2)
    print(f"GC_DENSE: r_live={r2_live} cnt_live={cnt2_live} r_dead={r2_dead} cnt_dead={cnt2_dead}")

    gc_free(g)
    return 0
"""
        mod = Parser.from_source(gc_code).parse_module()
        mod = resolve_imports(mod, ".")
        mir = MIRBuilder().build(mod)
        jit = NativeJITModule(mir)
        jit.run_main()
        out = "".join(jit.printed_lines)
        jit.close()

        self.assertIn("RAW_MEM: v0=777 v1=888", out)
        self.assertIn("REGION: rv1=100 rv2=200 used_before=64 allocs=2 used_after=0", out)
        self.assertIn("GC_MUTUAL: r_live=0 cnt_live=2 r_dead=2 cnt_dead=0 total=2", out)
        self.assertIn("GC_DENSE: r_live=0 cnt_live=5 r_dead=5 cnt_dead=0", out)

        # Standalone PE32+ Executable Compilation & Execution
        pe_exe_path = os.path.abspath("build/test_phase4_gc.exe")
        os.makedirs("build", exist_ok=True)
        PE32PlusExecutableBuilder(mir).write_executable(pe_exe_path)
        self.assertTrue(os.path.exists(pe_exe_path))

        pe_res = subprocess.run([pe_exe_path], capture_output=True, text=True, check=True)
        self.assertIn("RAW_MEM: v0=777 v1=888", pe_res.stdout)
        self.assertIn("REGION: rv1=100 rv2=200 used_before=64 allocs=2 used_after=0", pe_res.stdout)
        self.assertIn("GC_MUTUAL: r_live=0 cnt_live=2 r_dead=2 cnt_dead=0 total=2", pe_res.stdout)
        self.assertIn("GC_DENSE: r_live=0 cnt_live=5 r_dead=5 cnt_dead=0", pe_res.stdout)

        if os.path.exists(pe_exe_path):
            os.remove(pe_exe_path)

    def test_stdlib_unicode_engine(self):
        unicode_code = """
from unicode import utf8_byte_len, utf8_decode_at, utf8_codepoint_len, utf8_validate, utf8_codepoint_at
from unicode import utf16_is_surrogate, utf16_decode_surrogates, utf16_encode_high_surrogate, utf16_encode_low_surrogate
from unicode import cp_is_ascii, cp_is_whitespace, cp_is_alphabetic, cp_is_numeric, cp_is_emoji, grapheme_len, cp_to_upper, cp_to_lower

fn main() -> i64:
    # 1. UTF-8 Lead Byte Lengths
    b1 = utf8_byte_len(65)   # ASCII 'A' -> 1
    b2 = utf8_byte_len(194)  # 0xC2 -> 2
    b3 = utf8_byte_len(224)  # 0xE0 -> 3
    b4 = utf8_byte_len(240)  # 0xF0 -> 4
    b_err = utf8_byte_len(254) # invalid -> -1
    print(f"UTF8_BYTES: b1={b1} b2={b2} b3={b3} b4={b4} b_err={b_err}")

    # 2. String Codepoints & Validation
    s = "Hello World"
    cp_count = utf8_codepoint_len(s)
    is_valid = utf8_validate(s)
    cp_1 = utf8_codepoint_at(s, 1) # 'e' = 101
    print(f"UTF8_STR: cp_count={cp_count} is_valid={is_valid} cp_1={cp_1}")

    # 3. UTF-16 Surrogate Pair Transcoding (U+1F600 Grinning Face = 128512)
    face_cp = 128512
    high = utf16_encode_high_surrogate(face_cp)
    low = utf16_encode_low_surrogate(face_cp)
    decoded_cp = utf16_decode_surrogates(high, low)
    is_surr = utf16_is_surrogate(high)
    is_emoji = cp_is_emoji(face_cp)
    print(f"UTF16_SURR: high={high} low={low} decoded={decoded_cp} is_surr={is_surr} is_emoji={is_emoji}")

    # 4. Codepoint Classification & Properties
    ascii_ok = cp_is_ascii(65)
    ws_space = cp_is_whitespace(32)
    ws_tab = cp_is_whitespace(9)
    alpha_a = cp_is_alphabetic(65)
    alpha_cjk = cp_is_alphabetic(19968) # Chinese character '一'
    num_5 = cp_is_numeric(53) # '5'
    print(f"PROPS: ascii={ascii_ok} ws_sp={ws_space} ws_tab={ws_tab} alpha_a={alpha_a} alpha_cjk={alpha_cjk} num_5={num_5}")

    # 5. UAX #29 Grapheme Segmentation
    g_ascii = grapheme_len("blackmamba")
    print(f"GRAPHEME: g_ascii={g_ascii}")

    # 6. Case Conversion & Folding
    up_a = cp_to_upper(97)   # 'a' -> 'A' (65)
    lo_z = cp_to_lower(90)   # 'Z' -> 'z' (122)
    up_lat = cp_to_upper(224) # 'à' -> 'À' (192)
    print(f"CASE: up_a={up_a} lo_z={lo_z} up_lat={up_lat}")
    return 0
"""
        mod = Parser.from_source(unicode_code).parse_module()
        mod = resolve_imports(mod, ".")
        mir = MIRBuilder().build(mod)
        jit = NativeJITModule(mir)
        jit.run_main()
        out = "".join(jit.printed_lines)
        jit.close()

        self.assertIn("UTF8_BYTES: b1=1 b2=2 b3=3 b4=4 b_err=-1", out)
        self.assertIn("UTF8_STR: cp_count=11 is_valid=True cp_1=101", out)
        self.assertIn("UTF16_SURR: high=55357 low=56832 decoded=128512 is_surr=True is_emoji=True", out)
        self.assertIn("PROPS: ascii=True ws_sp=True ws_tab=True alpha_a=True alpha_cjk=True num_5=True", out)
        self.assertIn("GRAPHEME: g_ascii=10", out)
        self.assertIn("CASE: up_a=65 lo_z=122 up_lat=192", out)

        # Standalone PE32+ Executable Compilation & Execution
        pe_exe_path = os.path.abspath("build/test_phase4_unicode.exe")
        os.makedirs("build", exist_ok=True)
        PE32PlusExecutableBuilder(mir).write_executable(pe_exe_path)
        self.assertTrue(os.path.exists(pe_exe_path))

        pe_res = subprocess.run([pe_exe_path], capture_output=True, text=True, check=True)
        self.assertIn("UTF8_BYTES: b1=1 b2=2 b3=3 b4=4 b_err=-1", pe_res.stdout)
        self.assertIn("UTF8_STR: cp_count=11 is_valid=True cp_1=101", pe_res.stdout)
        self.assertIn("UTF16_SURR: high=55357 low=56832 decoded=128512 is_surr=True is_emoji=True", pe_res.stdout)
        self.assertIn("PROPS: ascii=True ws_sp=True ws_tab=True alpha_a=True alpha_cjk=True num_5=True", pe_res.stdout)
        self.assertIn("GRAPHEME: g_ascii=10", pe_res.stdout)
        self.assertIn("CASE: up_a=65 lo_z=122 up_lat=192", pe_res.stdout)

        if os.path.exists(pe_exe_path):
            os.remove(pe_exe_path)

    def test_stdlib_async_reactor(self):
        async_code = """
from async import async_loop_new, async_spawn, async_delay, async_tick, async_run_until_complete, async_run_all, async_task_status, async_task_result, async_task_is_done

def worker_add(x: i64) -> i64:
    return x + 100

def worker_mult(x: i64) -> i64:
    return x * 10

def main() -> i64:
    loop = async_loop_new(16)
    t1 = async_spawn(loop, worker_add, 42)
    t2 = async_spawn(loop, worker_mult, 7)

    # 1. Tick cooperative step
    executed = async_tick(loop)
    r1 = async_task_result(loop, t1)
    r2 = async_task_result(loop, t2)
    done1 = async_task_is_done(loop, t1)
    done2 = async_task_is_done(loop, t2)
    print(f"ASYNC_TICK: executed={executed} r1={r1} r2={r2} done1={done1} done2={done2}")

    # 2. Delayed Task Execution via monotonic hardware clock
    t3 = async_delay(loop, 2, worker_add, 500)
    st_before = async_task_status(loop, t3)
    r3 = async_run_until_complete(loop, t3)
    st_after = async_task_status(loop, t3)
    print(f"ASYNC_DELAY: st_before={st_before} r3={r3} st_after={st_after}")

    # 3. Run all batch queue
    t4 = async_spawn(loop, worker_mult, 9)
    total_completed = async_run_all(loop)
    r4 = async_task_result(loop, t4)
    print(f"ASYNC_ALL: total={total_completed} r4={r4}")
    return 0
"""
        mod = Parser.from_source(async_code).parse_module()
        mod = resolve_imports(mod, ".")
        mir = MIRBuilder().build(mod)
        jit = NativeJITModule(mir)
        jit.run_main()
        out = "".join(jit.printed_lines)
        jit.close()

        self.assertIn("ASYNC_TICK: executed=2 r1=142 r2=70 done1=True done2=True", out)
        self.assertIn("ASYNC_DELAY: st_before=0 r3=600 st_after=2", out)
        self.assertIn("ASYNC_ALL: total=4 r4=90", out)

        # Standalone PE32+ Executable Compilation & Execution
        pe_exe_path = os.path.abspath("build/test_phase4_async.exe")
        os.makedirs("build", exist_ok=True)
        PE32PlusExecutableBuilder(mir).write_executable(pe_exe_path)
        self.assertTrue(os.path.exists(pe_exe_path))

        pe_res = subprocess.run([pe_exe_path], capture_output=True, text=True, check=True)
        self.assertIn("ASYNC_TICK: executed=2 r1=142 r2=70 done1=True done2=True", pe_res.stdout)
        self.assertIn("ASYNC_DELAY: st_before=0 r3=600 st_after=2", pe_res.stdout)
        self.assertIn("ASYNC_ALL: total=4 r4=90", pe_res.stdout)

        if os.path.exists(pe_exe_path):
            os.remove(pe_exe_path)

    def test_stdlib_kv_store(self):
        kv_code = """
from kv import kv_open, kv_put, kv_get, kv_put_int, kv_get_int, kv_has, kv_delete, kv_sync, kv_compact, kv_close, kv_len

def main() -> i64:
    path = "build/test_kv_suite.db"
    db = kv_open(path, 64)
    kv_put(db, "user:1", "Alice")
    kv_put(db, "user:2", "Bob")
    kv_put(db, "user:3", "Charlie")
    kv_put_int(db, "score:1", 9500)
    kv_put_int(db, "score:2", 8200)

    # 1. In-memory data access & counts
    u1 = kv_get(db, "user:1")
    u2 = kv_get(db, "user:2")
    sc1 = kv_get_int(db, "score:1", 0)
    sc2 = kv_get_int(db, "score:2", 0)
    has_u1 = kv_has(db, "user:1")
    count1 = kv_len(db)
    print(f"KV_PASS1: u1={u1} u2={u2} sc1={sc1} sc2={sc2} has_u1={has_u1} count1={count1}")

    # 2. Deletion and compaction
    kv_delete(db, "user:2")
    has_u2_after = kv_has(db, "user:2")
    count2 = kv_len(db)
    print(f"KV_PASS2: has_u2_after={has_u2_after} count2={count2}")

    kv_compact(db)
    kv_close(db)

    # 3. Persistent reload and recovery from disk WAL
    db2 = kv_open(path, 64)
    u1_reload = kv_get(db2, "user:1")
    u2_reload = kv_get(db2, "user:2")
    u3_reload = kv_get(db2, "user:3")
    sc1_reload = kv_get_int(db2, "score:1", 0)
    has_u2_reload = kv_has(db2, "user:2")
    count3 = kv_len(db2)
    kv_close(db2)
    print(f"KV_PASS3: u1_reload={u1_reload} u2_reload={u2_reload} u3_reload={u3_reload} sc1_reload={sc1_reload} has_u2_reload={has_u2_reload} count3={count3}")
    return 0
"""
        db_path = os.path.abspath("build/test_kv_suite.db")
        if os.path.exists(db_path):
            os.remove(db_path)
        os.makedirs("build", exist_ok=True)

        mod = Parser.from_source(kv_code).parse_module()
        mod = resolve_imports(mod, ".")
        mir = MIRBuilder().build(mod)
        jit = NativeJITModule(mir)
        jit.run_main()
        out = "".join(jit.printed_lines)
        jit.close()

        self.assertIn("KV_PASS1: u1=Alice u2=Bob sc1=9500 sc2=8200 has_u1=True count1=5", out)
        self.assertIn("KV_PASS2: has_u2_after=False count2=4", out)
        self.assertIn("KV_PASS3: u1_reload=Alice u2_reload= u3_reload=Charlie sc1_reload=9500 has_u2_reload=False count3=4", out)

        # Standalone PE32+ Executable Compilation & Execution
        pe_exe_path = os.path.abspath("build/test_phase4_kv.exe")
        if os.path.exists(db_path):
            os.remove(db_path)
        PE32PlusExecutableBuilder(mir).write_executable(pe_exe_path)
        self.assertTrue(os.path.exists(pe_exe_path))

        pe_res = subprocess.run([pe_exe_path], capture_output=True, text=True, check=True)
        self.assertIn("KV_PASS1: u1=Alice u2=Bob sc1=9500 sc2=8200 has_u1=True count1=5", pe_res.stdout)
        self.assertIn("KV_PASS2: has_u2_after=False count2=4", pe_res.stdout)
        self.assertIn("KV_PASS3: u1_reload=Alice u2_reload= u3_reload=Charlie sc1_reload=9500 has_u2_reload=False count3=4", pe_res.stdout)

        if os.path.exists(pe_exe_path):
            os.remove(pe_exe_path)
        if os.path.exists(db_path):
            os.remove(db_path)

    def test_stdlib_http_websocket_framework(self):
        http_code = '''from http import (
    HttpRequest, HttpResponse, HttpServer, WsFrame,
    http_server_create, http_add_route, http_dispatch,
    http_parse_request, http_format_response, http_get_header, http_get_query_param,
    response_json, ws_accept_key, ws_handshake_response, ws_decode_frame, ws_encode_text_frame
)

def main() -> i64:
    # 1. Test Request Parsing
    crlf = chr(13) + chr(10)
    raw = "GET /api/v1/users?page=3&sort=asc HTTP/1.1" + crlf + "Host: api.blackmamba.dev" + crlf + crlf
    req = http_parse_request(raw)
    host = http_get_header(req.headers_raw, "Host")
    page = http_get_query_param(req.query, "page")
    print(f"HTTP_TEST: meth={req.method} path={req.path} host={host} page={page}")

    # 2. Test Router Dispatch
    srv = http_server_create("127.0.0.1", 8080, 8)
    http_add_route(srv, "GET", "/api/v1/users", 200, "application/json", '{"total": 42}')
    resp = http_dispatch(srv, req)
    print(f"ROUTER_TEST: st={resp.status} ct={resp.content_type} body={resp.body}")

    # 3. Test WebSocket RFC 6455
    key = "dGhlIHNhbXBsZSBub25jZQ=="
    accept_val = ws_accept_key(key)
    print(f"WS_ACCEPT: {accept_val}")

    # 4. Test WebSocket Frame Round-Trip
    msg = "Ping WebSocket Test"
    frame = ws_encode_text_frame(msg)
    decoded = ws_decode_frame(frame)
    print(f"WS_FRAME: op={decoded.opcode} payload={decoded.payload}")
    return 0
'''
        mod = Parser.from_source(http_code).parse_module()
        mod = resolve_imports(mod, ".")
        mir = MIRBuilder().build(mod)

        # JIT verification
        jit = NativeJITModule(mir)
        jit.run_main()
        out = "".join(jit.printed_lines)
        jit.close()

        self.assertIn("HTTP_TEST: meth=GET path=/api/v1/users host=api.blackmamba.dev page=3", out)
        self.assertIn('ROUTER_TEST: st=200 ct=application/json body={"total": 42}', out)
        self.assertIn("WS_ACCEPT: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=", out)
        self.assertIn("WS_FRAME: op=1 payload=Ping WebSocket Test", out)

        # Standalone PE32+ executable verification
        pe_exe_path = os.path.abspath("build/test_phase4_http.exe")
        PE32PlusExecutableBuilder(mir).write_executable(pe_exe_path)
        self.assertTrue(os.path.exists(pe_exe_path))

        pe_res = subprocess.run([pe_exe_path], capture_output=True, text=True, check=True)
        self.assertIn("HTTP_TEST: meth=GET path=/api/v1/users host=api.blackmamba.dev page=3", pe_res.stdout)
        self.assertIn('ROUTER_TEST: st=200 ct=application/json body={"total": 42}', pe_res.stdout)
        self.assertIn("WS_ACCEPT: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=", pe_res.stdout)
        self.assertIn("WS_FRAME: op=1 payload=Ping WebSocket Test", pe_res.stdout)

        if os.path.exists(pe_exe_path):
            os.remove(pe_exe_path)

    def test_stdlib_simd_vectorization(self):
        simd_code = '''from simd import (
    Vec4f, Vec8f, Vec4i,
    vec4f_set, vec4f_splat, vec4f_add, vec4f_mul, vec4f_fma, vec4f_hsum, vec4f_dot,
    vec8f_set, vec8f_splat, vec8f_mul, vec8f_hsum,
    vec4i_set, vec4i_add, vec4i_hsum,
    simd_add_f64, simd_fma_f64, simd_dot_f64, simd_sum_f64
)

def main() -> i64:
    # 1. Vec4f operations
    v1 = vec4f_set(1.0, 2.0, 3.0, 4.0)
    v2 = vec4f_splat(2.0)
    v_fma = vec4f_fma(v1, v2, vec4f_splat(1.0))
    hsum4 = vec4f_hsum(v_fma) # (1*2+1) + (2*2+1) + (3*2+1) + (4*2+1) = 3 + 5 + 7 + 9 = 24.0
    dot4 = vec4f_dot(v1, v2)   # 2 + 4 + 6 + 8 = 20.0
    print(f"SIMD_TEST4F: hsum={hsum4} dot={dot4}")

    # 2. Vec8f operations
    w1 = vec8f_set(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0)
    w2 = vec8f_splat(3.0)
    w_mul = vec8f_mul(w1, w2)
    hsum8 = vec8f_hsum(w_mul) # (1+2+3+4+5+6+7+8)*3 = 36 * 3 = 108.0
    print(f"SIMD_TEST8F: hsum={hsum8}")

    # 3. Vec4i operations
    i1 = vec4i_set(10, 20, 30, 40)
    i2 = vec4i_set(1, 2, 3, 4)
    i_add = vec4i_add(i1, i2)
    i_sum = vec4i_hsum(i_add) # 11 + 22 + 33 + 44 = 110
    print(f"SIMD_TEST4I: isum={i_sum}")

    # 4. Bulk 8-way unrolled SIMD kernels
    n = 16
    a = [2.0] * n
    b = [3.0] * n
    c = [1.0] * n
    out = [0.0] * n
    simd_fma_f64(a, b, c, out, n)
    bulk_sum = simd_sum_f64(out, n) # 16 * (2*3 + 1) = 16 * 7 = 112.0
    bulk_dot = simd_dot_f64(a, b, n) # 16 * (2*3) = 96.0
    print(f"SIMD_BULK: sum={bulk_sum} dot={bulk_dot}")
    return 0
'''
        mod = Parser.from_source(simd_code).parse_module()
        mod = resolve_imports(mod, ".")
        mir = MIRBuilder().build(mod)

        # JIT verification
        jit = NativeJITModule(mir)
        jit.run_main()
        out = "".join(jit.printed_lines)
        jit.close()

        self.assertIn("SIMD_TEST4F: hsum=24.0 dot=20.0", out)
        self.assertIn("SIMD_TEST8F: hsum=108.0", out)
        self.assertIn("SIMD_TEST4I: isum=110", out)
        self.assertIn("SIMD_BULK: sum=112.0 dot=96.0", out)

        # Standalone PE32+ executable verification
        pe_exe_path = os.path.abspath("build/test_phase4_simd.exe")
        PE32PlusExecutableBuilder(mir).write_executable(pe_exe_path)
        self.assertTrue(os.path.exists(pe_exe_path))

        pe_res = subprocess.run([pe_exe_path], capture_output=True, text=True, check=True)
        self.assertIn("SIMD_TEST4F: hsum=24 dot=20", pe_res.stdout)
        self.assertIn("SIMD_TEST8F: hsum=108", pe_res.stdout)
        self.assertIn("SIMD_TEST4I: isum=110", pe_res.stdout)
        self.assertIn("SIMD_BULK: sum=112 dot=96", pe_res.stdout)

        if os.path.exists(pe_exe_path):
            os.remove(pe_exe_path)


if __name__ == "__main__":
    unittest.main()
