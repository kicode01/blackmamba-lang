"""Backward compatibility shim forwarding to tinytalk.orchestrator."""
import sys
import tinytalk.orchestrator as _target
from tinytalk.orchestrator import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
