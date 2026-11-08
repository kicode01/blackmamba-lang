"""
Black Mamba (bmb) Package Manager Package.
Provides decentralized package manifest management, git dependency fetching,
cryptographic lockfiles, and project initialization.
"""

from .fetcher import compute_integrity
from .lock import LockedPackage, PackageLock
from .manager import PackageManager
from .manifest import Dependency, PackageManifest

__all__ = [
    "PackageManager",
    "PackageManifest",
    "PackageLock",
    "LockedPackage",
    "Dependency",
    "compute_integrity",
]
