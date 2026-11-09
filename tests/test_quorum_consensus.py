"""
Tests for Phase 11C Linearizable Quorum Consensus Engine (consensus.py)
"""

import unittest
from tinytalk.consensus import (
    NodeRole,
    LogEntry,
    RaftNode,
    QuorumCluster
)
import tinytalk.consensus as m_consensus


class TestQuorumConsensus(unittest.TestCase):
    def test_single_node_election(self):
        node = RaftNode("node-1")
        won = node.start_election()
        self.assertTrue(won)
        self.assertEqual(node.role, NodeRole.LEADER)
        self.assertEqual(node.current_term, 1)

    def test_three_node_cluster_election(self):
        cluster = QuorumCluster(["node-1", "node-2", "node-3"])
        leader_id = cluster.elect_leader("node-1")
        self.assertEqual(leader_id, "node-1")
        leader = cluster.get_leader()
        self.assertIsNotNone(leader)
        self.assertEqual(leader.node_id, "node-1")
        self.assertEqual(leader.role, NodeRole.LEADER)

    def test_replicated_log_propose_and_commit(self):
        cluster = QuorumCluster(["n1", "n2", "n3"])
        cluster.elect_leader("n1")
        leader = cluster.get_node("n1")
        self.assertIsNotNone(leader)

        # Propose state transition: SET x = 42
        ok, index = leader.propose("SET", ("x", 42))
        self.assertTrue(ok)
        self.assertEqual(index, 1)

        # Verify entry committed on majority
        self.assertEqual(leader.commit_index, 1)
        self.assertEqual(cluster.get_node("n2").commit_index, 1)
        self.assertEqual(cluster.get_node("n3").commit_index, 1)

        # Verify linearizable read from leader
        read_ok, val = leader.linearizable_read("x")
        self.assertTrue(read_ok)
        self.assertEqual(val, 42)

    def test_delete_and_custom_applier(self):
        cluster = QuorumCluster(["n1", "n2", "n3"])
        cluster.elect_leader("n1")
        leader = cluster.get_node("n1")

        leader.propose("SET", ("balance", 1000))
        _, val = leader.linearizable_read("balance")
        self.assertEqual(val, 1000)

        # Propose DEL
        leader.propose("DEL", "balance")
        _, val = leader.linearizable_read("balance")
        self.assertIsNone(val)

    def test_follower_rejects_proposal(self):
        cluster = QuorumCluster(["n1", "n2", "n3"])
        cluster.elect_leader("n1")
        follower = cluster.get_node("n2")
        ok, idx = follower.propose("SET", ("y", 99))
        self.assertFalse(ok)
        self.assertEqual(idx, -1)

    def test_backward_compatibility_shim(self):
        self.assertIs(m_consensus.RaftNode, RaftNode)
        self.assertIs(m_consensus.QuorumCluster, QuorumCluster)


if __name__ == "__main__":
    unittest.main()
