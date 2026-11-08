"""Backward compatibility shim forwarding to tinytalk.kernel."""
import sys
import tinytalk.kernel as _target
from tinytalk.kernel import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
