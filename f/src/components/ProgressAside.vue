<template>
    <aside
        class="hidden md:block md:w-[380px] bg-[#0A2136] text-white p-4 border-l border-gray-800 fixed right-0 top-0 h-full">
        <!-- Badge de variante y botón cambiar -->
        <div class="mt-12 mb-4 p-4 bg-gray-800 rounded-lg">
            <div class="flex items-center justify-between mb-3">
                <div class="flex items-center gap-2">
                    <div class="w-3 h-3 rounded-full" :style="{ backgroundColor: selectedVariantData.color }"></div>
                    <span class="text-sm font-semibold">Variante activa</span>
                </div>
                <!-- <button @click="goToVariantSelection"
                    class="text-xs px-2 py-1 rounded border border-gray-400 hover:bg-gray-700 transition-colors">
                    Cambiar
                </button> -->
            </div>
            <div class="flex items-center gap-3 p-2 rounded"
                :style="{ backgroundColor: selectedVariantData.color + '20' }">
                <div class="w-8 h-8 rounded-full flex items-center justify-center text-white font-bold text-sm"
                    :style="{ backgroundColor: selectedVariantData.color }">
                    {{ selectedVariantInitial }}
                </div>
                <div>
                    <p class="font-semibold text-sm" :style="{ color: selectedVariantData.color }">
                        {{ selectedVariantData.name }}
                    </p>
                    <p class="text-xs text-gray-300">{{ selectedVariantData.regions }}</p>
                </div>
            </div>
        </div>

        <!-- Estadísticas de aprendizaje -->
        <div class="p-4 bg-gray-800 rounded-lg">
            <LearningStats :stats="stats" />
            <DialectProgress :dialects="dialectProgress" />
        </div>
    </aside>
</template>

<script>
import { computed } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '../stores/auth';
import LearningStats from './LearningStats.vue';
import DialectProgress from './DialectProgress.vue';
import { statsData, dialectVariants } from '../lib/data.js';

export default {
    name: 'ProgressAside',
    components: {
        LearningStats,
        DialectProgress
    },
    setup() {
        const router = useRouter();
        const authStore = useAuthStore();

        const selectedVariantData = computed(() => {
            return dialectVariants.find(v => v.id === authStore.selectedVariant) || dialectVariants[3]; // 'all' por defecto
        });

        const selectedVariantInitial = computed(() => {
            return selectedVariantData.value.name.charAt(0);
        });

        const goToVariantSelection = () => {
            router.push('/select-variant');
        };

        const stats = computed(() => [
            { label: 'Palabras aprendidas', value: statsData.wordsLearned },
            { label: 'Lecciones completadas', value: statsData.lessonsCompleted },
            { label: 'Lecciones perfectas', value: statsData.perfectLessons },
            { label: 'Días estudiados', value: statsData.daysStudied }
        ]);

        const dialectProgress = computed(() => [
            { id: 'central', name: 'Central', progress: statsData.dialectProgress.central, color: '#F0983E' },
            { id: 'oriental', name: 'Oriental', progress: statsData.dialectProgress.oriental, color: '#CF3E81' },
            { id: 'occidental', name: 'Occidental', progress: statsData.dialectProgress.occidental, color: '#5DC7A4' }
        ]);

        return {
            stats,
            dialectProgress,
            selectedVariantData,
            selectedVariantInitial,
            goToVariantSelection
        };
    }
}
</script>