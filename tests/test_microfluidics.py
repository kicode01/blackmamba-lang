"""
Test Suite and Adversarial Volume Conservation Fuzzer for TinyTalk Phase 14B: Microfluidics.
"""

import unittest
import random
from tinytalk.microfluidics import MicrofluidicChip

class TestMicrofluidics(unittest.TestCase):
    def test_dispense_move_and_merge(self):
        chip = MicrofluidicChip(width=8, height=8)
        d1 = chip.dispense(x=0, y=0, volume_nl=2.0, reagent="reagent_A")
        d2 = chip.dispense(x=2, y=0, volume_nl=3.0, reagent="reagent_B")
        self.assertIsNotNone(d1)
        self.assertIsNotNone(d2)

        # Move d2 adjacent to d1: (2, 0) -> (1, 0)
        self.assertTrue(chip.move(d2.droplet_id, 1, 0))

        # Merge d1 and d2
        merged = chip.merge(d1.droplet_id, d2.droplet_id)
        self.assertIsNotNone(merged)
        self.assertEqual(merged.volume_nl, 5.0)
        self.assertEqual(merged.reagent, "reagent_A+reagent_B")

    def test_split_droplet(self):
        chip = MicrofluidicChip(width=8, height=8)
        d = chip.dispense(x=4, y=4, volume_nl=4.0)
        split_res = chip.split(d.droplet_id)
        self.assertIsNotNone(split_res)
        d1, d2 = split_res
        self.assertEqual(d1.volume_nl, 2.0)
        self.assertEqual(d2.volume_nl, 2.0)
        self.assertEqual(chip.total_volume_nl(), 4.0)

    def test_adversarial_volume_conservation_fuzzer_100_runs(self):
        """Fuzz droplet physics: total volume must be strictly conserved under random split/merge/move operations."""
        rng = random.Random(888)
        chip = MicrofluidicChip(width=10, height=10)

        # Initial seeding: dispense 5 droplets
        for i in range(5):
            chip.dispense(x=i, y=0, volume_nl=rng.uniform(1.0, 5.0))

        initial_volume = chip.total_volume_nl()

        for step in range(100):
            action = rng.choice(["move", "merge", "split"])
            active_ids = list(chip.droplets.keys())
            if not active_ids:
                break

            if action == "move":
                d_id = rng.choice(active_ids)
                d = chip.droplets[d_id]
                dx, dy = rng.choice([(1, 0), (-1, 0), (0, 1), (0, -1)])
                chip.move(d_id, d.x + dx, d.y + dy)

            elif action == "merge" and len(active_ids) >= 2:
                d1_id = rng.choice(active_ids)
                d2_id = rng.choice([i for i in active_ids if i != d1_id])
                chip.merge(d1_id, d2_id)

            elif action == "split":
                d_id = rng.choice(active_ids)
                chip.split(d_id)

            # Invariant: Conservation of Liquid Volume across all EWOD operations
            current_vol = chip.total_volume_nl()
            self.assertAlmostEqual(
                initial_volume,
                current_vol,
                places=5,
                msg=f"Step {step}: Volume conservation violated! {initial_volume} != {current_vol}"
            )

if __name__ == "__main__":
    unittest.main()
