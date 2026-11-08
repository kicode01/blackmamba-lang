"""Backward compatibility shim forwarding to tinytalk.canvas."""
import sys
import tinytalk.canvas as _target
from tinytalk.canvas import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
