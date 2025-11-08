export class DictionaryEntry {
    constructor(data = {}) {
        this.id = data.id || Date.now();
        this.spanish = data.spanish || "";
        this.language = data.language || "nhce";
        this.central = data.central || "";
        this.oriental = data.oriental || "";
        this.occidental = data.occidental || "";
        this.teenek = data.teenek || "";
        this.pronunciation = data.pronunciation || "";
        this.example = data.example || "";
        this.category = data.category || "general";
        this.difficulty = data.difficulty || "easy";
        this.tags = data.tags || [];
        this.frequency = data.frequency || 1;
    }

    getTranslation(language = null, dialect = "central") {
        const targetLanguage = language || this.language;
        const translations = {
            "nhce": {
                "central": this.central,
                "oriental": this.oriental,
                "occidental": this.occidental
            },
            "tkoc": {
                "occidental": this.teenek
            }
        };

        return translations[targetLanguage]?.[dialect] || this.spanish;
    }

    hasDialect(dialect) {
        const dialectMap = {
            "nhce": ["central", "oriental", "occidental"],
            "tkoc": ["occidental"]
        };

        return dialectMap[this.language]?.includes(dialect) || false;
    }

    getAvailableDialects() {
        const dialectMap = {
            "nhce": ["central", "oriental", "occidental"],
            "tkoc": ["occidental"]
        };

        return dialectMap[this.language] || [];
    }

    getNativeWord() {
        if (this.language === "tkoc") {
            return this.teenek;
        }
        return this.central || this.oriental || this.occidental;
    }
}