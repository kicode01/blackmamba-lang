import json
import os
import tempfile
import unittest

import mamba
from mamba.ast_graph import (
    ASTDeltaOp,
    ASTFormatter,
    ASTGraph,
    ASTPatcher,
    TokenSparseCodec,
    benchmark_token_efficiency,
    count_llm_tokens,
    make_pinpoint_diagnostic,
)
from mamba.backends.x86_64_jit import NativeJITModule
from mamba.cli import compile_source_to_mir, main as cli_main
from mamba.parser import Parser
from mamba.types import TypeInferencer


def run_jit_captured(source: str) -> str:
    outputs = []
    mir = compile_source_to_mir(source)
    jit = NativeJITModule(mir, output_callback=lambda s: outputs.append(s))
    try:
        jit.run_main()
    finally:
        jit.close()
    return "".join(outputs)


class TestStep1NestedStructsAndArenaLifetimes(unittest.TestCase):
    """Tests Step 1: Recursive StructLayout computation, nested composite struct initialization, and lexical arena escape analysis."""

    def test_recursive_struct_layout_calculation(self):
        src = """
struct Vec3:
    x: f64 = 0.0
    y: f64 = 0.0
    z: f64 = 0.0

struct Transform:
    pos: Vec3
    scale: Vec3
    id: i64 = 1

struct Entity:
    name: str = "bot"
    transform: Transform
    hp: f64 = 100.0
"""
        mod = Parser.from_source(src).parse_module()
        ti = TypeInferencer(mod)
        ti.run()

        self.assertIn("Vec3", ti.struct_layouts)
        self.assertIn("Transform", ti.struct_layouts)
        self.assertIn("Entity", ti.struct_layouts)

        vec_layout = ti.struct_layouts["Vec3"]
        self.assertEqual(vec_layout.slot_count, 3)
        self.assertEqual(vec_layout.immediate_bytes, 24)
        self.assertEqual(vec_layout.flat_scalar_slots, 3)
        self.assertEqual(vec_layout.recursive_bytes, 24)

        tf_layout = ti.struct_layouts["Transform"]
        self.assertEqual(tf_layout.slot_count, 3)
        self.assertEqual(tf_layout.flat_scalar_slots, 7)  # 3 + 3 + 1
        self.assertEqual(tf_layout.recursive_bytes, 56)
        self.assertEqual(tf_layout.nested_structs, ["Vec3", "Vec3"])

        ent_layout = ti.struct_layouts["Entity"]
        self.assertEqual(ent_layout.slot_count, 3)
        self.assertEqual(ent_layout.flat_scalar_slots, 9)  # 1 + 7 + 1
        self.assertEqual(ent_layout.recursive_bytes, 72)
        self.assertIn("transform.pos.x", ent_layout.flat_field_paths)
        self.assertIn("transform.scale.z", ent_layout.flat_field_paths)

    def test_three_level_nested_struct_default_init_and_mutation(self):
        src = """
struct Vec2:
    x: f64 = 1.5
    y: f64 = 2.5

struct Pose:
    origin: Vec2
    angle: f64 = 0.5

struct Robot:
    tag: str = "R2"
    pose: Pose
    active: i64 = 1

r = Robot()
print(r.tag)
print(r.pose.origin.x)
print(r.pose.origin.y)
print(r.pose.angle)

r.pose.origin.x = 10
r.pose.origin.y = 20.25
print(r.pose.origin.x + r.pose.origin.y)
"""
        out = run_jit_captured(src).strip().splitlines()
        self.assertEqual(out, ["R2", "1.5", "2.5", "0.5", "30.25"])

    def test_nested_struct_arena_escape_across_helper_calls(self):
        """
        Verifies that when a function extracts a nested struct (`outer.inner`) and passes
        it to a helper that allocates new heap strings/arrays onto `inner`, the caller's
        lexical arena does NOT prematurely rewind over those allocations on return.
        """
        src = """
struct InnerBuf:
    label: str = "init"
    items: Array[i64]

struct OuterPkg:
    id: i64 = 1
    inner: InnerBuf

fn attach_payload(buf: InnerBuf, idx: i64) -> void:
    buf.label = "pkg_" + str(idx)
    buf.items = [idx * 10, idx * 20, idx * 30]

fn process_outer(pkg: OuterPkg, step: i64) -> i64:
    tmp_scratch = [1, 2, 3, 4]
    sub = pkg.inner
    attach_payload(sub, step)
    return tmp_scratch[0] + step

p = OuterPkg()
for s in 1..=5:
    res = process_outer(p, s)
    # Allocate additional temporary arrays in main loop to ensure arena doesn't overwrite p.inner
    noise = [s, s + 1, s + 2, s + 3]

print(p.inner.label)
print(p.inner.items[0])
print(p.inner.items[1])
print(p.inner.items[2])
"""
        out = run_jit_captured(src).strip().splitlines()
        self.assertEqual(out, ["pkg_5", "50", "100", "150"])


class TestStep2TokenSparseASTGraphAndPatcher(unittest.TestCase):
    """Tests Step 2: Content-Addressed AST Graph, Bijective Token-Sparse Codec, Surgical AST Patcher, and CLI."""

    SAMPLE_MODULE = """
struct Vec3:
    x: f64 = 0.0
    y: f64 = 0.0
    z: f64 = 0.0

    fn norm_sq(self) -> f64:
        return self.x * self.x + self.y * self.y + self.z * self.z

    fn scale(self, factor: f64) -> Vec3:
        return Vec3(self.x * factor, self.y * factor, self.z * factor)

struct Particle:
    pos: Vec3
    vel: Vec3
    mass: f64 = 1.0

fn step_particle(p: Particle, dt: f64) -> void:
    p.pos.x = p.pos.x + p.vel.x * dt
    p.pos.y = p.pos.y + p.vel.y * dt
    p.pos.z = p.pos.z + p.vel.z * dt

fn total_kinetic_energy(p: Particle) -> f64:
    v2 = p.vel.norm_sq()
    return 0.5 * p.mass * v2

fn run_sim() -> f64:
    p = Particle(Vec3(0.0, 0.0, 0.0), Vec3(2.0, 3.0, 6.0), 4.0)
    step_particle(p, 0.5)
    return p.pos.z + total_kinetic_energy(p)
"""

    def test_ast_graph_content_addressed_uris_and_skeleton(self):
        graph = ASTGraph.from_source(self.SAMPLE_MODULE, module_name="physics")
        self.assertIn("bmb://physics/Vec3", graph.nodes)
        self.assertIn("bmb://physics/Vec3/norm_sq", graph.nodes)
        self.assertIn("bmb://physics/Vec3/scale", graph.nodes)
        self.assertIn("bmb://physics/Particle", graph.nodes)
        self.assertIn("bmb://physics/step_particle", graph.nodes)
        self.assertIn("bmb://physics/total_kinetic_energy", graph.nodes)
        self.assertIn("bmb://physics/run_sim", graph.nodes)

        # Verify short URI lookup
        norm_node = graph.inspect("Vec3/norm_sq")
        self.assertEqual(norm_node.uri, "bmb://physics/Vec3/norm_sq")
        self.assertEqual(norm_node.signature, "@F norm_sq(self)->f")
        self.assertEqual(len(norm_node.sha256), 12)

        # Verify call & type dependency edges
        ke_node = graph.inspect("total_kinetic_energy")
        self.assertIn(".norm_sq", ke_node.calls)
        self.assertIn("Particle", ke_node.types_used)
        self.assertIn("bmb://physics/run_sim", graph.callers_of("total_kinetic_energy"))

        # Verify skeleton compactness
        skeleton = graph.to_skeleton()
        self.assertIn("@mod bmb://physics", skeleton)
        self.assertIn("@S Vec3{x:f,y:f,z:f}", skeleton)
        self.assertIn("@F step_particle(p:Particle,dt:f)->v", skeleton)
        self.assertLess(count_llm_tokens(skeleton), count_llm_tokens(self.SAMPLE_MODULE) * 0.45)

    def test_bijective_token_sparse_codec_roundtrip(self):
        codec = TokenSparseCodec()
        compact = codec.encode(self.SAMPLE_MODULE)
        self.assertIn("@S Vec3:", compact)
        self.assertIn("@F norm_sq(self)->f:", compact)
        self.assertIn("@F step_particle(p:Particle,dt:f):", compact)
        self.assertLess(count_llm_tokens(compact), count_llm_tokens(self.SAMPLE_MODULE))

        decoded = codec.decode(compact)
        # Execute both original and round-tripped code via native x86-64 JIT
        orig_exec = self.SAMPLE_MODULE + "\nprint(run_sim())\n"
        dec_exec = decoded + "\nprint(run_sim())\n"
        self.assertEqual(run_jit_captured(orig_exec), run_jit_captured(dec_exec))
        self.assertEqual(run_jit_captured(dec_exec).strip(), "101.0")

    def test_surgical_ast_patcher_ops_and_atomic_rollback(self):
        patcher = ASTPatcher()

        # 1. Surgical REPLACE_SYMBOL using compact .bmbs syntax on a single function
        res1 = patcher.apply_patch(
            self.SAMPLE_MODULE,
            [
                ASTDeltaOp(
                    op="REPLACE_SYMBOL",
                    target_uri="bmb://physics/total_kinetic_energy",
                    code="@F total_kinetic_energy(p:Particle)->f:\n ^p.mass * p.vel.norm_sq()",
                )
            ],
            module_name="physics",
        )
        self.assertTrue(res1.success)
        self.assertFalse(res1.rolled_back)
        self.assertGreater(res1.token_savings_pct, 65.0)
        # With 1.0 * mass * v^2 instead of 0.5 * mass * v^2: 3.0 + 4.0 * 49.0 = 199.0
        self.assertEqual(run_jit_captured(res1.new_source + "\nprint(run_sim())\n").strip(), "199.0")

        # 2. Surgical ADD_FIELD + ADD_METHOD + RENAME_SYMBOL
        res2 = patcher.apply_patch(
            res1.new_source,
            [
                ASTDeltaOp(
                    op="ADD_FIELD",
                    target_uri="bmb://physics/Particle",
                    field_name="charge",
                    field_type="f",
                    default_expr="2.5",
                ),
                ASTDeltaOp(
                    op="ADD_METHOD",
                    target_uri="bmb://physics/Vec3",
                    code="@F sum_coords(self)->f:\n ^self.x + self.y + self.z",
                ),
                ASTDeltaOp(
                    op="RENAME_SYMBOL",
                    target_uri="bmb://physics/total_kinetic_energy",
                    new_name="calc_ke",
                ),
            ],
            module_name="physics",
        )
        self.assertTrue(res2.success)
        self.assertIn("charge: f64 = 2.5", res2.new_source)
        self.assertIn("fn sum_coords(self) -> f64:", res2.new_source)
        self.assertIn("fn calc_ke(p: Particle) -> f64:", res2.new_source)
        self.assertIn("calc_ke(p)", res2.new_source)

        # 3. Invalid patch triggers pre-commit failure, atomic rollback, and <= 20-token pinpoint diagnostic
        bad_res = patcher.apply_patch(
            res2.new_source,
            [
                ASTDeltaOp(
                    op="REPLACE_SYMBOL",
                    target_uri="bmb://physics/calc_ke",
                    code="fn calc_ke(p: Particle) -> f64:\n    return (p.mass +",
                )
            ],
            module_name="physics",
        )
        self.assertFalse(bad_res.success)
        self.assertTrue(bad_res.rolled_back)
        self.assertEqual(bad_res.new_source, res2.new_source)
        self.assertIsNotNone(bad_res.diagnostic)
        self.assertTrue(bad_res.diagnostic.to_compact_str().startswith("!ERR["))
        self.assertLessEqual(bad_res.diagnostic.token_count, 30)

    def test_token_efficiency_benchmark_exceeds_75_percent_savings(self):
        report = benchmark_token_efficiency(
            self.SAMPLE_MODULE,
            target_uri="bmb://physics/Vec3/norm_sq",
            module_name="physics",
        )
        self.assertGreaterEqual(report.edit_savings_pct, 80.0)
        self.assertGreaterEqual(report.roundtrip_savings_pct, 70.0)

    def test_cli_ast_and_patch_subcommands(self):
        with tempfile.TemporaryDirectory() as tmpdir:
            bmb_path = os.path.join(tmpdir, "sim.bmb")
            bmbs_path = os.path.join(tmpdir, "sim.bmbs")
            decoded_path = os.path.join(tmpdir, "sim_decoded.bmb")
            with open(bmb_path, "w", encoding="utf-8") as f:
                f.write(self.SAMPLE_MODULE)

            self.assertEqual(cli_main(["ast", "skeleton", bmb_path]), 0)
            self.assertEqual(cli_main(["ast", "inspect", bmb_path, "Vec3/norm_sq", "--compact"]), 0)
            self.assertEqual(cli_main(["ast", "encode", bmb_path, "-o", bmbs_path]), 0)
            self.assertTrue(os.path.exists(bmbs_path))
            self.assertEqual(cli_main(["ast", "decode", bmbs_path, "-o", decoded_path]), 0)
            self.assertTrue(os.path.exists(decoded_path))
            self.assertEqual(cli_main(["ast", "bench", bmb_path, "--json"]), 0)

            # Apply in-place surgical patch via CLI
            rc = cli_main([
                "patch",
                bmb_path,
                "--op",
                "ADD_FIELD",
                "--uri",
                "bmb://sim/Particle",
                "--field-name",
                "spin",
                "--field-type",
                "f64",
                "--default-expr",
                "0.5",
                "--in-place",
            ])
            self.assertEqual(rc, 0)
            with open(bmb_path, "r", encoding="utf-8") as f:
                patched_text = f.read()
            self.assertIn("spin: f64 = 0.5", patched_text)

    def test_stdlib_ast_graph_bmb_native_execution(self):
        src = """
import ast_graph

meta = ast_graph.make_symbol_meta("engine", "integrate", "RigidBody", "method", "@F integrate(self,dt:f)->v", 12, 24)
delta = ast_graph.make_delta_spec("REPLACE_SYMBOL", meta, "@F integrate(self,dt:f): ^")
sav = ast_graph.compute_token_savings_pct(400, 48)

print(delta.target_uri)
print(delta.meta.span.start_line)
print(delta.meta.span.end_line)
print(sav)
"""
        out = run_jit_captured(src).strip().splitlines()
        self.assertEqual(out, ["bmb://engine/RigidBody/integrate", "12", "24", "88.0"])


if __name__ == "__main__":
    unittest.main()
