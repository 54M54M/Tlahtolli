// src/data/learning.js
// Único punto de acceso a datos de aprendizaje.
// Junta apiClient + cacheStore + manejo de errores.
// Las views importan de aquí, nunca de apiClient directamente.

import { learningApi } from '../api/apiClient.js'
import { useAuthStore } from '../stores/auth.js'
import { useCacheStore } from '../stores/cache.js'

function stores() {
    return { auth: useAuthStore(), cache: useCacheStore() }
}

export async function getLevels(force = false) {
    const { auth, cache } = stores()
    const key = cache.levelsKey(auth.selectedLangId, auth.user?.id)
    if (!force) {
        const hit = cache.get(key)
        if (hit) return hit
    }
    const data = await learningApi.getLevels(auth.selectedLangId, auth.user?.id)
    cache.set(key, data)
    return data
}

export async function getUnits(levelId, force = false) {
    const { auth, cache } = stores()
    const key = cache.unitsKey(levelId, auth.user?.id)
    if (!force) {
        const hit = cache.get(key)
        if (hit) return hit
    }
    const data = await learningApi.getUnits(levelId, auth.user?.id)
    cache.set(key, data)
    return data
}

export async function getExercises(unitId) {
    return learningApi.getExercises(unitId)
}

export async function getVocabulary(unitId) {
    return learningApi.getVocabulary(unitId)
}

export async function getQuickExercises(levelId, count = 6) {
    return learningApi.getQuick(levelId, count)
}

/**
 * Resuelve la unidad y su nivel recorriendo los niveles del idioma activo.
 * Usado por LessonView y QuickLevelView al cargar la lección.
 */
export async function findUnitWithLevel(unitId) {
    const levels = await getLevels()
    for (const level of levels) {
        const units = await getUnits(level.id)
        const found = units.find(u => u.id === Number(unitId))
        if (found) return { unit: found, level }
    }
    return { unit: null, level: null }
}

/**
 * Invalida todo lo que cambia al completar una lección:
 * levels (progreso/desbloqueos), units del nivel afectado.
 * Llamar una sola vez desde lessonApi.js tras completeLesson().
 */
export function invalidateAfterLesson(levelId) {
    const { cache } = stores()
    cache.invalidatePrefix('levels')
    if (levelId != null) {
        const { auth } = stores()
        cache.invalidate(cache.unitsKey(levelId, auth.user?.id))
    }
}
