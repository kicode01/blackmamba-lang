"""Backward compatibility shim forwarding to tinytalk.repl."""
import sys
import tinytalk.repl as _target
from tinytalk.repl import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
