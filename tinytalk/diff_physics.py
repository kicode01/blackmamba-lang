"""
TinyTalk Phase 16A: Universal Differentiable Physics & Reverse-Mode Autograd Tape
Implements reverse-mode automatic differentiation (nabla f) across physical primitives:
scalar nodes, gradient backpropagation tape, and parameter optimization.
"""

from typing import List, Dict, Any, Tuple, Optional, Set
import math
import random

class DiffVar:
    """A differentiable scalar variable with reverse-mode automatic differentiation."""
    def __init__(self, data: float, name: str = ""):
        self.data = float(data)
        self.grad = 0.0
        self.name = name
        self._prev: Set['DiffVar'] = set()
        self._backward_fn = lambda: None

    def __add__(self, other: Any) -> 'DiffVar':
        other = other if isinstance(other, DiffVar) else DiffVar(other)
        out = DiffVar(self.data + other.data)
        out._prev = {self, other}

        def _backward():
            self.grad += out.grad
            other.grad += out.grad
        out._backward_fn = _backward
        return out

    def __radd__(self, other: Any) -> 'DiffVar':
        return self.__add__(other)

    def __sub__(self, other: Any) -> 'DiffVar':
        other = other if isinstance(other, DiffVar) else DiffVar(other)
        out = DiffVar(self.data - other.data)
        out._prev = {self, other}

        def _backward():
            self.grad += out.grad
            other.grad -= out.grad
        out._backward_fn = _backward
        return out

    def __rsub__(self, other: Any) -> 'DiffVar':
        other = other if isinstance(other, DiffVar) else DiffVar(other)
        return other.__sub__(self)

    def __mul__(self, other: Any) -> 'DiffVar':
        other = other if isinstance(other, DiffVar) else DiffVar(other)
        out = DiffVar(self.data * other.data)
        out._prev = {self, other}

        def _backward():
            self.grad += other.data * out.grad
            other.grad += self.data * out.grad
        out._backward_fn = _backward
        return out

    def __rmul__(self, other: Any) -> 'DiffVar':
        return self.__mul__(other)

    def __truediv__(self, other: Any) -> 'DiffVar':
        other = other if isinstance(other, DiffVar) else DiffVar(other)
        out = DiffVar(self.data / other.data)
        out._prev = {self, other}

        def _backward():
            self.grad += (1.0 / other.data) * out.grad
            other.grad += (-self.data / (other.data ** 2)) * out.grad
        out._backward_fn = _backward
        return out

    def __pow__(self, power: float) -> 'DiffVar':
        out = DiffVar(self.data ** power)
        out._prev = {self}

        def _backward():
            self.grad += (power * (self.data ** (power - 1))) * out.grad
        out._backward_fn = _backward
        return out

    def sin(self) -> 'DiffVar':
        out = DiffVar(math.sin(self.data))
        out._prev = {self}

        def _backward():
            self.grad += math.cos(self.data) * out.grad
        out._backward_fn = _backward
        return out

    def cos(self) -> 'DiffVar':
        out = DiffVar(math.cos(self.data))
        out._prev = {self}

        def _backward():
            self.grad -= math.sin(self.data) * out.grad
        out._backward_fn = _backward
        return out

    def backward(self) -> None:
        """Execute reverse-mode topological backpropagation."""
        topo: List['DiffVar'] = []
        visited: Set['DiffVar'] = set()

        def build_topo(v: 'DiffVar'):
            if v not in visited:
                visited.add(v)
                for child in v._prev:
                    build_topo(child)
                topo.append(v)

        build_topo(self)
        self.grad = 1.0
        for node in reversed(topo):
            node._backward_fn()
