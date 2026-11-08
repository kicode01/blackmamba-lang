# Unit tests for Phase 8F (v2.9.0): Pure .bmb Self-Hosting Optimizer & Linker Convergence
# Validates self-hosted modules, optimizer passes, binary emitters, and bit-for-bit stage parity.

import unittest
from mamba.selfhost import SelfHostManager
from mamba.cli import main


class TestPhase8FSelfHost(unittest.TestCase):

    def setUp(self):
        self.sh = SelfHostManager()

    def test_selfhost_module_inventory(self):
        """Verify that all 11 pure .bmb self-hosted compiler modules compile to valid MIR."""
        modules = self.sh.list_selfhost_modules()
        expected = [
            "constfold.bmb",
            "dce.bmb",
            "driver.bmb",
            "elf_builder.bmb",
            "escape.bmb",
            "inline.bmb",
            "macho_builder.bmb",
            "mir_types.bmb",
            "parity.bmb",
            "pe_builder.bmb",
            "struct_layout.bmb",
        ]
        self.assertEqual(modules, expected)
        status = self.sh.get_selfhost_status()
        self.assertEqual(status["module_count"], 11)
        self.assertTrue(status["all_mir_valid"])
        self.assertGreater(status["total_loc"], 700)

    def test_selfhost_optimizer_and_builders_compilation(self):
        """Verify that every self-hosted module compiles with zero errors."""
        ok, errors = self.sh.verify_all_modules()
        self.assertTrue(ok, f"Self-host verification failed with errors: {errors}")
        self.assertEqual(len(errors), 0)

    def test_selfhost_stage2_stage3_parity(self):
        """Verify bit-for-bit self-compilation reproducibility between Stage-2 and Stage-3."""
        parity_res = self.sh.check_stage_parity()
        self.assertTrue(parity_res["parity_verified"])
        self.assertTrue(parity_res["stage2_stage3_match"])
        self.assertEqual(parity_res["stage2_hash"], parity_res["stage3_hash"])
        self.assertGreater(parity_res["mir_instruction_count"], 1000)

    def test_selfhost_bench(self):
        """Verify compilation throughput measurement."""
        bench_res = self.sh.benchmark_selfhost()
        self.assertEqual(bench_res["modules_compiled"], 11)
        self.assertGreater(bench_res["total_functions"], 50)
        self.assertGreater(bench_res["functions_per_second"], 100.0)

    def test_cli_selfhost_commands(self):
        """Verify CLI commands `bmb selfhost info`, `bmb selfhost check`, `bmb selfhost check --parity`."""
        ret_info = main(["selfhost", "info", "--json"])
        self.assertEqual(ret_info, 0)

        ret_chk = main(["selfhost", "check"])
        self.assertEqual(ret_chk, 0)

        ret_parity = main(["selfhost", "check", "--parity"])
        self.assertEqual(ret_parity, 0)

        ret_bench = main(["selfhost", "bench", "--json"])
        self.assertEqual(ret_bench, 0)


if __name__ == "__main__":
    unittest.main()
