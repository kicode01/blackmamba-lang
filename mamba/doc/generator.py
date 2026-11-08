"""Backward compatibility shim forwarding to tinytalk.doc.generator."""
import sys
import tinytalk.doc.generator as _target
from tinytalk.doc.generator import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
