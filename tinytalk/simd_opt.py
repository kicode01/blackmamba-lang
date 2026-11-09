"""
TinyTalk Auto-Vectorization & SIMD Superoptimizer (Phase 12D)
=============================================================
Identifies loop patterns and parallel scalar arithmetic sequences,
vectorizing them into AVX2, AVX-512, and ARM Neon SIMD intrinsics
with Fused Multiply-Add (FMA) loop fusion.
"""

from __future__ import annotations
from typing import List, Dict, Optional, Tuple, Any
from dataclasses import dataclass, field
from tinytalk.superopt import SSAInstruction, CPUCostModel


@dataclass
class VectorInstruction:
    """A vectorized SIMD instruction operating on wide registers."""
    dest_vreg: str
    simd_op: str
    vector_width: int   # 128, 256, or 512 bits
    lanes: int          # e.g., 4 lanes for 128-bit float, 8 lanes for 256-bit float
    operands: List[Any]
    is_fma: bool = False

    def __repr__(self) -> str:
        ops = ", ".join(str(o) for o in self.operands)
        fma_tag = " [FMA]" if self.is_fma else ""
        return f"{self.dest_vreg} = {self.simd_op}_{self.vector_width}b<{self.lanes}x>({ops}){fma_tag}"


class SIMDSuperoptimizer:
    """
    Auto-vectorization engine for loop and array arithmetic.
    Transforms consecutive scalar loads and operations into SIMD vector bursts.
    """

    def __init__(self, target_vector_width: int = 256):
        self.vector_width = target_vector_width  # 128, 256, or 512
        self.lanes = self.vector_width // 32     # Default to 32-bit elements (f32 / i32)

    def vectorize_scalar_chain(
        self, scalar_instrs: List[SSAInstruction]
    ) -> Tuple[List[VectorInstruction], float]:
        """
        Analyze a sequence of scalar instructions and pack parallelizable
        chains into vectorized instructions.
        Returns (vector_instructions, theoretical_speedup).
        """
        vectorized: List[VectorInstruction] = []
        if not scalar_instrs:
            return vectorized, 1.0

        # Detect FMA opportunities: a * b + c
        # Look for mul followed by add using the mul result
        mul_map: Dict[str, Tuple[Any, Any]] = {}
        used_muls: set[str] = set()

        for instr in scalar_instrs:
            if instr.op in ("mul", "imul", "fmul") and len(instr.args) == 2:
                mul_map[instr.dest] = (instr.args[0], instr.args[1])

        # Pre-pass: identify which muls will be fused into FMA
        fused_muls: set[str] = set()
        for instr in scalar_instrs:
            if instr.op in ("add", "fadd") and len(instr.args) == 2:
                if instr.args[0] in mul_map:
                    fused_muls.add(instr.args[0])
                elif instr.args[1] in mul_map:
                    fused_muls.add(instr.args[1])

        i = 0
        while i < len(scalar_instrs):
            instr = scalar_instrs[i]

            # If this multiply is fused into a subsequent FMA, skip emitting separate vmul
            if instr.dest in fused_muls and instr.op in ("mul", "imul", "fmul"):
                i += 1
                continue

            # Fused Multiply-Add (FMA) Detection
            if instr.op in ("add", "fadd") and len(instr.args) == 2:
                arg0, arg1 = instr.args[0], instr.args[1]
                if arg0 in mul_map and arg0 not in used_muls:
                    m0, m1 = mul_map[arg0]
                    used_muls.add(arg0)
                    vectorized.append(
                        VectorInstruction(
                            dest_vreg=f"ymm_{instr.dest}",
                            simd_op="vfmadd213",
                            vector_width=self.vector_width,
                            lanes=self.lanes,
                            operands=[m0, m1, arg1],
                            is_fma=True
                        )
                    )
                    i += 1
                    continue
                elif arg1 in mul_map and arg1 not in used_muls:
                    m0, m1 = mul_map[arg1]
                    used_muls.add(arg1)
                    vectorized.append(
                        VectorInstruction(
                            dest_vreg=f"ymm_{instr.dest}",
                            simd_op="vfmadd213",
                            vector_width=self.vector_width,
                            lanes=self.lanes,
                            operands=[m0, m1, arg0],
                            is_fma=True
                        )
                    )
                    i += 1
                    continue

            # Standard SIMD Vectorization
            if instr.op in ("add", "sub", "mul", "imul", "and", "or", "xor"):
                vectorized.append(
                    VectorInstruction(
                        dest_vreg=f"ymm_{instr.dest}",
                        simd_op=f"v{instr.op}",
                        vector_width=self.vector_width,
                        lanes=self.lanes,
                        operands=instr.args,
                        is_fma=False
                    )
                )
            elif instr.op not in used_muls:
                vectorized.append(
                    VectorInstruction(
                        dest_vreg=f"ymm_{instr.dest}",
                        simd_op=f"v{instr.op}",
                        vector_width=self.vector_width,
                        lanes=self.lanes,
                        operands=instr.args,
                        is_fma=False
                    )
                )
            i += 1

        # Calculate SIMD throughput speedup factor
        scalar_cost = len(scalar_instrs)
        # Vectorized instructions process `lanes` elements concurrently per cycle
        fma_savings = len(used_muls) * 0.5
        simd_cost = max(1.0, len(vectorized) - fma_savings)
        speedup = round((scalar_cost * (self.lanes / 2.0)) / simd_cost, 2)
        return vectorized, speedup
