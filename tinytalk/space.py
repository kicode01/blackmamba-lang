"""
TinyTalk Phase 15C: Relativistic Deep-Space Causal State Sync
Simulates special relativistic spacetime intervals, Minkowski light-cone partitions,
and interplanetary speed-of-light propagation delays (Earth-Mars-Moon).
"""

from typing import List, Dict, Any, Tuple, Optional
import math
import random

SPEED_OF_LIGHT_KM_S = 299792.458 # km / s

class SpacetimeEvent:
    """An event in 4D Minkowski spacetime (t, x, y, z)."""
    def __init__(self, event_id: str, t_seconds: float, x_km: float, y_km: float, z_km: float, payload: Any = None):
        self.event_id = event_id
        self.t = t_seconds
        self.x = x_km
        self.y = y_km
        self.z = z_km
        self.payload = payload

    def interval_squared(self, other: 'SpacetimeEvent') -> float:
        """
        Compute squared invariant spacetime interval:
        s^2 = c^2 * (dt)^2 - (dx^2 + dy^2 + dz^2)
        """
        dt = other.t - self.t
        dx = other.x - self.x
        dy = other.y - self.y
        dz = other.z - self.z
        spatial_dist_sq = dx*dx + dy*dy + dz*dz
        time_dist_sq = (SPEED_OF_LIGHT_KM_S * dt) ** 2
        return time_dist_sq - spatial_dist_sq

    def causal_relationship(self, other: 'SpacetimeEvent') -> str:
        """
        Classify causal structure between self and other:
        - 'TIMELIKE': causally connected (self can influence other if other.t > self.t)
        - 'LIGHTLIKE': connected by light-speed photon signal
        - 'SPACELIKE': causally disconnected (cannot influence each other)
        """
        s2 = self.interval_squared(other)
        if abs(s2) < 1.0: # Numerical tolerance
            return "LIGHTLIKE"
        elif s2 > 0:
            return "TIMELIKE"
        else:
            return "SPACELIKE"


class PlanetaryNode:
    """Represents an interplanetary computational node (e.g. Earth, Moon, Mars)."""
    def __init__(self, name: str, x_km: float, y_km: float, z_km: float):
        self.name = name
        self.x = x_km
        self.y = y_km
        self.z = z_km
        self.local_clock = 0.0

    def light_travel_time_to(self, other: 'PlanetaryNode') -> float:
        """Calculate one-way light delay in seconds: distance / c."""
        dx = other.x - self.x
        dy = other.y - self.y
        dz = other.z - self.z
        dist_km = math.sqrt(dx*dx + dy*dy + dz*dz)
        return dist_km / SPEED_OF_LIGHT_KM_S
