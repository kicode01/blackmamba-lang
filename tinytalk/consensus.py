"""
TinyTalk & Black Mamba Linearizable Quorum Consensus Engine (v4.2.0)
Phase 11C: Raft / Multi-Paxos Linearizable State Machine Replication.

Provides deterministic leader election, log consensus with majority quorum verification,
leader lease tracking, and linearizable state machine reads and writes.
"""

from dataclasses import dataclass, field
from enum import Enum
from typing import Any, Callable, Dict, List, Optional, Set, Tuple
import time


class NodeRole(str, Enum):
    FOLLOWER = "FOLLOWER"
    CANDIDATE = "CANDIDATE"
    LEADER = "LEADER"


@dataclass
class LogEntry:
    index: int
    term: int
    command: str
    data: Any
    committed: bool = False
    timestamp: float = field(default_factory=time.time)


class RaftNode:
    """
    Raft Consensus Node implementing linearizable distributed state machine replication.
    """
    def __init__(self, node_id: str, peers: Optional[List[str]] = None):
        self.node_id = node_id
        self.peers: List[str] = peers or []
        self.current_term: int = 0
        self.voted_for: Optional[str] = None
        self.log: List[LogEntry] = []
        self.commit_index: int = 0
        self.last_applied: int = 0
        self.role: NodeRole = NodeRole.FOLLOWER
        self.leader_id: Optional[str] = None
        self.leader_lease_expiry: float = 0.0
        self.lease_duration: float = 5.0  # seconds
        self.state_machine: Dict[str, Any] = {}
        self.cluster_ref: Optional["QuorumCluster"] = None

    @property
    def quorum_size(self) -> int:
        total_nodes = len(self.peers) + 1
        return (total_nodes // 2) + 1

    @property
    def last_log_index(self) -> int:
        return self.log[-1].index if self.log else 0

    @property
    def last_log_term(self) -> int:
        return self.log[-1].term if self.log else 0

    def start_election(self) -> bool:
        """Transitions to CANDIDATE and solicits votes from all peers."""
        self.role = NodeRole.CANDIDATE
        self.current_term += 1
        self.voted_for = self.node_id
        votes_received = 1  # Self vote

        if not self.peers:
            # Single node cluster immediately wins
            self._become_leader()
            return True

        if self.cluster_ref:
            for peer_id in self.peers:
                peer = self.cluster_ref.get_node(peer_id)
                if peer:
                    granted, _ = peer.request_vote(
                        candidate_id=self.node_id,
                        term=self.current_term,
                        last_log_index=self.last_log_index,
                        last_log_term=self.last_log_term
                    )
                    if granted:
                        votes_received += 1

        if votes_received >= self.quorum_size:
            self._become_leader()
            return True
        else:
            self.role = NodeRole.FOLLOWER
            self.voted_for = None
            return False

    def _become_leader(self) -> None:
        self.role = NodeRole.LEADER
        self.leader_id = self.node_id
        self.leader_lease_expiry = time.time() + self.lease_duration
        # Send initial empty heartbeat
        if self.cluster_ref:
            self._broadcast_heartbeat()

    def request_vote(
        self,
        candidate_id: str,
        term: int,
        last_log_index: int,
        last_log_term: int
    ) -> Tuple[bool, int]:
        """Handles RequestVote RPC from a candidate."""
        if term > self.current_term:
            self.current_term = term
            self.role = NodeRole.FOLLOWER
            self.voted_for = None

        if term < self.current_term:
            return False, self.current_term

        # Check if vote already cast in this term
        can_vote = (self.voted_for is None or self.voted_for == candidate_id)

        # Check candidate's log is at least as up-to-date as receiver's log
        log_ok = (
            last_log_term > self.last_log_term
            or (last_log_term == self.last_log_term and last_log_index >= self.last_log_index)
        )

        if can_vote and log_ok:
            self.voted_for = candidate_id
            return True, self.current_term

        return False, self.current_term

    def append_entries(
        self,
        leader_id: str,
        term: int,
        prev_log_index: int,
        prev_log_term: int,
        entries: List[LogEntry],
        leader_commit: int
    ) -> Tuple[bool, int]:
        """Handles AppendEntries RPC from leader."""
        if term < self.current_term:
            return False, self.current_term

        if term > self.current_term or self.role == NodeRole.CANDIDATE:
            self.current_term = term
            self.role = NodeRole.FOLLOWER
            self.voted_for = None

        self.leader_id = leader_id

        # Verify entry at prev_log_index matches prev_log_term
        if prev_log_index > 0:
            if prev_log_index > len(self.log):
                return False, self.current_term
            if self.log[prev_log_index - 1].term != prev_log_term:
                return False, self.current_term

        # Append any new entries
        for entry in entries:
            idx = entry.index
            if idx <= len(self.log):
                self.log[idx - 1] = entry
            else:
                self.log.append(entry)

        # Update commit index
        if leader_commit > self.commit_index:
            self.commit_index = min(leader_commit, len(self.log))
            self._apply_to_state_machine()

        return True, self.current_term

    def _broadcast_heartbeat(self) -> None:
        if not self.cluster_ref:
            return
        for peer_id in self.peers:
            peer = self.cluster_ref.get_node(peer_id)
            if peer:
                peer.append_entries(
                    leader_id=self.node_id,
                    term=self.current_term,
                    prev_log_index=self.last_log_index,
                    prev_log_term=self.last_log_term,
                    entries=[],
                    leader_commit=self.commit_index
                )

    def propose(self, command: str, data: Any) -> Tuple[bool, int]:
        """
        Proposes a new state transition command. Only valid on LEADER.
        Replicates across cluster peers and commits when majority quorum acknowledges.
        """
        if self.role != NodeRole.LEADER:
            return False, -1

        new_index = len(self.log) + 1
        entry = LogEntry(
            index=new_index,
            term=self.current_term,
            command=command,
            data=data,
            committed=False
        )
        self.log.append(entry)

        acks = 1  # Leader itself acknowledged
        if self.cluster_ref:
            for peer_id in self.peers:
                peer = self.cluster_ref.get_node(peer_id)
                if peer:
                    ok, _ = peer.append_entries(
                        leader_id=self.node_id,
                        term=self.current_term,
                        prev_log_index=new_index - 1,
                        prev_log_term=self.log[new_index - 2].term if new_index > 1 else 0,
                        entries=[entry],
                        leader_commit=self.commit_index
                    )
                    if ok:
                        acks += 1

        if acks >= self.quorum_size:
            self.commit_index = new_index
            entry.committed = True
            self._apply_to_state_machine()
            # Broadcast updated commit index
            self._broadcast_heartbeat()
            return True, new_index

        return False, new_index

    def _apply_to_state_machine(self) -> None:
        while self.last_applied < self.commit_index:
            self.last_applied += 1
            entry = self.log[self.last_applied - 1]
            entry.committed = True
            # Default state machine supports "SET <key>", "DEL <key>"
            cmd = entry.command.upper()
            if cmd == "SET" and isinstance(entry.data, tuple) and len(entry.data) == 2:
                k, v = entry.data
                self.state_machine[str(k)] = v
            elif cmd == "DEL":
                self.state_machine.pop(str(entry.data), None)
            elif cmd == "APPLY" and callable(entry.data):
                entry.data(self.state_machine)

    def linearizable_read(self, key: str) -> Tuple[bool, Any]:
        """
        Performs a linearizable read ensuring leader lease is valid and node is current leader.
        """
        if self.role != NodeRole.LEADER:
            return False, None
        if time.time() > self.leader_lease_expiry:
            return False, None
        return True, self.state_machine.get(key)


class QuorumCluster:
    """
    Simulated or physical cluster router managing RaftNode network connectivity.
    """
    def __init__(self, node_ids: List[str]):
        self.nodes: Dict[str, RaftNode] = {}
        for nid in node_ids:
            peers = [p for p in node_ids if p != nid]
            node = RaftNode(node_id=nid, peers=peers)
            node.cluster_ref = self
            self.nodes[nid] = node

    def get_node(self, node_id: str) -> Optional[RaftNode]:
        return self.nodes.get(node_id)

    def elect_leader(self, preferred_candidate: Optional[str] = None) -> Optional[str]:
        target_id = preferred_candidate or next(iter(self.nodes.keys()))
        target = self.nodes.get(target_id)
        if target and target.start_election():
            return target.node_id
        return None

    def get_leader(self) -> Optional[RaftNode]:
        for node in self.nodes.values():
            if node.role == NodeRole.LEADER:
                return node
        return None
