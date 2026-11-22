// src/stores/energy.js
import { defineStore } from 'pinia'
import { energyApi, isOfflineError } from '../api/apiClient.js'
import { offline } from '../offline/status.js'
import { queueAnswer, hasPending, flushOutbox } from '../offline/outbox.js'

// Mismas reglas que EnergyService en el back (para calcularla sin conexión)
const RECOVERY_MS = 20 * 60 * 1000

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
                // Primero lo gastado sin conexión, para que el servidor lo descuente
                if (!offline.value && hasPending(userId)) await flushOutbox(userId)
                if (offline.value) throw Object.assign(new Error('Sin conexión'), { offline: true })
                // El backend aplica recuperación pasiva automáticamente en este GET.
                // Si no existe, lo crea.
                this.energy = await energyApi.get(userId)
                this.lastSync = Date.now()
                console.log('[energy] Sincronizado para userId:', userId, '→', this.energy?.currentEnergy, '/', this.energy?.maxEnergy)
            } catch (err) {
                if (!isOfflineError(err)) console.error('[energy] initializeEnergy:', err.message)
                // Fallback: energía por defecto para no romper la UI
                if (!this.energy || this.energy.userId !== userId) {
                    this.energy = { currentEnergy: 15, maxEnergy: 15, streakCount: 0, userId }
                    this.lastSync = Date.now()
                } else {
                    this._recoverLocally()
                }
            } finally {
                this.isLoading = false
            }
        },

        // Alias mantenido por compatibilidad con App.vue
        async syncFromLocalStorage(userId) {
            return this.initializeEnergy(userId)
        },

        /** Energía que respondió el servidor al enviar lo hecho sin conexión. */
        applyServer(energy) {
            if (!energy) return
            this.energy = { ...(this.energy || {}), ...energy }
            this.lastSync = Date.now()
        },

        // ── consumo ────────────────────────────────────────────────────────────

        async consumeForExercise(isCorrect) {
            const userId = this.energy?.userId
            if (!userId) {
                console.warn('[energy] consumeForExercise sin userId')
                return { newEnergy: 15, energyChange: 0, streak: 0 }
            }

            if (offline.value) return this._consumeOffline(userId, isCorrect)
            try {
                const result = await energyApi.consume(userId, isCorrect)
                this.energy.currentEnergy = result.newEnergy
                this.energy.streakCount = result.streak
                this.lastSync = Date.now()
                this._addChange(result.energyChange)
                return result
            } catch (err) {
                if (isOfflineError(err)) return this._consumeOffline(userId, isCorrect)
                console.error('[energy] consumeForExercise:', err.message)
                return { newEnergy: this.energy?.currentEnergy ?? 15, energyChange: 0, streak: 0 }
            }
        },

        /** Sin conexión: se calcula aquí con las mismas reglas y la respuesta se envía al reconectar. */
        _consumeOffline(userId, isCorrect) {
            this._recoverLocally()
            const e = this.energy
            let change = -1
            if (isCorrect) {
                change += Math.random() < 0.5 ? 1 : 2
                e.streakCount = (e.streakCount ?? 0) + 1
                if (e.streakCount >= 3) change += Math.random() < 0.5 ? 3 : 4
            } else {
                e.streakCount = 0
            }
            e.currentEnergy = Math.max(0, Math.min(e.maxEnergy ?? 15, (e.currentEnergy ?? 15) + change))
            queueAnswer(userId, isCorrect)
            this._addChange(change)
            return { newEnergy: e.currentEnergy, energyChange: change, streak: e.streakCount, maxEnergy: e.maxEnergy, offline: true }
        },

        /** Recuperación pasiva sin conexión: +1 cada 20 minutos desde la última vez. */
        _recoverLocally() {
            const e = this.energy
            if (!e || !this.lastSync) { this.lastSync = Date.now(); return }
            const max = e.maxEnergy ?? 15
            if ((e.currentEnergy ?? max) >= max) { this.lastSync = Date.now(); return }
            const recovered = Math.floor((Date.now() - this.lastSync) / RECOVERY_MS)
            if (recovered > 0) {
                e.currentEnergy = Math.min(max, e.currentEnergy + recovered)
                this.lastSync += recovered * RECOVERY_MS
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