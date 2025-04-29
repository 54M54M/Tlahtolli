<template>
    <div class="space-y-3">
        <h3 class="font-bold">Logros desbloqueados</h3>
        <template v-if="achievements.length > 0">
            <Card v-for="achievement in achievements" :key="achievement.id" class="bg-gray-800 border-gray-700">
                <div class="p-3">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-lg bg-gray-700 flex items-center justify-center text-xl">
                            {{ achievement.icon }}
                        </div>
                        <div class="flex-1">
                            <h4 class="font-medium">{{ achievement.title }}</h4>
                            <p class="text-xs text-gray-400">{{ achievement.description }}</p>
                        </div>
                        <div class="text-xs text-gray-500">{{ achievement.date }}</div>
                    </div>
                </div>
            </Card>
        </template>
        <div v-else class="text-gray-400 text-sm">
            No has desbloqueado logros todavía.
        </div>
    </div>
</template>

<script setup>
import Card from './Card.vue';

defineProps({
    achievements: {
        type: Array,
        required: true,
        default: () => []
    }
});
</script>