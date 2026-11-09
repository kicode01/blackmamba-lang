"""Backward compatibility shim forwarding to tinytalk.consensus."""
import sys
import tinytalk.consensus as _target
from tinytalk.consensus import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target
