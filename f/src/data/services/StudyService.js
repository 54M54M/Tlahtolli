import { DictionaryRepository } from '../repositories/DictionaryRepository.js';
import { LearningRepository } from '../repositories/LearningRepository.js';

export class StudyService {
    constructor() {
        this.dictionaryRepo = new DictionaryRepository();
        this.learningRepo = new LearningRepository();
    }

    generateVocabularyPractice(language, category = null, count = 10, difficulty = null) {
        let words = category ?
            this.dictionaryRepo.getEntriesByCategory(category, language) :
            this.dictionaryRepo.getRandomEntries(count, language, difficulty);

        // Si no hay suficientes palabras, completar con palabras aleatorias
        if (words.length < count) {
            const additionalWords = this.dictionaryRepo.getRandomEntries(
                count - words.length,
                language,
                difficulty
            );
            words = [...words, ...additionalWords];
        }

        const exercises = words.map((word, index) => ({
            id: `${language}_vocab_${index + 1}`,
            type: "multiple-choice",
            question: this.getQuestionText(language, word.spanish),
            options: this.generateWrongOptions(word, language, 3),
            correctAnswer: this.getCorrectTranslation(word, language),
            explanation: this.getExplanationText(language, word),
            points: this.getPointsByDifficulty(word.difficulty),
            difficulty: word.difficulty,
            metadata: {
                wordId: word.id,
                category: word.category,
                language: language
            }
        }));

        return exercises;
    }

    generateWrongOptions(correctWord, language, count = 3) {
        const allWords = this.dictionaryRepo.getAllEntries(language);
        const wrongWords = allWords
            .filter(word => word.id !== correctWord.id && word.category === correctWord.category)
            .sort(() => 0.5 - Math.random())
            .slice(0, count)
            .map(word => this.getCorrectTranslation(word, language));

        // Si no hay suficientes palabras de la misma categoría, completar con cualquier palabra
        if (wrongWords.length < count) {
            const additionalWords = allWords
                .filter(word => word.id !== correctWord.id)
                .sort(() => 0.5 - Math.random())
                .slice(0, count - wrongWords.length)
                .map(word => this.getCorrectTranslation(word, language));

            wrongWords.push(...additionalWords);
        }

        const correctTranslation = this.getCorrectTranslation(correctWord, language);
        const options = [...wrongWords, correctTranslation];

        // Mezclar opciones
        return options.sort(() => 0.5 - Math.random());
    }

    getCorrectTranslation(word, language) {
        if (language === 'nhce') {
            return word.central || word.spanish;
        } else if (language === 'tkoc') {
            return word.teenek || word.spanish;
        }
        return word.spanish;
    }

    getQuestionText(language, spanishWord) {
        const languageNames = {
            'nhce': 'náhuatl',
            'tkoc': 'teenek'
        };
        return `¿Cómo se dice "${spanishWord}" en ${languageNames[language]}?`;
    }

    getExplanationText(language, word) {
        const languageNames = {
            'nhce': 'náhuatl',
            'tkoc': 'teenek'
        };
        const translation = this.getCorrectTranslation(word, language);
        return `"${word.spanish}" se dice "${translation}" en ${languageNames[language]}. ${word.example ? `Ejemplo: ${word.example}` : ''}`;
    }

    getPointsByDifficulty(difficulty) {
        const points = {
            'easy': 10,
            'medium': 15,
            'hard': 20
        };
        return points[difficulty] || 10;
    }

    generateFillInBlank(language, count = 5) {
        const words = this.dictionaryRepo.getRandomEntries(count, language, "easy");

        return words.map((word, index) => ({
            id: `${language}_fill_${index + 1}`,
            type: "fill-blank",
            question: this.getFillQuestionText(language, word),
            correctAnswer: this.getCorrectTranslation(word, language),
            placeholder: this.getPlaceholderText(language),
            explanation: this.getExplanationText(language, word),
            points: this.getPointsByDifficulty(word.difficulty),
            difficulty: word.difficulty,
            metadata: {
                wordId: word.id,
                category: word.category,
                language: language
            }
        }));
    }

    getFillQuestionText(language, word) {
        const languageNames = {
            'nhce': 'náhuatl',
            'tkoc': 'teenek'
        };

        if (word.example && word.example.includes(' - ')) {
            const [sentence, translation] = word.example.split(' - ');
            return `Completa la traducción: "${sentence}" se dice: __________`;
        }

        return `¿Cómo se dice "${word.spanish}" en ${languageNames[language]}?`;
    }

    getPlaceholderText(language) {
        const placeholders = {
            'nhce': 'Escribe la palabra en náhuatl...',
            'tkoc': 'Escribe la palabra en teenek...'
        };
        return placeholders[language] || 'Escribe la traducción...';
    }

    generateListeningPractice(language, count = 5) {
        // Para una implementación futura con audio
        const words = this.dictionaryRepo.getRandomEntries(count, language, "easy");

        return words.map((word, index) => ({
            id: `${language}_listen_${index + 1}`,
            type: "fill-blank",
            question: `Escucha y escribe la palabra que escuchas:`,
            correctAnswer: this.getCorrectTranslation(word, language),
            placeholder: this.getPlaceholderText(language),
            explanation: `La palabra era "${this.getCorrectTranslation(word, language)}" que significa "${word.spanish}".`,
            points: 15,
            difficulty: "medium",
            hasAudio: true,
            metadata: {
                wordId: word.id,
                category: word.category,
                language: language
            }
        }));
    }

    createStudySession(language, focus = "vocabulary", options = {}) {
        const session = {
            id: Date.now(),
            language,
            focus,
            exercises: [],
            startTime: new Date(),
            completed: false,
            score: 0,
            settings: {
                count: options.count || 10,
                difficulty: options.difficulty || null,
                category: options.category || null,
                includeAudio: options.includeAudio || false
            }
        };

        switch (focus) {
            case "vocabulary":
                session.exercises = this.generateVocabularyPractice(
                    language,
                    options.category,
                    options.count || 10,
                    options.difficulty
                );
                break;

            case "grammar":
                session.exercises = this.generateFillInBlank(
                    language,
                    options.count || 5
                );
                break;

            case "listening":
                session.exercises = this.generateListeningPractice(
                    language,
                    options.count || 5
                );
                break;

            case "mixed":
                const vocabCount = Math.floor((options.count || 10) * 0.6);
                const grammarCount = Math.floor((options.count || 10) * 0.4);

                const vocab = this.generateVocabularyPractice(language, null, vocabCount);
                const grammar = this.generateFillInBlank(language, grammarCount);
                session.exercises = [...vocab, ...grammar].sort(() => 0.5 - Math.random());
                break;
        }

        return session;
    }

    evaluateSession(session, userAnswers) {
        let correct = 0;
        let totalPoints = 0;
        const results = [];

        session.exercises.forEach((exercise, index) => {
            const userAnswer = userAnswers[index];
            let isCorrect = false;

            switch (exercise.type) {
                case "multiple-choice":
                    isCorrect = userAnswer === exercise.correctAnswer;
                    break;
                case "fill-blank":
                    isCorrect = userAnswer.toLowerCase().trim() === exercise.correctAnswer.toLowerCase().trim();
                    break;
                default:
                    isCorrect = false;
            }

            if (isCorrect) {
                correct++;
                totalPoints += exercise.points;
            }

            results.push({
                exercise,
                userAnswer,
                isCorrect,
                explanation: exercise.explanation,
                points: isCorrect ? exercise.points : 0
            });
        });

        const score = (correct / session.exercises.length) * 100;
        const performance = score / 100;

        session.completed = true;
        session.endTime = new Date();
        session.score = score;
        session.totalPoints = totalPoints;
        session.correctAnswers = correct;
        session.performance = performance;

        return {
            session,
            results,
            score,
            correct,
            total: session.exercises.length,
            totalPoints,
            performance
        };
    }

    getStudyRecommendations(userId, language) {
        // En una implementación real, esto analizaría el historial de estudio del usuario
        // Por ahora, devolvemos recomendaciones basadas en el idioma

        const categories = this.dictionaryRepo.getCategories(language);
        const weakCategories = this.identifyWeakCategories(userId, language);
        const stats = this.dictionaryRepo.getLanguageStats(language);

        return {
            practiceVocabulary: weakCategories.slice(0, 2),
            reviewGrammar: ["verbos", "adjetivos"].filter(cat => categories.includes(cat)),
            newContent: this.suggestNewContent(language),
            focusAreas: this.getFocusAreas(stats),
            estimatedTime: "15-20 minutos"
        };
    }

    identifyWeakCategories(userId, language) {
        // Simulación - en una app real esto vendría de la base de datos
        const categories = this.dictionaryRepo.getCategories(language);
        return categories
            .sort(() => 0.5 - Math.random())
            .slice(0, Math.min(3, categories.length));
    }

    suggestNewContent(language) {
        const allEntries = this.dictionaryRepo.getAllEntries(language);
        // Simulación de palabras no aprendidas
        const learnedWords = [];

        return allEntries
            .filter(entry => !learnedWords.includes(entry.id))
            .sort(() => 0.5 - Math.random())
            .slice(0, 5)
            .map(entry => ({
                word: this.getCorrectTranslation(entry, language),
                translation: entry.spanish,
                category: entry.category,
                difficulty: entry.difficulty
            }));
    }

    getFocusAreas(stats) {
        const areas = [];

        if (stats.difficultyBreakdown.hard < 5) {
            areas.push("Palabras difíciles");
        }

        if (stats.categories < 8) {
            areas.push("Nuevas categorías");
        }

        return areas.length > 0 ? areas : ["Vocabulario general"];
    }

    // Método para generar práctica de repaso basada en palabras mal contestadas
    generateReviewSession(language, incorrectWords = [], count = 8) {
        let reviewWords = [...incorrectWords];

        // Si no hay suficientes palabras incorrectas, completar con palabras aleatorias
        if (reviewWords.length < count) {
            const additionalWords = this.dictionaryRepo.getRandomEntries(
                count - reviewWords.length,
                language
            ).map(word => word.id);
            reviewWords = [...reviewWords, ...additionalWords];
        }

        const words = reviewWords
            .slice(0, count)
            .map(wordId => this.dictionaryRepo.getEntry(wordId))
            .filter(word => word !== undefined);

        return this.generateVocabularyPractice(language, null, count).map(exercise => {
            // Reemplazar con las palabras de repaso específicas
            const word = words.find(w => w.id === exercise.metadata.wordId) || words[0];
            return {
                ...exercise,
                question: this.getQuestionText(language, word.spanish),
                correctAnswer: this.getCorrectTranslation(word, language),
                explanation: this.getExplanationText(language, word),
                metadata: {
                    ...exercise.metadata,
                    wordId: word.id,
                    category: word.category,
                    isReview: true
                }
            };
        });
    }
}