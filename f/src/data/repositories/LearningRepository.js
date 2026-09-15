import { learningApi, progressApi } from '../../api/apiClient.js'
import { useAuthStore } from '../../stores/auth.js'

export class LearningRepository {

    async getLevels(languageId) {
        const auth = useAuthStore()
        const userId = auth.user?.id || 1
        return learningApi.getLevels(languageId, userId)
    }

    async getLevelsWithUnlockCheck(languageId) {
        return this.getLevels(languageId)
    }

    async getUnits(languageId, levelId) {
        const auth = useAuthStore()
        const userId = auth.user?.id || 1
        return learningApi.getUnits(levelId, userId)
    }

    async getUnit(languageId, levelId, unitId) {
        const units = await this.getUnits(languageId, levelId)
        return units.find(u => u.id === unitId) || null
    }

    async getExercisesForUnit(languageId, levelId, unitId) {
        return learningApi.getExercises(unitId)
    }

    async getNextUnit(languageId, levelId, unitId) {
        const units = await this.getUnits(languageId, levelId)
        const idx = units.findIndex(u => u.id === unitId)
        return idx !== -1 && idx < units.length - 1 ? units[idx + 1] : null
    }

    // no-ops: el backend maneja progreso y desbloqueos automáticamente
    async completeUnit() { return true }
    async unlockUnit() { return true }
    async unlockLevel() { return true }
}
