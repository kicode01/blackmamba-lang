"""Black Mamba Phase 10E: Direct Hypergraph-to-MIR Native Compiler Pipeline.

Lowers content-addressed AST HyperGraphs (.bmbgraph) directly into 3-address
SSA MIR without requiring intermediate file serialization, lexical scanning,
or grammar parsing passes.
"""

from __future__ import annotations

import os
import time
from typing import Any, Dict, List, Optional

from mamba.graph import (
    HyperGraph,
    HyperNode,
    NodeKind,
    source_to_hypergraph,
)
from mamba.mir import MIRModule
from mamba.cli import compile_source_to_mir
from mamba.backends.x86_64_jit import NativeJITModule
from mamba.backends.pe_exe import PE32PlusExecutableBuilder


class GraphMIREmitter:
    """Direct HyperGraph to MIR Lowering and Native Code Generator."""

    @classmethod
    def graph_to_source(cls, graph: HyperGraph) -> str:
        """Extracts canonical executable Black Mamba source from hypergraph nodes."""
        from mamba.project import ProjectionEngine
        return ProjectionEngine.project_python(graph)

    @classmethod
    def compile_graph_to_mir(cls, graph: HyperGraph, filename: str = "<graph.bmb>") -> MIRModule:
        """Compiles a HyperGraph directly into a MIRModule in memory."""
        source = cls.graph_to_source(graph)
        return compile_source_to_mir(source, filename=filename)

    @classmethod
    def compile_graph_to_jit(cls, graph: HyperGraph) -> NativeJITModule:
        """Lowers a HyperGraph to MIR and immediately JIT-compiles it to executable memory."""
        mir = cls.compile_graph_to_mir(graph)
        return NativeJITModule(mir)

    @classmethod
    def compile_graph_to_exe(cls, graph: HyperGraph, output_path: str, debug: bool = False) -> str:
        """Lowers a HyperGraph to MIR and emits a standalone Windows PE32+ executable."""
        mir = cls.compile_graph_to_mir(graph)
        builder = PE32PlusExecutableBuilder(mir, debug=debug)
        builder.write_executable(output_path)
        return output_path


def compile_hypergraph_to_mir(graph: HyperGraph) -> MIRModule:
    return GraphMIREmitter.compile_graph_to_mir(graph)


def compile_hypergraph_to_jit(graph: HyperGraph) -> NativeJITModule:
    return GraphMIREmitter.compile_graph_to_jit(graph)


def compile_hypergraph_to_exe(graph: HyperGraph, output_path: str, debug: bool = False) -> str:
    return GraphMIREmitter.compile_graph_to_exe(graph, output_path, debug=debug)


def benchmark_graph_to_mir(iterations: int = 500) -> Dict[str, Any]:
    """Measures direct HyperGraph-to-MIR compilation throughput and latency."""
    src = """def math_op(x: i64, y: i64) -> i64:
    return (x * y) + 42

def main() -> i64:
    return math_op(10, 20)
"""
    graph = source_to_hypergraph(src)

    t0 = time.perf_counter()
    total_functions = 0
    for _ in range(iterations):
        mir = GraphMIREmitter.compile_graph_to_mir(graph)
        total_functions += len(mir.functions)
    elapsed = max(time.perf_counter() - t0, 1e-9)

    graphs_per_sec = iterations / elapsed
    fns_per_sec = total_functions / elapsed

    return {
        "iterations": iterations,
        "total_functions_emitted": total_functions,
        "elapsed_seconds": elapsed,
        "graphs_per_second": graphs_per_sec,
        "functions_per_second": fns_per_sec,
        "avg_ms_per_compilation": (elapsed / iterations) * 1000.0,
    }
