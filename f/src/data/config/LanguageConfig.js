export const LANGUAGE_FAMILIES = {
    UTO_AZTEC: {
        id: "uto-aztec",
        name: "Uto-azteca",
        color: "#58CC02"
    },
    MAYA: {
        id: "maya",
        name: "Maya",
        color: "#9C27B0"
    }
};

export const SUPPORTED_LANGUAGES = {
    // NÁHUATL - Variantes
    NHCL: {
        id: "nhcl",
        code: "nhcl",
        name: "Náhuatl clásico",
        nativeName: "Nāhuatlahtōlli",
        family: "uto-aztec",
        parent: "nahuatl",
        color: "#58CC02",
        description: "Variante clásica del náhuatl, recomendada para principiantes",
        flag: "🌽",
        difficulty: "easy",
        speakers: "~1,500,000",
        isRecommended: true
    },
    NHCE: {
        id: "nhce",
        code: "nhce",
        name: "Náhuatl central",
        nativeName: "Nāhuatlahtōlli Central",
        family: "uto-aztec",
        parent: "nahuatl",
        color: "#58CC02",
        description: "Variante central del náhuatl hablado en el Valle de México",
        flag: "🌽",
        difficulty: "intermediate",
        speakers: "~1,500,000",
    },
    NHHU: {
        id: "nhhu",
        code: "nhhu",
        name: "Náhuatl de la Huasteca",
        nativeName: "Nāhuatlahtōlli Huastecah",
        family: "uto-aztec",
        parent: "nahuatl",
        color: "#4CAF50",
        description: "Variante hablada en la región huasteca",
        flag: "🏞️",
        difficulty: "intermediate",
        speakers: "~200,000"
    },
    NHSP: {
        id: "nhsp",
        code: "nhsp",
        name: "Náhuatl de la Sierra de Puebla",
        nativeName: "Nāhuatlahtōlli Sierra Puebla",
        family: "uto-aztec",
        parent: "nahuatl",
        color: "#388E3C",
        description: "Variante de la Sierra Norte de Puebla",
        flag: "⛰️",
        difficulty: "intermediate",
        speakers: "~150,000"
    },
    NHGR: {
        id: "nhgr",
        code: "nhgr",
        name: "Náhuatl de Guerrero",
        nativeName: "Nāhuatlahtōlli Guerrero",
        family: "uto-aztec",
        parent: "nahuatl",
        color: "#2E7D32",
        description: "Variante del estado de Guerrero",
        flag: "🌵",
        difficulty: "intermediate",
        speakers: "~100,000"
    },

    // MAYA
    TKOC: {
        id: "tkoc",
        code: "tkoc",
        name: "Teenek (Huasteco)",
        nativeName: "Teenek",
        family: "maya",
        parent: "maya-family",
        color: "#9C27B0",
        description: "Idioma huasteco de la familia maya",
        flag: "🏞️",
        difficulty: "advanced",
        speakers: "~120,000",
        isRecommended: true
    },
    MAYU: {
        id: "mayu",
        code: "mayu",
        name: "Maya yucateco",
        nativeName: "Maaya t'aan",
        family: "maya",
        parent: "maya-family",
        color: "#7B1FA2",
        description: "Variante maya de Yucatán",
        flag: "🏛️",
        difficulty: "intermediate",
        speakers: "~800,000"
    },
    TZOT: {
        id: "tzot",
        code: "tzot",
        name: "Tzotzil",
        nativeName: "Bats'i k'op",
        family: "maya",
        parent: "maya-family",
        color: "#6A1B9A",
        description: "Lengua maya de Chiapas",
        flag: "⛰️",
        difficulty: "advanced",
        speakers: "~400,000"
    },
    TZEL: {
        id: "tzel",
        code: "tzel",
        name: "Tzeltal",
        nativeName: "Bats'il k'op",
        family: "maya",
        parent: "maya-family",
        color: "#4A148C",
        description: "Lengua maya de los Altos de Chiapas",
        flag: "🌄",
        difficulty: "advanced",
        speakers: "~450,000"
    },
    MAMM: {
        id: "mamm",
        code: "mamm",
        name: "Mam",
        nativeName: "Qyool Mam",
        family: "maya",
        parent: "maya-family",
        color: "#38006B",
        description: "Lengua maya de Guatemala y Chiapas",
        flag: "🌋",
        difficulty: "advanced",
        speakers: "~500,000"
    }
};

export const LANGUAGE_GROUPS = {
    // Grupo Náhuatl
    nahuatl: {
        name: "Náhuatl",
        description: "Familia lingüística uto-azteca",
        color: "#58CC02",
        variants: ["NHCE"]
        // variants: ["NHCL", "NHCE", "NHHU", "NHSP", "NHGR"]
    },

    // Grupo Maya
    // "maya-family": {
    //     name: "Maya",
    //     description: "Familia lingüística maya",
    //     color: "#9C27B0",
    //     variants: ["TKOC", "MAYU", "TZOT", "TZEL", "MAMM"]
    // }
};

// export const DEFAULT_LANGUAGE = "nhcl";

export const EXERCISE_TYPES = {
    MULTIPLE_CHOICE: "multiple-choice",
    FILL_BLANK: "fill-blank",
    MATCH: "match",
    CONJUGATE: "conjugate",
    CREATE: "create",
    LISTEN: "listen"
};