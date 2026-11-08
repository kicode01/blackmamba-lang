"""Backward compatibility shim forwarding to tinytalk.deploy."""
import sys
import tinytalk.deploy as _target
from tinytalk.deploy import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
