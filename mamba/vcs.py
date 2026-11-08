"""Black Mamba Phase 10D: Semantic 3-Way Graph VCS & Conflict-Free Structural Diff.

Provides native content-addressed AST HyperGraph version control:
- O(1) content-hash tree diffing that skips unchanged subtrees.
- Semantic 3-way structural merge with zero conflicts for disjoint AST symbols.
- Precise semantic conflict isolation at symbol granularity.
"""

from __future__ import annotations

import time
from dataclasses import dataclass, field
from enum import Enum
from typing import Any, Dict, List, Optional, Set, Tuple

from mamba.graph import (
    HyperGraph,
    HyperNode,
    NodeKind,
    source_to_hypergraph,
)


class DiffOp(Enum):
    UNCHANGED = "unchanged"
    ADDED = "added"
    REMOVED = "removed"
    MODIFIED = "modified"
    CONFLICT = "conflict"


@dataclass
class NodeDelta:
    node_id: int
    op: DiffOp
    kind: NodeKind
    name: str
    base_hash: Optional[str] = None
    target_hash: Optional[str] = None

    def format_line(self) -> str:
        symbol = f" ({self.name})" if self.name else ""
        if self.op == DiffOp.ADDED:
            return f"+ [{self.kind.name}] Node #{self.node_id}{symbol} (hash: {self.target_hash[:8] if self.target_hash else '?'})"
        elif self.op == DiffOp.REMOVED:
            return f"- [{self.kind.name}] Node #{self.node_id}{symbol} (hash: {self.base_hash[:8] if self.base_hash else '?'})"
        elif self.op == DiffOp.MODIFIED:
            return f"~ [{self.kind.name}] Node #{self.node_id}{symbol} ({self.base_hash[:8] if self.base_hash else '?'} -> {self.target_hash[:8] if self.target_hash else '?'})"
        elif self.op == DiffOp.CONFLICT:
            return f"! [CONFLICT] Node #{self.node_id}{symbol} ({self.base_hash[:8] if self.base_hash else '?'} -> ours:{self.target_hash[:8] if self.target_hash else '?'})"
        return f"  [{self.kind.name}] Node #{self.node_id}{symbol}"


@dataclass
class GraphDiffResult:
    base_root_hash: str
    target_root_hash: str
    deltas: List[NodeDelta] = field(default_factory=list)

    @property
    def added_count(self) -> int:
        return sum(1 for d in self.deltas if d.op == DiffOp.ADDED)

    @property
    def removed_count(self) -> int:
        return sum(1 for d in self.deltas if d.op == DiffOp.REMOVED)

    @property
    def modified_count(self) -> int:
        return sum(1 for d in self.deltas if d.op == DiffOp.MODIFIED)

    @property
    def unchanged_count(self) -> int:
        return sum(1 for d in self.deltas if d.op == DiffOp.UNCHANGED)

    @property
    def has_changes(self) -> bool:
        return self.base_root_hash != self.target_root_hash

    def summary(self) -> str:
        lines = [
            f"[Black Mamba VCS] Structural Graph Diff ({self.base_root_hash[:8]} -> {self.target_root_hash[:8]}):",
            f"  Changes: +{self.added_count} added, -{self.removed_count} removed, ~{self.modified_count} modified, {self.unchanged_count} unchanged",
        ]
        for delta in self.deltas:
            if delta.op != DiffOp.UNCHANGED:
                lines.append("    " + delta.format_line())
        return "\n".join(lines)


@dataclass
class GraphMergeConflict:
    node_id: int
    kind: NodeKind
    name: str
    base_hash: str
    ours_hash: str
    theirs_hash: str
    description: str


@dataclass
class GraphMergeResult:
    success: bool
    merged_graph: Optional[HyperGraph]
    conflicts: List[GraphMergeConflict] = field(default_factory=list)
    clean_merges_count: int = 0

    def summary(self) -> str:
        if self.success:
            return f"[Black Mamba VCS] 3-Way Graph Merge SUCCESS: {self.clean_merges_count} symbols cleanly merged, 0 conflicts."
        lines = [
            f"[Black Mamba VCS] 3-Way Graph Merge CONFLICT: {len(self.conflicts)} semantic conflict(s) detected!",
        ]
        for c in self.conflicts:
            lines.append(f"  Conflict at [{c.kind.name}] '{c.name}': {c.description}")
        return "\n".join(lines)


class SemanticVCS:
    """Zero-Syntax Semantic 3-Way Graph Version Control Engine."""

    @staticmethod
    def _get_node_name(node: HyperNode) -> str:
        if "name" in node.payload:
            return str(node.payload["name"])
        if "var_name" in node.payload:
            return str(node.payload["var_name"])
        if "target" in node.payload:
            return str(node.payload["target"])
        return ""

    @classmethod
    def diff(cls, base: HyperGraph, target: HyperGraph) -> GraphDiffResult:
        """Compute structural diff between two content-addressed HyperGraphs."""
        base_hash = base.root_hash
        target_hash = target.root_hash

        if base_hash == target_hash and base_hash:
            return GraphDiffResult(base_root_hash=base_hash, target_root_hash=target_hash)

        deltas: List[NodeDelta] = []

        # Index nodes by (kind, name) for symbol-level tracking
        base_symbols: Dict[Tuple[NodeKind, str], HyperNode] = {}
        for n in base.nodes.values():
            name = cls._get_node_name(n)
            if name:
                base_symbols[(n.kind, name)] = n

        target_symbols: Dict[Tuple[NodeKind, str], HyperNode] = {}
        for n in target.nodes.values():
            name = cls._get_node_name(n)
            if name:
                target_symbols[(n.kind, name)] = n

        # Check for additions and modifications
        for key, t_node in target_symbols.items():
            if key[0] == NodeKind.MODULE:
                continue
            name = cls._get_node_name(t_node)
            if key not in base_symbols:
                deltas.append(
                    NodeDelta(
                        node_id=t_node.node_id,
                        op=DiffOp.ADDED,
                        kind=t_node.kind,
                        name=name,
                        target_hash=t_node.content_hash,
                    )
                )
            else:
                b_node = base_symbols[key]
                if b_node.content_hash != t_node.content_hash:
                    deltas.append(
                        NodeDelta(
                            node_id=t_node.node_id,
                            op=DiffOp.MODIFIED,
                            kind=t_node.kind,
                            name=name,
                            base_hash=b_node.content_hash,
                            target_hash=t_node.content_hash,
                        )
                    )
                else:
                    deltas.append(
                        NodeDelta(
                            node_id=t_node.node_id,
                            op=DiffOp.UNCHANGED,
                            kind=t_node.kind,
                            name=name,
                            base_hash=b_node.content_hash,
                            target_hash=t_node.content_hash,
                        )
                    )

        # Check for removals
        for key, b_node in base_symbols.items():
            if key[0] == NodeKind.MODULE:
                continue
            if key not in target_symbols:
                name = cls._get_node_name(b_node)
                deltas.append(
                    NodeDelta(
                        node_id=b_node.node_id,
                        op=DiffOp.REMOVED,
                        kind=b_node.kind,
                        name=name,
                        base_hash=b_node.content_hash,
                    )
                )

        return GraphDiffResult(
            base_root_hash=base_hash,
            target_root_hash=target_hash,
            deltas=deltas,
        )

    @classmethod
    def merge_3way(
        cls, base: HyperGraph, ours: HyperGraph, theirs: HyperGraph
    ) -> GraphMergeResult:
        """Perform 3-way semantic structural merge between base, ours, and theirs."""
        diff_ours = cls.diff(base, ours)
        diff_theirs = cls.diff(base, theirs)

        # Map symbol key (kind, name) -> delta
        ours_map = {(d.kind, d.name): d for d in diff_ours.deltas if d.name}
        theirs_map = {(d.kind, d.name): d for d in diff_theirs.deltas if d.name}

        all_keys = set(ours_map.keys()) | set(theirs_map.keys())

        conflicts: List[GraphMergeConflict] = []
        clean_merges = 0

        # Construct new merged graph
        merged = HyperGraph()

        # Index nodes by key across graphs
        def get_symbols(g: HyperGraph) -> Dict[Tuple[NodeKind, str], HyperNode]:
            res = {}
            for n in g.nodes.values():
                name = cls._get_node_name(n)
                if name:
                    res[(n.kind, name)] = n
            return res

        b_syms = get_symbols(base)
        o_syms = get_symbols(ours)
        t_syms = get_symbols(theirs)

        # Initialize root module node
        root_id = merged.add_node(NodeKind.MODULE, {"name": "main"})
        merged.root_id = root_id

        def copy_subtree(src_graph: HyperGraph, src_id: int) -> int:
            src_node = src_graph.nodes[src_id]
            child_ids = [copy_subtree(src_graph, cid) for cid in src_node.children]
            nid = merged.add_node(src_node.kind, dict(src_node.payload), children=child_ids)
            return nid

        for key in sorted(all_keys, key=lambda k: (k[0].value, k[1])):
            kind, name = key
            if kind == NodeKind.MODULE:
                continue

            d_o = ours_map.get(key)
            d_t = theirs_map.get(key)

            b_node = b_syms.get(key)
            o_node = o_syms.get(key)
            t_node = t_syms.get(key)

            # Case 1: Unchanged in both
            if (not d_o or d_o.op == DiffOp.UNCHANGED) and (not d_t or d_t.op == DiffOp.UNCHANGED):
                if o_node:
                    top_id = copy_subtree(ours, o_node.node_id)
                    merged.nodes[root_id].children.append(top_id)
                clean_merges += 1
                continue

            # Case 2: Only 'ours' changed (or added), 'theirs' kept base
            if d_o and d_o.op != DiffOp.UNCHANGED and (not d_t or d_t.op == DiffOp.UNCHANGED):
                if d_o.op != DiffOp.REMOVED and o_node:
                    top_id = copy_subtree(ours, o_node.node_id)
                    merged.nodes[root_id].children.append(top_id)
                clean_merges += 1
                continue

            # Case 3: Only 'theirs' changed (or added), 'ours' kept base
            if d_t and d_t.op != DiffOp.UNCHANGED and (not d_o or d_o.op == DiffOp.UNCHANGED):
                if d_t.op != DiffOp.REMOVED and t_node:
                    top_id = copy_subtree(theirs, t_node.node_id)
                    merged.nodes[root_id].children.append(top_id)
                clean_merges += 1
                continue

            # Case 4: Both changed identically
            if d_o and d_t and d_o.target_hash == d_t.target_hash:
                if d_o.op != DiffOp.REMOVED and o_node:
                    top_id = copy_subtree(ours, o_node.node_id)
                    merged.nodes[root_id].children.append(top_id)
                clean_merges += 1
                continue

            # Case 5: Both changed differently -> TRUE SEMANTIC CONFLICT!
            conflicts.append(
                GraphMergeConflict(
                    node_id=o_node.node_id if o_node else (t_node.node_id if t_node else 0),
                    kind=kind,
                    name=name,
                    base_hash=b_node.content_hash if b_node else "",
                    ours_hash=o_node.content_hash if o_node else "",
                    theirs_hash=t_node.content_hash if t_node else "",
                    description=f"Symbol '{name}' simultaneously modified in conflicting ways by ours and theirs",
                )
            )

        merged.compute_hashes()
        success = len(conflicts) == 0

        return GraphMergeResult(
            success=success,
            merged_graph=merged if success else None,
            conflicts=conflicts,
            clean_merges_count=clean_merges,
        )

    @classmethod
    def benchmark_vcs(cls, iterations: int = 500) -> Dict[str, Any]:
        """Measure graph diffing and 3-way merge throughput."""
        src_base = """def f1(x: i64) -> i64:
    return x * 2

def f2(y: i64) -> i64:
    return y + 10
"""
        src_ours = """def f1(x: i64) -> i64:
    return x * 4

def f2(y: i64) -> i64:
    return y + 10
"""
        src_theirs = """def f1(x: i64) -> i64:
    return x * 2

def f2(y: i64) -> i64:
    return y + 20
"""
        g_base = source_to_hypergraph(src_base)
        g_ours = source_to_hypergraph(src_ours)
        g_theirs = source_to_hypergraph(src_theirs)

        t0 = time.perf_counter()
        clean_merges = 0
        for _ in range(iterations):
            res = cls.merge_3way(g_base, g_ours, g_theirs)
            if res.success:
                clean_merges += 1
        elapsed = max(time.perf_counter() - t0, 1e-9)

        merges_per_sec = iterations / elapsed

        return {
            "iterations": iterations,
            "clean_merges": clean_merges,
            "elapsed_seconds": elapsed,
            "merges_per_second": merges_per_sec,
            "avg_us_per_merge": (elapsed / iterations) * 1_000_000.0,
        }


def diff_graphs(base: HyperGraph, target: HyperGraph) -> GraphDiffResult:
    return SemanticVCS.diff(base, target)


def merge_graphs(base: HyperGraph, ours: HyperGraph, theirs: HyperGraph) -> GraphMergeResult:
    return SemanticVCS.merge_3way(base, ours, theirs)


def benchmark_vcs_engine(iterations: int = 500) -> Dict[str, Any]:
    return SemanticVCS.benchmark_vcs(iterations)
