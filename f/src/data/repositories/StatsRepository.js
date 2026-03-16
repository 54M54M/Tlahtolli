// src/data/repositories/StatsRepository.js
import { statsApi } from '../../api/apiClient.js'

export class StatsRepository {

    async getUserStats(userId) {
        try {
            const results = await statsApi.getByUser(userId)
            // El backend devuelve un array (un registro por idioma)
            // Para compatibilidad con el frontend que espera un objeto plano,
            // combinamos todos los idiomas en uno solo
            if (Array.isArray(results) && results.length > 0) {
                return results.reduce((acc, stat) => ({
                    userId: stat.userId,
                    wordsLearned: (acc.wordsLearned || 0) + (stat.wordsLearned || 0),
                    lessonsCompleted: (acc.lessonsCompleted || 0) + (stat.lessonsDone || 0),
                    perfectLessons: (acc.perfectLessons || 0) + (stat.perfectLess || 0),
                    daysStudied: Math.max(acc.daysStudied || 0, stat.daysStudied || 0),
                    bestStreak: Math.max(acc.bestStreak || 0, stat.bestStreak || 0),
                    totalMinutes: (acc.totalMinutes || 0) + (stat.totalMins || 0),
                }), {})
            }
            return this._defaultStats(userId)
        } catch (err) {
            console.error('[StatsRepository] getUserStats:', err)
            return this._defaultStats(userId)
        }
    }

    async getStatsByLanguage(userId, languageId) {
        try {
            return await statsApi.getByUserLang(userId, languageId)
        } catch (err) {
            console.error('[StatsRepository] getStatsByLanguage:', err)
            return null
        }
    }

    _defaultStats(userId) {
        return {
            userId,
            wordsLearned: 0,
            lessonsCompleted: 0,
            perfectLessons: 0,
            daysStudied: 0,
            bestStreak: 0,
            totalMinutes: 0,
        }
    }
}