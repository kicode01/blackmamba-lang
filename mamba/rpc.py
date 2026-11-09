"""
Black Mamba Zero-Copy Wire RPC Shim (v4.2.0)
Backward-compatibility alias pointing directly to tinytalk.rpc.
"""

from tinytalk.rpc import (
    MAGIC_BYTES,
    PROTOCOL_VERSION,
    FLAG_REQUEST,
    FLAG_RESPONSE,
    FLAG_HEARTBEAT,
    FLAG_ERROR,
    HEADER_SIZE,
    RPCFrameError,
    encode_frame,
    decode_frame,
    RPCDispatcher,
    RPCClient,
)

__all__ = [
    "MAGIC_BYTES",
    "PROTOCOL_VERSION",
    "FLAG_REQUEST",
    "FLAG_RESPONSE",
    "FLAG_HEARTBEAT",
    "FLAG_ERROR",
    "HEADER_SIZE",
    "RPCFrameError",
    "encode_frame",
    "decode_frame",
    "RPCDispatcher",
    "RPCClient",
]
