"""Backward compatibility shim forwarding to tinytalk.cas."""
import sys
import tinytalk.cas as _target
from tinytalk.cas import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target
