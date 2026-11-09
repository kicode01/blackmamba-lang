"""
Tests for Phase 11C Zero-Copy Binary Wire RPC Engine (rpc.py)
"""

import unittest
from tinytalk.rpc import (
    MAGIC_BYTES,
    HEADER_SIZE,
    FLAG_REQUEST,
    FLAG_RESPONSE,
    FLAG_HEARTBEAT,
    FLAG_ERROR,
    RPCFrameError,
    encode_frame,
    decode_frame,
    RPCDispatcher,
    RPCClient
)
import mamba.rpc as m_rpc


class TestWireRPC(unittest.TestCase):
    def test_encode_and_decode_valid_frame(self):
        payload = b"test payload binary \x00\x01\x02"
        frame = encode_frame(msg_id=42, method_id=101, payload=payload, flags=FLAG_REQUEST)
        self.assertEqual(len(frame), HEADER_SIZE + len(payload))

        msg_id, method_id, flags, decoded_view = decode_frame(frame)
        self.assertEqual(msg_id, 42)
        self.assertEqual(method_id, 101)
        self.assertEqual(flags, FLAG_REQUEST)
        self.assertEqual(bytes(decoded_view), payload)

    def test_checksum_corruption_detection(self):
        payload = b"critical financial payload"
        frame = bytearray(encode_frame(msg_id=1, method_id=1, payload=payload))
        # Corrupt 1 byte in payload
        frame[-1] ^= 0xFF
        with self.assertRaises(RPCFrameError):
            decode_frame(frame)

    def test_magic_corruption_detection(self):
        payload = b"payload"
        frame = bytearray(encode_frame(msg_id=1, method_id=1, payload=payload))
        # Corrupt magic
        frame[0] = ord("X")
        with self.assertRaises(RPCFrameError):
            decode_frame(frame)

    def test_dispatcher_and_client_roundtrip(self):
        dispatcher = RPCDispatcher()

        # Method 7: uppercase string
        def handle_upper(payload_view):
            return bytes(payload_view).upper()

        dispatcher.register_handler(7, handle_upper)

        client = RPCClient()
        req_frame = client.call(method_id=7, payload=b"hello mamba")

        # Server dispatch
        resp_frame = dispatcher.dispatch(req_frame)

        # Client receives response
        msg_id, result = client.receive_response(resp_frame)
        self.assertEqual(msg_id, 1)
        self.assertEqual(result, b"HELLO MAMBA")

    def test_dispatcher_unknown_method(self):
        dispatcher = RPCDispatcher()
        client = RPCClient()
        req_frame = client.call(method_id=999, payload=b"ping")
        resp_frame = dispatcher.dispatch(req_frame)

        with self.assertRaises(RPCFrameError):
            client.receive_response(resp_frame)

    def test_backward_compatibility_shim(self):
        self.assertIs(m_rpc.RPCClient, RPCClient)
        self.assertIs(m_rpc.RPCDispatcher, RPCDispatcher)
        self.assertEqual(m_rpc.HEADER_SIZE, 32)


if __name__ == "__main__":
    unittest.main()
