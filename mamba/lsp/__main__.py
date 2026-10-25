"""
CLI entry point for Black Mamba Language Server: `python -m mamba.lsp`.
"""

import argparse
import sys
from .server import run_stdio_server, run_tcp_server


def main():
    parser = argparse.ArgumentParser(
        prog="bmb-lsp",
        description="Black Mamba Language Server Protocol (LSP 3.17) Daemon",
    )
    parser.add_argument(
        "--stdio",
        action="store_true",
        default=True,
        help="Run language server over standard input/output (default)",
    )
    parser.add_argument(
        "--tcp",
        type=int,
        metavar="PORT",
        help="Run language server over a TCP socket listening on PORT",
    )
    parser.add_argument(
        "--host",
        type=str,
        default="127.0.0.1",
        help="TCP host to bind to (default: 127.0.0.1)",
    )

    args = parser.parse_args()

    if args.tcp:
        sys.exit(run_tcp_server(host=args.host, port=args.tcp))
    else:
        sys.exit(run_stdio_server())


if __name__ == "__main__":
    main()
