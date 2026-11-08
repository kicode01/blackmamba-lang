"""Backward compatibility shim forwarding to tinytalk.project."""
import sys
import tinytalk.project as _target
from tinytalk.project import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
