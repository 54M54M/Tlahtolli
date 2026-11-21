// src/stores/energy.js
import { defineStore } from 'pinia'
import { energyApi } from '../api/apiClient.js'

export const useEnergyStore = defineStore('energy', {
    state: () => ({
        energy: null,
        isLoading: false,
        lastSync: null,
        energyChanges: [],
    }),

    getters: {
        currentEnergy: (state) => state.energy?.currentEnergy ?? 15,
        maxEnergy: (state) => state.energy?.maxEnergy ?? 15,
        streakCount: (state) => state.energy?.streakCount ?? 0,
        energyPercentage: (state) => {
            if (!state.energy) return 100
            return (state.energy.currentEnergy / state.energy.maxEnergy) * 100
        },
        isLowEnergy: (state) => state.energy
            ? (state.energy.currentEnergy / state.energy.maxEnergy) < 0.3
            : false,
        isFullEnergy: (state) => state.energy
            ? state.energy.currentEnergy >= state.energy.maxEnergy
            : true,
        energyForHeader: (state) => ({
            current: state.energy?.currentEnergy ?? 15,
            max: state.energy?.maxEnergy ?? 15,
            streak: state.energy?.streakCount ?? 0,
        }),
    },

    actions: {
        // ── inicialización ─────────────────────────────────────────────────────

        async initializeEnergy(userId) {
            // Guardia: no llamar a la API sin un userId válido
            if (!userId) {
                console.warn('[energy] initializeEnergy llamado sin userId — ignorado')
                return
            }

            this.isLoading = true
            try {
                // El backend aplica recuperación pasiva automáticamente en este GET.
                // Si no existe, lo crea.
                this.energy = await energyApi.get(userId)
                this.lastSync = Date.now()
                console.log('[energy] Sincronizado para userId:', userId, '→', this.energy?.currentEnergy, '/', this.energy?.maxEnergy)
            } catch (err) {
                console.error('[energy] initializeEnergy:', err.message)
                // Fallback: energía por defecto para no romper la UI
                if (!this.energy) {
                    this.energy = { currentEnergy: 15, maxEnergy: 15, streakCount: 0, userId }
                }
            } finally {
                this.isLoading = false
            }
        },

        // Alias mantenido por compatibilidad con App.vue
        async syncFromLocalStorage(userId) {
            return this.initializeEnergy(userId)
        },

        // ── consumo ────────────────────────────────────────────────────────────

        async consumeForExercise(isCorrect) {
            const userId = this.energy?.userId
            if (!userId) {
                console.warn('[energy] consumeForExercise sin userId')
                return { newEnergy: 15, energyChange: 0, streak: 0 }
            }

            try {
                const result = await energyApi.consume(userId, isCorrect)
                this.energy.currentEnergy = result.newEnergy
                this.energy.streakCount = result.streak
                this.lastSync = Date.now()
                this._addChange(result.energyChange)
                return result
            } catch (err) {
                console.error('[energy] consumeForExercise:', err.message)
                return { newEnergy: this.energy?.currentEnergy ?? 15, energyChange: 0, streak: 0 }
            }
        },

        hasEnoughEnergy(required = 1) {
            return this.currentEnergy >= required
        },

        getRecoveryTime(energyNeeded = 1) {
            const minutes = energyNeeded * 20
            if (minutes < 60) return `${minutes} minutos`
            const h = Math.floor(minutes / 60)
            const m = minutes % 60
            return m > 0 ? `${h}h ${m}min` : `${h} horas`
        },

        // ── animaciones ────────────────────────────────────────────────────────

        _addChange(value) {
            const obj = { id: Date.now(), value, type: value > 0 ? 'gain' : 'loss' }
            this.energyChanges.push(obj)
            setTimeout(() => {
                this.energyChanges = this.energyChanges.filter(c => c.id !== obj.id)
            }, 2000)
        },

        clearEnergyChanges() {
            this.energyChanges = []
        },
    },

    persist: {
        key: 'energy-storage',
        paths: ['energy', 'lastSync'],
    },
})