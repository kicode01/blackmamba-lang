"""
Black Mamba (bmb) Package Manager — Dependency Fetcher & Integrity Hasher.
Clones Git repositories, resolves local path references, and computes SHA-256 digests.
"""

import hashlib
import os
import shutil
import subprocess
from typing import Optional, Tuple

from .lock import LockedPackage
from .manifest import Dependency, PackageManifest


def compute_integrity(package_dir: str) -> str:
    """
    Computes a deterministic SHA-256 hash across all source files in a package.
    Normalizes path separators to forward slashes for cross-platform reproducibility.
    """
    hasher = hashlib.sha256()
    valid_exts = (".bmb", ".toml", ".md", ".txt", ".c", ".h", ".wat")

    for root, _, files in os.walk(package_dir):
        # Skip git metadata or build directories
        if ".git" in root or ".mamba" in root or "build" in root or "__pycache__" in root:
            continue
        for fname in sorted(files):
            if fname.endswith(valid_exts) or fname in ("LICENSE", "README"):
                fpath = os.path.join(root, fname)
                rel_path = os.path.relpath(fpath, package_dir).replace("\\", "/")
                hasher.update(rel_path.encode("utf-8"))
                try:
                    with open(fpath, "rb") as f:
                        hasher.update(f.read())
                except Exception:
                    pass

    return f"sha256-{hasher.hexdigest()}"


def copy_package_files(src_dir: str, dst_dir: str) -> None:
    """Copies package files into vendor directory, excluding VCS metadata."""
    if os.path.exists(dst_dir):
        shutil.rmtree(dst_dir, ignore_errors=True)
    os.makedirs(dst_dir, exist_ok=True)

    for item in os.listdir(src_dir):
        if item in (".git", ".mamba", "build", "__pycache__"):
            continue
        s = os.path.join(src_dir, item)
        d = os.path.join(dst_dir, item)
        if os.path.isdir(s):
            shutil.copytree(s, d, ignore=shutil.ignore_patterns(".git", "__pycache__", "build"))
        else:
            shutil.copy2(s, d)


def fetch_path_dependency(
    dep: Dependency,
    base_dir: str,
    vendor_dir: str,
) -> LockedPackage:
    """Resolves and vendors a local filesystem path dependency."""
    assert dep.path is not None
    resolved_path = os.path.abspath(os.path.join(base_dir, dep.path))
    if not os.path.exists(resolved_path):
        raise FileNotFoundError(f"Path dependency '{dep.name}' not found at: {resolved_path}")

    # Check for mamba.toml in dependency
    dep_manifest_path = os.path.join(resolved_path, "mamba.toml")
    version = dep.version or "0.1.0"
    transitive_deps = []
    if os.path.exists(dep_manifest_path):
        try:
            m = PackageManifest.load(dep_manifest_path)
            version = m.version
            transitive_deps = list(m.dependencies.keys())
        except Exception:
            pass

    # Copy to vendor directory .mamba/packages/<name>
    dest_dir = os.path.join(vendor_dir, dep.name)
    copy_package_files(resolved_path, dest_dir)

    integrity = compute_integrity(dest_dir)
    return LockedPackage(
        name=dep.name,
        version=version,
        source="path",
        path=dep.path,
        integrity=integrity,
        dependencies=transitive_deps,
    )


def fetch_git_dependency(
    dep: Dependency,
    vendor_dir: str,
) -> LockedPackage:
    """Clones a remote git dependency, checks out the specified ref, and records commit."""
    assert dep.git is not None
    dest_dir = os.path.join(vendor_dir, dep.name)

    if os.path.exists(dest_dir):
        shutil.rmtree(dest_dir, ignore_errors=True)
    os.makedirs(dest_dir, exist_ok=True)

    # 1. Clone repository
    clone_cmd = ["git", "clone", "--depth", "1", dep.git, dest_dir]
    ref = dep.tag or dep.branch or dep.rev
    if ref and not dep.rev:
        clone_cmd = ["git", "clone", "--depth", "1", "--branch", ref, dep.git, dest_dir]

    res = subprocess.run(clone_cmd, capture_output=True, text=True)
    if res.returncode != 0:
        # Fallback to full clone if shallow branch clone fails
        fallback_cmd = ["git", "clone", dep.git, dest_dir]
        res = subprocess.run(fallback_cmd, capture_output=True, text=True)
        if res.returncode != 0:
            raise RuntimeError(f"Failed to clone git dependency '{dep.name}' from {dep.git}:\n{res.stderr}")

    # 2. Checkout specific revision if requested
    if dep.rev:
        checkout_res = subprocess.run(["git", "checkout", dep.rev], cwd=dest_dir, capture_output=True, text=True)
        if checkout_res.returncode != 0:
            raise RuntimeError(f"Failed to checkout revision '{dep.rev}' for '{dep.name}':\n{checkout_res.stderr}")

    # 3. Query resolved commit hash
    rev_res = subprocess.run(["git", "rev-parse", "HEAD"], cwd=dest_dir, capture_output=True, text=True)
    commit = rev_res.stdout.strip() if rev_res.returncode == 0 else ""

    # 4. Check for dependency mamba.toml
    dep_manifest_path = os.path.join(dest_dir, "mamba.toml")
    version = dep.version or "0.1.0"
    transitive_deps = []
    if os.path.exists(dep_manifest_path):
        try:
            m = PackageManifest.load(dep_manifest_path)
            version = m.version
            transitive_deps = list(m.dependencies.keys())
        except Exception:
            pass

    # Clean out internal .git folder from vendor to prevent git submodules conflicts
    git_dir = os.path.join(dest_dir, ".git")
    if os.path.exists(git_dir):
        # On Windows git objects can have read-only bits
        def _on_rm_error(func, path, exc_info):
            os.chmod(path, 0o777)
            func(path)
        shutil.rmtree(git_dir, onerror=_on_rm_error)

    integrity = compute_integrity(dest_dir)
    return LockedPackage(
        name=dep.name,
        version=version,
        source="git",
        url=dep.git,
        ref=ref,
        commit=commit,
        integrity=integrity,
        dependencies=transitive_deps,
    )
