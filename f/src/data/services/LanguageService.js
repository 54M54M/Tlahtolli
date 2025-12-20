import {
    SUPPORTED_LANGUAGES,
    LANGUAGE_GROUPS,
    // DEFAULT_LANGUAGE,
    LANGUAGE_FAMILIES
} from '../config/LanguageConfig.js';
import { UserRepository } from '../repositories/UserRepository.js';

export class LanguageService {
    constructor() {
        this.userRepo = new UserRepository();
    }

    getSupportedLanguages() {
        return Object.values(SUPPORTED_LANGUAGES);
    }

    getLanguageGroups() {
        return Object.entries(LANGUAGE_GROUPS).map(([key, group]) => ({
            id: key,
            ...group,
            languages: group.variants.map(code => SUPPORTED_LANGUAGES[code]),
            expanded: false
        }));
    }

    getLanguageInfo(languageCode) {
        if (!languageCode) {
            console.warn('Language code is null or undefined');
            return null;
        }

        const code = String(languageCode).toUpperCase();
        const lang = SUPPORTED_LANGUAGES[code];

        if (!lang) {
            console.warn(`Idioma no encontrado: ${languageCode}`);
        }
        return lang || null;
    }

    getLanguageGroup(languageCode) {
        const lang = this.getLanguageInfo(languageCode);
        if (!lang) return null;

        for (const [key, group] of Object.entries(LANGUAGE_GROUPS)) {
            if (group.variants.includes(lang.code.toUpperCase())) {
                return { id: key, ...group };
            }
        }
        return null;
    }

    getRecommendedLanguages() {
        return this.getSupportedLanguages().filter(lang => lang.isRecommended);
    }

    getVariantsForGroup(groupId) {
        const group = LANGUAGE_GROUPS[groupId];
        if (!group) return [];

        return group.variants
            .map(code => SUPPORTED_LANGUAGES[code])
            .filter(Boolean);
    }

    getCurrentLanguage(userId = 1) {
        const user = this.userRepo.getUser(userId);
        // return user?.currentLanguage || DEFAULT_LANGUAGE;
        return user?.currentLanguage;
    }

    setCurrentLanguage(userId, languageCode) {
        const user = this.userRepo.getUser(userId);
        const languageInfo = this.getLanguageInfo(languageCode);

        if (user && languageInfo) {
            if (user.unlockedLanguages.includes(languageCode)) {
                user.currentLanguage = languageCode;
                return { success: true, language: languageInfo };
            } else {
                return { success: false, error: 'LANGUAGE_LOCKED', language: languageInfo };
            }
        }
        return { success: false, error: 'LANGUAGE_NOT_FOUND' };
    }

    getAvailableLanguages(userId) {
        const user = this.userRepo.getUser(userId);
        if (!user) return [];

        return this.getSupportedLanguages().filter(lang =>
            user.unlockedLanguages.includes(lang.code)
        );
    }

    canLearnLanguage(userId, languageCode) {
        const user = this.userRepo.getUser(userId);
        const languageInfo = this.getLanguageInfo(languageCode);
        return !!user && !!languageInfo;
    }

    getLearningPath(languageCode) {
        const language = this.getLanguageInfo(languageCode);
        if (!language) return null;

        const paths = {
            // Náhuatl
            'nhcl': {
                stages: [
                    { level: 1, focus: "Fundamentos y saludos", estimatedTime: "2 semanas", color: "#58CC02" },
                    { level: 2, focus: "Conversación básica", estimatedTime: "3 semanas", color: "#1CB0F6" },
                    { level: 3, focus: "Gramática náhuatl", estimatedTime: "1 mes", color: "#FF9600" },
                    { level: 4, focus: "Conversación avanzada", estimatedTime: "1 mes", color: "#A560E8" },
                    { level: 5, focus: "Fluidez cultural", estimatedTime: "2 meses", color: "#FF4B4B" }
                ],
                totalEstimatedTime: "4-5 meses",
                totalLevels: 5
            },
            'nhce': {
                stages: [
                    { level: 1, focus: "Fundamentos y saludos", estimatedTime: "2 semanas", color: "#58CC02" },
                    { level: 2, focus: "Conversación básica", estimatedTime: "3 semanas", color: "#1CB0F6" },
                    { level: 3, focus: "Gramática intermedia", estimatedTime: "1 mes", color: "#FF9600" },
                    { level: 4, focus: "Conversación avanzada", estimatedTime: "1 mes", color: "#A560E8" },
                    { level: 5, focus: "Fluidez cultural", estimatedTime: "2 meses", color: "#FF4B4B" }
                ],
                totalEstimatedTime: "4-5 meses",
                totalLevels: 5
            },
            'nhhu': {
                stages: [
                    { level: 1, focus: "Sonidos huastecos", estimatedTime: "2 semanas", color: "#4CAF50" },
                    { level: 2, focus: "Vocabulario local", estimatedTime: "3 semanas", color: "#1CB0F6" },
                    { level: 3, focus: "Gramática regional", estimatedTime: "1 mes", color: "#FF9600" },
                    { level: 4, focus: "Diálogos huastecos", estimatedTime: "1 mes", color: "#A560E8" },
                    { level: 5, focus: "Cultura huasteca", estimatedTime: "2 meses", color: "#FF4B4B" }
                ],
                totalEstimatedTime: "4-5 meses",
                totalLevels: 5
            },
            'nhsp': {
                stages: [
                    { level: 1, focus: "Pronunciación serrana", estimatedTime: "2 semanas", color: "#388E3C" },
                    { level: 2, focus: "Frases de la sierra", estimatedTime: "3 semanas", color: "#1CB0F6" },
                    { level: 3, focus: "Gramática de Puebla", estimatedTime: "1 mes", color: "#FF9600" },
                    { level: 4, focus: "Conversación serrana", estimatedTime: "1 mes", color: "#A560E8" },
                    { level: 5, focus: "Tradiciones de la sierra", estimatedTime: "2 meses", color: "#FF4B4B" }
                ],
                totalEstimatedTime: "4-5 meses",
                totalLevels: 5
            },
            'nhgr': {
                stages: [
                    { level: 1, focus: "Acento guerrerense", estimatedTime: "2 semanas", color: "#2E7D32" },
                    { level: 2, focus: "Expresiones locales", estimatedTime: "3 semanas", color: "#1CB0F6" },
                    { level: 3, focus: "Gramática de Guerrero", estimatedTime: "1 mes", color: "#FF9600" },
                    { level: 4, focus: "Diálogos costeños", estimatedTime: "1 mes", color: "#A560E8" },
                    { level: 5, focus: "Cultura guerrerense", estimatedTime: "2 meses", color: "#FF4B4B" }
                ],
                totalEstimatedTime: "4-5 meses",
                totalLevels: 5
            },

            // Teenek (Huasteco)
            'tkoc': {
                stages: [
                    { level: 1, focus: "Sonidos teenek", estimatedTime: "3 semanas", color: "#9C27B0" },
                    { level: 2, focus: "Estructuras básicas", estimatedTime: "1 mes", color: "#7B1FA2" },
                    { level: 3, focus: "Gramática teenek", estimatedTime: "1.5 meses", color: "#6A1B9A" },
                    { level: 4, focus: "Conversación huasteca", estimatedTime: "2 meses", color: "#4A148C" },
                    { level: 5, focus: "Cultura huasteca maya", estimatedTime: "2.5 meses", color: "#38006B" }
                ],
                totalEstimatedTime: "7-8 meses",
                totalLevels: 5
            },

            // Maya Yucateco
            'mayu': {
                stages: [
                    { level: 1, focus: "Alfabeto maya", estimatedTime: "2 semanas", color: "#7B1FA2" },
                    { level: 2, focus: "Frases básicas yucatecas", estimatedTime: "3 semanas", color: "#6A1B9A" },
                    { level: 3, focus: "Gramática maya clásica", estimatedTime: "1 mes", color: "#4A148C" },
                    { level: 4, focus: "Conversación en Yucatán", estimatedTime: "1.5 meses", color: "#38006B" },
                    { level: 5, focus: "Cultura maya yucateca", estimatedTime: "2 meses", color: "#2A004D" }
                ],
                totalEstimatedTime: "5-6 meses",
                totalLevels: 5
            },

            // Tzotzil
            'tzot': {
                stages: [
                    { level: 1, focus: "Fonología tzotzil", estimatedTime: "3 semanas", color: "#6A1B9A" },
                    { level: 2, focus: "Vocabulario chiapaneco", estimatedTime: "1 mes", color: "#5A0B8A" },
                    { level: 3, focus: "Gramática tzotzil", estimatedTime: "1.5 meses", color: "#4A148C" },
                    { level: 4, focus: "Diálogos de los Altos", estimatedTime: "2 meses", color: "#3A047A" },
                    { level: 5, focus: "Cultura tzotzil", estimatedTime: "2.5 meses", color: "#2A006A" }
                ],
                totalEstimatedTime: "7-8 meses",
                totalLevels: 5
            },

            // Tzeltal
            'tzel': {
                stages: [
                    { level: 1, focus: "Sonidos tzeltal", estimatedTime: "3 semanas", color: "#4A148C" },
                    { level: 2, focus: "Expresiones tzeltal", estimatedTime: "1 mes", color: "#3A048C" },
                    { level: 3, focus: "Gramática tzeltal", estimatedTime: "1.5 meses", color: "#2A007C" },
                    { level: 4, focus: "Conversación en Chiapas", estimatedTime: "2 meses", color: "#1A006C" },
                    { level: 5, focus: "Tradiciones tzeltal", estimatedTime: "2.5 meses", color: "#0A005C" }
                ],
                totalEstimatedTime: "7-8 meses",
                totalLevels: 5
            },

            // Mam
            'mamm': {
                stages: [
                    { level: 1, focus: "Pronunciación mam", estimatedTime: "3 semanas", color: "#38006B" },
                    { level: 2, focus: "Vocabulario mam", estimatedTime: "1 mes", color: "#28005B" },
                    { level: 3, focus: "Gramática mam", estimatedTime: "1.5 meses", color: "#18004B" },
                    { level: 4, focus: "Diálogos mam", estimatedTime: "2 meses", color: "#08003B" },
                    { level: 5, focus: "Cultura mam guatemalteca", estimatedTime: "2.5 meses", color: "#00002B" }
                ],
                totalEstimatedTime: "7-8 meses",
                totalLevels: 5
            }
        };

        return paths[languageCode] || null;
    }

    getLanguageComparison() {
        return this.getSupportedLanguages().map(lang => ({
            ...lang,
            learningPath: this.getLearningPath(lang.code),
            isAvailable: (userId) => this.canLearnLanguage(userId, lang.code)
        }));
    }

    switchLanguageContext(userId, languageCode) {
        const result = this.setCurrentLanguage(userId, languageCode);
        if (result.success) {
            console.log(`Contexto cambiado a: ${languageCode} - ${result.language.name}`);
        }
        return result;
    }

    getLanguageProgressSummary(userId) {
        const availableLanguages = this.getAvailableLanguages(userId);
        const currentLanguage = this.getCurrentLanguage(userId);

        return {
            currentLanguage,
            availableLanguages,
            totalLanguages: availableLanguages.length,
            canLearnMore: availableLanguages.length < this.getSupportedLanguages().length
        };
    }

    getLanguageStats(userId, languageCode) {
        const user = this.userRepo.getUser(userId);
        const languageInfo = this.getLanguageInfo(languageCode);

        if (!user || !languageInfo) return null;

        const goals = user.learningGoals[languageCode] || {};
        const isCurrent = user.currentLanguage === languageCode;
        const isUnlocked = user.unlockedLanguages.includes(languageCode);

        return {
            ...languageInfo,
            isCurrent,
            isUnlocked,
            goals,
            learningPath: this.getLearningPath(languageCode)
        };
    }
}