"""
TinyTalk (tinytalk / .tnt / .bmb) — A High-Performance, Zero-Ceremony Python Superset & Multi-Target Native Compiler.

Synthesizes the best ideas of Mojo, Nim, and Codon while eliminating where they overreached:
- 100% clean Python indentation syntax (plus ergonomic .bmb extensions: `fn`/`def` unified, `struct`, `par for`, `|>`, `..`).
- Whole-program Cartesian type inference & specialization (write unannotated Python or explicit `i64`/`f64` hints).
- Zero borrow-checker ceremony and zero garbage-collector pauses via escape-analyzed stack/arena memory.
- Multi-target compilation:
  1. Direct in-memory x86-64 Native JIT (Win64 ABI via VirtualAlloc) with Zero-Copy Tensor Exchange
  2. Standalone Windows x86-64 PE32+ Executable (.exe) with zero external compiler dependencies
  3. Standalone Linux ELF64 Executable (.elf) with direct kernel syscalls
  4. WebAssembly binary (.wasm) & text (.wat)
  5. Portable C11 + OpenMP/SIMD (.c) & LLVM IR (.ll)
"""

import inspect
import textwrap
from typing import Any, Callable, Optional, Union
import sys
import importlib

import pkgutil

__version__ = "4.1.0"
__author__ = "TinyTalk Team"

# 100% backward compatibility alias: Ensure all tinytalk submodules map to mamba in sys.modules
sys.modules["mamba"] = sys.modules[__name__]

def _sync_mamba_submodules():
    this_mod = sys.modules[__name__]
    if hasattr(this_mod, "__path__"):
        for mod_info in pkgutil.walk_packages(this_mod.__path__, "tinytalk."):
            tnt_name = mod_info.name
            bmb_name = "mamba." + tnt_name[9:]
            try:
                m = importlib.import_module(tnt_name)
                sys.modules[bmb_name] = m
            except Exception:
                pass

_sync_mamba_submodules()

from .cli import compile_source_to_mir
from .backends.x86_64_jit import NativeJITModule
from .interop import (
    CPythonHostBridge,
    try_extract_buffer,
    as_numpy_array,
    as_torch_tensor,
)
from .ast_graph import (
    ASTGraph,
    ASTSymbolNode,
    TokenSparseCodec,
    ASTPatcher,
    ASTDeltaOp,
    ASTPatchResult,
    PinpointDiagnostic,
    benchmark_token_efficiency,
)
from .canvas import (
    MorphicCanvas,
    MorphNode,
    CanvasWire,
    CanvasSyncResult,
)
from .image import (
    ImageManager,
    ImageSaveReport,
    LoadedMambaImage,
)
from .fuzzer import (
    AdversarialFuzzer,
    FuzzReport,
    FuzzFailure,
)
from .reactive import (
    Signal,
    Computed,
    Effect,
    batch,
    ReactiveNode,
    ReactiveStore,
    DOMPatch,
    compile_reactive_wasm_bundle,
)
from .agent import (
    AutonomousAgent,
    AgentAction,
    SynthesisResult,
    HealResult,
)
from .mcp import (
    BlackMambaMCPServer,
    MCP_PROTOCOL_VERSION,
    SERVER_NAME,
    SERVER_VERSION,
)
from .orchestrator import (
    ASTSymbolLockManager,
    SymbolConflictError,
    LockMode,
    SwarmRole,
    SwarmAgent,
    AgentSwarm,
    SwarmResult,
)
from .replay import (
    ExecutionFrame,
    ReplayTrace,
    TimeTravelRecorder,
    OmniscientDebugger,
)
from .autograd import (
    Tensor,
    Module,
    Linear,
    LoRALinear,
    MSELoss,
    CrossEntropyLoss,
    Optimizer,
    SGD,
    AdamW,
    emit_gpu_tensor_shader,
)
from .shm import (
    SharedMemoryArena,
    SharedRingQueue,
    benchmark_shm_throughput,
)
from .gatekeeper import PreReleaseGatekeeper
from .selfhost import SelfHostManager
from .supervisor import SelfHealingSupervisor
from .contracts import FormalContractVerifier
from .unikernel import UnikernelBuilder
from .wcet import WCETAnalyzer
from .realtime import ZeroJitterPool, HardRealTimeScheduler, benchmark_rt_pool
from .spec import (
    PropertyTestEngine,
    PropertyResult,
    Strategy,
    IntegerStrategy,
    FloatStrategy,
    BooleanStrategy,
    StringStrategy,
    ListStrategy,
    integers,
    floats,
    booleans,
    strings,
    lists,
    AlgebraicLaws,
    SpecificationSynthesizer,
    benchmark_spec_engine,
)
from .ocap import (
    CAP_NONE,
    CAP_READ,
    CAP_WRITE,
    CAP_EXEC,
    CAP_NET,
    CAP_FS,
    CAP_DELEGATE,
    CAP_REVOKE,
    CAP_ALL,
    CapabilityToken,
    ObjectCapabilityKernel,
    MicroSandbox,
    benchmark_ocap_throughput,
)
from .fiber import (
    FiberState,
    Fiber,
    WorkStealingScheduler,
    benchmark_fiber_scheduler,
)
from .xbuild import (
    TargetPlatform,
    SUPPORTED_TARGETS,
    CrossCompiler,
    benchmark_xbuild_matrix,
)
from .provenance import (
    ArtifactSigner,
    SLSAProvenanceBuilder,
    benchmark_provenance_signing,
)
from .graph import (
    NodeKind,
    HyperNode,
    HyperGraph,
    source_to_hypergraph,
    benchmark_hypergraph_engine,
)
from .project import (
    ViewType,
    ProjectionEngine,
    VirtualDocumentProvider,
    benchmark_projections,
)
from .latent import (
    CodebookCategory,
    CodebookVector,
    LatentSynthesizer,
    synthesize_to_hypergraph,
    synthesize_to_code,
    benchmark_latent_synthesis,
)
from .vcs import (
    DiffOp,
    NodeDelta,
    GraphDiffResult,
    GraphMergeConflict,
    GraphMergeResult,
    SemanticVCS,
    diff_graphs,
    merge_graphs,
    benchmark_vcs_engine,
)
from .graph_mir import (
    GraphMIREmitter,
    compile_hypergraph_to_mir,
    compile_hypergraph_to_jit,
    compile_hypergraph_to_exe,
    benchmark_graph_to_mir,
)
from .transmute import (
    TransmuteFormat,
    RefactorReport,
    TransmutationEngine,
    transmute_py_to_bmb,
    transmute_bmb_to_graph,
    transmute_graph_to_bmb,
    verify_transmute_roundtrip,
    refactor_hypergraph,
    benchmark_transmute_pipeline,
)


def compile(source: str, filename: str = "<jit>", base_dir: str = "") -> NativeJITModule:
    """
    Compiles Black Mamba source code into a native x86-64 executable module in memory.
    The returned module can be invoked directly from Python:
        mod = mamba.compile("def saxpy(n: int, a: f64, x: Array[f64], y: Array[f64]): ...")
        mod.saxpy(100, 2.5, np_x, np_y)  # Zero copy!
    """
    mir = compile_source_to_mir(source, filename=filename, base_dir=base_dir)
    return NativeJITModule(mir)


def jit(fn_or_source: Union[Callable, str, None] = None) -> Any:
    """
    JIT compiler decorator or function for Black Mamba with zero-copy NumPy / PyTorch tensor exchange.
    
    Usage as decorator:
        @mamba.jit
        def fast_calc(n: int, x: List[f64], y: List[f64]):
            for i in 0..n:
                y[i] = x[i] * 2.0

    Usage on code string:
        kernel = mamba.jit('''
            def square(n: int, arr: Array[f64]):
                for i in 0..n:
                    arr[i] = arr[i] * arr[i]
        ''')
        kernel(len(x), x)
    """
    if fn_or_source is None:
        return lambda f: jit(f)

    if isinstance(fn_or_source, str):
        mod = compile(fn_or_source)
        user_funcs = [fn for fn in mod.mir_module.functions if fn.name not in ("main", "__bmb_main__")]
        if len(user_funcs) == 1:
            fn_name = user_funcs[0].name
            return getattr(mod, fn_name)
        return mod

    if callable(fn_or_source):
        try:
            src = inspect.getsource(fn_or_source)
            src = textwrap.dedent(src)
            # Filter out decorators from source line before parsing
            lines = src.splitlines()
            cleaned_lines = [l for l in lines if not l.strip().startswith("@mamba.jit") and not l.strip().startswith("@jit")]
            cleaned_src = "\n".join(cleaned_lines)
            mod = compile(cleaned_src, filename=fn_or_source.__name__)
            return getattr(mod, fn_or_source.__name__)
        except Exception as e:
            raise RuntimeError(f"Failed to JIT-compile function {fn_or_source.__name__!r}: {e}")

    raise TypeError(f"Expected callable function or source string, got {type(fn_or_source)}")


__all__ = [
    "compile",
    "jit",
    "NativeJITModule",
    "CPythonHostBridge",
    "try_extract_buffer",
    "as_numpy_array",
    "as_torch_tensor",
    "ASTGraph",
    "ASTSymbolNode",
    "TokenSparseCodec",
    "ASTPatcher",
    "ASTDeltaOp",
    "ASTPatchResult",
    "PinpointDiagnostic",
    "benchmark_token_efficiency",
    "MorphicCanvas",
    "MorphNode",
    "CanvasWire",
    "CanvasSyncResult",
    "ImageManager",
    "ImageSaveReport",
    "LoadedMambaImage",
    "AdversarialFuzzer",
    "FuzzReport",
    "FuzzFailure",
    "Signal",
    "Computed",
    "Effect",
    "batch",
    "ReactiveNode",
    "ReactiveStore",
    "DOMPatch",
    "compile_reactive_wasm_bundle",
    "AutonomousAgent",
    "AgentAction",
    "SynthesisResult",
    "HealResult",
    "BlackMambaMCPServer",
    "ASTSymbolLockManager",
    "SymbolConflictError",
    "LockMode",
    "SwarmRole",
    "SwarmAgent",
    "AgentSwarm",
    "SwarmResult",
    "ExecutionFrame",
    "ReplayTrace",
    "TimeTravelRecorder",
    "OmniscientDebugger",
    "Tensor",
    "Module",
    "Linear",
    "LoRALinear",
    "MSELoss",
    "CrossEntropyLoss",
    "Optimizer",
    "SGD",
    "AdamW",
    "emit_gpu_tensor_shader",
    "SharedMemoryArena",
    "SharedRingQueue",
    "benchmark_shm_throughput",
    "PreReleaseGatekeeper",
    "SelfHostManager",
    "SelfHealingSupervisor",
    "FormalContractVerifier",
    "UnikernelBuilder",
    "WCETAnalyzer",
    "ZeroJitterPool",
    "HardRealTimeScheduler",
    "benchmark_rt_pool",
    "PropertyTestEngine",
    "PropertyResult",
    "Strategy",
    "IntegerStrategy",
    "FloatStrategy",
    "BooleanStrategy",
    "StringStrategy",
    "ListStrategy",
    "integers",
    "floats",
    "booleans",
    "strings",
    "lists",
    "AlgebraicLaws",
    "SpecificationSynthesizer",
    "benchmark_spec_engine",
    "CAP_NONE",
    "CAP_READ",
    "CAP_WRITE",
    "CAP_EXEC",
    "CAP_NET",
    "CAP_FS",
    "CAP_DELEGATE",
    "CAP_REVOKE",
    "CAP_ALL",
    "CapabilityToken",
    "ObjectCapabilityKernel",
    "MicroSandbox",
    "benchmark_ocap_throughput",
    "FiberState",
    "Fiber",
    "WorkStealingScheduler",
    "benchmark_fiber_scheduler",
    "TargetPlatform",
    "SUPPORTED_TARGETS",
    "CrossCompiler",
    "benchmark_xbuild_matrix",
    "ArtifactSigner",
    "SLSAProvenanceBuilder",
    "benchmark_provenance_signing",
    "NodeKind",
    "HyperNode",
    "HyperGraph",
    "source_to_hypergraph",
    "benchmark_hypergraph_engine",
    "ViewType",
    "ProjectionEngine",
    "VirtualDocumentProvider",
    "benchmark_projections",
    "CodebookCategory",
    "CodebookVector",
    "LatentSynthesizer",
    "synthesize_to_hypergraph",
    "synthesize_to_code",
    "benchmark_latent_synthesis",
    "DiffOp",
    "NodeDelta",
    "GraphDiffResult",
    "GraphMergeConflict",
    "GraphMergeResult",
    "SemanticVCS",
    "diff_graphs",
    "merge_graphs",
    "benchmark_vcs_engine",
    "GraphMIREmitter",
    "compile_hypergraph_to_mir",
    "compile_hypergraph_to_jit",
    "compile_hypergraph_to_exe",
    "benchmark_graph_to_mir",
    "TransmuteFormat",
    "RefactorReport",
    "TransmutationEngine",
    "transmute_py_to_bmb",
    "transmute_bmb_to_graph",
    "transmute_graph_to_bmb",
    "verify_transmute_roundtrip",
    "refactor_hypergraph",
    "benchmark_transmute_pipeline",
]

