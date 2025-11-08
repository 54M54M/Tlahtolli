import { LocalStorageService } from '../storage/LocalStorageService.js';
import { Stats } from '../models/Stats.js';

export class StatsRepository {
    constructor() {
        this.storageKey = 'user-stats';
    }

    getUserStats(userId) {
        const allStats = LocalStorageService.getAllStats();
        const statsData = allStats[userId] || this.getDefaultStats(userId);

        // Convertir el objeto plano a instancia de Stats
        return new Stats(statsData);
    }

    saveUserStats(userId, stats) {
        const allStats = LocalStorageService.getAllStats();
        // Guardar como objeto plano (stats ya es una instancia de Stats)
        allStats[userId] = { ...stats };
        LocalStorageService.saveStats(allStats);
    }

    // verificar si ya se completó
    hasCompletedLesson(userId, language, levelId, unitId) {
        const stats = this.getUserStats(userId);
        // Podrías almacenar un historial de lecciones completadas
        // Por ahora, asumimos que si la unidad está marcada como completada en LearningRepository
        // entonces ya fue contada en las estadísticas
        return false; // Esto se determinará desde ProgressService
    }

    addLessonCompleted(userId, language, perfect = false) {
        const stats = this.getUserStats(userId);
        stats.addLessonCompleted(language, perfect);
        this.saveUserStats(userId, stats);
    }

    addWordsLearned(userId, language, count = 1) {
        const stats = this.getUserStats(userId);
        stats.addWordsLearned(language, count);
        this.saveUserStats(userId, stats);
    }

    updateStudyTime(userId, minutes) {
        const stats = this.getUserStats(userId);
        stats.totalMinutes += minutes;
        stats.daysStudied = Math.ceil(stats.totalMinutes / 60 / 24);
        stats.averageTimePerDay = stats.totalMinutes / Math.max(stats.daysStudied, 1);
        this.saveUserStats(userId, stats);
    }

    updateDialectProgress(userId, language, dialect, progress) {
        const stats = this.getUserStats(userId);
        if (!stats.languageProgress[language]) {
            stats.languageProgress[language] = {
                dialectProgress: {}
            };
        }
        stats.languageProgress[language].dialectProgress[dialect] = progress;
        this.saveUserStats(userId, stats);
    }

    getLanguageProgress(userId, language) {
        const stats = this.getUserStats(userId);
        return stats.languageProgress[language] || { dialectProgress: {} };
    }

    getOverallProgress(userId) {
        const stats = this.getUserStats(userId);
        return Math.min(100, (stats.lessonsCompleted / 100) * 100);
    }

    getDefaultStats(userId) {
        return {
            userId: userId,
            wordsLearned: 0,
            lessonsCompleted: 0,
            perfectLessons: 0,
            daysStudied: 0,
            bestStreak: 0,
            totalXP: 0,
            averageTimePerDay: 0,
            languageProgress: {},
            lastStudyDate: null,
            totalMinutes: 0
        };
    }
}