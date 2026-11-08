"""Backward compatibility shim forwarding to tinytalk.gatekeeper."""
import sys
import tinytalk.gatekeeper as _target
from tinytalk.gatekeeper import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
