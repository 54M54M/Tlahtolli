export const dictionaryEntries = [
    { spanish: "perro", central: "itzcuintli", oriental: "chichi", occidental: "chichton", example: "Ne itzcuintli istac. (Mi perro es blanco)", category: "animales" },
    { spanish: "gato", central: "miztli", oriental: "mizton", occidental: "miztontli", example: "In miztli cochi. (El gato duerme)", category: "animales" },
    { spanish: "casa", central: "calli", oriental: "calli", occidental: "calli", example: "Nocal yehyectzin. (Mi casa es bonita)", category: "lugares" },
    { spanish: "agua", central: "atl", oriental: "atl", occidental: "atl", example: "Niqui atl. (Bebo agua)", category: "naturaleza" },
    { spanish: "maíz", central: "cintli", oriental: "cintli", occidental: "cintli", example: "Nicua cintli. (Como maíz)", category: "comida" },
    { spanish: "hablar", central: "tlahtoa", oriental: "tajtoa", occidental: "tahtoa", example: "Nitlahtoa náhuatl. (Hablo náhuatl)", category: "verbos" },
    { spanish: "flor", central: "xochitl", oriental: "xochit", occidental: "xochitl", example: "Cualli xochitl. (Bonita flor)", category: "naturaleza" },
    { spanish: "niño", central: "piltontli", oriental: "konet", occidental: "piltzintli", example: "In piltontli choca. (El niño llora)", category: "personas" },
    { spanish: "mujer", central: "cihuatl", oriental: "siwat", occidental: "zihuatl", example: "In cihuatl cuica. (La mujer canta)", category: "personas" },
    { spanish: "hombre", central: "tlacatl", oriental: "takat", occidental: "tlacatl", example: "In tlacatl tequiti. (El hombre trabaja)", category: "personas" }
];

export const dialectVariants = [
    {
        id: "central",
        name: "Central",
        color: "#58CC02",
        documentation: "Alta",
        regions: "Valle de México, Tlaxcala, Puebla",
        speakers: "~1,500,000",
        features: "Conserva muchas características del náhuatl clásico. Pronunciación clara de /tl/ y /tz/.",
    },
    {
        id: "oriental",
        name: "Oriental",
        color: "#FFA500",
        documentation: "Media",
        regions: "Veracruz, Guerrero Oriental",
        speakers: "~500,000",
        features: "Sustitución de /tl/ por /t/ y cambios vocálicos. Influencia de lenguas totonacas.",
    },
    {
        id: "occidental",
        name: "Occidental",
        color: "#FF4B4B",
        documentation: "Baja",
        regions: "Michoacán, Jalisco, Durango, Colima",
        speakers: "~300,000",
        features: "Mayor divergencia del náhuatl clásico. Cambios consonánticos distintivos.",
    },
    {
        id: "all",
        name: "Todas las variantes",
        color: "#A560E8",
        documentation: "Variada",
        regions: "Todo México",
        speakers: "~2,300,000",
        features: "Estudio comparativo de las tres principales variantes dialectales.",
    }
];

export const exerciseData = {
    central: { word: "Itzcuintli", translation: "perro", sentence: "In ___ istac motlaloa.", fullSentence: "In itzcuintli istac motlaloa.", translation_sentence: "El perro blanco corre." },
    oriental: { word: "Chichi", translation: "perro", sentence: "In ___ istac motlaloa.", fullSentence: "In chichi istac motlaloa.", translation_sentence: "El perro blanco corre." },
    occidental: { word: "Chichton", translation: "perro", sentence: "In ___ istac motlaloa.", fullSentence: "In chichton istac motlaloa.", translation_sentence: "El perro blanco corre." }
};

export const levels = [
    {
        id: 1,
        title: "Fundamentos Básicos",
        titleSpanish: "Fundamentos Básicos",
        titleNahuatl: "Achto Tlamachtiliztli",
        description: "Introducción a los sonidos, saludos y vocabulario esencial",
        color: "#58CC02",
        units: 6,
        completedUnits: 2,
    },
    {
        id: 2,
        title: "Conversación Básica",
        titleSpanish: "Conversación Básica",
        titleNahuatl: "Tlahtolpehualiztli",
        description: "Frases comunes y diferencias dialectales básicas",
        color: "#1CB0F6",
        units: 6,
        completedUnits: 0,
    },
    {
        id: 3,
        title: "Gramática Intermedia",
        titleSpanish: "Gramática Intermedia",
        titleNahuatl: "Tlahtolmelauhtiliztli",
        description: "Estructura de oraciones y tiempos verbales",
        color: "#FF9600",
        units: 6,
        completedUnits: 0,
    },
    {
        id: 4,
        title: "Conversación Avanzada",
        titleSpanish: "Conversación Avanzada",
        titleNahuatl: "Huehca Tlahtolizmatiliztli",
        description: "Narrativas y expresiones idiomáticas",
        color: "#A560E8",
        units: 6,
        completedUnits: 0,
    },
    {
        id: 5,
        title: "Fluidez Cultural",
        titleSpanish: "Fluidez Cultural",
        titleNahuatl: "Nemiliztlamatiliztli",
        description: "Literatura, poesía y expresiones culturales",
        color: "#FF4B4B",
        units: 6,
        completedUnits: 0,
    }
];

export const levelUnits = {
    1: [
        {
            id: 1,
            title: "Saludos Básicos",
            color: "#58CC02",
            completed: true,
            objective: "Aprender a saludar en náhuatl en diferentes momentos del día",
            vocabulary: [
                { nahuatl: "Niltze", spanish: "Hola", pronunciation: "nil-tse" },
                { nahuatl: "Cualli tonalli", spanish: "Buenos días", pronunciation: "kua-li to-na-li" },
                { nahuatl: "Cualli tiotlac", spanish: "Buenas tardes", pronunciation: "kua-li tio-tlak" },
                { nahuatl: "Cualli yohualli", spanish: "Buenas noches", pronunciation: "kua-li yo-ua-li" },
            ],
            grammar: "En náhuatl, los saludos suelen comenzar con 'cualli' (bueno/a) seguido del momento del día.",
            exercises: [
                { type: "match", prompt: "Une cada saludo con su significado" },
                { type: "listen", prompt: "Escucha y repite los saludos" },
                { type: "practice", prompt: "Practica los saludos con un diálogo simple" },
            ],
        },
        {
            id: 2,
            title: "Presentaciones",
            color: "#1CB0F6",
            completed: true,
            objective: "Aprender a presentarte y decir tu nombre en náhuatl",
            vocabulary: [
                { nahuatl: "Notoca", spanish: "Me llamo/Mi nombre es", pronunciation: "no-to-ka" },
                { nahuatl: "Tlen motoca?", spanish: "¿Cómo te llamas?", pronunciation: "tlen mo-to-ka" },
                { nahuatl: "Nehuatl ni", spanish: "Yo soy", pronunciation: "ne-uatl ni" },
                { nahuatl: "Tehhuatl ti", spanish: "Tú eres", pronunciation: "te-uatl ti" },
            ],
            grammar: "Para presentarte, usa 'Notoca' seguido de tu nombre. Para preguntar el nombre de alguien, usa 'Tlen motoca?'",
            exercises: [
                { type: "fill", prompt: "Completa las frases con las palabras correctas" },
                { type: "dialogue", prompt: "Practica un diálogo de presentación" },
                { type: "record", prompt: "Graba tu presentación en náhuatl" },
            ],
        },
        {
            id: 3,
            title: "Preguntas Básicas",
            color: "#FF9600",
            completed: false,
            current: true,
            objective: "Aprender a hacer preguntas básicas en náhuatl",
            vocabulary: [
                { nahuatl: "Quenin?", spanish: "¿Cómo?", pronunciation: "ke-nin" },
                { nahuatl: "Tlen?", spanish: "¿Qué?", pronunciation: "tlen" },
                { nahuatl: "Canin?", spanish: "¿Dónde?", pronunciation: "ka-nin" },
                { nahuatl: "Quemman?", spanish: "¿Cuándo?", pronunciation: "kem-man" },
            ],
            grammar: "Las palabras interrogativas en náhuatl suelen ir al principio de la pregunta, similar al español.",
            exercises: [
                { type: "match", prompt: "Une cada palabra interrogativa con su significado" },
                { type: "create", prompt: "Crea preguntas usando las palabras aprendidas" },
                { type: "dialogue", prompt: "Practica un diálogo con preguntas y respuestas" },
            ],
        },
        {
            id: 4,
            title: "Pronombres Personales",
            color: "#A560E8",
            completed: false,
            objective: "Aprender los pronombres personales en náhuatl",
            vocabulary: [
                { nahuatl: "Nehuatl", spanish: "Yo", pronunciation: "ne-uatl" },
                { nahuatl: "Tehhuatl", spanish: "Tú", pronunciation: "te-uatl" },
                { nahuatl: "Yehuatl", spanish: "Él/Ella", pronunciation: "ye-uatl" },
                { nahuatl: "Tehhuan", spanish: "Nosotros", pronunciation: "te-uan" },
                { nahuatl: "Amehhuantin", spanish: "Ustedes", pronunciation: "a-me-uan-tin" },
                { nahuatl: "Yehhuantin", spanish: "Ellos/Ellas", pronunciation: "ye-uan-tin" },
            ],
            grammar: "Los pronombres personales en náhuatl tienen formas independientes y también prefijos que se usan con verbos.",
            exercises: [
                { type: "match", prompt: "Une cada pronombre con su significado" },
                { type: "fill", prompt: "Completa las oraciones con el pronombre correcto" },
                { type: "practice", prompt: "Practica usando los pronombres en frases simples" },
            ],
        },
        {
            id: 5,
            title: "Verbos Básicos",
            color: "#FF4B4B",
            completed: false,
            objective: "Aprender verbos básicos en náhuatl y su conjugación en presente",
            vocabulary: [
                { nahuatl: "Tlacua", spanish: "Comer", pronunciation: "tla-kua" },
                { nahuatl: "Cochi", spanish: "Dormir", pronunciation: "ko-chi" },
                { nahuatl: "Nemi", spanish: "Vivir/Caminar", pronunciation: "ne-mi" },
                { nahuatl: "Tlahtoa", spanish: "Hablar", pronunciation: "tla-toa" },
            ],
            grammar: "Los verbos en náhuatl se conjugan añadiendo prefijos que indican quién realiza la acción: ni- (yo), ti- (tú), etc.",
            exercises: [
                { type: "conjugate", prompt: "Conjuga los verbos en presente" },
                { type: "match", prompt: "Une cada verbo con su significado" },
                { type: "create", prompt: "Crea oraciones simples con los verbos aprendidos" },
            ],
        },
        {
            id: 6,
            title: "Familia",
            color: "#26CCC0",
            completed: false,
            objective: "Aprender vocabulario relacionado con la familia en náhuatl",
            vocabulary: [
                { nahuatl: "Tahtli", spanish: "Padre", pronunciation: "ta-tli" },
                { nahuatl: "Nantli", spanish: "Madre", pronunciation: "nan-tli" },
                { nahuatl: "Icniutl", spanish: "Hermano/a", pronunciation: "ik-ni-utl" },
                { nahuatl: "Piltzintli", spanish: "Niño/a", pronunciation: "pil-tsin-tli" },
                { nahuatl: "Coltzin", spanish: "Abuelo/a", pronunciation: "kol-tsin" },
            ],
            grammar: "Para indicar posesión, se usan prefijos: no- (mi), mo- (tu), i- (su), etc. Por ejemplo: 'notah' (mi padre).",
            exercises: [
                { type: "match", prompt: "Une cada término familiar con su significado" },
                { type: "fill", prompt: "Completa las oraciones con el término familiar correcto" },
                { type: "create", prompt: "Describe a tu familia usando el vocabulario aprendido" },
            ],
        },
    ],
    2: [
        { id: 1, title: "Preguntas Simples", locked: true, dialectVariants: true },
        { id: 2, title: "En el Mercado", locked: true, dialectVariants: true },
        { id: 3, title: "Comida", locked: true, dialectVariants: true, cultural: true },
        { id: 4, title: "Tiempo y Clima", locked: true, dialectVariants: true },
        { id: 5, title: "Direcciones", locked: true, dialectVariants: true },
        { id: 6, title: "Tradiciones", locked: true, cultural: true },
    ],
    3: [
        { id: 1, title: "Verbos Presentes", locked: true, dialectVariants: true },
        { id: 2, title: "Posesivos", locked: true, dialectVariants: true },
        { id: 3, title: "Adjetivos", locked: true, dialectVariants: true },
        { id: 4, title: "Plurales", locked: true, dialectVariants: true },
        { id: 5, title: "Reverenciales", locked: true, dialectVariants: true, cultural: true },
        { id: 6, title: "Poesía Náhuatl", locked: true, cultural: true },
    ],
    4: [
        { id: 1, title: "Narraciones", locked: true, dialectVariants: true },
        { id: 2, title: "Expresiones", locked: true, dialectVariants: true, cultural: true },
        { id: 3, title: "Verbos Complejos", locked: true, dialectVariants: true },
        { id: 4, title: "Medicina Tradicional", locked: true, cultural: true },
        { id: 5, title: "Agricultura", locked: true, dialectVariants: true, cultural: true },
        { id: 6, title: "Cosmovisión", locked: true, cultural: true },
    ],
    5: [
        { id: 1, title: "Códices", locked: true, cultural: true },
        { id: 2, title: "Mitos y Leyendas", locked: true, cultural: true },
        { id: 3, title: "Ceremonias", locked: true, dialectVariants: true, cultural: true },
        { id: 4, title: "Filosofía Náhuatl", locked: true, cultural: true },
        { id: 5, title: "Variaciones Regionales", locked: true, dialectVariants: true },
        { id: 6, title: "Náhuatl Contemporáneo", locked: true, dialectVariants: true, cultural: true },
    ]
};

export const regions = [
    {
        id: "central",
        name: "Náhuatl Central",
        description: "Hablado en el Valle de México, Tlaxcala y partes de Puebla. Es considerado la variante más cercana al náhuatl clásico.",
        communities: ["Milpa Alta", "Tepoztlán", "Tlaxcala", "Puebla Central"],
        position: { top: "45%", left: "48%" },
        color: "#58CC02",
        words: [
            { spanish: "perro", nahuatl: "itzcuintli" },
            { spanish: "niño", nahuatl: "piltontli" },
            { spanish: "hablar", nahuatl: "tlahtoa" },
        ],
    },
    {
        id: "oriental",
        name: "Náhuatl Oriental",
        description: "Hablado principalmente en Veracruz y partes orientales de Guerrero. Tiene influencias de lenguas totonacas.",
        communities: ["Sierra de Zongolica", "Orizaba", "Córdoba", "Guerrero Oriental"],
        position: { top: "55%", left: "60%" },
        color: "#FFA500",
        words: [
            { spanish: "perro", nahuatl: "chichi" },
            { spanish: "niño", nahuatl: "konet" },
            { spanish: "hablar", nahuatl: "tajtoa" },
        ],
    },
    {
        id: "occidental",
        name: "Náhuatl Occidental",
        description: "Hablado en Michoacán, Jalisco, Durango y otras regiones occidentales. Presenta mayor divergencia del náhuatl clásico.",
        communities: ["Michoacán", "Jalisco", "Durango", "Colima"],
        position: { top: "40%", left: "35%" },
        color: "#FF5252",
        words: [
            { spanish: "perro", nahuatl: "chichton" },
            { spanish: "niño", nahuatl: "piltzintli" },
            { spanish: "hablar", nahuatl: "tahtoa" },
        ],
    }
];

export const userData = {
    name: "Miguel Hernández",
    username: "miguel_h",
    level: 12,
    xp: 4850,
    xpToNextLevel: 5000,
    streak: 12,
    totalXP: 4850,
    minutesStudied: 320,
    joinDate: "15 de marzo de 2023",
    profileImage: "/placeholder.svg?height=100&width=100",
};

export const achievementsData = [
    {
        id: 1,
        title: "Primer Día",
        description: "Completaste tu primera lección",
        icon: "🏆",
        earned: true,
        date: "15 de marzo de 2023",
    },
    {
        id: 2,
        title: "Racha de 7 días",
        description: "Estudiaste durante 7 días consecutivos",
        icon: "🔥",
        earned: true,
        date: "22 de marzo de 2023",
    },
    {
        id: 3,
        title: "Vocabulario Básico",
        description: "Aprendiste 50 palabras nuevas",
        icon: "📚",
        earned: true,
        date: "5 de abril de 2023",
    },
    {
        id: 4,
        title: "Racha de 30 días",
        description: "Estudiaste durante 30 días consecutivos",
        icon: "⚡",
        earned: false,
    },
    {
        id: 5,
        title: "Maestro de Saludos",
        description: "Completaste todas las lecciones de saludos",
        icon: "👋",
        earned: true,
        date: "20 de marzo de 2023",
    },
    {
        id: 6,
        title: "Explorador Cultural",
        description: "Completaste 5 lecciones culturales",
        icon: "🏛️",
        earned: false,
    },
    {
        id: 7,
        title: "Políglota Náhuatl",
        description: "Aprendiste las 3 variantes dialectales",
        icon: "🗣️",
        earned: false,
    },
    {
        id: 8,
        title: "Narrador de Historias",
        description: "Completaste 10 historias en náhuatl",
        icon: "📖",
        earned: false,
    }
];

export const statsData = {
    wordsLearned: 78,
    lessonsCompleted: 12,
    perfectLessons: 8,
    daysStudied: 12,
    bestStreak: 12,
    totalXP: 4850,
    averageTimePerDay: 26,
    dialectProgress: {
        central: 65,
        oriental: 40,
        occidental: 25,
    }
};