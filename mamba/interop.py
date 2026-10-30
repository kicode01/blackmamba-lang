"""
Black Mamba (.bmb) CPython Host Interop Bridge & Zero-Copy Tensor Exchange.

Provides zero-copy, pay-as-you-go interoperability with host Python (and PyPI):
1. Dynamically links to host CPython C-API without binary bloat.
2. Allows Black Mamba programs to call PyPI packages (NumPy, PyTorch, SciPy, math).
3. Zero-copy tensor buffer exchange: accesses raw memory pointers of NumPy ndarrays,
   PyTorch tensors, and Python buffer protocol objects for direct SIMD/AVX processing.
4. Bidirectional zero-copy views: wraps Black Mamba memory as NumPy/PyTorch arrays.
5. Dynamic `eval()` and deoptimization fallback execution.
"""

import ctypes
import importlib
import os
import sys
import struct
from typing import Any, Optional, Tuple, Dict, List, Union


class Py_buffer(ctypes.Structure):
    """CPython standard buffer protocol descriptor (PEP 3118)."""
    _fields_ = [
        ("buf", ctypes.c_void_p),
        ("obj", ctypes.c_void_p),
        ("len", ctypes.c_ssize_t),
        ("itemsize", ctypes.c_ssize_t),
        ("readonly", ctypes.c_int),
        ("ndim", ctypes.c_int),
        ("format", ctypes.c_char_p),
        ("shape", ctypes.POINTER(ctypes.c_ssize_t)),
        ("strides", ctypes.POINTER(ctypes.c_ssize_t)),
        ("suboffsets", ctypes.POINTER(ctypes.c_ssize_t)),
        ("internal", ctypes.c_void_p),
    ]


PyBUF_SIMPLE = 0
PyBUF_WRITABLE = 0x0001


def try_extract_buffer(obj: Any) -> Optional[Tuple[int, int, int, str]]:
    """
    Attempts to extract (pointer_addr, element_count, itemsize_bytes, format_str)
    from any Python object supporting contiguous memory buffers.
    
    Supports:
    - NumPy ndarray (numpy.ndarray)
    - PyTorch Tensor (torch.Tensor)
    - Python standard array (array.array)
    - memoryview, bytearray, bytes
    - ctypes arrays and pointers
    - Universal PEP 3118 CPython Buffer Protocol
    
    Returns None if obj is not a buffer object.
    """
    if obj is None:
        return None

    # 1. NumPy ndarray / array-like with __array_interface__
    if hasattr(obj, "__array_interface__"):
        try:
            arr_info = obj.__array_interface__
            data = arr_info.get("data")
            if data and data[0]:
                ptr = int(data[0])
                size = int(getattr(obj, "size", 1))
                itemsize = int(getattr(obj, "itemsize", 8))
                dtype_s = str(getattr(obj, "dtype", "float64"))
                return ptr, size, itemsize, dtype_s
        except Exception:
            pass

    # 2. PyTorch Tensor (torch.Tensor)
    if hasattr(obj, "data_ptr") and callable(obj.data_ptr):
        try:
            ptr = int(obj.data_ptr())
            size = int(obj.numel())
            itemsize = int(obj.element_size())
            dtype_s = str(obj.dtype)
            return ptr, size, itemsize, dtype_s
        except Exception:
            pass

    # 3. Python standard library array (array.array)
    if hasattr(obj, "buffer_info") and callable(obj.buffer_info):
        try:
            info = obj.buffer_info()
            ptr = int(info[0])
            count = int(info[1])
            itemsize = int(obj.itemsize)
            typecode = str(getattr(obj, "typecode", "d"))
            return ptr, count, itemsize, typecode
        except Exception:
            pass

    # 4. ctypes Array / Pointer
    if isinstance(obj, ctypes.Array):
        try:
            ptr = ctypes.addressof(obj)
            count = len(obj)
            itemsize = ctypes.sizeof(obj._type_)
            return ptr, count, itemsize, "ctypes"
        except Exception:
            pass

    if isinstance(obj, (ctypes._Pointer, ctypes.c_void_p)):
        try:
            ptr = ctypes.cast(obj, ctypes.c_void_p).value or 0
            return ptr, 1, 8, "pointer"
        except Exception:
            pass

    # 5. memoryview, bytearray, bytes
    if isinstance(obj, (memoryview, bytearray, bytes)):
        try:
            buf_view = memoryview(obj)
            ptr = ctypes.addressof(ctypes.c_char.from_buffer(buf_view))
            itemsize = int(getattr(buf_view, "itemsize", 1))
            count = len(buf_view)
            fmt = str(getattr(buf_view, "format", "B"))
            return ptr, count, itemsize, fmt
        except Exception:
            pass

    # 6. Fallback to CPython Buffer Protocol via ctypes.pythonapi
    try:
        pyapi = ctypes.pythonapi
        view = Py_buffer()
        res = pyapi.PyObject_GetBuffer(ctypes.py_object(obj), ctypes.byref(view), PyBUF_SIMPLE)
        if res == 0 and view.buf:
            ptr = int(view.buf)
            itemsize = max(1, int(view.itemsize))
            count = int(view.len) // itemsize
            fmt = view.format.decode("utf-8") if view.format else "B"
            pyapi.PyBuffer_Release(ctypes.byref(view))
            return ptr, count, itemsize, fmt
    except Exception:
        pass

    return None


def as_numpy_array(ptr: int, shape: Union[int, Tuple[int, ...]], dtype: str = "float64") -> Any:
    """
    Constructs a zero-copy NumPy ndarray viewing the raw memory address `ptr`.
    Any mutation to this array directly modifies Black Mamba memory.
    """
    import numpy as np

    c_type_map = {
        "float64": ctypes.c_double,
        "f64": ctypes.c_double,
        "float": ctypes.c_double,
        "int64": ctypes.c_int64,
        "i64": ctypes.c_int64,
        "int": ctypes.c_int64,
        "int32": ctypes.c_int32,
        "i32": ctypes.c_int32,
        "uint8": ctypes.c_uint8,
        "bool": ctypes.c_bool,
    }
    c_type = c_type_map.get(str(dtype), ctypes.c_double)
    if isinstance(shape, int):
        total_elements = shape
        shape_tuple = (shape,)
    else:
        shape_tuple = tuple(shape)
        total_elements = 1
        for d in shape_tuple:
            total_elements *= d

    arr_c = (c_type * total_elements).from_address(ptr)
    np_arr = np.ctypeslib.as_array(arr_c)
    if len(shape_tuple) > 1:
        return np_arr.reshape(shape_tuple)
    return np_arr


def as_torch_tensor(ptr: int, shape: Union[int, Tuple[int, ...]], dtype: Optional[Any] = None) -> Any:
    """
    Constructs a zero-copy PyTorch tensor viewing the raw memory address `ptr`.
    Requires PyTorch (`import torch`).
    """
    try:
        import torch
    except ImportError:
        raise ImportError("PyTorch is not installed in the current environment")

    np_view = as_numpy_array(ptr, shape, dtype="float64")
    t = torch.from_numpy(np_view)
    if dtype is not None and t.dtype != dtype:
        return t.to(dtype)
    return t


class CPythonHostBridge:
    """Manages dynamic bindings to host CPython C-API and Tensor Exchange."""

    _instance: Optional["CPythonHostBridge"] = None

    def __init__(self):
        self.pyapi = ctypes.pythonapi
        self._tensor_registry: Dict[int, Any] = {}
        self._named_tensors: Dict[str, Any] = {}
        self._obj_registry: Dict[int, Any] = {}
        self._next_handle: int = 1000
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

    def eval_tensor(self, code_expr: str) -> Tuple[int, int, int]:
        """
        Evaluates a Python expression returning a NumPy array or PyTorch tensor.
        Retains a strong reference to prevent GC while in native execution.
        Returns (ptr: int, count: int, itemsize: int).
        """
        env = {
            "sys": sys,
            "os": os,
            "bridge": self,
            "self": self,
        }
        env.update(self._named_tensors)
        try:
            import numpy as np
            env["np"] = np
            env["numpy"] = np
        except ImportError:
            pass
        try:
            import torch
            env["torch"] = torch
        except ImportError:
            pass

        obj = eval(code_expr, env)
        info = try_extract_buffer(obj)
        if info is None:
            raise TypeError(f"Expression {code_expr!r} did not evaluate to a contiguous buffer or tensor")
        ptr, count, itemsize, _ = info
        self._tensor_registry[ptr] = obj
        return ptr, count, itemsize

    def register_tensor(self, name: str, obj: Any) -> int:
        """Registers a named Python tensor and returns its raw pointer."""
        info = try_extract_buffer(obj)
        if info is None:
            raise TypeError(f"Object {name!r} is not a valid contiguous buffer or tensor")
        ptr, _, _, _ = info
        self._named_tensors[name] = obj
        self._tensor_registry[ptr] = obj
        return ptr

    def get_registered_tensor(self, name: str) -> Optional[Any]:
        return self._named_tensors.get(name)

    def release_tensor(self, ptr: int) -> None:
        self._tensor_registry.pop(ptr, None)

    def register_object(self, obj: Any) -> int:
        if obj is None:
            return 0
        h = self._next_handle
        self._next_handle += 1
        self._obj_registry[h] = obj
        return h

    def get_object(self, handle: int) -> Optional[Any]:
        return self._obj_registry.get(handle)

    def release_object(self, handle: int) -> None:
        self._obj_registry.pop(handle, None)

    def call_func_any(self, mod_name: str, func_name: str, *args) -> Any:
        try:
            mod = importlib.import_module(mod_name)
        except ImportError as e:
            raise RuntimeError(f"Could not import Python module '{mod_name}': {e}")
        func = getattr(mod, func_name, None)
        if func is None:
            raise RuntimeError(f"Could not find function '{func_name}' in Python module '{mod_name}'")
        return func(*args)

    def getattr_any(self, handle_or_mod: Union[int, str], attr_name: str) -> Any:
        if isinstance(handle_or_mod, str):
            mod = importlib.import_module(handle_or_mod)
            return getattr(mod, attr_name)
        obj = self._obj_registry.get(handle_or_mod)
        if obj is None:
            raise RuntimeError(f"Invalid Python object handle: {handle_or_mod}")
        return getattr(obj, attr_name)

    def setattr_any(self, handle: int, attr_name: str, val: Any) -> None:
        obj = self._obj_registry.get(handle)
        if obj is None:
            raise RuntimeError(f"Invalid Python object handle: {handle}")
        setattr(obj, attr_name, val)

    def call_method_any(self, handle: int, method_name: str, *args) -> Any:
        obj = self._obj_registry.get(handle)
        if obj is None:
            raise RuntimeError(f"Invalid Python object handle: {handle}")
        method = getattr(obj, method_name, None)
        if method is None:
            raise RuntimeError(f"Object {type(obj).__name__} has no method '{method_name}'")
        return method(*args)

