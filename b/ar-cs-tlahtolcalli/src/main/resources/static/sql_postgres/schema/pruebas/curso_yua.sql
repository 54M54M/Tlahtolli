-- ============================================================
--  seed de prueba — Maya yucateco (yua)  · curso en pruebas (status = 'draft')
--  tlahtolcalli  [postgresql]
--
--  variante base: maya peninsular (yucatán, campeche, quintana roo) · iso 639-3: yua
--  ejecutar después de 1.-esquema.sql y 2.-datos_generales.sql.
--
--  contenido (curso completo, mismos niveles que nhn y hus):
--    6 niveles · 36 unidades · 213 palabras y frases (todas con desglose) · 216 ejercicios
--
--  tipología: predominantemente aglutinante, con partículas y clíticos (familia maya). juego A antes
--    (in, a, u, k), juego B después (-en, -ech, -o'ob), aspecto con k-, t- y táan, deícticos le…-a'/-o'.
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

-- ─────────────────────────────────────────────
--  0. limpieza (re-ejecución)
-- ─────────────────────────────────────────────
update ta_users set current_lang = null
 where current_lang = (select id from ct_languages where code = 'yua');
delete from ta_user_stats
 where language_id = (select id from ct_languages where code = 'yua');
delete from ta_user_achievements where language_tag = 'yua';
delete from ct_languages where code = 'yua';   -- en cascada: niveles, unidades, vocabulario, ejercicios, progreso

-- ─────────────────────────────────────────────
--  1. idioma (en pruebas: solo se ve en el front de desarrollo)
-- ─────────────────────────────────────────────
insert into ct_languages (code, lang_name, native_name, color, flag, family, writing_system, status)
values ('yua', 'Maya yucateco', 'Maaya t''aan', null, '🌽', 'maya', 'alphabet', 'draft');

-- ─────────────────────────────────────────────
--  2. niveles
-- ─────────────────────────────────────────────
insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 1, 'Saluda y preséntate', 'Ma''alob k''iin', null, 6, 'Ninguno - Nivel inicial', 1
from ct_languages where code = 'yua';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 2, 'Descríbete y describe a tu familia', 'In láak''o''ob', null, 6, 'Completar Nivel 1', 0
from ct_languages where code = 'yua';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 3, 'Pide y da información', 'Ba''ax, máax, tu''ux?', null, 6, 'Completar Nivel 2', 0
from ct_languages where code = 'yua';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 4, 'Habla en tiempos (ayer/hoy/mañana)', 'Bejla''e'', sáamal', null, 6, 'Completar Nivel 3', 0
from ct_languages where code = 'yua';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 5, 'Describe un día normal', 'Janal, meyaj', null, 6, 'Completar Nivel 4', 0
from ct_languages where code = 'yua';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 6, 'Describe y expresa preferencias', 'Ba''ax a k''áat?', null, 6, 'Completar Nivel 5', 0
from ct_languages where code = 'yua';

-- ─────────────────────────────────────────────
--  3.1 unidades — nivel 1: saluda y preséntate
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Saludos', null,
       'Saludar según la hora y preguntar cómo está alguien',
       'Ma''alob = bien, bueno; k''iin = sol, día; áak''ab = noche. Bix a beel? = ¿cómo va tu camino?', 1, null
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Despedidas', null,
       'Despedirse y quedar de verse',
       'Tak = hasta; sáamal = mañana; táan in bin = me voy (táan: lo que está pasando)', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, '¿Quién eres?', null,
       'Decir tu nombre y conocer los pronombres',
       'Teen (yo), teech (tú), leti'' (él, ella); in = mi, a = tu, u = su', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Agradecer y responder', null,
       'Dar las gracias, responder y decir sí o no',
       'Dios bo''otik = gracias (lit. que Dios lo pague); jach = muy; ma'' = no', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Cómo me siento', null,
       'Decir cómo te sientes y preguntar a otros',
       'Juego B: -en (yo), -ech (tú) van al final: k''oja''anen = estoy enfermo, k''oja''anech = estás enfermo', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Conversación básica', null,
       'Unir saludo, nombre, estado y despedida en una conversación',
       'Maaya t''aan = lengua maya; ich = en; k- + in = yo (lo que hago siempre)', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1;

-- ─────────────────────────────────────────────
--  3.2 unidades — nivel 2: descríbete y describe a tu familia
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Pronombres personales', null,
       'Conocer los pronombres en singular y plural',
       'To''on (nosotros), te''ex (ustedes), leti''o''ob (ellos); -o''ob hace el plural', 0, 'Completar Nivel 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'La familia', null,
       'Nombrar a los miembros de la familia',
       'In = mi, a = tu, u = su: in na'' (mi mamá), a taata (tu papá)', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Los abuelos y los hermanos', null,
       'Nombrar a los abuelos y a los hermanos',
       'Suku''un = hermano mayor; íits''in = hermano menor; kiik = hermana mayor', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Cómo es', null,
       'Describir cosas y personas',
       'El adjetivo va antes del nombre: nojoch naj = casa grande', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Los colores', null,
       'Nombrar los colores',
       'Chak, sak, éek'', k''an, ya''ax: los cinco colores básicos; van antes del nombre', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Contar del uno al cinco', null,
       'Contar del uno al cinco',
       'El número lleva un clasificador: p''éel (cosas), túul (seres vivos)', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2;

-- ─────────────────────────────────────────────
--  3.3 unidades — nivel 3: pide y da información
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Palabras para preguntar', null,
       'Hacer preguntas sencillas',
       'Ba''ax (qué), máax (quién), tu''ux (dónde), ba''axten (por qué): van al inicio', 0, 'Completar Nivel 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Mi casa y mi comunidad', null,
       'Hablar de la casa y del pueblo',
       'Ti'' + in = tin (en mi): tin naj = en mi casa', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Contar del seis al diez', null,
       'Contar del seis al diez',
       'Lajun = diez; los números se combinan con p''éel y túul', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Lugares y cosas', null,
       'Nombrar lugares y cosas del entorno',
       'Yaan = hay; nojoch bej = camino grande, carretera', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Cerca y lejos', null,
       'Decir si algo está cerca o lejos',
       'Le ... -a'' = este, esta; le ... -o'' = ese, esa', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Preguntas útiles', null,
       'Preguntar precios, pedir cosas y decir que no entiendes',
       'Bajux = cuánto cuesta; ts''a = dar; -en = a mí', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3;

-- ─────────────────────────────────────────────
--  3.4 unidades — nivel 4: habla en tiempos (ayer/hoy/mañana)
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Hoy, ayer y mañana', null,
       'Decir cuándo pasa algo',
       'T- + in = tin (lo hice); yaan in = tengo que, voy a', 0, 'Completar Nivel 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'La naturaleza', null,
       'Nombrar elementos de la naturaleza',
       'K''iin significa sol y también día; ek'' = estrella (no confundir con éek'' = negro)', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Lo que hago', null,
       'Decir lo que haces de costumbre',
       'K- + in = kin (yo, de costumbre): kin janal = como', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Lo que pasó', null,
       'Contar lo que ya hiciste',
       'T- + in = tin (yo, ya pasó); ts''o''ok = ya terminó', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Ahora y después', null,
       'Decir lo que estás haciendo ahora',
       'Táan + in = estoy haciendo; ma''ili'' = todavía no', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Repaso del tiempo', null,
       'Hablar de días y años',
       'Ja''ab = año; le ... -a'' = este: le ja''aba'' = este año', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4;

-- ─────────────────────────────────────────────
--  3.5 unidades — nivel 5: describe un día normal
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'La comida', null,
       'Nombrar la comida de todos los días',
       'Yéetel = con, y; ki'' = sabroso', 0, 'Completar Nivel 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Frutas y plantas', null,
       'Nombrar frutas y plantas',
       'Ya''ab = mucho; ki''ichpam = hermoso', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'En la cocina', null,
       'Nombrar cosas de la cocina',
       'Ti'' = en; ts''a = poner, dar', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Acciones del día', null,
       'Decir lo que haces durante el día',
       'K- + in = kin: kin ajal (me despierto), kin xíimbal (camino)', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Trabajos de la casa', null,
       'Hablar de los quehaceres',
       'Ich = en, dentro: ich kool = en la milpa', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Caliente y frío', null,
       'Decir si algo está caliente o frío',
       'Chokoj = caliente; síis = frío (agua, cosas); ke''el = frío (tiempo, cuerpo)', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5;

-- ─────────────────────────────────────────────
--  3.6 unidades — nivel 6: describe y expresa preferencias
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Animales del monte', null,
       'Nombrar animales del monte',
       '-o''ob hace el plural: ch''íich''o''ob = pájaros', 0, 'Completar Nivel 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Animales de la casa', null,
       'Nombrar animales de la casa',
       'Túul cuenta seres vivos: ka''a túul miis = dos gatos', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'El cuerpo', null,
       'Nombrar partes del cuerpo',
       'Yaj = duele: yaj in pool = me duele la cabeza', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Lo que quiero y lo que tengo', null,
       'Decir lo que quieres y lo que tienes',
       'In k''áat = quiero; yaan ten = tengo (lit. hay para mí)', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Expresiones', null,
       'Usar expresiones de todos los días',
       'Bey = así; xan = también; ko''one''ex = vámonos', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Conversación final', null,
       'Usar todo en una conversación',
       'Juego A antes del verbo y juego B después: in yaakumech = te quiero (yo a ti)', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6;

-- ─────────────────────────────────────────────
--  4. vocabulario (con desglose: pista al tocar una palabra subrayada)
-- ─────────────────────────────────────────────
-- nivel 1 · unidad 1: saludos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ma''alob k''iin', 'buenos días', 'ma''-a-lob k''iin', null, 'ma''alob = bien, bueno; k''iin = sol, día' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ma''alob chíinil k''iin', 'buenas tardes', 'ma''-a-lob chíi-nil k''iin', null, 'ma''alob = bien, bueno; chíinil = inclinado; k''iin = sol (el sol inclinado = la tarde)' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ma''alob áak''ab', 'buenas noches', 'ma''-a-lob áa-k''ab', null, 'ma''alob = bien, bueno; áak''ab = noche' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bix a beel?', '¿cómo estás?', 'bix a beel', null, 'bix = cómo; a = tu; beel = camino' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ma''alob', 'bien', 'ma''-a-lob', null, 'ma''alob = bien, bueno' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kux teech?', '¿y tú?', 'kux teech', null, 'kux = y (para devolver la pregunta); teech = tú' from ct_languages where code = 'yua';

-- nivel 1 · unidad 2: despedidas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tak sáamal', 'hasta mañana', 'tak sáa-mal', null, 'tak = hasta; sáamal = mañana' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tak tu láak'' k''iin', 'hasta otro día', 'tak tu láak'' k''iin', null, 'tak = hasta; tu = en (el); láak'' = otro; k''iin = día' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Táan in bin', 'ya me voy (lit. estoy yendo)', 'táan in bin', null, 'táan = estar haciendo (progresivo); in = yo; bin = ir' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Sáamal', 'mañana', 'sáa-mal', null, 'sáamal = mañana (el día siguiente)' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bin', 'ir', 'bin', null, 'bin = ir' from ct_languages where code = 'yua';

-- nivel 1 · unidad 3: ¿quién eres?
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bix a k''aaba''?', '¿cómo te llamas?', 'bix a k''aa-ba''', null, 'bix = cómo; a = tu; k''aaba'' = nombre' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'In k''aaba''e''', 'mi nombre es', 'in k''aa-ba''-e''', null, 'in = mi; k''aaba'' = nombre; -e'' = marca de tema (lo que sigue es el nombre)' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'K''aaba''', 'nombre', 'k''aa-ba''', null, 'k''aaba'' = nombre' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Teen', 'yo', 'teen', null, 'teen = yo' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Teech', 'tú', 'teech', null, 'teech = tú' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Leti''', 'él / ella', 'le-ti''', null, 'leti'' = él, ella' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'U k''aaba''', 'su nombre (de él o ella)', 'u k''aa-ba''', null, 'u = su (de él o ella); k''aaba'' = nombre' from ct_languages where code = 'yua';

-- nivel 1 · unidad 4: agradecer y responder
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Dios bo''otik', 'gracias', 'dios bo''-o-tik', null, 'Dios = Dios; bo''otik = lo pague' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jach Dios bo''otik', 'muchas gracias', 'jach dios bo''-o-tik', null, 'jach = muy; Dios = Dios; bo''otik = lo pague' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Mix ba''al', 'de nada', 'mix ba''-al', null, 'mix = ni, nada; ba''al = cosa' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Je''el', 'sí', 'je''-el', null, 'je''el = sí, así es' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ma''', 'no', 'ma''', null, 'ma'' = no' from ct_languages where code = 'yua';

-- nivel 1 · unidad 5: cómo me siento
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ki''imak in wóol', 'estoy contento(a)', 'ki''-i-mak in wóol', null, 'ki''imak = alegre; in = mi; w- = enlace ante vocal; óol = ánimo, corazón' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ki''imak a wóol?', '¿estás contento(a)?', 'ki''-i-mak a wóol', null, 'ki''imak = alegre; a = tu; w- = enlace ante vocal; óol = ánimo, corazón' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'K''oja''anen', 'estoy enfermo(a)', 'k''o-ja''-a-nen', null, 'k''oja''an = enfermo; -en = yo' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ka''anen', 'estoy cansado(a)', 'ka''-a-nen', null, 'ka''an = cansado; -en = yo' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ma''aloben', 'estoy bien', 'ma''-a-lo-ben', null, 'ma''alob = bien; -en = yo' from ct_languages where code = 'yua';

-- nivel 1 · unidad 6: conversación básica
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Maaya t''aan', 'lengua maya', 'maa-ya t''aan', null, 'maaya = maya; t''aan = palabra, lengua' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kin t''aan ich maaya', 'hablo en maya', 'kin t''aan ich maa-ya', null, 'k- = siempre, de costumbre; in = yo; t''aan = hablar; ich = en; maaya = maya' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ba''ax ka wa''alik?', '¿qué dices?', 'ba''-ax ka wa''-a-lik', null, 'ba''ax = qué; k- + a = tú (de costumbre); w- = enlace ante vocal; a''alik = decir' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Yéetel', 'con / y', 'yée-tel', null, 'yéetel = con, y' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'T''aan', 'palabra / hablar', 't''aan', null, 't''aan = palabra, hablar' from ct_languages where code = 'yua';

-- nivel 2 · unidad 1: pronombres personales
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'To''on', 'nosotros(as)', 'to''-on', null, 'to''on = nosotros' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Te''ex', 'ustedes', 'te''-ex', null, 'te''ex = ustedes' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Leti''o''ob', 'ellos / ellas', 'le-ti''-o''-ob', null, 'leti'' = él, ella; -o''ob = plural' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Teen ko''olelen', 'yo soy mujer', 'teen ko''-o-le-len', null, 'teen = yo; ko''olel = mujer; -en = soy' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Teech xiibech', 'tú eres hombre', 'teech xii-bech', null, 'teech = tú; xiib = hombre; -ech = eres' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Wíiniko''ob', 'personas', 'wíi-ni-ko''-ob', null, 'wíinik = persona; -o''ob = plural' from ct_languages where code = 'yua';

-- nivel 2 · unidad 2: la familia
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Na''', 'mamá', 'na''', null, 'na'' = mamá' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Taata', 'papá', 'taa-ta', null, 'taata = papá' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Paal', 'niño / hijo', 'paal', null, 'paal = niño, hijo' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'In na''', 'mi mamá', 'in na''', null, 'in = mi; na'' = mamá' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'A taata', 'tu papá', 'a taa-ta', null, 'a = tu; taata = papá' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'In paal', 'mi hijo(a)', 'in paal', null, 'in = mi; paal = niño, hijo' from ct_languages where code = 'yua';

-- nivel 2 · unidad 3: los abuelos y los hermanos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chiich', 'abuela', 'chiich', null, 'chiich = abuela' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nool', 'abuelo', 'nool', null, 'nool = abuelo' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Suku''un', 'hermano mayor', 'su-ku''-un', null, 'suku''un = hermano mayor' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Íits''in', 'hermano menor', 'íi-ts''in', null, 'íits''in = hermano(a) menor' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kiik', 'hermana mayor', 'kiik', null, 'kiik = hermana mayor' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'In chiich', 'mi abuela', 'in chiich', null, 'in = mi; chiich = abuela' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'U suku''un', 'su hermano mayor', 'u su-ku''-un', null, 'u = su; suku''un = hermano mayor' from ct_languages where code = 'yua';

-- nivel 2 · unidad 4: cómo es
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nojoch', 'grande', 'no-joch', null, 'nojoch = grande' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chichan', 'pequeño(a)', 'chi-chan', null, 'chichan = pequeño' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jats''uts', 'bonito(a)', 'ja-ts''uts', null, 'jats''uts = bonito' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'K''aas', 'feo(a) / malo(a)', 'k''aas', null, 'k''aas = feo, malo' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nojoch naj', 'casa grande', 'no-joch naj', null, 'nojoch = grande; naj = casa' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chichan paal', 'niño pequeño', 'chi-chan paal', null, 'chichan = pequeño; paal = niño' from ct_languages where code = 'yua';

-- nivel 2 · unidad 5: los colores
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chak', 'rojo', 'chak', null, 'chak = rojo' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Sak', 'blanco', 'sak', null, 'sak = blanco' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Éek''', 'negro', 'éek''', null, 'éek'' = negro' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'K''an', 'amarillo', 'k''an', null, 'k''an = amarillo' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ya''ax', 'verde / azul', 'ya''-ax', null, 'ya''ax = verde, azul' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ya''ax che''', 'ceiba (lit. árbol verde)', 'ya''-ax che''', null, 'ya''ax = verde; che'' = árbol' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Sak nikte''', 'flor blanca', 'sak nik-te''', null, 'sak = blanco; nikte'' = flor' from ct_languages where code = 'yua';

-- nivel 2 · unidad 6: contar del uno al cinco
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jun', 'uno', 'jun', null, 'jun = uno' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ka''a', 'dos', 'ka''-a', null, 'ka''a = dos' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Óox', 'tres', 'óox', null, 'óox = tres' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kan', 'cuatro', 'kan', null, 'kan = cuatro' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jo''', 'cinco', 'jo''', null, 'jo'' = cinco' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jun p''éel', 'uno (una cosa)', 'jun p''éel', null, 'jun = uno; p''éel = clasificador de cosas' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ka''a túul paal', 'dos niños', 'ka''-a túul paal', null, 'ka''a = dos; túul = clasificador de seres vivos; paal = niño' from ct_languages where code = 'yua';

-- nivel 3 · unidad 1: palabras para preguntar
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ba''ax?', '¿qué?', 'ba''-ax', null, 'ba''ax = qué' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Máax?', '¿quién?', 'máax', null, 'máax = quién' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tu''ux?', '¿dónde?', 'tu''-ux', null, 'tu''ux = dónde' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ba''axten?', '¿por qué?', 'ba''-ax-ten', null, 'ba''axten = por qué (de ba''ax = qué)' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Máax teech?', '¿quién eres?', 'máax teech', null, 'máax = quién; teech = tú' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tu''ux ka bin?', '¿a dónde vas?', 'tu''-ux ka bin', null, 'tu''ux = dónde; k- + a = tú (de costumbre); bin = ir' from ct_languages where code = 'yua';

-- nivel 3 · unidad 2: mi casa y mi comunidad
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Naj', 'casa', 'naj', null, 'naj = casa' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kaaj', 'pueblo', 'kaaj', null, 'kaaj = pueblo' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kool', 'milpa', 'kool', null, 'kool = milpa' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'In naj', 'mi casa', 'in naj', null, 'in = mi; naj = casa' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tin naj', 'en mi casa', 'tin naj', null, 't- = en (de ti''); in = mi; naj = casa' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ich kaaj', 'en el pueblo', 'ich kaaj', null, 'ich = en, dentro; kaaj = pueblo' from ct_languages where code = 'yua';

-- nivel 3 · unidad 3: contar del seis al diez
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Wak', 'seis', 'wak', null, 'wak = seis' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Uk', 'siete', 'uk', null, 'uk = siete' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Waxak', 'ocho', 'wa-xak', null, 'waxak = ocho' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bolon', 'nueve', 'bo-lon', null, 'bolon = nueve' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Lajun', 'diez', 'la-jun', null, 'lajun = diez' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Lajun p''éel', 'diez cosas', 'la-jun p''éel', null, 'lajun = diez; p''éel = clasificador de cosas' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Wak túul máak', 'seis personas', 'wak túul máak', null, 'wak = seis; túul = clasificador de seres vivos; máak = persona' from ct_languages where code = 'yua';

-- nivel 3 · unidad 4: lugares y cosas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'K''áax', 'monte', 'k''áax', null, 'k''áax = monte, selva' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ja''', 'agua', 'ja''', null, 'ja'' = agua' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ts''ono''ot', 'cenote', 'ts''o-no''-ot', null, 'ts''ono''ot = cenote' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bej', 'camino', 'bej', null, 'bej = camino' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nojoch bej', 'carretera (lit. camino grande)', 'no-joch bej', null, 'nojoch = grande; bej = camino' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tu''ux yaan ja''?', '¿dónde hay agua?', 'tu''-ux yaan ja''', null, 'tu''ux = dónde; yaan = hay; ja'' = agua' from ct_languages where code = 'yua';

-- nivel 3 · unidad 5: cerca y lejos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Naats''', 'cerca', 'naats''', null, 'naats'' = cerca' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Náach', 'lejos', 'náach', null, 'náach = lejos' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Te''ela''', 'aquí', 'te''-e-la''', null, 'te''el = lugar; -a'' = este, aquí' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Te''elo''', 'allá', 'te''-e-lo''', null, 'te''el = lugar; -o'' = ese, allá' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Naats'' le kaajo''', 'el pueblo está cerca', 'naats'' le kaa-jo''', null, 'naats'' = cerca; le ... -o'' = ese, el; kaaj = pueblo' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Náach in naj', 'mi casa está lejos', 'náach in naj', null, 'náach = lejos; in = mi; naj = casa' from ct_languages where code = 'yua';

-- nivel 3 · unidad 6: preguntas útiles
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bajux?', '¿cuánto cuesta?', 'ba-jux', null, 'bajux = cuánto cuesta' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bajux le je''ela''?', '¿cuánto cuesta esto?', 'ba-jux le je''-e-la''', null, 'bajux = cuánto cuesta; le je''el ... -a'' = esto' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ma'' in na''atik', 'no entiendo', 'ma'' in na''-a-tik', null, 'ma'' = no; in = yo; na''atik = entender' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ts''áaten ja''', 'dame agua', 'ts''áa-ten ja''', null, 'ts''a = dar; -en = a mí; ja'' = agua' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jaytúul a paalal?', '¿cuántos hijos tienes?', 'jay-túul a paa-lal', null, 'jay = cuántos; túul = clasificador de seres vivos; a = tu; paalal = hijos' from ct_languages where code = 'yua';

-- nivel 4 · unidad 1: hoy, ayer y mañana
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bejla''e''', 'hoy', 'bej-la''-e''', null, 'bejla'' = hoy; -e'' = marca de tema' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Joolje''ej', 'ayer', 'jool-je''-ej', null, 'joolje''ej = ayer' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ka''abej', 'pasado mañana', 'ka''-a-bej', null, 'ka''abej = pasado mañana' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Joolje''ej tin bin', 'ayer fui', 'jool-je''-ej tin bin', null, 'joolje''ej = ayer; t- = ya pasó (completivo); in = yo; bin = ir' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Sáamal yaan in bin', 'mañana voy a ir', 'sáa-mal yaan in bin', null, 'sáamal = mañana; yaan = tener que; in = yo; bin = ir' from ct_languages where code = 'yua';

-- nivel 4 · unidad 2: la naturaleza
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'K''iin', 'sol / día', 'k''iin', null, 'k''iin = sol, día' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Che''', 'árbol', 'che''', null, 'che'' = árbol, madera' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Lu''um', 'tierra', 'lu''-um', null, 'lu''um = tierra' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Cháak', 'lluvia', 'cháak', null, 'cháak = lluvia' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ka''an', 'cielo', 'ka''-an', null, 'ka''an = cielo' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ek''', 'estrella', 'ek''', null, 'ek'' = estrella' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nojoch che''', 'árbol grande', 'no-joch che''', null, 'nojoch = grande; che'' = árbol' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Táan u k''áaxal ja''', 'está lloviendo', 'táan u k''áa-xal ja''', null, 'táan = estar haciendo; u = su; k''áaxal = caer; ja'' = agua' from ct_languages where code = 'yua';

-- nivel 4 · unidad 3: lo que hago
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Meyaj', 'trabajo / trabajar', 'me-yaj', null, 'meyaj = trabajo, trabajar' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Janal', 'comida / comer', 'ja-nal', null, 'janal = comida, comer' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xook', 'estudiar / leer', 'xook', null, 'xook = estudiar, leer' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kin meyaj', 'trabajo', 'kin me-yaj', null, 'k- = de costumbre; in = yo; meyaj = trabajar' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kin janal', 'como', 'kin ja-nal', null, 'k- = de costumbre; in = yo; janal = comer' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kin xook', 'estudio', 'kin xook', null, 'k- = de costumbre; in = yo; xook = estudiar' from ct_languages where code = 'yua';

-- nivel 4 · unidad 4: lo que pasó
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tin meyaj', 'trabajé', 'tin me-yaj', null, 't- = ya pasó (completivo); in = yo; meyaj = trabajar' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tin janal', 'comí', 'tin ja-nal', null, 't- = ya pasó (completivo); in = yo; janal = comer' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tin xook', 'estudié', 'tin xook', null, 't- = ya pasó (completivo); in = yo; xook = estudiar' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ts''o''ok', 'ya (terminó)', 'ts''o''-ok', null, 'ts''o''ok = terminar, ya' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ts''o''ok in janal', 'ya comí', 'ts''o''-ok in ja-nal', null, 'ts''o''ok = ya, terminar; in = yo; janal = comer' from ct_languages where code = 'yua';

-- nivel 4 · unidad 5: ahora y después
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Táan', 'estar haciendo (ahora)', 'táan', null, 'táan = estar haciendo (progresivo)' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ma''ili''', 'todavía no', 'ma''-i-li''', null, 'ma'' = no; -ili'' = todavía' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Táan in janal', 'estoy comiendo', 'táan in ja-nal', null, 'táan = estar haciendo; in = yo; janal = comer' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Táan in meyaj', 'estoy trabajando', 'táan in me-yaj', null, 'táan = estar haciendo; in = yo; meyaj = trabajar' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Táan a xook?', '¿estás estudiando?', 'táan a xook', null, 'táan = estar haciendo; a = tú; xook = estudiar' from ct_languages where code = 'yua';

-- nivel 4 · unidad 6: repaso del tiempo
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ja''ab', 'año', 'ja''-ab', null, 'ja''ab = año' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Úuj', 'luna / mes', 'úuj', null, 'úuj = luna, mes' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jun ja''ab', 'un año', 'jun ja''-ab', null, 'jun = uno; ja''ab = año' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ka''a k''iin', 'dos días', 'ka''-a k''iin', null, 'ka''a = dos; k''iin = día' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Le ja''aba''', 'este año', 'le ja''-a-ba''', null, 'le ... -a'' = este; ja''ab = año' from ct_languages where code = 'yua';

-- nivel 5 · unidad 1: la comida
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Waaj', 'tortilla', 'waaj', null, 'waaj = tortilla' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ixi''im', 'maíz', 'i-xi''-im', null, 'ixi''im = maíz' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bu''ul', 'frijol', 'bu''-ul', null, 'bu''ul = frijol' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Iik', 'chile', 'iik', null, 'iik = chile' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Waaj yéetel bu''ul', 'tortilla con frijol', 'waaj yée-tel bu''-ul', null, 'waaj = tortilla; yéetel = con; bu''ul = frijol' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ki'' le janalo''', 'la comida está sabrosa', 'ki'' le ja-na-lo''', null, 'ki'' = sabroso; le ... -o'' = esa, la; janal = comida' from ct_languages where code = 'yua';

-- nivel 5 · unidad 2: frutas y plantas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ja''as', 'plátano', 'ja''-as', null, 'ja''as = plátano' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Pak''al', 'naranja', 'pa-k''al', null, 'pak''al = naranja' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nikte''', 'flor', 'nik-te''', null, 'nikte'' = flor' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xíiw', 'hierba', 'xíiw', null, 'xíiw = hierba' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ki''ichpam nikte''', 'flor hermosa', 'ki''-ich-pam nik-te''', null, 'ki''ichpam = hermoso; nikte'' = flor' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ya''ab ja''as', 'muchos plátanos', 'ya''-ab ja''-as', null, 'ya''ab = mucho; ja''as = plátano' from ct_languages where code = 'yua';

-- nivel 5 · unidad 3: en la cocina
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'K''óoben', 'cocina', 'k''óo-ben', null, 'k''óoben = cocina (las tres piedras del fogón)' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'K''áak''', 'fuego', 'k''áak''', null, 'k''áak'' = fuego' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kúum', 'olla', 'kúum', null, 'kúum = olla' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Luuch', 'jícara', 'luuch', null, 'luuch = jícara' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ti'' k''óoben', 'en la cocina', 'ti'' k''óo-ben', null, 'ti'' = en; k''óoben = cocina' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ts''a k''áak''', 'prende el fuego (lit. pon fuego)', 'ts''a k''áak''', null, 'ts''a = poner, dar; k''áak'' = fuego' from ct_languages where code = 'yua';

-- nivel 5 · unidad 4: acciones del día
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ajal', 'despertar', 'a-jal', null, 'ajal = despertar' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xíimbal', 'caminar', 'xíim-bal', null, 'xíimbal = caminar, pasear' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Taal', 'venir', 'taal', null, 'taal = venir' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kin ajal', 'me despierto', 'kin a-jal', null, 'k- = de costumbre; in = yo; ajal = despertar' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kin xíimbal', 'camino', 'kin xíim-bal', null, 'k- = de costumbre; in = yo; xíimbal = caminar' from ct_languages where code = 'yua';

-- nivel 5 · unidad 5: trabajos de la casa
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nook''', 'ropa', 'nook''', null, 'nook'' = ropa' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'P''o''', 'lavar', 'p''o''', null, 'p''o'' = lavar' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Míis', 'barrer', 'míis', null, 'míis = barrer' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kin p''o'' nook''', 'lavo ropa', 'kin p''o'' nook''', null, 'k- = de costumbre; in = yo; p''o'' = lavar; nook'' = ropa' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Meyaj ich kool', 'trabajar en la milpa', 'me-yaj ich kool', null, 'meyaj = trabajar; ich = en, dentro; kool = milpa' from ct_languages where code = 'yua';

-- nivel 5 · unidad 6: caliente y frío
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chokoj', 'caliente', 'cho-koj', null, 'chokoj = caliente' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Síis', 'frío (agua, cosas)', 'síis', null, 'síis = frío, fresco' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ke''el', 'frío (tiempo)', 'ke''-el', null, 'ke''el = frío' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chokoj ja''', 'agua caliente', 'cho-koj ja''', null, 'chokoj = caliente; ja'' = agua' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Síis ja''', 'agua fría', 'síis ja''', null, 'síis = frío; ja'' = agua' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jach chokoj', 'hace mucho calor (lit. muy caliente)', 'jach cho-koj', null, 'jach = muy; chokoj = caliente' from ct_languages where code = 'yua';

-- nivel 6 · unidad 1: animales del monte
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kéej', 'venado', 'kéej', null, 'kéej = venado' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ba''alam', 'jaguar', 'ba''-a-lam', null, 'ba''alam = jaguar' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ma''ax', 'mono', 'ma''-ax', null, 'ma''ax = mono' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ch''íich''', 'pájaro', 'ch''íich''', null, 'ch''íich'' = pájaro' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kaan', 'serpiente', 'kaan', null, 'kaan = serpiente' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ch''íich''o''ob', 'pájaros', 'ch''íi-ch''o''-ob', null, 'ch''íich'' = pájaro; -o''ob = plural' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nojoch ba''alam', 'jaguar grande', 'no-joch ba''-a-lam', null, 'nojoch = grande; ba''alam = jaguar' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Óox túul kéej', 'tres venados', 'óox túul kéej', null, 'óox = tres; túul = clasificador de seres vivos; kéej = venado' from ct_languages where code = 'yua';

-- nivel 6 · unidad 2: animales de la casa
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Peek''', 'perro', 'peek''', null, 'peek'' = perro' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Miis', 'gato', 'miis', null, 'miis = gato' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kaax', 'gallina', 'kaax', null, 'kaax = gallina' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tso''', 'pavo', 'tso''', null, 'tso'' = pavo' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'K''éek''en', 'cerdo', 'k''ée-k''en', null, 'k''éek''en = cerdo' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'In peek''', 'mi perro', 'in peek''', null, 'in = mi; peek'' = perro' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ka''a túul miis', 'dos gatos', 'ka''-a túul miis', null, 'ka''a = dos; túul = clasificador de seres vivos; miis = gato' from ct_languages where code = 'yua';

-- nivel 6 · unidad 3: el cuerpo
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Pool', 'cabeza', 'pool', null, 'pool = cabeza' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'K''ab', 'mano / brazo', 'k''ab', null, 'k''ab = mano, brazo' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ook', 'pie', 'ook', null, 'ook = pie' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ich', 'ojo / cara', 'ich', null, 'ich = ojo, cara' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chi''', 'boca', 'chi''', null, 'chi'' = boca' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'In k''ab', 'mi mano', 'in k''ab', null, 'in = mi; k''ab = mano' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Yaj in pool', 'me duele la cabeza', 'yaj in pool', null, 'yaj = duele; in = mi; pool = cabeza' from ct_languages where code = 'yua';

-- nivel 6 · unidad 4: lo que quiero y lo que tengo
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'In k''áat', 'quiero', 'in k''áat', null, 'in = yo; k''áat = querer' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Yaan ten', 'tengo (lit. hay para mí)', 'yaan ten', null, 'yaan = hay; ten = a mí, para mí' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ba''ax a k''áat?', '¿qué quieres?', 'ba''-ax a k''áat', null, 'ba''ax = qué; a = tú; k''áat = querer' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'In k''áat janal', 'quiero comer', 'in k''áat ja-nal', null, 'in = yo; k''áat = querer; janal = comer' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Yaan ten jun túul peek''', 'tengo un perro', 'yaan ten jun túul peek''', null, 'yaan = hay; ten = a mí; jun = uno; túul = clasificador de seres vivos; peek'' = perro' from ct_languages where code = 'yua';

-- nivel 6 · unidad 5: expresiones
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bey', 'así', 'bey', null, 'bey = así' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bey xan', 'igualmente', 'bey xan', null, 'bey = así; xan = también' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ko''one''ex', 'vámonos', 'ko''-o-ne''-ex', null, 'ko''ox = vamos; -e''ex = ustedes' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jach ma''alob', 'muy bien', 'jach ma''-a-lob', null, 'jach = muy; ma''alob = bien' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Je''el u páajtal', 'sí se puede', 'je''-el u páaj-tal', null, 'je''el = sí, ya; u = su; páajtal = poder' from ct_languages where code = 'yua';

-- nivel 6 · unidad 6: conversación final
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'In yaakumech', 'te quiero', 'in yaa-ku-mech', null, 'in = yo; yaakun = amar, querer; -ech = a ti' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tu''ux ka taal?', '¿de dónde vienes?', 'tu''-ux ka taal', null, 'tu''ux = dónde; k- + a = tú (de costumbre); taal = venir' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Kin kanik maaya', 'aprendo maya', 'kin ka-nik maa-ya', null, 'k- = de costumbre; in = yo; kanik = aprender; maaya = maya' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Yuum bo''otik', 'gracias (lit. que el señor lo pague)', 'yuum bo''-o-tik', null, 'yuum = señor; bo''otik = lo pague' from ct_languages where code = 'yua';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ki''imak in wóol in wilikech', 'me da gusto verte', 'ki''-i-mak in wóol in wi-li-kech', null, 'ki''imak = alegre; in wóol = mi corazón; in = yo; w- = enlace; il = ver; -ik = (transitivo); -ech = a ti' from ct_languages where code = 'yua';

-- ─────────────────────────────────────────────
--  5. rl_unit_vocab — vocabulario por unidad
-- ─────────────────────────────────────────────
-- nivel 1 · unidad 1: saludos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1
and v.word in ('Ma''alob k''iin', 'Ma''alob chíinil k''iin', 'Ma''alob áak''ab', 'Bix a beel?', 'Ma''alob', 'Kux teech?');

-- nivel 1 · unidad 2: despedidas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 2
and v.word in ('Tak sáamal', 'Tak tu láak'' k''iin', 'Táan in bin', 'Sáamal', 'Bin');

-- nivel 1 · unidad 3: ¿quién eres?
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 3
and v.word in ('Bix a k''aaba''?', 'In k''aaba''e''', 'K''aaba''', 'Teen', 'Teech', 'Leti''', 'U k''aaba''');

-- nivel 1 · unidad 4: agradecer y responder
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 4
and v.word in ('Dios bo''otik', 'Jach Dios bo''otik', 'Mix ba''al', 'Je''el', 'Ma''');

-- nivel 1 · unidad 5: cómo me siento
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 5
and v.word in ('Ki''imak in wóol', 'Ki''imak a wóol?', 'K''oja''anen', 'Ka''anen', 'Ma''aloben');

-- nivel 1 · unidad 6: conversación básica
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 6
and v.word in ('Maaya t''aan', 'Kin t''aan ich maaya', 'Ba''ax ka wa''alik?', 'Yéetel', 'T''aan');

-- nivel 2 · unidad 1: pronombres personales
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 1
and v.word in ('To''on', 'Te''ex', 'Leti''o''ob', 'Teen ko''olelen', 'Teech xiibech', 'Wíiniko''ob');

-- nivel 2 · unidad 2: la familia
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 2
and v.word in ('Na''', 'Taata', 'Paal', 'In na''', 'A taata', 'In paal');

-- nivel 2 · unidad 3: los abuelos y los hermanos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 3
and v.word in ('Chiich', 'Nool', 'Suku''un', 'Íits''in', 'Kiik', 'In chiich', 'U suku''un');

-- nivel 2 · unidad 4: cómo es
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 4
and v.word in ('Nojoch', 'Chichan', 'Jats''uts', 'K''aas', 'Nojoch naj', 'Chichan paal');

-- nivel 2 · unidad 5: los colores
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 5
and v.word in ('Chak', 'Sak', 'Éek''', 'K''an', 'Ya''ax', 'Ya''ax che''', 'Sak nikte''');

-- nivel 2 · unidad 6: contar del uno al cinco
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 6
and v.word in ('Jun', 'Ka''a', 'Óox', 'Kan', 'Jo''', 'Jun p''éel', 'Ka''a túul paal');

-- nivel 3 · unidad 1: palabras para preguntar
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 1
and v.word in ('Ba''ax?', 'Máax?', 'Tu''ux?', 'Ba''axten?', 'Máax teech?', 'Tu''ux ka bin?');

-- nivel 3 · unidad 2: mi casa y mi comunidad
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 2
and v.word in ('Naj', 'Kaaj', 'Kool', 'In naj', 'Tin naj', 'Ich kaaj');

-- nivel 3 · unidad 3: contar del seis al diez
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 3
and v.word in ('Wak', 'Uk', 'Waxak', 'Bolon', 'Lajun', 'Lajun p''éel', 'Wak túul máak');

-- nivel 3 · unidad 4: lugares y cosas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 4
and v.word in ('K''áax', 'Ja''', 'Ts''ono''ot', 'Bej', 'Nojoch bej', 'Tu''ux yaan ja''?');

-- nivel 3 · unidad 5: cerca y lejos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 5
and v.word in ('Naats''', 'Náach', 'Te''ela''', 'Te''elo''', 'Naats'' le kaajo''', 'Náach in naj');

-- nivel 3 · unidad 6: preguntas útiles
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 6
and v.word in ('Bajux?', 'Bajux le je''ela''?', 'Ma'' in na''atik', 'Ts''áaten ja''', 'Jaytúul a paalal?');

-- nivel 4 · unidad 1: hoy, ayer y mañana
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 1
and v.word in ('Bejla''e''', 'Joolje''ej', 'Ka''abej', 'Joolje''ej tin bin', 'Sáamal yaan in bin');

-- nivel 4 · unidad 2: la naturaleza
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 2
and v.word in ('K''iin', 'Che''', 'Lu''um', 'Cháak', 'Ka''an', 'Ek''', 'Nojoch che''', 'Táan u k''áaxal ja''');

-- nivel 4 · unidad 3: lo que hago
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 3
and v.word in ('Meyaj', 'Janal', 'Xook', 'Kin meyaj', 'Kin janal', 'Kin xook');

-- nivel 4 · unidad 4: lo que pasó
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 4
and v.word in ('Tin meyaj', 'Tin janal', 'Tin xook', 'Ts''o''ok', 'Ts''o''ok in janal');

-- nivel 4 · unidad 5: ahora y después
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 5
and v.word in ('Táan', 'Ma''ili''', 'Táan in janal', 'Táan in meyaj', 'Táan a xook?');

-- nivel 4 · unidad 6: repaso del tiempo
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 6
and v.word in ('Ja''ab', 'Úuj', 'Jun ja''ab', 'Ka''a k''iin', 'Le ja''aba''');

-- nivel 5 · unidad 1: la comida
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 1
and v.word in ('Waaj', 'Ixi''im', 'Bu''ul', 'Iik', 'Waaj yéetel bu''ul', 'Ki'' le janalo''');

-- nivel 5 · unidad 2: frutas y plantas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 2
and v.word in ('Ja''as', 'Pak''al', 'Nikte''', 'Xíiw', 'Ki''ichpam nikte''', 'Ya''ab ja''as');

-- nivel 5 · unidad 3: en la cocina
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 3
and v.word in ('K''óoben', 'K''áak''', 'Kúum', 'Luuch', 'Ti'' k''óoben', 'Ts''a k''áak''');

-- nivel 5 · unidad 4: acciones del día
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 4
and v.word in ('Ajal', 'Xíimbal', 'Taal', 'Kin ajal', 'Kin xíimbal');

-- nivel 5 · unidad 5: trabajos de la casa
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 5
and v.word in ('Nook''', 'P''o''', 'Míis', 'Kin p''o'' nook''', 'Meyaj ich kool');

-- nivel 5 · unidad 6: caliente y frío
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 6
and v.word in ('Chokoj', 'Síis', 'Ke''el', 'Chokoj ja''', 'Síis ja''', 'Jach chokoj');

-- nivel 6 · unidad 1: animales del monte
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 1
and v.word in ('Kéej', 'Ba''alam', 'Ma''ax', 'Ch''íich''', 'Kaan', 'Ch''íich''o''ob', 'Nojoch ba''alam', 'Óox túul kéej');

-- nivel 6 · unidad 2: animales de la casa
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 2
and v.word in ('Peek''', 'Miis', 'Kaax', 'Tso''', 'K''éek''en', 'In peek''', 'Ka''a túul miis');

-- nivel 6 · unidad 3: el cuerpo
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 3
and v.word in ('Pool', 'K''ab', 'Ook', 'Ich', 'Chi''', 'In k''ab', 'Yaj in pool');

-- nivel 6 · unidad 4: lo que quiero y lo que tengo
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 4
and v.word in ('In k''áat', 'Yaan ten', 'Ba''ax a k''áat?', 'In k''áat janal', 'Yaan ten jun túul peek''');

-- nivel 6 · unidad 5: expresiones
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 5
and v.word in ('Bey', 'Bey xan', 'Ko''one''ex', 'Jach ma''alob', 'Je''el u páajtal');

-- nivel 6 · unidad 6: conversación final
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 6
and v.word in ('In yaakumech', 'Tu''ux ka taal?', 'Kin kanik maaya', 'Yuum bo''otik', 'Ki''imak in wóol in wilikech');

-- ─────────────────────────────────────────────
--  6. ejercicios (6 por unidad: 4 opción múltiple + 2 completar)
-- ─────────────────────────────────────────────
-- nivel 1 · unidad 1: saludos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buenos días',
       '["Ma''alob k''iin"]',
       '["Bin", "Ma''alob k''iin", "Dios bo''otik", "Maaya t''aan"]',
       'citlali',
       'Ma''alob k''iin: ma''alob (bien, bueno) + k''iin (sol, día)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buenas tardes',
       '["Ma''alob chíinil k''iin"]',
       '["Ma''alob chíinil k''iin", "Teech", "Táan in bin", "Mix ba''al"]',
       'coltzin',
       'Ma''alob chíinil k''iin: ma''alob (bien, bueno) + chíinil (inclinado) + k''iin (sol (el sol inclinado = la tarde))',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Buenas noches',
       '["Ma''alob áak''ab"]',
       '["T''aan", "Ma''alob áak''ab", "Tak tu láak'' k''iin", "Yéetel"]',
       'neza',
       'Ma''alob áak''ab: ma''alob (bien, bueno) + áak''ab (noche)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Bien',
       '["Ma''alob"]',
       '["K''oja''anen", "Jach Dios bo''otik", "Ma''alob", "Sáamal"]',
       'tonatiuh',
       'Ma''alob significa bien',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Bix a ______?',
       '["beel", "Bix a beel?", "Bix a beel"]',
       null,
       'xochitl',
       'beel = camino',
       20, 'medium',
       '¿Cómo estás?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kux ______?',
       '["teech", "Kux teech?", "Kux teech"]',
       null,
       'citlali',
       'teech = tú',
       20, 'medium',
       '¿Y tú?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1;

-- nivel 1 · unidad 2: despedidas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hasta mañana',
       '["Tak sáamal"]',
       '["Tak sáamal", "Teech", "U k''aaba''", "Maaya t''aan"]',
       'coltzin',
       'Tak sáamal: tak (hasta) + sáamal (mañana)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mañana',
       '["Sáamal"]',
       '["Sáamal", "Mix ba''al", "Ma''alob k''iin", "Yéetel"]',
       'neza',
       'Sáamal significa mañana',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ir',
       '["Bin"]',
       '["Kin t''aan ich maaya", "Ma''", "Bin", "Je''el"]',
       'tonatiuh',
       'Bin significa ir',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hasta otro día',
       '["Tak tu láak'' k''iin"]',
       '["Tak tu láak'' k''iin", "Dios bo''otik", "In k''aaba''e''", "Maaya t''aan"]',
       'xochitl',
       'Tak tu láak'' k''iin: tak (hasta) + tu (en (el)) + láak'' (otro) + k''iin (día)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tak tu láak'' ______',
       '["k''iin", "Tak tu láak'' k''iin"]',
       null,
       'citlali',
       'k''iin = día',
       20, 'medium',
       'Hasta otro día'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Táan in ______',
       '["bin", "Táan in bin"]',
       null,
       'coltzin',
       'bin = ir',
       20, 'medium',
       'Ya me voy'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 2;

-- nivel 1 · unidad 3: ¿quién eres?
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cómo te llamas?',
       '["Bix a k''aaba''?"]',
       '["Bix a beel?", "Ba''ax ka wa''alik?", "Kux teech?", "Bix a k''aaba''?"]',
       'neza',
       'Bix a k''aaba''?: bix (cómo) + a (tu) + k''aaba'' (nombre)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nombre',
       '["K''aaba''"]',
       '["Jach Dios bo''otik", "K''aaba''", "Ma''alob", "T''aan"]',
       'tonatiuh',
       'K''aaba'' significa nombre',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Yo',
       '["Teen"]',
       '["Mix ba''al", "T''aan", "Táan in bin", "Teen"]',
       'xochitl',
       'Teen significa yo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tú',
       '["Teech"]',
       '["U k''aaba''", "Mix ba''al", "K''aaba''", "Teech"]',
       'citlali',
       'Teech significa tú',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'In ______',
       '["k''aaba''e''", "In k''aaba''e''"]',
       null,
       'coltzin',
       'In k''aaba''e'': in (mi) + k''aaba'' (nombre) + -e'' (marca de tema (lo que sigue es el nombre))',
       20, 'medium',
       'Mi nombre es'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'U ______',
       '["k''aaba''", "U k''aaba''"]',
       null,
       'neza',
       'k''aaba'' = nombre',
       20, 'medium',
       'Su nombre (de él o ella)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 3;

-- nivel 1 · unidad 4: agradecer y responder
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Gracias',
       '["Dios bo''otik"]',
       '["Teech", "Leti''", "In k''aaba''e''", "Dios bo''otik"]',
       'tonatiuh',
       'Dios bo''otik: Dios (Dios) + bo''otik (lo pague)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Sí',
       '["Je''el"]',
       '["Bin", "Yéetel", "T''aan", "Je''el"]',
       'xochitl',
       'Je''el significa sí',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'No',
       '["Ma''"]',
       '["Teech", "Tak sáamal", "Je''el", "Ma''"]',
       'citlali',
       'Ma'' significa no',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muchas gracias',
       '["Jach Dios bo''otik"]',
       '["Bin", "Je''el", "K''aaba''", "Jach Dios bo''otik"]',
       'coltzin',
       'Jach Dios bo''otik: jach (muy) + Dios (Dios) + bo''otik (lo pague)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Jach Dios ______',
       '["bo''otik", "Jach Dios bo''otik"]',
       null,
       'neza',
       'bo''otik = lo pague',
       20, 'medium',
       'Muchas gracias'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Mix ______',
       '["ba''al", "Mix ba''al"]',
       null,
       'tonatiuh',
       'ba''al = cosa',
       20, 'medium',
       'De nada'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 4;

-- nivel 1 · unidad 5: cómo me siento
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estoy enfermo(a)',
       '["K''oja''anen"]',
       '["K''oja''anen", "Ma''alob chíinil k''iin", "Kin t''aan ich maaya", "Teech"]',
       'xochitl',
       'K''oja''anen: k''oja''an (enfermo) + -en (yo)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estoy cansado(a)',
       '["Ka''anen"]',
       '["Leti''", "Jach Dios bo''otik", "U k''aaba''", "Ka''anen"]',
       'citlali',
       'Ka''anen: ka''an (cansado) + -en (yo)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estoy bien',
       '["Ma''aloben"]',
       '["Ma''aloben", "Ma''alob", "Ki''imak in wóol", "Ma''alob k''iin"]',
       'coltzin',
       'Ma''aloben: ma''alob (bien) + -en (yo)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estoy contento(a)',
       '["Ki''imak in wóol"]',
       '["Dios bo''otik", "Jach Dios bo''otik", "Ki''imak in wóol", "U k''aaba''"]',
       'neza',
       'Ki''imak in wóol: ki''imak (alegre) + in (mi) + w- (enlace ante vocal) + óol (ánimo, corazón)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ki''imak in ______',
       '["wóol", "Ki''imak in wóol"]',
       null,
       'tonatiuh',
       'Ki''imak in wóol: ki''imak (alegre) + in (mi) + w- (enlace ante vocal) + óol (ánimo, corazón)',
       20, 'medium',
       'Estoy contento(a)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ki''imak a ______?',
       '["wóol", "Ki''imak a wóol?", "Ki''imak a wóol"]',
       null,
       'xochitl',
       'Ki''imak a wóol?: ki''imak (alegre) + a (tu) + w- (enlace ante vocal) + óol (ánimo, corazón)',
       20, 'medium',
       '¿Estás contento(a)?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 5;

-- nivel 1 · unidad 6: conversación básica
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lengua maya',
       '["Maaya t''aan"]',
       '["Maaya t''aan", "Ma''alob", "Dios bo''otik", "Ma''alob chíinil k''iin"]',
       'citlali',
       'Maaya t''aan: maaya (maya) + t''aan (palabra, lengua)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Con',
       '["Yéetel"]',
       '["Teech", "Yéetel", "Táan in bin", "Ma''alob chíinil k''iin"]',
       'coltzin',
       'Yéetel significa con',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Palabra',
       '["T''aan"]',
       '["T''aan", "Dios bo''otik", "Je''el", "Sáamal"]',
       'neza',
       'T''aan significa palabra',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hablo en maya',
       '["Kin t''aan ich maaya"]',
       '["Yéetel", "Kin t''aan ich maaya", "Sáamal", "Bin"]',
       'tonatiuh',
       'Kin t''aan ich maaya: k- (siempre, de costumbre) + in (yo) + t''aan (hablar) + ich (en) + maaya (maya)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kin t''aan ich ______',
       '["maaya", "Kin t''aan ich maaya"]',
       null,
       'xochitl',
       'maaya = maya',
       20, 'medium',
       'Hablo en maya'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ba''ax ka ______?',
       '["wa''alik", "Ba''ax ka wa''alik?", "Ba''ax ka wa''alik"]',
       null,
       'citlali',
       'Ba''ax ka wa''alik?: ba''ax (qué) + k- + a (tú (de costumbre)) + w- (enlace ante vocal) + a''alik (decir)',
       20, 'medium',
       '¿Qué dices?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 1 and u.unit_num = 6;

-- nivel 2 · unidad 1: pronombres personales
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nosotros(as)',
       '["To''on"]',
       '["U suku''un", "In na''", "Nojoch", "To''on"]',
       'coltzin',
       'To''on significa nosotros(as)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ustedes',
       '["Te''ex"]',
       '["Éek''", "Ya''ax che''", "K''oja''anen", "Te''ex"]',
       'neza',
       'Te''ex significa ustedes',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ellos',
       '["Leti''o''ob"]',
       '["Íits''in", "Éek''", "Ma''", "Leti''o''ob"]',
       'tonatiuh',
       'Leti''o''ob: leti'' (él, ella) + -o''ob (plural)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Personas',
       '["Wíiniko''ob"]',
       '["Sáamal", "Na''", "Wíiniko''ob", "Jats''uts"]',
       'xochitl',
       'Wíiniko''ob: wíinik (persona) + -o''ob (plural)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Teen ______',
       '["ko''olelen", "Teen ko''olelen"]',
       null,
       'citlali',
       'Teen ko''olelen: teen (yo) + ko''olel (mujer) + -en (soy)',
       20, 'medium',
       'Yo soy mujer'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Teech ______',
       '["xiibech", "Teech xiibech"]',
       null,
       'coltzin',
       'Teech xiibech: teech (tú) + xiib (hombre) + -ech (eres)',
       20, 'medium',
       'Tú eres hombre'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 1;

-- nivel 2 · unidad 2: la familia
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mamá',
       '["Na''"]',
       '["Je''el", "Jun p''éel", "Na''", "Jo''"]',
       'neza',
       'Na'' significa mamá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Papá',
       '["Taata"]',
       '["K''an", "In k''aaba''e''", "Taata", "Ma''alob k''iin"]',
       'tonatiuh',
       'Taata significa papá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Niño',
       '["Paal"]',
       '["Suku''un", "Je''el", "Paal", "Nool"]',
       'xochitl',
       'Paal significa niño',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi mamá',
       '["In na''"]',
       '["U k''aaba''", "Chiich", "In na''", "Jach Dios bo''otik"]',
       'citlali',
       'In na'': in (mi) + na'' (mamá)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'A ______',
       '["taata", "A taata"]',
       null,
       'coltzin',
       'taata = papá',
       20, 'medium',
       'Tu papá'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'In ______',
       '["paal", "In paal"]',
       null,
       'neza',
       'paal = niño, hijo',
       20, 'medium',
       'Mi hijo(a)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 2;

-- nivel 2 · unidad 3: los abuelos y los hermanos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Abuela',
       '["Chiich"]',
       '["Je''el", "Yéetel", "Chiich", "Táan in bin"]',
       'tonatiuh',
       'Chiich significa abuela',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Abuelo',
       '["Nool"]',
       '["Ya''ax che''", "Nool", "Ma''alob chíinil k''iin", "A taata"]',
       'xochitl',
       'Nool significa abuelo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hermano mayor',
       '["Suku''un"]',
       '["Nool", "T''aan", "Suku''un", "Na''"]',
       'citlali',
       'Suku''un significa hermano mayor',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hermano menor',
       '["Íits''in"]',
       '["Sak nikte''", "K''an", "K''oja''anen", "Íits''in"]',
       'coltzin',
       'Íits''in significa hermano menor',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'In ______',
       '["chiich", "In chiich"]',
       null,
       'neza',
       'chiich = abuela',
       20, 'medium',
       'Mi abuela'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'U ______',
       '["suku''un", "U suku''un"]',
       null,
       'tonatiuh',
       'suku''un = hermano mayor',
       20, 'medium',
       'Su hermano mayor'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 3;

-- nivel 2 · unidad 4: cómo es
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Grande',
       '["Nojoch"]',
       '["Sak nikte''", "Nojoch", "Kin t''aan ich maaya", "Taata"]',
       'xochitl',
       'Nojoch significa grande',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pequeño(a)',
       '["Chichan"]',
       '["K''oja''anen", "Leti''o''ob", "Chak", "Chichan"]',
       'citlali',
       'Chichan significa pequeño(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Bonito(a)',
       '["Jats''uts"]',
       '["Jats''uts", "U suku''un", "Jun", "Chichan paal"]',
       'coltzin',
       'Jats''uts significa bonito(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Feo(a)',
       '["K''aas"]',
       '["Taata", "Leti''", "K''aas", "Ka''a"]',
       'neza',
       'K''aas significa feo(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nojoch ______',
       '["naj", "Nojoch naj"]',
       null,
       'tonatiuh',
       'naj = casa',
       20, 'medium',
       'Casa grande'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Chichan ______',
       '["paal", "Chichan paal"]',
       null,
       'xochitl',
       'paal = niño',
       20, 'medium',
       'Niño pequeño'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 4;

-- nivel 2 · unidad 5: los colores
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Rojo',
       '["Chak"]',
       '["Chak", "Teech", "Bin", "In paal"]',
       'citlali',
       'Chak significa rojo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Blanco',
       '["Sak"]',
       '["Sak", "In na''", "Jun", "Chiich"]',
       'coltzin',
       'Sak significa blanco',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Negro',
       '["Éek''"]',
       '["Éek''", "Taata", "Bin", "Tak sáamal"]',
       'neza',
       'Éek'' significa negro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Amarillo',
       '["K''an"]',
       '["Jats''uts", "Leti''o''ob", "Yéetel", "K''an"]',
       'tonatiuh',
       'K''an significa amarillo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ya''ax ______',
       '["che''", "Ya''ax che''"]',
       null,
       'xochitl',
       'che'' = árbol',
       20, 'medium',
       'Ceiba'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Sak ______',
       '["nikte''", "Sak nikte''"]',
       null,
       'citlali',
       'nikte'' = flor',
       20, 'medium',
       'Flor blanca'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 5;

-- nivel 2 · unidad 6: contar del uno al cinco
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Uno',
       '["Jun"]',
       '["Taata", "Táan in bin", "Jun", "A taata"]',
       'coltzin',
       'Jun significa uno',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dos',
       '["Ka''a"]',
       '["Ka''a", "Nojoch naj", "Suku''un", "Leti''o''ob"]',
       'neza',
       'Ka''a significa dos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tres',
       '["Óox"]',
       '["Óox", "Íits''in", "Ka''anen", "Wíiniko''ob"]',
       'tonatiuh',
       'Óox significa tres',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cuatro',
       '["Kan"]',
       '["Bin", "Kan", "Suku''un", "Tak tu láak'' k''iin"]',
       'xochitl',
       'Kan significa cuatro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Jun ______',
       '["p''éel", "Jun p''éel"]',
       null,
       'citlali',
       'p''éel = clasificador de cosas',
       20, 'medium',
       'Uno (una cosa)'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ka''a túul ______',
       '["paal", "Ka''a túul paal"]',
       null,
       'coltzin',
       'paal = niño',
       20, 'medium',
       'Dos niños'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 2 and u.unit_num = 6;

-- nivel 3 · unidad 1: palabras para preguntar
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Qué?',
       '["Ba''ax?"]',
       '["Máax teech?", "Tu''ux?", "Ba''ax?", "Ba''axten?"]',
       'neza',
       'Ba''ax? significa ¿qué?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Quién?',
       '["Máax?"]',
       '["Tu''ux ka bin?", "Máax?", "Bajux le je''ela''?", "Jaytúul a paalal?"]',
       'tonatiuh',
       'Máax? significa ¿quién?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Dónde?',
       '["Tu''ux?"]',
       '["Tu''ux?", "Ba''axten?", "Ba''ax?", "Jaytúul a paalal?"]',
       'xochitl',
       'Tu''ux? significa ¿dónde?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Por qué?',
       '["Ba''axten?"]',
       '["Tu''ux?", "Ba''ax?", "Ba''axten?", "Máax teech?"]',
       'citlali',
       'Ba''axten? significa ¿por qué?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Máax ______?',
       '["teech", "Máax teech?", "Máax teech"]',
       null,
       'coltzin',
       'teech = tú',
       20, 'medium',
       '¿Quién eres?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tu''ux ka ______?',
       '["bin", "Tu''ux ka bin?", "Tu''ux ka bin"]',
       null,
       'neza',
       'bin = ir',
       20, 'medium',
       '¿A dónde vas?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 1;

-- nivel 3 · unidad 2: mi casa y mi comunidad
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Casa',
       '["Naj"]',
       '["Naj", "K''aas", "Na''", "Ka''a túul paal"]',
       'tonatiuh',
       'Naj significa casa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pueblo',
       '["Kaaj"]',
       '["Leti''o''ob", "Sak nikte''", "In chiich", "Kaaj"]',
       'xochitl',
       'Kaaj significa pueblo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Milpa',
       '["Kool"]',
       '["Ka''a", "Naats''", "Te''ex", "Kool"]',
       'citlali',
       'Kool significa milpa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mi casa',
       '["In naj"]',
       '["Éek''", "Ts''áaten ja''", "Jo''", "In naj"]',
       'coltzin',
       'In naj: in (mi) + naj (casa)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tin ______',
       '["naj", "Tin naj"]',
       null,
       'neza',
       'naj = casa',
       20, 'medium',
       'En mi casa'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ich ______',
       '["kaaj", "Ich kaaj"]',
       null,
       'tonatiuh',
       'kaaj = pueblo',
       20, 'medium',
       'En el pueblo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 2;

-- nivel 3 · unidad 3: contar del seis al diez
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Seis',
       '["Wak"]',
       '["Bolon", "Wak", "Chiich", "Lajun p''éel"]',
       'xochitl',
       'Wak significa seis',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Siete',
       '["Uk"]',
       '["Ya''ax", "Ts''ono''ot", "Íits''in", "Uk"]',
       'citlali',
       'Uk significa siete',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ocho',
       '["Waxak"]',
       '["Wak túul máak", "Nojoch bej", "Ya''ax che''", "Waxak"]',
       'coltzin',
       'Waxak significa ocho',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nueve',
       '["Bolon"]',
       '["Uk", "Lajun p''éel", "Bolon", "Naats''"]',
       'neza',
       'Bolon significa nueve',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Lajun ______',
       '["p''éel", "Lajun p''éel"]',
       null,
       'tonatiuh',
       'p''éel = clasificador de cosas',
       20, 'medium',
       'Diez cosas'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Wak túul ______',
       '["máak", "Wak túul máak"]',
       null,
       'xochitl',
       'máak = persona',
       20, 'medium',
       'Seis personas'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 3;

-- nivel 3 · unidad 4: lugares y cosas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Monte',
       '["K''áax"]',
       '["Kool", "Ts''áaten ja''", "Éek''", "K''áax"]',
       'citlali',
       'K''áax significa monte',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Agua',
       '["Ja''"]',
       '["Ja''", "Chichan", "Paal", "Te''ex"]',
       'coltzin',
       'Ja'' significa agua',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cenote',
       '["Ts''ono''ot"]',
       '["Óox", "Ts''áaten ja''", "Ts''ono''ot", "Sak"]',
       'neza',
       'Ts''ono''ot significa cenote',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Camino',
       '["Bej"]',
       '["Nojoch", "Bej", "Óox", "Wak túul máak"]',
       'tonatiuh',
       'Bej significa camino',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nojoch ______',
       '["bej", "Nojoch bej"]',
       null,
       'xochitl',
       'bej = camino',
       20, 'medium',
       'Carretera'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tu''ux yaan ______?',
       '["ja''", "Tu''ux yaan ja''?", "Tu''ux yaan ja''"]',
       null,
       'citlali',
       'ja'' = agua',
       20, 'medium',
       '¿Dónde hay agua?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 4;

-- nivel 3 · unidad 5: cerca y lejos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cerca',
       '["Naats''"]',
       '["Teech xiibech", "Naats''", "Lajun p''éel", "Te''ex"]',
       'coltzin',
       'Naats'' significa cerca',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lejos',
       '["Náach"]',
       '["Uk", "Suku''un", "Sak nikte''", "Náach"]',
       'neza',
       'Náach significa lejos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Aquí',
       '["Te''ela''"]',
       '["Náach in naj", "Te''ela''", "Bej", "Nool"]',
       'tonatiuh',
       'Te''ela'': te''el (lugar) + -a'' (este, aquí)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Allá',
       '["Te''elo''"]',
       '["Te''elo''", "Leti''o''ob", "Ka''a túul paal", "Lajun"]',
       'xochitl',
       'Te''elo'': te''el (lugar) + -o'' (ese, allá)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Naats'' le ______',
       '["kaajo''", "Naats'' le kaajo''"]',
       null,
       'citlali',
       'Naats'' le kaajo'': naats'' (cerca) + le ... -o'' (ese, el) + kaaj (pueblo)',
       20, 'medium',
       'El pueblo está cerca'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Náach in ______',
       '["naj", "Náach in naj"]',
       null,
       'coltzin',
       'naj = casa',
       20, 'medium',
       'Mi casa está lejos'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 5;

-- nivel 3 · unidad 6: preguntas útiles
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cuánto cuesta?',
       '["Bajux?"]',
       '["Tu''ux yaan ja''?", "Bajux?", "Máax?", "Tu''ux?"]',
       'neza',
       'Bajux? significa ¿cuánto cuesta?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cuánto cuesta esto?',
       '["Bajux le je''ela''?"]',
       '["Tu''ux?", "Bajux le je''ela''?", "Tu''ux yaan ja''?", "Ba''axten?"]',
       'tonatiuh',
       'Bajux le je''ela''?: bajux (cuánto cuesta) + le je''el ... -a'' (esto)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'No entiendo',
       '["Ma'' in na''atik"]',
       '["Suku''un", "Te''elo''", "Teech xiibech", "Ma'' in na''atik"]',
       'xochitl',
       'Ma'' in na''atik: ma'' (no) + in (yo) + na''atik (entender)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dame agua',
       '["Ts''áaten ja''"]',
       '["Ts''áaten ja''", "Wak", "In naj", "Sak nikte''"]',
       'citlali',
       'Ts''áaten ja'': ts''a (dar) + -en (a mí) + ja'' (agua)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ts''áaten ______',
       '["ja''", "Ts''áaten ja''"]',
       null,
       'coltzin',
       'ja'' = agua',
       20, 'medium',
       'Dame agua'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Jaytúul a ______?',
       '["paalal", "Jaytúul a paalal?", "Jaytúul a paalal"]',
       null,
       'neza',
       'paalal = hijos',
       20, 'medium',
       '¿Cuántos hijos tienes?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 3 and u.unit_num = 6;

-- nivel 4 · unidad 1: hoy, ayer y mañana
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hoy',
       '["Bejla''e''"]',
       '["Cháak", "Ts''áaten ja''", "Joolje''ej", "Bejla''e''"]',
       'tonatiuh',
       'Bejla''e'': bejla'' (hoy) + -e'' (marca de tema)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ayer',
       '["Joolje''ej"]',
       '["Joolje''ej", "Naj", "Joolje''ej tin bin", "Kool"]',
       'xochitl',
       'Joolje''ej significa ayer',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pasado mañana',
       '["Ka''abej"]',
       '["Che''", "Táan", "Ka''abej", "Ts''o''ok"]',
       'citlali',
       'Ka''abej significa pasado mañana',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ayer fui',
       '["Joolje''ej tin bin"]',
       '["Ich kaaj", "Naj", "Wak", "Joolje''ej tin bin"]',
       'coltzin',
       'Joolje''ej tin bin: joolje''ej (ayer) + t- (ya pasó (completivo)) + in (yo) + bin (ir)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Joolje''ej tin ______',
       '["bin", "Joolje''ej tin bin"]',
       null,
       'neza',
       'bin = ir',
       20, 'medium',
       'Ayer fui'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Sáamal yaan in ______',
       '["bin", "Sáamal yaan in bin"]',
       null,
       'tonatiuh',
       'bin = ir',
       20, 'medium',
       'Mañana voy a ir'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 1;

-- nivel 4 · unidad 2: la naturaleza
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Sol',
       '["K''iin"]',
       '["K''iin", "Xook", "Kin meyaj", "Bej"]',
       'xochitl',
       'K''iin significa sol',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Árbol',
       '["Che''"]',
       '["Che''", "K''áax", "Lajun p''éel", "Tin naj"]',
       'citlali',
       'Che'' significa árbol',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tierra',
       '["Lu''um"]',
       '["Lu''um", "Lajun p''éel", "Tin meyaj", "Nojoch bej"]',
       'coltzin',
       'Lu''um significa tierra',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lluvia',
       '["Cháak"]',
       '["In naj", "Sáamal yaan in bin", "Ka''an", "Cháak"]',
       'neza',
       'Cháak significa lluvia',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nojoch ______',
       '["che''", "Nojoch che''"]',
       null,
       'tonatiuh',
       'che'' = árbol',
       20, 'medium',
       'Árbol grande'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Táan u k''áaxal ______',
       '["ja''", "Táan u k''áaxal ja''"]',
       null,
       'xochitl',
       'ja'' = agua',
       20, 'medium',
       'Está lloviendo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 2;

-- nivel 4 · unidad 3: lo que hago
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajo',
       '["Meyaj"]',
       '["Ts''o''ok in janal", "Joolje''ej", "Meyaj", "Waxak"]',
       'citlali',
       'Meyaj significa trabajo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Comida',
       '["Janal"]',
       '["Janal", "Ka''a k''iin", "Ich kaaj", "Táan in janal"]',
       'coltzin',
       'Janal significa comida',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estudiar',
       '["Xook"]',
       '["Náach", "Kin janal", "Nojoch bej", "Xook"]',
       'neza',
       'Xook significa estudiar',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajo',
       '["Kin meyaj"]',
       '["Kin meyaj", "Wak", "Naats''", "Kool"]',
       'tonatiuh',
       'Kin meyaj: k- (de costumbre) + in (yo) + meyaj (trabajar)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kin ______',
       '["janal", "Kin janal"]',
       null,
       'xochitl',
       'janal = comer',
       20, 'medium',
       'Como'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kin ______',
       '["xook", "Kin xook"]',
       null,
       'citlali',
       'xook = estudiar',
       20, 'medium',
       'Estudio'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 3;

-- nivel 4 · unidad 4: lo que pasó
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Trabajé',
       '["Tin meyaj"]',
       '["Te''elo''", "Wak túul máak", "Tin meyaj", "Ma'' in na''atik"]',
       'coltzin',
       'Tin meyaj: t- (ya pasó (completivo)) + in (yo) + meyaj (trabajar)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Comí',
       '["Tin janal"]',
       '["Tin janal", "Wak túul máak", "Naj", "Uk"]',
       'neza',
       'Tin janal: t- (ya pasó (completivo)) + in (yo) + janal (comer)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ya (terminó)',
       '["Ts''o''ok"]',
       '["Ts''o''ok", "Táan in janal", "Náach", "Cháak"]',
       'tonatiuh',
       'Ts''o''ok significa ya (terminó)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estudié',
       '["Tin xook"]',
       '["Xook", "Kaaj", "Tin xook", "Naats''"]',
       'xochitl',
       'Tin xook: t- (ya pasó (completivo)) + in (yo) + xook (estudiar)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tin ______',
       '["xook", "Tin xook"]',
       null,
       'citlali',
       'xook = estudiar',
       20, 'medium',
       'Estudié'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ts''o''ok in ______',
       '["janal", "Ts''o''ok in janal"]',
       null,
       'coltzin',
       'janal = comer',
       20, 'medium',
       'Ya comí'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 4;

-- nivel 4 · unidad 5: ahora y después
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estar haciendo (ahora)',
       '["Táan"]',
       '["Tin xook", "Táan", "Tin janal", "Waxak"]',
       'neza',
       'Táan significa estar haciendo (ahora)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Todavía no',
       '["Ma''ili''"]',
       '["Ma''ili''", "Ja''", "Nojoch bej", "Jun ja''ab"]',
       'tonatiuh',
       'Ma''ili'': ma'' (no) + -ili'' (todavía)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estoy comiendo',
       '["Táan in janal"]',
       '["Táan in janal", "Ts''o''ok in janal", "Táan u k''áaxal ja''", "Náach"]',
       'xochitl',
       'Táan in janal: táan (estar haciendo) + in (yo) + janal (comer)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Estoy trabajando',
       '["Táan in meyaj"]',
       '["Táan in meyaj", "Wak", "Ts''ono''ot", "Lajun"]',
       'citlali',
       'Táan in meyaj: táan (estar haciendo) + in (yo) + meyaj (trabajar)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Táan in ______',
       '["meyaj", "Táan in meyaj"]',
       null,
       'coltzin',
       'meyaj = trabajar',
       20, 'medium',
       'Estoy trabajando'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Táan a ______?',
       '["xook", "Táan a xook?", "Táan a xook"]',
       null,
       'neza',
       'xook = estudiar',
       20, 'medium',
       '¿Estás estudiando?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 5;

-- nivel 4 · unidad 6: repaso del tiempo
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Año',
       '["Ja''ab"]',
       '["Táan", "Ja''ab", "Wak túul máak", "Bolon"]',
       'tonatiuh',
       'Ja''ab significa año',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Luna',
       '["Úuj"]',
       '["K''áax", "Úuj", "Bejla''e''", "Janal"]',
       'xochitl',
       'Úuj significa luna',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Un año',
       '["Jun ja''ab"]',
       '["Ich kaaj", "Jun ja''ab", "Bejla''e''", "Náach"]',
       'citlali',
       'Jun ja''ab: jun (uno) + ja''ab (año)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dos días',
       '["Ka''a k''iin"]',
       '["Ka''a k''iin", "Ka''abej", "Ts''áaten ja''", "Ma'' in na''atik"]',
       'coltzin',
       'Ka''a k''iin: ka''a (dos) + k''iin (día)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ka''a ______',
       '["k''iin", "Ka''a k''iin"]',
       null,
       'neza',
       'k''iin = día',
       20, 'medium',
       'Dos días'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Le ______',
       '["ja''aba''", "Le ja''aba''"]',
       null,
       'tonatiuh',
       'Le ja''aba'': le ... -a'' (este) + ja''ab (año)',
       20, 'medium',
       'Este año'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 4 and u.unit_num = 6;

-- nivel 5 · unidad 1: la comida
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tortilla',
       '["Waaj"]',
       '["Waaj", "Tin meyaj", "Meyaj ich kool", "Meyaj"]',
       'xochitl',
       'Waaj significa tortilla',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Maíz',
       '["Ixi''im"]',
       '["Míis", "Ts''o''ok in janal", "Ixi''im", "Nikte''"]',
       'citlali',
       'Ixi''im significa maíz',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Frijol',
       '["Bu''ul"]',
       '["Joolje''ej", "Táan in janal", "Bu''ul", "Le ja''aba''"]',
       'coltzin',
       'Bu''ul significa frijol',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Chile',
       '["Iik"]',
       '["Bu''ul", "Bejla''e''", "Iik", "Xook"]',
       'neza',
       'Iik significa chile',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Waaj yéetel ______',
       '["bu''ul", "Waaj yéetel bu''ul"]',
       null,
       'tonatiuh',
       'bu''ul = frijol',
       20, 'medium',
       'Tortilla con frijol'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ki'' le ______',
       '["janalo''", "Ki'' le janalo''"]',
       null,
       'xochitl',
       'Ki'' le janalo'': ki'' (sabroso) + le ... -o'' (esa, la) + janal (comida)',
       20, 'medium',
       'La comida está sabrosa'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 1;

-- nivel 5 · unidad 2: frutas y plantas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Plátano',
       '["Ja''as"]',
       '["Ja''as", "Ja''ab", "Ts''o''ok in janal", "Síis"]',
       'citlali',
       'Ja''as significa plátano',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Naranja',
       '["Pak''al"]',
       '["Pak''al", "Tin janal", "Ixi''im", "Ke''el"]',
       'coltzin',
       'Pak''al significa naranja',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Flor',
       '["Nikte''"]',
       '["Ja''ab", "Tin meyaj", "Nikte''", "Kin xook"]',
       'neza',
       'Nikte'' significa flor',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hierba',
       '["Xíiw"]',
       '["Xíiw", "Kúum", "Táan in meyaj", "Kin xíimbal"]',
       'tonatiuh',
       'Xíiw significa hierba',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ki''ichpam ______',
       '["nikte''", "Ki''ichpam nikte''"]',
       null,
       'xochitl',
       'nikte'' = flor',
       20, 'medium',
       'Flor hermosa'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ya''ab ______',
       '["ja''as", "Ya''ab ja''as"]',
       null,
       'citlali',
       'ja''as = plátano',
       20, 'medium',
       'Muchos plátanos'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 2;

-- nivel 5 · unidad 3: en la cocina
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cocina',
       '["K''óoben"]',
       '["Bu''ul", "Ka''an", "Janal", "K''óoben"]',
       'coltzin',
       'K''óoben significa cocina',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Fuego',
       '["K''áak''"]',
       '["K''áak''", "Iik", "Pak''al", "Joolje''ej tin bin"]',
       'neza',
       'K''áak'' significa fuego',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Olla',
       '["Kúum"]',
       '["Ti'' k''óoben", "Ts''a k''áak''", "Kin xíimbal", "Kúum"]',
       'tonatiuh',
       'Kúum significa olla',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Jícara',
       '["Luuch"]',
       '["Luuch", "Joolje''ej tin bin", "Táan u k''áaxal ja''", "Ke''el"]',
       'xochitl',
       'Luuch significa jícara',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ti'' ______',
       '["k''óoben", "Ti'' k''óoben"]',
       null,
       'citlali',
       'k''óoben = cocina',
       20, 'medium',
       'En la cocina'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ts''a ______',
       '["k''áak''", "Ts''a k''áak''"]',
       null,
       'coltzin',
       'k''áak'' = fuego',
       20, 'medium',
       'Prende el fuego'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 3;

-- nivel 5 · unidad 4: acciones del día
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Despertar',
       '["Ajal"]',
       '["Ajal", "Luuch", "Bu''ul", "Pak''al"]',
       'neza',
       'Ajal significa despertar',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Caminar',
       '["Xíimbal"]',
       '["Úuj", "Ixi''im", "Xíimbal", "Táan in meyaj"]',
       'tonatiuh',
       'Xíimbal significa caminar',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Venir',
       '["Taal"]',
       '["Nikte''", "Taal", "Ja''ab", "Ti'' k''óoben"]',
       'xochitl',
       'Taal significa venir',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Me despierto',
       '["Kin ajal"]',
       '["Iik", "Ts''o''ok in janal", "Kin ajal", "Cháak"]',
       'citlali',
       'Kin ajal: k- (de costumbre) + in (yo) + ajal (despertar)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kin ______',
       '["ajal", "Kin ajal"]',
       null,
       'coltzin',
       'ajal = despertar',
       20, 'medium',
       'Me despierto'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kin ______',
       '["xíimbal", "Kin xíimbal"]',
       null,
       'neza',
       'xíimbal = caminar',
       20, 'medium',
       'Camino'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 4;

-- nivel 5 · unidad 5: trabajos de la casa
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ropa',
       '["Nook''"]',
       '["Nook''", "Cháak", "Jach chokoj", "Joolje''ej tin bin"]',
       'tonatiuh',
       'Nook'' significa ropa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lavar',
       '["P''o''"]',
       '["Pak''al", "Kin xíimbal", "P''o''", "Kin ajal"]',
       'xochitl',
       'P''o'' significa lavar',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Barrer',
       '["Míis"]',
       '["Ka''an", "Tin meyaj", "Míis", "Ti'' k''óoben"]',
       'citlali',
       'Míis significa barrer',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lavo ropa',
       '["Kin p''o'' nook''"]',
       '["K''iin", "Kin p''o'' nook''", "Le ja''aba''", "Jach chokoj"]',
       'coltzin',
       'Kin p''o'' nook'': k- (de costumbre) + in (yo) + p''o'' (lavar) + nook'' (ropa)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Kin p''o'' ______',
       '["nook''", "Kin p''o'' nook''"]',
       null,
       'neza',
       'nook'' = ropa',
       20, 'medium',
       'Lavo ropa'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Meyaj ich ______',
       '["kool", "Meyaj ich kool"]',
       null,
       'tonatiuh',
       'kool = milpa',
       20, 'medium',
       'Trabajar en la milpa'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 5;

-- nivel 5 · unidad 6: caliente y frío
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Caliente',
       '["Chokoj"]',
       '["Chokoj", "Ma''ili''", "Úuj", "Xook"]',
       'xochitl',
       'Chokoj significa caliente',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Frío (agua, cosas)',
       '["Síis"]',
       '["Ja''ab", "Síis", "Táan in janal", "Jach chokoj"]',
       'citlali',
       'Síis significa frío (agua, cosas)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Frío (tiempo)',
       '["Ke''el"]',
       '["Joolje''ej", "Nojoch che''", "Ke''el", "Kin ajal"]',
       'coltzin',
       'Ke''el significa frío (tiempo)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Agua caliente',
       '["Chokoj ja''"]',
       '["Chokoj ja''", "Iik", "Ka''abej", "Kin xíimbal"]',
       'neza',
       'Chokoj ja'': chokoj (caliente) + ja'' (agua)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Síis ______',
       '["ja''", "Síis ja''"]',
       null,
       'tonatiuh',
       'ja'' = agua',
       20, 'medium',
       'Agua fría'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Jach ______',
       '["chokoj", "Jach chokoj"]',
       null,
       'xochitl',
       'chokoj = caliente',
       20, 'medium',
       'Hace mucho calor'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 5 and u.unit_num = 6;

-- nivel 6 · unidad 1: animales del monte
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Venado',
       '["Kéej"]',
       '["Ya''ab ja''as", "Kéej", "Pak''al", "Ch''íich''"]',
       'citlali',
       'Kéej significa venado',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Jaguar',
       '["Ba''alam"]',
       '["Ba''alam", "Míis", "In k''áat janal", "Yuum bo''otik"]',
       'coltzin',
       'Ba''alam significa jaguar',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mono',
       '["Ma''ax"]',
       '["Meyaj ich kool", "Ma''ax", "Ba''alam", "K''éek''en"]',
       'neza',
       'Ma''ax significa mono',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pájaro',
       '["Ch''íich''"]',
       '["Ke''el", "Ch''íich''", "In k''áat", "Je''el u páajtal"]',
       'tonatiuh',
       'Ch''íich'' significa pájaro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Nojoch ______',
       '["ba''alam", "Nojoch ba''alam"]',
       null,
       'xochitl',
       'ba''alam = jaguar',
       20, 'medium',
       'Jaguar grande'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Óox túul ______',
       '["kéej", "Óox túul kéej"]',
       null,
       'citlali',
       'kéej = venado',
       20, 'medium',
       'Tres venados'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 1;

-- nivel 6 · unidad 2: animales de la casa
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Perro',
       '["Peek''"]',
       '["K''áak''", "In k''áat janal", "Kéej", "Peek''"]',
       'coltzin',
       'Peek'' significa perro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Gato',
       '["Miis"]',
       '["Miis", "Kaan", "Ki''imak in wóol in wilikech", "Ixi''im"]',
       'neza',
       'Miis significa gato',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Gallina',
       '["Kaax"]',
       '["Kin ajal", "Chi''", "Kaax", "Miis"]',
       'tonatiuh',
       'Kaax significa gallina',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pavo',
       '["Tso''"]',
       '["Chokoj", "In k''ab", "Yuum bo''otik", "Tso''"]',
       'xochitl',
       'Tso'' significa pavo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'In ______',
       '["peek''", "In peek''"]',
       null,
       'citlali',
       'peek'' = perro',
       20, 'medium',
       'Mi perro'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ka''a túul ______',
       '["miis", "Ka''a túul miis"]',
       null,
       'coltzin',
       'miis = gato',
       20, 'medium',
       'Dos gatos'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 2;

-- nivel 6 · unidad 3: el cuerpo
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cabeza',
       '["Pool"]',
       '["Ja''as", "Iik", "Pool", "Ts''a k''áak''"]',
       'neza',
       'Pool significa cabeza',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mano',
       '["K''ab"]',
       '["Yuum bo''otik", "Kaax", "K''ab", "Yaj in pool"]',
       'tonatiuh',
       'K''ab significa mano',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pie',
       '["Ook"]',
       '["Pool", "Jach chokoj", "Ki''ichpam nikte''", "Ook"]',
       'xochitl',
       'Ook significa pie',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ojo',
       '["Ich"]',
       '["Ich", "Ki'' le janalo''", "Ki''imak in wóol in wilikech", "Taal"]',
       'citlali',
       'Ich significa ojo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'In ______',
       '["k''ab", "In k''ab"]',
       null,
       'coltzin',
       'k''ab = mano',
       20, 'medium',
       'Mi mano'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Yaj in ______',
       '["pool", "Yaj in pool"]',
       null,
       'neza',
       'pool = cabeza',
       20, 'medium',
       'Me duele la cabeza'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 3;

-- nivel 6 · unidad 4: lo que quiero y lo que tengo
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quiero',
       '["In k''áat"]',
       '["Óox túul kéej", "In k''áat", "Kéej", "Pak''al"]',
       'tonatiuh',
       'In k''áat: in (yo) + k''áat (querer)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tengo',
       '["Yaan ten"]',
       '["Ya''ab ja''as", "Xíiw", "Yaan ten", "Nook''"]',
       'xochitl',
       'Yaan ten: yaan (hay) + ten (a mí, para mí)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Qué quieres?',
       '["Ba''ax a k''áat?"]',
       '["Ki'' le janalo''", "Nojoch ba''alam", "Ba''ax a k''áat?", "Tu''ux ka taal?"]',
       'citlali',
       'Ba''ax a k''áat?: ba''ax (qué) + a (tú) + k''áat (querer)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Quiero comer',
       '["In k''áat janal"]',
       '["Waaj yéetel bu''ul", "Je''el u páajtal", "In k''áat janal", "Síis"]',
       'coltzin',
       'In k''áat janal: in (yo) + k''áat (querer) + janal (comer)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'In k''áat ______',
       '["janal", "In k''áat janal"]',
       null,
       'neza',
       'janal = comer',
       20, 'medium',
       'Quiero comer'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Yaan ten jun túul ______',
       '["peek''", "Yaan ten jun túul peek''"]',
       null,
       'tonatiuh',
       'peek'' = perro',
       20, 'medium',
       'Tengo un perro'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 4;

-- nivel 6 · unidad 5: expresiones
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Así',
       '["Bey"]',
       '["Jach ma''alob", "Bey", "In yaakumech", "Bu''ul"]',
       'xochitl',
       'Bey significa así',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Igualmente',
       '["Bey xan"]',
       '["Ke''el", "Bey xan", "Chokoj ja''", "Waaj yéetel bu''ul"]',
       'citlali',
       'Bey xan: bey (así) + xan (también)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Vámonos',
       '["Ko''one''ex"]',
       '["Ch''íich''o''ob", "Kéej", "Ko''one''ex", "In k''áat janal"]',
       'coltzin',
       'Ko''one''ex: ko''ox (vamos) + -e''ex (ustedes)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muy bien',
       '["Jach ma''alob"]',
       '["Kúum", "Waaj yéetel bu''ul", "Jach ma''alob", "Ts''a k''áak''"]',
       'neza',
       'Jach ma''alob: jach (muy) + ma''alob (bien)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Jach ______',
       '["ma''alob", "Jach ma''alob"]',
       null,
       'tonatiuh',
       'ma''alob = bien',
       20, 'medium',
       'Muy bien'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Je''el u ______',
       '["páajtal", "Je''el u páajtal"]',
       null,
       'xochitl',
       'páajtal = poder',
       20, 'medium',
       'Sí se puede'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 5;

-- nivel 6 · unidad 6: conversación final
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Te quiero',
       '["In yaakumech"]',
       '["Kin kanik maaya", "Ko''one''ex", "Miis", "In yaakumech"]',
       'citlali',
       'In yaakumech: in (yo) + yaakun (amar, querer) + -ech (a ti)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿De dónde vienes?',
       '["Tu''ux ka taal?"]',
       '["Tu''ux ka taal?", "Kaax", "Ba''ax a k''áat?", "Tso''"]',
       'coltzin',
       'Tu''ux ka taal?: tu''ux (dónde) + k- + a (tú (de costumbre)) + taal (venir)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Aprendo maya',
       '["Kin kanik maaya"]',
       '["Kin kanik maaya", "Nojoch ba''alam", "K''áak''", "Luuch"]',
       'neza',
       'Kin kanik maaya: k- (de costumbre) + in (yo) + kanik (aprender) + maaya (maya)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Gracias',
       '["Yuum bo''otik"]',
       '["Pool", "Luuch", "Yuum bo''otik", "Kaax"]',
       'tonatiuh',
       'Yuum bo''otik: yuum (señor) + bo''otik (lo pague)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Yuum ______',
       '["bo''otik", "Yuum bo''otik"]',
       null,
       'xochitl',
       'bo''otik = lo pague',
       20, 'medium',
       'Gracias'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ki''imak in wóol in ______',
       '["wilikech", "Ki''imak in wóol in wilikech"]',
       null,
       'citlali',
       'Ki''imak in wóol in wilikech: ki''imak (alegre) + in wóol (mi corazón) + in (yo) + w- (enlace) + il (ver) + -ik ((transitivo)) + -ech (a ti)',
       20, 'medium',
       'Me da gusto verte'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'yua' and l.level_num = 6 and u.unit_num = 6;

-- ─────────────────────────────────────────────
--  7. sistema de escritura
-- ─────────────────────────────────────────────
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
    where la.code = 'yua' and l.level_num = 1 and u.unit_num = 1
) u
where usr.username = 'tetecuhtli';

-- ─────────────────────────────────────────────
--  9. ta_user_stats — registro inicial para el usuario demo
-- ─────────────────────────────────────────────
insert into ta_user_stats (user_id, language_id, words_learned, lessons_done, perfect_less, days_studied, best_streak, total_mins)
select usr.id, la.id, 0, 0, 0, 0, 0, 0
from ta_users usr
cross join ct_languages la
where usr.username = 'tetecuhtli' and la.code = 'yua';

commit;

-- ─────────────────────────────────────────────
--  verificación
--  esperado: ct_levels 6 · ct_units 36 · ct_vocabulary 213 · ct_exercises 216 · desglose 213 · status 1 (draft)
-- ─────────────────────────────────────────────
select 'ct_levels' as tabla, count(1) as registros from ct_levels where language_id = (select id from ct_languages where code = 'yua')
union all
select 'ct_units', count(1) from ct_units where level_id in (select id from ct_levels where language_id = (select id from ct_languages where code = 'yua'))
union all
select 'ct_vocabulary', count(1) from ct_vocabulary where language_id = (select id from ct_languages where code = 'yua')
union all
select 'ct_exercises', count(1) from ct_exercises where unit_id in (select u.id from ct_units u join ct_levels l on u.level_id = l.id where l.language_id = (select id from ct_languages where code = 'yua'))
union all
select 'desglose', count(1) from ct_vocabulary where language_id = (select id from ct_languages where code = 'yua') and breakdown is not null
union all
select 'status', case when status = 'draft' then 1 else 0 end from ct_languages where code = 'yua';
