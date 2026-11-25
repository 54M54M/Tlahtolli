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

/** opts.optional: si falla sin conexión no muestra la pantalla de "Sin conexión" (p. ej. vocabulario de repaso). */
export async function getVocabulary(unitId, opts) {
    return learningApi.getVocabulary(unitId, opts)
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

// ── Acceso: niveles y unidades bloqueados no se abren aunque se escriba la URL ──
// (el backend también lo valida al completar; esto evita mostrar la vista)

/** El nivel es del idioma activo y está desbloqueado. */
export async function canOpenLevel(levelId) {
    const level = (await getLevels()).find(l => l.id === Number(levelId))
    return !!level && !level.locked
}

/** La unidad es del idioma activo, su nivel está desbloqueado y la unidad también. */
export async function canOpenUnit(unitId) {
    const { unit, level } = await findUnitWithLevel(unitId)
    return !!unit && !unit.locked && !!level && !level.locked
}

/** Nivel en curso: el primero desbloqueado sin terminar (o el último desbloqueado). */
export async function currentLevelId() {
    const open = (await getLevels()).filter(l => !l.locked).sort((a, b) => a.levelNum - b.levelNum)
    const level = open.find(l => l.completedUnits < l.totalUnits) || open[open.length - 1]
    return level?.id ?? null
}

/** Lección en curso: la marcada como actual del nivel en curso (o la primera abierta sin completar). */
export async function currentUnitId() {
    const levelId = await currentLevelId()
    if (levelId == null) return null
    const open = (await getUnits(levelId)).filter(u => !u.locked)
    const unit = open.find(u => u.current && !u.completed) || open.find(u => !u.completed) || open[open.length - 1]
    return unit?.id ?? null
}

/**
 * Invalida todo lo que cambia al completar una lección:
 * levels (progreso/desbloqueos) y units (desbloqueos, también del nivel siguiente).
 * Llamar una sola vez desde lessonApi.js tras completeLesson().
 */
export function invalidateAfterLesson(levelId) { // eslint-disable-line no-unused-vars
    const { cache } = stores()
    cache.invalidatePrefix('levels')
    // Todas las unidades: al terminar un nivel se desbloquean las del siguiente,
    // y la validación de acceso de las rutas las lee de esta caché
    cache.invalidatePrefix('units')
}
