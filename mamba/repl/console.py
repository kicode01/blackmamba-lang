"""Backward compatibility shim forwarding to tinytalk.repl.console."""
import sys
import tinytalk.repl.console as _target
from tinytalk.repl.console import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
