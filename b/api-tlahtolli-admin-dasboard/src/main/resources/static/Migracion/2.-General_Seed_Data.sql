-- ============================================================
--  SEED DATA — General (Usuarios demo, Logros, Energía)
--  Tlahtolli v1.0  [PostgreSQL]
--
--  Ejecutar DESPUÉS de Tlahtolli_Database_Script.sql
--  y ANTES de cualquier seed de idioma específico.
--
--  Contenido:
--    USERS (usuarios demo)
--    USER_ENERGY
--    ACHIEVEMENTS
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
INSERT INTO USERS (USERNAME, FULL_NAME, EMAIL, USER_LEVEL, XP, TOTAL_XP, STREAK, JOIN_DATE, CURRENT_LANG)
VALUES ('tetecuhtli', 'UserDemo', 'demo@tlahtolli.mx', 1, 0, 0, 0, CURRENT_DATE, NULL);

-- ─────────────────────────────────────────────
--  2. ENERGÍA DEL USUARIO DEMO
-- ─────────────────────────────────────────────
INSERT INTO USER_ENERGY (USER_ID, MAX_ENERGY, CURRENT_ENRG, STREAK_COUNT, LAST_UPDATE, DAILY_USAGE)
VALUES ((SELECT ID FROM USERS WHERE USERNAME = 'tetecuhtli'), 15, 15, 0, NOW(), 0);

-- ─────────────────────────────────────────────
--  3. LOGROS (globales, no ligados a idioma)
-- ─────────────────────────────────────────────
INSERT INTO ACHIEVEMENTS (TITLE, DESCRIPTION, ICON, XP_REWARD, REQUIREMENT, CATEGORY, RARITY)
VALUES ('Primer Día',             'Completaste tu primera lección',             '🎉', 50,  'completar 1 lección',       'general',     'common');
INSERT INTO ACHIEVEMENTS (TITLE, DESCRIPTION, ICON, XP_REWARD, REQUIREMENT, CATEGORY, RARITY)
VALUES ('Racha de 7 días',        'Estudiaste durante 7 días consecutivos',     '🔥', 100, 'mantener racha de 7 días',  'dedication',  'rare');
INSERT INTO ACHIEVEMENTS (TITLE, DESCRIPTION, ICON, XP_REWARD, REQUIREMENT, CATEGORY, RARITY)
VALUES ('Vocabulario Básico',     'Aprendiste 50 palabras nuevas',              '📚', 150, 'aprender 50 palabras',      'vocabulary',  'common');
INSERT INTO ACHIEVEMENTS (TITLE, DESCRIPTION, ICON, XP_REWARD, REQUIREMENT, CATEGORY, RARITY)
VALUES ('Racha de 30 días',       'Estudiaste durante 30 días consecutivos',    '⚡', 300, 'mantener racha de 30 días', 'dedication',  'epic');
INSERT INTO ACHIEVEMENTS (TITLE, DESCRIPTION, ICON, XP_REWARD, REQUIREMENT, CATEGORY, RARITY)
VALUES ('Perfeccionista',         'Completaste 10 lecciones perfectas',         '⭐', 200, '10 lecciones perfectas',    'performance', 'rare');
INSERT INTO ACHIEVEMENTS (TITLE, DESCRIPTION, ICON, XP_REWARD, REQUIREMENT, CATEGORY, RARITY)
VALUES ('Estudiante Comprometido','Estudiaste 1000 minutos',                    '⏰', 150, '1000 minutos de estudio',   'dedication',  'common');

-- ─────────────────────────────────────────────
--  VERIFICACIÓN
-- ─────────────────────────────────────────────
SELECT 'USERS'        AS TABLA, COUNT(*) AS REGISTROS FROM USERS        UNION ALL
SELECT 'USER_ENERGY',           COUNT(*) FROM USER_ENERGY               UNION ALL
SELECT 'ACHIEVEMENTS',          COUNT(*) FROM ACHIEVEMENTS;
