-- =====================================================
-- Seed: Tipos de Documentos Válidos
-- =====================================================
-- Inserta los tipos de documentos de identidad estándar
-- para Colombia en la tabla type_document.
-- Ejecutarse después de crear las tablas principales.

INSERT INTO type_document (id, name) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Cédula de Ciudadanía (CC)'),
  ('00000000-0000-0000-0000-000000000002', 'Tarjeta de Identidad (TI)'),
  ('00000000-0000-0000-0000-000000000003', 'Pasaporte'),
  ('00000000-0000-0000-0000-000000000004', 'Cédula de Extranjería (CE)'),
  ('00000000-0000-0000-0000-000000000005', 'Permiso por Protección Temporal (PPT)'),
  ('00000000-0000-0000-0000-000000000006', 'Documento de Identificación Personal (DIPS)')
ON CONFLICT (name) DO NOTHING;
