"""Backward compatibility shim forwarding to tinytalk.image."""
import sys
import tinytalk.image as _target
from tinytalk.image import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
