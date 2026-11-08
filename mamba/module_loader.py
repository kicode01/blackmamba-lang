"""Backward compatibility shim forwarding to tinytalk.module_loader."""
import sys
import tinytalk.module_loader as _target
from tinytalk.module_loader import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
