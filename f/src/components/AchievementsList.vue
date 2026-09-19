<template>
    <div class="space-y-3">
        <h3 class="font-bold">Logros desbloqueados</h3>
        <div v-if="loading" class="text-center py-4">
            <div class="animate-spin rounded-full h-6 w-6 border-b-2 border-white mx-auto"></div>
        </div>

        <template v-else-if="achievements.length > 0">
            <Card v-for="item in achievements" :key="getAch(item).id"
                class="bg-gray-800 border-gray-700 transition-transform hover:scale-[1.02]">
                <div class="p-3">
                    <div class="flex items-center gap-3">
                        <div class="w-10 h-10 rounded-lg flex items-center justify-center text-xl"
                            :style="{ backgroundColor: getRarityColorSafe(item) + '20', color: getRarityColorSafe(item) }">
                            {{ getAch(item).icon }}
                        </div>
                        <div class="flex-1">
                            <h4 class="font-medium">{{ getAch(item).title }}</h4>
                            <p class="text-xs text-gray-400">{{ getAch(item).description }}</p>
                            <div class="flex items-center gap-2 mt-1">
                                <span class="text-xs text-green-400">+{{ getAch(item).xpReward }} XP</span>
                                <span class="text-xs text-gray-500" v-if="getDate(item)">
                                    {{ formatDate(getDate(item)) }}
                                </span>
                            </div>
                        </div>
                        <div class="text-xs text-gray-500" v-if="getAch(item).rarity !== 'common'">
                            <span class="px-2 py-1 rounded-full text-white"
                                :style="{ backgroundColor: getRarityColorSafe(item) }">
                                {{ getRarityText(getAch(item).rarity) }}
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

const props = defineProps({
    achievements: {
        type: Array,
        required: true,
        default: () => []
    },
    // Si true, cada item tiene forma { achievement, earnedAt }
    nested: {
        type: Boolean,
        default: false
    },
    loading: {
        type: Boolean,
        default: false
    }
});

const getAch = (item) => props.nested ? item.achievement : item;
const getDate = (item) => props.nested ? item.earnedAt : item.date;

const RARITY_COLORS = { common: '#58CC02', rare: '#1CB0F6', epic: '#A560E8', legendary: '#FF4B4B' };

const getRarityColorSafe = (item) => {
    const ach = getAch(item);
    if (typeof ach.getRarityColor === 'function') return ach.getRarityColor();
    return RARITY_COLORS[ach.rarity] || '#58CC02';
};

const formatDate = (dateString) => {
    if (!dateString) return '';
    try {
        // Parsear como fecha local para evitar desfase por zona horaria UTC
        const [year, month, day] = String(dateString).split('-').map(Number);
        return new Date(year, month - 1, day).toLocaleDateString('es-MX', { day: 'numeric', month: 'short', year: 'numeric' });
    } catch { return ''; }
};

const getRarityText = (rarity) =>
    ({ common: 'Común', rare: 'Raro', epic: 'Épico', legendary: 'Legendario' }[rarity] || rarity);
</script>