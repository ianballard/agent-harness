import hmac
import json
from base64 import urlsafe_b64decode

from fastapi.testclient import TestClient

from app.config import get_settings
from app.db import initialize_database
from app.main import create_app
from app.repositories.users import SQLiteUserRepository


def test_signup_creates_user_and_returns_public_payload(monkeypatch, tmp_path) -> None:
    client, database_path = _create_client(monkeypatch, tmp_path)

    try:
        response = client.post(
            "/api/auth/signup",
            json={
                "email": "person@example.com",
                "password": "password123",
                "full_name": "Example Person",
            },
        )

        assert response.status_code == 201
        assert response.json()["email"] == "person@example.com"
        assert response.json()["full_name"] == "Example Person"
        assert "password_hash" not in response.json()

        repository = SQLiteUserRepository(database_path)
        saved_user = repository.get_user_by_email("person@example.com")

        assert saved_user is not None
        assert saved_user.full_name == "Example Person"
        assert saved_user.password_hash != "password123"
    finally:
        client.close()
        _cleanup_settings(monkeypatch)


def test_signup_rejects_duplicate_email(monkeypatch, tmp_path) -> None:
    client, _ = _create_client(monkeypatch, tmp_path)

    try:
        payload = {
            "email": "person@example.com",
            "password": "password123",
            "full_name": "Example Person",
        }

        first_response = client.post("/api/auth/signup", json=payload)
        duplicate_response = client.post("/api/auth/signup", json=payload)

        assert first_response.status_code == 201
        assert duplicate_response.status_code == 409
        assert duplicate_response.json() == {
            "detail": "A user with this email already exists."
        }
    finally:
        client.close()
        _cleanup_settings(monkeypatch)


def test_login_returns_bearer_token_for_valid_credentials(monkeypatch, tmp_path) -> None:
    client, _ = _create_client(monkeypatch, tmp_path)

    try:
        signup_response = client.post(
            "/api/auth/signup",
            json={
                "email": "person@example.com",
                "password": "password123",
                "full_name": "Example Person",
            },
        )
        login_response = client.post(
            "/api/auth/login",
            json={"email": "person@example.com", "password": "password123"},
        )

        assert signup_response.status_code == 201
        assert login_response.status_code == 200
        assert login_response.json()["token_type"] == "bearer"

        token = login_response.json()["access_token"]
        payload_segment, signature_segment = token.split(".")
        expected_signature = hmac.new(
            get_settings().secret_key.encode("utf-8"),
            payload_segment.encode("ascii"),
            "sha256",
        ).digest()

        assert hmac.compare_digest(
            _decode_segment(signature_segment),
            expected_signature,
        )
        assert json.loads(_decode_segment(payload_segment))["sub"] == "1"
    finally:
        client.close()
        _cleanup_settings(monkeypatch)


def test_login_rejects_invalid_credentials(monkeypatch, tmp_path) -> None:
    client, _ = _create_client(monkeypatch, tmp_path)

    try:
        client.post(
            "/api/auth/signup",
            json={
                "email": "person@example.com",
                "password": "password123",
                "full_name": "Example Person",
            },
        )

        response = client.post(
            "/api/auth/login",
            json={"email": "person@example.com", "password": "wrong-password"},
        )

        assert response.status_code == 401
        assert response.json() == {"detail": "Invalid email or password."}
    finally:
        client.close()
        _cleanup_settings(monkeypatch)


def test_profile_returns_current_user_for_authenticated_request(
    monkeypatch, tmp_path
) -> None:
    client, _ = _create_client(monkeypatch, tmp_path)

    try:
        signup_response = client.post(
            "/api/auth/signup",
            json={
                "email": "person@example.com",
                "password": "password123",
                "full_name": "Example Person",
            },
        )
        login_response = client.post(
            "/api/auth/login",
            json={"email": "person@example.com", "password": "password123"},
        )
        token = login_response.json()["access_token"]

        profile_response = client.get(
            "/api/profile",
            headers={"Authorization": f"Bearer {token}"},
        )

        assert signup_response.status_code == 201
        assert login_response.status_code == 200
        assert profile_response.status_code == 200
        assert profile_response.json() == signup_response.json()
    finally:
        client.close()
        _cleanup_settings(monkeypatch)


def test_profile_rejects_missing_authentication(monkeypatch, tmp_path) -> None:
    client, _ = _create_client(monkeypatch, tmp_path)

    try:
        response = client.get("/api/profile")

        assert response.status_code == 401
        assert response.json() == {
            "detail": "Authentication credentials were not provided or are invalid."
        }
    finally:
        client.close()
        _cleanup_settings(monkeypatch)


def _create_client(monkeypatch, tmp_path):
    database_path = tmp_path / "auth.db"
    monkeypatch.setenv("SQLITE_DB_PATH", str(database_path))
    monkeypatch.setenv("SECRET_KEY", "test-secret-key")
    initialize_database(database_path)
    get_settings.cache_clear()
    return TestClient(create_app()), database_path


def _cleanup_settings(monkeypatch) -> None:
    monkeypatch.delenv("SQLITE_DB_PATH", raising=False)
    monkeypatch.delenv("SECRET_KEY", raising=False)
    get_settings.cache_clear()


def _decode_segment(value: str) -> bytes:
    padding = "=" * (-len(value) % 4)
    return urlsafe_b64decode(f"{value}{padding}")
