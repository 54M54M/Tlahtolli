-- ============================================================
--  sistemas de escritura — nhn y hus
--  tlahtolcalli  [postgresql]
--
--  llena ct_writing_systems.characters (json con la estructura que conoce el backend:
--  type, letter, pronunciation, syllables, más example tomado del curso).
--  tipos que muestra el modo alfabeto de la app: vowel, consonant, ejective, longVowel.
--
--  nhn: ortografía moderna — 4 vocales, 11 consonantes, 4 dígrafos (ch, kw, tl, ts;
--       un solo sonido), j = saltillo y 4 vocales largas con macrón (ā ē ī ō).
--       system_type 'syllabary': la app muestra la tabla de sílabas (consonante + vocal),
--       ct_languages.writing_system sigue en 'alphabet'.
--  hus: norma inali — 5 vocales, 17 consonantes (incluye ' = saltillo),
--       7 glotalizadas y 5 vocales largas (á é í ó ú).
--
--  re-ejecutable. los seeds 4 (nhn) y 5 (hus) ya traen este mismo json.
-- ============================================================



begin;

-- nhn
update ct_writing_systems
   set system_type = 'syllabary',
       characters  = '[
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
]'
 where language_id = (select id from ct_languages where code = 'nhn');

-- hus
update ct_writing_systems
   set system_type = 'alphabet',
       characters  = '[
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
]'
 where language_id = (select id from ct_languages where code = 'hus');

commit;

-- verificación: entradas por tipo
select la.code, e->>'type' as tipo, count(1) as entradas
  from ct_writing_systems ws
  join ct_languages la on la.id = ws.language_id
 cross join jsonb_array_elements(ws.characters::jsonb) e
 where la.code in ('nhn', 'hus')
 group by la.code, e->>'type'
 order by la.code, tipo;
