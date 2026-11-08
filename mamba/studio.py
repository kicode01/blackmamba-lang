"""Backward compatibility shim forwarding to tinytalk.studio."""
import sys
import tinytalk.studio as _target
from tinytalk.studio import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
