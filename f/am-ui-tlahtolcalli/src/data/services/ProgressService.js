// src/data/services/ProgressService.js
import { progressApi, statsApi, achievementsApi } from '../../api/apiClient.js'
import { useAuthStore } from '../../stores/auth.js'

export class ProgressService {

    async completeLesson(userId, language, levelId, unitId, performance = 1.0,
        wordsLearned = [], earnedPoints = null,
        correctAns = 0, totalExerc = 0, timeSeconds = 0) {
        try {
            const auth = useAuthStore()
            const languageId = auth.selectedLangId

            const result = await progressApi.complete({
                userId,
                unitId,
                languageId,
                performance,
                earnedExp: earnedPoints ?? Math.round(performance * 100),
                correctAns,
                totalExerc,
                timeSeconds,
            })

            await auth.refreshUser()

            return {
                xpEarned: result.xpEarned,
                wasAlreadyCompleted: result.wasAlreadyCompleted,
                perfectLesson: result.perfectLesson,
                newAchievements: result.newAchievements,
            }
        } catch (err) {
            console.error('[ProgressService] completeLesson:', err)
            return {
                xpEarned: earnedPoints ?? 0,
                wasAlreadyCompleted: false,
                perfectLesson: false,
                newAchievements: 0,
            }
        }
    }

    async getLanguageProgress(userId, language) {
        try {
            const auth = useAuthStore()
            const data = await statsApi.getByUserLang(userId, auth.selectedLangId)
            if (!data) return this._defaultProgress()
            return {
                dialectProgress: (data.lessonsDone / 36) * 100,
                wordsLearned: data.wordsLearned || 0,
                lessonsCompleted: data.lessonsDone || 0,
                unitsCompleted: data.lessonsDone || 0,
                completionRate: (data.lessonsDone / 36) * 100,
            }
        } catch (err) {
            console.error('[ProgressService] getLanguageProgress:', err)
            return this._defaultProgress()
        }
    }

    async getAllAchievementsWithProgress(userId) {
        try {
            return await achievementsApi.getWithStatus(userId)
        } catch (err) {
            console.error('[ProgressService] getAllAchievementsWithProgress:', err)
            return []
        }
    }

    _defaultProgress() {
        return {
            dialectProgress: 0, wordsLearned: 0,
            lessonsCompleted: 0, unitsCompleted: 0, completionRate: 0,
        }
    }
}