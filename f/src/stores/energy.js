import { defineStore } from 'pinia'
import { EnergyService } from '../data/services/EnergyService.js'
import { Energy } from '../data/models/Energy.js'

export const useEnergyStore = defineStore('energy', {
    state: () => ({
        energy: null,
        isLoading: false,
        lastSync: null,
        energyChanges: []
    }),

    getters: {
        // Getters útiles para acceder a los datos de energía
        currentEnergy: (state) => state.energy?.currentEnergy,
        maxEnergy: (state) => state.energy?.maxEnergy,
        energyPercentage: (state) => {
            if (!state.energy) return 100
            return (state.energy.currentEnergy / state.energy.maxEnergy) * 100
        },
        streakCount: (state) => state.energy?.streakCount || 0,
        isLowEnergy: (state) => {
            if (!state.energy) return false
            return (state.energy.currentEnergy / state.energy.maxEnergy) < 0.3
        },
        isFullEnergy: (state) => {
            if (!state.energy) return false
            return state.energy.currentEnergy >= state.energy.maxEnergy
        },
        // Para mostrar en el header
        displayEnergy: (state) => `${state.energy?.currentEnergy}/${state.energy?.maxEnergy}`,
        energyForHeader: (state) => ({
            current: state.energy?.currentEnergy,
            max: state.energy?.maxEnergy,
            streak: state.energy?.streakCount || 0
        })
    },

    actions: {
        // Inicializar energía para un usuario
        async initializeEnergy(userId) {
            this.isLoading = true
            try {
                const energyService = new EnergyService()
                const { energy, notification } = energyService.initializeEnergy(userId)

                if (energy instanceof Energy) {
                    this.energy = energy
                } else {
                    this.energy = Energy.fromJSON(energy)
                }

                this.lastSync = Date.now()

                if (notification?.show) {
                    // console.log('⚡ Energía completa:', notification.message)
                }

                // console.log('⚡ Energía inicializada globalmente:', this.energy)
                return this.energy
            } catch (error) {
                console.error('Error al inicializar energía:', error)
                // Crear energía por defecto
                this.energy = new Energy(userId || 1)
                return this.energy
            } finally {
                this.isLoading = false
            }
        },

        // Consumir energía para un ejercicio (sincronizado)
        async consumeForExercise(isCorrect) {
            if (!this.energy) {
                await this.initializeEnergy(1) // Usuario por defecto
            }

            const energyService = new EnergyService()
            const energyResult = energyService.consumeForExercise(this.energy, isCorrect)

            // Actualizar energía en el store
            this.energy.currentEnergy = energyResult.newEnergy
            this.energy.streakCount = energyResult.streak
            this.energy.lastUpdate = Date.now()

            // Guardar cambios
            this.saveToLocalStorage()

            // Agregar cambio para animaciones
            this.addEnergyChange(energyResult.energyChange)

            return energyResult
        },

        // Recuperar energía desde práctica
        async recoverFromPractice() {
            if (!this.energy) {
                await this.initializeEnergy(1)
            }

            const energyService = new EnergyService()
            const result = energyService.recoverFromPractice(this.energy)

            // Actualizar
            this.energy.currentEnergy = result.newEnergy
            this.energy.lastUpdate = Date.now()

            this.saveToLocalStorage()
            this.addEnergyChange(result.recovery)

            return result
        },

        // Verificar si hay suficiente energía
        hasEnoughEnergy(exercisesCount = 1) {
            if (!this.energy) return false
            return this.energy.currentEnergy >= exercisesCount
        },

        // Sincronizar energía desde localStorage (para cuando se abre la app)
        syncFromLocalStorage(userId = 1) {
            try {
                const energyService = new EnergyService()
                const saved = energyService.loadEnergy(userId)

                if (saved) {
                    this.energy = Energy.fromJSON(saved)
                    this.lastSync = Date.now()
                    // console.log('⚡ Energía sincronizada desde localStorage')
                } else {
                    this.initializeEnergy(userId)
                }
            } catch (error) {
                console.error('Error sincronizando energía:', error)
                this.initializeEnergy(userId)
            }
        },

        // Guardar energía en localStorage
        saveToLocalStorage() {
            if (!this.energy) return

            try {
                const energyService = new EnergyService()
                energyService.saveEnergy(this.energy.userId, this.energy)
                this.lastSync = Date.now()
            } catch (error) {
                console.error('Error guardando energía:', error)
            }
        },

        // Agregar cambio para animaciones
        addEnergyChange(change) {
            const changeObj = {
                id: Date.now(),
                value: change,
                timestamp: Date.now(),
                type: change > 0 ? 'gain' : 'loss'
            }

            this.energyChanges.push(changeObj)

            // Limpiar después de 2 segundos
            setTimeout(() => {
                this.energyChanges = this.energyChanges.filter(c => c.id !== changeObj.id)
            }, 2000)
        },

        // Resetear cambios (para limpieza)
        clearEnergyChanges() {
            this.energyChanges = []
        },

        // Obtener tiempo de recuperación
        getRecoveryTime(energyNeeded = 1) {
            const energyService = new EnergyService()
            return energyService.calculateRecoveryTime(energyNeeded)
        },

        // Actualizar energía manualmente (para debugging)
        setEnergy(value) {
            if (!this.energy) {
                this.initializeEnergy(1)
            }

            this.energy.currentEnergy = Math.max(0, Math.min(this.energy.maxEnergy, value))
            this.saveToLocalStorage()
        }
    },

    persist: {
        key: 'energy-storage',
        paths: ['energy', 'lastSync']
    }
})