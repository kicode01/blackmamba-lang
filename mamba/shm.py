"""Backward compatibility shim forwarding to tinytalk.shm."""
import sys
import tinytalk.shm as _target
from tinytalk.shm import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
