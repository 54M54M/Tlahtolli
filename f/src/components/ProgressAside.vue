<template>
    <aside class="md:w-[380px] bg-[#0A2136] text-white p-4 fixed right-0 top-0 h-full overflow-hidden flex flex-col">
        <!-- Contenedor con scroll (sin barra visible) -->
        <div class="flex-1 overflow-y-auto scrollbar-hide pr-2 md:mt-[-53px]">
            <!-- Espacio para el header fijo -->
            <div class="h-12"></div>

            <!-- Loading state -->
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

            <!-- Estadísticas de aprendizaje -->
            <div class="md:pt-[1px] rounded-lg">
                <LearningStats :stats="stats" />
                <br class="md:hidden">
                <DialectProgress class="md:mt-4 -mt-1" :dialects="languageProgress" />
            </div>

            <!-- Espacio extra al final para mejor scroll -->
            <div class="h-4"></div>
        </div>
    </aside>
</template>

<script>
import { computed } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '../stores/auth';
import LearningStats from './LearningStats.vue';
import DialectProgress from './DialectProgress.vue';
import { LanguageService } from '../data/services/LanguageService.js';
import { StatsRepository } from '../data/repositories/StatsRepository.js';
import { LocalStorageService } from '../data/storage/LocalStorageService.js'; // CORREGIR IMPORT

export default {
    name: 'ProgressAside',
    components: {
        LearningStats,
        DialectProgress
    },
    setup() {
        const router = useRouter();
        const authStore = useAuthStore();
        const languageService = new LanguageService();
        const statsRepo = new StatsRepository();

        const isLanguageReady = computed(() => {
            return authStore.isLanguageReady && authStore.selectedLanguage
        });

        const selectedLanguageData = computed(() => {
            if (!isLanguageReady.value || !authStore.selectedLanguage) {
                return {
                    color: '#666',
                    name: 'Selecciona un idioma',
                    nativeName: '',
                    flag: '🌐'
                }
            }

            const langInfo = languageService.getLanguageInfo(authStore.selectedLanguage);

            return langInfo || {
                color: '#666',
                name: 'Idioma no encontrado',
                nativeName: '',
                flag: '❓'
            };
        });

        const goToLanguageSelection = () => {
            router.push('/select-language');
        };

        const stats = computed(() => {
            const userStats = statsRepo.getUserStats(1);

            return [
                {
                    label: 'Palabras aprendidas',
                    value: userStats.wordsLearned || 0
                },
                {
                    label: 'Lecciones completadas',
                    value: userStats.lessonsCompleted || 0
                },
                {
                    label: 'Lecciones perfectas',
                    value: userStats.perfectLessons || 0
                },
                {
                    label: 'Días estudiados',
                    value: userStats.daysStudied || 0
                }
            ];
        });

        const languageProgress = computed(() => {
            const selectedLanguage = authStore.selectedLanguage;

            if (!selectedLanguage) {
                return [{
                    id: 'none',
                    name: 'Sin idioma seleccionado',
                    progress: 0,
                    color: '#666'
                }];
            }

            const languageInfo = languageService.getLanguageInfo(selectedLanguage);

            // USAR LocalStorageService DIRECTAMENTE
            const progress = LocalStorageService.getProgress(selectedLanguage);
            const progressPercentage = progress.totalUnits > 0 ?
                (progress.completedUnits / progress.totalUnits) * 100 : 0;

            return [
                {
                    id: selectedLanguage,
                    name: languageInfo?.name || 'Idioma actual',
                    progress: progressPercentage,
                    color: languageInfo?.color || '#666'
                }
            ];
        });

        return {
            stats,
            languageProgress,
            selectedLanguageData,
            goToLanguageSelection,
            isLanguageReady
        };
    }
}
</script>

<style scoped>
/* Ocultar scrollbar para Chrome, Safari y Opera */
.scrollbar-hide::-webkit-scrollbar {
    display: none;
}

/* Ocultar scrollbar para IE, Edge y Firefox */
.scrollbar-hide {
    -ms-overflow-style: none;
    /* IE and Edge */
    scrollbar-width: none;
    /* Firefox */
}
</style>