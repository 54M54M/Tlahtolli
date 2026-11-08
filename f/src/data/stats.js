// src/data/stats.js
import { statsApi } from '../api/apiClient.js'
import { useAuthStore } from '../stores/auth.js'
import { useCacheStore } from '../stores/cache.js'

function stores() {
    return { auth: useAuthStore(), cache: useCacheStore() }
}

export async function getStatsByLanguage(languageId) {
    const { auth, cache } = stores()
    const key = cache.statsKey(auth.user?.id, languageId)
    const hit = cache.get(key)
    if (hit) return hit
    const data = await statsApi.getByUserLang(auth.user?.id, languageId)
    cache.set(key, data)
    return data
}

export async function getAllStats() {
    const { auth, cache } = stores()
    const key = cache.statsKey(auth.user?.id, 'all')
    const hit = cache.get(key)
    if (hit) return hit

    const results = await statsApi.getByUser(auth.user?.id)
    if (!Array.isArray(results) || results.length === 0) return _defaultStats(auth.user?.id)

    const merged = results.reduce((acc, s) => ({
        userId: s.userId,
        wordsLearned: (acc.wordsLearned || 0) + (s.wordsLearned || 0),
        lessonsCompleted: (acc.lessonsCompleted || 0) + (s.lessonsDone || 0),
        perfectLessons: (acc.perfectLessons || 0) + (s.perfectLess || 0),
        daysStudied: Math.max(acc.daysStudied || 0, s.daysStudied || 0),
        bestStreak: Math.max(acc.bestStreak || 0, s.bestStreak || 0),
        totalMinutes: (acc.totalMinutes || 0) + (s.totalMins || 0),
    }), {})

    cache.set(key, merged)
    return merged
}

export function invalidateStats(languageId) {
    const { auth, cache } = stores()
    cache.invalidate(
        cache.statsKey(auth.user?.id, languageId),
        cache.statsKey(auth.user?.id, 'all'),
    )
}

function _defaultStats(userId) {
    return { userId, wordsLearned: 0, lessonsCompleted: 0, perfectLessons: 0, daysStudied: 0, bestStreak: 0, totalMinutes: 0 }
}
