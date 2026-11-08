"""Backward compatibility shim forwarding to tinytalk.contracts."""
import sys
import tinytalk.contracts as _target
from tinytalk.contracts import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
