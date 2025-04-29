<template>
    <Card class="bg-gray-800 rounded-lg p-4">
        <h3 class="font-bold mb-3">Estadísticas de aprendizaje</h3>
        <div class="grid grid-cols-2 gap-3">
            <Card v-for="stat in stats" :key="stat.label" class="bg-gray-700 rounded-lg p-3">
                <p class="text-gray-400 text-xs">{{ stat.label }}</p>
                <p class="text-xl font-bold">{{ stat.value }}</p>
            </Card>
        </div>
    </Card>
</template>

<script setup>
import Card from './Card.vue';

defineProps({
    stats: {
        type: Array,
        required: true
    }
});
</script>