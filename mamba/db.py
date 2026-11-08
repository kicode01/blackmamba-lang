"""Backward compatibility shim forwarding to tinytalk.db."""
import sys
import tinytalk.db as _target
from tinytalk.db import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
