<template>
    <Card class="bg-gray-800 rounded-lg p-4">
        <h3 class="font-bold mb-3">Estadísticas de aprendizaje</h3>
        <div class="grid grid-cols-2 gap-3">
            <Card v-for="stat in stats" :key="stat.label" class="bg-gray-700 rounded-lg p-3">
                <div class="flex items-center justify-center space-x-1">
                    <p class="text-xl font-bold text-center"
                        :class="getNumberColor(stat.label, getStatValue(stat.value))">
                        {{ getStatValue(stat.value) }}
                    </p>
                    <span v-if="showStreakEmoji(stat.label, getStatValue(stat.value))" class="text-[14px]">
                        {{ getStreakEmoji(stat.label, getStatValue(stat.value)) }}
                    </span>
                </div>
                <p class="text-gray-400 text-[10px] text-center">{{ stat.label }}</p>
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

const getStatValue = (value) => {
    if (Array.isArray(value)) {
        return value[0]; // Toma el primer elemento del array
    }
    return value; // Si ya es un valor simple, lo devuelve tal cual
};

const getStatColor = (label) => {
    const colorMap = {
        'Lecciones perfectas': 'text-[#ffb900]',
        'Días estudiados': 'text-orange-400',
    };
    return colorMap[label] || 'text-white';
};

const getNumberColor = (label, value) => {
    const numericValue = Number(value); // Asegura que sea número
    const streakLabels = ['Lecciones perfectas', 'Días estudiados'];

    if (!streakLabels.includes(label)) {
        return getStatColor(label);
    }

    if (numericValue === 1) {
        return 'text-white';
    } else if (numericValue === 2) {
        return getStatColor(label);
    } else if (numericValue >= 3) {
        return getStatColor(label);
    }

    return 'text-white';
};

const showStreakEmoji = (label, value) => {
    const numericValue = Number(value);
    const streakLabels = ['Lecciones perfectas', 'Días estudiados'];
    return streakLabels.includes(label) && numericValue >= 3;
};

const getStreakEmoji = (label, value) => {
    if (!showStreakEmoji(label, value)) return '';

    const emojis = {
        'Lecciones perfectas': '🏆',
        'Días estudiados': '🔥'
    };

    return emojis[label] || '🔥';
};
</script>