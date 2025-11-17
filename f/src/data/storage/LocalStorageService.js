export class LocalStorageService {
    static saveProgress(language, progressData) {
        // console.log(`📝 Guardando progreso para lenguaje: ${language}`, progressData);
        const allProgress = this.getAllProgress();
        allProgress[language] = progressData;
        const dataToSave = JSON.stringify(allProgress);

        localStorage.setItem('user-progress', dataToSave);

        // console.log(`✅ Progreso guardado en localStorage:`, dataToSave);
    }

    static getProgress(language) {
        // console.log(`📖 Obteniendo progreso para lenguaje: ${language}`);
        const allProgress = this.getAllProgress();
        const progress = allProgress[language] || this.getDefaultProgress(language);
        // console.log(`📊 Progreso recuperado:`, progress);
        return progress;
    }

    static getAllProgress() {
        const progress = JSON.parse(localStorage.getItem('user-progress') || '{}');
        // console.log(`📋 Todo el progreso:`, progress);
        return progress;
    }

    static getDefaultProgress(language) {
        // console.log(`🔄 Usando progreso por defecto para: ${language}`);
        const defaultProgress = {
            levels: {
                1: { completedUnits: 0, totalUnits: 6 },
                2: { completedUnits: 0, totalUnits: 6 },
                3: { completedUnits: 0, totalUnits: 6 },
                4: { completedUnits: 0, totalUnits: 6 },
                5: { completedUnits: 0, totalUnits: 6 }
            },
            currentUnit: { levelId: 1, unitId: 1 },
            completedUnits: 0,
            totalUnits: 30
        };
        // console.log(`⚙️ Progreso por defecto:`, defaultProgress);
        return defaultProgress;
    }

    static saveUserData(userData) {
        // console.log(`👤 Guardando datos de usuario:`, userData);
        const dataToSave = JSON.stringify(userData);
        localStorage.setItem('user-data', dataToSave);
        // console.log(`✅ Datos de usuario guardados:`, dataToSave);
    }

    static getUserData() {
        const userData = JSON.parse(localStorage.getItem('user-data') || '{}');
        // console.log(`👤 Datos de usuario recuperados:`, userData);
        return userData;
    }

    static saveStats(statsData) {
        const dataToSave = JSON.stringify(statsData);
        localStorage.setItem('user-stats', dataToSave);
    }

    static getAllStats() {
        return JSON.parse(localStorage.getItem('user-stats') || '{}');
    }

    static getStats(userId) {
        const allStats = this.getAllStats();
        return allStats[userId] || null;
    }

    static saveAchievements(achievements) {
        const dataToSave = JSON.stringify(achievements);
        localStorage.setItem('user-achievements', dataToSave);
    }

    static getAchievements() {
        return JSON.parse(localStorage.getItem('user-achievements') || '[]');
    }

    // Método para limpiar también las stats
    static clearAll() {
        localStorage.removeItem('user-progress');
        localStorage.removeItem('user-data');
        localStorage.removeItem('user-stats');
        localStorage.removeItem('user-achievements');
    }

    // Método adicional para monitorear cambios en tiempo real
    static monitorChanges() {
        console.log(`👀 Monitoreando cambios en localStorage...`);
        window.addEventListener('storage', (e) => {
            console.log(`🔄 Cambio detectado en localStorage:`, {
                key: e.key,
                oldValue: e.oldValue,
                newValue: e.newValue,
                url: e.url
            });
        });
    }
    
    static setLastVisited(language, levelId, unitId = null) {
        const progress = this.getProgress(language);
        progress.lastVisited = {
            levelId: levelId,
            unitId: unitId,
            timestamp: new Date().toISOString()
        };
        localStorage.setItem(`progress_${language}`, JSON.stringify(progress));
    }

    static getLastVisited(language) {
        const progress = this.getProgress(language);
        return progress.lastVisited || null;
    }
}