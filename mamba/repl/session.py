"""
Black Mamba (bmb) Interactive REPL — Session & Execution Engine.
Provides incremental compilation, live variable state persistence,
dynamic expression evaluation, and compiler inspection commands.
"""

import os
from dataclasses import dataclass
from typing import Any, Callable, Dict, List, Optional, Set

from ..ast_nodes import (
    Assign,
    AugAssign,
    ExprStmt,
    FromImportStmt,
    FuncDef,
    ImportStmt,
    Module,
    StructDef,
)
from ..backends.x86_64_jit import NativeJITModule
from ..lexer import Lexer, LexerError
from ..mir import MIRBuilder, MIRModule
from ..module_loader import resolve_imports
from ..parser import ParseError, Parser
from ..types import TypeInferencer


@dataclass
class ReplResult:
    """Outcome of evaluating a single REPL turn."""
    result: Any = None
    result_type: Optional[str] = None
    output: str = ""
    is_expression: bool = False
    message: Optional[str] = None
    error: Optional[str] = None


class ReplSession:
    """
    Maintains incremental compiler state and variable bindings across REPL turns.
    """

    def __init__(self, base_dir: Optional[str] = None):
        self.base_dir = base_dir or os.getcwd()
        self.imports: List[str] = []
        self.structs: Dict[str, str] = {}
        self.funcs: Dict[str, str] = {}
        self.statements: List[str] = []
        self.assigned_vars: Set[str] = set()
        self.last_mir: Optional[MIRModule] = None
        self.last_disasm: Optional[str] = None
        self.last_result: Any = None
        self.last_type: Optional[str] = None

    def reset(self) -> None:
        """Clears all session declarations and state."""
        self.imports.clear()
        self.structs.clear()
        self.funcs.clear()
        self.statements.clear()
        self.assigned_vars.clear()
        self.last_mir = None
        self.last_disasm = None
        self.last_result = None
        self.last_type = None

    def execute(self, source: str) -> ReplResult:
        """
        Executes a single line or block of Black Mamba code or meta-command.
        """
        stripped = source.strip()
        if not stripped:
            return ReplResult()

        # Handle Meta Commands
        if stripped.startswith(":") or stripped in ("help", "quit", "exit", "exit()", "quit()"):
            return self._handle_meta_command(stripped)

        # Parse source snippet
        try:
            tokens = Lexer(source).tokenize()
            mod = Parser(tokens).parse_module()
        except (LexerError, ParseError) as err:
            return ReplResult(error=str(err))
        except Exception as e:
            return ReplResult(error=f"Syntax Error: {e}")

        if not mod.statements:
            return ReplResult()

        # Check for single statement expression vs declarations/assignments
        if len(mod.statements) == 1:
            stmt = mod.statements[0]

            # Import Statements
            if isinstance(stmt, (ImportStmt, FromImportStmt)):
                return self._handle_import(stripped, mod)

            # Struct Definition
            if isinstance(stmt, StructDef):
                self.structs[stmt.name] = stripped
                return ReplResult(message=f"Defined struct {stmt.name}")

            # Function Definition
            if isinstance(stmt, FuncDef):
                self.funcs[stmt.name] = stripped
                params_str = ", ".join(f"{p.name}: {p.type_ann or 'i64'}" for p in stmt.params)
                ret_str = stmt.return_type or "i64"
                return ReplResult(message=f"Defined function {stmt.name}({params_str}) -> {ret_str}")

            # Expression Statement (Evaluation)
            if isinstance(stmt, ExprStmt):
                return self._eval_expression(stripped)

        # Multi-statement or assignment block
        return self._exec_statements(stripped, mod)

    def _handle_meta_command(self, cmd: str) -> ReplResult:
        """Processes REPL interactive control commands."""
        clean = cmd.lstrip(":").strip().lower()

        if clean in ("exit", "quit", "q", "exit()", "quit()"):
            return ReplResult(message="EXIT")

        if clean in ("help", "h", "?"):
            help_text = (
                "Black Mamba (.bmb) Interactive REPL Commands:\n"
                "  :help, :h, ?      Show this help reference\n"
                "  :vars             Inspect all active variables, types, and values\n"
                "  :funcs            List defined session functions and signatures\n"
                "  :structs          List defined session struct layouts\n"
                "  :mir              Display optimized SSA Mid-Level IR of last run\n"
                "  :asm              Display emitted native x86-64 machine code disassembly\n"
                "  :reset            Clear session environment and reset state\n"
                "  :exit, :quit, :q  Exit the Black Mamba REPL\n"
                "\n"
                "Tips:\n"
                "  - Enter expressions (e.g. 10 + 20) to evaluate and print results\n"
                "  - Multi-line blocks (fn, if, while, struct) continue on '... '\n"
                "  - Standard library: from math import sin, PI | from time import clock_ns"
            )
            return ReplResult(message=help_text)

        if clean in ("vars", "v"):
            if not self.assigned_vars:
                return ReplResult(message="No session variables defined.")
            var_lines = []
            for vname in sorted(self.assigned_vars):
                res = self._eval_expression(vname)
                if res.is_expression and res.error is None:
                    var_lines.append(f"  {vname}: {res.result_type} = {res.result!r}")
                else:
                    var_lines.append(f"  {vname} (defined)")
            return ReplResult(message="Active Session Variables:\n" + "\n".join(var_lines))

        if clean in ("funcs", "f"):
            if not self.funcs:
                return ReplResult(message="No user functions defined in session.")
            fn_lines = [f"  {fname}:\n    " + fsrc.replace("\n", "\n    ") for fname, fsrc in self.funcs.items()]
            return ReplResult(message="Session Functions:\n" + "\n".join(fn_lines))

        if clean in ("structs", "s"):
            if not self.structs:
                return ReplResult(message="No structs defined in session.")
            st_lines = [f"  {sname}:\n    " + ssrc.replace("\n", "\n    ") for sname, ssrc in self.structs.items()]
            return ReplResult(message="Session Structs:\n" + "\n".join(st_lines))

        if clean == "mir":
            if self.last_mir is None:
                return ReplResult(message="No MIR available yet. Execute code first.")
            return ReplResult(message="Optimized SSA Mid-Level IR (MIR):\n" + self.last_mir.format())

        if clean == "asm":
            if self.last_disasm is None:
                return ReplResult(message="No disassembly available yet. Execute code first.")
            return ReplResult(message="Emitted Native x86-64 Machine Code:\n" + self.last_disasm)

        if clean == "reset":
            self.reset()
            return ReplResult(message="Session environment reset.")

        return ReplResult(error=f"Unknown REPL command ':{clean}'. Type :help for available commands.")

    def _handle_import(self, source: str, mod: Module) -> ReplResult:
        """Validates and persists a module import."""
        try:
            resolve_imports(mod, self.base_dir)
            self.imports.append(source)
            return ReplResult(message=f"Imported: {source.strip()}")
        except Exception as e:
            return ReplResult(error=f"Import error: {e}")

    def _eval_expression(self, expr_src: str) -> ReplResult:
        """
        Evaluates a single expression in the accumulated session context.
        """
        # Step 1: Infer return type of the expression
        infer_code = self._build_program(
            fn_name="__repl_infer__",
            body_lines=self.statements + [f"__repl_res = {expr_src}", "return 0"],
            ret_type="i64",
        )
        try:
            mod_inf = Parser.from_source(infer_code).parse_module()
            mod_inf = resolve_imports(mod_inf, self.base_dir)
            inf = TypeInferencer(mod_inf)
            inf.run()
            sig = inf.signatures.get("__repl_infer__")
            inferred_type = sig.var_types.get("__repl_res", "i64") if sig else "i64"
        except Exception:
            inferred_type = "i64"

        # If expression is void (like print()), execute as statement
        if inferred_type in ("void", "None", None):
            return self._exec_statements(expr_src, None)

        # Step 2: Compile evaluation function with inferred return type
        run_code = self._build_program(
            fn_name="__repl_eval__",
            body_lines=self.statements + [f"return {expr_src}"],
            ret_type=inferred_type,
        )

        output_buffer: List[str] = []

        try:
            mod_run = Parser.from_source(run_code).parse_module()
            mod_run = resolve_imports(mod_run, self.base_dir)
            mir = MIRBuilder().build(mod_run, base_dir=self.base_dir)
            self.last_mir = mir

            jit = NativeJITModule(mir, output_callback=output_buffer.append)
            self.last_disasm = jit.format_disassembly()
            val = jit.call_function("__repl_eval__")
            jit.close()

            out_text = "".join(output_buffer)
            self.last_result = val
            self.last_type = inferred_type
            return ReplResult(
                result=val,
                result_type=inferred_type,
                output=out_text,
                is_expression=True,
            )
        except Exception as e:
            return ReplResult(error=f"Runtime error: {e}", output="".join(output_buffer))

    def _exec_statements(self, stmt_src: str, mod: Optional[Module]) -> ReplResult:
        """
        Executes a statement or block, verifying compilation and tracking variable assignments.
        """
        # New statement lines
        new_lines = [line for line in stmt_src.splitlines() if line.strip()]

        run_code = self._build_program(
            fn_name="__repl_exec__",
            body_lines=self.statements + new_lines + ["return 0"],
            ret_type="i64",
        )

        output_buffer: List[str] = []

        try:
            mod_run = Parser.from_source(run_code).parse_module()
            mod_run = resolve_imports(mod_run, self.base_dir)
            mir = MIRBuilder().build(mod_run, base_dir=self.base_dir)
            self.last_mir = mir

            jit = NativeJITModule(mir, output_callback=output_buffer.append)
            self.last_disasm = jit.format_disassembly()
            jit.call_function("__repl_exec__")
            jit.close()

            # Append validated state-bearing statements to session state (exclude top-level print calls)
            self.statements.extend(
                ln for ln in new_lines if not ln.startswith("print(")
            )

            # Track variable names if assigned
            if mod:
                for s in mod.statements:
                    if isinstance(s, (Assign, AugAssign)):
                        self.assigned_vars.add(s.target)

            out_text = "".join(output_buffer)
            return ReplResult(output=out_text)
        except Exception as e:
            return ReplResult(error=f"Execution error: {e}", output="".join(output_buffer))

    def _build_program(self, fn_name: str, body_lines: List[str], ret_type: str = "i64") -> str:
        """Constructs a complete compilable Black Mamba module string."""
        parts: List[str] = []

        # Imports
        for imp in self.imports:
            parts.append(imp)

        # Struct definitions
        for ssrc in self.structs.values():
            parts.append(ssrc)

        # Function definitions
        for fsrc in self.funcs.values():
            parts.append(fsrc)

        # Runner function
        parts.append(f"fn {fn_name}() -> {ret_type}:")
        if body_lines:
            for bline in body_lines:
                parts.append(f"    {bline}")
        else:
            parts.append("    return 0")

        # Entry main stub
        parts.append("fn main() -> i64:\n    return 0")

        return "\n\n".join(parts)
