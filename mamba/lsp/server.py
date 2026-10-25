"""
Black Mamba Language Server Protocol (LSP) — Daemon Event Loop.
Coordinates JSON-RPC transport, document synchronization, diagnostics publication,
hover hints, autocompletion, definition lookup, and formatting.
"""

import sys
from typing import BinaryIO, Dict, Optional
from .analyzer import DocumentAnalyzer
from .formatter import format_source
from .protocol import (
    make_notification,
    make_response,
    read_message,
    write_message,
)


class LanguageServer:
    """
    Standard Language Server Protocol 3.17 daemon for Black Mamba (.bmb).
    """

    def __init__(self, in_stream: BinaryIO, out_stream: BinaryIO):
        self.in_stream = in_stream
        self.out_stream = out_stream
        self.docs: Dict[str, DocumentAnalyzer] = {}
        self.is_running = True
        self.is_shutdown = False

    def run(self) -> None:
        """Runs the main message dispatch loop until client exit."""
        while self.is_running:
            msg = read_message(self.in_stream)
            if msg is None:
                break
            self.handle_message(msg)

    def handle_message(self, msg: dict) -> None:
        """Dispatches an incoming JSON-RPC request or notification."""
        method = msg.get("method")
        msg_id = msg.get("id")

        # 1. Lifecycle: initialize
        if method == "initialize":
            from .. import __version__
            res = {
                "capabilities": {
                    "textDocumentSync": 1,  # 1 = Full sync
                    "hoverProvider": True,
                    "completionProvider": {
                        "resolveProvider": False,
                        "triggerCharacters": [".", ":", ">"],
                    },
                    "definitionProvider": True,
                    "documentSymbolProvider": True,
                    "documentFormattingProvider": True,
                },
                "serverInfo": {
                    "name": "bmb-lsp",
                    "version": __version__,
                },
            }
            write_message(self.out_stream, make_response(msg_id, res))
            return

        # 2. Lifecycle: initialized
        if method == "initialized":
            return

        # 3. Lifecycle: shutdown
        if method == "shutdown":
            self.is_shutdown = True
            write_message(self.out_stream, make_response(msg_id, None))
            return

        # 4. Lifecycle: exit
        if method == "exit":
            self.is_running = False
            return

        # 5. Document Sync: textDocument/didOpen
        if method == "textDocument/didOpen":
            td = msg.get("params", {}).get("textDocument", {})
            uri = td.get("uri", "")
            text = td.get("text", "")
            analyzer = DocumentAnalyzer(uri, text)
            self.docs[uri] = analyzer
            diags = analyzer.analyze()
            self._publish_diagnostics(uri, diags)
            return

        # 6. Document Sync: textDocument/didChange
        if method == "textDocument/didChange":
            params = msg.get("params", {})
            uri = params.get("textDocument", {}).get("uri", "")
            changes = params.get("contentChanges", [])
            if changes:
                new_text = changes[-1].get("text", "")
                analyzer = self.docs.get(uri)
                if not analyzer:
                    analyzer = DocumentAnalyzer(uri, new_text)
                    self.docs[uri] = analyzer
                else:
                    analyzer.update_source(new_text)
                diags = analyzer.analyze()
                self._publish_diagnostics(uri, diags)
            return

        # 7. Document Sync: textDocument/didClose
        if method == "textDocument/didClose":
            uri = msg.get("params", {}).get("textDocument", {}).get("uri", "")
            self.docs.pop(uri, None)
            self._publish_diagnostics(uri, [])
            return

        # 8. Document Sync: textDocument/didSave
        if method == "textDocument/didSave":
            uri = msg.get("params", {}).get("textDocument", {}).get("uri", "")
            analyzer = self.docs.get(uri)
            if analyzer:
                diags = analyzer.analyze()
                self._publish_diagnostics(uri, diags)
            return

        # 9. Language Feature: textDocument/hover
        if method == "textDocument/hover":
            params = msg.get("params", {})
            uri = params.get("textDocument", {}).get("uri", "")
            pos = params.get("position", {})
            analyzer = self.docs.get(uri)
            hover_res = analyzer.get_hover(pos.get("line", 0), pos.get("character", 0)) if analyzer else None
            write_message(self.out_stream, make_response(msg_id, hover_res))
            return

        # 10. Language Feature: textDocument/completion
        if method == "textDocument/completion":
            params = msg.get("params", {})
            uri = params.get("textDocument", {}).get("uri", "")
            pos = params.get("position", {})
            analyzer = self.docs.get(uri)
            comp_res = analyzer.get_completions(pos.get("line", 0), pos.get("character", 0)) if analyzer else {"isIncomplete": False, "items": []}
            write_message(self.out_stream, make_response(msg_id, comp_res))
            return

        # 11. Language Feature: textDocument/definition
        if method == "textDocument/definition":
            params = msg.get("params", {})
            uri = params.get("textDocument", {}).get("uri", "")
            pos = params.get("position", {})
            analyzer = self.docs.get(uri)
            defn_res = analyzer.get_definition(pos.get("line", 0), pos.get("character", 0)) if analyzer else None
            write_message(self.out_stream, make_response(msg_id, defn_res))
            return

        # 12. Language Feature: textDocument/documentSymbol
        if method == "textDocument/documentSymbol":
            params = msg.get("params", {})
            uri = params.get("textDocument", {}).get("uri", "")
            analyzer = self.docs.get(uri)
            syms_res = analyzer.get_document_symbols() if analyzer else []
            write_message(self.out_stream, make_response(msg_id, syms_res))
            return

        # 13. Language Feature: textDocument/formatting
        if method == "textDocument/formatting":
            params = msg.get("params", {})
            uri = params.get("textDocument", {}).get("uri", "")
            analyzer = self.docs.get(uri)
            if analyzer:
                formatted = format_source(analyzer.source)
                edits = [{
                    "range": {
                        "start": {"line": 0, "character": 0},
                        "end": {"line": len(analyzer.lines), "character": 0},
                    },
                    "newText": formatted,
                }]
            else:
                edits = []
            write_message(self.out_stream, make_response(msg_id, edits))
            return

        # Unhandled request -> respond with empty or None if request
        if msg_id is not None:
            write_message(self.out_stream, make_response(msg_id, None))

    def _publish_diagnostics(self, uri: str, diagnostics: list) -> None:
        """Publishes diagnostic error squiggles to the client."""
        notif = make_notification("textDocument/publishDiagnostics", {
            "uri": uri,
            "diagnostics": diagnostics,
        })
        write_message(self.out_stream, notif)


def run_stdio_server() -> int:
    """Launches the Language Server daemon over stdin/stdout."""
    server = LanguageServer(sys.stdin.buffer, sys.stdout.buffer)
    server.run()
    return 0


def run_tcp_server(host: str = "127.0.0.1", port: int = 8088) -> int:
    """Launches the Language Server daemon over a TCP socket."""
    import socket
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    s.bind((host, port))
    s.listen(1)
    sys.stderr.write(f"[bmb-lsp] Listening on {host}:{port}...\n")
    sys.stderr.flush()
    conn, _ = s.accept()
    stream = conn.makefile("rwb")
    server = LanguageServer(stream, stream)
    server.run()
    s.close()
    return 0
