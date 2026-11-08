"""Backward compatibility shim forwarding to tinytalk.autograd."""
import sys
import tinytalk.autograd as _target
from tinytalk.autograd import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
