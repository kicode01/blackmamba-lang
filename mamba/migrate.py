"""Backward compatibility shim forwarding to tinytalk.migrate."""
import sys
import tinytalk.migrate as _target
from tinytalk.migrate import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
