"""
Backward compatibility shim: mamba.pgo -> tinytalk.pgo
"""
import sys
import tinytalk.pgo as _target

sys.modules[__name__] = _target
