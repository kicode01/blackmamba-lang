"""
Tests for Phase 11D Content-Addressed Merkle CAS Engine (cas.py)
"""

import unittest
from tinytalk.cas import (
    hash_content,
    MerkleNode,
    MerkleTree,
    ContentAddressedStore
)
import tinytalk.cas as m_cas


class TestMerkleCAS(unittest.TestCase):
    def test_merkle_tree_construction_and_root(self):
        hashes = [hash_content(f"leaf_{i}".encode()) for i in range(4)]
        tree = MerkleTree(hashes)
        self.assertIsNotNone(tree.root_hash)
        self.assertEqual(len(tree.leaves), 4)

    def test_merkle_inclusion_proof_valid(self):
        hashes = [hash_content(f"tx_data_{i}".encode()) for i in range(8)]
        tree = MerkleTree(hashes)
        root = tree.root_hash

        for idx in range(8):
            proof = tree.get_proof(idx)
            is_valid = MerkleTree.verify_proof(root, hashes[idx], proof)
            self.assertTrue(is_valid, f"Proof failed for leaf index {idx}")

    def test_merkle_inclusion_proof_invalid(self):
        hashes = [hash_content(f"chunk_{i}".encode()) for i in range(4)]
        tree = MerkleTree(hashes)
        proof = tree.get_proof(0)
        # Verify with wrong hash
        bogus_hash = hash_content(b"tampered")
        self.assertFalse(MerkleTree.verify_proof(tree.root_hash, bogus_hash, proof))

    def test_cas_put_get_and_deduplication(self):
        cas = ContentAddressedStore(default_chunk_size=1024)
        # Create 4 KB payload with 2 repeating blocks of 2 KB
        block_a = b"A" * 2048
        block_b = b"B" * 2048
        payload = block_a + block_b

        root, chunk_ids = cas.put(payload, chunk_size=2048)
        self.assertEqual(len(chunk_ids), 2)

        # Retrieve full payload
        retrieved = cas.get(root)
        self.assertEqual(retrieved, payload)

        # Ingest same payload again -> verify deduplication
        _, chunk_ids_2 = cas.put(payload, chunk_size=2048)
        self.assertEqual(chunk_ids, chunk_ids_2)
        self.assertEqual(cas.dedup_ratio(), 2.0)

    def test_cas_missing_chunk(self):
        cas = ContentAddressedStore()
        self.assertIsNone(cas.get("non_existent_root"))

    def test_backward_compatibility_shim(self):
        self.assertIs(m_cas.ContentAddressedStore, ContentAddressedStore)
        self.assertIs(m_cas.MerkleTree, MerkleTree)


if __name__ == "__main__":
    unittest.main()
