// src/views/learn/lessonApi.js
import { progressApi } from '../../api/apiClient.js'
import { useAuthStore } from '../../stores/auth.js'
import { useEnergyStore } from '../../stores/energy.js'
import { getExercises, getVocabulary, findUnitWithLevel, invalidateAfterLesson } from '../../data/learning.js'
import { invalidateStats } from '../../data/stats.js'
import { invalidateAchievements } from '../../data/achievements.js'

/**
 * Carga los datos de una lección dado el unitId.
 * Devuelve { currentUnit, currentLevel, currentExercises, vocabulary }
 */
export async function loadLessonData(unitId) {
    const [exercises, vocabulary, { unit, level }] = await Promise.all([
        getExercises(unitId),
        getVocabulary(unitId),
        findUnitWithLevel(unitId),
    ])
    return { currentUnit: unit, currentLevel: level, currentExercises: exercises, vocabulary }
}

/**
 * Registra la lección completada en el backend e invalida toda la caché
 * relacionada en un solo lugar.
 */
export async function completeLesson({
    unitId, levelId, performance, earnedExp,
    correctAns, totalExerc, timeSeconds,
}) {
    const auth = useAuthStore()

    const result = await progressApi.complete({
        userId: auth.user?.id || 1,
        unitId: Number(unitId),
        languageId: auth.selectedLangId,
        performance,
        earnedExp,
        correctAns,
        totalExerc,
        timeSeconds,
    })

    await auth.refreshUser()

    // Invalidación centralizada: un solo lugar decide qué caché limpiar
    invalidateAfterLesson(levelId)
    invalidateStats(auth.selectedLangId)
    invalidateAchievements(auth.selectedLanguage)

    return result
}

/**
 * Registra un QuickLevel completado. Misma invalidación que completeLesson:
 * el nivel actual cambia y el siguiente puede desbloquearse.
 */
export async function completeQuickLevel({
    levelId, performance, earnedExp,
    correctAns, totalExerc, timeSeconds,
}) {
    const auth = useAuthStore()

    const result = await progressApi.complete({
        userId: auth.user?.id || 1,
        levelId: Number(levelId),
        unitId: null,
        languageId: auth.selectedLangId,
        performance,
        earnedExp,
        correctAns,
        totalExerc,
        timeSeconds,
    })

    await auth.refreshUser()

    invalidateAfterLesson(levelId)
    invalidateStats(auth.selectedLangId)
    invalidateAchievements(auth.selectedLanguage)

    return result
}

export async function consumeEnergy(isCorrect) {
    return useEnergyStore().consumeForExercise(isCorrect)
}