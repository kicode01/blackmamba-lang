"""
TinyTalk Phase 13A: Neuromorphic Silicon Backend & Spiking Neural Networks (SNN)
Provides Leaky Integrate-and-Fire (LIF) neuron dynamics, synaptic weight matrix
integration, spike train generation, and spike raster encoding.
"""

from typing import List, Dict, Any, Tuple, Optional
import math
import random

class LIFNeuron:
    """
    Leaky Integrate-and-Fire (LIF) neuron model.
    Dynamics:
      V[t] = beta * V[t-1] + I_syn[t]
      S[t] = 1 if V[t] >= V_th else 0
      V[t] = V_reset if S[t] == 1 (hard reset)
    """
    def __init__(
        self,
        decay: float = 0.9,
        v_threshold: float = 1.0,
        v_reset: float = 0.0,
        refractory_steps: int = 1
    ):
        self.decay = max(0.0, min(1.0, decay))
        self.v_threshold = v_threshold
        self.v_reset = v_reset
        self.refractory_steps = max(0, refractory_steps)
        self.v = v_reset
        self.refractory_counter = 0

    def step(self, current: float) -> Tuple[int, float]:
        """Advance one discrete time step given input synaptic current."""
        if self.refractory_counter > 0:
            self.refractory_counter -= 1
            self.v = self.v_reset
            return (0, self.v)

        # Decay membrane potential and integrate synaptic current
        self.v = (self.v * self.decay) + current

        # Spike generation
        if self.v >= self.v_threshold:
            spike = 1
            self.v = self.v_reset
            self.refractory_counter = self.refractory_steps
        else:
            spike = 0

        return (spike, self.v)

    def reset(self) -> None:
        """Reset membrane state to resting potential."""
        self.v = self.v_reset
        self.refractory_counter = 0


class SpikingNeuralLayer:
    """A layer of LIF neurons interconnected with synaptic weights."""
    def __init__(
        self,
        num_inputs: int,
        num_neurons: int,
        decay: float = 0.9,
        v_threshold: float = 1.0,
        weights: Optional[List[List[float]]] = None
    ):
        self.num_inputs = num_inputs
        self.num_neurons = num_neurons
        self.decay = decay
        self.v_threshold = v_threshold
        self.neurons = [
            LIFNeuron(decay=decay, v_threshold=v_threshold)
            for _ in range(num_neurons)
        ]
        if weights is not None:
            self.weights = weights
        else:
            # Deterministic initialization based on fan-in
            scale = 1.0 / math.sqrt(max(1, num_inputs))
            self.weights = [
                [(0.5 * scale) for _ in range(num_inputs)]
                for _ in range(num_neurons)
            ]

    def forward_step(self, inputs: List[float]) -> Tuple[List[int], List[float]]:
        """Advance the layer by one timestep given an input vector."""
        spikes = []
        voltages = []
        for i, neuron in enumerate(self.neurons):
            # Synaptic current is dot product of weights and input
            row_w = self.weights[i]
            synaptic_current = sum(
                w * inp for w, inp in zip(row_w, inputs[:self.num_inputs])
            )
            spk, v = neuron.step(synaptic_current)
            spikes.append(spk)
            voltages.append(v)
        return spikes, voltages

    def reset(self) -> None:
        """Reset all neurons in layer."""
        for neuron in self.neurons:
            neuron.reset()


class SNNNetwork:
    """
    Multi-layer Spiking Neural Network with time-series spike-train simulation
    and raster recording.
    """
    def __init__(self, layer_sizes: List[int], decay: float = 0.9, v_threshold: float = 1.0):
        if len(layer_sizes) < 2:
            raise ValueError("SNNNetwork requires at least 2 layer sizes (input, output)")
        self.layer_sizes = layer_sizes
        self.layers: List[SpikingNeuralLayer] = []
        for i in range(len(layer_sizes) - 1):
            n_in = layer_sizes[i]
            n_out = layer_sizes[i + 1]
            self.layers.append(SpikingNeuralLayer(n_in, n_out, decay=decay, v_threshold=v_threshold))

    def set_weights(self, layer_idx: int, weights: List[List[float]]) -> None:
        """Set explicit synaptic weights for a layer."""
        self.layers[layer_idx].weights = weights

    def reset(self) -> None:
        """Reset entire network."""
        for layer in self.layers:
            layer.reset()

    def simulate(self, input_timesteps: List[List[float]]) -> Dict[str, Any]:
        """
        Simulate network across sequential timesteps.
        input_timesteps: list of vectors (one per timestep).
        """
        self.reset()
        num_layers = len(self.layers)
        output_spikes_per_step: List[List[int]] = []
        all_layer_spikes: Dict[int, List[List[int]]] = {l: [] for l in range(num_layers)}

        for inp in input_timesteps:
            current_signal = inp
            for l_idx, layer in enumerate(self.layers):
                spk, _ = layer.forward_step(current_signal)
                all_layer_spikes[l_idx].append(spk)
                # Next layer receives binary spikes as floats
                current_signal = [float(s) for s in spk]
            output_spikes_per_step.append(spk)

        # Calculate spike counts and firing rates
        total_steps = len(input_timesteps)
        output_counts = [0] * self.layer_sizes[-1]
        for spk in output_spikes_per_step:
            for neuron_idx, s in enumerate(spk):
                output_counts[neuron_idx] += s

        firing_rates = [
            (c / total_steps) if total_steps > 0 else 0.0
            for c in output_counts
        ]

        return {
            "timesteps": total_steps,
            "layer_sizes": self.layer_sizes,
            "output_spikes": output_spikes_per_step,
            "output_counts": output_counts,
            "firing_rates": firing_rates,
            "layer_spikes": all_layer_spikes
        }

    def generate_raster_ascii(self, simulation_result: Dict[str, Any]) -> str:
        """Render a clean ASCII spike raster diagram."""
        out_spikes = simulation_result["output_spikes"]
        if not out_spikes:
            return "No timesteps"
        num_neurons = len(out_spikes[0])
        timesteps = len(out_spikes)

        lines = [f"Spike Raster (Output Layer: {num_neurons} neurons, {timesteps} steps):"]
        for n in range(num_neurons):
            row = "".join("|" if out_spikes[t][n] == 1 else "." for t in range(timesteps))
            lines.append(f"Neuron {n:02d} |{row}| ({simulation_result['output_counts'][n]} spikes)")
        return "\n".join(lines)
