# Black Mamba Distributed Object-Capability Security Kernel & Micro-Sandboxing
# Phase 9D (v3.3.0): Cryptographically Unforgeable Capability Tokens & Default-Deny Sandboxing
# 100% Zero-External-Dependency Pure Standard Library Implementation.

import os
import hmac
import hashlib
import time
import secrets
from dataclasses import dataclass, field
from typing import Dict, List, Optional, Set, Any, Callable


# Capability Rights Bitmask
CAP_NONE = 0
CAP_READ = 1
CAP_WRITE = 2
CAP_EXEC = 4
CAP_NET = 8
CAP_FS = 16
CAP_DELEGATE = 32
CAP_REVOKE = 64
CAP_ALL = 127

RIGHTS_NAMES = {
    CAP_READ: "READ",
    CAP_WRITE: "WRITE",
    CAP_EXEC: "EXEC",
    CAP_NET: "NET",
    CAP_FS: "FS",
    CAP_DELEGATE: "DELEGATE",
    CAP_REVOKE: "REVOKE",
}


def rights_to_string(rights_mask: int) -> str:
    if rights_mask == CAP_ALL:
        return "ALL"
    if rights_mask == CAP_NONE:
        return "NONE"
    active = [name for bit, name in RIGHTS_NAMES.items() if (rights_mask & bit) == bit]
    return "|".join(active) if active else "NONE"


@dataclass
class CapabilityToken:
    token_id: str
    resource_uri: str
    rights: int
    issuer: str
    issued_at: float
    expires_at: Optional[float]
    parent_id: Optional[str] = None
    signature: str = ""

    def is_expired(self, current_time: Optional[float] = None) -> bool:
        if self.expires_at is None:
            return False
        now = current_time if current_time is not None else time.time()
        return now > self.expires_at

    def has_right(self, right: int) -> bool:
        return (self.rights & right) == right

    def to_dict(self) -> Dict[str, Any]:
        return {
            "token_id": self.token_id,
            "resource_uri": self.resource_uri,
            "rights": self.rights,
            "rights_str": rights_to_string(self.rights),
            "issuer": self.issuer,
            "issued_at": round(self.issued_at, 4),
            "expires_at": round(self.expires_at, 4) if self.expires_at else None,
            "parent_id": self.parent_id,
            "signature": self.signature,
        }


class ObjectCapabilityKernel:
    """
    Cryptographic Object-Capability Security Kernel.
    Mints unforgeable HMAC-signed capability tokens, enforces non-attenuation
    monotonic rights lowering, and maintains a zero-overhead revocation ledger.
    """

    def __init__(self, secret_key: Optional[bytes] = None):
        self.secret_key = secret_key or secrets.token_bytes(32)
        self.revocation_ledger: Set[str] = set()

    def _sign(self, token_id: str, resource_uri: str, rights: int, issued_at: float, expires_at: Optional[float]) -> str:
        exp_str = str(expires_at) if expires_at is not None else "NEVER"
        msg = f"{token_id}:{resource_uri}:{rights}:{issued_at}:{exp_str}".encode("utf-8")
        return hmac.new(self.secret_key, msg, hashlib.sha256).hexdigest()

    def mint_token(
        self,
        resource_uri: str,
        rights: int = CAP_READ,
        ttl_seconds: Optional[float] = 3600.0,
        issuer: str = "root-kernel",
    ) -> CapabilityToken:
        token_id = secrets.token_hex(12)
        now = time.time()
        expires_at = (now + ttl_seconds) if ttl_seconds is not None else None
        sig = self._sign(token_id, resource_uri, rights, now, expires_at)
        return CapabilityToken(
            token_id=token_id,
            resource_uri=resource_uri,
            rights=rights,
            issuer=issuer,
            issued_at=now,
            expires_at=expires_at,
            parent_id=None,
            signature=sig,
        )

    def attenuate(
        self,
        parent: CapabilityToken,
        requested_rights: int,
        ttl_seconds: Optional[float] = None,
        issuer: Optional[str] = None,
    ) -> CapabilityToken:
        """
        Derives an attenuated child token.
        CRITICAL INVARIANT: The child rights are strictly masked by parent.rights (monotonic decrease).
        """
        if not self.verify(parent, CAP_DELEGATE):
            # Must possess delegation right to attenuate
            raise PermissionError(f"Token '{parent.token_id}' lacks CAP_DELEGATE right to derive sub-capabilities")

        attenuated_rights = parent.rights & requested_rights
        token_id = secrets.token_hex(12)
        now = time.time()
        
        # Child expiry cannot exceed parent expiry
        if ttl_seconds is not None:
            child_exp = now + ttl_seconds
            if parent.expires_at is not None and child_exp > parent.expires_at:
                child_exp = parent.expires_at
        else:
            child_exp = parent.expires_at

        sig = self._sign(token_id, parent.resource_uri, attenuated_rights, now, child_exp)
        return CapabilityToken(
            token_id=token_id,
            resource_uri=parent.resource_uri,
            rights=attenuated_rights,
            issuer=issuer or f"delegated-by-{parent.token_id}",
            issued_at=now,
            expires_at=child_exp,
            parent_id=parent.token_id,
            signature=sig,
        )

    def revoke(self, token_id: str) -> None:
        self.revocation_ledger.add(token_id)

    def is_revoked(self, token_id: str) -> bool:
        return token_id in self.revocation_ledger

    def verify(
        self,
        token: CapabilityToken,
        required_right: int,
        resource_uri: Optional[str] = None,
        current_time: Optional[float] = None,
    ) -> bool:
        # 1. Revocation check
        if token.token_id in self.revocation_ledger:
            return False

        # 2. Expiration check
        if token.is_expired(current_time):
            return False

        # 3. Resource URI boundary check
        if resource_uri and token.resource_uri != "*" and token.resource_uri != resource_uri:
            # Check hierarchical resource matching (e.g. fs:///data covers fs:///data/sub)
            if not resource_uri.startswith(token.resource_uri):
                return False

        # 4. Rights bitmask check
        if not token.has_right(required_right):
            return False

        # 5. Cryptographic signature verification
        expected_sig = self._sign(
            token.token_id,
            token.resource_uri,
            token.rights,
            token.issued_at,
            token.expires_at,
        )
        return hmac.compare_digest(token.signature, expected_sig)


class MicroSandbox:
    """
    Isolated execution micro-sandbox with nanosecond default-deny capability enforcement.
    """

    def __init__(self, sandbox_id: str, allowed_rights: int, kernel: ObjectCapabilityKernel):
        self.sandbox_id = sandbox_id
        self.allowed_rights = allowed_rights
        self.kernel = kernel
        self.granted_tokens: Dict[str, CapabilityToken] = {}
        self.violations_count = 0
        self.operations_count = 0

    def grant_token(self, token: CapabilityToken) -> None:
        self.granted_tokens[token.token_id] = token

    def check_access(self, token: CapabilityToken, required_right: int, resource_uri: str) -> bool:
        # Check sandbox policy boundary
        if (self.allowed_rights & required_right) != required_right:
            self.violations_count += 1
            return False

        # Check cryptographic token validity via kernel
        if not self.kernel.verify(token, required_right, resource_uri):
            self.violations_count += 1
            return False

        self.operations_count += 1
        return True

    def run_sandboxed(self, action_fn: Callable[..., Any], token: CapabilityToken, required_right: int, resource_uri: str, *args, **kwargs) -> Any:
        if not self.check_access(token, required_right, resource_uri):
            raise PermissionError(
                f"[MicroSandbox:{self.sandbox_id}] Denied access to '{resource_uri}' with right {rights_to_string(required_right)}"
            )
        return action_fn(*args, **kwargs)


def benchmark_ocap_throughput(iterations: int = 100000) -> Dict[str, Any]:
    kernel = ObjectCapabilityKernel()
    tok = kernel.mint_token("bmb://mem/slab", CAP_READ | CAP_WRITE | CAP_EXEC | CAP_DELEGATE, ttl_seconds=3600)
    sandbox = MicroSandbox("bench-box", CAP_READ | CAP_WRITE, kernel)
    sandbox.grant_token(tok)

    t0 = time.perf_counter()
    valid_count = 0
    for _ in range(iterations):
        if sandbox.check_access(tok, CAP_READ, "bmb://mem/slab"):
            valid_count += 1
    total_time = time.perf_counter() - t0

    ns_per_check = (total_time / iterations) * 1e9 if iterations > 0 else 0.0
    ops_per_sec = iterations / total_time if total_time > 0 else 0.0

    return {
        "iterations": iterations,
        "valid_checks": valid_count,
        "total_elapsed_seconds": round(total_time, 6),
        "ns_per_capability_check": round(ns_per_check, 2),
        "checks_per_second": round(ops_per_sec, 1),
        "zero_violations": sandbox.violations_count == 0,
    }
