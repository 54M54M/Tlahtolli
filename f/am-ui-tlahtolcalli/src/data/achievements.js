// src/data/achievements.js
import { achievementsApi } from '../api/apiClient.js'
import { useAuthStore } from '../stores/auth.js'
import { useCacheStore } from '../stores/cache.js'

function stores() {
    return { auth: useAuthStore(), cache: useCacheStore() }
}

export async function getAchievementsWithStatus(languageTag) {
    const { auth, cache } = stores()
    const key = cache.achievementsKey(auth.user?.id, languageTag)
    const hit = cache.get(key)
    if (hit) return hit
    const data = await achievementsApi.getWithStatus(auth.user?.id, languageTag)
    const result = Array.isArray(data) ? data : []
    cache.set(key, result)
    return result
}

export function invalidateAchievements(languageTag) {
    const { auth, cache } = stores()
    cache.invalidate(cache.achievementsKey(auth.user?.id, languageTag))
}
