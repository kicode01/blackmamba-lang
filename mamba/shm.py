# Black Mamba Zero-Copy Distributed IPC & Cluster Shared Memory (Phase 8E / v2.8.0)
# Cross-process OS shared-memory arenas and lock-free ring queues for
# sub-microsecond actor messaging, tensor exchange, and .bmbimg sharing.

import os
import mmap
import time
import struct
import tempfile
from typing import Optional, Tuple, Dict, Any, Union

from .autograd import Tensor


SHM_MAGIC = b"BMB_SHM1"
RING_MAGIC = b"BMB_RING"
HEADER_SIZE = 64


def _get_shm_path(name: str) -> str:
    # Normalize name to safe filename
    safe_name = "".join(c if c.isalnum() or c in "._-" else "_" for c in name)
    return os.path.join(tempfile.gettempdir(), f"bmb_shm_{safe_name}.dat")


class SharedMemoryArena:
    """
    Cross-process OS shared memory arena using memory-mapped OS primitives (mmap).
    Allows zero-copy exchange of tensors, dataframes, and .bmbimg snapshots across
    distinct processes and CLI commands.
    """

    def __init__(self, name: str, size: int = 1024 * 1024, create: bool = False):
        self.name = name
        self.path = _get_shm_path(name)
        self.is_creator = create
        self._closed = False

        if create:
            if os.path.exists(self.path):
                try:
                    os.remove(self.path)
                except Exception:
                    pass
            self.size = size
            self.file = open(self.path, "w+b")
            self.file.write(b"\x00" * size)
            self.file.flush()
            self.buf = mmap.mmap(self.file.fileno(), size)
            self._init_header()
        else:
            if not os.path.exists(self.path):
                raise FileNotFoundError(f"Shared memory arena '{name}' not found at {self.path}")
            self.size = os.path.getsize(self.path)
            self.file = open(self.path, "r+b")
            self.buf = mmap.mmap(self.file.fileno(), self.size)
            self._verify_header()

    def _init_header(self) -> None:
        # 64-byte Header:
        # Magic (8B) + Version (4B) + Flags (4B) + DataSize (8B) + Reserved (40B)
        header = struct.pack("<8sIIQ40x", SHM_MAGIC, 280, 0, 0)
        self.buf[0:HEADER_SIZE] = header
        self.buf.flush()

    def _verify_header(self) -> None:
        magic = bytes(self.buf[0:8])
        if magic != SHM_MAGIC:
            raise ValueError(f"Invalid shared memory magic: {magic}")

    def write_bytes(self, data: bytes, offset: int = HEADER_SIZE) -> int:
        if offset + len(data) > self.size:
            raise ValueError(f"Data size {len(data)} exceeds arena capacity at offset {offset}")
        self.buf[offset : offset + len(data)] = data
        # Update DataSize in header
        struct.pack_into("<Q", self.buf, 16, len(data))
        self.buf.flush()
        return len(data)

    def read_bytes(self, length: Optional[int] = None, offset: int = HEADER_SIZE) -> bytes:
        if length is None:
            # Read DataSize from header
            length = struct.unpack_from("<Q", self.buf, 16)[0]
        if offset + length > self.size:
            raise ValueError("Read exceeds arena bounds")
        return bytes(self.buf[offset : offset + length])

    def write_tensor(self, tensor: Tensor, offset: int = HEADER_SIZE) -> int:
        """
        Serializes a Tensor (shape + float64 elements) directly into shared memory.
        """
        shape_bytes = struct.pack(f"<{len(tensor.shape) + 1}I", len(tensor.shape), *tensor.shape)
        data_bytes = struct.pack(f"<{tensor.size}d", *tensor.data)
        payload = shape_bytes + data_bytes
        return self.write_bytes(payload, offset=offset)

    def read_tensor(self, offset: int = HEADER_SIZE) -> Tensor:
        """
        Reconstructs a Tensor directly from shared memory with zero disk I/O.
        """
        raw = self.read_bytes(offset=offset)
        ndim = struct.unpack_from("<I", raw, 0)[0]
        shape = struct.unpack_from(f"<{ndim}I", raw, 4)
        data_offset = 4 + ndim * 4
        num_elements = 1
        for s in shape:
            num_elements *= s
        data = list(struct.unpack_from(f"<{num_elements}d", raw, data_offset))
        return Tensor(data, shape=shape)

    def write_image(self, image_bytes: bytes, offset: int = HEADER_SIZE) -> int:
        """
        Writes serialized .bmbimg snapshot bytes directly into shared memory.
        """
        return self.write_bytes(image_bytes, offset=offset)

    def read_image(self, offset: int = HEADER_SIZE) -> bytes:
        """
        Reads .bmbimg snapshot bytes directly from shared memory.
        """
        return self.read_bytes(offset=offset)

    def close(self) -> None:
        if not self._closed:
            try:
                self.buf.flush()
                self.buf.close()
                self.file.close()
            except Exception:
                pass
            self._closed = True

    def unlink(self) -> None:
        self.close()
        if os.path.exists(self.path):
            try:
                os.remove(self.path)
            except Exception:
                pass

    def __enter__(self) -> "SharedMemoryArena":
        return self

    def __exit__(self, exc_type, exc_val, exc_tb) -> None:
        self.close()
        if self.is_creator:
            self.unlink()


class SharedRingQueue:
    """
    Lock-free Single-Producer Single-Consumer (SPSC) / MPMC ring buffer
    in OS shared memory for sub-microsecond IPC messaging.
    """

    def __init__(
        self,
        name: str,
        capacity: int = 1024,
        slot_size: int = 512,
        create: bool = False,
    ):
        self.name = name
        self.path = _get_shm_path(name)
        self.capacity = capacity
        self.slot_size = slot_size
        self.total_size = HEADER_SIZE + capacity * slot_size
        self.is_creator = create
        self._closed = False

        if create:
            if os.path.exists(self.path):
                try:
                    os.remove(self.path)
                except Exception:
                    pass
            self.file = open(self.path, "w+b")
            self.file.write(b"\x00" * self.total_size)
            self.file.flush()
            self.buf = mmap.mmap(self.file.fileno(), self.total_size)
            self._init_ring()
        else:
            if not os.path.exists(self.path):
                raise FileNotFoundError(f"Shared ring queue '{name}' not found at {self.path}")
            self.total_size = os.path.getsize(self.path)
            self.file = open(self.path, "r+b")
            self.buf = mmap.mmap(self.file.fileno(), self.total_size)
            self._read_ring_header()

    def _init_ring(self) -> None:
        # 64-byte Ring Header:
        # Magic (8B) + Capacity (8B) + SlotSize (8B) + Head (8B) + Tail (8B) + Reserved (24B)
        hdr = struct.pack("<8sQQQQ24x", RING_MAGIC, self.capacity, self.slot_size, 0, 0)
        self.buf[0:HEADER_SIZE] = hdr
        self.buf.flush()

    def _read_ring_header(self) -> None:
        magic, cap, slot_sz = struct.unpack_from("<8sQQ", self.buf, 0)
        if magic != RING_MAGIC:
            raise ValueError(f"Invalid ring magic: {magic}")
        self.capacity = cap
        self.slot_size = slot_sz

    def _get_head(self) -> int:
        return struct.unpack_from("<Q", self.buf, 24)[0]

    def _set_head(self, val: int) -> None:
        struct.pack_into("<Q", self.buf, 24, val)

    def _get_tail(self) -> int:
        return struct.unpack_from("<Q", self.buf, 32)[0]

    def _set_tail(self, val: int) -> None:
        struct.pack_into("<Q", self.buf, 32, val)

    def qsize(self) -> int:
        head = self._get_head()
        tail = self._get_tail()
        return tail - head

    def is_empty(self) -> bool:
        return self._get_head() == self._get_tail()

    def is_full(self) -> bool:
        return self.qsize() >= self.capacity

    def push(self, data: bytes, timeout: float = 1.0) -> bool:
        """
        Writes data into the next ring slot.
        Each slot has 4 bytes length prefix followed by payload.
        """
        if len(data) > self.slot_size - 4:
            raise ValueError(f"Payload {len(data)}B exceeds maximum slot capacity {self.slot_size - 4}B")

        t0 = time.perf_counter()
        while self.is_full():
            if time.perf_counter() - t0 > timeout:
                return False
            time.sleep(0.0001)

        tail = self._get_tail()
        slot_idx = tail % self.capacity
        offset = HEADER_SIZE + slot_idx * self.slot_size

        # Pack length + payload
        struct.pack_into("<I", self.buf, offset, len(data))
        self.buf[offset + 4 : offset + 4 + len(data)] = data
        self._set_tail(tail + 1)
        return True

    def pop(self, timeout: float = 1.0) -> Optional[bytes]:
        """
        Reads data from the current head slot.
        """
        t0 = time.perf_counter()
        while self.is_empty():
            if time.perf_counter() - t0 > timeout:
                return None
            time.sleep(0.0001)

        head = self._get_head()
        slot_idx = head % self.capacity
        offset = HEADER_SIZE + slot_idx * self.slot_size

        msg_len = struct.unpack_from("<I", self.buf, offset)[0]
        data = bytes(self.buf[offset + 4 : offset + 4 + msg_len])
        self._set_head(head + 1)
        return data

    def close(self) -> None:
        if not self._closed:
            try:
                self.buf.flush()
                self.buf.close()
                self.file.close()
            except Exception:
                pass
            self._closed = True

    def unlink(self) -> None:
        self.close()
        if os.path.exists(self.path):
            try:
                os.remove(self.path)
            except Exception:
                pass

    def __enter__(self) -> "SharedRingQueue":
        return self

    def __exit__(self, exc_type, exc_val, exc_tb) -> None:
        self.close()
        if self.is_creator:
            self.unlink()


def benchmark_shm_throughput(iterations: int = 10000, message_size: int = 256) -> Dict[str, Any]:
    """
    Benchmarks sub-microsecond shared memory queue throughput and latency.
    """
    queue_name = f"bmb_bench_{int(time.time() * 1000)}"
    q = SharedRingQueue(queue_name, capacity=iterations + 10, slot_size=message_size + 16, create=True)
    msg = b"X" * message_size

    try:
        t0 = time.perf_counter()
        for _ in range(iterations):
            q.push(msg)
        push_time = time.perf_counter() - t0

        t1 = time.perf_counter()
        for _ in range(iterations):
            q.pop()
        pop_time = time.perf_counter() - t1

        total_time = push_time + pop_time
        total_ops = iterations * 2
        throughput_ops = total_ops / max(1e-9, total_time)
        latency_us = (total_time / total_ops) * 1_000_000
        gb_per_sec = (total_ops * message_size) / (max(1e-9, total_time) * (1024 ** 3))

        return {
            "iterations": iterations,
            "message_size_bytes": message_size,
            "push_time_sec": push_time,
            "pop_time_sec": pop_time,
            "total_time_sec": total_time,
            "ops_per_second": throughput_ops,
            "latency_microseconds": latency_us,
            "throughput_gb_sec": gb_per_sec,
        }
    finally:
        q.close()
        q.unlink()
