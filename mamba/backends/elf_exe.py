"""Backward compatibility shim forwarding to tinytalk.backends.elf_exe."""
import sys
import tinytalk.backends.elf_exe as _target
from tinytalk.backends.elf_exe import *

# Forward module directly in sys.modules
sys.modules[__name__] = _target

if __name__ == "__main__":
    if hasattr(_target, "main"):
        sys.exit(_target.main())
