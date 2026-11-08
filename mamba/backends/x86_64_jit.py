"""Backward compatibility shim forwarding to tinytalk.backends.x86_64_jit."""
import sys
import tinytalk.backends.x86_64_jit as _target
from tinytalk.backends.x86_64_jit import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
