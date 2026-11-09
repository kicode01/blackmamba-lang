"""Backward compatibility shim forwarding to tinytalk.rpc."""
import sys
import tinytalk.rpc as _target
from tinytalk.rpc import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target
