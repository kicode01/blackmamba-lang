"""Backward compatibility shim forwarding to tinytalk.pkg.lock."""
import sys
import tinytalk.pkg.lock as _target
from tinytalk.pkg.lock import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
