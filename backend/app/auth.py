from __future__ import annotations

import base64
from datetime import UTC, datetime
import hashlib
import hmac
import json
import secrets
from typing import Any

from app.config import Settings


_PASSWORD_DELIMITER = "$"
_PASSWORD_SALT_BYTES = 16
_SCRYPT_N = 2**14
_SCRYPT_R = 8
_SCRYPT_P = 1
_SCRYPT_DKLEN = 64


def hash_password(password: str) -> str:
    salt = secrets.token_bytes(_PASSWORD_SALT_BYTES)
    digest = hashlib.scrypt(
        password.encode("utf-8"),
        salt=salt,
        n=_SCRYPT_N,
        r=_SCRYPT_R,
        p=_SCRYPT_P,
        dklen=_SCRYPT_DKLEN,
    )
    salt_b64 = base64.urlsafe_b64encode(salt).decode("ascii")
    digest_b64 = base64.urlsafe_b64encode(digest).decode("ascii")
    return f"scrypt{_PASSWORD_DELIMITER}{salt_b64}{_PASSWORD_DELIMITER}{digest_b64}"


def verify_password(password: str, password_hash: str) -> bool:
    try:
        algorithm, salt_b64, digest_b64 = password_hash.split(_PASSWORD_DELIMITER)
    except ValueError:
        return False

    if algorithm != "scrypt":
        return False

    salt = _decode_base64(salt_b64)
    expected_digest = _decode_base64(digest_b64)

    if salt is None or expected_digest is None:
        return False

    candidate_digest = hashlib.scrypt(
        password.encode("utf-8"),
        salt=salt,
        n=_SCRYPT_N,
        r=_SCRYPT_R,
        p=_SCRYPT_P,
        dklen=len(expected_digest),
    )
    return hmac.compare_digest(candidate_digest, expected_digest)


def create_access_token(*, user_id: int, settings: Settings) -> str:
    issued_at = datetime.now(UTC).replace(microsecond=0).isoformat()
    payload = {"sub": str(user_id), "iat": issued_at}
    payload_bytes = json.dumps(payload, separators=(",", ":"), sort_keys=True).encode(
        "utf-8"
    )
    payload_b64 = _encode_base64(payload_bytes)
    signature = hmac.new(
        settings.secret_key.encode("utf-8"),
        payload_b64.encode("ascii"),
        hashlib.sha256,
    ).digest()
    signature_b64 = _encode_base64(signature)
    return f"{payload_b64}.{signature_b64}"


def decode_access_token(token: str, settings: Settings) -> dict[str, Any] | None:
    try:
        payload_b64, signature_b64 = token.split(".")
    except ValueError:
        return None

    expected_signature = hmac.new(
        settings.secret_key.encode("utf-8"),
        payload_b64.encode("ascii"),
        hashlib.sha256,
    ).digest()
    actual_signature = _decode_base64(signature_b64)
    if actual_signature is None or not hmac.compare_digest(
        actual_signature, expected_signature
    ):
        return None

    payload_bytes = _decode_base64(payload_b64)
    if payload_bytes is None:
        return None

    try:
        payload = json.loads(payload_bytes)
    except json.JSONDecodeError:
        return None

    if not isinstance(payload, dict):
        return None

    return payload


def _encode_base64(value: bytes) -> str:
    return base64.urlsafe_b64encode(value).decode("ascii").rstrip("=")


def _decode_base64(value: str) -> bytes | None:
    padding = "=" * (-len(value) % 4)
    try:
        return base64.urlsafe_b64decode(f"{value}{padding}")
    except (ValueError, TypeError):
        return None
