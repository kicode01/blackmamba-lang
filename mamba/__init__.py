"""
Black Mamba (mamba / .bmb) Backward Compatibility Shim.
All functionality is now natively powered by TinyTalk (tinytalk / .tnt).
This module ensures 100% seamless backward compatibility for existing codebases.
"""
import sys
import importlib
import pkgutil
import tinytalk
from tinytalk import *

# Mirror attributes
__version__ = tinytalk.__version__
__author__ = tinytalk.__author__

# Ensure sys.modules["mamba"] is tinytalk and all submodules are synchronized
sys.modules[__name__] = tinytalk

if hasattr(tinytalk, "__path__"):
    for mod_info in pkgutil.walk_packages(tinytalk.__path__, "tinytalk."):
        tnt_name = mod_info.name
        bmb_name = "mamba." + tnt_name[9:]
        try:
            m = importlib.import_module(tnt_name)
            sys.modules[bmb_name] = m
        except Exception:
            pass
