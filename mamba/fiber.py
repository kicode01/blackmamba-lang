"""Backward compatibility shim forwarding to tinytalk.fiber."""
import sys
import tinytalk.fiber as _target
from tinytalk.fiber import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
