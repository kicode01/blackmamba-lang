import os
import sys
import json
import tempfile
import unittest
from io import StringIO
from unittest.mock import patch

from mamba.mcp import BlackMambaMCPServer, MCP_PROTOCOL_VERSION, SERVER_VERSION
from mamba.orchestrator import (
    ASTSymbolLockManager,
    SymbolConflictError,
    LockMode,
    SwarmRole,
    SwarmAgent,
    AgentSwarm,
)
from mamba.cli import main as bmb_main


class TestPhase8BMCPServerAndOrchestrator(unittest.TestCase):
    def setUp(self):
        self.tmpdir_obj = tempfile.TemporaryDirectory()
        self.tmpdir = self.tmpdir_obj.name
        self.server = BlackMambaMCPServer(workspace_dir=self.tmpdir)

    def tearDown(self):
        self.tmpdir_obj.cleanup()

    # --- MCP SERVER TESTS ---
    def test_mcp_server_initialize_and_ping(self):
        # 1. Initialize Handshake
        init_req = {
            "jsonrpc": "2.0",
            "id": 1,
            "method": "initialize",
            "params": {
                "protocolVersion": MCP_PROTOCOL_VERSION,
                "clientInfo": {"name": "test-client", "version": "1.0.0"},
            },
        }
        init_res = self.server.handle_request(init_req)
        self.assertEqual(init_res["jsonrpc"], "2.0")
        self.assertEqual(init_res["id"], 1)
        self.assertEqual(init_res["result"]["protocolVersion"], MCP_PROTOCOL_VERSION)
        self.assertEqual(init_res["result"]["serverInfo"]["version"], SERVER_VERSION)

        # 2. Ping
        ping_res = self.server.handle_request({"jsonrpc": "2.0", "id": 2, "method": "ping"})
        self.assertEqual(ping_res["result"], {})

    def test_mcp_server_tools_list(self):
        res = self.server.handle_request({"jsonrpc": "2.0", "id": 3, "method": "tools/list"})
        tools = res["result"]["tools"]
        tool_names = {t["name"] for t in tools}
        expected = {
            "bmb_ast_inspect",
            "bmb_ast_encode",
            "bmb_ast_decode",
            "bmb_ast_patch",
            "bmb_jit_run",
            "bmb_image_save",
            "bmb_image_load",
            "bmb_canvas_morphs",
            "bmb_db_query",
            "bmb_fuzz",
        }
        self.assertTrue(expected.issubset(tool_names), msg=f"Missing tools: {expected - tool_names}")

    def test_mcp_tool_ast_inspect_and_token_codec(self):
        source = """
struct Point:
    x: i64 = 0
    y: i64 = 0

fn get_distance_sq(p: Point) -> i64:
    return p.x * p.x + p.y * p.y
"""
        # Inspect
        insp_req = {
            "jsonrpc": "2.0",
            "id": 4,
            "method": "tools/call",
            "params": {
                "name": "bmb_ast_inspect",
                "arguments": {"source": source},
            },
        }
        insp_res = self.server.handle_request(insp_req)
        self.assertFalse(insp_res["result"]["isError"])
        text_data = json.loads(insp_res["result"]["content"][0]["text"])
        self.assertEqual(text_data["symbol_count"], 2)

        # Encode to token-sparse .bmbs
        enc_req = {
            "jsonrpc": "2.0",
            "id": 5,
            "method": "tools/call",
            "params": {
                "name": "bmb_ast_encode",
                "arguments": {"source": source},
            },
        }
        enc_res = self.server.handle_request(enc_req)
        enc_data = json.loads(enc_res["result"]["content"][0]["text"])
        self.assertTrue(enc_data["read_savings_pct"] >= 0)
        self.assertTrue(enc_data["full_bmb_tokens"] > 0)
        encoded_str = enc_data["encoded"]

        # Decode back
        dec_req = {
            "jsonrpc": "2.0",
            "id": 6,
            "method": "tools/call",
            "params": {
                "name": "bmb_ast_decode",
                "arguments": {"encoded": encoded_str},
            },
        }
        dec_res = self.server.handle_request(dec_req)
        dec_data = json.loads(dec_res["result"]["content"][0]["text"])
        self.assertIn("Point", dec_data["source"])

    def test_mcp_tool_jit_run(self):
        source = """
fn add(a: i64, b: i64) -> i64:
    return a + b

fn main() -> i64:
    res = add(15, 27)
    print("SUM=" + str(res))
    return 0
"""
        call_req = {
            "jsonrpc": "2.0",
            "id": 7,
            "method": "tools/call",
            "params": {
                "name": "bmb_jit_run",
                "arguments": {"source": source},
            },
        }
        res = self.server.handle_request(call_req)
        self.assertFalse(res["result"]["isError"])
        data = json.loads(res["result"]["content"][0]["text"])
        self.assertEqual(data["exit_code"], 0)
        self.assertEqual(data["exception_slot"], 0)
        self.assertIn("SUM=42", data["stdout"])

    def test_mcp_tool_image_save_and_load(self):
        source = """
struct Config:
    timeout: i64 = 5000
    retries: i64 = 3
"""
        image_path = os.path.join(self.tmpdir, "test_snapshot.bmbimg")
        save_req = {
            "jsonrpc": "2.0",
            "id": 8,
            "method": "tools/call",
            "params": {
                "name": "bmb_image_save",
                "arguments": {"source": source, "output_path": image_path},
            },
        }
        save_res = self.server.handle_request(save_req)
        self.assertFalse(save_res["result"]["isError"])
        save_data = json.loads(save_res["result"]["content"][0]["text"])
        self.assertTrue(save_data["bytes"] > 0)

        load_req = {
            "jsonrpc": "2.0",
            "id": 9,
            "method": "tools/call",
            "params": {
                "name": "bmb_image_load",
                "arguments": {"path": image_path},
            },
        }
        load_res = self.server.handle_request(load_req)
        self.assertFalse(load_res["result"]["isError"])
        load_data = json.loads(load_res["result"]["content"][0]["text"])
        self.assertEqual(load_data["version"], SERVER_VERSION)

    def test_mcp_resources_list_and_read(self):
        res_list = self.server.handle_request({"jsonrpc": "2.0", "id": 10, "method": "resources/list"})
        resources = res_list["result"]["resources"]
        self.assertTrue(any(r["uri"] == "bmb://workspace/status" for r in resources))

        read_res = self.server.handle_request({
            "jsonrpc": "2.0",
            "id": 11,
            "method": "resources/read",
            "params": {"uri": "bmb://workspace/status"},
        })
        contents = read_res["result"]["contents"]
        self.assertEqual(contents[0]["uri"], "bmb://workspace/status")
        parsed = json.loads(contents[0]["text"])
        self.assertEqual(parsed["version"], SERVER_VERSION)

    # --- AST SYMBOL LOCK MANAGER TESTS ---
    def test_ast_symbol_lock_exclusive_and_shared(self):
        mgr = ASTSymbolLockManager()
        uri = "bmb://math/Vec3/norm"

        # Agent 1 acquires exclusive write
        mgr.acquire(uri, "agent-1", LockMode.EXCLUSIVE_WRITE)
        self.assertTrue(mgr.is_locked(uri))
        self.assertEqual(mgr.get_holder(uri), "agent-1")

        # Agent 2 trying to acquire exclusive should timeout and raise SymbolConflictError
        with self.assertRaises(SymbolConflictError):
            mgr.acquire(uri, "agent-2", LockMode.EXCLUSIVE_WRITE, timeout=0.05)

        # Agent 1 releases
        mgr.release(uri, "agent-1")
        self.assertFalse(mgr.is_locked(uri))

        # Two agents can concurrently hold shared read locks
        mgr.acquire(uri, "agent-reader-1", LockMode.SHARED_READ)
        mgr.acquire(uri, "agent-reader-2", LockMode.SHARED_READ)
        self.assertTrue(mgr.is_locked(uri))

        # Writer cannot acquire while readers exist
        with self.assertRaises(SymbolConflictError):
            mgr.acquire(uri, "agent-writer", LockMode.EXCLUSIVE_WRITE, timeout=0.05)

        # Readers release
        mgr.release(uri, "agent-reader-1")
        mgr.release(uri, "agent-reader-2")
        self.assertFalse(mgr.is_locked(uri))

    # --- AGENT SWARM ORCHESTRATOR TESTS ---
    def test_agent_swarm_execution(self):
        swarm = AgentSwarm(workspace_dir=self.tmpdir)
        res = swarm.execute_goal(
            goal="Design and implement high-performance order item processing pipeline",
            verify=True,
        )
        self.assertTrue(res.tests_passed, msg=res.test_output)
        self.assertEqual(res.app_name, "order_service")
        self.assertTrue(res.lock_events_count >= 2)
        self.assertTrue(res.canvas_morphs > 0)
        self.assertTrue(os.path.exists(res.image_path))
        self.assertTrue(res.total_token_savings_pct > 0)

    # --- CLI SWARM COMMAND TEST ---
    def test_cli_bmb_swarm_json(self):
        buf = StringIO()
        with patch("sys.stdout", buf):
            rc = bmb_main([
                "swarm",
                "Build telemetry monitoring service",
                "--output", self.tmpdir,
                "--json",
            ])
        self.assertEqual(rc, 0)
        data = json.loads(buf.getvalue())
        self.assertEqual(data["app_name"], "telemetry_hub")
        self.assertTrue(data["tests_passed"])
        self.assertTrue(data["lock_events_count"] >= 2)


if __name__ == "__main__":
    unittest.main()
