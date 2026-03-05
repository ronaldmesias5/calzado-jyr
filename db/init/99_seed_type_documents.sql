-- =====================================================
-- Seed: Tipos de Documentos Válidos
-- =====================================================
-- ¡NO CAMBIAR EL NOMBRE DE ESTE ARCHIVO!
-- Este archivo debe ejecutarse DESPUÉS de crear todas las tablas.
-- Por eso su nombre inicia con '99_'.
-- Así Docker lo ejecuta al final y garantiza que la tabla type_document existe.
--
-- Si necesitas agregar más seeds, usa el prefijo '99_' para que siempre vayan al final.

INSERT INTO type_document (id, name) VALUES
  ('00000000-0000-0000-0000-000000000001', 'Cédula de Ciudadanía (CC)'),
  ('00000000-0000-0000-0000-000000000002', 'Tarjeta de Identidad (TI)'),
  ('00000000-0000-0000-0000-000000000003', 'Pasaporte'),
  ('00000000-0000-0000-0000-000000000004', 'Cédula de Extranjería (CE)'),
  ('00000000-0000-0000-0000-000000000005', 'Permiso por Protección Temporal (PPT)'),
  ('00000000-0000-0000-0000-000000000006', 'Documento de Identificación Personal (DIPS)')
ON CONFLICT (name) DO NOTHING;
