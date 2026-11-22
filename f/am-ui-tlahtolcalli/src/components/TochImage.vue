<template>
    <img :src="image" alt="Toch" class="mx-auto mb-4 h-64 object-contain" />
</template>

<script setup>
// Las imágenes salen solas de src/assets/exercises/toch/ (ver src/data/toch.js)
import { computed } from 'vue';
import { toch, tochRandom, TOCH_PREMIO } from '../data/toch.js';

const props = defineProps({
    performance: { type: Number, required: true },
    lessonTime: { type: Number, required: true }
});

// Lección perfecta en menos de 30 s → premio; si no, una al azar
const image = computed(() =>
    props.performance === 1 && props.lessonTime < 30 ? toch(TOCH_PREMIO) : tochRandom()
);
</script>
