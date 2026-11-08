"""Backward compatibility shim forwarding to tinytalk.container."""
import sys
import tinytalk.container as _target
from tinytalk.container import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
