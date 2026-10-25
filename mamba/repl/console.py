"""
Black Mamba (bmb) Interactive REPL — Terminal Console & Prompt Interface.
Provides multiline input accumulation, ANSI color styling, history navigation,
and clean signal interruption.
"""

import os
import sys
from typing import Optional

from .session import ReplResult, ReplSession

# Enable ANSI escape sequences on Windows console
if sys.platform == "win32":
    os.system("")

# Try importing readline for command history
try:
    import readline
except ImportError:
    try:
        import pyreadline3 as readline  # type: ignore
    except ImportError:
        readline = None  # type: ignore

# ANSI Color Codes
COLOR_GREEN = "\033[1;32m"
COLOR_DIM = "\033[2m"
COLOR_CYAN = "\033[36m"
COLOR_YELLOW = "\033[1;33m"
COLOR_RED = "\033[1;31m"
COLOR_BOLD = "\033[1m"
COLOR_RESET = "\033[0m"


def _safe_print(text: str = "", end: str = "\n") -> None:
    """Prints text safely without crashing on non-UTF-8 Windows codepages."""
    try:
        sys.stdout.write(text + end)
        sys.stdout.flush()
    except UnicodeEncodeError:
        try:
            sys.stdout.buffer.write((text + end).encode("utf-8", errors="replace"))
            sys.stdout.buffer.flush()
        except Exception:
            # Fallback to ascii representation
            sys.stdout.write(text.encode("ascii", errors="replace").decode("ascii") + end)
            sys.stdout.flush()


def print_banner() -> None:
    """Displays the Black Mamba REPL welcome banner."""
    banner = f"""{COLOR_GREEN}+------------------------------------------------------------------------+
|  {COLOR_BOLD}Black Mamba (.bmb) Native JIT REPL v0.5.0{COLOR_RESET}{COLOR_GREEN}                             |
|  Bare-Metal x86-64 Execution * Zero GC Pauses * Real-Time JIT          |
|  Type {COLOR_CYAN}:help{COLOR_RESET}{COLOR_GREEN} for commands, {COLOR_CYAN}:vars{COLOR_RESET}{COLOR_GREEN} for variables, {COLOR_CYAN}:exit{COLOR_RESET}{COLOR_GREEN} or Ctrl+D to quit |
+------------------------------------------------------------------------+{COLOR_RESET}"""
    _safe_print(banner)


def is_block_continuation(lines: list) -> bool:
    """
    Determines if current multiline input needs more lines before compiling.
    """
    if not lines:
        return False
    last = lines[-1].strip()

    # Ends with colon -> needs block body
    if last.endswith(":"):
        return True

    # Count unmatched brackets
    full_text = "\n".join(lines)
    opens = full_text.count("(") + full_text.count("[") + full_text.count("{")
    closes = full_text.count(")") + full_text.count("]") + full_text.count("}")
    if opens > closes:
        return True

    # Inside indented block
    if len(lines) > 1 and lines[-1].startswith("    "):
        return True

    return False


def format_result(res: ReplResult) -> str:
    """Formats a ReplResult for terminal display."""
    parts = []

    # 1. Any printed output (stdout side-effects)
    if res.output:
        parts.append(res.output.rstrip())

    # 2. Informational message
    if res.message:
        parts.append(f"{COLOR_CYAN}{res.message}{COLOR_RESET}")

    # 3. Expression return value
    if res.is_expression:
        val = res.result
        vtype = res.result_type or "i64"
        if vtype == "str":
            val_str = f"'{val}'"
        else:
            val_str = str(val)
        parts.append(f"{COLOR_YELLOW}{val_str}{COLOR_RESET} {COLOR_DIM}({vtype}){COLOR_RESET}")

    # 4. Error message
    if res.error:
        parts.append(f"{COLOR_RED}{res.error}{COLOR_RESET}")

    return "\n".join(parts)


def run_repl(session: Optional[ReplSession] = None) -> int:
    """
    Runs the main interactive REPL loop until exit.
    """
    if session is None:
        session = ReplSession()

    print_banner()

    prompt_primary = f"{COLOR_GREEN}bmb >>> {COLOR_RESET}"
    prompt_continuation = f"{COLOR_DIM}bmb ... {COLOR_RESET}"

    while True:
        try:
            line = input(prompt_primary)
        except EOFError:
            _safe_print(f"\n{COLOR_DIM}Exiting Black Mamba REPL. Goodbye!{COLOR_RESET}")
            break
        except KeyboardInterrupt:
            _safe_print()
            continue

        if not line.strip():
            continue

        lines = [line]

        # Multiline collection loop
        while is_block_continuation(lines):
            try:
                cont_line = input(prompt_continuation)
            except (EOFError, KeyboardInterrupt):
                _safe_print()
                lines = []
                break

            if not cont_line.strip() and not lines[-1].endswith(":"):
                # Blank line terminates indented block
                break
            lines.append(cont_line)

        if not lines:
            continue

        full_source = "\n".join(lines)
        res = session.execute(full_source)

        if res.message == "EXIT":
            _safe_print(f"{COLOR_DIM}Exiting Black Mamba REPL. Goodbye!{COLOR_RESET}")
            break

        out = format_result(res)
        if out:
            _safe_print(out)

    return 0
