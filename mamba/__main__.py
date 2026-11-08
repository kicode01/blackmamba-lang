"""Backward compatibility shim forwarding to tinytalk.__main__."""
import sys
import tinytalk.__main__ as _target
from tinytalk.__main__ import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
