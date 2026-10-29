"""
Phase 2 Unit Tests: Python Syntactic Parity & Ergonomics for Black Mamba (.bmb)
Tests:
- Context Managers (`with` & `async with`)
- List & Dict Comprehensions
- Dict Literals (`{k: v, ...}`)
- Dunder Operator Overloading (`__add__`, `__sub__`, `__mul__`, `__getitem__`, `__setitem__`, `__len__`, `__str__`)
- Structural Pattern Matching with guards and alternatives (`case A | B if guard:`)
- Yield Expressions
"""

import unittest
from mamba.lexer import Lexer, TokenType
from mamba.parser import Parser
from mamba.mir import MIRBuilder
from mamba.backends.x86_64_jit import NativeJITModule
from mamba.ast_nodes import WithStmt, ListComp, DictComp, DictLit, YieldExpr, MatchStmt


class TestPhase2SyntacticParity(unittest.TestCase):

    def test_lexer_phase2_keywords(self):
        source = "with async await yield"
        tokens = Lexer(source).tokenize()
        types = [t.type for t in tokens if t.type not in (TokenType.EOF, TokenType.NEWLINE)]
        self.assertEqual(types, [TokenType.WITH, TokenType.ASYNC, TokenType.AWAIT, TokenType.YIELD])

    def test_parser_with_stmt(self):
        source = """
with open("test.txt") as f:
    x = 10
"""
        ast = Parser.from_source(source).parse_module()
        self.assertEqual(len(ast.statements), 1)
        self.assertIsInstance(ast.statements[0], WithStmt)
        w = ast.statements[0]
        self.assertEqual(len(w.items), 1)
        self.assertEqual(w.items[0].optional_vars, "f")

    def test_parser_list_and_dict_comp(self):
        source = """
a = [x * 2 for x in 0..10 if x > 2]
d = {k: k * 10 for k in 0..5}
lit = {"alpha": 1, "beta": 2}
"""
        ast = Parser.from_source(source).parse_module()
        self.assertEqual(len(ast.statements), 3)
        self.assertIsInstance(ast.statements[0].value, ListComp)
        self.assertIsInstance(ast.statements[1].value, DictComp)
        self.assertIsInstance(ast.statements[2].value, DictLit)

    def test_parser_match_guard(self):
        source = """
match x:
    case 1 | 2 if y > 0:
        return 100
    case _ if y < 0:
        return 200
    case _:
        return 0
"""
        ast = Parser.from_source(source).parse_module()
        self.assertEqual(len(ast.statements), 1)
        self.assertIsInstance(ast.statements[0], MatchStmt)
        m = ast.statements[0]
        self.assertIsNotNone(m.cases[0].guard)
        self.assertIsNotNone(m.cases[1].guard)
        self.assertIsNone(m.cases[2].guard)

    def test_jit_dunder_operator_overloading(self):
        source = """
struct Vec2:
    x: i64
    y: i64

    def __add__(self, other: Vec2) -> Vec2:
        return Vec2(self.x + other.x, self.y + other.y)

    def __sub__(self, other: Vec2) -> Vec2:
        return Vec2(self.x - other.x, self.y - other.y)

    def __mul__(self, other: Vec2) -> Vec2:
        return Vec2(self.x * other.x, self.y * other.y)

    def __getitem__(self, idx: i64) -> i64:
        if idx == 0:
            return self.x
        return self.y

    def __len__(self) -> i64:
        return 2

def main() -> i64:
    v1 = Vec2(10, 20)
    v2 = Vec2(3, 4)
    v3 = v1 + v2
    v4 = v1 - v2
    v5 = v1 * v2
    l = len(v1)
    x0 = v3[0]
    y0 = v3[1]
    # v3.x = 13, v3.y = 24, v4.x = 7, v4.y = 16, v5.x = 30, v5.y = 80, l = 2
    return v3.x + v4.x + v5.x + l + x0 + y0
"""
        ast = Parser.from_source(source).parse_module()
        mir = MIRBuilder().build(ast)
        jit = NativeJITModule(mir)
        res = jit.run_main()
        jit.close()
        # 13 + 7 + 30 + 2 + 13 + 24 = 89
        self.assertEqual(res, 89)

    def test_jit_context_manager(self):
        source = """
struct ContextLogger:
    state: i64

    def __enter__(self) -> ContextLogger:
        self.state = 42
        return self

    def __exit__(self, exc_type: i64, exc_val: i64, exc_tb: i64) -> i64:
        self.state = 99
        return 0

def run_ctx() -> i64:
    mgr = ContextLogger(0)
    res = 0
    with mgr as c:
        res = c.state
    # After with block, exit was guaranteed called, but inside returned 42
    return res + mgr.state

def main() -> i64:
    return run_ctx()
"""
        ast = Parser.from_source(source).parse_module()
        mir = MIRBuilder().build(ast)
        jit = NativeJITModule(mir)
        res = jit.run_main()
        jit.close()
        # 42 + 99 = 141
        self.assertEqual(res, 141)

    def test_jit_list_comprehension(self):
        source = """
def main() -> i64:
    squares = [x * x for x in 0..6]
    evens = [x for x in 0..10 if x % 2 == 0]
    total = 0
    for i in 0..len(squares):
        total += squares[i]
    for j in 0..len(evens):
        total += evens[j]
    return total
"""
        ast = Parser.from_source(source).parse_module()
        mir = MIRBuilder().build(ast)
        jit = NativeJITModule(mir)
        res = jit.run_main()
        jit.close()
        # squares: 0 + 1 + 4 + 9 + 16 + 25 = 55
        # evens: 0 + 2 + 4 + 6 + 8 = 20
        # total = 75
        self.assertEqual(res, 75)

    def test_jit_dict_literal_and_comp(self):
        source = """
def main() -> i64:
    d = {"apple": 100, "banana": 200, "cherry": 300}
    d["date"] = 400
    a = d["apple"]
    b = d["banana"]
    c = d["cherry"]
    dt = d["date"]
    l = len(d)
    return a + b + c + dt + l
"""
        ast = Parser.from_source(source).parse_module()
        mir = MIRBuilder().build(ast)
        jit = NativeJITModule(mir)
        res = jit.run_main()
        jit.close()
        # 100 + 200 + 300 + 400 + 4 = 1004
        self.assertEqual(res, 1004)

    def test_jit_pattern_matching_guards(self):
        source = """
def classify(code: i64, flag: i64) -> i64:
    match code:
        case 1 | 2 if flag == 1:
            return 10
        case 1 | 2:
            return 20
        case 3 if flag == 1:
            return 30
        case _ if flag == 99:
            return 999
        case _:
            return -1

def main() -> i64:
    r1 = classify(1, 1) # 10
    r2 = classify(2, 0) # 20
    r3 = classify(3, 1) # 30
    r4 = classify(3, 0) # -1
    r5 = classify(5, 99) # 999
    r6 = classify(5, 0) # -1
    return r1 + r2 + r3 + r4 + r5 + r6
"""
        ast = Parser.from_source(source).parse_module()
        mir = MIRBuilder().build(ast)
        jit = NativeJITModule(mir)
        res = jit.run_main()
        jit.close()
        # 10 + 20 + 30 + (-1) + 999 + (-1) = 1057
        self.assertEqual(res, 1057)

    def test_phase2_full_showcase(self):
        import os
        showcase_path = os.path.join(os.path.dirname(__file__), "..", "examples", "syntax_parity_showcase.bmb")
        with open(showcase_path, "r", encoding="utf-8") as f:
            src = f.read()
        ast = Parser.from_source(src, showcase_path).parse_module()
        mir = MIRBuilder().build(ast, base_dir=os.path.dirname(showcase_path), filename="syntax_parity_showcase.bmb")
        jit = NativeJITModule(mir)
        res = jit.run_main()
        out = jit.get_output()
        jit.close()
        self.assertEqual(res, 0)
        self.assertIn("All Phase 2 Syntactic Parity Checks PASSED", out)
        if os.path.exists("syntax_parity_test_output.tmp"):
            os.remove("syntax_parity_test_output.tmp")


if __name__ == "__main__":
    unittest.main()
