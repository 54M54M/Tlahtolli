<template>
    <div class="mx-auto">
        <!-- Mostrar palabras aprendidas en unidades completadas -->
        <div v-if="completedUnits.length > 0">
            <div v-for="unit in completedUnits" :key="unit.id" class="p-[6px]">


                <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                    <div v-for="word in unit.vocabulary" :key="word.word"
                        class="bg-gray-800 p-3 rounded border border-gray-700 hover:border-gray-600 transition-colors">
                        <div class="flex justify-between items-start">
                            <div class="flex-1">
                                <p class="font-medium text-white mb-1">{{ word.word }}</p>
                                <p class="text-sm text-gray-400 mb-2">{{ word.translation }}</p>
                                <p v-if="word.pronunciation" class="text-xs text-gray-500 font-mono">
                                    /{{ word.pronunciation }}/
                                </p>
                            </div>
                            <!-- <button @click="speakWord(word.word)"
                                class="text-blue-400 hover:text-blue-300 transition-colors ml-2 flex-shrink-0">
                                <Volume2 class="h-4 w-4" />
                            </button> -->
                        </div>
                        <p v-if="word.example" class="text-xs text-gray-400 mt-2 italic">
                            "{{ word.example }}"
                        </p>
                    </div>
                </div>
            </div>
        </div>

        <div v-else class="text-center py-8">
            <BookOpen class="h-12 w-12 text-gray-600 mx-auto mb-4" />
            <p class="text-gray-400 mb-2">Aún no has completado ninguna unidad</p>
            <p class="text-sm text-gray-500">Completa lecciones para ver tus palabras aprendidas aquí.</p>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue';

import { BookOpen, Volume2 } from 'lucide-vue-next';

import { LearningRepository } from '../../data/repositories/LearningRepository.js';
import { ProgressService } from '../../data/services/ProgressService.js';
import Badge from '../../components/Badge.vue';

const props = defineProps({
    language: String,
    currentLanguageName: String,
    currentLanguageColor: String
});

const learningRepo = new LearningRepository();
const progressService = new ProgressService();

// Obtener todas las unidades completadas
const completedUnits = computed(() => {
    const allUnits = [];

    // Obtener unidades completadas de todos los niveles
    const levels = learningRepo.getLevels(props.language);
    levels.forEach(level => {
        const units = learningRepo.getUnits(props.language, level.id);
        const completedLevelUnits = units.filter(unit => unit.completed);
        allUnits.push(...completedLevelUnits);
    });

    return allUnits;
});

// Estadísticas
const completedUnitsCount = computed(() => completedUnits.value.length);
const totalWordsCount = computed(() => {
    return completedUnits.value.reduce((total, unit) => total + unit.vocabulary.length, 0);
});
const completedLevelsCount = computed(() => {
    const levels = learningRepo.getLevels(props.language);
    return levels.filter(level => level.isCompleted()).length;
});
const progressPercentage = computed(() => {
    const levels = learningRepo.getLevels(props.language);
    const totalUnits = levels.reduce((total, level) => total + level.units, 0);
    const completedUnits = levels.reduce((total, level) => total + level.completedUnits, 0);
    return totalUnits > 0 ? Math.round((completedUnits / totalUnits) * 100) : 0;
});
const hasCompletedLevel1 = computed(() => {
    const level1 = learningRepo.getLevel(props.language, 1);
    return level1?.isCompleted() || false;
});

const speakWord = (word) => {
    if ('speechSynthesis' in window) {
        speechSynthesis.cancel();
        const utterance = new SpeechSynthesisUtterance(word);
        utterance.lang = 'es-MX';
        utterance.rate = 0.9;
        speechSynthesis.speak(utterance);
    }
};
</script>