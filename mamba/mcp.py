# Black Mamba (BMB) Model Context Protocol (MCP) Server
# Enables zero-latency AST inspection, surgical patching, JIT execution,
# canvas visualization, image snapshots, and database querying for AI agents
# (Claude, Cursor, Windsurf, Antigravity, and autonomous subagents).

import sys
import os
import json
import traceback
from typing import Dict, Any, List, Optional, Callable

from .ast_graph import ASTGraph, TokenSparseCodec, ASTPatcher, ASTDeltaOp, benchmark_token_efficiency
from .backends.x86_64_jit import NativeJITModule
from .cli import compile_source_to_mir
from .canvas import MorphicCanvas
from .image import ImageManager
from .db import Database
from .fuzzer import AdversarialFuzzer


MCP_PROTOCOL_VERSION = "2024-11-05"
SERVER_NAME = "blackmamba-mcp-server"
SERVER_VERSION = "2.5.0"


class BlackMambaMCPServer:
    """
    Standard Model Context Protocol (MCP) Server implementation for Black Mamba.
    Exposes high-performance compiler tools, AST delta patching, JIT evaluation,
    and runtime image management over JSON-RPC 2.0.
    """

    def __init__(self, workspace_dir: Optional[str] = None):
        self.workspace_dir = os.path.abspath(workspace_dir or os.getcwd())
        self.patcher = ASTPatcher()
        self.image_mgr = ImageManager()
        self.registered_tools: Dict[str, Callable[[Dict[str, Any]], Dict[str, Any]]] = {}
        self._register_default_tools()

    def _register_default_tools(self) -> None:
        self.registered_tools["bmb_ast_inspect"] = self._tool_ast_inspect
        self.registered_tools["bmb_ast_encode"] = self._tool_ast_encode
        self.registered_tools["bmb_ast_decode"] = self._tool_ast_decode
        self.registered_tools["bmb_ast_patch"] = self._tool_ast_patch
        self.registered_tools["bmb_jit_run"] = self._tool_jit_run
        self.registered_tools["bmb_image_save"] = self._tool_image_save
        self.registered_tools["bmb_image_load"] = self._tool_image_load
        self.registered_tools["bmb_canvas_morphs"] = self._tool_canvas_morphs
        self.registered_tools["bmb_db_query"] = self._tool_db_query
        self.registered_tools["bmb_fuzz"] = self._tool_fuzz

    def get_tool_definitions(self) -> List[Dict[str, Any]]:
        """Returns JSON schema definitions for all exposed MCP tools."""
        return [
            {
                "name": "bmb_ast_inspect",
                "description": "Inspects a Black Mamba source file or string, returning content-addressed AST symbol URIs, SHA-256 hashes, signatures, and skeleton outline.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "source": {"type": "string", "description": "Raw .bmb source code to inspect (optional if path is provided)"},
                        "path": {"type": "string", "description": "Path to .bmb file (optional if source is provided)"},
                    },
                },
            },
            {
                "name": "bmb_ast_encode",
                "description": "Encodes Black Mamba source into token-sparse compact .bmbs / S-expression notation, saving up to 87% LLM context tokens.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "source": {"type": "string", "description": "Standard .bmb source code"},
                    },
                    "required": ["source"],
                },
            },
            {
                "name": "bmb_ast_decode",
                "description": "Decodes token-sparse .bmbs / S-expression notation back into idiomatic human-readable .bmb source code.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "encoded": {"type": "string", "description": "Compact token-sparse .bmbs content"},
                    },
                    "required": ["encoded"],
                },
            },
            {
                "name": "bmb_ast_patch",
                "description": "Applies surgical, verified AST delta operations (REPLACE_SYMBOL, ADD_SYMBOL, DELETE_SYMBOL, etc.) to a .bmb file with automatic compiler validation and rollback.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "source": {"type": "string", "description": "Target source code to patch"},
                        "operations": {
                            "type": "array",
                            "description": "List of ASTDeltaOp mutations",
                            "items": {
                                "type": "object",
                                "properties": {
                                    "op": {"type": "string", "enum": ["REPLACE_SYMBOL", "ADD_SYMBOL", "DELETE_SYMBOL", "ADD_FIELD", "REMOVE_FIELD", "ADD_METHOD", "RENAME_SYMBOL"]},
                                    "target_uri": {"type": "string", "description": "Symbol URI e.g. bmb://mod/Type/method"},
                                    "code": {"type": "string", "description": "New code for replace/add"},
                                    "new_name": {"type": "string", "description": "Target identifier for rename"},
                                },
                                "required": ["op", "target_uri"],
                            },
                        },
                    },
                    "required": ["source", "operations"],
                },
            },
            {
                "name": "bmb_jit_run",
                "description": "Compiles and executes Black Mamba code in-memory with the native x86-64 JIT, capturing stdout and return value in < 15 ms.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "source": {"type": "string", "description": "Complete .bmb source containing main()"},
                    },
                    "required": ["source"],
                },
            },
            {
                "name": "bmb_image_save",
                "description": "Freezes live runtime heap, in-memory SQLite tables, and 2D canvas state into a portable .bmbimg snapshot with instant resume.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "source": {"type": "string", "description": "Source code to capture state from"},
                        "output_path": {"type": "string", "description": "Path to write .bmbimg file"},
                    },
                    "required": ["source", "output_path"],
                },
            },
            {
                "name": "bmb_image_load",
                "description": "Resumes and inspects a Smalltalk-style .bmbimg memory image snapshot in < 5 ms.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "path": {"type": "string", "description": "Path to .bmbimg image file"},
                    },
                    "required": ["path"],
                },
            },
            {
                "name": "bmb_canvas_morphs",
                "description": "Constructs and inspects the 2D Spatial Morphic Canvas for a module, returning morph cards, positions, and wires.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "source": {"type": "string", "description": ".bmb source code to mount on canvas"},
                        "module_name": {"type": "string", "description": "Optional module identifier"},
                    },
                    "required": ["source"],
                },
            },
            {
                "name": "bmb_db_query",
                "description": "Executes a SQL query on a Black Mamba relational database (SQLite/WAL mode) and returns structured row results.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "db_path": {"type": "string", "description": "Path to SQLite database file"},
                        "sql": {"type": "string", "description": "SQL statement to execute"},
                    },
                    "required": ["db_path", "sql"],
                },
            },
            {
                "name": "bmb_fuzz",
                "description": "Executes adversarial compiler fuzzer verification across differential CPython vs JIT, PE .exe, and token-sparse codecs.",
                "inputSchema": {
                    "type": "object",
                    "properties": {
                        "cases": {"type": "integer", "description": "Number of fuzzer cases to run per vector", "default": 5},
                        "seed": {"type": "integer", "description": "Deterministic PRNG seed", "default": 20261108},
                    },
                },
            },
        ]

    # Tool Implementations
    def _tool_ast_inspect(self, args: Dict[str, Any]) -> Dict[str, Any]:
        source = args.get("source")
        path = args.get("path")
        if not source and path:
            if not os.path.exists(path):
                raise FileNotFoundError(f"File not found: {path}")
            with open(path, "r", encoding="utf-8") as f:
                source = f.read()
        if not source:
            raise ValueError("Either 'source' or 'path' must be provided.")

        g = ASTGraph.from_source(source, module_name=os.path.basename(path).split(".")[0] if path else "main")
        nodes_info = [node.to_dict() for node in g.nodes.values()]
        return {
            "module": g.module_name,
            "symbol_count": len(g.nodes),
            "skeleton": g.to_skeleton(),
            "symbols": nodes_info,
        }

    def _tool_ast_encode(self, args: Dict[str, Any]) -> Dict[str, Any]:
        src = args["source"]
        codec = TokenSparseCodec()
        encoded = codec.encode(src)
        stats = benchmark_token_efficiency(src)
        return {
            "encoded": encoded,
            "read_savings_pct": stats.read_savings_pct,
            "full_bmb_tokens": stats.full_bmb_tokens,
            "compact_bmbs_tokens": stats.compact_bmbs_tokens,
        }

    def _tool_ast_decode(self, args: Dict[str, Any]) -> Dict[str, Any]:
        encoded = args["encoded"]
        codec = TokenSparseCodec()
        decoded = codec.decode(encoded)
        return {"source": decoded}

    def _tool_ast_patch(self, args: Dict[str, Any]) -> Dict[str, Any]:
        source = args["source"]
        ops_data = args["operations"]
        ops = [ASTDeltaOp.from_dict(d) for d in ops_data]
        res = self.patcher.apply_patch(source, ops)
        return {
            "success": res.success,
            "new_source": res.new_source,
            "patched_symbols": res.patched_symbols,
            "diagnostics": res.diagnostics,
            "elapsed_ms": res.elapsed_ms,
        }

    def _tool_jit_run(self, args: Dict[str, Any]) -> Dict[str, Any]:
        source = args["source"]
        mir = compile_source_to_mir(source)
        outputs: List[str] = []
        jit = NativeJITModule(mir, output_callback=lambda s: outputs.append(s))
        try:
            ret = jit.run_main()
            slot0 = jit._rt_slots_arr[0] if hasattr(jit, "_rt_slots_arr") else 0
            return {
                "exit_code": ret,
                "exception_slot": slot0,
                "stdout": "".join(outputs),
                "success": (ret == 0 and slot0 == 0),
            }
        finally:
            jit.close()

    def _tool_image_save(self, args: Dict[str, Any]) -> Dict[str, Any]:
        source = args["source"]
        out_path = args["output_path"]
        canvas = MorphicCanvas(source=source)
        snap = self.image_mgr.save_image(path=out_path, canvas=canvas, modules={"main": source})
        return {
            "path": snap.path,
            "sha256": snap.sha256,
            "bytes": os.path.getsize(out_path) if os.path.exists(out_path) else 0,
            "elapsed_ms": snap.elapsed_ms,
        }

    def _tool_image_load(self, args: Dict[str, Any]) -> Dict[str, Any]:
        path = args["path"]
        snap = self.image_mgr.load_image(path)
        morph_count = len(snap.canvas.morphs) if snap.canvas else 0
        wire_count = len(snap.canvas.wires) if snap.canvas else 0
        return {
            "path": snap.path,
            "version": snap.version,
            "sha256": snap.sha256,
            "modules": list(snap.modules.keys()),
            "morph_count": morph_count,
            "wire_count": wire_count,
            "elapsed_ms": snap.elapsed_ms,
        }

    def _tool_canvas_morphs(self, args: Dict[str, Any]) -> Dict[str, Any]:
        source = args["source"]
        mod_name = args.get("module_name", "canvas_module")
        canvas = MorphicCanvas(source=source, module_name=mod_name)
        morphs_info = []
        for m in canvas.morphs:
            morphs_info.append({
                "id": m.id,
                "title": m.title,
                "kind": m.kind.name,
                "x": m.x,
                "y": m.y,
                "width": m.width,
                "height": m.height,
                "ast_uri": m.ast_uri,
            })
        return {
            "module_name": mod_name,
            "morph_count": len(canvas.morphs),
            "wire_count": len(canvas.wires),
            "morphs": morphs_info,
        }

    def _tool_db_query(self, args: Dict[str, Any]) -> Dict[str, Any]:
        import time
        t0 = time.perf_counter()
        db_path = args["db_path"]
        sql = args["sql"]
        db = Database(db_path)
        try:
            sql_stripped = sql.strip().upper()
            if sql_stripped.startswith("SELECT") or sql_stripped.startswith("PRAGMA"):
                rows = db.fetchall(sql)
                cols = list(rows[0].keys()) if rows else []
            else:
                db.execute(sql)
                rows = []
                cols = []
            elapsed = (time.perf_counter() - t0) * 1000.0
            return {
                "db_path": db_path,
                "columns": cols,
                "rows": rows,
                "row_count": len(rows),
                "elapsed_ms": elapsed,
            }
        finally:
            db.close()

    def _tool_fuzz(self, args: Dict[str, Any]) -> Dict[str, Any]:
        cases = args.get("cases", 5)
        seed = args.get("seed", 20261108)
        fuzzer = AdversarialFuzzer(seed=seed)
        report = fuzzer.run_suite(
            diff_cases=cases,
            pe_cases=max(1, cases // 2),
            codec_cases=cases,
            arena_cases=cases,
            chaos_cases=cases,
            hist_cases=max(1, cases // 2),
        )
        return {
            "all_passed": report.all_passed,
            "passed_count": report.passed_count,
            "failed_count": report.failed_count,
            "total_cases": report.total_cases,
            "elapsed_ms": report.elapsed_ms,
        }

    def handle_request(self, req: Dict[str, Any]) -> Dict[str, Any]:
        """Processes a single JSON-RPC 2.0 request dictionary and returns a response dictionary."""
        req_id = req.get("id")
        method = req.get("method")
        params = req.get("params", {})

        if not method:
            return {
                "jsonrpc": "2.0",
                "id": req_id,
                "error": {"code": -32600, "message": "Invalid Request: missing method"},
            }

        try:
            if method == "initialize":
                return {
                    "jsonrpc": "2.0",
                    "id": req_id,
                    "result": {
                        "protocolVersion": MCP_PROTOCOL_VERSION,
                        "capabilities": {
                            "tools": {"listChanged": False},
                            "resources": {"subscribe": False, "listChanged": False},
                        },
                        "serverInfo": {
                            "name": SERVER_NAME,
                            "version": SERVER_VERSION,
                        },
                    },
                }

            elif method == "notifications/initialized":
                return {}

            elif method == "ping":
                return {"jsonrpc": "2.0", "id": req_id, "result": {}}

            elif method == "tools/list":
                return {
                    "jsonrpc": "2.0",
                    "id": req_id,
                    "result": {"tools": self.get_tool_definitions()},
                }

            elif method == "tools/call":
                tool_name = params.get("name")
                tool_args = params.get("arguments", {})
                if tool_name not in self.registered_tools:
                    return {
                        "jsonrpc": "2.0",
                        "id": req_id,
                        "error": {"code": -32601, "message": f"Method/Tool not found: {tool_name}"},
                    }
                tool_fn = self.registered_tools[tool_name]
                out_data = tool_fn(tool_args)
                return {
                    "jsonrpc": "2.0",
                    "id": req_id,
                    "result": {
                        "content": [
                            {
                                "type": "text",
                                "text": json.dumps(out_data, indent=2),
                            }
                        ],
                        "isError": False,
                    },
                }

            elif method == "resources/list":
                return {
                    "jsonrpc": "2.0",
                    "id": req_id,
                    "result": {
                        "resources": [
                            {
                                "uri": "bmb://workspace/status",
                                "name": "Workspace Status",
                                "description": "Current active Black Mamba compiler workspace path and version.",
                                "mimeType": "application/json",
                            }
                        ]
                    },
                }

            elif method == "resources/read":
                uri = params.get("uri")
                if uri == "bmb://workspace/status":
                    status_content = json.dumps({
                        "workspace": self.workspace_dir,
                        "version": SERVER_VERSION,
                        "active_tools": list(self.registered_tools.keys()),
                    })
                    return {
                        "jsonrpc": "2.0",
                        "id": req_id,
                        "result": {
                            "contents": [
                                {
                                    "uri": uri,
                                    "mimeType": "application/json",
                                    "text": status_content,
                                }
                            ]
                        },
                    }
                else:
                    return {
                        "jsonrpc": "2.0",
                        "id": req_id,
                        "error": {"code": -32602, "message": f"Resource not found: {uri}"},
                    }

            else:
                return {
                    "jsonrpc": "2.0",
                    "id": req_id,
                    "error": {"code": -32601, "message": f"Unknown method: {method}"},
                }

        except Exception as e:
            return {
                "jsonrpc": "2.0",
                "id": req_id,
                "error": {
                    "code": -32000,
                    "message": str(e),
                    "data": {"traceback": traceback.format_exc()},
                },
            }

    def run_stdio(self) -> None:
        """
        Runs the MCP server over standard input/output (stdio).
        Logs to stderr to avoid corrupting the JSON-RPC communication stream.
        """
        sys.stderr.write(f"[{SERVER_NAME}] Starting stdio loop (v{SERVER_VERSION})...\n")
        sys.stderr.flush()

        for line in sys.stdin:
            line = line.strip()
            if not line:
                continue
            try:
                req = json.loads(line)
            except Exception as e:
                err_resp = {
                    "jsonrpc": "2.0",
                    "id": None,
                    "error": {"code": -32700, "message": f"Parse error: {e}"},
                }
                sys.stdout.write(json.dumps(err_resp) + "\n")
                sys.stdout.flush()
                continue

            resp = self.handle_request(req)
            if resp:  # Notifications might return empty dict
                sys.stdout.write(json.dumps(resp) + "\n")
                sys.stdout.flush()
