"""
Módulo: schemas/type_document.py
Descripción: Schemas Pydantic para tipos de documentos de identidad.
¿Para qué? Validar y documentar los datos de entrada/salida para tipos de documentos.
¿Impacto? Define la API REST para gestionar tipos de documentos.
"""

import uuid
from pydantic import BaseModel, ConfigDict, Field


class TypeDocumentCreate(BaseModel):
    """Schema para crear un nuevo tipo de documento."""
    name: str = Field(..., min_length=2, max_length=100, description="Nombre del tipo de documento (CC, TI, Pasaporte, etc.)")


class TypeDocumentResponse(BaseModel):
    """Schema de respuesta para tipos de documentos."""
    id: uuid.UUID
    name: str

    model_config = ConfigDict(from_attributes=True)
