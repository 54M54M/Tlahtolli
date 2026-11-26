-- ============================================================
--  seed de prueba — Maya yucateco (yua)  · curso en pruebas (status = 'draft')
--  tlahtolcalli  [postgresql]
--
--  variante base: maya peninsular (yucatán, campeche, quintana roo) · iso 639-3: yua
--  ejecutar después de 1.-esquema.sql y 2.-datos_generales.sql.
--
--  contenido mínimo para probar el front de desarrollo:
--    2 niveles · 6 unidades · 27 palabras · ejercicios por unidad
--
--  ortografía: alfabeto maya de 1984 (inali / academia de la lengua maya)

--    · Vocal doble = vocal larga: k'aaba', naj / taata
--    · Acento agudo = tono alto en vocal larga: áak'ab, óox
--    · La comilla sola es el corte glotal: ja', na', ma'alob
--    · Glotalizadas: ch', k', p', t', ts' (k'iin, ts'íib)
--    · x suena como sh (ixi'im); j como j suave (jun, ja')
--
--  borrador para pruebas: palabras, traducciones y pronunciaciones deben
--  validarse con hablantes antes de publicar el curso.
--
--  re-ejecutable: borra primero todo lo de 'yua'.
-- ============================================================

begin;

-- 0. limpieza (re-ejecución)
update ta_users set current_lang = null
 where current_lang = (select id from ct_languages where code = 'yua');
delete from ta_user_stats
 where language_id = (select id from ct_languages where code = 'yua');
delete from ta_user_achievements where language_tag = 'yua';
delete from ct_languages where code = 'yua';   -- en cascada: niveles, unidades, vocabulario, ejercicios, progreso

-- 1. idioma (en pruebas: solo se ve en el front de desarrollo)
insert into ct_languages (code, lang_name, native_name, color, flag, family, writing_system, status)
values ('yua', 'Maya yucateco', 'Maaya t''aan', null, '🌽', 'maya', 'alphabet', 'draft');

-- 2. niveles
insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 1, 'Saluda y preséntate', 'Ma''alob k''iin', null, 3, 'Ninguno - Nivel inicial', 1
from ct_languages where code = 'yua';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 2, 'Tu mundo cercano', 'In naj', null, 3, 'Completar Nivel 1', 0
from ct_languages where code = 'yua';

-- 3. unidades
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Saludos', null, 'Saludar según la hora y preguntar cómo está alguien', 'Ma''alob = bien, bueno; k''iin = sol, día; áak''ab = noche', 1, null
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, '¿Quién eres?', null, 'Decir tu nombre y conocer los pronombres', 'Teen (yo), teech (tú), leti'' (él, ella); in = mi, a = tu', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Números', null, 'Contar del uno al cinco', 'Los números van antes de lo que cuentan', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Familia', null, 'Nombrar a la familia', 'In na'' = mi mamá; a taata = tu papá', 1, null
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Casa y comida', null, 'Nombrar cosas de la casa y la comida', 'In naj = mi casa', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Naturaleza', null, 'Nombrar elementos de la naturaleza', 'K''iin significa sol y también día', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2;

-- 4. vocabulario
-- nivel 1 · unidad 1: saludos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ma''alob k''iin', 'buenos días', 'ma''-a-lob k''iin', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ma''alob áak''ab', 'buenas noches', 'ma''-a-lob áa-k''ab', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Bix a beel?', '¿cómo estás?', 'bix a beel', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ma''alob', 'bien', 'ma''-a-lob', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Dios bo''otik', 'gracias', 'dios bo''-o-tik', null from ct_languages where code = 'yua';
-- nivel 1 · unidad 2: ¿quién eres?
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Bix a k''aaba''?', '¿cómo te llamas?', 'bix a k''aa-ba''', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'In k''aaba''e''', 'mi nombre es', 'in k''aa-ba''-e''', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Teen', 'yo', 'teen', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Teech', 'tú', 'teech', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Leti''', 'él / ella', 'le-ti''', null from ct_languages where code = 'yua';
-- nivel 1 · unidad 3: números
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Jun', 'uno', 'jun', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ka''a', 'dos', 'ka''-a', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Óox', 'tres', 'óox', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kan', 'cuatro', 'kan', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Jo''', 'cinco', 'jo''', null from ct_languages where code = 'yua';
-- nivel 2 · unidad 1: familia
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Na''', 'mamá', 'na''', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Taata', 'papá', 'taa-ta', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Paal', 'niño / hijo', 'paal', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Suku''un', 'hermano mayor', 'su-ku''-un', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Íits''in', 'hermano menor', 'íi-ts''in', null from ct_languages where code = 'yua';
-- nivel 2 · unidad 2: casa y comida
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Naj', 'casa', 'naj', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ja''', 'agua', 'ja''', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ixi''im', 'maíz', 'i-xi''-im', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Waaj', 'tortilla', 'waaj', null from ct_languages where code = 'yua';
-- nivel 2 · unidad 3: naturaleza
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'K''iin', 'sol / día', 'k''iin', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Che''', 'árbol', 'che''', null from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Lu''um', 'tierra', 'lu''-um', null from ct_languages where code = 'yua';

-- 5. vocabulario por unidad
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1
and v.word in ('Ma''alob k''iin', 'Ma''alob áak''ab', 'Bix a beel?', 'Ma''alob', 'Dios bo''otik');

insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 2
and v.word in ('Bix a k''aaba''?', 'In k''aaba''e''', 'Teen', 'Teech', 'Leti''');

insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 3
and v.word in ('Jun', 'Ka''a', 'Óox', 'Kan', 'Jo''');

insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 1
and v.word in ('Na''', 'Taata', 'Paal', 'Suku''un', 'Íits''in');

insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 2
and v.word in ('Naj', 'Ja''', 'Ixi''im', 'Waaj');

insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 3
and v.word in ('K''iin', 'Che''', 'Lu''um');

-- 6. ejercicios (opción múltiple por palabra + uno de completar o traducción inversa)
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buenos días',
       '["Ma''alob k''iin"]',
       '["Ma''alob", "Ma''alob k''iin", "Bix a k''aaba''?", "Teen"]',
       'citlali',
       'Ma''alob k''iin significa buenos días',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buenas noches',
       '["Ma''alob áak''ab"]',
       '["In k''aaba''e''", "Teech", "Ma''alob áak''ab", "Jun"]',
       'coltzin',
       'Ma''alob áak''ab significa buenas noches',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cómo estás?',
       '["Bix a beel?"]',
       '["Leti''", "Ka''a", "Kan", "Bix a beel?"]',
       'neza',
       'Bix a beel? significa ¿cómo estás?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Bien',
       '["Ma''alob"]',
       '["Ma''alob", "Óox", "Jo''", "Taata"]',
       'tonatiuh',
       'Ma''alob significa bien',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Gracias',
       '["Dios bo''otik"]',
       '["Na''", "Dios bo''otik", "Paal", "Íits''in"]',
       'xochitl',
       'Dios bo''otik significa gracias',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ k''iin',
       '["Ma''alob", "Ma''alob k''iin"]',
       null,
       'citlali',
       'Ma''alob k''iin significa buenos días',
       20, 'medium', 'Buenos días'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cómo te llamas?',
       '["Bix a k''aaba''?"]',
       '["Ma''alob", "In k''aaba''e''", "Bix a k''aaba''?", "Teech"]',
       'coltzin',
       'Bix a k''aaba''? significa ¿cómo te llamas?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi nombre es',
       '["In k''aaba''e''"]',
       '["Teen", "Leti''", "Ka''a", "In k''aaba''e''"]',
       'neza',
       'In k''aaba''e'' significa mi nombre es',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Yo',
       '["Teen"]',
       '["Teen", "Jun", "Óox", "Jo''"]',
       'tonatiuh',
       'Teen significa yo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tú',
       '["Teech"]',
       '["Kan", "Teech", "Na''", "Paal"]',
       'xochitl',
       'Teech significa tú',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Él / ella',
       '["Leti''"]',
       '["Taata", "Suku''un", "Leti''", "Naj"]',
       'citlali',
       'Leti'' significa él / ella',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ a k''aaba''?',
       '["Bix", "Bix a k''aaba''?"]',
       null,
       'coltzin',
       'Bix a k''aaba''? significa ¿cómo te llamas?',
       20, 'medium', '¿Cómo te llamas?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Uno',
       '["Jun"]',
       '["Dios bo''otik", "In k''aaba''e''", "Teech", "Jun"]',
       'neza',
       'Jun significa uno',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dos',
       '["Ka''a"]',
       '["Ka''a", "Teen", "Leti''", "Óox"]',
       'tonatiuh',
       'Ka''a significa dos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tres',
       '["Óox"]',
       '["Jun", "Óox", "Kan", "Na''"]',
       'xochitl',
       'Óox significa tres',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cuatro',
       '["Kan"]',
       '["Jo''", "Taata", "Kan", "Suku''un"]',
       'citlali',
       'Kan significa cuatro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cinco',
       '["Jo''"]',
       '["Paal", "Íits''in", "Ja''", "Jo''"]',
       'coltzin',
       'Jo'' significa cinco',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', '¿Qué significa?',
       'Jun',
       '["uno"]',
       '["niño / hijo", "casa", "tortilla", "uno"]',
       'neza',
       'Jun significa uno',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mamá',
       '["Na''"]',
       '["Ma''alob", "Na''", "Bix a k''aaba''?", "Teen"]',
       'tonatiuh',
       'Na'' significa mamá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Papá',
       '["Taata"]',
       '["In k''aaba''e''", "Teech", "Taata", "Jun"]',
       'xochitl',
       'Taata significa papá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Niño / hijo',
       '["Paal"]',
       '["Leti''", "Ka''a", "Kan", "Paal"]',
       'citlali',
       'Paal significa niño / hijo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hermano mayor',
       '["Suku''un"]',
       '["Suku''un", "Óox", "Jo''", "Taata"]',
       'coltzin',
       'Suku''un significa hermano mayor',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hermano menor',
       '["Íits''in"]',
       '["Na''", "Íits''in", "Paal", "Naj"]',
       'neza',
       'Íits''in significa hermano menor',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', '¿Qué significa?',
       'Na''',
       '["mamá"]',
       '["yo", "mamá", "uno", "cuatro"]',
       'tonatiuh',
       'Na'' significa mamá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Casa',
       '["Naj"]',
       '["Dios bo''otik", "In k''aaba''e''", "Naj", "Teech"]',
       'xochitl',
       'Naj significa casa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Agua',
       '["Ja''"]',
       '["Teen", "Leti''", "Ka''a", "Ja''"]',
       'citlali',
       'Ja'' significa agua',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Maíz',
       '["Ixi''im"]',
       '["Ixi''im", "Jun", "Óox", "Jo''"]',
       'coltzin',
       'Ixi''im significa maíz',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tortilla',
       '["Waaj"]',
       '["Kan", "Waaj", "Na''", "Paal"]',
       'neza',
       'Waaj significa tortilla',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', '¿Qué significa?',
       'Naj',
       '["casa"]',
       '["tres", "mamá", "casa", "hermano mayor"]',
       'tonatiuh',
       'Naj significa casa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Sol / día',
       '["K''iin"]',
       '["Bix a k''aaba''?", "Teen", "Leti''", "K''iin"]',
       'xochitl',
       'K''iin significa sol / día',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Árbol',
       '["Che''"]',
       '["Che''", "Teech", "Jun", "Óox"]',
       'citlali',
       'Che'' significa árbol',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tierra',
       '["Lu''um"]',
       '["Ka''a", "Lu''um", "Kan", "Na''"]',
       'coltzin',
       'Lu''um significa tierra',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', '¿Qué significa?',
       'K''iin',
       '["sol / día"]',
       '["niño / hijo", "casa", "tortilla", "sol / día"]',
       'neza',
       'K''iin significa sol / día',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 3;

-- 7. sistema de escritura
insert into ct_writing_systems (language_id, system_type, system_name, description, characters, notes)
select id, 'alphabet', 'alfabeto maya',
       'Alfabeto maya de 1984. Variante base: maya peninsular. Borrador de prueba, pendiente de validar con hablantes.',
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
        "example": "Naj"
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
        "example": "Che''"
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
        "example": "Ixi''im"
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
        "example": "Ma''alob"
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
        "example": "Jun"
    },
    {
        "type": "longVowel",
        "letter": "aa",
        "pronunciation": "a larga",
        "syllables": {
            "a": "aa (a larga)"
        },
        "example": "Paal"
    },
    {
        "type": "longVowel",
        "letter": "ee",
        "pronunciation": "e larga",
        "syllables": {
            "e": "ee (e larga)"
        },
        "example": "Teen"
    },
    {
        "type": "longVowel",
        "letter": "ii",
        "pronunciation": "i larga",
        "syllables": {
            "i": "ii (i larga)"
        },
        "example": "K''iin"
    },
    {
        "type": "longVowel",
        "letter": "oo",
        "pronunciation": "o larga",
        "syllables": {
            "o": "oo (o larga)"
        },
        "example": "Dios bo''otik"
    },
    {
        "type": "longVowel",
        "letter": "uu",
        "pronunciation": "u larga",
        "syllables": {
            "u": "uu (u larga)"
        },
        "example": "Suku''un"
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
        "example": "Bix"
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
        "example": "Che''"
    },
    {
        "type": "consonant",
        "letter": "j",
        "pronunciation": "j",
        "syllables": {
            "a": "ja",
            "e": "je",
            "i": "ji",
            "o": "jo",
            "u": "ju"
        },
        "example": "Jun"
    },
    {
        "type": "consonant",
        "letter": "k",
        "pronunciation": "k",
        "syllables": {
            "a": "ka",
            "e": "ke",
            "i": "ki",
            "o": "ko",
            "u": "ku"
        },
        "example": "Kan"
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
        "example": "Lu''um"
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
        "example": "Ma''alob"
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
        "example": "Naj"
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
        "example": "Paal"
    },
    {
        "type": "consonant",
        "letter": "s",
        "pronunciation": "s",
        "syllables": {
            "a": "sa",
            "e": "se",
            "i": "si",
            "o": "so",
            "u": "su"
        },
        "example": "Suku''un"
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
        "example": "Taata"
    },
    {
        "type": "consonant",
        "letter": "ts",
        "pronunciation": "ts",
        "syllables": {
            "a": "tsa",
            "e": "tse",
            "i": "tsi",
            "o": "tso",
            "u": "tsu"
        },
        "example": "Íits''in"
    },
    {
        "type": "consonant",
        "letter": "w",
        "pronunciation": "w",
        "syllables": {
            "a": "wa",
            "e": "we",
            "i": "wi",
            "o": "wo",
            "u": "wu"
        },
        "example": "Waaj"
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
        "example": "Ixi''im"
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
        "example": "Yo''och"
    },
    {
        "type": "ejective",
        "letter": "ch''",
        "pronunciation": "ch''",
        "syllables": {
            "a": "ch''a",
            "e": "ch''e",
            "i": "ch''i",
            "o": "ch''o",
            "u": "ch''u"
        },
        "example": "Ch''ich''"
    },
    {
        "type": "ejective",
        "letter": "k''",
        "pronunciation": "k''",
        "syllables": {
            "a": "k''a",
            "e": "k''e",
            "i": "k''i",
            "o": "k''o",
            "u": "k''u"
        },
        "example": "K''iin"
    },
    {
        "type": "ejective",
        "letter": "p''",
        "pronunciation": "p''",
        "syllables": {
            "a": "p''a",
            "e": "p''e",
            "i": "p''i",
            "o": "p''o",
            "u": "p''u"
        },
        "example": "P''iit"
    },
    {
        "type": "ejective",
        "letter": "t''",
        "pronunciation": "t''",
        "syllables": {
            "a": "t''a",
            "e": "t''e",
            "i": "t''i",
            "o": "t''o",
            "u": "t''u"
        },
        "example": "T''aan"
    },
    {
        "type": "ejective",
        "letter": "ts''",
        "pronunciation": "ts''",
        "syllables": {
            "a": "ts''a",
            "e": "ts''e",
            "i": "ts''i",
            "o": "ts''o",
            "u": "ts''u"
        },
        "example": "Ts''íib"
    }
]',
       '["Vocal doble = vocal larga: k''aaba'', naj / taata", "Acento agudo = tono alto en vocal larga: áak''ab, óox", "La comilla sola es el corte glotal: ja'', na'', ma''alob", "Glotalizadas: ch'', k'', p'', t'', ts'' (k''iin, ts''íib)", "x suena como sh (ixi''im); j como j suave (jun, ja'')"]'
from ct_languages where code = 'yua';

commit;

-- verificación
select 'ct_levels' as tabla, count(1) as registros from ct_levels where language_id = (select id from ct_languages where code = 'yua')
union all
select 'ct_units', count(1) from ct_units where level_id in (select id from ct_levels where language_id = (select id from ct_languages where code = 'yua'))
union all
select 'ct_vocabulary', count(1) from ct_vocabulary where language_id = (select id from ct_languages where code = 'yua')
union all
select 'ct_exercises', count(1) from ct_exercises where unit_id in (select u.id from ct_units u join ct_levels l on u.level_id = l.id where l.language_id = (select id from ct_languages where code = 'yua'))
union all
select 'status', case when status = 'draft' then 1 else 0 end from ct_languages where code = 'yua';
-- esperado: ct_levels 2 · ct_units 6 · ct_vocabulary 27 · ct_exercises 33 · status 1 (draft)
