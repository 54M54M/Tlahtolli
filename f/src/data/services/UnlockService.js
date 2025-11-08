import { UserRepository } from '../repositories/UserRepository.js';
import { LearningRepository } from '../repositories/LearningRepository.js';
import { StatsRepository } from '../repositories/StatsRepository.js';

export class UnlockService {
    constructor() {
        this.userRepo = new UserRepository();
        this.learningRepo = new LearningRepository();
        this.statsRepo = new StatsRepository();
    }

    checkUnitUnlocks(userId, language, levelId, currentUnitId) {
        const currentUnit = this.learningRepo.getUnit(language, levelId, currentUnitId);

        if (currentUnit && currentUnit.completed) {
            const nextUnit = this.learningRepo.getNextUnit(language, levelId, currentUnitId);
            if (nextUnit && nextUnit.locked) {
                this.learningRepo.unlockUnit(language, nextUnit.levelId, nextUnit.id);
                return { unlocked: true, type: 'UNIT', item: nextUnit };
            }
        }
        return { unlocked: false };
    }

    checkLevelUnlocks(userId, language, completedLevelId) {
        const levels = this.learningRepo.getLevels(language);
        const currentLevel = levels.find(level => level.id === completedLevelId);

        if (currentLevel && currentLevel.isCompleted()) {
            const nextLevel = levels.find(level => level.id === completedLevelId + 1);
            if (nextLevel && nextLevel.locked) {
                nextLevel.locked = false;
                return { unlocked: true, type: 'LEVEL', item: nextLevel };
            }
        }
        return { unlocked: false };
    }

    // Todos los idiomas están disponibles desde el inicio
    checkLanguageUnlocks(userId) {
        return [];
    }

    checkAchievementUnlocks(userId) {
        const user = this.userRepo.getUser(userId);
        const stats = this.statsRepo.getUserStats(userId);
        const unlockedAchievements = [];

        // Logro por racha de 7 días
        if (user.streak >= 7) {
            unlockedAchievements.push({
                id: '7_day_streak',
                title: "Racha de 7 días",
                description: "Estudiaste durante 7 días consecutivos",
                icon: "🔥",
                xpReward: 100
            });
        }

        // Logro por completar 50 palabras
        if (stats.wordsLearned >= 50) {
            unlockedAchievements.push({
                id: '50_words',
                title: "Vocabulario Básico",
                description: "Aprendiste 50 palabras nuevas",
                icon: "📚",
                xpReward: 150
            });
        }

        // Logro por aprender primer idioma adicional
        if (user.unlockedLanguages.length >= 2) {
            unlockedAchievements.push({
                id: 'bilingual_learner',
                title: "Aprendiz Bilingüe",
                description: "Desbloqueaste tu segundo idioma",
                icon: "🗣️",
                xpReward: 200
            });
        }

        // Logro por completar nivel 1 en cualquier idioma
        const languages = user.unlockedLanguages;
        for (const lang of languages) {
            const level1 = this.learningRepo.getLevel(lang, 1);
            if (level1 && level1.isCompleted()) {
                unlockedAchievements.push({
                    id: `first_level_${lang}`,
                    title: `Primer Nivel ${lang.toUpperCase()}`,
                    description: `Completaste el nivel 1 de ${this.getLanguageName(lang)}`,
                    icon: "🎯",
                    xpReward: 100
                });
                break; // Solo un logro por primer nivel completado
            }
        }

        return unlockedAchievements;
    }

    canAccessContent(userId, language, levelId, unitId) {
        const user = this.userRepo.getUser(userId);

        // Verificar si el idioma está soportado (no si está desbloqueado)
        const supportedLanguages = this.learningRepo.getSupportedLanguages();
        if (!supportedLanguages.includes(language)) {
            return {
                accessible: false,
                reason: 'LANGUAGE_NOT_SUPPORTED',
                message: `El idioma ${language} no está soportado`
            };
        }

        const level = this.learningRepo.getLevel(language, levelId);
        const unit = this.learningRepo.getUnit(language, levelId, unitId);

        // Nivel 1, Unidad 1 siempre accesible
        if (levelId === 1 && unitId === 1) {
            return { accessible: true };
        }

        if (!level || level.locked) {
            return {
                accessible: false,
                reason: 'LEVEL_LOCKED',
                message: 'Completa el nivel anterior primero'
            };
        }

        if (!unit || unit.locked) {
            return {
                accessible: false,
                reason: 'UNIT_LOCKED',
                message: 'Completa la unidad anterior primero'
            };
        }

        return { accessible: true };
    }

    // No hay requisitos para desbloquear idiomas
    getUnlockRequirements(userId, language) {
        return [];
    }

    getLanguageName(languageCode) {
        const languages = {
            'nhce': 'Náhuatl Central',
            'tkoc': 'Teenek Occidental'
        };
        return languages[languageCode] || languageCode;
    }

    // Método principal que verifica todos los desbloqueos
    checkAllUnlocks(userId, context = {}) {
        const { language, levelId, unitId, performance } = context;
        const unlocks = [];

        // Solo verificar desbloqueos de unidades y niveles
        if (language && levelId && unitId) {
            const unitUnlock = this.checkUnitUnlocks(userId, language, levelId, unitId);
            if (unitUnlock.unlocked) unlocks.push(unitUnlock);

            const levelUnlock = this.checkLevelUnlocks(userId, language, levelId);
            if (levelUnlock.unlocked) unlocks.push(levelUnlock);
        }

        // Verificar logros (mantener estos)
        const achievementUnlocks = this.checkAchievementUnlocks(userId);
        if (achievementUnlocks.length > 0) {
            unlocks.push({
                unlocked: true,
                type: 'ACHIEVEMENT',
                items: achievementUnlocks
            });
        }

        return unlocks;
    }
}