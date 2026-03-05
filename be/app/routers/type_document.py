"""
Módulo: routers/type_document.py
Descripción: Endpoints para gestionar tipos de documentos de identidad.
¿Para qué? Proporcionar CRUD básico para tipos de documentos.
¿Impacto? Permite listar y crear tipos de documentos disponibles.
"""

import uuid

from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.dependencies import get_db
from app.models.type_document import TypeDocument
from app.schemas.type_document import TypeDocumentCreate, TypeDocumentResponse

router = APIRouter(
    prefix="/api/v1/type-documents",
    tags=["type-documents"],
)


@router.get(
    "",
    response_model=list[TypeDocumentResponse],
    summary="Listar todos los tipos de documentos",
)
def get_all_type_documents(
    db: Session = Depends(get_db),
) -> list[TypeDocumentResponse]:
    """Obtiene la lista de todos los tipos de documentos disponibles."""
    type_documents = db.query(TypeDocument).all()
    return [
        TypeDocumentResponse(id=td.id, name=td.name)
        for td in type_documents
    ]


@router.get(
    "/{type_document_id}",
    response_model=TypeDocumentResponse,
    summary="Obtener tipo de documento por ID",
)
def get_type_document(
    type_document_id: uuid.UUID,
    db: Session = Depends(get_db),
) -> TypeDocumentResponse:
    """Obtiene un tipo de documento específico por su ID."""
    type_document = db.query(TypeDocument).filter(
        TypeDocument.id == type_document_id
    ).first()
    
    if not type_document:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Tipo de documento no encontrado",
        )
    
    return TypeDocumentResponse(id=type_document.id, name=type_document.name)


@router.post(
    "",
    response_model=TypeDocumentResponse,
    status_code=status.HTTP_201_CREATED,
    summary="Crear nuevo tipo de documento",
)
def create_type_document(
    type_document_data: TypeDocumentCreate,
    db: Session = Depends(get_db),
) -> TypeDocumentResponse:
    """Crea un nuevo tipo de documento."""
    # Verificar que no exista uno con el mismo nombre
    existing = db.query(TypeDocument).filter(
        TypeDocument.name == type_document_data.name
    ).first()
    
    if existing:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=f"El tipo de documento '{type_document_data.name}' ya existe",
        )
    
    new_type_document = TypeDocument(name=type_document_data.name)
    db.add(new_type_document)
    db.commit()
    db.refresh(new_type_document)
    
    return TypeDocumentResponse(id=new_type_document.id, name=new_type_document.name)
