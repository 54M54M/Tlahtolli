-- ============================================================
--  seed data — náhuatl central (nhn)
--  tlahtolcalli  [postgresql]
--
--  variante: náhuatl central (iso 639-3: nhn; grupo nah)
--  ejecutar después de:
--    1. tlahtolli_database_script.sql
--    2. general_seed_data.sql   (usuario demo y logros)
--
--  contenido (curso completo):
--    6 niveles · 36 unidades · 195 palabras y frases · 254 asociaciones · 216 ejercicios
--    ct_languages → ct_levels → ct_units → ct_vocabulary → rl_unit_vocab
--    → ct_exercises → ct_writing_systems → ta_user_progress → ta_user_stats
--
--  borrador para revisión con hablantes: todas las palabras, traducciones
--  y pronunciaciones deben validarse antes de publicarse.
--
--  norma ortográfica (una sola, en todo el contenido): ortografía moderna
--    · k, kw, w, s, ts, x (sh), ch, tl, l, m, n, p, t, y
--    · j = saltillo (corte de voz): tlasojkāmati, kēmaj, ajmo
--    · macrón = vocal larga: ā ē ī ō (ātl, nāwi, ōme); vocal sin macrón = corta
--    · sin acentos del español
--    · sílabas: ch, tl, ts y kw son un solo sonido; la tl final se queda en
--      la sílaba anterior (xō-chitl, ne-wātl)
--    · vocales largas tomadas del náhuatl clásico (karttunen, andrews):
--      validar con hablantes de la variante central
--  guía de pronunciación (generada con la misma regla para todo):
--    vocal larga = vocal doble (aa); x = sh; ' = saltillo; sílabas con guion
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
values ('nhn', 'Náhuatl central', 'Nāwatlajtōlli', null, '🌽', 'uto-aztec', 'alphabet');

-- ─────────────────────────────────────────────
--  2. niveles (título en náhuatl: frase corta del propio curso)
-- ─────────────────────────────────────────────
insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 1, 'Saluda y preséntate', 'Kēn tinemi?', null, 6, 'Ninguno - Nivel inicial', 1
from ct_languages where code = 'nhn';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 2, 'Descríbete y describe a tu familia', 'Nonān īwān notaj', null, 6, 'Completar Nivel 1', 0
from ct_languages where code = 'nhn';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 3, 'Pide y da información', 'Tlen, ākin, kānin?', null, 6, 'Completar Nivel 2', 0
from ct_languages where code = 'nhn';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 4, 'Habla en tiempos (ayer/hoy/mañana)', 'Yālwa, āxkān, mostla', null, 6, 'Completar Nivel 3', 0
from ct_languages where code = 'nhn';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 5, 'Describe un día normal', 'Tlanēsi, tlayowa', null, 6, 'Completar Nivel 4', 0
from ct_languages where code = 'nhn';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 6, 'Describe y expresa preferencias', 'Tlen mitspaktiā?', null, 6, 'Completar Nivel 5', 0
from ct_languages where code = 'nhn';

-- ─────────────────────────────────────────────
--  3.1 unidades — nivel 1: saluda y preséntate
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Saludos', null,
       'Saludar y preguntar cómo está la otra persona',
       'Kēn tinemi? / Kwalli ninemi: el verbo nemi (vivir, andar) con ni- (yo) y ti- (tú)', 1, null
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Despedidas', null,
       'Despedirse y quedar de verse',
       'Timoittaske (nos vemos) y palabras de tiempo: mostla, oksēppa', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Cómo te llamas', null,
       'Preguntar y decir el nombre',
       'Posesivos no- (mi), mo- (tu), i- (su) con tōka (nombre); pronombres newātl, tewātl, yewātl', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Agradecer y responder', null,
       'Dar las gracias, responder y decir sí o no',
       'Tlasojkāmati, miak tlasojkāmati, ajmo tlen; kēmaj / ajmo', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Cómo me siento', null,
       'Decir cómo te sientes y preguntar a otros',
       'Prefijos de sujeto: ni- (yo), ti- (tú), sin prefijo (él/ella): niyōlpāki, tiyōlpāki, yōlpāki', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Conversación básica', null,
       'Unir saludo, nombre, estado y despedida en una conversación',
       'Īwān (y), tlen (qué) y repaso de la unidad 1 a la 5', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1;

-- ─────────────────────────────────────────────
--  3.2 unidades — nivel 2: descríbete y describe a tu familia
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Pronombres personales', null,
       'Conocer los pronombres en singular y plural',
       'Newātl, tewātl, yewātl (singular) y tewān, amewān, yewān (plural)', 0, 'Completar Nivel 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'La familia', null,
       'Nombrar a los miembros de la familia',
       'Posesivo no- (mi) con nombres de parentesco: nonān, notaj, nokonēw; inin (este, esta)', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Cómo es mi familia', null,
       'Describir a la familia con adjetivos',
       'Adjetivo después del nombre: notaj chikāwak (mi papá es fuerte)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Hermanos y amigos', null,
       'Hablar de hermanos y amigos',
       'Noknīw (mi amigo), noāchkāw (mi hermano mayor), noikkāw (mi hermano menor)', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Los abuelos', null,
       'Hablar de los abuelos y de las personas mayores',
       'Nokōl (mi abuelo), nosij (mi abuela); wēwe, ilamatl, tlamatini', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Mi familia completa', null,
       'Describir tu familia con oraciones completas',
       'Nikpia (tengo) y los números sē (uno) y ōme (dos); plural posesivo -wān: nokonēwān', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2;

-- ─────────────────────────────────────────────
--  3.3 unidades — nivel 3: pide y da información
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Palabras para preguntar', null,
       'Conocer las palabras para hacer preguntas',
       'Tlen (qué), ākin (quién), kānin (dónde), kēmman (cuándo), tleīka (por qué), kēn (cómo)', 0, 'Completar Nivel 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Preguntas personales', null,
       'Preguntar y responder sobre uno mismo',
       'Ākin tewātl?, Kānin tichānej?, Tlen tikchīwa?: la pregunta va al inicio', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Preguntas sobre otros', null,
       'Preguntar por otras personas',
       'Sin prefijo para él o ella: tekiti (trabaja), momachtiā (estudia), chānej (vive)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Dónde está y qué necesito', null,
       'Preguntar por lugares y necesidades',
       'Nikan (aquí), ōmpa (allá); nikneki (quiero), moneki (se necesita)', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Respuestas completas', null,
       'Responder con oraciones completas',
       'Nikan ka (aquí está), nikneki ātl (quiero agua), ajmo nikmati (no sé)', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Cuántos', null,
       'Preguntar cantidades y contar del uno al cinco',
       'Kēski (cuántos) y los números sē, ōme, ēyi, nāwi, mākwīlli', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3;

-- ─────────────────────────────────────────────
--  3.4 unidades — nivel 4: habla en tiempos (ayer/hoy/mañana)
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Hoy, ayer y mañana', null,
       'Ubicar las acciones en el tiempo',
       'Āxkān (hoy, ahora), yālwa (ayer), mostla (mañana), wīptla (pasado mañana)', 0, 'Completar Nivel 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Pasado y futuro', null,
       'Conjugar en pasado y futuro',
       'Pasado con ō- al inicio: ōnitekit (trabajé); futuro con -s al final: nitekitis (trabajaré)', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Ver y verse', null,
       'Usar un verbo con objeto en distintos tiempos',
       'Nikitta (lo veo), ōnikittak (lo vi), nikittas (lo veré); nimitsitta (te veo)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Comer, beber e ir', null,
       'Hablar de actividades diarias en tres tiempos',
       'Nitlakwā (como), ōnitlakwaj (comí), nitlakwās (comeré); niyaw (voy), ōniya (fui)', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Cuándo y dónde', null,
       'Combinar tiempo y lugar en una oración',
       'Primero el tiempo, luego el verbo y al final el lugar: yālwa ōniya ōmpa', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Contar lo que pasó', null,
       'Contar una secuencia de acciones',
       'Achto (primero), sātepan (después), niman (luego)', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4;

-- ─────────────────────────────────────────────
--  3.5 unidades — nivel 5: describe un día normal
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Por la mañana', null,
       'Describir cómo empieza el día',
       'Verbos reflexivos con ni- + mo/no: nimāltiā (me baño); nimēwa (me levanto)', 0, 'Completar Nivel 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Dormir y comer', null,
       'Hablar de la comida y el descanso',
       'Nikkwā (lo como) lleva objeto: nikkwā tlaxkalli; nitlakwā (como) no lo lleva', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Con otras personas', null,
       'Decir qué haces con otras personas',
       'Plural nosotros: ti- ... -j: titlakwāj (comemos), titekitij (trabajamos); nowān (conmigo), mowān (contigo)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Mañana, tarde y noche', null,
       'Ubicar la rutina en las partes del día',
       'Teōtlak (tarde), yowalli (noche), tlayowa (anochece)', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Rutinas en plural', null,
       'Describir lo que hacen varias personas',
       'Plural ellos: sin prefijo y con -j al final: kochij (duermen), tlakwāj (comen)', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Mi día completo', null,
       'Describir un día de principio a fin',
       'Repaso de rutina, tiempo y orden: tlanēsi, nimēwa, achto, sātepan, niman', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5;

-- ─────────────────────────────────────────────
--  3.6 unidades — nivel 6: describe y expresa preferencias
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Lo que me gusta', null,
       'Decir qué te gusta y qué no',
       'Nēchpaktiā (me gusta, lit. me alegra), mitspaktiā (te gusta); ajmo nēchpaktiā (no me gusta)', 0, 'Completar Nivel 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Lo que quiero', null,
       'Expresar deseos y necesidades',
       'Nikneki + verbo en futuro: nikneki nitlakwās (quiero comer); kineki (él o ella quiere)', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Pedir y ordenar', null,
       'Pedir algo con respeto y dar indicaciones',
       'Imperativo con xi-: xitlakwā (come), xiwālla (ven); nimitstlatlawtiā (por favor, te lo pido)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Más y menos', null,
       'Comparar y valorar',
       'Ok achi (más), senka kwalli (muy bueno), ajmo kwalli (no es bueno)', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Mis gustos', null,
       'Hablar de tus gustos con comida y bebida',
       'Nēchpaktiā + nombre: nēchpaktiā ātl (me gusta el agua)', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Expresión completa', null,
       'Conversar sobre gustos, deseos y peticiones',
       'Repaso del nivel: preguntas con tlen, gustos con nēchpaktiā y deseos con nikneki', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6;

-- ─────────────────────────────────────────────
--  4. vocabulario
-- ─────────────────────────────────────────────
-- nivel 1 · unidad 1: saludos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kēn tinemi?', '¿cómo estás? (lit. ¿cómo vives?)', 'keen ti-ne-mi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kwalli ninemi', 'estoy bien (lit. vivo bien)', 'kwal-li ni-ne-mi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Īwān tewātl?', '¿y tú?', 'ii-waan te-waatl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ximopanōlti', 'pase / bienvenido(a)', 'shi-mo-pa-nool-ti', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kwalli', 'bien / bueno', 'kwal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kēn', 'cómo', 'keen', null from ct_languages where code = 'nhn';
-- nivel 1 · unidad 2: despedidas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Timoittaske', 'nos vemos', 'ti-mo-it-tas-ke', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Mostla', 'mañana', 'mos-tla', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Oksēppa', 'otra vez', 'ok-seep-pa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Timoittaske mostla', 'nos vemos mañana', 'ti-mo-it-tas-ke mos-tla', null from ct_languages where code = 'nhn';
-- nivel 1 · unidad 3: cómo te llamas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kēn motōka?', '¿cómo te llamas? (lit. ¿cómo es tu nombre?)', 'keen mo-too-ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Notōka', 'mi nombre / me llamo', 'no-too-ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Motōka', 'tu nombre', 'mo-too-ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ītōka', 'su nombre (de él o ella)', 'ii-too-ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Newātl', 'yo', 'ne-waatl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tewātl', 'tú', 'te-waatl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yewātl', 'él / ella', 'ye-waatl', null from ct_languages where code = 'nhn';
-- nivel 1 · unidad 4: agradecer y responder
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlasojkāmati', 'gracias', 'tla-so''-kaa-ma-ti', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Miak tlasojkāmati', 'muchas gracias', 'mi-ak tla-so''-kaa-ma-ti', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Miak', 'mucho', 'mi-ak', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ajmo tlen', 'de nada (lit. no es nada)', 'a''-mo tlen', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ajmo', 'no', 'a''-mo', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kēmaj', 'sí', 'kee-ma''', null from ct_languages where code = 'nhn';
-- nivel 1 · unidad 5: cómo me siento
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niyōlpāki', 'estoy contento(a)', 'ni-yool-paa-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tiyōlpāki', 'estás contento(a)', 'ti-yool-paa-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yōlpāki', 'está contento(a)', 'yool-paa-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nisiawi', 'estoy cansado(a)', 'ni-si-a-wi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tisiawi', 'estás cansado(a)', 'ti-si-a-wi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Siawi', 'está cansado(a)', 'si-a-wi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ninokokoa', 'estoy enfermo(a)', 'ni-no-ko-ko-a', null from ct_languages where code = 'nhn';
-- nivel 1 · unidad 6: conversación básica
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Īwān', 'y', 'ii-waan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlen', 'qué', 'tlen', null from ct_languages where code = 'nhn';
-- nivel 2 · unidad 1: pronombres personales
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tewān', 'nosotros', 'te-waan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Amewān', 'ustedes', 'a-me-waan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yewān', 'ellos / ellas', 'ye-waan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Newātl niyōlpāki', 'yo estoy contento(a)', 'ne-waatl ni-yool-paa-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tewātl tisiawi', 'tú estás cansado(a)', 'te-waatl ti-si-a-wi', null from ct_languages where code = 'nhn';
-- nivel 2 · unidad 2: la familia
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nonān', 'mi mamá', 'no-naan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Notaj', 'mi papá', 'no-ta''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nokonēw', 'mi hijo(a)', 'no-ko-neew', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nochān', 'mi casa', 'no-chaan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Inin', 'este / esta', 'i-nin', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Inin nonān', 'esta es mi mamá', 'i-nin no-naan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Inin notaj', 'este es mi papá', 'i-nin no-ta''', null from ct_languages where code = 'nhn';
-- nivel 2 · unidad 3: cómo es mi familia
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Chikāwak', 'fuerte', 'chi-kaa-wak', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Wēy', 'grande', 'weey', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tepitōn', 'pequeño(a)', 'te-pi-toon', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yankwik', 'nuevo(a)', 'yan-kwik', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Notaj chikāwak', 'mi papá es fuerte', 'no-ta'' chi-kaa-wak', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nonān kwalli', 'mi mamá es buena', 'no-naan kwal-li', null from ct_languages where code = 'nhn';
-- nivel 2 · unidad 4: hermanos y amigos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Noknīw', 'mi amigo(a)', 'nok-niiw', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Noāchkāw', 'mi hermano mayor', 'no-aach-kaaw', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Noikkāw', 'mi hermano menor', 'no-ik-kaaw', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Telpōchtli', 'muchacho / joven', 'tel-pooch-tli', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ichpōchtli', 'muchacha / joven', 'ich-pooch-tli', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Inin noknīw', 'este es mi amigo', 'i-nin nok-niiw', null from ct_languages where code = 'nhn';
-- nivel 2 · unidad 5: los abuelos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nokōl', 'mi abuelo', 'no-kool', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nosij', 'mi abuela', 'no-si''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Wēwe', 'anciano', 'wee-we', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ilamatl', 'anciana', 'i-la-matl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlamatini', 'sabio(a)', 'tla-ma-ti-ni', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nosij tlamatini', 'mi abuela es sabia', 'no-si'' tla-ma-ti-ni', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nokōl wēwe', 'mi abuelo es anciano', 'no-kool wee-we', null from ct_languages where code = 'nhn';
-- nivel 2 · unidad 6: mi familia completa
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikpia', 'tengo', 'nik-pi-a', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Sē', 'uno', 'see', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ōme', 'dos', 'oo-me', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nokonēwān', 'mis hijos', 'no-ko-nee-waan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikpia sē noknīw', 'tengo un amigo', 'nik-pi-a see nok-niiw', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikpia ōme nokonēwān', 'tengo dos hijos', 'nik-pi-a oo-me no-ko-nee-waan', null from ct_languages where code = 'nhn';
-- nivel 3 · unidad 1: palabras para preguntar
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ākin', 'quién', 'aa-kin', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kānin', 'dónde', 'kaa-nin', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kēmman', 'cuándo', 'keem-man', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tleīka', 'por qué', 'tle-ii-ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kēski', 'cuántos(as)', 'kees-ki', null from ct_languages where code = 'nhn';
-- nivel 3 · unidad 2: preguntas personales
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ākin tewātl?', '¿quién eres tú?', 'aa-kin te-waatl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kānin tichānej?', '¿dónde vives?', 'kaa-nin ti-chaa-ne''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nichānej Tlaxkallān', 'vivo en Tlaxcala', 'ni-chaa-ne'' tlash-kal-laan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlen tikchīwa?', '¿qué haces?', 'tlen tik-chii-wa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nitekiti', 'trabajo', 'ni-te-ki-ti', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nimomachtiā', 'estudio', 'ni-mo-mach-ti-aa', null from ct_languages where code = 'nhn';
-- nivel 3 · unidad 3: preguntas sobre otros
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ākin yewātl?', '¿quién es él / ella?', 'aa-kin ye-waatl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlen kichīwa?', '¿qué hace él / ella?', 'tlen ki-chii-wa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kānin chānej?', '¿dónde vive él / ella?', 'kaa-nin chaa-ne''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tekiti', 'trabaja', 'te-ki-ti', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Momachtiā', 'estudia', 'mo-mach-ti-aa', null from ct_languages where code = 'nhn';
-- nivel 3 · unidad 4: dónde está y qué necesito
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikan', 'aquí', 'ni-kan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ōmpa', 'allá', 'oom-pa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kānin ka?', '¿dónde está?', 'kaa-nin ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikneki', 'quiero / necesito', 'nik-ne-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Moneki', 'se necesita', 'mo-ne-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ātl', 'agua', 'aatl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlen tikneki?', '¿qué quieres?', 'tlen tik-ne-ki', null from ct_languages where code = 'nhn';
-- nivel 3 · unidad 5: respuestas completas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikan ka', 'aquí está', 'ni-kan ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ōmpa ka', 'allá está', 'oom-pa ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikneki ātl', 'quiero agua', 'nik-ne-ki aatl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ajmo nikneki', 'no quiero', 'a''-mo nik-ne-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikmati', 'sé / lo sé', 'nik-ma-ti', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ajmo nikmati', 'no sé', 'a''-mo nik-ma-ti', null from ct_languages where code = 'nhn';
-- nivel 3 · unidad 6: cuántos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ēyi', 'tres', 'ee-yi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nāwi', 'cuatro', 'naa-wi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Mākwīlli', 'cinco', 'maa-kwiil-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kēski tikneki?', '¿cuántos quieres?', 'kees-ki tik-ne-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikneki ōme', 'quiero dos', 'nik-ne-ki oo-me', null from ct_languages where code = 'nhn';
-- nivel 4 · unidad 1: hoy, ayer y mañana
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Āxkān', 'hoy / ahora', 'aash-kaan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yālwa', 'ayer', 'yaal-wa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Wīptla', 'pasado mañana', 'wiip-tla', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tōnalli', 'día / sol', 'too-nal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yowalli', 'noche', 'yo-wal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Āxkān nitekiti', 'hoy trabajo', 'aash-kaan ni-te-ki-ti', null from ct_languages where code = 'nhn';
-- nivel 4 · unidad 2: pasado y futuro
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ōnitekit', 'trabajé', 'oo-ni-te-kit', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nitekitis', 'trabajaré', 'ni-te-ki-tis', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ōtitekit', 'trabajaste', 'oo-ti-te-kit', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Titekitis', 'trabajarás', 'ti-te-ki-tis', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ōnikochik', 'dormí', 'oo-ni-ko-chik', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikochis', 'dormiré', 'ni-ko-chis', null from ct_languages where code = 'nhn';
-- nivel 4 · unidad 3: ver y verse
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikitta', 'lo / la veo', 'ni-kit-ta', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ōnikittak', 'lo / la vi', 'oo-ni-kit-tak', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikittas', 'lo / la veré', 'ni-kit-tas', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nimitsitta', 'te veo', 'ni-mi-tsit-ta', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ōnimitsittak', 'te vi', 'oo-ni-mi-tsit-tak', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yālwa ōnimitsittak', 'ayer te vi', 'yaal-wa oo-ni-mi-tsit-tak', null from ct_languages where code = 'nhn';
-- nivel 4 · unidad 4: comer, beber e ir
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nitlakwā', 'como', 'ni-tla-kwaa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ōnitlakwaj', 'comí', 'oo-ni-tla-kwa''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nitlakwās', 'comeré', 'ni-tla-kwaas', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niātli', 'bebo', 'ni-aa-tli', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niyaw', 'voy', 'ni-yaw', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ōniya', 'fui', 'oo-ni-ya', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niyas', 'iré', 'ni-yas', null from ct_languages where code = 'nhn';
-- nivel 4 · unidad 5: cuándo y dónde
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yālwa ōniya ōmpa', 'ayer fui allá', 'yaal-wa oo-ni-ya oom-pa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Mostla niyas', 'mañana iré', 'mos-tla ni-yas', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Āxkān nikan nikaj', 'hoy estoy aquí', 'aash-kaan ni-kan ni-ka''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikaj', 'estoy', 'ni-ka''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tikaj', 'estás', 'ti-ka''', null from ct_languages where code = 'nhn';
-- nivel 4 · unidad 6: contar lo que pasó
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Achto', 'primero', 'ach-to', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Sātepan', 'después', 'saa-te-pan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niman', 'luego / enseguida', 'ni-man', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Achto nitlakwā', 'primero como', 'ach-to ni-tla-kwaa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Sātepan nitekiti', 'después trabajo', 'saa-te-pan ni-te-ki-ti', null from ct_languages where code = 'nhn';
-- nivel 5 · unidad 1: por la mañana
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nimēwa', 'me levanto', 'ni-mee-wa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nimāltiā', 'me baño', 'ni-maal-ti-aa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikīsa', 'salgo', 'ni-kii-sa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niwāllaw', 'vengo', 'ni-waal-law', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kwalkān', 'temprano', 'kwal-kaan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlanēsi', 'amanece', 'tla-nee-si', null from ct_languages where code = 'nhn';
-- nivel 5 · unidad 2: dormir y comer
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikochi', 'duermo', 'ni-ko-chi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlaxkalli', 'tortilla', 'tlash-kal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Etl', 'frijol', 'etl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Chīlli', 'chile', 'chiil-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikkwā tlaxkalli', 'como tortilla', 'nik-kwaa tlash-kal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikkwā etl', 'como frijol', 'nik-kwaa etl', null from ct_languages where code = 'nhn';
-- nivel 5 · unidad 3: con otras personas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Titlakwāj', 'comemos', 'ti-tla-kwaa''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Titekitij', 'trabajamos', 'ti-te-ki-ti''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nowān', 'conmigo', 'no-waan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Mowān', 'contigo', 'mo-waan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nitlakwā mowān', 'como contigo', 'ni-tla-kwaa mo-waan', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nonān īwān newātl titlakwāj', 'mi mamá y yo comemos', 'no-naan ii-waan ne-waatl ti-tla-kwaa''', null from ct_languages where code = 'nhn';
-- nivel 5 · unidad 4: mañana, tarde y noche
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Teōtlak', 'tarde', 'te-oo-tlak', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlayowa', 'anochece', 'tla-yo-wa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Teōtlak nitekiti', 'en la tarde trabajo', 'te-oo-tlak ni-te-ki-ti', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yowalli nikochi', 'en la noche duermo', 'yo-wal-li ni-ko-chi', null from ct_languages where code = 'nhn';
-- nivel 5 · unidad 5: rutinas en plural
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tikochij', 'dormimos', 'ti-ko-chi''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kochij', 'duermen', 'ko-chi''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlakwāj', 'comen', 'tla-kwaa''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tekitij', 'trabajan', 'te-ki-ti''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tewān tikochij', 'nosotros dormimos', 'te-waan ti-ko-chi''', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yewān tlakwāj', 'ellos comen', 'ye-waan tla-kwaa''', null from ct_languages where code = 'nhn';
-- nivel 5 · unidad 6: mi día completo
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlanēsi nimēwa', 'amanece y me levanto', 'tla-nee-si ni-mee-wa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Niman nikīsa', 'luego salgo', 'ni-man ni-kii-sa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kwalkān nimāltiā', 'temprano me baño', 'kwal-kaan ni-maal-ti-aa', null from ct_languages where code = 'nhn';
-- nivel 6 · unidad 1: lo que me gusta
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nēchpaktiā', 'me gusta', 'neech-pak-ti-aa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ajmo nēchpaktiā', 'no me gusta', 'a''-mo neech-pak-ti-aa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Mitspaktiā?', '¿te gusta?', 'mits-pak-ti-aa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Senka', 'mucho / muy', 'sen-ka', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Achi', 'un poco', 'a-chi', null from ct_languages where code = 'nhn';
-- nivel 6 · unidad 2: lo que quiero
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tikneki', 'quieres', 'tik-ne-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kineki', 'quiere', 'ki-ne-ki', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikneki nitlakwās', 'quiero comer', 'nik-ne-ki ni-tla-kwaas', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nikneki nikochis', 'quiero dormir', 'nik-ne-ki ni-ko-chis', null from ct_languages where code = 'nhn';
-- nivel 6 · unidad 3: pedir y ordenar
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Xitlakwā', 'come (tú)', 'shi-tla-kwaa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Xikochi', 'duerme (tú)', 'shi-ko-chi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Xiwālla', 'ven (tú)', 'shi-waal-la', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ximotlāli', 'siéntate', 'shi-mo-tlaa-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nimitstlatlawtiā', 'por favor (lit. te lo pido)', 'ni-mits-tla-tlaw-ti-aa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nimitstlatlawtiā, xiwālla', 'por favor, ven', 'ni-mits-tla-tlaw-ti-aa shi-waal-la', null from ct_languages where code = 'nhn';
-- nivel 6 · unidad 4: más y menos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ok achi', 'más', 'ok a-chi', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ok achi kwalli', 'mejor', 'ok a-chi kwal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Senka kwalli', 'muy bueno', 'sen-ka kwal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ajmo kwalli', 'no es bueno', 'a''-mo kwal-li', null from ct_languages where code = 'nhn';
-- nivel 6 · unidad 5: mis gustos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nēchpaktiā ātl', 'me gusta el agua', 'neech-pak-ti-aa aatl', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nēchpaktiā tlaxkalli', 'me gusta la tortilla', 'neech-pak-ti-aa tlash-kal-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ajmo nēchpaktiā chīlli', 'no me gusta el chile', 'a''-mo neech-pak-ti-aa chiil-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Mitspaktiā etl?', '¿te gusta el frijol?', 'mits-pak-ti-aa etl', null from ct_languages where code = 'nhn';
-- nivel 6 · unidad 6: expresión completa
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tlen mitspaktiā?', '¿qué te gusta?', 'tlen mits-pak-ti-aa', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nāwatlajtōlli', 'idioma náhuatl', 'naa-wa-tla''-tool-li', null from ct_languages where code = 'nhn';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nēchpaktiā nāwatlajtōlli', 'me gusta el náhuatl', 'neech-pak-ti-aa naa-wa-tla''-tool-li', null from ct_languages where code = 'nhn';

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
and v.word in ('Kēn tinemi?', 'Kwalli ninemi', 'Īwān tewātl?', 'Ximopanōlti', 'Kwalli', 'Kēn');

-- nivel 1 · unidad 2: despedidas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 2
and v.word in ('Timoittaske', 'Mostla', 'Oksēppa', 'Timoittaske mostla', 'Kwalli');

-- nivel 1 · unidad 3: cómo te llamas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 3
and v.word in ('Kēn motōka?', 'Notōka', 'Motōka', 'Ītōka', 'Newātl', 'Tewātl', 'Yewātl');

-- nivel 1 · unidad 4: agradecer y responder
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 4
and v.word in ('Tlasojkāmati', 'Miak tlasojkāmati', 'Miak', 'Ajmo tlen', 'Ajmo', 'Kēmaj');

-- nivel 1 · unidad 5: cómo me siento
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 5
and v.word in ('Niyōlpāki', 'Tiyōlpāki', 'Yōlpāki', 'Nisiawi', 'Tisiawi', 'Siawi', 'Ninokokoa', 'Kēn tinemi?');

-- nivel 1 · unidad 6: conversación básica
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 6
and v.word in ('Īwān', 'Tlen', 'Kēn tinemi?', 'Kwalli ninemi', 'Īwān tewātl?', 'Kēn motōka?', 'Notōka', 'Tlasojkāmati', 'Timoittaske', 'Niyōlpāki');

-- nivel 2 · unidad 1: pronombres personales
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 1
and v.word in ('Tewān', 'Amewān', 'Yewān', 'Newātl niyōlpāki', 'Tewātl tisiawi', 'Newātl', 'Tewātl', 'Yewātl');

-- nivel 2 · unidad 2: la familia
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 2
and v.word in ('Nonān', 'Notaj', 'Nokonēw', 'Nochān', 'Inin', 'Inin nonān', 'Inin notaj');

-- nivel 2 · unidad 3: cómo es mi familia
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 3
and v.word in ('Chikāwak', 'Wēy', 'Tepitōn', 'Yankwik', 'Notaj chikāwak', 'Nonān kwalli', 'Kwalli', 'Nonān', 'Notaj');

-- nivel 2 · unidad 4: hermanos y amigos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 4
and v.word in ('Noknīw', 'Noāchkāw', 'Noikkāw', 'Telpōchtli', 'Ichpōchtli', 'Inin noknīw', 'Inin');

-- nivel 2 · unidad 5: los abuelos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 5
and v.word in ('Nokōl', 'Nosij', 'Wēwe', 'Ilamatl', 'Tlamatini', 'Nosij tlamatini', 'Nokōl wēwe');

-- nivel 2 · unidad 6: mi familia completa
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 6
and v.word in ('Nikpia', 'Sē', 'Ōme', 'Nokonēwān', 'Nikpia sē noknīw', 'Nikpia ōme nokonēwān', 'Nonān', 'Notaj', 'Īwān');

-- nivel 3 · unidad 1: palabras para preguntar
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 1
and v.word in ('Ākin', 'Kānin', 'Kēmman', 'Tleīka', 'Kēski', 'Tlen', 'Kēn');

-- nivel 3 · unidad 2: preguntas personales
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 2
and v.word in ('Ākin tewātl?', 'Kānin tichānej?', 'Nichānej Tlaxkallān', 'Tlen tikchīwa?', 'Nitekiti', 'Nimomachtiā');

-- nivel 3 · unidad 3: preguntas sobre otros
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 3
and v.word in ('Ākin yewātl?', 'Tlen kichīwa?', 'Kānin chānej?', 'Tekiti', 'Momachtiā', 'Yewātl');

-- nivel 3 · unidad 4: dónde está y qué necesito
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 4
and v.word in ('Nikan', 'Ōmpa', 'Kānin ka?', 'Nikneki', 'Moneki', 'Ātl', 'Tlen tikneki?');

-- nivel 3 · unidad 5: respuestas completas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 5
and v.word in ('Nikan ka', 'Ōmpa ka', 'Nikneki ātl', 'Ajmo nikneki', 'Nikmati', 'Ajmo nikmati', 'Ajmo');

-- nivel 3 · unidad 6: cuántos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 6
and v.word in ('Ēyi', 'Nāwi', 'Mākwīlli', 'Kēski tikneki?', 'Nikneki ōme', 'Kēski', 'Sē', 'Ōme');

-- nivel 4 · unidad 1: hoy, ayer y mañana
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 1
and v.word in ('Āxkān', 'Yālwa', 'Wīptla', 'Tōnalli', 'Yowalli', 'Āxkān nitekiti', 'Mostla');

-- nivel 4 · unidad 2: pasado y futuro
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 2
and v.word in ('Ōnitekit', 'Nitekitis', 'Ōtitekit', 'Titekitis', 'Ōnikochik', 'Nikochis', 'Nitekiti');

-- nivel 4 · unidad 3: ver y verse
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 3
and v.word in ('Nikitta', 'Ōnikittak', 'Nikittas', 'Nimitsitta', 'Ōnimitsittak', 'Yālwa ōnimitsittak', 'Yālwa');

-- nivel 4 · unidad 4: comer, beber e ir
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 4
and v.word in ('Nitlakwā', 'Ōnitlakwaj', 'Nitlakwās', 'Niātli', 'Niyaw', 'Ōniya', 'Niyas');

-- nivel 4 · unidad 5: cuándo y dónde
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 5
and v.word in ('Yālwa ōniya ōmpa', 'Mostla niyas', 'Āxkān nikan nikaj', 'Nikaj', 'Tikaj', 'Ōmpa', 'Nikan', 'Āxkān');

-- nivel 4 · unidad 6: contar lo que pasó
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 6
and v.word in ('Achto', 'Sātepan', 'Niman', 'Achto nitlakwā', 'Sātepan nitekiti', 'Nitlakwā', 'Nitekiti');

-- nivel 5 · unidad 1: por la mañana
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 1
and v.word in ('Nimēwa', 'Nimāltiā', 'Nikīsa', 'Niwāllaw', 'Kwalkān', 'Tlanēsi');

-- nivel 5 · unidad 2: dormir y comer
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 2
and v.word in ('Nikochi', 'Tlaxkalli', 'Etl', 'Chīlli', 'Nikkwā tlaxkalli', 'Nikkwā etl', 'Nitlakwā');

-- nivel 5 · unidad 3: con otras personas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 3
and v.word in ('Titlakwāj', 'Titekitij', 'Nowān', 'Mowān', 'Nitlakwā mowān', 'Nonān īwān newātl titlakwāj', 'Nonān');

-- nivel 5 · unidad 4: mañana, tarde y noche
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 4
and v.word in ('Teōtlak', 'Tlayowa', 'Teōtlak nitekiti', 'Yowalli nikochi', 'Tlanēsi', 'Yowalli', 'Nikochi');

-- nivel 5 · unidad 5: rutinas en plural
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 5
and v.word in ('Tikochij', 'Kochij', 'Tlakwāj', 'Tekitij', 'Tewān tikochij', 'Yewān tlakwāj', 'Tewān', 'Yewān');

-- nivel 5 · unidad 6: mi día completo
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 6
and v.word in ('Tlanēsi nimēwa', 'Niman nikīsa', 'Kwalkān nimāltiā', 'Achto', 'Sātepan', 'Niman', 'Teōtlak nitekiti', 'Yowalli nikochi');

-- nivel 6 · unidad 1: lo que me gusta
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 1
and v.word in ('Nēchpaktiā', 'Ajmo nēchpaktiā', 'Mitspaktiā?', 'Senka', 'Achi');

-- nivel 6 · unidad 2: lo que quiero
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 2
and v.word in ('Tikneki', 'Kineki', 'Nikneki nitlakwās', 'Nikneki nikochis', 'Nikneki', 'Ajmo nikneki');

-- nivel 6 · unidad 3: pedir y ordenar
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 3
and v.word in ('Xitlakwā', 'Xikochi', 'Xiwālla', 'Ximotlāli', 'Nimitstlatlawtiā', 'Nimitstlatlawtiā, xiwālla');

-- nivel 6 · unidad 4: más y menos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 4
and v.word in ('Ok achi', 'Ok achi kwalli', 'Senka kwalli', 'Ajmo kwalli', 'Achi', 'Senka', 'Kwalli');

-- nivel 6 · unidad 5: mis gustos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 5
and v.word in ('Nēchpaktiā ātl', 'Nēchpaktiā tlaxkalli', 'Ajmo nēchpaktiā chīlli', 'Mitspaktiā etl?', 'Ātl', 'Tlaxkalli', 'Chīlli', 'Etl');

-- nivel 6 · unidad 6: expresión completa
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 6
and v.word in ('Tlen mitspaktiā?', 'Nāwatlajtōlli', 'Nēchpaktiā nāwatlajtōlli', 'Nēchpaktiā', 'Nikneki', 'Tlen tikneki?');

-- ─────────────────────────────────────────────
--  6. ejercicios (6 por unidad: 4 opción múltiple + 2 completar)
-- ─────────────────────────────────────────────
-- nivel 1 · unidad 1: saludos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cómo estás?',
       '["Kēn tinemi?"]',
       '["Kēn tinemi?", "Kēn motōka?", "Ximopanōlti", "Timoittaske"]',
       'citlali',
       'Kēn tinemi? pregunta cómo está alguien; literalmente es ¿cómo vives?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estoy bien',
       '["Kwalli ninemi"]',
       '["Kwalli ninemi", "Īwān tewātl?", "Kēn tinemi?", "Notōka"]',
       'coltzin',
       'Kwalli ninemi responde a Kēn tinemi?: kwalli (bien) + ninemi (yo vivo)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Y tú?',
       '["Īwān tewātl?"]',
       '["Īwān tewātl?", "Kwalli ninemi", "Tlasojkāmati", "Ximopanōlti"]',
       'neza',
       'Īwān (y) + tewātl (tú) devuelve la pregunta',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pase / bienvenido',
       '["Ximopanōlti"]',
       '["Ximopanōlti", "Timoittaske", "Kēn tinemi?", "Kwalli"]',
       'tonatiuh',
       'Ximopanōlti es una invitación respetuosa a pasar',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kēn ______?',
       '["tinemi", "Kēn tinemi?", "Kēn tinemi"]',
       null,
       'xochitl',
       'Ti- marca la segunda persona: tinemi = tú vives',
       20, 'medium',
       '¿Cómo estás?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kwalli ______',
       '["ninemi", "Kwalli ninemi"]',
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
       '["Timoittaske"]',
       '["Timoittaske", "Ximopanōlti", "Mostla", "Oksēppa"]',
       'coltzin',
       'Timoittaske significa nos veremos o nos vemos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mañana',
       '["Mostla"]',
       '["Mostla", "Oksēppa", "Kwalli", "Kēn"]',
       'neza',
       'Mostla significa mañana (el día siguiente)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Otra vez',
       '["Oksēppa"]',
       '["Oksēppa", "Mostla", "Miak", "Kēn"]',
       'tonatiuh',
       'Oksēppa significa otra vez, de nuevo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nos vemos mañana',
       '["Timoittaske mostla"]',
       '["Timoittaske mostla", "Kēn tinemi?", "Kwalli ninemi", "Miak tlasojkāmati"]',
       'xochitl',
       'Timoittaske (nos vemos) + mostla (mañana)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Timoittaske ______',
       '["mostla", "Timoittaske mostla"]',
       null,
       'citlali',
       'Mostla va después del verbo: timoittaske mostla',
       20, 'medium',
       'Nos vemos mañana'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ mostla',
       '["Timoittaske", "Timoittaske mostla"]',
       null,
       'coltzin',
       'Timoittaske es la despedida para quedar de verse',
       20, 'medium',
       'Nos vemos mañana'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 2;

-- nivel 1 · unidad 3: cómo te llamas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cómo te llamas?',
       '["Kēn motōka?"]',
       '["Kēn motōka?", "Kēn tinemi?", "Īwān tewātl?", "Notōka"]',
       'neza',
       'Kēn motōka? pregunta literalmente ¿cómo es tu nombre?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi nombre / me llamo',
       '["Notōka"]',
       '["Notōka", "Motōka", "Ītōka", "Newātl"]',
       'tonatiuh',
       'No- significa mi: notōka = mi nombre',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tu nombre',
       '["Motōka"]',
       '["Motōka", "Notōka", "Ītōka", "Tewātl"]',
       'xochitl',
       'Mo- significa tu: motōka = tu nombre',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Yo',
       '["Newātl"]',
       '["Newātl", "Tewātl", "Yewātl", "Notōka"]',
       'citlali',
       'Newātl es el pronombre yo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ Xochitl',
       '["Notōka", "Notōka Xochitl"]',
       null,
       'coltzin',
       'Para decir tu nombre: notōka + nombre',
       20, 'medium',
       'Me llamo Xochitl'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kēn ______?',
       '["motōka", "Kēn motōka?", "Kēn motōka"]',
       null,
       'neza',
       'Mo- (tu) + tōka (nombre): motōka',
       20, 'medium',
       '¿Cómo te llamas?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 3;

-- nivel 1 · unidad 4: agradecer y responder
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Gracias',
       '["Tlasojkāmati"]',
       '["Tlasojkāmati", "Timoittaske", "Ximopanōlti", "Ajmo tlen"]',
       'tonatiuh',
       'Tlasojkāmati es la forma de dar las gracias',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muchas gracias',
       '["Miak tlasojkāmati"]',
       '["Miak tlasojkāmati", "Ajmo tlen", "Kwalli ninemi", "Tlasojkāmati"]',
       'xochitl',
       'Miak (mucho) + tlasojkāmati (gracias)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'De nada',
       '["Ajmo tlen"]',
       '["Ajmo tlen", "Kēmaj", "Miak", "Tlasojkāmati"]',
       'citlali',
       'Ajmo tlen responde a las gracias; literalmente no es nada',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Sí',
       '["Kēmaj"]',
       '["Kēmaj", "Ajmo", "Kwalli", "Miak"]',
       'coltzin',
       'Kēmaj significa sí; la h final es un saltillo (corte de voz)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ tlasojkāmati',
       '["Miak", "Miak tlasojkāmati"]',
       null,
       'neza',
       'Miak (mucho) va antes de tlasojkāmati',
       20, 'medium',
       'Muchas gracias'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ajmo ______',
       '["tlen", "Ajmo tlen"]',
       null,
       'tonatiuh',
       'Ajmo (no) + tlen (qué, nada): ajmo tlen',
       20, 'medium',
       'De nada'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 4;

-- nivel 1 · unidad 5: cómo me siento
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estoy contento',
       '["Niyōlpāki"]',
       '["Niyōlpāki", "Tiyōlpāki", "Yōlpāki", "Nisiawi"]',
       'xochitl',
       'Ni- (yo) + yōlpāki (estar contento)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estás contento',
       '["Tiyōlpāki"]',
       '["Tiyōlpāki", "Niyōlpāki", "Yōlpāki", "Tisiawi"]',
       'citlali',
       'Ti- (tú) + yōlpāki',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Está cansado (él o ella)',
       '["Siawi"]',
       '["Siawi", "Nisiawi", "Tisiawi", "Yōlpāki"]',
       'coltzin',
       'Sin prefijo el verbo habla de él o ella: siawi',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estoy enfermo',
       '["Ninokokoa"]',
       '["Ninokokoa", "Nisiawi", "Niyōlpāki", "Kwalli ninemi"]',
       'neza',
       'Ninokokoa significa estoy enfermo o me siento mal',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______siawi',
       '["Ni", "Nisiawi"]',
       null,
       'tonatiuh',
       'Agrega ni- para hablar de ti mismo: nisiawi',
       20, 'medium',
       'Estoy cansado'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______yōlpāki',
       '["Ti", "Tiyōlpāki"]',
       null,
       'xochitl',
       'Agrega ti- para hablar de la otra persona: tiyōlpāki',
       20, 'medium',
       'Estás contento'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 5;

-- nivel 1 · unidad 6: conversación básica
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Y',
       '["Īwān"]',
       '["Īwān", "Tlen", "Kēn", "Ajmo"]',
       'citlali',
       'Īwān une palabras e ideas: y',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Qué',
       '["Tlen"]',
       '["Tlen", "Kēn", "Īwān", "Miak"]',
       'coltzin',
       'Tlen pregunta qué',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cómo estás? Estoy bien, ¿y tú?',
       '["Kēn tinemi? Kwalli ninemi, īwān tewātl?"]',
       '["Kēn tinemi? Kwalli ninemi, īwān tewātl?", "Kēn motōka? Notōka, īwān tewātl?", "Tlasojkāmati, ajmo tlen", "Timoittaske mostla"]',
       'neza',
       'Saludo completo: pregunta, respuesta y devolver la pregunta',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me llamo Citlali, estoy contenta',
       '["Notōka Citlali, niyōlpāki"]',
       '["Notōka Citlali, niyōlpāki", "Motōka Citlali, tiyōlpāki", "Ītōka Citlali, yōlpāki", "Notōka Citlali, nisiawi"]',
       'tonatiuh',
       'Notōka (me llamo) + niyōlpāki (estoy contenta)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tlasojkāmati, ______ mostla',
       '["timoittaske", "Tlasojkāmati, timoittaske mostla"]',
       null,
       'xochitl',
       'Despedida completa: tlasojkāmati, timoittaske mostla',
       20, 'medium',
       'Gracias, nos vemos mañana'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kēn ______? Kwalli ninemi',
       '["tinemi", "Kēn tinemi? Kwalli ninemi"]',
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
       '["Tewān"]',
       '["Newātl", "Yewān", "Yewātl", "Tewān"]',
       'coltzin',
       'Tewān significa nosotros',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ustedes',
       '["Amewān"]',
       '["Nokonēw", "Notaj", "Amewān", "Yewātl"]',
       'neza',
       'Amewān significa ustedes',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ellos',
       '["Yewān"]',
       '["Tewān", "Newātl", "Amewān", "Yewān"]',
       'tonatiuh',
       'Yewān significa ellos / ellas',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Yo estoy contento(a)',
       '["Newātl niyōlpāki"]',
       '["Newātl niyōlpāki", "Inin noknīw", "Inin notaj", "Nokōl wēwe"]',
       'xochitl',
       'Newātl niyōlpāki significa yo estoy contento(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ niyōlpāki',
       '["Newātl", "Newātl niyōlpāki"]',
       null,
       'citlali',
       'Newātl niyōlpāki significa yo estoy contento(a)',
       20, 'medium',
       'Yo estoy contento(a)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tewātl ______',
       '["tisiawi", "Tewātl tisiawi"]',
       null,
       'coltzin',
       'Tewātl tisiawi significa tú estás cansado(a)',
       20, 'medium',
       'Tú estás cansado(a)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 1;

-- nivel 2 · unidad 2: la familia
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi mamá',
       '["Nonān"]',
       '["Inin", "Amewān", "Nochān", "Nonān"]',
       'neza',
       'Nonān significa mi mamá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi papá',
       '["Notaj"]',
       '["Notaj", "Yewān", "Nokonēw", "Tewān"]',
       'tonatiuh',
       'Notaj significa mi papá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi hijo(a)',
       '["Nokonēw"]',
       '["Yewān", "Nochān", "Nokonēw", "Amewān"]',
       'xochitl',
       'Nokonēw significa mi hijo(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi casa',
       '["Nochān"]',
       '["Yewān", "Inin", "Amewān", "Nochān"]',
       'citlali',
       'Nochān significa mi casa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nonān',
       '["Inin", "Inin nonān"]',
       null,
       'coltzin',
       'Inin nonān significa esta es mi mamá',
       20, 'medium',
       'Esta es mi mamá'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Inin ______',
       '["notaj", "Inin notaj"]',
       null,
       'neza',
       'Inin notaj significa este es mi papá',
       20, 'medium',
       'Este es mi papá'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 2;

-- nivel 2 · unidad 3: cómo es mi familia
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Fuerte',
       '["Chikāwak"]',
       '["Chikāwak", "Kwalli", "Tepitōn", "Nonān"]',
       'tonatiuh',
       'Chikāwak significa fuerte',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Grande',
       '["Wēy"]',
       '["Tewān", "Kwalli", "Nonān", "Wēy"]',
       'xochitl',
       'Wēy significa grande',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pequeño(a)',
       '["Tepitōn"]',
       '["Chikāwak", "Yankwik", "Tewān", "Tepitōn"]',
       'citlali',
       'Tepitōn significa pequeño(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nuevo(a)',
       '["Yankwik"]',
       '["Wēy", "Kwalli", "Yankwik", "Amewān"]',
       'coltzin',
       'Yankwik significa nuevo(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ chikāwak',
       '["Notaj", "Notaj chikāwak"]',
       null,
       'neza',
       'Notaj chikāwak significa mi papá es fuerte',
       20, 'medium',
       'Mi papá es fuerte'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nonān ______',
       '["kwalli", "Nonān kwalli"]',
       null,
       'tonatiuh',
       'Nonān kwalli significa mi mamá es buena',
       20, 'medium',
       'Mi mamá es buena'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 3;

-- nivel 2 · unidad 4: hermanos y amigos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi amigo(a)',
       '["Noknīw"]',
       '["Noknīw", "Yewān", "Inin", "Tewān"]',
       'xochitl',
       'Noknīw significa mi amigo(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi hermano mayor',
       '["Noāchkāw"]',
       '["Noāchkāw", "Yewān", "Inin", "Tewān"]',
       'citlali',
       'Noāchkāw significa mi hermano mayor',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi hermano menor',
       '["Noikkāw"]',
       '["Ichpōchtli", "Telpōchtli", "Amewān", "Noikkāw"]',
       'coltzin',
       'Noikkāw significa mi hermano menor',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muchacho',
       '["Telpōchtli"]',
       '["Amewān", "Telpōchtli", "Yewān", "Inin"]',
       'neza',
       'Telpōchtli significa muchacho / joven',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ noknīw',
       '["Inin", "Inin noknīw"]',
       null,
       'tonatiuh',
       'Inin noknīw significa este es mi amigo',
       20, 'medium',
       'Este es mi amigo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______knīw',
       '["No", "Noknīw"]',
       null,
       'xochitl',
       'Noknīw significa mi amigo(a)',
       20, 'medium',
       'Mi amigo(a)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 4;

-- nivel 2 · unidad 5: los abuelos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi abuelo',
       '["Nokōl"]',
       '["Nokōl", "Tewān", "Amewān", "Tlamatini"]',
       'citlali',
       'Nokōl significa mi abuelo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi abuela',
       '["Nosij"]',
       '["Amewān", "Tewān", "Yewān", "Nosij"]',
       'coltzin',
       'Nosij significa mi abuela',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Anciano',
       '["Wēwe"]',
       '["Wēwe", "Nonān", "Yewān", "Nokōl"]',
       'neza',
       'Wēwe significa anciano',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Anciana',
       '["Ilamatl"]',
       '["Nosij", "Nonān", "Ilamatl", "Tlamatini"]',
       'tonatiuh',
       'Ilamatl significa anciana',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ tlamatini',
       '["Nosij", "Nosij tlamatini"]',
       null,
       'xochitl',
       'Nosij tlamatini significa mi abuela es sabia',
       20, 'medium',
       'Mi abuela es sabia'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nokōl ______',
       '["wēwe", "Nokōl wēwe"]',
       null,
       'citlali',
       'Nokōl wēwe significa mi abuelo es anciano',
       20, 'medium',
       'Mi abuelo es anciano'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 5;

-- nivel 2 · unidad 6: mi familia completa
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tengo',
       '["Nikpia"]',
       '["Nikpia", "Sē", "Nokonēwān", "Amewān"]',
       'coltzin',
       'Nikpia significa tengo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Uno',
       '["Sē"]',
       '["Nonān", "Nokonēwān", "Nikpia", "Sē"]',
       'neza',
       'Sē significa uno',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dos',
       '["Ōme"]',
       '["Amewān", "Notaj", "Ōme", "Sē"]',
       'tonatiuh',
       'Ōme significa dos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mis hijos',
       '["Nokonēwān"]',
       '["Notaj", "Tewān", "Nokonēwān", "Īwān"]',
       'xochitl',
       'Nokonēwān significa mis hijos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ sē noknīw',
       '["Nikpia", "Nikpia sē noknīw"]',
       null,
       'citlali',
       'Nikpia sē noknīw significa tengo un amigo',
       20, 'medium',
       'Tengo un amigo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nikpia ōme ______',
       '["nokonēwān", "Nikpia ōme nokonēwān"]',
       null,
       'coltzin',
       'Nikpia ōme nokonēwān significa tengo dos hijos',
       20, 'medium',
       'Tengo dos hijos'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 2 and u.unit_num = 6;

-- nivel 3 · unidad 1: palabras para preguntar
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quién',
       '["Ākin"]',
       '["Kēn", "Ākin", "Nimomachtiā", "Tlen"]',
       'neza',
       'Ākin significa quién',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dónde',
       '["Kānin"]',
       '["Kānin", "Tlen", "Nimomachtiā", "Kēski"]',
       'tonatiuh',
       'Kānin significa dónde',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cuándo',
       '["Kēmman"]',
       '["Kēski", "Kēn", "Kēmman", "Kānin"]',
       'xochitl',
       'Kēmman significa cuándo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Por qué',
       '["Tleīka"]',
       '["Kēski", "Tleīka", "Kānin", "Nitekiti"]',
       'citlali',
       'Tleīka significa por qué',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______kin',
       '["Ā", "Ākin"]',
       null,
       'coltzin',
       'Ākin significa quién',
       20, 'medium',
       'Quién'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ānin',
       '["K", "Kānin"]',
       null,
       'neza',
       'Kānin significa dónde',
       20, 'medium',
       'Dónde'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 1;

-- nivel 3 · unidad 2: preguntas personales
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajo',
       '["Nitekiti"]',
       '["Nimomachtiā", "Kēmman", "Ākin", "Nitekiti"]',
       'tonatiuh',
       'Nitekiti significa trabajo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estudio',
       '["Nimomachtiā"]',
       '["Nimomachtiā", "Momachtiā", "Nitekiti", "Tleīka"]',
       'xochitl',
       'Nimomachtiā significa estudio',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Quién eres tú?',
       '["Ākin tewātl?"]',
       '["Tlen tikchīwa?", "Ākin tewātl?", "Tlen tikneki?", "Kānin tichānej?"]',
       'citlali',
       'Ākin tewātl? significa ¿quién eres tú?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Dónde vives?',
       '["Kānin tichānej?"]',
       '["Kānin tichānej?", "Tlen kichīwa?", "Kānin ka?", "Tlen tikchīwa?"]',
       'coltzin',
       'Kānin tichānej? significa ¿dónde vives?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ tewātl?',
       '["Ākin", "Ākin tewātl?"]',
       null,
       'neza',
       'Ākin tewātl? significa ¿quién eres tú?',
       20, 'medium',
       '¿Quién eres tú?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kānin ______?',
       '["tichānej", "Kānin tichānej?"]',
       null,
       'tonatiuh',
       'Kānin tichānej? significa ¿dónde vives?',
       20, 'medium',
       '¿Dónde vives?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 2;

-- nivel 3 · unidad 3: preguntas sobre otros
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabaja',
       '["Tekiti"]',
       '["Yewātl", "Nitekiti", "Kēmman", "Tekiti"]',
       'xochitl',
       'Tekiti significa trabaja',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estudia',
       '["Momachtiā"]',
       '["Tleīka", "Yewātl", "Momachtiā", "Tekiti"]',
       'citlali',
       'Momachtiā significa estudia',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Quién es él',
       '["Ākin yewātl?"]',
       '["Kānin ka?", "Ākin yewātl?", "Tlen tikchīwa?", "Tlen tikneki?"]',
       'coltzin',
       'Ākin yewātl? significa ¿quién es él / ella?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Qué hace él',
       '["Tlen kichīwa?"]',
       '["Nichānej Tlaxkallān", "Tlen kichīwa?", "Tlen tikchīwa?", "Ākin tewātl?"]',
       'neza',
       'Tlen kichīwa? significa ¿qué hace él / ella?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ yewātl?',
       '["Ākin", "Ākin yewātl?"]',
       null,
       'tonatiuh',
       'Ākin yewātl? significa ¿quién es él / ella?',
       20, 'medium',
       '¿Quién es él'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tlen ______?',
       '["kichīwa", "Tlen kichīwa?"]',
       null,
       'xochitl',
       'Tlen kichīwa? significa ¿qué hace él / ella?',
       20, 'medium',
       '¿Qué hace él'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 3;

-- nivel 3 · unidad 4: dónde está y qué necesito
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Aquí',
       '["Nikan"]',
       '["Nikan", "Kānin", "Moneki", "Nikneki"]',
       'citlali',
       'Nikan significa aquí',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Allá',
       '["Ōmpa"]',
       '["Tleīka", "Ōmpa", "Kēmman", "Nikan"]',
       'coltzin',
       'Ōmpa significa allá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quiero',
       '["Nikneki"]',
       '["Nikneki", "Ōmpa", "Kānin", "Moneki"]',
       'neza',
       'Nikneki significa quiero / necesito',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Se necesita',
       '["Moneki"]',
       '["Moneki", "Ākin", "Ōmpa", "Ātl"]',
       'tonatiuh',
       'Moneki significa se necesita',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ ka?',
       '["Kānin", "Kānin ka?"]',
       null,
       'xochitl',
       'Kānin ka? significa ¿dónde está?',
       20, 'medium',
       '¿Dónde está?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tlen ______?',
       '["tikneki", "Tlen tikneki?"]',
       null,
       'citlali',
       'Tlen tikneki? significa ¿qué quieres?',
       20, 'medium',
       '¿Qué quieres?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 4;

-- nivel 3 · unidad 5: respuestas completas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Sé',
       '["Nikmati"]',
       '["Nimomachtiā", "Tleīka", "Nikmati", "Ajmo"]',
       'coltzin',
       'Nikmati significa sé / lo sé',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Aquí está',
       '["Nikan ka"]',
       '["Nikan ka", "Ajmo nikmati", "Ōmpa ka", "Nichānej Tlaxkallān"]',
       'neza',
       'Nikan ka significa aquí está',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Allá está',
       '["Ōmpa ka"]',
       '["Ākin tewātl?", "Kānin tichānej?", "Ōmpa ka", "Nichānej Tlaxkallān"]',
       'tonatiuh',
       'Ōmpa ka significa allá está',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quiero agua',
       '["Nikneki ātl"]',
       '["Tlen tikchīwa?", "Ākin tewātl?", "Nikneki ātl", "Ajmo nikneki"]',
       'xochitl',
       'Nikneki ātl significa quiero agua',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ ka',
       '["Nikan", "Nikan ka"]',
       null,
       'citlali',
       'Nikan ka significa aquí está',
       20, 'medium',
       'Aquí está'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ōmpa ______',
       '["ka", "Ōmpa ka"]',
       null,
       'coltzin',
       'Ōmpa ka significa allá está',
       20, 'medium',
       'Allá está'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 5;

-- nivel 3 · unidad 6: cuántos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tres',
       '["Ēyi"]',
       '["Sē", "Ēyi", "Kēski", "Ōme"]',
       'neza',
       'Ēyi significa tres',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cuatro',
       '["Nāwi"]',
       '["Kānin", "Kēski", "Mākwīlli", "Nāwi"]',
       'tonatiuh',
       'Nāwi significa cuatro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cinco',
       '["Mākwīlli"]',
       '["Nāwi", "Mākwīlli", "Ēyi", "Ākin"]',
       'xochitl',
       'Mākwīlli significa cinco',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cuántos quieres?',
       '["Kēski tikneki?"]',
       '["Ākin tewātl?", "Kēski tikneki?", "Kānin tichānej?", "Tlen tikchīwa?"]',
       'citlali',
       'Kēski tikneki? significa ¿cuántos quieres?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ tikneki?',
       '["Kēski", "Kēski tikneki?"]',
       null,
       'coltzin',
       'Kēski tikneki? significa ¿cuántos quieres?',
       20, 'medium',
       '¿Cuántos quieres?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nikneki ______',
       '["ōme", "Nikneki ōme"]',
       null,
       'neza',
       'Nikneki ōme significa quiero dos',
       20, 'medium',
       'Quiero dos'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 3 and u.unit_num = 6;

-- nivel 4 · unidad 1: hoy, ayer y mañana
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hoy',
       '["Āxkān"]',
       '["Wīptla", "Āxkān", "Mostla", "Tōnalli"]',
       'tonatiuh',
       'Āxkān significa hoy / ahora',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ayer',
       '["Yālwa"]',
       '["Āxkān", "Yowalli", "Yālwa", "Tōnalli"]',
       'xochitl',
       'Yālwa significa ayer',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pasado mañana',
       '["Wīptla"]',
       '["Yālwa", "Āxkān", "Wīptla", "Ōtitekit"]',
       'citlali',
       'Wīptla significa pasado mañana',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Día',
       '["Tōnalli"]',
       '["Yowalli", "Wīptla", "Ōnitekit", "Tōnalli"]',
       'coltzin',
       'Tōnalli significa día / sol',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nitekiti',
       '["Āxkān", "Āxkān nitekiti"]',
       null,
       'neza',
       'Āxkān nitekiti significa hoy trabajo',
       20, 'medium',
       'Hoy trabajo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______xkān',
       '["Ā", "Āxkān"]',
       null,
       'tonatiuh',
       'Āxkān significa hoy / ahora',
       20, 'medium',
       'Hoy'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 1;

-- nivel 4 · unidad 2: pasado y futuro
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajé',
       '["Ōnitekit"]',
       '["Ōnikochik", "Ōnitekit", "Nikochis", "Yālwa"]',
       'xochitl',
       'Ōnitekit significa trabajé',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajaré',
       '["Nitekitis"]',
       '["Nitekitis", "Nikochis", "Nitekiti", "Āxkān"]',
       'citlali',
       'Nitekitis significa trabajaré',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajaste',
       '["Ōtitekit"]',
       '["Ōnitekit", "Nitekiti", "Ōtitekit", "Yālwa"]',
       'coltzin',
       'Ōtitekit significa trabajaste',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajarás',
       '["Titekitis"]',
       '["Yālwa", "Ōtitekit", "Nitekiti", "Titekitis"]',
       'neza',
       'Titekitis significa trabajarás',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______itekit',
       '["Ōn", "Ōnitekit"]',
       null,
       'tonatiuh',
       'Ōnitekit significa trabajé',
       20, 'medium',
       'Trabajé'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______tekitis',
       '["Ni", "Nitekitis"]',
       null,
       'xochitl',
       'Nitekitis significa trabajaré',
       20, 'medium',
       'Trabajaré'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 2;

-- nivel 4 · unidad 3: ver y verse
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lo',
       '["Nikitta"]',
       '["Tōnalli", "Nimitsitta", "Nikitta", "Wīptla"]',
       'citlali',
       'Nikitta significa lo / la veo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lo',
       '["Ōnikittak"]',
       '["Ōnimitsittak", "Ōnitekit", "Wīptla", "Ōnikittak"]',
       'coltzin',
       'Ōnikittak significa lo / la vi',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lo',
       '["Nikittas"]',
       '["Ōnitekit", "Yālwa", "Nikittas", "Wīptla"]',
       'neza',
       'Nikittas significa lo / la veré',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Te veo',
       '["Nimitsitta"]',
       '["Tōnalli", "Nimitsitta", "Nikittas", "Ōnimitsittak"]',
       'tonatiuh',
       'Nimitsitta significa te veo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ ōnimitsittak',
       '["Yālwa", "Yālwa ōnimitsittak"]',
       null,
       'xochitl',
       'Yālwa ōnimitsittak significa ayer te vi',
       20, 'medium',
       'Ayer te vi'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______kitta',
       '["Ni", "Nikitta"]',
       null,
       'citlali',
       'Nikitta significa lo / la veo',
       20, 'medium',
       'Lo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 3;

-- nivel 4 · unidad 4: comer, beber e ir
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Como',
       '["Nitlakwā"]',
       '["Nitlakwās", "Niyas", "Nitlakwā", "Āxkān"]',
       'coltzin',
       'Nitlakwā significa como',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Comí',
       '["Ōnitlakwaj"]',
       '["Nitlakwās", "Niātli", "Ōnitlakwaj", "Āxkān"]',
       'neza',
       'Ōnitlakwaj significa comí',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Comeré',
       '["Nitlakwās"]',
       '["Nitlakwās", "Yālwa", "Ōniya", "Niyaw"]',
       'tonatiuh',
       'Nitlakwās significa comeré',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Bebo',
       '["Niātli"]',
       '["Nitlakwās", "Niyas", "Ōniya", "Niātli"]',
       'xochitl',
       'Niātli significa bebo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______tlakwā',
       '["Ni", "Nitlakwā"]',
       null,
       'citlali',
       'Nitlakwā significa como',
       20, 'medium',
       'Como'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______itlakwaj',
       '["Ōn", "Ōnitlakwaj"]',
       null,
       'coltzin',
       'Ōnitlakwaj significa comí',
       20, 'medium',
       'Comí'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 4;

-- nivel 4 · unidad 5: cuándo y dónde
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estoy',
       '["Nikaj"]',
       '["Yālwa", "Wīptla", "Nikaj", "Nikan"]',
       'neza',
       'Nikaj significa estoy',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estás',
       '["Tikaj"]',
       '["Nikaj", "Tikaj", "Yowalli", "Āxkān"]',
       'tonatiuh',
       'Tikaj significa estás',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ayer fui allá',
       '["Yālwa ōniya ōmpa"]',
       '["Yālwa ōniya ōmpa", "Āxkān nitekiti", "Yālwa ōnimitsittak", "Sātepan nitekiti"]',
       'xochitl',
       'Yālwa ōniya ōmpa significa ayer fui allá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mañana iré',
       '["Mostla niyas"]',
       '["Mostla niyas", "Sātepan nitekiti", "Āxkān nitekiti", "Āxkān nikan nikaj"]',
       'citlali',
       'Mostla niyas significa mañana iré',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ ōniya ōmpa',
       '["Yālwa", "Yālwa ōniya ōmpa"]',
       null,
       'coltzin',
       'Yālwa ōniya ōmpa significa ayer fui allá',
       20, 'medium',
       'Ayer fui allá'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Mostla ______',
       '["niyas", "Mostla niyas"]',
       null,
       'neza',
       'Mostla niyas significa mañana iré',
       20, 'medium',
       'Mañana iré'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 5;

-- nivel 4 · unidad 6: contar lo que pasó
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Primero',
       '["Achto"]',
       '["Tōnalli", "Yālwa", "Achto", "Wīptla"]',
       'tonatiuh',
       'Achto significa primero',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Después',
       '["Sātepan"]',
       '["Nitekiti", "Niman", "Wīptla", "Sātepan"]',
       'xochitl',
       'Sātepan significa después',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Luego',
       '["Niman"]',
       '["Sātepan", "Yālwa", "Achto", "Niman"]',
       'citlali',
       'Niman significa luego / enseguida',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Primero como',
       '["Achto nitlakwā"]',
       '["Mostla niyas", "Yālwa ōnimitsittak", "Āxkān nitekiti", "Achto nitlakwā"]',
       'coltzin',
       'Achto nitlakwā significa primero como',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nitlakwā',
       '["Achto", "Achto nitlakwā"]',
       null,
       'neza',
       'Achto nitlakwā significa primero como',
       20, 'medium',
       'Primero como'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Sātepan ______',
       '["nitekiti", "Sātepan nitekiti"]',
       null,
       'tonatiuh',
       'Sātepan nitekiti significa después trabajo',
       20, 'medium',
       'Después trabajo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 4 and u.unit_num = 6;

-- nivel 5 · unidad 1: por la mañana
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me levanto',
       '["Nimēwa"]',
       '["Etl", "Nimēwa", "Tlanēsi", "Nimāltiā"]',
       'xochitl',
       'Nimēwa significa me levanto',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me baño',
       '["Nimāltiā"]',
       '["Nimāltiā", "Nimēwa", "Nikīsa", "Etl"]',
       'citlali',
       'Nimāltiā significa me baño',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Salgo',
       '["Nikīsa"]',
       '["Nimēwa", "Nikochi", "Nikīsa", "Tlanēsi"]',
       'coltzin',
       'Nikīsa significa salgo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Vengo',
       '["Niwāllaw"]',
       '["Nikīsa", "Tlanēsi", "Niwāllaw", "Etl"]',
       'neza',
       'Niwāllaw significa vengo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______mēwa',
       '["Ni", "Nimēwa"]',
       null,
       'tonatiuh',
       'Nimēwa significa me levanto',
       20, 'medium',
       'Me levanto'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______māltiā',
       '["Ni", "Nimāltiā"]',
       null,
       'xochitl',
       'Nimāltiā significa me baño',
       20, 'medium',
       'Me baño'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 1;

-- nivel 5 · unidad 2: dormir y comer
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Duermo',
       '["Nikochi"]',
       '["Nikīsa", "Nitlakwā", "Nimāltiā", "Nikochi"]',
       'citlali',
       'Nikochi significa duermo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tortilla',
       '["Tlaxkalli"]',
       '["Nimēwa", "Tlaxkalli", "Chīlli", "Nikīsa"]',
       'coltzin',
       'Tlaxkalli significa tortilla',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Frijol',
       '["Etl"]',
       '["Nimēwa", "Niwāllaw", "Etl", "Chīlli"]',
       'neza',
       'Etl significa frijol',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Chile',
       '["Chīlli"]',
       '["Nimēwa", "Nimāltiā", "Tlaxkalli", "Chīlli"]',
       'tonatiuh',
       'Chīlli significa chile',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ tlaxkalli',
       '["Nikkwā", "Nikkwā tlaxkalli"]',
       null,
       'xochitl',
       'Nikkwā tlaxkalli significa como tortilla',
       20, 'medium',
       'Como tortilla'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nikkwā ______',
       '["etl", "Nikkwā etl"]',
       null,
       'citlali',
       'Nikkwā etl significa como frijol',
       20, 'medium',
       'Como frijol'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 2;

-- nivel 5 · unidad 3: con otras personas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Comemos',
       '["Titlakwāj"]',
       '["Nowān", "Titlakwāj", "Mowān", "Nimāltiā"]',
       'coltzin',
       'Titlakwāj significa comemos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajamos',
       '["Titekitij"]',
       '["Mowān", "Titlakwāj", "Titekitij", "Niwāllaw"]',
       'neza',
       'Titekitij significa trabajamos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Conmigo',
       '["Nowān"]',
       '["Nikīsa", "Nowān", "Nimēwa", "Mowān"]',
       'tonatiuh',
       'Nowān significa conmigo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Contigo',
       '["Mowān"]',
       '["Nimāltiā", "Nikīsa", "Nonān", "Mowān"]',
       'xochitl',
       'Mowān significa contigo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ mowān',
       '["Nitlakwā", "Nitlakwā mowān"]',
       null,
       'citlali',
       'Nitlakwā mowān significa como contigo',
       20, 'medium',
       'Como contigo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nonān īwān newātl ______',
       '["titlakwāj", "Nonān īwān newātl titlakwāj"]',
       null,
       'coltzin',
       'Nonān īwān newātl titlakwāj significa mi mamá y yo comemos',
       20, 'medium',
       'Mi mamá y yo comemos'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 3;

-- nivel 5 · unidad 4: mañana, tarde y noche
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tarde',
       '["Teōtlak"]',
       '["Nimāltiā", "Nikochi", "Teōtlak", "Niwāllaw"]',
       'neza',
       'Teōtlak significa tarde',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Anochece',
       '["Tlayowa"]',
       '["Nikochi", "Tlayowa", "Tlanēsi", "Nikīsa"]',
       'tonatiuh',
       'Tlayowa significa anochece',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'En la tarde trabajo',
       '["Teōtlak nitekiti"]',
       '["Teōtlak nitekiti", "Nitlakwā mowān", "Nikkwā etl", "Tlanēsi nimēwa"]',
       'xochitl',
       'Teōtlak nitekiti significa en la tarde trabajo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'En la noche duermo',
       '["Yowalli nikochi"]',
       '["Nikkwā etl", "Yowalli nikochi", "Nikkwā tlaxkalli", "Yewān tlakwāj"]',
       'citlali',
       'Yowalli nikochi significa en la noche duermo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nitekiti',
       '["Teōtlak", "Teōtlak nitekiti"]',
       null,
       'coltzin',
       'Teōtlak nitekiti significa en la tarde trabajo',
       20, 'medium',
       'En la tarde trabajo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Yowalli ______',
       '["nikochi", "Yowalli nikochi"]',
       null,
       'neza',
       'Yowalli nikochi significa en la noche duermo',
       20, 'medium',
       'En la noche duermo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 4;

-- nivel 5 · unidad 5: rutinas en plural
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dormimos',
       '["Tikochij"]',
       '["Tikochij", "Nimēwa", "Nimāltiā", "Tekitij"]',
       'tonatiuh',
       'Tikochij significa dormimos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Duermen',
       '["Kochij"]',
       '["Kochij", "Tlakwāj", "Nikīsa", "Tewān"]',
       'xochitl',
       'Kochij significa duermen',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Comen',
       '["Tlakwāj"]',
       '["Tlakwāj", "Tikochij", "Nimēwa", "Nimāltiā"]',
       'citlali',
       'Tlakwāj significa comen',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajan',
       '["Tekitij"]',
       '["Nikīsa", "Yewān", "Tekitij", "Kochij"]',
       'coltzin',
       'Tekitij significa trabajan',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ tikochij',
       '["Tewān", "Tewān tikochij"]',
       null,
       'neza',
       'Tewān tikochij significa nosotros dormimos',
       20, 'medium',
       'Nosotros dormimos'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Yewān ______',
       '["tlakwāj", "Yewān tlakwāj"]',
       null,
       'tonatiuh',
       'Yewān tlakwāj significa ellos comen',
       20, 'medium',
       'Ellos comen'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 5;

-- nivel 5 · unidad 6: mi día completo
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Amanece y me levanto',
       '["Tlanēsi nimēwa"]',
       '["Tlanēsi nimēwa", "Niman nikīsa", "Teōtlak nitekiti", "Nikkwā tlaxkalli"]',
       'xochitl',
       'Tlanēsi nimēwa significa amanece y me levanto',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Luego salgo',
       '["Niman nikīsa"]',
       '["Niman nikīsa", "Nitlakwā mowān", "Tlanēsi nimēwa", "Yowalli nikochi"]',
       'citlali',
       'Niman nikīsa significa luego salgo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Temprano me baño',
       '["Kwalkān nimāltiā"]',
       '["Nikkwā etl", "Kwalkān nimāltiā", "Tlanēsi nimēwa", "Nonān īwān newātl titlakwāj"]',
       'coltzin',
       'Kwalkān nimāltiā significa temprano me baño',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Primero',
       '["Achto"]',
       '["Niwāllaw", "Kwalkān", "Achto", "Nimēwa"]',
       'neza',
       'Achto significa primero',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nimēwa',
       '["Tlanēsi", "Tlanēsi nimēwa"]',
       null,
       'tonatiuh',
       'Tlanēsi nimēwa significa amanece y me levanto',
       20, 'medium',
       'Amanece y me levanto'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Niman ______',
       '["nikīsa", "Niman nikīsa"]',
       null,
       'xochitl',
       'Niman nikīsa significa luego salgo',
       20, 'medium',
       'Luego salgo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 5 and u.unit_num = 6;

-- nivel 6 · unidad 1: lo que me gusta
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me gusta',
       '["Nēchpaktiā"]',
       '["Xiwālla", "Achi", "Nēchpaktiā", "Mitspaktiā?"]',
       'citlali',
       'Nēchpaktiā significa me gusta',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Te gusta?',
       '["Mitspaktiā?"]',
       '["Xiwālla", "Mitspaktiā?", "Xikochi", "Tikneki"]',
       'coltzin',
       'Mitspaktiā? significa ¿te gusta?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mucho',
       '["Senka"]',
       '["Mitspaktiā?", "Nēchpaktiā", "Xikochi", "Senka"]',
       'neza',
       'Senka significa mucho / muy',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Un poco',
       '["Achi"]',
       '["Achi", "Xitlakwā", "Nēchpaktiā", "Mitspaktiā?"]',
       'tonatiuh',
       'Achi significa un poco',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nēchpaktiā',
       '["Ajmo", "Ajmo nēchpaktiā"]',
       null,
       'xochitl',
       'Ajmo nēchpaktiā significa no me gusta',
       20, 'medium',
       'No me gusta'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______chpaktiā',
       '["Nē", "Nēchpaktiā"]',
       null,
       'citlali',
       'Nēchpaktiā significa me gusta',
       20, 'medium',
       'Me gusta'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 1;

-- nivel 6 · unidad 2: lo que quiero
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quieres',
       '["Tikneki"]',
       '["Senka", "Tikneki", "Kineki", "Achi"]',
       'coltzin',
       'Tikneki significa quieres',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quiere',
       '["Kineki"]',
       '["Xikochi", "Kineki", "Nēchpaktiā", "Nikneki"]',
       'neza',
       'Kineki significa quiere',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quiero comer',
       '["Nikneki nitlakwās"]',
       '["Ajmo kwalli", "Ajmo nēchpaktiā", "Ok achi kwalli", "Nikneki nitlakwās"]',
       'tonatiuh',
       'Nikneki nitlakwās significa quiero comer',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quiero dormir',
       '["Nikneki nikochis"]',
       '["Senka kwalli", "Nikneki nikochis", "Ajmo nēchpaktiā", "Nikneki nitlakwās"]',
       'xochitl',
       'Nikneki nikochis significa quiero dormir',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nitlakwās',
       '["Nikneki", "Nikneki nitlakwās"]',
       null,
       'citlali',
       'Nikneki nitlakwās significa quiero comer',
       20, 'medium',
       'Quiero comer'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nikneki ______',
       '["nikochis", "Nikneki nikochis"]',
       null,
       'coltzin',
       'Nikneki nikochis significa quiero dormir',
       20, 'medium',
       'Quiero dormir'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 2;

-- nivel 6 · unidad 3: pedir y ordenar
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Come (tú)',
       '["Xitlakwā"]',
       '["Xitlakwā", "Nēchpaktiā", "Mitspaktiā?", "Ximotlāli"]',
       'neza',
       'Xitlakwā significa come (tú)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Duerme (tú)',
       '["Xikochi"]',
       '["Xikochi", "Ximotlāli", "Mitspaktiā?", "Senka"]',
       'tonatiuh',
       'Xikochi significa duerme (tú)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ven (tú)',
       '["Xiwālla"]',
       '["Ximotlāli", "Mitspaktiā?", "Senka", "Xiwālla"]',
       'xochitl',
       'Xiwālla significa ven (tú)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Siéntate',
       '["Ximotlāli"]',
       '["Ximotlāli", "Nimitstlatlawtiā", "Xiwālla", "Xitlakwā"]',
       'citlali',
       'Ximotlāli significa siéntate',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______, xiwālla',
       '["Nimitstlatlawtiā", "Nimitstlatlawtiā, xiwālla"]',
       null,
       'coltzin',
       'Nimitstlatlawtiā, xiwālla significa por favor, ven',
       20, 'medium',
       'Por favor, ven'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______tlakwā',
       '["Xi", "Xitlakwā"]',
       null,
       'neza',
       'Xitlakwā significa come (tú)',
       20, 'medium',
       'Come (tú)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 3;

-- nivel 6 · unidad 4: más y menos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Más',
       '["Ok achi"]',
       '["Ajmo kwalli", "Ok achi", "Ajmo nēchpaktiā", "Nimitstlatlawtiā, xiwālla"]',
       'tonatiuh',
       'Ok achi significa más',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mejor',
       '["Ok achi kwalli"]',
       '["Ajmo nēchpaktiā", "Ok achi", "Nimitstlatlawtiā, xiwālla", "Ok achi kwalli"]',
       'xochitl',
       'Ok achi kwalli significa mejor',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muy bueno',
       '["Senka kwalli"]',
       '["Senka kwalli", "Ok achi", "Nēchpaktiā ātl", "Nikneki nitlakwās"]',
       'citlali',
       'Senka kwalli significa muy bueno',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'No es bueno',
       '["Ajmo kwalli"]',
       '["Nikneki nikochis", "Ok achi kwalli", "Senka kwalli", "Ajmo kwalli"]',
       'coltzin',
       'Ajmo kwalli significa no es bueno',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ achi',
       '["Ok", "Ok achi"]',
       null,
       'neza',
       'Ok achi significa más',
       20, 'medium',
       'Más'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ok achi ______',
       '["kwalli", "Ok achi kwalli"]',
       null,
       'tonatiuh',
       'Ok achi kwalli significa mejor',
       20, 'medium',
       'Mejor'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 4;

-- nivel 6 · unidad 5: mis gustos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me gusta el agua',
       '["Nēchpaktiā ātl"]',
       '["Nikneki nitlakwās", "Nēchpaktiā ātl", "Nimitstlatlawtiā, xiwālla", "Ok achi"]',
       'xochitl',
       'Nēchpaktiā ātl significa me gusta el agua',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me gusta la tortilla',
       '["Nēchpaktiā tlaxkalli"]',
       '["Nēchpaktiā ātl", "Ok achi", "Nēchpaktiā tlaxkalli", "Ajmo nēchpaktiā"]',
       'citlali',
       'Nēchpaktiā tlaxkalli significa me gusta la tortilla',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'No me gusta el chile',
       '["Ajmo nēchpaktiā chīlli"]',
       '["Ajmo nēchpaktiā chīlli", "Mitspaktiā etl?", "Nēchpaktiā tlaxkalli", "Nikneki nitlakwās"]',
       'coltzin',
       'Ajmo nēchpaktiā chīlli significa no me gusta el chile',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Te gusta el frijol?',
       '["Mitspaktiā etl?"]',
       '["Mitspaktiā etl?", "Nikneki nikochis", "Ajmo nēchpaktiā chīlli", "Nikneki nitlakwās"]',
       'neza',
       'Mitspaktiā etl? significa ¿te gusta el frijol?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ ātl',
       '["Nēchpaktiā", "Nēchpaktiā ātl"]',
       null,
       'tonatiuh',
       'Nēchpaktiā ātl significa me gusta el agua',
       20, 'medium',
       'Me gusta el agua'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nēchpaktiā ______',
       '["tlaxkalli", "Nēchpaktiā tlaxkalli"]',
       null,
       'xochitl',
       'Nēchpaktiā tlaxkalli significa me gusta la tortilla',
       20, 'medium',
       'Me gusta la tortilla'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 5;

-- nivel 6 · unidad 6: expresión completa
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Idioma náhuatl',
       '["Nāwatlajtōlli"]',
       '["Achi", "Nāwatlajtōlli", "Nikneki", "Senka"]',
       'citlali',
       'Nāwatlajtōlli significa idioma náhuatl',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Qué te gusta?',
       '["Tlen mitspaktiā?"]',
       '["Ajmo nēchpaktiā", "Nimitstlatlawtiā, xiwālla", "Ok achi", "Tlen mitspaktiā?"]',
       'coltzin',
       'Tlen mitspaktiā? significa ¿qué te gusta?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me gusta el náhuatl',
       '["Nēchpaktiā nāwatlajtōlli"]',
       '["Ok achi", "Ajmo nēchpaktiā", "Nēchpaktiā nāwatlajtōlli", "Nikneki nikochis"]',
       'neza',
       'Nēchpaktiā nāwatlajtōlli significa me gusta el náhuatl',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me gusta',
       '["Nēchpaktiā"]',
       '["Senka", "Nikneki", "Nēchpaktiā", "Tikneki"]',
       'tonatiuh',
       'Nēchpaktiā significa me gusta',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ mitspaktiā?',
       '["Tlen", "Tlen mitspaktiā?"]',
       null,
       'xochitl',
       'Tlen mitspaktiā? significa ¿qué te gusta?',
       20, 'medium',
       '¿Qué te gusta?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nēchpaktiā ______',
       '["nāwatlajtōlli", "Nēchpaktiā nāwatlajtōlli"]',
       null,
       'citlali',
       'Nēchpaktiā nāwatlajtōlli significa me gusta el náhuatl',
       20, 'medium',
       'Me gusta el náhuatl'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'nhn' and l.level_num = 6 and u.unit_num = 6;

-- ─────────────────────────────────────────────
--  7. sistema de escritura
-- ─────────────────────────────────────────────
insert into ct_writing_systems (language_id, system_type, system_name, description, characters, notes)
select id, 'syllabary', 'alfabeto moderno',
       'Ortografía moderna con macrones para la vocal larga. Borrador pendiente de validar con hablantes de la variante.',
       '[
    {
        "type": "vowel",
        "letter": "a",
        "pronunciation": "a",
        "syllables": {
            "a": "a",
            "e": null,
            "i": null,
            "o": null
        },
        "example": "Ajmo"
    },
    {
        "type": "vowel",
        "letter": "e",
        "pronunciation": "e",
        "syllables": {
            "a": null,
            "e": "e",
            "i": null,
            "o": null
        },
        "example": "Etl"
    },
    {
        "type": "vowel",
        "letter": "i",
        "pronunciation": "i",
        "syllables": {
            "a": null,
            "e": null,
            "i": "i",
            "o": null
        },
        "example": "Inin"
    },
    {
        "type": "vowel",
        "letter": "o",
        "pronunciation": "o",
        "syllables": {
            "a": null,
            "e": null,
            "i": null,
            "o": "o"
        },
        "example": "Oksēppa"
    },
    {
        "type": "digraph",
        "letter": "ch",
        "pronunciation": "ch",
        "syllables": {
            "a": "cha",
            "e": "che",
            "i": "chi",
            "o": "cho",
            "u": null
        },
        "example": "Chikāwak"
    },
    {
        "type": "consonant",
        "letter": "j",
        "pronunciation": "saltillo (corte de voz), al final de sílaba",
        "syllables": {},
        "example": "Tlasojkāmati"
    },
    {
        "type": "consonant",
        "letter": "k",
        "pronunciation": "k",
        "syllables": {
            "a": "ka",
            "e": "ke",
            "i": "ki",
            "o": "ko"
        },
        "example": "Kēn"
    },
    {
        "type": "digraph",
        "letter": "kw",
        "pronunciation": "kw",
        "syllables": {
            "a": "kwa",
            "e": "kwe",
            "i": "kwi",
            "o": "kwo",
            "u": null
        },
        "example": "Kwalli"
    },
    {
        "type": "consonant",
        "letter": "l",
        "pronunciation": "l",
        "syllables": {
            "a": "la",
            "e": "le",
            "i": "li",
            "o": "lo"
        },
        "example": "Ximopanōlti"
    },
    {
        "type": "consonant",
        "letter": "m",
        "pronunciation": "m",
        "syllables": {
            "a": "ma",
            "e": "me",
            "i": "mi",
            "o": "mo"
        },
        "example": "Mostla"
    },
    {
        "type": "consonant",
        "letter": "n",
        "pronunciation": "n",
        "syllables": {
            "a": "na",
            "e": "ne",
            "i": "ni",
            "o": "no"
        },
        "example": "Notōka"
    },
    {
        "type": "consonant",
        "letter": "p",
        "pronunciation": "p",
        "syllables": {
            "a": "pa",
            "e": "pe",
            "i": "pi",
            "o": "po"
        },
        "example": "Ximopanōlti"
    },
    {
        "type": "consonant",
        "letter": "s",
        "pronunciation": "s",
        "syllables": {
            "a": "sa",
            "e": "se",
            "i": "si",
            "o": "so"
        },
        "example": "Siawi"
    },
    {
        "type": "consonant",
        "letter": "t",
        "pronunciation": "t",
        "syllables": {
            "a": "ta",
            "e": "te",
            "i": "ti",
            "o": "to"
        },
        "example": "Timoittaske"
    },
    {
        "type": "digraph",
        "letter": "tl",
        "pronunciation": "tl (un solo sonido)",
        "syllables": {
            "a": "tla",
            "e": "tle",
            "i": "tli",
            "o": "tlo",
            "u": null
        },
        "example": "Tlasojkāmati"
    },
    {
        "type": "digraph",
        "letter": "ts",
        "pronunciation": "ts",
        "syllables": {
            "a": "tsa",
            "e": "tse",
            "i": "tsi",
            "o": "tso",
            "u": null
        },
        "example": "Nimitsitta"
    },
    {
        "type": "consonant",
        "letter": "w",
        "pronunciation": "w",
        "syllables": {
            "a": "wa",
            "e": "we",
            "i": "wi",
            "o": "wo"
        },
        "example": "Wēy"
    },
    {
        "type": "consonant",
        "letter": "x",
        "pronunciation": "sh",
        "syllables": {
            "a": "xa (sha)",
            "e": "xe (she)",
            "i": "xi (shi)",
            "o": "xo (sho)"
        },
        "example": "Ximopanōlti"
    },
    {
        "type": "consonant",
        "letter": "y",
        "pronunciation": "y",
        "syllables": {
            "a": "ya",
            "e": "ye",
            "i": "yi",
            "o": "yo"
        },
        "example": "Yewātl"
    },
    {
        "type": "longVowel",
        "letter": "ā",
        "pronunciation": "aa",
        "syllables": {
            "a": "ā (aa)"
        },
        "example": "Newātl"
    },
    {
        "type": "longVowel",
        "letter": "ē",
        "pronunciation": "ee",
        "syllables": {
            "e": "ē (ee)"
        },
        "example": "Kēn"
    },
    {
        "type": "longVowel",
        "letter": "ī",
        "pronunciation": "ii",
        "syllables": {
            "i": "ī (ii)"
        },
        "example": "Ītōka"
    },
    {
        "type": "longVowel",
        "letter": "ō",
        "pronunciation": "oo",
        "syllables": {
            "o": "ō (oo)"
        },
        "example": "Ximopanōlti"
    }
]',
       '["Ch, tl, ts y kw representan un solo sonido y no se separan al silabear",
         "La tl final se queda en la sílaba anterior: xō-chitl, ne-wātl",
         "El macrón marca la vocal larga: ā, ē, ī, ō (ātl agua, nāwi cuatro, ōme dos)",
         "La j marca el saltillo (corte de voz): tlasojkāmati, kēmaj, ajmo",
         "La x suena como sh: ximopanōlti",
         "La doble l se pronuncia como dos l: kwal-li",
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
