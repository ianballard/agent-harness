from __future__ import annotations

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer

from app.auth import decode_access_token
from app.config import Settings, get_settings
from app.repositories.users import SQLiteUserRepository, UserRecord


_bearer_scheme = HTTPBearer(auto_error=False)


def get_user_repository(settings: Settings = Depends(get_settings)) -> SQLiteUserRepository:
    return SQLiteUserRepository(settings.sqlite_db_path)


def get_current_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(_bearer_scheme),
    repository: SQLiteUserRepository = Depends(get_user_repository),
    settings: Settings = Depends(get_settings),
) -> UserRecord:
    unauthorized = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Authentication credentials were not provided or are invalid.",
    )

    if credentials is None or credentials.scheme.lower() != "bearer":
        raise unauthorized

    payload = decode_access_token(credentials.credentials, settings)
    user_id = payload.get("sub") if payload is not None else None
    if not isinstance(user_id, str) or not user_id.isdigit():
        raise unauthorized

    try:
        user = repository.get_user_by_id(int(user_id))
    except LookupError:
        raise unauthorized

    return user
