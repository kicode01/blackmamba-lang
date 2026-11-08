"""Backward compatibility shim forwarding to tinytalk.wcet."""
import sys
import tinytalk.wcet as _target
from tinytalk.wcet import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
