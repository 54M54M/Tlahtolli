// src/data/repositories/SyllabaryRepository.js
// Reemplaza la versión que tenía los datos hardcodeados en memoria.
import { writingApi } from '../../api/apiClient.js'

export class SyllabaryRepository {

    // Cache en memoria para no recargar en cada render
    _cache = {}

    async _load(languageId) {
        if (this._cache[languageId]) return this._cache[languageId]
        try {
            const results = await writingApi.getByLanguage(languageId)
            this._cache[languageId] = Array.isArray(results) ? results : [results]
            return this._cache[languageId]
        } catch (err) {
            console.error('[SyllabaryRepository] _load:', err)
            return []
        }
    }

    async getWritingSystem(languageCode) {
        // languageCode aquí es el ID numérico del idioma
        const data = await this._load(languageCode)
        return data[0]?.systemType || 'alphabet'
    }

    async getCurrentWritingSystemInfo(languageId) {
        const data = await this._load(languageId)
        const ws = data[0]
        if (!ws) return this._defaultInfo()
        return {
            name: ws.systemName || 'Sistema de escritura',
            description: ws.description || '',
            notes: this._parseJson(ws.notes, []),
        }
    }

    async getSyllabary(languageId) {
        const data = await this._load(languageId)
        return this._parseJson(data[0]?.characters, [])
    }

    async getVowels(languageId) {
        const syllabary = await this.getSyllabary(languageId)
        const vowelEntry = syllabary.find(e => e.vowel)
        return vowelEntry ? vowelEntry.vowel : {}
    }

    async getConsonants(languageId) {
        const syllabary = await this.getSyllabary(languageId)
        return syllabary.filter(e => e.type === 'consonant')
    }

    async getSpecialCharacters(languageId) {
        const syllabary = await this.getSyllabary(languageId)
        return syllabary.filter(e => e.type === 'digraph')
    }

    async getLongVowels(languageId) {
        const syllabary = await this.getSyllabary(languageId)
        const entries = syllabary.filter(e => e.type === 'longVowel')
        if (!entries.length) return null
        const result = {}
        entries.forEach(e => {
            const key = e.letter?.charAt(0).toLowerCase()
            if (key) result[key] = e.letter
        })
        return result
    }

    async getAlphabetByType(languageId) {
        const syllabary = await this.getSyllabary(languageId)
        return {
            vowels: syllabary.filter(e => e.type === 'vowel'),
            consonants: syllabary.filter(e => e.type === 'consonant'),
            ejectives: syllabary.filter(e => e.type === 'ejective'),
            longVowels: syllabary.filter(e => e.type === 'longVowel'),
        }
    }

    async getWritingSystemInfo(systemType) {
        return this._defaultInfo()
    }

    // ── helpers ───────────────────────────────────────────────────────────────

    _parseJson(str, fallback) {
        if (!str) return fallback
        try { return JSON.parse(str) } catch { return fallback }
    }

    _defaultInfo() {
        return { name: 'Sistema de escritura', description: '', notes: [] }
    }
}