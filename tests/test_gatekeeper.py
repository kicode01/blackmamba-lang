# tests/test_gatekeeper.py
# Verification of PreReleaseGatekeeper pipeline

import unittest
from mamba.gatekeeper import PreReleaseGatekeeper


class TestPreReleaseGatekeeper(unittest.TestCase):

    def setUp(self):
        self.gk = PreReleaseGatekeeper()

    def test_stage1_stdlib_syntax_and_mir_check(self):
        res = self.gk.stage1_stdlib_syntax_and_mir_check()
        self.assertTrue(res["passed"], f"Stdlib compilation failed: {res.get('errors')}")
        self.assertTrue(res["total_modules"] >= 30)
        self.assertEqual(res["total_modules"], res["compiled_modules"])

    def test_stage4_multi_target_emitter_matrix(self):
        res = self.gk.stage4_multi_target_emitter_matrix()
        self.assertTrue(res["passed"], f"Target emitters failed: {res.get('targets')}")
        for target, ok in res["targets"].items():
            self.assertTrue(ok, f"Target {target} failed verification")

    def test_stage5_packaging_and_manifest_check(self):
        res = self.gk.stage5_packaging_and_manifest_check()
        self.assertTrue(res["passed"], f"Version mismatch: {res.get('versions')}")
        self.assertTrue(res["consistent"])


if __name__ == "__main__":
    unittest.main()
