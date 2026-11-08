"""Backward compatibility shim forwarding to tinytalk.transmute."""
import sys
import tinytalk.transmute as _target
from tinytalk.transmute import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
