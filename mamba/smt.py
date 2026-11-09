"""
Backward compatibility shim: mamba.smt -> tinytalk.smt
"""
import sys
import tinytalk.smt as _target

sys.modules[__name__] = _target
