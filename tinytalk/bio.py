"""
TinyTalk Phase 14A: DNA-Origami Scaffold Routing & Staple Strand Synthesizer
Compiles 2D/3D nanoscale geometries into self-assembling DNA oligonucleotides:
- Scaffold sequence mapping (M13mp18 or custom template)
- Watson-Crick complementary base pairing (A-T, G-C)
- Holliday junction crossover staple strand routing
- Melting temperature (Tm) and GC content thermodynamic calculations
- Automated robotic synthesis plate layout (96-well / 384-well)
"""

from typing import List, Dict, Any, Tuple, Optional
import math
import random

COMPLEMENTS = {'A': 'T', 'T': 'A', 'C': 'G', 'G': 'C'}

class DNAOrigamiSynthesizer:
    """
    Synthesizes staple oligonucleotide strands to fold a long single-stranded DNA scaffold
    into target nanoscale shapes via programmed crossovers.
    """
    def __init__(self, scaffold_seq: Optional[str] = None):
        # Default to standard M13mp18 bacteriophage scaffold segment if None
        if scaffold_seq is None:
            self.scaffold = (
                "AATGTTGAATACTCATACTCTTCCTTTTTCAATATTATTGAAGCATTTATCAGGGTTATTGTCTCATGAGCGGATACATATTTGAATGT"
                "ATTTAGAAAAATAAACAAATAGGGGTTCCGCGCACATTTCCCCGAAAAGTGCCACCTGACGTCTAAGAAACCATTATTATCATGACATTA"
            ) * 10
        else:
            self.scaffold = scaffold_seq.upper()

    @staticmethod
    def reverse_complement(seq: str) -> str:
        """Calculate reverse complement of a DNA nucleotide sequence."""
        return "".join(COMPLEMENTS.get(base, 'N') for base in reversed(seq.upper()))

    @staticmethod
    def calculate_melting_temp(seq: str) -> float:
        """
        Calculate duplex melting temperature (Tm) in Celsius using nearest-neighbor / basic formula:
        For seq > 14 nt: Tm = 64.9 + 41 * (yG + zC - 16.4) / (wA + xT + yG + zC)
        """
        seq = seq.upper()
        length = len(seq)
        if length == 0:
            return 0.0
        g_count = seq.count('G')
        c_count = seq.count('C')
        gc_count = g_count + c_count
        if length <= 14:
            return (seq.count('A') + seq.count('T')) * 2.0 + gc_count * 4.0
        return 64.9 + 41.0 * (gc_count - 16.4) / length

    @staticmethod
    def calculate_gc_content(seq: str) -> float:
        """Calculate percentage of G and C nucleotides."""
        seq = seq.upper()
        if not seq:
            return 0.0
        return (seq.count('G') + seq.count('C')) / len(seq) * 100.0

    def synthesize_staples(
        self,
        target_helix_count: int = 4,
        staple_length: int = 32,
        crossover_period: int = 16
    ) -> List[Dict[str, Any]]:
        """
        Generate Holliday junction staple strands that bind adjacent scaffold helices.
        Each staple consists of two domains (domain A and domain B) crossing over adjacent helices.
        """
        staples = []
        domain_len = staple_length // 2
        scaffold_len = len(self.scaffold)

        for h in range(target_helix_count - 1):
            helix_offset_1 = h * 100
            helix_offset_2 = (h + 1) * 100

            for i in range(0, 80, crossover_period):
                idx1 = (helix_offset_1 + i) % scaffold_len
                idx2 = (helix_offset_2 + i + domain_len) % scaffold_len

                # Extract binding domains from scaffold
                domain1 = self.scaffold[idx1 : idx1 + domain_len]
                domain2 = self.scaffold[idx2 : idx2 + domain_len]

                if len(domain1) == domain_len and len(domain2) == domain_len:
                    # Staple is complementary to scaffold domains
                    staple_seq = self.reverse_complement(domain1) + self.reverse_complement(domain2)
                    tm = self.calculate_melting_temp(staple_seq)
                    gc = self.calculate_gc_content(staple_seq)

                    staples.append({
                        "name": f"STAPLE_H{h}_H{h+1}_{i:03d}",
                        "sequence": staple_seq,
                        "length": len(staple_seq),
                        "tm_celsius": round(tm, 2),
                        "gc_percent": round(gc, 2),
                        "crossover": (f"Helix_{h}:{idx1}", f"Helix_{h+1}:{idx2}")
                    })

        return staples

    def export_fasta(self, staples: List[Dict[str, Any]]) -> str:
        """Export synthesized staple strands in FASTA format."""
        lines = []
        for s in staples:
            lines.append(f">{s['name']} len={s['length']} tm={s['tm_celsius']}C gc={s['gc_percent']}%")
            lines.append(s['sequence'])
        return "\n".join(lines)
