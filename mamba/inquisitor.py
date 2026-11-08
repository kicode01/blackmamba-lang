"""Backward compatibility shim forwarding to tinytalk.inquisitor."""
import sys
import tinytalk.inquisitor as _target
from tinytalk.inquisitor import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
