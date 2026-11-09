"""Backward compatibility shim forwarding to tinytalk.planet."""
import sys
import tinytalk.planet as _target
from tinytalk.planet import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target
