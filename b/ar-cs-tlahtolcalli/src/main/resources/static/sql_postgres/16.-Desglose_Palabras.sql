-- ============================================================
--  16. desglose de palabras + unidad actual
--
--  1) ct_vocabulary.breakdown: desglose que sale en la pista al tocar una palabra subrayada
--     (pronunciación arriba y una fila por parte: "parte = significado", separadas por ";").
--     ejemplo: 'no- = mi; tōka = nombre'. si está vacío, la pista muestra solo la pronunciación.
--  2) ta_user_progress: al repasar una unidad, la siguiente volvía a quedar como "actual" aunque ya
--     estuviera completada (salía el ícono ▶▶ en una unidad terminada). se limpia aquí; el back ya no lo hace.
--
--  los desgloses de abajo salen del propio contenido del curso (gramática de la unidad 3 y las
--  traducciones literales del vocabulario). re-ejecutable.
-- ============================================================

alter table ct_vocabulary add column if not exists breakdown varchar(1000);

update ta_user_progress
   set is_current = 0
 where completed = 1
   and is_current = 1;

-- náhuatl central (nhn) · nivel 1
update ct_vocabulary v
   set breakdown = x.breakdown
  from (values
        ('Kēn tinemi?',        'kēn = cómo; ti- = tú; nemi = vivir'),
        ('Kwalli ninemi',      'kwalli = bien; ni- = yo; nemi = vivir'),
        ('Īwān tewātl?',       'īwān = y; tewātl = tú'),
        ('Timoittaske mostla', 'timoittaske = nos vemos; mostla = mañana'),
        ('Kēn motōka?',        'kēn = cómo; mo- = tu; tōka = nombre'),
        ('Notōka',             'no- = mi; tōka = nombre'),
        ('Motōka',             'mo- = tu; tōka = nombre'),
        ('Ītōka',              'ī- = su (de él o ella); tōka = nombre'),
        ('Miak tlasojkāmati',  'miak = mucho; tlasojkāmati = gracias'),
        ('Ajmo tlen',          'ajmo = no; tlen = qué'),
        ('Niyōlpāki',          'ni- = yo; yōlpāki = estar contento(a)'),
        ('Tiyōlpāki',          'ti- = tú; yōlpāki = estar contento(a)'),
        ('Nisiawi',            'ni- = yo; siawi = estar cansado(a)'),
        ('Tisiawi',            'ti- = tú; siawi = estar cansado(a)')
       ) as x(word, breakdown),
       ct_languages l
 where l.id = v.language_id
   and l.code = 'nhn'
   and v.word = x.word;

-- revisar: select word, translation, pronunciation, breakdown from ct_vocabulary where breakdown is not null order by id;
