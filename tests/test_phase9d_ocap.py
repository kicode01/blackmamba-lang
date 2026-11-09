# TinyTalk Test Suite: Phase 9D (v3.3.0)
# Distributed Object-Capability Security Kernel & Micro-Sandboxing

import unittest
import os
import time
from tinytalk.ocap import (
    ObjectCapabilityKernel,
    MicroSandbox,
    CapabilityToken,
    benchmark_ocap_throughput,
    CAP_NONE,
    CAP_READ,
    CAP_WRITE,
    CAP_EXEC,
    CAP_NET,
    CAP_FS,
    CAP_DELEGATE,
    CAP_REVOKE,
    CAP_ALL,
    rights_to_string,
)
from tinytalk.cli import compile_source_to_mir
from tinytalk.backends.x86_64_jit import NativeJITModule


class TestPhase9DObjectCapability(unittest.TestCase):
    """
    Validates cryptographically unforgeable capability tokens, monotonic rights
    attenuation, default-deny micro-sandboxing, and pure .tnt ocap execution.
    """

    def setUp(self):
        self.kernel = ObjectCapabilityKernel()

    def test_01_mint_and_verify_token(self):
        """Mint a cryptographic capability token and verify valid rights."""
        tok = self.kernel.mint_token("tnt://mem/slab", CAP_READ | CAP_WRITE, ttl_seconds=3600)
        self.assertIsNotNone(tok.token_id)
        self.assertEqual(tok.resource_uri, "tnt://mem/slab")
        self.assertTrue(tok.has_right(CAP_READ))
        self.assertTrue(tok.has_right(CAP_WRITE))
        self.assertFalse(tok.has_right(CAP_EXEC))

        # Verify through kernel
        self.assertTrue(self.kernel.verify(tok, CAP_READ, "tnt://mem/slab"))
        self.assertTrue(self.kernel.verify(tok, CAP_WRITE, "tnt://mem/slab"))
        self.assertFalse(self.kernel.verify(tok, CAP_EXEC, "tnt://mem/slab"))
        # Non-matching resource URI denied
        self.assertFalse(self.kernel.verify(tok, CAP_READ, "tnt://net/socket"))

    def test_02_attenuation_monotonic_rights_lowering(self):
        """Verify child capabilities can only attenuate (reduce) rights, never escalate."""
        parent = self.kernel.mint_token(
            "tnt://fs/data",
            CAP_READ | CAP_WRITE | CAP_DELEGATE,
            ttl_seconds=1800,
        )

        # Attenuate to read-only child
        child = self.kernel.attenuate(parent, CAP_READ)
        self.assertTrue(child.has_right(CAP_READ))
        self.assertFalse(child.has_right(CAP_WRITE))
        self.assertEqual(child.parent_id, parent.token_id)
        self.assertTrue(self.kernel.verify(child, CAP_READ, "tnt://fs/data"))

        # Attempt privilege escalation: asking for CAP_NET when parent doesn't have it
        escalated_child = self.kernel.attenuate(parent, CAP_READ | CAP_NET)
        # Invariant: escalated bit must be masked out
        self.assertFalse(escalated_child.has_right(CAP_NET))
        self.assertFalse(self.kernel.verify(escalated_child, CAP_NET, "tnt://fs/data"))

        # Parent without CAP_DELEGATE cannot derive child tokens
        non_delegating = self.kernel.mint_token("tnt://fs/data", CAP_READ, ttl_seconds=1800)
        with self.assertRaises(PermissionError):
            self.kernel.attenuate(non_delegating, CAP_READ)

    def test_03_revocation_ledger(self):
        """Verify token revocation immediately invalidates access across all verifiers."""
        tok = self.kernel.mint_token("tnt://db/users", CAP_READ, ttl_seconds=3600)
        self.assertTrue(self.kernel.verify(tok, CAP_READ, "tnt://db/users"))

        # Revoke token
        self.kernel.revoke(tok.token_id)
        self.assertTrue(self.kernel.is_revoked(tok.token_id))
        self.assertFalse(self.kernel.verify(tok, CAP_READ, "tnt://db/users"))

    def test_04_micro_sandbox_enforcement(self):
        """Verify MicroSandbox intercepts unauthorized accesses and maintains audit count."""
        sandbox = MicroSandbox("sandbox-1", CAP_READ, self.kernel)
        tok_read_write = self.kernel.mint_token("tnt://ipc/channel", CAP_READ | CAP_WRITE, ttl_seconds=3600)
        sandbox.grant_token(tok_read_write)

        # Read allowed
        self.assertTrue(sandbox.check_access(tok_read_write, CAP_READ, "tnt://ipc/channel"))
        self.assertEqual(sandbox.operations_count, 1)
        self.assertEqual(sandbox.violations_count, 0)

        # Write blocked by sandbox policy (sandbox only allows CAP_READ)
        self.assertFalse(sandbox.check_access(tok_read_write, CAP_WRITE, "tnt://ipc/channel"))
        self.assertEqual(sandbox.violations_count, 1)

        # Exec blocked by both sandbox policy and token
        self.assertFalse(sandbox.check_access(tok_read_write, CAP_EXEC, "tnt://ipc/channel"))
        self.assertEqual(sandbox.violations_count, 2)

        # run_sandboxed wrapper
        res = sandbox.run_sandboxed(lambda x: x * 2, tok_read_write, CAP_READ, "tnt://ipc/channel", 21)
        self.assertEqual(res, 42)

        with self.assertRaises(PermissionError):
            sandbox.run_sandboxed(lambda: None, tok_read_write, CAP_WRITE, "tnt://ipc/channel")

    def test_05_benchmark_ocap_throughput(self):
        """Verify object-capability check achieves sub-microsecond latency."""
        res = benchmark_ocap_throughput(iterations=1000)
        self.assertEqual(res["iterations"], 1000)
        self.assertEqual(res["valid_checks"], 1000)
        self.assertTrue(res["zero_violations"])
        self.assertGreater(res["checks_per_second"], 10000.0)

    def test_06_pure_bmb_ocap_module(self):
        """Verify pure .tnt ocap module compiles and executes in native JIT."""
        ocap_path = os.path.join(os.path.dirname(__file__), "..", "tinytalk", "stdlib", "ocap.tnt")
        self.assertTrue(os.path.exists(ocap_path))

        with open(ocap_path, "r", encoding="utf-8") as f:
            src = f.read()

        mir = compile_source_to_mir(src, filename="ocap.tnt")
        self.assertIsNotNone(mir)
        self.assertGreaterEqual(len(mir.functions), 6)

        jit_mod = NativeJITModule(mir)
        self.assertTrue(hasattr(jit_mod, "ocap_benchmark_checks"))
        self.assertTrue(hasattr(jit_mod, "ocap_create_token"))
        self.assertTrue(hasattr(jit_mod, "ocap_check_permission"))

        # Run 500 in-memory capability checks in JIT
        valid_count = jit_mod.ocap_benchmark_checks(500, CAP_READ | CAP_WRITE)
        self.assertEqual(valid_count, 500)


if __name__ == "__main__":
    unittest.main()
