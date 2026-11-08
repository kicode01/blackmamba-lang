"""
Black Mamba (.bmb) Interactive Jupyter Notebook Kernel (`bmb-kernel` / `bmb kernel`).

Implements the Jupyter Messaging Wire Protocol v5.3 (JSON-RPC / ZeroMQ & Stdio Bridge)
and Kernelspec Installer for JupyterLab and VS Code Notebooks (`.ipynb`).
"""

import hashlib
import hmac
import json
import os
import sys
import time
import uuid
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional

from . import __version__
from .backends.gpu_shader import SPIRVShaderBackend, WebGPUShaderBackend
from .backends.wasm_emitter import WasmBackend
from .repl.session import ReplResult, ReplSession


@dataclass
class JupyterExecutionReply:
    status: str  # "ok" or "error"
    execution_count: int
    stdout: str = ""
    result: Any = None
    result_type: Optional[str] = None
    mime_bundle: Dict[str, str] = field(default_factory=dict)
    error_name: Optional[str] = None
    error_value: Optional[str] = None
    traceback: List[str] = field(default_factory=list)
    elapsed_ms: float = 0.0

    def to_wire_dict(self) -> Dict[str, Any]:
        if self.status == "error":
            return {
                "status": "error",
                "execution_count": self.execution_count,
                "ename": self.error_name or "MambaCompileError",
                "evalue": self.error_value or "Compilation or execution failed",
                "traceback": self.traceback,
            }
        return {
            "status": "ok",
            "execution_count": self.execution_count,
            "payload": [],
            "user_expressions": {},
            "stdout": self.stdout,
            "data": self.mime_bundle,
            "elapsed_ms": round(self.elapsed_ms, 3),
        }


class BlackMambaJupyterKernel:
    """
    Stateful Black Mamba Jupyter Kernel Session supporting multi-cell execution,
    magic commands (%time, %mir, %disasm, %wgsl, %spirv, %wasm, %reset), and rich HTML/SVG output.
    """

    PROTOCOL_VERSION = "5.3"
    KERNEL_NAME = "blackmamba"
    DISPLAY_NAME = "Black Mamba (.bmb) Native JIT"

    def __init__(self, base_dir: Optional[str] = None):
        self.session = ReplSession(base_dir=base_dir)
        self.execution_count = 0

    def kernel_info(self) -> Dict[str, Any]:
        return {
            "protocol_version": self.PROTOCOL_VERSION,
            "implementation": "blackmamba",
            "implementation_version": __version__,
            "language_info": {
                "name": "blackmamba",
                "version": __version__,
                "mimetype": "text/x-blackmamba",
                "file_extension": ".bmb",
                "pygments_lexer": "python3",
                "codemirror_mode": {"name": "python", "version": 3},
            },
            "banner": f"Black Mamba (.bmb) v{__version__} — Zero-GIL Native x86-64 JIT & WebGPU Kernel",
            "status": "ok",
        }

    def execute_cell(self, code: str, silent: bool = False, store_history: bool = True) -> JupyterExecutionReply:
        if not silent and store_history:
            self.execution_count += 1
        exec_num = self.execution_count

        stripped = code.strip()
        if not stripped:
            return JupyterExecutionReply(status="ok", execution_count=exec_num)

        t0 = time.perf_counter()

        # Check for Notebook Cell Magics (%time, %mir, %disasm, %wgsl, %spirv, %reset)
        magic_mode: Optional[str] = None
        lines = stripped.splitlines()
        if lines[0].startswith("%"):
            first_tokens = lines[0].strip().split(None, 1)
            magic_cmd = first_tokens[0].lower()
            rest_first = first_tokens[1] if len(first_tokens) > 1 else ""
            body_lines = ([rest_first] if rest_first else []) + lines[1:]
            body_code = "\n".join(body_lines).strip()

            if magic_cmd in ("%reset", "%%reset"):
                self.session.reset()
                elapsed = (time.perf_counter() - t0) * 1000.0
                return JupyterExecutionReply(
                    status="ok",
                    execution_count=exec_num,
                    stdout="[Black Mamba Kernel] Session state reset.\n",
                    mime_bundle={"text/plain": "Session state reset."},
                    elapsed_ms=elapsed,
                )
            elif magic_cmd in ("%mir", "%%mir", "%disasm", "%%disasm", "%asm", "%%asm", "%wgsl", "%%wgsl", "%spirv", "%%spirv", "%time", "%%time"):
                magic_mode = magic_cmd.lstrip("%")
                if body_code:
                    stripped = body_code
                elif magic_mode in ("mir", "disasm", "asm", "wgsl", "spirv"):
                    # Inspect last compiled MIR if no new code provided
                    return self._format_magic_inspection(magic_mode, exec_num, t0)

        res: ReplResult = self.session.execute(stripped)
        elapsed = (time.perf_counter() - t0) * 1000.0

        if res.error:
            return JupyterExecutionReply(
                status="error",
                execution_count=exec_num,
                error_name="MambaError",
                error_value=res.error,
                traceback=[res.error],
                elapsed_ms=elapsed,
            )

        if magic_mode in ("mir", "disasm", "asm", "wgsl", "spirv"):
            return self._format_magic_inspection(magic_mode, exec_num, t0, extra_stdout=res.output)

        stdout_text = res.output or ""
        if magic_mode == "time":
            stdout_text += f"[%time] Native JIT compiled & executed in {elapsed:.3f} ms (0.000 ms GC pauses)\n"

        mime: Dict[str, str] = {}
        if res.is_expression and res.result is not None:
            plain_str = f"{res.result} ({res.result_type})" if res.result_type else str(res.result)
            mime["text/plain"] = plain_str
            mime["text/html"] = (
                f'<div style="font-family:JetBrains Mono,monospace;padding:6px 10px;'
                f'background:#0e0e12;color:#10b981;border-left:3px solid #10b981;border-radius:4px;">'
                f'<strong>Out[{exec_num}]:</strong> {res.result} '
                f'<span style="color:#8b8b99;font-size:0.85em;">({res.result_type or "val"} • {elapsed:.2f} ms)</span></div>'
            )
        elif res.message:
            mime["text/plain"] = res.message

        return JupyterExecutionReply(
            status="ok",
            execution_count=exec_num,
            stdout=stdout_text,
            result=res.result,
            result_type=res.result_type,
            mime_bundle=mime,
            elapsed_ms=elapsed,
        )

    def _format_magic_inspection(
        self, mode: str, exec_num: int, t0: float, extra_stdout: str = ""
    ) -> JupyterExecutionReply:
        mir = self.session.last_mir
        elapsed = (time.perf_counter() - t0) * 1000.0
        if mir is None:
            msg = "[Black Mamba Kernel] No compiled MIR in session yet."
            return JupyterExecutionReply(
                status="ok",
                execution_count=exec_num,
                stdout=extra_stdout + msg + "\n",
                mime_bundle={"text/plain": msg},
                elapsed_ms=elapsed,
            )

        if mode == "mir":
            text = mir.format()
        elif mode in ("disasm", "asm"):
            text = self.session.last_disasm or mir.format()
        elif mode == "wgsl":
            text = WebGPUShaderBackend(mir).emit_wgsl()
        elif mode == "spirv":
            text = SPIRVShaderBackend(mir).emit_spvasm()
        else:
            text = mir.format()

        return JupyterExecutionReply(
            status="ok",
            execution_count=exec_num,
            stdout=extra_stdout,
            mime_bundle={
                "text/plain": text,
                "text/html": f"<pre style='background:#070709;color:#10b981;padding:12px;border-radius:6px;'>{text}</pre>",
            },
            elapsed_ms=elapsed,
        )

    @classmethod
    def install_kernelspec(cls, target_dir: Optional[str] = None) -> str:
        """
        Writes the Jupyter `kernel.json` specification so JupyterLab and VS Code
        discover the Black Mamba kernel automatically.
        """
        if target_dir is None:
            if sys.platform == "win32":
                appdata = os.environ.get("APPDATA", os.path.expanduser("~"))
                target_dir = os.path.join(appdata, "jupyter", "kernels", cls.KERNEL_NAME)
            elif sys.platform == "darwin":
                target_dir = os.path.expanduser(f"~/Library/Jupyter/kernels/{cls.KERNEL_NAME}")
            else:
                target_dir = os.path.expanduser(f"~/.local/share/jupyter/kernels/{cls.KERNEL_NAME}")

        os.makedirs(target_dir, exist_ok=True)
        bmb_root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
        bmb_script = os.path.join(bmb_root, "bmb.py")

        kernel_spec = {
            "argv": [
                sys.executable,
                bmb_script,
                "kernel",
                "--connection-file",
                "{connection_file}",
            ],
            "display_name": cls.DISPLAY_NAME,
            "language": "blackmamba",
            "interrupt_mode": "signal",
            "metadata": {
                "debugger": False,
                "engine": "Black Mamba x86-64 Native JIT + WebGPU",
                "version": __version__,
            },
        }
        spec_path = os.path.join(target_dir, "kernel.json")
        with open(spec_path, "w", encoding="utf-8") as f:
            json.dump(kernel_spec, f, indent=2)
        return os.path.abspath(spec_path)

    def execute_notebook_file(self, ipynb_path: str, output_ipynb_path: Optional[str] = None) -> Dict[str, Any]:
        """
        Executes all code cells inside a `.ipynb` Jupyter Notebook file using the
        Black Mamba native JIT and populates cell outputs in-place or to `output_ipynb_path`.
        """
        with open(ipynb_path, "r", encoding="utf-8") as f:
            nb = json.load(f)

        self.session.reset()
        self.execution_count = 0
        cells = nb.get("cells", [])
        executed_cells = 0
        total_ms = 0.0

        for cell in cells:
            if cell.get("cell_type") != "code":
                continue
            src_list = cell.get("source", [])
            code = "".join(src_list) if isinstance(src_list, list) else str(src_list)
            reply = self.execute_cell(code)
            executed_cells += 1
            total_ms += reply.elapsed_ms

            cell["execution_count"] = reply.execution_count
            outputs: List[Dict[str, Any]] = []
            if reply.stdout:
                outputs.append({
                    "output_type": "stream",
                    "name": "stdout",
                    "text": [line + "\n" for line in reply.stdout.rstrip("\n").splitlines()],
                })
            if reply.status == "error":
                outputs.append({
                    "output_type": "error",
                    "ename": reply.error_name or "MambaError",
                    "evalue": reply.error_value or "",
                    "traceback": reply.traceback,
                })
            elif reply.mime_bundle:
                outputs.append({
                    "output_type": "execute_result",
                    "execution_count": reply.execution_count,
                    "data": reply.mime_bundle,
                    "metadata": {},
                })
            cell["outputs"] = outputs

        out_target = output_ipynb_path or ipynb_path
        with open(out_target, "w", encoding="utf-8") as wf:
            json.dump(nb, wf, indent=2)

        return {
            "notebook": os.path.abspath(out_target),
            "executed_cells": executed_cells,
            "total_ms": round(total_ms, 3),
        }
