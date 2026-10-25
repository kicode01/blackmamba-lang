"""
Black Mamba (bmb) Interactive REPL Package.
Provides instant bare-metal JIT compilation, live variable state persistence,
and terminal interactive interface.
"""

from .console import run_repl
from .session import ReplResult, ReplSession

__all__ = [
    "ReplSession",
    "ReplResult",
    "run_repl",
]
