<template>
    <aside class="md:w-[380px] bg-[#0A2136] text-white p-4 fixed right-0 top-0 h-full overflow-hidden flex flex-col">
        <!-- Contenedor con scroll (sin barra visible) -->
        <div class="flex-1 overflow-y-auto scrollbar-hide pr-2 md:mt-[-53px]">
            <!-- Espacio para el header fijo -->
            <div class="h-12"></div>

            <!-- Loading state -->
            <div v-if="!isVariantReady" class="mb-4 p-4 bg-gray-800 rounded-lg shadow-md">
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

            <!-- Badge de variante y botón cambiar -->
            <div v-else class="mb-4 p-4 bg-gray-800 rounded-lg shadow-md">
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
            <div class="md:pt-[1px] rounded-lg">
                <LearningStats :stats="stats" />
                <br class="md:hidden">
                <DialectProgress class="mt-5" :dialects="dialectProgress" />
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

        const isVariantReady = computed(() => {
            return authStore.isVariantReady && authStore.selectedVariant
        });

        const selectedVariantData = computed(() => {
            if (!isVariantReady.value) {
                return { color: '#666', name: 'Cargando...', regions: '' }
            }
            return dialectVariants.find(v => v.id === authStore.selectedVariant) || dialectVariants[0]; // Primera variante por defecto
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

        const dialectProgress = computed(() => {
            const selectedVariant = authStore.selectedVariant;
            const variantInfo = dialectVariants.find(v => v.id === selectedVariant) || dialectVariants[0];

            return [
                {
                    id: selectedVariant,
                    name: variantInfo.name,
                    progress: statsData.dialectProgress[selectedVariant] || 0,
                    color: variantInfo.color
                }
            ];
        });

        return {
            stats,
            dialectProgress,
            selectedVariantData,
            selectedVariantInitial,
            goToVariantSelection,
            isVariantReady
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