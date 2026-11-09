"""
Test Suite and Adversarial Fuzzer for TinyTalk Phase 13B: Intel Loihi 2 Microcode Emitter.
"""

import unittest
import random
import math
from tinytalk.loihi2 import Loihi2Core, STDPPlasticityEngine

class TestLoihi2(unittest.TestCase):
    def test_core_allocation_and_routing(self):
        core = Loihi2Core(core_id=0x10, max_compartments=2)
        self.assertTrue(core.allocate_compartment(0, v_threshold=1.0, decay=0.9))
        self.assertTrue(core.allocate_compartment(1, v_threshold=1.2, decay=0.85))
        # Exceed capacity
        self.assertFalse(core.allocate_compartment(2))

        core.add_axonal_route(src_comp=0, dest_core=0x20, dest_comp=4)
        mcode = core.emit_microcode()
        self.assertTrue(any("CORE_INIT 0x0010" in line for line in mcode))
        self.assertTrue(any("AXON_ROUTE C[000] -> CORE[0x0020]:C[004]" in line for line in mcode))

    def test_stdp_potentiation_and_depression(self):
        stdp = STDPPlasticityEngine(a_plus=0.05, a_minus=0.06, tau_plus=20.0, tau_minus=20.0)

        w_initial = 0.5
        # Pre before post (t_pre=10, t_post=15 -> dt=+5): LTP (weight increases)
        w_ltp = stdp.update_weight(w_initial, t_pre=10, t_post=15)
        self.assertGreater(w_ltp, w_initial)

        # Post before pre (t_pre=25, t_post=15 -> dt=-10): LTD (weight decreases)
        w_ltd = stdp.update_weight(w_initial, t_pre=25, t_post=15)
        self.assertLess(w_ltd, w_initial)

    def test_adversarial_stdp_fuzzer_100_runs(self):
        """Fuzz STDP weight plasticity across 100 randomized timing spikes."""
        rng = random.Random(42)
        stdp = STDPPlasticityEngine(w_min=0.0, w_max=1.0)
        for trial in range(100):
            current_w = rng.uniform(0.0, 1.0)
            t_pre = rng.randint(0, 1000)
            t_post = rng.randint(0, 1000)

            updated_w = stdp.update_weight(current_w, t_pre, t_post)

            # Invariant 1: Bounds clamp
            self.assertGreaterEqual(updated_w, 0.0)
            self.assertLessEqual(updated_w, 1.0)

            # Invariant 2: LTP directionality
            if t_post > t_pre:
                self.assertGreaterEqual(updated_w, current_w)
            elif t_post < t_pre:
                self.assertLessEqual(updated_w, current_w)
            else:
                self.assertEqual(updated_w, current_w)

if __name__ == "__main__":
    unittest.main()
