"""Backward compatibility shim forwarding to tinytalk.ocap."""
import sys
import tinytalk.ocap as _target
from tinytalk.ocap import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
