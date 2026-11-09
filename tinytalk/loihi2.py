"""
TinyTalk Phase 13B: Intel Loihi 2 Synaptic Routing & Axonal Microcode Emitter
Simulates Loihi 2 neuromorphic cores, compartmental dendritic routing,
and Spike-Timing-Dependent Plasticity (STDP) synaptic weight dynamics.
"""

from typing import List, Dict, Any, Tuple, Optional
import math
import random

class Loihi2Core:
    """
    Representation of an Intel Loihi 2 neuromorphic neuro-core.
    Each core manages up to 1024 compartments with axonal multicast routing.
    """
    def __init__(self, core_id: int, max_compartments: int = 128):
        self.core_id = core_id
        self.max_compartments = max_compartments
        self.compartments: Dict[int, Dict[str, Any]] = {}
        self.axonal_routes: Dict[int, List[Tuple[int, int]]] = {} # local_comp_id -> list of (dest_core_id, dest_comp_id)

    def allocate_compartment(
        self,
        comp_id: int,
        v_threshold: float = 1.0,
        decay: float = 0.9,
        bias: float = 0.0
    ) -> bool:
        """Allocate a microcore compartment."""
        if len(self.compartments) >= self.max_compartments:
            return False
        self.compartments[comp_id] = {
            "v_threshold": v_threshold,
            "decay": decay,
            "bias": bias,
            "v": 0.0,
            "spike_history": [],
            "last_spike_t": -1
        }
        self.axonal_routes[comp_id] = []
        return True

    def add_axonal_route(self, src_comp: int, dest_core: int, dest_comp: int) -> None:
        """Route axonal spikes to a destination core and compartment."""
        if src_comp in self.axonal_routes:
            self.axonal_routes[src_comp].append((dest_core, dest_comp))

    def emit_microcode(self) -> List[str]:
        """Emit low-level Loihi 2 microcode instructions."""
        asm = [f"; --- LOIHI 2 CORE 0x{self.core_id:04X} CONFIGURATION ---"]
        asm.append(f"CORE_INIT 0x{self.core_id:04X}, NUM_COMP={len(self.compartments)}")
        for comp_id, data in self.compartments.items():
            asm.append(
                f"COMP_CFG C[{comp_id:03d}], V_TH={data['v_threshold']:.2f}, "
                f"DECAY={data['decay']:.2f}, BIAS={data['bias']:.2f}"
            )
            for dst_core, dst_comp in self.axonal_routes.get(comp_id, []):
                asm.append(f"AXON_ROUTE C[{comp_id:03d}] -> CORE[0x{dst_core:04X}]:C[{dst_comp:03d}]")
        return asm


class STDPPlasticityEngine:
    """
    Spike-Timing-Dependent Plasticity (STDP) learning rule simulator.
    Modulates synaptic weights based on temporal correlation between pre- and post-synaptic spikes.
    """
    def __init__(
        self,
        a_plus: float = 0.01,
        a_minus: float = 0.012,
        tau_plus: float = 20.0,
        tau_minus: float = 20.0,
        w_min: float = 0.0,
        w_max: float = 1.0
    ):
        self.a_plus = a_plus
        self.a_minus = a_minus
        self.tau_plus = tau_plus
        self.tau_minus = tau_minus
        self.w_min = w_min
        self.w_max = w_max

    def update_weight(
        self,
        current_weight: float,
        t_pre: int,
        t_post: int
    ) -> float:
        """Calculate updated synaptic weight based on delta_t = t_post - t_pre."""
        dt = t_post - t_pre
        if dt > 0:
            # Long-Term Potentiation (LTP): pre fired before post
            delta_w = self.a_plus * math.exp(-dt / self.tau_plus)
            new_w = current_weight + delta_w
        elif dt < 0:
            # Long-Term Depression (LTD): post fired before pre
            delta_w = -self.a_minus * math.exp(dt / self.tau_minus)
            new_w = current_weight + delta_w
        else:
            new_w = current_weight

        # Clamp weight within bounds
        return max(self.w_min, min(self.w_max, new_w))
