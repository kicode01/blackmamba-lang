"""Backward compatibility shim forwarding to tinytalk.lsp.server."""
import sys
import tinytalk.lsp.server as _target
from tinytalk.lsp.server import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
