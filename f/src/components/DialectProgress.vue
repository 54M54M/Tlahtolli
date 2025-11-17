<template>
    <Card class="bg-gray-800 rounded-lg p-4 shadow-md">
        <h3 class="font-bold mb-3">Progreso del idioma</h3>
        <div class="mb-3">
            <div class="flex justify-between text-sm mb-1">
                <span :style="`color: ${selectedLanguageData.color}`">{{ selectedLanguageData.name }}</span>
                <span class="text-gray-400">{{ selectedLanguageData.progress }}%</span>
            </div>
            <ProgressBar :current="selectedLanguageData.progress" :total="100" class="h-2 bg-gray-700"
                :color="selectedLanguageData.color" />
        </div>
    </Card>
</template>

<script setup>
import { computed } from 'vue';
import { useAuthStore } from '../stores/auth';
import Card from './Card.vue';
import ProgressBar from './ProgressBar.vue';
import { LanguageService } from '../data/services/LanguageService.js';
import { getStatsRepository } from '../data/repositories/RepositoryFactory.js';

const authStore = useAuthStore();
const languageService = new LanguageService();
const statsRepo = getStatsRepository();

const props = defineProps({
    dialects: {
        type: Array,
        required: true
    }
});

// Combinar los datos de progreso con la información del idioma
const selectedLanguageData = computed(() => {
    const selectedLanguage = authStore.selectedLanguage;

    if (!selectedLanguage) {
        return {
            id: 'none',
            name: 'Selecciona un idioma',
            color: '#666',
            progress: 0
        };
    }

    // Encontrar el idioma en LanguageService para obtener la información
    const languageInfo = languageService.getLanguageInfo(selectedLanguage);

    // Encontrar el progreso en los props.dialects
    const progressInfo = props.dialects.find(dialect => dialect.id === selectedLanguage) || props.dialects[0];

    // Limitar el progreso a máximo 2 decimales
    const progress = progressInfo?.progress || 0;
    const formattedProgress = typeof progress === 'number' ? Number(progress.toFixed(2)) : 0;

    return {
        id: languageInfo?.id || selectedLanguage,
        name: languageInfo?.name || 'Idioma actual',
        color: languageInfo?.color || '#666',
        progress: formattedProgress
    };
});
</script>