"""
Black Mamba (.bmb) Recursive-Descent & Pratt Parser.

Parses both pure Python 3 syntax and Black Mamba (.bmb) extensions into a unified AST.
"""

from typing import List, Optional, Tuple
from .lexer import Lexer, Token, TokenType
from .ast_nodes import (
    ArrayLit,
    Assign,
    AugAssign,
    BinOp,
    BoolLit,
    Break,
    Call,
    Continue,
    Expr,
    ExprStmt,
    FieldAccess,
    FieldAssign,
    FloatLit,
    ForRangeStmt,
    FromImportStmt,
    FuncDef,
    IfStmt,
    ImportStmt,
    IndexAssign,
    IndexAugAssign,
    IndexExpr,
    IntLit,
    MatchCase,
    MatchStmt,
    MethodCall,
    Module,
    Param,
    PassStmt,
    RangeExpr,
    Return,
    SliceExpr,
    Stmt,
    StringLit,
    StructDef,
    StructField,
    TernaryIf,
    UnaryOp,
    Var,
    WhileStmt,
)


class ParseError(Exception):
    def __init__(self, message: str, token: Token):
        super().__init__(f"[ParseError L{token.line}:{token.col}] {message} (got {token.type.name} {token.value!r})")
        self.token = token


class Parser:
    def __init__(self, tokens: List[Token]):
        self.tokens = tokens
        self.pos = 0

    @classmethod
    def from_source(cls, source: str, filename: str = "<input.bmb>") -> "Parser":
        lexer = Lexer(source, filename)
        return cls(lexer.tokenize())

    def current(self) -> Token:
        return self.tokens[self.pos]

    def peek(self, offset: int = 1) -> Token:
        idx = min(self.pos + offset, len(self.tokens) - 1)
        return self.tokens[idx]

    def match(self, *types: TokenType) -> Optional[Token]:
        if self.current().type in types:
            tok = self.current()
            self.pos += 1
            return tok
        return None

    def expect(self, tt: TokenType, msg: str = "") -> Token:
        tok = self.current()
        if tok.type != tt:
            raise ParseError(msg or f"Expected {tt.name}", tok)
        self.pos += 1
        return tok

    def skip_newlines(self) -> None:
        while self.match(TokenType.NEWLINE, TokenType.SEMI):
            pass

    def parse_module(self) -> Module:
        stmts: List[Stmt] = []
        self.skip_newlines()
        while self.current().type != TokenType.EOF:
            stmt = self.parse_stmt()
            if stmt is not None:
                stmts.append(stmt)
            self.skip_newlines()
        return Module(line=1, col=1, statements=stmts)

    def parse_stmt(self) -> Optional[Stmt]:
        self.skip_newlines()
        tok = self.current()

        # Decorators
        decorators: List[str] = []
        while self.match(TokenType.AT):
            dec_name = self.expect(TokenType.IDENT, "Expected decorator name").value
            if self.match(TokenType.LPAREN):
                while not self.match(TokenType.RPAREN):
                    self.pos += 1
            self.skip_newlines()
            decorators.append(dec_name)

        tok = self.current()
        if tok.type in (TokenType.DEF, TokenType.FN):
            return self.parse_func_def(decorators)
        if tok.type in (TokenType.STRUCT, TokenType.CLASS):
            return self.parse_struct_def()
        if tok.type == TokenType.IF:
            return self.parse_if()
        if tok.type == TokenType.WHILE:
            return self.parse_while()
        if tok.type == TokenType.FOR:
            return self.parse_for(is_parallel=False)
        if tok.type == TokenType.PAR:
            self.pos += 1
            return self.parse_for(is_parallel=True)
        if tok.type == TokenType.MATCH:
            return self.parse_match()
        if tok.type == TokenType.RETURN:
            return self.parse_return()
        if tok.type == TokenType.BREAK:
            self.pos += 1
            self.skip_newlines()
            return Break(line=tok.line, col=tok.col)
        if tok.type == TokenType.CONTINUE:
            self.pos += 1
            self.skip_newlines()
            return Continue(line=tok.line, col=tok.col)
        if tok.type == TokenType.PASS:
            self.pos += 1
            self.skip_newlines()
            return PassStmt(line=tok.line, col=tok.col)
        if tok.type == TokenType.IMPORT:
            self.pos += 1
            mod_tok = self.expect(TokenType.IDENT, "Expected module name after 'import'")
            alias = None
            if self.match(TokenType.AS):
                alias_tok = self.expect(TokenType.IDENT, "Expected alias name after 'as'")
                alias = alias_tok.value
            self.skip_newlines()
            return ImportStmt(line=tok.line, col=tok.col, module_name=mod_tok.value, alias=alias)
        if tok.type == TokenType.FROM:
            self.pos += 1
            mod_tok = self.expect(TokenType.IDENT, "Expected module name after 'from'")
            self.expect(TokenType.IMPORT, "Expected 'import' after module name in from-import")
            names = []
            if self.match(TokenType.STAR):
                names.append("*")
            else:
                while True:
                    n_tok = self.expect(TokenType.IDENT, "Expected imported name")
                    names.append(n_tok.value)
                    if not self.match(TokenType.COMMA):
                        break
            self.skip_newlines()
            return FromImportStmt(line=tok.line, col=tok.col, module_name=mod_tok.value, names=names)
        if tok.type in (TokenType.LET, TokenType.CONST, TokenType.MUT):
            is_const = tok.type == TokenType.CONST
            self.pos += 1
            name_tok = self.expect(TokenType.IDENT, "Expected variable name")
            type_ann = None
            if self.match(TokenType.COLON):
                type_ann = self.parse_type_annotation()
            self.expect(TokenType.ASSIGN, "Expected '=' in variable declaration")
            val = self.parse_expr()
            self.skip_newlines()
            return Assign(
                line=tok.line,
                col=tok.col,
                target=name_tok.value,
                value=val,
                type_ann=type_ann,
                is_const=is_const,
            )

        return self.parse_simple_stmt()

    def parse_type_annotation(self) -> str:
        tok = self.current()
        if tok.type == TokenType.NONE:
            self.pos += 1
            return "void"
        base = self.expect(TokenType.IDENT, "Expected type name").value
        if self.match(TokenType.LBRACKET):
            inner = self.parse_type_annotation()
            self.expect(TokenType.RBRACKET, "Expected ']' in generic type")
            return f"{base}[{inner}]"
        return base

    def parse_func_def(self, decorators: List[str]) -> FuncDef:
        start_tok = self.current()
        self.pos += 1  # consume def or fn
        name = self.expect(TokenType.IDENT, "Expected function name").value
        self.expect(TokenType.LPAREN, "Expected '(' after function name")
        params: List[Param] = []
        if self.current().type != TokenType.RPAREN:
            while True:
                p_name = self.expect(TokenType.IDENT, "Expected parameter name").value
                p_type = None
                if self.match(TokenType.COLON):
                    p_type = self.parse_type_annotation()
                p_default = None
                if self.match(TokenType.ASSIGN):
                    p_default = self.parse_expr()
                params.append(Param(name=p_name, type_ann=p_type, default=p_default))
                if not self.match(TokenType.COMMA):
                    break
                if self.current().type == TokenType.RPAREN:
                    break
        self.expect(TokenType.RPAREN, "Expected ')' after parameters")
        ret_type = None
        if self.match(TokenType.ARROW):
            ret_type = self.parse_type_annotation()
        self.expect(TokenType.COLON, "Expected ':' after function signature")
        body = self.parse_block()
        return FuncDef(
            line=start_tok.line,
            col=start_tok.col,
            name=name,
            params=params,
            return_type=ret_type,
            decorators=decorators,
            body=body,
        )

    def parse_struct_def(self) -> StructDef:
        start_tok = self.current()
        self.pos += 1  # struct or class
        name = self.expect(TokenType.IDENT, "Expected struct/class name").value
        if self.match(TokenType.LPAREN):
            while not self.match(TokenType.RPAREN):
                self.pos += 1
        self.expect(TokenType.COLON, "Expected ':' after struct/class name")
        self.skip_newlines()
        self.expect(TokenType.INDENT, "Expected indented block for struct/class")

        fields: List[StructField] = []
        methods: List[FuncDef] = []
        self.skip_newlines()
        while self.current().type not in (TokenType.DEDENT, TokenType.EOF):
            if self.current().type == TokenType.PASS:
                self.pos += 1
                self.skip_newlines()
                continue
            decorators: List[str] = []
            while self.match(TokenType.AT):
                decorators.append(self.expect(TokenType.IDENT).value)
                self.skip_newlines()
            if self.current().type in (TokenType.DEF, TokenType.FN):
                methods.append(self.parse_func_def(decorators))
            else:
                f_name = self.expect(TokenType.IDENT, "Expected field name").value
                f_type = "i64"
                if self.match(TokenType.COLON):
                    f_type = self.parse_type_annotation()
                f_default = None
                if self.match(TokenType.ASSIGN):
                    f_default = self.parse_expr()
                fields.append(StructField(name=f_name, type_ann=f_type, default=f_default))
            self.skip_newlines()

        self.match(TokenType.DEDENT)
        return StructDef(line=start_tok.line, col=start_tok.col, name=name, fields=fields, methods=methods)

    def parse_block(self) -> List[Stmt]:
        if self.current().type != TokenType.NEWLINE:
            # Single-line suite: `if cond: return 1`
            stmt = self.parse_stmt()
            return [stmt] if stmt else []
        self.skip_newlines()
        self.expect(TokenType.INDENT, "Expected indented block")
        stmts: List[Stmt] = []
        self.skip_newlines()
        while self.current().type not in (TokenType.DEDENT, TokenType.EOF):
            stmt = self.parse_stmt()
            if stmt is not None:
                stmts.append(stmt)
            self.skip_newlines()
        self.match(TokenType.DEDENT)
        return stmts

    def parse_if(self) -> IfStmt:
        start_tok = self.expect(TokenType.IF)
        cond = self.parse_expr()
        self.expect(TokenType.COLON, "Expected ':' after if condition")
        then_body = self.parse_block()
        elif_branches: List[Tuple[Expr, List[Stmt]]] = []
        else_body: List[Stmt] = []

        self.skip_newlines()
        while self.match(TokenType.ELIF):
            e_cond = self.parse_expr()
            self.expect(TokenType.COLON, "Expected ':' after elif condition")
            e_body = self.parse_block()
            elif_branches.append((e_cond, e_body))
            self.skip_newlines()

        if self.match(TokenType.ELSE):
            self.expect(TokenType.COLON, "Expected ':' after else")
            else_body = self.parse_block()

        return IfStmt(
            line=start_tok.line,
            col=start_tok.col,
            cond=cond,
            then_body=then_body,
            elif_branches=elif_branches,
            else_body=else_body,
        )

    def parse_while(self) -> WhileStmt:
        start_tok = self.expect(TokenType.WHILE)
        cond = self.parse_expr()
        self.expect(TokenType.COLON, "Expected ':' after while condition")
        body = self.parse_block()
        return WhileStmt(line=start_tok.line, col=start_tok.col, cond=cond, body=body)

    def parse_for(self, is_parallel: bool = False) -> ForRangeStmt:
        start_tok = self.expect(TokenType.FOR, "Expected 'for'")
        var_name = self.expect(TokenType.IDENT, "Expected loop variable").value
        self.expect(TokenType.IN, "Expected 'in' in for loop")
        iter_expr = self.parse_expr()
        self.expect(TokenType.COLON, "Expected ':' after for header")
        body = self.parse_block()

        start_e: Expr = IntLit(line=start_tok.line, col=start_tok.col, value=0)
        stop_e: Expr = IntLit(line=start_tok.line, col=start_tok.col, value=0)
        step_e: Expr = IntLit(line=start_tok.line, col=start_tok.col, value=1)
        inclusive = False

        if isinstance(iter_expr, Call) and iter_expr.func in ("range", "prange"):
            if iter_expr.func == "prange":
                is_parallel = True
            if len(iter_expr.args) == 1:
                stop_e = iter_expr.args[0]
            elif len(iter_expr.args) == 2:
                start_e, stop_e = iter_expr.args[0], iter_expr.args[1]
            elif len(iter_expr.args) >= 3:
                start_e, stop_e, step_e = iter_expr.args[0], iter_expr.args[1], iter_expr.args[2]
        elif isinstance(iter_expr, RangeExpr):
            start_e = iter_expr.start
            stop_e = iter_expr.stop
            step_e = iter_expr.step
            inclusive = iter_expr.inclusive
        else:
            stop_e = iter_expr

        return ForRangeStmt(
            line=start_tok.line,
            col=start_tok.col,
            var_name=var_name,
            start=start_e,
            stop=stop_e,
            step=step_e,
            inclusive=inclusive,
            is_parallel=is_parallel,
            body=body,
        )

    def parse_match(self) -> MatchStmt:
        start_tok = self.expect(TokenType.MATCH)
        subject = self.parse_expr()
        self.expect(TokenType.COLON, "Expected ':' after match expression")
        self.skip_newlines()
        self.expect(TokenType.INDENT, "Expected indented block for match")
        cases: List[MatchCase] = []
        self.skip_newlines()
        while self.match(TokenType.CASE):
            if self.current().type == TokenType.IDENT and self.current().value == "_":
                self.pos += 1
                pat = None
            else:
                pat = self.parse_expr()
            self.expect(TokenType.COLON, "Expected ':' after case pattern")
            c_body = self.parse_block()
            cases.append(MatchCase(pattern=pat, body=c_body))
            self.skip_newlines()
        self.match(TokenType.DEDENT)
        return MatchStmt(line=start_tok.line, col=start_tok.col, subject=subject, cases=cases)

    def parse_return(self) -> Return:
        start_tok = self.expect(TokenType.RETURN)
        if self.current().type in (TokenType.NEWLINE, TokenType.DEDENT, TokenType.EOF, TokenType.SEMI):
            self.skip_newlines()
            return Return(line=start_tok.line, col=start_tok.col, value=None)
        val = self.parse_expr()
        self.skip_newlines()
        return Return(line=start_tok.line, col=start_tok.col, value=val)

    def parse_simple_stmt(self) -> Stmt:
        tok = self.current()
        # Check for typed assignment `ident: type = expr`
        if tok.type == TokenType.IDENT and self.peek().type == TokenType.COLON:
            name = self.expect(TokenType.IDENT).value
            self.expect(TokenType.COLON)
            type_ann = self.parse_type_annotation()
            self.expect(TokenType.ASSIGN, "Expected '=' after type annotation")
            val = self.parse_expr()
            self.skip_newlines()
            return Assign(line=tok.line, col=tok.col, target=name, value=val, type_ann=type_ann)

        expr = self.parse_expr()

        # Standard assignment
        if self.match(TokenType.ASSIGN, TokenType.WALRUS):
            val = self.parse_expr()
            self.skip_newlines()
            if isinstance(expr, Var):
                return Assign(line=tok.line, col=tok.col, target=expr.name, value=val)
            if isinstance(expr, IndexExpr):
                return IndexAssign(line=tok.line, col=tok.col, target=expr.target, index=expr.index, value=val)
            if isinstance(expr, FieldAccess):
                return FieldAssign(line=tok.line, col=tok.col, target=expr.target, field_name=expr.field_name, value=val)
            raise ParseError("Invalid assignment target", tok)

        # Augmented assignment
        aug_types = (
            TokenType.PLUS_EQ,
            TokenType.MINUS_EQ,
            TokenType.STAR_EQ,
            TokenType.SLASH_EQ,
            TokenType.DSLASH_EQ,
            TokenType.PERCENT_EQ,
            TokenType.AMP_EQ,
            TokenType.PIPE_EQ,
            TokenType.CARET_EQ,
            TokenType.LSHIFT_EQ,
            TokenType.RSHIFT_EQ,
        )
        aug_tok = self.match(*aug_types)
        if aug_tok is not None:
            op = aug_tok.value[:-1]  # strip '='
            val = self.parse_expr()
            self.skip_newlines()
            if isinstance(expr, Var):
                return AugAssign(line=tok.line, col=tok.col, target=expr.name, op=op, value=val)
            if isinstance(expr, IndexExpr):
                return IndexAugAssign(
                    line=tok.line, col=tok.col, target=expr.target, index=expr.index, op=op, value=val
                )
            if isinstance(expr, FieldAccess):
                return FieldAssign(
                    line=tok.line,
                    col=tok.col,
                    target=expr.target,
                    field_name=expr.field_name,
                    value=BinOp(line=tok.line, col=tok.col, left=expr, op=op, right=val),
                )
            raise ParseError("Invalid augmented assignment target", tok)

        self.skip_newlines()
        return ExprStmt(line=tok.line, col=tok.col, expr=expr)

    # --- Expression Precedence Hierarchy ---

    def parse_expr(self) -> Expr:
        return self.parse_pipeline()

    def parse_pipeline(self) -> Expr:
        expr = self.parse_ternary()
        while self.match(TokenType.PIPE_GT):
            rhs_tok = self.current()
            rhs = self.parse_ternary()
            if isinstance(rhs, Call):
                expr = Call(line=rhs_tok.line, col=rhs_tok.col, func=rhs.func, args=[expr] + rhs.args)
            elif isinstance(rhs, Var):
                expr = Call(line=rhs_tok.line, col=rhs_tok.col, func=rhs.name, args=[expr])
            else:
                raise ParseError("Right-hand side of '|>' pipeline must be a function or call", rhs_tok)
        return expr

    def parse_ternary(self) -> Expr:
        expr = self.parse_or()
        if self.match(TokenType.IF):
            cond = self.parse_or()
            self.expect(TokenType.ELSE, "Expected 'else' in conditional expression")
            else_e = self.parse_ternary()
            return TernaryIf(line=expr.line, col=expr.col, cond=cond, then_expr=expr, else_expr=else_e)
        return expr

    def parse_or(self) -> Expr:
        left = self.parse_and()
        while self.match(TokenType.OR):
            right = self.parse_and()
            left = BinOp(line=left.line, col=left.col, op="or", left=left, right=right)
        return left

    def parse_and(self) -> Expr:
        left = self.parse_not()
        while self.match(TokenType.AND):
            right = self.parse_not()
            left = BinOp(line=left.line, col=left.col, op="and", left=left, right=right)
        return left

    def parse_not(self) -> Expr:
        tok = self.match(TokenType.NOT)
        if tok:
            return UnaryOp(line=tok.line, col=tok.col, op="not", operand=self.parse_not())
        return self.parse_comparison()

    def parse_comparison(self) -> Expr:
        left = self.parse_range()
        comp_types = (TokenType.EQ, TokenType.NE, TokenType.LT, TokenType.LE, TokenType.GT, TokenType.GE)
        while True:
            tok = self.match(*comp_types)
            if not tok:
                break
            right = self.parse_range()
            left = BinOp(line=left.line, col=left.col, op=tok.value, left=left, right=right)
        return left

    def parse_range(self) -> Expr:
        left = self.parse_bitor()
        tok = self.match(TokenType.RANGE, TokenType.RANGE_INC)
        if tok:
            right = self.parse_bitor()
            return RangeExpr(
                line=left.line,
                col=left.col,
                start=left,
                stop=right,
                step=IntLit(line=left.line, col=left.col, value=1),
                inclusive=(tok.type == TokenType.RANGE_INC),
            )
        return left

    def parse_bitor(self) -> Expr:
        left = self.parse_bitxor()
        while self.match(TokenType.PIPE):
            right = self.parse_bitxor()
            left = BinOp(line=left.line, col=left.col, op="|", left=left, right=right)
        return left

    def parse_bitxor(self) -> Expr:
        left = self.parse_bitand()
        while self.match(TokenType.CARET):
            right = self.parse_bitand()
            left = BinOp(line=left.line, col=left.col, op="^", left=left, right=right)
        return left

    def parse_bitand(self) -> Expr:
        left = self.parse_shift()
        while self.match(TokenType.AMP):
            right = self.parse_shift()
            left = BinOp(line=left.line, col=left.col, op="&", left=left, right=right)
        return left

    def parse_shift(self) -> Expr:
        left = self.parse_add()
        while True:
            tok = self.match(TokenType.LSHIFT, TokenType.RSHIFT)
            if not tok:
                break
            right = self.parse_add()
            left = BinOp(line=left.line, col=left.col, op=tok.value, left=left, right=right)
        return left

    def parse_add(self) -> Expr:
        left = self.parse_mul()
        while True:
            tok = self.match(TokenType.PLUS, TokenType.MINUS)
            if not tok:
                break
            right = self.parse_mul()
            left = BinOp(line=left.line, col=left.col, op=tok.value, left=left, right=right)
        return left

    def parse_mul(self) -> Expr:
        left = self.parse_unary()
        while True:
            tok = self.match(TokenType.STAR, TokenType.SLASH, TokenType.DSLASH, TokenType.PERCENT)
            if not tok:
                break
            right = self.parse_unary()
            # Detect `[val] * n` array repetition idiom
            if tok.type == TokenType.STAR and isinstance(left, ArrayLit) and len(left.elements) == 1 and left.repeat_count is None:
                left = ArrayLit(
                    line=left.line,
                    col=left.col,
                    elements=[],
                    repeat_value=left.elements[0],
                    repeat_count=right,
                )
            else:
                left = BinOp(line=left.line, col=left.col, op=tok.value, left=left, right=right)
        return left

    def parse_unary(self) -> Expr:
        tok = self.match(TokenType.MINUS, TokenType.PLUS, TokenType.TILDE)
        if tok:
            operand = self.parse_unary()
            if tok.type == TokenType.PLUS:
                return operand
            return UnaryOp(line=tok.line, col=tok.col, op=tok.value, operand=operand)
        return self.parse_power()

    def parse_power(self) -> Expr:
        left = self.parse_postfix()
        if self.match(TokenType.POW):
            right = self.parse_unary()
            return BinOp(line=left.line, col=left.col, op="**", left=left, right=right)
        return left

    def parse_postfix(self) -> Expr:
        expr = self.parse_primary()
        while True:
            if self.match(TokenType.LPAREN):
                args: List[Expr] = []
                if self.current().type != TokenType.RPAREN:
                    while True:
                        args.append(self.parse_expr())
                        if not self.match(TokenType.COMMA):
                            break
                        if self.current().type == TokenType.RPAREN:
                            break
                self.expect(TokenType.RPAREN, "Expected ')' after arguments")
                if isinstance(expr, Var):
                    expr = Call(line=expr.line, col=expr.col, func=expr.name, args=args)
                elif isinstance(expr, FieldAccess):
                    expr = MethodCall(line=expr.line, col=expr.col, target=expr.target, method=expr.field_name, args=args)
                else:
                    raise ParseError("Expression is not callable", self.current())
            elif self.match(TokenType.LBRACKET):
                start = None
                stop = None
                step = None
                is_slice = False
                if self.current().type == TokenType.COLON:
                    is_slice = True
                    self.pos += 1
                    if self.current().type not in (TokenType.RBRACKET, TokenType.COLON):
                        stop = self.parse_expr()
                    if self.match(TokenType.COLON):
                        if self.current().type != TokenType.RBRACKET:
                            step = self.parse_expr()
                else:
                    first_expr = self.parse_expr()
                    if self.match(TokenType.COLON):
                        is_slice = True
                        start = first_expr
                        if self.current().type not in (TokenType.RBRACKET, TokenType.COLON):
                            stop = self.parse_expr()
                        if self.match(TokenType.COLON):
                            if self.current().type != TokenType.RBRACKET:
                                step = self.parse_expr()
                    else:
                        first_expr = first_expr
                self.expect(TokenType.RBRACKET, "Expected ']' after index or slice")
                if is_slice:
                    expr = SliceExpr(line=expr.line, col=expr.col, target=expr, start=start, stop=stop, step=step)
                else:
                    expr = IndexExpr(line=expr.line, col=expr.col, target=expr, index=first_expr)
            elif self.match(TokenType.DOT):
                field_tok = self.expect(TokenType.IDENT, "Expected field or method name after '.'")
                expr = FieldAccess(line=expr.line, col=expr.col, target=expr, field_name=field_tok.value)
            else:
                break
        return expr

    def parse_primary(self) -> Expr:
        tok = self.current()
        if tok.type == TokenType.INT:
            self.pos += 1
            return IntLit(line=tok.line, col=tok.col, value=int(tok.value))
        if tok.type == TokenType.FLOAT:
            self.pos += 1
            return FloatLit(line=tok.line, col=tok.col, value=float(tok.value))
        if tok.type == TokenType.BOOL:
            self.pos += 1
            return BoolLit(line=tok.line, col=tok.col, value=bool(tok.value))
        if tok.type == TokenType.STRING:
            self.pos += 1
            return StringLit(line=tok.line, col=tok.col, value=str(tok.value))
        if tok.type == TokenType.NONE:
            self.pos += 1
            return IntLit(line=tok.line, col=tok.col, value=0)
        if tok.type == TokenType.IDENT:
            self.pos += 1
            return Var(line=tok.line, col=tok.col, name=str(tok.value))
        if tok.type == TokenType.LPAREN:
            self.pos += 1
            expr = self.parse_expr()
            self.expect(TokenType.RPAREN, "Expected ')'")
            return expr
        if tok.type == TokenType.LBRACKET:
            self.pos += 1
            elems: List[Expr] = []
            if self.current().type != TokenType.RBRACKET:
                while True:
                    elems.append(self.parse_expr())
                    if not self.match(TokenType.COMMA):
                        break
                    if self.current().type == TokenType.RBRACKET:
                        break
            self.expect(TokenType.RBRACKET, "Expected ']'")
            return ArrayLit(line=tok.line, col=tok.col, elements=elems)

        raise ParseError("Unexpected token in expression", tok)
