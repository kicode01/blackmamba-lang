"""
Black Mamba (.bmb) Indentation-Aware Lexer.

Supports full standard Python syntax plus Black Mamba (.bmb) ergonomic extensions:
- Unified `def` and `fn` function declarations
- `struct` value-type definitions
- `par for` lock-free parallel loops
- `let` / `const` / `mut` optional bindings
- Pipeline operator `|>`
- Range operators `..` and `..=`
- Decorator annotations (`@simd`, `@parallel`, `@inline`, `@fastmath`, `@nogil`)
"""

from dataclasses import dataclass
from enum import Enum, auto
from typing import List, Optional


class TokenType(Enum):
    # Literals & Identifiers
    IDENT = auto()
    INT = auto()
    FLOAT = auto()
    STRING = auto()
    BOOL = auto()

    # Keywords
    DEF = auto()
    FN = auto()
    STRUCT = auto()
    CLASS = auto()
    RETURN = auto()
    IF = auto()
    ELIF = auto()
    ELSE = auto()
    WHILE = auto()
    FOR = auto()
    PAR = auto()
    IN = auto()
    BREAK = auto()
    CONTINUE = auto()
    PASS = auto()
    MATCH = auto()
    CASE = auto()
    LET = auto()
    CONST = auto()
    MUT = auto()
    AND = auto()
    OR = auto()
    NOT = auto()
    TRUE = auto()
    FALSE = auto()
    NONE = auto()
    IMPORT = auto()
    FROM = auto()
    AS = auto()
    TRY = auto()
    EXCEPT = auto()
    FINALLY = auto()
    RAISE = auto()

    # Operators
    PLUS = auto()          # +
    MINUS = auto()         # -
    STAR = auto()          # *
    SLASH = auto()         # /
    DSLASH = auto()        # //
    PERCENT = auto()       # %
    POW = auto()           # **
    PIPE_GT = auto()       # |>
    ARROW = auto()         # ->
    RANGE = auto()         # ..
    RANGE_INC = auto()     # ..=
    AMP = auto()           # &
    PIPE = auto()          # |
    CARET = auto()         # ^
    TILDE = auto()         # ~
    LSHIFT = auto()        # <<
    RSHIFT = auto()        # >>

    # Comparisons
    EQ = auto()            # ==
    NE = auto()            # !=
    LT = auto()            # <
    LE = auto()            # <=
    GT = auto()            # >
    GE = auto()            # >=

    # Assignments
    ASSIGN = auto()        # =
    WALRUS = auto()        # :=
    PLUS_EQ = auto()       # +=
    MINUS_EQ = auto()      # -=
    STAR_EQ = auto()       # *=
    SLASH_EQ = auto()      # /=
    DSLASH_EQ = auto()     # //=
    PERCENT_EQ = auto()    # %=
    AMP_EQ = auto()        # &=
    PIPE_EQ = auto()       # |=
    CARET_EQ = auto()      # ^=
    LSHIFT_EQ = auto()     # <<=
    RSHIFT_EQ = auto()     # >>=

    # Delimiters
    LPAREN = auto()        # (
    RPAREN = auto()        # )
    LBRACKET = auto()      # [
    RBRACKET = auto()      # ]
    LBRACE = auto()        # {
    RBRACE = auto()        # }
    COLON = auto()         # :
    COMMA = auto()         # ,
    DOT = auto()           # .
    SEMI = auto()          # ;
    AT = auto()            # @

    # Structure
    NEWLINE = auto()
    INDENT = auto()
    DEDENT = auto()
    EOF = auto()


KEYWORDS = {
    "def": TokenType.DEF,
    "fn": TokenType.FN,
    "struct": TokenType.STRUCT,
    "class": TokenType.CLASS,
    "return": TokenType.RETURN,
    "if": TokenType.IF,
    "elif": TokenType.ELIF,
    "else": TokenType.ELSE,
    "while": TokenType.WHILE,
    "for": TokenType.FOR,
    "par": TokenType.PAR,
    "in": TokenType.IN,
    "break": TokenType.BREAK,
    "continue": TokenType.CONTINUE,
    "pass": TokenType.PASS,
    "match": TokenType.MATCH,
    "case": TokenType.CASE,
    "let": TokenType.LET,
    "const": TokenType.CONST,
    "mut": TokenType.MUT,
    "and": TokenType.AND,
    "or": TokenType.OR,
    "not": TokenType.NOT,
    "True": TokenType.TRUE,
    "False": TokenType.FALSE,
    "None": TokenType.NONE,
    "import": TokenType.IMPORT,
    "from": TokenType.FROM,
    "as": TokenType.AS,
    "try": TokenType.TRY,
    "except": TokenType.EXCEPT,
    "finally": TokenType.FINALLY,
    "raise": TokenType.RAISE,
}


@dataclass
class Token:
    type: TokenType
    value: object
    line: int
    col: int

    def __repr__(self) -> str:
        return f"Token({self.type.name}, {self.value!r}, L{self.line}:{self.col})"


class LexerError(Exception):
    def __init__(self, message: str, line: int, col: int):
        super().__init__(f"[LexerError L{line}:{col}] {message}")
        self.line = line
        self.col = col


class Lexer:
    def __init__(self, source: str, filename: str = "<input.bmb>"):
        self.source = source.replace("\r\n", "\n").replace("\r", "\n")
        self.filename = filename
        self.pos = 0
        self.line = 1
        self.col = 1
        self.tokens: List[Token] = []
        self.indent_stack: List[int] = [0]
        self.paren_depth = 0

    def tokenize(self) -> List[Token]:
        self._lines = self.source.split("\n")
        self._line_idx = 0
        num_lines = len(self._lines)

        while self._line_idx < num_lines:
            raw_line = self._lines[self._line_idx]
            line_num = self._line_idx + 1
            self._line_idx += 1

            # Handle indentation only when not inside parentheses/brackets/braces
            if self.paren_depth == 0:
                stripped = raw_line.lstrip(" \t")
                if not stripped or stripped.startswith("#"):
                    continue
                indent = 0
                for ch in raw_line:
                    if ch == " ":
                        indent += 1
                    elif ch == "\t":
                        indent += 4
                    else:
                        break

                if indent > self.indent_stack[-1]:
                    self.indent_stack.append(indent)
                    self.tokens.append(Token(TokenType.INDENT, indent, line_num, 1))
                else:
                    while indent < self.indent_stack[-1]:
                        self.indent_stack.pop()
                        self.tokens.append(Token(TokenType.DEDENT, indent, line_num, 1))
                    if indent != self.indent_stack[-1]:
                        raise LexerError(
                            f"Inconsistent indentation ({indent} spaces, expected {self.indent_stack[-1]})",
                            line_num,
                            1,
                        )

            self._tokenize_line(raw_line, line_num)

            if self.paren_depth == 0 and (
                not self.tokens or self.tokens[-1].type not in (TokenType.NEWLINE, TokenType.INDENT, TokenType.DEDENT)
            ):
                self.tokens.append(Token(TokenType.NEWLINE, "\n", line_num, len(raw_line) + 1))

        while len(self.indent_stack) > 1:
            self.indent_stack.pop()
            self.tokens.append(Token(TokenType.DEDENT, 0, len(self._lines) + 1, 1))

        self.tokens.append(Token(TokenType.EOF, None, len(self._lines) + 1, 1))
        return self.tokens

    def _tokenize_line(self, line: str, line_num: int) -> None:
        i = 0
        n = len(line)
        # Skip leading whitespace
        while i < n and line[i] in (" ", "\t"):
            i += 1

        while i < n:
            ch = line[i]
            col = i + 1

            if ch in (" ", "\t"):
                i += 1
                continue

            if ch == "#":
                break  # Comment to end of line

            # Multi-character operators (3 chars)
            three = line[i : i + 3]
            if three == "//=":
                self.tokens.append(Token(TokenType.DSLASH_EQ, "//=", line_num, col))
                i += 3
                continue
            if three == "<<=":
                self.tokens.append(Token(TokenType.LSHIFT_EQ, "<<=", line_num, col))
                i += 3
                continue
            if three == ">>=":
                self.tokens.append(Token(TokenType.RSHIFT_EQ, ">>=", line_num, col))
                i += 3
                continue
            if three == "..=":
                self.tokens.append(Token(TokenType.RANGE_INC, "..=", line_num, col))
                i += 3
                continue

            # Multi-character operators (2 chars)
            two = line[i : i + 2]
            two_map = {
                "**": TokenType.POW,
                "//": TokenType.DSLASH,
                "|>": TokenType.PIPE_GT,
                "->": TokenType.ARROW,
                "..": TokenType.RANGE,
                "==": TokenType.EQ,
                "!=": TokenType.NE,
                "<=": TokenType.LE,
                ">=": TokenType.GE,
                "<<": TokenType.LSHIFT,
                ">>": TokenType.RSHIFT,
                ":=": TokenType.WALRUS,
                "+=": TokenType.PLUS_EQ,
                "-=": TokenType.MINUS_EQ,
                "*=": TokenType.STAR_EQ,
                "/=": TokenType.SLASH_EQ,
                "%=": TokenType.PERCENT_EQ,
                "&=": TokenType.AMP_EQ,
                "|=": TokenType.PIPE_EQ,
                "^=": TokenType.CARET_EQ,
            }
            if two in two_map:
                self.tokens.append(Token(two_map[two], two, line_num, col))
                i += 2
                continue

            # Triple-quoted string literals ("""...""" or '''...''')
            if ch in ('"', "'") and line[i : i + 3] == ch * 3:
                delim = ch * 3
                start_line = line_num
                start_col = col
                i += 3
                chars = []
                closed = False
                while True:
                    while i < n:
                        if line[i : i + 3] == delim:
                            i += 3
                            closed = True
                            break
                        if line[i] == "\\" and i + 1 < n:
                            esc = line[i + 1]
                            if esc == "x" and i + 3 < n and all(c in "0123456789abcdefABCDEF" for c in line[i + 2 : i + 4]):
                                chars.append(chr(int(line[i + 2 : i + 4], 16)))
                                i += 4
                                continue
                            esc_map = {"n": "\n", "t": "\t", "r": "\r", "\\": "\\", '"': '"', "'": "'", "0": "\0"}
                            chars.append(esc_map.get(esc, esc))
                            i += 2
                        else:
                            chars.append(line[i])
                            i += 1
                    if closed:
                        break
                    if not hasattr(self, "_lines") or self._line_idx >= len(self._lines):
                        raise LexerError("Unterminated triple-quoted string literal", start_line, start_col)
                    chars.append("\n")
                    line = self._lines[self._line_idx]
                    line_num = self._line_idx + 1
                    self._line_idx += 1
                    i = 0
                    n = len(line)
                self.tokens.append(Token(TokenType.STRING, "".join(chars), start_line, start_col))
                continue

            # String literals
            if ch in ('"', "'"):
                quote = ch
                i += 1
                chars = []
                while i < n and line[i] != quote:
                    if line[i] == "\\" and i + 1 < n:
                        esc = line[i + 1]
                        if esc == "x" and i + 3 < n and all(c in "0123456789abcdefABCDEF" for c in line[i + 2 : i + 4]):
                            chars.append(chr(int(line[i + 2 : i + 4], 16)))
                            i += 4
                            continue
                        esc_map = {"n": "\n", "t": "\t", "r": "\r", "\\": "\\", '"': '"', "'": "'", "0": "\0"}
                        chars.append(esc_map.get(esc, esc))
                        i += 2
                    else:
                        chars.append(line[i])
                        i += 1
                if i >= n or line[i] != quote:
                    raise LexerError("Unterminated string literal", line_num, col)
                i += 1
                self.tokens.append(Token(TokenType.STRING, "".join(chars), line_num, col))
                continue

            # Numeric literals (int & float, hex 0x, bin 0b, underscores)
            if ch.isdigit():
                start = i
                if ch == "0" and i + 1 < n and line[i + 1] in ("x", "X"):
                    i += 2
                    while i < n and (line[i] in "0123456789abcdefABCDEF_"):
                        i += 1
                    val = int(line[start:i].replace("_", ""), 16)
                    self.tokens.append(Token(TokenType.INT, val, line_num, col))
                    continue
                if ch == "0" and i + 1 < n and line[i + 1] in ("b", "B"):
                    i += 2
                    while i < n and (line[i] in "01_"):
                        i += 1
                    val = int(line[start:i].replace("_", ""), 2)
                    self.tokens.append(Token(TokenType.INT, val, line_num, col))
                    continue

                is_float = False
                while i < n and (line[i].isdigit() or line[i] == "_"):
                    i += 1
                if i < n and line[i] == "." and (i + 1 >= n or line[i + 1] != "."):
                    is_float = True
                    i += 1
                    while i < n and (line[i].isdigit() or line[i] == "_"):
                        i += 1
                if i < n and line[i] in ("e", "E"):
                    is_float = True
                    i += 1
                    if i < n and line[i] in ("+", "-"):
                        i += 1
                    while i < n and (line[i].isdigit() or line[i] == "_"):
                        i += 1
                raw_num = line[start:i].replace("_", "")
                if is_float:
                    self.tokens.append(Token(TokenType.FLOAT, float(raw_num), line_num, col))
                else:
                    self.tokens.append(Token(TokenType.INT, int(raw_num), line_num, col))
                continue

            # Identifiers & Keywords (also handle f-strings f"..." and raw strings r"...")
            if ch.isalpha() or ch == "_":
                if ch in ("r", "R") and i + 1 < n and line[i + 1] in ('"', "'"):
                    quote = line[i + 1]
                    i += 2
                    chars = []
                    while i < n and line[i] != quote:
                        chars.append(line[i])
                        i += 1
                    if i >= n or line[i] != quote:
                        raise LexerError("Unterminated raw string literal", line_num, col)
                    i += 1
                    self.tokens.append(Token(TokenType.STRING, "".join(chars), line_num, col))
                    continue

                if ch in ("f", "F") and i + 1 < n and line[i + 1] in ('"', "'"):
                    # Parse f-string into concatenation of expressions or string
                    quote = line[i + 1]
                    i += 2
                    chars = []
                    while i < n and line[i] != quote:
                        if line[i] == "\\" and i + 1 < n:
                            esc = line[i + 1]
                            esc_map = {"n": "\n", "t": "\t", "r": "\r", "\\": "\\", '"': '"', "'": "'"}
                            chars.append(esc_map.get(esc, esc))
                            i += 2
                        else:
                            chars.append(line[i])
                            i += 1
                    if i >= n or line[i] != quote:
                        raise LexerError("Unterminated f-string literal", line_num, col)
                    i += 1
                    self.tokens.append(Token(TokenType.STRING, "f:" + "".join(chars), line_num, col))
                    continue

                start = i
                while i < n and (line[i].isalnum() or line[i] == "_"):
                    i += 1
                ident = line[start:i]
                tok_type = KEYWORDS.get(ident, TokenType.IDENT)
                if tok_type == TokenType.TRUE:
                    self.tokens.append(Token(TokenType.BOOL, True, line_num, col))
                elif tok_type == TokenType.FALSE:
                    self.tokens.append(Token(TokenType.BOOL, False, line_num, col))
                else:
                    self.tokens.append(Token(tok_type, ident, line_num, col))
                continue

            # Single-character tokens
            single_map = {
                "+": TokenType.PLUS,
                "-": TokenType.MINUS,
                "*": TokenType.STAR,
                "/": TokenType.SLASH,
                "%": TokenType.PERCENT,
                "&": TokenType.AMP,
                "|": TokenType.PIPE,
                "^": TokenType.CARET,
                "~": TokenType.TILDE,
                "<": TokenType.LT,
                ">": TokenType.GT,
                "=": TokenType.ASSIGN,
                "(": TokenType.LPAREN,
                ")": TokenType.RPAREN,
                "[": TokenType.LBRACKET,
                "]": TokenType.RBRACKET,
                "{": TokenType.LBRACE,
                "}": TokenType.RBRACE,
                ":": TokenType.COLON,
                ",": TokenType.COMMA,
                ".": TokenType.DOT,
                ";": TokenType.SEMI,
                "@": TokenType.AT,
            }
            if ch in single_map:
                tt = single_map[ch]
                if tt in (TokenType.LPAREN, TokenType.LBRACKET, TokenType.LBRACE):
                    self.paren_depth += 1
                elif tt in (TokenType.RPAREN, TokenType.RBRACKET, TokenType.RBRACE):
                    self.paren_depth = max(0, self.paren_depth - 1)
                self.tokens.append(Token(tt, ch, line_num, col))
                i += 1
                continue

            raise LexerError(f"Unexpected character {ch!r}", line_num, col)
