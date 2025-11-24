export class Exercise {
    constructor(data = {}) {
        this.id = data.id || Date.now();
        this.unitId = data.unitId || 1;
        this.levelId = data.levelId || 1;
        this.type = data.type || "multiple-choice";
        this.question = data.question || "";
        this.answer = data.answer || "";
        this.character = data.character;
        this.options = data.options || [];
        this.correctAnswer = data.correctAnswer || 0;
        this.correct = data.correct || []; // Para respuestas múltiples
        this.placeholder = data.placeholder || "";
        this.explanation = data.explanation || "";
        this.points = data.points || 10;
        this.difficulty = data.difficulty || "easy";
        this.language = data.language || "nhce";
        this.dialectVariant = data.dialectVariant || "all";
    }

    validateAnswer(userAnswer) {
        switch (this.type) {
            case "multiple-choice":
                return userAnswer === this.correctAnswer;
            case "fill-blank":
                // SOPORTE PARA MÚLTIPLES RESPUESTAS CORRECTAS
                const userAnswerClean = userAnswer.toLowerCase().trim();

                // Si correctAnswer es un array, aceptar cualquiera de las respuestas
                if (Array.isArray(this.correctAnswer)) {
                    return this.correctAnswer.some(correct =>
                        userAnswerClean === correct.toLowerCase().trim()
                    );
                }
                // Si es string, comportamiento normal
                return userAnswerClean === this.correctAnswer.toLowerCase().trim();
            case "match":
                return JSON.stringify(userAnswer) === JSON.stringify(this.correctAnswer);
            case "multiple-correct":
                const userAnswers = Array.isArray(userAnswer) ? userAnswer : [userAnswer];
                const correctAnswers = Array.isArray(this.correct) ? this.correct : [this.correctAnswer];
                return userAnswers.length === correctAnswers.length &&
                    userAnswers.every(answer => correctAnswers.includes(answer));
            default:
                return false;
        }
    }

    getMaxPoints() {
        const basePoints = this.points;
        const difficultyMultiplier = {
            "easy": 1,
            "medium": 1.5,
            "hard": 2
        };
        return basePoints * (difficultyMultiplier[this.difficulty] || 1);
    }
}