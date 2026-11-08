"""Backward compatibility shim forwarding to tinytalk.pkg.manager."""
import sys
import tinytalk.pkg.manager as _target
from tinytalk.pkg.manager import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
