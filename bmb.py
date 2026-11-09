#!/usr/bin/env python3
"""
TinyTalk Legacy CLI Compatibility Shim.
Redirects legacy 'bmb' invocations to TinyTalk (tnt).
"""
import sys
from tinytalk.cli import main

if __name__ == "__main__":
    sys.exit(main())
