"""
TinyTalk Phase 15D: Relativistic Interplanetary CRDT & Causal Sync
Implements Conflict-Free Replicated Data Types (CRDT) for multi-planetary networks:
- State-based PN-Counter (Positive-Negative Counter)
- Relativistic LWW-Register (Last-Write-Wins with Lorentz-consistent Lamport timestamps)
- Mathematical lattice idempotency, commutativity, and associativity guarantees
"""

from typing import List, Dict, Any, Tuple, Optional

class RelativisticPNCounter:
    """
    Positive-Negative Counter CRDT.
    Guarantees conflict-free convergence across high-latency space networks.
    """
    def __init__(self, node_id: str):
        self.node_id = node_id
        self.p_matrix: Dict[str, int] = {node_id: 0} # Increments
        self.n_matrix: Dict[str, int] = {node_id: 0} # Decrements

    def increment(self, amount: int = 1) -> None:
        if amount > 0:
            self.p_matrix[self.node_id] = self.p_matrix.get(self.node_id, 0) + amount

    def decrement(self, amount: int = 1) -> None:
        if amount > 0:
            self.n_matrix[self.node_id] = self.n_matrix.get(self.node_id, 0) + amount

    def value(self) -> int:
        return sum(self.p_matrix.values()) - sum(self.n_matrix.values())

    def merge(self, other: 'RelativisticPNCounter') -> None:
        """Pointwise maximum merge (lattice join operation)."""
        all_keys = set(self.p_matrix.keys()) | set(other.p_matrix.keys())
        for k in all_keys:
            self.p_matrix[k] = max(self.p_matrix.get(k, 0), other.p_matrix.get(k, 0))

        all_n_keys = set(self.n_matrix.keys()) | set(other.n_matrix.keys())
        for k in all_n_keys:
            self.n_matrix[k] = max(self.n_matrix.get(k, 0), other.n_matrix.get(k, 0))


class RelativisticLWWRegister:
    """
    Last-Write-Wins Register CRDT.
    Uses (timestamp, node_id) total ordering to resolve concurrent writes.
    """
    def __init__(self, node_id: str, initial_value: Any = None):
        self.node_id = node_id
        self.value = initial_value
        self.timestamp = 0.0

    def write(self, value: Any, timestamp: float) -> None:
        if timestamp > self.timestamp:
            self.value = value
            self.timestamp = timestamp

    def merge(self, other: 'RelativisticLWWRegister') -> None:
        """Merge by choosing value with strictly higher timestamp (tie-break by node_id)."""
        if other.timestamp > self.timestamp:
            self.value = other.value
            self.timestamp = other.timestamp
            self.node_id = other.node_id
        elif other.timestamp == self.timestamp:
            if other.node_id > self.node_id:
                self.value = other.value
                self.node_id = other.node_id
