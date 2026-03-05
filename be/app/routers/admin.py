"""
Módulo: routers/admin.py
Descripción: Endpoints administrativos — validación de usuarios, gestión de roles, etc.
¿Para qué? Proveer funcionalidades exclusivas para administradores del sistema.
¿Impacto? Permite a los admins validar clientes nuevos y gestionar usuarios.
"""

import uuid

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.dependencies import get_current_user, get_db
from app.models.user import User
from app.schemas.user import MessageResponse, UserResponse

router = APIRouter(
    prefix="/api/v1/admin",
    tags=["admin"],
)


@router.get(
    "/users/pending-validation",
    response_model=list[UserResponse],
    summary="Listar usuarios pendientes de validación",
)
def get_pending_users(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> list[UserResponse]:
    """Obtiene la lista de usuarios pendientes de validación por admin.
    
    Solo disponible para administradores.
    """
    # Verificar que el usuario es admin
    if current_user.role.name != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo administradores pueden acceder a este endpoint",
        )
    
    # Obtener usuarios no validados
    pending_users = db.query(User).filter(
        User.is_validated == False
    ).all()
    
    return [
        UserResponse(
            id=user.id,
            email=user.email,
            name=user.name,
            last_name=user.last_name,
            phone=user.phone,
            identity_document=user.identity_document,
            identity_document_type_id=user.identity_document_type_id,
            identity_document_type_name=user.identity_document_type.name if user.identity_document_type else None,
            is_active=user.is_active,
            is_validated=user.is_validated,
            must_change_password=user.must_change_password,
            role_name=user.role.name if user.role else None,
            business_name=user.business_name,
            occupation=user.occupation,
            created_at=user.created_at,
            updated_at=user.updated_at,
        )
        for user in pending_users
    ]


@router.patch(
    "/users/{user_id}/validate",
    response_model=UserResponse,
    summary="Validar usuario como administrador",
)
def validate_user(
    user_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> UserResponse:
    """Valida un usuario cliente nuevo.
    
    Marca el usuario como validado y activa su cuenta.
    Solo disponible para administradores.
    """
    # Verificar que el usuario es admin
    if current_user.role.name != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo administradores pueden validar usuarios",
        )
    
    # Buscar el usuario a validar
    user_to_validate = db.query(User).filter(User.id == user_id).first()
    if not user_to_validate:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuario no encontrado",
        )
    
    # Validar el usuario
    user_to_validate.is_validated = True
    user_to_validate.is_active = True
    user_to_validate.validated_by = current_user.id
    
    from datetime import datetime, timezone
    user_to_validate.validated_at = datetime.now(timezone.utc)
    
    db.commit()
    db.refresh(user_to_validate)
    
    return UserResponse(
        id=user_to_validate.id,
        email=user_to_validate.email,
        name=user_to_validate.name,
        last_name=user_to_validate.last_name,
        phone=user_to_validate.phone,
        identity_document=user_to_validate.identity_document,
        identity_document_type_id=user_to_validate.identity_document_type_id,
        identity_document_type_name=user_to_validate.identity_document_type.name if user_to_validate.identity_document_type else None,
        is_active=user_to_validate.is_active,
        is_validated=user_to_validate.is_validated,
        must_change_password=user_to_validate.must_change_password,
        role_name=user_to_validate.role.name if user_to_validate.role else None,
        business_name=user_to_validate.business_name,
        occupation=user_to_validate.occupation,
        created_at=user_to_validate.created_at,
        updated_at=user_to_validate.updated_at,
    )


@router.patch(
    "/users/{user_id}/force-password-change",
    response_model=MessageResponse,
    summary="Forzar cambio de contraseña",
)
def force_password_change(
    user_id: uuid.UUID,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
) -> MessageResponse:
    """Fuerza el cambio de contraseña en el próximo login.
    
    Útil para resets administrativos.
    Solo disponible para administradores.
    """
    # Verificar que el usuario es admin
    if current_user.role.name != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Solo administradores pueden forzar cambios de contraseña",
        )
    
    # Buscar el usuario
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Usuario no encontrado",
        )
    
    # Marcar que debe cambiar contraseña
    user.must_change_password = True
    db.commit()
    
    return MessageResponse(
        message=f"Usuario {user.email} deberá cambiar contraseña en el próximo login"
    )
