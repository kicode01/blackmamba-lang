"""Backward compatibility shim forwarding to tinytalk.repl.session."""
import sys
import tinytalk.repl.session as _target
from tinytalk.repl.session import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
