"""
Black Mamba Language Server Protocol (LSP) — Semantic Document Analyzer.
Provides real-time AST parsing, Cartesian type inference diagnostics,
intelligent hover tooltips, struct field autocompletion, and Go to Definition.
"""

import os
import re
from typing import Dict, List, Optional, Set, Tuple
from ..ast_nodes import (
    Assign,
    Expr,
    ExprStmt,
    FieldAccess,
    FuncDef,
    Module,
    Param,
    Return,
    Stmt,
    StructDef,
    StructField,
    Var,
)
from ..lexer import Lexer, LexerError, Token
from ..parser import Parser, ParseError
from ..types import FunctionSignature, TypeInferencer
from .protocol import CompletionItemKind, DiagnosticSeverity, SymbolKind

KEYWORDS = [
    ("def", "Define a new function", "def name(params) -> return_type:\n    ..."),
    ("struct", "Define a new structure type", "struct Name:\n    field: type"),
    ("return", "Return a value from a function", "return value"),
    ("if", "Conditional branch statement", "if condition:\n    ..."),
    ("elif", "Else-if conditional branch", "elif condition:\n    ..."),
    ("else", "Fallback conditional branch", "else:\n    ..."),
    ("while", "Loop while condition is true", "while condition:\n    ..."),
    ("for", "Iterate over a range or array", "for i in 0..10:\n    ..."),
    ("in", "Range iteration operator", "for x in collection:"),
    ("import", "Import a module", "import module_name"),
    ("from", "Import specific symbols from module", "from module import symbol"),
    ("as", "Alias an imported symbol", "import module as alias"),
    ("break", "Break out of innermost loop", "break"),
    ("continue", "Continue to next loop iteration", "continue"),
    ("pass", "No-op placeholder statement", "pass"),
    ("match", "Pattern match statement", "match value:\n    case pattern:\n        ..."),
    ("case", "Pattern match case arm", "case pattern:"),
    ("inline", "Request inlining optimization", "@inline\ndef func(): ..."),
]

BUILTINS = [
    ("print", "print(*args)", "Print values to stdout with automatic formatting"),
    ("len", "len(collection) -> i64", "Returns the length of a string or array"),
    ("int", "int(x) -> i64", "Converts float or string to 64-bit integer"),
    ("i64", "i64(x) -> i64", "Alias for int(x)"),
    ("float", "float(x) -> f64", "Converts integer or string to 64-bit float"),
    ("f64", "f64(x) -> f64", "Alias for float(x)"),
    ("str", "str(x) -> str", "Converts value to string representation"),
    ("bool", "bool(x) -> bool", "Converts value to boolean"),
    ("abs", "abs(x) -> x", "Returns the absolute value of an integer or float"),
    ("min", "min(a, b) -> x", "Returns the minimum of two values"),
    ("max", "max(a, b) -> x", "Returns the maximum of two values"),
    ("ord", "ord(c) -> i64", "Returns the integer ASCII value of a character"),
    ("chr", "chr(i) -> str", "Returns the single-character string for an ASCII value"),
    ("clock_ns", "clock_ns() -> i64", "Monotonic nanosecond hardware timestamp"),
    ("clock_sec", "clock_sec() -> f64", "Monotonic hardware seconds as float"),
    ("sleep_ms", "sleep_ms(ms: i64)", "High precision millisecond sleep"),
    ("sleep_ns", "sleep_ns(ns: i64)", "High precision nanosecond spin-wait"),
]

STDLIB_MODULES = [
    ("math", "Chebyshev/Taylor minimax trigonometry, exp, log, and constants (PI, E)"),
    ("time", "Nanosecond monotonic clocks and sleep primitives"),
    ("random", "Hardware-seeded Xoshiro256++ PRNG ($2^{256} - 1$ period)"),
    ("json", "Pure native JSON parser and serializer with DOM query API"),
    ("hash", "Cryptographic SHA-256, HMAC-SHA256, MurmurHash3, FNV-1a"),
    ("os", "File I/O, directory, environment, and path primitives"),
    ("socket", "High-performance TCP/UDP networking sockets (IPv4)"),
    ("array", "Growable vector collections (IntVector) and slice views"),
    ("thread", "Hardware multithreading, atomics, Mutex, par_for, par_map"),
    ("chan", "Lock-free bounded MPMC ring buffer channels for hardware threads"),
    ("regex", "Pure native linear-time regular expressions (Thompson NFA / Pike VM)"),
    ("gc", "Generational region tracking and tracing cycle collection for cyclic heap graphs"),
    ("test", "Assertion framework and hardware benchmarking harness"),
]


class DocumentAnalyzer:
    """
    Performs real-time lexical, syntactic, and semantic analysis of a single .bmb document.
    Maintains document versions and AST caches for uninterrupted code completion.
    """

    def __init__(self, uri: str, source: str):
        self.uri = uri
        self.source = source
        self.lines: List[str] = source.splitlines(keepends=True)
        self.tokens: List[Token] = []
        self.ast: Optional[Module] = None
        self.signatures: Dict[str, FunctionSignature] = {}
        self.structs: Dict[str, StructDef] = {}
        self.funcs: Dict[str, FuncDef] = {}
        self.global_vars: Dict[str, str] = {}
        self.diagnostics: List[dict] = []

        # Previous valid analysis cache for resilient completion while editing
        self.last_valid_ast: Optional[Module] = None
        self.last_valid_signatures: Dict[str, FunctionSignature] = {}
        self.last_valid_structs: Dict[str, StructDef] = {}

    def update_source(self, new_source: str) -> None:
        self.source = new_source
        self.lines = new_source.splitlines(keepends=True)

    def analyze(self) -> List[dict]:
        """
        Runs complete analysis pipeline. Returns list of LSP Diagnostic dicts.
        """
        self.diagnostics = []

        # 1. Lexical Analysis
        try:
            lexer = Lexer(self.source, filename=self.uri)
            self.tokens = lexer.tokenize()
        except LexerError as le:
            l = max(0, le.line - 1)
            c = max(0, le.col - 1)
            self.diagnostics.append({
                "range": {
                    "start": {"line": l, "character": c},
                    "end": {"line": l, "character": c + 1},
                },
                "severity": DiagnosticSeverity.Error,
                "source": "bmb",
                "message": str(le),
            })
            return self.diagnostics
        except Exception as e:
            self.diagnostics.append({
                "range": {
                    "start": {"line": 0, "character": 0},
                    "end": {"line": 0, "character": 1},
                },
                "severity": DiagnosticSeverity.Error,
                "source": "bmb",
                "message": f"Lexer error: {e}",
            })
            return self.diagnostics

        # 2. Syntactic Analysis
        try:
            parser = Parser(self.tokens)
            ast = parser.parse_module()
            self.ast = ast
        except ParseError as pe:
            tok = getattr(pe, "token", None)
            l = max(0, (tok.line - 1) if tok and hasattr(tok, "line") else 0)
            c = max(0, (tok.col - 1) if tok and hasattr(tok, "col") else 0)
            tok_len = len(str(tok.value or "")) if tok and hasattr(tok, "value") and tok.value else 1
            self.diagnostics.append({
                "range": {
                    "start": {"line": l, "character": c},
                    "end": {"line": l, "character": c + max(1, tok_len)},
                },
                "severity": DiagnosticSeverity.Error,
                "source": "bmb",
                "message": str(pe),
            })
            return self.diagnostics
        except Exception as e:
            self.diagnostics.append({
                "range": {
                    "start": {"line": 0, "character": 0},
                    "end": {"line": 0, "character": 1},
                },
                "severity": DiagnosticSeverity.Error,
                "source": "bmb",
                "message": f"Parse error: {e}",
            })
            return self.diagnostics

        # 3. Cartesian Type Inference & Semantic Analysis
        try:
            ti = TypeInferencer(self.ast)
            ti.run()
            self.signatures = ti.signatures
            self.structs = ti.structs
            self.funcs = ti.funcs
            self.global_vars = ti.global_vars

            # Update valid caches
            self.last_valid_ast = self.ast
            self.last_valid_signatures = dict(self.signatures)
            self.last_valid_structs = dict(self.structs)
        except Exception as e:
            # Type error diagnostic
            self.diagnostics.append({
                "range": {
                    "start": {"line": 0, "character": 0},
                    "end": {"line": 0, "character": 1},
                },
                "severity": DiagnosticSeverity.Warning,
                "source": "bmb",
                "message": f"Type inference warning: {e}",
            })

        return self.diagnostics

    # --- Feature: Hover Tooltips ---

    def get_hover(self, line: int, character: int) -> Optional[dict]:
        """
        Returns hover documentation and type signatures for the token at (line, character).
        """
        word, start_col, end_col = self._get_word_at_position(line, character)
        if not word:
            return None

        line_str = self._get_line_text(line)

        # 1. Field Access hover: check if preceded by `.` e.g. `obj.field`
        dot_idx = start_col - 1
        while dot_idx >= 0 and line_str[dot_idx].isspace():
            dot_idx -= 1
        if dot_idx >= 0 and line_str[dot_idx] == ".":
            # Extract receiver expression before dot
            recv_word, _, _ = self._get_word_at_position(line, dot_idx - 1)
            if recv_word:
                recv_type = self._resolve_var_type(recv_word, line)
                struct_def = self._get_struct(recv_type)
                if struct_def:
                    for f in struct_def.fields:
                        if f.name == word:
                            doc = f"```bmb\n(field) {struct_def.name}.{f.name}: {f.type_ann}\n```\nField '{f.name}' of struct `{struct_def.name}`."
                            return {
                                "contents": {"kind": "markdown", "value": doc},
                                "range": {"start": {"line": line, "character": start_col}, "end": {"line": line, "character": end_col}},
                            }

        # 2. Struct hover
        struct_def = self._get_struct(word)
        if struct_def:
            fields_doc = "\n".join(f"    {f.name}: {f.type_ann}" for f in struct_def.fields)
            doc = f"```bmb\nstruct {struct_def.name}:\n{fields_doc}\n```\nValue struct type with contiguous 64-bit slot layout."
            return {
                "contents": {"kind": "markdown", "value": doc},
                "range": {"start": {"line": line, "character": start_col}, "end": {"line": line, "character": end_col}},
            }

        # 3. Function hover
        fn_sig = self._get_signature(word)
        fn_def = self._get_func_def(word)
        if fn_sig:
            param_names = [p.name for p in fn_def.params] if fn_def else [f"arg{i}" for i in range(len(fn_sig.param_types))]
            params_str = ", ".join(f"{p}: {t}" for p, t in zip(param_names, fn_sig.param_types))
            doc = f"```bmb\ndef {word}({params_str}) -> {fn_sig.return_type}\n```"
            return {
                "contents": {"kind": "markdown", "value": doc},
                "range": {"start": {"line": line, "character": start_col}, "end": {"line": line, "character": end_col}},
            }

        # 4. Local Variable / Parameter hover
        var_type = self._resolve_var_type(word, line)
        if var_type:
            kind_label = "parameter" if self._is_param(word, line) else "variable"
            doc = f"```bmb\n({kind_label}) {word}: {var_type}\n```"
            return {
                "contents": {"kind": "markdown", "value": doc},
                "range": {"start": {"line": line, "character": start_col}, "end": {"line": line, "character": end_col}},
            }

        # 5. Built-in Function hover
        for b_name, b_sig, b_doc in BUILTINS:
            if b_name == word:
                doc = f"```bmb\n{b_sig}\n```\n{b_doc}"
                return {
                    "contents": {"kind": "markdown", "value": doc},
                    "range": {"start": {"line": line, "character": start_col}, "end": {"line": line, "character": end_col}},
                }

        # 6. Standard Library Module hover
        for m_name, m_doc in STDLIB_MODULES:
            if m_name == word:
                doc = f"```bmb\nimport {m_name}\n```\n**Black Mamba Standard Library** (`{m_name}.bmb`)\n\n{m_doc}"
                return {
                    "contents": {"kind": "markdown", "value": doc},
                    "range": {"start": {"line": line, "character": start_col}, "end": {"line": line, "character": end_col}},
                }

        # 7. Keyword hover
        for kw, kw_doc, kw_syntax in KEYWORDS:
            if kw == word:
                doc = f"```bmb\n{kw_syntax}\n```\n{kw_doc}"
                return {
                    "contents": {"kind": "markdown", "value": doc},
                    "range": {"start": {"line": line, "character": start_col}, "end": {"line": line, "character": end_col}},
                }

        return None

    # --- Feature: Autocompletion ---

    def get_completions(self, line: int, character: int) -> dict:
        """
        Returns contextual completion items for position (line, character).
        Supports struct member access after `.` and scope-aware completions.
        """
        line_str = self._get_line_text(line)
        prefix = line_str[:character]

        # 1. Dot Member Access Completion (e.g. `obj.`)
        dot_match = re.search(r"([a-zA-Z_][a-zA-Z0-9_]*)\.\s*$", prefix)
        if dot_match:
            recv_name = dot_match.group(1)
            recv_type = self._resolve_var_type(recv_name, line)
            struct_def = self._get_struct(recv_type)
            items = []
            if struct_def:
                # Add struct fields
                for f in struct_def.fields:
                    items.append({
                        "label": f.name,
                        "kind": CompletionItemKind.Field,
                        "detail": f.type_ann or "i64",
                        "documentation": f"Field '{f.name}' of struct `{struct_def.name}`",
                        "insertText": f.name,
                    })
                # Add struct methods
                for m in struct_def.methods:
                    items.append({
                        "label": m.name,
                        "kind": CompletionItemKind.Method,
                        "detail": f"({', '.join(p.name for p in m.params[1:])}) -> {m.return_type}",
                        "documentation": f"Method '{m.name}' of struct `{struct_def.name}`",
                        "insertText": f"{m.name}($0)",
                        "insertTextFormat": 2,  # Snippet
                    })
            return {"isIncomplete": False, "items": items}

        # 2. General Scope Completion
        items = []

        # Local variables & parameters in current function
        cur_fn = self._get_enclosing_func(line)
        if cur_fn:
            sig = self._get_signature(cur_fn.name)
            if sig:
                for vname, vtype in sig.var_types.items():
                    if not vname.startswith("%"):
                        items.append({
                            "label": vname,
                            "kind": CompletionItemKind.Variable,
                            "detail": vtype,
                            "documentation": f"Local variable '{vname}' ({vtype})",
                        })
            for p in cur_fn.params:
                items.append({
                    "label": p.name,
                    "kind": CompletionItemKind.Variable,
                    "detail": p.type_ann or "i64",
                    "documentation": f"Parameter '{p.name}' ({p.type_ann or 'i64'})",
                })

        # Functions defined in document
        funcs_dict = self.funcs or getattr(self.last_valid_ast, "functions", {})
        for fname, fdef in (self.funcs.items() if self.funcs else []):
            sig = self._get_signature(fname)
            ret_t = sig.return_type if sig else (fdef.return_type or "i64")
            p_str = ", ".join(p.name for p in fdef.params)
            items.append({
                "label": fname,
                "kind": CompletionItemKind.Function,
                "detail": f"({p_str}) -> {ret_t}",
                "documentation": f"Function `{fname}` defined at line {fdef.line}",
                "insertText": f"{fname}($0)",
                "insertTextFormat": 2,
            })

        # Structs defined in document
        structs_dict = self.structs or self.last_valid_structs
        for sname, sdef in structs_dict.items():
            f_names = ", ".join(f.name for f in sdef.fields)
            items.append({
                "label": sname,
                "kind": CompletionItemKind.Struct,
                "detail": f"struct {sname}({f_names})",
                "documentation": f"Struct `{sname}` defined at line {sdef.line}",
                "insertText": sname,
            })

        # Standard library modules
        for mname, mdoc in STDLIB_MODULES:
            items.append({
                "label": mname,
                "kind": CompletionItemKind.Module,
                "detail": f"Standard Library ({mname}.bmb)",
                "documentation": mdoc,
            })

        # Built-in functions
        for bname, bsig, bdoc in BUILTINS:
            items.append({
                "label": bname,
                "kind": CompletionItemKind.Function,
                "detail": bsig,
                "documentation": bdoc,
                "insertText": f"{bname}($0)",
                "insertTextFormat": 2,
            })

        # Keywords
        for kw, kwdoc, _ in KEYWORDS:
            items.append({
                "label": kw,
                "kind": CompletionItemKind.Keyword,
                "detail": "Keyword",
                "documentation": kwdoc,
            })

        return {"isIncomplete": False, "items": items}

    # --- Feature: Go to Definition ---

    def get_definition(self, line: int, character: int) -> Optional[dict]:
        """
        Locates definition location for word at (line, character).
        """
        word, _, _ = self._get_word_at_position(line, character)
        if not word:
            return None

        # 1. Struct Definition
        struct_def = self._get_struct(word)
        if struct_def:
            l = max(0, struct_def.line - 1)
            c = max(0, struct_def.col - 1)
            return {
                "uri": self.uri,
                "range": {
                    "start": {"line": l, "character": c},
                    "end": {"line": l, "character": c + len(struct_def.name)},
                },
            }

        # 2. Function Definition
        fn_def = self._get_func_def(word)
        if fn_def:
            l = max(0, fn_def.line - 1)
            c = max(0, fn_def.col - 1)
            return {
                "uri": self.uri,
                "range": {
                    "start": {"line": l, "character": c},
                    "end": {"line": l, "character": c + len(fn_def.name)},
                },
            }

        # 3. Local Parameter or Assignment Definition
        cur_fn = self._get_enclosing_func(line)
        if cur_fn:
            for p in cur_fn.params:
                if p.name == word:
                    l = max(0, cur_fn.line - 1)
                    return {
                        "uri": self.uri,
                        "range": {
                            "start": {"line": l, "character": 0},
                            "end": {"line": l, "character": len(p.name)},
                        },
                    }
            for stmt in cur_fn.body:
                if isinstance(stmt, Assign) and stmt.target == word:
                    l = max(0, stmt.line - 1)
                    c = max(0, stmt.col - 1)
                    return {
                        "uri": self.uri,
                        "range": {
                            "start": {"line": l, "character": c},
                            "end": {"line": l, "character": c + len(stmt.target)},
                        },
                    }

        return None

    # --- Feature: Document Symbols (Outline) ---

    def get_document_symbols(self) -> List[dict]:
        """
        Extracts hierarchical document symbols for the VS Code Outline / Breadcrumbs view.
        """
        symbols = []
        ast = self.ast or self.last_valid_ast
        if not ast:
            return symbols

        for stmt in ast.statements:
            if isinstance(stmt, StructDef):
                l_start = max(0, stmt.line - 1)
                l_end = l_start + max(1, len(stmt.fields))
                children = []
                for f in stmt.fields:
                    children.append({
                        "name": f.name,
                        "kind": SymbolKind.Field,
                        "detail": f.type_ann or "i64",
                        "range": {"start": {"line": l_start, "character": 0}, "end": {"line": l_start, "character": len(f.name)}},
                        "selectionRange": {"start": {"line": l_start, "character": 0}, "end": {"line": l_start, "character": len(f.name)}},
                    })
                symbols.append({
                    "name": stmt.name,
                    "kind": SymbolKind.Struct,
                    "range": {"start": {"line": l_start, "character": 0}, "end": {"line": l_end, "character": 0}},
                    "selectionRange": {"start": {"line": l_start, "character": 0}, "end": {"line": l_start, "character": len(stmt.name)}},
                    "children": children,
                })
            elif isinstance(stmt, FuncDef):
                l_start = max(0, stmt.line - 1)
                l_end = l_start + max(1, len(stmt.body))
                sig = self._get_signature(stmt.name)
                ret_t = sig.return_type if sig else (stmt.return_type or "i64")
                p_str = ", ".join(f"{p.name}: {p.type_ann or 'i64'}" for p in stmt.params)
                symbols.append({
                    "name": stmt.name,
                    "kind": SymbolKind.Function,
                    "detail": f"({p_str}) -> {ret_t}",
                    "range": {"start": {"line": l_start, "character": 0}, "end": {"line": l_end, "character": 0}},
                    "selectionRange": {"start": {"line": l_start, "character": 0}, "end": {"line": l_start, "character": len(stmt.name)}},
                })
            elif isinstance(stmt, Assign):
                l = max(0, stmt.line - 1)
                symbols.append({
                    "name": stmt.target,
                    "kind": SymbolKind.Variable,
                    "detail": stmt.type_ann or "i64",
                    "range": {"start": {"line": l, "character": 0}, "end": {"line": l, "character": len(stmt.target)}},
                    "selectionRange": {"start": {"line": l, "character": 0}, "end": {"line": l, "character": len(stmt.target)}},
                })

        return symbols

    # --- Internal Helper Routines ---

    def _get_line_text(self, line: int) -> str:
        if 0 <= line < len(self.lines):
            return self.lines[line]
        return ""

    def _get_word_at_position(self, line: int, character: int) -> Tuple[str, int, int]:
        line_text = self._get_line_text(line)
        if not line_text or character < 0:
            return "", 0, 0
        if character >= len(line_text):
            character = max(0, len(line_text) - 1)

        start = character
        while start > 0 and (line_text[start - 1].isalnum() or line_text[start - 1] == "_"):
            start -= 1

        end = character
        while end < len(line_text) and (line_text[end].isalnum() or line_text[end] == "_"):
            end += 1

        word = line_text[start:end].strip()
        return word, start, end

    def _get_struct(self, name: Optional[str]) -> Optional[StructDef]:
        if not name:
            return None
        return self.structs.get(name) or self.last_valid_structs.get(name)

    def _get_signature(self, name: str) -> Optional[FunctionSignature]:
        return self.signatures.get(name) or self.last_valid_signatures.get(name)

    def _get_func_def(self, name: str) -> Optional[FuncDef]:
        if name in self.funcs:
            return self.funcs[name]
        ast = self.ast or self.last_valid_ast
        if ast:
            for s in ast.statements:
                if isinstance(s, FuncDef) and s.name == name:
                    return s
        return None

    def _get_enclosing_func(self, line_0: int) -> Optional[FuncDef]:
        target_line = line_0 + 1
        ast = self.ast or self.last_valid_ast
        if not ast:
            return None
        candidate: Optional[FuncDef] = None
        for s in ast.statements:
            if isinstance(s, FuncDef):
                if s.line <= target_line:
                    candidate = s
        return candidate

    def _resolve_var_type(self, var_name: str, line_0: int) -> Optional[str]:
        cur_fn = self._get_enclosing_func(line_0)
        if cur_fn:
            sig = self._get_signature(cur_fn.name)
            if sig and var_name in sig.var_types:
                return sig.var_types[var_name]
            for p in cur_fn.params:
                if p.name == var_name:
                    return p.type_ann or "i64"
        if var_name in self.global_vars:
            return self.global_vars[var_name]
        return None

    def _is_param(self, var_name: str, line_0: int) -> bool:
        cur_fn = self._get_enclosing_func(line_0)
        if cur_fn:
            return any(p.name == var_name for p in cur_fn.params)
        return False
