from dataclasses import dataclass
from datetime import UTC, datetime
from pathlib import Path
import sqlite3

from app.db import get_connection


@dataclass(frozen=True)
class UserCreate:
    email: str
    password_hash: str
    full_name: str


@dataclass(frozen=True)
class UserRecord:
    id: int
    email: str
    password_hash: str
    full_name: str
    created_at: str


class SQLiteUserRepository:
    def __init__(self, database_path: Path) -> None:
        self._database_path = database_path

    def create_user(self, user: UserCreate) -> UserRecord:
        created_at = datetime.now(UTC).isoformat()

        with get_connection(self._database_path) as connection:
            cursor = connection.execute(
                """
                INSERT INTO users (email, password_hash, full_name, created_at)
                VALUES (?, ?, ?, ?)
                """,
                (user.email, user.password_hash, user.full_name, created_at),
            )
            user_id = cursor.lastrowid

        return self.get_user_by_id(user_id)

    def get_user_by_email(self, email: str) -> UserRecord | None:
        with get_connection(self._database_path) as connection:
            row = connection.execute(
                """
                SELECT id, email, password_hash, full_name, created_at
                FROM users
                WHERE email = ?
                """,
                (email,),
            ).fetchone()

        return _row_to_user(row)

    def get_user_by_id(self, user_id: int | None) -> UserRecord:
        if user_id is None:
            raise ValueError("user_id is required")

        with get_connection(self._database_path) as connection:
            row = connection.execute(
                """
                SELECT id, email, password_hash, full_name, created_at
                FROM users
                WHERE id = ?
                """,
                (user_id,),
            ).fetchone()

        user = _row_to_user(row)
        if user is None:
            raise LookupError(f"user {user_id} was not found")

        return user


def _row_to_user(row: sqlite3.Row | None) -> UserRecord | None:
    if row is None:
        return None

    return UserRecord(
        id=row["id"],
        email=row["email"],
        password_hash=row["password_hash"],
        full_name=row["full_name"],
        created_at=row["created_at"],
    )
