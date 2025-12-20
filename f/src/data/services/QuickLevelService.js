import { getLearningRepository } from '../repositories/RepositoryFactory.js';
import { ProgressService } from './ProgressService.js';
import { EXERCISES_DATA } from '../repositories/contentRepositories/learningContent.js';

export class QuickLevelService {
    constructor() {
        this.learningRepo = getLearningRepository();
        this.progressService = new ProgressService();
    }

    /**
     * Completa el QuickLevel y maneja todo el proceso de desbloqueo
     */
    async completeQuickLevel(language, currentLevelId, performance, correctAnswersCount, totalExercises, earnedPoints = null) {
        console.log(`🚀 QUICKLEVEL SERVICE - Completando nivel ${currentLevelId}`);

        let currentLevelCompleted = false;
        let unlockResult = { unlocked: false, nextLevelId: null };

        if (performance >= 0.8) {
            currentLevelCompleted = this.completeAllUnitsInCurrentLevel(language, currentLevelId);
            unlockResult = this.unlockNextLevelWithExercises(language, currentLevelId);
        } else {
            console.log(`⚠ Rendimiento insuficiente (${performance}) - No se desbloquea siguiente nivel`);
        }

        // 🆕 PASAR earnedPoints a completeLesson
        const wordsLearned = this.getWordsLearnedFromLevel(language, currentLevelId);
        const progressResult = this.progressService.completeLesson(
            1,
            language,
            currentLevelId,
            'quick-level',
            performance,
            wordsLearned,
            earnedPoints // 🆕 Pasar puntos ganados
        );

        return {
            currentLevelCompleted,
            progressRecorded: progressResult,
            nextLevelUnlocked: unlockResult.unlocked,
            nextLevelId: unlockResult.nextLevelId,
            performance,
            correctAnswersCount,
            totalExercises
        };
    }

    /**
     * Completa todas las unidades del nivel actual
     */
    completeAllUnitsInCurrentLevel(language, levelId) {
        const units = this.learningRepo.getUnits(language, levelId);
        let unitsCompleted = 0;

        console.log(`📋 COMPLETANDO UNIDADES - Nivel ${levelId}`, {
            totalUnits: units.length,
            units: units.map(u => ({ id: u.id, completed: u.completed, locked: u.locked }))
        });

        units.forEach(unit => {
            if (!unit.completed) {
                const wasCompleted = this.learningRepo.completeUnit(language, levelId, unit.id);
                if (wasCompleted) {
                    unitsCompleted++;
                    console.log(`✅ Unidad ${unit.id} completada`);
                }
            }
        });

        const updatedUnits = this.learningRepo.getUnits(language, levelId);
        const allCompleted = updatedUnits.every(unit => unit.completed);

        console.log(`🎯 RESUMEN COMPLETADO - Unidades completadas: ${unitsCompleted}, Todas completadas: ${allCompleted}`);
        return allCompleted;
    }

    /**
     * Desbloquea el siguiente nivel y genera ejercicios para la unidad 1
     */
    unlockNextLevelWithExercises(language, currentLevelId) {
        const levels = this.learningRepo.getLevels(language);
        const currentLevelIndex = levels.findIndex(level => level.id === currentLevelId);

        if (currentLevelIndex === -1 || currentLevelIndex >= levels.length - 1) {
            console.log(`ℹ️ No hay siguiente nivel después del ${currentLevelId}`);
            return { unlocked: false, nextLevelId: null };
        }

        const nextLevel = levels[currentLevelIndex + 1];
        const nextLevelId = nextLevel.id;

        console.log(`🔓 INICIANDO DESBLOQUEO NIVEL ${nextLevelId}`);
        console.log(`📊 Estado inicial nivel ${nextLevelId}:`, {
            locked: nextLevel.locked,
            id: nextLevel.id,
            title: nextLevel.title
        });

        // 1. Desbloquear el nivel
        let levelUnlocked = false;
        if (nextLevel.locked) {
            levelUnlocked = this.unlockLevel(language, nextLevelId);
            console.log(`🔓 Nivel ${nextLevelId} desbloqueado:`, levelUnlocked);
        } else {
            levelUnlocked = true;
            console.log(`ℹ️ Nivel ${nextLevelId} ya estaba desbloqueado`);
        }

        // 2. Desbloquear y preparar la unidad 1 del siguiente nivel
        let unitUnlocked = false;
        let exercisesGenerated = false;

        const nextLevelUnits = this.learningRepo.getUnits(language, nextLevelId);
        console.log(`📋 Unidades del nivel ${nextLevelId}:`, nextLevelUnits.length);

        if (nextLevelUnits.length > 0) {
            const firstUnit = nextLevelUnits[0];
            console.log(`🎯 Procesando unidad ${firstUnit.id}:`, {
                id: firstUnit.id,
                locked: firstUnit.locked,
                current: firstUnit.current,
                hasExercises: !!firstUnit.exercises
            });

            // Desbloquear unidad usando el método del repositorio
            if (firstUnit.locked) {
                unitUnlocked = this.learningRepo.unlockUnit(language, nextLevelId, firstUnit.id);
                console.log(`🔓 Unidad ${firstUnit.id} desbloqueada:`, unitUnlocked);

                // VERIFICACIÓN EXTRA - Confirmar que se desbloqueó
                const updatedUnit = this.learningRepo.getUnit(language, nextLevelId, firstUnit.id);
                console.log(`✅ Estado actualizado unidad:`, {
                    id: updatedUnit.id,
                    locked: updatedUnit.locked,
                    current: updatedUnit.current
                });
            } else {
                unitUnlocked = true;
                console.log(`ℹ️ Unidad ${firstUnit.id} ya estaba desbloqueada`);
            }

            // 3. GENERAR EJERCICIOS - MÉTODO MEJORADO
            if (unitUnlocked) {
                console.log(`🎯 FORZANDO GENERACIÓN DE EJERCICIOS PARA UNIDAD ${firstUnit.id}...`);
                exercisesGenerated = this.forceGenerateExercisesForUnit(language, nextLevelId, firstUnit.id);
                console.log(`✅ Ejercicios generados para unidad ${firstUnit.id}:`, exercisesGenerated);
            }
        } else {
            console.log(`❌ No hay unidades en el nivel ${nextLevelId}`);
        }

        const result = {
            unlocked: levelUnlocked && unitUnlocked && exercisesGenerated,
            nextLevelId: nextLevelId,
            levelUnlocked,
            unitUnlocked,
            exercisesGenerated
        };

        console.log(`🎯 RESULTADO FINAL DESBLOQUEO:`, result);
        return result;
    }

    /**
     * Método para forzar generación de ejercicios
     */
    forceGenerateExercisesForUnit(language, levelId, unitId) {
        try {
            console.log(`🎯 FORZANDO EJERCICIOS: ${language}_${levelId}_${unitId}`);

            // PRIMERO: Verificar si hay ejercicios en EXERCISES_DATA
            const allExercises = EXERCISES_DATA[language] || [];

            // Aplicar el mismo mapeo que en LearningRepository
            const unitMapping = this.getUnitMapping(levelId, unitId);
            console.log(`🔄 Mapeo QuickLevel: UI ${unitId} → Ejercicios ${unitMapping.exerciseUnitId}`);

            const unitExercises = allExercises.filter(exercise =>
                exercise.levelId === levelId && exercise.unitId === unitMapping.exerciseUnitId
            );

            console.log(`📊 Ejercicios encontrados en EXERCISES_DATA: ${unitExercises.length} para unidad mapeada ${unitMapping.exerciseUnitId}`);

            if (unitExercises.length === 0) {
                console.log(`❌ NO HAY EJERCICIOS DEFINIDOS para ${language}_${levelId}_${unitId} (mapeada a ${unitMapping.exerciseUnitId})`);
                return false;
            }

            // SEGUNDO: Usar el método del repositorio para generar ejercicios
            const exercises = this.learningRepo.getExercisesForUnit(language, levelId, unitId);
            console.log(`📊 Ejercicios generados por repositorio: ${exercises.length}`);

            // TERCERO: Obtener la unidad y actualizar su estado COMPLETAMENTE
            const unit = this.learningRepo.getUnit(language, levelId, unitId);
            if (unit) {
                // Actualizar TODAS las propiedades necesarias
                unit.exercises = exercises;
                unit.locked = false;
                unit.current = true;
                unit.completed = false;

                console.log(`✅ Unidad ${unitId} actualizada:`, {
                    id: unit.id,
                    locked: unit.locked,
                    current: unit.current,
                    completed: unit.completed,
                    exercisesCount: exercises.length
                });
            }

            console.log(`✅ Ejercicios forzados: ${exercises.length} para ${language}_${levelId}_${unitId}`);
            return exercises.length > 0;
        } catch (error) {
            console.error('❌ Error forzando ejercicios:', error);
            return false;
        }
    }

    // Agregar el mismo método de mapeo a QuickLevelService
    getUnitMapping(levelId, uiUnitId) {
        if (levelId === 1) {
            return {
                uiUnitId: uiUnitId,
                exerciseUnitId: uiUnitId,
                description: `Nivel 1: UI ${uiUnitId} → Ejercicios ${uiUnitId}`
            };
        } else {
            const exerciseUnitId = ((uiUnitId - 1) % 6) + 1;
            return {
                uiUnitId: uiUnitId,
                exerciseUnitId: exerciseUnitId,
                description: `Nivel ${levelId}: UI ${uiUnitId} → Ejercicios ${exerciseUnitId}`
            };
        }
    }

    /**
     * Método auxiliar para desbloquear nivel
     */
    unlockLevel(language, levelId) {
        const level = this.learningRepo.getLevel(language, levelId);
        if (level && level.locked) {
            level.locked = false;
            console.log(`🔓 Nivel ${levelId} desbloqueado manualmente`);
            return true;
        }
        return false;
    }

    /**
     * Obtiene palabras aprendidas del nivel
     */
    getWordsLearnedFromLevel(language, levelId) {
        const units = this.learningRepo.getUnits(language, levelId);
        const wordsLearned = [];

        units.forEach(unit => {
            if (unit.vocabulary && typeof unit.vocabulary === 'object') {
                Object.keys(unit.vocabulary).forEach(wordKey => {
                    wordsLearned.push({
                        word: wordKey,
                        translation: unit.vocabulary[wordKey].translation,
                        dialect: language
                    });
                });
            }
        });

        return wordsLearned;
    }

    /**
     * Obtiene ejercicios aleatorios para el QuickLevel
     */
    getRandomExercisesForLevel(language, levelId, count = 6) {
        const units = this.learningRepo.getUnits(language, levelId);
        const allExercises = [];

        units.forEach(unit => {
            const unitExercises = this.learningRepo.getExercisesForUnit(language, levelId, unit.id);
            const markedExercises = unitExercises.map(exercise => ({
                ...exercise,
                sourceUnit: unit.id,
                sourceUnitTitle: unit.title
            }));
            allExercises.push(...markedExercises);
        });

        // Seleccionar ejercicios aleatorios
        return this.selectRandomExercises(allExercises, count);
    }

    /**
     * Selecciona ejercicios aleatorios
     */
    selectRandomExercises(exercises, count) {
        const shuffled = [...exercises].sort(() => 0.5 - Math.random());
        return shuffled.slice(0, count);
    }

    /**
     * Verifica el estado actual del sistema (para debugging)
     */
    checkSystemState(language, levelId) {
        console.log(`🔍 VERIFICANDO ESTADO DEL SISTEMA:`);

        // Verificar nivel actual
        const currentLevel = this.learningRepo.getLevel(language, levelId);
        console.log(`📊 Nivel actual ${levelId}:`, {
            locked: currentLevel?.locked,
            completedUnits: currentLevel?.completedUnits,
            totalUnits: currentLevel?.units
        });

        // Verificar unidades del nivel actual
        const currentUnits = this.learningRepo.getUnits(language, levelId);
        console.log(`📋 Unidades del nivel ${levelId}:`,
            currentUnits?.map(u => ({
                id: u.id,
                completed: u.completed,
                locked: u.locked,
                current: u.current
            }))
        );

        // Verificar siguiente nivel si existe
        const levels = this.learningRepo.getLevels(language);
        const currentLevelIndex = levels.findIndex(level => level.id === levelId);
        if (currentLevelIndex < levels.length - 1) {
            const nextLevel = levels[currentLevelIndex + 1];
            const nextLevelUnits = this.learningRepo.getUnits(language, nextLevel.id);
            console.log(`🔮 Siguiente nivel ${nextLevel.id}:`, {
                locked: nextLevel.locked,
                units: nextLevel.units
            });
            console.log(`🔮 Unidades del siguiente nivel:`,
                nextLevelUnits.map(u => ({
                    id: u.id,
                    completed: u.completed,
                    locked: u.locked,
                    current: u.current,
                    hasExercises: !!u.exercises
                }))
            );
        }
    }
}