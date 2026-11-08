#!/usr/bin/env python3
"""
Black Mamba (bmb) Legacy CLI Compatibility Wrapper.
Delegates seamlessly to TinyTalk (tinytalk / tnt).
"""

import sys
from tinytalk.cli import main

if __name__ == "__main__":
    sys.exit(main())
