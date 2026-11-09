"""
Black Mamba Linearizable Quorum Consensus Shim (v4.2.0)
Backward-compatibility alias pointing directly to tinytalk.consensus.
"""

from tinytalk.consensus import (
    NodeRole,
    LogEntry,
    RaftNode,
    QuorumCluster,
)

__all__ = [
    "NodeRole",
    "LogEntry",
    "RaftNode",
    "QuorumCluster",
]
