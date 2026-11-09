"""Backward compatibility shim forwarding to tinytalk.zk."""
import sys
import tinytalk.zk as _target
from tinytalk.zk import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target
