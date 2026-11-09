"""
Black Mamba Content-Addressed Merkle CAS Shim (v4.3.0)
Backward-compatibility alias pointing directly to tinytalk.cas.
"""

from tinytalk.cas import (
    hash_content,
    MerkleNode,
    MerkleTree,
    ContentAddressedStore,
)

__all__ = [
    "hash_content",
    "MerkleNode",
    "MerkleTree",
    "ContentAddressedStore",
]
