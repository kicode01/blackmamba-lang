"""Backward compatibility shim forwarding to tinytalk.provenance."""
import sys
import tinytalk.provenance as _target
from tinytalk.provenance import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
