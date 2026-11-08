"""Backward compatibility shim forwarding to tinytalk.ast_graph."""
import sys
import tinytalk.ast_graph as _target
from tinytalk.ast_graph import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
