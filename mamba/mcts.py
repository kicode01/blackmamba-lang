"""
Backward compatibility shim: mamba.mcts -> tinytalk.mcts
"""
import sys
import tinytalk.mcts as _target

sys.modules[__name__] = _target
