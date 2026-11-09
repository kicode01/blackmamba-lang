"""
TinyTalk Phase 14D: Chemical Reaction Network (CRN) Kinetic Rate Simulator
Simulates biochemical molecular logic circuits using Gillespie Stochastic
Simulation Algorithm (SSA) and Law of Mass Action stoichiometry.
"""

from typing import List, Dict, Any, Tuple, Optional
import math
import random

class ChemicalReaction:
    """Represents a biochemical reaction: Reactants -> Products with kinetic rate k."""
    def __init__(
        self,
        reactants: Dict[str, int],
        products: Dict[str, int],
        rate_k: float,
        name: str = "rxn"
    ):
        self.reactants = reactants # species -> stoichiometric coefficient
        self.products = products
        self.rate_k = max(0.0, rate_k)
        self.name = name

    def compute_propensity(self, state: Dict[str, int]) -> float:
        """Compute propensity a_mu based on current molecule populations."""
        prop = self.rate_k
        for species, coeff in self.reactants.items():
            pop = state.get(species, 0)
            if pop < coeff:
                return 0.0
            # Binomial factor for stoichiometry
            if coeff == 1:
                prop *= pop
            elif coeff == 2:
                prop *= (pop * (pop - 1) / 2.0)
            else:
                prop *= (pop ** coeff)
        return prop

    def apply(self, state: Dict[str, int]) -> None:
        """Update molecule populations when reaction fires."""
        for species, coeff in self.reactants.items():
            state[species] = state.get(species, 0) - coeff
        for species, coeff in self.products.items():
            state[species] = state.get(species, 0) + coeff


class CRNSimulator:
    """Simulates a Chemical Reaction Network over discrete time."""
    def __init__(self, initial_state: Dict[str, int]):
        self.state = dict(initial_state)
        self.reactions: List[ChemicalReaction] = []
        self.time = 0.0

    def add_reaction(self, rxn: ChemicalReaction) -> None:
        self.reactions.append(rxn)

    def step_gillespie(self, rng: random.Random) -> Optional[float]:
        """
        Advance simulation by one Gillespie SSA step.
        Returns time increment dt, or None if network is quiescent.
        """
        propensities = [rxn.compute_propensity(self.state) for rxn in self.reactions]
        a_0 = sum(propensities)
        if a_0 <= 0.0:
            return None # Quiescent

        # Sample time to next reaction: dt = (1/a_0) * ln(1 / r1)
        r1 = max(1e-12, rng.random())
        dt = -math.log(r1) / a_0
        self.time += dt

        # Select which reaction fires with probability a_mu / a_0
        r2 = rng.random() * a_0
        cumulative = 0.0
        selected_rxn = self.reactions[-1]
        for rxn, prop in zip(self.reactions, propensities):
            cumulative += prop
            if r2 <= cumulative:
                selected_rxn = rxn
                break

        selected_rxn.apply(self.state)
        return dt

    def simulate(self, steps: int = 50, seed: int = 42) -> List[Dict[str, Any]]:
        """Run multiple SSA steps and record population trajectory."""
        rng = random.Random(seed)
        trajectory = []
        for _ in range(steps):
            trajectory.append({
                "time": self.time,
                "state": dict(self.state)
            })
            dt = self.step_gillespie(rng)
            if dt is None:
                break
        return trajectory
