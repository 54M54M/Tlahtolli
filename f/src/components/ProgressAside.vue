<template>
    <aside class="md:w-[380px] bg-[#0A2136] text-white p-4 fixed right-0 top-0 h-full overflow-hidden flex flex-col">
        <div class="flex-1 overflow-y-auto scrollbar-hide md:mt-[-53px]">
            <div class="h-12"></div>

            <!-- Loading -->
            <div v-if="!isLanguageReady" class="mb-4 p-4 bg-gray-800 rounded-lg shadow-md">
                <div class="animate-pulse">
                    <div class="h-4 bg-gray-700 rounded w-1/2 mb-3"></div>
                    <div class="flex items-center gap-3 p-2">
                        <div class="w-8 h-8 rounded-full bg-gray-700"></div>
                        <div class="flex-1">
                            <div class="h-4 bg-gray-700 rounded w-3/4 mb-2"></div>
                            <div class="h-3 bg-gray-700 rounded w-1/2"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Badge de idioma -->
            <div v-else class="mb-4 p-4 bg-gray-800 rounded-lg shadow-md">
                <div class="flex items-center justify-between mb-3">
                    <div class="flex items-center gap-2">
                        <div class="w-3 h-3 rounded-full" :style="{ backgroundColor: selectedLanguageData.color }">
                        </div>
                        <span class="text-sm font-semibold">Idioma activo</span>
                    </div>
                </div>
                <div class="flex items-center gap-3 p-2 rounded"
                    :style="{ backgroundColor: selectedLanguageData.color + '20' }">
                    <div class="w-8 h-8 rounded-full flex items-center justify-center text-white font-bold text-sm"
                        :style="{ backgroundColor: selectedLanguageData.color }">
                        {{ selectedLanguageData.flag }}
                    </div>
                    <div>
                        <p class="font-semibold text-sm" :style="{ color: selectedLanguageData.color }">
                            {{ selectedLanguageData.name }}
                        </p>
                        <p class="text-xs text-gray-300">{{ selectedLanguageData.nativeName }}</p>
                    </div>
                </div>
            </div>

            <!-- Estadísticas -->
            <div class="md:pt-[1px] rounded-lg">
                <LearningStats :stats="stats" />
                <br class="md:hidden">
                <DialectProgress class="md:mt-4 -mt-1" :dialects="languageProgress" />
            </div>

            <div class="h-4"></div>
        </div>
    </aside>
</template>

<script>
import { computed, ref, onMounted, watch } from 'vue'
import { useAuthStore } from '../stores/auth.js'
import { statsApi } from '../api/apiClient.js'
import { LanguageService } from '../data/services/LanguageService.js'
import LearningStats from './LearningStats.vue'
import DialectProgress from './DialectProgress.vue'

export default {
    name: 'ProgressAside',
    components: { LearningStats, DialectProgress },
    setup() {
        const authStore = useAuthStore()
        const languageService = new LanguageService()
        const rawStats = ref(null)

        const isLanguageReady = computed(() =>
            authStore.isLanguageReady && !!authStore.selectedLanguage)

        const selectedLanguageData = computed(() => {
            if (!authStore.selectedLanguage) {
                return { color: '#666', name: 'Selecciona un idioma', nativeName: '', flag: '🌐' }
            }

            // 1. Objeto completo guardado en el store al momento de seleccionar (viene de la BD)
            const langObj = authStore.selectedLangObj
            if (langObj) {
                return {
                    color: langObj.color || '#666',
                    name: langObj.name || langObj.code || authStore.selectedLanguage,
                    nativeName: langObj.nativeName || langObj.native_name || '',
                    flag: langObj.icon || langObj.emoji || langObj.flag || '🌐',
                }
            }

            // 2. Fallback al servicio local (datos estáticos) para sesiones previas al cambio
            return languageService.getLanguageInfo(authStore.selectedLanguage) ||
                { color: '#666', name: 'Idioma no encontrado', nativeName: '', flag: '❓' }
        })

        const stats = computed(() => {
            const s = rawStats.value
            return [
                { label: 'Palabras aprendidas', value: s?.wordsLearned || 0 },
                { label: 'Lecciones completadas', value: s?.lessonsDone || 0 },
                { label: 'Lecciones perfectas', value: s?.perfectLess || 0 },
                { label: 'Días estudiados', value: s?.daysStudied || 0 },
            ]
        })

        const languageProgress = computed(() => {
            const lang = selectedLanguageData.value
            const done = rawStats.value?.lessonsDone || 0
            return [{
                id: authStore.selectedLanguage,
                name: lang.name,
                progress: Math.min(100, (done / 36) * 100),
                color: lang.color,
            }]
        })

        const loadStats = async () => {
            if (!authStore.user || !authStore.selectedLangId) return
            try {
                const results = await statsApi.getByUserLang(
                    authStore.user.id,
                    authStore.selectedLangId
                )
                rawStats.value = results
            } catch (err) {
                console.warn('[ProgressAside] loadStats:', err.message)
            }
        }

        onMounted(loadStats)
        watch(() => authStore.selectedLangId, loadStats)

        return {
            isLanguageReady, selectedLanguageData, stats, languageProgress,
        }
    },
}
</script>

<style scoped>
.scrollbar-hide::-webkit-scrollbar {
    display: none;
}

.scrollbar-hide {
    -ms-overflow-style: none;
    scrollbar-width: none;
}
</style>