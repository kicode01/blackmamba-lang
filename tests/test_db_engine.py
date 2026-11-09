"""
Unit tests for TinyTalk Database Engine & Type-Safe ORM (tinytalk.db / bmb db).
Tests connection, Model, Field, Query builder, aggregates, transactions, CLI, and native .tnt.
"""

import os
import sys
import tempfile
import unittest
import argparse
from tinytalk.db import (
    Database,
    Model,
    Field,
    IntegerField,
    TextField,
    RealField,
    BooleanField,
    Query,
    Record,
    RecordSet,
    connect,
    cmd_db,
)
from tinytalk.cli import compile_source_to_mir
from tinytalk.backends.x86_64_jit import NativeJITModule


class TestUser(Model):
    table_name = "test_users"
    id = IntegerField("id", primary_key=True, auto_increment=True)
    username = TextField("username", unique=True, nullable=False)
    role = TextField("role")
    credits = IntegerField("credits", default=100)
    rating = RealField("rating", default=5.0)
    is_active = BooleanField("is_active", default=1)


class TestMambaDatabaseEngine(unittest.TestCase):

    def setUp(self):
        self.db = Database(":memory:")
        self.db.create_tables(TestUser)

    def tearDown(self):
        self.db.close()

    def test_table_creation_and_schema(self):
        tables = self.db.tables()
        self.assertIn("test_users", tables)
        cols = self.db.table_info("test_users")
        col_names = [c["name"] for c in cols]
        self.assertIn("id", col_names)
        self.assertIn("username", col_names)
        self.assertIn("role", col_names)
        self.assertIn("credits", col_names)
        self.assertIn("rating", col_names)
        self.assertIn("is_active", col_names)

    def test_crud_insert_select_update_delete(self):
        # 1. Insert
        uid1 = self.db.table("test_users").insert(username="alice", role="architect", credits=5000, rating=4.95, is_active=1)
        uid2 = self.db.table("test_users").insert(username="bob", role="dev", credits=2500, rating=4.80, is_active=1)
        uid3 = self.db.table("test_users").insert(username="charlie", role="intern", credits=500, rating=4.10, is_active=0)

        self.assertEqual(uid1, 1)
        self.assertEqual(uid2, 2)
        self.assertEqual(uid3, 3)

        # 2. Select All
        all_users = self.db.table("test_users").all()
        self.assertEqual(len(all_users), 3)

        # 3. Filter & First
        alice = self.db.table("test_users").filter("username = ?", "alice").first()
        self.assertIsNotNone(alice)
        self.assertEqual(alice.role, "architect")
        self.assertEqual(alice["credits"], 5000)

        # 4. Update
        affected = self.db.table("test_users").filter("username = ?", "charlie").update(role="junior_dev", credits=1200)
        self.assertEqual(affected, 1)
        charlie = self.db.table("test_users").filter("username = ?", "charlie").first()
        self.assertEqual(charlie.role, "junior_dev")
        self.assertEqual(charlie.credits, 1200)

        # 5. Delete
        del_count = self.db.table("test_users").filter("credits < ?", 2000).delete()
        self.assertEqual(del_count, 1)
        remaining = self.db.table("test_users").count()
        self.assertEqual(remaining, 2)

    def test_query_builder_ordering_and_limits(self):
        self.db.table("test_users").insert(username="u1", role="eng", credits=100)
        self.db.table("test_users").insert(username="u2", role="eng", credits=300)
        self.db.table("test_users").insert(username="u3", role="eng", credits=200)

        ordered = (
            self.db.table("test_users")
            .order_by("credits", "DESC")
            .limit(2)
            .all()
        )
        self.assertEqual(len(ordered), 2)
        self.assertEqual(ordered[0].username, "u2")
        self.assertEqual(ordered[1].username, "u3")

    def test_aggregates_sum_avg_min_max(self):
        self.db.table("test_users").insert(username="dev1", credits=1000, rating=3.0)
        self.db.table("test_users").insert(username="dev2", credits=2000, rating=4.0)
        self.db.table("test_users").insert(username="dev3", credits=3000, rating=5.0)

        q = self.db.table("test_users")
        self.assertEqual(q.count(), 3)
        self.assertEqual(q.sum("credits"), 6000.0)
        self.assertAlmostEqual(q.avg("credits"), 2000.0)
        self.assertEqual(q.min("credits"), 1000)
        self.assertEqual(q.max("credits"), 3000)

    def test_parameterized_sql_injection_immunity(self):
        self.db.table("test_users").insert(username="admin", role="admin")
        # Malicious payload designed to bypass naive WHERE clauses
        evil_payload = "' OR '1'='1"
        res = self.db.table("test_users").filter("username = ?", evil_payload).all()
        self.assertEqual(len(res), 0)

    def test_acid_transactions(self):
        with self.db.transaction():
            self.db.table("test_users").insert(username="tx1", role="eng")
            self.db.table("test_users").insert(username="tx2", role="eng")

        self.assertEqual(self.db.table("test_users").count(), 2)

        # Test rollback on exception
        try:
            with self.db.transaction():
                self.db.table("test_users").insert(username="tx3", role="eng")
                raise RuntimeError("Simulated failure during checkout")
        except RuntimeError:
            pass

        # tx3 should have been rolled back
        self.assertEqual(self.db.table("test_users").count(), 2)

    def test_recordset_representations(self):
        self.db.table("test_users").insert(username="neo", role="chosen_one", credits=9999)
        rs = self.db.table("test_users").all()

        ascii_tbl = rs.to_ascii_table()
        self.assertIn("test_users", self.db.tables())
        self.assertIn("neo", ascii_tbl)
        self.assertIn("chosen_one", ascii_tbl)

        json_str = rs.to_json()
        self.assertIn('"username": "neo"', json_str)

        html_tbl = rs.to_html_table()
        self.assertIn("<table", html_tbl)
        self.assertIn("neo", html_tbl)

    def test_cli_subcommands(self):
        with tempfile.TemporaryDirectory() as tmp_dir:
            db_path = os.path.join(tmp_dir, "app_test.db")

            # 1. bmb db init
            args_init = argparse.Namespace(action="init", path=db_path)
            ret_init = cmd_db(args_init)
            self.assertEqual(ret_init, 0)
            self.assertTrue(os.path.exists(db_path))

            # 2. bmb db query
            args_query = argparse.Namespace(
                action="query",
                file=db_path,
                sql="CREATE TABLE items (id INTEGER, name TEXT);",
            )
            ret_query = cmd_db(args_query)
            self.assertEqual(ret_query, 0)

            # 3. bmb db tables
            args_tables = argparse.Namespace(action="tables", file=db_path)
            ret_tables = cmd_db(args_tables)
            self.assertEqual(ret_tables, 0)

            # 4. bmb db dump
            args_dump = argparse.Namespace(action="dump", file=db_path, table=None, format="json")
            ret_dump = cmd_db(args_dump)
            self.assertEqual(ret_dump, 0)

    def test_native_bmb_database_app(self):
        app_bmb = os.path.join(os.path.dirname(__file__), "..", "examples", "database_app.tnt")
        self.assertTrue(os.path.exists(app_bmb))

        with open(app_bmb, "r", encoding="utf-8") as f:
            src = f.read()

        mir = compile_source_to_mir(src, app_bmb)
        out_buf = []
        jit = NativeJITModule(mir, output_callback=lambda s: out_buf.append(s))
        code = jit.run_main()
        jit.close()

        full_output = "".join(out_buf)
        self.assertEqual(code, 0)
        self.assertIn("BLACK MAMBA HIGH-VELOCITY RELATIONAL DATABASE PIPELINE", full_output)
        self.assertIn("lead_architect", full_output)
        self.assertIn("Total active accounts: 3", full_output)
        self.assertIn('"status": "active"', full_output)


if __name__ == "__main__":
    unittest.main()
