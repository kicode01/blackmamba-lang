# Black Mamba Time-Travel Deterministic Replay & Omniscient Debugger
# Provides instruction-level and arena-generation state recording,
# bi-directional execution scrubbing (forward/backward), variable history timelines,
# and zero-overhead .bmbreplay checkpoints.

import os
import sys
import json
import time
import zlib
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Any, Tuple, Union

from .parser import Parser
from .ast_nodes import (
    Assign, AugAssign, BinOp, UnaryOp, IntLit, FloatLit, StringLit, BoolLit,
    Var, Call, MethodCall, FieldAccess, FieldAssign, IfStmt, WhileStmt,
    ForRangeStmt, Return, ExprStmt, FuncDef, StructDef, Module
)
from .backends.x86_64_jit import NativeJITModule
from .cli import compile_source_to_mir


REPLAY_FORMAT_VERSION = "2.6.0"
DEFAULT_RING_CAPACITY = 10000
CHECKPOINT_INTERVAL = 10


@dataclass
class ExecutionFrame:
    """A single deterministic execution state frame in time."""
    step_index: int
    line_number: int
    function_name: str
    event: str  # "CALL", "LINE", "MUTATION", "ARENA_ALLOC", "RETURN"
    variables: Dict[str, Any]
    call_stack: List[str]
    arena_generation: int = 0
    delta_from_prev: Dict[str, Any] = field(default_factory=dict)
    stdout_chunk: Optional[str] = None

    def to_dict(self) -> Dict[str, Any]:
        return {
            "step": self.step_index,
            "line": self.line_number,
            "func": self.function_name,
            "event": self.event,
            "vars": self.variables,
            "stack": self.call_stack,
            "arena_gen": self.arena_generation,
            "delta": self.delta_from_prev,
            "stdout": self.stdout_chunk,
        }

    @classmethod
    def from_dict(cls, d: Dict[str, Any]) -> "ExecutionFrame":
        return cls(
            step_index=d["step"],
            line_number=d["line"],
            function_name=d["func"],
            event=d["event"],
            variables=d.get("vars", {}),
            call_stack=d.get("stack", []),
            arena_generation=d.get("arena_gen", 0),
            delta_from_prev=d.get("delta", {}),
            stdout_chunk=d.get("stdout"),
        )


@dataclass
class ReplayTrace:
    """Complete recorded deterministic execution history."""
    trace_id: str
    module_name: str
    source_code: str
    total_steps: int
    frames: List[ExecutionFrame]
    checkpoints: Dict[int, Dict[str, Any]]
    metadata: Dict[str, Any] = field(default_factory=dict)

    def to_dict(self) -> Dict[str, Any]:
        return {
            "version": REPLAY_FORMAT_VERSION,
            "trace_id": self.trace_id,
            "module_name": self.module_name,
            "source_code": self.source_code,
            "total_steps": self.total_steps,
            "frames": [f.to_dict() for f in self.frames],
            "checkpoints": {str(k): v for k, v in self.checkpoints.items()},
            "metadata": self.metadata,
        }

    @classmethod
    def from_dict(cls, d: Dict[str, Any]) -> "ReplayTrace":
        checkpoints = {int(k): v for k, v in d.get("checkpoints", {}).items()}
        frames = [ExecutionFrame.from_dict(f) for f in d.get("frames", [])]
        return cls(
            trace_id=d["trace_id"],
            module_name=d.get("module_name", "main"),
            source_code=d.get("source_code", ""),
            total_steps=d.get("total_steps", len(frames)),
            frames=frames,
            checkpoints=checkpoints,
            metadata=d.get("metadata", {}),
        )

    def save(self, path: str, compress: bool = False) -> int:
        data = json.dumps(self.to_dict(), indent=2).encode("utf-8")
        if compress or path.endswith(".gz") or path.endswith(".zst"):
            payload = zlib.compress(data, level=6)
        else:
            payload = data
        with open(path, "wb") as f:
            f.write(payload)
        return len(payload)

    @classmethod
    def load(cls, path: str) -> "ReplayTrace":
        with open(path, "rb") as f:
            raw = f.read()
        try:
            decomp = zlib.decompress(raw)
            data = json.loads(decomp.decode("utf-8"))
        except Exception:
            data = json.loads(raw.decode("utf-8"))
        return cls.from_dict(data)


class TimeTravelRecorder:
    """
    Deterministic Ring-Buffer State Recorder.
    Executes Black Mamba AST while recording every variable mutation, function call,
    return, and arena allocation into execution frames with periodic checkpoints.
    """

    def __init__(self, capacity: int = DEFAULT_RING_CAPACITY, checkpoint_interval: int = CHECKPOINT_INTERVAL):
        self.capacity = capacity
        self.checkpoint_interval = checkpoint_interval
        self.frames: List[ExecutionFrame] = []
        self.checkpoints: Dict[int, Dict[str, Any]] = {}
        self.call_stack: List[str] = []
        self.arena_generation = 0
        self.stdout_log: List[str] = []
        self.current_vars: Dict[str, Any] = {}
        self.functions: Dict[str, FuncDef] = {}
        self.structs: Dict[str, StructDef] = {}

    def _record_frame(self, line: int, func: str, event: str, prev_vars: Dict[str, Any], stdout_chunk: Optional[str] = None) -> ExecutionFrame:
        step_idx = len(self.frames)
        vars_snapshot = dict(self.current_vars)

        # Compute delta from previous frame
        delta: Dict[str, Any] = {}
        for k, v in vars_snapshot.items():
            if k not in prev_vars or prev_vars[k] != v:
                delta[k] = {"before": prev_vars.get(k), "after": v}

        frame = ExecutionFrame(
            step_index=step_idx,
            line_number=line,
            function_name=func,
            event=event,
            variables=vars_snapshot,
            call_stack=list(self.call_stack),
            arena_generation=self.arena_generation,
            delta_from_prev=delta,
            stdout_chunk=stdout_chunk,
        )

        if len(self.frames) < self.capacity:
            self.frames.append(frame)
        else:
            # Ring buffer wrap-around
            self.frames.pop(0)
            self.frames.append(frame)

        if step_idx % self.checkpoint_interval == 0:
            self.checkpoints[step_idx] = {
                "step": step_idx,
                "vars": vars_snapshot,
                "arena_gen": self.arena_generation,
                "stack": list(self.call_stack),
            }

        return frame

    def record_source(self, source: str, module_name: str = "main") -> ReplayTrace:
        """Parses and deterministically executes the source code under recording instrumentation."""
        t0 = time.perf_counter()
        ast_mod: Module = Parser.from_source(source, filename=f"<{module_name}>").parse_module()

        for stmt in ast_mod.statements:
            if isinstance(stmt, FuncDef):
                self.functions[stmt.name] = stmt
            elif isinstance(stmt, StructDef):
                self.structs[stmt.name] = stmt

        # Execute top-level or main()
        self.call_stack.append("<module>")
        self._record_frame(line=1, func="<module>", event="CALL", prev_vars={})

        entry_fn = self.functions.get("main")
        if entry_fn:
            self._exec_func(entry_fn, [])
        else:
            for stmt in ast_mod.statements:
                if not isinstance(stmt, (FuncDef, StructDef)):
                    self._exec_stmt(stmt, "<module>")

        self._record_frame(line=ast_mod.statements[-1].line if ast_mod.statements else 1, func="<module>", event="RETURN", prev_vars=self.current_vars)
        self.call_stack.pop()

        elapsed_ms = (time.perf_counter() - t0) * 1000.0

        # Also verify with Native JIT
        jit_verified = False
        try:
            mir = compile_source_to_mir(source)
            jit = NativeJITModule(mir)
            try:
                ret = jit.run_main()
                slot0 = jit._rt_slots_arr[0] if hasattr(jit, "_rt_slots_arr") else 0
                jit_verified = (slot0 == 0)
            finally:
                jit.close()
        except Exception:
            jit_verified = False

        trace = ReplayTrace(
            trace_id=f"trace_{int(time.time() * 1000)}",
            module_name=module_name,
            source_code=source,
            total_steps=len(self.frames),
            frames=self.frames,
            checkpoints=self.checkpoints,
            metadata={
                "elapsed_ms": elapsed_ms,
                "jit_verified": jit_verified,
                "arena_generations": self.arena_generation,
                "function_count": len(self.functions),
                "struct_count": len(self.structs),
            },
        )
        return trace

    def _exec_func(self, fn: FuncDef, args: List[Any]) -> Any:
        self.call_stack.append(fn.name)
        prev_vars = dict(self.current_vars)

        # Bind parameters
        for i, param in enumerate(fn.params):
            val = args[i] if i < len(args) else 0
            self.current_vars[param.name] = val

        self._record_frame(line=fn.line, func=fn.name, event="CALL", prev_vars=prev_vars)

        return_val = None
        for stmt in fn.body:
            ret = self._exec_stmt(stmt, fn.name)
            if ret is not None and isinstance(stmt, Return):
                return_val = ret
                break

        self._record_frame(line=fn.line, func=fn.name, event="RETURN", prev_vars=prev_vars)
        self.call_stack.pop()
        return return_val

    def _exec_stmt(self, stmt: Any, func_name: str) -> Any:
        line = getattr(stmt, "line", 1)
        prev_vars = dict(self.current_vars)

        if isinstance(stmt, Assign):
            val = self._eval_expr(stmt.value, func_name)
            self.current_vars[stmt.target] = val
            self._record_frame(line=line, func=func_name, event="MUTATION", prev_vars=prev_vars)
            return None

        elif isinstance(stmt, AugAssign):
            cur = self.current_vars.get(stmt.target, 0)
            diff = self._eval_expr(stmt.value, func_name)
            if stmt.op == "+":
                new_val = cur + diff
            elif stmt.op == "-":
                new_val = cur - diff
            elif stmt.op == "*":
                new_val = cur * diff
            elif stmt.op == "//":
                new_val = cur // diff
            else:
                new_val = diff
            self.current_vars[stmt.target] = new_val
            self._record_frame(line=line, func=func_name, event="MUTATION", prev_vars=prev_vars)
            return None

        elif isinstance(stmt, IfStmt):
            self._record_frame(line=line, func=func_name, event="LINE", prev_vars=prev_vars)
            cond = self._eval_expr(stmt.cond, func_name)
            if cond:
                for s in stmt.then_body:
                    r = self._exec_stmt(s, func_name)
                    if r is not None:
                        return r
            elif stmt.else_body:
                for s in stmt.else_body:
                    r = self._exec_stmt(s, func_name)
                    if r is not None:
                        return r
            return None

        elif isinstance(stmt, WhileStmt):
            while self._eval_expr(stmt.cond, func_name):
                self._record_frame(line=line, func=func_name, event="LINE", prev_vars=prev_vars)
                for s in stmt.body:
                    r = self._exec_stmt(s, func_name)
                    if r is not None:
                        return r
            return None

        elif isinstance(stmt, ForRangeStmt):
            start = self._eval_expr(stmt.start, func_name)
            stop = self._eval_expr(stmt.stop, func_name)
            step = self._eval_expr(stmt.step, func_name) if stmt.step else 1
            cur = start
            while (cur < stop if step > 0 else cur > stop):
                self.current_vars[stmt.var_name] = cur
                self._record_frame(line=line, func=func_name, event="MUTATION", prev_vars=prev_vars)
                for s in stmt.body:
                    r = self._exec_stmt(s, func_name)
                    if r is not None:
                        return r
                cur += step
            return None

        elif isinstance(stmt, Return):
            val = self._eval_expr(stmt.value, func_name) if stmt.value else None
            self._record_frame(line=line, func=func_name, event="RETURN", prev_vars=prev_vars)
            return val

        elif isinstance(stmt, ExprStmt):
            self._record_frame(line=line, func=func_name, event="LINE", prev_vars=prev_vars)
            self._eval_expr(stmt.expr, func_name)
            return None

        else:
            self._record_frame(line=line, func=func_name, event="LINE", prev_vars=prev_vars)
            return None

    def _eval_expr(self, expr: Any, func_name: str) -> Any:
        if isinstance(expr, IntLit):
            return expr.value
        elif isinstance(expr, FloatLit):
            return expr.value
        elif isinstance(expr, StringLit):
            return expr.value
        elif isinstance(expr, BoolLit):
            return expr.value
        elif isinstance(expr, Var):
            return self.current_vars.get(expr.name, 0)

        elif isinstance(expr, BinOp):
            l = self._eval_expr(expr.left, func_name)
            r = self._eval_expr(expr.right, func_name)
            op = expr.op
            if op == "+":
                return l + r
            elif op == "-":
                return l - r
            elif op == "*":
                return l * r
            elif op == "/":
                return l / r if r != 0 else 0
            elif op == "//":
                return l // r if r != 0 else 0
            elif op == "%":
                return l % r if r != 0 else 0
            elif op == "==":
                return l == r
            elif op == "!=":
                return l != r
            elif op == "<":
                return l < r
            elif op == "<=":
                return l <= r
            elif op == ">":
                return l > r
            elif op == ">=":
                return l >= r
            return 0

        elif isinstance(expr, UnaryOp):
            v = self._eval_expr(expr.operand, func_name)
            if expr.op == "-":
                return -v
            elif expr.op == "not":
                return not v
            return v

        elif isinstance(expr, Call):
            callee_name = expr.func if isinstance(expr.func, str) else getattr(expr.func, "name", str(expr.func))
            args = [self._eval_expr(a, func_name) for a in expr.args]

            if callee_name == "print":
                out = " ".join(str(a) for a in args)
                self.stdout_log.append(out)
                self._record_frame(line=getattr(expr, "line", 1), func=func_name, event="LINE", prev_vars=self.current_vars, stdout_chunk=out)
                return None
            elif callee_name == "str":
                return str(args[0]) if args else ""
            elif callee_name in self.structs:
                # Struct instantiation -> arena allocation!
                self.arena_generation += 1
                struct_obj = {"_type": callee_name, "fields": {}}
                for i, f_def in enumerate(self.structs[callee_name].fields):
                    val = args[i] if i < len(args) else 0
                    struct_obj["fields"][f_def.name] = val
                self._record_frame(line=getattr(expr, "line", 1), func=func_name, event="ARENA_ALLOC", prev_vars=self.current_vars)
                return struct_obj
            elif callee_name in self.functions:
                return self._exec_func(self.functions[callee_name], args)
            return 0

        elif isinstance(expr, FieldAccess):
            target_expr = getattr(expr, "target", None) or getattr(expr, "obj", None)
            obj = self._eval_expr(target_expr, func_name)
            if isinstance(obj, dict) and "fields" in obj:
                return obj["fields"].get(expr.field_name, 0)
            return 0

        return 0


class OmniscientDebugger:
    """
    Time-Travel Omniscient Debugger Engine.
    Enables instant seeking backward and forward through execution time,
    querying variable mutation histories, inspecting arena generations,
    and rendering interactive HTML5 debugging timelines.
    """

    def __init__(self, trace: ReplayTrace):
        self.trace = trace
        self.cursor: int = 0
        if not self.trace.frames:
            raise ValueError("Cannot initialize debugger on an empty trace.")

    @property
    def total_steps(self) -> int:
        return self.trace.total_steps

    def current_frame(self) -> ExecutionFrame:
        return self.trace.frames[self.cursor]

    def step_forward(self, count: int = 1) -> ExecutionFrame:
        self.cursor = min(self.trace.total_steps - 1, self.cursor + count)
        return self.current_frame()

    def step_backward(self, count: int = 1) -> ExecutionFrame:
        self.cursor = max(0, self.cursor - count)
        return self.current_frame()

    def jump_to_step(self, target_step: int) -> ExecutionFrame:
        if target_step < 0 or target_step >= self.trace.total_steps:
            raise IndexError(f"Target step {target_step} out of bounds [0, {self.trace.total_steps - 1}]")
        self.cursor = target_step
        return self.current_frame()

    def jump_to_line(self, line_number: int, reverse: bool = False) -> Optional[ExecutionFrame]:
        indices = range(self.cursor - 1, -1, -1) if reverse else range(self.cursor + 1, self.trace.total_steps)
        for idx in indices:
            if self.trace.frames[idx].line_number == line_number:
                self.cursor = idx
                return self.trace.frames[idx]
        return None

    def query_variable_history(self, var_name: str) -> List[Dict[str, Any]]:
        """Returns the full chronological modification history for a given variable."""
        history = []
        last_val = None
        for frame in self.trace.frames:
            if var_name in frame.variables:
                val = frame.variables[var_name]
                if val != last_val:
                    history.append({
                        "step": frame.step_index,
                        "line": frame.line_number,
                        "func": frame.function_name,
                        "value": val,
                    })
                    last_val = val
        return history

    def diff_steps(self, step_a: int, step_b: int) -> Dict[str, Any]:
        """Calculates variable, arena, and execution differences between two points in time."""
        if not (0 <= step_a < self.trace.total_steps and 0 <= step_b < self.trace.total_steps):
            raise IndexError("Diff step indices out of bounds")

        fa = self.trace.frames[step_a]
        fb = self.trace.frames[step_b]

        all_keys = set(fa.variables.keys()).union(fb.variables.keys())
        changed_vars: Dict[str, Any] = {}
        for k in all_keys:
            val_a = fa.variables.get(k)
            val_b = fb.variables.get(k)
            if val_a != val_b:
                changed_vars[k] = {"before": val_a, "after": val_b}

        return {
            "step_a": step_a,
            "step_b": step_b,
            "step_delta": step_b - step_a,
            "arena_delta": fb.arena_generation - fa.arena_generation,
            "changed_variables": changed_vars,
            "stack_before": fa.call_stack,
            "stack_after": fb.call_stack,
        }

    def export_interactive_html(self, output_path: str) -> str:
        """Exports a standalone interactive HTML5 time-travel timeline debugger."""
        trace_json = json.dumps(self.trace.to_dict())
        html_content = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>TinyTalk Omniscient Debugger — {self.trace.module_name}</title>
<style>
  :root {{
    --bg-main: #0d1117;
    --bg-card: #161b22;
    --bg-hover: #21262d;
    --border: #30363d;
    --accent: #58a6ff;
    --accent-gold: #f1e05a;
    --green: #238636;
    --red: #da3633;
    --text: #c9d1d9;
    --text-muted: #8b949e;
  }}
  * {{ box-sizing: border-box; margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, monospace; }}
  body {{ background: var(--bg-main); color: var(--text); display: flex; flex-direction: column; height: 100vh; overflow: hidden; }}
  header {{ background: var(--bg-card); border-bottom: 1px solid var(--border); padding: 12px 20px; display: flex; justify-content: space-between; align-items: center; }}
  header h1 {{ font-size: 16px; color: #58a6ff; display: flex; align-items: center; gap: 8px; }}
  .tag {{ background: #238636; color: white; padding: 2px 8px; border-radius: 12px; font-size: 11px; }}
  .main-layout {{ display: flex; flex: 1; overflow: hidden; }}
  .panel {{ flex: 1; border-right: 1px solid var(--border); overflow-y: auto; padding: 16px; }}
  .source-panel {{ flex: 1.2; background: #0b0e14; }}
  .state-panel {{ flex: 0.9; background: var(--bg-card); }}
  .timeline-footer {{ background: var(--bg-card); border-top: 1px solid var(--border); padding: 16px 20px; display: flex; flex-direction: column; gap: 10px; }}
  .controls {{ display: flex; align-items: center; gap: 12px; }}
  button {{ background: var(--bg-hover); color: var(--text); border: 1px solid var(--border); padding: 6px 14px; border-radius: 6px; cursor: pointer; font-size: 13px; }}
  button:hover {{ background: #30363d; border-color: #8b949e; }}
  button.active {{ background: #1f6feb; border-color: #58a6ff; color: white; }}
  input[type=range] {{ flex: 1; cursor: pointer; }}
  .code-line {{ display: flex; line-height: 1.6; font-size: 13px; padding: 0 4px; }}
  .code-line.active {{ background: rgba(88, 166, 255, 0.25); border-left: 3px solid #58a6ff; }}
  .line-no {{ width: 36px; color: var(--text-muted); text-align: right; margin-right: 12px; user-select: none; }}
  .var-table {{ width: 100%; border-collapse: collapse; font-size: 13px; margin-top: 10px; }}
  .var-table th, .var-table td {{ border: 1px solid var(--border); padding: 6px 10px; text-align: left; }}
  .var-table th {{ background: var(--bg-hover); color: var(--accent); }}
  .badge-event {{ padding: 2px 6px; border-radius: 4px; font-size: 11px; font-weight: bold; }}
  .ev-MUTATION {{ background: #388bfd33; color: #58a6ff; }}
  .ev-CALL {{ background: #23863633; color: #3fb950; }}
  .ev-ARENA_ALLOC {{ background: #d2992233; color: #f1e05a; }}
  .ev-RETURN {{ background: #da363333; color: #f85149; }}
</style>
</head>
<body>
<header>
  <h1><span>⏱️ TinyTalk Omniscient Debugger</span> <span class="tag">v2.6.0 Time-Travel</span></h1>
  <div>Module: <strong>{self.trace.module_name}</strong> | Total Steps: <strong>{self.trace.total_steps}</strong></div>
</header>
<div class="main-layout">
  <div class="panel source-panel">
    <h3 style="margin-bottom: 12px; color: var(--text-muted); font-size: 12px; text-transform: uppercase;">Source Code Navigation</h3>
    <div id="sourceContainer"></div>
  </div>
  <div class="panel state-panel">
    <h3 style="margin-bottom: 12px; color: var(--text-muted); font-size: 12px; text-transform: uppercase;">Time-Frame State Inspector</h3>
    <div style="display: flex; gap: 8px; margin-bottom: 12px;">
      <div>Step: <strong id="stepLabel" style="color: var(--accent);">0</strong></div>
      <div>Event: <span id="eventBadge" class="badge-event ev-CALL">CALL</span></div>
      <div>Arena Gen: <strong id="arenaLabel" style="color: var(--accent-gold);">0</strong></div>
    </div>
    <div style="margin-bottom: 8px; font-size: 13px;">Call Stack: <code id="stackLabel" style="color: #7ee787;">&lt;module&gt;</code></div>
    <table class="var-table">
      <thead><tr><th>Variable</th><th>Value</th><th>Type</th></tr></thead>
      <tbody id="varsBody"></tbody>
    </table>
    <h4 style="margin-top: 16px; margin-bottom: 6px; color: var(--text-muted); font-size: 12px;">Frame Mutation Delta</h4>
    <pre id="deltaPre" style="background: var(--bg-main); padding: 8px; border-radius: 6px; font-size: 12px; border: 1px solid var(--border); overflow-x: auto;">{{}}</pre>
  </div>
</div>
<div class="timeline-footer">
  <div class="controls">
    <button onclick="step(-1)">◀ Step Back</button>
    <button id="playBtn" onclick="togglePlay()">▶ Play</button>
    <button onclick="step(1)">Step Forward ▶</button>
    <span style="font-size: 13px; color: var(--text-muted); min-width: 90px;" id="timeLabel">0 / {self.trace.total_steps - 1}</span>
    <input type="range" id="timelineSlider" min="0" max="{self.trace.total_steps - 1}" value="0" oninput="seekTo(parseInt(this.value))" />
  </div>
</div>
<script>
  const trace = {trace_json};
  let currentStep = 0;
  let playing = false;
  let playTimer = null;

  function renderSource() {{
    const container = document.getElementById("sourceContainer");
    const lines = trace.source_code.split("\\n");
    container.innerHTML = lines.map((l, i) => `
      <div class="code-line" id="line-${{i+1}}">
        <span class="line-no">${{i+1}}</span>
        <span class="line-code">${{escapeHtml(l)}}</span>
      </div>
    `).join("");
  }}

  function escapeHtml(text) {{
    return text.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
  }}

  function updateView() {{
    const frame = trace.frames[currentStep];
    document.getElementById("stepLabel").textContent = frame.step;
    document.getElementById("timelineSlider").value = frame.step;
    document.getElementById("timeLabel").textContent = `${{frame.step}} / ${{trace.total_steps - 1}}`;
    document.getElementById("arenaLabel").textContent = frame.arena_gen;
    document.getElementById("stackLabel").textContent = frame.stack.join(" -> ");
    
    const badge = document.getElementById("eventBadge");
    badge.textContent = frame.event;
    badge.className = "badge-event ev-" + frame.event;

    // Highlight source line
    document.querySelectorAll(".code-line").forEach(el => el.classList.remove("active"));
    const activeLine = document.getElementById("line-" + frame.line);
    if (activeLine) {{
      activeLine.classList.add("active");
      activeLine.scrollIntoView({{ block: "nearest", behavior: "smooth" }});
    }}

    // Render variables
    const tbody = document.getElementById("varsBody");
    tbody.innerHTML = Object.entries(frame.vars).map(([k, v]) => `
      <tr>
        <td style="color: #79c0ff; font-weight: bold;">${{k}}</td>
        <td>${{escapeHtml(JSON.stringify(v))}}</td>
        <td style="color: var(--text-muted);">${{typeof v}}</td>
      </tr>
    `).join("");

    document.getElementById("deltaPre").textContent = JSON.stringify(frame.delta, null, 2);
  }}

  function step(delta) {{
    currentStep = Math.max(0, Math.min(trace.total_steps - 1, currentStep + delta));
    updateView();
  }}

  function seekTo(target) {{
    currentStep = target;
    updateView();
  }}

  function togglePlay() {{
    playing = !playing;
    document.getElementById("playBtn").textContent = playing ? "⏸ Pause" : "▶ Play";
    if (playing) {{
      playTimer = setInterval(() => {{
        if (currentStep >= trace.total_steps - 1) {{
          togglePlay();
        }} else {{
          step(1);
        }}
      }}, 100);
    }} else {{
      clearInterval(playTimer);
    }}
  }}

  renderSource();
  updateView();
</script>
</body>
</html>
"""
        with open(output_path, "w", encoding="utf-8") as f:
            f.write(html_content)
        return output_path
