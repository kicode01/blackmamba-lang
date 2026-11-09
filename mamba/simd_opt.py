"""
Backward compatibility shim: mamba.simd_opt -> tinytalk.simd_opt
"""
import sys
import tinytalk.simd_opt as _target

sys.modules[__name__] = _target
