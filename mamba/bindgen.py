"""
Black Mamba (bmb) C Header Binding Generator (Bindgen).

Parses C header files (.h) and automatically generates typed Black Mamba (.bmb)
foreign function interface (FFI) bindings using `extern "c" from "<lib>":`.
"""

import os
import re
from typing import Dict, List, Optional, Tuple


# C type mapping table -> Black Mamba type
C_TO_BMB_TYPE: Dict[str, str] = {
    "void": "void",
    "char": "i64",
    "signed char": "i64",
    "unsigned char": "i64",
    "short": "i64",
    "unsigned short": "i64",
    "int": "i32",
    "unsigned int": "u32",
    "long": "i64",
    "unsigned long": "u64",
    "long long": "i64",
    "unsigned long long": "u64",
    "int8_t": "i8",
    "uint8_t": "u8",
    "int16_t": "i16",
    "uint16_t": "u16",
    "int32_t": "i32",
    "uint32_t": "u32",
    "int64_t": "i64",
    "uint64_t": "u64",
    "size_t": "usize",
    "ssize_t": "isize",
    "uintptr_t": "uintptr",
    "intptr_t": "i64",
    "float": "f64",
    "double": "f64",
    "bool": "bool",
    "_Bool": "bool",
    "const char*": "str",
    "char*": "str",
    "char *": "str",
    "const char *": "str",
    "DWORD": "i32",
    "BOOL": "bool",
    "HANDLE": "ptr",
    "LPVOID": "ptr",
    "LPCSTR": "str",
    "LPSTR": "str",
    "ULONGLONG": "u64",
}


def _strip_c_comments(code: str) -> str:
    # Remove block comments /* ... */
    code = re.sub(r"/\*.*?\*/", "", code, flags=re.DOTALL)
    # Remove line comments // ...
    code = re.sub(r"//.*$", "", code, flags=re.MULTILINE)
    return code


def _map_c_type(c_type_str: str) -> str:
    cleaned = c_type_str.strip()
    cleaned = re.sub(r"\bconst\b", "", cleaned).strip()
    # Check pointer types
    if cleaned.endswith("*") or "*" in cleaned:
        base = cleaned.replace("*", "").strip()
        if base in ("char", "const char"):
            return "str"
        return "ptr"
    # Exact lookup
    if cleaned in C_TO_BMB_TYPE:
        return C_TO_BMB_TYPE[cleaned]
    # Check common prefixes/suffixes
    if cleaned.startswith("u") or cleaned.startswith("uint"):
        return "u64"
    if "int" in cleaned or "long" in cleaned or "short" in cleaned:
        return "i64"
    if "float" in cleaned or "double" in cleaned:
        return "f64"
    return "i64"


def parse_c_header(header_content: str) -> List[Tuple[str, List[Tuple[str, str]], str]]:
    """
    Parses C function declarations from header content.
    Returns list of (function_name, [(param_name, param_type)], return_type).
    """
    clean_code = _strip_c_comments(header_content)
    functions: List[Tuple[str, List[Tuple[str, str]], str]] = []
    seen_names = set()

    # Match C function prototypes: <return_type> <name>(<args>);
    # e.g.: int puts(const char *s);
    pattern = re.compile(
        r"(?:extern\s+)?([a-zA-Z_0-9\s\*]+?)\s+([a-zA-Z_0-9]+)\s*\(([^)]*)\)\s*;",
        re.MULTILINE,
    )

    for match in pattern.finditer(clean_code):
        ret_c = match.group(1).strip()
        fn_name = match.group(2).strip()
        args_str = match.group(3).strip()

        # Skip control flow / preprocessor false positives
        if fn_name in ("if", "while", "for", "switch", "return", "sizeof", "typedef", "define"):
            continue
        if ret_c.startswith("#") or "typedef" in ret_c:
            continue
        if fn_name in seen_names:
            continue
        seen_names.add(fn_name)

        bmb_ret = _map_c_type(ret_c)
        params: List[Tuple[str, str]] = []

        if args_str and args_str != "void":
            arg_parts = [a.strip() for a in args_str.split(",") if a.strip()]
            for idx, arg in enumerate(arg_parts):
                # Handle variadic
                if arg == "...":
                    break
                arg_clean = arg.strip()
                m_ident = re.search(r"([a-zA-Z_][a-zA-Z0-9_]*)$", arg_clean)
                if m_ident:
                    p_name = m_ident.group(1)
                    p_type_c = arg_clean[: m_ident.start()].strip()
                    if not p_type_c:
                        p_type_c = p_name
                        p_name = f"arg{idx}"
                else:
                    p_type_c = arg_clean
                    p_name = f"arg{idx}"

                # Clean identifier name
                p_name = re.sub(r"[^a-zA-Z0-9_]", "", p_name) or f"arg{idx}"
                # Avoid reserved keywords and types in Black Mamba
                if p_name in (
                    "def", "fn", "class", "struct", "import", "from", "for", "while",
                    "if", "else", "elif", "let", "const", "mut", "str", "int", "float",
                    "bool", "list", "array", "pass", "return", "break", "continue",
                ):
                    p_name = f"_{p_name}"
                bmb_type = _map_c_type(p_type_c)
                params.append((p_name, bmb_type))

        functions.append((fn_name, params, bmb_ret))

    return functions


def generate_bmb_bindings(header_path: str, lib_name: str) -> str:
    """Reads header_path and produces Black Mamba binding source code."""
    with open(header_path, "r", encoding="utf-8", errors="replace") as f:
        content = f.read()

    funcs = parse_c_header(content)
    base_h = os.path.basename(header_path)

    lines = [
        f'# Generated by Black Mamba (bmb) Bindgen from {base_h}',
        f'# Target Shared Library: {lib_name}',
        '',
        f'extern "c" from "{lib_name}":',
    ]

    if not funcs:
        lines.append('    pass')
    else:
        for fn_name, params, ret_t in funcs:
            params_s = ", ".join(f"{pn}: {pt}" for pn, pt in params)
            lines.append(f'    def {fn_name}({params_s}) -> {ret_t}')

    lines.append('')
    return "\n".join(lines)
