-- ============================================================
--  seed de prueba — Zapoteco del Istmo (zai)  · curso en pruebas (status = 'draft')
--  tlahtolcalli  [postgresql]
--
--  variante base: zapoteco del istmo de tehuantepec (juchitán, oaxaca) · iso 639-3: zai
--  ejecutar después de 1.-esquema.sql y 2.-datos_generales.sql.
--
--  contenido (curso completo, mismos niveles que nhn y hus):
--    6 niveles · 36 unidades · 219 palabras y frases (todas con desglose) · 216 ejercicios
--
--  tipología: no aglutinante, más analítica y tonal (familia otomangue). pocas piezas por palabra:
--    aspecto con prefijo (ri-/ru-, bi-/gu-, ca-/cu-, zu-), persona con pronombre o terminación
--    (-lu', -be), posesión con x-/j- y plural con ca; el desglose suele tener una o dos filas.
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

-- ─────────────────────────────────────────────
--  0. limpieza (re-ejecución)
-- ─────────────────────────────────────────────
update ta_users set current_lang = null
 where current_lang = (select id from ct_languages where code = 'zai');
delete from ta_user_stats
 where language_id = (select id from ct_languages where code = 'zai');
delete from ta_user_achievements where language_tag = 'zai';
delete from ct_languages where code = 'zai';   -- en cascada: niveles, unidades, vocabulario, ejercicios, progreso

-- ─────────────────────────────────────────────
--  1. idioma (en pruebas: solo se ve en el front de desarrollo)
-- ─────────────────────────────────────────────
insert into ct_languages (code, lang_name, native_name, color, flag, family, writing_system, status)
values ('zai', 'Zapoteco del Istmo', 'Diidxazá', null, '🌺', 'otomangue', 'alphabet', 'draft');

-- ─────────────────────────────────────────────
--  2. niveles
-- ─────────────────────────────────────────────
insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 1, 'Saluda y preséntate', 'Padiuxi', null, 6, 'Ninguno - Nivel inicial', 1
from ct_languages where code = 'zai';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 2, 'Descríbete y describe a tu familia', 'Jñaa ne bixhoze', null, 6, 'Completar Nivel 1', 0
from ct_languages where code = 'zai';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 3, 'Pide y da información', 'Xi, tu, paraa?', null, 6, 'Completar Nivel 2', 0
from ct_languages where code = 'zai';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 4, 'Habla en tiempos (ayer/hoy/mañana)', 'Yanna ne guixi', null, 6, 'Completar Nivel 3', 0
from ct_languages where code = 'zai';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 5, 'Describe un día normal', 'Gueta ne nisa', null, 6, 'Completar Nivel 4', 0
from ct_languages where code = 'zai';

insert into ct_levels (language_id, level_num, title, title_native, color, total_units, unlock_req, is_free)
select id, 6, 'Describe y expresa preferencias', 'Bi''cu'' ne mistu', null, 6, 'Completar Nivel 5', 0
from ct_languages where code = 'zai';

-- ─────────────────────────────────────────────
--  3.1 unidades — nivel 1: saluda y preséntate
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Saludos', null,
       'Saludar y preguntar cómo está alguien',
       'Xi modo nuu lii? = ¿cómo estás? (nuu = está; lii = tú); ne = y', 1, null
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'El día y la noche', null,
       'Nombrar los momentos del día',
       'Ti = un, uno: ti dxi = un día', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, '¿Quién eres?', null,
       'Preguntar el nombre y conocer los pronombres',
       'La = nombre; -lu'' = tu, -be = su: lalu'' (tu nombre), labe (su nombre). Naa (yo), lii (tú), laabe (él, ella)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Agradecer y responder', null,
       'Dar las gracias y responder',
       'Xquíxe pe'' = muchas gracias; ca después del nombre = ese, esa', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Las personas', null,
       'Nombrar a niños y jóvenes',
       'Ba''du'' = niño; huiini'' = pequeño: ba''du huiini'' = bebé', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Conversación básica', null,
       'Nombrar la lengua y a su gente',
       'Binni = gente; zá = nube: binnizá = gente de las nubes; diidxa'' = palabra: diidxazá = la lengua', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1;

-- ─────────────────────────────────────────────
--  3.2 unidades — nivel 2: descríbete y describe a tu familia
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Pronombres personales', null,
       'Conocer los pronombres en plural',
       'Laa + terminación: laanu (nosotros), laatu (ustedes), laacabe (ellos); ca = plural', 0, 'Completar Nivel 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'La familia', null,
       'Nombrar a los miembros de la familia',
       '-lu'' al final = tu: xiiñilu'' = tu hijo', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Los abuelos y los hermanos', null,
       'Nombrar a los abuelos y a los hermanos',
       'Bida'' = anciano(a): jñaabida'' = abuela, bixhozebida'' = abuelo', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Cómo es', null,
       'Describir cosas y personas',
       'El adjetivo va después del nombre: yoo huiini'' = casa pequeña', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Los colores', null,
       'Nombrar los colores',
       'Na- marca un estado o cualidad: naguchi = (es) amarillo; el color va después del nombre', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Contar del uno al cinco', null,
       'Contar del uno al cinco',
       'El número va antes de lo que cuenta: chupa bi''cu'' = dos perros', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2;

-- ─────────────────────────────────────────────
--  3.3 unidades — nivel 3: pide y da información
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Palabras para preguntar', null,
       'Hacer preguntas sencillas',
       'Xi (qué), tu (quién), paraa (dónde), xiñee (por qué) van al inicio', 0, 'Completar Nivel 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Mi casa y mi comunidad', null,
       'Hablar de la casa y del pueblo',
       'J- o x- al inicio = de (posesión): neza (camino) → jneza (camino de)', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Contar del seis al diez', null,
       'Contar del seis al diez',
       'Del once en adelante: chii ne tobi (diez y uno)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Lugares y cosas', null,
       'Nombrar lugares del entorno',
       'Luguiá = encima de; xa''na = debajo de', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Encima, debajo y dentro', null,
       'Decir dónde está algo',
       'Ndaani'' = dentro de; ra = donde', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Preguntas útiles', null,
       'Pedir más o menos de algo y preguntar qué es',
       'Nga = ése, es; jma = más; caadxi = poco', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3;

-- ─────────────────────────────────────────────
--  3.4 unidades — nivel 4: habla en tiempos (ayer/hoy/mañana)
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Hoy y mañana', null,
       'Decir cuándo pasa algo',
       'Yanna = ahora; yannadxí = hoy (ahora + día)', 0, 'Completar Nivel 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'La naturaleza', null,
       'Nombrar elementos de la naturaleza',
       'Gubidxa = sol; beeu = luna; guie'' = flor', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'Lo que hago', null,
       'Decir lo que se hace de costumbre',
       'Ri- / ru- al inicio = de costumbre: riguite = juega', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'Lo que pasó', null,
       'Contar lo que ya pasó',
       'Bi- al inicio = ya pasó: biree = salió; ma = ya', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Días, meses y años', null,
       'Contar días, meses y años',
       'Número + nombre: chupa dxi = dos días', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'El clima', null,
       'Hablar del viento, la lluvia y el frío',
       'Na- = así es (estado): naga''nda = (está) frío', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4;

-- ─────────────────────────────────────────────
--  3.5 unidades — nivel 5: describe un día normal
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'La comida', null,
       'Nombrar la comida de todos los días',
       'Ne = y, con: gueta ne zidi = tortilla con sal', 0, 'Completar Nivel 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Frutas y plantas', null,
       'Nombrar frutas y plantas',
       'Yaga + fruta = el árbol de esa fruta', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'En la casa', null,
       'Nombrar cosas de la casa',
       'X- / j- = de (posesión): doo (mecate) → xtoo (mecate de)', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'La ropa', null,
       'Nombrar la ropa tradicional',
       'Nahui = lleva puesta (falda larga)', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'La milpa', null,
       'Hablar de la milpa',
       'Ñaa = milpa (terreno); guela = milpa (las plantas)', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Sabores y olores', null,
       'Describir sabores y olores',
       'Xho'' = olor; el que tiene el olor va después', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5;

-- ─────────────────────────────────────────────
--  3.6 unidades — nivel 6: describe y expresa preferencias
-- ─────────────────────────────────────────────
insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 1, 'Animales del monte', null,
       'Nombrar animales del monte',
       'Gui''xhi'' = monte: mistu gui''xhi'' = gato del monte', 0, 'Completar Nivel 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 2, 'Animales de la casa', null,
       'Nombrar animales de la casa',
       'Ca antes del nombre = plural: ca bi''cu'' = los perros', 0, 'Completar Unidad 1'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 3, 'La cabeza', null,
       'Nombrar partes de la cabeza',
       'Lu = cara, ojo; bizalú = ojo', 0, 'Completar Unidad 2'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 4, 'El cuerpo', null,
       'Nombrar partes del cuerpo',
       'Ladi = cuerpo; ñee = pierna; batañee = pie', 0, 'Completar Unidad 3'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 5, 'Palabras con guenda', null,
       'Formar palabras con guenda',
       'Guenda- convierte un verbo o cualidad en sustantivo: guendanabani = vida (nabani = vivo)', 0, 'Completar Unidad 4'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6;

insert into ct_units (level_id, unit_num, title, color, objective, grammar, is_free, unlock_req)
select l.id, 6, 'Conversación final', null,
       'Usar todo en una conversación',
       'Pa = si; ganda = poder; -e'' al final del verbo = yo', 0, 'Completar Unidad 5'
from ct_levels l join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6;

-- ─────────────────────────────────────────────
--  4. vocabulario (con desglose: pista al tocar una palabra subrayada)
-- ─────────────────────────────────────────────
-- nivel 1 · unidad 1: saludos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Padiuxi', 'hola / buenos días', 'pa-diu-xi', null, 'padiuxi = saludo (hola)' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xi modo nuu lii?', '¿cómo estás?', 'xi mo-do nuu lii', null, 'xi = qué; modo = modo (del español); nuu = está; lii = tú' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ne lii?', '¿y tú?', 'ne lii', null, 'ne = y; lii = tú' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xi modo nuu laabe?', '¿cómo está él / ella?', 'xi mo-do nuu laa-be', null, 'xi = qué; modo = modo; nuu = está; laabe = él, ella' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nuu', 'está / estar', 'nuu', null, 'nuu = estar (en un lugar o de un modo)' from ct_languages where code = 'zai';

-- nivel 1 · unidad 2: el día y la noche
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Dxi', 'día', 'dxi', null, 'dxi = día' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Gueela''', 'noche', 'guee-la''', null, 'gueela'' = noche' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Huadxí', 'tarde', 'hua-dxí', null, 'huadxí = tarde' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ti dxi', 'un día', 'ti dxi', null, 'ti = un, uno; dxi = día' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ti gueela''', 'una noche', 'ti guee-la''', null, 'ti = un, uno; gueela'' = noche' from ct_languages where code = 'zai';

-- nivel 1 · unidad 3: ¿quién eres?
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xi lalu''?', '¿cómo te llamas?', 'xi la-lu''', null, 'xi = qué; la = nombre; -lu'' = tu' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xi labe?', '¿cómo se llama él / ella?', 'xi la-be', null, 'xi = qué; la = nombre; -be = su (de él o ella)' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'La', 'nombre', 'la', null, 'la = nombre' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Naa', 'yo', 'naa', null, 'naa = yo' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Lii', 'tú', 'lii', null, 'lii = tú' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Laabe', 'él / ella', 'laa-be', null, 'laa = (base del pronombre); -be = él, ella' from ct_languages where code = 'zai';

-- nivel 1 · unidad 4: agradecer y responder
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xquíxe pe'' lii', 'muchas gracias', 'xquí-xe pe'' lii', null, 'xquíxe = gracias; pe'' = mucho; lii = a ti' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xquíxe pe'' laatu', 'muchas gracias a ustedes', 'xquí-xe pe'' laa-tu', null, 'xquíxe = gracias; pe'' = mucho; laatu = ustedes' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Co''', 'no', 'co''', null, 'co'' = no' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Diidxa''', 'palabra', 'dii-dxa''', null, 'diidxa'' = palabra' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Diidxa'' ca', 'esa palabra', 'dii-dxa'' ca', null, 'diidxa'' = palabra; ca = esa' from ct_languages where code = 'zai';

-- nivel 1 · unidad 5: las personas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ba''du''', 'niño', 'ba''-du''', null, 'ba''du'' = niño' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Dxaapa''', 'jovencita', 'dxaa-pa''', null, 'dxaapa'' = jovencita' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Badudxaapa''', 'muchacha', 'ba-du-dxaa-pa''', null, 'ba''du'' = niño, joven; dxaapa'' = jovencita' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Badunguiiu', 'muchacho', 'ba-dun-guiiu', null, 'ba''du'' = niño, joven; nguiiu = hombre' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ba''du huiini''', 'bebé', 'ba''-du huii-ni''', null, 'ba''du'' = niño; huiini'' = pequeño' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ba''du dxaapa huiini''', 'niña', 'ba''-du dxaa-pa huii-ni''', null, 'ba''du'' = niño; dxaapa'' = jovencita; huiini'' = pequeño' from ct_languages where code = 'zai';

-- nivel 1 · unidad 6: conversación básica
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Diidxazá', 'lengua zapoteca', 'dii-dxa-zá', null, 'diidxa'' = palabra; zá = nube' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Binnizá', 'gente zapoteca', 'bin-ni-zá', null, 'binni = gente; zá = nube' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Binni', 'gente / persona', 'bin-ni', null, 'binni = gente, persona' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Zá', 'nube', 'zá', null, 'zá = nube' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Binni guidxi', 'gente del pueblo', 'bin-ni gui-dxi', null, 'binni = gente; guidxi = pueblo' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Naa binnizá', 'soy zapoteca', 'naa bin-ni-zá', null, 'naa = yo; binnizá = gente zapoteca' from ct_languages where code = 'zai';

-- nivel 2 · unidad 1: pronombres personales
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Laanu', 'nosotros(as)', 'laa-nu', null, 'laa = (base del pronombre); -nu = nosotros' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Laatu', 'ustedes', 'laa-tu', null, 'laa = (base del pronombre); -tu = ustedes' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Laacabe', 'ellos / ellas', 'laa-ca-be', null, 'laa = (base del pronombre); ca = plural; -be = él, ella' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Naa ne lii', 'yo y tú', 'naa ne lii', null, 'naa = yo; ne = y; lii = tú' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Laabe ne naa', 'él / ella y yo', 'laa-be ne naa', null, 'laabe = él, ella; ne = y; naa = yo' from ct_languages where code = 'zai';

-- nivel 2 · unidad 2: la familia
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jñaa', 'mamá', 'jñaa', null, 'jñaa = mamá, madre' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bixhoze', 'papá', 'bi-xho-ze', null, 'bixhoze = papá, padre' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xiiñi''', 'hijo / hija', 'xii-ñi''', null, 'xiiñi'' = hijo, hija' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xheela''', 'esposo(a)', 'xhee-la''', null, 'xheela'' = esposo, esposa' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jñaa ne bixhoze', 'mamá y papá', 'jñaa ne bi-xho-ze', null, 'jñaa = mamá; ne = y; bixhoze = papá' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xiiñilu''', 'tu hijo(a)', 'xii-ñi-lu''', null, 'xiiñi'' = hijo; -lu'' = tu' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jñaa ne xiiñi''', 'mamá e hijo', 'jñaa ne xii-ñi''', null, 'jñaa = mamá; ne = y; xiiñi'' = hijo' from ct_languages where code = 'zai';

-- nivel 2 · unidad 3: los abuelos y los hermanos
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jñaabida''', 'abuela', 'jñaa-bi-da''', null, 'jñaa = madre; bida'' = anciana' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bixhozebida''', 'abuelo', 'bi-xho-ze-bi-da''', null, 'bixhoze = padre; bida'' = anciano' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Biche''', 'hermano (de un hombre)', 'bi-che''', null, 'biche'' = hermano de un hombre' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bizana''', 'hermana (de un hombre)', 'bi-za-na''', null, 'bizana'' = hermana de un hombre' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jñaabida'' ne bixhozebida''', 'abuela y abuelo', 'jñaa-bi-da'' ne bi-xho-ze-bi-da''', null, 'jñaabida'' = abuela; ne = y; bixhozebida'' = abuelo' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Biche'' ne bizana''', 'hermano y hermana', 'bi-che'' ne bi-za-na''', null, 'biche'' = hermano; ne = y; bizana'' = hermana' from ct_languages where code = 'zai';

-- nivel 2 · unidad 4: cómo es
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Huiini''', 'pequeño(a)', 'huii-ni''', null, 'huiini'' = pequeño' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Naroba''', 'grande', 'na-ro-ba''', null, 'na- = así es (estado); roba'' = grande' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Mboota', 'grandote', 'mboo-ta', null, 'mboota = grandote' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Sicarú', 'bonito(a)', 'si-ca-rú', null, 'sicarú = bonito' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Yoo huiini''', 'casa pequeña', 'yoo huii-ni''', null, 'yoo = casa; huiini'' = pequeño' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Yaga naroba''', 'árbol grande', 'ya-ga na-ro-ba''', null, 'yaga = árbol; naroba'' = grande' from ct_languages where code = 'zai';

-- nivel 2 · unidad 5: los colores
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Naguchi', 'amarillo', 'na-gu-chi', null, 'na- = así es (estado); guchi = amarillo' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Naxiñá', 'rojo', 'na-xi-ñá', null, 'na- = así es (estado); xiñá = rojo' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Naquichi', 'blanco', 'na-qui-chi', null, 'na- = así es (estado); quichi = blanco' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nayaase''', 'negro', 'na-yaa-se''', null, 'na- = así es (estado); yaase'' = negro' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nayaxe', 'verde / azul', 'na-ya-xe', null, 'na- = así es (estado); yaxe = verde, azul' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guie'' naxiñá', 'flor roja', 'guie'' na-xi-ñá', null, 'guie'' = flor; naxiñá = rojo' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bi''cu'' nayaase''', 'perro negro', 'bi''-cu'' na-yaa-se''', null, 'bi''cu'' = perro; nayaase'' = negro' from ct_languages where code = 'zai';

-- nivel 2 · unidad 6: contar del uno al cinco
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tobi', 'uno', 'to-bi', null, 'tobi = uno' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chupa', 'dos', 'chu-pa', null, 'chupa = dos' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chonna', 'tres', 'chon-na', null, 'chonna = tres' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tapa', 'cuatro', 'ta-pa', null, 'tapa = cuatro' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Gaayu''', 'cinco', 'gaa-yu''', null, 'gaayu'' = cinco' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chupa bi''cu''', 'dos perros', 'chu-pa bi''-cu''', null, 'chupa = dos; bi''cu'' = perro' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ti yaga', 'un árbol', 'ti ya-ga', null, 'ti = un, uno; yaga = árbol' from ct_languages where code = 'zai';

-- nivel 3 · unidad 1: palabras para preguntar
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xi?', '¿qué?', 'xi', null, 'xi = qué' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tu?', '¿quién?', 'tu', null, 'tu = quién' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Paraa?', '¿dónde?', 'pa-raa', null, 'paraa = dónde' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xiñee?', '¿por qué?', 'xi-ñee', null, 'xiñee = por qué' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Tu laabe?', '¿quién es él / ella?', 'tu laa-be', null, 'tu = quién; laabe = él, ella' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Paraa nuu yoo?', '¿dónde está la casa?', 'pa-raa nuu yoo', null, 'paraa = dónde; nuu = está; yoo = casa' from ct_languages where code = 'zai';

-- nivel 3 · unidad 2: mi casa y mi comunidad
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Yoo', 'casa', 'yoo', null, 'yoo = casa' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Lidxi', 'hogar', 'li-dxi', null, 'lidxi = hogar, casa de alguien' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guidxi', 'pueblo', 'gui-dxi', null, 'guidxi = pueblo' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Neza', 'camino', 'ne-za', null, 'neza = camino' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jneza guidxi', 'camino del pueblo', 'jne-za gui-dxi', null, 'j- = de (posesión); neza = camino; guidxi = pueblo' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ti yoo', 'una casa', 'ti yoo', null, 'ti = un, uno; yoo = casa' from ct_languages where code = 'zai';

-- nivel 3 · unidad 3: contar del seis al diez
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xhoopa''', 'seis', 'xhoo-pa''', null, 'xhoopa'' = seis' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Gadxe', 'siete', 'ga-dxe', null, 'gadxe = siete' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xhono', 'ocho', 'xho-no', null, 'xhono = ocho' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ga''', 'nueve', 'ga''', null, 'ga'' = nueve' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chii', 'diez', 'chii', null, 'chii = diez' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chii ne tobi', 'once', 'chii ne to-bi', null, 'chii = diez; ne = y; tobi = uno' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chii ne chupa', 'doce', 'chii ne chu-pa', null, 'chii = diez; ne = y; chupa = dos' from ct_languages where code = 'zai';

-- nivel 3 · unidad 4: lugares y cosas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Dani', 'cerro', 'da-ni', null, 'dani = cerro' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guiigu''', 'río', 'guii-gu''', null, 'guiigu'' = río' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Le''', 'cerco', 'le''', null, 'le'' = cerco' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nisa', 'agua', 'ni-sa', null, 'nisa = agua' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Luguiá dani', 'encima del cerro', 'lu-guiá da-ni', null, 'luguiá = encima de; dani = cerro' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xa''na yaga', 'debajo del árbol', 'xa''-na ya-ga', null, 'xa''na = debajo de; yaga = árbol' from ct_languages where code = 'zai';

-- nivel 3 · unidad 5: encima, debajo y dentro
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Luguiá', 'encima de', 'lu-guiá', null, 'luguiá = encima de' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xa''na', 'debajo de', 'xa''-na', null, 'xa''na = debajo de' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ndaani''', 'dentro de', 'ndaa-ni''', null, 'ndaani'' = dentro de' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ndaani'' yoo', 'dentro de la casa', 'ndaa-ni'' yoo', null, 'ndaani'' = dentro de; yoo = casa' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Luguiá yaga', 'encima del árbol', 'lu-guiá ya-ga', null, 'luguiá = encima de; yaga = árbol' from ct_languages where code = 'zai';

-- nivel 3 · unidad 6: preguntas útiles
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nga', 'ése / es', 'nga', null, 'nga = ése, es' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jma', 'más', 'jma', null, 'jma = más' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Caadxi', 'poco(s)', 'caa-dxi', null, 'caadxi = poco, pocos' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xi nga ca?', '¿qué es eso?', 'xi nga ca', null, 'xi = qué; nga = es; ca = eso' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Jma nisa', 'más agua', 'jma ni-sa', null, 'jma = más; nisa = agua' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Caadxi gueta', 'unas pocas tortillas', 'caa-dxi gue-ta', null, 'caadxi = poco; gueta = tortilla' from ct_languages where code = 'zai';

-- nivel 4 · unidad 1: hoy y mañana
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Yanna', 'ahora', 'yan-na', null, 'yanna = ahora' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Yannadxí', 'hoy', 'yan-na-dxí', null, 'yanna = ahora; dxí = día' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guixi', 'mañana', 'gui-xi', null, 'guixi = mañana (el día siguiente)' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Siado''', 'temprano / en la mañana', 'sia-do''', null, 'siado'' = temprano, por la mañana' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guixi siado''', 'mañana temprano', 'gui-xi sia-do''', null, 'guixi = mañana; siado'' = temprano' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Yannadxí ne guixi', 'hoy y mañana', 'yan-na-dxí ne gui-xi', null, 'yannadxí = hoy; ne = y; guixi = mañana' from ct_languages where code = 'zai';

-- nivel 4 · unidad 2: la naturaleza
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Gubidxa', 'sol', 'gu-bi-dxa', null, 'gubidxa = sol' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Beeu', 'luna', 'beeu', null, 'beeu = luna, mes' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guie''', 'flor', 'guie''', null, 'guie'' = flor' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Yaga', 'árbol', 'ya-ga', null, 'yaga = árbol, madera' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Gui', 'fuego', 'gui', null, 'gui = fuego' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Gubidxa ne beeu', 'el sol y la luna', 'gu-bi-dxa ne beeu', null, 'gubidxa = sol; ne = y; beeu = luna' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guie'' sicarú', 'flor bonita', 'guie'' si-ca-rú', null, 'guie'' = flor; sicarú = bonito' from ct_languages where code = 'zai';

-- nivel 4 · unidad 3: lo que hago
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ro', 'come', 'ro', null, 'ro = come (de costumbre)' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Riguite', 'juega', 'ri-gui-te', null, 'ri- = de costumbre; guite = jugar' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ruuna', 'llora', 'ruu-na', null, 'ru- = de costumbre; uuna = llorar' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ruxidxi', 'ríe', 'ru-xi-dxi', null, 'ru- = de costumbre; xidxi = reír' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ro gueta', 'come tortilla', 'ro gue-ta', null, 'ro = come; gueta = tortilla' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Riguite ca ba''du''', 'los niños juegan', 'ri-gui-te ca ba''-du''', null, 'ri- = de costumbre; guite = jugar; ca = plural (los); ba''du'' = niño' from ct_languages where code = 'zai';

-- nivel 4 · unidad 4: lo que pasó
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ma', 'ya', 'ma', null, 'ma = ya' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Biree', 'salió', 'bi-ree', null, 'bi- = ya pasó; ree = salir' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Biaazi', 'cayó / llegó (la noche)', 'biaa-zi', null, 'bi- = ya pasó; aazi = caer, llegar' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ma biree', 'ya salió', 'ma bi-ree', null, 'ma = ya; bi- = ya pasó; ree = salir' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Biree gubidxa', 'salió el sol', 'bi-ree gu-bi-dxa', null, 'bi- = ya pasó; ree = salir; gubidxa = sol' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ma biaazi gueela''', 'ya anocheció', 'ma biaa-zi guee-la''', null, 'ma = ya; biaazi = cayó, llegó; gueela'' = noche' from ct_languages where code = 'zai';

-- nivel 4 · unidad 5: días, meses y años
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Iza', 'año', 'i-za', null, 'iza = año' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ti iza', 'un año', 'ti i-za', null, 'ti = un, uno; iza = año' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chupa dxi', 'dos días', 'chu-pa dxi', null, 'chupa = dos; dxi = día' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chonna beeu', 'tres meses', 'chon-na beeu', null, 'chonna = tres; beeu = luna, mes' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Gande', 'veinte', 'gan-de', null, 'gande = veinte' from ct_languages where code = 'zai';

-- nivel 4 · unidad 6: el clima
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bi', 'viento / aire', 'bi', null, 'bi = viento, aire' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Naga''nda', 'frío', 'na-ga''n-da', null, 'na- = así es (estado); ga''nda = frío' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nisaguie', 'lluvia', 'ni-sa-guie', null, 'nisa = agua; guie = (de arriba)' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bi naga''nda', 'aire frío', 'bi na-ga''n-da', null, 'bi = aire; naga''nda = frío' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Zá ne nisaguie', 'nube y lluvia', 'zá ne ni-sa-guie', null, 'zá = nube; ne = y; nisaguie = lluvia' from ct_languages where code = 'zai';

-- nivel 5 · unidad 1: la comida
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Gueta', 'tortilla', 'gue-ta', null, 'gueta = tortilla' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xuba''', 'maíz (grano)', 'xu-ba''', null, 'xuba'' = maíz en grano' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Zidi', 'sal', 'zi-di', null, 'zidi = sal' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Niza', 'mazorca', 'ni-za', null, 'niza = mazorca' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Zee', 'elote', 'zee', null, 'zee = elote' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Cuba', 'masa', 'cu-ba', null, 'cuba = masa' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Gueta ne zidi', 'tortilla con sal', 'gue-ta ne zi-di', null, 'gueta = tortilla; ne = y, con; zidi = sal' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ti niza', 'una mazorca', 'ti ni-za', null, 'ti = un, uno; niza = mazorca' from ct_languages where code = 'zai';

-- nivel 5 · unidad 2: frutas y plantas
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Biadxi', 'ciruela', 'bia-dxi', null, 'biadxi = ciruela' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Du''ga''', 'higo', 'du''-ga''', null, 'du''ga'' = higo' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guitu', 'calabaza', 'gui-tu', null, 'guitu = calabaza' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Gueza', 'tabaco', 'gue-za', null, 'gueza = tabaco' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Yaga biadxi', 'árbol de ciruela', 'ya-ga bia-dxi', null, 'yaga = árbol; biadxi = ciruela' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chupa biadxi', 'dos ciruelas', 'chu-pa bia-dxi', null, 'chupa = dos; biadxi = ciruela' from ct_languages where code = 'zai';

-- nivel 5 · unidad 3: en la casa
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guixhe', 'hamaca', 'gui-xhe', null, 'guixhe = hamaca' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Daa', 'petate', 'daa', null, 'daa = petate' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Doo', 'mecate / cuerda', 'doo', null, 'doo = mecate, cuerda' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Dxumi', 'canasta', 'dxu-mi', null, 'dxumi = canasta' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ruba', 'tenate', 'ru-ba', null, 'ruba = tenate' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ti guixhe', 'una hamaca', 'ti gui-xhe', null, 'ti = un, uno; guixhe = hamaca' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Daa ne guixhe', 'petate y hamaca', 'daa ne gui-xhe', null, 'daa = petate; ne = y; guixhe = hamaca' from ct_languages where code = 'zai';

-- nivel 5 · unidad 4: la ropa
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bidaani', 'huipil', 'bi-daa-ni', null, 'bidaani = huipil' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Suudi', 'su enagua', 'suu-di', null, 'suudi = enagua de ella (forma poseída)' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nahui', 'lleva puesta (falda)', 'na-hui', null, 'nahui = lleva puesta (falda larga)' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bidaani sicarú', 'huipil bonito', 'bi-daa-ni si-ca-rú', null, 'bidaani = huipil; sicarú = bonito' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bidaani naxiñá', 'huipil rojo', 'bi-daa-ni na-xi-ñá', null, 'bidaani = huipil; naxiñá = rojo' from ct_languages where code = 'zai';

-- nivel 5 · unidad 5: la milpa
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ñaa', 'milpa', 'ñaa', null, 'ñaa = milpa (terreno)' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guela', 'milpa tierna', 'gue-la', null, 'guela = las plantas de la milpa' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bexa', 'grano', 'be-xa', null, 'bexa = grano' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guichi', 'espina', 'gui-chi', null, 'guichi = espina' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ndaani'' ñaa', 'dentro de la milpa', 'ndaa-ni'' ñaa', null, 'ndaani'' = dentro de; ñaa = milpa' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ñaa naroba''', 'milpa grande', 'ñaa na-ro-ba''', null, 'ñaa = milpa; naroba'' = grande' from ct_languages where code = 'zai';

-- nivel 5 · unidad 6: sabores y olores
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nanixe', 'sabroso', 'na-ni-xe', null, 'na- = así es (estado); nixe = sabroso' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xho''', 'olor', 'xho''', null, 'xho'' = olor' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Lanna''', 'olor a metal o a pescado', 'lan-na''', null, 'lanna'' = olor a metal o a pescado' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Gueta nanixe', 'tortilla sabrosa', 'gue-ta na-ni-xe', null, 'gueta = tortilla; nanixe = sabroso' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xho'' guie''', 'olor a flor', 'xho'' guie''', null, 'xho'' = olor; guie'' = flor' from ct_languages where code = 'zai';

-- nivel 6 · unidad 1: animales del monte
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Lexu', 'conejo', 'le-xu', null, 'lexu = conejo' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ga''na''', 'mapache', 'ga''-na''', null, 'ga''na'' = mapache' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Be''te''', 'zorrillo', 'be''-te''', null, 'be''te'' = zorrillo' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Beenda''', 'culebra', 'been-da''', null, 'beenda'' = culebra' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Migu', 'mono', 'mi-gu', null, 'migu = mono' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Mistu gui''xhi''', 'gato montés', 'mis-tu gui''-xhi''', null, 'mistu = gato; gui''xhi'' = monte' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Mani'' gui''xhi''', 'animal del monte', 'ma-ni'' gui''-xhi''', null, 'mani'' = animal; gui''xhi'' = monte' from ct_languages where code = 'zai';

-- nivel 6 · unidad 2: animales de la casa
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bi''cu''', 'perro', 'bi''-cu''', null, 'bi''cu'' = perro' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Mistu', 'gato', 'mis-tu', null, 'mistu = gato' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bere', 'pollo / gallina', 'be-re', null, 'bere = pollo, gallina' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Mani''', 'animal', 'ma-ni''', null, 'mani'' = animal' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bizu', 'abeja', 'bi-zu', null, 'bizu = abeja' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Huaga', 'rata', 'hua-ga', null, 'huaga = rata' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ca bi''cu''', 'los perros', 'ca bi''-cu''', null, 'ca = plural (los); bi''cu'' = perro' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ti bere', 'un pollo', 'ti be-re', null, 'ti = un, uno; bere = pollo' from ct_languages where code = 'zai';

-- nivel 6 · unidad 3: la cabeza
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ique', 'cabeza', 'i-que', null, 'ique = cabeza' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Diaga', 'oreja', 'dia-ga', null, 'diaga = oreja' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xii', 'nariz', 'xii', null, 'xii = nariz' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Lu', 'cara', 'lu', null, 'lu = cara, ojo' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Bizalú', 'ojo', 'bi-za-lú', null, 'bizalú = ojo (de lu = cara, ojo)' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Laya', 'diente', 'la-ya', null, 'laya = diente' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guicha', 'cabello', 'gui-cha', null, 'guicha = cabello' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guicha nayaase''', 'cabello negro', 'gui-cha na-yaa-se''', null, 'guicha = cabello; nayaase'' = negro' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chupa diaga', 'dos orejas', 'chu-pa dia-ga', null, 'chupa = dos; diaga = oreja' from ct_languages where code = 'zai';

-- nivel 6 · unidad 4: el cuerpo
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ladi', 'cuerpo', 'la-di', null, 'ladi = cuerpo' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ñee', 'pierna', 'ñee', null, 'ñee = pierna' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Batañee', 'pie', 'ba-ta-ñee', null, 'batañee = pie (de ñee = pierna)' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Xibi', 'rodilla', 'xi-bi', null, 'xibi = rodilla' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Ladi binni', 'cuerpo de una persona', 'la-di bin-ni', null, 'ladi = cuerpo; binni = persona' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Chupa ñee', 'dos piernas', 'chu-pa ñee', null, 'chupa = dos; ñee = pierna' from ct_languages where code = 'zai';

-- nivel 6 · unidad 5: palabras con guenda
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guendanabani', 'vida', 'guen-da-na-ba-ni', null, 'guenda- = (forma sustantivos); nabani = vivo' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guendaró', 'comida', 'guen-da-ró', null, 'guenda- = (forma sustantivos); ró = comer' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guenda guti', 'muerte', 'guen-da gu-ti', null, 'guenda = (forma sustantivos); guti = morir' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guendanabani ne guenda guti', 'la vida y la muerte', 'guen-da-na-ba-ni ne guen-da gu-ti', null, 'guendanabani = vida; ne = y; guenda guti = muerte' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Diidxa'' sicarú', 'palabra bonita', 'dii-dxa'' si-ca-rú', null, 'diidxa'' = palabra; sicarú = bonito' from ct_languages where code = 'zai';

-- nivel 6 · unidad 6: conversación final
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Nadxiie'' lii', 'te quiero', 'na-dxiie'' lii', null, 'nadxii = querer; -e'' = yo; lii = a ti' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Pa ganda', 'si se puede', 'pa gan-da', null, 'pa = si; ganda = poder' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Hra bidubi', 'el final', 'hra bi-du-bi', null, 'hra = cuando; bi- = ya pasó; dubi = terminar' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Guidxi sicarú', 'pueblo bonito', 'gui-dxi si-ca-rú', null, 'guidxi = pueblo; sicarú = bonito' from ct_languages where code = 'zai';
insert into ct_vocabulary (language_id, word, translation, pronunciation, example, breakdown)
select id, 'Da''bacaanda lu''', 'tienes sueño', 'da''-ba-caan-da lu''', null, 'da''bacaanda = tener sueño; lu'' = tú' from ct_languages where code = 'zai';

-- ─────────────────────────────────────────────
--  5. rl_unit_vocab — vocabulario por unidad
-- ─────────────────────────────────────────────
-- nivel 1 · unidad 1: saludos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1
and v.word in ('Padiuxi', 'Xi modo nuu lii?', 'Ne lii?', 'Xi modo nuu laabe?', 'Nuu');

-- nivel 1 · unidad 2: el día y la noche
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 2
and v.word in ('Dxi', 'Gueela''', 'Huadxí', 'Ti dxi', 'Ti gueela''');

-- nivel 1 · unidad 3: ¿quién eres?
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 3
and v.word in ('Xi lalu''?', 'Xi labe?', 'La', 'Naa', 'Lii', 'Laabe');

-- nivel 1 · unidad 4: agradecer y responder
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 4
and v.word in ('Xquíxe pe'' lii', 'Xquíxe pe'' laatu', 'Co''', 'Diidxa''', 'Diidxa'' ca');

-- nivel 1 · unidad 5: las personas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 5
and v.word in ('Ba''du''', 'Dxaapa''', 'Badudxaapa''', 'Badunguiiu', 'Ba''du huiini''', 'Ba''du dxaapa huiini''');

-- nivel 1 · unidad 6: conversación básica
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 6
and v.word in ('Diidxazá', 'Binnizá', 'Binni', 'Zá', 'Binni guidxi', 'Naa binnizá');

-- nivel 2 · unidad 1: pronombres personales
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 1
and v.word in ('Laanu', 'Laatu', 'Laacabe', 'Naa ne lii', 'Laabe ne naa');

-- nivel 2 · unidad 2: la familia
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 2
and v.word in ('Jñaa', 'Bixhoze', 'Xiiñi''', 'Xheela''', 'Jñaa ne bixhoze', 'Xiiñilu''', 'Jñaa ne xiiñi''');

-- nivel 2 · unidad 3: los abuelos y los hermanos
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 3
and v.word in ('Jñaabida''', 'Bixhozebida''', 'Biche''', 'Bizana''', 'Jñaabida'' ne bixhozebida''', 'Biche'' ne bizana''');

-- nivel 2 · unidad 4: cómo es
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 4
and v.word in ('Huiini''', 'Naroba''', 'Mboota', 'Sicarú', 'Yoo huiini''', 'Yaga naroba''');

-- nivel 2 · unidad 5: los colores
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 5
and v.word in ('Naguchi', 'Naxiñá', 'Naquichi', 'Nayaase''', 'Nayaxe', 'Guie'' naxiñá', 'Bi''cu'' nayaase''');

-- nivel 2 · unidad 6: contar del uno al cinco
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 6
and v.word in ('Tobi', 'Chupa', 'Chonna', 'Tapa', 'Gaayu''', 'Chupa bi''cu''', 'Ti yaga');

-- nivel 3 · unidad 1: palabras para preguntar
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 1
and v.word in ('Xi?', 'Tu?', 'Paraa?', 'Xiñee?', 'Tu laabe?', 'Paraa nuu yoo?');

-- nivel 3 · unidad 2: mi casa y mi comunidad
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 2
and v.word in ('Yoo', 'Lidxi', 'Guidxi', 'Neza', 'Jneza guidxi', 'Ti yoo');

-- nivel 3 · unidad 3: contar del seis al diez
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 3
and v.word in ('Xhoopa''', 'Gadxe', 'Xhono', 'Ga''', 'Chii', 'Chii ne tobi', 'Chii ne chupa');

-- nivel 3 · unidad 4: lugares y cosas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 4
and v.word in ('Dani', 'Guiigu''', 'Le''', 'Nisa', 'Luguiá dani', 'Xa''na yaga');

-- nivel 3 · unidad 5: encima, debajo y dentro
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 5
and v.word in ('Luguiá', 'Xa''na', 'Ndaani''', 'Ndaani'' yoo', 'Luguiá yaga');

-- nivel 3 · unidad 6: preguntas útiles
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 6
and v.word in ('Nga', 'Jma', 'Caadxi', 'Xi nga ca?', 'Jma nisa', 'Caadxi gueta');

-- nivel 4 · unidad 1: hoy y mañana
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 1
and v.word in ('Yanna', 'Yannadxí', 'Guixi', 'Siado''', 'Guixi siado''', 'Yannadxí ne guixi');

-- nivel 4 · unidad 2: la naturaleza
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 2
and v.word in ('Gubidxa', 'Beeu', 'Guie''', 'Yaga', 'Gui', 'Gubidxa ne beeu', 'Guie'' sicarú');

-- nivel 4 · unidad 3: lo que hago
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 3
and v.word in ('Ro', 'Riguite', 'Ruuna', 'Ruxidxi', 'Ro gueta', 'Riguite ca ba''du''');

-- nivel 4 · unidad 4: lo que pasó
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 4
and v.word in ('Ma', 'Biree', 'Biaazi', 'Ma biree', 'Biree gubidxa', 'Ma biaazi gueela''');

-- nivel 4 · unidad 5: días, meses y años
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 5
and v.word in ('Iza', 'Ti iza', 'Chupa dxi', 'Chonna beeu', 'Gande');

-- nivel 4 · unidad 6: el clima
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 6
and v.word in ('Bi', 'Naga''nda', 'Nisaguie', 'Bi naga''nda', 'Zá ne nisaguie');

-- nivel 5 · unidad 1: la comida
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 1
and v.word in ('Gueta', 'Xuba''', 'Zidi', 'Niza', 'Zee', 'Cuba', 'Gueta ne zidi', 'Ti niza');

-- nivel 5 · unidad 2: frutas y plantas
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 2
and v.word in ('Biadxi', 'Du''ga''', 'Guitu', 'Gueza', 'Yaga biadxi', 'Chupa biadxi');

-- nivel 5 · unidad 3: en la casa
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 3
and v.word in ('Guixhe', 'Daa', 'Doo', 'Dxumi', 'Ruba', 'Ti guixhe', 'Daa ne guixhe');

-- nivel 5 · unidad 4: la ropa
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 4
and v.word in ('Bidaani', 'Suudi', 'Nahui', 'Bidaani sicarú', 'Bidaani naxiñá');

-- nivel 5 · unidad 5: la milpa
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 5
and v.word in ('Ñaa', 'Guela', 'Bexa', 'Guichi', 'Ndaani'' ñaa', 'Ñaa naroba''');

-- nivel 5 · unidad 6: sabores y olores
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 6
and v.word in ('Nanixe', 'Xho''', 'Lanna''', 'Gueta nanixe', 'Xho'' guie''');

-- nivel 6 · unidad 1: animales del monte
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 1
and v.word in ('Lexu', 'Ga''na''', 'Be''te''', 'Beenda''', 'Migu', 'Mistu gui''xhi''', 'Mani'' gui''xhi''');

-- nivel 6 · unidad 2: animales de la casa
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 2
and v.word in ('Bi''cu''', 'Mistu', 'Bere', 'Mani''', 'Bizu', 'Huaga', 'Ca bi''cu''', 'Ti bere');

-- nivel 6 · unidad 3: la cabeza
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 3
and v.word in ('Ique', 'Diaga', 'Xii', 'Lu', 'Bizalú', 'Laya', 'Guicha', 'Guicha nayaase''', 'Chupa diaga');

-- nivel 6 · unidad 4: el cuerpo
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 4
and v.word in ('Ladi', 'Ñee', 'Batañee', 'Xibi', 'Ladi binni', 'Chupa ñee');

-- nivel 6 · unidad 5: palabras con guenda
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 5
and v.word in ('Guendanabani', 'Guendaró', 'Guenda guti', 'Guendanabani ne guenda guti', 'Diidxa'' sicarú');

-- nivel 6 · unidad 6: conversación final
insert into rl_unit_vocab (unit_id, vocab_id)
select u.id, v.id from ct_units u
join ct_levels l on u.level_id = l.id
join ct_languages la on l.language_id = la.id
join ct_vocabulary v on v.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 6
and v.word in ('Nadxiie'' lii', 'Pa ganda', 'Hra bidubi', 'Guidxi sicarú', 'Da''bacaanda lu''');

-- ─────────────────────────────────────────────
--  6. ejercicios (6 por unidad: 4 opción múltiple + 2 completar)
-- ─────────────────────────────────────────────
-- nivel 1 · unidad 1: saludos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hola',
       '["Padiuxi"]',
       '["Diidxa'' ca", "Badunguiiu", "Padiuxi", "Laabe"]',
       'citlali',
       'Padiuxi significa hola',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Cómo estás?',
       '["Xi modo nuu lii?"]',
       '["Xi labe?", "Xi modo nuu laabe?", "Xi lalu''?", "Xi modo nuu lii?"]',
       'coltzin',
       'Xi modo nuu lii?: xi (qué) + modo (modo (del español)) + nuu (está) + lii (tú)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Está',
       '["Nuu"]',
       '["Ti dxi", "Nuu", "Dxi", "Naa binnizá"]',
       'neza',
       'Nuu significa está',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Y tú?',
       '["Ne lii?"]',
       '["Xi lalu''?", "Xi labe?", "Ne lii?", "Xi modo nuu laabe?"]',
       'tonatiuh',
       'Ne lii?: ne (y) + lii (tú)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ne ______?',
       '["lii", "Ne lii?", "Ne lii"]',
       null,
       'xochitl',
       'lii = tú',
       20, 'medium',
       '¿Y tú?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Xi modo nuu ______?',
       '["laabe", "Xi modo nuu laabe?", "Xi modo nuu laabe"]',
       null,
       'citlali',
       'laabe = él, ella',
       20, 'medium',
       '¿Cómo está él'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1;

-- nivel 1 · unidad 2: el día y la noche
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Día',
       '["Dxi"]',
       '["Nuu", "Binnizá", "Dxi", "Binni guidxi"]',
       'coltzin',
       'Dxi significa día',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Noche',
       '["Gueela''"]',
       '["Naa", "Binni", "Gueela''", "Nuu"]',
       'neza',
       'Gueela'' significa noche',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tarde',
       '["Huadxí"]',
       '["Gueela''", "Co''", "Huadxí", "Naa binnizá"]',
       'tonatiuh',
       'Huadxí significa tarde',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Un día',
       '["Ti dxi"]',
       '["Naa", "Nuu", "Ti dxi", "Binni guidxi"]',
       'xochitl',
       'Ti dxi: ti (un, uno) + dxi (día)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ti ______',
       '["dxi", "Ti dxi"]',
       null,
       'citlali',
       'dxi = día',
       20, 'medium',
       'Un día'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ti ______',
       '["gueela''", "Ti gueela''"]',
       null,
       'coltzin',
       'gueela'' = noche',
       20, 'medium',
       'Una noche'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 2;

-- nivel 1 · unidad 3: ¿quién eres?
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nombre',
       '["La"]',
       '["La", "Zá", "Dxi", "Ba''du huiini''"]',
       'neza',
       'La significa nombre',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Yo',
       '["Naa"]',
       '["Binni", "Diidxazá", "La", "Naa"]',
       'tonatiuh',
       'Naa significa yo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tú',
       '["Lii"]',
       '["Lii", "Naa binnizá", "La", "Ba''du''"]',
       'xochitl',
       'Lii significa tú',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Él',
       '["Laabe"]',
       '["Badunguiiu", "Naa binnizá", "Laabe", "La"]',
       'citlali',
       'Laabe: laa ((base del pronombre)) + -be (él, ella)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Xi ______?',
       '["lalu''", "Xi lalu''?", "Xi lalu''"]',
       null,
       'coltzin',
       'Xi lalu''?: xi (qué) + la (nombre) + -lu'' (tu)',
       20, 'medium',
       '¿Cómo te llamas?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Xi ______?',
       '["labe", "Xi labe?", "Xi labe"]',
       null,
       'neza',
       'Xi labe?: xi (qué) + la (nombre) + -be (su (de él o ella))',
       20, 'medium',
       '¿Cómo se llama él'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 3;

-- nivel 1 · unidad 4: agradecer y responder
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muchas gracias',
       '["Xquíxe pe'' lii"]',
       '["Diidxa'' ca", "Huadxí", "Xquíxe pe'' lii", "Gueela''"]',
       'tonatiuh',
       'Xquíxe pe'' lii: xquíxe (gracias) + pe'' (mucho) + lii (a ti)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'No',
       '["Co''"]',
       '["Dxaapa''", "Binni", "Co''", "Ti dxi"]',
       'xochitl',
       'Co'' significa no',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Palabra',
       '["Diidxa''"]',
       '["Naa", "Dxi", "Diidxa''", "Lii"]',
       'citlali',
       'Diidxa'' significa palabra',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muchas gracias a ustedes',
       '["Xquíxe pe'' laatu"]',
       '["Xquíxe pe'' laatu", "Dxi", "Diidxa''", "Ba''du dxaapa huiini''"]',
       'coltzin',
       'Xquíxe pe'' laatu: xquíxe (gracias) + pe'' (mucho) + laatu (ustedes)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Xquíxe pe'' ______',
       '["laatu", "Xquíxe pe'' laatu"]',
       null,
       'neza',
       'laatu = ustedes',
       20, 'medium',
       'Muchas gracias a ustedes'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Diidxa'' ______',
       '["ca", "Diidxa'' ca"]',
       null,
       'tonatiuh',
       'ca = esa',
       20, 'medium',
       'Esa palabra'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 4;

-- nivel 1 · unidad 5: las personas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Niño',
       '["Ba''du''"]',
       '["Nuu", "Badudxaapa''", "Ba''du''", "Naa"]',
       'xochitl',
       'Ba''du'' significa niño',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Jovencita',
       '["Dxaapa''"]',
       '["Nuu", "Zá", "Badunguiiu", "Dxaapa''"]',
       'citlali',
       'Dxaapa'' significa jovencita',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muchacha',
       '["Badudxaapa''"]',
       '["Gueela''", "Binni guidxi", "Ba''du dxaapa huiini''", "Badudxaapa''"]',
       'coltzin',
       'Badudxaapa'': ba''du'' (niño, joven) + dxaapa'' (jovencita)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muchacho',
       '["Badunguiiu"]',
       '["Badunguiiu", "Naa", "Diidxa''", "Huadxí"]',
       'neza',
       'Badunguiiu: ba''du'' (niño, joven) + nguiiu (hombre)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ba''du ______',
       '["huiini''", "Ba''du huiini''"]',
       null,
       'tonatiuh',
       'huiini'' = pequeño',
       20, 'medium',
       'Bebé'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ba''du dxaapa ______',
       '["huiini''", "Ba''du dxaapa huiini''"]',
       null,
       'xochitl',
       'huiini'' = pequeño',
       20, 'medium',
       'Niña'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 5;

-- nivel 1 · unidad 6: conversación básica
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lengua zapoteca',
       '["Diidxazá"]',
       '["Binni guidxi", "Diidxazá", "Gueela''", "Zá"]',
       'citlali',
       'Diidxazá: diidxa'' (palabra) + zá (nube)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Gente zapoteca',
       '["Binnizá"]',
       '["Ti gueela''", "Naa", "Binnizá", "Laabe"]',
       'coltzin',
       'Binnizá: binni (gente) + zá (nube)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Gente',
       '["Binni"]',
       '["Ti dxi", "Ba''du''", "Laabe", "Binni"]',
       'neza',
       'Binni significa gente',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nube',
       '["Zá"]',
       '["Zá", "Badudxaapa''", "Dxi", "Huadxí"]',
       'tonatiuh',
       'Zá significa nube',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Binni ______',
       '["guidxi", "Binni guidxi"]',
       null,
       'xochitl',
       'guidxi = pueblo',
       20, 'medium',
       'Gente del pueblo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Naa ______',
       '["binnizá", "Naa binnizá"]',
       null,
       'citlali',
       'binnizá = gente zapoteca',
       20, 'medium',
       'Soy zapoteca'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 1 and u.unit_num = 6;

-- nivel 2 · unidad 1: pronombres personales
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nosotros(as)',
       '["Laanu"]',
       '["Bixhozebida''", "Biche''", "Laanu", "Ba''du huiini''"]',
       'coltzin',
       'Laanu: laa ((base del pronombre)) + -nu (nosotros)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ustedes',
       '["Laatu"]',
       '["Laatu", "Nayaase''", "Naa ne lii", "Co''"]',
       'neza',
       'Laatu: laa ((base del pronombre)) + -tu (ustedes)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ellos',
       '["Laacabe"]',
       '["Laabe ne naa", "Badunguiiu", "Laacabe", "Jñaabida'' ne bixhozebida''"]',
       'tonatiuh',
       'Laacabe: laa ((base del pronombre)) + ca (plural) + -be (él, ella)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Yo y tú',
       '["Naa ne lii"]',
       '["Gaayu''", "Badudxaapa''", "Naa ne lii", "Jñaa ne xiiñi''"]',
       'xochitl',
       'Naa ne lii: naa (yo) + ne (y) + lii (tú)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Naa ne ______',
       '["lii", "Naa ne lii"]',
       null,
       'citlali',
       'lii = tú',
       20, 'medium',
       'Yo y tú'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Laabe ne ______',
       '["naa", "Laabe ne naa"]',
       null,
       'coltzin',
       'naa = yo',
       20, 'medium',
       'Él'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 1;

-- nivel 2 · unidad 2: la familia
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mamá',
       '["Jñaa"]',
       '["Laanu", "Padiuxi", "Jñaa", "Bixhoze"]',
       'neza',
       'Jñaa significa mamá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Papá',
       '["Bixhoze"]',
       '["Dxi", "Naa ne lii", "Jñaabida'' ne bixhozebida''", "Bixhoze"]',
       'tonatiuh',
       'Bixhoze significa papá',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hijo',
       '["Xiiñi''"]',
       '["Binni", "Badunguiiu", "Laacabe", "Xiiñi''"]',
       'xochitl',
       'Xiiñi'' significa hijo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Esposo(a)',
       '["Xheela''"]',
       '["Tapa", "Xheela''", "Badudxaapa''", "Padiuxi"]',
       'citlali',
       'Xheela'' significa esposo(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Jñaa ne ______',
       '["bixhoze", "Jñaa ne bixhoze"]',
       null,
       'coltzin',
       'bixhoze = papá',
       20, 'medium',
       'Mamá y papá'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Jñaa ne ______',
       '["xiiñi''", "Jñaa ne xiiñi''"]',
       null,
       'neza',
       'xiiñi'' = hijo',
       20, 'medium',
       'Mamá e hijo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 2;

-- nivel 2 · unidad 3: los abuelos y los hermanos
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Abuela',
       '["Jñaabida''"]',
       '["Binnizá", "Gaayu''", "Laabe", "Jñaabida''"]',
       'tonatiuh',
       'Jñaabida'': jñaa (madre) + bida'' (anciana)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Abuelo',
       '["Bixhozebida''"]',
       '["Naquichi", "Ba''du huiini''", "Bixhozebida''", "Lii"]',
       'xochitl',
       'Bixhozebida'': bixhoze (padre) + bida'' (anciano)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hermano (de un hombre)',
       '["Biche''"]',
       '["Naa ne lii", "Laabe", "Biche''", "Huiini''"]',
       'citlali',
       'Biche'' significa hermano (de un hombre)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hermana (de un hombre)',
       '["Bizana''"]',
       '["Chupa", "Laabe ne naa", "Ba''du huiini''", "Bizana''"]',
       'coltzin',
       'Bizana'' significa hermana (de un hombre)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Jñaabida'' ne ______',
       '["bixhozebida''", "Jñaabida'' ne bixhozebida''"]',
       null,
       'neza',
       'bixhozebida'' = abuelo',
       20, 'medium',
       'Abuela y abuelo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Biche'' ne ______',
       '["bizana''", "Biche'' ne bizana''"]',
       null,
       'tonatiuh',
       'bizana'' = hermana',
       20, 'medium',
       'Hermano y hermana'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 3;

-- nivel 2 · unidad 4: cómo es
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pequeño(a)',
       '["Huiini''"]',
       '["Jñaabida'' ne bixhozebida''", "Huiini''", "Huadxí", "Ti dxi"]',
       'xochitl',
       'Huiini'' significa pequeño(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Grande',
       '["Naroba''"]',
       '["Jñaa ne xiiñi''", "Xiiñi''", "Naroba''", "Dxaapa''"]',
       'citlali',
       'Naroba'': na- (así es (estado)) + roba'' (grande)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Grandote',
       '["Mboota"]',
       '["Xheela''", "Ti dxi", "Biche''", "Mboota"]',
       'coltzin',
       'Mboota significa grandote',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Bonito(a)',
       '["Sicarú"]',
       '["Chupa", "Nayaase''", "Sicarú", "Bizana''"]',
       'neza',
       'Sicarú significa bonito(a)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Yoo ______',
       '["huiini''", "Yoo huiini''"]',
       null,
       'tonatiuh',
       'huiini'' = pequeño',
       20, 'medium',
       'Casa pequeña'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Yaga ______',
       '["naroba''", "Yaga naroba''"]',
       null,
       'xochitl',
       'naroba'' = grande',
       20, 'medium',
       'Árbol grande'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 4;

-- nivel 2 · unidad 5: los colores
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Amarillo',
       '["Naguchi"]',
       '["Zá", "Naguchi", "Mboota", "Tapa"]',
       'citlali',
       'Naguchi: na- (así es (estado)) + guchi (amarillo)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Rojo',
       '["Naxiñá"]',
       '["Yaga naroba''", "Naa ne lii", "Naxiñá", "Jñaabida'' ne bixhozebida''"]',
       'coltzin',
       'Naxiñá: na- (así es (estado)) + xiñá (rojo)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Blanco',
       '["Naquichi"]',
       '["Bixhozebida''", "Naquichi", "Co''", "Ti gueela''"]',
       'neza',
       'Naquichi: na- (así es (estado)) + quichi (blanco)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Negro',
       '["Nayaase''"]',
       '["Ti gueela''", "Xquíxe pe'' laatu", "Nayaase''", "Naa"]',
       'tonatiuh',
       'Nayaase'': na- (así es (estado)) + yaase'' (negro)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Guie'' ______',
       '["naxiñá", "Guie'' naxiñá"]',
       null,
       'xochitl',
       'naxiñá = rojo',
       20, 'medium',
       'Flor roja'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Bi''cu'' ______',
       '["nayaase''", "Bi''cu'' nayaase''"]',
       null,
       'citlali',
       'nayaase'' = negro',
       20, 'medium',
       'Perro negro'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 5;

-- nivel 2 · unidad 6: contar del uno al cinco
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Uno',
       '["Tobi"]',
       '["Tobi", "Diidxazá", "Co''", "Gueela''"]',
       'coltzin',
       'Tobi significa uno',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dos',
       '["Chupa"]',
       '["Chupa", "Naa ne lii", "Biche''", "Laanu"]',
       'neza',
       'Chupa significa dos',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tres',
       '["Chonna"]',
       '["Naa ne lii", "Ti gueela''", "Chonna", "Huadxí"]',
       'tonatiuh',
       'Chonna significa tres',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cuatro',
       '["Tapa"]',
       '["Tapa", "Jñaa ne xiiñi''", "Xheela''", "Naxiñá"]',
       'xochitl',
       'Tapa significa cuatro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Chupa ______',
       '["bi''cu''", "Chupa bi''cu''"]',
       null,
       'citlali',
       'bi''cu'' = perro',
       20, 'medium',
       'Dos perros'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ti ______',
       '["yaga", "Ti yaga"]',
       null,
       'coltzin',
       'yaga = árbol',
       20, 'medium',
       'Un árbol'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 2 and u.unit_num = 6;

-- nivel 3 · unidad 1: palabras para preguntar
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Qué?',
       '["Xi?"]',
       '["Xi?", "Paraa nuu yoo?", "Xiñee?", "Xi nga ca?"]',
       'neza',
       'Xi? significa ¿qué?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Quién?',
       '["Tu?"]',
       '["Xi?", "Tu?", "Paraa?", "Xi nga ca?"]',
       'tonatiuh',
       'Tu? significa ¿quién?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Dónde?',
       '["Paraa?"]',
       '["Xi nga ca?", "Paraa?", "Paraa nuu yoo?", "Tu laabe?"]',
       'xochitl',
       'Paraa? significa ¿dónde?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Por qué?',
       '["Xiñee?"]',
       '["Paraa?", "Xiñee?", "Tu?", "Xi nga ca?"]',
       'citlali',
       'Xiñee? significa ¿por qué?',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Tu ______?',
       '["laabe", "Tu laabe?", "Tu laabe"]',
       null,
       'coltzin',
       'laabe = él, ella',
       20, 'medium',
       '¿Quién es él'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Paraa nuu ______?',
       '["yoo", "Paraa nuu yoo?", "Paraa nuu yoo"]',
       null,
       'neza',
       'yoo = casa',
       20, 'medium',
       '¿Dónde está la casa?'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 1;

-- nivel 3 · unidad 2: mi casa y mi comunidad
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Casa',
       '["Yoo"]',
       '["Jñaa ne xiiñi''", "Gaayu''", "Yoo", "Chii ne tobi"]',
       'tonatiuh',
       'Yoo significa casa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hogar',
       '["Lidxi"]',
       '["Xa''na", "Tapa", "Lidxi", "Dani"]',
       'xochitl',
       'Lidxi significa hogar',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pueblo',
       '["Guidxi"]',
       '["Xa''na yaga", "Guidxi", "Jñaabida'' ne bixhozebida''", "Jñaabida''"]',
       'citlali',
       'Guidxi significa pueblo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Camino',
       '["Neza"]',
       '["Naguchi", "Nayaxe", "Neza", "Chii"]',
       'coltzin',
       'Neza significa camino',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Jneza ______',
       '["guidxi", "Jneza guidxi"]',
       null,
       'neza',
       'guidxi = pueblo',
       20, 'medium',
       'Camino del pueblo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ti ______',
       '["yoo", "Ti yoo"]',
       null,
       'tonatiuh',
       'yoo = casa',
       20, 'medium',
       'Una casa'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 2;

-- nivel 3 · unidad 3: contar del seis al diez
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Seis',
       '["Xhoopa''"]',
       '["Xhoopa''", "Ga''", "Yoo huiini''", "Xheela''"]',
       'xochitl',
       'Xhoopa'' significa seis',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Siete',
       '["Gadxe"]',
       '["Ti yaga", "Caadxi", "Bixhoze", "Gadxe"]',
       'citlali',
       'Gadxe significa siete',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ocho',
       '["Xhono"]',
       '["Jñaa", "Mboota", "Xhono", "Xa''na yaga"]',
       'coltzin',
       'Xhono significa ocho',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nueve',
       '["Ga''"]',
       '["Jñaabida'' ne bixhozebida''", "Tobi", "Bi''cu'' nayaase''", "Ga''"]',
       'neza',
       'Ga'' significa nueve',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Chii ne ______',
       '["tobi", "Chii ne tobi"]',
       null,
       'tonatiuh',
       'tobi = uno',
       20, 'medium',
       'Once'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Chii ne ______',
       '["chupa", "Chii ne chupa"]',
       null,
       'xochitl',
       'chupa = dos',
       20, 'medium',
       'Doce'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 3;

-- nivel 3 · unidad 4: lugares y cosas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cerro',
       '["Dani"]',
       '["Dani", "Yaga naroba''", "Jñaa ne bixhoze", "Nayaxe"]',
       'citlali',
       'Dani significa cerro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Río',
       '["Guiigu''"]',
       '["Xa''na", "Guiigu''", "Ndaani''", "Guidxi"]',
       'coltzin',
       'Guiigu'' significa río',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cerco',
       '["Le''"]',
       '["Le''", "Luguiá", "Xiiñilu''", "Caadxi"]',
       'neza',
       'Le'' significa cerco',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Agua',
       '["Nisa"]',
       '["Ti yoo", "Xa''na yaga", "Nisa", "Jñaabida'' ne bixhozebida''"]',
       'tonatiuh',
       'Nisa significa agua',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Luguiá ______',
       '["dani", "Luguiá dani"]',
       null,
       'xochitl',
       'dani = cerro',
       20, 'medium',
       'Encima del cerro'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Xa''na ______',
       '["yaga", "Xa''na yaga"]',
       null,
       'citlali',
       'yaga = árbol',
       20, 'medium',
       'Debajo del árbol'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 4;

-- nivel 3 · unidad 5: encima, debajo y dentro
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Encima de',
       '["Luguiá"]',
       '["Sicarú", "Luguiá", "Naa ne lii", "Naquichi"]',
       'coltzin',
       'Luguiá significa encima de',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Debajo de',
       '["Xa''na"]',
       '["Guie'' naxiñá", "Chupa", "Xa''na", "Le''"]',
       'neza',
       'Xa''na significa debajo de',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dentro de',
       '["Ndaani''"]',
       '["Ndaani''", "Xhoopa''", "Luguiá dani", "Jñaa ne xiiñi''"]',
       'tonatiuh',
       'Ndaani'' significa dentro de',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dentro de la casa',
       '["Ndaani'' yoo"]',
       '["Ndaani'' yoo", "Xa''na yaga", "Chupa bi''cu''", "Luguiá dani"]',
       'xochitl',
       'Ndaani'' yoo: ndaani'' (dentro de) + yoo (casa)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ndaani'' ______',
       '["yoo", "Ndaani'' yoo"]',
       null,
       'citlali',
       'yoo = casa',
       20, 'medium',
       'Dentro de la casa'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Luguiá ______',
       '["yaga", "Luguiá yaga"]',
       null,
       'coltzin',
       'yaga = árbol',
       20, 'medium',
       'Encima del árbol'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 5;

-- nivel 3 · unidad 6: preguntas útiles
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ése',
       '["Nga"]',
       '["Nga", "Nayaxe", "Xheela''", "Caadxi"]',
       'neza',
       'Nga significa ése',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Más',
       '["Jma"]',
       '["Jma", "Caadxi", "Tapa", "Xhoopa''"]',
       'tonatiuh',
       'Jma significa más',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Poco(s)',
       '["Caadxi"]',
       '["Guidxi", "Mboota", "Caadxi", "Naguchi"]',
       'xochitl',
       'Caadxi significa poco(s)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       '¿Qué es eso?',
       '["Xi nga ca?"]',
       '["Tu?", "Paraa nuu yoo?", "Tu laabe?", "Xi nga ca?"]',
       'citlali',
       'Xi nga ca?: xi (qué) + nga (es) + ca (eso)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Jma ______',
       '["nisa", "Jma nisa"]',
       null,
       'coltzin',
       'nisa = agua',
       20, 'medium',
       'Más agua'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Caadxi ______',
       '["gueta", "Caadxi gueta"]',
       null,
       'neza',
       'gueta = tortilla',
       20, 'medium',
       'Unas pocas tortillas'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 3 and u.unit_num = 6;

-- nivel 4 · unidad 1: hoy y mañana
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ahora',
       '["Yanna"]',
       '["Yanna", "Ti yoo", "Jma", "Biree gubidxa"]',
       'tonatiuh',
       'Yanna significa ahora',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hoy',
       '["Yannadxí"]',
       '["Nisaguie", "Bi", "Bi naga''nda", "Yannadxí"]',
       'xochitl',
       'Yannadxí: yanna (ahora) + dxí (día)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mañana',
       '["Guixi"]',
       '["Guixi", "Siado''", "Neza", "Xhoopa''"]',
       'citlali',
       'Guixi significa mañana',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Temprano',
       '["Siado''"]',
       '["Siado''", "Ma", "Guie''", "Ro"]',
       'coltzin',
       'Siado'' significa temprano',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Guixi ______',
       '["siado''", "Guixi siado''"]',
       null,
       'neza',
       'siado'' = temprano',
       20, 'medium',
       'Mañana temprano'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Yannadxí ne ______',
       '["guixi", "Yannadxí ne guixi"]',
       null,
       'tonatiuh',
       'guixi = mañana',
       20, 'medium',
       'Hoy y mañana'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 1;

-- nivel 4 · unidad 2: la naturaleza
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Sol',
       '["Gubidxa"]',
       '["Caadxi gueta", "Beeu", "Gubidxa", "Riguite ca ba''du''"]',
       'xochitl',
       'Gubidxa significa sol',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Luna',
       '["Beeu"]',
       '["Lidxi", "Ruuna", "Beeu", "Biree"]',
       'citlali',
       'Beeu significa luna',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Flor',
       '["Guie''"]',
       '["Ma", "Caadxi", "Nisaguie", "Guie''"]',
       'coltzin',
       'Guie'' significa flor',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Árbol',
       '["Yaga"]',
       '["Ma", "Ndaani'' yoo", "Yaga", "Ndaani''"]',
       'neza',
       'Yaga significa árbol',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Gubidxa ne ______',
       '["beeu", "Gubidxa ne beeu"]',
       null,
       'tonatiuh',
       'beeu = luna',
       20, 'medium',
       'El sol y la luna'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Guie'' ______',
       '["sicarú", "Guie'' sicarú"]',
       null,
       'xochitl',
       'sicarú = bonito',
       20, 'medium',
       'Flor bonita'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 2;

-- nivel 4 · unidad 3: lo que hago
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Come',
       '["Ro"]',
       '["Riguite ca ba''du''", "Guie''", "Ro", "Luguiá yaga"]',
       'citlali',
       'Ro significa come',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Juega',
       '["Riguite"]',
       '["Dani", "Le''", "Riguite", "Ruxidxi"]',
       'coltzin',
       'Riguite: ri- (de costumbre) + guite (jugar)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Llora',
       '["Ruuna"]',
       '["Ruuna", "Iza", "Jma", "Caadxi gueta"]',
       'neza',
       'Ruuna: ru- (de costumbre) + uuna (llorar)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ríe',
       '["Ruxidxi"]',
       '["Ma", "Naga''nda", "Iza", "Ruxidxi"]',
       'tonatiuh',
       'Ruxidxi: ru- (de costumbre) + xidxi (reír)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ro ______',
       '["gueta", "Ro gueta"]',
       null,
       'xochitl',
       'gueta = tortilla',
       20, 'medium',
       'Come tortilla'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Riguite ca ______',
       '["ba''du''", "Riguite ca ba''du''"]',
       null,
       'citlali',
       'ba''du'' = niño',
       20, 'medium',
       'Los niños juegan'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 3;

-- nivel 4 · unidad 4: lo que pasó
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ya',
       '["Ma"]',
       '["Chii", "Dani", "Ma", "Ma biaazi gueela''"]',
       'coltzin',
       'Ma significa ya',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Salió',
       '["Biree"]',
       '["Neza", "Yannadxí", "Biree", "Chonna beeu"]',
       'neza',
       'Biree: bi- (ya pasó) + ree (salir)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cayó',
       '["Biaazi"]',
       '["Siado''", "Guie'' sicarú", "Biaazi", "Nga"]',
       'tonatiuh',
       'Biaazi: bi- (ya pasó) + aazi (caer, llegar)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ya salió',
       '["Ma biree"]',
       '["Chonna beeu", "Guiigu''", "Ndaani'' yoo", "Ma biree"]',
       'xochitl',
       'Ma biree: ma (ya) + bi- (ya pasó) + ree (salir)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Biree ______',
       '["gubidxa", "Biree gubidxa"]',
       null,
       'citlali',
       'gubidxa = sol',
       20, 'medium',
       'Salió el sol'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ma biaazi ______',
       '["gueela''", "Ma biaazi gueela''"]',
       null,
       'coltzin',
       'gueela'' = noche',
       20, 'medium',
       'Ya anocheció'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 4;

-- nivel 4 · unidad 5: días, meses y años
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Año',
       '["Iza"]',
       '["Iza", "Gande", "Naga''nda", "Gadxe"]',
       'neza',
       'Iza significa año',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Un año',
       '["Ti iza"]',
       '["Yaga", "Ma biree", "Ti iza", "Guie''"]',
       'tonatiuh',
       'Ti iza: ti (un, uno) + iza (año)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Veinte',
       '["Gande"]',
       '["Naga''nda", "Gande", "Xhono", "Ndaani''"]',
       'xochitl',
       'Gande significa veinte',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Dos días',
       '["Chupa dxi"]',
       '["Biree", "Chupa dxi", "Ti iza", "Naga''nda"]',
       'citlali',
       'Chupa dxi: chupa (dos) + dxi (día)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Chupa ______',
       '["dxi", "Chupa dxi"]',
       null,
       'coltzin',
       'dxi = día',
       20, 'medium',
       'Dos días'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Chonna ______',
       '["beeu", "Chonna beeu"]',
       null,
       'neza',
       'beeu = luna, mes',
       20, 'medium',
       'Tres meses'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 5;

-- nivel 4 · unidad 6: el clima
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Viento',
       '["Bi"]',
       '["Guiigu''", "Gande", "Yaga", "Bi"]',
       'tonatiuh',
       'Bi significa viento',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Frío',
       '["Naga''nda"]',
       '["Chii ne tobi", "Chii ne chupa", "Gande", "Naga''nda"]',
       'xochitl',
       'Naga''nda: na- (así es (estado)) + ga''nda (frío)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lluvia',
       '["Nisaguie"]',
       '["Biaazi", "Ruxidxi", "Nisaguie", "Neza"]',
       'citlali',
       'Nisaguie: nisa (agua) + guie ((de arriba))',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Aire frío',
       '["Bi naga''nda"]',
       '["Bi naga''nda", "Ga''", "Yoo", "Ruxidxi"]',
       'coltzin',
       'Bi naga''nda: bi (aire) + naga''nda (frío)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Bi ______',
       '["naga''nda", "Bi naga''nda"]',
       null,
       'neza',
       'naga''nda = frío',
       20, 'medium',
       'Aire frío'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Zá ne ______',
       '["nisaguie", "Zá ne nisaguie"]',
       null,
       'tonatiuh',
       'nisaguie = lluvia',
       20, 'medium',
       'Nube y lluvia'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 4 and u.unit_num = 6;

-- nivel 5 · unidad 1: la comida
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tortilla',
       '["Gueta"]',
       '["Yanna", "Gueta", "Suudi", "Gubidxa"]',
       'xochitl',
       'Gueta significa tortilla',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Maíz (grano)',
       '["Xuba''"]',
       '["Zá ne nisaguie", "Xuba''", "Niza", "Yannadxí ne guixi"]',
       'citlali',
       'Xuba'' significa maíz (grano)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Sal',
       '["Zidi"]',
       '["Ndaani'' ñaa", "Guie''", "Yannadxí", "Zidi"]',
       'coltzin',
       'Zidi significa sal',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mazorca',
       '["Niza"]',
       '["Niza", "Bidaani", "Gande", "Chonna beeu"]',
       'neza',
       'Niza significa mazorca',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Gueta ne ______',
       '["zidi", "Gueta ne zidi"]',
       null,
       'tonatiuh',
       'zidi = sal',
       20, 'medium',
       'Tortilla con sal'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ti ______',
       '["niza", "Ti niza"]',
       null,
       'xochitl',
       'niza = mazorca',
       20, 'medium',
       'Una mazorca'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 1;

-- nivel 5 · unidad 2: frutas y plantas
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Ciruela',
       '["Biadxi"]',
       '["Cuba", "Xho'' guie''", "Guie'' sicarú", "Biadxi"]',
       'citlali',
       'Biadxi significa ciruela',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Higo',
       '["Du''ga''"]',
       '["Guixi siado''", "Du''ga''", "Riguite", "Biree gubidxa"]',
       'coltzin',
       'Du''ga'' significa higo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Calabaza',
       '["Guitu"]',
       '["Chonna beeu", "Gui", "Chupa dxi", "Guitu"]',
       'neza',
       'Guitu significa calabaza',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tabaco',
       '["Gueza"]',
       '["Gueza", "Guitu", "Yaga biadxi", "Beeu"]',
       'tonatiuh',
       'Gueza significa tabaco',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Yaga ______',
       '["biadxi", "Yaga biadxi"]',
       null,
       'xochitl',
       'biadxi = ciruela',
       20, 'medium',
       'Árbol de ciruela'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Chupa ______',
       '["biadxi", "Chupa biadxi"]',
       null,
       'citlali',
       'biadxi = ciruela',
       20, 'medium',
       'Dos ciruelas'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 2;

-- nivel 5 · unidad 3: en la casa
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Hamaca',
       '["Guixhe"]',
       '["Ma biree", "Ti niza", "Ti guixhe", "Guixhe"]',
       'coltzin',
       'Guixhe significa hamaca',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Petate',
       '["Daa"]',
       '["Nanixe", "Daa", "Ruba", "Bidaani"]',
       'neza',
       'Daa significa petate',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mecate',
       '["Doo"]',
       '["Nanixe", "Zidi", "Du''ga''", "Doo"]',
       'tonatiuh',
       'Doo significa mecate',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Canasta',
       '["Dxumi"]',
       '["Dxumi", "Yanna", "Zá ne nisaguie", "Du''ga''"]',
       'xochitl',
       'Dxumi significa canasta',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ti ______',
       '["guixhe", "Ti guixhe"]',
       null,
       'citlali',
       'guixhe = hamaca',
       20, 'medium',
       'Una hamaca'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Daa ne ______',
       '["guixhe", "Daa ne guixhe"]',
       null,
       'coltzin',
       'guixhe = hamaca',
       20, 'medium',
       'Petate y hamaca'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 3;

-- nivel 5 · unidad 4: la ropa
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Huipil',
       '["Bidaani"]',
       '["Iza", "Bidaani", "Gui", "Nahui"]',
       'neza',
       'Bidaani significa huipil',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Su enagua',
       '["Suudi"]',
       '["Biadxi", "Suudi", "Gueta", "Riguite"]',
       'tonatiuh',
       'Suudi significa su enagua',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Lleva puesta (falda)',
       '["Nahui"]',
       '["Nahui", "Lanna''", "Biree", "Ñaa"]',
       'xochitl',
       'Nahui significa lleva puesta (falda)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Huipil bonito',
       '["Bidaani sicarú"]',
       '["Yannadxí ne guixi", "Bidaani sicarú", "Guixi", "Zee"]',
       'citlali',
       'Bidaani sicarú: bidaani (huipil) + sicarú (bonito)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Bidaani ______',
       '["sicarú", "Bidaani sicarú"]',
       null,
       'coltzin',
       'sicarú = bonito',
       20, 'medium',
       'Huipil bonito'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Bidaani ______',
       '["naxiñá", "Bidaani naxiñá"]',
       null,
       'neza',
       'naxiñá = rojo',
       20, 'medium',
       'Huipil rojo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 4;

-- nivel 5 · unidad 5: la milpa
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Milpa',
       '["Ñaa"]',
       '["Ñaa", "Iza", "Zidi", "Biree"]',
       'tonatiuh',
       'Ñaa significa milpa',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Milpa tierna',
       '["Guela"]',
       '["Ma biaazi gueela''", "Guie'' sicarú", "Guela", "Guixi siado''"]',
       'xochitl',
       'Guela significa milpa tierna',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Grano',
       '["Bexa"]',
       '["Ndaani'' ñaa", "Gueta ne zidi", "Daa ne guixhe", "Bexa"]',
       'citlali',
       'Bexa significa grano',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Espina',
       '["Guichi"]',
       '["Chonna beeu", "Guichi", "Cuba", "Ro gueta"]',
       'coltzin',
       'Guichi significa espina',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ndaani'' ______',
       '["ñaa", "Ndaani'' ñaa"]',
       null,
       'neza',
       'ñaa = milpa',
       20, 'medium',
       'Dentro de la milpa'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ñaa ______',
       '["naroba''", "Ñaa naroba''"]',
       null,
       'tonatiuh',
       'naroba'' = grande',
       20, 'medium',
       'Milpa grande'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 5;

-- nivel 5 · unidad 6: sabores y olores
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Sabroso',
       '["Nanixe"]',
       '["Ma", "Zidi", "Nanixe", "Lanna''"]',
       'xochitl',
       'Nanixe: na- (así es (estado)) + nixe (sabroso)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Olor',
       '["Xho''"]',
       '["Chupa biadxi", "Lanna''", "Xho''", "Nisaguie"]',
       'citlali',
       'Xho'' significa olor',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Olor a metal o a pescado',
       '["Lanna''"]',
       '["Lanna''", "Gubidxa ne beeu", "Ma", "Ti guixhe"]',
       'coltzin',
       'Lanna'' significa olor a metal o a pescado',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Tortilla sabrosa',
       '["Gueta nanixe"]',
       '["Daa", "Lanna''", "Guitu", "Gueta nanixe"]',
       'neza',
       'Gueta nanixe: gueta (tortilla) + nanixe (sabroso)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Gueta ______',
       '["nanixe", "Gueta nanixe"]',
       null,
       'tonatiuh',
       'nanixe = sabroso',
       20, 'medium',
       'Tortilla sabrosa'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Xho'' ______',
       '["guie''", "Xho'' guie''"]',
       null,
       'xochitl',
       'guie'' = flor',
       20, 'medium',
       'Olor a flor'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 5 and u.unit_num = 6;

-- nivel 6 · unidad 1: animales del monte
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Conejo',
       '["Lexu"]',
       '["Lexu", "Yaga biadxi", "Bidaani", "Nadxiie'' lii"]',
       'citlali',
       'Lexu significa conejo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Mapache',
       '["Ga''na''"]',
       '["Bizu", "Chupa ñee", "Ga''na''", "Cuba"]',
       'coltzin',
       'Ga''na'' significa mapache',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Zorrillo',
       '["Be''te''"]',
       '["Be''te''", "Ti guixhe", "Nanixe", "Guichi"]',
       'neza',
       'Be''te'' significa zorrillo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Culebra',
       '["Beenda''"]',
       '["Diaga", "Ladi binni", "Beenda''", "Guendanabani"]',
       'tonatiuh',
       'Beenda'' significa culebra',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Mistu ______',
       '["gui''xhi''", "Mistu gui''xhi''"]',
       null,
       'xochitl',
       'gui''xhi'' = monte',
       20, 'medium',
       'Gato montés'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 1;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Mani'' ______',
       '["gui''xhi''", "Mani'' gui''xhi''"]',
       null,
       'citlali',
       'gui''xhi'' = monte',
       20, 'medium',
       'Animal del monte'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 1;

-- nivel 6 · unidad 2: animales de la casa
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Perro',
       '["Bi''cu''"]',
       '["Beenda''", "Gueta nanixe", "Zidi", "Bi''cu''"]',
       'coltzin',
       'Bi''cu'' significa perro',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Gato',
       '["Mistu"]',
       '["Bere", "Gueza", "Mistu", "Batañee"]',
       'neza',
       'Mistu significa gato',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pollo',
       '["Bere"]',
       '["Mistu", "Bere", "Bizalú", "Xii"]',
       'tonatiuh',
       'Bere significa pollo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Animal',
       '["Mani''"]',
       '["Mani''", "Ladi binni", "Ti bere", "Xuba''"]',
       'xochitl',
       'Mani'' significa animal',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ca ______',
       '["bi''cu''", "Ca bi''cu''"]',
       null,
       'citlali',
       'bi''cu'' = perro',
       20, 'medium',
       'Los perros'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 2;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ti ______',
       '["bere", "Ti bere"]',
       null,
       'coltzin',
       'bere = pollo',
       20, 'medium',
       'Un pollo'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 2;

-- nivel 6 · unidad 3: la cabeza
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cabeza',
       '["Ique"]',
       '["Zee", "Ique", "Zidi", "Bidaani naxiñá"]',
       'neza',
       'Ique significa cabeza',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Oreja',
       '["Diaga"]',
       '["Xibi", "Guendanabani", "Ti bere", "Diaga"]',
       'tonatiuh',
       'Diaga significa oreja',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Nariz',
       '["Xii"]',
       '["Nadxiie'' lii", "Diidxa'' sicarú", "Guidxi sicarú", "Xii"]',
       'xochitl',
       'Xii significa nariz',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cara',
       '["Lu"]',
       '["Nadxiie'' lii", "Gueza", "Lu", "Guicha nayaase''"]',
       'citlali',
       'Lu significa cara',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Guicha ______',
       '["nayaase''", "Guicha nayaase''"]',
       null,
       'coltzin',
       'nayaase'' = negro',
       20, 'medium',
       'Cabello negro'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 3;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Chupa ______',
       '["diaga", "Chupa diaga"]',
       null,
       'neza',
       'diaga = oreja',
       20, 'medium',
       'Dos orejas'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 3;

-- nivel 6 · unidad 4: el cuerpo
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Cuerpo',
       '["Ladi"]',
       '["Suudi", "Ladi", "Ruba", "Ca bi''cu''"]',
       'tonatiuh',
       'Ladi significa cuerpo',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pierna',
       '["Ñee"]',
       '["Diaga", "Pa ganda", "Ñee", "Xuba''"]',
       'xochitl',
       'Ñee significa pierna',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pie',
       '["Batañee"]',
       '["Batañee", "Bere", "Xho'' guie''", "Ique"]',
       'citlali',
       'Batañee significa pie',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Rodilla',
       '["Xibi"]',
       '["Ga''na''", "Batañee", "Bidaani", "Xibi"]',
       'coltzin',
       'Xibi significa rodilla',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Ladi ______',
       '["binni", "Ladi binni"]',
       null,
       'neza',
       'binni = persona',
       20, 'medium',
       'Cuerpo de una persona'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 4;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Chupa ______',
       '["ñee", "Chupa ñee"]',
       null,
       'tonatiuh',
       'ñee = pierna',
       20, 'medium',
       'Dos piernas'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 4;

-- nivel 6 · unidad 5: palabras con guenda
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Vida',
       '["Guendanabani"]',
       '["Niza", "Ladi binni", "Chupa biadxi", "Guendanabani"]',
       'xochitl',
       'Guendanabani: guenda- ((forma sustantivos)) + nabani (vivo)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Comida',
       '["Guendaró"]',
       '["Xibi", "Guendanabani ne guenda guti", "Ñee", "Guendaró"]',
       'citlali',
       'Guendaró: guenda- ((forma sustantivos)) + ró (comer)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Muerte',
       '["Guenda guti"]',
       '["Diaga", "Xho'' guie''", "Guenda guti", "Ladi binni"]',
       'coltzin',
       'Guenda guti: guenda ((forma sustantivos)) + guti (morir)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'La vida y la muerte',
       '["Guendanabani ne guenda guti"]',
       '["Guendanabani ne guenda guti", "Mani'' gui''xhi''", "Nahui", "Bidaani sicarú"]',
       'neza',
       'Guendanabani ne guenda guti: guendanabani (vida) + ne (y) + guenda guti (muerte)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Guendanabani ne guenda ______',
       '["guti", "Guendanabani ne guenda guti"]',
       null,
       'tonatiuh',
       'Guendanabani ne guenda guti: guendanabani (vida) + ne (y) + guenda guti (muerte)',
       20, 'medium',
       'La vida y la muerte'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 5;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Diidxa'' ______',
       '["sicarú", "Diidxa'' sicarú"]',
       null,
       'xochitl',
       'sicarú = bonito',
       20, 'medium',
       'Palabra bonita'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 5;

-- nivel 6 · unidad 6: conversación final
insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Te quiero',
       '["Nadxiie'' lii"]',
       '["Bi''cu''", "Bizu", "Guendaró", "Nadxiie'' lii"]',
       'citlali',
       'Nadxiie'' lii: nadxii (querer) + -e'' (yo) + lii (a ti)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Si se puede',
       '["Pa ganda"]',
       '["Chupa biadxi", "Migu", "Pa ganda", "Guicha"]',
       'coltzin',
       'Pa ganda: pa (si) + ganda (poder)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'El final',
       '["Hra bidubi"]',
       '["Diaga", "Hra bidubi", "Chupa ñee", "Ñaa"]',
       'neza',
       'Hra bidubi: hra (cuando) + bi- (ya pasó) + dubi (terminar)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'multiple-choice', 'Selecciona la traducción correcta',
       'Pueblo bonito',
       '["Guidxi sicarú"]',
       '["Xuba''", "Guidxi sicarú", "Ñee", "Ique"]',
       'tonatiuh',
       'Guidxi sicarú: guidxi (pueblo) + sicarú (bonito)',
       15, 'medium', null
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Guidxi ______',
       '["sicarú", "Guidxi sicarú"]',
       null,
       'xochitl',
       'sicarú = bonito',
       20, 'medium',
       'Pueblo bonito'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 6;

insert into ct_exercises (unit_id, exercise_type, question, answer, correct_ans, options, character_ref, explanation, points, difficulty, placeholder)
select u.id, 'fill-blank', 'Completa la frase:',
       'Da''bacaanda ______',
       '["lu''", "Da''bacaanda lu''"]',
       null,
       'citlali',
       'lu'' = tú',
       20, 'medium',
       'Tienes sueño'
from ct_units u join ct_levels l on u.level_id = l.id join ct_languages la on l.language_id = la.id
where la.code = 'zai' and l.level_num = 6 and u.unit_num = 6;

-- ─────────────────────────────────────────────
--  7. sistema de escritura
-- ─────────────────────────────────────────────
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
    where la.code = 'zai' and l.level_num = 1 and u.unit_num = 1
) u
where usr.username = 'tetecuhtli';

-- ─────────────────────────────────────────────
--  9. ta_user_stats — registro inicial para el usuario demo
-- ─────────────────────────────────────────────
insert into ta_user_stats (user_id, language_id, words_learned, lessons_done, perfect_less, days_studied, best_streak, total_mins)
select usr.id, la.id, 0, 0, 0, 0, 0, 0
from ta_users usr
cross join ct_languages la
where usr.username = 'tetecuhtli' and la.code = 'zai';

commit;

-- ─────────────────────────────────────────────
--  verificación
--  esperado: ct_levels 6 · ct_units 36 · ct_vocabulary 219 · ct_exercises 216 · desglose 219 · status 1 (draft)
-- ─────────────────────────────────────────────
select 'ct_levels' as tabla, count(1) as registros from ct_levels where language_id = (select id from ct_languages where code = 'zai')
union all
select 'ct_units', count(1) from ct_units where level_id in (select id from ct_levels where language_id = (select id from ct_languages where code = 'zai'))
union all
select 'ct_vocabulary', count(1) from ct_vocabulary where language_id = (select id from ct_languages where code = 'zai')
union all
select 'ct_exercises', count(1) from ct_exercises where unit_id in (select u.id from ct_units u join ct_levels l on u.level_id = l.id where l.language_id = (select id from ct_languages where code = 'zai'))
union all
select 'desglose', count(1) from ct_vocabulary where language_id = (select id from ct_languages where code = 'zai') and breakdown is not null
union all
select 'status', case when status = 'draft' then 1 else 0 end from ct_languages where code = 'zai';
