"""
TinyTalk Phase 14C: Reconfigurable Molecular Lattice Topology & Tile Assembly
Implements the abstract Tile Assembly Model (aTAM) for programmable molecular
self-assembly: Wang tiles, glue binding strengths, and crystal nucleation.
"""

from typing import List, Dict, Any, Tuple, Optional
import random

class WangTile:
    """
    A square molecular unit with specific glue types on its 4 edges:
    North, East, South, West.
    """
    def __init__(self, tile_type: str, north: str, east: str, south: str, west: str):
        self.tile_type = tile_type
        self.north = north
        self.east = east
        self.south = south
        self.west = west


class MolecularLattice:
    """
    2D Self-Assembling Molecular Lattice under temperature tau.
    A tile binds at coordinate (x, y) if total matching glue strength >= tau.
    """
    def __init__(self, temperature: int = 2):
        self.temperature = temperature
        self.grid: Dict[Tuple[int, int], WangTile] = {}
        self.glue_strengths: Dict[str, int] = {} # glue_name -> strength (default 1)

    def set_glue_strength(self, glue_name: str, strength: int) -> None:
        self.glue_strengths[glue_name] = max(0, strength)

    def get_glue_strength(self, glue_name: str) -> int:
        if glue_name in ("null", "0", ""):
            return 0
        return self.glue_strengths.get(glue_name, 1)

    def place_seed(self, x: int, y: int, tile: WangTile) -> None:
        """Place seed tile on lattice to initiate crystal nucleation."""
        self.grid[(x, y)] = tile

    def compute_binding_strength(self, x: int, y: int, tile: WangTile) -> int:
        """Compute total glue affinity if tile were placed at (x, y)."""
        strength = 0
        # Check North neighbor (its South must match candidate's North)
        if (x, y + 1) in self.grid:
            neighbor = self.grid[(x, y + 1)]
            if neighbor.south == tile.north and tile.north not in ("null", "0"):
                strength += self.get_glue_strength(tile.north)

        # Check South neighbor (its North must match candidate's South)
        if (x, y - 1) in self.grid:
            neighbor = self.grid[(x, y - 1)]
            if neighbor.north == tile.south and tile.south not in ("null", "0"):
                strength += self.get_glue_strength(tile.south)

        # Check East neighbor (its West must match candidate's East)
        if (x + 1, y) in self.grid:
            neighbor = self.grid[(x + 1, y)]
            if neighbor.west == tile.east and tile.east not in ("null", "0"):
                strength += self.get_glue_strength(tile.east)

        # Check West neighbor (its East must match candidate's West)
        if (x - 1, y) in self.grid:
            neighbor = self.grid[(x - 1, y)]
            if neighbor.east == tile.west and tile.west not in ("null", "0"):
                strength += self.get_glue_strength(tile.west)

        return strength

    def can_attach(self, x: int, y: int, tile: WangTile) -> bool:
        """Check if tile satisfies cooperative binding threshold tau."""
        if (x, y) in self.grid:
            return False
        affinity = self.compute_binding_strength(x, y, tile)
        return affinity >= self.temperature

    def assemble_step(self, tile_set: List[WangTile], max_radius: int = 10) -> Optional[Tuple[int, int, WangTile]]:
        """Attempt to attach one valid tile from tile_set at an open border location."""
        # Find all open candidate positions adjacent to existing tiles
        candidate_positions = set()
        for (x, y) in self.grid:
            for dx, dy in [(0, 1), (0, -1), (1, 0), (-1, 0)]:
                nx, ny = x + dx, y + dy
                if (nx, ny) not in self.grid and abs(nx) <= max_radius and abs(ny) <= max_radius:
                    candidate_positions.add((nx, ny))

        for pos in sorted(list(candidate_positions)):
            for tile in tile_set:
                if self.can_attach(pos[0], pos[1], tile):
                    self.grid[pos] = tile
                    return (pos[0], pos[1], tile)
        return None
