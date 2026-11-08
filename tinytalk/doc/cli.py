"""
Black Mamba (bmb) Documentation Generator — Command Line Interface.
Implements `bmb doc [file_or_dir] [-o output_dir] [--open]`.
"""

import argparse
import os
import sys
import webbrowser

from .generator import DocGenerator


def cmd_doc(args: argparse.Namespace) -> int:
    target = getattr(args, "target", ".") or "."
    output_dir = getattr(args, "output", None) or "build/docs"

    gen = DocGenerator(output_dir=output_dir)

    try:
        if os.path.isfile(target):
            out_path = gen.generate_file(target)
        elif os.path.isdir(target):
            out_path = gen.generate_package(target)
        else:
            print(f"Error: Target path '{target}' not found.", file=sys.stderr)
            return 1

        print(f"[bmb doc] Generated static HTML documentation -> {out_path}")

        if getattr(args, "open_browser", False):
            print(f"[bmb doc] Opening in default web browser...")
            webbrowser.open(f"file:///{os.path.abspath(out_path).replace(os.sep, '/')}")

        return 0
    except Exception as e:
        print(f"Error generating documentation: {e}", file=sys.stderr)
        return 1
