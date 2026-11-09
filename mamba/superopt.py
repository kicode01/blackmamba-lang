"""
Backward compatibility shim: mamba.superopt -> tinytalk.superopt
"""
import sys
import tinytalk.superopt as _target

sys.modules[__name__] = _target
