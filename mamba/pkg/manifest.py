"""Backward compatibility shim forwarding to tinytalk.pkg.manifest."""
import sys
import tinytalk.pkg.manifest as _target
from tinytalk.pkg.manifest import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
