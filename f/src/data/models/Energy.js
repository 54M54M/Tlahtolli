export class Energy {
    constructor(userId) {
        this.userId = userId;
        this.maxEnergy = 15;
        this.currentEnergy = 15;
        // this.maxEnergy = 25;
        // this.currentEnergy = 25;
        this.streakCount = 0;
        this.lastUpdate = Date.now();
        this.dailyConsumption = 0;
        this.totalExercisesToday = 0;
    }

    // Método para clonar (para Vue reactivity)
    clone() {
        const cloned = new Energy(this.userId);
        cloned.maxEnergy = this.maxEnergy;
        cloned.currentEnergy = this.currentEnergy;
        cloned.streakCount = this.streakCount;
        cloned.lastUpdate = this.lastUpdate;
        cloned.dailyConsumption = this.dailyConsumption;
        cloned.totalExercisesToday = this.totalExercisesToday;
        return cloned;
    }

    // Método para convertir a objeto plano (para almacenamiento)
    toJSON() {
        return {
            userId: this.userId,
            maxEnergy: this.maxEnergy,
            currentEnergy: this.currentEnergy,
            streakCount: this.streakCount,
            lastUpdate: this.lastUpdate,
            dailyConsumption: this.dailyConsumption,
            totalExercisesToday: this.totalExercisesToday
        };
    }

    // Método estático para crear desde objeto
    static fromJSON(data) {
        const energy = new Energy(data.userId);
        energy.maxEnergy = data.maxEnergy;
        energy.currentEnergy = data.currentEnergy;
        energy.streakCount = data.streakCount || 0;
        energy.lastUpdate = data.lastUpdate || Date.now();
        energy.dailyConsumption = data.dailyConsumption || 0;
        energy.totalExercisesToday = data.totalExercisesToday || 0;
        return energy;
    }

    // Getters útiles
    get percentage() {
        return (this.currentEnergy / this.maxEnergy) * 100;
    }

    get isLow() {
        return this.percentage < 30;
    }

    get isFull() {
        return this.currentEnergy >= this.maxEnergy;
    }

    get isEmpty() {
        return this.currentEnergy <= 0;
    }

    get hasStreak() {
        return this.streakCount >= 3;
    }
}