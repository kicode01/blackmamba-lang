"""Backward compatibility shim forwarding to tinytalk.replay."""
import sys
import tinytalk.replay as _target
from tinytalk.replay import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
