-- ============================================================
--  seed de prueba — Zapoteco del Istmo (zai)  · curso en pruebas (status = 'draft')
--  tlahtolcalli  [postgresql]
--
--  variante base: zapoteco del istmo de tehuantepec (juchitán, oaxaca) · iso 639-3: zai
--  ejecutar después de 8.-estado_cursos.sql (columna status).
--
--  contenido mínimo para probar el front de desarrollo:
--    2 niveles · 6 unidades · 26 palabras · ejercicios por unidad
--
--  ortografía: alfabeto popular del zapoteco del istmo

--    · Vocal doble = vocal larga o cortada: diidxa', yoo, beeu
--    · La comilla sola es el corte glotal: guie', xuba'
--    · xh suena como sh suave (bixhoze); x como sh fuerte (xiiñi')
--    · dx suena parecido a la j del inglés (diidxa', gubidxa)
--    · El acento marca el tono alto donde hace falta distinguir palabras (xquíxe)
--
--  borrador para pruebas: palabras, traducciones y pronunciaciones deben
--  validarse con hablantes antes de publicar el curso.
--
--  re-ejecutable: borra primero todo lo de 'zai'.
-- ============================================================

begin;

-- 0. limpieza (re-ejecución)
update ta_users set current_lang = null
 where current_lang = (select id from ct_languages where code = 'zai');
delete from ta_user_stats
 where language_id = (select id from ct_languages where code = 'zai');
delete from ta_user_achievements where language_tag = 'zai';
delete from ct_languages where code = 'zai';   -- en cascada: niveles, unidades, vocabulario, ejercicios, progreso

-- 1. idioma (en pruebas: solo se ve en el front de desarrollo)
insert into ct_languages (code, lang_name, native_name, color, flag, family, writing_system, status)
values ('zai', 'Zapoteco del Istmo', 'Diidxazá', null, '🌺', 'otomangue', 'alphabet', 'draft');

-- 2. niveles
insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 1, 'Saluda y preséntate', 'Padiuxi', null, 3, 'Ninguno - Nivel inicial', 1
from ct_languages where code = 'zai';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 2, 'Tu mundo cercano', 'Yoo', null, 3, 'Completar Nivel 1', 0
from ct_languages where code = 'zai';

-- 3. unidades
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Saludos', null, 'Saludar, dar las gracias y nombrar la lengua', 'Diidxa'' = palabra; zá = nube: diidxazá es la lengua de la gente de las nubes (binnizá)', 1, null
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, '¿Quién eres?', null, 'Preguntar el nombre y conocer los pronombres', 'Naa (yo), lii (tú), laabe (él, ella)', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Números', null, 'Contar del uno al cinco', 'Los números van antes de lo que cuentan', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Familia', null, 'Nombrar a la familia', 'Jñaa = madre; bixhoze = padre', 1, null
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Casa y comida', null, 'Nombrar cosas de la casa y la comida', 'Yoo = casa', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Naturaleza', null, 'Nombrar elementos de la naturaleza', 'Gubidxa = sol; beeu = luna', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2;

-- 4. vocabulario
-- nivel 1 · unidad 1: saludos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Padiuxi', 'hola / buenos días', 'pa-diu-xi', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Xi modo nuu lii?', '¿cómo estás?', 'xi mo-do nuu lii', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Xquíxe pe'' lii', 'muchas gracias', 'xquí-xe pe'' lii', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Diidxazá', 'lengua zapoteca', 'dii-dxa-zá', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Binnizá', 'gente zapoteca', 'bin-ni-zá', null from ct_languages where code = 'zai';
-- nivel 1 · unidad 2: ¿quién eres?
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Xi lalu''?', '¿cómo te llamas?', 'xi la-lu''', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Naa', 'yo', 'naa', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Lii', 'tú', 'lii', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Laabe', 'él / ella', 'laa-be', null from ct_languages where code = 'zai';
-- nivel 1 · unidad 3: números
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tobi', 'uno', 'to-bi', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Chupa', 'dos', 'chu-pa', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Chonna', 'tres', 'chon-na', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tapa', 'cuatro', 'ta-pa', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Gaayu''', 'cinco', 'gaa-yu''', null from ct_languages where code = 'zai';
-- nivel 2 · unidad 1: familia
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Jñaa', 'mamá', 'jñaa', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Bixhoze', 'papá', 'bi-xho-ze', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Xiiñi''', 'hijo / hija', 'xii-ñi''', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Badudxaapa''', 'muchacha', 'ba-du-dxaa-pa''', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Badunguiiu', 'muchacho', 'ba-dun-guiiu', null from ct_languages where code = 'zai';
-- nivel 2 · unidad 2: casa y comida
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yoo', 'casa', 'yoo', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nisa', 'agua', 'ni-sa', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Xuba''', 'maíz (grano)', 'xu-ba''', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Gueta', 'tortilla', 'gue-ta', null from ct_languages where code = 'zai';
-- nivel 2 · unidad 3: naturaleza
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Gubidxa', 'sol', 'gu-bi-dxa', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Beeu', 'luna', 'beeu', null from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Guie''', 'flor', 'guie''', null from ct_languages where code = 'zai';

-- 5. vocabulario por unidad
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1
and v.word in ('Padiuxi', 'Xi modo nuu lii?', 'Xquíxe pe'' lii', 'Diidxazá', 'Binnizá');

insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 2
and v.word in ('Xi lalu''?', 'Naa', 'Lii', 'Laabe');

insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 3
and v.word in ('Tobi', 'Chupa', 'Chonna', 'Tapa', 'Gaayu''');

insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 1
and v.word in ('Jñaa', 'Bixhoze', 'Xiiñi''', 'Badudxaapa''', 'Badunguiiu');

insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 2
and v.word in ('Yoo', 'Nisa', 'Xuba''', 'Gueta');

insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 3
and v.word in ('Gubidxa', 'Beeu', 'Guie''');

-- 6. ejercicios (opción múltiple por palabra + uno de completar o traducción inversa)
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hola / buenos días',
       '["Padiuxi"]',
       '["Diidxazá", "Padiuxi", "Xi lalu''?", "Lii"]',
       'citlali',
       'Padiuxi significa hola / buenos días',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cómo estás?',
       '["Xi modo nuu lii?"]',
       '["Naa", "Laabe", "Xi modo nuu lii?", "Chupa"]',
       'coltzin',
       'Xi modo nuu lii? significa ¿cómo estás?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muchas gracias',
       '["Xquíxe pe'' lii"]',
       '["Tobi", "Chonna", "Gaayu''", "Xquíxe pe'' lii"]',
       'neza',
       'Xquíxe pe'' lii significa muchas gracias',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lengua zapoteca',
       '["Diidxazá"]',
       '["Diidxazá", "Tapa", "Jñaa", "Xiiñi''"]',
       'tonatiuh',
       'Diidxazá significa lengua zapoteca',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Gente zapoteca',
       '["Binnizá"]',
       '["Bixhoze", "Binnizá", "Badudxaapa''", "Yoo"]',
       'xochitl',
       'Binnizá significa gente zapoteca',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ modo nuu lii?',
       '["Xi", "Xi modo nuu lii?"]',
       null,
       'citlali',
       'Xi modo nuu lii? significa ¿cómo estás?',
       20, 'medium', '¿Cómo estás?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cómo te llamas?',
       '["Xi lalu''?"]',
       '["Diidxazá", "Naa", "Xi lalu''?", "Laabe"]',
       'coltzin',
       'Xi lalu''? significa ¿cómo te llamas?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Yo',
       '["Naa"]',
       '["Lii", "Tobi", "Chonna", "Naa"]',
       'neza',
       'Naa significa yo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tú',
       '["Lii"]',
       '["Lii", "Chupa", "Tapa", "Jñaa"]',
       'tonatiuh',
       'Lii significa tú',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Él / ella',
       '["Laabe"]',
       '["Gaayu''", "Laabe", "Bixhoze", "Badudxaapa''"]',
       'xochitl',
       'Laabe significa él / ella',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ lalu''?',
       '["Xi", "Xi lalu''?"]',
       null,
       'citlali',
       'Xi lalu''? significa ¿cómo te llamas?',
       20, 'medium', '¿Cómo te llamas?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Uno',
       '["Tobi"]',
       '["Binnizá", "Naa", "Laabe", "Tobi"]',
       'coltzin',
       'Tobi significa uno',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dos',
       '["Chupa"]',
       '["Chupa", "Lii", "Tobi", "Tapa"]',
       'neza',
       'Chupa significa dos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tres',
       '["Chonna"]',
       '["Chupa", "Chonna", "Gaayu''", "Bixhoze"]',
       'tonatiuh',
       'Chonna significa tres',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cuatro',
       '["Tapa"]',
       '["Jñaa", "Xiiñi''", "Tapa", "Badunguiiu"]',
       'xochitl',
       'Tapa significa cuatro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cinco',
       '["Gaayu''"]',
       '["Badudxaapa''", "Yoo", "Xuba''", "Gaayu''"]',
       'citlali',
       'Gaayu'' significa cinco',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', '¿Qué significa?',
       'Tobi',
       '["uno"]',
       '["muchacha", "agua", "sol", "uno"]',
       'coltzin',
       'Tobi significa uno',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mamá',
       '["Jñaa"]',
       '["Diidxazá", "Jñaa", "Xi lalu''?", "Lii"]',
       'neza',
       'Jñaa significa mamá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Papá',
       '["Bixhoze"]',
       '["Naa", "Laabe", "Bixhoze", "Chupa"]',
       'tonatiuh',
       'Bixhoze significa papá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hijo / hija',
       '["Xiiñi''"]',
       '["Tobi", "Chonna", "Gaayu''", "Xiiñi''"]',
       'xochitl',
       'Xiiñi'' significa hijo / hija',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muchacha',
       '["Badudxaapa''"]',
       '["Badudxaapa''", "Tapa", "Jñaa", "Xiiñi''"]',
       'citlali',
       'Badudxaapa'' significa muchacha',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muchacho',
       '["Badunguiiu"]',
       '["Bixhoze", "Badunguiiu", "Badudxaapa''", "Nisa"]',
       'coltzin',
       'Badunguiiu significa muchacho',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', '¿Qué significa?',
       'Jñaa',
       '["mamá"]',
       '["tú", "mamá", "dos", "cinco"]',
       'neza',
       'Jñaa significa mamá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Casa',
       '["Yoo"]',
       '["Binnizá", "Naa", "Yoo", "Laabe"]',
       'tonatiuh',
       'Yoo significa casa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Agua',
       '["Nisa"]',
       '["Lii", "Tobi", "Chonna", "Nisa"]',
       'xochitl',
       'Nisa significa agua',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Maíz (grano)',
       '["Xuba''"]',
       '["Xuba''", "Chupa", "Tapa", "Jñaa"]',
       'citlali',
       'Xuba'' significa maíz (grano)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tortilla',
       '["Gueta"]',
       '["Gaayu''", "Gueta", "Bixhoze", "Badudxaapa''"]',
       'coltzin',
       'Gueta significa tortilla',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', '¿Qué significa?',
       'Yoo',
       '["casa"]',
       '["cuatro", "papá", "casa", "muchacho"]',
       'neza',
       'Yoo significa casa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Sol',
       '["Gubidxa"]',
       '["Xi lalu''?", "Lii", "Tobi", "Gubidxa"]',
       'tonatiuh',
       'Gubidxa significa sol',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Luna',
       '["Beeu"]',
       '["Beeu", "Laabe", "Chupa", "Tapa"]',
       'xochitl',
       'Beeu significa luna',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Flor',
       '["Guie''"]',
       '["Chonna", "Guie''", "Gaayu''", "Bixhoze"]',
       'citlali',
       'Guie'' significa flor',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', '¿Qué significa?',
       'Gubidxa',
       '["sol"]',
       '["muchacha", "agua", "luna", "sol"]',
       'coltzin',
       'Gubidxa significa sol',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 3;

-- 7. sistema de escritura
insert into ct_writing_systems (language_id, system_type, system_name, description, characters, notes)
select id, 'alphabet', 'alfabeto popular zapoteco',
       'Alfabeto popular del zapoteco del Istmo. Variante base: Juchitán. Borrador de prueba, pendiente de validar con hablantes.',
       '[
    {
        "type": "vowel",
        "letter": "a",
        "pronunciation": "a",
        "syllables": {
            "a": "a",
            "e": null,
            "i": null,
            "o": null,
            "u": null
        },
        "example": "Nisa"
    },
    {
        "type": "vowel",
        "letter": "e",
        "pronunciation": "e",
        "syllables": {
            "a": null,
            "e": "e",
            "i": null,
            "o": null,
            "u": null
        },
        "example": "Gueta"
    },
    {
        "type": "vowel",
        "letter": "i",
        "pronunciation": "i",
        "syllables": {
            "a": null,
            "e": null,
            "i": "i",
            "o": null,
            "u": null
        },
        "example": "Lii"
    },
    {
        "type": "vowel",
        "letter": "o",
        "pronunciation": "o",
        "syllables": {
            "a": null,
            "e": null,
            "i": null,
            "o": "o",
            "u": null
        },
        "example": "Tobi"
    },
    {
        "type": "vowel",
        "letter": "u",
        "pronunciation": "u",
        "syllables": {
            "a": null,
            "e": null,
            "i": null,
            "o": null,
            "u": "u"
        },
        "example": "Chupa"
    },
    {
        "type": "longVowel",
        "letter": "aa",
        "pronunciation": "a larga o cortada",
        "syllables": {
            "a": "aa (a larga o cortada)"
        },
        "example": "Naa"
    },
    {
        "type": "longVowel",
        "letter": "ee",
        "pronunciation": "e larga o cortada",
        "syllables": {
            "e": "ee (e larga o cortada)"
        },
        "example": "Beeu"
    },
    {
        "type": "longVowel",
        "letter": "ii",
        "pronunciation": "i larga o cortada",
        "syllables": {
            "i": "ii (i larga o cortada)"
        },
        "example": "Diidxa''"
    },
    {
        "type": "longVowel",
        "letter": "oo",
        "pronunciation": "o larga o cortada",
        "syllables": {
            "o": "oo (o larga o cortada)"
        },
        "example": "Yoo"
    },
    {
        "type": "longVowel",
        "letter": "uu",
        "pronunciation": "u larga o cortada",
        "syllables": {
            "u": "uu (u larga o cortada)"
        },
        "example": "Nuu"
    },
    {
        "type": "consonant",
        "letter": "b",
        "pronunciation": "b",
        "syllables": {
            "a": "ba",
            "e": "be",
            "i": "bi",
            "o": "bo",
            "u": "bu"
        },
        "example": "Beeu"
    },
    {
        "type": "consonant",
        "letter": "ch",
        "pronunciation": "ch",
        "syllables": {
            "a": "cha",
            "e": "che",
            "i": "chi",
            "o": "cho",
            "u": "chu"
        },
        "example": "Chupa"
    },
    {
        "type": "consonant",
        "letter": "d",
        "pronunciation": "d",
        "syllables": {
            "a": "da",
            "e": "de",
            "i": "di",
            "o": "do",
            "u": "du"
        },
        "example": "Diidxa''"
    },
    {
        "type": "consonant",
        "letter": "dx",
        "pronunciation": "dy",
        "syllables": {
            "a": "dxa",
            "e": "dxe",
            "i": "dxi",
            "o": "dxo",
            "u": "dxu"
        },
        "example": "Gubidxa"
    },
    {
        "type": "consonant",
        "letter": "g",
        "pronunciation": "g",
        "syllables": {
            "a": "ga",
            "e": "ge",
            "i": "gi",
            "o": "go",
            "u": "gu"
        },
        "example": "Gueta"
    },
    {
        "type": "consonant",
        "letter": "l",
        "pronunciation": "l",
        "syllables": {
            "a": "la",
            "e": "le",
            "i": "li",
            "o": "lo",
            "u": "lu"
        },
        "example": "Laabe"
    },
    {
        "type": "consonant",
        "letter": "m",
        "pronunciation": "m",
        "syllables": {
            "a": "ma",
            "e": "me",
            "i": "mi",
            "o": "mo",
            "u": "mu"
        },
        "example": "Modo"
    },
    {
        "type": "consonant",
        "letter": "n",
        "pronunciation": "n",
        "syllables": {
            "a": "na",
            "e": "ne",
            "i": "ni",
            "o": "no",
            "u": "nu"
        },
        "example": "Nisa"
    },
    {
        "type": "consonant",
        "letter": "ñ",
        "pronunciation": "ñ",
        "syllables": {
            "a": "ña",
            "e": "ñe",
            "i": "ñi",
            "o": "ño",
            "u": "ñu"
        },
        "example": "Jñaa"
    },
    {
        "type": "consonant",
        "letter": "p",
        "pronunciation": "p",
        "syllables": {
            "a": "pa",
            "e": "pe",
            "i": "pi",
            "o": "po",
            "u": "pu"
        },
        "example": "Padiuxi"
    },
    {
        "type": "consonant",
        "letter": "t",
        "pronunciation": "t",
        "syllables": {
            "a": "ta",
            "e": "te",
            "i": "ti",
            "o": "to",
            "u": "tu"
        },
        "example": "Tapa"
    },
    {
        "type": "consonant",
        "letter": "x",
        "pronunciation": "sh",
        "syllables": {
            "a": "xa",
            "e": "xe",
            "i": "xi",
            "o": "xo",
            "u": "xu"
        },
        "example": "Xiiñi''"
    },
    {
        "type": "consonant",
        "letter": "xh",
        "pronunciation": "sh suave",
        "syllables": {
            "a": "xha",
            "e": "xhe",
            "i": "xhi",
            "o": "xho",
            "u": "xhu"
        },
        "example": "Bixhoze"
    },
    {
        "type": "consonant",
        "letter": "y",
        "pronunciation": "y",
        "syllables": {
            "a": "ya",
            "e": "ye",
            "i": "yi",
            "o": "yo",
            "u": "yu"
        },
        "example": "Yoo"
    },
    {
        "type": "consonant",
        "letter": "z",
        "pronunciation": "s",
        "syllables": {
            "a": "za",
            "e": "ze",
            "i": "zi",
            "o": "zo",
            "u": "zu"
        },
        "example": "Binnizá"
    }
]',
       '["Vocal doble = vocal larga o cortada: diidxa'', yoo, beeu", "La comilla sola es el corte glotal: guie'', xuba''", "xh suena como sh suave (bixhoze); x como sh fuerte (xiiñi'')", "dx suena parecido a la j del inglés (diidxa'', gubidxa)", "El acento marca el tono alto donde hace falta distinguir palabras (xquíxe)"]'
from ct_languages where code = 'zai';

commit;

-- verificación
select 'ct_levels' as tabla, count(1) as registros from ct_levels where language_id = (select id from ct_languages where code = 'zai')
union all
select 'ct_units', count(1) from ct_units where level_id in (select id from ct_levels where language_id = (select id from ct_languages where code = 'zai'))
union all
select 'ct_vocabulary', count(1) from ct_vocabulary where language_id = (select id from ct_languages where code = 'zai')
union all
select 'ct_exercises', count(1) from ct_exercises where unit_id in (select u.id from ct_units u join ct_levels l on u.level_id = l.id where l.language_id = (select id from ct_languages where code = 'zai'))
union all
select 'status', case when status = 'draft' then 1 else 0 end from ct_languages where code = 'zai';
-- esperado: ct_levels 2 · ct_units 6 · ct_vocabulary 26 · ct_exercises 32 · status 1 (draft)
