"""Backward compatibility shim forwarding to tinytalk.parser."""
import sys
import tinytalk.parser as _target
from tinytalk.parser import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
