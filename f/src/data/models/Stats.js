export class Stats {
    constructor(data = {}) {
        this.userId = data.userId || 1;
        this.wordsLearned = data.wordsLearned || 0;
        this.lessonsCompleted = data.lessonsCompleted || 0;
        this.perfectLessons = data.perfectLessons || 0;
        this.daysStudied = data.daysStudied || 0;
        this.bestStreak = data.bestStreak || 0;
        this.totalXP = data.totalXP || 0;
        this.averageTimePerDay = data.averageTimePerDay || 0;
        this.languageProgress = data.languageProgress || {};
        this.lastStudyDate = data.lastStudyDate || null;
        this.totalMinutes = data.totalMinutes || 0;
    }

    updateLanguageProgress(language, progressData) {
        if (!this.languageProgress[language]) {
            this.languageProgress[language] = {
                dialectProgress: {},
                wordsLearned: 0,
                lessonsCompleted: 0,
                unitsCompleted: 0,
                levelsCompleted: 0
            };
        }

        Object.assign(this.languageProgress[language], progressData);
    }

    addWordsLearned(language, count = 1) {
        if (!this.languageProgress[language]) {
            this.updateLanguageProgress(language, {});
        }
        this.languageProgress[language].wordsLearned += count;
        this.wordsLearned += count;
    }

    addLessonCompleted(language, perfect = false) {
        if (!this.languageProgress[language]) {
            this.updateLanguageProgress(language, {});
        }
        this.languageProgress[language].lessonsCompleted++;
        this.lessonsCompleted++;

        if (perfect) {
            this.perfectLessons++;
        }
    }

    updateStreak(currentStreak) {
        if (currentStreak > this.bestStreak) {
            this.bestStreak = currentStreak;
        }
    }
}