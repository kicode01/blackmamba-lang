"""
Phase 3 Unit Tests: Universal Python Bridge, Drop-In Execution & PyPI Ecosystem Parity
Tests:
- Transparent Python Bridge (`from python import ...`, `from python.<pkg> import ...`)
- Python Dynamic Evaluation Intrinsics (`py_eval`, `py_eval_f64`, `py_eval_str`)
- Python-to-Black Mamba Automated Migration Engine (`mamba.migrate`)
- Native Top-PyPI Parity Modules (`requests.bmb`, `pydantic.bmb`, `fastapi.bmb`, `pytest.bmb`)
- Drop-In Python (.py) Script Execution
"""

import os
import sys
import tempfile
import unittest
from mamba.parser import Parser
from mamba.mir import MIRBuilder
from mamba.backends.x86_64_jit import NativeJITModule
from mamba.migrate import migrate_source, PythonToMambaMigrator
from mamba.cli import compile_source_to_mir


class TestPhase3BridgeAndMigrate(unittest.TestCase):

    def _run_mamba(self, source: str) -> int:
        mir = compile_source_to_mir(source, "<test_phase3.bmb>")
        jit = NativeJITModule(mir)
        try:
            return jit.run_main()
        finally:
            jit.close()

    # --- 1. Python Bridge & Host Interop ---

    def test_python_bridge_math_sqrt(self):
        source = """
from python import math
def main() -> i64:
    r: f64 = math.sqrt(100.0)
    if r == 10.0:
        return 42
    return 0
"""
        code = self._run_mamba(source)
        self.assertEqual(code, 42)

    def test_python_bridge_from_import(self):
        source = """
from python.math import sqrt
def main() -> i64:
    r: f64 = sqrt(81.0)
    if r == 9.0:
        return 77
    return 0
"""
        code = self._run_mamba(source)
        self.assertEqual(code, 77)

    def test_python_bridge_py_eval(self):
        source = """
def main() -> i64:
    res: i64 = py_eval("15 * 4 + 2")
    return res
"""
        code = self._run_mamba(source)
        self.assertEqual(code, 62)

    def test_python_bridge_py_eval_f64(self):
        source = """
def main() -> i64:
    res: f64 = py_eval_f64("2.5 * 4.0")
    if res == 10.0:
        return 1
    return 0
"""
        code = self._run_mamba(source)
        self.assertEqual(code, 1)

    def test_python_bridge_py_eval_str(self):
        source = """
from python import sys
def main() -> i64:
    s: str = py_eval_str("sys.platform")
    if len(s) > 0:
        return 100
    return 0
"""
        code = self._run_mamba(source)
        self.assertEqual(code, 100)

    # --- 2. Automated Migration Engine ---

    def test_migrator_class_to_struct(self):
        py_code = '''
class Point:
    def __init__(self, x: float, y: float):
        self.x = x
        self.y = y

    def norm(self) -> float:
        return (self.x * self.x + self.y * self.y) ** 0.5
'''
        bmb_code, report = migrate_source(py_code)
        self.assertIn("struct Point:", bmb_code)
        self.assertIn("x: f64", bmb_code)
        self.assertIn("y: f64", bmb_code)
        self.assertIn("def norm(self) -> f64:", bmb_code)
        self.assertGreater(report["classes_promoted_to_structs"], 0)

    def test_migrator_dataclass_promotion(self):
        py_code = '''
from dataclasses import dataclass

@dataclass
class Vector3D:
    x: float
    y: float
    z: float
'''
        bmb_code, report = migrate_source(py_code)
        self.assertIn("struct Vector3D:", bmb_code)
        self.assertIn("x: f64", bmb_code)
        self.assertIn("y: f64", bmb_code)
        self.assertIn("z: f64", bmb_code)
        self.assertNotIn("@dataclass", bmb_code)

    def test_migrator_type_annotations(self):
        py_code = '''
def add(a: int, b: int) -> int:
    return a + b
'''
        bmb_code, report = migrate_source(py_code)
        self.assertIn("def add(a: i64, b: i64) -> i64:", bmb_code)

    # --- 3. Native Top-PyPI Standard Libraries ---

    def test_native_requests_response(self):
        source = """
from requests import Response
def main() -> i64:
    resp = Response(200, "{\\"msg\\": \\"ok\\"}", True, "Content-Type: application/json")
    if resp.status_code == 200 and resp.ok:
        return 50
    return 0
"""
        code = self._run_mamba(source)
        self.assertEqual(code, 50)

    def test_native_pydantic_validators(self):
        source = """
from pydantic import validate_int_field, validate_str_field, validate_email
def main() -> i64:
    v1 = validate_int_field(30, 0, 100)
    v2 = validate_str_field("antigravity", 3, 20)
    v3 = validate_email("test@blackmamba.dev")
    if v1 and v2 and v3:
        return 99
    return 0
"""
        code = self._run_mamba(source)
        self.assertEqual(code, 99)

    def test_native_fastapi_router(self):
        source = """
from fastapi import new_fastapi
def main() -> i64:
    app = new_fastapi("TestApp", "1.0.0")
    app.get("/ping", "pong")
    app.post("/submit", "received")
    
    res1 = app.dispatch("GET", "/ping")
    res2 = app.dispatch("POST", "/submit")
    res3 = app.dispatch("GET", "/unknown")
    
    if res1 == "pong" and res2 == "received" and res3 == "{\\"detail\\": \\"Not Found\\"}":
        return 123
    return 0
"""
        code = self._run_mamba(source)
        self.assertEqual(code, 123)

    def test_native_pytest_session(self):
        source = """
from pytest import new_test_session
def main() -> i64:
    ts = new_test_session()
    ts.assert_eq_i64(10, 10, "ten equals ten")
    ts.assert_true(True, "truth check")
    if ts.passed == 2 and ts.failed == 0:
        return 88
    return 0
"""
        code = self._run_mamba(source)
        self.assertEqual(code, 88)

    # --- 4. Drop-In Python Execution ---

    def test_dropin_python_file_execution(self):
        py_source = """
def compute(n: int) -> int:
    total = 0
    for i in range(n):
        total += i
    return total

def main() -> int:
    return compute(11)

main()
"""
        with tempfile.NamedTemporaryFile("w", suffix=".py", delete=False, encoding="utf-8") as f:
            f.write(py_source)
            tmp_path = f.name

        try:
            migrated, _ = migrate_source(py_source)
            mir = compile_source_to_mir(migrated, tmp_path)
            jit = NativeJITModule(mir)
            try:
                res = jit.run_main()
                self.assertEqual(res, 55)  # sum 0..10 = 55
            finally:
                jit.close()
        finally:
            if os.path.exists(tmp_path):
                os.remove(tmp_path)


if __name__ == "__main__":
    unittest.main()
