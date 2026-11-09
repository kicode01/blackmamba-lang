"""
Test Suite and Adversarial Minkowski Invariant Fuzzer for TinyTalk Phase 15C: Space Sync.
"""

import unittest
import random
import math
from tinytalk.space import SpacetimeEvent, PlanetaryNode, SPEED_OF_LIGHT_KM_S

class TestSpace(unittest.TestCase):
    def test_earth_moon_light_delay(self):
        # Earth at origin (0, 0, 0), Moon at (384400, 0, 0) km
        earth = PlanetaryNode("Earth", 0.0, 0.0, 0.0)
        moon = PlanetaryNode("Moon", 384400.0, 0.0, 0.0)

        delay = earth.light_travel_time_to(moon)
        # One-way delay ~1.282 seconds
        self.assertAlmostEqual(delay, 1.28222, places=3)

    def test_causal_light_cone_classification(self):
        e1 = SpacetimeEvent("E1", t_seconds=0.0, x_km=0.0, y_km=0.0, z_km=0.0)
        # Event 2: 1 second later, 100,000 km away (< c*1s = 299,792 km) -> Timelike
        e2_timelike = SpacetimeEvent("E2", t_seconds=1.0, x_km=100000.0, y_km=0.0, z_km=0.0)
        self.assertEqual(e1.causal_relationship(e2_timelike), "TIMELIKE")

        # Event 3: 1 second later, 500,000 km away (> c*1s) -> Spacelike
        e3_spacelike = SpacetimeEvent("E3", t_seconds=1.0, x_km=500000.0, y_km=0.0, z_km=0.0)
        self.assertEqual(e1.causal_relationship(e3_spacelike), "SPACELIKE")

    def test_adversarial_minkowski_interval_fuzzer_100_runs(self):
        """Fuzz Lorentz spacetime interval invariant across 100 randomized event pairs."""
        rng = random.Random(1905) # Special relativity year
        for trial in range(100):
            t1 = rng.uniform(0.0, 100.0)
            x1 = rng.uniform(-1e6, 1e6)
            y1 = rng.uniform(-1e6, 1e6)
            z1 = rng.uniform(-1e6, 1e6)

            dt = rng.uniform(-10.0, 10.0)
            dx = rng.uniform(-5e5, 5e5)
            dy = rng.uniform(-5e5, 5e5)
            dz = rng.uniform(-5e5, 5e5)

            eA = SpacetimeEvent("A", t1, x1, y1, z1)
            eB = SpacetimeEvent("B", t1 + dt, x1 + dx, y1 + dy, z1 + dz)

            s2_AB = eA.interval_squared(eB)
            s2_BA = eB.interval_squared(eA)

            # Invariant: Spacetime interval symmetry s^2(A, B) == s^2(B, A)
            self.assertAlmostEqual(s2_AB, s2_BA, places=3)

            # Invariant: Distance-to-time light cone classification consistency
            spatial_dist = math.sqrt(dx*dx + dy*dy + dz*dz)
            max_c_dist = SPEED_OF_LIGHT_KM_S * abs(dt)

            if spatial_dist < max_c_dist - 1.0:
                self.assertEqual(eA.causal_relationship(eB), "TIMELIKE")
            elif spatial_dist > max_c_dist + 1.0:
                self.assertEqual(eA.causal_relationship(eB), "SPACELIKE")

if __name__ == "__main__":
    unittest.main()
