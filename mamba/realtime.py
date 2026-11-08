"""Backward compatibility shim forwarding to tinytalk.realtime."""
import sys
import tinytalk.realtime as _target
from tinytalk.realtime import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
