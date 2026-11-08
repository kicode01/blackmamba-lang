"""
Black Mamba Language Server Protocol (LSP) — JSON-RPC 2.0 Framing & Constants.
Implements the LSP 3.17 protocol framing for stdio and socket transports.
"""

import json
from typing import BinaryIO, Optional


class DiagnosticSeverity:
    Error = 1
    Warning = 2
    Information = 3
    Hint = 4


class CompletionItemKind:
    Text = 1
    Method = 2
    Function = 3
    Constructor = 4
    Field = 5
    Variable = 6
    Class = 7
    Interface = 8
    Module = 9
    Property = 10
    Unit = 11
    Value = 12
    Enum = 13
    Keyword = 14
    Snippet = 15
    Color = 16
    File = 17
    Reference = 18
    Folder = 19
    EnumMember = 20
    Constant = 21
    Struct = 22
    Event = 23
    Operator = 24
    TypeParameter = 25


class SymbolKind:
    File = 1
    Module = 2
    Namespace = 3
    Package = 4
    Class = 5
    Method = 6
    Property = 7
    Field = 8
    Constructor = 9
    Enum = 10
    Interface = 11
    Function = 12
    Variable = 13
    Constant = 14
    String = 15
    Number = 16
    Boolean = 17
    Array = 18
    Object = 19
    Key = 20
    Null = 21
    EnumMember = 22
    Struct = 23
    Event = 24
    Operator = 25
    TypeParameter = 26


def read_message(stream: BinaryIO) -> Optional[dict]:
    """
    Reads an incoming JSON-RPC 2.0 message with `Content-Length: <n>\\r\\n\\r\\n` header.
    Returns parsed dictionary payload, or None on EOF or error.
    """
    content_length: Optional[int] = None
    while True:
        line_bytes = stream.readline()
        if not line_bytes:
            return None
        line = line_bytes.decode("ascii", errors="replace").strip()
        if not line:
            # Empty line marks end of headers
            break
        if line.lower().startswith("content-length:"):
            try:
                content_length = int(line.split(":", 1)[1].strip())
            except ValueError:
                return None

    if content_length is None or content_length < 0:
        return None

    body_bytes = stream.read(content_length)
    if len(body_bytes) < content_length:
        return None

    try:
        return json.loads(body_bytes.decode("utf-8"))
    except Exception:
        return None


def write_message(stream: BinaryIO, payload: dict) -> None:
    """
    Serializes a dictionary payload into JSON-RPC 2.0 framed bytes and flushes to stream.
    """
    body = json.dumps(payload, separators=(",", ":"), ensure_ascii=False).encode("utf-8")
    header = f"Content-Length: {len(body)}\r\n\r\n".encode("ascii")
    stream.write(header + body)
    stream.flush()


def make_response(request_id: Optional[int | str], result: object) -> dict:
    """Constructs a successful JSON-RPC 2.0 response."""
    return {
        "jsonrpc": "2.0",
        "id": request_id,
        "result": result,
    }


def make_error(request_id: Optional[int | str], code: int, message: str) -> dict:
    """Constructs a JSON-RPC 2.0 error response."""
    return {
        "jsonrpc": "2.0",
        "id": request_id,
        "error": {
            "code": code,
            "message": message,
        },
    }


def make_notification(method: str, params: dict) -> dict:
    """Constructs a JSON-RPC 2.0 notification (no ID)."""
    return {
        "jsonrpc": "2.0",
        "method": method,
        "params": params,
    }
