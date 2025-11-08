import { UserRepository } from '../repositories/UserRepository.js';
import { StatsRepository } from '../repositories/StatsRepository.js';
import { LearningRepository } from '../repositories/LearningRepository.js';
import { UnlockService } from './UnlockService.js';
import { AchievementService } from './AchievementService.js';
import { LocalStorageService } from '../storage/LocalStorageService.js';

export class ProgressService {
    constructor() {
        this.userRepo = new UserRepository();
        this.statsRepo = new StatsRepository();
        this.learningRepo = new LearningRepository();
        this.unlockService = new UnlockService();
        this.achievementService = new AchievementService();
    }

    completeLesson(userId, language, levelId, unitId, performance = 1.0, wordsLearned = []) {
        const user = this.userRepo.getUser(userId);

        // VERIFICAR SI LA UNIDAD YA ESTABA COMPLETADA ANTES - CORREGIDO
        const unit = this.learningRepo.getUnit(language, levelId, unitId);
        const wasAlreadyCompleted = unit && unit.completed;

        console.log('📊 ProgressService.completeLesson - Estado unidad:', {
            language,
            levelId,
            unitId,
            wasAlreadyCompleted,
            unitStatus: unit ? 'encontrada' : 'no encontrada',
            unitCompleted: unit?.completed
        });

        // Calcular XP basado en el rendimiento
        const baseXP = 100;
        const performanceMultiplier = performance; // 0.0 to 1.0
        const xpEarned = Math.floor(baseXP * performanceMultiplier);

        // ✅ CORREGIDO: SIEMPRE dar XP, incluso si es repetición
        user.addXP(xpEarned);
        console.log('💰 XP ganada:', xpEarned, 'XP total:', user.xp);

        // SOLO ACTUALIZAR ESTADÍSTICAS SI LA UNIDAD NO ESTABA COMPLETADA
        if (!wasAlreadyCompleted) {
            console.log('📈 Unidad nueva - actualizando estadísticas');

            // Actualizar estadísticas
            const perfect = performance >= 0.9;
            this.statsRepo.addLessonCompleted(userId, language, perfect);

            // Actualizar palabras aprendidas
            if (wordsLearned.length > 0) {
                this.statsRepo.addWordsLearned(userId, language, wordsLearned.length);

                // Actualizar progreso de dialecto
                wordsLearned.forEach(word => {
                    if (word.dialect) {
                        const currentProgress = this.statsRepo.getLanguageProgress(userId, language);
                        const dialectProgress = currentProgress.dialectProgress[word.dialect] || 0;
                        const newProgress = Math.min(100, dialectProgress + (100 / 50)); // +2% por palabra (50 palabras = 100%)
                        this.statsRepo.updateDialectProgress(userId, language, word.dialect, newProgress);
                    }
                });
            }
        } else {
            console.log('🔄 Unidad repetida - solo XP, sin estadísticas');
        }

        // Completar unidad (esto maneja el estado interno del repositorio)
        const unitCompleted = this.learningRepo.completeUnit(language, levelId, unitId);

        // Guardar progreso en LocalStorage
        this.saveProgressToStorage(userId, language);

        // VERIFICAR LOGROS DESPUÉS DE COMPLETAR LA LECCIÓN
        const newAchievements = this.achievementService.checkAndUnlockAchievements(userId);

        // Verificar todos los desbloqueos
        const unlocks = this.unlockService.checkAllUnlocks(userId, {
            language,
            levelId,
            unitId,
            performance
        });

        // Actualizar tiempo de estudio (estimado: 15 minutos por lección)
        this.statsRepo.updateStudyTime(userId, 15);

        return {
            xpEarned,
            newLevel: user.level,
            perfectLesson: !wasAlreadyCompleted && perfect, // Solo contar como perfecta si es primera vez
            unitCompleted,
            unlocks,
            newAchievements, // <- AGREGAR NUEVOS LOGROS DESBLOQUEADOS
            wordsLearned: wasAlreadyCompleted ? 0 : wordsLearned.length, // Solo contar palabras si es primera vez
            wasAlreadyCompleted // Informar si era una repetición
        };
    }

    saveProgressToStorage(userId, language) {
        const learningRepo = new LearningRepository();
        const levels = learningRepo.getLevels(language);
        const completedUnits = learningRepo.getCompletedUnits(language);

        const progressData = {
            completedUnits: completedUnits.length,
            totalUnits: 30,
            levels: {}
        };

        levels.forEach(level => {
            progressData.levels[level.id] = {
                completedUnits: level.completedUnits,
                totalUnits: level.units
            };
        });

        LocalStorageService.saveProgress(language, progressData);
    }

    completeExerciseSession(userId, sessionResults) {
        const { session, correct, total, totalPoints, performance } = sessionResults;
        const user = this.userRepo.getUser(userId);

        // Calcular XP para sesión de ejercicios
        const xpEarned = Math.floor(totalPoints * performance);
        user.addXP(xpEarned);

        // Actualizar estadísticas
        this.statsRepo.addWordsLearned(userId, session.language, correct);

        // Actualizar tiempo de estudio (estimado basado en número de ejercicios)
        const estimatedMinutes = Math.max(10, Math.floor(total * 1.5));
        this.statsRepo.updateStudyTime(userId, estimatedMinutes);

        // Verificar desbloqueos
        const unlocks = this.unlockService.checkAllUnlocks(userId, {
            performance
        });

        return {
            xpEarned,
            newLevel: user.level,
            unlocks,
            sessionScore: sessionResults.score
        };
    }

    getUserProgress(userId) {
        const user = this.userRepo.getUser(userId);
        const stats = this.statsRepo.getUserStats(userId);
        const overallProgress = this.statsRepo.getOverallProgress(userId);
        const availableLanguages = this.unlockService.getAvailableLanguages(userId);

        return {
            user,
            stats,
            overallProgress,
            nextLevelXP: user.xpToNextLevel - user.xp,
            availableLanguages,
            currentLanguage: user.currentLanguage
        };
    }



    getLanguageProgress(userId, language) {
        const storageProgress = LocalStorageService.getProgress(language);
        const levels = this.learningRepo.getLevels(language);
        const completedLevels = levels.filter(level => level.isCompleted()).length;

        return {
            dialectProgress: storageProgress.completedUnits > 0 ?
                (storageProgress.completedUnits / storageProgress.totalUnits) * 100 : 0,
            wordsLearned: storageProgress.completedUnits * 5, // Estimación
            lessonsCompleted: storageProgress.completedUnits,
            unitsCompleted: storageProgress.completedUnits,
            levelsCompleted: completedLevels,
            totalLevels: levels.length,
            completionRate: (completedLevels / levels.length) * 100
        };
    }
    getDialectProgress(userId, language) {
        const progress = this.statsRepo.getLanguageProgress(userId, language);
        return progress.dialectProgress || {};
    }

    updateStudyTime(userId, minutes) {
        const user = this.userRepo.getUser(userId);
        const stats = this.statsRepo.getUserStats(userId);

        if (user && stats) {
            user.minutesStudied += minutes;
            stats.totalMinutes += minutes;
            stats.daysStudied = Math.ceil(stats.totalMinutes / 60 / 24); // Estimación
            stats.averageTimePerDay = stats.totalMinutes / Math.max(stats.daysStudied, 1);

            return true;
        }
        return false;
    }

    getStudyStreak(userId) {
        const user = this.userRepo.getUser(userId);
        const stats = this.statsRepo.getUserStats(userId);

        return {
            currentStreak: user.streak,
            bestStreak: stats.bestStreak,
            maintained: user.streak > 0
        };
    }

    updateStreak(userId) {
        const user = this.userRepo.getUser(userId);
        const stats = this.statsRepo.getUserStats(userId);

        if (user && stats) {
            user.updateStreak();
            stats.updateStreak(user.streak);
            return user.streak;
        }
        return 0;
    }

    resetStreak(userId) {
        const user = this.userRepo.getUser(userId);
        if (user) {
            user.streak = 0;
            return true;
        }
        return false;
    }

    // Método para obtener resumen de progreso para dashboard
    getProgressSummary(userId) {
        const progress = this.getUserProgress(userId);
        const currentLanguage = progress.user.currentLanguage;
        const languageProgress = this.getLanguageProgress(userId, currentLanguage);

        return {
            general: {
                level: progress.user.level,
                xp: progress.user.xp,
                nextLevelXP: progress.nextLevelXP,
                overallProgress: progress.overallProgress,
                streak: progress.user.streak
            },
            currentLanguage: {
                code: currentLanguage,
                progress: languageProgress.completionRate,
                wordsLearned: languageProgress.wordsLearned,
                lessonsCompleted: languageProgress.lessonsCompleted,
                nextLevel: languageProgress.nextLevel
            },
            studyStats: {
                totalMinutes: progress.stats.totalMinutes,
                averageDaily: progress.stats.averageTimePerDay,
                daysStudied: progress.stats.daysStudied
            }
        };
    }

    // Método para cambiar de idioma
    switchLanguage(userId, languageCode) {
        const user = this.userRepo.getUser(userId);
        if (user && user.unlockedLanguages.includes(languageCode)) {
            user.currentLanguage = languageCode;
            return {
                success: true,
                newLanguage: languageCode,
                message: `Idioma cambiado a ${languageCode}`
            };
        }
        return {
            success: false,
            message: 'Idioma no disponible o no desbloqueado'
        };
    }

    // Método para obtener logros recientes
    getRecentUnlocks(userId) {
        // En una implementación real, esto vendría de una base de datos
        // Por ahora, simulamos algunos desbloqueos recientes
        return [
            {
                type: 'LEVEL',
                title: 'Nivel 1 Completado',
                description: 'Completaste el nivel 1 de Náhuatl',
                timestamp: new Date(Date.now() - 86400000).toISOString(), // 1 día atrás
                xp: 100
            }
        ];
    }

    getCompletedUnitsCount(userId, language) {
        const learningRepo = new LearningRepository();
        const completedUnits = learningRepo.getCompletedUnits(language);
        return completedUnits.length;
    }

    getLearnedWordsCount(userId, language) {
        const learningRepo = new LearningRepository();
        const completedUnits = learningRepo.getCompletedUnits(language);
        return completedUnits.reduce((total, unit) => total + unit.vocabulary.length, 0);
    }

    getLevelCompletionStatus(userId, language, levelId) {
        const level = this.learningRepo.getLevel(language, levelId);
        if (!level) return { completed: false, progress: 0 };

        return {
            completed: level.isCompleted(),
            progress: level.progress,
            completedUnits: level.completedUnits,
            totalUnits: level.units
        };
    }

    // Método para obtener logros del usuario
    getUserAchievements(userId) {
        try {
            return this.achievementService.getEarnedAchievements();
        } catch (error) {
            console.error('Error getting user achievements:', error);
            return [];
        }
    }

    // Método para obtener todos los logros con progreso
    getAllAchievementsWithProgress(userId) {
        try {
            return this.achievementService.getAllAchievementsWithProgress(userId);
        } catch (error) {
            console.error('Error getting achievements with progress:', error);
            return this.achievementService.achievements.map(achievement => new Achievement({
                ...achievement,
                progress: { current: 0, target: 1, percentage: 0 }
            }));
        }
    }

}