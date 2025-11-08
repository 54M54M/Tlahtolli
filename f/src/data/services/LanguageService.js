import { SUPPORTED_LANGUAGES, DEFAULT_LANGUAGE } from '../config/LanguageConfig.js';
import { UserRepository } from '../repositories/UserRepository.js';

export class LanguageService {
    constructor() {
        this.userRepo = new UserRepository();
    }

    getSupportedLanguages() {
        console.log('Getting supported languages:', Object.values(SUPPORTED_LANGUAGES));
        return Object.values(SUPPORTED_LANGUAGES);
    }

    getLanguageInfo(languageCode) {
        // Verificar si languageCode es null o undefined
        if (!languageCode) {
            console.warn('Language code is null or undefined');
            return null;
        }

        // Asegurarse de que languageCode sea string
        const code = String(languageCode).toUpperCase();
        const lang = SUPPORTED_LANGUAGES[code];

        if (!lang) {
            console.warn(`Idioma no encontrado: ${languageCode}`);
        }
        return lang || null;
    }

    getCurrentLanguage(userId = 1) {
        const user = this.userRepo.getUser(userId);
        return user?.currentLanguage || DEFAULT_LANGUAGE;
    }

    setCurrentLanguage(userId, languageCode) {
        const user = this.userRepo.getUser(userId);
        const languageInfo = this.getLanguageInfo(languageCode);

        if (user && languageInfo) {
            // Verificar que el idioma esté desbloqueado (todos están desbloqueados ahora)
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
            'tkoc': {
                stages: [
                    { level: 1, focus: "Sonidos básicos y saludos", estimatedTime: "3 semanas", color: "#9C27B0" },
                    { level: 2, focus: "Estructuras básicas", estimatedTime: "1 mes", color: "#7B1FA2" },
                    { level: 3, focus: "Gramática teenek", estimatedTime: "1.5 meses", color: "#6A1B9A" },
                    { level: 4, focus: "Conversación", estimatedTime: "2 meses", color: "#4A148C" },
                    { level: 5, focus: "Cultura huasteca", estimatedTime: "2.5 meses", color: "#38006B" }
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