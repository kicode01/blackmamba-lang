"""Backward compatibility shim forwarding to tinytalk.backends.gpu_shader."""
import sys
import tinytalk.backends.gpu_shader as _target
from tinytalk.backends.gpu_shader import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
