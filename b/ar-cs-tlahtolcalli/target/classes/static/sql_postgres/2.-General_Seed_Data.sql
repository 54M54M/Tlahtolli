-- ============================================================
--  SEED DATA — General (Usuarios demo, Logros, Energía)
--  Tlahtolli v1.0  [PostgreSQL]
--
--  Ejecutar DESPUÉS de Tlahtolli_Database_Script.sql
--  y ANTES de cualquier seed de idioma específico.
--
--  Contenido:
--    TA_USERS (usuarios demo)
--    TA_USER_ENERGY
--    CT_ACHIEVEMENTS
--
--  Orden de ejecución recomendado:
--    1. Tlahtolli_Database_Script.sql
--    2. General_Seed_Data.sql          ← este archivo
--    3. Nahuatl_Seed_Data.sql
--    4. Teenek_Seed_Data.sql
-- ============================================================

-- ─────────────────────────────────────────────
--  1. USUARIO DEMO
--
--  NOTA: CURRENT_LANG se asigna DESPUÉS de insertar los idiomas.
--        Se deja en NULL aquí y se actualiza al final del bloque.
-- ─────────────────────────────────────────────
INSERT INTO TA_USERS (USERNAME, FULL_NAME, EMAIL, USER_LEVEL, XP, TOTAL_XP, STREAK, JOIN_DATE, CURRENT_LANG)
VALUES ('tetecuhtli', 'UserDemo', 'demo@tlahtolli.mx', 1, 0, 0, 0, CURRENT_DATE, NULL);

-- ─────────────────────────────────────────────
--  2. ENERGÍA DEL USUARIO DEMO
-- ─────────────────────────────────────────────
INSERT INTO TA_USER_ENERGY (USER_ID, MAX_ENERGY, CURRENT_ENRG, STREAK_COUNT, LAST_UPDATE, DAILY_USAGE)
VALUES ((SELECT ID FROM TA_USERS WHERE USERNAME = 'tetecuhtli'), 15, 15, 0, NOW(), 0);

-- ─────────────────────────────────────────────
--  3. LOGROS (globales, no ligados a idioma)
-- ─────────────────────────────────────────────
INSERT INTO CT_ACHIEVEMENTS (TITLE, DESCRIPTION, ICON, XP_REWARD, REQUIREMENT, CATEGORY, RARITY, LANGUAGE_TAG)
VALUES ('Primer Día','Completaste tu primera lección','🎉',50,'completar 1 lección','general','common', NULL);
INSERT INTO CT_ACHIEVEMENTS (TITLE, DESCRIPTION, ICON, XP_REWARD, REQUIREMENT, CATEGORY, RARITY, LANGUAGE_TAG)
VALUES ('Racha de 7 días','Estudiaste durante 7 días consecutivos','🔥',100,'mantener racha de 7 días','dedication','rare', NULL);
INSERT INTO CT_ACHIEVEMENTS (TITLE, DESCRIPTION, ICON, XP_REWARD, REQUIREMENT, CATEGORY, RARITY, LANGUAGE_TAG)
VALUES ('Vocabulario Básico','Aprendiste 50 palabras nuevas','📚',150,'aprender 50 palabras','vocabulary','common', NULL);
INSERT INTO CT_ACHIEVEMENTS (TITLE, DESCRIPTION, ICON, XP_REWARD, REQUIREMENT, CATEGORY, RARITY, LANGUAGE_TAG)
VALUES ('Racha de 30 días','Estudiaste durante 30 días consecutivos','⚡',300,'mantener racha de 30 días','dedication','epic', NULL);
INSERT INTO CT_ACHIEVEMENTS (TITLE, DESCRIPTION, ICON, XP_REWARD, REQUIREMENT, CATEGORY, RARITY, LANGUAGE_TAG)
VALUES ('Perfeccionista','Completaste 10 lecciones perfectas','⭐',200,'10 lecciones perfectas','performance','rare', NULL);
INSERT INTO CT_ACHIEVEMENTS (TITLE, DESCRIPTION, ICON, XP_REWARD, REQUIREMENT, CATEGORY, RARITY, LANGUAGE_TAG)
VALUES ('Estudiante Comprometido','Estudiaste 1000 minutos','⏰',150,'1000 minutos de estudio','dedication','common', NULL);

-- ─────────────────────────────────────────────
--  VERIFICACIÓN
-- ─────────────────────────────────────────────
SELECT 'TA_USERS'        AS TABLA, COUNT(*) AS REGISTROS FROM TA_USERS        UNION ALL
SELECT 'TA_USER_ENERGY',           COUNT(*) FROM TA_USER_ENERGY               UNION ALL
SELECT 'CT_ACHIEVEMENTS',          COUNT(*) FROM CT_ACHIEVEMENTS;
