"""
Black Mamba (mamba / .bmb) Backward Compatibility Shim.
All functionality is now natively powered by TinyTalk (tinytalk / .tnt).
This module ensures 100% seamless backward compatibility for existing codebases.
"""
import sys
import importlib
import tinytalk
from tinytalk import *

# Mirror attributes
__version__ = tinytalk.__version__
__author__ = tinytalk.__author__

def __getattr__(name: str):
    """Dynamically forward submodule lookups on mamba to tinytalk."""
    if hasattr(tinytalk, name):
        return getattr(tinytalk, name)
    try:
        mod = importlib.import_module(f"tinytalk.{name}")
        sys.modules[f"mamba.{name}"] = mod
        return mod
    except ImportError:
        raise AttributeError(f"module 'mamba' has no attribute '{name}'")
