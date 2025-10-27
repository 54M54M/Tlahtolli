<template>
    <Card class="bg-gray-800 rounded-lg p-4 shadow-md">
        <h3 class="font-bold mb-3">Progreso por variante dialectal</h3>
        <div class="mb-3">
            <div class="flex justify-between text-sm mb-1">
                <span :style="`color: ${selectedDialectData.color}`">{{ selectedDialectData.name }}</span>
                <span class="text-gray-400">{{ selectedDialectData.progress }}%</span>
            </div>
            <ProgressBar :current="selectedDialectData.progress" :total="100" class="h-2 bg-gray-700"
                :color="selectedDialectData.color" />
        </div>
    </Card>
</template>

<script setup>
import { computed } from 'vue';
import { useAuthStore } from '../stores/auth';
import Card from './Card.vue';
import ProgressBar from './ProgressBar.vue';
import { dialectVariants } from '../lib/data.js';

const authStore = useAuthStore();

const props = defineProps({
    dialects: {
        type: Array,
        required: true
    }
});

// Combinar los datos de progreso con la información de la variante (incluyendo color)
const selectedDialectData = computed(() => {
    const selectedVariant = authStore.selectedVariant;

    // Encontrar la variante en dialectVariants para obtener el color
    const variantInfo = dialectVariants.find(v => v.id === selectedVariant) || dialectVariants[0];

    // Encontrar el progreso en los props.dialects
    const progressInfo = props.dialects.find(dialect => dialect.id === selectedVariant) || props.dialects[0];

    return {
        id: variantInfo.id,
        name: variantInfo.name,
        color: variantInfo.color,
        progress: progressInfo.progress
    };
});
</script>