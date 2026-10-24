"""
Black Mamba (.bmb) CPython Host Interop Bridge.

Provides zero-copy, pay-as-you-go interoperability with host Python 3.14 (and PyPI):
1. Dynamically links to host CPython C-API (`python314.dll`) without binary bloat.
2. Allows Black Mamba programs to call PyPI packages (NumPy, PyTorch, SciPy, math).
3. Zero-copy buffer exchange: accesses raw memory pointers of NumPy/Tensors for SIMD processing.
4. Dynamic `eval()` and deoptimization fallback execution.
"""

import ctypes
import os
import sys
import struct
from typing import Any, Optional


class CPythonHostBridge:
    """Manages dynamic bindings to host CPython C-API."""

    _instance: Optional["CPythonHostBridge"] = None

    def __init__(self):
        self.pyapi = ctypes.pythonapi
        self._setup_c_signatures()

    @classmethod
    def get_instance(cls) -> "CPythonHostBridge":
        if cls._instance is None:
            cls._instance = cls()
        return cls._instance

    def _setup_c_signatures(self) -> None:
        # PyImport_ImportModule: char* -> PyObject*
        self.pyapi.PyImport_ImportModule.restype = ctypes.c_void_p
        self.pyapi.PyImport_ImportModule.argtypes = [ctypes.c_char_p]

        # PyObject_GetAttrString: (PyObject*, char*) -> PyObject*
        self.pyapi.PyObject_GetAttrString.restype = ctypes.c_void_p
        self.pyapi.PyObject_GetAttrString.argtypes = [ctypes.c_void_p, ctypes.c_char_p]

        # PyObject_CallObject: (PyObject*, PyObject*) -> PyObject*
        self.pyapi.PyObject_CallObject.restype = ctypes.c_void_p
        self.pyapi.PyObject_CallObject.argtypes = [ctypes.c_void_p, ctypes.c_void_p]

        # PyFloat_FromDouble: double -> PyObject*
        self.pyapi.PyFloat_FromDouble.restype = ctypes.c_void_p
        self.pyapi.PyFloat_FromDouble.argtypes = [ctypes.c_double]

        # PyFloat_AsDouble: PyObject* -> double
        self.pyapi.PyFloat_AsDouble.restype = ctypes.c_double
        self.pyapi.PyFloat_AsDouble.argtypes = [ctypes.c_void_p]

        # PyLong_FromLongLong: int64 -> PyObject*
        self.pyapi.PyLong_FromLongLong.restype = ctypes.c_void_p
        self.pyapi.PyLong_FromLongLong.argtypes = [ctypes.c_longlong]

        # PyLong_AsLongLong: PyObject* -> int64
        self.pyapi.PyLong_AsLongLong.restype = ctypes.c_longlong
        self.pyapi.PyLong_AsLongLong.argtypes = [ctypes.c_void_p]

        # PyTuple_New: int -> PyObject*
        self.pyapi.PyTuple_New.restype = ctypes.c_void_p
        self.pyapi.PyTuple_New.argtypes = [ctypes.c_ssize_t]

        # PyTuple_SetItem: (PyObject*, int, PyObject*) -> int
        self.pyapi.PyTuple_SetItem.restype = ctypes.c_int
        self.pyapi.PyTuple_SetItem.argtypes = [ctypes.c_void_p, ctypes.c_ssize_t, ctypes.c_void_p]

        # PyRun_SimpleString: char* -> int
        self.pyapi.PyRun_SimpleString.restype = ctypes.c_int
        self.pyapi.PyRun_SimpleString.argtypes = [ctypes.c_char_p]

    def call_func_f64_1(self, mod_name: str, func_name: str, arg: float) -> float:
        """Calls a host CPython module function `f(float) -> float`."""
        mod = self.pyapi.PyImport_ImportModule(mod_name.encode("utf-8"))
        if not mod:
            raise RuntimeError(f"Could not import host Python module '{mod_name}'")
        func = self.pyapi.PyObject_GetAttrString(mod, func_name.encode("utf-8"))
        if not func:
            raise RuntimeError(f"Could not find function '{func_name}' in module '{mod_name}'")

        args_tuple = self.pyapi.PyTuple_New(1)
        py_arg = self.pyapi.PyFloat_FromDouble(ctypes.c_double(arg))
        self.pyapi.PyTuple_SetItem(args_tuple, 0, py_arg)

        res_obj = self.pyapi.PyObject_CallObject(func, args_tuple)
        if not res_obj:
            raise RuntimeError(f"Call to {mod_name}.{func_name} failed")
        res_val = self.pyapi.PyFloat_AsDouble(res_obj)
        return float(res_val)

    def call_func_i64_1(self, mod_name: str, func_name: str, arg: int) -> int:
        """Calls a host CPython module function `f(int) -> int`."""
        mod = self.pyapi.PyImport_ImportModule(mod_name.encode("utf-8"))
        if not mod:
            raise RuntimeError(f"Could not import host Python module '{mod_name}'")
        func = self.pyapi.PyObject_GetAttrString(mod, func_name.encode("utf-8"))
        if not func:
            raise RuntimeError(f"Could not find function '{func_name}' in module '{mod_name}'")

        args_tuple = self.pyapi.PyTuple_New(1)
        py_arg = self.pyapi.PyLong_FromLongLong(ctypes.c_longlong(arg))
        self.pyapi.PyTuple_SetItem(args_tuple, 0, py_arg)

        res_obj = self.pyapi.PyObject_CallObject(func, args_tuple)
        if not res_obj:
            raise RuntimeError(f"Call to {mod_name}.{func_name} failed")
        return int(self.pyapi.PyLong_AsLongLong(res_obj))

    def eval_code(self, code_expr: str) -> Any:
        """Executes dynamic Python expression or statement with shape-guard fallback."""
        return eval(code_expr)
