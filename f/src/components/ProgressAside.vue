<template>
    <aside
        class="hidden md:block md:w-[380px] bg-[#0A2136] text-white p-4 border-l border-gray-800 fixed right-0 top-0 h-full">
        <div class="mt-12 p-4 bg-gray-800 rounded-lg">
            <LearningStats :stats="stats" />
            <DialectProgress :dialects="dialectProgress" />
        </div>
    </aside>
</template>

<script>
import { computed } from 'vue';
import LearningStats from './LearningStats.vue';
import DialectProgress from './DialectProgress.vue';
import { statsData } from '../lib/data.js';

export default {
    name: 'ProgressAside',
    components: {
        LearningStats,
        DialectProgress
    },
    setup() {
        const stats = computed(() => [
            { label: 'Palabras aprendidas', value: statsData.wordsLearned },
            { label: 'Lecciones completadas', value: statsData.lessonsCompleted },
            { label: 'Lecciones perfectas', value: statsData.perfectLessons },
            { label: 'Días estudiados', value: statsData.daysStudied }
        ]);

        const dialectProgress = computed(() => [
            { id: 'central', name: 'Central', progress: statsData.dialectProgress.central, color: '#58CC02' },
            { id: 'oriental', name: 'Oriental', progress: statsData.dialectProgress.oriental, color: '#FFA500' },
            { id: 'occidental', name: 'Occidental', progress: statsData.dialectProgress.occidental, color: '#FF4B4B' }
        ]);

        return {
            stats,
            dialectProgress
        };
    }
}
</script>