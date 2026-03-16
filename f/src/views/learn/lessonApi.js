// src/views/learn/lessonApi.js
// Mixin/composable con la lógica de carga y completado de lección
// que usa la API. Se importa en LessonView.vue y QuickLevelView.vue.

import { learningApi, progressApi } from '../../api/apiClient.js'
import { useAuthStore } from '../../stores/auth.js'
import { useEnergyStore } from '../../stores/energy.js'

/**
 * Carga los datos de una lección dado el unitId.
 * Devuelve { currentUnit, currentLevel, currentExercises, vocabulary }
 */
export async function loadLessonData(unitId) {
    const auth = useAuthStore()
    const userId = auth.user?.id || 1
    const langId = auth.selectedLangId

    // 1. Cargar ejercicios de la unidad
    const exercises = await learningApi.getExercises(unitId)

    // 2. Cargar vocabulario para PronunciationTooltip
    const vocabulary = await learningApi.getVocabulary(unitId)

    // 3. Buscar la unidad y su nivel recorriendo los niveles del idioma
    const levels = await learningApi.getLevels(langId, userId)
    let currentUnit = null
    let currentLevel = null

    for (const level of levels) {
        const units = await learningApi.getUnits(level.id, userId)
        const found = units.find(u => u.id === Number(unitId))
        if (found) {
            currentUnit = found
            currentLevel = level
            break
        }
    }

    return { currentUnit, currentLevel, currentExercises: exercises, vocabulary }
}

/**
 * Registra la lección completada en el backend.
 * Devuelve el resultado con xpEarned, nextUnitId, etc.
 */
export async function completeLesson({
    unitId, performance, earnedExp,
    correctAns, totalExerc, timeSeconds,
}) {
    const auth = useAuthStore()
    const userId = auth.user?.id || 1
    const langId = auth.selectedLangId

    const result = await progressApi.complete({
        userId,
        unitId: Number(unitId),
        languageId: langId,
        performance,
        earnedExp,
        correctAns,
        totalExerc,
        timeSeconds,
    })

    // Refrescar XP del usuario en el store
    await auth.refreshUser()

    return result
}

/**
 * Consume energía en el store global y en el backend.
 */
export async function consumeEnergy(isCorrect) {
    const energy = useEnergyStore()
    return energy.consumeForExercise(isCorrect)
}