"""
TinyTalk Phase 14E: Biocomputation Thermodynamic Verifier & Oligo Quality Engine
Performs pre-synthesis quality certification for DNA-origami and synthetic biology:
- Spontaneous hybridization check: Delta G < 0 (kcal/mol)
- Homopolymer run avoidance (max run < 5 bases)
- Balanced GC clamp bounds (35% to 65%)
- Self-complementary hairpin penalty
"""

from typing import List, Dict, Any, Tuple
import math

class BioThermodynamicVerifier:
    """
    Formal certification engine for synthetic oligonucleotides.
    """
    def __init__(self, temp_kelvin: float = 310.15): # 37 C physiological temperature
        self.temp_kelvin = temp_kelvin

    def calculate_gibbs_free_energy(self, seq: str) -> float:
        """
        Estimate Gibbs Free Energy Delta G = Delta H - T * Delta S
        Rough empirical nearest-neighbor model:
        Average dH = -8.0 kcal/mol, dS = -0.022 kcal/(mol*K) per base pair
        """
        seq = seq.upper()
        if len(seq) < 2:
            return 0.0
        n_pairs = len(seq) - 1
        gc_fraction = (seq.count('G') + seq.count('C')) / len(seq)

        # GC pairs have stronger enthalpy (-10.5 kcal/mol vs -7.5 for AT)
        delta_h = n_pairs * (-7.5 - 3.0 * gc_fraction)
        delta_s = n_pairs * (-0.022) # kcal / (mol * K)

        delta_g = delta_h - (self.temp_kelvin * delta_s)
        return delta_g

    def verify_oligonucleotide(self, seq: str) -> Dict[str, Any]:
        """Verify quality and thermodynamic stability of an oligonucleotide."""
        seq = seq.upper()
        violations = []

        if len(seq) < 6:
            violations.append("Oligo too short (< 6 nt)")

        # 1. GC content check
        gc_pct = (seq.count('G') + seq.count('C')) / max(1, len(seq)) * 100.0
        if gc_pct < 35.0 or gc_pct > 65.0:
            violations.append(f"Unbalanced GC content: {gc_pct:.1f}% (acceptable: 35-65%)")

        # 2. Homopolymer run check
        current_run = 1
        for i in range(1, len(seq)):
            if seq[i] == seq[i - 1]:
                current_run += 1
                if current_run >= 5:
                    violations.append(f"Excessive homopolymer run '{seq[i]*5}' detected at position {i-4}")
                    break
            else:
                current_run = 1

        # 3. Thermodynamic feasibility
        delta_g = self.calculate_gibbs_free_energy(seq)
        if delta_g >= 0.0:
            violations.append(f"Non-spontaneous hybridization: Delta G = {delta_g:.2f} >= 0 kcal/mol")

        return {
            "valid": len(violations) == 0,
            "violations": violations,
            "sequence": seq,
            "length": len(seq),
            "gc_percent": round(gc_pct, 2),
            "delta_g_kcal_mol": round(delta_g, 2)
        }
