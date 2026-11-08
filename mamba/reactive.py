"""Backward compatibility shim forwarding to tinytalk.reactive."""
import sys
import tinytalk.reactive as _target
from tinytalk.reactive import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
