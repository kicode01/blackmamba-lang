"""Backward compatibility shim forwarding to tinytalk.supervisor."""
import sys
import tinytalk.supervisor as _target
from tinytalk.supervisor import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
