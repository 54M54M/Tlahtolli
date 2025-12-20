export class EnergyService {
    constructor() {
        this.ENERGY_KEY = 'tonalli_energy_data';
        this.RECOVERY_INTERVAL = 20 * 60 * 1000; // 20 minutos
    }

    // Inicializar energía para un usuario
    initializeEnergy(userId) {
        const saved = this.loadEnergy(userId);
        if (saved) {
            // Calcular recarga pasiva
            const now = Date.now();
            const timePassed = now - saved.lastUpdate;
            const recoveryUnits = Math.floor(timePassed / this.RECOVERY_INTERVAL);

            if (recoveryUnits > 0) {
                saved.currentEnergy = Math.min(
                    saved.maxEnergy,
                    saved.currentEnergy + recoveryUnits
                );
                saved.lastUpdate = now;
                this.saveEnergy(userId, saved);

                // Verificar si está llena para notificación
                if (saved.currentEnergy >= saved.maxEnergy) {
                    return {
                        energy: saved,
                        notification: {
                            show: true,
                            message: "¡Recuperaste toda tu energía! ¿Qué tal si aprendemos algo nuevo?"
                        }
                    };
                }
            }
            return { energy: saved, notification: null };
        }

        // Crear nueva energía
        const newEnergy = {
            userId: userId,
            maxEnergy: 15,
            currentEnergy: 15,
            // maxEnergy: 25,
            // currentEnergy: 25,
            streakCount: 0,
            lastUpdate: Date.now(),
            dailyConsumption: 0,
            totalExercisesToday: 0
        };

        this.saveEnergy(userId, newEnergy);
        return { energy: newEnergy, notification: null };
    }

    // Consumir energía para un ejercicio
    consumeForExercise(energy, isCorrect) {
        let energyChange = -1; // Consumo base siempre

        // Bonus por acierto
        if (isCorrect) {
            // Bonus aleatorio +1 o +2
            const correctBonus = Math.random() < 0.5 ? 1 : 2;
            energyChange += correctBonus;

            // Incrementar racha
            energy.streakCount++;

            // Bonus por racha (3+ aciertos seguidos)
            if (energy.streakCount >= 3) {
                const streakBonus = Math.random() < 0.5 ? 3 : 4;
                energyChange += streakBonus;
            }
        } else {
            // Resetear racha si falla
            energy.streakCount = 0;
        }

        // Aplicar cambio
        const newEnergy = energy.currentEnergy + energyChange;
        energy.currentEnergy = Math.max(0, Math.min(energy.maxEnergy, newEnergy));
        energy.lastUpdate = Date.now();
        energy.totalExercisesToday++;

        this.saveEnergy(energy.userId, energy);

        return {
            energyChange,
            newEnergy: energy.currentEnergy,
            streak: energy.streakCount,
            isEnergyFull: energy.currentEnergy >= energy.maxEnergy
        };
    }

    // Recargar con ejercicio de práctica
    recoverFromPractice(energy) {
        const recovery = 1; // +1 por ejercicio de práctica

        energy.currentEnergy = Math.min(
            energy.maxEnergy,
            energy.currentEnergy + recovery
        );
        energy.lastUpdate = Date.now();

        this.saveEnergy(energy.userId, energy);

        return {
            recovery,
            newEnergy: energy.currentEnergy,
            isEnergyFull: energy.currentEnergy >= energy.maxEnergy
        };
    }

    // Métodos de almacenamiento usando localStorage directamente
    saveEnergy(userId, energy) {
        try {
            const key = `${this.ENERGY_KEY}_${userId}`;
            localStorage.setItem(key, JSON.stringify(energy));
        } catch (error) {
            console.error('Error guardando energía:', error);
        }
    }

    loadEnergy(userId) {
        try {
            const key = `${this.ENERGY_KEY}_${userId}`;
            const data = localStorage.getItem(key);
            return data ? JSON.parse(data) : null;
        } catch (error) {
            console.error('Error cargando energía:', error);
            return null;
        }
    }

    // Verificar si hay suficiente energía para una lección
    hasEnoughEnergy(energy, exercisesCount) {
        return energy.currentEnergy >= exercisesCount; // Al menos 1 por ejercicio
    }

    // Calcular tiempo para recuperar X energía
    calculateRecoveryTime(energyNeeded) {
        const minutes = energyNeeded * 20; // 20 min por punto
        if (minutes < 60) return `${minutes} minutos`;
        const hours = Math.floor(minutes / 60);
        const mins = minutes % 60;
        return mins > 0 ? `${hours}h ${mins}min` : `${hours} horas`;
    }

    // Resetear energía diaria (llamar a medianoche)
    resetDailyStats(energy) {
        energy.dailyConsumption = 0;
        energy.totalExercisesToday = 0;
        this.saveEnergy(energy.userId, energy);
    }
}