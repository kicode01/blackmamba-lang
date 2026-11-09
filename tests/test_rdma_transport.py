"""Unit tests for TinyTalk Kernel-Bypass RDMA Transport (Phase 11B - v4.1.0)."""
import unittest
from tinytalk.rdma import KernelBypassRing, RDMATransport
import tinytalk.rdma as mamba_rdma


class TestRDMATransport(unittest.TestCase):
    def test_ring_enqueue_dequeue(self):
        ring = KernelBypassRing(capacity=64)
        self.assertEqual(ring.size, 0)
        self.assertTrue(ring.available_space >= 64)

        # Enqueue packet
        pkt = b"\x01\x00\x55\xaa\xfe\xed"
        success = ring.enqueue(pkt)
        self.assertTrue(success)
        self.assertEqual(ring.size, 1)

        # Dequeue
        dequeued = ring.dequeue()
        self.assertEqual(dequeued, pkt)
        self.assertEqual(ring.size, 0)

    def test_ring_burst_operations(self):
        ring = KernelBypassRing(capacity=128)
        packets = [f"packet-{i}".encode("utf-8") for i in range(50)]

        sent = ring.tx_burst(packets)
        self.assertEqual(sent, 50)
        self.assertEqual(ring.size, 50)

        # Receive burst of 32
        batch1 = ring.rx_burst(max_packets=32)
        self.assertEqual(len(batch1), 32)
        self.assertEqual(batch1[0], b"packet-0")
        self.assertEqual(batch1[31], b"packet-31")

        # Receive remaining 18
        batch2 = ring.rx_burst(max_packets=32)
        self.assertEqual(len(batch2), 18)
        self.assertEqual(batch2[-1], b"packet-49")
        self.assertEqual(ring.size, 0)

    def test_ring_overflow_drop_handling(self):
        ring = KernelBypassRing(capacity=16)
        for i in range(16):
            self.assertTrue(ring.enqueue(b"data"))

        # 17th packet must be dropped cleanly without memory leak
        overflow = ring.enqueue(b"overflow")
        self.assertFalse(overflow)
        self.assertEqual(ring.dropped_count, 1)

    def test_rdma_transport_telemetry(self):
        transport = RDMATransport(interface_name="mlx5_core", queue_depth=256)
        self.assertEqual(transport.interface_name, "mlx5_core")

        # Ingest packets
        for i in range(20):
            transport.inject_ingress_packet(b"HFT_BTC_PRICE_TICK_94500.50")

        burst = transport.receive_burst(max_packets=20)
        self.assertEqual(len(burst), 20)

        telemetry = transport.get_telemetry()
        self.assertTrue(telemetry["kernel_bypass"])
        self.assertTrue(telemetry["zero_copy"])
        self.assertLess(telemetry["latency_wire_ns"], 1000.0)  # Sub-microsecond (< 1 us)
        self.assertEqual(telemetry["rx_packets"], 20)
        self.assertEqual(telemetry["dropped_packets"], 0)

    def test_mamba_backward_compatibility_shim(self):
        shim_ring = mamba_rdma.KernelBypassRing(capacity=32)
        self.assertTrue(shim_ring.enqueue(b"shim_test"))
        self.assertEqual(shim_ring.dequeue(), b"shim_test")


if __name__ == "__main__":
    unittest.main()
