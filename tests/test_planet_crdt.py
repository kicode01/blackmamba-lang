"""Unit tests for TinyTalk Planetary CRDT Substrate (Phase 11B - v4.1.0)."""
import unittest
from tinytalk.planet import VectorClock, PNCounter, LWWRegister, ORSet, PlanetaryActor
import tinytalk.planet as mamba_planet


class TestPlanetaryCRDT(unittest.TestCase):
    def test_vector_clock_causality(self):
        vc1 = VectorClock()
        vc1.increment("us-east")
        vc1.increment("us-east")

        vc2 = vc1.clone()
        vc2.increment("eu-west")

        self.assertTrue(vc1.is_strictly_before(vc2))
        self.assertTrue(vc2.is_descendant_of(vc1))
        self.assertFalse(vc1.is_concurrent(vc2))

        # Concurrent branch
        vc3 = vc1.clone()
        vc3.increment("ap-south")

        self.assertTrue(vc2.is_concurrent(vc3))
        self.assertTrue(vc3.is_concurrent(vc2))

        # Merge
        merged = vc2.merge(vc3)
        self.assertEqual(merged.get("us-east"), 2)
        self.assertEqual(merged.get("eu-west"), 1)
        self.assertEqual(merged.get("ap-south"), 1)
        self.assertTrue(merged.is_descendant_of(vc2))
        self.assertTrue(merged.is_descendant_of(vc3))

    def test_pn_counter_convergence(self):
        # 3 replicas in different regions
        node_a = PNCounter("region-a")
        node_b = PNCounter("region-b")
        node_c = PNCounter("region-c")

        # Concurrent mutations
        node_a.increment(10)
        node_a.decrement(2)

        node_b.increment(50)
        node_b.decrement(15)

        node_c.increment(100)

        # Pairwise and 3-way merge
        merge_ab = node_a.merge(node_b)
        self.assertEqual(merge_ab.value, (10 - 2) + (50 - 15))

        converged_1 = merge_ab.merge(node_c)
        converged_2 = node_c.merge(node_b).merge(node_a)

        # Convergence invariant
        self.assertEqual(converged_1.value, converged_2.value)
        self.assertEqual(converged_1.value, (8 + 35 + 100))

    def test_lww_register_conflict_resolution(self):
        reg_a = LWWRegister("old_value", timestamp=100.0, node_id="node-1")
        reg_b = LWWRegister("new_value", timestamp=150.0, node_id="node-2")

        merged = reg_a.merge(reg_b)
        self.assertEqual(merged.get(), "new_value")

        # Equal timestamp tie-break on node_id
        reg_tie1 = LWWRegister("val_alpha", timestamp=200.0, node_id="node-A")
        reg_tie2 = LWWRegister("val_beta", timestamp=200.0, node_id="node-B")

        merged_tie = reg_tie1.merge(reg_tie2)
        self.assertEqual(merged_tie.get(), "val_beta")

    def test_or_set_add_wins_semantics(self):
        set_a = ORSet()
        set_b = ORSet()

        # Both add 'apple'
        set_a.add("apple")
        set_b.add("banana")

        # Merge
        merged = set_a.merge(set_b)
        self.assertTrue(merged.contains("apple"))
        self.assertTrue(merged.contains("banana"))

        # Replicas diverge: set_a removes apple, set_b concurrently adds another apple
        set_a_synced = merged.clone()
        set_b_synced = merged.clone()

        set_a_synced.remove("apple")
        set_b_synced.add("apple")  # Concurrent add

        # When merged, Add-Wins ensures 'apple' remains
        final_merge = set_a_synced.merge(set_b_synced)
        self.assertTrue(final_merge.contains("apple"))

        # Compaction
        final_merge.compact()
        self.assertTrue(final_merge.contains("apple"))

    def test_planetary_actor_lifecycle_and_migration(self):
        actor_a = PlanetaryActor("actor-hft-trader", "us-east")
        actor_a.set_counter("trades_executed", 42)
        actor_a.set_register("last_price", 94500.50)
        actor_a.add_to_set("open_orders", "order-101")
        actor_a.add_to_set("open_orders", "order-102")

        # Migrate actor live across the world to eu-west
        actor_a.migrate_to("eu-west")
        self.assertEqual(actor_a.current_region, "eu-west")
        self.assertIn("eu-west", actor_a.migration_history)

        actor_a.set_counter("trades_executed", 8)  # total 50
        actor_a.remove_from_set("open_orders", "order-101")

        state = actor_a.export_state()
        self.assertEqual(state["current_region"], "eu-west")
        self.assertEqual(state["counters"]["trades_executed"], 50)
        self.assertEqual(state["registers"]["last_price"], 94500.50)
        self.assertEqual(state["sets"]["open_orders"], ["order-102"])

    def test_mamba_backward_compatibility_shim(self):
        # Ensure import tinytalk.planet works identically
        mc = mamba_planet.PNCounter("compat-node")
        mc.increment(7)
        self.assertEqual(mc.value, 7)


if __name__ == "__main__":
    unittest.main()
