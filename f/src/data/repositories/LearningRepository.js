// src/data/repositories/LearningRepository.js
// Reemplaza la versión que operaba sobre datos hardcodeados en memoria.
// Ahora todas las operaciones van a la API del backend.

import { learningApi, progressApi } from '../../api/apiClient.js'
import { useAuthStore } from '../../stores/auth.js'

export class LearningRepository {

    // ── Niveles ──────────────────────────────────────────────────────────────

    async getLevels(languageId) {
        const auth = useAuthStore()
        const userId = auth.user?.id || 1
        return learningApi.getLevels(languageId, userId)
    }

    // Alias usado en HomeView con chequeo de desbloqueo
    async getLevelsWithUnlockCheck(languageId) {
        return this.getLevels(languageId)
    }

    // ── Unidades ──────────────────────────────────────────────────────────────

    async getUnits(languageId, levelId) {
        const auth = useAuthStore()
        const userId = auth.user?.id || 1
        return learningApi.getUnits(levelId, userId)
    }

    async getUnit(languageId, levelId, unitId) {
        const units = await this.getUnits(languageId, levelId)
        return units.find(u => u.id === unitId) || null
    }

    // ── Ejercicios ────────────────────────────────────────────────────────────

    async getExercisesForUnit(languageId, levelId, unitId) {
        return learningApi.getExercises(unitId)
    }

    // ── Acciones de progreso ──────────────────────────────────────────────────

    // LessonView y QuickLevelView llaman esto tras completar
    async completeUnit(languageId, levelId, unitId) {
        // El progreso se actualiza desde ProgressService vía /user-progress/complete
        // Este método queda como no-op aquí; la actualización real la hace completeLesson()
        return true
    }

    async unlockUnit(languageId, levelId, unitId) {
        // El backend lo maneja automáticamente en completeLesson()
        return true
    }

    async unlockLevel(languageId, levelId) {
        // El backend lo maneja automáticamente
        return true
    }

    async getNextUnit(languageId, levelId, unitId) {
        const units = await this.getUnits(languageId, levelId)
        const idx = units.findIndex(u => u.id === unitId)
        return idx !== -1 && idx < units.length - 1 ? units[idx + 1] : null
    }

    getLevel(languageId, levelId) {
        // Versión sync — devuelve null, las vistas deben usar getLevels() async
        // Se mantiene por compatibilidad con código legado
        return null
    }

    getLevels(languageId) {
        // Versión sync — devuelve [] para compatibilidad; las vistas deben usar await
        return []
    }

    getCompletedUnits(languageId) {
        return []
    }
}