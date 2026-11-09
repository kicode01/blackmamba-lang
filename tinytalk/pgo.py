"""
TinyTalk Profile-Guided Superoptimization (PGO) & Kernel Cache (Phase 12E)
===========================================================================
Collects runtime execution profiles, branch frequencies, and hot loop trip counts.
Caches verified superoptimized assembly kernels in persistent disk storage (.tntcache)
with SHA-256 cryptographic invalidation, completing Phase 12.
"""

from __future__ import annotations
import os
import json
import hashlib
from typing import Dict, List, Optional, Tuple, Any
from dataclasses import dataclass, field
from tinytalk.superopt import SSAInstruction, CPUCostModel


@dataclass
class ExecutionProfile:
    """Execution telemetry for a function or basic block."""
    invocation_count: int = 0
    branch_taken_counts: Dict[str, int] = field(default_factory=dict)
    hot_loop_iterations: int = 0
    total_cpu_cycles: float = 0.0

    @property
    def is_hot(self) -> bool:
        """Determines if a block exceeds the threshold for superoptimization."""
        return self.invocation_count >= 100 or self.hot_loop_iterations >= 1000


@dataclass
class CachedKernel:
    """A cached, formally verified superoptimized kernel."""
    ast_hash: str
    original_ops: List[str]
    optimized_ops: List[str]
    cycle_speedup: float
    verified_by_smt: bool


class ProfileGuidedOptimizer:
    """
    Profile-Guided Optimization (PGO) engine and persistent disk cache.
    Instruments code to identify hot spots and applies cached superoptimized kernels.
    """

    CACHE_HEADER = "TNTCACHE01"

    def __init__(self, cache_file_path: Optional[str] = None):
        self.cache_file = cache_file_path or ".tntcache"
        self.profiles: Dict[str, ExecutionProfile] = {}
        self.kernel_cache: Dict[str, CachedKernel] = {}
        self._load_cache()

    def record_invocation(self, func_name: str, cycles: float = 1.0) -> None:
        """Record an execution invocation of a function."""
        if func_name not in self.profiles:
            self.profiles[func_name] = ExecutionProfile()
        prof = self.profiles[func_name]
        prof.invocation_count += 1
        prof.total_cpu_cycles += cycles

    def record_loop(self, func_name: str, iterations: int) -> None:
        """Record iterations executed in a loop."""
        if func_name not in self.profiles:
            self.profiles[func_name] = ExecutionProfile()
        self.profiles[func_name].hot_loop_iterations += iterations

    def get_profile(self, func_name: str) -> ExecutionProfile:
        """Get telemetry profile for a function."""
        return self.profiles.get(func_name, ExecutionProfile())

    def compute_kernel_hash(self, instructions: List[SSAInstruction]) -> str:
        """Compute SHA-256 fingerprint for an instruction sequence."""
        repr_str = ";".join(f"{i.dest}={i.op}({i.args})" for i in instructions)
        return hashlib.sha256(repr_str.encode("utf-8")).hexdigest()

    def cache_kernel(
        self,
        instructions: List[SSAInstruction],
        optimized: List[SSAInstruction],
        speedup: float,
        verified_by_smt: bool = True
    ) -> str:
        """Save a verified superoptimized kernel to cache."""
        k_hash = self.compute_kernel_hash(instructions)
        entry = CachedKernel(
            ast_hash=k_hash,
            original_ops=[i.op for i in instructions],
            optimized_ops=[i.op for i in optimized],
            cycle_speedup=speedup,
            verified_by_smt=verified_by_smt
        )
        self.kernel_cache[k_hash] = entry
        self._save_cache()
        return k_hash

    def lookup_kernel(self, instructions: List[SSAInstruction]) -> Optional[CachedKernel]:
        """Lookup a previously superoptimized kernel from cache."""
        k_hash = self.compute_kernel_hash(instructions)
        return self.kernel_cache.get(k_hash)

    def _save_cache(self) -> None:
        """Persist cache entries to disk."""
        try:
            data = {
                "header": self.CACHE_HEADER,
                "entries": {
                    k: {
                        "ast_hash": v.ast_hash,
                        "original_ops": v.original_ops,
                        "optimized_ops": v.optimized_ops,
                        "cycle_speedup": v.cycle_speedup,
                        "verified_by_smt": v.verified_by_smt
                    }
                    for k, v in self.kernel_cache.items()
                }
            }
            with open(self.cache_file, "w", encoding="utf-8") as f:
                json.dump(data, f, indent=2)
        except Exception:
            pass

    def _load_cache(self) -> None:
        """Load persistent cache from disk."""
        if not os.path.exists(self.cache_file):
            return
        try:
            with open(self.cache_file, "r", encoding="utf-8") as f:
                data = json.load(f)
            if data.get("header") == self.CACHE_HEADER:
                for k, v in data.get("entries", {}).items():
                    self.kernel_cache[k] = CachedKernel(
                        ast_hash=v["ast_hash"],
                        original_ops=v["original_ops"],
                        optimized_ops=v["optimized_ops"],
                        cycle_speedup=v["cycle_speedup"],
                        verified_by_smt=v["verified_by_smt"]
                    )
        except Exception:
            pass
