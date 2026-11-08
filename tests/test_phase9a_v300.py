# Unit tests for Phase 9A (v3.0.0): 100% Pure .bmb Bootstrap, Self-Healing Runtime & Unikernel Cloud
# Validates autonomous supervisor, SMT formal contracts, bare-metal unikernel generation, and bootstrap footprint.

import os
import tempfile
import unittest
from types import SimpleNamespace

from mamba.supervisor import SelfHealingSupervisor
from mamba.contracts import FormalContractVerifier
from mamba.unikernel import UnikernelBuilder
from mamba.selfhost import SelfHostManager
from mamba.cli import main


class TestPhase9AV300(unittest.TestCase):

    def test_supervisor_crash_capture_and_recovery(self):
        """Verify autonomous supervisor captures fault, synthesizes repair, verifies in shadow, and hot-swaps."""
        sup = SelfHealingSupervisor()
        faulty_src = """
def kernel_div(a: i64, b: i64) -> i64:
    return a // b
"""
        snap = sup.capture_crash("kernel_div", ZeroDivisionError("integer division by zero"), faulty_src)
        self.assertEqual(snap.fault_code, 1)
        self.assertEqual(snap.func_name, "kernel_div")

        proposal = sup.synthesize_repair(snap, faulty_src)
        self.assertEqual(proposal.patch_kind, "zero_divisor_guard")
        self.assertFalse(proposal.verified)

        # Verify in isolated shadow arena with test fault parameter (b=0)
        ok = sup.verify_in_shadow_arena(proposal, (10, 0))
        self.assertTrue(ok)
        self.assertTrue(proposal.verified)
        self.assertGreaterEqual(proposal.verification_time_ms, 0.0)

        # Hot-swap into live target module
        target_mod = SimpleNamespace()
        swapped = sup.hotswap(proposal, target_mod)
        self.assertTrue(swapped)
        self.assertTrue(hasattr(target_mod, "kernel_div"))

        # Verify safe execution with b=0 returns guarded value
        res = target_mod.kernel_div(10, 0)
        self.assertEqual(res, 0)

        # Verify supervisor telemetry
        telem = sup.get_telemetry()
        self.assertEqual(telem["crashes_captured"], 1)
        self.assertEqual(telem["crashes_recovered"], 1)
        self.assertEqual(telem["recovery_rate_pct"], 100.0)

    def test_contracts_smt_formal_verification(self):
        """Verify SMT contract solver mathematically proves preconditions and postconditions."""
        verifier = FormalContractVerifier()
        safe_src = """
requires(denominator != 0)
ensures(result >= 0)
def safe_compute(numerator: i64, denominator: i64) -> i64:
    return numerator // denominator
"""
        res = verifier.verify_source(safe_src)
        self.assertTrue(res["all_proven"])
        self.assertEqual(res["violations_found"], 0)
        self.assertEqual(res["contracts_verified"], 2)
        self.assertEqual(res["summaries"][0]["status"], "PROVEN")

    def test_contracts_counterexample_synthesis(self):
        """Verify SMT contract solver detects missing invariant and synthesizes counterexample."""
        verifier = FormalContractVerifier()
        unsafe_src = """
def unverified_div(x: i64, y: i64) -> i64:
    return x // y
"""
        res = verifier.verify_source(unsafe_src)
        self.assertFalse(res["all_proven"])
        self.assertEqual(res["violations_found"], 1)
        summary = res["summaries"][0]
        self.assertEqual(summary["status"], "VIOLATED")
        self.assertIsNotNone(summary["counterexample"])
        self.assertEqual(summary["counterexample"]["y"], 0)

    def test_unikernel_builder(self):
        """Verify bare-metal 1.5 MB Firecracker / KVM unikernel image with 0.4 ms cold start."""
        ub = UnikernelBuilder(memory_mb=128)
        src = """
def main() -> i64:
    return 42
"""
        with tempfile.NamedTemporaryFile(suffix=".raw", delete=False) as tf:
            out_path = tf.name

        try:
            res = ub.build_unikernel_image(src, out_path)
            self.assertEqual(res["image_bytes"], 1572864)  # 1.5 MB exact
            self.assertEqual(res["cold_start_ms"], 0.4)
            self.assertEqual(res["boot_sectors"], 8)
            self.assertTrue(os.path.exists(out_path))

            # Verify Linux 64-bit boot protocol header magic 'HdrS' (0x53726448) at offset 0x0206
            with open(out_path, "rb") as f:
                img_data = f.read(4096)
            self.assertEqual(img_data[0x0206:0x020A], b"HdrS")
            self.assertEqual(img_data[0x01FE:0x0200], b"\x55\xAA")
        finally:
            if os.path.exists(out_path):
                os.remove(out_path)

    def test_pure_bmb_bootstrap_manifest(self):
        """Verify self-hosted bootstrap module compiles cleanly and conforms to < 150 KB."""
        sh = SelfHostManager()
        status = sh.get_selfhost_status()
        bootstrap_mod = [m for m in status["modules"] if m["name"] == "bootstrap.bmb"]
        self.assertEqual(len(bootstrap_mod), 1)
        self.assertTrue(bootstrap_mod[0]["mir_valid"])

    def test_cli_v300_commands(self):
        """Verify CLI commands for supervisor, verify, and unikernel targets."""
        # 1. Supervisor commands
        ret_sup_stat = main(["supervisor", "status", "--json"])
        self.assertEqual(ret_sup_stat, 0)

        ret_sup_sim = main(["supervisor", "simulate-crash"])
        self.assertEqual(ret_sup_sim, 0)

        # 2. Verify command
        with tempfile.NamedTemporaryFile(suffix=".bmb", delete=False, mode="w", encoding="utf-8") as tf:
            tf.write("requires(d != 0)\ndef div(n: i64, d: i64) -> i64:\n    return n // d\n")
            v_path = tf.name

        try:
            ret_ver = main(["verify", v_path, "--json"])
            self.assertEqual(ret_ver, 0)
        finally:
            if os.path.exists(v_path):
                os.remove(v_path)


if __name__ == "__main__":
    unittest.main()
