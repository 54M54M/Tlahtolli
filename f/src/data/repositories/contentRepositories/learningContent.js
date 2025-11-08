import { Level } from '../../models/Level.js';
import { Unit } from '../../models/Unit.js';
import { Exercise } from '../../models/Exercise.js';

// ================= PALETA DE COLORES CONSISTENTE =================
const COLOR_PALETTE = {
    GREEN: '#58CC02',
    BLUE: '#1CB0F6',
    ORANGE: '#FF9600',
    RED: '#FF4B4B',
    TEAL: '#26CCC0',
    PURPLE: '#9C27B0',
};

/// ================= /LEVELS/{ID} =================
export const LEVELS_DATA = {
    // NAHUATL CENTRAL
    nhce: [
        new Level({
            id: 1, language: "nhce", title: "Fundamentos Básicos",
            titleSpanish: "Fundamentos Básicos", titleNative: "Achto Tlamachtiliztli",
            description: "Introducción a los sonidos, saludos y vocabulario esencial",
            color: COLOR_PALETTE.GREEN, units: 6, completedUnits: 0, locked: false,
            unlockRequirement: "Ninguno - Nivel inicial", order: 1
        }),
        new Level({
            id: 2, language: "nhce", title: "Conversación Básica",
            titleSpanish: "Conversación Básica", titleNative: "Tlahtolpehualiztli",
            description: "Frases comunes y diferencias dialectales básicas",
            color: COLOR_PALETTE.BLUE, units: 6, completedUnits: 0, locked: true,
            unlockRequirement: "Completar 4 unidades del Nivel 1", order: 2
        }),
        new Level({
            id: 3, language: "nhce", title: "Gramática Esencial",
            titleSpanish: "Gramática Esencial", titleNative: "Tlahtolmelahuac",
            description: "Estructuras gramaticales fundamentales y verbos",
            color: COLOR_PALETTE.ORANGE, units: 6, completedUnits: 0, locked: true,
            unlockRequirement: "Completar Nivel 2", order: 3
        }),
        new Level({
            id: 4, language: "nhce", title: "Cultura y Tradiciones",
            titleSpanish: "Cultura y Tradiciones", titleNative: "Tlahtolcultura",
            description: "Lenguaje en contexto cultural y expresiones tradicionales",
            color: COLOR_PALETTE.PURPLE, units: 6, completedUnits: 0, locked: true,
            unlockRequirement: "Completar Nivel 3", order: 4
        }),
        new Level({
            id: 5, language: "nhce", title: "Náhuatl Avanzado",
            titleSpanish: "Náhuatl Avanzado", titleNative: "Huēhueh Tlahtōlli",
            description: "Lenguaje formal, filosofía y variaciones regionales",
            color: COLOR_PALETTE.RED, units: 6, completedUnits: 0, locked: true,
            unlockRequirement: "Completar Nivel 4", order: 5
        })
    ],

    // TEENEK OCCIDENTAL
    tkoc: [
        new Level({
            id: 1, language: "tkoc", title: "Fundamentos Teenek",
            titleSpanish: "Fundamentos Teenek", titleNative: "Báayal u baats'",
            description: "Sonidos básicos, saludos y vocabulario esencial teenek",
            color: COLOR_PALETTE.GREEN, units: 6, completedUnits: 0, locked: false,
            unlockRequirement: "Ninguno - Nivel inicial", order: 1
        }),
        new Level({
            id: 2, language: "tkoc", title: "Conversación Básica",
            titleSpanish: "Conversación Básica", titleNative: "T'aab'al u baats'",
            description: "Frases comunes y estructuras básicas teenek",
            color: COLOR_PALETTE.BLUE, units: 6, completedUnits: 0, locked: true,
            unlockRequirement: "Completar Nivel 1", order: 2
        }),
        new Level({
            id: 3, language: "tkoc", title: "Vida Cotidiana",
            titleSpanish: "Vida Cotidiana", titleNative: "U yajalil u ts'íibil",
            description: "Vocabulario para actividades diarias y familia",
            color: COLOR_PALETTE.ORANGE, units: 6, completedUnits: 0, locked: true,
            unlockRequirement: "Completar Nivel 2", order: 3
        }),
        new Level({
            id: 4, language: "tkoc", title: "Naturaleza y Cultura",
            titleSpanish: "Naturaleza y Cultura", titleNative: "U ch'íinil u yool",
            description: "Medio ambiente, tradiciones y expresiones culturales",
            color: COLOR_PALETTE.PURPLE, units: 6, completedUnits: 0, locked: true,
            unlockRequirement: "Completar Nivel 3", order: 4
        }),
        new Level({
            id: 5, language: "tkoc", title: "Teenek Avanzado",
            titleSpanish: "Teenek Avanzado", titleNative: "U noj u baats'",
            description: "Estructuras complejas y conversación fluida",
            color: COLOR_PALETTE.RED, units: 6, completedUnits: 0, locked: true,
            unlockRequirement: "Completar Nivel 4", order: 5
        })
    ]
};

// ================= /LEVELS/{ID}/UNITS/{ID} =================
export const UNITS_DATA = {
    // NAHUATL
    nhce: [
        // Lessons para Nivel 1 - Fundamentos Básicos
        new Unit({
            id: 1, levelId: 1, language: "nhce",
            title: "Saludos Básicos", color: COLOR_PALETTE.GREEN,
            completed: false, locked: false, current: true,
            objective: "Aprender a saludar en náhuatl en diferentes momentos del día",
            grammar: "En náhuatl, los saludos suelen comenzar con 'cualli' (bueno/a) seguido del momento del día.",
            vocabulary: [
                { word: "Cualli tonalli", translation: "Buenos días", pronunciation: "kwal-li to-nal-li", example: "Cualli tonalli - Buen día" },
                { word: "Cualli", translation: "Bueno", pronunciation: "kwal-li", example: "Cualli - Bueno" },
                { word: "Tlazocamati", translation: "Gracias", pronunciation: "tla-so-ka-ma-ti", example: "Tlazocamati - Gracias" },
                { word: "Cualli yohual", translation: "Buenas noches", pronunciation: "kwal-li yo-hual", example: "Cualli yohual - Buenas noches" },
                { word: "Nimitztlahtlauhtia", translation: "Por favor", pronunciation: "ni-mitz-tla-tlau-tia", example: "Nimitztlahtlauhtia - Por favor" }
            ]
        }),
        new Unit({
            id: 2, levelId: 1, language: "nhce",
            title: "Presentaciones", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Aprender a presentarte y decir tu nombre en náhuatl",
            grammar: "Para presentarte, usa 'Notoca' seguido de tu nombre. Para preguntar el nombre de alguien, usa 'Tlen motoca?'",
            vocabulary: [
                { word: "Notoca", translation: "Mi nombre es", pronunciation: "no-to-ka", example: "Notoca Juan - Mi nombre es Juan" },
                { word: "Nitlacatl", translation: "Yo soy una persona", pronunciation: "ni-tla-catl", example: "Nitlacatl - Yo soy una persona" },
                { word: "Tinechpactia", translation: "Me gustas", pronunciation: "ti-nech-pac-tia", example: "Tinechpactia - Me gustas" },
            ]
        }),
        new Unit({
            id: 3, levelId: 1, language: "nhce",
            title: "Preguntas Básicas", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Aprender a hacer preguntas básicas en náhuatl",
            grammar: "Las palabras interrogativas en náhuatl suelen ir al principio de la pregunta, similar al español.",
            vocabulary: [
                { word: "Quenin timoyolcuitia", translation: "¿Cómo estás?", pronunciation: "que-nin ti-mo-yol-cui-tia", example: "Quenin timoyolcuitia? - ¿Cómo estás?" },
                { word: "Tlen", translation: "Qué", pronunciation: "tlen", example: "Tlen tictlazotla? - ¿Qué te gusta?" },
                { word: "Acan", translation: "Dónde", pronunciation: "a-kan", example: "Acan tica? - ¿Dónde estás?" },
                { word: "Queh", translation: "Quién", pronunciation: "keh", example: "Queh notoca? - ¿Quién soy?" },
                { word: "Ahmelli", translation: "De nada", pronunciation: "ah-mel-li", example: "Ahmelli - De nada" }
            ]
        }),
        new Unit({
            id: 4, levelId: 1, language: "nhce",
            title: "Pronombres Personales", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Aprender los pronombres personales en náhuatl",
            grammar: "Los pronombres personales en náhuatl tienen formas independientes y también prefijos que se usan con verbos.",
            vocabulary: [
                { word: "Nehuatl", translation: "Yo", pronunciation: "ne-uatl", example: "Nehuatl nicchihua - Yo hago" },
                { word: "Tehhuatl", translation: "Tú", pronunciation: "te-uatl", example: "Tehhuatl tichihua - Tú haces" },
                { word: "Yehuatl", translation: "Él/Ella", pronunciation: "ye-uatl", example: "Yehuatl quichihua - Él/Ella hace" }
            ]
        }),
        new Unit({
            id: 5, levelId: 1, language: "nhce",
            title: "Verbos Básicos", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Aprender verbos básicos en náhuatl y su conjugación en presente",
            grammar: "Los verbos en náhuatl se conjugan añadiendo prefijos que indican quién realiza la acción: ni- (yo), ti- (tú), etc.",
            vocabulary: [
                { word: "Tlacua", translation: "Comer", pronunciation: "tla-kua", example: "Nitlacua - Yo como" },
                { word: "Cochi", translation: "Dormir", pronunciation: "ko-chi", example: "Ticochi - Tú duermes" },
                { word: "Nemi", translation: "Vivir/Caminar", pronunciation: "ne-mi", example: "Ninemi - Yo camino" }
            ]
        }),
        new Unit({
            id: 6, levelId: 1, language: "nhce",
            title: "Familia", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Aprender vocabulario relacionado con la familia en náhuatl",
            grammar: "Para indicar posesión, se usan prefijos: no- (mi), mo- (tu), i- (su), etc. Por ejemplo: 'notah' (mi padre).",
            vocabulary: [
                { word: "Tahtli", translation: "Padre", pronunciation: "ta-tli", example: "Notahtli - Mi padre" },
                { word: "Nantli", translation: "Madre", pronunciation: "nan-tli", example: "Nonantli - Mi madre" },
                { word: "Icniutl", translation: "Hermano/a", pronunciation: "ik-ni-utl", example: "Noicniuh - Mi hermano/a" }
            ]
        }),

        // Unidades para Nivel 2 - Conversación Básica
        new Unit({
            id: 7, levelId: 2, language: "nhce",
            title: "Preguntas Simples", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Aprender a formular y responder preguntas básicas en conversación",
            grammar: "Las preguntas simples en náhuatl siguen la estructura: palabra interrogativa + verbo + complemento.",
            vocabulary: [
                { word: "Tlen", translation: "Qué", pronunciation: "tlen", example: "Tlen tictemoa? - ¿Qué buscas?" },
                { word: "Acan", translation: "Dónde", pronunciation: "a-kan", example: "Acan tica? - ¿Dónde estás?" },
                { word: "Queh", translation: "Quién", pronunciation: "keh", example: "Queh motoca? - ¿Quién eres?" }
            ]
        }),
        new Unit({
            id: 8, levelId: 2, language: "nhce",
            title: "Expresiones Cotidianas", color: COLOR_PALETTE.GREEN,
            completed: false, locked: true, current: false,
            objective: "Aprender expresiones comunes para situaciones diarias",
            grammar: "Las expresiones cotidianas suelen usar verbos en presente y pronombres posesivos.",
            vocabulary: [
                { word: "Nimitztlapaloa", translation: "Te ayudo", pronunciation: "ni-mitz-tla-pa-loa", example: "Nimitztlapaloa - Te ayudo" },
                { word: "Tinechpactia", translation: "Me gustas", pronunciation: "ti-nech-pac-tia", example: "Tinechpactia - Me gustas" },
                { word: "Nimitztlatlauhtia", translation: "Te ruego", pronunciation: "ni-mitz-tla-tlau-tia", example: "Nimitztlatlauhtia - Te ruego" }
            ]
        }),
        new Unit({
            id: 9, levelId: 2, language: "nhce",
            title: "Tiempo y Fechas", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Aprender a hablar sobre el tiempo y las fechas en náhuatl",
            grammar: "El tiempo en náhuatl se expresa con palabras específicas para días, meses y estaciones.",
            vocabulary: [
                { word: "Tonalli", translation: "Día/Sol", pronunciation: "to-nal-li", example: "Cualli tonalli - Buen día" },
                { word: "Metztli", translation: "Luna/Mes", pronunciation: "metz-tli", example: "Ce metztli - Un mes" },
                { word: "Xihuitl", translation: "Año", pronunciation: "xi-huitl", example: "Ce xihuitl - Un año" }
            ]
        }),
        new Unit({
            id: 10, levelId: 2, language: "nhce",
            title: "Comida y Bebida", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Vocabulario relacionado con alimentos y bebidas",
            grammar: "Los nombres de alimentos suelen llevar el prefijo 'tla-' que indica algo inanimado.",
            vocabulary: [
                { word: "Tlaxcalli", translation: "Tortilla", pronunciation: "tla-xcal-li", example: "Tlaxcalli - Tortilla" },
                { word: "Atolli", translation: "Atole", pronunciation: "a-tol-li", example: "Atolli - Atole" },
                { word: "Chilli", translation: "Chile", pronunciation: "chil-li", example: "Chilli - Chile" }
            ]
        }),
        new Unit({
            id: 11, levelId: 2, language: "nhce",
            title: "Direcciones y Lugares", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Aprender a dar y seguir direcciones en náhuatl",
            grammar: "Las direcciones usan palabras como 'pan' (sobre/en) y 'icpac' (encima) para indicar posición.",
            vocabulary: [
                { word: "Nepantla", translation: "En medio", pronunciation: "ne-pan-tla", example: "Nepantla - En medio" },
                { word: "Icpac", translation: "Encima", pronunciation: "ik-pak", example: "Icpac - Encima" },
                { word: "Tlalpan", translation: "En la tierra", pronunciation: "tla-lpan", example: "Tlalpan - En la tierra" }
            ]
        }),
        new Unit({
            id: 12, levelId: 2, language: "nhce",
            title: "Emociones y Sentimientos", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Expresar emociones y sentimientos básicos",
            grammar: "Las emociones se expresan con verbos que incluyen '-yotl' (naturaleza/esencia) para estados.",
            vocabulary: [
                { word: "Pactia", translation: "Estar contento", pronunciation: "pac-tia", example: "Nipactia - Estoy contento" },
                { word: "Choka", translation: "Llorar", pronunciation: "cho-ka", example: "Tichoka - Tú lloras" },
                { word: "Tlahueliloc", translation: "Enojado", pronunciation: "tla-we-li-lok", example: "Nitlahueliloc - Estoy enojado" }
            ]
        }),

        // Unidades para Nivel 3 - Gramática Esencial
        new Unit({
            id: 13, levelId: 3, language: "nhce",
            title: "Verbos Presentes", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Aprender la conjugación de verbos en tiempo presente",
            grammar: "Los verbos en presente usan prefijos: ni- (yo), ti- (tú), qui- (él/ella), ti- (nosotros), an- (ustedes), qui- (ellos).",
            vocabulary: [
                { word: "Chihua", translation: "Hacer", pronunciation: "chi-hua", example: "Nichihua - Yo hago" },
                { word: "Tlahtoa", translation: "Hablar", pronunciation: "tla-toa", example: "Titlahtoa - Tú hablas" },
                { word: "Temoa", translation: "Buscar", pronunciation: "te-moa", example: "Quitemoa - Él/Ella busca" }
            ]
        }),
        new Unit({
            id: 14, levelId: 3, language: "nhce",
            title: "Verbos Pasados", color: COLOR_PALETTE.GREEN,
            completed: false, locked: true, current: false,
            objective: "Conjugación de verbos en tiempo pasado",
            grammar: "El pasado se forma con el sufijo '-c' o '-que' dependiendo del verbo y la persona.",
            vocabulary: [
                { word: "Chihua", translation: "Hacer", pronunciation: "chi-hua", example: "Nichihuac - Yo hice" },
                { word: "Tlahtoa", translation: "Hablar", pronunciation: "tla-toa", example: "Titlahtoac - Tú hablaste" },
                { word: "Temoa", translation: "Buscar", pronunciation: "te-moa", example: "Quitemoac - Él/Ella buscó" }
            ]
        }),
        new Unit({
            id: 15, levelId: 3, language: "nhce",
            title: "Verbos Futuros", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Aprender a conjugar verbos en tiempo futuro",
            grammar: "El futuro se forma con el sufijo '-z' o '-s' dependiendo del verbo.",
            vocabulary: [
                { word: "Chihua", translation: "Hacer", pronunciation: "chi-hua", example: "Nichihuaz - Yo haré" },
                { word: "Tlahtoa", translation: "Hablar", pronunciation: "tla-toa", example: "Titlahtoaz - Tú hablarás" },
                { word: "Temoa", translation: "Buscar", pronunciation: "te-moa", example: "Quitemoaz - Él/Ella buscará" }
            ]
        }),
        new Unit({
            id: 16, levelId: 3, language: "nhce",
            title: "Sustantivos y Adjetivos", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Aprender el uso de sustantivos y adjetivos en náhuatl",
            grammar: "Los adjetivos suelen ir después del sustantivo y concuerdan en número.",
            vocabulary: [
                { word: "Cuahtli", translation: "Águila", pronunciation: "kua-tli", example: "Cuahtli - Águila" },
                { word: "Coatl", translation: "Serpiente", pronunciation: "ko-atl", example: "Coatl - Serpiente" },
                { word: "Hueyi", translation: "Grande", pronunciation: "we-yi", example: "Hueyi cuauhtli - Águila grande" }
            ]
        }),
        new Unit({
            id: 17, levelId: 3, language: "nhce",
            title: "Posesivos", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Aprender el uso de pronombres posesivos",
            grammar: "Los posesivos se forman con prefijos: no- (mi), mo- (tu), i- (su), to- (nuestro), etc.",
            vocabulary: [
                { word: "Nocal", translation: "Mi casa", pronunciation: "no-kal", example: "Nocal - Mi casa" },
                { word: "Mocal", translation: "Tu casa", pronunciation: "mo-kal", example: "Mocal - Tu casa" },
                { word: "Ical", translation: "Su casa", pronunciation: "i-kal", example: "Ical - Su casa" }
            ]
        }),
        new Unit({
            id: 18, levelId: 3, language: "nhce",
            title: "Preposiciones", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Aprender el uso de preposiciones en náhuatl",
            grammar: "Las preposiciones en náhuatl suelen ser posposiciones que van después del sustantivo.",
            vocabulary: [
                { word: "Ipan", translation: "Sobre/En", pronunciation: "i-pan", example: "Ipan petlatl - Sobre la estera" },
                { word: "Itic", translation: "Dentro", pronunciation: "i-tik", example: "Itic calli - Dentro de la casa" },
                { word: "Ihuan", translation: "Con", pronunciation: "i-wan", example: "Ihuan notah - Con mi padre" }
            ]
        }),

        // Unidades para Nivel 4 - Cultura y Tradiciones
        new Unit({
            id: 19, levelId: 4, language: "nhce",
            title: "Narraciones", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Aprender a contar historias y narraciones tradicionales",
            grammar: "Las narraciones en náhuatl suelen usar el tiempo pasado y conectores narrativos.",
            vocabulary: [
                { word: "Zan", translation: "Solo/Solamente", pronunciation: "zan", example: "Zan ce - Solo uno" },
                { word: "Huel", translation: "Muy/Mucho", pronunciation: "huel", example: "Huel cualli - Muy bueno" },
                { word: "Cenca", translation: "Mucho", pronunciation: "ken-ka", example: "Cenca cualli - Mucho bueno" }
            ]
        }),
        new Unit({
            id: 20, levelId: 4, language: "nhce",
            title: "Cosmovisión", color: COLOR_PALETTE.GREEN,
            completed: false, locked: true, current: false,
            objective: "Vocabulario relacionado con la cosmovisión náhuatl",
            grammar: "Los conceptos cosmológicos suelen usar el sufijo '-yotl' que indica esencia o naturaleza.",
            vocabulary: [
                { word: "Tonatiuh", translation: "Sol", pronunciation: "to-na-tiuh", example: "Tonatiuh - Sol" },
                { word: "Meztli", translation: "Luna", pronunciation: "mez-tli", example: "Meztli - Luna" },
                { word: "Citlalli", translation: "Estrella", pronunciation: "sit-lal-li", example: "Citlalli - Estrella" }
            ]
        }),
        new Unit({
            id: 21, levelId: 4, language: "nhce",
            title: "Tradiciones Orales", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Aprender expresiones de la tradición oral náhuatl",
            grammar: "Las tradiciones orales usan formas verbales específicas y recursos poéticos.",
            vocabulary: [
                { word: "Tlahtolli", translation: "Palabra", pronunciation: "tla-to-li", example: "Tlahtolli - Palabra" },
                { word: "Zazanilli", translation: "Cuento", pronunciation: "sa-sa-nil-li", example: "Zazanilli - Cuento" },
                { word: "Cuicatl", translation: "Canto", pronunciation: "kui-katl", example: "Cuicatl - Canto" }
            ]
        }),
        new Unit({
            id: 22, levelId: 4, language: "nhce",
            title: "Ceremonias", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Vocabulario relacionado con ceremonias tradicionales",
            grammar: "El lenguaje ceremonial usa formas reverenciales y términos específicos.",
            vocabulary: [
                { word: "Tlamaniliztli", translation: "Ofrenda", pronunciation: "tla-ma-ni-liz-tli", example: "Tlamaniliztli - Ofrenda" },
                { word: "Nextlahualiztli", translation: "Ayuno", pronunciation: "nex-tla-wa-li-liz-tli", example: "Nextlahualiztli - Ayuno" },
                { word: "Tlacahuapahualiztli", translation: "Bautizo", pronunciation: "tla-ka-wa-pa-wa-li-liz-tli", example: "Tlacahuapahualiztli - Bautizo" }
            ]
        }),
        new Unit({
            id: 23, levelId: 4, language: "nhce",
            title: "Arte y Artesanía", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Vocabulario relacionado con artes y artesanías tradicionales",
            grammar: "Los términos artísticos suelen usar el prefijo 'tla-' que indica actividad.",
            vocabulary: [
                { word: "Tlacuilolli", translation: "Pintura", pronunciation: "tla-kwi-lol-li", example: "Tlacuilolli - Pintura" },
                { word: "Amantecayotl", translation: "Arte plumaria", pronunciation: "a-man-te-ka-yotl", example: "Amantecayotl - Arte plumaria" },
                { word: "Toltecayotl", translation: "Arte tolteca", pronunciation: "tol-te-ka-yotl", example: "Toltecayotl - Arte tolteca" }
            ]
        }),
        new Unit({
            id: 24, levelId: 4, language: "nhce",
            title: "Medicina Tradicional", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Aprender vocabulario de medicina tradicional náhuatl",
            grammar: "Los términos médicos suelen incluir '-patli' (medicina) o '-ticitl' (médico).",
            vocabulary: [
                { word: "Ticiti", translation: "Médico", pronunciation: "ti-si-ti", example: "Ticiti - Médico" },
                { word: "Patli", translation: "Medicina", pronunciation: "pa-tli", example: "Patli - Medicina" },
                { word: "Tlazolpatli", translation: "Medicina purgante", pronunciation: "tla-sol-pa-tli", example: "Tlazolpatli - Medicina purgante" }
            ]
        }),

        // Unidades para Nivel 5 - Náhuatl Avanzado
        new Unit({
            id: 25, levelId: 5, language: "nhce",
            title: "Códices", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Estudio del lenguaje utilizado en los códices prehispánicos",
            grammar: "El lenguaje de los códices combina elementos pictográficos con glifos fonéticos.",
            vocabulary: [
                { word: "Amoxtli", translation: "Libro/Códice", pronunciation: "a-mox-tli", example: "Amoxtli - Libro" },
                { word: "Tlahcuilolli", translation: "Escritura", pronunciation: "tla-kwi-lol-li", example: "Tlahcuilolli - Escritura" },
                { word: "Tlapohualiztli", translation: "Cuenta/Calendario", pronunciation: "tla-po-wa-liz-tli", example: "Tlapohualiztli - Calendario" }
            ]
        }),
        new Unit({
            id: 26, levelId: 5, language: "nhce",
            title: "Poesía Náhuatl", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Estudio del lenguaje poético y metafórico náhuatl",
            grammar: "La poesía náhuatl usa metáforas complejas y paralelismos sintácticos.",
            vocabulary: [
                { word: "Xochitl", translation: "Flor", pronunciation: "sho-chitl", example: "Xochitl - Flor" },
                { word: "Cuicatl", translation: "Canto", pronunciation: "kui-katl", example: "Cuicatl - Canto" },
                { word: "In xochitl in cuicatl", translation: "Flor y canto", pronunciation: "in sho-chitl in kui-katl", example: "In xochitl in cuicatl - Flor y canto" }
            ]
        }),
        new Unit({
            id: 27, levelId: 5, language: "nhce",
            title: "Filosofía Náhuatl", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Estudio de conceptos filosóficos en náhuatl",
            grammar: "La filosofía náhuatl usa términos abstractos con el sufijo '-yotl'.",
            vocabulary: [
                { word: "Neltiliztli", translation: "Verdad", pronunciation: "nel-ti-liz-tli", example: "Neltiliztli - Verdad" },
                { word: "Tlamatiliztli", translation: "Sabiduría", pronunciation: "tla-ma-ti-liz-tli", example: "Tlamatiliztli - Sabiduría" },
                { word: "Yoliztli", translation: "Vida", pronunciation: "yo-liz-tli", example: "Yoliztli - Vida" }
            ]
        }),
        new Unit({
            id: 28, levelId: 5, language: "nhce",
            title: "Lenguaje Formal", color: COLOR_PALETTE.GREEN,
            completed: false, locked: true, current: false,
            objective: "Aprender formas de lenguaje formal y reverencial",
            grammar: "El lenguaje formal usa sufijos reverenciales como '-tzin' y formas verbales especiales.",
            vocabulary: [
                { word: "Notlahcol", translation: "Mi señor", pronunciation: "no-tla-kol", example: "Notlahcol - Mi señor" },
                { word: "Motlahcol", translation: "Tu señor", pronunciation: "mo-tla-kol", example: "Motlahcol - Tu señor" },
                { word: "Itlahcol", translation: "Su señor", pronunciation: "i-tla-kol", example: "Itlahcol - Su señor" }
            ]
        }),
        new Unit({
            id: 29, levelId: 5, language: "nhce",
            title: "Variaciones Dialectales", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Estudio de variaciones dialectales del náhuatl",
            grammar: "Las variaciones dialectales afectan principalmente la fonología y el léxico.",
            vocabulary: [
                { word: "Masehualtlahtolli", translation: "Lengua de los masehuales", pronunciation: "ma-se-wal-tla-to-li", example: "Masehualtlahtolli - Lengua náhuatl" },
                { word: "Tlahtolmelahuac", translation: "Lengua pura", pronunciation: "tla-tol-me-la-wak", example: "Tlahtolmelahuac - Lengua pura" },
                { word: "Tlahtoltequitl", translation: "Uso de la lengua", pronunciation: "tla-tol-te-kitl", example: "Tlahtoltequitl - Uso de la lengua" }
            ]
        }),
        new Unit({
            id: 30, levelId: 5, language: "nhce",
            title: "Documentos Históricos", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Estudio del lenguaje en documentos históricos náhuatl",
            grammar: "Los documentos históricos usan formas arcaicas y préstamos del español.",
            vocabulary: [
                { word: "Huehuehtlahtolli", translation: "Palabra antigua", pronunciation: "we-we-tla-to-li", example: "Huehuehtlahtolli - Palabra antigua" },
                { word: "Tlahtolamatl", translation: "Documento", pronunciation: "tla-to-la-matl", example: "Tlahtolamatl - Documento" },
                { word: "Tlahtolcuilolamatl", translation: "Documento escrito", pronunciation: "tla-tol-kwi-lo-la-matl", example: "Tlahtolcuilolamatl - Documento escrito" }
            ]
        })
    ],

    // TEENEK
    tkoc: [
        // NIVEL 1 - Unidades
        new Unit({
            id: 1, levelId: 1, language: "tkoc",
            title: "Saludos en Teenek", color: COLOR_PALETTE.GREEN,
            completed: false, locked: false, current: true,
            objective: "Aprender saludos básicos en teenek",
            grammar: "Los saludos en teenek suelen usar 'Bix' para preguntar el estado y tienen formas específicas para diferentes momentos del día.",
            vocabulary: [
                { word: "Bix a beel", translation: "Buenos días", pronunciation: "bish a bel", example: "Bix a beel, ¿bix yaanam?" },
                { word: "Bix a k'iin", translation: "Buenas tardes", pronunciation: "bish a k'in", example: "Bix a k'iin, ¿bix a wàay?" },
                { word: "Waal a b'ixik", translation: "Gracias", pronunciation: "waal a bish-ik", example: "Waal a b'ixik ti'" },
                { word: "Maats'", translation: "Adiós", pronunciation: "ma-ts'", example: "Maats', jant'een" },
                { word: "Bix yaanam", translation: "¿Cómo estás?", pronunciation: "bish yaa-nam", example: "Bix yaanam, inam?" }
            ]
        }),
        new Unit({
            id: 2, levelId: 1, language: "tkoc",
            title: "Números Básicos", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Aprender números del 1 al 10 en teenek",
            grammar: "El sistema numérico teenek es vigesimal, pero los números básicos tienen formas específicas.",
            vocabulary: [
                { word: "T'uun", translation: "Uno", pronunciation: "t'un", example: "T'uun ts'akal" },
                { word: "Ts'íib", translation: "Dos", pronunciation: "ts'iib", example: "Ts'íib wakax" },
                { word: "Oxib", translation: "Tres", pronunciation: "o-shih", example: "Oxib ixim" },
                { word: "Tseeb", translation: "Cuatro", pronunciation: "tseb", example: "Tseeb ch'ich'" },
                { word: "Boob", translation: "Cinco", pronunciation: "bob", example: "Boob uits" }
            ]
        }),
        new Unit({
            id: 3, levelId: 1, language: "tkoc",
            title: "Familia y Personas", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Vocabulario de familia y relaciones personales",
            grammar: "Los términos de parentesco en teenek reflejan la estructura familiar tradicional.",
            vocabulary: [
                { word: "Inam", translation: "Madre", pronunciation: "i-nam", example: "Bix a beel, inam" },
                { word: "Itat", translation: "Padre", pronunciation: "i-tat", example: "Itat yaan ch'een" },
                { word: "Ats'its", translation: "Hermano/a", pronunciation: "a-ts'its", example: "Ats'its yaan ch'een" },
                { word: "U ch'úupal", translation: "Hijo", pronunciation: "u ch'u-pal", example: "U ch'úupal yaan" },
                { word: "U íits'in", translation: "Amigo", pronunciation: "u i-ts'in", example: "U íits'in yaan ch'een" }
            ]
        }),
        new Unit({
            id: 4, levelId: 1, language: "tkoc",
            title: "Partes del Cuerpo", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Aprender las partes del cuerpo en teenek",
            grammar: "Las partes del cuerpo en teenek suelen llevar prefijos posesivos según a quién pertenezcan.",
            vocabulary: [
                { word: "U yool", translation: "Cabeza", pronunciation: "u yol", example: "U yool yaan ch'een" },
                { word: "U kab'", translation: "Mano", pronunciation: "u kab", example: "U kab' yaan ch'een" },
                { word: "U wakax", translation: "Pie", pronunciation: "u wa-kash", example: "U wakax yaan ch'een" },
                { word: "U chi'", translation: "Boca", pronunciation: "u chi", example: "U chi' yaan ch'een" },
                { word: "U ich", translation: "Ojo", pronunciation: "u ich", example: "U ich yaan ch'een" }
            ]
        }),
        new Unit({
            id: 5, levelId: 1, language: "tkoc",
            title: "Animales y Naturaleza", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Vocabulario de animales y elementos naturales",
            grammar: "Los nombres de animales en teenek suelen ser descriptivos y reflejan características del animal.",
            vocabulary: [
                { word: "Ch'ich'", translation: "Pájaro", pronunciation: "ch'ich", example: "Tseeb ch'ich'" },
                { word: "Peem", translation: "Perro", pronunciation: "pem", example: "Oxib peem" },
                { word: "Misu", translation: "Gato", pronunciation: "mi-su", example: "Ts'íib misu" },
                { word: "Ha'", translation: "Agua", pronunciation: "ha", example: "Boob ha'" },
                { word: "Che'", translation: "Árbol", pronunciation: "che", example: "T'uun che'" }
            ]
        }),
        new Unit({
            id: 6, levelId: 1, language: "tkoc",
            title: "Colores y Formas", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Aprender colores básicos y formas en teenek",
            grammar: "Los colores en teenek suelen funcionar como adjetivos y se colocan después del sustantivo.",
            vocabulary: [
                { word: "Ch'ooj", translation: "Rojo", pronunciation: "ch'oj", example: "Ch'ich' ch'ooj" },
                { word: "Yaax", translation: "Verde", pronunciation: "yaash", example: "Che' yaax" },
                { word: "K'an", translation: "Amarillo", pronunciation: "k'an", example: "K'an ixim" },
                { word: "Taab", translation: "Negro", pronunciation: "tab", example: "Peem taab" },
                { word: "Saak", translation: "Blanco", pronunciation: "sak", example: "Misu saak" }
            ]
        }),

        // NIVEL 2 - Unidades
        new Unit({
            id: 7, levelId: 2, language: "tkoc",
            title: "Preguntas Comunes", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Aprender a formular preguntas básicas",
            grammar: "Las preguntas en teenek suelen comenzar con partículas interrogativas como 'Bix', 'Jant''.",
            vocabulary: [
                { word: "Jant' yaan a k'aba", translation: "¿Cómo te llamas?", pronunciation: "hant yaan a k'aba", example: "Jant' yaan a k'aba?" },
                { word: "Jant' teen yaan", translation: "¿Dónde estás?", pronunciation: "hant teen yaan", example: "Jant' teen yaanam?" },
                { word: "Jant' u ts'akal", translation: "¿Cuánto cuesta?", pronunciation: "hant u ts'akal", example: "Jant' u ts'akal u ch'ich'?" },
                { word: "Bix a wàay", translation: "¿Cómo amaneciste?", pronunciation: "bish a waay", example: "Bix a wàay, itat?" },
                { word: "Jant' u k'iin", translation: "¿Qué hora es?", pronunciation: "hant u k'in", example: "Jant' u k'iin?" }
            ]
        }),
        new Unit({
            id: 8, levelId: 2, language: "tkoc",
            title: "Expresiones Cotidianas", color: COLOR_PALETTE.GREEN,
            completed: false, locked: true, current: false,
            objective: "Aprender expresiones para situaciones diarias",
            grammar: "Las expresiones cotidianas usan verbos de estado y formas interrogativas comunes.",
            vocabulary: [
                { word: "Yaan in wotoch", translation: "Estoy en casa", pronunciation: "yaan in wo-toch", example: "Yaan in wotoch" },
                { word: "Ma' yaan in wotoch", translation: "No estoy en casa", pronunciation: "ma yaan in wo-toch", example: "Ma' yaan in wotoch" },
                { word: "K'uch in wotoch", translation: "Llegué a casa", pronunciation: "k'uch in wo-toch", example: "K'uch in wotoch" },
                { word: "Tin bin", translation: "Me voy", pronunciation: "tin bin", example: "Tin bin, maats'" },
                { word: "Yaan a wotoch", translation: "Estás en casa", pronunciation: "yaan a wo-toch", example: "Yaan a wotoch?" }
            ]
        }),
        new Unit({
            id: 9, levelId: 2, language: "tkoc",
            title: "Comida y Alimentos", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Vocabulario relacionado con alimentos y comidas",
            grammar: "Los nombres de alimentos suelen llevar clasificadores según el tipo de alimento.",
            vocabulary: [
                { word: "Ixim", translation: "Maíz", pronunciation: "i-shim", example: "Oxib ixim" },
                { word: "Uits", translation: "Calabaza", pronunciation: "uits", example: "Boob uits" },
                { word: "Ch'uhuk", translation: "Fríjol", pronunciation: "ch'u-huk", example: "Ts'íib ch'uhuk" },
                { word: "Iich", translation: "Chile", pronunciation: "iich", example: "T'uun iich" },
                { word: "Ha'", translation: "Agua", pronunciation: "ha", example: "T'uun ha'" }
            ]
        }),
        new Unit({
            id: 10, levelId: 2, language: "tkoc",
            title: "Actividades Diarias", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Aprender verbos para actividades cotidianas",
            grammar: "Los verbos en teenek se conjugan con prefijos de persona y sufijos de tiempo.",
            vocabulary: [
                { word: "Meyah", translation: "Trabajar", pronunciation: "me-yah", example: "Tin meyah" },
                { word: "A'almaj", translation: "Comer", pronunciation: "a'al-mah", example: "Ta'almaj" },
                { word: "Wéenel", translation: "Dormir", pronunciation: "we-nel", example: "Tin wéenel" },
                { word: "Ch'ijch'", translation: "Caminar", pronunciation: "ch'ijch", example: "Tin ch'ijch'" },
                { word: "U'uy", translation: "Escuchar", pronunciation: "u'uy", example: "Ta'u'uy" }
            ]
        }),
        new Unit({
            id: 11, levelId: 2, language: "tkoc",
            title: "Lugares y Direcciones", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Vocabulario para ubicaciones y direcciones",
            grammar: "Las direcciones usan partículas locativas como 'teen' (en) y 'ti'' (a/hacia).",
            vocabulary: [
                { word: "Wotoch", translation: "Casa", pronunciation: "wo-toch", example: "Yaan in wotoch" },
                { word: "Nah", translation: "Casa (de alguien)", pronunciation: "nah", example: "U nah itat" },
                { word: "K'aax", translation: "Monte", pronunciation: "k'aash", example: "Teen k'aax" },
                { word: "Ch'e'en", translation: "Pueblo", pronunciation: "ch'e'en", example: "Teen ch'e'en" },
                { word: "Bej", translation: "Camino", pronunciation: "beh", example: "U bej" }
            ]
        }),
        new Unit({
            id: 12, levelId: 2, language: "tkoc",
            title: "Tiempo y Fechas", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Aprender a hablar sobre el tiempo y fechas",
            grammar: "El tiempo se expresa con palabras específicas para días, meses y períodos.",
            vocabulary: [
                { word: "K'iin", translation: "Día", pronunciation: "k'in", example: "Bix a k'iin" },
                { word: "Ak'ab", translation: "Noche", pronunciation: "a-k'ab", example: "Bix a ak'ab" },
                { word: "U k'iin", translation: "Sol/Hora", pronunciation: "u k'in", example: "Jant' u k'iin?" },
                { word: "Ja'", translation: "Lluvia", pronunciation: "ha", example: "Yaan ja'" },
                { word: "Sijnal", translation: "Frío", pronunciation: "si-hnal", example: "Yaan sijnal" }
            ]
        }),

        // NIVEL 3 - Unidades
        new Unit({
            id: 13, levelId: 3, language: "tkoc",
            title: "Verbos de Acción", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Aprender verbos básicos y su conjugación",
            grammar: "Los verbos en teenek se conjugan según la persona y el tiempo, usando prefijos y sufijos específicos.",
            vocabulary: [
                { word: "K'ay", translation: "Cantar", pronunciation: "k'ay", example: "In k'ay" },
                { word: "Wil", translation: "Ver", pronunciation: "wil", example: "A wil" },
                { word: "U'uy", translation: "Oír", pronunciation: "u'uy", example: "Y u'uy" },
                { word: "Luk", translation: "Salir", pronunciation: "luk", example: "K luk" },
                { word: "Ok", translation: "Entrar", pronunciation: "ok", example: "T ok" }
            ]
        }),
        new Unit({
            id: 14, levelId: 3, language: "tkoc",
            title: "Verbos de Estado", color: COLOR_PALETTE.GREEN,
            completed: false, locked: true, current: false,
            objective: "Aprender verbos que expresan estados y condiciones",
            grammar: "Los verbos de estado usan la partícula 'yaan' para indicar existencia o posesión.",
            vocabulary: [
                { word: "Yaan", translation: "Hay/Estar", pronunciation: "yaan", example: "Yaan in wotoch" },
                { word: "K'uch", translation: "Llegar", pronunciation: "k'uch", example: "K'uch in wotoch" },
                { word: "Bin", translation: "Ir", pronunciation: "bin", example: "Tin bin" },
                { word: "Tal", translation: "Venir", pronunciation: "tal", example: "Tin tal" },
                { word: "Meyah", translation: "Trabajar", pronunciation: "me-yah", example: "Tin meyah" }
            ]
        }),
        new Unit({
            id: 15, levelId: 3, language: "tkoc",
            title: "Adjetivos y Descripciones", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Aprender adjetivos para describir personas y objetos",
            grammar: "Los adjetivos en teenek suelen ir después del sustantivo y concuerdan en número.",
            vocabulary: [
                { word: "Noj", translation: "Grande", pronunciation: "noh", example: "Wotoch noj" },
                { word: "Ch'ich'", translation: "Pequeño", pronunciation: "ch'ich", example: "Ch'ich' wotoch" },
                { word: "Ch'ooj", translation: "Rojo", pronunciation: "ch'oj", example: "Ixim ch'ooj" },
                { word: "Yaax", translation: "Verde", pronunciation: "yaash", example: "Che' yaax" },
                { word: "K'an", translation: "Amarillo", pronunciation: "k'an", example: "Uits k'an" }
            ]
        }),
        new Unit({
            id: 16, levelId: 3, language: "tkoc",
            title: "Pronombres Personales", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Aprender los pronombres personales en teenek",
            grammar: "Los pronombres personales tienen formas independientes y también se usan como prefijos verbales.",
            vocabulary: [
                { word: "In", translation: "Yo", pronunciation: "in", example: "In wil" },
                { word: "A", translation: "Tú", pronunciation: "a", example: "A wil" },
                { word: "U", translation: "Él/Ella", pronunciation: "u", example: "U wil" },
                { word: "K", translation: "Nosotros", pronunciation: "k", example: "K wil" },
                { word: "U ... e'ex", translation: "Ustedes", pronunciation: "u e'ex", example: "U wil e'ex" }
            ]
        }),
        new Unit({
            id: 17, levelId: 3, language: "tkoc",
            title: "Posesivos", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Aprender el uso de pronombres posesivos",
            grammar: "Los posesivos se forman con prefijos: 'in-' (mi), 'a-' (tu), 'u-' (su), etc.",
            vocabulary: [
                { word: "In wotoch", translation: "Mi casa", pronunciation: "in wo-toch", example: "Yaan in wotoch" },
                { word: "A wotoch", translation: "Tu casa", pronunciation: "a wo-toch", example: "Yaan a wotoch" },
                { word: "U wotoch", translation: "Su casa", pronunciation: "u wo-toch", example: "Yaan u wotoch" },
                { word: "In wakax", translation: "Mi pie", pronunciation: "in wa-kash", example: "U wakax" },
                { word: "A kab'", translation: "Tu mano", pronunciation: "a kab", example: "U kab'" }
            ]
        }),
        new Unit({
            id: 18, levelId: 3, language: "tkoc",
            title: "Preposiciones y Locativos", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Aprender el uso de preposiciones y partículas locativas",
            grammar: "Las preposiciones en teenek son partículas que indican ubicación y dirección.",
            vocabulary: [
                { word: "Teen", translation: "En", pronunciation: "teen", example: "Teen wotoch" },
                { word: "Ti'", translation: "A/Hacia", pronunciation: "ti", example: "Ti' ch'e'en" },
                { word: "Ich", translation: "Con", pronunciation: "ich", example: "Ich u íits'in" },
                { word: "Yetel", translation: "Y/Con", pronunciation: "ye-tel", example: "Inam yetel itat" },
                { word: "Tu'ux", translation: "Donde", pronunciation: "tu'ux", example: "Tu'ux yaan a wotoch?" }
            ]
        }),

        // NIVEL 4 - Unidades
        new Unit({
            id: 19, levelId: 4, language: "tkoc",
            title: "Tiempo y Clima", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Vocabulario relacionado con el tiempo y condiciones climáticas",
            grammar: "Las expresiones de tiempo en teenek usan partículas específicas para indicar pasado, presente y futuro.",
            vocabulary: [
                { word: "K'iin", translation: "Sol/Día", pronunciation: "k'in", example: "Bix a k'iin" },
                { word: "Ik'", translation: "Viento", pronunciation: "ik", example: "Ik' yaan" },
                { word: "Ja'", translation: "Lluvia", pronunciation: "ha", example: "Ja' yaan ch'een" },
                { word: "Sijnal", translation: "Frío", pronunciation: "si-hnal", example: "Sijnal yaan" },
                { word: "Ch'uuj", translation: "Calor", pronunciation: "ch'uj", example: "Ch'uuj yaan" }
            ]
        }),
        new Unit({
            id: 20, levelId: 4, language: "tkoc",
            title: "Naturaleza y Medio Ambiente", color: COLOR_PALETTE.GREEN,
            completed: false, locked: true, current: false,
            objective: "Vocabulario de elementos naturales y medio ambiente",
            grammar: "Los términos de naturaleza suelen usar clasificadores según el tipo de elemento.",
            vocabulary: [
                { word: "Luum", translation: "Tierra", pronunciation: "luum", example: "U luum" },
                { word: "Che'", translation: "Árbol", pronunciation: "che", example: "T'uun che'" },
                { word: "Ha'", translation: "Agua", pronunciation: "ha", example: "Boob ha'" },
                { word: "K'aax", translation: "Monte/Bosque", pronunciation: "k'aash", example: "Teen k'aax" },
                { word: "Ch'ooj", translation: "Rojo", pronunciation: "ch'oj", example: "Luum ch'ooj" }
            ]
        }),
        new Unit({
            id: 21, levelId: 4, language: "tkoc",
            title: "Tradiciones y Costumbres", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Vocabulario relacionado con tradiciones teenek",
            grammar: "El lenguaje ceremonial usa formas específicas y términos tradicionales.",
            vocabulary: [
                { word: "Báayal u baats'", translation: "Lengua teenek", pronunciation: "baa-yal u bats", example: "Báayal u baats'" },
                { word: "U yool u baats'", translation: "Esencia de la palabra", pronunciation: "u yol u bats", example: "U yool u baats'" },
                { word: "Ch'een u yool", translation: "Corazón del pueblo", pronunciation: "ch'en u yol", example: "Ch'een u yool" },
                { word: "U ts'íibil", translation: "Sabiduría", pronunciation: "u ts'iibil", example: "Báayal u ts'íibil" },
                { word: "U k'ab u yool", translation: "Mano del corazón", pronunciation: "u k'ab u yol", example: "U k'ab u yool" }
            ]
        }),
        new Unit({
            id: 22, levelId: 4, language: "tkoc",
            title: "Ceremonias y Rituales", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Vocabulario de ceremonias tradicionales teenek",
            grammar: "El lenguaje ritual usa formas arcaicas y términos específicos.",
            vocabulary: [
                { word: "U ch'een", translation: "Ceremonia", pronunciation: "u ch'e'en", example: "U ch'een" },
                { word: "U yumil", translation: "Ofrenda", pronunciation: "u yu-mil", example: "U yumil" },
                { word: "U k'ay", translation: "Canto ceremonial", pronunciation: "u k'ay", example: "U k'ay" },
                { word: "U baats'", translation: "Palabra sagrada", pronunciation: "u bats", example: "U baats'" },
                { word: "U yool", translation: "Corazón/Esencia", pronunciation: "u yol", example: "U yool" }
            ]
        }),
        new Unit({
            id: 23, levelId: 4, language: "tkoc",
            title: "Artesanías y Oficios", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Vocabulario de artesanías tradicionales teenek",
            grammar: "Los términos de oficios suelen usar el sufijo '-el' que indica actividad.",
            vocabulary: [
                { word: "U meyah", translation: "Trabajo", pronunciation: "u me-yah", example: "U meyah" },
                { word: "U ch'ay", translation: "Tejer", pronunciation: "u ch'ay", example: "U ch'ay" },
                { word: "U pak'", translation: "Sembrar", pronunciation: "u pak", example: "U pak'" },
                { word: "U lool", translation: "Flor", pronunciation: "u lol", example: "U lool" },
                { word: "U ts'íib", translation: "Escritura", pronunciation: "u ts'iib", example: "U ts'íib" }
            ]
        }),
        new Unit({
            id: 24, levelId: 4, language: "tkoc",
            title: "Medicina Tradicional", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Vocabulario de medicina tradicional teenek",
            grammar: "Los términos médicos usan clasificadores específicos para plantas y remedios.",
            vocabulary: [
                { word: "U ts'ak", translation: "Remedio", pronunciation: "u ts'ak", example: "U ts'ak" },
                { word: "U meyah", translation: "Curación", pronunciation: "u me-yah", example: "U meyah" },
                { word: "U yool", translation: "Salud", pronunciation: "u yol", example: "U yool" },
                { word: "U ch'uhuk", translation: "Planta medicinal", pronunciation: "u ch'u-huk", example: "U ch'uhuk" },
                { word: "U k'ab", translation: "Mano (para curar)", pronunciation: "u kab", example: "U k'ab" }
            ]
        }),

        // NIVEL 5 - Unidades
        new Unit({
            id: 25, levelId: 5, language: "tkoc",
            title: "Expresiones Culturales", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Aprender expresiones y proverbios tradicionales teenek",
            grammar: "Las expresiones culturales teenek suelen usar metáforas y referencias a la naturaleza.",
            vocabulary: [
                { word: "U yool u baats'", translation: "La esencia de la palabra", pronunciation: "u yol u bats", example: "U yool u baats' yaan ch'een" },
                { word: "Ch'een u yool", translation: "Corazón del pueblo", pronunciation: "ch'en u yol", example: "Ch'een u yool teenek" },
                { word: "Báayal u ts'íibil", translation: "Mucha sabiduría", pronunciation: "baa-yal u ts'iibil", example: "Báayal u ts'íibil yaan" },
                { word: "U k'ab u yool", translation: "La mano del corazón", pronunciation: "u k'ab u yol", example: "U k'ab u yool yaan" },
                { word: "U yool u k'aax", translation: "Esencia del monte", pronunciation: "u yol u k'aash", example: "U yool u k'aax" }
            ]
        }),
        new Unit({
            id: 26, levelId: 5, language: "tkoc",
            title: "Poesía y Cantos", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Estudio del lenguaje poético teenek",
            grammar: "La poesía teenek usa paralelismos y metáforas basadas en la naturaleza.",
            vocabulary: [
                { word: "U k'ay", translation: "Canto", pronunciation: "u k'ay", example: "U k'ay" },
                { word: "U baats'", translation: "Palabra", pronunciation: "u bats", example: "U baats'" },
                { word: "U yool", translation: "Corazón", pronunciation: "u yol", example: "U yool" },
                { word: "U lool", translation: "Flor", pronunciation: "u lol", example: "U lool" },
                { word: "U k'iin", translation: "Sol", pronunciation: "u k'in", example: "U k'iin" }
            ]
        }),
        new Unit({
            id: 27, levelId: 5, language: "tkoc",
            title: "Filosofía Teenek", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Estudio de conceptos filosóficos teenek",
            grammar: "La filosofía teenek usa términos abstractos con el sufijo '-il'.",
            vocabulary: [
                { word: "U yoolil", translation: "Esencia", pronunciation: "u yo-lil", example: "U yoolil" },
                { word: "U ts'íibil", translation: "Sabiduría", pronunciation: "u ts'iibil", example: "U ts'íibil" },
                { word: "U baats'il", translation: "Lenguaje", pronunciation: "u bat-sil", example: "U baats'il" },
                { word: "U k'ab il", translation: "Acción", pronunciation: "u kab il", example: "U k'ab il" },
                { word: "U meyahil", translation: "Trabajo", pronunciation: "u me-ya-hil", example: "U meyahil" }
            ]
        }),
        new Unit({
            id: 28, levelId: 5, language: "tkoc",
            title: "Lenguaje Formal", color: COLOR_PALETTE.GREEN,
            completed: false, locked: true, current: false,
            objective: "Aprender formas de lenguaje formal teenek",
            grammar: "El lenguaje formal usa formas reverenciales y construcciones complejas.",
            vocabulary: [
                { word: "U yum", translation: "Señor", pronunciation: "u yum", example: "U yum" },
                { word: "U na'", translation: "Señora", pronunciation: "u na", example: "U na'" },
                { word: "U ch'een", translation: "Respetado", pronunciation: "u ch'e'en", example: "U ch'een" },
                { word: "U yool", translation: "Honorable", pronunciation: "u yol", example: "U yool" },
                { word: "U baats'", translation: "Sabio", pronunciation: "u bats", example: "U baats'" }
            ]
        }),
        new Unit({
            id: 29, levelId: 5, language: "tkoc",
            title: "Variaciones Dialectales", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Estudio de variaciones del teenek occidental",
            grammar: "Las variaciones dialectales afectan principalmente la fonología y el léxico.",
            vocabulary: [
                { word: "U baats'il", translation: "Dialecto", pronunciation: "u bat-sil", example: "U baats'il" },
                { word: "U yool", translation: "Variante", pronunciation: "u yol", example: "U yool" },
                { word: "U k'ay", translation: "Pronunciación", pronunciation: "u k'ay", example: "U k'ay" },
                { word: "U ts'íib", translation: "Escritura", pronunciation: "u ts'iib", example: "U ts'íib" },
                { word: "U meyah", translation: "Uso", pronunciation: "u me-yah", example: "U meyah" }
            ]
        }),
        new Unit({
            id: 30, levelId: 5, language: "tkoc",
            title: "Documentación Lingüística", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Vocabulario para documentación lingüística teenek",
            grammar: "El lenguaje técnico incorpora términos modernos con raíces tradicionales.",
            vocabulary: [
                { word: "U ts'íibal", translation: "Documento", pronunciation: "u ts'iibal", example: "U ts'íibal" },
                { word: "U baats'al", translation: "Texto", pronunciation: "u bat-sal", example: "U baats'al" },
                { word: "U k'ayal", translation: "Grabación", pronunciation: "u k'a-yal", example: "U k'ayal" },
                { word: "U wilal", translation: "Video", pronunciation: "u wi-lal", example: "U wilal" },
                { word: "U yoolil", translation: "Análisis", pronunciation: "u yo-lil", example: "U yoolil" }
            ]
        })
    ]
};

// ================= /LEVELS/{ID}/UNITS/{ID}/EXERCISES =================
export const EXERCISES_DATA = {
    // NAHUATL
    nhce: [
        // Level 1, Unit 1 - Saludos básicos
        new Exercise({
            id: 1, unitId: 1, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Buenos días",
            correctAnswer: "Cualli tonalli",
            points: 10,
            difficulty: "easy",
            explanation: "'Cualli tonalli' significa literalmente 'Buen día' en náhuatl."
        }),
        new Exercise({
            id: 2, unitId: 1, levelId: 1, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ tonalli",
            correctAnswer: "Cualli",
            placeholder: "Escribe la palabra en náhuatl",
            points: 15,
            difficulty: "easy",
            explanation: "'Cualli' significa 'bueno' en náhuatl."
        }),
        new Exercise({
            id: 3, unitId: 1, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Buenas noches",
            correctAnswer: "Cualli yohual",
            points: 10,
            difficulty: "easy",
            explanation: "'Cualli yohual' se descompone en 'bueno' (cualli) y 'noche' (yohual)."
        }),
        new Exercise({
            id: 4, unitId: 1, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Gracias",
            correctAnswer: "Tlazocamati",
            points: 10,
            difficulty: "easy",
            explanation: "'Tlazocamati' es la forma estándar de dar las gracias en náhuatl."
        }),
        new Exercise({
            id: 5, unitId: 1, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Por favor",
            correctAnswer: "Nimitztlahtlauhtia",
            points: 10,
            difficulty: "easy",
            explanation: "'Nimitztlahtlauhtia' se utiliza para rogar o suplicar, funcionando como 'por favor'."
        }),

        // Level 1, Unit 2 - Presentaciones
        new Exercise({
            id: 6, unitId: 2, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mi nombre es",
            correctAnswer: "Notoca",
            points: 10,
            difficulty: "easy",
            explanation: "'Notoca' se usa para presentarse seguido del nombre."
        }),
        new Exercise({
            id: 7, unitId: 2, levelId: 1, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ Juan (Me llamo Juan)",
            correctAnswer: "Notoca",
            placeholder: "Escribe la palabra en náhuatl",
            points: 15,
            difficulty: "easy",
            explanation: "'Notoca' significa 'mi nombre es' y va seguido del nombre."
        }),
        new Exercise({
            id: 8, unitId: 2, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Yo soy una persona",
            correctAnswer: "Nitlacatl",
            points: 10,
            difficulty: "easy",
            explanation: "'Nitlacatl' significa 'yo soy una persona'."
        }),
        new Exercise({
            id: 9, unitId: 2, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Me gustas / Me agradas",
            correctAnswer: "Tinechpactia",
            points: 10,
            difficulty: "easy",
            explanation: "'Tinechpactia' expresa gusto o agrado hacia otra persona."
        }),
        new Exercise({
            id: 10, unitId: 2, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Quién eres?",
            correctAnswer: "Queh motoca",
            points: 10,
            difficulty: "easy",
            explanation: "'Queh motoca?' significa literalmente '¿Quién tu nombre?'"
        }),

        // Level 1, Unit 3 - Preguntas básicas
        new Exercise({
            id: 11, unitId: 3, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Cómo estás?",
            correctAnswer: "Quenin timoyolcuitia",
            points: 10,
            difficulty: "easy",
            explanation: "'Quenin timoyolcuitia' es la forma común de preguntar cómo está alguien."
        }),
        new Exercise({
            id: 12, unitId: 3, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Qué",
            correctAnswer: "Tlen",
            points: 10,
            difficulty: "easy",
            explanation: "'Tlen' se usa para preguntas como '¿Qué es esto?'"
        }),
        new Exercise({
            id: 13, unitId: 3, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Dónde",
            correctAnswer: "Acan",
            points: 10,
            difficulty: "easy",
            explanation: "'Acan' se usa para preguntar por ubicaciones."
        }),
        new Exercise({
            id: 14, unitId: 3, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Quién",
            correctAnswer: "Queh",
            points: 10,
            difficulty: "easy",
            explanation: "'Queh' se usa para preguntar por personas."
        }),
        new Exercise({
            id: 15, unitId: 3, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "De nada",
            correctAnswer: "Ahmelli",
            points: 10,
            difficulty: "easy",
            explanation: "'Ahmelli' es la respuesta cortés cuando alguien te da las gracias."
        }),

        // Level 1, Unit 4 - Pronombres personales
        new Exercise({
            id: 16, unitId: 4, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Yo",
            correctAnswer: "Nehuatl",
            points: 10,
            difficulty: "easy",
            explanation: "'Nehuatl' es el pronombre personal para primera persona singular."
        }),
        new Exercise({
            id: 17, unitId: 4, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tú",
            correctAnswer: "Tehhuatl",
            points: 10,
            difficulty: "easy",
            explanation: "'Tehhuatl' es el pronombre personal para segunda persona singular."
        }),
        new Exercise({
            id: 18, unitId: 4, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Él / Ella",
            correctAnswer: "Yehuatl",
            points: 10,
            difficulty: "easy",
            explanation: "'Yehuatl' es el pronombre personal para tercera persona singular."
        }),
        new Exercise({
            id: 19, unitId: 4, levelId: 1, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ nicchihua (Yo hago)",
            correctAnswer: "Nehuatl nicchihua",
            placeholder: "Escribe el pronombre en náhuatl",
            points: 15,
            difficulty: "easy",
            explanation: "'Nehuatl' es 'yo' y 'nicchihua' es 'yo hago'."
        }),
        new Exercise({
            id: 20, unitId: 4, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Prefijo verbal para 'yo'",
            correctAnswer: "ni",
            points: 10,
            difficulty: "easy",
            explanation: "El prefijo 'ni-' se usa con verbos para indicar primera persona singular."
        }),

        // Level 1, Unit 5 - Verbos básicos
        new Exercise({
            id: 21, unitId: 5, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Comer",
            correctAnswer: "Tlacua",
            points: 10,
            difficulty: "easy",
            explanation: "'Tlacua' es el verbo base para 'comer'."
        }),
        new Exercise({
            id: 22, unitId: 5, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Yo como",
            correctAnswer: "Nitlacua",
            points: 10,
            difficulty: "easy",
            explanation: "'Nitlacua' se forma con el prefijo 'ni-' (yo) + 'tlacua' (comer)."
        }),
        new Exercise({
            id: 23, unitId: 5, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Dormir",
            correctAnswer: "Cochi",
            points: 10,
            difficulty: "easy",
            explanation: "'Cochi' es el verbo base para 'dormir'."
        }),
        new Exercise({
            id: 24, unitId: 5, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Vivir / Caminar",
            correctAnswer: "Nemi",
            points: 10,
            difficulty: "easy",
            explanation: "'Nemi' puede significar tanto 'vivir' como 'caminar' dependiendo del contexto."
        }),
        new Exercise({
            id: 25, unitId: 5, levelId: 1, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ ninemi (Yo camino)",
            correctAnswer: "Ninemi",
            placeholder: "Escribe el verbo conjugado",
            points: 15,
            difficulty: "easy",
            explanation: "'Ninemi' significa 'yo camino' o 'yo vivo'."
        }),

        // Level 1, Unit 6 - Familia
        new Exercise({
            id: 26, unitId: 6, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Padre",
            correctAnswer: "Tahtli",
            points: 10,
            difficulty: "easy",
            explanation: "'Tahtli' significa 'padre'."
        }),
        new Exercise({
            id: 27, unitId: 6, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mi padre",
            correctAnswer: "Notahtli",
            points: 10,
            difficulty: "easy",
            explanation: "'Notahtli' se forma con el posesivo 'no-' (mi) + 'tahtli' (padre)."
        }),
        new Exercise({
            id: 28, unitId: 6, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Madre",
            correctAnswer: "Nantli",
            points: 10,
            difficulty: "easy",
            explanation: "'Nantli' significa 'madre'."
        }),
        new Exercise({
            id: 29, unitId: 6, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hermano/a",
            correctAnswer: "Icniutl",
            points: 10,
            difficulty: "easy",
            explanation: "'Icniutl' significa 'hermano' o 'hermana'."
        }),
        new Exercise({
            id: 30, unitId: 6, levelId: 1, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Mi hermano/a)",
            correctAnswer: "Noicniuh",
            placeholder: "Escribe la palabra en náhuatl",
            points: 15,
            difficulty: "easy",
            explanation: "'Noicniuh' se forma con 'no-' (mi) + 'icniuh' (forma posesiva de icniutl)."
        }),

        // Level 2, Unit 1 - Preguntas simples
        new Exercise({
            id: 31, unitId: 7, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Qué buscas?",
            correctAnswer: "Tlen tictemoa",
            points: 15,
            difficulty: "medium",
            explanation: "'Tlen tictemoa' significa literalmente '¿Qué tú buscas?'"
        }),
        new Exercise({
            id: 32, unitId: 7, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Dónde estás?",
            correctAnswer: "Acan tica",
            points: 15,
            difficulty: "medium",
            explanation: "'Acan tica' usa 'aca' (dónde) y 'tica' (estás)."
        }),
        new Exercise({
            id: 33, unitId: 7, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Quién eres?",
            correctAnswer: "Queh motoca",
            points: 15,
            difficulty: "medium",
            explanation: "'Queh motoca' significa '¿Quién tu nombre?'"
        }),
        new Exercise({
            id: 34, unitId: 7, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ tictemoa? (¿Qué buscas?)",
            correctAnswer: "Tlen",
            placeholder: "Escribe la palabra interrogativa",
            points: 20,
            difficulty: "medium",
            explanation: "'Tlen' significa 'qué' y se usa para preguntas sobre cosas."
        }),
        new Exercise({
            id: 35, unitId: 7, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la estructura correcta",
            answer: "Estructura pregunta simple",
            correctAnswer: "Palabra interrogativa + verbo + complemento",
            points: 15,
            difficulty: "medium",
            explanation: "Las preguntas simples siguen el orden: palabra interrogativa, luego verbo, y finalmente complemento si lo hay."
        }),

        // Level 2, Unit 2 - Expresiones cotidianas
        new Exercise({
            id: 36, unitId: 8, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Te ayudo",
            correctAnswer: "Nimitztlapaloa",
            points: 15,
            difficulty: "medium",
            explanation: "'Nimitztlapaloa' significa 'yo te ayudo'."
        }),
        new Exercise({
            id: 37, unitId: 8, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Me gustas",
            correctAnswer: "Tinechpactia",
            points: 15,
            difficulty: "medium",
            explanation: "'Tinechpactia' expresa afecto o gusto hacia alguien."
        }),
        new Exercise({
            id: 38, unitId: 8, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Te ruego",
            correctAnswer: "Nimitztlatlauhtia",
            points: 15,
            difficulty: "medium",
            explanation: "'Nimitztlatlauhtia' se usa para suplicar o rogar algo."
        }),
        new Exercise({
            id: 39, unitId: 8, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Te ayudo)",
            correctAnswer: "Nimitztlapaloa",
            placeholder: "Escribe la expresión en náhuatl",
            points: 20,
            difficulty: "medium",
            explanation: "'Nimitztlapaloa' combina 'ni-' (yo), 'mitz-' (te) y 'tlapaloa' (ayudar)."
        }),
        new Exercise({
            id: 40, unitId: 8, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Prefijo para 'te'",
            correctAnswer: "mitz-",
            points: 15,
            difficulty: "medium",
            explanation: "El prefijo 'mitz-' se usa para indicar segunda persona singular como objeto indirecto."
        }),

        // Level 2, Unit 3 - Tiempo y fechas
        new Exercise({
            id: 41, unitId: 9, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Día / Sol",
            correctAnswer: "Tonalli",
            points: 15,
            difficulty: "medium",
            explanation: "'Tonalli' puede significar tanto 'día' como 'sol'."
        }),
        new Exercise({
            id: 42, unitId: 9, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Luna / Mes",
            correctAnswer: "Metztli",
            points: 15,
            difficulty: "medium",
            explanation: "'Metztli' significa tanto 'luna' como 'mes'."
        }),
        new Exercise({
            id: 43, unitId: 9, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Año",
            correctAnswer: "Xihuitl",
            points: 15,
            difficulty: "medium",
            explanation: "'Xihuitl' significa 'año'."
        }),
        new Exercise({
            id: 44, unitId: 9, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Ce ______ (Un mes)",
            correctAnswer: "metztli",
            placeholder: "Escribe la palabra en náhuatl",
            points: 20,
            difficulty: "medium",
            explanation: "'Ce' significa 'uno' y 'metztli' significa 'mes'."
        }),
        new Exercise({
            id: 45, unitId: 9, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Palabra para luna y mes",
            correctAnswer: "Metztli",
            points: 15,
            difficulty: "medium",
            explanation: "'Metztli' tiene ambos significados, similar a cómo en español 'luna' se relaciona con 'mes lunar'."
        }),

        // Level 2, Unit 4 - Comida y bebida
        new Exercise({
            id: 46, unitId: 10, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tortilla",
            correctAnswer: "Tlaxcalli",
            points: 15,
            difficulty: "medium",
            explanation: "'Tlaxcalli' es la palabra náhuatl para 'tortilla'."
        }),
        new Exercise({
            id: 47, unitId: 10, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Atole",
            correctAnswer: "Atolli",
            points: 15,
            difficulty: "medium",
            explanation: "'Atolli' es la bebida tradicional de maíz."
        }),
        new Exercise({
            id: 48, unitId: 10, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Chile",
            correctAnswer: "Chilli",
            points: 15,
            difficulty: "medium",
            explanation: "'Chilli' es el origen de la palabra española 'chile'."
        }),
        new Exercise({
            id: 49, unitId: 10, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Tortilla)",
            correctAnswer: "Tlaxcalli",
            placeholder: "Escribe la palabra en náhuatl",
            points: 20,
            difficulty: "medium",
            explanation: "'Tlaxcalli' viene de 'tlaxcalli' que significa 'pan cocido'."
        }),
        new Exercise({
            id: 50, unitId: 10, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Prefijo para alimentos",
            correctAnswer: "tla-",
            points: 15,
            difficulty: "medium",
            explanation: "El prefijo 'tla-' indica algo inanimado y es común en nombres de alimentos."
        }),

        // Level 2, Unit 5 - Direcciones y lugares
        new Exercise({
            id: 51, unitId: 11, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "En medio",
            correctAnswer: "Nepantla",
            points: 15,
            difficulty: "medium",
            explanation: "'Nepantla' significa 'en medio' o 'entre'."
        }),
        new Exercise({
            id: 52, unitId: 11, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Encima",
            correctAnswer: "Icpac",
            points: 15,
            difficulty: "medium",
            explanation: "'Icpac' significa 'encima' o 'sobre'."
        }),
        new Exercise({
            id: 53, unitId: 11, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "En la tierra",
            correctAnswer: "Tlalpan",
            points: 15,
            difficulty: "medium",
            explanation: "'Tlalpan' viene de 'tlalli' (tierra) + 'pan' (sobre)."
        }),
        new Exercise({
            id: 54, unitId: 11, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ petlatl (Sobre la estera)",
            correctAnswer: "Ipan",
            placeholder: "Escribe la preposición",
            points: 20,
            difficulty: "medium",
            explanation: "'Ipan' significa 'sobre' o 'en' y va seguido del sustantivo."
        }),
        new Exercise({
            id: 55, unitId: 11, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Posición 'en medio'",
            correctAnswer: "Nepantla",
            points: 15,
            difficulty: "medium",
            explanation: "'Nepantla' es un concepto importante que significa 'en el medio' o 'entre dos cosas'."
        }),

        // Level 2, Unit 6 - Emociones y sentimientos
        new Exercise({
            id: 56, unitId: 12, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Estar contento",
            correctAnswer: "Pactia",
            points: 15,
            difficulty: "medium",
            explanation: "'Pactia' significa 'estar contento' o 'estar satisfecho'."
        }),
        new Exercise({
            id: 57, unitId: 12, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Llorar",
            correctAnswer: "Choka",
            points: 15,
            difficulty: "medium",
            explanation: "'Choka' es el verbo para 'llorar'."
        }),
        new Exercise({
            id: 58, unitId: 12, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Enojado",
            correctAnswer: "Tlahueliloc",
            points: 15,
            difficulty: "medium",
            explanation: "'Tlahueliloc' significa 'estar enojado' o 'estar furioso'."
        }),
        new Exercise({
            id: 59, unitId: 12, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Ni______ (Estoy contento)",
            correctAnswer: "pactia",
            placeholder: "Escribe el verbo",
            points: 20,
            difficulty: "medium",
            explanation: "'Nipactia' se forma con 'ni-' (yo) + 'pactia' (estar contento)."
        }),
        new Exercise({
            id: 60, unitId: 12, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sufijo para estados emocionales",
            correctAnswer: "-yotl",
            points: 15,
            difficulty: "medium",
            explanation: "El sufijo '-yotl' indica naturaleza o esencia, usado en términos emocionales."
        }),

        // Level 3, Unit 1 - Verbos presentes
        new Exercise({
            id: 61, unitId: 13, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Yo hago",
            correctAnswer: "Nichihua",
            points: 20,
            difficulty: "hard",
            explanation: "'Nichihua' usa el prefijo 'ni-' para primera persona singular."
        }),
        new Exercise({
            id: 62, unitId: 13, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tú hablas",
            correctAnswer: "Titlahtoa",
            points: 20,
            difficulty: "hard",
            explanation: "'Titlahtoa' usa el prefijo 'ti-' para segunda persona singular."
        }),
        new Exercise({
            id: 63, unitId: 13, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Él/Ella busca",
            correctAnswer: "Quitemoa",
            points: 20,
            difficulty: "hard",
            explanation: "'Quitemoa' usa el prefijo 'qui-' para tercera persona singular."
        }),
        new Exercise({
            id: 64, unitId: 13, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Yo hablo)",
            correctAnswer: "Nitlahtoa",
            placeholder: "Escribe el verbo conjugado",
            points: 25,
            difficulty: "hard",
            explanation: "'Nitlahtoa' combina 'ni-' (yo) + 'tlahtoa' (hablar)."
        }),
        new Exercise({
            id: 65, unitId: 13, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Prefijo verbal para 'tú'",
            correctAnswer: "ti-",
            points: 20,
            difficulty: "hard",
            explanation: "El prefijo 'ti-' se usa para segunda persona singular en tiempo presente."
        }),

        // Level 3, Unit 2 - Verbos pasados
        new Exercise({
            id: 66, unitId: 14, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Yo hice",
            correctAnswer: "Nichihuac",
            points: 20,
            difficulty: "hard",
            explanation: "'Nichihuac' usa el sufijo '-c' para indicar tiempo pasado."
        }),
        new Exercise({
            id: 67, unitId: 14, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tú hablaste",
            correctAnswer: "Titlahtoac",
            points: 20,
            difficulty: "hard",
            explanation: "'Titlahtoac' combina 'ti-' (tú) + 'tlahtoa' (hablar) + '-c' (pasado)."
        }),
        new Exercise({
            id: 68, unitId: 14, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Él/Ella buscó",
            correctAnswer: "Quitemoac",
            points: 20,
            difficulty: "hard",
            explanation: "'Quitemoac' usa 'qui-' (él/ella) + 'temoa' (buscar) + '-c' (pasado)."
        }),
        new Exercise({
            id: 69, unitId: 14, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Nichihu______ (Yo hice)",
            correctAnswer: "ac",
            placeholder: "Escribe la terminación",
            points: 25,
            difficulty: "hard",
            explanation: "La terminación '-ac' (o '-c') indica tiempo pasado para primera persona."
        }),
        new Exercise({
            id: 70, unitId: 14, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sufijo tiempo pasado",
            correctAnswer: "-c o -que",
            points: 20,
            difficulty: "hard",
            explanation: "Los sufijos '-c' o '-que' se usan para formar el tiempo pasado, dependiendo del verbo."
        }),

        // Level 3, Unit 3 - Verbos futuros
        new Exercise({
            id: 71, unitId: 15, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Yo haré",
            correctAnswer: "Nichihuaz",
            points: 20,
            difficulty: "hard",
            explanation: "'Nichihuaz' usa el sufijo '-z' para indicar tiempo futuro."
        }),
        new Exercise({
            id: 72, unitId: 15, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tú hablarás",
            correctAnswer: "Titlahtoaz",
            points: 20,
            difficulty: "hard",
            explanation: "'Titlahtoaz' combina 'ti-' (tú) + 'tlahtoa' (hablar) + '-z' (futuro)."
        }),
        new Exercise({
            id: 73, unitId: 15, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Él/Ella buscará",
            correctAnswer: "Quitemoaz",
            points: 20,
            difficulty: "hard",
            explanation: "'Quitemoaz' usa 'qui-' (él/ella) + 'temoa' (buscar) + '-z' (futuro)."
        }),
        new Exercise({
            id: 74, unitId: 15, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Nitlahtoa______ (Yo hablaré)",
            correctAnswer: "z",
            placeholder: "Escribe la terminación",
            points: 25,
            difficulty: "hard",
            explanation: "La terminación '-z' indica tiempo futuro."
        }),
        new Exercise({
            id: 75, unitId: 15, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sufijo tiempo futuro",
            correctAnswer: "-z o -s",
            points: 20,
            difficulty: "hard",
            explanation: "Los sufijos '-z' o '-s' se usan para formar el tiempo futuro, dependiendo del verbo."
        }),

        // Level 3, Unit 4 - Sustantivos y adjetivos
        new Exercise({
            id: 76, unitId: 16, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Águila",
            correctAnswer: "Cuahtli",
            points: 20,
            difficulty: "hard",
            explanation: "'Cuahtli' significa 'águila', un animal importante en la cultura náhuatl."
        }),
        new Exercise({
            id: 77, unitId: 16, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Serpiente",
            correctAnswer: "Coatl",
            points: 20,
            difficulty: "hard",
            explanation: "'Coatl' significa 'serpiente', animal sagrado en la cosmovisión náhuatl."
        }),
        new Exercise({
            id: 78, unitId: 16, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Grande",
            correctAnswer: "Hueyi",
            points: 20,
            difficulty: "hard",
            explanation: "'Hueyi' significa 'grande' y va después del sustantivo."
        }),
        new Exercise({
            id: 79, unitId: 16, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Cuahtli ______ (Águila grande)",
            correctAnswer: "hueyi",
            placeholder: "Escribe el adjetivo",
            points: 25,
            difficulty: "hard",
            explanation: "En náhuatl, los adjetivos generalmente van después del sustantivo."
        }),
        new Exercise({
            id: 80, unitId: 16, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la posición correcta",
            answer: "Posición del adjetivo",
            correctAnswer: "Después del sustantivo",
            points: 20,
            difficulty: "hard",
            explanation: "A diferencia del español, en náhuatl el adjetivo suele ir después del sustantivo que modifica."
        }),

        // Level 3, Unit 5 - Posesivos
        new Exercise({
            id: 81, unitId: 17, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mi casa",
            correctAnswer: "Nocal",
            points: 20,
            difficulty: "hard",
            explanation: "'Nocal' usa el posesivo 'no-' (mi) + 'cal' (casa)."
        }),
        new Exercise({
            id: 82, unitId: 17, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tu casa",
            correctAnswer: "Mocal",
            points: 20,
            difficulty: "hard",
            explanation: "'Mocal' usa el posesivo 'mo-' (tu) + 'cal' (casa)."
        }),
        new Exercise({
            id: 83, unitId: 17, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Su casa",
            correctAnswer: "Ical",
            points: 20,
            difficulty: "hard",
            explanation: "'Ical' usa el posesivo 'i-' (su) + 'cal' (casa)."
        }),
        new Exercise({
            id: 84, unitId: 17, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Mi casa)",
            correctAnswer: "Nocal",
            placeholder: "Escribe la palabra en náhuatl",
            points: 25,
            difficulty: "hard",
            explanation: "'Nocal' se forma con el posesivo 'no-' (mi) y 'cal' (casa)."
        }),
        new Exercise({
            id: 85, unitId: 17, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Prefijo posesivo para 'mi'",
            correctAnswer: "no-",
            points: 20,
            difficulty: "hard",
            explanation: "El prefijo 'no-' indica posesión de primera persona singular."
        }),

        // Level 3, Unit 6 - Preposiciones
        new Exercise({
            id: 86, unitId: 18, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sobre / En",
            correctAnswer: "Ipan",
            points: 20,
            difficulty: "hard",
            explanation: "'Ipan' significa 'sobre' o 'en' y funciona como posposición."
        }),
        new Exercise({
            id: 87, unitId: 18, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Dentro",
            correctAnswer: "Itic",
            points: 20,
            difficulty: "hard",
            explanation: "'Itic' significa 'dentro' y va después del sustantivo."
        }),
        new Exercise({
            id: 88, unitId: 18, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Con",
            correctAnswer: "Ihuan",
            points: 20,
            difficulty: "hard",
            explanation: "'Ihuan' significa 'con' y se usa para indicar compañía."
        }),
        new Exercise({
            id: 89, unitId: 18, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Calli ______ (Dentro de la casa)",
            correctAnswer: "itic",
            placeholder: "Escribe la posposición",
            points: 25,
            difficulty: "hard",
            explanation: "'Itic' va después del sustantivo, a diferencia de las preposiciones en español."
        }),
        new Exercise({
            id: 90, unitId: 18, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona el término correcto",
            answer: "Tipo de palabra como 'ipan'",
            correctAnswer: "Posposiciones",
            points: 20,
            difficulty: "hard",
            explanation: "En náhuatl se usan posposiciones que van después del sustantivo, no preposiciones."
        }),

        // Level 4, Unit 1 - Narraciones
        new Exercise({
            id: 91, unitId: 19, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Solo / Solamente",
            correctAnswer: "Zan",
            points: 25,
            difficulty: "hard",
            explanation: "'Zan' significa 'solo' o 'solamente' y se usa para limitar el alcance."
        }),
        new Exercise({
            id: 92, unitId: 19, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Muy / Mucho",
            correctAnswer: "Huel",
            points: 25,
            difficulty: "hard",
            explanation: "'Huel' se usa para intensificar adjetivos, similar a 'muy' en español."
        }),
        new Exercise({
            id: 93, unitId: 19, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mucho (cantidad)",
            correctAnswer: "Cenca",
            points: 25,
            difficulty: "hard",
            explanation: "'Cenca' significa 'mucho' y se usa para indicar gran cantidad."
        }),
        new Exercise({
            id: 94, unitId: 19, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ cualli (Muy bueno)",
            correctAnswer: "Huel",
            placeholder: "Escribe el intensificador",
            points: 30,
            difficulty: "hard",
            explanation: "'Huel' se coloca antes del adjetivo para intensificarlo."
        }),
        new Exercise({
            id: 95, unitId: 19, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la opción correcta",
            answer: "Tiempo verbal en narraciones",
            correctAnswer: "Pasado",
            points: 25,
            difficulty: "hard",
            explanation: "Las narraciones tradicionales náhuatl suelen usar el tiempo pasado para contar eventos."
        }),

        // Level 4, Unit 2 - Cosmovisión
        new Exercise({
            id: 96, unitId: 20, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sol",
            correctAnswer: "Tonatiuh",
            points: 25,
            difficulty: "hard",
            explanation: "'Tonatiuh' es el dios sol en la cosmovisión náhuatl."
        }),
        new Exercise({
            id: 97, unitId: 20, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Luna",
            correctAnswer: "Meztli",
            points: 25,
            difficulty: "hard",
            explanation: "'Meztli' es la diosa luna en la mitología náhuatl."
        }),
        new Exercise({
            id: 98, unitId: 20, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Estrella",
            correctAnswer: "Citlalli",
            points: 25,
            difficulty: "hard",
            explanation: "'Citlalli' significa 'estrella' y era importante en la astronomía náhuatl."
        }),
        new Exercise({
            id: 99, unitId: 20, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Sol)",
            correctAnswer: "Tonatiuh",
            placeholder: "Escribe la palabra en náhuatl",
            points: 30,
            difficulty: "hard",
            explanation: "'Tonatiuh' era una deidad central en la cosmovisión náhuatl."
        }),
        new Exercise({
            id: 100, unitId: 20, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sufijo para conceptos abstractos",
            correctAnswer: "-yotl",
            points: 25,
            difficulty: "hard",
            explanation: "El sufijo '-yotl' indica esencia o naturaleza, usado en términos cosmológicos."
        }),

        // Level 4, Unit 3 - Tradiciones orales
        new Exercise({
            id: 101, unitId: 21, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Palabra",
            correctAnswer: "Tlahtolli",
            points: 25,
            difficulty: "hard",
            explanation: "'Tlahtolli' significa 'palabra' y era fundamental en la tradición oral."
        }),
        new Exercise({
            id: 102, unitId: 21, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Cuento",
            correctAnswer: "Zazanilli",
            points: 25,
            difficulty: "hard",
            explanation: "'Zazanilli' se refiere a cuentos o narraciones tradicionales."
        }),
        new Exercise({
            id: 103, unitId: 21, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Canto",
            correctAnswer: "Cuicatl",
            points: 25,
            difficulty: "hard",
            explanation: "'Cuicatl' significa 'canto' o 'poesía cantada'."
        }),
        new Exercise({
            id: 104, unitId: 21, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "In xochitl in ______ (Flor y canto)",
            correctAnswer: "cuicatl",
            placeholder: "Escribe la palabra en náhuatl",
            points: 30,
            difficulty: "hard",
            explanation: "'In xochitl in cuicatl' es una expresión poética que significa 'flor y canto', símbolo de la poesía náhuatl."
        }),
        new Exercise({
            id: 105, unitId: 21, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la opción correcta",
            answer: "Recursos literarios poesía náhuatl",
            correctAnswer: "Metáforas y paralelismos",
            points: 25,
            difficulty: "hard",
            explanation: "La poesía náhuatl tradicional usa metáforas complejas y estructuras paralelas."
        }),

        // Level 4, Unit 4 - Ceremonias
        new Exercise({
            id: 106, unitId: 22, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ofrenda",
            correctAnswer: "Tlamaniliztli",
            points: 25,
            difficulty: "hard",
            explanation: "'Tlamaniliztli' se refiere a las ofrendas ceremoniales."
        }),
        new Exercise({
            id: 107, unitId: 22, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ayuno",
            correctAnswer: "Nextlahualiztli",
            points: 25,
            difficulty: "hard",
            explanation: "'Nextlahualiztli' significa 'ayuno', práctica ceremonial importante."
        }),
        new Exercise({
            id: 108, unitId: 22, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Bautizo",
            correctAnswer: "Tlacahuapahualiztli",
            points: 25,
            difficulty: "hard",
            explanation: "'Tlacahuapahualiztli' es el término para ceremonia de bautizo."
        }),
        new Exercise({
            id: 109, unitId: 22, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Ofrenda)",
            correctAnswer: "Tlamaniliztli",
            placeholder: "Escribe la palabra en náhuatl",
            points: 30,
            difficulty: "hard",
            explanation: "'Tlamaniliztli' viene de 'tlamani' (ofrecer) + '-liztli' (sufijo de acción)."
        }),
        new Exercise({
            id: 110, unitId: 22, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la opción correcta",
            answer: "Característica lenguaje ceremonial",
            correctAnswer: "Formas reverenciales y términos específicos",
            points: 25,
            difficulty: "hard",
            explanation: "El lenguaje ceremonial usa formas reverenciales como '-tzin' y vocabulario especializado."
        }),

        // Level 4, Unit 5 - Arte y artesanía
        new Exercise({
            id: 111, unitId: 23, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Pintura",
            correctAnswer: "Tlacuilolli",
            points: 25,
            difficulty: "hard",
            explanation: "'Tlacuilolli' significa 'pintura' o 'escritura pictórica'."
        }),
        new Exercise({
            id: 112, unitId: 23, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Arte plumaria",
            correctAnswer: "Amantecayotl",
            points: 25,
            difficulty: "hard",
            explanation: "'Amantecayotl' es el arte de trabajar con plumas, muy valorado."
        }),
        new Exercise({
            id: 113, unitId: 23, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Arte tolteca",
            correctAnswer: "Toltecayotl",
            points: 25,
            difficulty: "hard",
            explanation: "'Toltecayotl' se refiere al arte y sabiduría de los toltecas."
        }),
        new Exercise({
            id: 114, unitId: 23, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Pintura)",
            correctAnswer: "Tlacuilolli",
            placeholder: "Escribe la palabra en náhuatl",
            points: 30,
            difficulty: "hard",
            explanation: "'Tlacuilolli' viene de 'tlacuiloa' (escribir/pintar) + '-lli' (sufijo de acción)."
        }),
        new Exercise({
            id: 115, unitId: 23, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Prefijo términos artísticos",
            correctAnswer: "tla-",
            points: 25,
            difficulty: "hard",
            explanation: "El prefijo 'tla-' indica actividad y es común en términos relacionados con arte y artesanía."
        }),

        // Level 4, Unit 6 - Medicina tradicional
        new Exercise({
            id: 116, unitId: 24, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Médico",
            correctAnswer: "Ticiti",
            points: 25,
            difficulty: "hard",
            explanation: "'Ticiti' significa 'médico' o 'curandero'."
        }),
        new Exercise({
            id: 117, unitId: 24, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Medicina",
            correctAnswer: "Patli",
            points: 25,
            difficulty: "hard",
            explanation: "'Patli' significa 'medicina' o 'remedio'."
        }),
        new Exercise({
            id: 118, unitId: 24, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Medicina purgante",
            correctAnswer: "Tlazolpatli",
            points: 25,
            difficulty: "hard",
            explanation: "'Tlazolpatli' significa literalmente 'medicina para la basura' (purga)."
        }),
        new Exercise({
            id: 119, unitId: 24, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Médico)",
            correctAnswer: "Ticiti",
            placeholder: "Escribe la palabra en náhuatl",
            points: 30,
            difficulty: "hard",
            explanation: "'Ticiti' es el término tradicional para médico o sanador."
        }),
        new Exercise({
            id: 120, unitId: 24, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la opción correcta",
            answer: "Sufijos términos médicos",
            correctAnswer: "-patli y -ticitl",
            points: 25,
            difficulty: "hard",
            explanation: "Los sufijos '-patli' (medicina) y '-ticitl' (médico) son característicos del vocabulario médico."
        }),

        // Level 5, Unit 1 - Códices
        new Exercise({
            id: 121, unitId: 25, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Libro / Códice",
            correctAnswer: "Amoxtli",
            points: 30,
            difficulty: "expert",
            explanation: "'Amoxtli' significa 'libro' o 'códice', los documentos pictográficos prehispánicos."
        }),
        new Exercise({
            id: 122, unitId: 25, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Escritura",
            correctAnswer: "Tlahcuilolli",
            points: 30,
            difficulty: "expert",
            explanation: "'Tlahcuilolli' se refiere al sistema de escritura pictórica."
        }),
        new Exercise({
            id: 123, unitId: 25, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Calendario",
            correctAnswer: "Tlapohualiztli",
            points: 30,
            difficulty: "expert",
            explanation: "'Tlapohualiztli' significa 'cuenta' o 'calendario'."
        }),
        new Exercise({
            id: 124, unitId: 25, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Libro/Códice)",
            correctAnswer: "Amoxtli",
            placeholder: "Escribe la palabra en náhuatl",
            points: 35,
            difficulty: "expert",
            explanation: "'Amoxtli' era el término para los libros de pictografías náhuatl."
        }),
        new Exercise({
            id: 125, unitId: 25, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la opción correcta",
            answer: "Lenguaje de códices combina",
            correctAnswer: "Elementos pictográficos con glifos fonéticos",
            points: 30,
            difficulty: "expert",
            explanation: "Los códices combinan pictografías (dibujos que representan ideas) con glifos fonéticos (que representan sonidos)."
        }),

        // Level 5, Unit 2 - Poesía náhuatl
        new Exercise({
            id: 126, unitId: 26, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Flor",
            correctAnswer: "Xochitl",
            points: 30,
            difficulty: "expert",
            explanation: "'Xochitl' significa 'flor', símbolo importante en la poesía náhuatl."
        }),
        new Exercise({
            id: 127, unitId: 26, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Canto",
            correctAnswer: "Cuicatl",
            points: 30,
            difficulty: "expert",
            explanation: "'Cuicatl' significa 'canto' o 'poesía'."
        }),
        new Exercise({
            id: 128, unitId: 26, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "In xochitl in cuicatl",
            correctAnswer: "Flor y canto",
            points: 30,
            difficulty: "expert",
            explanation: "'In xochitl in cuicatl' es una expresión metafórica que representa la poesía y el arte."
        }),
        new Exercise({
            id: 129, unitId: 26, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "In ______ in cuicatl (Flor y canto)",
            correctAnswer: "xochitl",
            placeholder: "Escribe la palabra en náhuatl",
            points: 35,
            difficulty: "expert",
            explanation: "'Xochitl' significa 'flor' en esta expresión poética."
        }),
        new Exercise({
            id: 130, unitId: 26, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la opción correcta",
            answer: "Recursos poesía náhuatl",
            correctAnswer: "Metáforas complejas y paralelismos sintácticos",
            points: 30,
            difficulty: "expert",
            explanation: "La poesía náhuatl tradicional emplea metáforas elaboradas y estructuras paralelas."
        }),

        // Level 5, Unit 3 - Filosofía náhuatl
        new Exercise({
            id: 131, unitId: 27, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Verdad",
            correctAnswer: "Neltiliztli",
            points: 30,
            difficulty: "expert",
            explanation: "'Neltiliztli' significa 'verdad' o 'fundamento'."
        }),
        new Exercise({
            id: 132, unitId: 27, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sabiduría",
            correctAnswer: "Tlamatiliztli",
            points: 30,
            difficulty: "expert",
            explanation: "'Tlamatiliztli' significa 'sabiduría' o 'conocimiento'."
        }),
        new Exercise({
            id: 133, unitId: 27, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Vida",
            correctAnswer: "Yoliztli",
            points: 30,
            difficulty: "expert",
            explanation: "'Yoliztli' significa 'vida', concepto central en la filosofía náhuatl."
        }),
        new Exercise({
            id: 134, unitId: 27, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Verdad)",
            correctAnswer: "Neltiliztli",
            placeholder: "Escribe la palabra en náhuatl",
            points: 35,
            difficulty: "expert",
            explanation: "'Neltiliztli' viene de 'nelhuayotl' (raíz/fundamento)."
        }),
        new Exercise({
            id: 135, unitId: 27, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sufijo conceptos filosóficos",
            correctAnswer: "-yotl",
            points: 30,
            difficulty: "expert",
            explanation: "El sufijo '-yotl' indica esencia o naturaleza, usado en términos filosóficos abstractos."
        }),

        // Level 5, Unit 4 - Lenguaje formal
        new Exercise({
            id: 136, unitId: 28, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mi señor (formal)",
            correctAnswer: "Notlahcol",
            points: 30,
            difficulty: "expert",
            explanation: "'Notlahcol' es una forma reverencial para 'mi señor'."
        }),
        new Exercise({
            id: 137, unitId: 28, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tu señor (formal)",
            correctAnswer: "Motlahcol",
            points: 30,
            difficulty: "expert",
            explanation: "'Motlahcol' es la forma reverencial para 'tu señor'."
        }),
        new Exercise({
            id: 138, unitId: 28, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Su señor (formal)",
            correctAnswer: "Itlahcol",
            points: 30,
            difficulty: "expert",
            explanation: "'Itlahcol' es la forma reverencial para 'su señor'."
        }),
        new Exercise({
            id: 139, unitId: 28, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Mi señor - formal)",
            correctAnswer: "Notlahcol",
            placeholder: "Escribe la expresión en náhuatl",
            points: 35,
            difficulty: "expert",
            explanation: "'Notlahcol' usa el posesivo reverencial 'no-' + 'tlahcol' (señor)."
        }),
        new Exercise({
            id: 140, unitId: 28, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la opción correcta",
            answer: "Característica lenguaje formal",
            correctAnswer: "Sufijos reverenciales y formas verbales especiales",
            points: 30,
            difficulty: "expert",
            explanation: "El lenguaje formal usa sufijos como '-tzin' y formas verbales reverenciales."
        }),

        // Level 5, Unit 5 - Variaciones dialectales
        new Exercise({
            id: 141, unitId: 29, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Lengua de los masehuales",
            correctAnswer: "Masehualtlahtolli",
            points: 30,
            difficulty: "expert",
            explanation: "'Masehualtlahtolli' significa 'lengua náhuatl' o 'lengua del pueblo'."
        }),
        new Exercise({
            id: 142, unitId: 29, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Lengua pura",
            correctAnswer: "Tlahtolmelahuac",
            points: 30,
            difficulty: "expert",
            explanation: "'Tlahtolmelahuac' se refiere al náhuatl puro o correcto."
        }),
        new Exercise({
            id: 143, unitId: 29, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Uso de la lengua",
            correctAnswer: "Tlahtoltequitl",
            points: 30,
            difficulty: "expert",
            explanation: "'Tlahtoltequitl' significa 'uso o práctica del lenguaje'."
        }),
        new Exercise({
            id: 144, unitId: 29, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Lengua náhuatl)",
            correctAnswer: "Masehualtlahtolli",
            placeholder: "Escribe la expresión en náhuatl",
            points: 35,
            difficulty: "expert",
            explanation: "'Masehualtlahtolli' combina 'masehual' (pueblo) + 'tlahtolli' (lengua)."
        }),
        new Exercise({
            id: 145, unitId: 29, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la opción correcta",
            answer: "Aspectos que varían entre dialectos",
            correctAnswer: "Fonología y léxico",
            points: 30,
            difficulty: "expert",
            explanation: "Las variaciones dialectales afectan principalmente la pronunciación y el vocabulario."
        }),

        // Level 5, Unit 6 - Documentos históricos
        new Exercise({
            id: 146, unitId: 30, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Palabra antigua",
            correctAnswer: "Huehuehtlahtolli",
            points: 30,
            difficulty: "expert",
            explanation: "'Huehuehtlahtolli' significa 'palabra de los ancianos' o 'sabiduría antigua'."
        }),
        new Exercise({
            id: 147, unitId: 30, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Documento",
            correctAnswer: "Tlahtolamatl",
            points: 30,
            difficulty: "expert",
            explanation: "'Tlahtolamatl' significa literalmente 'papel de palabras'."
        }),
        new Exercise({
            id: 148, unitId: 30, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Documento escrito",
            correctAnswer: "Tlahtolcuilolamatl",
            points: 30,
            difficulty: "expert",
            explanation: "'Tlahtolcuilolamatl' especifica que es un documento escrito."
        }),
        new Exercise({
            id: 149, unitId: 30, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Palabra antigua)",
            correctAnswer: "Huehuehtlahtolli",
            placeholder: "Escribe la expresión en náhuatl",
            points: 35,
            difficulty: "expert",
            explanation: "'Huehuehtlahtolli' combina 'huehueh' (antiguo) + 'tlahtolli' (palabra)."
        }),
        new Exercise({
            id: 150, unitId: 30, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la opción correcta",
            answer: "Característica documentos históricos",
            correctAnswer: "Formas arcaicas y préstamos del español",
            points: 30,
            difficulty: "expert",
            explanation: "Los documentos históricos muestran formas lingüísticas arcaicas e incorporan préstamos del español colonial."
        })
    ],

    // TEENEK
    tkoc: [
        // Level 1, Unit 1 - Saludos en Teenek
        new Exercise({
            id: 1, unitId: 1, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Buenos días",
            correctAnswer: "Bix a beel",
            points: 10,
            difficulty: "easy",
            explanation: "'Bix a beel' es el saludo formal para 'Buenos días' en teenek."
        }),
        new Exercise({
            id: 2, unitId: 1, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Gracias",
            correctAnswer: "Waal a b'ixik",
            points: 10,
            difficulty: "easy",
            explanation: "'Waal a b'ixik' es la forma de agradecer en teenek."
        }),
        new Exercise({
            id: 3, unitId: 1, levelId: 1, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Bix a ______ (Buenas tardes)",
            correctAnswer: "k'iin",
            placeholder: "Escribe la palabra en teenek",
            points: 15,
            difficulty: "medium",
            explanation: "'Bix a k'iin' significa 'Buenas tardes' en teenek."
        }),
        new Exercise({
            id: 4, unitId: 1, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Adiós",
            correctAnswer: "Maats'",
            points: 10,
            difficulty: "easy",
            explanation: "'Maats'' es la forma común de despedirse en teenek."
        }),
        new Exercise({
            id: 5, unitId: 1, levelId: 1, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Bix ______ (¿Cómo estás?)",
            correctAnswer: "yaanam",
            placeholder: "Escribe la palabra en teenek",
            points: 15,
            difficulty: "medium",
            explanation: "'Bix yaanam' es la forma de preguntar cómo está alguien en teenek."
        }),

        // Level 1, Unit 2 - Números Básicos
        new Exercise({
            id: 6, unitId: 2, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Uno",
            correctAnswer: "T'uun",
            points: 10,
            difficulty: "easy",
            explanation: "'T'uun' significa 'Uno' en teenek."
        }),
        new Exercise({
            id: 7, unitId: 2, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tres",
            correctAnswer: "Oxib",
            points: 10,
            difficulty: "easy",
            explanation: "'Oxib' significa 'Tres' en teenek."
        }),
        new Exercise({
            id: 8, unitId: 2, levelId: 1, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Cinco)",
            correctAnswer: "Boob",
            placeholder: "Escribe el número en teenek",
            points: 15,
            difficulty: "medium",
            explanation: "'Boob' significa 'Cinco' en teenek."
        }),
        new Exercise({
            id: 9, unitId: 2, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Dos",
            correctAnswer: "Ts'íib",
            points: 10,
            difficulty: "easy",
            explanation: "'Ts'íib' significa 'Dos' en teenek."
        }),
        new Exercise({
            id: 10, unitId: 2, levelId: 1, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Cuatro)",
            correctAnswer: "Tseeb",
            placeholder: "Escribe el número en teenek",
            points: 15,
            difficulty: "medium",
            explanation: "'Tseeb' significa 'Cuatro' en teenek."
        }),

        // Level 1, Unit 3 - Familia y Personas
        new Exercise({
            id: 11, unitId: 3, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Madre",
            correctAnswer: "Inam",
            points: 10,
            difficulty: "easy",
            explanation: "'Inam' significa 'Madre' en teenek."
        }),
        new Exercise({
            id: 12, unitId: 3, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Padre",
            correctAnswer: "Itat",
            points: 10,
            difficulty: "easy",
            explanation: "'Itat' significa 'Padre' en teenek."
        }),
        new Exercise({
            id: 13, unitId: 3, levelId: 1, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "U ______ (Amigo)",
            correctAnswer: "íits'in",
            placeholder: "Escribe la palabra en teenek",
            points: 15,
            difficulty: "medium",
            explanation: "'U íits'in' significa 'Amigo' en teenek."
        }),
        new Exercise({
            id: 14, unitId: 3, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hermano/a",
            correctAnswer: "Ats'its",
            points: 10,
            difficulty: "easy",
            explanation: "'Ats'its' significa 'Hermano/a' en teenek."
        }),
        new Exercise({
            id: 15, unitId: 3, levelId: 1, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "U ______ (Hijo)",
            correctAnswer: "ch'úupal",
            placeholder: "Escribe la palabra en teenek",
            points: 15,
            difficulty: "medium",
            explanation: "'U ch'úupal' significa 'Hijo' en teenek."
        }),

        // Level 1, Unit 4 - Partes del Cuerpo
        new Exercise({
            id: 16, unitId: 4, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Cabeza",
            correctAnswer: "U yool",
            points: 10,
            difficulty: "easy",
            explanation: "'U yool' significa 'Cabeza' en teenek."
        }),
        new Exercise({
            id: 17, unitId: 4, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mano",
            correctAnswer: "U kab'",
            points: 10,
            difficulty: "easy",
            explanation: "'U kab'' significa 'Mano' en teenek."
        }),
        new Exercise({
            id: 18, unitId: 4, levelId: 1, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "U ______ (Pie)",
            correctAnswer: "wakax",
            placeholder: "Escribe la palabra en teenek",
            points: 15,
            difficulty: "medium",
            explanation: "'U wakax' significa 'Pie' en teenek."
        }),
        new Exercise({
            id: 19, unitId: 4, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Boca",
            correctAnswer: "U chi'",
            points: 10,
            difficulty: "easy",
            explanation: "'U chi'' significa 'Boca' en teenek."
        }),
        new Exercise({
            id: 20, unitId: 4, levelId: 1, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "U ______ (Ojo)",
            correctAnswer: "ich",
            placeholder: "Escribe la palabra en teenek",
            points: 15,
            difficulty: "medium",
            explanation: "'U ich' significa 'Ojo' en teenek."
        }),

        // Level 1, Unit 5 - Animales y Naturaleza
        new Exercise({
            id: 21, unitId: 5, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Pájaro",
            correctAnswer: "Ch'ich'",
            points: 10,
            difficulty: "easy",
            explanation: "'Ch'ich'' significa 'Pájaro' en teenek."
        }),
        new Exercise({
            id: 22, unitId: 5, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Perro",
            correctAnswer: "Peem",
            points: 10,
            difficulty: "easy",
            explanation: "'Peem' significa 'Perro' en teenek."
        }),
        new Exercise({
            id: 23, unitId: 5, levelId: 1, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Gato)",
            correctAnswer: "Misu",
            placeholder: "Escribe la palabra en teenek",
            points: 15,
            difficulty: "medium",
            explanation: "'Misu' significa 'Gato' en teenek."
        }),
        new Exercise({
            id: 24, unitId: 5, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Agua",
            correctAnswer: "Ha'",
            points: 10,
            difficulty: "easy",
            explanation: "'Ha'' significa 'Agua' en teenek."
        }),
        new Exercise({
            id: 25, unitId: 5, levelId: 1, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Árbol)",
            correctAnswer: "Che'",
            placeholder: "Escribe la palabra en teenek",
            points: 15,
            difficulty: "medium",
            explanation: "'Che'' significa 'Árbol' en teenek."
        }),

        // Level 1, Unit 6 - Colores y Formas
        new Exercise({
            id: 26, unitId: 6, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Rojo",
            correctAnswer: "Ch'ooj",
            points: 10,
            difficulty: "easy",
            explanation: "'Ch'ooj' significa 'Rojo' en teenek."
        }),
        new Exercise({
            id: 27, unitId: 6, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Verde",
            correctAnswer: "Yaax",
            points: 10,
            difficulty: "easy",
            explanation: "'Yaax' significa 'Verde' en teenek."
        }),
        new Exercise({
            id: 28, unitId: 6, levelId: 1, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Amarillo)",
            correctAnswer: "K'an",
            placeholder: "Escribe la palabra en teenek",
            points: 15,
            difficulty: "medium",
            explanation: "'K'an' significa 'Amarillo' en teenek."
        }),
        new Exercise({
            id: 29, unitId: 6, levelId: 1, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Negro",
            correctAnswer: "Taab",
            points: 10,
            difficulty: "easy",
            explanation: "'Taab' significa 'Negro' en teenek."
        }),
        new Exercise({
            id: 30, unitId: 6, levelId: 1, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ (Blanco)",
            correctAnswer: "Saak",
            placeholder: "Escribe la palabra en teenek",
            points: 15,
            difficulty: "medium",
            explanation: "'Saak' significa 'Blanco' en teenek."
        }),

        // Level 2, Unit 1 - Preguntas Comunes
        new Exercise({
            id: 31, unitId: 7, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Cómo te llamas?",
            correctAnswer: "Jant' yaan a k'aba",
            points: 15,
            difficulty: "medium",
            explanation: "'Jant' yaan a k'aba' significa literalmente '¿Cómo está tu nombre?'"
        }),
        new Exercise({
            id: 32, unitId: 7, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Dónde estás?",
            correctAnswer: "Jant' teen yaan",
            points: 15,
            difficulty: "medium",
            explanation: "'Jant' teen yaan' significa '¿Dónde estás?'"
        }),
        new Exercise({
            id: 33, unitId: 7, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Cuánto cuesta?",
            correctAnswer: "Jant' u ts'akal",
            points: 15,
            difficulty: "medium",
            explanation: "'Jant' u ts'akal' significa '¿Cuánto su precio?'"
        }),
        new Exercise({
            id: 34, unitId: 7, levelId: 2, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Bix a ______ (¿Cómo amaneciste?)",
            correctAnswer: "wàay",
            placeholder: "Escribe la palabra en teenek",
            points: 20,
            difficulty: "medium",
            explanation: "'Bix a wàay' es un saludo matutino que significa '¿Cómo amaneciste?'"
        }),
        new Exercise({
            id: 35, unitId: 7, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Partícula para preguntas",
            correctAnswer: "Jant'",
            points: 15,
            difficulty: "medium",
            explanation: "'Jant'' es una partícula interrogativa común en teenek."
        }),

        // Level 2, Unit 2 - Expresiones Cotidianas
        new Exercise({
            id: 36, unitId: 8, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Estoy en casa",
            correctAnswer: "Yaan in wotoch",
            points: 15,
            difficulty: "medium",
            explanation: "'Yaan in wotoch' significa literalmente 'Hay mi casa'"
        }),
        new Exercise({
            id: 37, unitId: 8, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "No estoy en casa",
            correctAnswer: "Ma' yaan in wotoch",
            points: 15,
            difficulty: "medium",
            explanation: "'Ma' yaan in wotoch' usa la negación 'ma''"
        }),
        new Exercise({
            id: 38, unitId: 8, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Llegué a casa",
            correctAnswer: "K'uch in wotoch",
            points: 15,
            difficulty: "medium",
            explanation: "'K'uch in wotoch' significa 'Llegué mi casa'"
        }),
        new Exercise({
            id: 39, unitId: 8, levelId: 2, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Tin ______ (Me voy)",
            correctAnswer: "bin",
            placeholder: "Escribe el verbo en teenek",
            points: 20,
            difficulty: "medium",
            explanation: "'Tin bin' significa 'Yo voy' o 'Me voy'"
        }),
        new Exercise({
            id: 40, unitId: 8, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Verbo 'estar' o 'haber'",
            correctAnswer: "Yaan",
            points: 15,
            difficulty: "medium",
            explanation: "'Yaan' es un verbo multifuncional que significa 'estar', 'haber' o 'existir'"
        }),

        // Level 2, Unit 3 - Comida y Alimentos
        new Exercise({
            id: 41, unitId: 9, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Maíz",
            correctAnswer: "Ixim",
            points: 15,
            difficulty: "medium",
            explanation: "'Ixim' significa 'Maíz', alimento básico en la cultura teenek."
        }),
        new Exercise({
            id: 42, unitId: 9, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Calabaza",
            correctAnswer: "Uits",
            points: 15,
            difficulty: "medium",
            explanation: "'Uits' significa 'Calabaza'."
        }),
        new Exercise({
            id: 43, unitId: 9, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Fríjol",
            correctAnswer: "Ch'uhuk",
            points: 15,
            difficulty: "medium",
            explanation: "'Ch'uhuk' significa 'Fríjol'."
        }),
        new Exercise({
            id: 44, unitId: 9, levelId: 2, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "T'uun ______ (Un chile)",
            correctAnswer: "iich",
            placeholder: "Escribe la palabra en teenek",
            points: 20,
            difficulty: "medium",
            explanation: "'Iich' significa 'Chile' en teenek."
        }),
        new Exercise({
            id: 45, unitId: 9, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Agua",
            correctAnswer: "Ha'",
            points: 15,
            difficulty: "medium",
            explanation: "'Ha'' significa 'Agua' en teenek."
        }),

        // Level 2, Unit 4 - Actividades Diarias
        new Exercise({
            id: 46, unitId: 10, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Trabajar",
            correctAnswer: "Meyah",
            points: 15,
            difficulty: "medium",
            explanation: "'Meyah' significa 'Trabajar'."
        }),
        new Exercise({
            id: 47, unitId: 10, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Comer",
            correctAnswer: "A'almaj",
            points: 15,
            difficulty: "medium",
            explanation: "'A'almaj' significa 'Comer'."
        }),
        new Exercise({
            id: 48, unitId: 10, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Dormir",
            correctAnswer: "Wéenel",
            points: 15,
            difficulty: "medium",
            explanation: "'Wéenel' significa 'Dormir'."
        }),
        new Exercise({
            id: 49, unitId: 10, levelId: 2, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Tin ______ (Yo camino)",
            correctAnswer: "ch'ijch'",
            placeholder: "Escribe el verbo en teenek",
            points: 20,
            difficulty: "medium",
            explanation: "'Tin ch'ijch'' significa 'Yo camino'."
        }),
        new Exercise({
            id: 50, unitId: 10, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Prefijo para 'yo'",
            correctAnswer: "Tin",
            points: 15,
            difficulty: "medium",
            explanation: "'Tin' es el prefijo para primera persona singular en presente."
        }),

        // Level 2, Unit 5 - Lugares y Direcciones
        new Exercise({
            id: 51, unitId: 11, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Casa",
            correctAnswer: "Wotoch",
            points: 15,
            difficulty: "medium",
            explanation: "'Wotoch' significa 'Casa'."
        }),
        new Exercise({
            id: 52, unitId: 11, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Casa de alguien",
            correctAnswer: "Nah",
            points: 15,
            difficulty: "medium",
            explanation: "'Nah' se usa para 'casa de' seguido del poseedor."
        }),
        new Exercise({
            id: 53, unitId: 11, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Monte",
            correctAnswer: "K'aax",
            points: 15,
            difficulty: "medium",
            explanation: "'K'aax' significa 'Monte' o 'Bosque'."
        }),
        new Exercise({
            id: 54, unitId: 11, levelId: 2, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Teen ______ (En el pueblo)",
            correctAnswer: "ch'e'en",
            placeholder: "Escribe la palabra en teenek",
            points: 20,
            difficulty: "medium",
            explanation: "'Ch'e'en' significa 'Pueblo'."
        }),
        new Exercise({
            id: 55, unitId: 11, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Partícula 'en'",
            correctAnswer: "Teen",
            points: 15,
            difficulty: "medium",
            explanation: "'Teen' es una partícula locativa que significa 'en'."
        }),

        // Level 2, Unit 6 - Tiempo y Fechas
        new Exercise({
            id: 56, unitId: 12, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Día",
            correctAnswer: "K'iin",
            points: 15,
            difficulty: "medium",
            explanation: "'K'iin' significa 'Día' o 'Sol'."
        }),
        new Exercise({
            id: 57, unitId: 12, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Noche",
            correctAnswer: "Ak'ab",
            points: 15,
            difficulty: "medium",
            explanation: "'Ak'ab' significa 'Noche'."
        }),
        new Exercise({
            id: 58, unitId: 12, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Qué hora es?",
            correctAnswer: "Jant' u k'iin",
            points: 15,
            difficulty: "medium",
            explanation: "'Jant' u k'iin' significa literalmente '¿Cómo el sol?'"
        }),
        new Exercise({
            id: 59, unitId: 12, levelId: 2, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Yaan ______ (Hay lluvia)",
            correctAnswer: "ja'",
            placeholder: "Escribe la palabra en teenek",
            points: 20,
            difficulty: "medium",
            explanation: "'Ja'' significa 'Lluvia'."
        }),
        new Exercise({
            id: 60, unitId: 12, levelId: 2, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Frío",
            correctAnswer: "Sijnal",
            points: 15,
            difficulty: "medium",
            explanation: "'Sijnal' significa 'Frío'."
        }),

        // Level 3, Unit 1 - Verbos de Acción
        new Exercise({
            id: 61, unitId: 13, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Cantar",
            correctAnswer: "K'ay",
            points: 20,
            difficulty: "hard",
            explanation: "'K'ay' significa 'Cantar'."
        }),
        new Exercise({
            id: 62, unitId: 13, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ver",
            correctAnswer: "Wil",
            points: 20,
            difficulty: "hard",
            explanation: "'Wil' significa 'Ver'."
        }),
        new Exercise({
            id: 63, unitId: 13, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Oír",
            correctAnswer: "U'uy",
            points: 20,
            difficulty: "hard",
            explanation: "'U'uy' significa 'Oír'."
        }),
        new Exercise({
            id: 64, unitId: 13, levelId: 3, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "In ______ (Yo canto)",
            correctAnswer: "k'ay",
            placeholder: "Escribe el verbo en teenek",
            points: 25,
            difficulty: "hard",
            explanation: "'In k'ay' significa 'Yo canto'."
        }),
        new Exercise({
            id: 65, unitId: 13, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Prefijo para 'yo' con verbos",
            correctAnswer: "In",
            points: 20,
            difficulty: "hard",
            explanation: "'In' es el prefijo para primera persona singular con verbos de acción."
        }),

        // Level 3, Unit 2 - Verbos de Estado
        new Exercise({
            id: 66, unitId: 14, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Estar",
            correctAnswer: "Yaan",
            points: 20,
            difficulty: "hard",
            explanation: "'Yaan' significa 'Estar', 'Haber' o 'Existir'."
        }),
        new Exercise({
            id: 67, unitId: 14, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Llegar",
            correctAnswer: "K'uch",
            points: 20,
            difficulty: "hard",
            explanation: "'K'uch' significa 'Llegar'."
        }),
        new Exercise({
            id: 68, unitId: 14, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ir",
            correctAnswer: "Bin",
            points: 20,
            difficulty: "hard",
            explanation: "'Bin' significa 'Ir'."
        }),
        new Exercise({
            id: 69, unitId: 14, levelId: 3, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Tin ______ (Yo voy)",
            correctAnswer: "bin",
            placeholder: "Escribe el verbo en teenek",
            points: 25,
            difficulty: "hard",
            explanation: "'Tin bin' significa 'Yo voy'."
        }),
        new Exercise({
            id: 70, unitId: 14, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Venir",
            correctAnswer: "Tal",
            points: 20,
            difficulty: "hard",
            explanation: "'Tal' significa 'Venir'."
        }),

        // Level 3, Unit 3 - Adjetivos y Descripciones
        new Exercise({
            id: 71, unitId: 15, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Grande",
            correctAnswer: "Noj",
            points: 20,
            difficulty: "hard",
            explanation: "'Noj' significa 'Grande'."
        }),
        new Exercise({
            id: 72, unitId: 15, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Pequeño",
            correctAnswer: "Ch'ich'",
            points: 20,
            difficulty: "hard",
            explanation: "'Ch'ich'' significa 'Pequeño'."
        }),
        new Exercise({
            id: 73, unitId: 15, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Rojo",
            correctAnswer: "Ch'ooj",
            points: 20,
            difficulty: "hard",
            explanation: "'Ch'ooj' significa 'Rojo'."
        }),
        new Exercise({
            id: 74, unitId: 15, levelId: 3, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Wotoch ______ (Casa grande)",
            correctAnswer: "noj",
            placeholder: "Escribe el adjetivo en teenek",
            points: 25,
            difficulty: "hard",
            explanation: "En teenek, los adjetivos van después del sustantivo."
        }),
        new Exercise({
            id: 75, unitId: 15, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la posición correcta",
            answer: "Posición del adjetivo",
            correctAnswer: "Después del sustantivo",
            points: 20,
            difficulty: "hard",
            explanation: "En teenek, el adjetivo generalmente va después del sustantivo que modifica."
        }),

        // Level 3, Unit 4 - Pronombres Personales
        new Exercise({
            id: 76, unitId: 16, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Yo",
            correctAnswer: "In",
            points: 20,
            difficulty: "hard",
            explanation: "'In' significa 'Yo'."
        }),
        new Exercise({
            id: 77, unitId: 16, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tú",
            correctAnswer: "A",
            points: 20,
            difficulty: "hard",
            explanation: "'A' significa 'Tú'."
        }),
        new Exercise({
            id: 78, unitId: 16, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Él/Ella",
            correctAnswer: "U",
            points: 20,
            difficulty: "hard",
            explanation: "'U' significa 'Él' o 'Ella'."
        }),
        new Exercise({
            id: 79, unitId: 16, levelId: 3, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ wil (Yo veo)",
            correctAnswer: "In",
            placeholder: "Escribe el pronombre en teenek",
            points: 25,
            difficulty: "hard",
            explanation: "'In wil' significa 'Yo veo'."
        }),
        new Exercise({
            id: 80, unitId: 16, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Nosotros",
            correctAnswer: "K",
            points: 20,
            difficulty: "hard",
            explanation: "'K' significa 'Nosotros'."
        }),

        // Level 3, Unit 5 - Posesivos
        new Exercise({
            id: 81, unitId: 17, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mi casa",
            correctAnswer: "In wotoch",
            points: 20,
            difficulty: "hard",
            explanation: "'In wotoch' significa 'Mi casa'."
        }),
        new Exercise({
            id: 82, unitId: 17, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tu casa",
            correctAnswer: "A wotoch",
            points: 20,
            difficulty: "hard",
            explanation: "'A wotoch' significa 'Tu casa'."
        }),
        new Exercise({
            id: 83, unitId: 17, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Su casa",
            correctAnswer: "U wotoch",
            points: 20,
            difficulty: "hard",
            explanation: "'U wotoch' significa 'Su casa'."
        }),
        new Exercise({
            id: 84, unitId: 17, levelId: 3, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ wotoch (Mi casa)",
            correctAnswer: "In",
            placeholder: "Escribe el posesivo en teenek",
            points: 25,
            difficulty: "hard",
            explanation: "'In' es el posesivo para primera persona singular."
        }),
        new Exercise({
            id: 85, unitId: 17, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Prefijo posesivo para 'mi'",
            correctAnswer: "In",
            points: 20,
            difficulty: "hard",
            explanation: "'In' es el prefijo posesivo para primera persona singular."
        }),

        // Level 3, Unit 6 - Preposiciones y Locativos
        new Exercise({
            id: 86, unitId: 18, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "En",
            correctAnswer: "Teen",
            points: 20,
            difficulty: "hard",
            explanation: "'Teen' significa 'En'."
        }),
        new Exercise({
            id: 87, unitId: 18, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "A/Hacia",
            correctAnswer: "Ti'",
            points: 20,
            difficulty: "hard",
            explanation: "'Ti'' significa 'A' o 'Hacia'."
        }),
        new Exercise({
            id: 88, unitId: 18, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Con",
            correctAnswer: "Ich",
            points: 20,
            difficulty: "hard",
            explanation: "'Ich' significa 'Con'."
        }),
        new Exercise({
            id: 89, unitId: 18, levelId: 3, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "______ wotoch (En casa)",
            correctAnswer: "Teen",
            placeholder: "Escribe la preposición en teenek",
            points: 25,
            difficulty: "hard",
            explanation: "'Teen wotoch' significa 'En casa'."
        }),
        new Exercise({
            id: 90, unitId: 18, levelId: 3, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Partícula 'Y/Con'",
            correctAnswer: "Yetel",
            points: 20,
            difficulty: "hard",
            explanation: "'Yetel' significa 'Y' o 'Con'."
        }),

        // Level 4, Unit 1 - Tiempo y Clima
        new Exercise({
            id: 91, unitId: 19, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sol",
            correctAnswer: "K'iin",
            points: 25,
            difficulty: "hard",
            explanation: "'K'iin' significa 'Sol' o 'Día'."
        }),
        new Exercise({
            id: 92, unitId: 19, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Viento",
            correctAnswer: "Ik'",
            points: 25,
            difficulty: "hard",
            explanation: "'Ik'' significa 'Viento'."
        }),
        new Exercise({
            id: 93, unitId: 19, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Lluvia",
            correctAnswer: "Ja'",
            points: 25,
            difficulty: "hard",
            explanation: "'Ja'' significa 'Lluvia'."
        }),
        new Exercise({
            id: 94, unitId: 19, levelId: 4, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Yaan ______ (Hay frío)",
            correctAnswer: "sijnal",
            placeholder: "Escribe la palabra en teenek",
            points: 30,
            difficulty: "hard",
            explanation: "'Sijnal' significa 'Frío'."
        }),
        new Exercise({
            id: 95, unitId: 19, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Calor",
            correctAnswer: "Ch'uuj",
            points: 25,
            difficulty: "hard",
            explanation: "'Ch'uuj' significa 'Calor'."
        }),

        // Level 4, Unit 2 - Naturaleza y Medio Ambiente
        new Exercise({
            id: 96, unitId: 20, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tierra",
            correctAnswer: "Luum",
            points: 25,
            difficulty: "hard",
            explanation: "'Luum' significa 'Tierra'."
        }),
        new Exercise({
            id: 97, unitId: 20, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Árbol",
            correctAnswer: "Che'",
            points: 25,
            difficulty: "hard",
            explanation: "'Che'' significa 'Árbol'."
        }),
        new Exercise({
            id: 98, unitId: 20, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Agua",
            correctAnswer: "Ha'",
            points: 25,
            difficulty: "hard",
            explanation: "'Ha'' significa 'Agua'."
        }),
        new Exercise({
            id: 99, unitId: 20, levelId: 4, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Teen ______ (En el monte)",
            correctAnswer: "k'aax",
            placeholder: "Escribe la palabra en teenek",
            points: 30,
            difficulty: "hard",
            explanation: "'K'aax' significa 'Monte' o 'Bosque'."
        }),
        new Exercise({
            id: 100, unitId: 20, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tierra roja",
            correctAnswer: "Luum ch'ooj",
            points: 25,
            difficulty: "hard",
            explanation: "'Luum ch'ooj' significa 'Tierra roja'."
        }),

        // Level 4, Unit 3 - Tradiciones y Costumbres
        new Exercise({
            id: 101, unitId: 21, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Lengua teenek",
            correctAnswer: "Báayal u baats'",
            points: 25,
            difficulty: "hard",
            explanation: "'Báayal u baats'' significa 'Lengua teenek'."
        }),
        new Exercise({
            id: 102, unitId: 21, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Esencia de la palabra",
            correctAnswer: "U yool u baats'",
            points: 25,
            difficulty: "hard",
            explanation: "'U yool u baats'' es un concepto cultural importante."
        }),
        new Exercise({
            id: 103, unitId: 21, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Corazón del pueblo",
            correctAnswer: "Ch'een u yool",
            points: 25,
            difficulty: "hard",
            explanation: "'Ch'een u yool' significa 'Corazón del pueblo'."
        }),
        new Exercise({
            id: 104, unitId: 21, levelId: 4, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "Báayal u ______ (Mucha sabiduría)",
            correctAnswer: "ts'íibil",
            placeholder: "Escribe la palabra en teenek",
            points: 30,
            difficulty: "hard",
            explanation: "'Ts'íibil' significa 'Sabiduría'."
        }),
        new Exercise({
            id: 105, unitId: 21, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mano del corazón",
            correctAnswer: "U k'ab u yool",
            points: 25,
            difficulty: "hard",
            explanation: "'U k'ab u yool' es una expresión cultural que significa 'Mano del corazón'."
        }),

        // Level 4, Unit 4 - Ceremonias y Rituales
        new Exercise({
            id: 106, unitId: 22, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ceremonia",
            correctAnswer: "U ch'een",
            points: 25,
            difficulty: "hard",
            explanation: "'U ch'een' significa 'Ceremonia'."
        }),
        new Exercise({
            id: 107, unitId: 22, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ofrenda",
            correctAnswer: "U yumil",
            points: 25,
            difficulty: "hard",
            explanation: "'U yumil' significa 'Ofrenda'."
        }),
        new Exercise({
            id: 108, unitId: 22, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Canto ceremonial",
            correctAnswer: "U k'ay",
            points: 25,
            difficulty: "hard",
            explanation: "'U k'ay' significa 'Canto ceremonial'."
        }),
        new Exercise({
            id: 109, unitId: 22, levelId: 4, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "U ______ (Palabra sagrada)",
            correctAnswer: "baats'",
            placeholder: "Escribe la palabra en teenek",
            points: 30,
            difficulty: "hard",
            explanation: "'U baats'' significa 'Palabra sagrada'."
        }),
        new Exercise({
            id: 110, unitId: 22, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Corazón/Esencia",
            correctAnswer: "U yool",
            points: 25,
            difficulty: "hard",
            explanation: "'U yool' significa 'Corazón' o 'Esencia' en contextos ceremoniales."
        }),

        // Level 4, Unit 5 - Artesanías y Oficios
        new Exercise({
            id: 111, unitId: 23, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Trabajo",
            correctAnswer: "U meyah",
            points: 25,
            difficulty: "hard",
            explanation: "'U meyah' significa 'Trabajo'."
        }),
        new Exercise({
            id: 112, unitId: 23, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tejer",
            correctAnswer: "U ch'ay",
            points: 25,
            difficulty: "hard",
            explanation: "'U ch'ay' significa 'Tejer'."
        }),
        new Exercise({
            id: 113, unitId: 23, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sembrar",
            correctAnswer: "U pak'",
            points: 25,
            difficulty: "hard",
            explanation: "'U pak'' significa 'Sembrar'."
        }),
        new Exercise({
            id: 114, unitId: 23, levelId: 4, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "U ______ (Flor)",
            correctAnswer: "lool",
            placeholder: "Escribe la palabra en teenek",
            points: 30,
            difficulty: "hard",
            explanation: "'U lool' significa 'Flor'."
        }),
        new Exercise({
            id: 115, unitId: 23, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Escritura",
            correctAnswer: "U ts'íib",
            points: 25,
            difficulty: "hard",
            explanation: "'U ts'íib' significa 'Escritura'."
        }),

        // Level 4, Unit 6 - Medicina Tradicional
        new Exercise({
            id: 116, unitId: 24, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Remedio",
            correctAnswer: "U ts'ak",
            points: 25,
            difficulty: "hard",
            explanation: "'U ts'ak' significa 'Remedio'."
        }),
        new Exercise({
            id: 117, unitId: 24, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Curación",
            correctAnswer: "U meyah",
            points: 25,
            difficulty: "hard",
            explanation: "'U meyah' también puede significar 'Curación' en contextos médicos."
        }),
        new Exercise({
            id: 118, unitId: 24, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Salud",
            correctAnswer: "U yool",
            points: 25,
            difficulty: "hard",
            explanation: "'U yool' significa 'Salud' en contextos médicos."
        }),
        new Exercise({
            id: 119, unitId: 24, levelId: 4, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "U ______ (Planta medicinal)",
            correctAnswer: "ch'uhuk",
            placeholder: "Escribe la palabra en teenek",
            points: 30,
            difficulty: "hard",
            explanation: "'U ch'uhuk' significa 'Planta medicinal'."
        }),
        new Exercise({
            id: 120, unitId: 24, levelId: 4, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mano (para curar)",
            correctAnswer: "U k'ab",
            points: 25,
            difficulty: "hard",
            explanation: "'U k'ab' puede referirse a la 'mano curandera' en contextos de medicina tradicional."
        }),

        // Level 5, Unit 1 - Expresiones Culturales
        new Exercise({
            id: 121, unitId: 25, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "La esencia de la palabra",
            correctAnswer: "U yool u baats'",
            points: 30,
            difficulty: "expert",
            explanation: "'U yool u baats'' es una expresión cultural profunda."
        }),
        new Exercise({
            id: 122, unitId: 25, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Corazón del pueblo",
            correctAnswer: "Ch'een u yool",
            points: 30,
            difficulty: "expert",
            explanation: "'Ch'een u yool' representa la identidad cultural teenek."
        }),
        new Exercise({
            id: 123, unitId: 25, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mucha sabiduría",
            correctAnswer: "Báayal u ts'íibil",
            points: 30,
            difficulty: "expert",
            explanation: "'Báayal u ts'íibil' significa 'Mucha sabiduría'."
        }),
        new Exercise({
            id: 124, unitId: 25, levelId: 5, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "U k'ab u ______ (La mano del corazón)",
            correctAnswer: "yool",
            placeholder: "Escribe la palabra en teenek",
            points: 35,
            difficulty: "expert",
            explanation: "'U k'ab u yool' es una expresión metafórica importante."
        }),
        new Exercise({
            id: 125, unitId: 25, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la característica principal",
            answer: "Característica expresiones culturales",
            correctAnswer: "Metáforas y referencias a la naturaleza",
            points: 30,
            difficulty: "expert",
            explanation: "Las expresiones culturales teenek usan abundantemente metáforas basadas en la naturaleza."
        }),

        // Level 5, Unit 2 - Poesía y Cantos
        new Exercise({
            id: 126, unitId: 26, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Canto",
            correctAnswer: "U k'ay",
            points: 30,
            difficulty: "expert",
            explanation: "'U k'ay' significa 'Canto' en contextos poéticos."
        }),
        new Exercise({
            id: 127, unitId: 26, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Palabra",
            correctAnswer: "U baats'",
            points: 30,
            difficulty: "expert",
            explanation: "'U baats'' significa 'Palabra'."
        }),
        new Exercise({
            id: 128, unitId: 26, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Corazón",
            correctAnswer: "U yool",
            points: 30,
            difficulty: "expert",
            explanation: "'U yool' significa 'Corazón'."
        }),
        new Exercise({
            id: 129, unitId: 26, levelId: 5, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "U ______ (Flor)",
            correctAnswer: "lool",
            placeholder: "Escribe la palabra en teenek",
            points: 35,
            difficulty: "expert",
            explanation: "'U lool' significa 'Flor', símbolo común en la poesía teenek."
        }),
        new Exercise({
            id: 130, unitId: 26, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la característica principal",
            answer: "Recursos poesía teenek",
            correctAnswer: "Paralelismos y metáforas naturales",
            points: 30,
            difficulty: "expert",
            explanation: "La poesía teenek tradicional usa paralelismos sintácticos y metáforas basadas en la naturaleza."
        }),

        // Level 5, Unit 3 - Filosofía Teenek
        new Exercise({
            id: 131, unitId: 27, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Esencia",
            correctAnswer: "U yoolil",
            points: 30,
            difficulty: "expert",
            explanation: "'U yoolil' significa 'Esencia'."
        }),
        new Exercise({
            id: 132, unitId: 27, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sabiduría",
            correctAnswer: "U ts'íibil",
            points: 30,
            difficulty: "expert",
            explanation: "'U ts'íibil' significa 'Sabiduría'."
        }),
        new Exercise({
            id: 133, unitId: 27, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Lenguaje",
            correctAnswer: "U baats'il",
            points: 30,
            difficulty: "expert",
            explanation: "'U baats'il' significa 'Lenguaje'."
        }),
        new Exercise({
            id: 134, unitId: 27, levelId: 5, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "U k'ab ______ (Acción)",
            correctAnswer: "il",
            placeholder: "Escribe el sufijo en teenek",
            points: 35,
            difficulty: "expert",
            explanation: "El sufijo '-il' se usa para formar términos abstractos."
        }),
        new Exercise({
            id: 135, unitId: 27, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sufijo conceptos abstractos",
            correctAnswer: "-il",
            points: 30,
            difficulty: "expert",
            explanation: "El sufijo '-il' se usa para formar términos abstractos en filosofía teenek."
        }),

        // Level 5, Unit 4 - Lenguaje Formal
        new Exercise({
            id: 136, unitId: 28, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Señor (formal)",
            correctAnswer: "U yum",
            points: 30,
            difficulty: "expert",
            explanation: "'U yum' es la forma respetuosa para 'Señor'."
        }),
        new Exercise({
            id: 137, unitId: 28, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Señora (formal)",
            correctAnswer: "U na'",
            points: 30,
            difficulty: "expert",
            explanation: "'U na'' es la forma respetuosa para 'Señora'."
        }),
        new Exercise({
            id: 138, unitId: 28, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Respetado",
            correctAnswer: "U ch'een",
            points: 30,
            difficulty: "expert",
            explanation: "'U ch'een' significa 'Respetado'."
        }),
        new Exercise({
            id: 139, unitId: 28, levelId: 5, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "U ______ (Honorable)",
            correctAnswer: "yool",
            placeholder: "Escribe la palabra en teenek",
            points: 35,
            difficulty: "expert",
            explanation: "'U yool' puede significar 'Honorable' en contextos formales."
        }),
        new Exercise({
            id: 140, unitId: 28, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la característica principal",
            answer: "Característica lenguaje formal",
            correctAnswer: "Formas reverenciales y construcciones complejas",
            points: 30,
            difficulty: "expert",
            explanation: "El lenguaje formal teenek usa formas reverenciales y estructuras gramaticales más complejas."
        }),

        // Level 5, Unit 5 - Variaciones Dialectales
        new Exercise({
            id: 141, unitId: 29, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Dialecto",
            correctAnswer: "U baats'il",
            points: 30,
            difficulty: "expert",
            explanation: "'U baats'il' puede significar 'Dialecto'."
        }),
        new Exercise({
            id: 142, unitId: 29, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Variante",
            correctAnswer: "U yool",
            points: 30,
            difficulty: "expert",
            explanation: "'U yool' puede significar 'Variante'."
        }),
        new Exercise({
            id: 143, unitId: 29, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Pronunciación",
            correctAnswer: "U k'ay",
            points: 30,
            difficulty: "expert",
            explanation: "'U k'ay' puede significar 'Pronunciación'."
        }),
        new Exercise({
            id: 144, unitId: 29, levelId: 5, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "U ______ (Escritura)",
            correctAnswer: "ts'íib",
            placeholder: "Escribe la palabra en teenek",
            points: 35,
            difficulty: "expert",
            explanation: "'U ts'íib' significa 'Escritura'."
        }),
        new Exercise({
            id: 145, unitId: 29, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la característica principal",
            answer: "Aspectos que varían entre variantes",
            correctAnswer: "Fonología y léxico",
            points: 30,
            difficulty: "expert",
            explanation: "Las variaciones dialectales afectan principalmente la pronunciación y el vocabulario."
        }),

        // Level 5, Unit 6 - Documentación Lingüística
        new Exercise({
            id: 146, unitId: 30, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Documento",
            correctAnswer: "U ts'íibal",
            points: 30,
            difficulty: "expert",
            explanation: "'U ts'íibal' significa 'Documento'."
        }),
        new Exercise({
            id: 147, unitId: 30, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Texto",
            correctAnswer: "U baats'al",
            points: 30,
            difficulty: "expert",
            explanation: "'U baats'al' significa 'Texto'."
        }),
        new Exercise({
            id: 148, unitId: 30, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Grabación",
            correctAnswer: "U k'ayal",
            points: 30,
            difficulty: "expert",
            explanation: "'U k'ayal' significa 'Grabación'."
        }),
        new Exercise({
            id: 149, unitId: 30, levelId: 5, language: "tkoc",
            type: "fill-blank",
            question: "Completa la frase",
            answer: "U ______ (Video)",
            correctAnswer: "wilal",
            placeholder: "Escribe la palabra en teenek",
            points: 35,
            difficulty: "expert",
            explanation: "'U wilal' significa 'Video'."
        }),
        new Exercise({
            id: 150, unitId: 30, levelId: 5, language: "tkoc",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Análisis",
            correctAnswer: "U yoolil",
            points: 30,
            difficulty: "expert",
            explanation: "'U yoolil' puede significar 'Análisis' en contextos de documentación lingüística."
        })
    ],
};