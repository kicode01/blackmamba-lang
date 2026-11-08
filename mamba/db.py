"""
Black Mamba (mamba / bmb) — Full-Stack Database Engine & Type-Safe ORM (mamba.db).

Provides:
  1. High-Performance SQLite3 Connection Engine (file and in-memory).
  2. Type-Safe Field and Model Declarations.
  3. Fluent, Chainable Query Builder with parameterized SQL injection immunity.
  4. Aggregate Analytics (COUNT, SUM, AVG, MIN, MAX).
  5. Automatic Table Creation and Schema Migrations.
  6. Transaction Context Management (ACID: BEGIN, COMMIT, ROLLBACK).
  7. Seamless Integration with `mamba.web` (RecordSet -> HTML table).
  8. `bmb db` CLI commands (init, query, tables, dump).
"""

import os
import sys
import json
import sqlite3
import argparse
from typing import Any, Callable, Dict, List, Optional, Tuple, Type, Union


# ==============================================================================
# 1. Field & Schema Definitions
# ==============================================================================

class Field:
    """Type-safe column field definition for database models."""

    def __init__(
        self,
        name: str = "",
        field_type: str = "TEXT",
        primary_key: bool = False,
        auto_increment: bool = False,
        nullable: bool = True,
        default: Any = None,
        unique: bool = False,
    ):
        self.name = name
        self.field_type = field_type.upper()
        self.primary_key = primary_key
        self.auto_increment = auto_increment
        self.nullable = nullable
        self.default = default
        self.unique = unique

    def to_sql_def(self) -> str:
        parts = [self.name, self.field_type]
        if self.primary_key:
            parts.append("PRIMARY KEY")
            if self.auto_increment and self.field_type == "INTEGER":
                parts.append("AUTOINCREMENT")
        if not self.nullable and not self.primary_key:
            parts.append("NOT NULL")
        if self.unique and not self.primary_key:
            parts.append("UNIQUE")
        if self.default is not None:
            if isinstance(self.default, str):
                parts.append(f"DEFAULT '{self.default}'")
            else:
                parts.append(f"DEFAULT {self.default}")
        return " ".join(parts)


# Type Aliases / Factory Helpers
def IntegerField(name: str = "", primary_key: bool = False, auto_increment: bool = False, **kwargs) -> Field:
    return Field(name, "INTEGER", primary_key=primary_key, auto_increment=auto_increment, **kwargs)

def TextField(name: str = "", unique: bool = False, nullable: bool = True, **kwargs) -> Field:
    return Field(name, "TEXT", unique=unique, nullable=nullable, **kwargs)

def RealField(name: str = "", default: Any = 0.0, **kwargs) -> Field:
    return Field(name, "REAL", default=default, **kwargs)

def BooleanField(name: str = "", default: int = 0, **kwargs) -> Field:
    return Field(name, "INTEGER", default=default, **kwargs)


# ==============================================================================
# 2. Record & RecordSet (Query Results)
# ==============================================================================

class Record:
    """Dynamic, dict-like and attribute-accessible database row object."""

    def __init__(self, data: Dict[str, Any]):
        self._data = data
        for k, v in data.items():
            setattr(self, k, v)

    def __getitem__(self, key: str) -> Any:
        return self._data[key]

    def __setitem__(self, key: str, value: Any):
        self._data[key] = value
        setattr(self, key, value)

    def __contains__(self, key: str) -> bool:
        return key in self._data

    def get(self, key: str, default: Any = None) -> Any:
        return self._data.get(key, default)

    def keys(self):
        return self._data.keys()

    def values(self):
        return self._data.values()

    def items(self):
        return self._data.items()

    def to_dict(self) -> Dict[str, Any]:
        return dict(self._data)

    def to_json(self) -> str:
        return json.dumps(self._data, default=str)

    def __repr__(self) -> str:
        fields = ", ".join(f"{k}={v!r}" for k, v in self._data.items())
        return f"Record({fields})"


class RecordSet(list):
    """List of Record instances with convenient analytical & format helpers."""

    def first(self) -> Optional[Record]:
        return self[0] if len(self) > 0 else None

    def last(self) -> Optional[Record]:
        return self[-1] if len(self) > 0 else None

    def to_list(self) -> List[Dict[str, Any]]:
        return [r.to_dict() for r in self]

    def to_json(self, indent: int = 2) -> str:
        return json.dumps(self.to_list(), indent=indent, default=str)

    def to_ascii_table(self) -> str:
        if not self:
            return "(Empty RecordSet)"
        cols = list(self[0].keys())
        widths = {c: len(c) for c in cols}
        for r in self:
            for c in cols:
                val_str = str(r.get(c, ""))
                if len(val_str) > widths[c]:
                    widths[c] = len(val_str)

        # Build border
        border = "+" + "+".join("-" * (widths[c] + 2) for c in cols) + "+"
        header = "|" + "|".join(f" {c.ljust(widths[c])} " for c in cols) + "|"
        rows = []
        for r in self:
            row_str = "|" + "|".join(f" {str(r.get(c, '')).ljust(widths[c])} " for c in cols) + "|"
            rows.append(row_str)

        return "\n".join([border, header, border] + rows + [border])

    def to_html_table(self, style_class: str = "mamba-db-table") -> str:
        """Render directly into HTML5 table markup for mamba.web."""
        if not self:
            return "<div class='mamba-db-empty'>No records found.</div>"
        cols = list(self[0].keys())
        th_elems = "".join(f"<th style='padding:10px 14px;border-bottom:2px solid #334155;text-align:left;color:#94a3b8;'>{c}</th>" for c in cols)
        tr_rows = []
        for r in self:
            tds = "".join(f"<td style='padding:10px 14px;border-bottom:1px solid #1e293b;color:#f8fafc;'>{r.get(c, '')}</td>" for c in cols)
            tr_rows.append(f"<tr style='background:rgba(255,255,255,0.01);'>{tds}</tr>")
        return (
            f"<table class='{style_class}' style='width:100%;border-collapse:collapse;font-family:monospace;font-size:14px;'>"
            f"<thead><tr style='background:#0f172a;'>{th_elems}</tr></thead>"
            f"<tbody>{''.join(tr_rows)}</tbody>"
            f"</table>"
        )


# ==============================================================================
# 3. Model Base Class
# ==============================================================================

class Model:
    """Declarative ORM Model base class."""
    table_name: str = ""

    @classmethod
    def _get_fields(cls) -> Dict[str, Field]:
        fields = {}
        for attr_name, attr_val in cls.__dict__.items():
            if isinstance(attr_val, Field):
                if not attr_val.name:
                    attr_val.name = attr_name
                fields[attr_name] = attr_val
        return fields

    @classmethod
    def create_table_sql(cls) -> str:
        tname = cls.table_name or cls.__name__.lower() + "s"
        fields = cls._get_fields()
        col_defs = [f.to_sql_def() for f in fields.values()]
        return f"CREATE TABLE IF NOT EXISTS {tname} (\n  " + ",\n  ".join(col_defs) + "\n);"


# ==============================================================================
# 4. Fluent Query Builder
# ==============================================================================

class Query:
    """Chainable fluent query builder for SQL execution."""

    def __init__(self, db: "Database", table: str, model_cls: Optional[Type[Model]] = None):
        self.db = db
        self.table = table
        self.model_cls = model_cls
        self._select_cols: List[str] = ["*"]
        self._where_clauses: List[str] = []
        self._where_params: List[Any] = []
        self._order_by_clauses: List[str] = []
        self._limit_val: Optional[int] = None
        self._offset_val: Optional[int] = None
        self._group_by_cols: List[str] = []
        self._having_clauses: List[str] = []
        self._having_params: List[Any] = []
        self._joins: List[str] = []

    def select(self, *cols: str) -> "Query":
        if cols:
            self._select_cols = list(cols)
        return self

    def where(self, condition: str, *params: Any) -> "Query":
        self._where_clauses.append(condition)
        self._where_params.extend(params)
        return self

    def filter(self, condition: str, *params: Any) -> "Query":
        """Alias for where() for Pythonic ORM idiom."""
        return self.where(condition, *params)

    def or_where(self, condition: str, *params: Any) -> "Query":
        if not self._where_clauses:
            return self.where(condition, *params)
        prev = self._where_clauses.pop()
        combined = f"({prev} OR {condition})"
        self._where_clauses.append(combined)
        self._where_params.extend(params)
        return self

    def order_by(self, col: str, direction: str = "ASC") -> "Query":
        clean_dir = "DESC" if direction.upper().startswith("DESC") else "ASC"
        self._order_by_clauses.append(f"{col} {clean_dir}")
        return self

    def limit(self, count: int) -> "Query":
        self._limit_val = count
        return self

    def offset(self, count: int) -> "Query":
        self._offset_val = count
        return self

    def join(self, other_table: str, on_clause: str, join_type: str = "INNER") -> "Query":
        self._joins.append(f"{join_type.upper()} JOIN {other_table} ON {on_clause}")
        return self

    def group_by(self, *cols: str) -> "Query":
        self._group_by_cols.extend(cols)
        return self

    def having(self, condition: str, *params: Any) -> "Query":
        self._having_clauses.append(condition)
        self._having_params.extend(params)
        return self

    def to_sql(self) -> Tuple[str, Tuple[Any, ...]]:
        cols_str = ", ".join(self._select_cols)
        sql = f"SELECT {cols_str} FROM {self.table}"
        if self._joins:
            sql += " " + " ".join(self._joins)
        if self._where_clauses:
            sql += " WHERE " + " AND ".join(self._where_clauses)
        if self._group_by_cols:
            sql += " GROUP BY " + ", ".join(self._group_by_cols)
        if self._having_clauses:
            sql += " HAVING " + " AND ".join(self._having_clauses)
        if self._order_by_clauses:
            sql += " ORDER BY " + ", ".join(self._order_by_clauses)
        if self._limit_val is not None:
            sql += f" LIMIT {self._limit_val}"
        if self._offset_val is not None:
            sql += f" OFFSET {self._offset_val}"

        params = tuple(self._where_params + self._having_params)
        return sql, params

    def all(self) -> RecordSet:
        sql, params = self.to_sql()
        rows = self.db.fetchall(sql, params)
        records = [Record(r) for r in rows]
        return RecordSet(records)

    def first(self) -> Optional[Record]:
        saved_limit = self._limit_val
        self._limit_val = 1
        res = self.all()
        self._limit_val = saved_limit
        return res.first()

    def count(self) -> int:
        old_cols = self._select_cols
        self._select_cols = ["COUNT(*) as count"]
        sql, params = self.to_sql()
        self._select_cols = old_cols
        row = self.db.fetchone(sql, params)
        return int(row["count"]) if row else 0

    def sum(self, col: str) -> float:
        old_cols = self._select_cols
        self._select_cols = [f"SUM({col}) as sum_val"]
        sql, params = self.to_sql()
        self._select_cols = old_cols
        row = self.db.fetchone(sql, params)
        return float(row["sum_val"] or 0.0) if row else 0.0

    def avg(self, col: str) -> float:
        old_cols = self._select_cols
        self._select_cols = [f"AVG({col}) as avg_val"]
        sql, params = self.to_sql()
        self._select_cols = old_cols
        row = self.db.fetchone(sql, params)
        return float(row["avg_val"] or 0.0) if row else 0.0

    def min(self, col: str) -> Any:
        old_cols = self._select_cols
        self._select_cols = [f"MIN({col}) as min_val"]
        sql, params = self.to_sql()
        self._select_cols = old_cols
        row = self.db.fetchone(sql, params)
        return row["min_val"] if row else None

    def max(self, col: str) -> Any:
        old_cols = self._select_cols
        self._select_cols = [f"MAX({col}) as max_val"]
        sql, params = self.to_sql()
        self._select_cols = old_cols
        row = self.db.fetchone(sql, params)
        return row["max_val"] if row else None

    def insert(self, **data: Any) -> int:
        """Insert a row and return the newly generated primary key (lastrowid)."""
        keys = list(data.keys())
        placeholders = ["?"] * len(keys)
        sql = f"INSERT INTO {self.table} ({', '.join(keys)}) VALUES ({', '.join(placeholders)})"
        params = tuple(data[k] for k in keys)
        cursor = self.db.execute(sql, params)
        return cursor.lastrowid

    def bulk_insert(self, records: List[Dict[str, Any]]) -> int:
        """Insert multiple rows in a single batch statement."""
        if not records:
            return 0
        keys = list(records[0].keys())
        placeholders = ["?"] * len(keys)
        sql = f"INSERT INTO {self.table} ({', '.join(keys)}) VALUES ({', '.join(placeholders)})"
        param_rows = [tuple(r.get(k, None) for k in keys) for r in records]
        cursor = self.db.cursor()
        cursor.executemany(sql, param_rows)
        self.db.commit()
        return len(records)

    def update(self, **data: Any) -> int:
        """Update matching rows and return the number of affected rows."""
        set_clauses = [f"{k} = ?" for k in data.keys()]
        sql = f"UPDATE {self.table} SET {', '.join(set_clauses)}"
        params = list(data.values())
        if self._where_clauses:
            sql += " WHERE " + " AND ".join(self._where_clauses)
            params.extend(self._where_params)
        cursor = self.db.execute(sql, tuple(params))
        return cursor.rowcount

    def delete(self) -> int:
        """Delete matching rows and return the number of affected rows."""
        sql = f"DELETE FROM {self.table}"
        if self._where_clauses:
            sql += " WHERE " + " AND ".join(self._where_clauses)
        cursor = self.db.execute(sql, tuple(self._where_params))
        return cursor.rowcount


# ==============================================================================
# 5. Database Connection Engine
# ==============================================================================

class Database:
    """High-velocity SQLite database connection and transaction manager."""

    def __init__(self, path: str = ":memory:", wal_mode: bool = True):
        self.path = path
        self.wal_mode = wal_mode
        self._conn: Optional[sqlite3.Connection] = None
        self._in_transaction: bool = False
        self.connect()

    def connect(self) -> sqlite3.Connection:
        if self._conn is None:
            if self.path != ":memory:":
                parent = os.path.dirname(os.path.abspath(self.path))
                if parent:
                    os.makedirs(parent, exist_ok=True)
            self._conn = sqlite3.connect(self.path)
            self._conn.row_factory = sqlite3.Row
            if self.wal_mode and self.path != ":memory:":
                self._conn.execute("PRAGMA journal_mode=WAL;")
                self._conn.execute("PRAGMA synchronous=NORMAL;")
        return self._conn

    def cursor(self) -> sqlite3.Cursor:
        return self.connect().cursor()

    def execute(self, sql: str, params: Union[tuple, list] = ()) -> sqlite3.Cursor:
        cur = self.connect().cursor()
        cur.execute(sql, params)
        if not self._in_transaction:
            self._conn.commit()
        return cur

    def executescript(self, sql_script: str) -> None:
        self.connect().executescript(sql_script)
        if not self._in_transaction:
            self._conn.commit()

    def fetchall(self, sql: str, params: Union[tuple, list] = ()) -> List[Dict[str, Any]]:
        cur = self.execute(sql, params)
        rows = cur.fetchall()
        return [dict(r) for r in rows]

    def fetchone(self, sql: str, params: Union[tuple, list] = ()) -> Optional[Dict[str, Any]]:
        cur = self.execute(sql, params)
        row = cur.fetchone()
        return dict(row) if row else None

    def begin(self) -> None:
        self.connect().execute("BEGIN TRANSACTION;")
        self._in_transaction = True

    def commit(self) -> None:
        self.connect().commit()
        self._in_transaction = False

    def rollback(self) -> None:
        self.connect().rollback()
        self._in_transaction = False

    def transaction(self):
        """Context manager for ACID transaction block."""
        db = self

        class TransactionContext:
            def __enter__(self):
                db.begin()
                return db

            def __exit__(self, exc_type, exc_val, exc_tb):
                if exc_type is not None:
                    db.rollback()
                else:
                    db.commit()

        return TransactionContext()

    def table(self, table_name: str) -> Query:
        """Create a Query builder targeting `table_name`."""
        return Query(self, table_name)

    def query(self, target: Union[str, Type[Model]]) -> Query:
        """Create a Query builder targeting a table name or Model class."""
        if isinstance(target, str):
            return Query(self, target)
        elif issubclass(target, Model):
            tname = target.table_name or target.__name__.lower() + "s"
            return Query(self, tname, model_cls=target)
        else:
            raise ValueError(f"Invalid query target: {target}")

    def create_tables(self, *models: Type[Model]) -> None:
        """Execute DDL statements to create tables for specified Models."""
        for m in models:
            sql = m.create_table_sql()
            self.execute(sql)

    def drop_tables(self, *models: Type[Model]) -> None:
        for m in models:
            tname = m.table_name or m.__name__.lower() + "s"
            self.execute(f"DROP TABLE IF EXISTS {tname};")

    def tables(self) -> List[str]:
        rows = self.fetchall("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';")
        return [r["name"] for r in rows]

    def table_info(self, table_name: str) -> List[Dict[str, Any]]:
        return self.fetchall(f"PRAGMA table_info({table_name});")

    def count_table(self, table_name: str) -> int:
        row = self.fetchone(f"SELECT COUNT(*) as cnt FROM {table_name};")
        return int(row["cnt"]) if row else 0

    def dump_schema(self) -> str:
        rows = self.fetchall("SELECT sql FROM sqlite_master WHERE sql IS NOT NULL ORDER BY type DESC, name;")
        return "\n\n".join(r["sql"] + ";" for r in rows)

    def dump_json(self, table_name: Optional[str] = None) -> str:
        result = {}
        target_tables = [table_name] if table_name else self.tables()
        for t in target_tables:
            result[t] = self.fetchall(f"SELECT * FROM {t};")
        return json.dumps(result, indent=2, default=str)

    def close(self) -> None:
        if self._conn:
            self._conn.close()
            self._conn = None


# Module-level convenience functions
def connect(path: str = ":memory:") -> Database:
    return Database(path)


# ==============================================================================
# 6. CLI Command Handler (`bmb db`)
# ==============================================================================

def cmd_db(args: argparse.Namespace) -> int:
    """CLI subcommands for `bmb db` (init, query, tables, dump)."""
    action = getattr(args, "action", "tables")

    if action == "init":
        path = getattr(args, "path", "database.db")
        db = Database(path)
        db.execute("CREATE TABLE IF NOT EXISTS _mamba_meta (key TEXT PRIMARY KEY, value TEXT);")
        db.execute("INSERT OR REPLACE INTO _mamba_meta VALUES ('version', '2.2.0'), ('created_at', datetime('now'));")
        db.close()
        print(f"[Black Mamba DB] Initialized SQLite database -> {path} (WAL Mode Enabled)")
        return 0

    db_path = getattr(args, "file", None)
    if not db_path:
        print("Error: Database file path required.", file=sys.stderr)
        return 1

    if not os.path.exists(db_path):
        print(f"Error: Database file not found: {db_path}", file=sys.stderr)
        return 1

    db = Database(db_path)
    try:
        if action == "query":
            sql = getattr(args, "sql", "")
            if not sql:
                print("Error: SQL query statement required.", file=sys.stderr)
                return 1
            try:
                if sql.strip().upper().startswith("SELECT") or sql.strip().upper().startswith("PRAGMA"):
                    res = RecordSet([Record(r) for r in db.fetchall(sql)])
                    print(res.to_ascii_table())
                    print(f"\n({len(res)} row{'s' if len(res) != 1 else ''} returned)")
                else:
                    cur = db.execute(sql)
                    print(f"[Black Mamba DB] Query executed successfully. Affected rows: {cur.rowcount}")
            except Exception as e:
                print(f"[Black Mamba DB Error] {e}", file=sys.stderr)
                return 1
            return 0

        elif action == "tables":
            tbls = db.tables()
            if not tbls:
                print(f"[Black Mamba DB] No user tables found in '{db_path}'.")
                return 0
            records = []
            for t in tbls:
                cnt = db.count_table(t)
                cols = db.table_info(t)
                col_summary = ", ".join(f"{c['name']} ({c['type']})" for c in cols)
                records.append(Record({"table": t, "rows": cnt, "columns": len(cols), "schema": col_summary}))
            print(f"[Black Mamba DB] Tables in '{db_path}':")
            print(RecordSet(records).to_ascii_table())
            return 0

        elif action == "dump":
            tbl = getattr(args, "table", None)
            fmt = getattr(args, "format", "json")
            if fmt == "sql":
                print(db.dump_schema())
            else:
                print(db.dump_json(tbl))
            return 0

        return 0
    finally:
        db.close()
