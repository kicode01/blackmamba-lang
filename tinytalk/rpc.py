"""
TinyTalk & Black Mamba Zero-Copy Binary Wire RPC Engine (v4.2.0)
Phase 11C: Ultra-Low-Latency Binary Wire RPC Protocol.

Provides 32-byte cache-aligned binary framing with hardware CRC32 checksumming,
zero-copy memoryview parsing, multiplexed client promises, and deterministic dispatch.
"""

import struct
import zlib
from typing import Any, Callable, Dict, Optional, Tuple, Union

MAGIC_BYTES = b"TNTR"  # TinyTalk Remote
PROTOCOL_VERSION = 0x0420

FLAG_REQUEST = 0x0001
FLAG_RESPONSE = 0x0002
FLAG_HEARTBEAT = 0x0004
FLAG_ERROR = 0x0008

# Header Format:
# 4s (Magic: TNTR)
# H (Version: 2B)
# H (Flags: 2B)
# Q (Msg ID: 8B)
# I (Method ID: 4B)
# I (Payload Len: 4B)
# I (Checksum CRC32: 4B)
# 4s (Reserved: 4B)
# Total Header: 4 + 2 + 2 + 8 + 4 + 4 + 4 + 4 = 32 bytes (cache-line aligned)
HEADER_FORMAT = "<4sHHQIII4s"
HEADER_SIZE = struct.calcsize(HEADER_FORMAT)  # exactly 32 bytes


class RPCFrameError(Exception):
    """Raised when an RPC wire frame fails validation or checksum."""
    pass


def encode_frame(
    msg_id: int,
    method_id: int,
    payload: bytes,
    flags: int = FLAG_REQUEST
) -> bytes:
    """Encodes an RPC frame with 32-byte aligned header and CRC32 payload checksum."""
    payload_len = len(payload)
    checksum = zlib.crc32(payload) & 0xFFFFFFFF
    header = struct.pack(
        HEADER_FORMAT,
        MAGIC_BYTES,
        PROTOCOL_VERSION,
        flags,
        msg_id,
        method_id,
        payload_len,
        checksum,
        b"\x00\x00\x00\x00"
    )
    return header + payload


def decode_frame(
    buffer: Union[bytes, bytearray, memoryview]
) -> Tuple[int, int, int, memoryview]:
    """
    Decodes an RPC frame with zero-copy validation.
    Returns: (msg_id, method_id, flags, payload_view)
    """
    view = memoryview(buffer)
    if len(view) < HEADER_SIZE:
        raise RPCFrameError(f"Buffer too short for RPC header ({len(view)} < {HEADER_SIZE})")

    magic, version, flags, msg_id, method_id, payload_len, checksum, _ = struct.unpack(
        HEADER_FORMAT, view[:HEADER_SIZE]
    )

    if magic != MAGIC_BYTES:
        raise RPCFrameError(f"Invalid RPC magic: {magic!r} != {MAGIC_BYTES!r}")

    if len(view) < HEADER_SIZE + payload_len:
        raise RPCFrameError(
            f"Truncated frame: expected {HEADER_SIZE + payload_len} bytes, got {len(view)}"
        )

    payload_view = view[HEADER_SIZE:HEADER_SIZE + payload_len]
    calculated_crc = zlib.crc32(payload_view) & 0xFFFFFFFF
    if calculated_crc != checksum:
        raise RPCFrameError(
            f"RPC payload checksum mismatch: 0x{calculated_crc:08X} != 0x{checksum:08X}"
        )

    return msg_id, method_id, flags, payload_view


class RPCDispatcher:
    """
    Server-side RPC message dispatcher executing registered method handlers.
    """
    def __init__(self):
        self._handlers: Dict[int, Callable[[memoryview], bytes]] = {}

    def register_handler(self, method_id: int, handler: Callable[[memoryview], bytes]) -> None:
        self._handlers[method_id] = handler

    def dispatch(self, raw_frame: bytes) -> bytes:
        """Processes an incoming request frame and returns the encoded response frame."""
        try:
            msg_id, method_id, flags, payload = decode_frame(raw_frame)
            if flags & FLAG_HEARTBEAT:
                return encode_frame(msg_id, 0, b"", FLAG_RESPONSE | FLAG_HEARTBEAT)

            handler = self._handlers.get(method_id)
            if not handler:
                err_msg = f"Unknown method ID: {method_id}".encode("utf-8")
                return encode_frame(msg_id, method_id, err_msg, FLAG_RESPONSE | FLAG_ERROR)

            resp_payload = handler(payload)
            return encode_frame(msg_id, method_id, resp_payload, FLAG_RESPONSE)
        except Exception as e:
            return encode_frame(0, 0, str(e).encode("utf-8"), FLAG_RESPONSE | FLAG_ERROR)


class RPCClient:
    """
    Client-side multiplexed RPC connection managing outstanding request correlation.
    """
    def __init__(self):
        self._next_msg_id: int = 1
        self._pending_calls: Dict[int, Dict[str, Any]] = {}

    def call(self, method_id: int, payload: bytes) -> bytes:
        """Encodes request frame and increments message ID."""
        msg_id = self._next_msg_id
        self._next_msg_id += 1
        self._pending_calls[msg_id] = {
            "method_id": method_id,
            "status": "PENDING"
        }
        return encode_frame(msg_id, method_id, payload, FLAG_REQUEST)

    def receive_response(self, raw_frame: bytes) -> Tuple[int, bytes]:
        """Resolves an incoming response frame matching pending message ID."""
        msg_id, method_id, flags, payload = decode_frame(raw_frame)
        if msg_id in self._pending_calls:
            self._pending_calls[msg_id]["status"] = "RESOLVED"
            del self._pending_calls[msg_id]
        if flags & FLAG_ERROR:
            raise RPCFrameError(f"RPC Remote Error: {bytes(payload).decode('utf-8', errors='replace')}")
        return msg_id, bytes(payload)
