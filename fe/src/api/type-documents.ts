/**
 * Archivo: api/type-documents.ts
 * Descripción: Servicio API para tipos de documentos.
 * ¿Para qué? Obtener la lista de tipos de documentos disponibles.
 */

import axios from 'axios';
import { TypeDocument } from '@/types/auth';

const BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000';

export async function getTypeDocuments(): Promise<TypeDocument[]> {
  try {
    const response = await axios.get<TypeDocument[]>(
      `${BASE_URL}/api/v1/type-documents`
    );
    return response.data;
  } catch (error) {
    console.error('Error fetching type documents:', error);
    throw error;
  }
}

export async function getTypeDocument(id: string): Promise<TypeDocument> {
  try {
    const response = await axios.get<TypeDocument>(
      `${BASE_URL}/api/v1/type-documents/${id}`
    );
    return response.data;
  } catch (error) {
    console.error('Error fetching type document:', error);
    throw error;
  }
}
