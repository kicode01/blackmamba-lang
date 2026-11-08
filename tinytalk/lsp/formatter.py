"""
Black Mamba Language Server Protocol (LSP) — Source Code Formatter.
Applies clean, standard 4-space indentation and canonical operator spacing.
"""

import re


def _format_code_segment(segment: str) -> str:
    """Formats code outside string literals and comments."""
    # 1. Normalize keywords: fn/def/struct/class/return
    segment = re.sub(r"\b(fn|def|struct|class|if|while|for|return)\s+", r"\1 ", segment)
    # 2. Normalize arrow ->
    segment = re.sub(r"\s*->\s*", " -> ", segment)
    # 3. Normalize colons followed by type or not at end: ':int' -> ': int'
    segment = re.sub(r":(?!\s|$)", ": ", segment)
    # 4. Normalize commas: ',b' -> ', b'
    segment = re.sub(r",(?!\s|$)", ", ", segment)
    # 5. Normalize operators + - * / = ==
    segment = re.sub(r"(?<=[a-zA-Z0-9_\)])\s*(\+|\*|\/|\%)\s*(?=[a-zA-Z0-9_\(])", r" \1 ", segment)
    segment = re.sub(r"(?<=[a-zA-Z0-9_\)])\s*(-)\s*(?=[a-zA-Z0-9_\(])", r" - ", segment)
    segment = re.sub(r"(?<=[a-zA-Z0-9_\)])\s*(==|!=|<=|>=)\s*(?=[a-zA-Z0-9_\(])", r" \1 ", segment)
    segment = re.sub(r"(?<=[a-zA-Z0-9_])\s*(=)\s*(?=[a-zA-Z0-9_\(])", r" = ", segment)
    segment = re.sub(r"\s*\|\>\s*", " |> ", segment)
    # Collapse multiple consecutive spaces
    segment = re.sub(r" {2,}", " ", segment)
    return segment


def _format_line_content(line: str) -> str:
    """Formats a single line while preserving string literals and comments."""
    parts = re.split(r'("[^"]*"|\'[^\']*\'|#.*$)', line)
    formatted_parts = []
    for part in parts:
        if part.startswith('"') or part.startswith("'") or part.startswith("#"):
            formatted_parts.append(part)
        else:
            formatted_parts.append(_format_code_segment(part))
    return "".join(formatted_parts).strip()


def format_source(source: str) -> str:
    """
    Formats Black Mamba source code according to the canonical 4-space indentation standard.
    """
    raw_lines = source.splitlines()
    if not raw_lines:
        return "\n" if source.endswith("\n") else ""

    formatted_lines = []
    indent_level = 0

    for raw in raw_lines:
        stripped = raw.strip()
        if not stripped:
            formatted_lines.append("")
            continue

        # Check for dedent keywords: elif, else, case (when under match)
        is_dedent = False
        if (
            stripped.startswith("elif ")
            or stripped.startswith("elif:")
            or stripped == "else:"
            or stripped.startswith("else:")
            or stripped.startswith("case ")
        ):
            is_dedent = True

        effective_indent = max(0, indent_level - 1 if is_dedent else indent_level)
        line_indent = "    " * effective_indent

        # Format line content while protecting comments and strings
        formatted_content = _format_line_content(stripped)

        formatted_lines.append(line_indent + formatted_content)

        # Update indent level for next line
        # If line ends with ':' and is not a comment
        if formatted_content.endswith(":") and not formatted_content.startswith("#"):
            indent_level = effective_indent + 1
        elif is_dedent:
            indent_level = effective_indent + 1

    result = "\n".join(formatted_lines)
    if source.endswith("\n"):
        result += "\n"
    return result
