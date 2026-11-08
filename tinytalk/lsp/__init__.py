"""
Black Mamba Language Server Protocol (LSP) package.
Provides language intelligence, real-time diagnostics, hover tooltips,
autocompletion, go-to-definition, and symbol outline for Black Mamba (.bmb).
"""

from .analyzer import DocumentAnalyzer
from .formatter import format_source
from .protocol import (
    DiagnosticSeverity,
    CompletionItemKind,
    SymbolKind,
    read_message,
    write_message,
    make_response,
    make_error,
    make_notification,
)
from .server import LanguageServer, run_stdio_server, run_tcp_server

__all__ = [
    "LanguageServer",
    "DocumentAnalyzer",
    "format_source",
    "DiagnosticSeverity",
    "CompletionItemKind",
    "SymbolKind",
    "read_message",
    "write_message",
    "make_response",
    "make_error",
    "make_notification",
    "run_stdio_server",
    "run_tcp_server",
]
