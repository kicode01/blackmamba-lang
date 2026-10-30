"""
Black Mamba (bmb) Package Manager — Command Line Interface.
Implements subcommands: init, add, remove, install, update, list, build, run.
"""

import argparse
import os
import sys
from typing import List, Optional

from .manager import PackageManager


def cmd_pkg_init(args: argparse.Namespace) -> int:
    mgr = PackageManager()
    target_dir = args.directory or os.getcwd()
    manifest = mgr.init_project(target_dir=target_dir, name=args.name, is_lib=args.lib)
    print(f"[bmb pkg] Initialized new Black Mamba package '{manifest.name}' v{manifest.version} at {target_dir}")
    print(f"          Entry point: {manifest.entry}")
    print(f"          Manifest:    mamba.toml")
    return 0


def cmd_pkg_add(args: argparse.Namespace) -> int:
    mgr = PackageManager()
    if not os.path.exists(mgr.manifest_path):
        print(f"Error: No mamba.toml found in {mgr.project_dir}. Run 'bmb pkg init' first.", file=sys.stderr)
        return 1

    try:
        locked = mgr.add_dependency(
            name=args.package,
            git=args.git,
            tag=args.tag,
            branch=args.branch,
            rev=args.rev,
            path=args.path,
            version=args.version,
            registry=getattr(args, "registry", None),
        )
        print(f"[bmb pkg] Added dependency '{locked.name}' ({locked.source}: {locked.version})")
        print(f"          Integrity: {locked.integrity}")
        print(f"          Updated:   mamba.toml and mamba.lock")
        return 0
    except Exception as e:
        print(f"Error adding dependency: {e}", file=sys.stderr)
        return 1


def cmd_pkg_remove(args: argparse.Namespace) -> int:
    mgr = PackageManager()
    if not os.path.exists(mgr.manifest_path):
        print(f"Error: No mamba.toml found in {mgr.project_dir}.", file=sys.stderr)
        return 1

    success = mgr.remove_dependency(args.package)
    if success:
        print(f"[bmb pkg] Removed dependency '{args.package}'")
        return 0
    else:
        print(f"Error: Dependency '{args.package}' not found in mamba.toml.", file=sys.stderr)
        return 1


def cmd_pkg_install(args: argparse.Namespace) -> int:
    mgr = PackageManager()
    if not os.path.exists(mgr.manifest_path):
        print(f"Error: No mamba.toml found in {mgr.project_dir}.", file=sys.stderr)
        return 1

    try:
        lock = mgr.install(frozen=args.frozen)
        print(f"[bmb pkg] Successfully installed {len(lock.packages)} package(s) into .mamba/packages/")
        for pname, p in sorted(lock.packages.items()):
            print(f"          - {pname} v{p.version} ({p.source}) [{p.integrity[:18]}...]")
        return 0
    except Exception as e:
        print(f"Error installing dependencies: {e}", file=sys.stderr)
        return 1


def cmd_pkg_update(args: argparse.Namespace) -> int:
    mgr = PackageManager()
    if not os.path.exists(mgr.manifest_path):
        print(f"Error: No mamba.toml found in {mgr.project_dir}.", file=sys.stderr)
        return 1

    try:
        lock = mgr.update(name=args.package)
        print(f"[bmb pkg] Updated dependencies in mamba.lock ({len(lock.packages)} packages locked)")
        return 0
    except Exception as e:
        print(f"Error updating dependencies: {e}", file=sys.stderr)
        return 1


def cmd_pkg_list(_args: argparse.Namespace) -> int:
    mgr = PackageManager()
    if not os.path.exists(mgr.manifest_path):
        print(f"Error: No mamba.toml found in {mgr.project_dir}.", file=sys.stderr)
        return 1

    records = mgr.list_dependencies()
    if not records:
        print(f"[bmb pkg] No dependencies declared in {mgr.manifest_path}.")
        return 0

    print("=" * 72)
    print(f"BLACK MAMBA PACKAGE DEPENDENCIES ({len(records)} total)")
    print("=" * 72)
    print(f"{'Package':<20} | {'Version':<10} | {'Source':<8} | {'Installed':<10} | {'Integrity'}")
    print("-" * 72)
    for r in records:
        print(f"{r['name']:<20} | {r['version']:<10} | {r['source']:<8} | {r['installed']:<10} | {r['integrity']}")
    print("-" * 72)
    return 0


def cmd_pkg_build(args: argparse.Namespace) -> int:
    mgr = PackageManager()
    if not os.path.exists(mgr.manifest_path):
        print(f"Error: No mamba.toml found in {mgr.project_dir}.", file=sys.stderr)
        return 1

    from .manifest import PackageManifest
    manifest = PackageManifest.load(mgr.manifest_path)
    entry_path = os.path.join(mgr.project_dir, manifest.entry)
    if not os.path.exists(entry_path):
        print(f"Error: Package entry point '{entry_path}' does not exist.", file=sys.stderr)
        return 1

    # Delegate to build command
    from ..cli import cmd_build
    build_args = argparse.Namespace(
        file=entry_path,
        target=args.target or manifest.build_target,
        output=args.output,
        debug=getattr(args, "debug", False),
        base_addr="0x08000000",
    )
    return cmd_build(build_args)


def cmd_pkg_run(args: argparse.Namespace) -> int:
    mgr = PackageManager()
    if not os.path.exists(mgr.manifest_path):
        print(f"Error: No mamba.toml found in {mgr.project_dir}.", file=sys.stderr)
        return 1

    from .manifest import PackageManifest
    manifest = PackageManifest.load(mgr.manifest_path)
    entry_path = os.path.join(mgr.project_dir, manifest.entry)
    if not os.path.exists(entry_path):
        print(f"Error: Package entry point '{entry_path}' does not exist.", file=sys.stderr)
        return 1

    # Delegate to run command
    from ..cli import cmd_run
    run_args = argparse.Namespace(
        file=entry_path,
        stats=args.stats if hasattr(args, "stats") else False,
    )
    return cmd_run(run_args)




def cmd_pkg_publish(args: argparse.Namespace) -> int:
    import json
    import shutil
    import tarfile
    from .manifest import PackageManifest
    from .fetcher import compute_integrity

    mgr = PackageManager()
    if not os.path.exists(mgr.manifest_path):
        print(f"Error: No mamba.toml found in {mgr.project_dir}.", file=sys.stderr)
        return 1

    manifest = PackageManifest.load(mgr.manifest_path)
    pkg_name = manifest.name
    pkg_ver = manifest.version
    print(f"[bmb pkg] Packaging '{pkg_name}' v{pkg_ver} for publication...")

    dist_dir = os.path.join(mgr.project_dir, "dist")
    os.makedirs(dist_dir, exist_ok=True)
    archive_name = f"{pkg_name}-{pkg_ver}.bmbpkg"
    archive_path = os.path.join(dist_dir, archive_name)

    with tarfile.open(archive_path, "w:gz") as tar:
        for item in ["mamba.toml", "src", "README.md", "LICENSE"]:
            src_item = os.path.join(mgr.project_dir, item)
            if os.path.exists(src_item):
                tar.add(src_item, arcname=item)

    integrity = compute_integrity(mgr.project_dir)
    pkg_size = os.path.getsize(archive_path)
    print(f"[bmb pkg] Packaged: {archive_path} ({pkg_size} bytes)")
    print(f"          Integrity: {integrity}")

    reg_path = getattr(args, "registry", None)
    if reg_path:
        if os.path.isdir(reg_path):
            index_file = os.path.join(reg_path, "index.json")
        else:
            index_file = reg_path
            reg_path = os.path.dirname(index_file) or "."

        index_data = {"packages": {}}
        if os.path.exists(index_file):
            try:
                with open(index_file, "r", encoding="utf-8") as f:
                    index_data = json.load(f)
            except Exception:
                pass

        pkgs_map = index_data.get("packages", index_data)
        if pkg_name not in pkgs_map:
            pkgs_map[pkg_name] = {}

        dest_archive = os.path.join(reg_path, archive_name)
        if os.path.abspath(archive_path) != os.path.abspath(dest_archive):
            shutil.copy2(archive_path, dest_archive)

        pkgs_map[pkg_name][pkg_ver] = {
            "version": pkg_ver,
            "archive": archive_name,
            "integrity": integrity,
            "dependencies": list(manifest.dependencies.keys()),
            "description": getattr(manifest, "description", f"{pkg_name} package"),
        }
        index_data["packages"] = pkgs_map
        with open(index_file, "w", encoding="utf-8") as f:
            json.dump(index_data, f, indent=2)
        print(f"[bmb pkg] Published '{pkg_name}' v{pkg_ver} to registry at {index_file}")
    else:
        print(f"[bmb pkg] Publication bundle ready at {archive_path}")

    return 0


def cmd_pkg_server(args: argparse.Namespace) -> int:
    import http.server
    import socketserver
    port = args.port or 8080
    serve_dir = args.directory or os.getcwd()

    class Handler(http.server.SimpleHTTPRequestHandler):
        def __init__(self, *a, **kw):
            super().__init__(*a, directory=serve_dir, **kw)

    print(f"[bmb pkg server] Serving Black Mamba Package Registry on port {port}...")
    print(f"                 Registry root: {os.path.abspath(serve_dir)}")
    print(f"                 Index URL:     http://localhost:{port}/index.json")
    try:
        with socketserver.TCPServer(("", port), Handler) as httpd:
            httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nRegistry server stopped.")
    return 0


def register_pkg_subparsers(subparsers) -> None:
    """Registers `bmb pkg` and its subcommands to the main argument parser."""
    p_pkg = subparsers.add_parser("pkg", help="Manage Black Mamba packages, manifests, and dependencies")
    pkg_sub = p_pkg.add_subparsers(dest="pkg_command")

    # init
    p_init = pkg_sub.add_parser("init", help="Initialize a new package with mamba.toml and src/")
    p_init.add_argument("directory", nargs="?", default=".", help="Target project directory (default: current dir)")
    p_init.add_argument("--name", help="Package name (default: directory name)")
    p_init.add_argument("--lib", action="store_true", help="Create a library package with src/lib.bmb")
    p_init.add_argument("--bin", action="store_true", help="Create an executable package with src/main.bmb (default)")

    # add
    p_add = pkg_sub.add_parser("add", help="Add a new dependency to mamba.toml and mamba.lock")
    p_add.add_argument("package", help="Name of the package")
    p_add.add_argument("--git", help="Git repository URL")
    p_add.add_argument("--tag", help="Git tag")
    p_add.add_argument("--branch", help="Git branch")
    p_add.add_argument("--rev", help="Git commit revision")
    p_add.add_argument("--path", help="Local directory path")
    p_add.add_argument("--version", help="Version requirement constraint")
    p_add.add_argument("--registry", help="JSON package registry index URL or file path")

    # remove
    p_rm = pkg_sub.add_parser("remove", help="Remove a dependency from mamba.toml and mamba.lock")
    p_rm.add_argument("package", help="Name of the package to remove")

    # install
    p_inst = pkg_sub.add_parser("install", help="Install all dependencies into .mamba/packages/")
    p_inst.add_argument("--frozen", action="store_true", help="Require exact hash matches against mamba.lock")

    # update
    p_upd = pkg_sub.add_parser("update", help="Update dependencies to latest matching commits")
    p_upd.add_argument("package", nargs="?", help="Specific package to update (default: all)")

    # list
    pkg_sub.add_parser("list", help="List all declared and installed dependencies")

    # build
    p_bld = pkg_sub.add_parser("build", help="Build package binary from mamba.toml entry point")
    p_bld.add_argument("--target", "-t", help="Target output format (exe, elf, wasm, etc.)")
    p_bld.add_argument("--output", "-o", help="Output file path")
    p_bld.add_argument("--debug", "-g", action="store_true", help="Emit native debug symbols")

    # run
    p_rn = pkg_sub.add_parser("run", help="Run package binary from mamba.toml entry point")
    p_rn.add_argument("--stats", action="store_true", help="Print execution timing statistics")

    # publish
    p_pub = pkg_sub.add_parser("publish", help="Package and publish to a Black Mamba registry")
    p_pub.add_argument("--registry", "-r", help="Registry directory or index.json file path")

    # server
    p_srv = pkg_sub.add_parser("server", help="Host a lightweight local Black Mamba package registry server")
    p_srv.add_argument("--port", "-p", type=int, default=8080, help="Port to listen on (default: 8080)")
    p_srv.add_argument("--directory", "-d", default=".", help="Directory containing packages and index.json")


def handle_pkg_command(args: argparse.Namespace) -> int:
    """Dispatches `bmb pkg` subcommands."""
    cmd = getattr(args, "pkg_command", None)
    if cmd == "init":
        return cmd_pkg_init(args)
    if cmd == "add":
        return cmd_pkg_add(args)
    if cmd == "remove":
        return cmd_pkg_remove(args)
    if cmd == "install":
        return cmd_pkg_install(args)
    if cmd == "update":
        return cmd_pkg_update(args)
    if cmd == "list":
        return cmd_pkg_list(args)
    if cmd == "build":
        return cmd_pkg_build(args)
    if cmd == "run":
        return cmd_pkg_run(args)
    if cmd == "publish":
        return cmd_pkg_publish(args)
    if cmd == "server":
        return cmd_pkg_server(args)

    print("Usage: bmb pkg {init,add,remove,install,update,list,build,run,publish,server} ...", file=sys.stderr)
    return 1
