import { Achievement } from '../models/Achievement.js';
import { StatsRepository } from '../repositories/StatsRepository.js';
import { UserRepository } from '../repositories/UserRepository.js';
import { LearningRepository } from '../repositories/LearningRepository.js';
import { LocalStorageService } from '../storage/LocalStorageService.js';

export class AchievementService {
    constructor() {
        this.statsRepo = new StatsRepository();
        this.userRepo = new UserRepository();
        this.learningRepo = new LearningRepository();
        this.achievements = this.initializeAchievements();
        this.loadEarnedAchievements();
    }

    initializeAchievements() {
        return [
            new Achievement({
                id: 1,
                title: "Primer Día",
                description: "Completaste tu primera lección",
                icon: "🎉",
                xpReward: 50,
                requirement: "Completar 1 lección",
                category: "general",
                rarity: "common"
            }),
            new Achievement({
                id: 2,
                title: "Racha de 7 días",
                description: "Estudiaste durante 7 días consecutivos",
                icon: "🔥",
                xpReward: 100,
                requirement: "Mantener racha de 7 días",
                category: "dedication",
                rarity: "rare"
            }),
            new Achievement({
                id: 3,
                title: "Vocabulario Básico",
                description: "Aprendiste 50 palabras nuevas",
                icon: "📚",
                xpReward: 150,
                requirement: "Aprender 50 palabras",
                category: "vocabulary",
                rarity: "common"
            }),
            new Achievement({
                id: 4,
                title: "Racha de 30 días",
                description: "Estudiaste durante 30 días consecutivos",
                icon: "⚡",
                xpReward: 300,
                requirement: "Mantener racha de 30 días",
                category: "dedication",
                rarity: "epic"
            }),
            new Achievement({
                id: 5,
                title: "Maestro de Saludos",
                description: "Completaste todas las lecciones de saludos",
                icon: "👋",
                xpReward: 100,
                requirement: "Completar nivel 1 de saludos",
                category: "language",
                rarity: "common",
                languageSpecific: true
            }),
            new Achievement({
                id: 6,
                title: "Explorador Cultural",
                description: "Completaste 5 lecciones culturales",
                icon: "🏛️",
                xpReward: 200,
                requirement: "Completar 5 lecciones culturales",
                category: "culture",
                rarity: "rare"
            }),
            new Achievement({
                id: 7,
                title: "Narrador de Historias",
                description: "Completaste 10 historias en náhuatl",
                icon: "📖",
                xpReward: 250,
                requirement: "Completar 10 historias",
                category: "storytelling",
                rarity: "rare",
                languageSpecific: true,
                language: "nhce"
            }),
            new Achievement({
                id: 9,
                title: "Perfeccionista",
                description: "Completaste 10 lecciones perfectas",
                icon: "⭐",
                xpReward: 200,
                requirement: "10 lecciones perfectas",
                category: "performance",
                rarity: "rare"
            }),
            new Achievement({
                id: 10,
                title: "Estudiante Comprometido",
                description: "Estudiaste 1000 minutos",
                icon: "⏰",
                xpReward: 150,
                requirement: "1000 minutos de estudio",
                category: "dedication",
                rarity: "common"
            })
        ];
    }

    loadEarnedAchievements() {
        const savedAchievements = LocalStorageService.getAchievements();
        if (savedAchievements && savedAchievements.length > 0) {
            savedAchievements.forEach(saved => {
                const achievement = this.achievements.find(a => a.id === saved.id);
                if (achievement && saved.earned) {
                    achievement.earned = true;
                    achievement.date = saved.date;
                }
            });
        }
    }

    saveEarnedAchievements() {
        const earnedAchievements = this.achievements.filter(a => a.earned);
        LocalStorageService.saveAchievements(earnedAchievements);
    }

    checkAchievements(userId) {
        const stats = this.statsRepo.getUserStats(userId);
        const user = this.userRepo.getUser(userId);
        const newAchievements = [];

        this.achievements.forEach(achievement => {
            if (!achievement.earned && this.isRequirementMet(achievement, stats, user)) {
                const xpReward = achievement.earn();
                newAchievements.push({
                    achievement: achievement,
                    xpReward: xpReward
                });

                if (xpReward > 0) {
                    this.userRepo.addXP(userId, xpReward);
                }
            }
        });

        if (newAchievements.length > 0) {
            this.saveEarnedAchievements();
        }

        return newAchievements;
    }

    isRequirementMet(achievement, stats, user) {
        const requirement = achievement.requirement.toLowerCase();
        console.log('🔍 Verificando requisito:', achievement.title, '-', requirement);

        if (requirement.includes("completar 1 lección") || requirement.includes("primera lección")) {
            console.log('📊 Lecciones completadas:', stats.lessonsCompleted);
            const result = stats.lessonsCompleted >= 1;
            console.log('✅ Resultado requisito primera lección:', result);
            return result;
        }

        if (requirement.includes("7 días") || requirement.includes("racha de 7")) {
            const result = user.streak >= 7;
            console.log('✅ Resultado requisito 7 días:', result, '(streak:', user.streak, ')');
            return result;
        }

        if (requirement.includes("50 palabras") || requirement.includes("aprender 50")) {
            const result = stats.wordsLearned >= 50;
            console.log('✅ Resultado requisito 50 palabras:', result, '(words:', stats.wordsLearned, ')');
            return result;
        }

        if (requirement.includes("30 días") || requirement.includes("racha de 30")) {
            const result = user.streak >= 30;
            console.log('✅ Resultado requisito 30 días:', result, '(streak:', user.streak, ')');
            return result;
        }

        if (requirement.includes("10 lecciones perfectas")) {
            const result = stats.perfectLessons >= 10;
            console.log('✅ Resultado requisito 10 lecciones perfectas:', result, '(perfect:', stats.perfectLessons, ')');
            return result;
        }

        if (requirement.includes("1000 minutos")) {
            const result = stats.totalMinutes >= 1000;
            console.log('✅ Resultado requisito 1000 minutos:', result, '(minutes:', stats.totalMinutes, ')');
            return result;
        }

        if (requirement.includes("2 idiomas")) {
            const result = user.unlockedLanguages.length >= 2;
            console.log('✅ Resultado requisito 2 idiomas:', result, '(languages:', user.unlockedLanguages.length, ')');
            return result;
        }

        if (achievement.languageSpecific && achievement.language) {
            const languageProgress = stats.languageProgress[achievement.language];
            if (languageProgress) {
                if (requirement.includes("nivel 1 de saludos")) {
                    const result = languageProgress.lessonsCompleted >= 5;
                    console.log('✅ Resultado requisito nivel 1 saludos:', result, '(lessons:', languageProgress.lessonsCompleted, ')');
                    return result;
                }
                if (requirement.includes("10 historias")) {
                    const result = languageProgress.lessonsCompleted >= 10;
                    console.log('✅ Resultado requisito 10 historias:', result, '(lessons:', languageProgress.lessonsCompleted, ')');
                    return result;
                }
            }
        }

        console.log('❌ Requisito no reconocido:', requirement);
        return false;
    }

    getAchievementsByCategory(category = null) {
        if (category) {
            return this.achievements.filter(achievement => achievement.category === category);
        }
        return this.achievements;
    }

    getEarnedAchievements() {
        return this.achievements.filter(achievement => achievement.earned);
    }

    getUnearnedAchievements() {
        return this.achievements.filter(achievement => !achievement.earned);
    }

    getAchievementProgress(achievement, stats, user) {
        const requirement = achievement.requirement.toLowerCase();

        if (requirement.includes("lección")) {
            return {
                current: stats.lessonsCompleted,
                target: 1,
                percentage: Math.min(100, (stats.lessonsCompleted / 1) * 100)
            };
        }

        if (requirement.includes("palabras")) {
            return {
                current: stats.wordsLearned,
                target: 50,
                percentage: Math.min(100, (stats.wordsLearned / 50) * 100)
            };
        }

        if (requirement.includes("días")) {
            const target = requirement.includes("30") ? 30 : 7;
            return {
                current: user.streak,
                target: target,
                percentage: Math.min(100, (user.streak / target) * 100)
            };
        }

        if (requirement.includes("lecciones perfectas")) {
            return {
                current: stats.perfectLessons,
                target: 10,
                percentage: Math.min(100, (stats.perfectLessons / 10) * 100)
            };
        }

        if (requirement.includes("minutos")) {
            return {
                current: stats.totalMinutes,
                target: 1000,
                percentage: Math.min(100, (stats.totalMinutes / 1000) * 100)
            };
        }

        return {
            current: 0,
            target: 1,
            percentage: 0
        };
    }

    checkAndUnlockAchievements(userId) {
        const stats = this.statsRepo.getUserStats(userId);
        const user = this.userRepo.getUser(userId);
        const newAchievements = [];

        console.log('🏆 AchievementService - Iniciando verificación de logros...');
        console.log('📊 Estadísticas del usuario:', {
            lessonsCompleted: stats.lessonsCompleted,
            wordsLearned: stats.wordsLearned,
            perfectLessons: stats.perfectLessons,
            totalMinutes: stats.totalMinutes
        });
        console.log('👤 Datos del usuario:', {
            streak: user.streak,
            unlockedLanguages: user.unlockedLanguages.length,
            xp: user.xp,
            level: user.level
        });

        this.achievements.forEach(achievement => {
            if (!achievement.earned) {
                console.log(`\n🔍 Verificando logro: ${achievement.title}`);

                // SOLO VERIFICAR SI EL REQUISITO SE CUMPLE - SIN CONDICIONES DUPLICADAS
                if (this.isRequirementMet(achievement, stats, user)) {
                    console.log('✅ REQUISITO CUMPLIDO - Desbloqueando logro:', achievement.title);

                    const xpReward = achievement.earn();
                    newAchievements.push({
                        achievement: achievement,
                        xpReward: xpReward
                    });

                    // AGREGAR XP - ESTA ES LA PARTE CRÍTICA
                    if (xpReward > 0) {
                        console.log('💰 AGREGANDO XP:', xpReward, 'al usuario');
                        const newXP = this.userRepo.addXP(userId, xpReward);
                        console.log('💰 XP después de agregar:', newXP);

                        // VERIFICAR QUE SE GUARDÓ
                        const updatedUser = this.userRepo.getUser(userId);
                        console.log('💰 Usuario actualizado:', {
                            xp: updatedUser.xp,
                            totalXP: updatedUser.totalXP,
                            level: updatedUser.level
                        });
                    }

                    console.log(`🎉 LOGRO DESBLOQUEADO: ${achievement.title} - +${xpReward} XP`);
                } else {
                    // DEBUG: Ver progreso actual
                    const progress = this.getAchievementProgress(achievement, stats, user);
                    console.log('❌ Requisito NO cumplido - Progreso:', progress.percentage + '%');
                }
            } else {
                console.log(`📌 Logro ya desbloqueado: ${achievement.title}`);
            }
        });

        if (newAchievements.length > 0) {
            this.saveEarnedAchievements();
            console.log(`🏆 ${newAchievements.length} logro(s) desbloqueado(s) en total`);
        } else {
            console.log('🏆 No se desbloquearon nuevos logros en esta verificación');
        }

        return newAchievements;
    }

    getAllAchievementsWithProgress(userId) {
        try {
            const stats = this.statsRepo.getUserStats(userId);
            const user = this.userRepo.getUser(userId);

            // ✅ CORRECCIÓN: NO llamar a checkAndUnlockAchievements aquí para evitar bucle infinito
            // Solo calcular el progreso, no desbloquear logros

            // Asegurarse de que cada logro sea una instancia de Achievement
            return this.achievements.map(achievement => {
                const progress = this.getAchievementProgress(achievement, stats, user);

                // Crear una nueva instancia de Achievement con los datos actualizados
                const achievementInstance = new Achievement({
                    ...achievement,
                    earned: achievement.earned,
                    date: achievement.date,
                    progress: progress
                });

                return achievementInstance;
            });
        } catch (error) {
            console.error('Error in getAllAchievementsWithProgress:', error);
            // Retornar logros básicos como instancias de Achievement
            return this.achievements.map(achievement => new Achievement({
                ...achievement,
                progress: { current: 0, target: 1, percentage: 0 }
            }));
        }
    }
}