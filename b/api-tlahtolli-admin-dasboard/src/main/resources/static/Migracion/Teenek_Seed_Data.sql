-- ============================================================
--  SEED DATA — Huasteco / Tének (tkoc)
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
--
--  NOTA: El sistema de escritura del Tének usa el alfabeto latino
--        con caracteres especiales. En el schema se mapea como
--        'alphabet' para cumplir el CHK_LANGUAGES_WS constraint.
-- ============================================================

-- ─────────────────────────────────────────────
--  1. IDIOMA
-- ─────────────────────────────────────────────
INSERT INTO LANGUAGES (CODE, LANG_NAME, NATIVE_NAME, COLOR, FLAG, FAMILY, WRITING_SYSTEM)
VALUES ('tkoc', 'Huasteco de Occidente', 'Tének Occidental', '#58CC02', '🌿', 'maya', 'alphabet');

-- ─────────────────────────────────────────────
--  2. NIVELES
-- ─────────────────────────────────────────────
INSERT INTO LEVELS (LANGUAGE_ID, LEVEL_NUM, TITLE, TITLE_NATIVE, COLOR, TOTAL_UNITS, UNLOCK_REQ, IS_FREE)
SELECT ID, 1, 'Saluda y preséntate', 'Tsakalwaꞌ wakꞌaꞌleꞌt wakꞌin',
       '#4bb101', 6, 'Ninguno - Nivel inicial', 1
FROM LANGUAGES WHERE CODE = 'tkoc';

INSERT INTO LEVELS (LANGUAGE_ID, LEVEL_NUM, TITLE, TITLE_NATIVE, COLOR, TOTAL_UNITS, UNLOCK_REQ, IS_FREE)
SELECT ID, 2, 'Descríbete y describe a tu familia', 'Wakꞌaꞌleꞌt kaꞌ wakꞌaꞌleꞌt in alaꞌak',
       '#1CB0F6', 6, 'Completar Nivel 1', 0
FROM LANGUAGES WHERE CODE = 'tkoc';

INSERT INTO LEVELS (LANGUAGE_ID, LEVEL_NUM, TITLE, TITLE_NATIVE, COLOR, TOTAL_UNITS, UNLOCK_REQ, IS_FREE)
SELECT ID, 3, 'Pide y da información', 'Tseꞌek wakꞌaꞌlꞌaw kaꞌ tsiꞌek',
       '#FF9600', 6, 'Completar Nivel 2', 0
FROM LANGUAGES WHERE CODE = 'tkoc';

INSERT INTO LEVELS (LANGUAGE_ID, LEVEL_NUM, TITLE, TITLE_NATIVE, COLOR, TOTAL_UNITS, UNLOCK_REQ, IS_FREE)
SELECT ID, 4, 'Habla en tiempos (ayer/hoy/mañana)', 'Watꞌanab tiemp (kꞌinal / uxum / uxukꞌab)',
       '#FF4B4B', 6, 'Completar Nivel 3', 0
FROM LANGUAGES WHERE CODE = 'tkoc';

INSERT INTO LEVELS (LANGUAGE_ID, LEVEL_NUM, TITLE, TITLE_NATIVE, COLOR, TOTAL_UNITS, UNLOCK_REQ, IS_FREE)
SELECT ID, 5, 'Describe un día normal', 'Wakꞌaꞌleꞌt jun kꞌinal kaꞌax',
       '#26CCC0', 6, 'Completar Nivel 4', 0
FROM LANGUAGES WHERE CODE = 'tkoc';

INSERT INTO LEVELS (LANGUAGE_ID, LEVEL_NUM, TITLE, TITLE_NATIVE, COLOR, TOTAL_UNITS, UNLOCK_REQ, IS_FREE)
SELECT ID, 6, 'Describe y expresa preferencias', 'Wakꞌaꞌleꞌt kaꞌ tsiꞌek kꞌaꞌ kꞌakꞌun',
       '#9C27B0', 6, 'Completar Nivel 5', 0
FROM LANGUAGES WHERE CODE = 'tkoc';

-- ─────────────────────────────────────────────
--  3. UNIDADES — Nivel 1
-- ─────────────────────────────────────────────
INSERT INTO UNITS (LEVEL_ID, UNIT_NUM, TITLE, COLOR, OBJECTIVE, GRAMMAR, IS_FREE, UNLOCK_REQ)
SELECT L.ID, 1, 'Tsakalwaꞌ (Saludos básicos)', '#4bb101',
       'Aprender saludos básicos del día y la noche',
       'Estructura básica de saludos', 1, NULL
FROM LEVELS L JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'tkoc' AND L.LEVEL_NUM = 1;

INSERT INTO UNITS (LEVEL_ID, UNIT_NUM, TITLE, COLOR, OBJECTIVE, GRAMMAR, IS_FREE, UNLOCK_REQ)
SELECT L.ID, 2, 'Wakꞌin (Presentaciones simples)', '#4bb101',
       'Aprender a presentarse y despedirse',
       'Uso de "Wakꞌaꞌ" y "Kꞌaꞌakꞌaꞌab"', 0, 'Completar Unidad 1'
FROM LEVELS L JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'tkoc' AND L.LEVEL_NUM = 1;

INSERT INTO UNITS (LEVEL_ID, UNIT_NUM, TITLE, COLOR, OBJECTIVE, GRAMMAR, IS_FREE, UNLOCK_REQ)
SELECT L.ID, 3, 'Kꞌaꞌ in wakꞌaꞌl (Cómo te llamas)', '#4bb101',
       'Aprender a preguntar y decir nombres',
       'Uso de "Wakꞌaꞌ" y "Kꞌaꞌ wakꞌaꞌl"', 0, 'Completar Unidad 2'
FROM LEVELS L JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'tkoc' AND L.LEVEL_NUM = 1;

INSERT INTO UNITS (LEVEL_ID, UNIT_NUM, TITLE, COLOR, OBJECTIVE, GRAMMAR, IS_FREE, UNLOCK_REQ)
SELECT L.ID, 4, 'Expresar gratitud', '#4bb101',
       'Aprender a dar las gracias',
       'Uso de "Jawꞌab" y "Lakꞌam"', 0, 'Completar Unidad 3'
FROM LEVELS L JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'tkoc' AND L.LEVEL_NUM = 1;

INSERT INTO UNITS (LEVEL_ID, UNIT_NUM, TITLE, COLOR, OBJECTIVE, GRAMMAR, IS_FREE, UNLOCK_REQ)
SELECT L.ID, 5, 'Estados y condiciones', '#4bb101',
       'Aprender a expresar cómo estás',
       'Uso de "Wakꞌaꞌ", "Kꞌaw" y "Kꞌakꞌun"', 0, 'Completar Unidad 4'
FROM LEVELS L JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'tkoc' AND L.LEVEL_NUM = 1;

INSERT INTO UNITS (LEVEL_ID, UNIT_NUM, TITLE, COLOR, OBJECTIVE, GRAMMAR, IS_FREE, UNLOCK_REQ)
SELECT L.ID, 6, 'Conversación básica', '#4bb101',
       'Integrar todo lo aprendido en una conversación',
       'Estructura completa de conversación básica', 0, 'Completar Unidad 5'
FROM LEVELS L JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'tkoc' AND L.LEVEL_NUM = 1;

-- ─────────────────────────────────────────────
--  4. VOCABULARIO — Nivel 1
-- ─────────────────────────────────────────────
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Tsakalwaꞌ',        'hola',                   'tsa-kal-wa',        NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Kꞌaꞌakꞌaꞌab',      'adiós',                  'kꞌa-akꞌ-a-ab',      NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Wakꞌaꞌ',           'yo soy',                 'wak-ꞌa',            NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Kꞌaw',             'bueno / bien',           'kꞌaw',              NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Jawꞌab',           'gracias',                'jaw-ab',            NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Kꞌinal',           'día',                    'kꞌi-nal',           NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Akꞌab',            'noche',                  'ak-ab',             NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Uxum',             'tarde',                  'u-xum',             NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Haꞌ',              'sí',                     'ha',                NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Maꞌ',              'no',                     'ma',                NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Kꞌaꞌ',             'cómo / qué',             'kꞌa',               NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Lakꞌam',           'mucho',                  'lak-am',            NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Kꞌakꞌun',          'muy / verdaderamente',   'kꞌak-un',           NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'In',               'mi',                     'in',                NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Tukin',            'nombre',                 'tu-kin',            NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Wakꞌaꞌl',          'llamarse',               'wak-ꞌal',           NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Kaꞌax',            'bien / correcto',        'ka-ax',             NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Maꞌ kꞌaw',         'mal / no bien',          'ma kꞌaw',           NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Kꞌaw kꞌinal',      'buen día',               'kꞌaw kꞌi-nal',      NULL FROM LANGUAGES WHERE CODE='tkoc';
INSERT INTO VOCABULARY (LANGUAGE_ID, WORD, TRANSLATION, PRONUNCIATION, EXAMPLE)
SELECT ID, 'Kꞌaw akꞌab',       'buena noche',            'kꞌaw ak-ab',        NULL FROM LANGUAGES WHERE CODE='tkoc';

-- ─────────────────────────────────────────────
--  5. UNIT_VOCAB — asociar vocabulario a unidades
-- ─────────────────────────────────────────────
-- Unidad 1: Saludos básicos
INSERT INTO UNIT_VOCAB (UNIT_ID, VOCAB_ID)
SELECT U.ID, V.ID FROM UNITS U
JOIN LEVELS L ON U.LEVEL_ID = L.ID
JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
JOIN VOCABULARY V ON V.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'tkoc' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 1
AND V.WORD IN ('Tsakalwaꞌ','Kꞌinal','Akꞌab','Uxum','Kꞌaw kꞌinal','Kꞌaw akꞌab');

-- Unidad 2: Presentaciones
INSERT INTO UNIT_VOCAB (UNIT_ID, VOCAB_ID)
SELECT U.ID, V.ID FROM UNITS U
JOIN LEVELS L ON U.LEVEL_ID = L.ID
JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
JOIN VOCABULARY V ON V.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'tkoc' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 2
AND V.WORD IN ('Tsakalwaꞌ','Kꞌaꞌakꞌaꞌab','Wakꞌaꞌ','Kꞌaw','Haꞌ','Maꞌ');

-- Unidad 3: Nombres
INSERT INTO UNIT_VOCAB (UNIT_ID, VOCAB_ID)
SELECT U.ID, V.ID FROM UNITS U
JOIN LEVELS L ON U.LEVEL_ID = L.ID
JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
JOIN VOCABULARY V ON V.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'tkoc' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 3
AND V.WORD IN ('Wakꞌaꞌ','Wakꞌaꞌl','Tukin','Kꞌaꞌ','In');

-- Unidad 4: Gratitud
INSERT INTO UNIT_VOCAB (UNIT_ID, VOCAB_ID)
SELECT U.ID, V.ID FROM UNITS U
JOIN LEVELS L ON U.LEVEL_ID = L.ID
JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
JOIN VOCABULARY V ON V.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'tkoc' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 4
AND V.WORD IN ('Jawꞌab','Lakꞌam','Kꞌaw','Kꞌaꞌakꞌaꞌab');

-- Unidad 5: Estados
INSERT INTO UNIT_VOCAB (UNIT_ID, VOCAB_ID)
SELECT U.ID, V.ID FROM UNITS U
JOIN LEVELS L ON U.LEVEL_ID = L.ID
JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
JOIN VOCABULARY V ON V.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'tkoc' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 5
AND V.WORD IN ('Kꞌakꞌun','Kꞌaw','Wakꞌaꞌ','Kꞌaꞌ','Maꞌ kꞌaw','Kaꞌax');

-- Unidad 6: Conversación (todo el vocabulario nivel 1)
INSERT INTO UNIT_VOCAB (UNIT_ID, VOCAB_ID)
SELECT U.ID, V.ID FROM UNITS U
JOIN LEVELS L ON U.LEVEL_ID = L.ID
JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
JOIN VOCABULARY V ON V.LANGUAGE_ID = LA.ID
WHERE LA.CODE = 'tkoc' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 6;

-- ─────────────────────────────────────────────
--  6. EJERCICIOS — Unidad 1 (6 ejercicios)
-- ─────────────────────────────────────────────
INSERT INTO EXERCISES (UNIT_ID, EXERCISE_TYPE, QUESTION, ANSWER, CORRECT_ANS, OPTIONS, CHARACTER_REF, EXPLANATION, POINTS, DIFFICULTY)
SELECT U.ID, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hola',
       '["Tsakalwaꞌ"]',
       '["Tsakalwaꞌ","Kꞌaw","Kꞌinal","Maꞌ"]',
       'citlali',
       'Tsakalwaꞌ significa hola en tének',
       15, 'medium'
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE='tkoc' AND L.LEVEL_NUM=1 AND U.UNIT_NUM=1;

INSERT INTO EXERCISES (UNIT_ID, EXERCISE_TYPE, QUESTION, ANSWER, CORRECT_ANS, OPTIONS, CHARACTER_REF, EXPLANATION, POINTS, DIFFICULTY)
SELECT U.ID, 'multiple-choice', 'Selecciona la traducción correcta',
       'Día',
       '["Kꞌinal"]',
       '["Kꞌinal","Akꞌab","Uxum","Kꞌaw"]',
       'coltzin',
       'Kꞌinal significa día en tének',
       15, 'medium'
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE='tkoc' AND L.LEVEL_NUM=1 AND U.UNIT_NUM=1;

INSERT INTO EXERCISES (UNIT_ID, EXERCISE_TYPE, QUESTION, ANSWER, CORRECT_ANS, OPTIONS, CHARACTER_REF, EXPLANATION, POINTS, DIFFICULTY)
SELECT U.ID, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buen día',
       '["Kꞌaw kꞌinal"]',
       '["Kꞌaw kꞌinal","Kꞌaw akꞌab","Tsakalwaꞌ","Kꞌaꞌakꞌaꞌab"]',
       'neza',
       'Kꞌaw kꞌinal es el saludo para buen día en tének',
       15, 'medium'
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE='tkoc' AND L.LEVEL_NUM=1 AND U.UNIT_NUM=1;

INSERT INTO EXERCISES (UNIT_ID, EXERCISE_TYPE, QUESTION, ANSWER, CORRECT_ANS, OPTIONS, CHARACTER_REF, EXPLANATION, POINTS, DIFFICULTY)
SELECT U.ID, 'multiple-choice', 'Selecciona la traducción correcta',
       'Noche',
       '["Akꞌab"]',
       '["Akꞌab","Kꞌinal","Uxum","Kꞌaw"]',
       'tonatiuh',
       'Akꞌab significa noche en tének',
       15, 'medium'
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE='tkoc' AND L.LEVEL_NUM=1 AND U.UNIT_NUM=1;

INSERT INTO EXERCISES (UNIT_ID, EXERCISE_TYPE, QUESTION, ANSWER, CORRECT_ANS, OPTIONS, CHARACTER_REF, EXPLANATION, POINTS, DIFFICULTY)
SELECT U.ID, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tarde',
       '["Uxum"]',
       '["Uxum","Akꞌab","Kꞌinal","Tsakalwaꞌ"]',
       'xochitl',
       'Uxum significa tarde en tének',
       15, 'medium'
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE='tkoc' AND L.LEVEL_NUM=1 AND U.UNIT_NUM=1;

INSERT INTO EXERCISES (UNIT_ID, EXERCISE_TYPE, QUESTION, ANSWER, CORRECT_ANS, OPTIONS, CHARACTER_REF, EXPLANATION, POINTS, DIFFICULTY)
SELECT U.ID, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buena noche',
       '["Kꞌaw akꞌab"]',
       '["Kꞌaw akꞌab","Kꞌaw kꞌinal","Tsakalwaꞌ","Kꞌaꞌakꞌaꞌab"]',
       'coltzin',
       'Kꞌaw akꞌab es el saludo para buena noche en tének',
       15, 'medium'
FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID = L.ID JOIN LANGUAGES LA ON L.LANGUAGE_ID = LA.ID
WHERE LA.CODE='tkoc' AND L.LEVEL_NUM=1 AND U.UNIT_NUM=1;

-- ─────────────────────────────────────────────
--  7. SISTEMA DE ESCRITURA
-- ─────────────────────────────────────────────
--  NOTA: SYSTEM_TYPE usa 'alphabet' (valor válido del CHK constraint).
INSERT INTO WRITING_SYSTEMS (LANGUAGE_ID, SYSTEM_TYPE, SYSTEM_NAME, DESCRIPTION, NOTES)
SELECT ID, 'alphabet', 'alfabeto tének',
       'Con base en la norma de escritura del tének según el INALI',
       '["El tének usa el alfabeto latino con caracteres especiales como ꞌ (saltillo)",
         "Las vocales pueden ser cortas o largas: a, e, i, o / aa, ee, ii, oo",
         "El saltillo (ꞌ) representa una pausa glotal",
         "Los sonidos característicos: ts, tz, ch, ꞌ"]'
FROM LANGUAGES WHERE CODE = 'tkoc';

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
    WHERE LA.CODE = 'tkoc' AND L.LEVEL_NUM = 1 AND U.UNIT_NUM = 1
) U
WHERE USR.USERNAME = 'tetecuhtli';

-- ─────────────────────────────────────────────
--  9. USER_STATS — registro inicial para usuario demo
-- ─────────────────────────────────────────────
INSERT INTO USER_STATS (USER_ID, LANGUAGE_ID, WORDS_LEARNED, LESSONS_DONE, PERFECT_LESS, DAYS_STUDIED, BEST_STREAK, TOTAL_MINS)
SELECT USR.ID, LA.ID, 0, 0, 0, 0, 0, 0
FROM USERS USR
CROSS JOIN LANGUAGES LA
WHERE USR.USERNAME = 'tetecuhtli' AND LA.CODE = 'tkoc';

-- ─────────────────────────────────────────────
--  VERIFICACIÓN
-- ─────────────────────────────────────────────
SELECT 'LANGUAGES (tkoc)'       AS TABLA, COUNT(*) AS REGISTROS FROM LANGUAGES       WHERE CODE = 'tkoc'    UNION ALL
SELECT 'LEVELS (tkoc)',          COUNT(*) FROM LEVELS        WHERE LANGUAGE_ID = (SELECT ID FROM LANGUAGES WHERE CODE='tkoc') UNION ALL
SELECT 'UNITS (tkoc)',           COUNT(*) FROM UNITS         WHERE LEVEL_ID IN (SELECT ID FROM LEVELS WHERE LANGUAGE_ID = (SELECT ID FROM LANGUAGES WHERE CODE='tkoc')) UNION ALL
SELECT 'VOCABULARY (tkoc)',      COUNT(*) FROM VOCABULARY    WHERE LANGUAGE_ID = (SELECT ID FROM LANGUAGES WHERE CODE='tkoc') UNION ALL
SELECT 'EXERCISES (tkoc)',       COUNT(*) FROM EXERCISES      WHERE UNIT_ID IN (SELECT U.ID FROM UNITS U JOIN LEVELS L ON U.LEVEL_ID=L.ID WHERE L.LANGUAGE_ID=(SELECT ID FROM LANGUAGES WHERE CODE='tkoc')) UNION ALL
SELECT 'WRITING_SYSTEMS (tkoc)', COUNT(*) FROM WRITING_SYSTEMS WHERE LANGUAGE_ID = (SELECT ID FROM LANGUAGES WHERE CODE='tkoc');
