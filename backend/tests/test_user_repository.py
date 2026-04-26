import sqlite3

from fastapi.testclient import TestClient

from app.config import get_settings
from app.db import initialize_database
from app.main import create_app
from app.repositories.users import SQLiteUserRepository, UserCreate


def test_app_startup_initializes_sqlite_database(
    monkeypatch, tmp_path
) -> None:
    database_path = tmp_path / "startup.db"

    monkeypatch.setenv("SQLITE_DB_PATH", str(database_path))
    get_settings.cache_clear()

    try:
        with TestClient(create_app()) as client:
            response = client.get("/api/health")

        assert response.status_code == 200
        assert database_path.exists()

        with sqlite3.connect(database_path) as connection:
            table = connection.execute(
                "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'users'"
            ).fetchone()

        assert table == ("users",)
    finally:
        monkeypatch.delenv("SQLITE_DB_PATH", raising=False)
        get_settings.cache_clear()


def test_sqlite_user_repository_creates_and_reads_users(tmp_path) -> None:
    database_path = tmp_path / "users.db"
    initialize_database(database_path)
    repository = SQLiteUserRepository(database_path)

    created_user = repository.create_user(
        UserCreate(
            email="person@example.com",
            password_hash="hashed-password",
            full_name="Example Person",
        )
    )

    loaded_by_email = repository.get_user_by_email("person@example.com")
    loaded_by_id = repository.get_user_by_id(created_user.id)

    assert created_user.id > 0
    assert created_user.email == "person@example.com"
    assert created_user.password_hash == "hashed-password"
    assert created_user.full_name == "Example Person"
    assert created_user.created_at
    assert loaded_by_email == created_user
    assert loaded_by_id == created_user


def test_sqlite_user_repository_returns_none_for_missing_email(tmp_path) -> None:
    database_path = tmp_path / "users.db"
    initialize_database(database_path)
    repository = SQLiteUserRepository(database_path)

    assert repository.get_user_by_email("missing@example.com") is None
