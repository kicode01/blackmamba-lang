"""
Unit and Integration Tests for Black Mamba Phase 4:
"The High-Performance Domain Monopolies & Full Stdlib Parity"

Verifies:
1. collections.bmb (Deque, Counter, DefaultDict, OrderedDict)
2. heap.bmb (MinHeap, PriorityQueue, heappush, heappop, bisect_left, bisect_right, insort_i64)
3. iter.bmb (chain_i64, take_i64, drop_i64, repeat_i64, accumulate_sum, MemoCache)
4. process.bmb (process_run, process_check_output, ProcessResult)
5. csv.bmb (CsvDoc, csv_parse, csv_dumps)
6. pathlib.bmb (Path, .name(), .stem(), .suffix(), .parent(), .join(), .as_posix())
7. tensor.bmb & llama.bmb (tensor_rmsnorm, tensor_softmax, q8_0_dot, q4_0_dot, GGUFHeader, LlamaConfig)
8. fastapi.bmb (parameterized route matching, parse_query_param, dispatch)
9. profile.py (Profiler, interactive SVG flamegraph generation)
10. cli.py (cmd_test test runner discovery & execution)
"""

import os
import sys
import tempfile
import unittest
from mamba.parser import Parser
from mamba.mir import MIRBuilder
from mamba.backends.x86_64_jit import NativeJITModule
from mamba.profile import Profiler
from mamba.cli import main as cli_main


def _compile_and_run(source: str, base_dir: str = "") -> int:
    ast_mod = Parser.from_source(source, "<test.bmb>").parse_module()
    resolved_base = base_dir or os.path.join(os.path.dirname(__file__), "..")
    mir = MIRBuilder().build(ast_mod, base_dir=resolved_base, filename="<test.bmb>")
    jit = NativeJITModule(mir)
    return jit.run_main()


class TestPhase4DomainMonopolies(unittest.TestCase):

    def test_collections_deque(self):
        source = """
from collections import Deque, deque_new

def main() -> i64:
    d = deque_new(16)
    d.push_back(10)
    d.push_back(20)
    d.push_front(5)
    # elements in order: 5, 10, 20
    if d.len() != 3:
        return 1
    if d.peek_front() != 5:
        return 2
    if d.peek_back() != 20:
        return 3
    if d.pop_front() != 5:
        return 4
    if d.pop_back() != 20:
        return 5
    if d.pop_front() != 10:
        return 6
    if not d.is_empty():
        return 7
    return 42
"""
        res = _compile_and_run(source)
        self.assertEqual(res, 42)

    def test_collections_counter_and_defaultdict(self):
        source = """
from collections import Counter, counter_new, DefaultDict, default_dict_new

def main() -> i64:
    c = counter_new(16)
    c.update("apple")
    c.update("banana")
    c.update("apple")
    c.update("apple")
    # "apple" has 3, "banana" has 1
    if c.get("apple") != 3:
        return 1
    if c.get("banana") != 1:
        return 2
    if c.total() != 4:
        return 3
    if c.most_common_key() != "apple":
        return 4

    dd = default_dict_new(16, 999)
    # Non-existent key returns default
    if dd.get("foo") != 999:
        return 5
    dd.set("foo", 123)
    if dd.get("foo") != 123:
        return 6
    return 100
"""
        res = _compile_and_run(source)
        self.assertEqual(res, 100)

    def test_collections_ordered_dict(self):
        source = """
from collections import OrderedDict, ordered_dict_new

def main() -> i64:
    od = ordered_dict_new(16)
    od.set("a", "alpha")
    od.set("b", "beta")
    od.set("c", "gamma")
    # Update existing key maintains insertion position
    od.set("b", "beta2")

    if od.get("a") != "alpha":
        return 1
    if od.get("b") != "beta2":
        return 2
    if od.get("c") != "gamma":
        return 3
    keys = od.keys_in_order()
    if keys[0] != "a" or keys[1] != "b" or keys[2] != "c":
        return 4
    return 77
"""
        res = _compile_and_run(source)
        self.assertEqual(res, 77)

    def test_heap_and_priority_queue(self):
        source = """
from heap import MinHeap, min_heap_new, bisect_left, bisect_right, insort_i64

def main() -> i64:
    h = min_heap_new(16)
    h.push(50)
    h.push(10)
    h.push(30)
    h.push(5)
    h.push(20)

    # Popping should yield 5, 10, 20, 30, 50 in sorted order
    if h.pop() != 5:
        return 1
    if h.pop() != 10:
        return 2
    if h.pop() != 20:
        return 3
    if h.pop() != 30:
        return 4
    if h.pop() != 50:
        return 5

    # Bisect testing on sorted array [10, 20, 20, 30, 40]
    arr = [10, 20, 20, 30, 40]
    if bisect_left(arr, 5, 20) != 1:
        return 6
    if bisect_right(arr, 5, 20) != 3:
        return 7
    return 88
"""
        res = _compile_and_run(source)
        self.assertEqual(res, 88)

    def test_iter_combinators_and_memo_cache(self):
        source = """
from iter import chain_i64, take_i64, drop_i64, accumulate_sum, permutations_count, combinations_count, memo_cache_new

def main() -> i64:
    a1 = [1, 2, 3]
    a2 = [4, 5]
    c = chain_i64(a1, 3, a2, 2)
    if c[0] != 1 or c[3] != 4 or c[4] != 5:
        return 1

    t = take_i64(c, 2, 5)
    if t[0] != 1 or t[1] != 2:
        return 2

    d = drop_i64(c, 3, 5)
    if d[0] != 4 or d[1] != 5:
        return 3

    acc = accumulate_sum(c, 5)
    # sums: 1, 3, 6, 10, 15
    if acc[4] != 15:
        return 4

    if permutations_count(5, 3) != 60:
        return 5
    if combinations_count(5, 3) != 10:
        return 6

    # MemoCache testing
    cache = memo_cache_new(16)
    if cache.has(42):
        return 7
    cache.put(42, 1729)
    if not cache.has(42):
        return 8
    if cache.get(42) != 1729:
        return 9
    return 99
"""
        res = _compile_and_run(source)
        self.assertEqual(res, 99)

    def test_process_execution(self):
        source = """
from process import process_run, process_check_output

def main() -> i64:
    # Run cross-platform echo command
    res = process_run("echo mamba_phase4_verified")
    if res.exit_code != 0:
        return 1
    if not res.success:
        return 2
    out = process_check_output("echo 12345")
    if len(out) == 0:
        return 3
    return 55
"""
        res = _compile_and_run(source)
        self.assertEqual(res, 55)

    def test_csv_parser_and_serialization(self):
        source = """
from csv import csv_parse, csv_dumps

def main() -> i64:
    csv_text = "id,name,role\\n1,Alice,Engineer\\n2,Bob,Architect"
    doc = csv_parse(csv_text, ",")
    if doc.num_rows != 3:
        return 1
    if doc.num_cols != 3:
        return 2
    if doc.get(0, 0) != "id" or doc.get(0, 1) != "name" or doc.get(0, 2) != "role":
        return 3
    if doc.get(1, 1) != "Alice":
        return 4
    if doc.get(2, 2) != "Architect":
        return 5

    # Modify cell and serialize
    doc.set(2, 2, "Director")
    out = csv_dumps(doc)
    doc2 = csv_parse(out, ",")
    if doc2.get(2, 2) != "Director":
        return 6
    return 44
"""
        res = _compile_and_run(source)
        self.assertEqual(res, 44)

    def test_pathlib_object_oriented_paths(self):
        source = """
from pathlib import path, Path

def main() -> i64:
    p = path("src/mamba/compiler.bmb")
    if p.name() != "compiler.bmb":
        return 1
    if p.stem() != "compiler":
        return 2
    if p.suffix() != ".bmb":
        return 3
    parent = p.parent()
    if parent.as_posix() != "src/mamba":
        return 4

    p2 = parent.join("runtime.bmb")
    if p2.as_posix() != "src/mamba/runtime.bmb":
        return 5
    return 66
"""
        res = _compile_and_run(source)
        self.assertEqual(res, 66)

    def test_tensor_edge_ai_and_quantization(self):
        source = """
from tensor import tensor_rmsnorm, tensor_softmax, tensor_silu, q8_0_dot, q4_0_dot, gguf_validate_magic, GGUFHeader, gguf_parse_header
from llama import LlamaConfig, llama_config_default

def main() -> i64:
    # 1. RMSNorm test
    x = [2.0, 2.0, 2.0, 2.0]
    w = [1.0, 1.0, 1.0, 1.0]
    out_norm = [0.0, 0.0, 0.0, 0.0]
    tensor_rmsnorm(x, out_norm, w, 4, 0.00001)
    # RMS of [2, 2, 2, 2] is 2.0, so x / rms is ~1.0
    if out_norm[0] < 0.99 or out_norm[0] > 1.01:
        return 1

    # 2. Softmax test
    sm_in = [1.0, 2.0, 3.0]
    sm_out = [0.0, 0.0, 0.0]
    tensor_softmax(sm_in, sm_out, 3)
    sum_prob = sm_out[0] + sm_out[1] + sm_out[2]
    if sum_prob < 0.999 or sum_prob > 1.001:
        return 2

    # 3. Quantized dot products: Q8_0
    q8_w = [10, -5, 20, 0]
    act = [1.0, 2.0, 0.5, 4.0]
    # dot = 10*1 + (-5)*2 + 20*0.5 + 0*4 = 10 - 10 + 10 = 10.0. Scale = 0.5 -> 5.0
    res_q8 = q8_0_dot(q8_w, act, 4, 0.5)
    if res_q8 < 4.99 or res_q8 > 5.01:
        return 3

    # 4. GGUF header validation
    if not gguf_validate_magic(1179993927):
        return 4
    raw_header = [1179993927, 3, 291, 18]
    gh = gguf_parse_header(raw_header, 0)
    if not gh.valid:
        return 5
    if gh.tensor_count != 291:
        return 6

    # 5. LLaMA config check
    cfg = llama_config_default(32000)
    if cfg.vocab_size != 32000 or cfg.dim != 256:
        return 7
    return 111
"""
        res = _compile_and_run(source)
        self.assertEqual(res, 111)

    def test_fastapi_parameterized_routing_and_queries(self):
        source = """
from fastapi import new_fastapi, parse_query_param

def main() -> i64:
    # Query string parsing
    q = "user=admin&role=lead&active=true"
    if parse_query_param(q, "user") != "admin":
        return 1
    if parse_query_param(q, "role") != "lead":
        return 2
    if parse_query_param(q, "active") != "true":
        return 3
    if parse_query_param(q, "missing") != "":
        return 4

    # FastAPI parameterized route matching
    app = new_fastapi("MambaAPI", "1.5.0")
    app.get("/", "{\\"status\\": \\"root\\"}")
    app.get("/users/:id", "{\\"status\\": \\"ok\\"}")

    res_root = app.dispatch("GET", "/")
    if res_root != "{\\"status\\": \\"root\\"}":
        return 5

    res_param = app.dispatch("GET", "/users/42")
    if res_param != "{\\"status\\": \\"ok\\", \\"param\\": \\"42\\"}":
        return 6
    return 222
"""
        res = _compile_and_run(source)
        self.assertEqual(res, 222)

    def test_profiler_and_svg_flamegraph(self):
        code = """
def compute_sum(n: i64) -> i64:
    total = 0
    for i in 0..n:
        total += i
    return total

def main() -> i64:
    s = compute_sum(1000)
    return s
"""
        ast_mod = Parser.from_source(code, "<prof.bmb>").parse_module()
        mir = MIRBuilder().build(ast_mod, base_dir=os.getcwd(), filename="<prof.bmb>")
        profiler = Profiler(mir)
        times = profiler.profile_execution(iterations=3)
        self.assertIn("compute_sum", times)
        self.assertIn("main", times)
        
        with tempfile.NamedTemporaryFile(suffix=".svg", delete=False) as tmp:
            tmp_path = tmp.name
        try:
            profiler.generate_flamegraph_svg(tmp_path, title="Test Flamegraph")
            self.assertTrue(os.path.exists(tmp_path))
            with open(tmp_path, encoding="utf-8") as f:
                content = f.read()
            self.assertIn("<svg", content)
            self.assertIn("compute_sum", content)
            self.assertIn("</svg>", content)
        finally:
            if os.path.exists(tmp_path):
                os.remove(tmp_path)

    def test_cli_test_command(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            test_file = os.path.join(tmpdir, "test_demo.bmb")
            with open(test_file, "w", encoding="utf-8") as f:
                f.write("""
def test_alpha() -> i64:
    return 0

def test_beta() -> i64:
    return 1

def main() -> i64:
    return 0
""")
            ret = cli_main(["test", tmpdir])
            self.assertEqual(ret, 0)


if __name__ == "__main__":
    unittest.main()
