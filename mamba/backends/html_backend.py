"""Backward compatibility shim forwarding to tinytalk.backends.html_backend."""
import sys
import tinytalk.backends.html_backend as _target
from tinytalk.backends.html_backend import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
