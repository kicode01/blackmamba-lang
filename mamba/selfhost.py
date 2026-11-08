"""Backward compatibility shim forwarding to tinytalk.selfhost."""
import sys
import tinytalk.selfhost as _target
from tinytalk.selfhost import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
