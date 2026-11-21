// src/data/repositories/SyllabaryRepository.js
import { writingApi } from '../../api/apiClient.js'

export class SyllabaryRepository {

    _cache = {}

    async _load(languageId) {
        if (!languageId) return [];
        const key = String(languageId);
        if (this._cache[key]) return this._cache[key];
        try {
            const results = await writingApi.getByLanguage(languageId);
            this._cache[key] = Array.isArray(results) ? results : (results ? [results] : []);
            return this._cache[key];
        } catch (err) {
            console.error('[SyllabaryRepository] _load:', err);
            return [];
        }
    }

    async getWritingSystem(languageId) {
        const data = await this._load(languageId);
        return data[0]?.systemType || 'alphabet';
    }

    async getCurrentWritingSystemInfo(languageId) {
        const data = await this._load(languageId);
        const ws = data[0];
        if (!ws) return this._defaultInfo();
        return {
            name: ws.systemName || 'Sistema de escritura',
            description: ws.description || '',
            notes: this._parseJson(ws.notes, []),
        };
    }

    async getSyllabary(languageId) {
        const data = await this._load(languageId);
        return this._parseJson(data[0]?.characters, []);
    }

    // Devuelve objeto { a: "a", e: "e", i: "i", o: "o" }
    // que es lo que espera WritingSystem.vue para calcular availableVowels
    async getVowels(languageId) {
        const syllabary = await this.getSyllabary(languageId);
        const vowelEntries = syllabary.filter(e => e.type === 'vowel');
        const result = {};
        vowelEntries.forEach(e => {
            result[e.letter] = e.letter;
        });
        return result;
    }

    // Devuelve solo las consonantes simples (type === 'consonant')
    async getConsonants(languageId) {
        const syllabary = await this.getSyllabary(languageId);
        return syllabary
            .filter(e => e.type === 'consonant')
            .map(e => ({ syllables: {}, ...e }));
    }

    // Devuelve los digrafos (type === 'digraph')
    async getSpecialCharacters(languageId) {
        const syllabary = await this.getSyllabary(languageId);
        return syllabary.filter(e => e.type === 'digraph');
    }

    // Devuelve objeto { a: "a", e: "e", i: "i", o: "o" } -> long vowel letters
    async getLongVowels(languageId) {
        const syllabary = await this.getSyllabary(languageId);
        const entries = syllabary.filter(e => e.type === 'longVowel');
        if (!entries.length) return null;
        const map = { 'a': 'a', 'e': 'e', 'i': 'i', 'o': 'o' };
        const accentMap = { 'a': 'a', 'e': 'e', 'i': 'i', 'o': 'o', '\u0101': 'a', '\u0113': 'e', '\u012b': 'i', '\u014d': 'o' };
        const result = {};
        entries.forEach(e => {
            const firstChar = e.letter.charAt(0);
            const baseKey = accentMap[firstChar] || firstChar;
            result[baseKey] = e.letter;
        });
        return result;
    }

    async getAlphabetByType(languageId) {
        const syllabary = await this.getSyllabary(languageId);
        return {
            vowels: syllabary.filter(e => e.type === 'vowel'),
            consonants: syllabary.filter(e => e.type === 'consonant'),
            ejectives: syllabary.filter(e => e.type === 'ejective'),
            longVowels: syllabary.filter(e => e.type === 'longVowel'),
        };
    }

    async getWritingSystemInfo(systemType) {
        return this._defaultInfo();
    }

    _parseJson(str, fallback) {
        if (!str) return fallback;
        try { return JSON.parse(str); } catch { return fallback; }
    }

    _defaultInfo() {
        return { name: 'Sistema de escritura', description: '', notes: [] };
    }
}