export class Unit {
    constructor(data = {}) {
        this.id = data.id || 1;
        this.levelId = data.levelId || 1;
        this.language = data.language || "nhce";
        this.title = data.title || "";
        this.color = data.color || "#58CC02";
        this.completed = data.completed || false;
        this.current = data.current || false;
        this.locked = data.locked !== undefined ? data.locked : true;
        this.objective = data.objective || "";
        this.grammar = data.grammar || "";
        this.vocabulary = data.vocabulary || [];
        this.exercises = data.exercises || [];
        this.dialectVariants = data.dialectVariants || false;
        this.cultural = data.cultural || false;
        this.unlockRequirement = data.unlockRequirement || "";
        this.estimatedMinutes = data.estimatedMinutes || 15;
    }

    addVocabulary(word, translation, pronunciation = "", example = "") {
        this.vocabulary.push({
            word,
            translation,
            pronunciation,
            example
        });
    }

    addExercise(exercise) {
        this.exercises.push(exercise);
    }

    complete() {
        this.completed = true;
        this.current = false;
    }

    unlock() {
        this.locked = false;
    }
}