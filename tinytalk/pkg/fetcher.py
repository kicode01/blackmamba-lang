"""
Black Mamba (bmb) Package Manager — Dependency Fetcher & Integrity Hasher.
Clones Git repositories, resolves local path references, and computes SHA-256 digests.
"""

import hashlib
import json
import os
import shutil
import subprocess
import tarfile
import urllib.request
import zipfile
from typing import Any, Dict, Optional, Tuple

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
        # Skip git metadata or build directories relative to package_dir
        rel_root = os.path.relpath(root, package_dir).replace("\\", "/")
        rel_parts = set(rel_root.split("/")) if rel_root != "." else set()
        if rel_parts & {".git", ".mamba", "build", "__pycache__"}:
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


def _semver_key(v: str) -> Tuple[int, ...]:
    parts = []
    for seg in v.lstrip("v").split("-")[0].split("."):
        try:
            parts.append(int(seg))
        except ValueError:
            parts.append(0)
    return tuple(parts)


def fetch_registry_dependency(
    dep: Dependency,
    base_dir: str,
    vendor_dir: str,
) -> LockedPackage:
    """Resolves, fetches, and SHA-256 verifies a package from a JSON Registry Index."""
    reg_source = dep.registry or os.environ.get("MAMBA_REGISTRY", "")
    if not reg_source:
        raise ValueError(f"No registry index configured for package '{dep.name}'.")

    if reg_source.startswith(("http://", "https://", "file://")):
        with urllib.request.urlopen(reg_source, timeout=15) as resp:
            index_data: Dict[str, Any] = json.loads(resp.read().decode("utf-8"))
        reg_base_dir = base_dir
    else:
        reg_path = reg_source if os.path.isabs(reg_source) else os.path.abspath(os.path.join(base_dir, reg_source))
        if not os.path.exists(reg_path):
            raise FileNotFoundError(f"Registry index not found at: {reg_path}")
        with open(reg_path, "r", encoding="utf-8") as rf:
            index_data = json.load(rf)
        reg_base_dir = os.path.dirname(reg_path)

    pkgs_map = index_data.get("packages", index_data)
    if dep.name not in pkgs_map:
        raise KeyError(f"Package '{dep.name}' not found in registry '{reg_source}'.")

    versions_map = pkgs_map[dep.name]
    if not isinstance(versions_map, dict) or not versions_map:
        raise ValueError(f"Invalid version table for package '{dep.name}' in registry.")

    req_ver = dep.version
    if not req_ver or req_ver in ("*", "latest"):
        resolved_ver = sorted(versions_map.keys(), key=_semver_key)[-1]
    elif req_ver in versions_map:
        resolved_ver = req_ver
    else:
        prefix = req_ver.lstrip("^~=")
        candidates = [v for v in versions_map.keys() if v.startswith(prefix)]
        if not candidates:
            raise KeyError(f"Version '{req_ver}' for package '{dep.name}' not found in registry.")
        resolved_ver = sorted(candidates, key=_semver_key)[-1]

    entry = versions_map[resolved_ver]
    dest_dir = os.path.join(vendor_dir, dep.name)
    if os.path.exists(dest_dir):
        shutil.rmtree(dest_dir, ignore_errors=True)
    os.makedirs(dest_dir, exist_ok=True)

    if "files" in entry and isinstance(entry["files"], dict):
        for rel_file, content in entry["files"].items():
            target_f = os.path.abspath(os.path.join(dest_dir, rel_file))
            if not target_f.startswith(os.path.abspath(dest_dir)):
                raise RuntimeError(f"Unsafe path '{rel_file}' in registry entry for '{dep.name}'.")
            os.makedirs(os.path.dirname(target_f), exist_ok=True)
            with open(target_f, "w", encoding="utf-8") as wf:
                wf.write(str(content))
    elif "archive" in entry:
        arch_src = str(entry["archive"])
        tmp_arch = os.path.join(vendor_dir, f".tmp_{dep.name}_archive")
        if arch_src.startswith(("http://", "https://", "file://")):
            with urllib.request.urlopen(arch_src, timeout=30) as resp, open(tmp_arch, "wb") as af:
                af.write(resp.read())
            arch_file = tmp_arch
        else:
            arch_file = arch_src if os.path.isabs(arch_src) else os.path.abspath(os.path.join(reg_base_dir, arch_src))
        try:
            if arch_src.endswith(".zip") or zipfile.is_zipfile(arch_file):
                with zipfile.ZipFile(arch_file, "r") as zf:
                    zf.extractall(dest_dir)
            else:
                with tarfile.open(arch_file, "r:*") as tf:
                    tf.extractall(dest_dir)
        finally:
            if os.path.exists(tmp_arch):
                os.remove(tmp_arch)
    elif "path" in entry:
        pkg_src = str(entry["path"])
        resolved_pkg_src = pkg_src if os.path.isabs(pkg_src) else os.path.abspath(os.path.join(reg_base_dir, pkg_src))
        copy_package_files(resolved_pkg_src, dest_dir)
    elif "git" in entry:
        sub_dep = Dependency(
            name=dep.name,
            version=resolved_ver,
            git=entry["git"],
            tag=entry.get("tag"),
            branch=entry.get("branch"),
            rev=entry.get("rev"),
        )
        locked_git = fetch_git_dependency(sub_dep, vendor_dir)
        locked_git.source = "registry"
        return locked_git
    else:
        raise ValueError(f"Registry entry for '{dep.name}@{resolved_ver}' lacks 'path', 'archive', 'files', or 'git'.")

    integrity = compute_integrity(dest_dir)
    expected_integrity = entry.get("integrity")
    if expected_integrity and expected_integrity != integrity:
        shutil.rmtree(dest_dir, ignore_errors=True)
        raise RuntimeError(
            f"Registry cryptographic integrity mismatch for '{dep.name}@{resolved_ver}'!\n"
            f"  Expected: {expected_integrity}\n"
            f"  Actual:   {integrity}"
        )

    transitive_deps = list(entry.get("dependencies", []))
    dep_manifest_path = os.path.join(dest_dir, "mamba.toml")
    if os.path.exists(dep_manifest_path):
        try:
            m = PackageManifest.load(dep_manifest_path)
            transitive_deps = list(m.dependencies.keys())
        except Exception:
            pass

    return LockedPackage(
        name=dep.name,
        version=resolved_ver,
        source="registry",
        url=reg_source,
        integrity=integrity,
        dependencies=transitive_deps,
    )
