"""TinyTalk Planetary CRDT Substrate (Phase 11B - v4.1.0).

Provides Conflict-Free Replicated Data Types (CRDTs), Causal Vector Clocks,
and Distributed Actor State Synchronization across multi-datacenter clusters
with zero central coordinators.
"""
from __future__ import annotations
import time
import uuid
from typing import Any, Dict, Set, Tuple, Optional


class VectorClock:
    """Causal vector clock for multi-node event ordering and concurrency detection."""

    def __init__(self, clock: Optional[Dict[str, int]] = None) -> None:
        self.clock: Dict[str, int] = dict(clock) if clock else {}

    def increment(self, node_id: str) -> None:
        self.clock[node_id] = self.clock.get(node_id, 0) + 1

    def get(self, node_id: str) -> int:
        return self.clock.get(node_id, 0)

    def clone(self) -> VectorClock:
        return VectorClock(self.clock)

    def merge(self, other: VectorClock) -> VectorClock:
        merged: Dict[str, int] = {}
        all_nodes = set(self.clock.keys()) | set(other.clock.keys())
        for node in all_nodes:
            merged[node] = max(self.clock.get(node, 0), other.clock.get(node, 0))
        return VectorClock(merged)

    def is_equal(self, other: VectorClock) -> bool:
        all_nodes = set(self.clock.keys()) | set(other.clock.keys())
        return all(self.clock.get(n, 0) == other.clock.get(n, 0) for n in all_nodes)

    def is_strictly_before(self, other: VectorClock) -> bool:
        all_nodes = set(self.clock.keys()) | set(other.clock.keys())
        any_strictly_less = False
        for n in all_nodes:
            v_self = self.clock.get(n, 0)
            v_other = other.clock.get(n, 0)
            if v_self > v_other:
                return False
            if v_self < v_other:
                any_strictly_less = True
        return any_strictly_less

    def is_descendant_of(self, other: VectorClock) -> bool:
        return other.is_strictly_before(self)

    def is_concurrent(self, other: VectorClock) -> bool:
        return not self.is_equal(other) and not self.is_strictly_before(other) and not other.is_strictly_before(self)

    def to_dict(self) -> Dict[str, int]:
        return dict(self.clock)

    def __repr__(self) -> str:
        return f"VectorClock({self.clock})"


class PNCounter:
    """Positive-Negative Distributed Counter (State-based CRDT).

    Guarantees monotonic convergence across multi-master concurrent increments & decrements.
    """

    def __init__(self, node_id: str, pos: Optional[Dict[str, int]] = None, neg: Optional[Dict[str, int]] = None) -> None:
        self.node_id: str = node_id
        self.pos: Dict[str, int] = dict(pos) if pos else {}
        self.neg: Dict[str, int] = dict(neg) if neg else {}

    def increment(self, delta: int = 1) -> None:
        if delta < 0:
            self.decrement(-delta)
            return
        self.pos[self.node_id] = self.pos.get(self.node_id, 0) + delta

    def decrement(self, delta: int = 1) -> None:
        if delta < 0:
            self.increment(-delta)
            return
        self.neg[self.node_id] = self.neg.get(self.node_id, 0) + delta

    @property
    def value(self) -> int:
        return sum(self.pos.values()) - sum(self.neg.values())

    def clone(self) -> PNCounter:
        return PNCounter(self.node_id, self.pos, self.neg)

    def merge(self, other: PNCounter) -> PNCounter:
        new_pos: Dict[str, int] = {}
        new_neg: Dict[str, int] = {}
        all_nodes = set(self.pos.keys()) | set(other.pos.keys()) | set(self.neg.keys()) | set(other.neg.keys())
        for n in all_nodes:
            new_pos[n] = max(self.pos.get(n, 0), other.pos.get(n, 0))
            new_neg[n] = max(self.neg.get(n, 0), other.neg.get(n, 0))
        return PNCounter(self.node_id, new_pos, new_neg)

    def __repr__(self) -> str:
        return f"PNCounter(value={self.value}, pos={self.pos}, neg={self.neg})"


class LWWRegister:
    """Last-Write-Wins Register (LWW-Register CRDT).

    Resolves concurrent updates via hybrid timestamp and node_id tie-breaking.
    """

    def __init__(self, value: Any = None, timestamp: float = 0.0, node_id: str = "") -> None:
        self.value: Any = value
        self.timestamp: float = timestamp if timestamp else time.time()
        self.node_id: str = node_id

    def set(self, value: Any, timestamp: Optional[float] = None, node_id: Optional[str] = None) -> None:
        ts = timestamp if timestamp is not None else time.time()
        nid = node_id if node_id is not None else self.node_id
        if ts > self.timestamp or (ts == self.timestamp and nid >= self.node_id):
            self.value = value
            self.timestamp = ts
            self.node_id = nid

    def get(self) -> Any:
        return self.value

    def clone(self) -> LWWRegister:
        return LWWRegister(self.value, self.timestamp, self.node_id)

    def merge(self, other: LWWRegister) -> LWWRegister:
        if other.timestamp > self.timestamp:
            return other.clone()
        elif other.timestamp < self.timestamp:
            return self.clone()
        else:
            # Deterministic tie-break on node_id
            winner = other if other.node_id >= self.node_id else self
            return winner.clone()

    def __repr__(self) -> str:
        return f"LWWRegister(value={self.value!r}, ts={self.timestamp}, node={self.node_id!r})"


class ORSet:
    """Observed-Remove Set with Add-Wins semantics (OR-Set CRDT).

    Elements are associated with unique addition tags. Removal adds existing tags
    to a tombstone set. An item is member if at least one addition tag is active.
    """

    def __init__(
        self,
        add_set: Optional[Set[Tuple[Any, str]]] = None,
        tombstones: Optional[Set[str]] = None
    ) -> None:
        self.add_set: Set[Tuple[Any, str]] = set(add_set) if add_set else set()
        self.tombstones: Set[str] = set(tombstones) if tombstones else set()

    def add(self, item: Any, tag: Optional[str] = None) -> str:
        tag_id = tag or uuid.uuid4().hex
        self.add_set.add((item, tag_id))
        return tag_id

    def remove(self, item: Any) -> None:
        # Move all current tags of item to tombstones
        for val, tag in self.add_set:
            if val == item:
                self.tombstones.add(tag)

    def contains(self, item: Any) -> bool:
        return item in self.read()

    def read(self) -> Set[Any]:
        return {item for item, tag in self.add_set if tag not in self.tombstones}

    def clone(self) -> ORSet:
        return ORSet(self.add_set, self.tombstones)

    def merge(self, other: ORSet) -> ORSet:
        merged_adds = self.add_set | other.add_set
        merged_tombs = self.tombstones | other.tombstones
        return ORSet(merged_adds, merged_tombs)

    def compact(self) -> None:
        """Purge obsolete tombstoned additions to bound memory growth."""
        self.add_set = {(item, tag) for item, tag in self.add_set if tag not in self.tombstones}

    def __repr__(self) -> str:
        return f"ORSet(elements={self.read()!r}, tombstones_count={len(self.tombstones)})"


class PlanetaryActor:
    """Distributed TinyTalk Smalltalk Actor with CRDT State & Live Migration.

    Maintains vector clock causality, encapsulates CRDT fields, and supports
    transparent cross-region migration without state loss or central lock coordination.
    """

    def __init__(self, actor_id: str, home_region: str) -> None:
        self.actor_id: str = actor_id
        self.home_region: str = home_region
        self.current_region: str = home_region
        self.clock: VectorClock = VectorClock()
        self.clock.increment(home_region)
        self.counters: Dict[str, PNCounter] = {}
        self.registers: Dict[str, LWWRegister] = {}
        self.sets: Dict[str, ORSet] = {}
        self.migration_history: list = [home_region]

    def set_counter(self, name: str, delta: int) -> None:
        if name not in self.counters:
            self.counters[name] = PNCounter(self.current_region)
        if delta >= 0:
            self.counters[name].increment(delta)
        else:
            self.counters[name].decrement(-delta)
        self.clock.increment(self.current_region)

    def get_counter(self, name: str) -> int:
        return self.counters[name].value if name in self.counters else 0

    def set_register(self, name: str, value: Any, timestamp: Optional[float] = None) -> None:
        if name not in self.registers:
            self.registers[name] = LWWRegister(value, timestamp, self.current_region)
        else:
            self.registers[name].set(value, timestamp, self.current_region)
        self.clock.increment(self.current_region)

    def get_register(self, name: str) -> Any:
        return self.registers[name].get() if name in self.registers else None

    def add_to_set(self, name: str, item: Any) -> str:
        if name not in self.sets:
            self.sets[name] = ORSet()
        tag = self.sets[name].add(item)
        self.clock.increment(self.current_region)
        return tag

    def remove_from_set(self, name: str, item: Any) -> None:
        if name in self.sets:
            self.sets[name].remove(item)
            self.clock.increment(self.current_region)

    def get_set(self, name: str) -> Set[Any]:
        return self.sets[name].read() if name in self.sets else set()

    def migrate_to(self, target_region: str) -> None:
        """Transparently migrate execution context to target region."""
        self.current_region = target_region
        self.clock.increment(target_region)
        self.migration_history.append(target_region)

    def merge(self, other: PlanetaryActor) -> None:
        """Merge state from a replica in another datacenter/region."""
        self.clock = self.clock.merge(other.clock)

        # Merge counters
        for k, v in other.counters.items():
            if k in self.counters:
                self.counters[k] = self.counters[k].merge(v)
            else:
                self.counters[k] = v.clone()

        # Merge registers
        for k, v in other.registers.items():
            if k in self.registers:
                self.registers[k] = self.registers[k].merge(v)
            else:
                self.registers[k] = v.clone()

        # Merge sets
        for k, v in other.sets.items():
            if k in self.sets:
                self.sets[k] = self.sets[k].merge(v)
            else:
                self.sets[k] = v.clone()

    def export_state(self) -> Dict[str, Any]:
        return {
            "actor_id": self.actor_id,
            "current_region": self.current_region,
            "clock": self.clock.to_dict(),
            "counters": {k: v.value for k, v in self.counters.items()},
            "registers": {k: v.get() for k, v in self.registers.items()},
            "sets": {k: list(v.read()) for k, v in self.sets.items()},
            "migrations": list(self.migration_history),
        }
