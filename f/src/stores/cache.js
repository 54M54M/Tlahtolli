import { defineStore } from 'pinia'

const TTL = 5 * 60 * 1000 // 5 minutos

export const useCacheStore = defineStore('cache', {
    state: () => ({
        entries: {},
    }),
    actions: {
        _key(...parts) {
            return parts.join(':')
        },
        get(key) {
            const entry = this.entries[key]
            if (!entry) return null
            if (Date.now() - entry.ts > TTL) {
                delete this.entries[key]
                return null
            }
            return entry.data
        },
        set(key, data) {
            this.entries[key] = { data, ts: Date.now() }
        },
        invalidate(...keys) {
            keys.forEach(k => delete this.entries[k])
        },
        invalidatePrefix(prefix) {
            Object.keys(this.entries)
                .filter(k => k.startsWith(prefix))
                .forEach(k => delete this.entries[k])
        },

        // ── helpers por dominio ──────────────────────────────────────────────

        levelsKey(langId, userId) { return this._key('levels', langId, userId) },
        unitsKey(levelId, userId) { return this._key('units', levelId, userId) },
        statsKey(userId, langId) { return this._key('stats', userId, langId) },
        achievementsKey(userId, lang) { return this._key('achievements', userId, lang) },
    },
})
