"""Backward compatibility shim forwarding to tinytalk.rdma."""
import sys
import tinytalk.rdma as _target
from tinytalk.rdma import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target
