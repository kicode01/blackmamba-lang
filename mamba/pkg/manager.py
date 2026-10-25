"""
Black Mamba (bmb) Package Manager — Core Engine.
Coordinates project initialization, dependency resolution, lockfile synchronization,
and package building.
"""

import os
import shutil
from typing import Dict, List, Optional

from .fetcher import (
    compute_integrity,
    fetch_git_dependency,
    fetch_path_dependency,
    fetch_registry_dependency,
)
from .lock import LockedPackage, PackageLock
from .manifest import Dependency, PackageManifest


class PackageManager:
    """Manages package lifecycle, manifests, lockfiles, and dependencies."""

    def __init__(self, project_dir: Optional[str] = None):
        self.project_dir = os.path.abspath(project_dir or os.getcwd())
        self.manifest_path = os.path.join(self.project_dir, "mamba.toml")
        self.lock_path = os.path.join(self.project_dir, "mamba.lock")
        self.vendor_dir = os.path.join(self.project_dir, ".mamba", "packages")

    def init_project(
        self,
        target_dir: Optional[str] = None,
        name: Optional[str] = None,
        is_lib: bool = False,
    ) -> PackageManifest:
        """Initializes a new Black Mamba project layout."""
        proj_dir = os.path.abspath(target_dir or self.project_dir)
        os.makedirs(proj_dir, exist_ok=True)

        pkg_name = name or os.path.basename(proj_dir).lower().replace(" ", "-")
        src_dir = os.path.join(proj_dir, "src")
        os.makedirs(src_dir, exist_ok=True)

        entry_file = "src/lib.bmb" if is_lib else "src/main.bmb"
        entry_path = os.path.join(proj_dir, entry_file)

        if not os.path.exists(entry_path):
            with open(entry_path, "w", encoding="utf-8") as f:
                if is_lib:
                    f.write(
                        f"# {pkg_name} — Black Mamba Library Module\n\n"
                        "fn add(a: i64, b: i64) -> i64:\n"
                        "    return a + b\n"
                    )
                else:
                    f.write(
                        f"# {pkg_name} — Black Mamba Application\n\n"
                        "fn main() -> i64:\n"
                        f'    print("Hello from {pkg_name}!")\n'
                        "    return 0\n"
                    )

        # Generate mamba.toml
        manifest = PackageManifest(
            name=pkg_name,
            version="0.1.0",
            description=f"A Black Mamba {'library' if is_lib else 'application'}",
            entry=entry_file,
            build_target="exe",
            opt_level="speed",
        )
        manifest_file = os.path.join(proj_dir, "mamba.toml")
        manifest.save(manifest_file)

        # Generate .gitignore
        gitignore_path = os.path.join(proj_dir, ".gitignore")
        if not os.path.exists(gitignore_path):
            with open(gitignore_path, "w", encoding="utf-8") as f:
                f.write("build/\n.mamba/\n*.exe\n*.wasm\n*.wat\n*.ll\n")

        return manifest

    def add_dependency(
        self,
        name: str,
        git: Optional[str] = None,
        tag: Optional[str] = None,
        branch: Optional[str] = None,
        rev: Optional[str] = None,
        path: Optional[str] = None,
        version: Optional[str] = None,
        registry: Optional[str] = None,
    ) -> LockedPackage:
        """Adds a dependency to mamba.toml and resolves it into mamba.lock."""
        manifest = PackageManifest.load(self.manifest_path)
        dep = Dependency(
            name=name,
            git=git,
            tag=tag,
            branch=branch,
            rev=rev,
            path=path,
            version=version,
            registry=registry,
        )

        # Fetch dependency into vendor first (atomic — don't pollute mamba.toml on integrity error)
        os.makedirs(self.vendor_dir, exist_ok=True)
        if dep.path:
            locked = fetch_path_dependency(dep, self.project_dir, self.vendor_dir)
        elif dep.git:
            locked = fetch_git_dependency(dep, self.vendor_dir)
        elif dep.registry or os.environ.get("MAMBA_REGISTRY"):
            locked = fetch_registry_dependency(dep, self.project_dir, self.vendor_dir)
        else:
            # Simple local reference or path
            locked = LockedPackage(name=name, version=version or "0.1.0", source="local")

        manifest.dependencies[name] = dep
        manifest.save(self.manifest_path)

        # Update lockfile
        lock = PackageLock.load(self.lock_path)
        lock.packages[name] = locked
        lock.save(self.lock_path)

        return locked

    def remove_dependency(self, name: str) -> bool:
        """Removes a dependency from mamba.toml, mamba.lock, and vendor directory."""
        if not os.path.exists(self.manifest_path):
            return False

        manifest = PackageManifest.load(self.manifest_path)
        removed = False

        if name in manifest.dependencies:
            del manifest.dependencies[name]
            manifest.save(self.manifest_path)
            removed = True

        if os.path.exists(self.lock_path):
            lock = PackageLock.load(self.lock_path)
            if name in lock.packages:
                del lock.packages[name]
                lock.save(self.lock_path)

        pkg_vendor_dir = os.path.join(self.vendor_dir, name)
        if os.path.exists(pkg_vendor_dir):
            shutil.rmtree(pkg_vendor_dir, ignore_errors=True)

        return removed

    def install(self, frozen: bool = False) -> PackageLock:
        """
        Installs all dependencies declared in mamba.toml.
        If frozen=True, enforces exact match with mamba.lock.
        """
        if not os.path.exists(self.manifest_path):
            raise FileNotFoundError(f"Manifest not found: {self.manifest_path}")

        manifest = PackageManifest.load(self.manifest_path)
        lock = PackageLock.load(self.lock_path) if os.path.exists(self.lock_path) else PackageLock()

        if frozen and not os.path.exists(self.lock_path):
            raise RuntimeError("Flag --frozen specified but mamba.lock does not exist.")

        os.makedirs(self.vendor_dir, exist_ok=True)

        for dep_name, dep in manifest.dependencies.items():
            dest_dir = os.path.join(self.vendor_dir, dep_name)

            # Check if already installed and integrity matches lockfile
            if os.path.exists(dest_dir) and dep_name in lock.packages:
                current_hash = compute_integrity(dest_dir)
                if current_hash == lock.packages[dep_name].integrity:
                    continue

            # Fetch dependency
            if dep.path:
                locked = fetch_path_dependency(dep, self.project_dir, self.vendor_dir)
            elif dep.git:
                locked = fetch_git_dependency(dep, self.vendor_dir)
            elif dep.registry or os.environ.get("MAMBA_REGISTRY"):
                locked = fetch_registry_dependency(dep, self.project_dir, self.vendor_dir)
            else:
                locked = LockedPackage(name=dep_name, version=dep.version or "0.1.0", source="local")

            if frozen and dep_name in lock.packages:
                expected_hash = lock.packages[dep_name].integrity
                if expected_hash and locked.integrity != expected_hash:
                    raise RuntimeError(
                        f"Cryptographic integrity mismatch for package '{dep_name}'!\n"
                        f"  Expected: {expected_hash}\n"
                        f"  Actual:   {locked.integrity}"
                    )

            lock.packages[dep_name] = locked

        lock.save(self.lock_path)
        return lock

    def update(self, name: Optional[str] = None) -> PackageLock:
        """Re-fetches specified or all dependencies and refreshes mamba.lock."""
        if not os.path.exists(self.manifest_path):
            raise FileNotFoundError(f"Manifest not found: {self.manifest_path}")

        manifest = PackageManifest.load(self.manifest_path)
        lock = PackageLock.load(self.lock_path) if os.path.exists(self.lock_path) else PackageLock()

        deps_to_update = [name] if name else list(manifest.dependencies.keys())

        for dep_name in deps_to_update:
            if dep_name not in manifest.dependencies:
                continue
            dep = manifest.dependencies[dep_name]
            if dep.path:
                locked = fetch_path_dependency(dep, self.project_dir, self.vendor_dir)
            elif dep.git:
                locked = fetch_git_dependency(dep, self.vendor_dir)
            elif dep.registry or os.environ.get("MAMBA_REGISTRY"):
                locked = fetch_registry_dependency(dep, self.project_dir, self.vendor_dir)
            else:
                locked = LockedPackage(name=dep_name, version=dep.version or "0.1.0", source="local")
            lock.packages[dep_name] = locked

        lock.save(self.lock_path)
        return lock

    def list_dependencies(self) -> List[Dict[str, str]]:
        """Returns detailed list of installed dependencies and lock state."""
        if not os.path.exists(self.manifest_path):
            return []

        manifest = PackageManifest.load(self.manifest_path)
        lock = PackageLock.load(self.lock_path) if os.path.exists(self.lock_path) else PackageLock()

        records = []
        for dep_name, dep in manifest.dependencies.items():
            locked = lock.packages.get(dep_name)
            vendor_path = os.path.join(self.vendor_dir, dep_name)
            is_installed = os.path.exists(vendor_path)

            records.append({
                "name": dep_name,
                "version": locked.version if locked else (dep.version or "*"),
                "source": locked.source if locked else ("path" if dep.path else ("git" if dep.git else "local")),
                "installed": "yes" if is_installed else "no",
                "integrity": locked.integrity[:16] + "..." if (locked and locked.integrity) else "n/a",
            })
        return records
