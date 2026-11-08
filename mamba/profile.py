"""Backward compatibility shim forwarding to tinytalk.profile."""
import sys
import tinytalk.profile as _target
from tinytalk.profile import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
