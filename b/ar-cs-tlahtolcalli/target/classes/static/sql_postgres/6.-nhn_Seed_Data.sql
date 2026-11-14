-- ============================================================
--  seed data — náhuatl central (nhn)
--  tlahtolcalli  [postgresql]
--
--  variante: náhuatl central (iso 639-3: nhn; grupo nah)
--  ejecutar después de:
--    1. tlahtolli_database_script.sql
--    2. general_seed_data.sql   (usuario demo y logros)
--
--  contenido (curso completo, mismos temas que nhce):
--    6 niveles · 36 unidades · 195 palabras y frases · 254 asociaciones · 216 ejercicios
--    ct_languages → ct_levels → ct_units → ct_vocabulary → rl_unit_vocab
--    → ct_exercises → ct_writing_systems → ta_user_progress → ta_user_stats
--
--  borrador para revisión con hablantes: todas las palabras, traducciones
--  y pronunciaciones deben validarse antes de publicarse.
--
--  norma ortográfica (una sola, en todo el contenido):
--    · ortografía práctica de base clásica: c/qu (k), cu/uc (kw), hu/uh (w),
--      tz (ts), tl, ch, x (sh), z y c+e,i (s)
--    · h = saltillo (corte de voz): tlazohcamati, quemah, ahmo
--    · sin macrones: la vocal larga no se marca en ninguna palabra
--    · sin acentos del español
--    · sílabas: tl, tz, ch, qu, cu, hu son un solo sonido; la tl final se
--      queda en la sílaba anterior (xo-chitl, ne-huatl)
--  guía de pronunciación (generada con la misma regla para todo):
--    k, kw, w, s, sh, ts; ' = saltillo; sílabas separadas con guion
--
--  re-ejecutable: borra primero todo lo de 'nhn'.
-- ============================================================

begin;

-- ─────────────────────────────────────────────
--  0. limpieza (re-ejecución)
-- ─────────────────────────────────────────────
update ta_users set current_lang = null
where current_lang = (select id from ct_languages where code = 'nhn');
delete from ta_user_stats
where language_id = (select id from ct_languages where code = 'nhn');
delete from ct_languages where code = 'nhn';   -- en cascada: niveles, unidades, vocabulario, ejercicios, progreso

alter table ct_exercises add column if not exists placeholder varchar(255);

-- ─────────────────────────────────────────────
--  1. idioma
-- ─────────────────────────────────────────────
insert into ct_languages (code, lang_name, native_name, color, flag, family, writing_system)
values ('nhn', 'Náhuatl central', 'Nahuatlahtolli', null, '🌽', 'uto-aztec', 'alphabet');

-- ─────────────────────────────────────────────
--  2. niveles (título en náhuatl: frase corta del propio curso)
-- ─────────────────────────────────────────────
insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 1, 'Saluda y preséntate', 'Quen tinemi?', null, 6, 'Ninguno - Nivel inicial', 1
from ct_languages where code = 'nhn';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 2, 'Descríbete y describe a tu familia', 'Nonan ihuan notah', null, 6, 'Completar Nivel 1', 0
from ct_languages where code = 'nhn';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 3, 'Pide y da información', 'Tlen, aquin, canin?', null, 6, 'Completar Nivel 2', 0
from ct_languages where code = 'nhn';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 4, 'Habla en tiempos (ayer/hoy/mañana)', 'Yalhua, axcan, moztla', null, 6, 'Completar Nivel 3', 0
from ct_languages where code = 'nhn';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 5, 'Describe un día normal', 'Tlaneci, tlayohua', null, 6, 'Completar Nivel 4', 0
from ct_languages where code = 'nhn';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 6, 'Describe y expresa preferencias', 'Tlen mitzpactia?', null, 6, 'Completar Nivel 5', 0
from ct_languages where code = 'nhn';

-- ─────────────────────────────────────────────
--  3.1 unidades — nivel 1: saluda y preséntate
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Saludos', null,
       'Saludar y preguntar cómo está la otra persona',
       'Quen tinemi? / Cualli ninemi: el verbo nemi (vivir, andar) con ni- (yo) y ti- (tú)', 1, null
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Despedidas', null,
       'Despedirse y quedar de verse',
       'Timoittazque (nos vemos) y palabras de tiempo: moztla, occeppa', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Cómo te llamas', null,
       'Preguntar y decir el nombre',
       'Posesivos no- (mi), mo- (tu), i- (su) con toca (nombre); pronombres nehuatl, tehuatl, yehuatl', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Agradecer y responder', null,
       'Dar las gracias, responder y decir sí o no',
       'Tlazohcamati, miac tlazohcamati, ahmo tlen; quemah / ahmo', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Cómo me siento', null,
       'Decir cómo te sientes y preguntar a otros',
       'Prefijos de sujeto: ni- (yo), ti- (tú), sin prefijo (él/ella): niyolpaqui, tiyolpaqui, yolpaqui', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Conversación básica', null,
       'Unir saludo, nombre, estado y despedida en una conversación',
       'Ihuan (y), tlen (qué) y repaso de la unidad 1 a la 5', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1;

-- ─────────────────────────────────────────────
--  3.2 unidades — nivel 2: descríbete y describe a tu familia
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Pronombres personales', null,
       'Conocer los pronombres en singular y plural',
       'Nehuatl, tehuatl, yehuatl (singular) y tehuan, amehuan, yehuan (plural)', 0, 'Completar Nivel 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'La familia', null,
       'Nombrar a los miembros de la familia',
       'Posesivo no- (mi) con nombres de parentesco: nonan, notah, noconeuh; inin (este, esta)', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Cómo es mi familia', null,
       'Describir a la familia con adjetivos',
       'Adjetivo después del nombre: notah chicahuac (mi papá es fuerte)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Hermanos y amigos', null,
       'Hablar de hermanos y amigos',
       'Nocniuh (mi amigo), noachcauh (mi hermano mayor), noiccauh (mi hermano menor)', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Los abuelos', null,
       'Hablar de los abuelos y de las personas mayores',
       'Nocol (mi abuelo), nocih (mi abuela); huehue, ilamatl, tlamatini', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Mi familia completa', null,
       'Describir tu familia con oraciones completas',
       'Nicpia (tengo) y los números ce (uno) y ome (dos); plural posesivo -huan: noconehuan', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2;

-- ─────────────────────────────────────────────
--  3.3 unidades — nivel 3: pide y da información
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Palabras para preguntar', null,
       'Conocer las palabras para hacer preguntas',
       'Tlen (qué), aquin (quién), canin (dónde), quemman (cuándo), tleica (por qué), quen (cómo)', 0, 'Completar Nivel 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Preguntas personales', null,
       'Preguntar y responder sobre uno mismo',
       'Aquin tehuatl?, Canin tichaneh?, Tlen ticchihua?: la pregunta va al inicio', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Preguntas sobre otros', null,
       'Preguntar por otras personas',
       'Sin prefijo para él o ella: tequiti (trabaja), momachtia (estudia), chaneh (vive)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Dónde está y qué necesito', null,
       'Preguntar por lugares y necesidades',
       'Nican (aquí), ompa (allá); nicnequi (quiero), monequi (se necesita)', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Respuestas completas', null,
       'Responder con oraciones completas',
       'Nican ca (aquí está), nicnequi atl (quiero agua), ahmo nicmati (no sé)', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Cuántos', null,
       'Preguntar cantidades y contar del uno al cinco',
       'Quezqui (cuántos) y los números ce, ome, eyi, nahui, macuilli', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3;

-- ─────────────────────────────────────────────
--  3.4 unidades — nivel 4: habla en tiempos (ayer/hoy/mañana)
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Hoy, ayer y mañana', null,
       'Ubicar las acciones en el tiempo',
       'Axcan (hoy, ahora), yalhua (ayer), moztla (mañana), huiptla (pasado mañana)', 0, 'Completar Nivel 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Pasado y futuro', null,
       'Conjugar en pasado y futuro',
       'Pasado con o- al inicio: onitequit (trabajé); futuro con -z al final: nitequitiz (trabajaré)', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Ver y verse', null,
       'Usar un verbo con objeto en distintos tiempos',
       'Niquitta (lo veo), oniquittac (lo vi), niquittaz (lo veré); nimitzitta (te veo)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Comer, beber e ir', null,
       'Hablar de actividades diarias en tres tiempos',
       'Nitlacua (como), onitlacuah (comí), nitlacuaz (comeré); niyauh (voy), oniya (fui)', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Cuándo y dónde', null,
       'Combinar tiempo y lugar en una oración',
       'Primero el tiempo, luego el verbo y al final el lugar: yalhua oniya ompa', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Contar lo que pasó', null,
       'Contar una secuencia de acciones',
       'Achto (primero), zatepan (después), niman (luego)', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4;

-- ─────────────────────────────────────────────
--  3.5 unidades — nivel 5: describe un día normal
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Por la mañana', null,
       'Describir cómo empieza el día',
       'Verbos reflexivos con ni- + mo/no: nimaltia (me baño); nimehua (me levanto)', 0, 'Completar Nivel 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Dormir y comer', null,
       'Hablar de la comida y el descanso',
       'Niccua (lo como) lleva objeto: niccua tlaxcalli; nitlacua (como) no lo lleva', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Con otras personas', null,
       'Decir qué haces con otras personas',
       'Plural nosotros: ti- ... -h: titlacuah (comemos), titequitih (trabajamos); nohuan (conmigo), mohuan (contigo)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Mañana, tarde y noche', null,
       'Ubicar la rutina en las partes del día',
       'Teotlac (tarde), yohualli (noche), tlayohua (anochece)', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Rutinas en plural', null,
       'Describir lo que hacen varias personas',
       'Plural ellos: sin prefijo y con -h al final: cochih (duermen), tlacuah (comen)', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Mi día completo', null,
       'Describir un día de principio a fin',
       'Repaso de rutina, tiempo y orden: tlaneci, nimehua, achto, zatepan, niman', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5;

-- ─────────────────────────────────────────────
--  3.6 unidades — nivel 6: describe y expresa preferencias
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Lo que me gusta', null,
       'Decir qué te gusta y qué no',
       'Nechpactia (me gusta, lit. me alegra), mitzpactia (te gusta); ahmo nechpactia (no me gusta)', 0, 'Completar Nivel 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Lo que quiero', null,
       'Expresar deseos y necesidades',
       'Nicnequi + verbo en futuro: nicnequi nitlacuaz (quiero comer); quinequi (él o ella quiere)', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Pedir y ordenar', null,
       'Pedir algo con respeto y dar indicaciones',
       'Imperativo con xi-: xitlacua (come), xihualla (ven); nimitztlatlauhtia (por favor, te lo pido)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Más y menos', null,
       'Comparar y valorar',
       'Oc achi (más), cenca cualli (muy bueno), ahmo cualli (no es bueno)', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Mis gustos', null,
       'Hablar de tus gustos con comida y bebida',
       'Nechpactia + nombre: nechpactia atl (me gusta el agua)', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Expresión completa', null,
       'Conversar sobre gustos, deseos y peticiones',
       'Repaso del nivel: preguntas con tlen, gustos con nechpactia y deseos con nicnequi', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6;

-- ─────────────────────────────────────────────
--  4. vocabulario
-- ─────────────────────────────────────────────
-- nivel 1 · unidad 1: saludos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Quen tinemi?', '¿cómo estás? (lit. ¿cómo vives?)', 'ken ti-ne-mi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Cualli ninemi', 'estoy bien (lit. vivo bien)', 'kwal-li ni-ne-mi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ihuan tehuatl?', '¿y tú?', 'i-wan te-watl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ximopanolti', 'pase / bienvenido(a)', 'shi-mo-pa-nol-ti', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Cualli', 'bien / bueno', 'kwal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Quen', 'cómo', 'ken', null from ct_languages where code = 'nhn';
-- nivel 1 · unidad 2: despedidas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Timoittazque', 'nos vemos', 'ti-mo-it-tas-ke', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Moztla', 'mañana', 'mos-tla', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Occeppa', 'otra vez', 'ok-sep-pa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Timoittazque moztla', 'nos vemos mañana', 'ti-mo-it-tas-ke mos-tla', null from ct_languages where code = 'nhn';
-- nivel 1 · unidad 3: cómo te llamas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Quen motoca?', '¿cómo te llamas? (lit. ¿cómo es tu nombre?)', 'ken mo-to-ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Notoca', 'mi nombre / me llamo', 'no-to-ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Motoca', 'tu nombre', 'mo-to-ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Itoca', 'su nombre (de él o ella)', 'i-to-ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nehuatl', 'yo', 'ne-watl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tehuatl', 'tú', 'te-watl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yehuatl', 'él / ella', 'ye-watl', null from ct_languages where code = 'nhn';
-- nivel 1 · unidad 4: agradecer y responder
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlazohcamati', 'gracias', 'tla-so''-ka-ma-ti', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Miac tlazohcamati', 'muchas gracias', 'mi-ak tla-so''-ka-ma-ti', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Miac', 'mucho', 'mi-ak', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ahmo tlen', 'de nada (lit. no es nada)', 'a''-mo tlen', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ahmo', 'no', 'a''-mo', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Quemah', 'sí', 'ke-ma''', null from ct_languages where code = 'nhn';
-- nivel 1 · unidad 5: cómo me siento
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niyolpaqui', 'estoy contento(a)', 'ni-yol-pa-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tiyolpaqui', 'estás contento(a)', 'ti-yol-pa-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yolpaqui', 'está contento(a)', 'yol-pa-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niciahui', 'estoy cansado(a)', 'ni-si-a-wi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ticiahui', 'estás cansado(a)', 'ti-si-a-wi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ciahui', 'está cansado(a)', 'si-a-wi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ninococoa', 'estoy enfermo(a)', 'ni-no-ko-ko-a', null from ct_languages where code = 'nhn';
-- nivel 1 · unidad 6: conversación básica
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ihuan', 'y', 'i-wan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlen', 'qué', 'tlen', null from ct_languages where code = 'nhn';
-- nivel 2 · unidad 1: pronombres personales
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tehuan', 'nosotros', 'te-wan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Amehuan', 'ustedes', 'a-me-wan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yehuan', 'ellos / ellas', 'ye-wan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nehuatl niyolpaqui', 'yo estoy contento(a)', 'ne-watl ni-yol-pa-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tehuatl ticiahui', 'tú estás cansado(a)', 'te-watl ti-si-a-wi', null from ct_languages where code = 'nhn';
-- nivel 2 · unidad 2: la familia
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nonan', 'mi mamá', 'no-nan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Notah', 'mi papá', 'no-ta''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Noconeuh', 'mi hijo(a)', 'no-ko-new', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nochan', 'mi casa', 'no-chan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Inin', 'este / esta', 'i-nin', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Inin nonan', 'esta es mi mamá', 'i-nin no-nan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Inin notah', 'este es mi papá', 'i-nin no-ta''', null from ct_languages where code = 'nhn';
-- nivel 2 · unidad 3: cómo es mi familia
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Chicahuac', 'fuerte', 'chi-ka-wak', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Huey', 'grande', 'wey', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tepiton', 'pequeño(a)', 'te-pi-ton', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yancuic', 'nuevo(a)', 'yan-kwik', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Notah chicahuac', 'mi papá es fuerte', 'no-ta'' chi-ka-wak', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nonan cualli', 'mi mamá es buena', 'no-nan kwal-li', null from ct_languages where code = 'nhn';
-- nivel 2 · unidad 4: hermanos y amigos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nocniuh', 'mi amigo(a)', 'nok-niw', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Noachcauh', 'mi hermano mayor', 'no-ach-kaw', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Noiccauh', 'mi hermano menor', 'no-ik-kaw', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Telpochtli', 'muchacho / joven', 'tel-poch-tli', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ichpochtli', 'muchacha / joven', 'ich-poch-tli', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Inin nocniuh', 'este es mi amigo', 'i-nin nok-niw', null from ct_languages where code = 'nhn';
-- nivel 2 · unidad 5: los abuelos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nocol', 'mi abuelo', 'no-kol', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nocih', 'mi abuela', 'no-si''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Huehue', 'anciano', 'we-we', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ilamatl', 'anciana', 'i-la-matl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlamatini', 'sabio(a)', 'tla-ma-ti-ni', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nocih tlamatini', 'mi abuela es sabia', 'no-si'' tla-ma-ti-ni', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nocol huehue', 'mi abuelo es anciano', 'no-kol we-we', null from ct_languages where code = 'nhn';
-- nivel 2 · unidad 6: mi familia completa
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nicpia', 'tengo', 'nik-pi-a', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ce', 'uno', 'se', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ome', 'dos', 'o-me', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Noconehuan', 'mis hijos', 'no-ko-ne-wan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nicpia ce nocniuh', 'tengo un amigo', 'nik-pi-a se nok-niw', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nicpia ome noconehuan', 'tengo dos hijos', 'nik-pi-a o-me no-ko-ne-wan', null from ct_languages where code = 'nhn';
-- nivel 3 · unidad 1: palabras para preguntar
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Aquin', 'quién', 'a-kin', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Canin', 'dónde', 'ka-nin', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Quemman', 'cuándo', 'kem-man', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tleica', 'por qué', 'tle-i-ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Quezqui', 'cuántos(as)', 'kes-ki', null from ct_languages where code = 'nhn';
-- nivel 3 · unidad 2: preguntas personales
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Aquin tehuatl?', '¿quién eres tú?', 'a-kin te-watl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Canin tichaneh?', '¿dónde vives?', 'ka-nin ti-cha-ne''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nichaneh Tlaxcallan', 'vivo en Tlaxcala', 'ni-cha-ne'' tlash-kal-lan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlen ticchihua?', '¿qué haces?', 'tlen tik-chi-wa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nitequiti', 'trabajo', 'ni-te-ki-ti', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nimomachtia', 'estudio', 'ni-mo-mach-ti-a', null from ct_languages where code = 'nhn';
-- nivel 3 · unidad 3: preguntas sobre otros
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Aquin yehuatl?', '¿quién es él / ella?', 'a-kin ye-watl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlen quichihua?', '¿qué hace él / ella?', 'tlen ki-chi-wa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Canin chaneh?', '¿dónde vive él / ella?', 'ka-nin cha-ne''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tequiti', 'trabaja', 'te-ki-ti', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Momachtia', 'estudia', 'mo-mach-ti-a', null from ct_languages where code = 'nhn';
-- nivel 3 · unidad 4: dónde está y qué necesito
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nican', 'aquí', 'ni-kan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ompa', 'allá', 'om-pa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Canin ca?', '¿dónde está?', 'ka-nin ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nicnequi', 'quiero / necesito', 'nik-ne-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Monequi', 'se necesita', 'mo-ne-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Atl', 'agua', 'atl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlen ticnequi?', '¿qué quieres?', 'tlen tik-ne-ki', null from ct_languages where code = 'nhn';
-- nivel 3 · unidad 5: respuestas completas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nican ca', 'aquí está', 'ni-kan ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ompa ca', 'allá está', 'om-pa ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nicnequi atl', 'quiero agua', 'nik-ne-ki atl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ahmo nicnequi', 'no quiero', 'a''-mo nik-ne-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nicmati', 'sé / lo sé', 'nik-ma-ti', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ahmo nicmati', 'no sé', 'a''-mo nik-ma-ti', null from ct_languages where code = 'nhn';
-- nivel 3 · unidad 6: cuántos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Eyi', 'tres', 'e-yi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nahui', 'cuatro', 'na-wi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Macuilli', 'cinco', 'ma-kwil-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Quezqui ticnequi?', '¿cuántos quieres?', 'kes-ki tik-ne-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nicnequi ome', 'quiero dos', 'nik-ne-ki o-me', null from ct_languages where code = 'nhn';
-- nivel 4 · unidad 1: hoy, ayer y mañana
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Axcan', 'hoy / ahora', 'ash-kan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yalhua', 'ayer', 'yal-wa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Huiptla', 'pasado mañana', 'wip-tla', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tonalli', 'día / sol', 'to-nal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yohualli', 'noche', 'yo-wal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Axcan nitequiti', 'hoy trabajo', 'ash-kan ni-te-ki-ti', null from ct_languages where code = 'nhn';
-- nivel 4 · unidad 2: pasado y futuro
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Onitequit', 'trabajé', 'o-ni-te-kit', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nitequitiz', 'trabajaré', 'ni-te-ki-tis', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Otitequit', 'trabajaste', 'o-ti-te-kit', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Titequitiz', 'trabajarás', 'ti-te-ki-tis', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Onicochic', 'dormí', 'o-ni-ko-chik', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nicochiz', 'dormiré', 'ni-ko-chis', null from ct_languages where code = 'nhn';
-- nivel 4 · unidad 3: ver y verse
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niquitta', 'lo / la veo', 'ni-kit-ta', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Oniquittac', 'lo / la vi', 'o-ni-kit-tak', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niquittaz', 'lo / la veré', 'ni-kit-tas', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nimitzitta', 'te veo', 'ni-mi-tsit-ta', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Onimitzittac', 'te vi', 'o-ni-mi-tsit-tak', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yalhua onimitzittac', 'ayer te vi', 'yal-wa o-ni-mi-tsit-tak', null from ct_languages where code = 'nhn';
-- nivel 4 · unidad 4: comer, beber e ir
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nitlacua', 'como', 'ni-tla-kwa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Onitlacuah', 'comí', 'o-ni-tla-kwa''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nitlacuaz', 'comeré', 'ni-tla-kwas', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niatli', 'bebo', 'ni-a-tli', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niyauh', 'voy', 'ni-yaw', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Oniya', 'fui', 'o-ni-ya', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niyaz', 'iré', 'ni-yas', null from ct_languages where code = 'nhn';
-- nivel 4 · unidad 5: cuándo y dónde
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yalhua oniya ompa', 'ayer fui allá', 'yal-wa o-ni-ya om-pa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Moztla niyaz', 'mañana iré', 'mos-tla ni-yas', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Axcan nican nicah', 'hoy estoy aquí', 'ash-kan ni-kan ni-ka''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nicah', 'estoy', 'ni-ka''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ticah', 'estás', 'ti-ka''', null from ct_languages where code = 'nhn';
-- nivel 4 · unidad 6: contar lo que pasó
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Achto', 'primero', 'ach-to', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Zatepan', 'después', 'sa-te-pan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niman', 'luego / enseguida', 'ni-man', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Achto nitlacua', 'primero como', 'ach-to ni-tla-kwa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Zatepan nitequiti', 'después trabajo', 'sa-te-pan ni-te-ki-ti', null from ct_languages where code = 'nhn';
-- nivel 5 · unidad 1: por la mañana
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nimehua', 'me levanto', 'ni-me-wa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nimaltia', 'me baño', 'ni-mal-ti-a', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niquiza', 'salgo', 'ni-ki-sa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nihuallauh', 'vengo', 'ni-wal-law', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Cualcan', 'temprano', 'kwal-kan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlaneci', 'amanece', 'tla-ne-si', null from ct_languages where code = 'nhn';
-- nivel 5 · unidad 2: dormir y comer
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nicochi', 'duermo', 'ni-ko-chi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlaxcalli', 'tortilla', 'tlash-kal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Etl', 'frijol', 'etl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Chilli', 'chile', 'chil-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niccua tlaxcalli', 'como tortilla', 'nik-kwa tlash-kal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niccua etl', 'como frijol', 'nik-kwa etl', null from ct_languages where code = 'nhn';
-- nivel 5 · unidad 3: con otras personas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Titlacuah', 'comemos', 'ti-tla-kwa''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Titequitih', 'trabajamos', 'ti-te-ki-ti''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nohuan', 'conmigo', 'no-wan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Mohuan', 'contigo', 'mo-wan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nitlacua mohuan', 'como contigo', 'ni-tla-kwa mo-wan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nonan ihuan nehuatl titlacuah', 'mi mamá y yo comemos', 'no-nan i-wan ne-watl ti-tla-kwa''', null from ct_languages where code = 'nhn';
-- nivel 5 · unidad 4: mañana, tarde y noche
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Teotlac', 'tarde', 'te-o-tlak', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlayohua', 'anochece', 'tla-yo-wa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Teotlac nitequiti', 'en la tarde trabajo', 'te-o-tlak ni-te-ki-ti', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yohualli nicochi', 'en la noche duermo', 'yo-wal-li ni-ko-chi', null from ct_languages where code = 'nhn';
-- nivel 5 · unidad 5: rutinas en plural
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ticochih', 'dormimos', 'ti-ko-chi''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Cochih', 'duermen', 'ko-chi''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlacuah', 'comen', 'tla-kwa''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tequitih', 'trabajan', 'te-ki-ti''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tehuan ticochih', 'nosotros dormimos', 'te-wan ti-ko-chi''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yehuan tlacuah', 'ellos comen', 'ye-wan tla-kwa''', null from ct_languages where code = 'nhn';
-- nivel 5 · unidad 6: mi día completo
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlaneci nimehua', 'amanece y me levanto', 'tla-ne-si ni-me-wa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niman niquiza', 'luego salgo', 'ni-man ni-ki-sa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Cualcan nimaltia', 'temprano me baño', 'kwal-kan ni-mal-ti-a', null from ct_languages where code = 'nhn';
-- nivel 6 · unidad 1: lo que me gusta
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nechpactia', 'me gusta', 'nech-pak-ti-a', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ahmo nechpactia', 'no me gusta', 'a''-mo nech-pak-ti-a', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Mitzpactia?', '¿te gusta?', 'mits-pak-ti-a', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Cenca', 'mucho / muy', 'sen-ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Achi', 'un poco', 'a-chi', null from ct_languages where code = 'nhn';
-- nivel 6 · unidad 2: lo que quiero
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ticnequi', 'quieres', 'tik-ne-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Quinequi', 'quiere', 'ki-ne-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nicnequi nitlacuaz', 'quiero comer', 'nik-ne-ki ni-tla-kwas', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nicnequi nicochiz', 'quiero dormir', 'nik-ne-ki ni-ko-chis', null from ct_languages where code = 'nhn';
-- nivel 6 · unidad 3: pedir y ordenar
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Xitlacua', 'come (tú)', 'shi-tla-kwa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Xicochi', 'duerme (tú)', 'shi-ko-chi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Xihualla', 'ven (tú)', 'shi-wal-la', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ximotlali', 'siéntate', 'shi-mo-tla-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nimitztlatlauhtia', 'por favor (lit. te lo pido)', 'ni-mits-tla-tlaw-ti-a', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nimitztlatlauhtia, xihualla', 'por favor, ven', 'ni-mits-tla-tlaw-ti-a shi-wal-la', null from ct_languages where code = 'nhn';
-- nivel 6 · unidad 4: más y menos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Oc achi', 'más', 'ok a-chi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Oc achi cualli', 'mejor', 'ok a-chi kwal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Cenca cualli', 'muy bueno', 'sen-ka kwal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ahmo cualli', 'no es bueno', 'a''-mo kwal-li', null from ct_languages where code = 'nhn';
-- nivel 6 · unidad 5: mis gustos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nechpactia atl', 'me gusta el agua', 'nech-pak-ti-a atl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nechpactia tlaxcalli', 'me gusta la tortilla', 'nech-pak-ti-a tlash-kal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ahmo nechpactia chilli', 'no me gusta el chile', 'a''-mo nech-pak-ti-a chil-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Mitzpactia etl?', '¿te gusta el frijol?', 'mits-pak-ti-a etl', null from ct_languages where code = 'nhn';
-- nivel 6 · unidad 6: expresión completa
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlen mitzpactia?', '¿qué te gusta?', 'tlen mits-pak-ti-a', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nahuatlahtolli', 'idioma náhuatl', 'na-wa-tla''-tol-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nechpactia nahuatlahtolli', 'me gusta el náhuatl', 'nech-pak-ti-a na-wa-tla''-tol-li', null from ct_languages where code = 'nhn';

-- ─────────────────────────────────────────────
--  5. rl_unit_vocab — vocabulario por unidad (nuevo + repaso)
-- ─────────────────────────────────────────────
-- nivel 1 · unidad 1: saludos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 1
  and v.word in ('Quen tinemi?', 'Cualli ninemi', 'Ihuan tehuatl?', 'Ximopanolti', 'Cualli', 'Quen');

-- nivel 1 · unidad 2: despedidas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 2
  and v.word in ('Timoittazque', 'Moztla', 'Occeppa', 'Timoittazque moztla', 'Cualli');

-- nivel 1 · unidad 3: cómo te llamas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 3
  and v.word in ('Quen motoca?', 'Notoca', 'Motoca', 'Itoca', 'Nehuatl', 'Tehuatl', 'Yehuatl');

-- nivel 1 · unidad 4: agradecer y responder
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 4
  and v.word in ('Tlazohcamati', 'Miac tlazohcamati', 'Miac', 'Ahmo tlen', 'Ahmo', 'Quemah');

-- nivel 1 · unidad 5: cómo me siento
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 5
  and v.word in ('Niyolpaqui', 'Tiyolpaqui', 'Yolpaqui', 'Niciahui', 'Ticiahui', 'Ciahui', 'Ninococoa', 'Quen tinemi?');

-- nivel 1 · unidad 6: conversación básica
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 6
  and v.word in ('Ihuan', 'Tlen', 'Quen tinemi?', 'Cualli ninemi', 'Ihuan tehuatl?', 'Quen motoca?', 'Notoca', 'Tlazohcamati', 'Timoittazque', 'Niyolpaqui');

-- nivel 2 · unidad 1: pronombres personales
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 1
  and v.word in ('Tehuan', 'Amehuan', 'Yehuan', 'Nehuatl niyolpaqui', 'Tehuatl ticiahui', 'Nehuatl', 'Tehuatl', 'Yehuatl');

-- nivel 2 · unidad 2: la familia
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 2
  and v.word in ('Nonan', 'Notah', 'Noconeuh', 'Nochan', 'Inin', 'Inin nonan', 'Inin notah');

-- nivel 2 · unidad 3: cómo es mi familia
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 3
  and v.word in ('Chicahuac', 'Huey', 'Tepiton', 'Yancuic', 'Notah chicahuac', 'Nonan cualli', 'Cualli', 'Nonan', 'Notah');

-- nivel 2 · unidad 4: hermanos y amigos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 4
  and v.word in ('Nocniuh', 'Noachcauh', 'Noiccauh', 'Telpochtli', 'Ichpochtli', 'Inin nocniuh', 'Inin');

-- nivel 2 · unidad 5: los abuelos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 5
  and v.word in ('Nocol', 'Nocih', 'Huehue', 'Ilamatl', 'Tlamatini', 'Nocih tlamatini', 'Nocol huehue');

-- nivel 2 · unidad 6: mi familia completa
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 6
  and v.word in ('Nicpia', 'Ce', 'Ome', 'Noconehuan', 'Nicpia ce nocniuh', 'Nicpia ome noconehuan', 'Nonan', 'Notah', 'Ihuan');

-- nivel 3 · unidad 1: palabras para preguntar
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 1
  and v.word in ('Aquin', 'Canin', 'Quemman', 'Tleica', 'Quezqui', 'Tlen', 'Quen');

-- nivel 3 · unidad 2: preguntas personales
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 2
  and v.word in ('Aquin tehuatl?', 'Canin tichaneh?', 'Nichaneh Tlaxcallan', 'Tlen ticchihua?', 'Nitequiti', 'Nimomachtia');

-- nivel 3 · unidad 3: preguntas sobre otros
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 3
  and v.word in ('Aquin yehuatl?', 'Tlen quichihua?', 'Canin chaneh?', 'Tequiti', 'Momachtia', 'Yehuatl');

-- nivel 3 · unidad 4: dónde está y qué necesito
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 4
  and v.word in ('Nican', 'Ompa', 'Canin ca?', 'Nicnequi', 'Monequi', 'Atl', 'Tlen ticnequi?');

-- nivel 3 · unidad 5: respuestas completas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 5
  and v.word in ('Nican ca', 'Ompa ca', 'Nicnequi atl', 'Ahmo nicnequi', 'Nicmati', 'Ahmo nicmati', 'Ahmo');

-- nivel 3 · unidad 6: cuántos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 6
  and v.word in ('Eyi', 'Nahui', 'Macuilli', 'Quezqui ticnequi?', 'Nicnequi ome', 'Quezqui', 'Ce', 'Ome');

-- nivel 4 · unidad 1: hoy, ayer y mañana
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 1
  and v.word in ('Axcan', 'Yalhua', 'Huiptla', 'Tonalli', 'Yohualli', 'Axcan nitequiti', 'Moztla');

-- nivel 4 · unidad 2: pasado y futuro
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 2
  and v.word in ('Onitequit', 'Nitequitiz', 'Otitequit', 'Titequitiz', 'Onicochic', 'Nicochiz', 'Nitequiti');

-- nivel 4 · unidad 3: ver y verse
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 3
  and v.word in ('Niquitta', 'Oniquittac', 'Niquittaz', 'Nimitzitta', 'Onimitzittac', 'Yalhua onimitzittac', 'Yalhua');

-- nivel 4 · unidad 4: comer, beber e ir
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 4
  and v.word in ('Nitlacua', 'Onitlacuah', 'Nitlacuaz', 'Niatli', 'Niyauh', 'Oniya', 'Niyaz');

-- nivel 4 · unidad 5: cuándo y dónde
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 5
  and v.word in ('Yalhua oniya ompa', 'Moztla niyaz', 'Axcan nican nicah', 'Nicah', 'Ticah', 'Ompa', 'Nican', 'Axcan');

-- nivel 4 · unidad 6: contar lo que pasó
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 6
  and v.word in ('Achto', 'Zatepan', 'Niman', 'Achto nitlacua', 'Zatepan nitequiti', 'Nitlacua', 'Nitequiti');

-- nivel 5 · unidad 1: por la mañana
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 1
  and v.word in ('Nimehua', 'Nimaltia', 'Niquiza', 'Nihuallauh', 'Cualcan', 'Tlaneci');

-- nivel 5 · unidad 2: dormir y comer
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 2
  and v.word in ('Nicochi', 'Tlaxcalli', 'Etl', 'Chilli', 'Niccua tlaxcalli', 'Niccua etl', 'Nitlacua');

-- nivel 5 · unidad 3: con otras personas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 3
  and v.word in ('Titlacuah', 'Titequitih', 'Nohuan', 'Mohuan', 'Nitlacua mohuan', 'Nonan ihuan nehuatl titlacuah', 'Nonan');

-- nivel 5 · unidad 4: mañana, tarde y noche
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 4
  and v.word in ('Teotlac', 'Tlayohua', 'Teotlac nitequiti', 'Yohualli nicochi', 'Tlaneci', 'Yohualli', 'Nicochi');

-- nivel 5 · unidad 5: rutinas en plural
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 5
  and v.word in ('Ticochih', 'Cochih', 'Tlacuah', 'Tequitih', 'Tehuan ticochih', 'Yehuan tlacuah', 'Tehuan', 'Yehuan');

-- nivel 5 · unidad 6: mi día completo
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 6
  and v.word in ('Tlaneci nimehua', 'Niman niquiza', 'Cualcan nimaltia', 'Achto', 'Zatepan', 'Niman', 'Teotlac nitequiti', 'Yohualli nicochi');

-- nivel 6 · unidad 1: lo que me gusta
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 1
  and v.word in ('Nechpactia', 'Ahmo nechpactia', 'Mitzpactia?', 'Cenca', 'Achi');

-- nivel 6 · unidad 2: lo que quiero
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 2
  and v.word in ('Ticnequi', 'Quinequi', 'Nicnequi nitlacuaz', 'Nicnequi nicochiz', 'Nicnequi', 'Ahmo nicnequi');

-- nivel 6 · unidad 3: pedir y ordenar
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 3
  and v.word in ('Xitlacua', 'Xicochi', 'Xihualla', 'Ximotlali', 'Nimitztlatlauhtia', 'Nimitztlatlauhtia, xihualla');

-- nivel 6 · unidad 4: más y menos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 4
  and v.word in ('Oc achi', 'Oc achi cualli', 'Cenca cualli', 'Ahmo cualli', 'Achi', 'Cenca', 'Cualli');

-- nivel 6 · unidad 5: mis gustos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 5
  and v.word in ('Nechpactia atl', 'Nechpactia tlaxcalli', 'Ahmo nechpactia chilli', 'Mitzpactia etl?', 'Atl', 'Tlaxcalli', 'Chilli', 'Etl');

-- nivel 6 · unidad 6: expresión completa
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
                           join ct_levels l on u.level_id = l.id
                           join ct_languages la on l.language_id = la.id
                           join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 6
  and v.word in ('Tlen mitzpactia?', 'Nahuatlahtolli', 'Nechpactia nahuatlahtolli', 'Nechpactia', 'Nicnequi', 'Tlen ticnequi?');

-- ─────────────────────────────────────────────
--  6. ejercicios (6 por unidad: 4 opción múltiple + 2 completar)
-- ─────────────────────────────────────────────
-- nivel 1 · unidad 1: saludos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cómo estás?',
       '["Quen tinemi?"]',
       '["Quen tinemi?", "Quen motoca?", "Ximopanolti", "Timoittazque"]',
       'citlali',
       'Quen tinemi? pregunta cómo está alguien; literalmente es ¿cómo vives?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estoy bien',
       '["Cualli ninemi"]',
       '["Cualli ninemi", "Ihuan tehuatl?", "Quen tinemi?", "Notoca"]',
       'coltzin',
       'Cualli ninemi responde a Quen tinemi?: cualli (bien) + ninemi (yo vivo)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Y tú?',
       '["Ihuan tehuatl?"]',
       '["Ihuan tehuatl?", "Cualli ninemi", "Tlazohcamati", "Ximopanolti"]',
       'neza',
       'Ihuan (y) + tehuatl (tú) devuelve la pregunta',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pase / bienvenido',
       '["Ximopanolti"]',
       '["Ximopanolti", "Timoittazque", "Quen tinemi?", "Cualli"]',
       'tonatiuh',
       'Ximopanolti es una invitación respetuosa a pasar',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Quen ______?',
       '["tinemi", "Quen tinemi?", "Quen tinemi"]',
       null,
       'xochitl',
       'Ti- marca la segunda persona: tinemi = tú vives',
       20, 'medium',
       '¿Cómo estás?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Cualli ______',
       '["ninemi", "Cualli ninemi"]',
       null,
       'citlali',
       'Ni- marca la primera persona: ninemi = yo vivo',
       20, 'medium',
       'Estoy bien'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 1;

-- nivel 1 · unidad 2: despedidas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nos vemos',
       '["Timoittazque"]',
       '["Timoittazque", "Ximopanolti", "Moztla", "Occeppa"]',
       'coltzin',
       'Timoittazque significa nos veremos o nos vemos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mañana',
       '["Moztla"]',
       '["Moztla", "Occeppa", "Cualli", "Quen"]',
       'neza',
       'Moztla significa mañana (el día siguiente)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Otra vez',
       '["Occeppa"]',
       '["Occeppa", "Moztla", "Miac", "Quen"]',
       'tonatiuh',
       'Occeppa significa otra vez, de nuevo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nos vemos mañana',
       '["Timoittazque moztla"]',
       '["Timoittazque moztla", "Quen tinemi?", "Cualli ninemi", "Miac tlazohcamati"]',
       'xochitl',
       'Timoittazque (nos vemos) + moztla (mañana)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Timoittazque ______',
       '["moztla", "Timoittazque moztla"]',
       null,
       'citlali',
       'Moztla va después del verbo: timoittazque moztla',
       20, 'medium',
       'Nos vemos mañana'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ moztla',
       '["Timoittazque", "Timoittazque moztla"]',
       null,
       'coltzin',
       'Timoittazque es la despedida para quedar de verse',
       20, 'medium',
       'Nos vemos mañana'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 2;

-- nivel 1 · unidad 3: cómo te llamas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cómo te llamas?',
       '["Quen motoca?"]',
       '["Quen motoca?", "Quen tinemi?", "Ihuan tehuatl?", "Notoca"]',
       'neza',
       'Quen motoca? pregunta literalmente ¿cómo es tu nombre?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi nombre / me llamo',
       '["Notoca"]',
       '["Notoca", "Motoca", "Itoca", "Nehuatl"]',
       'tonatiuh',
       'No- significa mi: notoca = mi nombre',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tu nombre',
       '["Motoca"]',
       '["Motoca", "Notoca", "Itoca", "Tehuatl"]',
       'xochitl',
       'Mo- significa tu: motoca = tu nombre',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Yo',
       '["Nehuatl"]',
       '["Nehuatl", "Tehuatl", "Yehuatl", "Notoca"]',
       'citlali',
       'Nehuatl es el pronombre yo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ Xochitl',
       '["Notoca", "Notoca Xochitl"]',
       null,
       'coltzin',
       'Para decir tu nombre: notoca + nombre',
       20, 'medium',
       'Me llamo Xochitl'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Quen ______?',
       '["motoca", "Quen motoca?", "Quen motoca"]',
       null,
       'neza',
       'Mo- (tu) + toca (nombre): motoca',
       20, 'medium',
       '¿Cómo te llamas?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 3;

-- nivel 1 · unidad 4: agradecer y responder
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Gracias',
       '["Tlazohcamati"]',
       '["Tlazohcamati", "Timoittazque", "Ximopanolti", "Ahmo tlen"]',
       'tonatiuh',
       'Tlazohcamati es la forma de dar las gracias',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muchas gracias',
       '["Miac tlazohcamati"]',
       '["Miac tlazohcamati", "Ahmo tlen", "Cualli ninemi", "Tlazohcamati"]',
       'xochitl',
       'Miac (mucho) + tlazohcamati (gracias)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'De nada',
       '["Ahmo tlen"]',
       '["Ahmo tlen", "Quemah", "Miac", "Tlazohcamati"]',
       'citlali',
       'Ahmo tlen responde a las gracias; literalmente no es nada',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Sí',
       '["Quemah"]',
       '["Quemah", "Ahmo", "Cualli", "Miac"]',
       'coltzin',
       'Quemah significa sí; la h final es un saltillo (corte de voz)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ tlazohcamati',
       '["Miac", "Miac tlazohcamati"]',
       null,
       'neza',
       'Miac (mucho) va antes de tlazohcamati',
       20, 'medium',
       'Muchas gracias'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ahmo ______',
       '["tlen", "Ahmo tlen"]',
       null,
       'tonatiuh',
       'Ahmo (no) + tlen (qué, nada): ahmo tlen',
       20, 'medium',
       'De nada'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 4;

-- nivel 1 · unidad 5: cómo me siento
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estoy contento',
       '["Niyolpaqui"]',
       '["Niyolpaqui", "Tiyolpaqui", "Yolpaqui", "Niciahui"]',
       'xochitl',
       'Ni- (yo) + yolpaqui (estar contento)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estás contento',
       '["Tiyolpaqui"]',
       '["Tiyolpaqui", "Niyolpaqui", "Yolpaqui", "Ticiahui"]',
       'citlali',
       'Ti- (tú) + yolpaqui',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Está cansado (él o ella)',
       '["Ciahui"]',
       '["Ciahui", "Niciahui", "Ticiahui", "Yolpaqui"]',
       'coltzin',
       'Sin prefijo el verbo habla de él o ella: ciahui',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estoy enfermo',
       '["Ninococoa"]',
       '["Ninococoa", "Niciahui", "Niyolpaqui", "Cualli ninemi"]',
       'neza',
       'Ninococoa significa estoy enfermo o me siento mal',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ciahui',
       '["Ni", "Niciahui"]',
       null,
       'tonatiuh',
       'Agrega ni- para hablar de ti mismo: niciahui',
       20, 'medium',
       'Estoy cansado'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______yolpaqui',
       '["Ti", "Tiyolpaqui"]',
       null,
       'xochitl',
       'Agrega ti- para hablar de la otra persona: tiyolpaqui',
       20, 'medium',
       'Estás contento'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 5;

-- nivel 1 · unidad 6: conversación básica
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Y',
       '["Ihuan"]',
       '["Ihuan", "Tlen", "Quen", "Ahmo"]',
       'citlali',
       'Ihuan une palabras e ideas: y',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Qué',
       '["Tlen"]',
       '["Tlen", "Quen", "Ihuan", "Miac"]',
       'coltzin',
       'Tlen pregunta qué',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cómo estás? Estoy bien, ¿y tú?',
       '["Quen tinemi? Cualli ninemi, ihuan tehuatl?"]',
       '["Quen tinemi? Cualli ninemi, ihuan tehuatl?", "Quen motoca? Notoca, ihuan tehuatl?", "Tlazohcamati, ahmo tlen", "Timoittazque moztla"]',
       'neza',
       'Saludo completo: pregunta, respuesta y devolver la pregunta',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me llamo Citlali, estoy contenta',
       '["Notoca Citlali, niyolpaqui"]',
       '["Notoca Citlali, niyolpaqui", "Motoca Citlali, tiyolpaqui", "Itoca Citlali, yolpaqui", "Notoca Citlali, niciahui"]',
       'tonatiuh',
       'Notoca (me llamo) + niyolpaqui (estoy contenta)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tlazohcamati, ______ moztla',
       '["timoittazque", "Tlazohcamati, timoittazque moztla"]',
       null,
       'xochitl',
       'Despedida completa: tlazohcamati, timoittazque moztla',
       20, 'medium',
       'Gracias, nos vemos mañana'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Quen ______? Cualli ninemi',
       '["tinemi", "Quen tinemi? Cualli ninemi"]',
       null,
       'citlali',
       'Pregunta con ti- (tú) y respuesta con ni- (yo)',
       20, 'medium',
       '¿Cómo estás? Estoy bien'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 6;

-- nivel 2 · unidad 1: pronombres personales
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nosotros',
       '["Tehuan"]',
       '["Nehuatl", "Yehuan", "Yehuatl", "Tehuan"]',
       'coltzin',
       'Tehuan significa nosotros',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ustedes',
       '["Amehuan"]',
       '["Noconeuh", "Notah", "Amehuan", "Yehuatl"]',
       'neza',
       'Amehuan significa ustedes',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ellos',
       '["Yehuan"]',
       '["Tehuan", "Nehuatl", "Amehuan", "Yehuan"]',
       'tonatiuh',
       'Yehuan significa ellos / ellas',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Yo estoy contento(a)',
       '["Nehuatl niyolpaqui"]',
       '["Nehuatl niyolpaqui", "Inin nocniuh", "Inin notah", "Nocol huehue"]',
       'xochitl',
       'Nehuatl niyolpaqui significa yo estoy contento(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ niyolpaqui',
       '["Nehuatl", "Nehuatl niyolpaqui"]',
       null,
       'citlali',
       'Nehuatl niyolpaqui significa yo estoy contento(a)',
       20, 'medium',
       'Yo estoy contento(a)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tehuatl ______',
       '["ticiahui", "Tehuatl ticiahui"]',
       null,
       'coltzin',
       'Tehuatl ticiahui significa tú estás cansado(a)',
       20, 'medium',
       'Tú estás cansado(a)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 1;

-- nivel 2 · unidad 2: la familia
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi mamá',
       '["Nonan"]',
       '["Inin", "Amehuan", "Nochan", "Nonan"]',
       'neza',
       'Nonan significa mi mamá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi papá',
       '["Notah"]',
       '["Notah", "Yehuan", "Noconeuh", "Tehuan"]',
       'tonatiuh',
       'Notah significa mi papá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi hijo(a)',
       '["Noconeuh"]',
       '["Yehuan", "Nochan", "Noconeuh", "Amehuan"]',
       'xochitl',
       'Noconeuh significa mi hijo(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi casa',
       '["Nochan"]',
       '["Yehuan", "Inin", "Amehuan", "Nochan"]',
       'citlali',
       'Nochan significa mi casa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nonan',
       '["Inin", "Inin nonan"]',
       null,
       'coltzin',
       'Inin nonan significa esta es mi mamá',
       20, 'medium',
       'Esta es mi mamá'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Inin ______',
       '["notah", "Inin notah"]',
       null,
       'neza',
       'Inin notah significa este es mi papá',
       20, 'medium',
       'Este es mi papá'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 2;

-- nivel 2 · unidad 3: cómo es mi familia
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Fuerte',
       '["Chicahuac"]',
       '["Chicahuac", "Cualli", "Tepiton", "Nonan"]',
       'tonatiuh',
       'Chicahuac significa fuerte',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Grande',
       '["Huey"]',
       '["Tehuan", "Cualli", "Nonan", "Huey"]',
       'xochitl',
       'Huey significa grande',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pequeño(a)',
       '["Tepiton"]',
       '["Chicahuac", "Yancuic", "Tehuan", "Tepiton"]',
       'citlali',
       'Tepiton significa pequeño(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nuevo(a)',
       '["Yancuic"]',
       '["Huey", "Cualli", "Yancuic", "Amehuan"]',
       'coltzin',
       'Yancuic significa nuevo(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ chicahuac',
       '["Notah", "Notah chicahuac"]',
       null,
       'neza',
       'Notah chicahuac significa mi papá es fuerte',
       20, 'medium',
       'Mi papá es fuerte'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nonan ______',
       '["cualli", "Nonan cualli"]',
       null,
       'tonatiuh',
       'Nonan cualli significa mi mamá es buena',
       20, 'medium',
       'Mi mamá es buena'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 3;

-- nivel 2 · unidad 4: hermanos y amigos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi amigo(a)',
       '["Nocniuh"]',
       '["Nocniuh", "Yehuan", "Inin", "Tehuan"]',
       'xochitl',
       'Nocniuh significa mi amigo(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi hermano mayor',
       '["Noachcauh"]',
       '["Noachcauh", "Yehuan", "Inin", "Tehuan"]',
       'citlali',
       'Noachcauh significa mi hermano mayor',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi hermano menor',
       '["Noiccauh"]',
       '["Ichpochtli", "Telpochtli", "Amehuan", "Noiccauh"]',
       'coltzin',
       'Noiccauh significa mi hermano menor',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muchacho',
       '["Telpochtli"]',
       '["Amehuan", "Telpochtli", "Yehuan", "Inin"]',
       'neza',
       'Telpochtli significa muchacho / joven',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nocniuh',
       '["Inin", "Inin nocniuh"]',
       null,
       'tonatiuh',
       'Inin nocniuh significa este es mi amigo',
       20, 'medium',
       'Este es mi amigo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______cniuh',
       '["No", "Nocniuh"]',
       null,
       'xochitl',
       'Nocniuh significa mi amigo(a)',
       20, 'medium',
       'Mi amigo(a)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 4;

-- nivel 2 · unidad 5: los abuelos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi abuelo',
       '["Nocol"]',
       '["Nocol", "Tehuan", "Amehuan", "Tlamatini"]',
       'citlali',
       'Nocol significa mi abuelo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi abuela',
       '["Nocih"]',
       '["Amehuan", "Tehuan", "Yehuan", "Nocih"]',
       'coltzin',
       'Nocih significa mi abuela',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Anciano',
       '["Huehue"]',
       '["Huehue", "Nonan", "Yehuan", "Nocol"]',
       'neza',
       'Huehue significa anciano',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Anciana',
       '["Ilamatl"]',
       '["Nocih", "Nonan", "Ilamatl", "Tlamatini"]',
       'tonatiuh',
       'Ilamatl significa anciana',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ tlamatini',
       '["Nocih", "Nocih tlamatini"]',
       null,
       'xochitl',
       'Nocih tlamatini significa mi abuela es sabia',
       20, 'medium',
       'Mi abuela es sabia'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nocol ______',
       '["huehue", "Nocol huehue"]',
       null,
       'citlali',
       'Nocol huehue significa mi abuelo es anciano',
       20, 'medium',
       'Mi abuelo es anciano'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 5;

-- nivel 2 · unidad 6: mi familia completa
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tengo',
       '["Nicpia"]',
       '["Nicpia", "Ce", "Noconehuan", "Amehuan"]',
       'coltzin',
       'Nicpia significa tengo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Uno',
       '["Ce"]',
       '["Nonan", "Noconehuan", "Nicpia", "Ce"]',
       'neza',
       'Ce significa uno',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dos',
       '["Ome"]',
       '["Amehuan", "Notah", "Ome", "Ce"]',
       'tonatiuh',
       'Ome significa dos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mis hijos',
       '["Noconehuan"]',
       '["Notah", "Tehuan", "Noconehuan", "Ihuan"]',
       'xochitl',
       'Noconehuan significa mis hijos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ ce nocniuh',
       '["Nicpia", "Nicpia ce nocniuh"]',
       null,
       'citlali',
       'Nicpia ce nocniuh significa tengo un amigo',
       20, 'medium',
       'Tengo un amigo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nicpia ome ______',
       '["noconehuan", "Nicpia ome noconehuan"]',
       null,
       'coltzin',
       'Nicpia ome noconehuan significa tengo dos hijos',
       20, 'medium',
       'Tengo dos hijos'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 6;

-- nivel 3 · unidad 1: palabras para preguntar
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quién',
       '["Aquin"]',
       '["Quen", "Aquin", "Nimomachtia", "Tlen"]',
       'neza',
       'Aquin significa quién',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dónde',
       '["Canin"]',
       '["Canin", "Tlen", "Nimomachtia", "Quezqui"]',
       'tonatiuh',
       'Canin significa dónde',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cuándo',
       '["Quemman"]',
       '["Quezqui", "Quen", "Quemman", "Canin"]',
       'xochitl',
       'Quemman significa cuándo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Por qué',
       '["Tleica"]',
       '["Quezqui", "Tleica", "Canin", "Nitequiti"]',
       'citlali',
       'Tleica significa por qué',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______quin',
       '["A", "Aquin"]',
       null,
       'coltzin',
       'Aquin significa quién',
       20, 'medium',
       'Quién'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______anin',
       '["C", "Canin"]',
       null,
       'neza',
       'Canin significa dónde',
       20, 'medium',
       'Dónde'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 1;

-- nivel 3 · unidad 2: preguntas personales
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajo',
       '["Nitequiti"]',
       '["Nimomachtia", "Quemman", "Aquin", "Nitequiti"]',
       'tonatiuh',
       'Nitequiti significa trabajo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estudio',
       '["Nimomachtia"]',
       '["Nimomachtia", "Momachtia", "Nitequiti", "Tleica"]',
       'xochitl',
       'Nimomachtia significa estudio',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Quién eres tú?',
       '["Aquin tehuatl?"]',
       '["Tlen ticchihua?", "Aquin tehuatl?", "Tlen ticnequi?", "Canin tichaneh?"]',
       'citlali',
       'Aquin tehuatl? significa ¿quién eres tú?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Dónde vives?',
       '["Canin tichaneh?"]',
       '["Canin tichaneh?", "Tlen quichihua?", "Canin ca?", "Tlen ticchihua?"]',
       'coltzin',
       'Canin tichaneh? significa ¿dónde vives?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ tehuatl?',
       '["Aquin", "Aquin tehuatl?"]',
       null,
       'neza',
       'Aquin tehuatl? significa ¿quién eres tú?',
       20, 'medium',
       '¿Quién eres tú?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Canin ______?',
       '["tichaneh", "Canin tichaneh?"]',
       null,
       'tonatiuh',
       'Canin tichaneh? significa ¿dónde vives?',
       20, 'medium',
       '¿Dónde vives?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 2;

-- nivel 3 · unidad 3: preguntas sobre otros
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabaja',
       '["Tequiti"]',
       '["Yehuatl", "Nitequiti", "Quemman", "Tequiti"]',
       'xochitl',
       'Tequiti significa trabaja',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estudia',
       '["Momachtia"]',
       '["Tleica", "Yehuatl", "Momachtia", "Tequiti"]',
       'citlali',
       'Momachtia significa estudia',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Quién es él',
       '["Aquin yehuatl?"]',
       '["Canin ca?", "Aquin yehuatl?", "Tlen ticchihua?", "Tlen ticnequi?"]',
       'coltzin',
       'Aquin yehuatl? significa ¿quién es él / ella?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Qué hace él',
       '["Tlen quichihua?"]',
       '["Nichaneh Tlaxcallan", "Tlen quichihua?", "Tlen ticchihua?", "Aquin tehuatl?"]',
       'neza',
       'Tlen quichihua? significa ¿qué hace él / ella?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ yehuatl?',
       '["Aquin", "Aquin yehuatl?"]',
       null,
       'tonatiuh',
       'Aquin yehuatl? significa ¿quién es él / ella?',
       20, 'medium',
       '¿Quién es él'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tlen ______?',
       '["quichihua", "Tlen quichihua?"]',
       null,
       'xochitl',
       'Tlen quichihua? significa ¿qué hace él / ella?',
       20, 'medium',
       '¿Qué hace él'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 3;

-- nivel 3 · unidad 4: dónde está y qué necesito
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Aquí',
       '["Nican"]',
       '["Nican", "Canin", "Monequi", "Nicnequi"]',
       'citlali',
       'Nican significa aquí',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Allá',
       '["Ompa"]',
       '["Tleica", "Ompa", "Quemman", "Nican"]',
       'coltzin',
       'Ompa significa allá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quiero',
       '["Nicnequi"]',
       '["Nicnequi", "Ompa", "Canin", "Monequi"]',
       'neza',
       'Nicnequi significa quiero / necesito',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Se necesita',
       '["Monequi"]',
       '["Monequi", "Aquin", "Ompa", "Atl"]',
       'tonatiuh',
       'Monequi significa se necesita',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ ca?',
       '["Canin", "Canin ca?"]',
       null,
       'xochitl',
       'Canin ca? significa ¿dónde está?',
       20, 'medium',
       '¿Dónde está?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tlen ______?',
       '["ticnequi", "Tlen ticnequi?"]',
       null,
       'citlali',
       'Tlen ticnequi? significa ¿qué quieres?',
       20, 'medium',
       '¿Qué quieres?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 4;

-- nivel 3 · unidad 5: respuestas completas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Sé',
       '["Nicmati"]',
       '["Nimomachtia", "Tleica", "Nicmati", "Ahmo"]',
       'coltzin',
       'Nicmati significa sé / lo sé',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Aquí está',
       '["Nican ca"]',
       '["Nican ca", "Ahmo nicmati", "Ompa ca", "Nichaneh Tlaxcallan"]',
       'neza',
       'Nican ca significa aquí está',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Allá está',
       '["Ompa ca"]',
       '["Aquin tehuatl?", "Canin tichaneh?", "Ompa ca", "Nichaneh Tlaxcallan"]',
       'tonatiuh',
       'Ompa ca significa allá está',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quiero agua',
       '["Nicnequi atl"]',
       '["Tlen ticchihua?", "Aquin tehuatl?", "Nicnequi atl", "Ahmo nicnequi"]',
       'xochitl',
       'Nicnequi atl significa quiero agua',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ ca',
       '["Nican", "Nican ca"]',
       null,
       'citlali',
       'Nican ca significa aquí está',
       20, 'medium',
       'Aquí está'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ompa ______',
       '["ca", "Ompa ca"]',
       null,
       'coltzin',
       'Ompa ca significa allá está',
       20, 'medium',
       'Allá está'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 5;

-- nivel 3 · unidad 6: cuántos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tres',
       '["Eyi"]',
       '["Ce", "Eyi", "Quezqui", "Ome"]',
       'neza',
       'Eyi significa tres',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cuatro',
       '["Nahui"]',
       '["Canin", "Quezqui", "Macuilli", "Nahui"]',
       'tonatiuh',
       'Nahui significa cuatro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cinco',
       '["Macuilli"]',
       '["Nahui", "Macuilli", "Eyi", "Aquin"]',
       'xochitl',
       'Macuilli significa cinco',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cuántos quieres?',
       '["Quezqui ticnequi?"]',
       '["Aquin tehuatl?", "Quezqui ticnequi?", "Canin tichaneh?", "Tlen ticchihua?"]',
       'citlali',
       'Quezqui ticnequi? significa ¿cuántos quieres?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ ticnequi?',
       '["Quezqui", "Quezqui ticnequi?"]',
       null,
       'coltzin',
       'Quezqui ticnequi? significa ¿cuántos quieres?',
       20, 'medium',
       '¿Cuántos quieres?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nicnequi ______',
       '["ome", "Nicnequi ome"]',
       null,
       'neza',
       'Nicnequi ome significa quiero dos',
       20, 'medium',
       'Quiero dos'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 6;

-- nivel 4 · unidad 1: hoy, ayer y mañana
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hoy',
       '["Axcan"]',
       '["Huiptla", "Axcan", "Moztla", "Tonalli"]',
       'tonatiuh',
       'Axcan significa hoy / ahora',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ayer',
       '["Yalhua"]',
       '["Axcan", "Yohualli", "Yalhua", "Tonalli"]',
       'xochitl',
       'Yalhua significa ayer',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pasado mañana',
       '["Huiptla"]',
       '["Yalhua", "Axcan", "Huiptla", "Otitequit"]',
       'citlali',
       'Huiptla significa pasado mañana',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Día',
       '["Tonalli"]',
       '["Yohualli", "Huiptla", "Onitequit", "Tonalli"]',
       'coltzin',
       'Tonalli significa día / sol',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nitequiti',
       '["Axcan", "Axcan nitequiti"]',
       null,
       'neza',
       'Axcan nitequiti significa hoy trabajo',
       20, 'medium',
       'Hoy trabajo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______xcan',
       '["A", "Axcan"]',
       null,
       'tonatiuh',
       'Axcan significa hoy / ahora',
       20, 'medium',
       'Hoy'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 1;

-- nivel 4 · unidad 2: pasado y futuro
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajé',
       '["Onitequit"]',
       '["Onicochic", "Onitequit", "Nicochiz", "Yalhua"]',
       'xochitl',
       'Onitequit significa trabajé',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajaré',
       '["Nitequitiz"]',
       '["Nitequitiz", "Nicochiz", "Nitequiti", "Axcan"]',
       'citlali',
       'Nitequitiz significa trabajaré',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajaste',
       '["Otitequit"]',
       '["Onitequit", "Nitequiti", "Otitequit", "Yalhua"]',
       'coltzin',
       'Otitequit significa trabajaste',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajarás',
       '["Titequitiz"]',
       '["Yalhua", "Otitequit", "Nitequiti", "Titequitiz"]',
       'neza',
       'Titequitiz significa trabajarás',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______itequit',
       '["On", "Onitequit"]',
       null,
       'tonatiuh',
       'Onitequit significa trabajé',
       20, 'medium',
       'Trabajé'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______tequitiz',
       '["Ni", "Nitequitiz"]',
       null,
       'xochitl',
       'Nitequitiz significa trabajaré',
       20, 'medium',
       'Trabajaré'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 2;

-- nivel 4 · unidad 3: ver y verse
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lo',
       '["Niquitta"]',
       '["Tonalli", "Nimitzitta", "Niquitta", "Huiptla"]',
       'citlali',
       'Niquitta significa lo / la veo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lo',
       '["Oniquittac"]',
       '["Onimitzittac", "Onitequit", "Huiptla", "Oniquittac"]',
       'coltzin',
       'Oniquittac significa lo / la vi',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lo',
       '["Niquittaz"]',
       '["Onitequit", "Yalhua", "Niquittaz", "Huiptla"]',
       'neza',
       'Niquittaz significa lo / la veré',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Te veo',
       '["Nimitzitta"]',
       '["Tonalli", "Nimitzitta", "Niquittaz", "Onimitzittac"]',
       'tonatiuh',
       'Nimitzitta significa te veo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ onimitzittac',
       '["Yalhua", "Yalhua onimitzittac"]',
       null,
       'xochitl',
       'Yalhua onimitzittac significa ayer te vi',
       20, 'medium',
       'Ayer te vi'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______quitta',
       '["Ni", "Niquitta"]',
       null,
       'citlali',
       'Niquitta significa lo / la veo',
       20, 'medium',
       'Lo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 3;

-- nivel 4 · unidad 4: comer, beber e ir
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Como',
       '["Nitlacua"]',
       '["Nitlacuaz", "Niyaz", "Nitlacua", "Axcan"]',
       'coltzin',
       'Nitlacua significa como',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Comí',
       '["Onitlacuah"]',
       '["Nitlacuaz", "Niatli", "Onitlacuah", "Axcan"]',
       'neza',
       'Onitlacuah significa comí',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Comeré',
       '["Nitlacuaz"]',
       '["Nitlacuaz", "Yalhua", "Oniya", "Niyauh"]',
       'tonatiuh',
       'Nitlacuaz significa comeré',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Bebo',
       '["Niatli"]',
       '["Nitlacuaz", "Niyaz", "Oniya", "Niatli"]',
       'xochitl',
       'Niatli significa bebo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______tlacua',
       '["Ni", "Nitlacua"]',
       null,
       'citlali',
       'Nitlacua significa como',
       20, 'medium',
       'Como'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______itlacuah',
       '["On", "Onitlacuah"]',
       null,
       'coltzin',
       'Onitlacuah significa comí',
       20, 'medium',
       'Comí'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 4;

-- nivel 4 · unidad 5: cuándo y dónde
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estoy',
       '["Nicah"]',
       '["Yalhua", "Huiptla", "Nicah", "Nican"]',
       'neza',
       'Nicah significa estoy',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estás',
       '["Ticah"]',
       '["Nicah", "Ticah", "Yohualli", "Axcan"]',
       'tonatiuh',
       'Ticah significa estás',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ayer fui allá',
       '["Yalhua oniya ompa"]',
       '["Yalhua oniya ompa", "Axcan nitequiti", "Yalhua onimitzittac", "Zatepan nitequiti"]',
       'xochitl',
       'Yalhua oniya ompa significa ayer fui allá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mañana iré',
       '["Moztla niyaz"]',
       '["Moztla niyaz", "Zatepan nitequiti", "Axcan nitequiti", "Axcan nican nicah"]',
       'citlali',
       'Moztla niyaz significa mañana iré',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ oniya ompa',
       '["Yalhua", "Yalhua oniya ompa"]',
       null,
       'coltzin',
       'Yalhua oniya ompa significa ayer fui allá',
       20, 'medium',
       'Ayer fui allá'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Moztla ______',
       '["niyaz", "Moztla niyaz"]',
       null,
       'neza',
       'Moztla niyaz significa mañana iré',
       20, 'medium',
       'Mañana iré'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 5;

-- nivel 4 · unidad 6: contar lo que pasó
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Primero',
       '["Achto"]',
       '["Tonalli", "Yalhua", "Achto", "Huiptla"]',
       'tonatiuh',
       'Achto significa primero',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Después',
       '["Zatepan"]',
       '["Nitequiti", "Niman", "Huiptla", "Zatepan"]',
       'xochitl',
       'Zatepan significa después',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Luego',
       '["Niman"]',
       '["Zatepan", "Yalhua", "Achto", "Niman"]',
       'citlali',
       'Niman significa luego / enseguida',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Primero como',
       '["Achto nitlacua"]',
       '["Moztla niyaz", "Yalhua onimitzittac", "Axcan nitequiti", "Achto nitlacua"]',
       'coltzin',
       'Achto nitlacua significa primero como',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nitlacua',
       '["Achto", "Achto nitlacua"]',
       null,
       'neza',
       'Achto nitlacua significa primero como',
       20, 'medium',
       'Primero como'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Zatepan ______',
       '["nitequiti", "Zatepan nitequiti"]',
       null,
       'tonatiuh',
       'Zatepan nitequiti significa después trabajo',
       20, 'medium',
       'Después trabajo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 6;

-- nivel 5 · unidad 1: por la mañana
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me levanto',
       '["Nimehua"]',
       '["Etl", "Nimehua", "Tlaneci", "Nimaltia"]',
       'xochitl',
       'Nimehua significa me levanto',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me baño',
       '["Nimaltia"]',
       '["Nimaltia", "Nimehua", "Niquiza", "Etl"]',
       'citlali',
       'Nimaltia significa me baño',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Salgo',
       '["Niquiza"]',
       '["Nimehua", "Nicochi", "Niquiza", "Tlaneci"]',
       'coltzin',
       'Niquiza significa salgo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Vengo',
       '["Nihuallauh"]',
       '["Niquiza", "Tlaneci", "Nihuallauh", "Etl"]',
       'neza',
       'Nihuallauh significa vengo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______mehua',
       '["Ni", "Nimehua"]',
       null,
       'tonatiuh',
       'Nimehua significa me levanto',
       20, 'medium',
       'Me levanto'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______maltia',
       '["Ni", "Nimaltia"]',
       null,
       'xochitl',
       'Nimaltia significa me baño',
       20, 'medium',
       'Me baño'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 1;

-- nivel 5 · unidad 2: dormir y comer
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Duermo',
       '["Nicochi"]',
       '["Niquiza", "Nitlacua", "Nimaltia", "Nicochi"]',
       'citlali',
       'Nicochi significa duermo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tortilla',
       '["Tlaxcalli"]',
       '["Nimehua", "Tlaxcalli", "Chilli", "Niquiza"]',
       'coltzin',
       'Tlaxcalli significa tortilla',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Frijol',
       '["Etl"]',
       '["Nimehua", "Nihuallauh", "Etl", "Chilli"]',
       'neza',
       'Etl significa frijol',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Chile',
       '["Chilli"]',
       '["Nimehua", "Nimaltia", "Tlaxcalli", "Chilli"]',
       'tonatiuh',
       'Chilli significa chile',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ tlaxcalli',
       '["Niccua", "Niccua tlaxcalli"]',
       null,
       'xochitl',
       'Niccua tlaxcalli significa como tortilla',
       20, 'medium',
       'Como tortilla'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Niccua ______',
       '["etl", "Niccua etl"]',
       null,
       'citlali',
       'Niccua etl significa como frijol',
       20, 'medium',
       'Como frijol'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 2;

-- nivel 5 · unidad 3: con otras personas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Comemos',
       '["Titlacuah"]',
       '["Nohuan", "Titlacuah", "Mohuan", "Nimaltia"]',
       'coltzin',
       'Titlacuah significa comemos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajamos',
       '["Titequitih"]',
       '["Mohuan", "Titlacuah", "Titequitih", "Nihuallauh"]',
       'neza',
       'Titequitih significa trabajamos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Conmigo',
       '["Nohuan"]',
       '["Niquiza", "Nohuan", "Nimehua", "Mohuan"]',
       'tonatiuh',
       'Nohuan significa conmigo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Contigo',
       '["Mohuan"]',
       '["Nimaltia", "Niquiza", "Nonan", "Mohuan"]',
       'xochitl',
       'Mohuan significa contigo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ mohuan',
       '["Nitlacua", "Nitlacua mohuan"]',
       null,
       'citlali',
       'Nitlacua mohuan significa como contigo',
       20, 'medium',
       'Como contigo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nonan ihuan nehuatl ______',
       '["titlacuah", "Nonan ihuan nehuatl titlacuah"]',
       null,
       'coltzin',
       'Nonan ihuan nehuatl titlacuah significa mi mamá y yo comemos',
       20, 'medium',
       'Mi mamá y yo comemos'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 3;

-- nivel 5 · unidad 4: mañana, tarde y noche
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tarde',
       '["Teotlac"]',
       '["Nimaltia", "Nicochi", "Teotlac", "Nihuallauh"]',
       'neza',
       'Teotlac significa tarde',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Anochece',
       '["Tlayohua"]',
       '["Nicochi", "Tlayohua", "Tlaneci", "Niquiza"]',
       'tonatiuh',
       'Tlayohua significa anochece',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'En la tarde trabajo',
       '["Teotlac nitequiti"]',
       '["Teotlac nitequiti", "Nitlacua mohuan", "Niccua etl", "Tlaneci nimehua"]',
       'xochitl',
       'Teotlac nitequiti significa en la tarde trabajo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'En la noche duermo',
       '["Yohualli nicochi"]',
       '["Niccua etl", "Yohualli nicochi", "Niccua tlaxcalli", "Yehuan tlacuah"]',
       'citlali',
       'Yohualli nicochi significa en la noche duermo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nitequiti',
       '["Teotlac", "Teotlac nitequiti"]',
       null,
       'coltzin',
       'Teotlac nitequiti significa en la tarde trabajo',
       20, 'medium',
       'En la tarde trabajo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Yohualli ______',
       '["nicochi", "Yohualli nicochi"]',
       null,
       'neza',
       'Yohualli nicochi significa en la noche duermo',
       20, 'medium',
       'En la noche duermo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 4;

-- nivel 5 · unidad 5: rutinas en plural
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dormimos',
       '["Ticochih"]',
       '["Ticochih", "Nimehua", "Nimaltia", "Tequitih"]',
       'tonatiuh',
       'Ticochih significa dormimos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Duermen',
       '["Cochih"]',
       '["Cochih", "Tlacuah", "Niquiza", "Tehuan"]',
       'xochitl',
       'Cochih significa duermen',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Comen',
       '["Tlacuah"]',
       '["Tlacuah", "Ticochih", "Nimehua", "Nimaltia"]',
       'citlali',
       'Tlacuah significa comen',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajan',
       '["Tequitih"]',
       '["Niquiza", "Yehuan", "Tequitih", "Cochih"]',
       'coltzin',
       'Tequitih significa trabajan',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ ticochih',
       '["Tehuan", "Tehuan ticochih"]',
       null,
       'neza',
       'Tehuan ticochih significa nosotros dormimos',
       20, 'medium',
       'Nosotros dormimos'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Yehuan ______',
       '["tlacuah", "Yehuan tlacuah"]',
       null,
       'tonatiuh',
       'Yehuan tlacuah significa ellos comen',
       20, 'medium',
       'Ellos comen'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 5;

-- nivel 5 · unidad 6: mi día completo
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Amanece y me levanto',
       '["Tlaneci nimehua"]',
       '["Tlaneci nimehua", "Niman niquiza", "Teotlac nitequiti", "Niccua tlaxcalli"]',
       'xochitl',
       'Tlaneci nimehua significa amanece y me levanto',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Luego salgo',
       '["Niman niquiza"]',
       '["Niman niquiza", "Nitlacua mohuan", "Tlaneci nimehua", "Yohualli nicochi"]',
       'citlali',
       'Niman niquiza significa luego salgo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Temprano me baño',
       '["Cualcan nimaltia"]',
       '["Niccua etl", "Cualcan nimaltia", "Tlaneci nimehua", "Nonan ihuan nehuatl titlacuah"]',
       'coltzin',
       'Cualcan nimaltia significa temprano me baño',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Primero',
       '["Achto"]',
       '["Nihuallauh", "Cualcan", "Achto", "Nimehua"]',
       'neza',
       'Achto significa primero',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nimehua',
       '["Tlaneci", "Tlaneci nimehua"]',
       null,
       'tonatiuh',
       'Tlaneci nimehua significa amanece y me levanto',
       20, 'medium',
       'Amanece y me levanto'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Niman ______',
       '["niquiza", "Niman niquiza"]',
       null,
       'xochitl',
       'Niman niquiza significa luego salgo',
       20, 'medium',
       'Luego salgo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 6;

-- nivel 6 · unidad 1: lo que me gusta
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me gusta',
       '["Nechpactia"]',
       '["Xihualla", "Achi", "Nechpactia", "Mitzpactia?"]',
       'citlali',
       'Nechpactia significa me gusta',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Te gusta?',
       '["Mitzpactia?"]',
       '["Xihualla", "Mitzpactia?", "Xicochi", "Ticnequi"]',
       'coltzin',
       'Mitzpactia? significa ¿te gusta?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mucho',
       '["Cenca"]',
       '["Mitzpactia?", "Nechpactia", "Xicochi", "Cenca"]',
       'neza',
       'Cenca significa mucho / muy',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Un poco',
       '["Achi"]',
       '["Achi", "Xitlacua", "Nechpactia", "Mitzpactia?"]',
       'tonatiuh',
       'Achi significa un poco',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nechpactia',
       '["Ahmo", "Ahmo nechpactia"]',
       null,
       'xochitl',
       'Ahmo nechpactia significa no me gusta',
       20, 'medium',
       'No me gusta'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______chpactia',
       '["Ne", "Nechpactia"]',
       null,
       'citlali',
       'Nechpactia significa me gusta',
       20, 'medium',
       'Me gusta'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 1;

-- nivel 6 · unidad 2: lo que quiero
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quieres',
       '["Ticnequi"]',
       '["Cenca", "Ticnequi", "Quinequi", "Achi"]',
       'coltzin',
       'Ticnequi significa quieres',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quiere',
       '["Quinequi"]',
       '["Xicochi", "Quinequi", "Nechpactia", "Nicnequi"]',
       'neza',
       'Quinequi significa quiere',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quiero comer',
       '["Nicnequi nitlacuaz"]',
       '["Ahmo cualli", "Ahmo nechpactia", "Oc achi cualli", "Nicnequi nitlacuaz"]',
       'tonatiuh',
       'Nicnequi nitlacuaz significa quiero comer',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quiero dormir',
       '["Nicnequi nicochiz"]',
       '["Cenca cualli", "Nicnequi nicochiz", "Ahmo nechpactia", "Nicnequi nitlacuaz"]',
       'xochitl',
       'Nicnequi nicochiz significa quiero dormir',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nitlacuaz',
       '["Nicnequi", "Nicnequi nitlacuaz"]',
       null,
       'citlali',
       'Nicnequi nitlacuaz significa quiero comer',
       20, 'medium',
       'Quiero comer'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nicnequi ______',
       '["nicochiz", "Nicnequi nicochiz"]',
       null,
       'coltzin',
       'Nicnequi nicochiz significa quiero dormir',
       20, 'medium',
       'Quiero dormir'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 2;

-- nivel 6 · unidad 3: pedir y ordenar
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Come (tú)',
       '["Xitlacua"]',
       '["Xitlacua", "Nechpactia", "Mitzpactia?", "Ximotlali"]',
       'neza',
       'Xitlacua significa come (tú)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Duerme (tú)',
       '["Xicochi"]',
       '["Xicochi", "Ximotlali", "Mitzpactia?", "Cenca"]',
       'tonatiuh',
       'Xicochi significa duerme (tú)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ven (tú)',
       '["Xihualla"]',
       '["Ximotlali", "Mitzpactia?", "Cenca", "Xihualla"]',
       'xochitl',
       'Xihualla significa ven (tú)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Siéntate',
       '["Ximotlali"]',
       '["Ximotlali", "Nimitztlatlauhtia", "Xihualla", "Xitlacua"]',
       'citlali',
       'Ximotlali significa siéntate',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______, xihualla',
       '["Nimitztlatlauhtia", "Nimitztlatlauhtia, xihualla"]',
       null,
       'coltzin',
       'Nimitztlatlauhtia, xihualla significa por favor, ven',
       20, 'medium',
       'Por favor, ven'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______tlacua',
       '["Xi", "Xitlacua"]',
       null,
       'neza',
       'Xitlacua significa come (tú)',
       20, 'medium',
       'Come (tú)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 3;

-- nivel 6 · unidad 4: más y menos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Más',
       '["Oc achi"]',
       '["Ahmo cualli", "Oc achi", "Ahmo nechpactia", "Nimitztlatlauhtia, xihualla"]',
       'tonatiuh',
       'Oc achi significa más',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mejor',
       '["Oc achi cualli"]',
       '["Ahmo nechpactia", "Oc achi", "Nimitztlatlauhtia, xihualla", "Oc achi cualli"]',
       'xochitl',
       'Oc achi cualli significa mejor',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muy bueno',
       '["Cenca cualli"]',
       '["Cenca cualli", "Oc achi", "Nechpactia atl", "Nicnequi nitlacuaz"]',
       'citlali',
       'Cenca cualli significa muy bueno',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'No es bueno',
       '["Ahmo cualli"]',
       '["Nicnequi nicochiz", "Oc achi cualli", "Cenca cualli", "Ahmo cualli"]',
       'coltzin',
       'Ahmo cualli significa no es bueno',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ achi',
       '["Oc", "Oc achi"]',
       null,
       'neza',
       'Oc achi significa más',
       20, 'medium',
       'Más'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Oc achi ______',
       '["cualli", "Oc achi cualli"]',
       null,
       'tonatiuh',
       'Oc achi cualli significa mejor',
       20, 'medium',
       'Mejor'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 4;

-- nivel 6 · unidad 5: mis gustos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me gusta el agua',
       '["Nechpactia atl"]',
       '["Nicnequi nitlacuaz", "Nechpactia atl", "Nimitztlatlauhtia, xihualla", "Oc achi"]',
       'xochitl',
       'Nechpactia atl significa me gusta el agua',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me gusta la tortilla',
       '["Nechpactia tlaxcalli"]',
       '["Nechpactia atl", "Oc achi", "Nechpactia tlaxcalli", "Ahmo nechpactia"]',
       'citlali',
       'Nechpactia tlaxcalli significa me gusta la tortilla',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'No me gusta el chile',
       '["Ahmo nechpactia chilli"]',
       '["Ahmo nechpactia chilli", "Mitzpactia etl?", "Nechpactia tlaxcalli", "Nicnequi nitlacuaz"]',
       'coltzin',
       'Ahmo nechpactia chilli significa no me gusta el chile',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Te gusta el frijol?',
       '["Mitzpactia etl?"]',
       '["Mitzpactia etl?", "Nicnequi nicochiz", "Ahmo nechpactia chilli", "Nicnequi nitlacuaz"]',
       'neza',
       'Mitzpactia etl? significa ¿te gusta el frijol?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ atl',
       '["Nechpactia", "Nechpactia atl"]',
       null,
       'tonatiuh',
       'Nechpactia atl significa me gusta el agua',
       20, 'medium',
       'Me gusta el agua'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nechpactia ______',
       '["tlaxcalli", "Nechpactia tlaxcalli"]',
       null,
       'xochitl',
       'Nechpactia tlaxcalli significa me gusta la tortilla',
       20, 'medium',
       'Me gusta la tortilla'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 5;

-- nivel 6 · unidad 6: expresión completa
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Idioma náhuatl',
       '["Nahuatlahtolli"]',
       '["Achi", "Nahuatlahtolli", "Nicnequi", "Cenca"]',
       'citlali',
       'Nahuatlahtolli significa idioma náhuatl',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Qué te gusta?',
       '["Tlen mitzpactia?"]',
       '["Ahmo nechpactia", "Nimitztlatlauhtia, xihualla", "Oc achi", "Tlen mitzpactia?"]',
       'coltzin',
       'Tlen mitzpactia? significa ¿qué te gusta?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me gusta el náhuatl',
       '["Nechpactia nahuatlahtolli"]',
       '["Oc achi", "Ahmo nechpactia", "Nechpactia nahuatlahtolli", "Nicnequi nicochiz"]',
       'neza',
       'Nechpactia nahuatlahtolli significa me gusta el náhuatl',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me gusta',
       '["Nechpactia"]',
       '["Cenca", "Nicnequi", "Nechpactia", "Ticnequi"]',
       'tonatiuh',
       'Nechpactia significa me gusta',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ mitzpactia?',
       '["Tlen", "Tlen mitzpactia?"]',
       null,
       'xochitl',
       'Tlen mitzpactia? significa ¿qué te gusta?',
       20, 'medium',
       '¿Qué te gusta?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nechpactia ______',
       '["nahuatlahtolli", "Nechpactia nahuatlahtolli"]',
       null,
       'citlali',
       'Nechpactia nahuatlahtolli significa me gusta el náhuatl',
       20, 'medium',
       'Me gusta el náhuatl'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 6;

-- ─────────────────────────────────────────────
--  7. sistema de escritura
-- ─────────────────────────────────────────────
insert into ct_writing_systems (language_id, system_type, system_name, description, notes)
select id, 'alphabet', 'alfabeto práctico',
       'Ortografía práctica de base clásica, sin macrones. Borrador pendiente de validar con hablantes de la variante.',
       '["Tl, tz, ch, qu, cu y hu representan un solo sonido y no se separan al silabear",
         "La tl final se queda en la sílaba anterior: xo-chitl, ne-huatl",
         "La h marca el saltillo (corte de voz): tlazohcamati, quemah, ahmo",
         "La vocal larga no se marca: no se usan macrones en ninguna palabra",
         "La doble l se pronuncia como dos l: cual-li",
         "No se usan acentos del español"]'
from ct_languages where code = 'nhn';

-- ─────────────────────────────────────────────
--  8. ta_user_progress — unidad 1 desbloqueada para el usuario demo
-- ─────────────────────────────────────────────
insert into ta_user_progress (user_id, unit_id, completed, is_current, is_locked)
select usr.id, u.id, 0, 1, 0
from ta_users usr
         cross join (
    select u.id from ct_units u
                         join ct_levels l on u.level_id = l.id
                         join ct_languages la on l.language_id = la.id
    where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 1
) u
where usr.username = 'tetecuhtli';

-- ─────────────────────────────────────────────
--  9. ta_user_stats — registro inicial para el usuario demo
-- ─────────────────────────────────────────────
insert into ta_user_stats (user_id, language_id, words_learned, lessons_done, perfect_less, days_studied, best_streak, total_mins)
select usr.id, la.id, 0, 0, 0, 0, 0, 0
from ta_users usr
         cross join ct_languages la
where usr.username = 'tetecuhtli' and la.code = 'nhn';

commit;

-- ─────────────────────────────────────────────
--  verificación
--  esperado: ct_levels 6 · ct_units 36 · ct_vocabulary 195 · rl_unit_vocab 254 · ct_exercises 216 · ct_writing_systems 1
-- ─────────────────────────────────────────────
select 'ct_levels' as tabla, count(1) as registros from ct_levels where language_id = (select id from ct_languages where code = 'nhn')
union all
select 'ct_units', count(1) from ct_units where level_id in (select id from ct_levels where language_id = (select id from ct_languages where code = 'nhn'))
union all
select 'ct_vocabulary', count(1) from ct_vocabulary where language_id = (select id from ct_languages where code = 'nhn')
union all
select 'rl_unit_vocab', count(1) from rl_unit_vocab where unit_id in (select u.id from ct_units u join ct_levels l on u.level_id = l.id where l.language_id = (select id from ct_languages where code = 'nhn'))
union all
select 'ct_exercises', count(1) from ct_exercises where unit_id in (select u.id from ct_units u join ct_levels l on u.level_id = l.id where l.language_id = (select id from ct_languages where code = 'nhn'))
union all
select 'ct_writing_systems', count(1) from ct_writing_systems where language_id = (select id from ct_languages where code = 'nhn');

-- unidades sin ejercicios (debe devolver 0 filas):
-- select l.level_num, u.unit_num from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
--  where la.code = 'nhn' and not exists (select 1 from ct_exercises e where e.unit_id = u.id);