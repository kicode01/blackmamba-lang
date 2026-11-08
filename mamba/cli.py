"""Backward compatibility shim forwarding to tinytalk.cli."""
import sys
import tinytalk.cli as _target
from tinytalk.cli import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
