import { progressApi, isOfflineError } from '../../api/apiClient.js'
import { offline } from '../../offline/status.js'
import { newClientId, queueLesson } from '../../offline/outbox.js'
import { useAuthStore } from '../../stores/auth.js'
import { useEnergyStore } from '../../stores/energy.js'
import { getExercises, getVocabulary, getLevels, getUnits, findUnitWithLevel, invalidateAfterLesson } from '../../data/learning.js'
import { invalidateStats } from '../../data/stats.js'
import { invalidateAchievements } from '../../data/achievements.js'

/**
 * Carga los datos de una lección dado el unitId.
 * Devuelve { currentUnit, currentLevel, currentExercises, vocabulary, reviewVocabulary }
 */
export async function loadLessonData(unitId) {
    const [exercises, vocabulary, { unit, level }] = await Promise.all([
        getExercises(unitId),
        getVocabulary(unitId),
        findUnitWithLevel(unitId),
    ])
    const reviewVocabulary = await loadReviewVocabulary(unit, level)
    return { currentUnit: unit, currentLevel: level, currentExercises: exercises, vocabulary, reviewVocabulary }
}

/**
 * Vocabulario ya visto, para repasarlo en la lección (src/data/lessonPlan.js): el de las unidades anteriores
 * del mismo nivel; si es la primera unidad del nivel, el de las 2 últimas unidades del nivel anterior.
 * Es opcional: si algo falla (p. ej. sin conexión) la lección sigue sin repaso.
 */
async function loadReviewVocabulary(unit, level) {
    if (!unit?.id || !level?.id) return []
    try {
        const units = await getUnits(level.id)
        const num = u => u.unitNum ?? u.unit_num ?? 0
        let previous = units.filter(u => num(u) < num(unit))
        if (!previous.length) {
            const levels = await getLevels()
            const lnum = l => l.levelNum ?? l.level_num ?? 0
            const prevLevel = levels.filter(l => lnum(l) < lnum(level)).sort((a, b) => lnum(b) - lnum(a))[0]
            if (prevLevel) previous = (await getUnits(prevLevel.id)).sort((a, b) => num(b) - num(a)).slice(0, 2)
        }
        const lists = await Promise.all(previous.slice(-5).map(u =>
            getVocabulary(u.id, { optional: true }).catch(() => null)))
        return lists.filter(Boolean).flatMap(v => Array.isArray(v)
            ? v
            : Object.entries(v).map(([word, e]) => ({ word, ...(e || {}) })))
    } catch {
        return []
    }
}

/**
 * Registra la lección completada en el backend e invalida toda la caché
 * relacionada en un solo lugar.
 * Sin conexión: la guarda en el teléfono (outbox) y devuelve { offline: true }; se envía al reconectar.
 */
export async function completeLesson({
    unitId, levelId, performance, earnedExp,
    correctAns, totalExerc, timeSeconds,
}) {
    const auth = useAuthStore()
    return sendCompletion({
        userId: auth.user?.id || 1,
        unitId: Number(unitId),
        languageId: auth.selectedLangId,
        performance,
        earnedExp,
        correctAns,
        totalExerc,
        timeSeconds,
    }, levelId)
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
    return sendCompletion({
        userId: auth.user?.id || 1,
        levelId: Number(levelId),
        unitId: null,
        languageId: auth.selectedLangId,
        performance,
        earnedExp,
        correctAns,
        totalExerc,
        timeSeconds,
    }, levelId)
}

async function sendCompletion(data, levelId) {
    const auth = useAuthStore()
    // clientId: si el envío se repite (reintento), el servidor lo cuenta una sola vez.
    // completedAt: el día que cuenta es cuando la terminó, aunque se envíe horas después.
    const payload = { ...data, clientId: newClientId(), completedAt: new Date().toISOString() }

    const saveForLater = () => {
        queueLesson(payload.userId, payload)
        return {
            offline: true,
            xpEarned: payload.earnedExp,
            wasAlreadyCompleted: false,
            perfectLesson: false,
            nextUnitId: null,
            nextLevelUnlocked: false,
            newAchievements: 0,
        }
    }

    if (offline.value) return saveForLater()

    let result
    try {
        result = await progressApi.complete(payload)
    } catch (err) {
        // Sin conexión o servidor caído (Render despertando): se guarda y se reintenta después
        if (isOfflineError(err) || err?.status >= 500) return saveForLater()
        throw err
    }

    await auth.refreshUser()

    // Invalidación centralizada: un solo lugar decide qué caché limpiar
    invalidateAfterLesson(levelId)
    invalidateStats(auth.selectedLangId)
    invalidateAchievements(auth.selectedLanguage)

    return result
}

export async function consumeEnergy(isCorrect) {
    return useEnergyStore().consumeForExercise(isCorrect)
}