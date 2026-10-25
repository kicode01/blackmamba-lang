"""
Black Mamba (bmb) Package Manager — Package Manifest (`mamba.toml`).
Parses, validates, and serializes decentralized package configurations.
"""

import os
from dataclasses import dataclass, field
from typing import Any, Dict, List, Optional

try:
    import tomllib
except ImportError:
    import tomli as tomllib  # type: ignore


@dataclass
class Dependency:
    """Represents a direct or transitive package dependency."""
    name: str
    version: Optional[str] = None
    path: Optional[str] = None
    git: Optional[str] = None
    tag: Optional[str] = None
    branch: Optional[str] = None
    rev: Optional[str] = None
    registry: Optional[str] = None

    def to_dict(self) -> Any:
        # If it's just a simple version string, return string
        if self.version and not (self.path or self.git or self.tag or self.branch or self.rev or self.registry):
            return self.version
        d: Dict[str, Any] = {}
        if self.version:
            d["version"] = self.version
        if self.path:
            d["path"] = self.path
        if self.git:
            d["git"] = self.git
        if self.tag:
            d["tag"] = self.tag
        if self.branch:
            d["branch"] = self.branch
        if self.rev:
            d["rev"] = self.rev
        if self.registry:
            d["registry"] = self.registry
        return d

    @classmethod
    def from_value(cls, name: str, val: Any) -> "Dependency":
        if isinstance(val, str):
            return cls(name=name, version=val)
        if isinstance(val, dict):
            return cls(
                name=name,
                version=val.get("version"),
                path=val.get("path"),
                git=val.get("git"),
                tag=val.get("tag"),
                branch=val.get("branch"),
                rev=val.get("rev"),
                registry=val.get("registry"),
            )
        return cls(name=name)


@dataclass
class PackageManifest:
    """Configuration parsed from a `mamba.toml` manifest file."""
    name: str
    version: str = "0.1.0"
    description: str = ""
    authors: List[str] = field(default_factory=list)
    license: str = "MIT"
    entry: str = "src/main.bmb"
    dependencies: Dict[str, Dependency] = field(default_factory=dict)
    build_target: str = "exe"
    opt_level: str = "speed"

    @classmethod
    def load(cls, file_path: str) -> "PackageManifest":
        """Loads and parses a mamba.toml file."""
        if not os.path.exists(file_path):
            raise FileNotFoundError(f"Manifest not found: {file_path}")
        with open(file_path, "rb") as f:
            data = tomllib.load(f)
        return cls.from_dict(data)

    @classmethod
    def from_dict(cls, data: Dict[str, Any]) -> "PackageManifest":
        pkg = data.get("package", {})
        build = data.get("build", {})
        raw_deps = data.get("dependencies", {})

        deps: Dict[str, Dependency] = {}
        for dep_name, dep_val in raw_deps.items():
            deps[dep_name] = Dependency.from_value(dep_name, dep_val)

        return cls(
            name=pkg.get("name", "unnamed"),
            version=pkg.get("version", "0.1.0"),
            description=pkg.get("description", ""),
            authors=pkg.get("authors", []),
            license=pkg.get("license", "MIT"),
            entry=pkg.get("entry", "src/main.bmb"),
            dependencies=deps,
            build_target=build.get("target", "exe"),
            opt_level=build.get("opt-level", "speed"),
        )

    def to_toml(self) -> str:
        """Serializes manifest to clean TOML text."""
        def _q(val: Any) -> str:
            s = str(val).replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")
            return f'"{s}"'

        lines = []
        lines.append("[package]")
        lines.append(f"name = {_q(self.name)}")
        lines.append(f"version = {_q(self.version)}")
        if self.description:
            lines.append(f"description = {_q(self.description)}")
        if self.authors:
            authors_str = ", ".join(_q(a) for a in self.authors)
            lines.append(f"authors = [{authors_str}]")
        lines.append(f"license = {_q(self.license)}")
        lines.append(f"entry = {_q(self.entry)}")
        lines.append("")

        lines.append("[dependencies]")
        for dname, dep in sorted(self.dependencies.items()):
            val = dep.to_dict()
            if isinstance(val, str):
                lines.append(f"{dname} = {_q(val)}")
            elif isinstance(val, dict):
                parts = []
                for k, v in val.items():
                    parts.append(f"{k} = {_q(v)}")
                lines.append(f"{dname} = {{ {', '.join(parts)} }}")
        lines.append("")

        lines.append("[build]")
        lines.append(f"target = {_q(self.build_target)}")
        lines.append(f"opt-level = {_q(self.opt_level)}")
        lines.append("")

        return "\n".join(lines)

    def save(self, file_path: str) -> None:
        """Saves manifest to disk."""
        with open(file_path, "w", encoding="utf-8") as f:
            f.write(self.to_toml())
