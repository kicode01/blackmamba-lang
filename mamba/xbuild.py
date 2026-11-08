"""Backward compatibility shim forwarding to tinytalk.xbuild."""
import sys
import tinytalk.xbuild as _target
from tinytalk.xbuild import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
