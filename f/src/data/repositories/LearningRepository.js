import { Level } from '../models/Level.js';
import { Unit } from '../models/Unit.js';
import { Exercise } from '../models/Exercise.js';
import {
    LEVELS_DATA,
    UNITS_DATA,
    EXERCISES_DATA
} from './contentRepositories/learningContent.js';

export class LearningRepository {
    constructor() {
        this.levels = new Map();
        this.units = new Map();
        this.exercises = new Map();
        this.loadInitialData();
    }

    loadInitialData() {
        // Cargar niveles
        Object.values(LEVELS_DATA).forEach(languageLevels => {
            languageLevels.forEach(level => {
                this.levels.set(`${level.language}_${level.id}`, level);
            });
        });

        // Cargar unidades
        Object.values(UNITS_DATA).forEach(languageUnits => {
            languageUnits.forEach(unit => {
                this.units.set(`${unit.language}_${unit.levelId}_${unit.id}`, unit);
            });
        });

        // Cargar ejercicios
        Object.values(EXERCISES_DATA).forEach(languageExercises => {
            languageExercises.forEach(exercise => {
                this.exercises.set(`${exercise.language}_${exercise.levelId}_${exercise.unitId}_${exercise.id}`, exercise);
            });
        });
    }

    loadExercises() {

        // Agregar todos los ejercicios al mapa
        [...nhceExercises, ...tkocExercises].forEach(exercise => {
            this.exercises.set(`${exercise.language}_${exercise.levelId}_${exercise.unitId}_${exercise.id}`, exercise);
        });
    }

    // Banco de opciones para preguntas de múltiple opción
    getMultipleChoiceOptions(language, questionType) {
        const optionsBank = {
            // nhce: {
            //     greetings: [
            //         "Cualli tonalli", "Cualli", "Tlazocamati", "Nimitztlahtlauhtia",
            //         "Cualli yohual", "Nimitztlatlauhtia", "Hasta mañana"
            //     ],
            //     basic: [
            //         "Nimitztlahtlauhtia", "Nimitztlatlauhtia", "Nimitztlatlauhtiā", "Nimitztlatlauhtiah",
            //         "Nechpactia", "Tinechpactia", "Tinechpactiah", "Tinechpactiā"
            //     ],
            //     introductions: [
            //         "Notoca", "Nitlacatl", "Nechca", "Niquihtoz",
            //         "Niquihtoa", "Niquihtohua", "Notocayotl", "Nitlayecoltia"
            //     ],
            //     questions: [
            //         "Quenin timoyolcuitia?", "Quenin ticmati?", "Quenin tihuitzi?",
            //         "Tlein timitztlahpaloa?", "Tlein ticchihua?", "Quenin ticpiya?"
            //     ],
            //     responses: [
            //         "Cualli nimoyolcuitia", "Ahmelli nimoyolcuitia", "Zan nicyocoya",
            //         "Nimitztlapaloa", "Nimitztlatlauhtia", "Nimitztlatemoa"
            //     ],
            //     family: [
            //         "Nantli", "Tahtli", "Piltontli", "Conetl",
            //         "Cihuapilli", "Tlacapilli", "Ihuitl", "Telpochpilli"
            //     ],
            //     numbers: [
            //         "Ce", "Ome", "Yei", "Nahui", "Macuilli",
            //         "Chicuace", "Chicome", "Chicuei", "Chicnahui", "Mahtlactli"
            //     ]
            // },
            // tkoc: {
            //     greetings: [
            //         "Bix a beel", "Bix a k'iin", "Waal a b'ixik", "Bix yaanam",
            //         "Bix a wàay", "Bix a beel ka'", "Bix a k'iin ka'", "Bix a wàay ka'"
            //     ],
            //     basic: [
            //         "Báayal u baats'", "T'aab'al u baats'", "Ch'ich' u baats'", "Luum u baats'",
            //         "Bix a ti'", "Bix a na'", "Bix a yuum", "Bix a ch'ich'"
            //     ],
            //     numbers: [
            //         "T'uun", "Ts'íib", "Oxib", "Tseeb", "Boob", "Aak", "B'uku", "Ch'iin", "K'aab", "Laajun"
            //     ],
            //     family: [
            //         "Inam", "Itat", "Ats'its", "U ch'úupal", "U íits'in", "U yum", "U na'", "U ts'its"
            //     ],
            //     questions: [
            //         "Jant' yaan a k'aba", "Jant' teen yaan", "Jant' u ts'akal", "Bix a wàay",
            //         "Jant' u k'iin", "Jant' u beel", "Jant' u yool", "Jant' u baats'"
            //     ],
            //     verbs: [
            //         "Yaan", "K'uch", "Meyah", "U'uy", "A'almaj", "Ch'ijch'", "Lúub", "Pach"
            //     ],
            //     nouns: [
            //         "K'iin", "Beel", "Wàay", "Ch'ich'", "Na'", "Yuum", "Ti'", "Baats'"
            //     ]
            // }
        };

        return optionsBank[language]?.[questionType] || optionsBank[language]?.greetings || [];
    }

    // Mezclar array aleatoriamente (Fisher-Yates shuffle)
    shuffleArray(array) {
        const shuffled = [...array];
        for (let i = shuffled.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
        }
        return shuffled;
    }

    getExercisesForUnit(language, levelId, unitId) {
        const exercises = Array.from(this.exercises.values())
            .filter(exercise =>
                exercise.language === language &&
                exercise.levelId === levelId &&
                exercise.unitId === unitId
            )
            .sort((a, b) => a.id - b.id);

        // Obtener vocabulario de unidades relacionadas para enriquecer las opciones
        const relatedVocabulary = this.getRelatedVocabulary(language, levelId, unitId);

        return exercises.map(exercise => {
            if (exercise.type === "multiple-choice") {
                const correctAnswer = exercise.correctAnswer;

                // Usar el vocabulario relacionado (actual + anterior + posterior) como banco de opciones
                let optionsBank = relatedVocabulary;

                // Si aún no hay opciones, intentar con el banco de opciones por defecto
                if (!optionsBank || optionsBank.length === 0) {
                    optionsBank = this.getMultipleChoiceOptions(language, "greetings");
                }

                // Si aún no hay opciones, usar la respuesta correcta como única opción
                if (!optionsBank || optionsBank.length === 0) {
                    return {
                        ...exercise,
                        options: [correctAnswer],
                        correctAnswer: 0
                    };
                }

                // Filtrar opciones que no sean la respuesta correcta
                const wrongOptions = optionsBank.filter(option => option !== correctAnswer);

                // Seleccionar hasta 3 opciones incorrectas aleatorias
                const numWrongOptions = Math.min(3, wrongOptions.length);
                const selectedWrongOptions = this.shuffleArray(wrongOptions).slice(0, numWrongOptions);

                // Combinar con la respuesta correcta y mezclar
                const allOptions = this.shuffleArray([correctAnswer, ...selectedWrongOptions]);

                // Encontrar el índice de la respuesta correcta en las opciones mezcladas
                const correctIndex = allOptions.findIndex(option => option === correctAnswer);

                return {
                    ...exercise,
                    options: allOptions,
                    correctAnswer: correctIndex
                };
            }
            return exercise;
        });
    }

    // Nuevo método para obtener vocabulario de unidades relacionadas
    getRelatedVocabulary(language, levelId, unitId) {
        const vocabulary = new Set();

        // Obtener la unidad actual
        const currentUnit = this.getUnit(language, levelId, unitId);
        if (currentUnit && currentUnit.vocabulary) {
            currentUnit.vocabulary.forEach(item => vocabulary.add(item.word));
        }

        // Obtener unidades del mismo nivel
        const sameLevelUnits = this.getUnits(language, levelId);

        // Agregar vocabulario de unidades anteriores (hasta 2 unidades antes)
        const currentUnitIndex = sameLevelUnits.findIndex(unit => unit.id === unitId);
        for (let i = Math.max(0, currentUnitIndex - 2); i < currentUnitIndex; i++) {
            if (sameLevelUnits[i] && sameLevelUnits[i].vocabulary) {
                sameLevelUnits[i].vocabulary.forEach(item => vocabulary.add(item.word));
            }
        }

        // Agregar vocabulario de unidades posteriores (hasta 2 unidades después)
        for (let i = currentUnitIndex + 1; i <= Math.min(sameLevelUnits.length - 1, currentUnitIndex + 2); i++) {
            if (sameLevelUnits[i] && sameLevelUnits[i].vocabulary) {
                sameLevelUnits[i].vocabulary.forEach(item => vocabulary.add(item.word));
            }
        }

        // Si aún no hay suficiente vocabulario, agregar del nivel anterior
        if (vocabulary.size < 10 && levelId > 1) {
            const previousLevelUnits = this.getUnits(language, levelId - 1);
            // Tomar hasta 5 palabras del nivel anterior
            previousLevelUnits.slice(-3).forEach(unit => {
                if (unit && unit.vocabulary) {
                    unit.vocabulary.forEach(item => vocabulary.add(item.word));
                }
            });
        }

        return Array.from(vocabulary);
    }

    getLevels(language) {
        const levels = Array.from(this.levels.values())
            .filter(level => level.language === language)
            .sort((a, b) => a.order - b.order);
        return levels;
    }

    getLevelsWithUnlockCheck(language) {
        const levels = this.getLevels(language);
        this.checkAndUpdateLevelLockStatus(language);
        return levels;
    }

    checkAndUpdateLevelLockStatus(language) {
        const levels = this.getLevels(language); // Usar getLevels normal, no el que verifica

        levels.forEach(level => {
            if (level.locked) {
                let shouldUnlock = false;

                // Verificar requisitos basados en el nivel
                switch (level.id) {
                    case 2: // Nivel 2: Completar 4 unidades del Nivel 1
                        const level1Units = this.getUnits(language, 1);
                        const completedLevel1Units = level1Units.filter(unit => unit.completed).length;
                        shouldUnlock = completedLevel1Units >= 4;
                        break;

                    case 3: // Nivel 3: Completar Nivel 2
                        const level2 = this.getLevel(language, 2);
                        shouldUnlock = level2 && !level2.locked && level2.completedUnits === level2.units;
                        break;

                    case 4: // Nivel 4: Completar Nivel 3
                        const level3 = this.getLevel(language, 3);
                        shouldUnlock = level3 && !level3.locked && level3.completedUnits === level3.units;
                        break;

                    case 5: // Nivel 5: Completar Nivel 4
                        const level4 = this.getLevel(language, 4);
                        shouldUnlock = level4 && !level4.locked && level4.completedUnits === level4.units;
                        break;

                    default:
                        shouldUnlock = false;
                }

                // Desbloquear nivel si se cumplen los requisitos
                if (shouldUnlock) {
                    level.locked = false;
                    console.log(`Nivel ${level.id} desbloqueado para ${language}`);
                }
            }
        });
    }

    getLevel(language, levelId) {
        return this.levels.get(`${language}_${levelId}`);
    }

    getUnits(language, levelId) {
        return Array.from(this.units.values())
            .filter(unit => unit.language === language && unit.levelId === levelId)
            .sort((a, b) => a.id - b.id);
    }

    getUnit(language, levelId, unitId) {
        return this.units.get(`${language}_${levelId}_${unitId}`);
    }

    completeUnit(language, levelId, unitId) {
        const unit = this.getUnit(language, levelId, unitId);

        // VERIFICAR SI YA ESTABA COMPLETADA
        const wasAlreadyCompleted = unit && unit.completed;

        if (unit && !wasAlreadyCompleted) {
            unit.complete();

            // Actualizar progreso del nivel
            const level = this.getLevel(language, levelId);
            if (level) {
                level.completeUnit();
            }

            // DESBLOQUEAR SIGUIENTE UNIDAD AUTOMÁTICAMENTE
            const nextUnit = this.getNextUnit(language, levelId, unitId);
            if (nextUnit && nextUnit.locked) {
                nextUnit.unlock();
                nextUnit.current = true;
                // Remover current de la unidad anterior
                unit.current = false;
            }

            // Verificar y actualizar estado de desbloqueo de niveles
            this.checkAndUpdateLevelLockStatus(language);

            return true;
        }

        // Si ya estaba completada, retornar false para indicar que no hubo cambio
        return false;
    }

    unlockUnit(language, levelId, unitId) {
        const unit = this.getUnit(language, levelId, unitId);
        if (unit) {
            unit.unlock();
            return true;
        }
        return false;
    }

    getNextUnit(language, levelId, unitId) {
        const units = this.getUnits(language, levelId);
        const currentIndex = units.findIndex(unit => unit.id === unitId);

        if (currentIndex < units.length - 1) {
            return units[currentIndex + 1];
        }

        // Buscar en el siguiente nivel
        const levels = this.getLevels(language);
        const currentLevelIndex = levels.findIndex(level => level.id === levelId);

        if (currentLevelIndex < levels.length - 1) {
            const nextLevelUnits = this.getUnits(language, levels[currentLevelIndex + 1].id);
            return nextLevelUnits[0] || null;
        }

        return null;
    }

    getSupportedLanguages() {
        const languages = new Set();
        Array.from(this.levels.values()).forEach(level => {
            languages.add(level.language);
        });
        return Array.from(languages);
    }

    getCompletedUnits(language) {
        const completedUnits = [];
        const levels = this.getLevels(language);

        levels.forEach(level => {
            const units = this.getUnits(language, level.id);
            const completedLevelUnits = units.filter(unit => unit.completed);
            completedUnits.push(...completedLevelUnits);
        });

        return completedUnits;
    }

}