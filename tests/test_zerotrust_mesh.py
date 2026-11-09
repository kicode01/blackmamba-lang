"""
Tests for Phase 11D Zero-Trust Encrypted Mesh Network Engine (mesh.py)
"""

import unittest
from tinytalk.mesh import (
    xor_distance,
    PeerIdentity,
    MeshPacket,
    MeshTunnelError,
    MeshTunnel,
    MeshRouter
)
import mamba.mesh as m_mesh


class TestZeroTrustMesh(unittest.TestCase):
    def test_peer_identity_generation(self):
        peer1 = PeerIdentity.generate(seed="alice_seed_1")
        peer2 = PeerIdentity.generate(seed="bob_seed_2")
        self.assertTrue(peer1.node_id.startswith("tnt_node_"))
        self.assertNotEqual(peer1.node_id, peer2.node_id)
        self.assertEqual(len(peer1.public_key), 64)

    def test_xor_distance_metric(self):
        d_self = xor_distance("node_a", "node_a")
        self.assertEqual(d_self, 0)

        d_ab = xor_distance("node_a", "node_b")
        d_ba = xor_distance("node_b", "node_a")
        self.assertEqual(d_ab, d_ba)  # Symmetric
        self.assertGreater(d_ab, 0)

    def test_mesh_tunnel_encrypt_decrypt(self):
        alice = PeerIdentity.generate(seed="alice")
        bob = PeerIdentity.generate(seed="bob")

        shared_psk = "mesh_secret_key_123"
        alice_tunnel = MeshTunnel(alice, bob.public_key, shared_secret=shared_psk)
        bob_tunnel = MeshTunnel(bob, alice.public_key, shared_secret=shared_psk)

        plaintext = b"CONFIDENTIAL_STATE_CRDT_SYNC_PACKET"
        packet = alice_tunnel.encrypt(recipient_id=bob.node_id, plaintext=plaintext)

        # Bob decrypts
        decrypted = bob_tunnel.decrypt(packet)
        self.assertEqual(decrypted, plaintext)

    def test_anti_replay_protection(self):
        alice = PeerIdentity.generate(seed="alice")
        bob = PeerIdentity.generate(seed="bob")
        alice_tunnel = MeshTunnel(alice, bob.public_key, "shared")
        bob_tunnel = MeshTunnel(bob, alice.public_key, "shared")

        packet = alice_tunnel.encrypt(recipient_id=bob.node_id, plaintext=b"TX_1")
        bob_tunnel.decrypt(packet)

        # Replay same packet
        with self.assertRaises(MeshTunnelError):
            bob_tunnel.decrypt(packet)

    def test_tamper_detection(self):
        alice = PeerIdentity.generate(seed="alice")
        bob = PeerIdentity.generate(seed="bob")
        alice_tunnel = MeshTunnel(alice, bob.public_key, "shared")
        bob_tunnel = MeshTunnel(bob, alice.public_key, "shared")

        packet = alice_tunnel.encrypt(recipient_id=bob.node_id, plaintext=b"CRITICAL")
        # Tamper ciphertext
        tampered_bytes = bytearray(packet.ciphertext)
        tampered_bytes[0] ^= 0x01
        packet.ciphertext = bytes(tampered_bytes)

        with self.assertRaises(MeshTunnelError):
            bob_tunnel.decrypt(packet)

    def test_kademlia_peer_routing(self):
        local = PeerIdentity.generate(seed="router_node")
        router = MeshRouter(local)

        peers = [PeerIdentity.generate(seed=f"node_{i}") for i in range(10)]
        for p in peers:
            router.add_peer(p)

        closest = router.find_closest_peers(target_id="target_search_node", k=3)
        self.assertEqual(len(closest), 3)

    def test_backward_compatibility_shim(self):
        self.assertIs(m_mesh.PeerIdentity, PeerIdentity)
        self.assertIs(m_mesh.MeshTunnel, MeshTunnel)


if __name__ == "__main__":
    unittest.main()
