<template>
    <Card class="bg-gray-800 rounded-lg p-4">
        <h3 class="font-bold mb-3">Progreso por variante dialectal</h3>
        <div v-for="dialect in dialects" :key="dialect.id" class="mb-3">
            <div class="flex justify-between text-sm mb-1">
                <span :style="`color: ${dialect.color}`">{{ dialect.name }}</span>
                <span class="text-gray-400">{{ dialect.progress }}%</span>
            </div>
            <ProgressBar :current="dialect.progress" :total="100" class="h-2 bg-gray-700" :color="dialect.color" />
        </div>
    </Card>
</template>

<script setup>
import Card from './Card.vue';
import ProgressBar from './ProgressBar.vue';

defineProps({
    dialects: {
        type: Array,
        required: true
    }
});
</script>