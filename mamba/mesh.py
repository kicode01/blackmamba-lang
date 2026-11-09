"""
Black Mamba Zero-Trust Mesh Network Shim (v4.3.0)
Backward-compatibility alias pointing directly to tinytalk.mesh.
"""

from tinytalk.mesh import (
    xor_distance,
    PeerIdentity,
    MeshPacket,
    MeshTunnelError,
    MeshTunnel,
    MeshRouter,
)

__all__ = [
    "xor_distance",
    "PeerIdentity",
    "MeshPacket",
    "MeshTunnelError",
    "MeshTunnel",
    "MeshRouter",
]
