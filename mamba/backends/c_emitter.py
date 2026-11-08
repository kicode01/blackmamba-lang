"""Backward compatibility shim forwarding to tinytalk.backends.c_emitter."""
import sys
import tinytalk.backends.c_emitter as _target
from tinytalk.backends.c_emitter import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
