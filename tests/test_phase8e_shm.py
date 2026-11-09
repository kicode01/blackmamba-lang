# tests/test_phase8e_shm.py
# Comprehensive test suite for Phase 8E: Zero-Copy Distributed IPC & Cluster Shared Memory

import os
import sys
import time
import unittest
import argparse

from tinytalk.shm import (
    SharedMemoryArena, SharedRingQueue, benchmark_shm_throughput, SHM_MAGIC, RING_MAGIC
)
from tinytalk.autograd import Tensor
from tinytalk.cli import cmd_shm, compile_source_to_mir


class TestPhase8ESharedMemory(unittest.TestCase):

    def test_shared_memory_arena_lifecycle(self):
        name = f"test_arena_{int(time.time() * 1000)}"
        arena = SharedMemoryArena(name=name, size=65536, create=True)
        try:
            self.assertEqual(arena.size, 65536)
            data = b"TinyTalk High Speed Distributed IPC"
            written = arena.write_bytes(data)
            self.assertEqual(written, len(data))

            # Simulate separate process attaching to existing arena
            client = SharedMemoryArena(name=name, create=False)
            read_back = client.read_bytes(length=len(data))
            self.assertEqual(read_back, data)
            client.close()
        finally:
            arena.close()
            arena.unlink()

    def test_shared_memory_tensor_zero_copy(self):
        name = f"test_tensor_shm_{int(time.time() * 1000)}"
        orig_tensor = Tensor([
            [1.5, 2.5, 3.5],
            [4.5, 5.5, 6.5],
            [7.5, 8.5, 9.5]
        ])

        arena = SharedMemoryArena(name=name, size=131072, create=True)
        try:
            arena.write_tensor(orig_tensor)

            # Separate attachment reading tensor
            reader = SharedMemoryArena(name=name, create=False)
            restored_tensor = reader.read_tensor()
            self.assertEqual(restored_tensor.shape, (3, 3))
            self.assertEqual(restored_tensor.size, 9)
            for a, b in zip(orig_tensor.data, restored_tensor.data):
                self.assertAlmostEqual(a, b)
            reader.close()
        finally:
            arena.close()
            arena.unlink()

    def test_shared_memory_image_snapshot_storage(self):
        name = f"test_img_shm_{int(time.time() * 1000)}"
        mock_image = b"BMBIMG\x00\x00\x01\x00\x00\x00{\"modules\": [\"app\"], \"heap\": {}}"

        arena = SharedMemoryArena(name=name, size=65536, create=True)
        try:
            arena.write_image(mock_image)

            reader = SharedMemoryArena(name=name, create=False)
            restored_img = reader.read_image()
            self.assertEqual(restored_img, mock_image)
            reader.close()
        finally:
            arena.close()
            arena.unlink()

    def test_shared_ring_queue_fifo(self):
        name = f"test_ring_{int(time.time() * 1000)}"
        queue = SharedRingQueue(name=name, capacity=10, slot_size=128, create=True)
        try:
            self.assertTrue(queue.is_empty())
            self.assertFalse(queue.is_full())

            messages = [f"Msg-{i}".encode("utf-8") for i in range(5)]
            for msg in messages:
                ok = queue.push(msg)
                self.assertTrue(ok)

            self.assertEqual(queue.qsize(), 5)
            self.assertFalse(queue.is_empty())

            # Simulate consumer process
            consumer = SharedRingQueue(name=name, create=False)
            for expected in messages:
                val = consumer.pop(timeout=0.1)
                self.assertEqual(val, expected)

            self.assertTrue(consumer.is_empty())
            consumer.close()
        finally:
            queue.close()
            queue.unlink()

    def test_benchmark_shm_throughput(self):
        res = benchmark_shm_throughput(iterations=1000, message_size=128)
        self.assertEqual(res["iterations"], 1000)
        self.assertTrue(res["ops_per_second"] > 1000)
        self.assertTrue(res["latency_microseconds"] < 1000)
        self.assertTrue(res["throughput_gb_sec"] > 0)

    def test_cli_shm_commands(self):
        arena_name = f"cli_shm_test_{int(time.time() * 1000)}"

        # 1. create
        crt_args = argparse.Namespace(
            action="create",
            name=arena_name,
            size=32768,
            json=True,
        )
        self.assertEqual(cmd_shm(crt_args), 0)

        # 2. write
        wrt_args = argparse.Namespace(
            action="write",
            name=arena_name,
            data="TinyTalk Cluster Protocol Payload",
            json=True,
        )
        self.assertEqual(cmd_shm(wrt_args), 0)

        # 3. read
        rd_args = argparse.Namespace(
            action="read",
            name=arena_name,
            json=True,
        )
        self.assertEqual(cmd_shm(rd_args), 0)

        # 4. bench
        bnc_args = argparse.Namespace(
            action="bench",
            iters=200,
            size=64,
            json=True,
        )
        self.assertEqual(cmd_shm(bnc_args), 0)

        # 5. unlink
        unl_args = argparse.Namespace(
            action="unlink",
            name=arena_name,
        )
        self.assertEqual(cmd_shm(unl_args), 0)

    def test_native_bmb_shm_stdlib(self):
        stdlib_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), "tinytalk", "stdlib", "shm.tnt")
        self.assertTrue(os.path.exists(stdlib_path))
        with open(stdlib_path, "r", encoding="utf-8") as f:
            src = f.read()

        mir = compile_source_to_mir(src, filename=stdlib_path)
        self.assertIsNotNone(mir)
        self.assertTrue(len(mir.functions) >= 4)


if __name__ == "__main__":
    unittest.main()
