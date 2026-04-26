from fastapi import APIRouter, Depends

from app.api.dependencies import get_current_user
from app.api.routes.auth import UserResponse
from app.repositories.users import UserRecord


router = APIRouter(prefix="/profile")


@router.get("", response_model=UserResponse)
def read_profile(current_user: UserRecord = Depends(get_current_user)) -> UserResponse:
    return UserResponse(
        id=current_user.id,
        email=current_user.email,
        full_name=current_user.full_name,
        created_at=current_user.created_at,
    )
