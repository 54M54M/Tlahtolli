-- ============================================================
--  seed data — tének / huasteco (hus)
--  tlahtolcalli  [postgresql]
--
--  variante base: tének de san luis potosí (iso 639-3: hus)
--  ejecutar después de:
--    1.-esquema.sql
--    2.-datos_generales.sql   (usuario demo y logros)
--
--  contenido (curso completo, mismos niveles que nhn):
--    6 niveles · 36 unidades · 175 palabras y frases · 225 asociaciones · 216 ejercicios
--    ct_languages → ct_levels → ct_units → ct_vocabulary → rl_unit_vocab
--    → ct_exercises → ct_writing_systems → ta_user_progress → ta_user_stats → desglose
--
--  tipología: aglutinante con rasgos polisintéticos y ergativos (familia maya). persona y posesión
--    con piezas separables (u/nu = mi, a/na = tu, in = su), plural -chik y poseído -il;
--    el desglose separa esas piezas cuando el propio curso las muestra.
--
--  fuentes:
--    · inali, norma de escritura de la lengua tének
--      (junkudh tsalap abal ki dhucha' an tének kawintaláb)
--    · inali, prontuario de tének (saludos y cortesía)
--    · vocabulario huasteco-español de pueblosoriginarios.com, pasado a la
--      norma inali (ā → á, sh → x, th → dh)
--  las frases son las que aparecen tal cual en esas fuentes; no se armaron
--  frases nuevas por analogía.
--
--  borrador para revisión con hablantes: todas las palabras, traducciones
--  y pronunciaciones deben validarse antes de publicarse.
--
--  norma ortográfica (inali, una sola en todo el contenido):
--    · vocal con acento = vocal larga: atáj, búk, kalám
--    · ' sola = saltillo (corte de voz): ja', bó', kó'ol
--    · ch, dh, kw, ts, tx y las glotalizadas b', ch', k', k'w, t', ts', y'
--      son un solo sonido y no se separan al silabear
--    · plural de san luis potosí con -chik: tatá'chik, jajáchik
--  guía de pronunciación: sílabas separadas con guion según la norma
--  (utsun → u-tsun, bat'aw → ba-t'aw).
--
--  re-ejecutable: borra primero todo lo de 'hus'.
-- ============================================================

begin;

-- ─────────────────────────────────────────────
--  0. limpieza (re-ejecución)
-- ─────────────────────────────────────────────
update ta_users set current_lang = null
 where current_lang = (select id from ct_languages where code = 'hus');
delete from ta_user_stats
 where language_id = (select id from ct_languages where code = 'hus');
delete from ta_user_achievements where language_tag = 'hus';
delete from ct_languages where code = 'hus';   -- en cascada: niveles, unidades, vocabulario, ejercicios, progreso

-- ─────────────────────────────────────────────
--  1. idioma
-- ─────────────────────────────────────────────
insert into ct_languages (code, lang_name, native_name, color, flag, family, writing_system)
values ('hus', 'Tének', 'Tének kawintaláb', null, '🌿', 'maya', 'alphabet');

-- ─────────────────────────────────────────────
--  2. niveles (título en tének: palabras del propio curso)
-- ─────────────────────────────────────────────
insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 1, 'Saluda y preséntate', 'Tajk''anenek', null, 6, 'Ninguno - Nivel inicial', 1
from ct_languages where code = 'hus';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 2, 'Descríbete y describe a tu familia', 'Táta'' ani mím', null, 6, 'Completar Nivel 1', 0
from ct_languages where code = 'hus';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 3, 'Pide y da información', '¿Jantom, juta?', null, 6, 'Completar Nivel 2', 0
from ct_languages where code = 'hus';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 4, 'Habla en tiempos (ayer/hoy/mañana)', 'We''él, xowé'', kalám', null, 6, 'Completar Nivel 3', 0
from ct_languages where code = 'hus';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 5, 'Describe un día normal', 'Bakan ani tsanak''w', null, 6, 'Completar Nivel 4', 0
from ct_languages where code = 'hus';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 6, 'Describe y expresa preferencias', 'Koy ani pik''o''', null, 6, 'Completar Nivel 5', 0
from ct_languages where code = 'hus';

-- ─────────────────────────────────────────────
--  3.1 unidades — nivel 1: saluda y preséntate
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Saludos', null,
       'Saludar según la hora del día y dar la bienvenida',
       'Los saludos cambian con la hora: tajk''anenek (mañana), waklenenek (tarde), dhamk''unenek (noche)', 1, null
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Despedidas', null,
       'Despedirse y desear que le vaya bien a la otra persona',
       'Tayej ku tsu''uxinej (nos vemos) y kit k''alej alwa'' (que te vaya bien); alwa'' = bien, bueno', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Cómo te llamas', null,
       'Decir tu nombre y conocer los pronombres',
       'Naná'' (yo), tatá'' (tú), jajá'' (él, ella); u bij = mi nombre, a bij = tu nombre', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Agradecer y responder', null,
       'Dar las gracias y responder sí o no',
       'K''ak''námal (gracias, SLP); yán = mucho; yab niega el verbo', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Cortesía', null,
       'Pedir permiso y desear buen provecho',
       'Pakwlanchij yán (con permiso); kit k''apúts alwa'' (buen provecho)', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Conversación básica', null,
       'Unir saludo, nombre, agradecimiento y despedida',
       'Tének es el nombre del pueblo y de la lengua; kawintaláb = lengua, palabra', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1;

-- ─────────────────────────────────────────────
--  3.2 unidades — nivel 2: descríbete y describe a tu familia
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Pronombres personales', null,
       'Conocer los pronombres en singular y plural',
       'Plural con -chik en SLP: tatá''chik (ustedes), jajáchik (ellos), inikchik (hombres)', 0, 'Completar Nivel 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'La familia', null,
       'Nombrar a la familia cercana',
       'Táta'' (papá), mím (mamá); ani = y', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Los abuelos y los tíos', null,
       'Nombrar a los abuelos, tíos y hermanos',
       'Mám (abuelo, anciano), ách (abuela); itsán (tío), tsanub (tía); epchal (hermano)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Cómo es', null,
       'Describir con adjetivos',
       'Adjetivos de tamaño y cualidad: púlik, tsakam, ít, alabél, kidhab, nakat', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Los colores', null,
       'Nombrar los colores básicos',
       'Colores: tsakni'', dhakni'', t''unu'', yaxu'', manu''', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Contar del uno al cinco', null,
       'Contar del uno al cinco y hablar de amigos',
       'Números: jún, tsáb, óx, ché'', bó''', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2;

-- ─────────────────────────────────────────────
--  3.3 unidades — nivel 3: pide y da información
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Palabras para preguntar', null,
       'Conocer las palabras para hacer preguntas',
       'Jantom (qué), jantij (cómo), juta (dónde), jay (cuánto); jachan pregunta "¿es…?"', 0, 'Completar Nivel 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Mi casa y mi comunidad', null,
       'Hablar de la casa y la comunidad',
       'Posesivos: nu (mi), na (tu): nu kwentsál, na k''imá''; la vocal puede alargarse al poseer', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Contar del seis al diez', null,
       'Contar del seis al diez y hasta veinte',
       'Números: akak, búk, waxik, beléw, laju''; veinte = jún inik (lit. un hombre)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Lugares y cosas', null,
       'Nombrar lugares y objetos cotidianos',
       'Sustantivos de lugar y objetos: alté'', mom, ja'', tumín, úw, takab', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Cerca y lejos', null,
       'Ubicar las cosas',
       'Utat (cerca), ów (lejos), alal (abajo); ok''ox (primero), putat (entero)', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Preguntas útiles', null,
       'Preguntar por la lengua y la comunidad',
       'El artículo an (el, la): an kawnal; in bij = su nombre', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3;

-- ─────────────────────────────────────────────
--  3.4 unidades — nivel 4: habla en tiempos (ayer/hoy/mañana)
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Hoy, ayer y mañana', null,
       'Decir cuándo pasa algo',
       'Xowé'' (hoy), we''él (ayer), kalám (mañana); k''icháj (día, sol) y akal (noche)', 0, 'Completar Nivel 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'La naturaleza', null,
       'Nombrar elementos de la naturaleza',
       'Its'' (luna, mes) no es lo mismo que its (chile): el saltillo cambia la palabra', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Lo que hago', null,
       'Decir acciones en primera persona',
       'In + verbo intransitivo (yo): in atsim, in kalel; naná'' im belal (in → im antes de b)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Lo que pasó', null,
       'Hablar del pasado',
       'U + verbo transitivo (yo): u lejkiy an bakan (preparé la tortilla); tey = también', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Ahora y después', null,
       'Decir lo que estamos haciendo y lo que haremos',
       'Exom (estamos) + tu (nosotros) + verbo; ne''ets ku (iremos a / vamos a)', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Repaso del tiempo', null,
       'Contar qué pasó ayer y qué pasará mañana',
       'Ulits (llegar), ach''a'' (escuchar) y repaso de hoy, ayer y mañana', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4;

-- ─────────────────────────────────────────────
--  3.5 unidades — nivel 5: describe un día normal
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'La comida', null,
       'Nombrar la comida de todos los días',
       'Alimentos básicos: idhidh (maíz), ajan (elote), tsanak''w (frijol), its (chile)', 0, 'Completar Nivel 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Frutas y plantas', null,
       'Nombrar frutas y plantas',
       'Préstamo integrado: lanáx (naranja)', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'En la cocina', null,
       'Nombrar bebidas y objetos de cocina',
       'Préstamos integrados: kapéj (café), kuchil (cuchillo), mexa (mesa)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Acciones del día', null,
       'Conocer verbos de todos los días',
       'Verbos en su forma base: k''apul, uts''ál, wayal, met''ál, pidhál, belal', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Trabajos de la casa', null,
       'Decir los trabajos de la casa',
       'U + verbo (yo): u nujuwal, u kitnál; ¡ka …! da una orden: ¡ka k''wetoy!', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Caliente y frío', null,
       'Describir la comida y las cosas',
       'Adjetivos: k''ak'' (caliente), chamay (frío), ts''a''ik (amargo), t''apay (pegajoso), tolow (grueso)', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5;

-- ─────────────────────────────────────────────
--  3.6 unidades — nivel 6: describe y expresa preferencias
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Animales del monte', null,
       'Nombrar animales del monte',
       'Koy es el conejo: el mismo animal de la mascota de la app', 0, 'Completar Nivel 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Animales de la casa', null,
       'Nombrar animales cercanos y decir "mi perro"',
       'Poseer cambia la palabra: pik''o'' (perro) → nu pik''oil (mi perro)', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'El cuerpo', null,
       'Nombrar las partes del cuerpo',
       'Partes del cuerpo: ok'', k''ubak, akan, wal, wi'', okob, txukul', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Lo que quiero y lo que tengo', null,
       'Hablar de querer y tener',
       'Verbos en su forma base: le'' (querer), kó''ol (tener)', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Expresiones', null,
       'Expresar gusto y nombrar lugares',
       '¡Abél…! expresa admiración; nombres tének de lugares: Tampots''ots'', Labtóm', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Conversación final', null,
       'Unir todo lo aprendido en una conversación',
       'Repaso: saludo, nombre, familia, comida, animales y despedida', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6;

-- ─────────────────────────────────────────────
--  4. vocabulario
-- ─────────────────────────────────────────────
-- nivel 1 · unidad 1: saludos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tajk''anenek', 'buenos días', 'taj-k''a-ne-nek', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Waklenenek', 'buenas tardes', 'wak-le-ne-nek', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Dhamk''unenek', 'buenas noches', 'dham-k''u-ne-nek', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Alwa'' bats''udh', 'bienvenido(a)', 'al-wa'' ba-ts''udh', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kit wat''ey', 'pasa / adelante', 'kit wa-t''ey', null from ct_languages where code = 'hus';
-- nivel 1 · unidad 2: despedidas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tayej ku tsu''uxinej', 'hasta luego / nos vemos', 'ta-yej ku tsu-''u-xi-nej', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kit k''alej alwa''', 'que te vaya bien', 'kit k''a-lej al-wa''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Alwa''', 'bien / bueno', 'al-wa''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kalám', 'mañana', 'ka-lám', null from ct_languages where code = 'hus';
-- nivel 1 · unidad 3: cómo te llamas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Naná''', 'yo', 'na-ná''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tatá''', 'tú', 'ta-tá''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Jajá''', 'él / ella', 'ja-já''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Bij', 'nombre', 'bij', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Naná'' u bij', 'yo me llamo (lit. yo, mi nombre)', 'na-ná'' u bij', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, '¿Jantij a bij?', '¿cómo te llamas?', 'jan-tij a bij', null from ct_languages where code = 'hus';
-- nivel 1 · unidad 4: agradecer y responder
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'K''ak''námal', 'gracias', 'k''ak''-ná-mal', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Lej k''ak''námal yán', 'muchas gracias', 'lej k''ak''-ná-mal yán', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yán', 'mucho', 'yán', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Antsaná''', 'sí / así es', 'an-tsa-ná''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yab', 'no', 'yab', null from ct_languages where code = 'hus';
-- nivel 1 · unidad 5: cortesía
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Pakwlanchij yán', 'con permiso / disculpa', 'pakw-lan-chij yán', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kit k''apúts alwa''', 'buen provecho', 'kit k''a-púts al-wa''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Wanaj ku t''ojon kulbél', 'disfrutemos este encuentro', 'wa-naj ku t''o-jon kul-bél', null from ct_languages where code = 'hus';
-- nivel 1 · unidad 6: conversación básica
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tének', 'tének (pueblo y lengua)', 'té-nek', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kawintaláb', 'lengua / palabra', 'ka-win-ta-láb', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, '¿Jantom kawintaláb an kawnal?', '¿qué lengua hablas?', 'jan-tom ka-win-ta-láb an kaw-nal', null from ct_languages where code = 'hus';
-- nivel 2 · unidad 1: pronombres personales
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Wawá''', 'nosotros(as)', 'wa-wá''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tatá''chik', 'ustedes', 'ta-tá''-chik', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Jajáchik', 'ellos / ellas', 'ja-já-chik', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Inik', 'hombre', 'i-nik', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Uxum', 'mujer', 'u-xum', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Inikchik', 'hombres', 'i-nik-chik', null from ct_languages where code = 'hus';
-- nivel 2 · unidad 2: la familia
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Táta''', 'papá', 'tá-ta''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Mím', 'mamá', 'mím', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kwitól', 'niño(a)', 'kwi-tól', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ani', 'y', 'a-ni', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ixám', 'esposa', 'i-xám', null from ct_languages where code = 'hus';
-- nivel 2 · unidad 3: los abuelos y los tíos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Mám', 'abuelo / anciano', 'mám', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ách', 'abuela', 'ách', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Itsán', 'tío', 'i-tsán', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tsanub', 'tía', 'tsa-nub', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Epchal', 'hermano', 'ep-chal', null from ct_languages where code = 'hus';
-- nivel 2 · unidad 4: cómo es
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Púlik', 'grande', 'pú-lik', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tsakam', 'pequeño(a)', 'tsa-kam', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ít', 'nuevo(a)', 'ít', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Alabél', 'bonito(a)', 'a-la-bél', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kidhab', 'malo(a)', 'ki-dhab', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nakat', 'largo(a)', 'na-kat', null from ct_languages where code = 'hus';
-- nivel 2 · unidad 5: los colores
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tsakni''', 'rojo', 'tsak-ni''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Dhakni''', 'blanco', 'dhak-ni''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'T''unu''', 'negro', 't''u-nu''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yaxu''', 'verde', 'ya-xu''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Manu''', 'amarillo', 'ma-nu''', null from ct_languages where code = 'hus';
-- nivel 2 · unidad 6: contar del uno al cinco
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Jún', 'uno', 'jún', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tsáb', 'dos', 'tsáb', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Óx', 'tres', 'óx', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ché''', 'cuatro', 'ché''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Bó''', 'cinco', 'bó''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ja''úb', 'amigo(a)', 'ja-''úb', null from ct_languages where code = 'hus';
-- nivel 3 · unidad 1: palabras para preguntar
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Jantom', 'qué', 'jan-tom', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Jantij', 'cómo', 'jan-tij', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Juta', 'dónde', 'ju-ta', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Jay', 'cuánto', 'jay', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Jachan', '¿es…? (pregunta)', 'ja-chan', null from ct_languages where code = 'hus';
-- nivel 3 · unidad 2: mi casa y mi comunidad
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Atáj', 'casa', 'a-táj', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kwentsal', 'comunidad', 'kwen-tsal', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nu kwentsál', 'mi comunidad', 'nu kwen-tsál', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Na k''imá''', 'tu casa', 'na k''i-má''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, '¿Jachana k''imá?', '¿es tu casa?', 'ja-cha-na k''i-má', null from ct_languages where code = 'hus';
-- nivel 3 · unidad 3: contar del seis al diez
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Akak', 'seis', 'a-kak', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Búk', 'siete', 'búk', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Waxik', 'ocho', 'wa-xik', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Beléw', 'nueve', 'be-léw', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Laju''', 'diez', 'la-ju''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Jún inik', 'veinte', 'jún i-nik', null from ct_languages where code = 'hus';
-- nivel 3 · unidad 4: lugares y cosas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Alté''', 'monte', 'al-té''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Mom', 'pozo', 'mom', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ja''', 'agua', 'ja''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tumín', 'dinero', 'tu-mín', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Úw', 'papel', 'úw', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Takab', 'comal', 'ta-kab', null from ct_languages where code = 'hus';
-- nivel 3 · unidad 5: cerca y lejos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Utat', 'cerca', 'u-tat', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ów', 'lejos', 'ów', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Alal', 'abajo', 'a-lal', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ok''ox', 'primero', 'o-k''ox', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Putat', 'entero', 'pu-tat', null from ct_languages where code = 'hus';
-- nivel 3 · unidad 6: preguntas útiles
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'An', 'el / la', 'an', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, '¿Jantij in bij na kwentsalíl?', '¿cómo se llama tu comunidad?', 'jan-tij in bij na kwen-tsa-líl', null from ct_languages where code = 'hus';
-- nivel 4 · unidad 1: hoy, ayer y mañana
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Xowé''', 'hoy', 'xo-wé''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'We''él', 'ayer', 'we-''él', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'K''icháj', 'día / sol', 'k''i-cháj', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Akal', 'noche', 'a-kal', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'K''ij', 'tiempo', 'k''ij', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tamub', 'año', 'ta-mub', null from ct_languages where code = 'hus';
-- nivel 4 · unidad 2: la naturaleza
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Its''', 'luna / mes', 'its''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ik''', 'aire / viento', 'ik''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Lem', 'mariposa', 'lem', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tsunun', 'colibrí', 'tsu-nun', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ts''itsin', 'pájaro', 'ts''i-tsin', null from ct_languages where code = 'hus';
-- nivel 4 · unidad 3: lo que hago
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'In atsim', 'me baño', 'in a-tsim', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'In kalel', 'salgo', 'in ka-lel', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Naná'' im belal', 'yo camino', 'na-ná'' im be-lal', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ne''ech ban nu kwentsál', 'voy a mi comunidad', 'ne-''ech ban nu kwen-tsál', null from ct_languages where code = 'hus';
-- nivel 4 · unidad 4: lo que pasó
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'U lejkiy an bakan', 'preparé la tortilla', 'u lej-kiy an ba-kan', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Bakan', 'tortilla', 'ba-kan', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tatá'' tey i t''ojon', 'tú también trabajaste', 'ta-tá'' tey i t''o-jon', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tsekets an bichim', 'el caballo se cansó', 'tse-kets an bi-chim', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Bichim', 'caballo', 'bi-chim', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Wat''ey', 'pasó', 'wa-t''ey', null from ct_languages where code = 'hus';
-- nivel 4 · unidad 5: ahora y después
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Exom tu dhuchum', 'estamos escribiendo', 'e-xom tu dhu-chum', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Dhuchum', 'escribir', 'dhu-chum', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ne''ets ku ayin', 'regresaremos a casa', 'ne-''ets ku a-yin', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'T''ojnal', 'trabajar', 't''oj-nal', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'T''ojlab', 'trabajo', 't''oj-lab', null from ct_languages where code = 'hus';
-- nivel 4 · unidad 6: repaso del tiempo
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ulits', 'llegar', 'u-lits', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ach''a''', 'escuchar', 'a-ch''a''', null from ct_languages where code = 'hus';
-- nivel 5 · unidad 1: la comida
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Idhidh', 'maíz', 'i-dhidh', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ajan', 'elote', 'a-jan', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tsanak''w', 'frijol', 'tsa-nak''w', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Its', 'chile', 'its', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'K''apnél', 'comida', 'k''ap-nél', null from ct_languages where code = 'hus';
-- nivel 5 · unidad 2: frutas y plantas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Lanáx', 'naranja', 'la-náx', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Uj', 'aguacate', 'uj', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Utsun', 'papaya', 'u-tsun', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Pakab', 'caña', 'pa-kab', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Pak''ak''', 'nopal', 'pa-k''ak''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Way''', 'mazorca', 'way''', null from ct_languages where code = 'hus';
-- nivel 5 · unidad 3: en la cocina
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kapéj', 'café', 'ka-péj', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tay''', 'cal', 'tay''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kuchil', 'cuchillo', 'ku-chil', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Mexa', 'mesa', 'me-xa', null from ct_languages where code = 'hus';
-- nivel 5 · unidad 4: acciones del día
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'K''apul', 'comer', 'k''a-pul', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Uts''ál', 'beber', 'u-ts''ál', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Wayal', 'dormir', 'wa-yal', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Met''ál', 'ver', 'me-t''ál', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Pidhál', 'dar', 'pi-dhál', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Belal', 'caminar', 'be-lal', null from ct_languages where code = 'hus';
-- nivel 5 · unidad 5: trabajos de la casa
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'U nujuwal an lanax', 'vendo naranjas', 'u nu-ju-wal an la-nax', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'U kitnál an dhi''', 'cargo la leña', 'u kit-nál an dhi''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Dhi''', 'leña', 'dhi''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, '¡Ka k''wetoy na k''imá''!', '¡barre tu casa!', 'ka k''we-toy na k''i-má''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'K''wet', 'escoba', 'k''wet', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Xabún', 'jabón', 'xa-bún', null from ct_languages where code = 'hus';
-- nivel 5 · unidad 6: caliente y frío
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'K''ak''', 'caliente', 'k''ak''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Chamay', 'frío(a)', 'cha-may', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ts''a''ik', 'amargo(a)', 'ts''a-''ik', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'T''apay', 'pegajoso(a)', 't''a-pay', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tolow', 'grueso(a)', 'to-low', null from ct_languages where code = 'hus';
-- nivel 6 · unidad 1: animales del monte
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Koy', 'conejo', 'koy', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Chuch', 'coyote', 'chuch', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Itxamal', 'venado', 'i-txa-mal', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Edhem', 'mapache', 'e-dhem', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ot''el', 'ardilla', 'o-t''el', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Bat''aw', 'armadillo', 'ba-t''aw', null from ct_languages where code = 'hus';
-- nivel 6 · unidad 2: animales de la casa
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Pik''o''', 'perro', 'pi-k''o''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Mitsu''', 'gato', 'mi-tsu''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Koxol', 'gallo', 'ko-xol', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ch''uri''', 'burro', 'ch''u-ri''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Nu pik''oil', 'mi perro', 'nu pi-k''o-il', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Yaxk''wa''', 'rana', 'yax-k''wa''', null from ct_languages where code = 'hus';
-- nivel 6 · unidad 3: el cuerpo
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Ok''', 'cabeza', 'ok''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'K''ubak', 'mano', 'k''u-bak', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Akan', 'pie', 'a-kan', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Wal', 'ojo / cara', 'wal', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Wi''', 'boca', 'wi''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Okob', 'brazo', 'o-kob', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Txukul', 'panza', 'txu-kul', null from ct_languages where code = 'hus';
-- nivel 6 · unidad 4: lo que quiero y lo que tengo
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Le''', 'querer', 'le''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Kó''ol', 'tener', 'kó-''ol', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Xumpelel', 'sombrero', 'xum-pe-lel', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Belal atáj', 'carro (lit. casa que camina)', 'be-lal a-táj', null from ct_languages where code = 'hus';
-- nivel 6 · unidad 5: expresiones
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, '¡Abél junt''aj xu bixnél!', '¡qué bonita danza!', 'a-bél jun-t''aj xu bix-nél', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tének Tsabál', 'región tének', 'té-nek tsa-bál', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Tampots''ots''', 'San Luis Potosí', 'tam-po-ts''ots''', null from ct_languages where code = 'hus';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example)
select id, 'Labtóm', 'México', 'lab-tóm', null from ct_languages where code = 'hus';

-- ─────────────────────────────────────────────
--  5. rl_unit_vocab — vocabulario por unidad (nuevo + repaso)
-- ─────────────────────────────────────────────
-- nivel 1 · unidad 1: saludos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 1
and v.word in ('Tajk''anenek', 'Waklenenek', 'Dhamk''unenek', 'Alwa'' bats''udh', 'Kit wat''ey');

-- nivel 1 · unidad 2: despedidas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 2
and v.word in ('Tayej ku tsu''uxinej', 'Kit k''alej alwa''', 'Alwa''', 'Kalám');

-- nivel 1 · unidad 3: cómo te llamas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 3
and v.word in ('Naná''', 'Tatá''', 'Jajá''', 'Bij', 'Naná'' u bij', '¿Jantij a bij?');

-- nivel 1 · unidad 4: agradecer y responder
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 4
and v.word in ('K''ak''námal', 'Lej k''ak''námal yán', 'Yán', 'Antsaná''', 'Yab');

-- nivel 1 · unidad 5: cortesía
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 5
and v.word in ('Pakwlanchij yán', 'Kit k''apúts alwa''', 'Wanaj ku t''ojon kulbél', 'Kit wat''ey');

-- nivel 1 · unidad 6: conversación básica
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 6
and v.word in ('Tének', 'Kawintaláb', '¿Jantom kawintaláb an kawnal?', 'Tajk''anenek', '¿Jantij a bij?', 'Naná'' u bij', 'K''ak''námal', 'Tayej ku tsu''uxinej', 'Alwa''');

-- nivel 2 · unidad 1: pronombres personales
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 1
and v.word in ('Wawá''', 'Tatá''chik', 'Jajáchik', 'Inik', 'Uxum', 'Inikchik', 'Naná''', 'Tatá''', 'Jajá''');

-- nivel 2 · unidad 2: la familia
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 2
and v.word in ('Táta''', 'Mím', 'Kwitól', 'Ani', 'Ixám');

-- nivel 2 · unidad 3: los abuelos y los tíos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 3
and v.word in ('Mám', 'Ách', 'Itsán', 'Tsanub', 'Epchal', 'Ani');

-- nivel 2 · unidad 4: cómo es
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 4
and v.word in ('Púlik', 'Tsakam', 'Ít', 'Alabél', 'Kidhab', 'Nakat', 'Alwa''');

-- nivel 2 · unidad 5: los colores
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 5
and v.word in ('Tsakni''', 'Dhakni''', 'T''unu''', 'Yaxu''', 'Manu''');

-- nivel 2 · unidad 6: contar del uno al cinco
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 6
and v.word in ('Jún', 'Tsáb', 'Óx', 'Ché''', 'Bó''', 'Ja''úb', 'Táta''', 'Mím');

-- nivel 3 · unidad 1: palabras para preguntar
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 1
and v.word in ('Jantom', 'Jantij', 'Juta', 'Jay', 'Jachan');

-- nivel 3 · unidad 2: mi casa y mi comunidad
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 2
and v.word in ('Atáj', 'Kwentsal', 'Nu kwentsál', 'Na k''imá''', '¿Jachana k''imá?', 'Jachan');

-- nivel 3 · unidad 3: contar del seis al diez
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 3
and v.word in ('Akak', 'Búk', 'Waxik', 'Beléw', 'Laju''', 'Jún inik', 'Jún', 'Inik');

-- nivel 3 · unidad 4: lugares y cosas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 4
and v.word in ('Alté''', 'Mom', 'Ja''', 'Tumín', 'Úw', 'Takab');

-- nivel 3 · unidad 5: cerca y lejos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 5
and v.word in ('Utat', 'Ów', 'Alal', 'Ok''ox', 'Putat', 'Juta');

-- nivel 3 · unidad 6: preguntas útiles
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 6
and v.word in ('An', '¿Jantij in bij na kwentsalíl?', '¿Jantom kawintaláb an kawnal?', 'Kwentsal', 'Jantij', 'Jantom', 'Tének');

-- nivel 4 · unidad 1: hoy, ayer y mañana
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 1
and v.word in ('Xowé''', 'We''él', 'K''icháj', 'Akal', 'K''ij', 'Tamub', 'Kalám');

-- nivel 4 · unidad 2: la naturaleza
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 2
and v.word in ('Its''', 'Ik''', 'Lem', 'Tsunun', 'Ts''itsin', 'Alté''');

-- nivel 4 · unidad 3: lo que hago
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 3
and v.word in ('In atsim', 'In kalel', 'Naná'' im belal', 'Ne''ech ban nu kwentsál', 'Nu kwentsál');

-- nivel 4 · unidad 4: lo que pasó
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 4
and v.word in ('U lejkiy an bakan', 'Bakan', 'Tatá'' tey i t''ojon', 'Tsekets an bichim', 'Bichim', 'Wat''ey', 'An');

-- nivel 4 · unidad 5: ahora y después
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 5
and v.word in ('Exom tu dhuchum', 'Dhuchum', 'Ne''ets ku ayin', 'T''ojnal', 'T''ojlab');

-- nivel 4 · unidad 6: repaso del tiempo
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 6
and v.word in ('Ulits', 'Ach''a''', 'Xowé''', 'We''él', 'Kalám', 'In kalel', 'U lejkiy an bakan', 'Exom tu dhuchum');

-- nivel 5 · unidad 1: la comida
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 1
and v.word in ('Idhidh', 'Ajan', 'Tsanak''w', 'Its', 'K''apnél', 'Bakan');

-- nivel 5 · unidad 2: frutas y plantas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 2
and v.word in ('Lanáx', 'Uj', 'Utsun', 'Pakab', 'Pak''ak''', 'Way''');

-- nivel 5 · unidad 3: en la cocina
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 3
and v.word in ('Kapéj', 'Tay''', 'Kuchil', 'Mexa', 'Ja''', 'Takab');

-- nivel 5 · unidad 4: acciones del día
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 4
and v.word in ('K''apul', 'Uts''ál', 'Wayal', 'Met''ál', 'Pidhál', 'Belal');

-- nivel 5 · unidad 5: trabajos de la casa
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 5
and v.word in ('U nujuwal an lanax', 'U kitnál an dhi''', 'Dhi''', '¡Ka k''wetoy na k''imá''!', 'K''wet', 'Xabún', 'Na k''imá''');

-- nivel 5 · unidad 6: caliente y frío
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 6
and v.word in ('K''ak''', 'Chamay', 'Ts''a''ik', 'T''apay', 'Tolow', 'Kapéj');

-- nivel 6 · unidad 1: animales del monte
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 1
and v.word in ('Koy', 'Chuch', 'Itxamal', 'Edhem', 'Ot''el', 'Bat''aw');

-- nivel 6 · unidad 2: animales de la casa
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 2
and v.word in ('Pik''o''', 'Mitsu''', 'Koxol', 'Ch''uri''', 'Nu pik''oil', 'Yaxk''wa''', 'Bichim');

-- nivel 6 · unidad 3: el cuerpo
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 3
and v.word in ('Ok''', 'K''ubak', 'Akan', 'Wal', 'Wi''', 'Okob', 'Txukul');

-- nivel 6 · unidad 4: lo que quiero y lo que tengo
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 4
and v.word in ('Le''', 'Kó''ol', 'Xumpelel', 'Belal atáj', 'Tumín');

-- nivel 6 · unidad 5: expresiones
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 5
and v.word in ('¡Abél junt''aj xu bixnél!', 'Tének Tsabál', 'Tampots''ots''', 'Labtóm', 'Tének');

-- nivel 6 · unidad 6: conversación final
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 6
and v.word in ('Tajk''anenek', 'Naná'' u bij', 'Táta''', 'Mím', 'Bakan', 'Koy', 'Pik''o''', 'Lej k''ak''námal yán', 'Kit k''alej alwa''');

-- ─────────────────────────────────────────────
--  6. ejercicios (6 por unidad: 4 opción múltiple + 2 completar)
-- ─────────────────────────────────────────────
-- nivel 1 · unidad 1: saludos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buenos días',
       '["Tajk''anenek"]',
       '["Alwa''", "Dhamk''unenek", "Naná''", "Tajk''anenek"]',
       'citlali',
       'Tajk''anenek significa buenos días',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buenas tardes',
       '["Waklenenek"]',
       '["Bij", "Jajá''", "Waklenenek", "Naná''"]',
       'coltzin',
       'Waklenenek significa buenas tardes',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buenas noches',
       '["Dhamk''unenek"]',
       '["Tajk''anenek", "Alwa''", "Waklenenek", "Dhamk''unenek"]',
       'neza',
       'Dhamk''unenek significa buenas noches',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Bienvenido(a)',
       '["Alwa'' bats''udh"]',
       '["Alwa'' bats''udh", "Lej k''ak''námal yán", "Kit k''alej alwa''", "Kit k''apúts alwa''"]',
       'tonatiuh',
       'Alwa'' bats''udh significa bienvenido(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ bats''udh',
       '["Alwa''", "Alwa'' bats''udh"]',
       null,
       'xochitl',
       'Alwa'' bats''udh significa bienvenido(a)',
       20, 'medium',
       'Bienvenido(a)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kit ______',
       '["wat''ey", "Kit wat''ey"]',
       null,
       'citlali',
       'Kit wat''ey significa pasa / adelante',
       20, 'medium',
       'Pasa'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 1;

-- nivel 1 · unidad 2: despedidas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Bien',
       '["Alwa''"]',
       '["Dhamk''unenek", "Tatá''", "Waklenenek", "Alwa''"]',
       'coltzin',
       'Alwa'' significa bien / bueno',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mañana',
       '["Kalám"]',
       '["Kalám", "Jajá''", "Tajk''anenek", "Naná''"]',
       'neza',
       'Kalám significa mañana',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hasta luego',
       '["Tayej ku tsu''uxinej"]',
       '["Pakwlanchij yán", "Kit wat''ey", "Tayej ku tsu''uxinej", "Lej k''ak''námal yán"]',
       'tonatiuh',
       'Tayej ku tsu''uxinej significa hasta luego / nos vemos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Que te vaya bien',
       '["Kit k''alej alwa''"]',
       '["Pakwlanchij yán", "Naná'' u bij", "Lej k''ak''námal yán", "Kit k''alej alwa''"]',
       'xochitl',
       'Kit k''alej alwa'' significa que te vaya bien',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ ku tsu''uxinej',
       '["Tayej", "Tayej ku tsu''uxinej"]',
       null,
       'citlali',
       'Tayej ku tsu''uxinej significa hasta luego / nos vemos',
       20, 'medium',
       'Hasta luego'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kit k''alej ______',
       '["alwa''", "Kit k''alej alwa''"]',
       null,
       'coltzin',
       'Kit k''alej alwa'' significa que te vaya bien',
       20, 'medium',
       'Que te vaya bien'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 2;

-- nivel 1 · unidad 3: cómo te llamas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Yo',
       '["Naná''"]',
       '["Naná''", "Tajk''anenek", "Jajá''", "Waklenenek"]',
       'neza',
       'Naná'' significa yo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tú',
       '["Tatá''"]',
       '["Alwa''", "Tajk''anenek", "Waklenenek", "Tatá''"]',
       'tonatiuh',
       'Tatá'' significa tú',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Él',
       '["Jajá''"]',
       '["Naná''", "Bij", "Alwa''", "Jajá''"]',
       'xochitl',
       'Jajá'' significa él / ella',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nombre',
       '["Bij"]',
       '["Tatá''", "Tajk''anenek", "Bij", "Kalám"]',
       'citlali',
       'Bij significa nombre',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ u bij',
       '["Naná''", "Naná'' u bij"]',
       null,
       'coltzin',
       'Naná'' u bij significa yo me llamo (lit. yo, mi nombre)',
       20, 'medium',
       'Yo me llamo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '¿Jantij a ______?',
       '["bij", "Jantij a bij", "¿Jantij a bij?"]',
       null,
       'neza',
       '¿Jantij a bij? significa ¿cómo te llamas?',
       20, 'medium',
       '¿Cómo te llamas?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 3;

-- nivel 1 · unidad 4: agradecer y responder
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Gracias',
       '["K''ak''námal"]',
       '["K''ak''námal", "Kalám", "Waklenenek", "Dhamk''unenek"]',
       'tonatiuh',
       'K''ak''námal significa gracias',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mucho',
       '["Yán"]',
       '["Yán", "Kalám", "Waklenenek", "Dhamk''unenek"]',
       'xochitl',
       'Yán significa mucho',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Sí',
       '["Antsaná''"]',
       '["Tajk''anenek", "Yab", "Alwa''", "Antsaná''"]',
       'citlali',
       'Antsaná'' significa sí / así es',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'No',
       '["Yab"]',
       '["Alwa''", "Yab", "Kalám", "Waklenenek"]',
       'coltzin',
       'Yab significa no',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ k''ak''námal yán',
       '["Lej", "Lej k''ak''námal yán"]',
       null,
       'neza',
       'Lej k''ak''námal yán significa muchas gracias',
       20, 'medium',
       'Muchas gracias'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______k''námal',
       '["K''a", "K''ak''námal"]',
       null,
       'tonatiuh',
       'K''ak''námal significa gracias',
       20, 'medium',
       'Gracias'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 4;

-- nivel 1 · unidad 5: cortesía
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Con permiso',
       '["Pakwlanchij yán"]',
       '["Pakwlanchij yán", "Tayej ku tsu''uxinej", "Kit k''alej alwa''", "Alwa'' bats''udh"]',
       'xochitl',
       'Pakwlanchij yán significa con permiso / disculpa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buen provecho',
       '["Kit k''apúts alwa''"]',
       '["Kit k''alej alwa''", "Tayej ku tsu''uxinej", "Naná'' u bij", "Kit k''apúts alwa''"]',
       'citlali',
       'Kit k''apúts alwa'' significa buen provecho',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Disfrutemos este encuentro',
       '["Wanaj ku t''ojon kulbél"]',
       '["Wanaj ku t''ojon kulbél", "¿Jantij a bij?", "Naná'' u bij", "Pakwlanchij yán"]',
       'coltzin',
       'Wanaj ku t''ojon kulbél significa disfrutemos este encuentro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pasa',
       '["Kit wat''ey"]',
       '["Kit k''apúts alwa''", "¿Jantij a bij?", "Kit wat''ey", "Alwa'' bats''udh"]',
       'neza',
       'Kit wat''ey significa pasa / adelante',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ yán',
       '["Pakwlanchij", "Pakwlanchij yán"]',
       null,
       'tonatiuh',
       'Pakwlanchij yán significa con permiso / disculpa',
       20, 'medium',
       'Con permiso'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kit k''apúts ______',
       '["alwa''", "Kit k''apúts alwa''"]',
       null,
       'xochitl',
       'Kit k''apúts alwa'' significa buen provecho',
       20, 'medium',
       'Buen provecho'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 5;

-- nivel 1 · unidad 6: conversación básica
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tének (pueblo y lengua)',
       '["Tének"]',
       '["Tének", "Kawintaláb", "K''ak''námal", "Naná''"]',
       'citlali',
       'Tének significa tének (pueblo y lengua)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lengua',
       '["Kawintaláb"]',
       '["Alwa''", "K''ak''námal", "Tének", "Kawintaláb"]',
       'coltzin',
       'Kawintaláb significa lengua / palabra',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Qué lengua hablas?',
       '["¿Jantom kawintaláb an kawnal?"]',
       '["Pakwlanchij yán", "Kit wat''ey", "¿Jantom kawintaláb an kawnal?", "Naná'' u bij"]',
       'neza',
       '¿Jantom kawintaláb an kawnal? significa ¿qué lengua hablas?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buenos días',
       '["Tajk''anenek"]',
       '["Waklenenek", "Kalám", "Tajk''anenek", "Dhamk''unenek"]',
       'tonatiuh',
       'Tajk''anenek significa buenos días',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '¿______ kawintaláb an kawnal?',
       '["Jantom", "Jantom kawintaláb an kawnal", "¿Jantom kawintaláb an kawnal?"]',
       null,
       'xochitl',
       '¿Jantom kawintaláb an kawnal? significa ¿qué lengua hablas?',
       20, 'medium',
       '¿Qué lengua hablas?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '¿Jantij a ______?',
       '["bij", "Jantij a bij", "¿Jantij a bij?"]',
       null,
       'citlali',
       '¿Jantij a bij? significa ¿cómo te llamas?',
       20, 'medium',
       '¿Cómo te llamas?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 1 and u.unit_num = 6;

-- nivel 2 · unidad 1: pronombres personales
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nosotros(as)',
       '["Wawá''"]',
       '["Naná''", "Wawá''", "Jajá''", "Inikchik"]',
       'coltzin',
       'Wawá'' significa nosotros(as)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ustedes',
       '["Tatá''chik"]',
       '["Tatá''chik", "Inikchik", "Jajá''", "Uxum"]',
       'neza',
       'Tatá''chik significa ustedes',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ellos',
       '["Jajáchik"]',
       '["Uxum", "Naná''", "Jajáchik", "Tatá''chik"]',
       'tonatiuh',
       'Jajáchik significa ellos / ellas',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hombre',
       '["Inik"]',
       '["Uxum", "Inik", "Tatá''chik", "Tatá''"]',
       'xochitl',
       'Inik significa hombre',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______awá''',
       '["W", "Wawá''"]',
       null,
       'citlali',
       'Wawá'' significa nosotros(as)',
       20, 'medium',
       'Nosotros(as)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______tá''chik',
       '["Ta", "Tatá''chik"]',
       null,
       'coltzin',
       'Tatá''chik significa ustedes',
       20, 'medium',
       'Ustedes'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 1;

-- nivel 2 · unidad 2: la familia
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Papá',
       '["Táta''"]',
       '["Mím", "Ixám", "Kwitól", "Táta''"]',
       'neza',
       'Táta'' significa papá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mamá',
       '["Mím"]',
       '["Mím", "Inik", "Táta''", "Wawá''"]',
       'tonatiuh',
       'Mím significa mamá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Niño(a)',
       '["Kwitól"]',
       '["Ani", "Kwitól", "Inik", "Táta''"]',
       'xochitl',
       'Kwitól significa niño(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Y',
       '["Ani"]',
       '["Ani", "Wawá''", "Jajáchik", "Kwitól"]',
       'citlali',
       'Ani significa y',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______áta''',
       '["T", "Táta''"]',
       null,
       'coltzin',
       'Táta'' significa papá',
       20, 'medium',
       'Papá'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______itól',
       '["Kw", "Kwitól"]',
       null,
       'neza',
       'Kwitól significa niño(a)',
       20, 'medium',
       'Niño(a)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 2;

-- nivel 2 · unidad 3: los abuelos y los tíos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Abuelo',
       '["Mám"]',
       '["Itsán", "Jajáchik", "Ani", "Mám"]',
       'tonatiuh',
       'Mám significa abuelo / anciano',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Abuela',
       '["Ách"]',
       '["Wawá''", "Itsán", "Ách", "Mám"]',
       'xochitl',
       'Ách significa abuela',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tío',
       '["Itsán"]',
       '["Tatá''chik", "Itsán", "Wawá''", "Jajáchik"]',
       'citlali',
       'Itsán significa tío',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tía',
       '["Tsanub"]',
       '["Ani", "Tsanub", "Wawá''", "Itsán"]',
       'coltzin',
       'Tsanub significa tía',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______tsán',
       '["I", "Itsán"]',
       null,
       'neza',
       'Itsán significa tío',
       20, 'medium',
       'Tío'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______anub',
       '["Ts", "Tsanub"]',
       null,
       'tonatiuh',
       'Tsanub significa tía',
       20, 'medium',
       'Tía'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 3;

-- nivel 2 · unidad 4: cómo es
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Grande',
       '["Púlik"]',
       '["Púlik", "Alwa''", "Alabél", "Ít"]',
       'xochitl',
       'Púlik significa grande',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pequeño(a)',
       '["Tsakam"]',
       '["Tatá''chik", "Tsakam", "Wawá''", "Púlik"]',
       'citlali',
       'Tsakam significa pequeño(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nuevo(a)',
       '["Ít"]',
       '["Ít", "Tsakam", "Alwa''", "Alabél"]',
       'coltzin',
       'Ít significa nuevo(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Bonito(a)',
       '["Alabél"]',
       '["Alabél", "Nakat", "Tsakam", "Kidhab"]',
       'neza',
       'Alabél significa bonito(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______úlik',
       '["P", "Púlik"]',
       null,
       'tonatiuh',
       'Púlik significa grande',
       20, 'medium',
       'Grande'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______akam',
       '["Ts", "Tsakam"]',
       null,
       'xochitl',
       'Tsakam significa pequeño(a)',
       20, 'medium',
       'Pequeño(a)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 4;

-- nivel 2 · unidad 5: los colores
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Rojo',
       '["Tsakni''"]',
       '["Inik", "Wawá''", "Tsakni''", "Dhakni''"]',
       'citlali',
       'Tsakni'' significa rojo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Blanco',
       '["Dhakni''"]',
       '["Dhakni''", "Manu''", "Tsakni''", "Jajáchik"]',
       'coltzin',
       'Dhakni'' significa blanco',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Negro',
       '["T''unu''"]',
       '["Wawá''", "Tatá''chik", "T''unu''", "Jajáchik"]',
       'neza',
       'T''unu'' significa negro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Verde',
       '["Yaxu''"]',
       '["Inik", "Wawá''", "Yaxu''", "T''unu''"]',
       'tonatiuh',
       'Yaxu'' significa verde',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______kni''',
       '["Tsa", "Tsakni''"]',
       null,
       'xochitl',
       'Tsakni'' significa rojo',
       20, 'medium',
       'Rojo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______kni''',
       '["Dha", "Dhakni''"]',
       null,
       'citlali',
       'Dhakni'' significa blanco',
       20, 'medium',
       'Blanco'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 5;

-- nivel 2 · unidad 6: contar del uno al cinco
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Uno',
       '["Jún"]',
       '["Bó''", "Jún", "Ché''", "Ja''úb"]',
       'coltzin',
       'Jún significa uno',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dos',
       '["Tsáb"]',
       '["Mím", "Ché''", "Óx", "Tsáb"]',
       'neza',
       'Tsáb significa dos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tres',
       '["Óx"]',
       '["Tsáb", "Óx", "Jún", "Táta''"]',
       'tonatiuh',
       'Óx significa tres',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cuatro',
       '["Ché''"]',
       '["Tsáb", "Ché''", "Óx", "Ja''úb"]',
       'xochitl',
       'Ché'' significa cuatro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______áb',
       '["Ts", "Tsáb"]',
       null,
       'citlali',
       'Tsáb significa dos',
       20, 'medium',
       'Dos'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______é''',
       '["Ch", "Ché''"]',
       null,
       'coltzin',
       'Ché'' significa cuatro',
       20, 'medium',
       'Cuatro'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 2 and u.unit_num = 6;

-- nivel 3 · unidad 1: palabras para preguntar
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Qué',
       '["Jantom"]',
       '["Juta", "Jantom", "Atáj", "Jay"]',
       'neza',
       'Jantom significa qué',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cómo',
       '["Jantij"]',
       '["Jantom", "Jachan", "Jantij", "Jay"]',
       'tonatiuh',
       'Jantij significa cómo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dónde',
       '["Juta"]',
       '["Jantij", "Jantom", "Juta", "Búk"]',
       'xochitl',
       'Juta significa dónde',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cuánto',
       '["Jay"]',
       '["Jachan", "Juta", "Kwentsal", "Jay"]',
       'citlali',
       'Jay significa cuánto',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ntom',
       '["Ja", "Jantom"]',
       null,
       'coltzin',
       'Jantom significa qué',
       20, 'medium',
       'Qué'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ntij',
       '["Ja", "Jantij"]',
       null,
       'neza',
       'Jantij significa cómo',
       20, 'medium',
       'Cómo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 1;

-- nivel 3 · unidad 2: mi casa y mi comunidad
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Casa',
       '["Atáj"]',
       '["Jantij", "Atáj", "Juta", "Búk"]',
       'tonatiuh',
       'Atáj significa casa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Comunidad',
       '["Kwentsal"]',
       '["Kwentsal", "Juta", "Jay", "Akak"]',
       'xochitl',
       'Kwentsal significa comunidad',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi comunidad',
       '["Nu kwentsál"]',
       '["¿Jachana k''imá?", "Na k''imá''", "Jún inik", "Nu kwentsál"]',
       'citlali',
       'Nu kwentsál significa mi comunidad',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tu casa',
       '["Na k''imá''"]',
       '["Na k''imá''", "Nu kwentsál", "Jún inik", "¿Jantij in bij na kwentsalíl?"]',
       'coltzin',
       'Na k''imá'' significa tu casa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ kwentsál',
       '["Nu", "Nu kwentsál"]',
       null,
       'neza',
       'Nu kwentsál significa mi comunidad',
       20, 'medium',
       'Mi comunidad'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Na ______',
       '["k''imá''", "Na k''imá''"]',
       null,
       'tonatiuh',
       'Na k''imá'' significa tu casa',
       20, 'medium',
       'Tu casa'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 2;

-- nivel 3 · unidad 3: contar del seis al diez
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Seis',
       '["Akak"]',
       '["Beléw", "Akak", "Jún", "Búk"]',
       'xochitl',
       'Akak significa seis',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Siete',
       '["Búk"]',
       '["Waxik", "Jantij", "Jún", "Búk"]',
       'citlali',
       'Búk significa siete',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ocho',
       '["Waxik"]',
       '["Jantij", "Beléw", "Waxik", "Jún"]',
       'coltzin',
       'Waxik significa ocho',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nueve',
       '["Beléw"]',
       '["Jantij", "Beléw", "Waxik", "Laju''"]',
       'neza',
       'Beléw significa nueve',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ inik',
       '["Jún", "Jún inik"]',
       null,
       'tonatiuh',
       'Jún inik significa veinte',
       20, 'medium',
       'Veinte'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______kak',
       '["A", "Akak"]',
       null,
       'xochitl',
       'Akak significa seis',
       20, 'medium',
       'Seis'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 3;

-- nivel 3 · unidad 4: lugares y cosas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Monte',
       '["Alté''"]',
       '["Ja''", "Jantom", "Alté''", "Jantij"]',
       'citlali',
       'Alté'' significa monte',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pozo',
       '["Mom"]',
       '["Ja''", "Tumín", "Mom", "Jantij"]',
       'coltzin',
       'Mom significa pozo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Agua',
       '["Ja''"]',
       '["Ja''", "Juta", "Takab", "Úw"]',
       'neza',
       'Ja'' significa agua',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dinero',
       '["Tumín"]',
       '["Ja''", "Jantom", "Takab", "Tumín"]',
       'tonatiuh',
       'Tumín significa dinero',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______lté''',
       '["A", "Alté''"]',
       null,
       'xochitl',
       'Alté'' significa monte',
       20, 'medium',
       'Monte'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______umín',
       '["T", "Tumín"]',
       null,
       'citlali',
       'Tumín significa dinero',
       20, 'medium',
       'Dinero'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 4;

-- nivel 3 · unidad 5: cerca y lejos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cerca',
       '["Utat"]',
       '["Juta", "Jantom", "Utat", "Ok''ox"]',
       'coltzin',
       'Utat significa cerca',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lejos',
       '["Ów"]',
       '["Utat", "Ów", "Jay", "Putat"]',
       'neza',
       'Ów significa lejos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Abajo',
       '["Alal"]',
       '["Alal", "Ok''ox", "Jantom", "Jantij"]',
       'tonatiuh',
       'Alal significa abajo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Primero',
       '["Ok''ox"]',
       '["Ok''ox", "Ów", "Jantom", "Jantij"]',
       'xochitl',
       'Ok''ox significa primero',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______tat',
       '["U", "Utat"]',
       null,
       'citlali',
       'Utat significa cerca',
       20, 'medium',
       'Cerca'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______lal',
       '["A", "Alal"]',
       null,
       'coltzin',
       'Alal significa abajo',
       20, 'medium',
       'Abajo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 5;

-- nivel 3 · unidad 6: preguntas útiles
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'El',
       '["An"]',
       '["Atáj", "Tének", "An", "Juta"]',
       'neza',
       'An significa el / la',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cómo se llama tu comunidad?',
       '["¿Jantij in bij na kwentsalíl?"]',
       '["Jún inik", "Nu kwentsál", "¿Jachana k''imá?", "¿Jantij in bij na kwentsalíl?"]',
       'tonatiuh',
       '¿Jantij in bij na kwentsalíl? significa ¿cómo se llama tu comunidad?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Qué lengua hablas?',
       '["¿Jantom kawintaláb an kawnal?"]',
       '["¿Jantom kawintaláb an kawnal?", "Jún inik", "¿Jantij in bij na kwentsalíl?", "Nu kwentsál"]',
       'xochitl',
       '¿Jantom kawintaláb an kawnal? significa ¿qué lengua hablas?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Comunidad',
       '["Kwentsal"]',
       '["Jantom", "Jay", "Jachan", "Kwentsal"]',
       'citlali',
       'Kwentsal significa comunidad',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '¿______ in bij na kwentsalíl?',
       '["Jantij", "Jantij in bij na kwentsalíl", "¿Jantij in bij na kwentsalíl?"]',
       null,
       'coltzin',
       '¿Jantij in bij na kwentsalíl? significa ¿cómo se llama tu comunidad?',
       20, 'medium',
       '¿Cómo se llama tu comunidad?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '¿Jantom kawintaláb an ______?',
       '["kawnal", "Jantom kawintaláb an kawnal", "¿Jantom kawintaláb an kawnal?"]',
       null,
       'neza',
       '¿Jantom kawintaláb an kawnal? significa ¿qué lengua hablas?',
       20, 'medium',
       '¿Qué lengua hablas?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 3 and u.unit_num = 6;

-- nivel 4 · unidad 1: hoy, ayer y mañana
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hoy',
       '["Xowé''"]',
       '["Ik''", "Xowé''", "Tamub", "We''él"]',
       'tonatiuh',
       'Xowé'' significa hoy',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ayer',
       '["We''él"]',
       '["We''él", "Xowé''", "K''icháj", "Ik''"]',
       'xochitl',
       'We''él significa ayer',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Día',
       '["K''icháj"]',
       '["Xowé''", "Kalám", "K''icháj", "Tamub"]',
       'citlali',
       'K''icháj significa día / sol',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Noche',
       '["Akal"]',
       '["K''icháj", "Tamub", "Akal", "Ik''"]',
       'coltzin',
       'Akal significa noche',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______owé''',
       '["X", "Xowé''"]',
       null,
       'neza',
       'Xowé'' significa hoy',
       20, 'medium',
       'Hoy'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______e''él',
       '["W", "We''él"]',
       null,
       'tonatiuh',
       'We''él significa ayer',
       20, 'medium',
       'Ayer'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 1;

-- nivel 4 · unidad 2: la naturaleza
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Luna',
       '["Its''"]',
       '["We''él", "Ts''itsin", "Xowé''", "Its''"]',
       'xochitl',
       'Its'' significa luna / mes',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Aire',
       '["Ik''"]',
       '["Alté''", "Ik''", "Tsunun", "We''él"]',
       'citlali',
       'Ik'' significa aire / viento',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mariposa',
       '["Lem"]',
       '["Alté''", "K''icháj", "Lem", "Tsunun"]',
       'coltzin',
       'Lem significa mariposa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Colibrí',
       '["Tsunun"]',
       '["Alté''", "Xowé''", "Ik''", "Tsunun"]',
       'neza',
       'Tsunun significa colibrí',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ts''',
       '["I", "Its''"]',
       null,
       'tonatiuh',
       'Its'' significa luna / mes',
       20, 'medium',
       'Luna'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______unun',
       '["Ts", "Tsunun"]',
       null,
       'xochitl',
       'Tsunun significa colibrí',
       20, 'medium',
       'Colibrí'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 2;

-- nivel 4 · unidad 3: lo que hago
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me baño',
       '["In atsim"]',
       '["Naná'' im belal", "In atsim", "Ne''ech ban nu kwentsál", "Tatá'' tey i t''ojon"]',
       'citlali',
       'In atsim significa me baño',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Salgo',
       '["In kalel"]',
       '["Ne''ech ban nu kwentsál", "In atsim", "In kalel", "Exom tu dhuchum"]',
       'coltzin',
       'In kalel significa salgo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Yo camino',
       '["Naná'' im belal"]',
       '["Tsekets an bichim", "Naná'' im belal", "U lejkiy an bakan", "Ne''ech ban nu kwentsál"]',
       'neza',
       'Naná'' im belal significa yo camino',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Voy a mi comunidad',
       '["Ne''ech ban nu kwentsál"]',
       '["Tatá'' tey i t''ojon", "Tsekets an bichim", "Nu kwentsál", "Ne''ech ban nu kwentsál"]',
       'tonatiuh',
       'Ne''ech ban nu kwentsál significa voy a mi comunidad',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ atsim',
       '["In", "In atsim"]',
       null,
       'xochitl',
       'In atsim significa me baño',
       20, 'medium',
       'Me baño'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'In ______',
       '["kalel", "In kalel"]',
       null,
       'citlali',
       'In kalel significa salgo',
       20, 'medium',
       'Salgo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 3;

-- nivel 4 · unidad 4: lo que pasó
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tortilla',
       '["Bakan"]',
       '["K''icháj", "Xowé''", "Bakan", "K''ij"]',
       'coltzin',
       'Bakan significa tortilla',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Caballo',
       '["Bichim"]',
       '["Xowé''", "Bichim", "Wat''ey", "Akal"]',
       'neza',
       'Bichim significa caballo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pasó',
       '["Wat''ey"]',
       '["Wat''ey", "Xowé''", "An", "K''ij"]',
       'tonatiuh',
       'Wat''ey significa pasó',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Preparé la tortilla',
       '["U lejkiy an bakan"]',
       '["In atsim", "U lejkiy an bakan", "Tsekets an bichim", "Exom tu dhuchum"]',
       'xochitl',
       'U lejkiy an bakan significa preparé la tortilla',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ lejkiy an bakan',
       '["U", "U lejkiy an bakan"]',
       null,
       'citlali',
       'U lejkiy an bakan significa preparé la tortilla',
       20, 'medium',
       'Preparé la tortilla'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tatá'' tey i ______',
       '["t''ojon", "Tatá'' tey i t''ojon"]',
       null,
       'coltzin',
       'Tatá'' tey i t''ojon significa tú también trabajaste',
       20, 'medium',
       'Tú también trabajaste'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 4;

-- nivel 4 · unidad 5: ahora y después
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Escribir',
       '["Dhuchum"]',
       '["Dhuchum", "Akal", "K''ij", "Xowé''"]',
       'neza',
       'Dhuchum significa escribir',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajar',
       '["T''ojnal"]',
       '["T''ojnal", "T''ojlab", "Tamub", "We''él"]',
       'tonatiuh',
       'T''ojnal significa trabajar',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajo',
       '["T''ojlab"]',
       '["T''ojlab", "Dhuchum", "Akal", "K''ij"]',
       'xochitl',
       'T''ojlab significa trabajo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estamos escribiendo',
       '["Exom tu dhuchum"]',
       '["Tsekets an bichim", "Ne''ech ban nu kwentsál", "Exom tu dhuchum", "In atsim"]',
       'citlali',
       'Exom tu dhuchum significa estamos escribiendo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ tu dhuchum',
       '["Exom", "Exom tu dhuchum"]',
       null,
       'coltzin',
       'Exom tu dhuchum significa estamos escribiendo',
       20, 'medium',
       'Estamos escribiendo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ne''ets ku ______',
       '["ayin", "Ne''ets ku ayin"]',
       null,
       'neza',
       'Ne''ets ku ayin significa regresaremos a casa',
       20, 'medium',
       'Regresaremos a casa'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 5;

-- nivel 4 · unidad 6: repaso del tiempo
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Llegar',
       '["Ulits"]',
       '["Ulits", "Ach''a''", "We''él", "K''icháj"]',
       'tonatiuh',
       'Ulits significa llegar',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Escuchar',
       '["Ach''a''"]',
       '["Ach''a''", "K''ij", "Ulits", "Kalám"]',
       'xochitl',
       'Ach''a'' significa escuchar',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hoy',
       '["Xowé''"]',
       '["Akal", "Xowé''", "Ulits", "Tamub"]',
       'citlali',
       'Xowé'' significa hoy',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ayer',
       '["We''él"]',
       '["Akal", "K''ij", "We''él", "Xowé''"]',
       'coltzin',
       'We''él significa ayer',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ kalel',
       '["In", "In kalel"]',
       null,
       'neza',
       'In kalel significa salgo',
       20, 'medium',
       'Salgo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'U lejkiy an ______',
       '["bakan", "U lejkiy an bakan"]',
       null,
       'tonatiuh',
       'U lejkiy an bakan significa preparé la tortilla',
       20, 'medium',
       'Preparé la tortilla'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 4 and u.unit_num = 6;

-- nivel 5 · unidad 1: la comida
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Maíz',
       '["Idhidh"]',
       '["Utsun", "Its", "Idhidh", "Ajan"]',
       'xochitl',
       'Idhidh significa maíz',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Elote',
       '["Ajan"]',
       '["Utsun", "Ajan", "Uj", "K''apnél"]',
       'citlali',
       'Ajan significa elote',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Frijol',
       '["Tsanak''w"]',
       '["Ajan", "Idhidh", "Uj", "Tsanak''w"]',
       'coltzin',
       'Tsanak''w significa frijol',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Chile',
       '["Its"]',
       '["Its", "Lanáx", "Idhidh", "Ajan"]',
       'neza',
       'Its significa chile',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______dhidh',
       '["I", "Idhidh"]',
       null,
       'tonatiuh',
       'Idhidh significa maíz',
       20, 'medium',
       'Maíz'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______jan',
       '["A", "Ajan"]',
       null,
       'xochitl',
       'Ajan significa elote',
       20, 'medium',
       'Elote'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 1;

-- nivel 5 · unidad 2: frutas y plantas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Naranja',
       '["Lanáx"]',
       '["Way''", "Lanáx", "Uj", "Idhidh"]',
       'citlali',
       'Lanáx significa naranja',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Aguacate',
       '["Uj"]',
       '["Tsanak''w", "Uj", "Pakab", "Utsun"]',
       'coltzin',
       'Uj significa aguacate',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Papaya',
       '["Utsun"]',
       '["Tsanak''w", "Pakab", "Idhidh", "Utsun"]',
       'neza',
       'Utsun significa papaya',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Caña',
       '["Pakab"]',
       '["Ajan", "Pakab", "Utsun", "Lanáx"]',
       'tonatiuh',
       'Pakab significa caña',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______anáx',
       '["L", "Lanáx"]',
       null,
       'xochitl',
       'Lanáx significa naranja',
       20, 'medium',
       'Naranja'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______tsun',
       '["U", "Utsun"]',
       null,
       'citlali',
       'Utsun significa papaya',
       20, 'medium',
       'Papaya'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 2;

-- nivel 5 · unidad 3: en la cocina
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Café',
       '["Kapéj"]',
       '["Kapéj", "Takab", "Idhidh", "Mexa"]',
       'coltzin',
       'Kapéj significa café',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cal',
       '["Tay''"]',
       '["Tay''", "Mexa", "Idhidh", "Ajan"]',
       'neza',
       'Tay'' significa cal',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cuchillo',
       '["Kuchil"]',
       '["Mexa", "Idhidh", "Ajan", "Kuchil"]',
       'tonatiuh',
       'Kuchil significa cuchillo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mesa',
       '["Mexa"]',
       '["Mexa", "Ja''", "Kuchil", "Kapéj"]',
       'xochitl',
       'Mexa significa mesa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______apéj',
       '["K", "Kapéj"]',
       null,
       'citlali',
       'Kapéj significa café',
       20, 'medium',
       'Café'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ay''',
       '["T", "Tay''"]',
       null,
       'coltzin',
       'Tay'' significa cal',
       20, 'medium',
       'Cal'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 3;

-- nivel 5 · unidad 4: acciones del día
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Comer',
       '["K''apul"]',
       '["Met''ál", "K''apul", "Pidhál", "Ajan"]',
       'neza',
       'K''apul significa comer',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Beber',
       '["Uts''ál"]',
       '["Pidhál", "K''apul", "Ajan", "Uts''ál"]',
       'tonatiuh',
       'Uts''ál significa beber',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dormir',
       '["Wayal"]',
       '["Wayal", "K''apul", "Tsanak''w", "Belal"]',
       'xochitl',
       'Wayal significa dormir',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ver',
       '["Met''ál"]',
       '["Idhidh", "Uts''ál", "Wayal", "Met''ál"]',
       'citlali',
       'Met''ál significa ver',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______apul',
       '["K''", "K''apul"]',
       null,
       'coltzin',
       'K''apul significa comer',
       20, 'medium',
       'Comer'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ts''ál',
       '["U", "Uts''ál"]',
       null,
       'neza',
       'Uts''ál significa beber',
       20, 'medium',
       'Beber'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 4;

-- nivel 5 · unidad 5: trabajos de la casa
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Leña',
       '["Dhi''"]',
       '["Tsanak''w", "Dhi''", "K''apnél", "Lanáx"]',
       'tonatiuh',
       'Dhi'' significa leña',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Escoba',
       '["K''wet"]',
       '["Dhi''", "Lanáx", "K''wet", "Ajan"]',
       'xochitl',
       'K''wet significa escoba',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Jabón',
       '["Xabún"]',
       '["Xabún", "Idhidh", "K''wet", "Tsanak''w"]',
       'citlali',
       'Xabún significa jabón',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Vendo naranjas',
       '["U nujuwal an lanax"]',
       '["U nujuwal an lanax", "Na k''imá''", "¡Ka k''wetoy na k''imá''!", "U kitnál an dhi''"]',
       'coltzin',
       'U nujuwal an lanax significa vendo naranjas',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ nujuwal an lanax',
       '["U", "U nujuwal an lanax"]',
       null,
       'neza',
       'U nujuwal an lanax significa vendo naranjas',
       20, 'medium',
       'Vendo naranjas'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'U kitnál an ______',
       '["dhi''", "U kitnál an dhi''"]',
       null,
       'tonatiuh',
       'U kitnál an dhi'' significa cargo la leña',
       20, 'medium',
       'Cargo la leña'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 5;

-- nivel 5 · unidad 6: caliente y frío
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Caliente',
       '["K''ak''"]',
       '["Tolow", "Tsanak''w", "K''ak''", "Idhidh"]',
       'xochitl',
       'K''ak'' significa caliente',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Frío(a)',
       '["Chamay"]',
       '["T''apay", "Idhidh", "Ts''a''ik", "Chamay"]',
       'citlali',
       'Chamay significa frío(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Amargo(a)',
       '["Ts''a''ik"]',
       '["Ajan", "T''apay", "Ts''a''ik", "Kapéj"]',
       'coltzin',
       'Ts''a''ik significa amargo(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pegajoso(a)',
       '["T''apay"]',
       '["Tolow", "Chamay", "T''apay", "Idhidh"]',
       'neza',
       'T''apay significa pegajoso(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ak''',
       '["K''", "K''ak''"]',
       null,
       'tonatiuh',
       'K''ak'' significa caliente',
       20, 'medium',
       'Caliente'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______amay',
       '["Ch", "Chamay"]',
       null,
       'xochitl',
       'Chamay significa frío(a)',
       20, 'medium',
       'Frío(a)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 5 and u.unit_num = 6;

-- nivel 6 · unidad 1: animales del monte
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Conejo',
       '["Koy"]',
       '["Koy", "Edhem", "Pik''o''", "Itxamal"]',
       'citlali',
       'Koy significa conejo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Coyote',
       '["Chuch"]',
       '["Koy", "Chuch", "Itxamal", "Edhem"]',
       'coltzin',
       'Chuch significa coyote',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Venado',
       '["Itxamal"]',
       '["Pik''o''", "Koxol", "Itxamal", "Mitsu''"]',
       'neza',
       'Itxamal significa venado',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mapache',
       '["Edhem"]',
       '["Pik''o''", "Bat''aw", "Itxamal", "Edhem"]',
       'tonatiuh',
       'Edhem significa mapache',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______uch',
       '["Ch", "Chuch"]',
       null,
       'xochitl',
       'Chuch significa coyote',
       20, 'medium',
       'Coyote'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______amal',
       '["Itx", "Itxamal"]',
       null,
       'citlali',
       'Itxamal significa venado',
       20, 'medium',
       'Venado'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 1;

-- nivel 6 · unidad 2: animales de la casa
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Perro',
       '["Pik''o''"]',
       '["Ch''uri''", "Pik''o''", "Mitsu''", "Itxamal"]',
       'coltzin',
       'Pik''o'' significa perro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Gato',
       '["Mitsu''"]',
       '["Koxol", "Bichim", "Ch''uri''", "Mitsu''"]',
       'neza',
       'Mitsu'' significa gato',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Gallo',
       '["Koxol"]',
       '["Chuch", "Mitsu''", "Koxol", "Yaxk''wa''"]',
       'tonatiuh',
       'Koxol significa gallo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Burro',
       '["Ch''uri''"]',
       '["Ch''uri''", "Yaxk''wa''", "Koxol", "Mitsu''"]',
       'xochitl',
       'Ch''uri'' significa burro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ pik''oil',
       '["Nu", "Nu pik''oil"]',
       null,
       'citlali',
       'Nu pik''oil significa mi perro',
       20, 'medium',
       'Mi perro'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ik''o''',
       '["P", "Pik''o''"]',
       null,
       'coltzin',
       'Pik''o'' significa perro',
       20, 'medium',
       'Perro'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 2;

-- nivel 6 · unidad 3: el cuerpo
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cabeza',
       '["Ok''"]',
       '["Ok''", "Koy", "Wal", "Chuch"]',
       'neza',
       'Ok'' significa cabeza',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mano',
       '["K''ubak"]',
       '["Akan", "Ok''", "K''ubak", "Chuch"]',
       'tonatiuh',
       'K''ubak significa mano',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pie',
       '["Akan"]',
       '["Koy", "Chuch", "Akan", "Txukul"]',
       'xochitl',
       'Akan significa pie',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ojo',
       '["Wal"]',
       '["Txukul", "Wal", "Chuch", "Wi''"]',
       'citlali',
       'Wal significa ojo / cara',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ubak',
       '["K''", "K''ubak"]',
       null,
       'coltzin',
       'K''ubak significa mano',
       20, 'medium',
       'Mano'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______kan',
       '["A", "Akan"]',
       null,
       'neza',
       'Akan significa pie',
       20, 'medium',
       'Pie'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 3;

-- nivel 6 · unidad 4: lo que quiero y lo que tengo
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Querer',
       '["Le''"]',
       '["Le''", "Edhem", "Tumín", "Itxamal"]',
       'tonatiuh',
       'Le'' significa querer',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tener',
       '["Kó''ol"]',
       '["Kó''ol", "Le''", "Edhem", "Koy"]',
       'xochitl',
       'Kó''ol significa tener',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Sombrero',
       '["Xumpelel"]',
       '["Le''", "Xumpelel", "Kó''ol", "Ot''el"]',
       'citlali',
       'Xumpelel significa sombrero',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Carro',
       '["Belal atáj"]',
       '["Belal atáj", "Tének Tsabál", "Nu pik''oil", "¡Abél junt''aj xu bixnél!"]',
       'coltzin',
       'Belal atáj significa carro (lit. casa que camina)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ atáj',
       '["Belal", "Belal atáj"]',
       null,
       'neza',
       'Belal atáj significa carro (lit. casa que camina)',
       20, 'medium',
       'Carro'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ó''ol',
       '["K", "Kó''ol"]',
       null,
       'tonatiuh',
       'Kó''ol significa tener',
       20, 'medium',
       'Tener'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 4;

-- nivel 6 · unidad 5: expresiones
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'San Luis Potosí',
       '["Tampots''ots''"]',
       '["Ot''el", "Tampots''ots''", "Labtóm", "Edhem"]',
       'xochitl',
       'Tampots''ots'' significa San Luis Potosí',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'México',
       '["Labtóm"]',
       '["Koy", "Chuch", "Bat''aw", "Labtóm"]',
       'citlali',
       'Labtóm significa México',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¡Qué bonita danza!',
       '["¡Abél junt''aj xu bixnél!"]',
       '["Tének Tsabál", "Nu pik''oil", "Belal atáj", "¡Abél junt''aj xu bixnél!"]',
       'coltzin',
       '¡Abél junt''aj xu bixnél! significa ¡qué bonita danza!',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Región tének',
       '["Tének Tsabál"]',
       '["Belal atáj", "¡Abél junt''aj xu bixnél!", "Nu pik''oil", "Tének Tsabál"]',
       'neza',
       'Tének Tsabál significa región tének',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '¡______ junt''aj xu bixnél!',
       '["Abél", "Abél junt''aj xu bixnél", "¡Abél junt''aj xu bixnél!"]',
       null,
       'tonatiuh',
       '¡Abél junt''aj xu bixnél! significa ¡qué bonita danza!',
       20, 'medium',
       '¡Qué bonita danza!'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tének ______',
       '["Tsabál", "Tének Tsabál"]',
       null,
       'xochitl',
       'Tének Tsabál significa región tének',
       20, 'medium',
       'Región tének'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 5;

-- nivel 6 · unidad 6: conversación final
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buenos días',
       '["Tajk''anenek"]',
       '["Tajk''anenek", "Mím", "Koy", "Chuch"]',
       'citlali',
       'Tajk''anenek significa buenos días',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Yo me llamo',
       '["Naná'' u bij"]',
       '["¡Abél junt''aj xu bixnél!", "Kit k''alej alwa''", "Naná'' u bij", "Lej k''ak''námal yán"]',
       'coltzin',
       'Naná'' u bij significa yo me llamo (lit. yo, mi nombre)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Papá',
       '["Táta''"]',
       '["Táta''", "Tajk''anenek", "Koy", "Mím"]',
       'neza',
       'Táta'' significa papá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mamá',
       '["Mím"]',
       '["Tajk''anenek", "Chuch", "Edhem", "Mím"]',
       'tonatiuh',
       'Mím significa mamá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       '______ u bij',
       '["Naná''", "Naná'' u bij"]',
       null,
       'xochitl',
       'Naná'' u bij significa yo me llamo (lit. yo, mi nombre)',
       20, 'medium',
       'Yo me llamo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Lej k''ak''námal ______',
       '["yán", "Lej k''ak''námal yán"]',
       null,
       'citlali',
       'Lej k''ak''námal yán significa muchas gracias',
       20, 'medium',
       'Muchas gracias'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'hus' and l.level_num = 6 and u.unit_num = 6;

-- ─────────────────────────────────────────────
--  7. sistema de escritura
-- ─────────────────────────────────────────────
insert into ct_writing_systems (language_id, system_type, system_name, description, characters, notes)
select id, 'alphabet', 'alfabeto tének',
       'Norma de escritura del tének (INALI). Variante base: San Luis Potosí. Borrador pendiente de validar con hablantes.',
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
        "example": "Alwa''"
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
        "example": "Epchal"
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
        "example": "Inik"
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
        "example": "Ok''ox"
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
        "example": "Uxum"
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
        "example": "Bij"
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
        "example": "Ché''"
    },
    {
        "type": "consonant",
        "letter": "dh",
        "pronunciation": "dh (sonido interdental)",
        "syllables": {
            "a": "dha",
            "e": "dhe",
            "i": "dhi",
            "o": "dho",
            "u": "dhu"
        },
        "example": "Dhamk''unenek"
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
        "example": "Jajá''"
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
        "example": "Kalám"
    },
    {
        "type": "consonant",
        "letter": "kw",
        "pronunciation": "kw",
        "syllables": {
            "a": "kwa",
            "e": "kwe",
            "i": "kwi",
            "o": "kwo",
            "u": "kwu"
        },
        "example": "Kwitól"
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
        "example": "Laju''"
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
        "example": "Mím"
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
        "example": "Naná''"
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
        "example": "Púlik"
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
        "example": "Tajk''anenek"
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
        "example": "Tsanub"
    },
    {
        "type": "consonant",
        "letter": "tx",
        "pronunciation": "tx",
        "syllables": {
            "a": "txa",
            "e": "txe",
            "i": "txi",
            "o": "txo",
            "u": "txu"
        },
        "example": "Txukul"
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
        "example": "Waklenenek"
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
        "example": "Xowé''"
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
        "example": "Yán"
    },
    {
        "type": "consonant",
        "letter": "''",
        "pronunciation": "saltillo (corte de voz)",
        "syllables": {
            "a": null,
            "e": null,
            "i": null,
            "o": null,
            "u": null
        },
        "example": "Alwa''"
    },
    {
        "type": "ejective",
        "letter": "b''",
        "pronunciation": "b glotalizada",
        "syllables": {
            "a": "b''a",
            "e": "b''e",
            "i": "b''i",
            "o": "b''o",
            "u": "b''u"
        }
    },
    {
        "type": "ejective",
        "letter": "ch''",
        "pronunciation": "ch glotalizada",
        "syllables": {
            "a": "ch''a",
            "e": "ch''e",
            "i": "ch''i",
            "o": "ch''o",
            "u": "ch''u"
        },
        "example": "Ch''uri''"
    },
    {
        "type": "ejective",
        "letter": "k''",
        "pronunciation": "k glotalizada",
        "syllables": {
            "a": "k''a",
            "e": "k''e",
            "i": "k''i",
            "o": "k''o",
            "u": "k''u"
        },
        "example": "K''ak''námal"
    },
    {
        "type": "ejective",
        "letter": "k''w",
        "pronunciation": "kw glotalizada",
        "syllables": {
            "a": "k''wa",
            "e": "k''we",
            "i": "k''wi",
            "o": "k''wo",
            "u": "k''wu"
        },
        "example": "K''wet"
    },
    {
        "type": "ejective",
        "letter": "t''",
        "pronunciation": "t glotalizada",
        "syllables": {
            "a": "t''a",
            "e": "t''e",
            "i": "t''i",
            "o": "t''o",
            "u": "t''u"
        },
        "example": "T''unu''"
    },
    {
        "type": "ejective",
        "letter": "ts''",
        "pronunciation": "ts glotalizada",
        "syllables": {
            "a": "ts''a",
            "e": "ts''e",
            "i": "ts''i",
            "o": "ts''o",
            "u": "ts''u"
        },
        "example": "Ts''itsin"
    },
    {
        "type": "ejective",
        "letter": "y''",
        "pronunciation": "y glotalizada",
        "syllables": {
            "a": "y''a",
            "e": "y''e",
            "i": "y''i",
            "o": "y''o",
            "u": "y''u"
        },
        "example": "Way''"
    },
    {
        "type": "longVowel",
        "letter": "á",
        "pronunciation": "aa",
        "syllables": {
            "a": "á (aa)"
        },
        "example": "Ách"
    },
    {
        "type": "longVowel",
        "letter": "é",
        "pronunciation": "ee",
        "syllables": {
            "e": "é (ee)"
        },
        "example": "Tének"
    },
    {
        "type": "longVowel",
        "letter": "í",
        "pronunciation": "ii",
        "syllables": {
            "i": "í (ii)"
        },
        "example": "Ít"
    },
    {
        "type": "longVowel",
        "letter": "ó",
        "pronunciation": "oo",
        "syllables": {
            "o": "ó (oo)"
        },
        "example": "Óx"
    },
    {
        "type": "longVowel",
        "letter": "ú",
        "pronunciation": "uu",
        "syllables": {
            "u": "ú (uu)"
        },
        "example": "Úw"
    }
]',
       '["Vocales: a, e, i, o, u; con acento son largas: á, é, í, ó, ú (atáj, búk)",
         "La comilla sola es el saltillo (corte de voz): ja\u0027, bó\u0027, kó\u0027ol",
         "Ch, dh, kw, ts y tx son un solo sonido y no se separan al silabear",
         "Glotalizadas: b\u0027, ch\u0027, k\u0027, k\u0027w, t\u0027, ts\u0027, y\u0027 (k\u0027ubak, t\u0027ojlab)",
         "Silabeo: una consonante entre vocales abre la sílaba siguiente (u-tsun, ba-t\u0027aw, ko-xol)",
         "Plural en San Luis Potosí con -chik: tatá\u0027chik, jajáchik, inikchik"]'
from ct_languages where code = 'hus';

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
    where la.code = 'hus' and l.level_num = 1 and u.unit_num = 1
) u
where usr.username = 'tetecuhtli';

-- ─────────────────────────────────────────────
--  9. ta_user_stats — registro inicial para el usuario demo
-- ─────────────────────────────────────────────
insert into ta_user_stats (user_id, language_id, words_learned, lessons_done, perfect_less, days_studied, best_streak, total_mins)
select usr.id, la.id, 0, 0, 0, 0, 0, 0
from ta_users usr
cross join ct_languages la
where usr.username = 'tetecuhtli' and la.code = 'hus';


-- ─────────────────────────────────────────────
--  10. desglose de palabras (pista al tocar una palabra subrayada)
--      formato: 'parte = significado; parte = significado'. las palabras de una sola pieza llevan
--      una fila con su significado. guiones: prefijo (ni-) y sufijo (-tli). entre paréntesis, la
--      función cuando no hay traducción directa. borrador: validar con hablantes.
-- ─────────────────────────────────────────────
update ct_vocabulary v
   set breakdown = x.breakdown
  from (values
        ('Tajk''anenek',                  'tajk''anenek = buenos días'),
        ('Waklenenek',                    'waklenenek = buenas tardes'),
        ('Dhamk''unenek',                 'dhamk''unenek = buenas noches'),
        ('Alwa'' bats''udh',              'alwa'' = bien, bueno; bats''udh = (bienvenida)'),
        ('Kit wat''ey',                   'kit = tú; wat''ey = pasar'),
        ('Tayej ku tsu''uxinej',          'tayej = luego, después; ku = nosotros; tsu''uxinej = vernos'),
        ('Kit k''alej alwa''',            'kit = tú; k''alej = irse; alwa'' = bien'),
        ('Alwa''',                        'alwa'' = bien / bueno'),
        ('Kalám',                         'kalám = mañana'),
        ('Naná''',                        'naná'' = yo'),
        ('Tatá''',                        'tatá'' = tú'),
        ('Jajá''',                        'jajá'' = él / ella'),
        ('Bij',                           'bij = nombre'),
        ('Naná'' u bij',                  'naná'' = yo; u = mi; bij = nombre'),
        ('¿Jantij a bij?',                'jantij = cómo; a = tu; bij = nombre'),
        ('K''ak''námal',                  'k''ak''námal = gracias'),
        ('Lej k''ak''námal yán',          'lej = muy; k''ak''námal = gracias; yán = mucho'),
        ('Yán',                           'yán = mucho'),
        ('Antsaná''',                     'antsaná'' = sí / así es'),
        ('Yab',                           'yab = no'),
        ('Pakwlanchij yán',               'pakwlanchij = disculpa, con permiso; yán = mucho'),
        ('Kit k''apúts alwa''',           'kit = tú; k''apúts = comer; alwa'' = bien'),
        ('Wanaj ku t''ojon kulbél',       'wanaj = vamos a; ku = nosotros; t''ojon = hacer; kulbél = gusto, alegría'),
        ('Tének',                         'té'' = aquí; inik = gente (la gente de aquí)'),
        ('Kawintaláb',                    'kaw- = hablar, palabra; -intaláb = (forma sustantivos)'),
        ('¿Jantom kawintaláb an kawnal?', 'jantom = qué; kawintaláb = lengua; an = la, el; kaw- = hablar; -nal = (verbo)'),
        ('Wawá''',                        'wawá'' = nosotros(as)'),
        ('Tatá''chik',                    'tatá'' = tú; -chik = (plural)'),
        ('Jajáchik',                      'jajá'' = él, ella; -chik = (plural)'),
        ('Inik',                          'inik = hombre'),
        ('Uxum',                          'uxum = mujer'),
        ('Inikchik',                      'inik = hombre; -chik = (plural)'),
        ('Táta''',                        'táta'' = papá'),
        ('Mím',                           'mím = mamá'),
        ('Kwitól',                        'kwitól = niño(a)'),
        ('Ani',                           'ani = y'),
        ('Ixám',                          'ixám = esposa'),
        ('Mám',                           'mám = abuelo / anciano'),
        ('Ách',                           'ách = abuela'),
        ('Itsán',                         'itsán = tío'),
        ('Tsanub',                        'tsanub = tía'),
        ('Epchal',                        'epchal = hermano'),
        ('Púlik',                         'púlik = grande'),
        ('Tsakam',                        'tsakam = pequeño(a)'),
        ('Ít',                            'ít = nuevo(a)'),
        ('Alabél',                        'alabél = bonito(a)'),
        ('Kidhab',                        'kidhab = malo(a)'),
        ('Nakat',                         'nakat = largo(a)'),
        ('Tsakni''',                      'tsakni'' = rojo'),
        ('Dhakni''',                      'dhakni'' = blanco'),
        ('T''unu''',                      't''unu'' = negro'),
        ('Yaxu''',                        'yaxu'' = verde'),
        ('Manu''',                        'manu'' = amarillo'),
        ('Jún',                           'jún = uno'),
        ('Tsáb',                          'tsáb = dos'),
        ('Óx',                            'óx = tres'),
        ('Ché''',                         'ché'' = cuatro'),
        ('Bó''',                          'bó'' = cinco'),
        ('Ja''úb',                        'ja''úb = amigo(a)'),
        ('Jantom',                        'jantom = qué'),
        ('Jantij',                        'jantij = cómo'),
        ('Juta',                          'juta = dónde'),
        ('Jay',                           'jay = cuánto'),
        ('Jachan',                        'jachan = ¿es…? (pregunta)'),
        ('Atáj',                          'atáj = casa'),
        ('Kwentsal',                      'kwentsal = comunidad'),
        ('Nu kwentsál',                   'nu = mi; kwentsál = comunidad'),
        ('Na k''imá''',                   'na = tu; k''imá'' = casa (de alguien)'),
        ('¿Jachana k''imá?',              'jachan = ¿es…?; a = tu; k''imá = casa (de alguien)'),
        ('Akak',                          'akak = seis'),
        ('Búk',                           'búk = siete'),
        ('Waxik',                         'waxik = ocho'),
        ('Beléw',                         'beléw = nueve'),
        ('Laju''',                        'laju'' = diez'),
        ('Jún inik',                      'jún = uno; inik = hombre (una persona completa: veinte dedos)'),
        ('Alté''',                        'alté'' = monte'),
        ('Mom',                           'mom = pozo'),
        ('Ja''',                          'ja'' = agua'),
        ('Tumín',                         'tumín = dinero'),
        ('Úw',                            'úw = papel'),
        ('Takab',                         'takab = comal'),
        ('Utat',                          'utat = cerca'),
        ('Ów',                            'ów = lejos'),
        ('Alal',                          'alal = abajo'),
        ('Ok''ox',                        'ok''ox = primero'),
        ('Putat',                         'putat = entero'),
        ('An',                            'an = el / la'),
        ('¿Jantij in bij na kwentsalíl?', 'jantij = cómo; in = su; bij = nombre; na = tu; kwentsal = comunidad; -íl = (poseído)'),
        ('Xowé''',                        'xowé'' = hoy'),
        ('We''él',                        'we''él = ayer'),
        ('K''icháj',                      'k''icháj = día / sol'),
        ('Akal',                          'akal = noche'),
        ('K''ij',                         'k''ij = tiempo'),
        ('Tamub',                         'tamub = año'),
        ('Its''',                         'its'' = luna / mes'),
        ('Ik''',                          'ik'' = aire / viento'),
        ('Lem',                           'lem = mariposa'),
        ('Tsunun',                        'tsunun = colibrí'),
        ('Ts''itsin',                     'ts''itsin = pájaro'),
        ('In atsim',                      'in = yo; atsim = bañarse'),
        ('In kalel',                      'in = yo; kalel = salir'),
        ('Naná'' im belal',               'naná'' = yo; im = yo (en el verbo); belal = caminar'),
        ('Ne''ech ban nu kwentsál',       'ne''ech = voy; ban = a, en; nu = mi; kwentsál = comunidad'),
        ('U lejkiy an bakan',             'u = yo; lejkiy = preparé; an = la; bakan = tortilla'),
        ('Bakan',                         'bakan = tortilla'),
        ('Tatá'' tey i t''ojon',          'tatá'' = tú; tey = también; i t''ojon = trabajaste'),
        ('Tsekets an bichim',             'tsekets = se cansó; an = el; bichim = caballo'),
        ('Bichim',                        'bichim = caballo'),
        ('Wat''ey',                       'wat''ey = pasó'),
        ('Exom tu dhuchum',               'exom = estar haciendo (ahora); tu = nosotros; dhuchum = escribir'),
        ('Dhuchum',                       'dhuchum = escribir'),
        ('Ne''ets ku ayin',               'ne''ets = ir (lo que va a pasar); ku = nosotros; ayin = regresar (a casa)'),
        ('T''ojnal',                      't''oj- = trabajo; -nal = (verbo)'),
        ('T''ojlab',                      't''oj- = trabajo; -lab = (forma sustantivos)'),
        ('Ulits',                         'ulits = llegar'),
        ('Ach''a''',                      'ach''a'' = escuchar'),
        ('Idhidh',                        'idhidh = maíz'),
        ('Ajan',                          'ajan = elote'),
        ('Tsanak''w',                     'tsanak''w = frijol'),
        ('Its',                           'its = chile'),
        ('K''apnél',                      'k''ap- = comer; -nél = (forma sustantivos)'),
        ('Lanáx',                         'lanáx = naranja'),
        ('Uj',                            'uj = aguacate'),
        ('Utsun',                         'utsun = papaya'),
        ('Pakab',                         'pakab = caña'),
        ('Pak''ak''',                     'pak''ak'' = nopal'),
        ('Way''',                         'way'' = mazorca'),
        ('Kapéj',                         'kapéj = café'),
        ('Tay''',                         'tay'' = cal'),
        ('Kuchil',                        'kuchil = cuchillo'),
        ('Mexa',                          'mexa = mesa'),
        ('K''apul',                       'k''apul = comer'),
        ('Uts''ál',                       'uts''ál = beber'),
        ('Wayal',                         'wayal = dormir'),
        ('Met''ál',                       'met''ál = ver'),
        ('Pidhál',                        'pidhál = dar'),
        ('Belal',                         'belal = caminar'),
        ('U nujuwal an lanax',            'u = yo; nujuwal = vender; an = la(s); lanax = naranja'),
        ('U kitnál an dhi''',             'u = yo; kitnál = cargar; an = la; dhi'' = leña'),
        ('Dhi''',                         'dhi'' = leña'),
        ('¡Ka k''wetoy na k''imá''!',     'ka = (orden, tú); k''wetoy = barrer; na = tu; k''imá'' = casa'),
        ('K''wet',                        'k''wet = escoba'),
        ('Xabún',                         'xabún = jabón (del español)'),
        ('K''ak''',                       'k''ak'' = caliente'),
        ('Chamay',                        'chamay = frío(a)'),
        ('Ts''a''ik',                     'ts''a''ik = amargo(a)'),
        ('T''apay',                       't''apay = pegajoso(a)'),
        ('Tolow',                         'tolow = grueso(a)'),
        ('Koy',                           'koy = conejo'),
        ('Chuch',                         'chuch = coyote'),
        ('Itxamal',                       'itxamal = venado'),
        ('Edhem',                         'edhem = mapache'),
        ('Ot''el',                        'ot''el = ardilla'),
        ('Bat''aw',                       'bat''aw = armadillo'),
        ('Pik''o''',                      'pik''o'' = perro'),
        ('Mitsu''',                       'mitsu'' = gato'),
        ('Koxol',                         'koxol = gallo'),
        ('Ch''uri''',                     'ch''uri'' = burro'),
        ('Nu pik''oil',                   'nu = mi; pik''o'' = perro; -il = (poseído)'),
        ('Yaxk''wa''',                    'yaxk''wa'' = rana'),
        ('Ok''',                          'ok'' = cabeza'),
        ('K''ubak',                       'k''ubak = mano'),
        ('Akan',                          'akan = pie'),
        ('Wal',                           'wal = ojo / cara'),
        ('Wi''',                          'wi'' = boca'),
        ('Okob',                          'okob = brazo'),
        ('Txukul',                        'txukul = panza'),
        ('Le''',                          'le'' = querer'),
        ('Kó''ol',                        'kó''ol = tener'),
        ('Xumpelel',                      'xumpelel = sombrero'),
        ('Belal atáj',                    'belal = caminar; atáj = casa'),
        ('¡Abél junt''aj xu bixnél!',     'abél = bonito; junt''aj = qué (tan); xu = la (que); bixnél = danza'),
        ('Tének Tsabál',                  'tének = tének; tsabál = tierra, región'),
        ('Tampots''ots''',                'tam- = lugar de; pots''ots'' = (nombre del lugar)'),
        ('Labtóm',                        'labtóm = México')
       ) as x(word, breakdown),
       ct_languages l
 where l.id = v.language_id
   and l.code = 'hus'
   and v.word = x.word;

commit;

-- ─────────────────────────────────────────────
--  verificación
--  esperado (desglose = vocabulario): ct_levels 6 · ct_units 36 · ct_vocabulary 175 · rl_unit_vocab 225 · ct_exercises 216 · ct_writing_systems 1
-- ─────────────────────────────────────────────
select 'ct_levels' as tabla, count(1) as registros from ct_levels where language_id = (select id from ct_languages where code = 'hus')
union all
select 'ct_units', count(1) from ct_units where level_id in (select id from ct_levels where language_id = (select id from ct_languages where code = 'hus'))
union all
select 'ct_vocabulary', count(1) from ct_vocabulary where language_id = (select id from ct_languages where code = 'hus')
union all
select 'rl_unit_vocab', count(1) from rl_unit_vocab where unit_id in (select u.id from ct_units u join ct_levels l on u.level_id = l.id where l.language_id = (select id from ct_languages where code = 'hus'))
union all
select 'ct_exercises', count(1) from ct_exercises where unit_id in (select u.id from ct_units u join ct_levels l on u.level_id = l.id where l.language_id = (select id from ct_languages where code = 'hus'))
union all
select 'ct_writing_systems', count(1) from ct_writing_systems where language_id = (select id from ct_languages where code = 'hus')
union all
select 'desglose', count(1) from ct_vocabulary where language_id = (select id from ct_languages where code = 'hus') and breakdown is not null;
