"""
TinyTalk Phase 14B: Microfluidic Spatial Droplet Control Flow & Lab-on-a-Chip Routing
Simulates Digital Microfluidic (DMF) 2D electrode arrays, electrowetting-on-dielectric
(EWOD) droplet transport, coalescence (merging), and spatial non-interference routing.
"""

from typing import List, Dict, Any, Tuple, Optional
import math
import random

class Droplet:
    """Represents a picoliter/nanoliter discrete liquid droplet on an electrode array."""
    def __init__(self, droplet_id: int, volume_nl: float, x: int, y: int, reagent: str = "H2O"):
        self.droplet_id = droplet_id
        self.volume_nl = max(0.01, volume_nl)
        self.x = x
        self.y = y
        self.reagent = reagent


class MicrofluidicChip:
    """
    2D Digital Microfluidics (DMF) Grid Electrode Array.
    Enforces physical fluidic collision avoidance and spatial isolation rules.
    """
    def __init__(self, width: int = 16, height: int = 16):
        self.width = width
        self.height = height
        self.droplets: Dict[int, Droplet] = {}
        self.next_droplet_id = 1

    def dispense(self, x: int, y: int, volume_nl: float = 1.0, reagent: str = "sample") -> Optional[Droplet]:
        """Dispense a new droplet at electrode coordinate (x, y)."""
        if not (0 <= x < self.width and 0 <= y < self.height):
            return None
        # Check if cell is occupied
        for d in self.droplets.values():
            if d.x == x and d.y == y:
                return None
        d = Droplet(self.next_droplet_id, volume_nl, x, y, reagent)
        self.droplets[self.next_droplet_id] = d
        self.next_droplet_id += 1
        return d

    def move(self, droplet_id: int, target_x: int, target_y: int) -> bool:
        """Move a droplet to an adjacent electrode via EWOD activation."""
        if droplet_id not in self.droplets:
            return False
        if not (0 <= target_x < self.width and 0 <= target_y < self.height):
            return False

        d = self.droplets[droplet_id]
        # Must be adjacent move (Manhattan distance <= 1)
        dist = abs(d.x - target_x) + abs(d.y - target_y)
        if dist > 1:
            return False

        # Collision check
        for other in self.droplets.values():
            if other.droplet_id != droplet_id and other.x == target_x and other.y == target_y:
                return False

        d.x = target_x
        d.y = target_y
        return True

    def merge(self, d1_id: int, d2_id: int) -> Optional[Droplet]:
        """Coalesce two adjacent droplets into a single combined droplet."""
        if d1_id not in self.droplets or d2_id not in self.droplets or d1_id == d2_id:
            return None

        d1 = self.droplets[d1_id]
        d2 = self.droplets[d2_id]
        dist = abs(d1.x - d2.x) + abs(d1.y - d2.y)
        if dist > 1:
            return None # Must be adjacent to merge

        combined_volume = d1.volume_nl + d2.volume_nl
        combined_reagent = f"{d1.reagent}+{d2.reagent}"
        pos_x, pos_y = d1.x, d1.y

        del self.droplets[d1_id]
        del self.droplets[d2_id]

        new_d = Droplet(self.next_droplet_id, combined_volume, pos_x, pos_y, combined_reagent)
        self.droplets[self.next_droplet_id] = new_d
        self.next_droplet_id += 1
        return new_d

    def split(self, droplet_id: int) -> Optional[Tuple[Droplet, Droplet]]:
        """Split a droplet into two half-volume droplets at adjacent empty cell."""
        if droplet_id not in self.droplets:
            return None

        d = self.droplets[droplet_id]
        half_vol = d.volume_nl / 2.0

        # Find adjacent free cell for daughter droplet
        free_pos = None
        for dx, dy in [(1, 0), (-1, 0), (0, 1), (0, -1)]:
            nx, ny = d.x + dx, d.y + dy
            if 0 <= nx < self.width and 0 <= ny < self.height:
                if not any(other.x == nx and other.y == ny for other in self.droplets.values()):
                    free_pos = (nx, ny)
                    break

        if not free_pos:
            return None

        del self.droplets[droplet_id]

        d1 = Droplet(self.next_droplet_id, half_vol, d.x, d.y, d.reagent)
        self.droplets[self.next_droplet_id] = d1
        self.next_droplet_id += 1

        d2 = Droplet(self.next_droplet_id, half_vol, free_pos[0], free_pos[1], d.reagent)
        self.droplets[self.next_droplet_id] = d2
        self.next_droplet_id += 1

        return (d1, d2)

    def total_volume_nl(self) -> float:
        """Total fluid volume across all active droplets on chip."""
        return sum(d.volume_nl for d in self.droplets.values())
