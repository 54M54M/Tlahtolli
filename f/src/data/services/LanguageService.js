import { SUPPORTED_LANGUAGES, LANGUAGE_GROUPS } from '../config/LanguageConfig.js'

export class LanguageService {

    getSupportedLanguages() {
        return Object.values(SUPPORTED_LANGUAGES)
    }

    getLanguageGroups() {
        return Object.entries(LANGUAGE_GROUPS).map(([key, group]) => ({
            id: key,
            ...group,
            languages: group.variants.map(code => SUPPORTED_LANGUAGES[code]),
            expanded: false
        }))
    }

    getLanguageInfo(languageCode) {
        if (!languageCode) return null
        const lang = SUPPORTED_LANGUAGES[String(languageCode).toUpperCase()]
        if (!lang) console.warn(`Idioma no encontrado: ${languageCode}`)
        return lang || null
    }

    getLanguageGroup(languageCode) {
        const lang = this.getLanguageInfo(languageCode)
        if (!lang) return null
        for (const [key, group] of Object.entries(LANGUAGE_GROUPS)) {
            if (group.variants.includes(lang.code.toUpperCase())) return { id: key, ...group }
        }
        return null
    }

    getVariantsForGroup(groupId) {
        const group = LANGUAGE_GROUPS[groupId]
        if (!group) return []
        return group.variants.map(code => SUPPORTED_LANGUAGES[code]).filter(Boolean)
    }

    getRecommendedLanguages() {
        return this.getSupportedLanguages().filter(lang => lang.isRecommended)
    }
}
