-- ============================================================
--  MIGRACIÓN: Agregar columna PASSWORD_HASH a TA_USERS
--  Ejecutar UNA sola vez sobre la DB existente
-- ============================================================

ALTER TABLE TA_USERS
    ADD COLUMN PASSWORD_HASH VARCHAR(255) NOT NULL DEFAULT '';

-- Hash BCrypt de 'demo1234' generado con strength=10
UPDATE TA_USERS
SET PASSWORD_HASH = '$2a$10$LS0y45bwfjhU/YXkI6Txou8q6G2KQbljINC0u.W4CGU9jRjod9ksa'
WHERE USERNAME = 'tetecuhtli';

-- Quitar el DEFAULT vacío una vez poblados los datos
ALTER TABLE TA_USERS
    ALTER COLUMN PASSWORD_HASH DROP DEFAULT;
