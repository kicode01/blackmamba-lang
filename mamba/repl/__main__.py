"""
CLI entry point for Black Mamba Interactive REPL: `python -m mamba.repl`.
"""

import sys
from .console import run_repl


def main():
    sys.exit(run_repl())


if __name__ == "__main__":
    main()
