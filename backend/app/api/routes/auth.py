from __future__ import annotations

import sqlite3

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, Field

from app.auth import create_access_token, hash_password, verify_password
from app.config import Settings, get_settings
from app.api.dependencies import get_user_repository
from app.repositories.users import SQLiteUserRepository, UserCreate, UserRecord


router = APIRouter(prefix="/auth")


class SignupRequest(BaseModel):
    email: str = Field(min_length=3, max_length=320)
    password: str = Field(min_length=8)
    full_name: str = Field(min_length=1, max_length=255)


class LoginRequest(BaseModel):
    email: str = Field(min_length=3, max_length=320)
    password: str = Field(min_length=1)


class UserResponse(BaseModel):
    id: int
    email: str
    full_name: str
    created_at: str


class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"


@router.post(
    "/signup",
    response_model=UserResponse,
    status_code=status.HTTP_201_CREATED,
)
def signup(
    payload: SignupRequest,
    repository: SQLiteUserRepository = Depends(get_user_repository),
) -> UserResponse:
    try:
        created_user = repository.create_user(
            UserCreate(
                email=payload.email.lower(),
                password_hash=hash_password(payload.password),
                full_name=payload.full_name.strip(),
            )
        )
    except sqlite3.IntegrityError as exc:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="A user with this email already exists.",
        ) from exc

    return _to_user_response(created_user)


@router.post("/login", response_model=LoginResponse)
def login(
    payload: LoginRequest,
    repository: SQLiteUserRepository = Depends(get_user_repository),
    settings: Settings = Depends(get_settings),
) -> LoginResponse:
    user = repository.get_user_by_email(payload.email.lower())
    if user is None or not verify_password(payload.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password.",
        )

    return LoginResponse(
        access_token=create_access_token(user_id=user.id, settings=settings)
    )


def _to_user_response(user: UserRecord) -> UserResponse:
    return UserResponse(
        id=user.id,
        email=user.email,
        full_name=user.full_name,
        created_at=user.created_at,
    )
