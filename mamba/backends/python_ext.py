"""Backward compatibility shim forwarding to tinytalk.backends.python_ext."""
import sys
import tinytalk.backends.python_ext as _target
from tinytalk.backends.python_ext import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
