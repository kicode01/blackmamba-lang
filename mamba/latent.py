"""Backward compatibility shim forwarding to tinytalk.latent."""
import sys
import tinytalk.latent as _target
from tinytalk.latent import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
