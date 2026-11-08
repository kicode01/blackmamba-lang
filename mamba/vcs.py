"""Backward compatibility shim forwarding to tinytalk.vcs."""
import sys
import tinytalk.vcs as _target
from tinytalk.vcs import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
