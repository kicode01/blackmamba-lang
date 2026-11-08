"""Backward compatibility shim forwarding to tinytalk.bindgen."""
import sys
import tinytalk.bindgen as _target
from tinytalk.bindgen import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
