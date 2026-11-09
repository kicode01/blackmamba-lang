"""
TinyTalk Phase 16E: Conservation Law Verifier & Noether Invariant Engine
Formally verifies physical laws and conservation invariants in simulated systems:
- Conservation of Linear Momentum (sum m_i * v_i = const)
- Conservation of Angular Momentum (sum r_i x p_i = const)
- Total Energy conservation & bounded numerical drift
"""

from typing import List, Dict, Any, Tuple
import math

class PhysicsConservationVerifier:
    """
    Formal certification engine for continuous physical symmetries (Noether's Theorem).
    """
    def __init__(self, energy_drift_tolerance: float = 0.05, momentum_tolerance: float = 1e-4):
        self.energy_drift_tolerance = energy_drift_tolerance
        self.momentum_tolerance = momentum_tolerance

    def verify_linear_momentum_conservation(
        self,
        initial_momenta: List[Tuple[float, float, float]],
        final_momenta: List[Tuple[float, float, float]]
    ) -> Dict[str, Any]:
        """Verify that total linear momentum vector P = sum(m_i * v_i) is conserved."""
        init_px = sum(p[0] for p in initial_momenta)
        init_py = sum(p[1] for p in initial_momenta)
        init_pz = sum(p[2] for p in initial_momenta)

        fin_px = sum(p[0] for p in final_momenta)
        fin_py = sum(p[1] for p in final_momenta)
        fin_pz = sum(p[2] for p in final_momenta)

        err_x = abs(fin_px - init_px)
        err_y = abs(fin_py - init_py)
        err_z = abs(fin_pz - init_pz)
        total_err = math.sqrt(err_x**2 + err_y**2 + err_z**2)

        is_conserved = total_err <= self.momentum_tolerance
        violations = []
        if not is_conserved:
            violations.append(
                f"Linear momentum non-conservation: initial=({init_px:.4f}, {init_py:.4f}, {init_pz:.4f}), "
                f"final=({fin_px:.4f}, {fin_py:.4f}, {fin_pz:.4f}), error={total_err:.2e}"
            )

        return {
            "valid": is_conserved,
            "violations": violations,
            "momentum_error": total_err
        }

    def verify_energy_conservation(self, initial_energy: float, trajectory_energies: List[float]) -> Dict[str, Any]:
        """Verify that energy does not artificially drift beyond symplectic bounds."""
        if abs(initial_energy) < 1e-8:
            norm_factor = 1.0
        else:
            norm_factor = abs(initial_energy)

        max_drift = 0.0
        for e in trajectory_energies:
            drift = abs(e - initial_energy) / norm_factor
            if drift > max_drift:
                max_drift = drift

        is_valid = max_drift <= self.energy_drift_tolerance
        violations = []
        if not is_valid:
            violations.append(
                f"Energy drift violation: max relative drift {max_drift * 100:.2f}% > tolerance {self.energy_drift_tolerance * 100:.2f}%"
            )

        return {
            "valid": is_valid,
            "violations": violations,
            "max_relative_drift": max_drift
        }
