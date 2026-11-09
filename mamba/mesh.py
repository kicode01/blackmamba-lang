"""Backward compatibility shim forwarding to tinytalk.mesh."""
import sys
import tinytalk.mesh as _target
from tinytalk.mesh import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target
