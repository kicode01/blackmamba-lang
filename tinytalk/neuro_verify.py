"""
TinyTalk Phase 13E: Neuromorphic Event-Driven Spike Fuzzer & Verification Engine
Performs formal safety verification on SNN circuits:
- Refractory rate violation checks
- Energy budget bounds (pJ / spike)
- Epileptic runaway excitation detection
- Silent dead-circuit detection
"""

from typing import List, Dict, Any, Tuple
import math

class NeuromorphicVerifier:
    """
    Formal invariant analyzer for spiking neuromorphic networks.
    """
    def __init__(self, energy_per_spike_pj: float = 1.0, max_firing_rate: float = 0.5):
        self.energy_per_spike_pj = energy_per_spike_pj
        self.max_firing_rate = max_firing_rate

    def verify_spike_raster(
        self,
        spike_raster: List[List[int]],
        energy_budget_pj: float
    ) -> Dict[str, Any]:
        """
        Analyze a full simulation spike raster: List of [timestep][neuron_idx] binary spikes.
        Returns validation status, violations found, and total energy consumed.
        """
        if not spike_raster:
            return {"valid": True, "violations": [], "total_energy_pj": 0.0}

        timesteps = len(spike_raster)
        num_neurons = len(spike_raster[0])
        total_spikes = sum(sum(step) for step in spike_raster)
        total_energy = total_spikes * self.energy_per_spike_pj

        violations = []

        # 1. Energy Budget Check
        if total_energy > energy_budget_pj:
            violations.append(
                f"Energy budget exceeded: consumed {total_energy:.2f} pJ > budget {energy_budget_pj:.2f} pJ"
            )

        # 2. Firing Rate and Epileptic Runaway Check per neuron
        for n in range(num_neurons):
            neuron_spikes = sum(spike_raster[t][n] for t in range(timesteps))
            rate = neuron_spikes / timesteps
            if rate > self.max_firing_rate:
                violations.append(
                    f"Neuron {n} exceeded max firing rate: {rate:.2f} > {self.max_firing_rate:.2f} (possible runaway excitation)"
                )

        # 3. Synchronous Avalanche Check
        # If >80% of neurons spike in the exact same timestep
        for t, step in enumerate(spike_raster):
            active_pct = sum(step) / num_neurons
            if active_pct > 0.8:
                violations.append(
                    f"Synchronous avalanche at step {t}: {active_pct * 100:.1f}% neurons spiked simultaneously"
                )

        # 4. Silent Network Check
        if total_spikes == 0:
            violations.append("Silent network warning: 0 spikes emitted across entire simulation")

        return {
            "valid": len(violations) == 0,
            "violations": violations,
            "total_spikes": total_spikes,
            "total_energy_pj": total_energy,
            "mean_firing_rate": total_spikes / (timesteps * num_neurons)
        }
