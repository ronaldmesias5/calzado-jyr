"""
Módulo: routers/users.py
Descripción: Endpoints de usuario — perfil del usuario autenticado.
¿Para qué? Permitir al usuario obtener su información de perfil.
¿Impacto? Necesario para que el frontend pueda mostrar datos del usuario logueado.
"""

from fastapi import APIRouter, Depends

from app.dependencies import get_current_user
from app.models.user import User
from app.schemas.user import UserResponse

router = APIRouter(
    prefix="/api/v1/users",
    tags=["users"],
)


@router.get(
    "/me",
    response_model=UserResponse,
    summary="Obtener perfil del usuario autenticado",
)
def get_me(
    current_user: User = Depends(get_current_user),
) -> UserResponse:
    """Retorna los datos del usuario autenticado."""
    return UserResponse(
        id=current_user.id,
        email=current_user.email,
        name=current_user.name,
        last_name=current_user.last_name,
        phone=current_user.phone,
        identity_document=current_user.identity_document,
        is_active=current_user.is_active,
        is_validated=current_user.is_validated,
        must_change_password=current_user.must_change_password,
        role_name=current_user.role.name if current_user.role else None,
        business_name=current_user.business_name,
        occupation=current_user.occupation,
        created_at=current_user.created_at,
        updated_at=current_user.updated_at,
    )
