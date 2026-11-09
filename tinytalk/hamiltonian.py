"""
TinyTalk Phase 16B: Hamiltonian Classical Mechanics & Symplectic Integrator
Simulates conservative physical dynamical systems (harmonic oscillators, N-body gravitation)
using symplectic Velocity-Verlet integration guaranteeing long-term energy conservation.
"""

from typing import List, Dict, Any, Tuple, Optional, Callable
import math
import random

class HamiltonianSystem:
    """
    1D/2D Hamiltonian Dynamical System: H(q, p) = T(p) + V(q)
    Kinetic Energy: T(p) = p^2 / (2*m)
    Potential Energy: V(q)
    Equations of motion: dq/dt = p/m, dp/dt = -dV/dq = F(q)
    """
    def __init__(
        self,
        mass: float = 1.0,
        potential_fn: Optional[Callable[[float], float]] = None,
        force_fn: Optional[Callable[[float], float]] = None
    ):
        self.m = max(1e-6, mass)
        # Default to harmonic oscillator V(q) = 0.5 * k * q^2, F(q) = -k * q (k = 1.0)
        self.potential_fn = potential_fn or (lambda q: 0.5 * q * q)
        self.force_fn = force_fn or (lambda q: -q)

    def total_energy(self, q: float, p: float) -> float:
        """Calculate total conserved Hamiltonian energy H = T + V."""
        kinetic = (p ** 2) / (2.0 * self.m)
        potential = self.potential_fn(q)
        return kinetic + potential

    def step_verlet(self, q: float, p: float, dt: float) -> Tuple[float, float]:
        """
        Symplectic Velocity-Verlet step:
        1. p_half = p + 0.5 * dt * F(q)
        2. q_next = q + dt * (p_half / m)
        3. p_next = p_half + 0.5 * dt * F(q_next)
        """
        f1 = self.force_fn(q)
        p_half = p + 0.5 * dt * f1
        q_next = q + dt * (p_half / self.m)
        f2 = self.force_fn(q_next)
        p_next = p_half + 0.5 * dt * f2
        return (q_next, p_next)

    def simulate_trajectory(self, q0: float, p0: float, dt: float, steps: int) -> List[Tuple[float, float, float]]:
        """Simulate trajectory returning list of (time, q, p)."""
        traj = [(0.0, q0, p0)]
        q, p = q0, p0
        for i in range(1, steps + 1):
            q, p = self.step_verlet(q, p, dt)
            traj.append((i * dt, q, p))
        return traj
