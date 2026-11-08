"""
Black Mamba (bmb migrate) — Automated Python-to-Mamba AST Migration Engine.

Transforms legacy Python (.py) codebases into high-performance, native
Black Mamba (.bmb) source files:
1. Translates Python standard library and third-party imports to native Black Mamba
   stdlib modules (math, os, json, regex, tls, socket, thread, chan, time) or
   transparent `from python import ...` host bridge clauses.
2. Infers and normalizes type annotations (int -> i64, float -> f64, list -> List).
3. Promotes pure data classes and simple init-only classes to 0-overhead unboxed structs.
4. Converts unittest.TestCase and pytest test functions into native test.bmb assertions.
5. Emits idiomatic, canonical Black Mamba source code.
"""

import ast
import os
import sys
from typing import Dict, List, Optional, Set, Tuple, Any


TYPE_MAP = {
    "int": "i64",
    "int64": "i64",
    "float": "f64",
    "float64": "f64",
    "str": "str",
    "bool": "bool",
    "list": "List",
    "dict": "Dict",
    "None": "void",
    "Any": "i64",
}

STDLIB_MAP = {
    "math": "math",
    "os": "os",
    "sys": "os",
    "json": "json",
    "re": "regex",
    "regex": "regex",
    "ssl": "tls",
    "time": "time",
    "random": "random",
    "socket": "socket",
    "threading": "thread",
    "queue": "chan",
    "unittest": "test",
    "pytest": "test",
}


class PythonToMambaMigrator(ast.NodeTransformer):
    """AST rewriter transforming Python AST into Black Mamba AST representation."""

    def __init__(self):
        super().__init__()
        self.stats = {
            "classes_promoted_to_structs": 0,
            "classes_retained": 0,
            "functions_migrated": 0,
            "types_inferred": 0,
            "imports_mapped": 0,
            "tests_converted": 0,
        }
        self.struct_names: Set[str] = set()
        self.imported_modules: Set[str] = set()
        self.needs_test_import: bool = False

    def _convert_type_node(self, node: Optional[ast.AST]) -> str:
        if node is None:
            return ""
        if isinstance(node, ast.Name):
            return TYPE_MAP.get(node.id, node.id)
        if isinstance(node, ast.Constant):
            return TYPE_MAP.get(str(node.value), str(node.value))
        if isinstance(node, ast.Subscript):
            val = self._convert_type_node(node.value)
            slice_val = self._convert_type_node(node.slice)
            return f"{val}[{slice_val}]"
        if isinstance(node, ast.Tuple):
            elts = [self._convert_type_node(e) for e in node.elts]
            return ", ".join(elts)
        return "i64"

    def _infer_param_type(self, arg_node: ast.arg, fn_node: ast.FunctionDef) -> str:
        if arg_node.annotation is not None:
            return self._convert_type_node(arg_node.annotation)

        name = arg_node.arg
        if name == "self":
            return ""

        # Simple flow scan within body
        for stmt in ast.walk(fn_node):
            if isinstance(stmt, ast.BinOp):
                if isinstance(stmt.left, ast.Name) and stmt.left.id == name:
                    if isinstance(stmt.right, ast.Constant):
                        if isinstance(stmt.right.value, float):
                            self.stats["types_inferred"] += 1
                            return "f64"
                        if isinstance(stmt.right.value, int):
                            self.stats["types_inferred"] += 1
                            return "i64"
                if isinstance(stmt.right, ast.Name) and stmt.right.id == name:
                    if isinstance(stmt.left, ast.Constant):
                        if isinstance(stmt.left.value, float):
                            self.stats["types_inferred"] += 1
                            return "f64"
                        if isinstance(stmt.left.value, int):
                            self.stats["types_inferred"] += 1
                            return "i64"

        # Default heuristic
        self.stats["types_inferred"] += 1
        return "i64"

    def _infer_return_type(self, fn_node: ast.FunctionDef) -> str:
        if fn_node.returns is not None:
            return self._convert_type_node(fn_node.returns)

        # Check return statements
        has_return = False
        for stmt in ast.walk(fn_node):
            if isinstance(stmt, ast.Return) and stmt.value is not None:
                has_return = True
                if isinstance(stmt.value, ast.Constant):
                    if isinstance(stmt.value.value, float):
                        return "f64"
                    if isinstance(stmt.value.value, str):
                        return "str"
                    if isinstance(stmt.value.value, bool):
                        return "bool"
                    if isinstance(stmt.value.value, int):
                        return "i64"
        if not has_return:
            return "void"
        return "i64"


def migrate_source(source: str) -> Tuple[str, Dict[str, int]]:
    """Migrates a Python source string into idiomatic Black Mamba code."""
    tree = ast.parse(source)
    migrator = PythonToMambaMigrator()

    lines: List[str] = []
    lines.append("# [Black Mamba Migrator] Auto-generated from Python source")

    # 1. Process Imports
    stdlib_imports: List[str] = []
    python_bridge_mods: Set[str] = set()
    python_bridge_funcs: Dict[str, Set[str]] = {}

    remaining_body: List[ast.AST] = []

    for item in tree.body:
        if isinstance(item, ast.Import):
            for alias in item.names:
                base_name = alias.name.split(".")[0]
                if base_name in STDLIB_MAP:
                    mapped = STDLIB_MAP[base_name]
                    stdlib_imports.append(f"import {mapped}")
                    migrator.stats["imports_mapped"] += 1
                else:
                    python_bridge_mods.add(alias.name)
                    migrator.stats["imports_mapped"] += 1
        elif isinstance(item, ast.ImportFrom):
            mod_name = item.module or ""
            base_name = mod_name.split(".")[0]
            if base_name in STDLIB_MAP:
                mapped = STDLIB_MAP[base_name]
                names = [a.name for a in item.names]
                stdlib_imports.append(f"from {mapped} import {', '.join(names)}")
                migrator.stats["imports_mapped"] += 1
            else:
                if mod_name not in python_bridge_funcs:
                    python_bridge_funcs[mod_name] = set()
                for alias in item.names:
                    python_bridge_funcs[mod_name].add(alias.name)
                migrator.stats["imports_mapped"] += 1
        else:
            remaining_body.append(item)

    # Emit mapped standard library imports
    for imp_line in dict.fromkeys(stdlib_imports):
        lines.append(imp_line)

    # Emit Python bridge imports
    if python_bridge_mods:
        mods_str = ", ".join(sorted(python_bridge_mods))
        lines.append(f"from python import {mods_str}")
    for mod, funcs in sorted(python_bridge_funcs.items()):
        f_str = ", ".join(sorted(funcs))
        lines.append(f"from python.{mod} import {f_str}")

    if lines and len(lines) > 1:
        lines.append("")

    # 2. Process Classes, Functions, and Statements
    for node in remaining_body:
        # Detect if class is candidate for unboxed struct
        if isinstance(node, ast.ClassDef):
            has_dataclass_dec = any(
                (isinstance(dec, ast.Name) and dec.id == "dataclass") or
                (isinstance(dec, ast.Attribute) and dec.attr == "dataclass")
                for dec in node.decorator_list
            )
            has_init = any(isinstance(m, ast.FunctionDef) and m.name == "__init__" for m in node.body)
            is_struct_candidate = len(node.bases) == 0 and (has_dataclass_dec or has_init)

            if is_struct_candidate:
                migrator.stats["classes_promoted_to_structs"] += 1
                lines.append(f"struct {node.name}:")
                fields: List[Tuple[str, str]] = []
                methods: List[ast.FunctionDef] = []
                for sub in node.body:
                    if isinstance(sub, ast.AnnAssign) and isinstance(sub.target, ast.Name):
                        f_name = sub.target.id
                        f_type = migrator._convert_type_node(sub.annotation)
                        fields.append((f_name, f_type))
                    elif isinstance(sub, ast.FunctionDef):
                        if sub.name == "__init__":
                            # Scan self.x = x assignments
                            for s in sub.body:
                                if isinstance(s, ast.Assign) and len(s.targets) == 1:
                                    tgt = s.targets[0]
                                    if isinstance(tgt, ast.Attribute) and isinstance(tgt.value, ast.Name) and tgt.value.id == "self":
                                        f_name = tgt.attr
                                        f_type = "i64"
                                        for a in sub.args.args:
                                            if a.arg == f_name and a.annotation:
                                                f_type = migrator._convert_type_node(a.annotation)
                                                break
                                        fields.append((f_name, f_type))
                        else:
                            methods.append(sub)
                if not fields:
                    lines.append("    _unused: i64")
                else:
                    for fn, ft in fields:
                        lines.append(f"    {fn}: {ft}")
                for m in methods:
                    lines.append("")
                    _emit_function(m, lines, migrator, indent=4)
                lines.append("")
                continue
            else:
                migrator.stats["classes_retained"] += 1
                base_str = ""
                if node.bases:
                    bases = [b.id if isinstance(b, ast.Name) else "object" for b in node.bases]
                    base_str = f"({', '.join(bases)})"
                lines.append(f"class {node.name}{base_str}:")
                for sub in node.body:
                    if isinstance(sub, ast.FunctionDef):
                        _emit_function(sub, lines, migrator, indent=4)
                lines.append("")
                continue

        if isinstance(node, ast.FunctionDef):
            migrator.stats["functions_migrated"] += 1
            _emit_function(node, lines, migrator, indent=0)
            lines.append("")
            continue

        # Top-level code or main guard
        if isinstance(node, ast.If):
            # Check for if __name__ == '__main__':
            if _is_name_main(node.test):
                has_existing_main = any(isinstance(n, ast.FunctionDef) and n.name == "main" for n in remaining_body)
                if has_existing_main:
                    for sub in node.body:
                        lines.append(_unparse_stmt(sub))
                else:
                    lines.append("def main() -> i64:")
                    for sub in node.body:
                        lines.append(f"    {_unparse_stmt(sub)}")
                    lines.append("    return 0")
                    lines.append("")
                    lines.append("main()")
                continue

        lines.append(_unparse_stmt(node))

    output = "\n".join(lines).strip() + "\n"
    return output, migrator.stats


def _is_name_main(test_node: ast.AST) -> bool:
    if isinstance(test_node, ast.Compare) and len(test_node.ops) == 1 and isinstance(test_node.ops[0], ast.Eq):
        l = test_node.left
        r = test_node.comparators[0]
        if isinstance(l, ast.Name) and l.id == "__name__" and isinstance(r, ast.Constant) and r.value == "__main__":
            return True
        if isinstance(r, ast.Name) and r.id == "__name__" and isinstance(l, ast.Constant) and l.value == "__main__":
            return True
    return False


def _emit_function(fn: ast.FunctionDef, lines: List[str], migrator: PythonToMambaMigrator, indent: int = 0) -> None:
    pad = " " * indent
    params: List[str] = []
    for arg in fn.args.args:
        if arg.arg == "self":
            params.append("self")
        else:
            p_type = migrator._infer_param_type(arg, fn)
            params.append(f"{arg.arg}: {p_type}")
    ret_t = migrator._infer_return_type(fn)
    ret_suffix = f" -> {ret_t}" if ret_t != "void" else ""
    lines.append(f"{pad}def {fn.name}({', '.join(params)}){ret_suffix}:")
    if not fn.body:
        lines.append(f"{pad}    pass")
    else:
        for s in fn.body:
            # Check for unittest/pytest assert transformation
            migrated_s = _migrate_test_assert(s)
            for sub_line in migrated_s.splitlines():
                lines.append(f"{pad}    {sub_line}")


def _migrate_test_assert(stmt: ast.AST) -> str:
    """Transforms unittest/pytest assert calls to Black Mamba test.bmb assertions."""
    if isinstance(stmt, ast.Expr) and isinstance(stmt.value, ast.Call):
        call = stmt.value
        if isinstance(call.func, ast.Attribute) and isinstance(call.func.value, ast.Name) and call.func.value.id == "self":
            m_name = call.func.attr
            if m_name == "assertEqual" and len(call.args) >= 2:
                a1 = ast.unparse(call.args[0])
                a2 = ast.unparse(call.args[1])
                return f"assert_eq_i64({a1}, {a2})"
            if m_name == "assertTrue" and len(call.args) >= 1:
                a = ast.unparse(call.args[0])
                return f"assert {a}"
            if m_name == "assertFalse" and len(call.args) >= 1:
                a = ast.unparse(call.args[0])
                return f"assert not ({a})"
    return ast.unparse(stmt)


def _unparse_stmt(stmt: ast.AST) -> str:
    try:
        return ast.unparse(stmt)
    except Exception:
        return str(stmt)


def migrate_file(in_path: str, out_path: Optional[str] = None) -> Tuple[str, Dict[str, int]]:
    """Migrates a single Python file to Black Mamba source."""
    if not os.path.exists(in_path):
        raise FileNotFoundError(f"Input file not found: {in_path}")

    with open(in_path, "r", encoding="utf-8") as f:
        src = f.read()

    bmb_code, stats = migrate_source(src)
    target_path = out_path or (os.path.splitext(in_path)[0] + ".bmb")
    os.makedirs(os.path.dirname(os.path.abspath(target_path)), exist_ok=True)
    with open(target_path, "w", encoding="utf-8") as f:
        f.write(bmb_code)

    return target_path, stats


def migrate_directory(in_dir: str, out_dir: str) -> Dict[str, Any]:
    """Recursively migrates a Python project directory into a Black Mamba project."""
    total_stats = {
        "files_converted": 0,
        "classes_promoted_to_structs": 0,
        "classes_retained": 0,
        "functions_migrated": 0,
        "types_inferred": 0,
        "imports_mapped": 0,
    }
    converted_files: List[Tuple[str, str]] = []

    for root, _, files in os.walk(in_dir):
        for f in files:
            if f.endswith(".py"):
                full_in = os.path.join(root, f)
                rel_path = os.path.relpath(full_in, in_dir)
                full_out = os.path.join(out_dir, os.path.splitext(rel_path)[0] + ".bmb")
                target_path, st = migrate_file(full_in, full_out)
                converted_files.append((full_in, target_path))
                total_stats["files_converted"] += 1
                for k, v in st.items():
                    if k in total_stats:
                        total_stats[k] += v

    total_stats["converted_files"] = converted_files
    return total_stats
