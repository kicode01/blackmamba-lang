"""Backward compatibility shim forwarding to tinytalk.web."""
import sys
import tinytalk.web as _target
from tinytalk.web import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
