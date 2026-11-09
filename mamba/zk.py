"""
Black Mamba Zero-Knowledge State Verifier Shim (v4.4.0)
Backward-compatibility alias pointing directly to tinytalk.zk.
"""

from tinytalk.zk import (
    FIELD_PRIME,
    R1CSConstraint,
    ZKProof,
    R1CSCircuit,
    ZKProver,
    ZKVerifier,
)

__all__ = [
    "FIELD_PRIME",
    "R1CSConstraint",
    "ZKProof",
    "R1CSCircuit",
    "ZKProver",
    "ZKVerifier",
]
