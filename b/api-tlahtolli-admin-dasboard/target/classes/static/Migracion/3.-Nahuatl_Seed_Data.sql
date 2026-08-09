-- ============================================================
--  SEED DATA — Náhuatl Central (nhce)
--  Tlahtolli v1.0  [PostgreSQL]
--
--  Ejecutar DESPUÉS de:
--    1. Tlahtolli_Database_Script.sql
--    2. General_Seed_Data.sql   (crea usuario demo y logros)
--
--  Contenido:
--    LANGUAGES → LEVELS → UNITS → VOCABULARY
--    → UNIT_VOCAB → EXERCISES → WRITING_SYSTEMS
--    → USER_PROGRESS → USER_STATS  (para usuario demo)
-- ============================================================

-- ─────────────────────────────────────────────
--  1. IDIOMA
-- ─────────────────────────────────────────────
INSERT INTO LANGUAGES (CODE, LANG_NAME, NATIVE_NAME, COLOR, FLAG, FAMILY, WRITING_SYSTEM)
VALUES ('nhce', 'Náhuatl central', 'Nāhuatlahtōlli Central', '#58CC02', '🦅', 'uto-aztec', 'syllabary');

-- ─────────────────────────────────────────────
--  2. NIVELES
-- ─────────────────────────────────────────────
INSERT INTO LEVELS (LANGUAGE_ID, LEVEL_NUM, TITLE, TITLE_NATIVE, COLOR, TOTAL_UNITS, UNLOCK_REQ, IS_FREE)
SELECT ID, 1, 'Saluda y preséntate', 'Tiquilnamiqui ihuan timitstlania',
       '#4bb101', 6, 'Ninguno - Nivel inicial', 1
FROM LANGUAGES WHERE CODE = 'nhce';

INSERT INTO LEVELS (LANGUAGE_ID, LEVEL_NUM, TITLE, TITLE_NATIVE, COLOR, TOTAL_UNITS, UNLOCK_REQ, IS_FREE)
SELECT ID, 2, 'Describete y describe a tu familia', 'Timitstlania ihuan timitstlania in mocencal',
       '#1CB0F6', 6, 'Completar Nivel 1', 0
FROM LANGUAGES WHERE CODE = 'nhce';

INSERT INTO LEVELS (LANGUAGE_ID, LEVEL_NUM, TITLE, TITLE_NATIVE, COLOR, TOTAL_UNITS, UNLOCK_REQ, IS_FREE)
SELECT ID, 3, 'Pide y da información', 'Tlatlatlauhtia ihuan titlanana',
       '#FF9600', 6, 'Completar Nivel 2', 0
FROM LANGUAGES WHERE CODE = 'nhce';

INSERT INTO LEVELS (LANGUAGE_ID, LEVEL_NUM, TITLE, TITLE_NATIVE, COLOR, TOTAL_UNITS, UNLOCK_REQ, IS_FREE)
SELECT ID, 4, 'Habla en tiempos (ayer/hoy/mañana)', 'Tlahtoa ipan cahuitl',
       '#FF4B4B', 6, 'Completar Nivel 3', 0
FROM LANGUAGES WHERE CODE = 'nhce';

INSERT INTO LEVELS (LANGUAGE_ID, LEVEL_NUM, TITLE, TITLE_NATIVE, COLOR, TOTAL_UNITS, UNLOCK_REQ, IS_FREE)
SELECT ID, 5, 'Describe un día normal', 'Timitstlani ce tonalli neneuhqui',
       '#26CCC0', 6, 'Completar Nivel 4', 0
FROM LANGUAGES WHERE CODE = 'nhce';

INSERT INTO LEVELS (LANGUAGE_ID, LEVEL_NUM, TITLE, TITLE_NATIVE, COLOR, TOTAL_UNITS, UNLOCK_REQ, IS_FREE)
SELECT ID, 6, 'Describe y expresa preferencias', 'Timitstlania ihuan tiquixtia in tlen ticneltoca',
       '#9C27B0', 6, 'Completar Nivel 5', 0
FROM LANGUAGES WHERE CODE = 'nhce';

-- ─────────────────────────────────────────────
--  3. UNIDADES — Nivel 1
-- ─────────────────────────────────────────────
INSERT INTO UNITS (LEVEL_ID, UNIT_NUM, TITLE, COLOR, OBJECTIVE, GRAMMAR, IS_FREE, UNLOCK_REQ)
SELECT L.ID, 1, 'Saludos básicos', '#4bb101',
       'Aprender saludos básicos del día y la noche',
       'Estructura básica de saludos', 1, NULL
FROM LEVELS L JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1;

INSERT INTO UNITS (LEVEL_ID, UNIT_NUM, TITLE, COLOR, OBJECTIVE, GRAMMAR, IS_FREE, UNLOCK_REQ)
SELECT L.ID, 2, 'Presentaciones simples', '#4bb101',
       'Aprender a presentarse y despedirse',
       'Uso de Niltze y Timoittazceh', 0, 'Completar Unidad 1'
FROM LEVELS L JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1;

INSERT INTO UNITS (LEVEL_ID, UNIT_NUM, TITLE, COLOR, OBJECTIVE, GRAMMAR, IS_FREE, UNLOCK_REQ)
SELECT L.ID, 3, 'Cómo te llamas', '#4bb101',
       'Aprender a preguntar y decir nombres',
       'Uso de Notoca y Quen motoca', 0, 'Completar Unidad 2'
FROM LEVELS L JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1;

INSERT INTO UNITS (LEVEL_ID, UNIT_NUM, TITLE, COLOR, OBJECTIVE, GRAMMAR, IS_FREE, UNLOCK_REQ)
SELECT L.ID, 4, 'Expresar gratitud', '#4bb101',
       'Aprender a dar las gracias',
       'Uso de Tlazohcamati y Miac', 0, 'Completar Unidad 3'
FROM LEVELS L JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1;

INSERT INTO UNITS (LEVEL_ID, UNIT_NUM, TITLE, COLOR, OBJECTIVE, GRAMMAR, IS_FREE, UNLOCK_REQ)
SELECT L.ID, 5, 'Estados y condiciones', '#4bb101',
       'Aprender a expresar cómo estás',
       'Uso de Tica, Nicac y Huel', 0, 'Completar Unidad 4'
FROM LEVELS L JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1;

INSERT INTO UNITS (LEVEL_ID, UNIT_NUM, TITLE, COLOR, OBJECTIVE, GRAMMAR, IS_FREE, UNLOCK_REQ)
SELECT L.ID, 6, 'Conversación básica', '#4bb101',
       'Integrar todo lo aprendido en una conversación',
       'Estructura completa de conversación básica', 0, 'Completar Unidad 5'
FROM LEVELS L JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1;

-- ─────────────────────────────────────────────
--  4. VOCABULARIO — Nivel 1
-- ─────────────────────────────────────────────
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Cualli',        'bien / bueno / buenos / buena / buenas', 'kwal-li',       NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Tonalli',       'dia / día',              'to-nal-li',     NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Yohual',        'noche / noches',         'yo-wal',        NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Teotlac',       'tarde / tardes',         'te-o-tlak',     NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Niltze',        'hola',                   'nil-tse',       NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Timoittazceh',  'adiós / hasta luego',    'ti-mo-i-ta-se', NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Tlazohcamati',  'gracias',                'tla-so-ka-ma-ti', NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Quēmah',        'sí',                     'kee-maj',       NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Ahmo',          'no',                     'aj-mo',         NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Notoca',        'me llamo...',            'no-to-ka',      NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Quen',          'como / cómo',            'ken',           NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Miac',          'mucho / muchos',         'mi-ak',         NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Huel',          'muy / verdaderamente',   'wel',           NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Quenin',        'cómo (de qué manera)',   'ke-nin',        NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Nicac',         'estoy / yo estoy',       'ni-kak',        NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Ni',            'yo (prefijo acción)',    'ni-',           NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Ahmo cualli',   'mal / no bien',          'aj-mo-kwal-li', NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Tlen',          'qué / nada / cosa',      'tlen',          NULL FROM LANGUAGES WHERE CODE='nhce';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Ahmotlen',      'ninguna cosa / nada',    'ah-mo-tlen',    NULL FROM LANGUAGES WHERE CODE='nhce';

-- ─────────────────────────────────────────────
--  5. UNIT_VOCAB — asociar vocabulario a unidades
-- ─────────────────────────────────────────────
-- Unidad 1: Saludos básicos
INSERT INTO UNIT_VOCAB (UNIT_ID, VOCAB_ID)
SELECT U.ID, V.ID FROM UNITS U
JOIN LEVELS L ON U.LEVEL_ID = L.ID
JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
JOIN VOCABULARY V ON V.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 1
AND V.WORD IN ('Cualli','Tonalli','Yohual','Teotlac','Niltze','Timoittazceh');

-- Unidad 2: Presentaciones
INSERT INTO UNIT_VOCAB (UNIT_ID, VOCAB_ID)
SELECT U.ID, V.ID FROM UNITS U
JOIN LEVELS L ON U.LEVEL_ID = L.ID
JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
JOIN VOCABULARY V ON V.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 2
AND V.WORD IN ('Niltze','Timoittazceh','Cualli','Tonalli','Yohual');

-- Unidad 3: Nombres
INSERT INTO UNIT_VOCAB (UNIT_ID, VOCAB_ID)
SELECT U.ID, V.ID FROM UNITS U
JOIN LEVELS L ON U.LEVEL_ID = L.ID
JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
JOIN VOCABULARY V ON V.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 3
AND V.WORD IN ('Notoca','Quen','Quēmah','Ahmo');

-- Unidad 4: Gratitud
INSERT INTO UNIT_VOCAB (UNIT_ID, VOCAB_ID)
SELECT U.ID, V.ID FROM UNITS U
JOIN LEVELS L ON U.LEVEL_ID = L.ID
JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
JOIN VOCABULARY V ON V.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 4
AND V.WORD IN ('Tlazohcamati','Miac','Cualli','Timoittazceh');

-- Unidad 5: Estados
INSERT INTO UNIT_VOCAB (UNIT_ID, VOCAB_ID)
SELECT U.ID, V.ID FROM UNITS U
JOIN LEVELS L ON U.LEVEL_ID = L.ID
JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
JOIN VOCABULARY V ON V.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 5
AND V.WORD IN ('Huel','Quenin','Nicac','Ni','Ahmo cualli','Tlazohcamati');

-- Unidad 6: Conversación (todo el vocabulario nivel 1)
INSERT INTO UNIT_VOCAB (UNIT_ID, VOCAB_ID)
SELECT U.ID, V.ID FROM UNITS U
JOIN LEVELS L ON U.LEVEL_ID = L.ID
JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
JOIN VOCABULARY V ON V.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 6;

-- ─────────────────────────────────────────────
--  5b. LECCIONES — Nivel 1 (1 lección por unidad)
-- ─────────────────────────────────────────────
INSERT INTO LESSONS (UNIT_ID, LESSON_NUM, TITLE, DESCRIPTION, IS_FREE, XP_REWARD)
SELECT U.ID, 1, 'Saludos del día', 'Aprende a saludar en náhuatl según el momento del día', 1, 15
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 1;

INSERT INTO LESSONS (UNIT_ID, LESSON_NUM, TITLE, DESCRIPTION, IS_FREE, XP_REWARD)
SELECT U.ID, 1, 'Hola y adiós', 'Aprende a presentarte y despedirte', 0, 15
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 2;

INSERT INTO LESSONS (UNIT_ID, LESSON_NUM, TITLE, DESCRIPTION, IS_FREE, XP_REWARD)
SELECT U.ID, 1, '¿Cómo te llamas?', 'Aprende a preguntar y decir tu nombre', 0, 15
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 3;

INSERT INTO LESSONS (UNIT_ID, LESSON_NUM, TITLE, DESCRIPTION, IS_FREE, XP_REWARD)
SELECT U.ID, 1, 'Dar las gracias', 'Aprende a expresar gratitud en náhuatl', 0, 15
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 4;

INSERT INTO LESSONS (UNIT_ID, LESSON_NUM, TITLE, DESCRIPTION, IS_FREE, XP_REWARD)
SELECT U.ID, 1, '¿Cómo estás?', 'Aprende a expresar tu estado de ánimo', 0, 15
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 5;

INSERT INTO LESSONS (UNIT_ID, LESSON_NUM, TITLE, DESCRIPTION, IS_FREE, XP_REWARD)
SELECT U.ID, 1, 'Conversación completa', 'Integra todo lo aprendido en una conversación', 0, 20
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 6;

-- ─────────────────────────────────────────────
--  6. EJERCICIOS — Unidad 1 (6 ejercicios)
-- ─────────────────────────────────────────────
INSERT INTO EXERCISES (UNIT_ID, EXERCISE_TYPE, QUESTION, ANSWER, CORRECT_ANS, OPTIONS, CHARACTER_REF, EXPLANATION, POINTS, DIFFICULTY)
SELECT U.ID, 'multiple-choice', 'Selecciona la traducción correcta',
       'Bueno',
       '["Cualli"]',
       '["Cualli","Yohual","Niltze","Ahmo"]',
       'citlali',
       'Cualli significa bueno, buena, buenos, buenas o bien en náhuatl',
       15, 'medium'
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE='nhce' AND L.LEVEL_NUM=1 AND U.UNIT_NUM=1;

INSERT INTO EXERCISES (UNIT_ID, EXERCISE_TYPE, QUESTION, ANSWER, CORRECT_ANS, OPTIONS, CHARACTER_REF, EXPLANATION, POINTS, DIFFICULTY)
SELECT U.ID, 'multiple-choice', 'Selecciona la traducción correcta',
       'Día',
       '["Tonalli"]',
       '["Tonalli","Teotlac","Yohual","Cualli"]',
       'coltzin',
       'Tonalli significa día o días en náhuatl',
       15, 'medium'
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE='nhce' AND L.LEVEL_NUM=1 AND U.UNIT_NUM=1;

INSERT INTO EXERCISES (UNIT_ID, EXERCISE_TYPE, QUESTION, ANSWER, CORRECT_ANS, OPTIONS, CHARACTER_REF, EXPLANATION, POINTS, DIFFICULTY)
SELECT U.ID, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buenos días',
       '["Cualli tonalli"]',
       '["Cualli tonalli","Cualli yohual","Niltze","Timoittazceh"]',
       'neza',
       'Cualli tonalli es el saludo para buen día en náhuatl',
       15, 'medium'
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE='nhce' AND L.LEVEL_NUM=1 AND U.UNIT_NUM=1;

INSERT INTO EXERCISES (UNIT_ID, EXERCISE_TYPE, QUESTION, ANSWER, CORRECT_ANS, OPTIONS, CHARACTER_REF, EXPLANATION, POINTS, DIFFICULTY)
SELECT U.ID, 'multiple-choice', 'Selecciona la traducción correcta',
       'Noche',
       '["Yohual"]',
       '["Yohual","Tonalli","Teotlac","Cualli"]',
       'tonatiuh',
       'Yohual significa noche o noches en náhuatl',
       15, 'medium'
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE='nhce' AND L.LEVEL_NUM=1 AND U.UNIT_NUM=1;

INSERT INTO EXERCISES (UNIT_ID, EXERCISE_TYPE, QUESTION, ANSWER, CORRECT_ANS, OPTIONS, CHARACTER_REF, EXPLANATION, POINTS, DIFFICULTY)
SELECT U.ID, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tardes',
       '["Teotlac"]',
       '["Teotlac","Yohual","Tonalli","Niltze"]',
       'xochitl',
       'Teotlac significa tarde o tardes en náhuatl',
       15, 'medium'
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE='nhce' AND L.LEVEL_NUM=1 AND U.UNIT_NUM=1;

INSERT INTO EXERCISES (UNIT_ID, EXERCISE_TYPE, QUESTION, ANSWER, CORRECT_ANS, OPTIONS, CHARACTER_REF, EXPLANATION, POINTS, DIFFICULTY)
SELECT U.ID, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buenas noches',
       '["Cualli yohual"]',
       '["Cualli yohual","Cualli tonalli","Cualli teotlac","Niltze"]',
       'coltzin',
       'Cualli yohual es el saludo para buena noche en náhuatl',
       15, 'medium'
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE='nhce' AND L.LEVEL_NUM=1 AND U.UNIT_NUM=1;

-- ─────────────────────────────────────────────
--  7. SISTEMA DE ESCRITURA
-- ─────────────────────────────────────────────
INSERT INTO WRITING_SYSTEMS (LANGUAGE_ID, SYSTEM_TYPE, SYSTEM_NAME, DESCRIPTION, NOTES)
SELECT ID, 'syllabary', 'alfabeto',
       'Con base en la norma de escritura según el INALI',
       '["Algunas combinaciones [consonante - vocal] no existen en el idioma",
         "La U como vocal independiente no existe en náhuatl",
         "Las vocales largas (ā, ē, ī, ō) son distintivas y cambian el significado",
         "Los dígrafos representan fonemas unitarios (tl, tz, ch, qu, hu)"]'
FROM LANGUAGES WHERE CODE = 'nhce';

-- ─────────────────────────────────────────────
--  8. USER_PROGRESS — unidad 1 desbloqueada para usuario demo
-- ─────────────────────────────────────────────
INSERT INTO USER_PROGRESS (USER_ID, UNIT_ID, COMPLETED, IS_CURRENT, IS_LOCKED)
SELECT USR.ID, U.ID, 0, 1, 0
FROM USERS USR
CROSS JOIN (
    SELECT U.ID FROM UNITS U
    JOIN LEVELS L ON U.LEVEL_ID = L.ID
    JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
    WHERE LA.CODE = 'nhce' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 1
) U
WHERE USR.USERNAME = 'tetecuhtli';

-- ─────────────────────────────────────────────
--  9. USER_STATS — registro inicial para usuario demo
-- ─────────────────────────────────────────────
INSERT INTO USER_STATS (USER_ID, LANGUAGE_ID, WORDS_LEARNED, LESSONS_DONE, PERFECT_LESS, DAYS_STUDIED, BEST_STREAK, TOTAL_MINS)
SELECT USR.ID, LA.ID, 0, 0, 0, 0, 0, 0
FROM USERS USR
CROSS JOIN LANGUAGES LA
WHERE USR.USERNAME = 'tetecuhtli' AND LA.CODE = 'nhce';

-- ─────────────────────────────────────────────
--  VERIFICACIÓN
-- ─────────────────────────────────────────────
SELECT 'LANGUAGES (nhce)'       AS TABLA, COUNT(*) AS REGISTROS FROM LANGUAGES    WHERE CODE = 'nhce'    UNION ALL
SELECT 'LEVELS (nhce)',          COUNT(*) FROM LEVELS    WHERE LANGUAGE_ID = (SELECT ID FROM LANGUAGES WHERE CODE='nhce') UNION ALL
SELECT 'UNITS (nhce)',           COUNT(*) FROM UNITS     WHERE LEVEL_ID IN (SELECT ID FROM LEVELS WHERE LANGUAGE_ID = (SELECT ID FROM LANGUAGES WHERE CODE='nhce')) UNION ALL
SELECT 'VOCABULARY (nhce)',      COUNT(*) FROM VOCABULARY WHERE LANGUAGE_ID = (SELECT ID FROM LANGUAGES WHERE CODE='nhce') UNION ALL
SELECT 'EXERCISES (nhce)',       COUNT(*) FROM EXERCISES  WHERE UNIT_ID IN (SELECT U.ID FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID=L.ID WHERE L.LANGUAGE_ID=(SELECT ID FROM LANGUAGES WHERE CODE='nhce')) UNION ALL
SELECT 'WRITING_SYSTEMS (nhce)', COUNT(*) FROM WRITING_SYSTEMS WHERE LANGUAGE_ID = (SELECT ID FROM LANGUAGES WHERE CODE='nhce');
