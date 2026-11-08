"""
Black Mamba (mamba / .bmb) Backward Compatibility Shim.
All functionality is now natively powered by TinyTalk (tinytalk / .tnt).
This module ensures 100% seamless backward compatibility for existing codebases.
"""
import sys
import tinytalk
from tinytalk import *

# Mirror attributes
__version__ = tinytalk.__version__
__author__ = tinytalk.__author__

# Dynamic submodule redirect
class _MambaProxy:
    def __init__(self, target_pkg):
        self._target = target_pkg

    def __getattr__(self, name):
        return getattr(self._target, name)

# Ensure sys.modules["mamba"] behaves as tinytalk
sys.modules[__name__] = tinytalk
