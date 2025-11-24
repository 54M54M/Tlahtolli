/*

Hay un bug en quicklevel, fill-blanks

*/

import { Level } from '../../models/Level.js';
import { Unit } from '../../models/Unit.js';
import { Exercise } from '../../models/Exercise.js';

// ================= PALETA DE COLORES CONSISTENTE =================
const COLOR_PALETTE = {
    GREEN: '#4bb101',   // verde vibrante
    BLUE: '#1CB0F6',    // azul brillante
    ORANGE: '#FF9600',  // naranja vivo
    RED: '#FF4B4B',     // rojo brillante
    TEAL: '#26CCC0',    // turquesa vibrante
    PURPLE: '#9C27B0',  // magenta apagado
};

// ================= FUNCIONES AUXILIARES =================
function getVocabularyByWords(language, words) {
    const vocabulary = VOCABULARY_DATA[language];
    const result = {};

    if (vocabulary && words) {
        words.forEach(word => {
            if (vocabulary[word]) {
                result[word] = vocabulary[word];
            }
        });
    }

    return result;
}

// ================= /LEVELS/{ID} =================
/* HAY QUE ARREGLAR LOS EJERCICIOS, YA QUE MUCHAS PALABRAS SE CORRIJIERON */
export const LEVELS_DATA = {
    // NAHUATL CENTRAL
    nhce: [
        new Level({
            id: 1, language: "nhce", title: "Saluda y preséntate",
            titleSpanish: "Saluda y preséntate", titleNative: "Tiquilnamiqui ihuan timitstlania",
            description: "Aprende los saludos básicos y cómo presentarte",
            color: COLOR_PALETTE.GREEN, units: 6, completedUnits: 0, locked: false,
            unlockRequirement: "Ninguno - Nivel inicial", order: 1
        }),
        new Level({
            id: 2, language: "nhce", title: "Describete y describe a tu familia",
            titleSpanish: "Describete y describe a tu familia", titleNative: "Timitstlania ihuan timitstlania in mocencal",
            description: "Aprende a describirte a ti mismo y a tu familia",
            color: COLOR_PALETTE.BLUE, units: 6, completedUnits: 0, locked: true,
            unlockRequirement: "Completar Nivel 1", order: 2
        }),
        new Level({
            id: 3, language: "nhce", title: "Pide y da información",
            titleSpanish: "Pide y da información", titleNative: "Tlatlatlauhtia ihuan titlanana",
            description: "Aprende a hacer preguntas y dar información básica",
            color: COLOR_PALETTE.ORANGE, units: 6, completedUnits: 0, locked: true,
            unlockRequirement: "Completar Nivel 2", order: 3
        }),
        new Level({
            id: 4, language: "nhce", title: "Habla en tiempos (ayer/hoy/mañana)",
            titleSpanish: "Habla en tiempos (ayer/hoy/mañana)", titleNative: "Tlahtoa ipan cahuitl (yalhua/axan/moztla)",
            description: "Aprende a hablar sobre el pasado, presente y futuro",
            color: COLOR_PALETTE.RED, units: 6, completedUnits: 0, locked: true,
            unlockRequirement: "Completar Nivel 3", order: 4
        }),
        new Level({
            id: 5, language: "nhce", title: "Describe un día normal",
            titleSpanish: "Describe un día normal", titleNative: "Timitstlani ce tonalli neneuhqui",
            description: "Aprende a describir tu rutina diaria",
            color: COLOR_PALETTE.TEAL, units: 6, completedUnits: 0, locked: true,
            unlockRequirement: "Completar Nivel 4", order: 5
        }),
        new Level({
            id: 6, language: "nhce", title: "Describe y expresa preferencias",
            titleSpanish: "Describe y expresa preferencias", titleNative: "Timitstlania ihuan tiquixtia in tlen ticneltoca",
            description: "Aprende a expresar preferencias y deseos",
            color: COLOR_PALETTE.PURPLE, units: 6, completedUnits: 0, locked: true,
            unlockRequirement: "Completar Nivel 5", order: 6
        }),
    ],
};

// ================= VOCABULARIO =================
export const VOCABULARY_DATA = {
    // NAHUATL
    nhce: {
        // SALUDOS Y CORTESÍAS
        "Cualli": { translation: "bien / bueno / buenos / buena / buenas / bien", pronunciation: "kwal-li" },
        "Tonalli": { translation: "dia / día / dias / días", pronunciation: "to-nal-li" },
        "Yohual": { translation: "noche / noches", pronunciation: "yo-wal" },
        "Teotlac": { translation: "tarde / tardes", pronunciation: "te-o-tlak" },
        "Niltze": { translation: "hola", pronunciation: "nil-tse" },
        "Timoittazceh": { translation: "adiós / hasta luego / nos vemos", pronunciation: "ti-mo-i-ta-se" },

        "Tlazohcamati": { translation: "gracias", pronunciation: "tla-so-ka-ma-ti" },
        "Titlazohcamatiz": { translation: "agradecer / agradecerás / darás gracias", pronunciation: "ni-tla-zóh-ka-ma-tis" },
        "Nitlazohcamatiz": { translation: "agradeceré / daré gracias", pronunciation: "ni-tla-zóh-ka-ma-tis" },
        "Onitlazohcamati": { translation: "agradecí", pronunciation: "o-ni-tla-so-ka-ma-ti" },
        "Nitlazohcamati": { translation: "yo agradezco / doy gracias", pronunciation: "ni-tla-so-ka-ma-ti" },
        "Xitlazohcamati": { translation: "agradece / da gracias", pronunciation: "shi-tla-so-ka-ma-ti" },

        "Nimitztlatlauhtia": { translation: "por favor", pronunciation: "Ni-mits-tlatla-utia" },

        "Quēmah": { translation: "sí", pronunciation: "kee-maj" },

        "Ahmo": { translation: "no", pronunciation: "aj-mo" },
        "Ahmotlen": { translation: "nada / ninguna cosa", pronunciation: "ah-mo-tlen" },
        "Ahmo cualli": { translation: "mal / no bien", pronunciation: "ah-mo-kwal-li" },

        // PRONOMBRES PERSONALES
        "Nehuatl": { translation: "yo", pronunciation: "ne-watl" },
        "Tehuatl": { translation: "tú", pronunciation: "te-watl" },
        "Yehuatl": { translation: "él / ella", pronunciation: "ye-watl" },
        "Yehuan": { translation: "ellos / ellas", pronunciation: "ye-wan" },
        "Anmehuan": { translation: "ustedes", pronunciation: "an-me-wan" },
        "Tehuan": { translation: "nosotros", pronunciation: "te-wan" },

        // FAMILIA Y PERSONAS
        "Cencalli": { translation: "familia", pronunciation: "sen-kal" },
        "Nocencal": { translation: "mi familia", pronunciation: "no-sen-kal" },
        "Ticencal": { translation: "tu familia", pronunciation: "ti-sen-kal" },
        "Mocencal": { translation: "su familia", pronunciation: "mo-sen-kal" },

        "Tahtli": { translation: "padre / papá", pronunciation: "taj-tli" },
        "Notahtli": { translation: "mi padre / mi papá", pronunciation: "no-taj-tli" },
        "Motahtli": { translation: "tu padre / tu papá", pronunciation: "mo-taj-tli" },

        "Nantli": { translation: "madre / mamá", pronunciation: "nan-tli" },
        "Nonantli": { translation: "mi madre / mi mamá", pronunciation: "no-nan-tli" },
        "Monantli": { translation: "tu madre / tu mamá", pronunciation: "mo-nan-tli" },

        "Icniuh": { translation: "hermano / hermana / primo / prima / amigo / amiga", pronunciation: "ik-niw-tli" },
        "Icniuhtli": { translation: "hermano / hermana / primo / prima / amigo / amiga", pronunciation: "ik-niw-tli" },
        "Noicniuh": { translation: "mi hermano / mi hermana / mi primo / mi prima / mi amigo / mi amiga", pronunciation: "no-ik-ni-uj" },
        "Moicniuh": { translation: "tu hermano / tu hermana / tu primo / tu prima / tu amigo / tu amiga", pronunciation: "mo-ik-ni-uj" },
        "Ioicniuh": { translation: "su hermano / su hermana / su primo / su prima / su amigo / su amiga", pronunciation: "yo-ik-ni-uj" },

        "Nocihtzin": { translation: "mi hermana menor / mi hermanita", pronunciation: "no-sich-tzin" },

        "Telpochtli": { translation: "joven / muchacho / adolescente", pronunciation: "tel-potch-tli" },
        "Ichpochtli": { translation: "joven / muchacha / doncella", pronunciation: "ich-potch-tli" },

        "Huehue": { translation: "anciano / viejo / hombre mayor", pronunciation: "we-we" },
        "Ilamatl": { translation: "anciana / vieja / mujer mayor", pronunciation: "i-la-mat" },

        "Coltzin": { translation: "abuelo", pronunciation: "kol-tzin" },
        "Cihtzin": { translation: "abuela", pronunciation: "si-tzin" },

        "Tocaitl": { translation: "nombre", pronunciation: "to-ka-itl" },
        "Notoca": { translation: "me llamo...", pronunciation: "no-to-ka" },
        "Motoca": { translation: "te llamas", pronunciation: "mo-to-ka" },
        "Quen motoca": { translation: "cómo te llamas", pronunciation: "ken-mo-to-ka" },

        "Tlacatl": { translation: "persona", pronunciation: "tla-katl" },

        "Tlamatini": { translation: "sabio / conocedor", pronunciation: "tla-ma-ti-ni" },

        // ADJETIVOS Y DESCRIPCIONES
        "Huey": { translation: "grande", pronunciation: "wey" },
        "Tepiton": { translation: "pequeño", pronunciation: "te-pi-ton" },

        "Chicahuac": { translation: "fuerte  / robusto", pronunciation: "chi-ka-wak" },

        "Cuacualtzin": { translation: "hermosa / hermoso / bella / bello / bonita / bonito", pronunciation: "kwa-kwal-tzin" },

        "Melahuac": { translation: "verdadero / cierto / correcto", pronunciation: "me-la-wak" },

        "Miac": { translation: "mucho / muchos / muchas", pronunciation: "mi-ak" },
        "Huel": { translation: "muy / verdaderamente", pronunciation: "wel" },
        "Huel miac": { translation: "muchísimo / muchísimos / muchísimas", pronunciation: "wel-mi-ak" },

        // PALABRAS INTERROGATIVAS
        "Tlen": { translation: "qué / lo que", pronunciation: "tlen" },
        "Ica": { translation: "por", pronunciation: "i-ka" },
        "Tleca": { translation: "porque / porqué / por que / por qué", pronunciation: "tle-ka" },

        "Quen": { translation: "como", pronunciation: "ken" },          // comparativa
        "Quenin": { translation: "cómo", pronunciation: "ke-nin" },     // interrogativo - explicativo

        "Queman": { translation: "cuando / cuándo", pronunciation: "ke-man" },

        "Aquin": { translation: "quien / quién", pronunciation: "a-kin" },

        "Canin": { translation: "donde / dónde", pronunciation: "ka-nin" },

        // VERBOS
        "Chihua": { translation: "hace / hacer", pronunciation: "chi-wa" },
        "Quichihua": { translation: "él hace / ella hace", pronunciation: "ki-chi-wa" },
        "Chihuaz": { translation: "hará / haré", pronunciation: "chi-was" },
        "Quichihuaz": { translation: "hará / él hará / ella hará", pronunciation: "ki-chi-waz" }, // sin objeto, más general
        "Nicchihua": { translation: "yo hago", pronunciation: "nik-chi-wa" },
        "Nichihuaz": { translation: "yo haré", pronunciation: "ni-chi-waz" },
        "Tichihua": { translation: "tú haces", pronunciation: "ti-chi-wa" }, // sin objeto, más general
        "Ticchihua": { translation: "tú lo haces", pronunciation: "tik-chi-wa" }, // con objeto
        "Tichihuaz": { translation: "harás / tu harás", pronunciation: "ti-chi-waz" }, // sin objeto, más general
        "Ticchihuaz": { translation: "tú lo harás", pronunciation: "tik-chi-waz" }, // con objeto
        "Onicchihua": { translation: "yo lo hice", pronunciation: "o-nik-chi-wa" },
        "Otichihua": { translation: "hiciste / tú hiciste", pronunciation: "o-ti-chi-wa" },
        "Ochihua": { translation: "hizo / él hizo / ella hizo", pronunciation: "o-chi-wa" },
        "Oquichihua": { translation: "él lo hizo / ella lo hizo", pronunciation: "o-ki-chi-wa" }, // con objeto
        "Mochihua": { translation: "se hace / se hace algo", pronunciation: "mo-chi-wa" },
        "Nicchihuaz": { translation: "yo haré", pronunciation: "nik-chi-was" },
        "Xicchihua": { translation: "haz / hazlo", pronunciation: "shik-chi-wa" },

        "Tlacua": { translation: "comer", pronunciation: "tla-kwa" },
        "Nitlacua": { translation: "yo como", pronunciation: "ni-tla-kwa" },
        "Motlacua": { translation: "tú comes", pronunciation: "mo-tla-kwa" },
        "Quitlacua": { translation: "come / él come / ella come", pronunciation: "ki-tla-kwa" },
        "Titlacuaceh": { translation: "nosotros comemos", pronunciation: "ti-tla-kwas" },
        "Nitlacuaz": { translation: "comeré", pronunciation: "ni-tla-kwas" },
        "Quitlacuaz": { translation: "comerá / él comerá / ella comerá", pronunciation: "ki-tla-kwas" },
        "Titlacuaz": { translation: "comerás", pronunciation: "ti-tla-kwas" },
        "Xictlacua": { translation: "come / cómelo", pronunciation: "shik-tla-kwa" },
        "Titlacua": { translation: "comes / tú comes", pronunciation: "ti-tla-kwa" },
        "Tlacuaz": { translation: "comerá", pronunciation: "tla-kwas" },
        "Tictlacua": { translation: "comemos", pronunciation: "tik-tla-kwa" },
        "Nictlacua": { translation: "yo como", pronunciation: "nik-tla-kwa" },
        "Nictlacuaz": { translation: "yo comeré", pronunciation: "nik-tla-kwas" },

        "Cochi": { translation: "dormir", pronunciation: "ko-chi" },
        "Ticochi": { translation: "duermes", pronunciation: "ti-ko-chi" },
        "Nicochi": { translation: "duermo / yo duermo", pronunciation: "ni-ko-chi" },
        "Nicochiz": { translation: "yo dormiré", pronunciation: "ni-ko-chi" },
        "Ticochih": { translation: "dormimos", pronunciation: "ti-ko-chij" },
        "Xicochi": { translation: "tu duerme", pronunciation: "shi-ko-chi" },
        "Xicochih": { translation: "ustedes duerman", pronunciation: "shi-ko-chij" },
        "Ticochiceh": { translation: "dormimos", pronunciation: "ti-ko-chi-se" },
        "Niccochi": { translation: "yo duermo", pronunciation: "nik-ko-chi" },
        "Ximocochi": { translation: "duérmete", pronunciation: "shi-mo-ko-chi" },

        "Itta": { translation: "ver", pronunciation: "it-ta" },
        "Niquitta": { translation: "yo lo veo", pronunciation: "ni-kit-ta" },
        "Oniquittac": { translation: "yo lo vi", pronunciation: "o-ni-kit-tak" },
        "Onechittac": { translation: "me vio", pronunciation: "o-ne-chit-tak" },
        "Nimitzittaz": { translation: "te veré", pronunciation: "ni-mit-sit-tas" },
        "Oquittac": { translation: "vio / él lo vio / ella lo vio", pronunciation: "o-kit-tak" },
        "Quittaz": { translation: "él lo vera / ella lo verá", pronunciation: "kit-tas" },

        "Ca": { translation: "está / existe", pronunciation: "ka" },
        "Cac": { translation: "están / existen", pronunciation: "kak" },
        "Tica": { translation: "estás", pronunciation: "ti-ka" },
        "Ticaz": { translation: "estarás", pronunciation: "ti-kas" },
        "Nicac": { translation: "estoy", pronunciation: "ni-kak" },
        "Icacāh": { translation: "están", pronunciation: "i-ka-kaa" },
        "Onica": { translation: "yo estuve", pronunciation: "o-ni-ka" },
        "Ticah": { translation: "estamos", pronunciation: "ti-kaj" },
        "Nicaz": { translation: "estaré", pronunciation: "ni-kas" },
        "Icaz": { translation: "estará", pronunciation: "i-kas" },
        "Otica": { translation: "tú estuviste", pronunciation: "o-ti-ka" },
        "Oca": { translation: "él estuvo / ella estuvo", pronunciation: "o-ka" },

        // TIEMPOS Y UBICACIONES
        "Yalhua": { translation: "ayer", pronunciation: "yal-wa" },
        "Axan": { translation: "hoy", pronunciation: "a-shan" },
        "Moztla": { translation: "mañana", pronunciation: "mos-tla" },
        "Ye": { translation: "ahora", pronunciation: "ye" },

        "Ompa": { translation: "allá / alla / allí / alli", pronunciation: "om-pa" },
        "Ipan": { translation: "en / sobre", pronunciation: "i-pan" },

        // PARTÍCULAS Y CONECTORES
        "Oc": { translation: "más / todavía / aún", pronunciation: "ok" },
        "Ahmo oc": { translation: "menos / ya no", pronunciation: "aj-mo-ok" },

        "Monequi": { translation: "es necesario / se necesita", pronunciation: "mo-ne-ki" },
        "Oc monequi": { translation: "Todavía tengo que.. / Aún tengo que..", pronunciation: "ok-mo-ne-ki" },

        "Iuan": { translation: "con / y", pronunciation: "i-wan" },
        "Nechpa": { translation: "conmigo", pronunciation: "nech-pa" },
        "Ic": { translation: "asi / con eso", pronunciation: "ik" },
        "inīn": { translation: "este / esta / esto", pronunciation: "in-iín" },
        "inīn quen": { translation: "de esta manera", pronunciation: "in-iin-ken" },

        "Ahzo": { translation: "tal vez / quizás / probablemente", pronunciation: "a-so" },

        "Mitz": { translation: " te / a ti", pronunciation: "mits" },

        "Tla": { translation: "algo / cosa", pronunciation: "tla" },

        // SUFIJOS Y PREFIJOS
        "No": { translation: "mi / mio (1ª persona singular - posesivo)", pronunciation: "no-" },
        "Ni": { translation: "yo (1ª persona singular - acción)", pronunciation: "ni-" },
        "Ne": { translation: "a mí / me (1ª persona singular - objeto)", pronunciation: "ne-" },

        "Mo": { translation: "tú / tuyo (2ª persona singular - posesivo)", pronunciation: "mo-" },
        "Ti": { translation: "tu (2ª persona singular - acción)", pronunciation: "ti-" },
        "Mitz": { translation: "a ti / te (2ª persona singular - objeto)", pronunciation: "mits-" },
        "An": { translation: "ustedes (2ª persona plural)", pronunciation: "an-" },

        "Qui": { translation: "él / ella (3ª persona singular - transitivos)", pronunciation: "ki-" },
        "I": { translation: "su / suyo (3ª persona singular - posesivo)", pronunciation: "i-" },
        "In": { translation: "ellos / ellas (3ª persona plural - posesivo)", pronunciation: "in-" },

        "O": { translation: "prefijo pasado", pronunciation: "o-" },
        "Z": { translation: "sufijo fururo", pronunciation: "-z" },
        "Xi": { translation: "prefijo imperativo", pronunciation: "shi-" },
        "Ceh": { translation: "sufijo plural", pronunciation: "-se" }, // -ar -> -amos || -er -ir -> -imos
        "Te": { translation: "a alguien / de alguien (prefijo objeto/posesivo indefinido)", pronunciation: "te-" },

        // NOMBRES PERSONALES
        "Citlalli": { translation: "estrella", pronunciation: "si-tla-li" },
        "Xóchitl": { translation: "flor", pronunciation: "sho-chi-tl" },
    },
};

// ================= /LEVELS/{ID}/UNITS/{ID} =================
export const UNITS_DATA = {
    // NAHUATL
    nhce: [
        // Nivel 1 - Saluda y preséntate
        new Unit({
            id: 1, levelId: 1, language: "nhce",
            title: "Saludos básicos", color: COLOR_PALETTE.GREEN,
            completed: false, locked: false, current: true,
            objective: "Aprender saludos básicos del día y la noche",
            grammar: "Estructura básica de saludos",
            vocabulary: {}
        }),
        new Unit({
            id: 2, levelId: 1, language: "nhce",
            title: "Presentaciones simples", color: COLOR_PALETTE.GREEN,
            completed: false, locked: true, current: false,
            objective: "Aprender a presentarse y despedirse",
            grammar: "Uso de Niltze y Timoittazceh",
            vocabulary: {}
        }),
        new Unit({
            id: 3, levelId: 1, language: "nhce",
            title: "Cómo te llamas", color: COLOR_PALETTE.GREEN,
            completed: false, locked: true, current: false,
            objective: "Aprender a preguntar y decir nombres",
            grammar: "Uso de Notoca y Quen motoca",
            vocabulary: {}
        }),
        new Unit({
            id: 4, levelId: 1, language: "nhce",
            title: "Expresar gratitud", color: COLOR_PALETTE.GREEN,
            completed: false, locked: true, current: false,
            objective: "Aprender a dar las gracias",
            grammar: "Uso de Tlazohcamati y Miac",
            vocabulary: {}
        }),
        new Unit({
            id: 5, levelId: 1, language: "nhce",
            title: "Estados y condiciones", color: COLOR_PALETTE.GREEN,
            completed: false, locked: true, current: false,
            objective: "Aprender a expresar cómo estás",
            grammar: "Uso de Tica, Nicac y Huel",
            vocabulary: {}
        }),
        new Unit({
            id: 6, levelId: 1, language: "nhce",
            title: "Conversación básica", color: COLOR_PALETTE.GREEN,
            completed: false, locked: true, current: false,
            objective: "Integrar todo lo aprendido en una conversación",
            grammar: "Estructura completa de conversación básica",
            vocabulary: {}
        }),

        // Nivel 2 - Describete y describe a tu familia
        new Unit({
            id: 7, levelId: 2, language: "nhce",
            title: "Pronombres personales", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Aprender los pronombres personales",
            grammar: "Nehuatl, Tehuatl, Yehuatl, Tehuan, Yehuan",
            vocabulary: {}
        }),
        new Unit({
            id: 8, levelId: 2, language: "nhce",
            title: "La familia", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Aprender vocabulario de la familia",
            grammar: "Nocencal, Mocencal, sufijo -tzin",
            vocabulary: {}
        }),
        new Unit({
            id: 9, levelId: 2, language: "nhce",
            title: "Padres y características", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Describir a los padres y sus características",
            grammar: "Tahtli, Nantli, Chicahuac, Cuacualtzin",
            vocabulary: {}
        }),
        new Unit({
            id: 10, levelId: 2, language: "nhce",
            title: "Hermanos y amigos", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Aprender sobre hermanos y amigos",
            grammar: "Icniuhtli, Telpochtli, Ichpochtli",
            vocabulary: {}
        }),
        new Unit({
            id: 11, levelId: 2, language: "nhce",
            title: "Abuelos y sabiduría", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Aprender sobre los abuelos y la sabiduría",
            grammar: "Huehue, Ilamatl, Coltzin, Cihtzin, Tlamatini",
            vocabulary: {}
        }),
        new Unit({
            id: 12, levelId: 2, language: "nhce",
            title: "Descripción completa", color: COLOR_PALETTE.BLUE,
            completed: false, locked: true, current: false,
            objective: "Integrar descripciones de la familia",
            grammar: "Estructuras completas de descripción familiar",
            vocabulary: {}
        }),

        // Nivel 3 - Pide y da información
        new Unit({
            id: 13, levelId: 3, language: "nhce",
            title: "Partículas interrogativas", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Aprender partículas para hacer preguntas",
            grammar: "Tlen, Tleca, Queman, Aquin, Canin, Quenin",
            vocabulary: {}
        }),
        new Unit({
            id: 14, levelId: 3, language: "nhce",
            title: "Preguntas personales", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Aprender a hacer preguntas personales",
            grammar: "Aquin tehuatl?, Canin tica?, Tlen tichihua?",
            vocabulary: {}
        }),
        new Unit({
            id: 15, levelId: 3, language: "nhce",
            title: "Preguntas sobre otros", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Aprender a preguntar sobre otras personas",
            grammar: "Aquin motahtli?, Canin nocihtzin?, Tlen quichihua yehuatl?",
            vocabulary: {}
        }),
        new Unit({
            id: 16, levelId: 3, language: "nhce",
            title: "Ubicación y necesidad", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Aprender a preguntar sobre ubicación y necesidades",
            grammar: "Ompa, Monequi, Canin noicniuh?, Tlen monequi?",
            vocabulary: {}
        }),
        new Unit({
            id: 17, levelId: 3, language: "nhce",
            title: "Respuestas completas", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Aprender a dar respuestas completas",
            grammar: "Nehuatl ni..., Tehuatl tin..., Canin tica?, Nicac ipan...",
            vocabulary: {}
        }),
        new Unit({
            id: 18, levelId: 3, language: "nhce",
            title: "Diálogo informativo", color: COLOR_PALETTE.ORANGE,
            completed: false, locked: true, current: false,
            objective: "Integrar preguntas y respuestas en diálogos",
            grammar: "Estructuras completas de intercambio de información",
            vocabulary: {}
        }),

        // Nivel 4 - Habla en tiempos
        new Unit({
            id: 19, levelId: 4, language: "nhce",
            title: "Tiempos básicos", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Aprender los tiempos básicos",
            grammar: "Yalhua, Axan, Moztla, Pan",
            vocabulary: {}
        }),
        new Unit({
            id: 20, levelId: 4, language: "nhce",
            title: "Marcadores temporales", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Aprender marcadores de tiempo verbal",
            grammar: "Prefijo o- (pasado), sufijo -z (futuro)",
            vocabulary: {}
        }),
        new Unit({
            id: 21, levelId: 4, language: "nhce",
            title: "Acciones en el tiempo", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Aprender a expresar acciones en diferentes tiempos",
            grammar: "Onechittac, Nimitzittaz, Oquittac, Quittaz",
            vocabulary: {}
        }),
        new Unit({
            id: 22, levelId: 4, language: "nhce",
            title: "Actividades diarias", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Aprender a hablar sobre actividades diarias",
            grammar: "Tlacua, Iuan, Ompa, Onica",
            vocabulary: {}
        }),
        new Unit({
            id: 23, levelId: 4, language: "nhce",
            title: "Ubicación temporal", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Aprender a ubicar acciones en el tiempo y espacio",
            grammar: "Ompa, Onica, Nicac, Ticaz, Nictlacua",
            vocabulary: {}
        }),
        new Unit({
            id: 24, levelId: 4, language: "nhce",
            title: "Narrativa temporal", color: COLOR_PALETTE.RED,
            completed: false, locked: true, current: false,
            objective: "Integrar todos los tiempos en narrativas",
            grammar: "Estructuras completas de narración temporal",
            vocabulary: {}
        }),

        // Nivel 5 - Describe un día normal
        new Unit({
            id: 25, levelId: 5, language: "nhce",
            title: "Rutinas básicas", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Aprender vocabulario de rutinas diarias",
            grammar: "Tlacatl, Tlacua, Quichihua, Quitlacua",
            vocabulary: {}
        }),
        new Unit({
            id: 26, levelId: 5, language: "nhce",
            title: "Dormir y comer", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Aprender a hablar sobre dormir y comer",
            grammar: "Cochi, Quitlacua, Chihua, Ipan",
            vocabulary: {}
        }),
        new Unit({
            id: 27, levelId: 5, language: "nhce",
            title: "Actividades con otros", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Aprender a hablar sobre actividades con otras personas",
            grammar: "Nechpa, Motlacua, Titlacua, Mochihua",
            vocabulary: {}
        }),
        new Unit({
            id: 28, levelId: 5, language: "nhce",
            title: "Integración de rutinas", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Integrar diferentes actividades rutinarias",
            grammar: "Nictlacua, Ticchihua, Nicochi, Quitlacua, Nicchihua",
            vocabulary: {}
        }),
        new Unit({
            id: 29, levelId: 5, language: "nhce",
            title: "Rutinas en plural", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Aprender a hablar sobre rutinas en plural",
            grammar: "Sufijo -ceh para plural, estructuras con Tehuan",
            vocabulary: {}
        }),
        new Unit({
            id: 30, levelId: 5, language: "nhce",
            title: "Descripción completa del día", color: COLOR_PALETTE.TEAL,
            completed: false, locked: true, current: false,
            objective: "Integrar toda la rutina diaria en descripciones completas",
            grammar: "Estructuras completas de descripción rutinaria",
            vocabulary: {}
        }),

        // Nivel 6 - Describe y expresa preferencias
        new Unit({
            id: 31, levelId: 6, language: "nhce",
            title: "Comparaciones básicas", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Aprender a hacer comparaciones",
            grammar: "Quēmah, Monequi, Ahmo quēmah, Quēmah monequi",
            vocabulary: {}
        }),
        new Unit({
            id: 32, levelId: 6, language: "nhce",
            title: "Expresar preferencias", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Aprender a expresar preferencias y necesidades",
            grammar: "Quema monequi, Ahmo monequi",
            vocabulary: {}
        }),
        new Unit({
            id: 33, levelId: 6, language: "nhce",
            title: "Peticiones y órdenes", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Aprender a hacer peticiones y dar órdenes",
            grammar: "Nimitztlatlauhtia, xi-, xic-, Nimitztlatlauhtia xictlacua, Nimitztlatlauhtia ximocochi",
            vocabulary: {}
        }),
        new Unit({
            id: 34, levelId: 6, language: "nhce",
            title: "Integración de preferencias", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Integrar preferencias en oraciones completas",
            grammar: "Quema monequi nictlacua, Ahmo monequi nimocochiz",
            vocabulary: {}
        }),
        new Unit({
            id: 35, levelId: 6, language: "nhce",
            title: "Preferencias personales", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Aprender a expresar preferencias personales",
            grammar: "Nehuatl quema monequi..., Tehuatl ahmo monequi...",
            vocabulary: {}
        }),
        new Unit({
            id: 36, levelId: 6, language: "nhce",
            title: "Expresión completa", color: COLOR_PALETTE.PURPLE,
            completed: false, locked: true, current: false,
            objective: "Integrar todas las formas de expresión de preferencias",
            grammar: "Estructuras completas de expresión de deseos y preferencias",
            vocabulary: {}
        }),
    ],
};

// ================= /LEVELS/{ID}/UNITS/{ID}/EXERCISES =================
export const EXERCISES_DATA = {
    // NAHUATL
    nhce: [
        // ========== NIVEL 1 ==========
        // NIVEL 1 : UNIDAD 1
        // 1 : 1
        new Exercise({
            id: 1, unitId: 1, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            character: "neza",
            answer: "Bueno", // español
            correctAnswer: "Cualli", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Cualli significa bueno, buena, buenos, buenas o bien en náhuatl"
        }),
        new Exercise({
            id: 2, unitId: 1, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            character: "coltzin",
            answer: "Día", // español
            correctAnswer: "Tonalli", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tonalli significa día o días en náhuatl"
        }),
        new Exercise({
            id: 3, unitId: 1, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            character: "neza",
            answer: "Buenos días", // español
            correctAnswer: "Cualli tonalli", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Cualli tonalli es el saludo para 'buen día' en náhuatl"
        }),
        new Exercise({
            id: 4, unitId: 1, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            character: "tonatiuh",
            answer: "Noches", // español
            correctAnswer: "Yohual", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Yohual significa noche o noches en náhuatl"
        }),
        new Exercise({
            id: 5, unitId: 1, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            character: "xochitl",
            answer: "Tardes", // español
            correctAnswer: "Teotlac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Teotlac significa tarde o tardes en náhuatl"
        }),
        new Exercise({
            id: 6, unitId: 1, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            character: "neza",
            answer: "Buenas noches", // español
            correctAnswer: "Cualli yohual", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Cualli yohual es el saludo para 'buena noche' en náhuatl"
        }),

        // 1 : 2
        new Exercise({
            id: 7, unitId: 2, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hola", // español
            correctAnswer: "Niltze", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Niltze es una forma común de decir hola en náhuatl"
        }),
        new Exercise({
            id: 8, unitId: 2, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Adiós", // español
            correctAnswer: "Timoittazceh", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Timoittazceh se usa para despedirse, significa 'hasta luego' o 'nos vemos'"
        }),
        new Exercise({
            id: 9, unitId: 2, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hola, buen día", // español
            correctAnswer: "Niltze, cualli tonalli", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Combinación de saludo y deseo de buen día"
        }),
        new Exercise({
            id: 10, unitId: 2, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Adiós, buena noche", // español
            correctAnswer: "Timoittazceh, cualli yohual", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Despedida con deseo de buena noche"
        }),
        new Exercise({
            id: 11, unitId: 2, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hola, buena noche", // español
            correctAnswer: "Niltze, cualli yohual", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Saludo por la noche"
        }),
        new Exercise({
            id: 12, unitId: 2, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Adiós, buen día", // español
            correctAnswer: "Timoittazceh, cualli tonalli", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Despedida con deseo de buen día"
        }),

        // 1 : 3
        new Exercise({
            id: 13, unitId: 3, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Me llamo...", // español
            correctAnswer: "Notoca", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Notoca se usa para presentarse, significa 'me llamo'"
        }),
        new Exercise({
            id: 14, unitId: 3, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Como?", // español
            correctAnswer: "Quen", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Quen (como) es la forma abreviada de Quenin, significa 'cómo'"
        }),
        new Exercise({
            id: 15, unitId: 3, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Cómo te llamas?", // español
            correctAnswer: "Quen motoca?", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Quen motoca? es la pregunta para saber el nombre de alguien"
        }),
        new Exercise({
            id: 16, unitId: 3, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sí", // español
            correctAnswer: "Quēmah", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Quēmah significa sí en náhuatl"
        }),
        new Exercise({
            id: 17, unitId: 3, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "No", // español
            correctAnswer: "Ahmo", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ahmo significa no en náhuatl"
        }),
        new Exercise({
            id: 18, unitId: 3, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sí, me llamo Xóchitl", // español
            correctAnswer: "Quēmah, notoca Xóchitl", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Respuesta afirmativa con presentación del nombre"
        }),

        // 1 : 4
        new Exercise({
            id: 19, unitId: 4, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Gracias", // español
            correctAnswer: "Tlazohcamati", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tlazohcamati es la palabra para dar gracias en náhuatl"
        }),
        new Exercise({
            id: 20, unitId: 4, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Buen día, gracias", // español
            correctAnswer: "Cualli tonalli, tlazohcamati", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Saludo con agradecimiento"
        }),
        new Exercise({
            id: 21, unitId: 4, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Adiós, gracias", // español
            correctAnswer: "Timoittazceh, tlazohcamati", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Despedida con agradecimiento"
        }),
        new Exercise({
            id: 22, unitId: 4, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mucho", // español
            correctAnswer: "Miac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Miac significa mucho o mucha en náhuatl"
        }),
        new Exercise({
            id: 23, unitId: 4, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Muchas gracias", // español
            correctAnswer: "Tlazohcamati miac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Expresión de agradecimiento intensificado"
        }),
        new Exercise({
            id: 24, unitId: 4, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sí, muchas gracias", // español
            correctAnswer: "Quēmah, tlazohcamati miac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Respuesta afirmativa con agradecimiento intensificado"
        }),

        // 1 : 5
        new Exercise({
            id: 25, unitId: 5, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Muy", // español
            correctAnswer: "Huel", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Huel se usa para dar énfasis, significa 'muy' o 'verdaderamente'"
        }),
        new Exercise({
            id: 26, unitId: 5, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Muchísimas gracias", // español
            correctAnswer: "Tlazohcamati huel miac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Agradecimiento muy intenso y enfático"
        }),
        new Exercise({
            id: 27, unitId: 5, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Cómo estás?", // español
            correctAnswer: "Quenin tica?", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Quenin tica? es la pregunta sobre el estado o condición"
        }),
        new Exercise({
            id: 28, unitId: 5, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Estoy", // español
            correctAnswer: "Nicac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Nicac significa 'yo estoy' indicando estado o ubicación"
        }),
        new Exercise({
            id: 29, unitId: 5, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Yo", // español
            correctAnswer: "Ni", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ni es el prefijo que indica primera persona singular 'yo'"
        }),
        new Exercise({
            id: 30, unitId: 5, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mal", // español
            correctAnswer: "Ahmo cualli", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ahmo cualli significa 'no bien' o 'mal'"
        }),

        // 1 : 6
        new Exercise({
            id: 31, unitId: 6, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Buen día", // español
            correctAnswer: "Cualli tonalli", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Saludo de buen día"
        }),
        new Exercise({
            id: 32, unitId: 6, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hola, me llamo Citlalli", // español
            correctAnswer: "Niltze, notoca Citlalli", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Saludo con presentación personal"
        }),
        new Exercise({
            id: 33, unitId: 6, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sí, estoy bien", // español
            correctAnswer: "Quēmah cualli nicac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Respuesta afirmativa sobre el estado personal"
        }),
        new Exercise({
            id: 34, unitId: 6, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Adiós, muchas gracias", // español
            correctAnswer: "Timoittazceh, tlazohcamati miac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Despedida con agradecimiento intenso"
        }),
        new Exercise({
            id: 35, unitId: 6, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Nada", // español
            correctAnswer: "Tlen", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tlen puede significar 'nada', 'qué' o 'cosa' dependiendo del contexto. Se utiliza para preguntar por cosas o para referirse a algo de manera general o relativa"
        }),
        new Exercise({
            id: 36, unitId: 6, levelId: 1, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ninguna cosa", // español
            correctAnswer: "Ahmotlen", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ahmotlen significa literalmente 'ninguna cosa' o 'nada'"
        }),

        // ========== NIVEL 2 ==========
        // 2 : 1
        new Exercise({
            id: 37, unitId: 1, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Yo", // español
            correctAnswer: "Nehuatl", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Nehuatl es el pronombre personal 'yo'"
        }),
        new Exercise({
            id: 38, unitId: 1, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Él", // español
            correctAnswer: "Yehuatl", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Yehuatl es el pronombre personal para tercera persona singular"
        }),
        new Exercise({
            id: 39, unitId: 1, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tú", // español
            correctAnswer: "Tehuatl", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tehuatl es el pronombre personal 'tú'"
        }),
        new Exercise({
            id: 40, unitId: 1, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ellos", // español
            correctAnswer: "Yehuan", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Yehuan es el pronombre personal para tercera persona plural"
        }),
        new Exercise({
            id: 41, unitId: 1, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ustedes", // español
            correctAnswer: "Anmehuan", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Anmehuan es el pronombre personal para segunda persona plural formal"
        }),
        new Exercise({
            id: 42, unitId: 1, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Nosotros", // español
            correctAnswer: "Tehuan", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tehuan es el pronombre personal 'nosotros'"
        }),

        // 2 : 2
        new Exercise({
            id: 43, unitId: 2, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mi familia", // español
            correctAnswer: "Nocencal", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "No-Cencalli significa 'mi-familia'"
        }),
        new Exercise({
            id: 44, unitId: 2, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ahora", // español
            correctAnswer: "Ye", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ye indica tiempo presente. A menudo se omite 'ye' en presente simple"
        }),
        new Exercise({
            id: 45, unitId: 2, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tu familia", // español
            correctAnswer: "Mocencal", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Mo-Cencalli significa 'tu-familia'"
        }),
        new Exercise({
            id: 46, unitId: 2, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Grande", // español
            correctAnswer: "Huey", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Huey significa grande en tamaño"
        }),
        new Exercise({
            id: 47, unitId: 2, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Pequeño", // español
            correctAnswer: "Tepiton", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tepiton significa pequeño en tamaño"
        }),
        // desde aqui empiezan los fill-blank
        new Exercise({
            id: 48, unitId: 2, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ huey", // nahuatl
            correctAnswer: ["Nocencal huey", "Nocencal"], // nahuatl
            placeholder: "Mi familia es grande",
            points: 20,
            difficulty: "medium",
            explanation: "Nocencal huey significa 'Mi familia es grande'"
        }),

        // 2 : 3
        new Exercise({
            id: 49, unitId: 3, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Padre", // español
            correctAnswer: "Tahtli", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tahtli significa padre o papá"
        }),
        new Exercise({
            id: 50, unitId: 3, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Madre", // español
            correctAnswer: "Nantli", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Nantli significa madre o mamá"
        }),
        new Exercise({
            id: 51, unitId: 3, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Fuerte", // español
            correctAnswer: "Chicahuac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Chicahuac describe fuerza física o robustez"
        }),
        new Exercise({
            id: 52, unitId: 3, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hermoso", // español
            correctAnswer: "Cuacualtzin", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Cuacualtzin describe belleza o hermosura"
        }),
        new Exercise({
            id: 53, unitId: 3, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Chicahuac ______", // nahuatl
            correctAnswer: ["Chicahuac notahtli", "notahtli"], // nahuatl
            placeholder: "Mi padre es fuerte",
            points: 20,
            difficulty: "medium",
            explanation: "Chicahuac notahtli significa 'Mi padre es fuerte'"
        }),
        new Exercise({
            id: 54, unitId: 3, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ nonantli", // nahuatl
            correctAnswer: ["Cuacualtzin nonantli", "Cuacualtzin"], // nahuatl
            placeholder: "Mi madre es hermosa",
            points: 20,
            difficulty: "medium",
            explanation: "Cuacualtzin nonantli significa 'Mi madre es hermosa'"
        }),

        // 2 : 4
        new Exercise({
            id: 55, unitId: 4, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hermano", // español
            correctAnswer: "icniuhtli", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "icniuhtli tiene un significado amplio de relación cercana. Hermano/a, Primo/a, Amigo/a"
        }),
        new Exercise({
            id: 56, unitId: 4, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mi hermano", // español
            correctAnswer: "Noicniuh", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Noicniuh significa 'mi hermano', 'mi hermana' o 'mi amigo/a'"
        }),
        new Exercise({
            id: 57, unitId: 4, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Joven", // español
            correctAnswer: "Telpochtli", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Telpochtli se refiere a un joven masculino"
        }),
        new Exercise({
            id: 58, unitId: 4, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Muchacha", // español
            correctAnswer: "Ichpochtli", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ichpochtli se refiere a una joven femenina"
        }),
        new Exercise({
            id: 59, unitId: 4, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            // da errores
            answer: "Noicniuh ______", // nahuatl
            correctAnswer: ["Noicniuh telpochtli", "telpochtli"], // nahuatl
            placeholder: "Mi hermano es joven",
            points: 20,
            difficulty: "medium",
            explanation: "Noicniuh telpochtli significa 'Mi hermano es joven'"
        }),
        new Exercise({
            id: 60, unitId: 4, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Nehuatl ni ______", // nahuatl
            correctAnswer: ["Nehuatl ni ichpochtli", "ichpochtli"], // nahuatl
            placeholder: "Yo soy joven",
            points: 20,
            difficulty: "medium",
            explanation: "Nehuatl ni ichpochtli significa 'Yo soy joven' (femenino)"
        }),

        // 2 : 5
        new Exercise({
            id: 61, unitId: 5, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hombre mayor", // español
            correctAnswer: "Huehue", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Huehue se refiere a un hombre anciano o persona mayor"
        }),
        new Exercise({
            id: 62, unitId: 5, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mujer mayor", // español
            correctAnswer: "Ilamatl", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ilamatl se refiere a una mujer anciana o persona mayor"
        }),
        new Exercise({
            id: 63, unitId: 5, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Abuelo", // español
            correctAnswer: "Coltzin", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Coltzin significa abuelo, con matiz de respeto"
        }),
        new Exercise({
            id: 64, unitId: 5, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Abuela", // español
            correctAnswer: "Cihtzin", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Cihtzin significa abuela, con matiz de respeto"
        }),
        new Exercise({
            id: 65, unitId: 5, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Noicniuh ye ______", // nahuatl
            correctAnswer: ["Noicniuh ye huehue", "huehue", "huehuetzin"], // nahuatl
            placeholder: "Mi hermano ya es anciano",
            points: 20,
            difficulty: "medium",
            explanation: "Noicniuh ye huehue significa 'Mi hermano ya es anciano'"
        }),
        new Exercise({
            id: 66, unitId: 5, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Noicniuh ye ______", // nahuatl
            correctAnswer: ["Noicniuh ye ilamatl", "ilamatl"], // nahuatl
            placeholder: "Mi hermana ya es anciana",
            points: 20,
            difficulty: "medium",
            explanation: "Noicniuh ye ilamatl significa 'Mi hermana ya es anciana'"
        }),

        // 2 : 6
        new Exercise({
            id: 67, unitId: 6, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Nosotros somos familia", // español
            correctAnswer: "Tehuan ticencalimeh", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tehuan ticencalimeh significa 'Nosotros somos familia'"
        }),
        new Exercise({
            id: 68, unitId: 6, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mi familia es grande", // español
            correctAnswer: "Nocencal ye huey", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Nocencal ye huey describe una familia numerosa"
        }),
        new Exercise({
            id: 69, unitId: 6, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ella es mi abuela", // español
            correctAnswer: "Yehuatl nocihtzin", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Yehuatl nocihtzin presenta a la abuela"
        }),
        new Exercise({
            id: 70, unitId: 6, levelId: 2, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mi hermana es joven", // español
            correctAnswer: "Ichpochtli Noicniuh", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ichpochtli Noicniuh describe a una hermana joven"
        }),
        new Exercise({
            id: 71, unitId: 6, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Nehuatl ni ______", // nahuatl
            correctAnswer: ["Nehuatl ni ichpochtli", "ichpochtli"], // nahuatl
            placeholder: "Yo soy joven",
            points: 20,
            difficulty: "medium",
            explanation: "Nehuatl ni ichpochtli significa 'Yo soy joven' (femenino)"
        }),
        new Exercise({
            id: 72, unitId: 6, levelId: 2, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Chicahuac ______", // nahuatl
            correctAnswer: ["Chicahuac notahtli", "notahtli"], // nahuatl
            placeholder: "Mi padre es fuerte",
            points: 20,
            difficulty: "medium",
            explanation: "Chicahuac notahtli significa 'Mi padre es fuerte'"
        }),

        // ========== NIVEL 3 ==========
        // 3 : 1
        new Exercise({
            id: 73, unitId: 1, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Qué?", // español
            correctAnswer: "Tlen", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tlen puede significar 'que', 'nada' o 'cosa' dependiendo del contexto. Se utiliza para preguntar por cosas o para referirse a algo de manera general o relativa"
        }),
        new Exercise({
            id: 74, unitId: 1, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Por qué?", // español
            correctAnswer: "Tleca", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tleca pregunta por la razón o causa"
        }),
        new Exercise({
            id: 75, unitId: 1, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Cuándo?", // español
            correctAnswer: "Queman", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Queman pregunta por el tiempo o momento"
        }),
        new Exercise({
            id: 76, unitId: 1, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Quién?", // español
            correctAnswer: "Aquin", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Aquin pregunta por la identidad de personas"
        }),
        new Exercise({
            id: 77, unitId: 1, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Dónde?", // español
            correctAnswer: "Canin", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Canin pregunta por la ubicación o lugar"
        }),
        new Exercise({
            id: 78, unitId: 1, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Cómo? (de qué manera)", // español
            correctAnswer: "Quenin", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Quenin pregunta por la manera o forma"
        }),

        // 3 : 2
        new Exercise({
            id: 79, unitId: 2, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hacer", // español
            correctAnswer: "Chihua", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Chihua es el verbo para 'hacer'"
        }),
        new Exercise({
            id: 80, unitId: 2, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Quién eres tú?", // español
            correctAnswer: "Aquin tehuatl?", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Aquin tehuatl? pregunta por la identidad de la persona"
        }),
        new Exercise({
            id: 81, unitId: 2, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Dónde estás?", // español
            correctAnswer: "Canin tica?", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Canin tica? pregunta por la ubicación actual"
        }),
        new Exercise({
            id: 82, unitId: 2, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Qué haces?", // español
            correctAnswer: "Tlen tichihua?", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tlen tichihua? pregunta por la acción actual"
        }),
        new Exercise({
            id: 83, unitId: 2, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la pregunta:",
            answer: "______ mocencal", // nahuatl
            correctAnswer: ["Quenin mocencal", "Quenin"], // nahuatl
            placeholder: "¿Cómo está tu familia?",
            points: 20,
            difficulty: "medium",
            explanation: "Quenin mocencal significa '¿Cómo está tu familia?'. El nahuatl basa la interrogación en palabras interrogativas (tlen, quēn, can, āca, etc..) y opcionalmente en una partícula interrogativa: cuix (¿acaso…? o ¿será…?)"
        }),
        new Exercise({
            id: 84, unitId: 2, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la pregunta:",
            answer: "______ timoittazceh", // nahuatl
            correctAnswer: ["Queman timoittazceh", "Queman"], // nahuatl
            placeholder: "¿Cuándo nos vemos?",
            points: 20,
            difficulty: "medium",
            explanation: "Queman timoittazceh significa '¿Cuándo nos vemos?'"
        }),

        // 3 : 3
        new Exercise({
            id: 85, unitId: 3, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Quién es tu padre?", // español
            correctAnswer: "Aquin motahtli?", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Aquin motahtli? pregunta por la identidad del padre"
        }),
        new Exercise({
            id: 86, unitId: 3, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Dónde está mi abuela?", // español
            correctAnswer: "Canin nocihtzin?", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Canin nocihtzin? pregunta por la ubicación de la abuela"
        }),
        new Exercise({
            id: 87, unitId: 3, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Qué hace él?", // español
            correctAnswer: "Tlen quichihua yehuatl?", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tlen quichihua yehuatl? pregunta por la acción de tercera persona"
        }),
        new Exercise({
            id: 88, unitId: 3, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Cómo está ella?", // español
            correctAnswer: "Quenin yehuatl?", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Quenin yehuatl? pregunta por el estado de tercera persona"
        }),
        new Exercise({
            id: 89, unitId: 3, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la pregunta:",
            answer: "Tleca ______ tica cualli", // nahuatl
            correctAnswer: ["Tleca ahmo tica cualli", "ahmo"], // nahuatl
            placeholder: "¿Por qué no estás bien?",
            points: 20,
            difficulty: "medium",
            explanation: "Tleca ahmo tica cualli significa '¿Por qué no estás bien?'"
        }),
        new Exercise({
            id: 90, unitId: 3, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la pregunta:",
            answer: "______ titlacua", // nahuatl
            correctAnswer: ["Queman titlacua", "Queman"], // nahuatl
            placeholder: "¿Cuándo comes?",
            points: 20,
            difficulty: "medium",
            explanation: "Queman titlacua significa '¿Cuándo comes?'"
        }),

        // 3 : 4
        new Exercise({
            id: 91, unitId: 4, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Allá", // español
            correctAnswer: "Ompa", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ompa indica ubicación lejana, allí o allá"
        }),
        new Exercise({
            id: 92, unitId: 4, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Es necesario", // español
            correctAnswer: "Monequi", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Monequi expresa necesidad o requerimiento"
        }),
        new Exercise({
            id: 93, unitId: 4, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Quién es mi abuelo?", // español
            correctAnswer: "Aquin nocoltzin?", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Aquin nocoltzin? pregunta por la identidad del abuelo"
        }),
        new Exercise({
            id: 94, unitId: 4, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Dónde está mi hermano?", // español
            correctAnswer: "Canin noicniuh?", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Canin noicniuh? pregunta por la ubicación del hermano o hermana"
        }),
        new Exercise({
            id: 95, unitId: 4, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la pregunta:",
            answer: "______ monequi", // nahuatl
            correctAnswer: ["Tlen monequi", "Tlen"], // nahuatl
            placeholder: "¿Qué es necesario?",
            points: 20,
            difficulty: "medium",
            explanation: "Tlen monequi significa '¿Qué es necesario?'"
        }),
        new Exercise({
            id: 96, unitId: 4, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la pregunta:",
            answer: "______ motoca", // nahuatl
            correctAnswer: ["Quenin motoca", "Quenin"], // nahuatl
            placeholder: "¿Cuál es tu nombre?",
            points: 20,
            difficulty: "medium",
            explanation: "Quenin motoca es otra forma de preguntar el nombre"
        }),

        // 3 : 5
        new Exercise({
            id: 97, unitId: 5, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "De esta manera", // español
            correctAnswer: "ic", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "ic indica manera o forma de hacer algo"
        }),
        new Exercise({
            id: 98, unitId: 5, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Yo soy Moctezuma", // español
            correctAnswer: "Nehuatl ni Moctezuma", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Presentación personal con énfasis"
        }),
        new Exercise({
            id: 99, unitId: 5, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "El es mi hermano", // español
            correctAnswer: "Yehuatl Noicniuh", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Reconocimiento de relación fraternal"
        }),
        new Exercise({
            id: 100, unitId: 5, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Dónde estás?", // español
            correctAnswer: "Canin tica?", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Pregunta básica de ubicación"
        }),
        new Exercise({
            id: 101, unitId: 5, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Nicac ______ nocencal", // nahuatl
            correctAnswer: ["Nicac ipan nocencal", "ipan"], // nahuatl
            placeholder: "Estoy con mi familia",
            points: 20,
            difficulty: "medium",
            explanation: "Nicac ipan nocencal significa 'Estoy con mi familia' o 'Estoy en mi familia'"
        }),
        new Exercise({
            id: 102, unitId: 5, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la pregunta:",
            answer: "______ tlacuaz", // nahuatl
            correctAnswer: ["Queman tlacuaz", "Queman"], // nahuatl
            placeholder: "¿Cuándo se come?",
            points: 20,
            difficulty: "medium",
            explanation: "Queman titlacua? es pregunta reflexiva sobre el horario de comida de una o un grupo de personas"
        }),

        // 3 : 6
        new Exercise({
            id: 103, unitId: 6, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Quién es tu padre?", // español
            correctAnswer: "Aquin motahtli?", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Aquin notahtli? pregunta por la identidad del padre"
        }),
        new Exercise({
            id: 104, unitId: 6, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ella es mi abuela", // español
            correctAnswer: "Yehuatl nocihtzin", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Presentación de la abuela"
        }),
        new Exercise({
            id: 105, unitId: 6, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Dónde están ellos?", // español
            correctAnswer: "Canin yehuan", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Canin yehuan? pregunta por ubicación de grupo"
        }),
        new Exercise({
            id: 106, unitId: 6, levelId: 3, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Qué haces?", // español
            correctAnswer: "Tlen tichihua", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Pregunta sobre acción actual"
        }),
        new Exercise({
            // este da error en la IU
            id: 107, unitId: 6, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la pregunta:",
            answer: "______ yehuan", // nahuatl
            correctAnswer: ["Canin", "Canin yehuan"], // nahuatl
            placeholder: "¿Dónde están ellos?",
            points: 20,
            difficulty: "medium",
            explanation: "Canin yehuan significa '¿Dónde están ellos?'"
        }),
        new Exercise({
            id: 108, unitId: 6, levelId: 3, language: "nhce",
            type: "fill-blank",
            question: "Completa la pregunta:",
            answer: "______ tichihua", // nahuatl
            correctAnswer: ["Tlen tichihua", "Tlen"], // nahuatl
            placeholder: "¿Qué estás haciendo?",
            points: 20,
            difficulty: "medium",
            explanation: "Tlen tichihua es la pregunta básica sobre acciones, '¿Qué haces?' o '¿Qué estás haciendo?'"
        }),

        // ========== NIVEL 4 ==========
        // 4 : 1
        new Exercise({
            id: 109, unitId: 1, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ayer", // español
            correctAnswer: "Yalhua", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Yalhua se refiere al día anterior"
        }),
        new Exercise({
            id: 110, unitId: 1, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hoy", // español
            correctAnswer: "Axan", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Axan indica el día actual"
        }),
        new Exercise({
            id: 111, unitId: 1, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mañana", // español
            correctAnswer: "Moztla", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Moztla se refiere al día siguiente"
        }),
        new Exercise({
            id: 112, unitId: 1, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sobre", // español
            correctAnswer: "ipan", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ipan indica ubicación o tiempo sobre algo"
        }),
        new Exercise({
            id: 113, unitId: 1, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ teotlac", // nahuatl
            correctAnswer: ["Yalhua teotlac", "Yalhua"], // nahuatl
            placeholder: "Ayer en la tarde",
            points: 20,
            difficulty: "medium",
            explanation: "Yalhua teotlac significa 'Ayer en la tarde'"
        }),
        new Exercise({
            id: 114, unitId: 1, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ yohual", // nahuatl
            correctAnswer: ["Moztla yohual", "Moztla"], // nahuatl
            placeholder: "Mañana en la noche",
            points: 20,
            difficulty: "medium",
            explanation: "Moztla yohual significa 'Mañana en la noche'"
        }),

        // 4 : 2
        new Exercise({
            id: 115, unitId: 2, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Qué haces?", // español
            correctAnswer: "Tlen tichihua", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tlen tichihua significa Que haces? (hoy, ahora mismo)"
        }),
        new Exercise({
            id: 116, unitId: 2, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Qué hiciste?", // español
            correctAnswer: "Tlen otichihua", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tlen otichihua significa Que hiciste? (ayer, hace un tiempo). El tiempo pasado se muestra con prefijo 'o-'"
        }),
        new Exercise({
            id: 117, unitId: 2, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "¿Qué harás? (futuro)", // español
            correctAnswer: "Tlen tichihuaz?", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tlen tichihuaz? significa Que haras? (mañana, dentro de un  tiempo). El tiempo pasado se muestra con sufijo '-z'"
        }),
        // new Exercise({
        //     id: 118, unitId: 2, levelId: 4, language: "nhce",
        //     type: "multiple-choice",
        //     question: "Selecciona la traducción correcta",
        //     answer: "Prefijo de pretérito", // español
        //     correctAnswer: "o", // nahuatl
        //     points: 15,
        //     difficulty: "medium",
        //     explanation: "El prefijo 'o-' indica acción pasada"
        // }),
        new Exercise({
            id: 119, unitId: 2, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la pregunta:",
            answer: "Tlen ______", // nahuatl
            correctAnswer: ["Tlen otichihua", "otichihua"], // nahuatl
            placeholder: "¿Qué has hecho?",
            points: 20,
            difficulty: "medium",
            explanation: "Tlen otichihua es la forma correcta para preguntar en pasado"
        }),
        new Exercise({
            id: 120, unitId: 2, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la pregunta:",
            answer: "Tlen ______", // nahuatl
            correctAnswer: ["Tlen tichihuaz", "tichihuaz"], // nahuatl
            placeholder: "¿Qué harás?",
            points: 20,
            difficulty: "medium",
            explanation: "Tlen tichihuaz? es la forma correcta para preguntar en futuro"
        }),

        // 4 : 3
        new Exercise({
            id: 121, unitId: 3, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ayer, se lo agradecí", // español
            correctAnswer: "Yalhua, onitlazohcamati", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción completada en el pasado"
        }),
        new Exercise({
            id: 122, unitId: 3, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hoy, doy gracias", // español
            correctAnswer: "Axan, nitlazohcamati", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción en tiempo presente"
        }),
        new Exercise({
            id: 123, unitId: 3, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mañana, daré gracias", // español
            correctAnswer: "Moztla, nitlazohcamatiz", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción planeada en futuro"
        }),
        new Exercise({
            id: 124, unitId: 3, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Me vio", // español
            correctAnswer: "Onechittac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción pasada con objeto directo 'me'"
        }),
        new Exercise({
            id: 125, unitId: 3, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______, nitlazohcamatiz mitz.", // nahuatl
            correctAnswer: ["Moztla nitlazohcamatiz mitz", "Moztla"], // nahuatl
            placeholder: "Mañana te voy a dar las gracias",
            points: 20,
            difficulty: "medium",
            explanation: "Moztla establece el tiempo futuro de la acción y mitz marca el destinatario."
        }),
        new Exercise({
            id: 126, unitId: 3, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Yalhua, ______ mitz", // nahuatl
            correctAnswer: ["Yalhua, onitlazohcamati mitz", "onitlazohcamati"], // nahuatl
            placeholder: "ayer te agradecí",
            points: 20,
            difficulty: "medium",
            explanation: "onitlazohcamati es la forma pasada de 'dar gracias' en pasado"
        }),

        // 4 : 4
        new Exercise({
            id: 127, unitId: 4, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ayer, mi padre me vio", // español
            correctAnswer: "Yalhua, onechittac notahtli", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción pasada con sujeto y objeto específicos"
        }),
        new Exercise({
            id: 128, unitId: 4, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hoy, veo a mi familia", // español
            correctAnswer: "Axan, niquitta nocencal", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción presente con objeto directo"
        }),
        new Exercise({
            id: 129, unitId: 4, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mañana, nos veremos", // español
            correctAnswer: "Moztla, timoittazceh", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción futura recíproca"
        }),
        new Exercise({
            id: 130, unitId: 4, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ayer, ella los vio", // español
            correctAnswer: "Yalhua, oquittac yehuan", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción pasada con objeto plural"
        }),
        new Exercise({
            id: 131, unitId: 4, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Axan, nitlacua ______ nocencal", // nahuatl
            correctAnswer: ["Axan, nitlacua iuan nocencal", "iuan"], // nahuatl
            placeholder: "Ahora, como con mi familia",
            points: 20,
            difficulty: "medium",
            explanation: "Iuan significa 'con' indicando compañía"
        }),
        new Exercise({
            // Moztla, ticchihuaz miac tlamantli
            id: 132, unitId: 4, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Moztla, ______ tlen miac", // nahuatl
            correctAnswer: ["Moztla, ticchihuaz tlen miac", "ticchihuaz"], // nahuatl
            placeholder: "Mañana harás muchas cosas",
            points: 20,
            difficulty: "medium",
            explanation: "Ticchihuaz es la forma futura de 'tú harás'"
        }),

        // 4 : 5
        new Exercise({
            id: 133, unitId: 5, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Alla", // español
            correctAnswer: "Ompa", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ompa indica ubicación lejana"
        }),
        new Exercise({
            id: 134, unitId: 5, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Yo estuve", // español
            correctAnswer: "Onica", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Onica es la forma pasada de 'estar'"
        }),
        new Exercise({
            id: 135, unitId: 5, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ayer estuve allí", // español
            correctAnswer: "Yalhua onica ompa", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ubicación pasada en lugar lejano"
        }),
        new Exercise({
            id: 136, unitId: 5, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hoy estoy allí", // español
            correctAnswer: "Axan ompa nicac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ubicación presente en lugar lejano"
        }),
        new Exercise({
            id: 137, unitId: 5, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Moztla ompa ______", // nahuatl
            correctAnswer: ["Moztla ompa ticaz", "ticaz"], // nahuatl
            placeholder: "Mañana irás allá",
            points: 20,
            difficulty: "medium",
            explanation: "Ticaz es la forma futura de 'estar' para segunda persona"
        }),
        new Exercise({
            id: 138, unitId: 5, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Axan ompa ______", // nahuatl
            correctAnswer: ["Axan ompa nictlacua", "nictlacua"], // nahuatl
            placeholder: "Ahora estoy comiendo allí",
            points: 20,
            difficulty: "medium",
            explanation: "Nictlacua significa 'yo como' en presente"
        }),

        // 4 : 6
        new Exercise({
            id: 139, unitId: 6, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ayer, vi a mi hermano allí", // español
            correctAnswer: "Yalhua, ompa oniquittac noicniuh", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción pasada con ubicación específica"
        }),
        new Exercise({
            id: 140, unitId: 6, levelId: 4, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hoy, estoy allí", // español
            correctAnswer: "Axan, ompa nicac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ubicación presente específica"
        }),
        // new Exercise({
        //     id: 141, unitId: 6, levelId: 4, language: "nhce",
        //     type: "multiple-choice",
        //     question: "Selecciona la traducción correcta",
        //     answer: "Mañana, allí daré muchas gracias", // español
        //     correctAnswer: "Moztla, ompa nitlazohcamatiz miac", // nahuatl
        //     points: 15,
        //     difficulty: "medium",
        //     explanation: "Acción futura con ubicación e intensidad"
        // }),
        new Exercise({
            id: 142, unitId: 6, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Yalhua, ompa ______ nocihtzin", // nahuatl
            correctAnswer: ["Yalhua, ompa oquittac nocihtzin", "oquittac"], // nahuatl
            placeholder: "Ayer, allá, él vio a mi hermanito",
            points: 20,
            difficulty: "medium",
            explanation: "Oquittac es la forma pasada de 'ver' para tercera persona. Ompa marca la hubicacion de la accion (allí/allá)"
        }),
        new Exercise({
            id: 143, unitId: 6, levelId: 4, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Axan, ompa nictlacua ______ teotlac", // nahuatl
            correctAnswer: ["Axan, ompa nictlacua ipan teotlac", "ipan"], // nahuatl
            placeholder: "Hoy, ahi, como en la tarde",
            points: 20,
            difficulty: "medium",
            explanation: "Ipan introduce un complemento temporal o espacial: ipan teotlac = en la tarde."
        }),


        // ========== NIVEL 5 ==========
        // 5 : 1
        new Exercise({
            id: 144, unitId: 1, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Persona", // español
            correctAnswer: "Tlacatl", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Tlacatl significa persona o ser humano"
        }),
        new Exercise({
            id: 145, unitId: 1, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Come en la tarde", // español
            correctAnswer: "Tlacua teotlac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción habitual en tiempo específico"
        }),
        new Exercise({
            id: 146, unitId: 1, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "El hace lo correcto", // español
            correctAnswer: "Quichihua tlen melahuac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción con cualidad de veracidad"
        }),
        new Exercise({
            id: 147, unitId: 1, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ ______ iuan nocencal", // nahuatl
            correctAnswer: ["Axan, nitlacua iuan nocencal", "Axan, nitlacua"], // nahuatl
            placeholder: "Hoy, como con mi familia",
            points: 20,
            difficulty: "medium",
            explanation: "Axan, nitlacua iuan nocencal significa 'Hoy, como con mi familia'"
        }),
        new Exercise({
            id: 148, unitId: 1, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ yohual", // nahuatl
            correctAnswer: ["Titlacuaceh yohual", "Titlacuaceh"], // nahuatl
            placeholder: "Comerás en la noche",
            points: 20,
            difficulty: "medium",
            explanation: "Titlacuaceh yohual significa 'Comerás en la noche'"
        }),
        new Exercise({
            id: 149, unitId: 1, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Quitlacua ______ ______", // nahuatl
            correctAnswer: ["Quitlacua ipan yohual", "ipan yohual"], // nahuatl
            placeholder: "Él come en la noche",
            points: 20,
            difficulty: "medium",
            explanation: "Quitlacua ipan yohual significa 'Él/Ella come en la noche'"
        }),

        // 5 : 2
        new Exercise({
            id: 150, unitId: 2, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Dormir", // español
            correctAnswer: "Cochi", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Cochi es el verbo para dormir"
        }),
        new Exercise({
            id: 151, unitId: 2, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Come en la noche", // español
            correctAnswer: "Quitlacua ipan yohual", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción habitual nocturna"
        }),
        new Exercise({
            id: 152, unitId: 2, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Duerme en la noche", // español
            correctAnswer: "Cochi ipan yohual", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción de dormir en tiempo nocturno"
        }),
        new Exercise({
            id: 153, unitId: 2, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Yehuatl ______ ipan tonalli", // nahuatl
            correctAnswer: ["Yehuatl chihua ipan tonalli", "chihua"], // nahuatl
            placeholder: "¿Él hace algo durante el día?",
            points: 20,
            difficulty: "medium",
            explanation: "'Yehuatl chihua ipan tonalli?' significa '¿Él hace [algo] durante el día?'"
        }),
        new Exercise({
            id: 154, unitId: 2, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Yehuatl ______ ______ teotlac", // nahuatl
            correctAnswer: ["Yehuatl cochi ipan teotlac", "Cochi ipan"], // nahuatl
            placeholder: "Ella duerme en la tarde",
            points: 20,
            difficulty: "medium",
            explanation: "Yehuatl cochi ipan teotlac significa 'Ella duerme en la tarde'"
        }),
        new Exercise({
            id: 155, unitId: 2, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ ______ ipan yohual", // nahuatl
            correctAnswer: ["Tehuatl titlacua ipan yohual", "Tehuatl titlacua"], // nahuatl
            placeholder: "¿Tu comes durante la noche?",
            points: 20,
            difficulty: "medium",
            explanation: "'Tehuatl titlacua ipan yohual?' significa '¿Tu comes durante la noche?'"
        }),

        // 5 : 3
        new Exercise({
            id: 156, unitId: 3, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Conmigo", // español
            correctAnswer: "Nechpa", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Nechpa indica compañía con la primera persona"
        }),
        new Exercise({
            id: 157, unitId: 3, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tu comes", // español
            correctAnswer: "Motlacua", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Motlacua es la forma de 'comes' para segunda persona"
        }),
        new Exercise({
            id: 158, unitId: 3, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Comes conmigo", // español
            correctAnswer: "Titlacua nechpa", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción con compañía específica"
        }),
        new Exercise({
            id: 159, unitId: 3, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ mochihua", // nahuatl
            correctAnswer: ["Nechpa mochihua", "Nechpa"], // nahuatl
            placeholder: "Se hace conmigo",
            points: 20,
            difficulty: "medium",
            explanation: "Nechpa mochihua significa 'Se hace conmigo'"
        }),
        new Exercise({
            id: 160, unitId: 3, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ ipan yohual", // nahuatl
            correctAnswer: ["Nicochi ipan yohual", "Nicochi"], // nahuatl
            placeholder: "Duermo en la noche",
            points: 20,
            difficulty: "medium",
            explanation: "Nicochi ipan yohual significa 'Duermo en la noche'"
        }),
        new Exercise({
            id: 161, unitId: 3, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Titlacua ______", // nahuatl
            correctAnswer: ["Titlacua nechpa", "nechpa"], // nahuatl
            placeholder: "Comes conmigo",
            points: 20,
            difficulty: "medium",
            explanation: "Titlacua nechpa significa 'Comes conmigo'"
        }),

        // 5 : 4
        new Exercise({
            id: 162, unitId: 4, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hoy como", // español
            correctAnswer: "Axan nictlacua", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción presente con marcador temporal"
        }),
        new Exercise({
            id: 163, unitId: 4, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mañana lo harás", // español
            correctAnswer: "Ticchihua moztla", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción futura con marcador temporal"
        }),
        new Exercise({
            id: 164, unitId: 4, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Duermo en la noche", // español
            correctAnswer: "Nicochi ipan yohual", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción habitual nocturna"
        }),
        new Exercise({
            id: 165, unitId: 4, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ teotlac", // nahuatl
            correctAnswer: ["Quitlacua teotlac", "Quitlacua"], // nahuatl
            placeholder: "Ella come en la tarde",
            points: 20,
            difficulty: "medium",
            explanation: "Quitlacua teotlac significa 'Él/Ella come en la tarde'"
        }),
        new Exercise({
            id: 166, unitId: 4, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ ipan tonalli", // nahuatl
            correctAnswer: ["Nicchihua ipan tonalli", "Nicchihua"], // nahuatl
            placeholder: "Yo hago eso durante el día",
            points: 20,
            difficulty: "medium",
            explanation: "Nicchihua ipan tonalli significa 'Yo hago [algo/eso] durante el día'"
        }),
        new Exercise({
            id: 167, unitId: 4, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Yehuatl cochi ______  ______", // nahuatl
            correctAnswer: ["Yehuatl cochi ipan yohual", "ipan yohual"], // nahuatl
            placeholder: "Él duerme en la noche",
            points: 20,
            difficulty: "medium",
            explanation: "Yehuatl cochi ipan yohual significa 'El duerme en la noche'"
        }),

        // 5 : 5
        new Exercise({
            id: 168, unitId: 5, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Yo como con mi familia", // español
            correctAnswer: "Nehuatl nictlacua iuan nocencal", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción con énfasis en el sujeto y compañía"
        }),
        new Exercise({
            id: 169, unitId: 5, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Ella hace lo correcto", // español
            correctAnswer: "Yehuatl quichihua tlen melahuac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción con énfasis en el sujeto y cualidad"
        }),
        new Exercise({
            id: 170, unitId: 5, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Nosotros dormimos en la noche", // español
            correctAnswer: "Tehuan ticochiceh yohual", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción plural con tiempo específico"
        }),
        new Exercise({
            id: 171, unitId: 5, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Nehuatl nicchihua ______ ______", // nahuatl
            correctAnswer: ["Nehuatl nicchihua ipan tonalli", "ipan tonalli"], // nahuatl
            placeholder: "Yo hago eso durante el día",
            points: 20,
            difficulty: "medium",
            explanation: "Nehuatl nicchihua ipan tonalli significa 'Yo hago [algo/eso] durante el día'"
        }),
        new Exercise({
            id: 172, unitId: 5, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Yehuatl quitlacua ______ ______", // nahuatl
            correctAnswer: ["Yehuatl quitlacua ipan teotlac", "ipan teotlac"], // nahuatl
            placeholder: "Él come en la tarde",
            points: 20,
            difficulty: "medium",
            explanation: "Yehuatl quitlacua ipan teotlac significa 'Él/Ella come en la tarde'"
        }),
        new Exercise({
            id: 173, unitId: 5, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Tehuan tictlacua ______ ______", // nahuatl
            correctAnswer: ["Tehuan tictlacua iuan mocencal", "iuan mocencal"], // nahuatl
            placeholder: "Nosotros comemos con tu familia",
            points: 20,
            difficulty: "medium",
            explanation: "Tehuan tictlacua iuan mocencal significa 'Nosotros estamos comiendo con tu familia'"
        }),

        // 5 : 6
        new Exercise({
            id: 174, unitId: 6, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hoy, como en la tarde", // español
            correctAnswer: "Axan, nictlacua ipan teotlac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción presente con tiempo específico"
        }),
        new Exercise({
            id: 175, unitId: 6, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Mañana, harás muchas cosas", // español
            correctAnswer: "Moztla, tichihuaz tlen miac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción futura con cantidad"
        }),
        new Exercise({
            id: 176, unitId: 6, levelId: 5, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Hoy, duermo en la noche", // español
            correctAnswer: "Axan, nicochi ipan yohual", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Acción presente nocturna"
        }),
        new Exercise({
            id: 177, unitId: 6, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Moztla, ______ iuan mocencal", // nahuatl
            correctAnswer: ["Moztla, titlacuaz iuan mocencal", "titlacuaz"], // nahuatl
            placeholder: "Mañana, comerás con tu familia",
            points: 20,
            difficulty: "medium",
            explanation: "Moztla, titlacuaz iuan mocencal significa 'Mañana, comerás con tu familia'"
        }),
        new Exercise({
            id: 178, unitId: 6, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Yalhua, ______ tlen melahuac", // nahuatl
            correctAnswer: ["Yalhua, ochihua tlen melahuac", "ochihua"], // nahuatl
            placeholder: "Ayer, el hizo lo correcto",
            points: 20,
            difficulty: "medium",
            explanation: "Yalhua, ochihua tlen melahuac significa 'Ayer, [él/ella] hizo lo correcto'"
        }),
        new Exercise({
            id: 179, unitId: 6, levelId: 5, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Axan, ______ ipan teotlac", // nahuatl
            correctAnswer: ["Axan, niccochi ipan teotlac", "niccochi"], // nahuatl
            placeholder: "Hoy, duermo por la tarde",
            points: 20,
            difficulty: "medium",
            explanation: "Axan, niccochi ipan yohual significa 'Hoy, duermo por la tarde'"
        }),

        // ========== NIVEL 6 ==========
        // 6 : 1
        new Exercise({
            id: 180, unitId: 1, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Más", // español
            correctAnswer: "Oc", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Oc indica más, todavia, aun, comparación de mayor cantidad"
        }),
        new Exercise({
            id: 181, unitId: 1, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Es necesario", // español
            correctAnswer: "Monequi", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Monequi expresa necesidad u obligación"
        }),
        new Exercise({
            id: 182, unitId: 1, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Menos", // español
            correctAnswer: "Ahmo oc", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Ahmo oc significa literalmente 'no más'"
        }),
        new Exercise({
            id: 183, unitId: 1, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ monequi", // nahuatl
            correctAnswer: ["Oc monequi", "Oc"], // nahuatl
            placeholder: "Prefiero",
            points: 20,
            difficulty: "medium",
            explanation: "Oc monequi es 'Prefiero' o 'Es necesario'"
        }),
        new Exercise({
            id: 184, unitId: 1, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ monequi", // nahuatl
            correctAnswer: ["Ahmo monequi", "Ahmo"], // nahuatl
            placeholder: "No es necesario",
            points: 20,
            difficulty: "medium",
            explanation: "Ahmo monequi es 'No es necesario', aqui 'ahmo' tiene la funcion de 'no es..'"
        }),
        new Exercise({
            id: 185, unitId: 1, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ oc", // nahuatl
            correctAnswer: ["Ahmo oc", "Ahmo"], // nahuatl
            placeholder: "Menos",
            points: 20,
            difficulty: "medium",
            explanation: "Ahmo oc es la forma de decir 'menos'"
        }),


        // 6 : 2
        new Exercise({
            id: 186, unitId: 2, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Si, tienes que agradecer", // español
            correctAnswer: "Quēmah, monequi titlazohcamatiz", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Expresión de necesidad enfática"
        }),
        new Exercise({
            id: 187, unitId: 2, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "No es necesario, mañana", // español
            correctAnswer: "Ahmo monequi, moztla", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Negación de necesidad con tiempo futuro"
        }),
        new Exercise({
            id: 188, unitId: 2, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Todavía necesito duermar", // español
            correctAnswer: "Oc monequi nicochi", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Expresión de preferencia futura"
        }),
        new Exercise({
            id: 189, unitId: 2, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Ahmo, ______ nictlacuaz", // nahuatl
            correctAnswer: ["Ahmo, monequi nictlacuaz", "monequi"], // nahuatl
            placeholder: "No, es necesario que coma",
            points: 20,
            difficulty: "medium",
            explanation: "Ahmo, monequi nictlacuaz significa 'No, es necesario que coma'"
        }),
        new Exercise({
            id: 190, unitId: 2, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Oc ______ tichihuaz", // nahuatl
            correctAnswer: ["Oc monequi tichihuaz", "monequi"], // nahuatl
            placeholder: "Prefiero que hagas eso",
            points: 20,
            difficulty: "medium",
            explanation: "Oc monequi tichihuaz significa 'Todavía necesitas hacer [eso]'"
        }),
        new Exercise({
            id: 191, unitId: 2, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ monequi titlazohcamatiz", // nahuatl
            correctAnswer: ["Oc monequi titlazohcamatiz", "Oc"], // nahuatl
            placeholder: "Prefiero que agradezcas",
            points: 20,
            difficulty: "medium",
            explanation: "Oc monequi titlazohcamatiz expresa necesidad enfática"
        }),

        // 6 : 3
        new Exercise({
            id: 192, unitId: 3, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Por favor", // español
            correctAnswer: "Nimitztlatlauhtia", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Nimitztlatlauhtia significa 'por favor' en náhuatl"
        }),
        new Exercise({
            id: 193, unitId: 3, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Come por favor", // español
            correctAnswer: "Nimitztlatlauhtia xictlacua", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Petición educada usando 'tla' y 'xi-'"
        }),
        new Exercise({
            id: 194, unitId: 3, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Duerme por favor", // español
            correctAnswer: "Nimitztlatlauhtia ximocochi", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Petición educada para dormir"
        }),
        new Exercise({
            id: 195, unitId: 3, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ xicchihua", // nahuatl
            correctAnswer: ["Nimitztlatlauhtia xicchihua", "Nimitztlatlauhtia"], // nahuatl
            placeholder: "Por favor, hazlo",
            points: 20,
            difficulty: "medium",
            explanation: "Nimitztlatlauhtia xicchihua es una petición educada para hacer algo"
        }),
        new Exercise({
            id: 196, unitId: 3, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Nimitztlatlauhtia ______", // nahuatl
            correctAnswer: ["Nimitztlatlauhtia xictlacua", "xictlacua"], // nahuatl
            placeholder: "Por favor, come",
            points: 20,
            difficulty: "medium",
            explanation: "Nimitztlatlauhtia xictlacua es la forma correcta de pedir educadamente que coma"
        }),
        new Exercise({
            id: 197, unitId: 3, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Nimitztlatlauhtia ______", // nahuatl
            correctAnswer: ["Nimitztlatlauhtia ximocochi", "ximocochi"], // nahuatl
            placeholder: "Por favor, duerme",
            points: 20,
            difficulty: "medium",
            explanation: "Nimitztlatlauhtia ximocochi es la forma correcta de pedir educadamente que duerma"
        }),

        // 6 : 4
        new Exercise({
            id: 198, unitId: 4, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Prefiero comer", // español
            correctAnswer: "Oc monequi nictlacua", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Expresión de preferencia en presente"
        }),
        new Exercise({
            id: 199, unitId: 4, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "No es necesario que duerma", // español
            correctAnswer: "Ahmo monequi nicochi", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Negación de necesidad futura"
        }),
        new Exercise({
            id: 200, unitId: 4, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Duerme por favor", // español
            correctAnswer: "Nimitztlatlauhtia ximocochi", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Petición educada reiterada"
        }),
        new Exercise({
            id: 201, unitId: 4, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "______ xictlacua", // nahuatl
            correctAnswer: ["Nimitztlatlauhtia xictlacua", "Tla"], // nahuatl
            placeholder: "Por favor, come",
            points: 20,
            difficulty: "medium",
            explanation: "Nimitztlatlauhtia xictlacua es la estructura para peticiones educadas"
        }),
        new Exercise({
            id: 202, unitId: 4, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Oc monequi ______", // nahuatl
            correctAnswer: ["Oc monequi nicchihuaz", "nicchihuaz"], // nahuatl
            placeholder: "Prefiero hacer eso",
            points: 20,
            difficulty: "medium",
            explanation: "Oc monequi nicchihuaz significa 'Prefiero hacer eso'"
        }),
        new Exercise({
            id: 203, unitId: 4, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Ahmo monequi ______", // nahuatl
            correctAnswer: ["Ahmo monequi titlazohcamatiz", "titlazohcamatiz"], // nahuatl
            placeholder: "No es necesario que agradezcas",
            points: 20,
            difficulty: "medium",
            explanation: "Ahmo monequi titlazohcamatiz significa 'No es necesario que [tu] agradezcas'"
        }),

        // 6 : 5
        new Exercise({
            id: 204, unitId: 5, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Yo prefiero hacer eso", // español
            correctAnswer: "Nehuatl oc monequi nicchihuaz", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Expresión personal de preferencia futura"
        }),
        new Exercise({
            id: 205, unitId: 5, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Tú no necesitas hacer eso", // español
            correctAnswer: "Tehuatl ahmo monequi ticchihuaz", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Negación de necesidad para segunda persona"
        }),
        new Exercise({
            id: 206, unitId: 5, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sí, es necesario que él lo haga", // español
            correctAnswer: "Yehuatl quēmah monequi quichihuaz", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Expresión de preferencia para tercera persona"
        }),
        new Exercise({
            id: 207, unitId: 5, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Nehuatl oc monequi ______", // nahuatl
            correctAnswer: ["Nehuatl oc monequi nictlacuaz", "nictlacuaz"], // nahuatl
            placeholder: "Yo prefiero comer esto",
            points: 20,
            difficulty: "medium",
            explanation: "Nehuatl oc monequi nictlacuaz significa 'Yo prefiero comer esto'"
        }),
        new Exercise({
            id: 208, unitId: 5, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Yehuatl oc monequi ______", // nahuatl
            correctAnswer: ["Yehuatl oc monequi quitlacuaz", "quitlacuaz"], // nahuatl
            placeholder: "Ella prefiere comer eso",
            points: 20,
            difficulty: "medium",
            explanation: "Yehuatl oc monequi quitlacuaz significa 'Ella prefiere comer eso'"
        }),
        new Exercise({
            id: 209, unitId: 5, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Tehuatl ahmo monequi ______", // nahuatl
            correctAnswer: ["Tehuatl ahmo monequi ticchihuaz", "ticchihuaz"], // nahuatl
            placeholder: "Tú no necesitas hacer eso",
            points: 20,
            difficulty: "medium",
            explanation: "Tehuatl ahmo monequi ticchihuaz significa 'Tú no necesitas hacer eso'"
        }),

        // 6 : 6
        new Exercise({
            id: 210, unitId: 6, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Sí, es necesario que yo esté aquí", // español
            correctAnswer: "Quēmah monequi nicac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Expresión de preferencia sobre estado"
        }),
        new Exercise({
            id: 211, unitId: 6, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "No es necesario que estés allí", // español
            correctAnswer: "Ahmo monequi tica ompa", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Negación de necesidad de ubicación"
        }),
        new Exercise({
            id: 212, unitId: 6, levelId: 6, language: "nhce",
            type: "multiple-choice",
            question: "Selecciona la traducción correcta",
            answer: "Por favor, agradece mucho", // español
            correctAnswer: "Nimitztlatlauhtia xitlazohcamati miac", // nahuatl
            points: 15,
            difficulty: "medium",
            explanation: "Petición educada con intensidad"
        }),
        new Exercise({
            id: 213, unitId: 6, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Quēmah, ______ ______", // nahuatl
            correctAnswer: ["Quēmah, cualli tonalli", "cualli tonalli"], // nahuatl
            placeholder: "Sí, buen día",
            points: 20,
            difficulty: "medium",
            explanation: "Quēmah cualli tonalli significa 'Sí, buen día'"
        }),
        new Exercise({
            id: 214, unitId: 6, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Ahmo monequi ______ ______", // nahuatl
            correctAnswer: ["Ahmo monequi nicchihua moztla", "nicchihua moztla"], // nahuatl
            placeholder: "No es necesario, lo hago mañana",
            points: 20,
            difficulty: "medium",
            explanation: "Ahmo monequi nicchihua moztla significa 'No es necesario, lo hago mañana'"
        }),
        new Exercise({
            id: 215, unitId: 6, levelId: 6, language: "nhce",
            type: "fill-blank",
            question: "Completa la frase:",
            answer: "Nimitztlatlauhtia ximocochi ______ ______", // nahuatl
            correctAnswer: ["Nimitztlatlauhtia ximocochi ipan yohual", "ipan yohual"], // nahuatl
            placeholder: "Por favor, duerme en la noche",
            points: 20,
            difficulty: "medium",
            explanation: "Nimitztlatlauhtia ximocochi ipan yohual significa 'Duerme por favor en la noche'"
        })
    ],
};

// ================= ACTUALIZAR VOCABULARIO DE UNIDADES =================
function updateUnitsVocabulary() {
    // console.log('🔄 INICIANDO ACTUALIZACIÓN DE VOCABULARIO');

    // Función de mapeo de unidades
    function getUnitMapping(levelId, uiUnitId) {
        if (levelId === 1) {
            return {
                uiUnitId: uiUnitId,
                exerciseUnitId: uiUnitId,
                description: `Nivel 1: UI ${uiUnitId} → Ejercicios ${uiUnitId}`
            };
        } else {

            const exerciseUnitId = ((uiUnitId - 1) % 6) + 1;

            return {
                uiUnitId: uiUnitId,
                exerciseUnitId: exerciseUnitId,
                description: `Nivel ${levelId}: UI ${uiUnitId} → Ejercicios ${exerciseUnitId}`
            };
        }
    }

    // Función para extraer palabras de ejercicios CON soporte para arrays
    function extractWordsFromExercises(uiUnitId, levelId, language) {
        const exercises = EXERCISES_DATA[language] || [];
        const words = new Set();

        // Aplicar el mapeo de unidades
        const unitMapping = getUnitMapping(levelId, uiUnitId);

        exercises.forEach(exercise => {
            // Buscar ejercicios usando el unitId mapeado
            if (exercise.levelId === levelId && exercise.unitId === unitMapping.exerciseUnitId) {

                // Variables para almacenar información del ejercicio cuando haya errores
                let hasErrors = false;
                const errorInfo = {
                    exerciseId: exercise.id,
                    levelId: exercise.levelId,
                    unitId: exercise.unitId,
                    uiUnitId: uiUnitId,
                    missingWords: [],
                    missingMappings: []
                };

                // 1. Buscar en el correctAnswer
                if (exercise.correctAnswer) {
                    let correctAnswers = [];

                    // Si es array, usar todas las respuestas
                    if (Array.isArray(exercise.correctAnswer)) {
                        correctAnswers = exercise.correctAnswer;
                    } else {
                        // Si es string, convertir a array con un solo elemento
                        correctAnswers = [exercise.correctAnswer];
                    }

                    correctAnswers.forEach(answer => {
                        if (typeof answer === 'string') {
                            answer.split(' ').forEach(word => {
                                const cleanWord = word.replace(/[.,!?;]/g, '').trim();
                                if (cleanWord && VOCABULARY_DATA[language]?.[cleanWord]) {
                                    words.add(cleanWord);
                                } else if (cleanWord) {
                                    // Palabra no encontrada - registrar error
                                    hasErrors = true;
                                    errorInfo.missingWords.push(cleanWord);
                                }
                            });
                        }
                    });
                }

                // 2. Buscar correspondencias en español → náhuatl
                if (exercise.answer && typeof exercise.answer === 'string') {
                    const spanishWords = exercise.answer.split(/[\s,]+/).map(word =>
                        word.replace(/[.,!?;]/g, '').trim().toLowerCase()
                    ).filter(word => word.length > 0);

                    spanishWords.forEach(spanishWord => {
                        let found = false;
                        for (const nahuatlWord in VOCABULARY_DATA[language] || {}) {
                            const vocabItem = VOCABULARY_DATA[language][nahuatlWord];
                            if (vocabItem.translation &&
                                vocabItem.translation.toLowerCase().includes(spanishWord)) {
                                words.add(nahuatlWord);
                                found = true;
                                break;
                            }
                        }
                        if (!found) {
                            // Mapeo no encontrado - registrar error
                            hasErrors = true;
                            errorInfo.missingMappings.push(spanishWord);
                        }
                    });
                }

                // 3. Mostrar información del ejercicio SOLO si hay errores
                if (hasErrors) {
                    console.log(`❌ ERRORES en: Nivel ${errorInfo.levelId} | Unidad ${errorInfo.unitId} | Id ${errorInfo.exerciseId} → Ejercicio ${errorInfo.unitId}):`);

                    if (errorInfo.missingWords.length > 0) {
                        console.log(`❌ Palabra:`, errorInfo.missingWords);
                    }

                    if (errorInfo.missingMappings.length > 0) {
                        console.log(`❌ Esp → Nahua:`, errorInfo.missingMappings);
                    }

                    console.log(`   ❓ Pregunta: "${exercise.question}"`);
                    console.log(`   📝 Tipo: ${exercise.type}`);
                }
            }
        });

        return Array.from(words);
    }

    // PRIMERO: Procesar todas las unidades para obtener su vocabulario base
    const unitVocabularies = {};

    for (const language in UNITS_DATA) {
        unitVocabularies[language] = {};
        UNITS_DATA[language].forEach(unit => {
            // console.log(`🔄 PROCESANDO VOCABULARIO BASE - Unidad UI ${unit.id} (Nivel ${unit.levelId})`);
            const words = extractWordsFromExercises(unit.id, unit.levelId, language);
            unitVocabularies[language][unit.id] = words;
        });
    }

    // SEGUNDO: Aplicar vocabulario con herencia en orden de niveles
    for (const language in UNITS_DATA) {
        // Ordenar unidades por nivel
        const sortedUnits = [...UNITS_DATA[language]].sort((a, b) => a.levelId - b.levelId);

        sortedUnits.forEach(unit => {
            // console.log(`🎯 APLICANDO VOCABULARIO CON HERENCIA - Unidad UI ${unit.id} (Nivel ${unit.levelId})`);

            const allWords = new Set();

            // 1. Agregar vocabulario base de esta unidad
            const baseWords = unitVocabularies[language][unit.id] || [];
            baseWords.forEach(word => allWords.add(word));

            // 2. Agregar vocabulario de niveles anteriores
            if (unit.levelId > 1) {
                // console.log(`📚 Heredando vocabulario de niveles anteriores...`);

                // Buscar todas las unidades de niveles anteriores
                const previousUnits = UNITS_DATA[language].filter(u => u.levelId < unit.levelId);
                previousUnits.forEach(prevUnit => {
                    const prevWords = unitVocabularies[language][prevUnit.id] || [];
                    prevWords.forEach(word => {
                        // console.log(`➕ Heredando: ${word} de Unidad UI ${prevUnit.id}`);
                        allWords.add(word);
                    });
                });
            }

            // 3. Aplicar vocabulario final a la unidad
            const finalWords = Array.from(allWords);
            unit.vocabulary = getVocabularyByWords(language, finalWords);

            // console.log(`🏁 VOCABULARIO FINAL Unidad UI ${unit.id}:`, {
            //     totalPalabras: finalWords.length,
            //     palabras: finalWords
            // });
        });
    }

    // console.log('✅ ACTUALIZACIÓN DE VOCABULARIO COMPLETADA');

    // Verificación final
    // console.log('📊 RESUMEN FINAL:');
    for (const language in UNITS_DATA) {
        const unitsWithVocab = UNITS_DATA[language].filter(unit =>
            unit.vocabulary && Object.keys(unit.vocabulary).length > 0
        );
        // console.log(`✅ ${language}: ${unitsWithVocab.length}/${UNITS_DATA[language].length} unidades con vocabulario`);

        // Mostrar estadísticas por nivel
        const levels = [...new Set(UNITS_DATA[language].map(u => u.levelId))].sort();
        levels.forEach(level => {
            const levelUnits = UNITS_DATA[language].filter(u => u.levelId === level);
            const levelUnitsWithVocab = levelUnits.filter(u => u.vocabulary && Object.keys(u.vocabulary).length > 0);
            // console.log(`   Nivel ${level}: ${levelUnitsWithVocab.length}/${levelUnits.length} unidades con vocabulario`);
        });
    }
}

// ================= INICIALIZACIÓN FINAL =================
updateUnitsVocabulary();

// Verificación final
// console.log('✅ INICIALIZACIÓN COMPLETADA - RESUMEN:');
for (const language in UNITS_DATA) {
    const unitsWithVocab = UNITS_DATA[language].filter(unit =>
        unit.vocabulary && Object.keys(unit.vocabulary).length > 0
    );
    const unitsWithoutVocab = UNITS_DATA[language].filter(unit =>
        !unit.vocabulary || Object.keys(unit.vocabulary).length === 0
    );

    // console.log(`📊 ${language}: ${unitsWithVocab.length} unidades con vocabulario, ${unitsWithoutVocab.length} sin vocabulario`);

    // Log de unidades sin vocabulario para debugging
    if (unitsWithoutVocab.length > 0) {
        // console.log(`❌ Unidades sin vocabulario en ${language}:`,
        //     unitsWithoutVocab.map(u => `UI${u.id}(N${u.levelId})`));
    }
}

// ================= FUNCIONES DE BÚSQUEDA =================
export function getLevelById(language, levelId) {
    return LEVELS_DATA[language]?.find(level => level.id === levelId);
}

export function getUnitById(language, unitId) {
    return UNITS_DATA[language]?.find(unit => unit.id === unitId);
}

export function getExercisesByUnitId(language, unitId) {
    return EXERCISES_DATA[language]?.filter(exercise => exercise.unitId === unitId) || [];
}

export function getVocabularyByUnit(language, unitId) {
    const unit = getUnitById(language, unitId);
    return unit ? unit.vocabulary : {};
}