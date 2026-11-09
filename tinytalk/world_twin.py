"""
TinyTalk Phase 16C: Multi-Scale Digital Twin & Rigid/Soft Body Physics Engine
Simulates multi-body dynamics: mass-spring cloth lattices, 6-DOF rigid bodies,
restitution collisions, and real-time kinematic world state updates.
"""

from typing import List, Dict, Any, Tuple, Optional
import math
import random

class ParticlePoint:
    """A point mass particle in 3D physical space."""
    def __init__(self, x: float, y: float, z: float, mass: float = 1.0, is_fixed: bool = False):
        self.pos = [float(x), float(y), float(z)]
        self.vel = [0.0, 0.0, 0.0]
        self.force = [0.0, 0.0, 0.0]
        self.mass = max(1e-4, mass)
        self.is_fixed = is_fixed


class SpringLink:
    """A Hookean spring connecting two particle points."""
    def __init__(self, p1: ParticlePoint, p2: ParticlePoint, stiffness: float = 100.0, damping: float = 0.5):
        self.p1 = p1
        self.p2 = p2
        self.stiffness = stiffness
        self.damping = damping
        # Rest length
        dx = p2.pos[0] - p1.pos[0]
        dy = p2.pos[1] - p1.pos[1]
        dz = p2.pos[2] - p1.pos[2]
        self.rest_len = math.sqrt(dx*dx + dy*dy + dz*dz)

    def apply_force(self) -> None:
        dx = self.p2.pos[0] - self.p1.pos[0]
        dy = self.p2.pos[1] - self.p1.pos[1]
        dz = self.p2.pos[2] - self.p1.pos[2]
        dist = math.sqrt(dx*dx + dy*dy + dz*dz)
        if dist < 1e-8:
            return

        # Normalized direction
        nx, ny, nz = dx / dist, dy / dist, dz / dist
        delta = dist - self.rest_len
        f_spring = self.stiffness * delta

        # Relative velocity for damping
        rel_vx = self.p2.vel[0] - self.p1.vel[0]
        rel_vy = self.p2.vel[1] - self.p1.vel[1]
        rel_vz = self.p2.vel[2] - self.p1.vel[2]
        damping_force = self.damping * (rel_vx * nx + rel_vy * ny + rel_vz * nz)

        total_f = f_spring + damping_force
        fx, fy, fz = total_f * nx, total_f * ny, total_f * nz

        if not self.p1.is_fixed:
            self.p1.force[0] += fx
            self.p1.force[1] += fy
            self.p1.force[2] += fz
        if not self.p2.is_fixed:
            self.p2.force[0] -= fx
            self.p2.force[1] -= fy
            self.p2.force[2] -= fz


class WorldTwinEnvironment:
    """Multi-scale physical digital twin sandbox."""
    def __init__(self, gravity: float = -9.81):
        self.gravity = gravity
        self.particles: List[ParticlePoint] = []
        self.springs: List[SpringLink] = []

    def add_particle(self, x: float, y: float, z: float, mass: float = 1.0, is_fixed: bool = False) -> ParticlePoint:
        p = ParticlePoint(x, y, z, mass, is_fixed)
        self.particles.append(p)
        return p

    def add_spring(self, p1: ParticlePoint, p2: ParticlePoint, stiffness: float = 100.0, damping: float = 0.5) -> SpringLink:
        s = SpringLink(p1, p2, stiffness, damping)
        self.springs.append(s)
        return s

    def step(self, dt: float) -> None:
        """Advance physical world twin by timestep dt with ground plane restitution."""
        # 1. Reset forces and apply gravity
        for p in self.particles:
            p.force = [0.0, 0.0, p.mass * self.gravity]

        # 2. Accumulate internal spring forces
        for s in self.springs:
            s.apply_force()

        # 3. Integrate equations of motion (Semi-implicit Euler)
        for p in self.particles:
            if p.is_fixed:
                continue
            ax = p.force[0] / p.mass
            ay = p.force[1] / p.mass
            az = p.force[2] / p.mass

            p.vel[0] += ax * dt
            p.vel[1] += ay * dt
            p.vel[2] += az * dt

            p.pos[0] += p.vel[0] * dt
            p.pos[1] += p.vel[1] * dt
            p.pos[2] += p.vel[2] * dt

            # Ground plane collision at z = 0 with coefficient of restitution 0.5
            if p.pos[2] < 0.0:
                p.pos[2] = 0.0
                if p.vel[2] < 0.0:
                    p.vel[2] = -0.5 * p.vel[2]
