"""Backward compatibility shim forwarding to tinytalk.backends.arm64_macho."""
import sys
import tinytalk.backends.arm64_macho as _target
from tinytalk.backends.arm64_macho import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
