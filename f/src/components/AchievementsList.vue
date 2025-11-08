<template>
    <div class="space-y-3">
        <h3 class="font-bold">Logros desbloqueados</h3>
        <template v-if="achievements.length > 0">
            <Card v-for="achievement in achievements" :key="achievement.id"
                class="bg-gray-800 border-gray-700 transition-transform hover:scale-[1.02]">
                <div class="p-3">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-lg flex items-center justify-center text-xl"
                            :style="{ backgroundColor: getRarityColorSafe(achievement) + '20', color: getRarityColorSafe(achievement) }">
                            {{ achievement.icon }}
                        </div>
                        <div class="flex-1">
                            <h4 class="font-medium">{{ achievement.title }}</h4>
                            <p class="text-xs text-gray-400">{{ achievement.description }}</p>
                            <div class="flex items-center gap-2 mt-1">
                                <span class="text-xs text-green-400">+{{ achievement.xpReward }} XP</span>
                                <span class="text-xs text-gray-500" v-if="achievement.date">
                                    {{ formatDate(achievement.date) }}
                                </span>
                            </div>
                        </div>
                        <div class="text-xs text-gray-500" v-if="achievement.rarity !== 'common'">
                            <span class="px-2 py-1 rounded-full text-white"
                                :style="{ backgroundColor: getRarityColorSafe(achievement) }">
                                {{ getRarityText(achievement.rarity) }}
                            </span>
                        </div>
                    </div>
                </div>
            </Card>
        </template>
        <div v-else class="text-gray-400 text-sm text-center py-4">
            <div class="text-4xl mb-2">🏆</div>
            <p>No has desbloqueado logros todavía.</p>
            <p class="text-xs mt-1">¡Completa lecciones para desbloquear logros!</p>
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

// Función segura para obtener color de rareza
const getRarityColorSafe = (achievement) => {
    if (typeof achievement.getRarityColor === 'function') {
        return achievement.getRarityColor();
    }

    // Fallback si no es una instancia de Achievement
    const colors = {
        "common": "#58CC02",
        "rare": "#1CB0F6",
        "epic": "#A560E8",
        "legendary": "#FF4B4B"
    };
    return colors[achievement.rarity] || "#58CC02";
};

const formatDate = (dateString) => {
    if (!dateString) return '';
    const date = new Date(dateString);
    return date.toLocaleDateString('es-ES', {
        day: 'numeric',
        month: 'short',
        year: 'numeric'
    });
};

const getRarityText = (rarity) => {
    const rarityMap = {
        'common': 'Común',
        'rare': 'Raro',
        'epic': 'Épico',
        'legendary': 'Legendario'
    };
    return rarityMap[rarity] || rarity;
};
</script>