import { DictionaryEntry } from '../models/DictionaryEntry.js';

export class DictionaryRepository {
    constructor() {
        this.entries = new Map();
        this.categories = new Set();
        this.loadInitialData();
    }

    loadInitialData() {
        const initialEntries = [
            // Entradas Náhuatl Central
            new DictionaryEntry({
                id: 1, spanish: "Pasado mañana", language: "nhce",
                central: "acalpatiotl", oriental: "acalpatiot", occidental: "acalpatiot",
                example: "Pasado mañana vendrá mi pueblo. (Acalpatiotl quinequi noaltepil huitz.)",
                category: "tiempo", difficulty: "medium", frequency: 2
            }),
            new DictionaryEntry({
                id: 2, spanish: "Comprender, entender", language: "nhce",
                central: "acicamati", oriental: "acicamati", occidental: "acicamati",
                example: "Entiende el conocimiento. (Tlaacicamati in tlamachtiliztli.)",
                category: "verbos", difficulty: "hard", frequency: 4
            }),
            new DictionaryEntry({
                id: 3, spanish: "perro", language: "nhce",
                central: "itzcuintli", oriental: "chichi", occidental: "chichton",
                example: "Mi perro es blanco. (Ne itzcuintli istac.)",
                category: "animales", difficulty: "easy", frequency: 5
            }),

            // NUEVAS ENTRADAS TEENEK OCCIDENTAL
            new DictionaryEntry({
                id: 100, spanish: "Buenos días", language: "tkoc",
                teenek: "Bix a beel", pronunciation: "bish a bel",
                example: "Bix a beel, ¿bix yaanam? - Buenos días, ¿cómo estás?",
                category: "saludos", difficulty: "easy", frequency: 5
            }),
            new DictionaryEntry({
                id: 101, spanish: "Buenas tardes", language: "tkoc",
                teenek: "Bix a k'iin", pronunciation: "bish a k'in",
                example: "Bix a k'iin, ¿bix a wàay? - Buenas tardes, ¿cómo estás?",
                category: "saludos", difficulty: "easy", frequency: 4
            }),
            new DictionaryEntry({
                id: 102, spanish: "Gracias", language: "tkoc",
                teenek: "Waal a b'ixik", pronunciation: "waal a bish-ik",
                example: "Waal a b'ixik ti' - Muchas gracias",
                category: "saludos", difficulty: "easy", frequency: 5
            }),
            new DictionaryEntry({
                id: 103, spanish: "Agua", language: "tkoc",
                teenek: "Ja'", pronunciation: "ha",
                example: "Tin ja' u ch'een - El agua está en el pozo",
                category: "naturaleza", difficulty: "easy", frequency: 4
            }),
            new DictionaryEntry({
                id: 104, spanish: "Fuego", language: "tkoc",
                teenek: "K'aak", pronunciation: "k'aak",
                example: "U k'aak u ch'een - El fuego de la casa",
                category: "naturaleza", difficulty: "easy", frequency: 3
            }),
            new DictionaryEntry({
                id: 105, spanish: "Maíz", language: "tkoc",
                teenek: "Ixi'im", pronunciation: "ishi-im",
                example: "Ta k'axal ixi'im - Vamos a cosechar maíz",
                category: "comida", difficulty: "medium", frequency: 4
            }),
            new DictionaryEntry({
                id: 106, spanish: "Frijol", language: "tkoc",
                teenek: "Bu'ul", pronunciation: "bu-ul",
                example: "In bu'ul u pach - Los frijoles están cocidos",
                category: "comida", difficulty: "medium", frequency: 3
            }),
            new DictionaryEntry({
                id: 107, spanish: "Casa", language: "tkoc",
                teenek: "Ch'een", pronunciation: "ch'en",
                example: "In ch'een u yotoch - Esta casa es mi hogar",
                category: "lugares", difficulty: "easy", frequency: 4
            }),
            new DictionaryEntry({
                id: 108, spanish: "Pueblo", language: "tkoc",
                teenek: "Kaaj", pronunciation: "kaah",
                example: "In kaaj u yok'ol - El pueblo está lejos",
                category: "lugares", difficulty: "easy", frequency: 3
            }),
            new DictionaryEntry({
                id: 109, spanish: "Hombre", language: "tkoc",
                teenek: "Winik", pronunciation: "winik",
                example: "In winik u ch'een - El hombre de la casa",
                category: "personas", difficulty: "easy", frequency: 4
            }),
            new DictionaryEntry({
                id: 110, spanish: "Mujer", language: "tkoc",
                teenek: "Ch'up", pronunciation: "ch'up",
                example: "In ch'up u pàal - La mujer y el niño",
                category: "personas", difficulty: "easy", frequency: 4
            }),
            new DictionaryEntry({
                id: 111, spanish: "Niño", language: "tkoc",
                teenek: "Paal", pronunciation: "paal",
                example: "In paal u ch'een - El niño de la casa",
                category: "personas", difficulty: "easy", frequency: 4
            }),
            new DictionaryEntry({
                id: 112, spanish: "Sol", language: "tkoc",
                teenek: "K'iin", pronunciation: "k'in",
                example: "U k'iin u yok'ol - El sol está arriba",
                category: "naturaleza", difficulty: "easy", frequency: 4
            }),
            new DictionaryEntry({
                id: 113, spanish: "Luna", language: "tkoc",
                teenek: "Uj", pronunciation: "uh",
                example: "U uj u ch'een - La luna de la noche",
                category: "naturaleza", difficulty: "easy", frequency: 3
            }),
            new DictionaryEntry({
                id: 114, spanish: "Estrella", language: "tkoc",
                teenek: "Ek'", pronunciation: "ek",
                example: "Miak ek' u ch'een - Muchas estrellas en el cielo",
                category: "naturaleza", difficulty: "easy", frequency: 3
            })
        ];

        initialEntries.forEach(entry => {
            this.entries.set(entry.id, entry);
            this.categories.add(entry.category);
        });
    }

    getAllEntries(language = null) {
        const entries = Array.from(this.entries.values());
        if (language) {
            return entries.filter(entry => entry.language === language);
        }
        return entries;
    }

    getEntry(entryId) {
        return this.entries.get(entryId);
    }

    // búsquedas más flexibles
    searchEntries(query, language = null) {
        const entries = this.getAllEntries(language);
        const lowerQuery = query.toLowerCase().trim();

        return entries.filter(entry =>
            entry.spanish.toLowerCase().includes(lowerQuery) ||
            entry.central.toLowerCase().includes(lowerQuery) ||
            entry.oriental.toLowerCase().includes(lowerQuery) ||
            entry.occidental.toLowerCase().includes(lowerQuery) ||
            entry.teenek.toLowerCase().includes(lowerQuery) ||
            entry.category.toLowerCase().includes(lowerQuery) ||
            // Búsqueda por coincidencia parcial en español
            this.fuzzyMatch(entry.spanish.toLowerCase(), lowerQuery)
        );
    }

    // coincidencia flexible
    fuzzyMatch(text, search) {
        if (!search) return true;

        // Coincidencia exacta
        if (text.includes(search)) return true;

        // Coincidencia por palabras individuales
        const searchWords = search.split(' ');
        const textWords = text.split(' ');

        return searchWords.every(searchWord =>
            textWords.some(textWord => textWord.includes(searchWord))
        );
    }

    getEntriesByCategory(category, language = null) {
        const entries = this.getAllEntries(language);
        return entries.filter(entry => entry.category === category);
    }

    getCategories(language = null) {
        const entries = this.getAllEntries(language);
        const categories = new Set(entries.map(entry => entry.category));
        return Array.from(categories).sort();
    }

    getRandomEntries(count = 10, language = null, difficulty = null) {
        let entries = this.getAllEntries(language);

        if (difficulty) {
            entries = entries.filter(entry => entry.difficulty === difficulty);
        }

        // Mezclar array
        const shuffled = entries.sort(() => 0.5 - Math.random());
        return shuffled.slice(0, count);
    }

    addEntry(entryData) {
        const entry = new DictionaryEntry(entryData);
        this.entries.set(entry.id, entry);
        this.categories.add(entry.category);
        return entry;
    }

    getWordOfTheDay(language = null) {
        const entries = this.getAllEntries(language);
        if (entries.length === 0) return null;

        const today = new Date();
        const dayOfYear = Math.floor((today - new Date(today.getFullYear(), 0, 0)) / 1000 / 60 / 60 / 24);
        const index = dayOfYear % entries.length;

        return entries[index];
    }

    getLanguageStats(language) {
        const entries = this.getAllEntries(language);
        const categories = this.getCategories(language);

        return {
            totalWords: entries.length,
            categories: categories.length,
            difficultyBreakdown: {
                easy: entries.filter(e => e.difficulty === 'easy').length,
                medium: entries.filter(e => e.difficulty === 'medium').length,
                hard: entries.filter(e => e.difficulty === 'hard').length
            }
        };
    }
}