"""Backward compatibility shim forwarding to tinytalk.fuzzer."""
import sys
import tinytalk.fuzzer as _target
from tinytalk.fuzzer import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
