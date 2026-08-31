<template>
    <img :src="image" class="mx-auto mb-4 h-64 object-contain" />
</template>

<script setup>
import { computed } from 'vue';
import tochN1 from '../assets/exercises/toch/toch_n1.webp';
import tochCelebracion from '../assets/exercises/toch/toch_celebracion.webp';
import tochMencanto from '../assets/exercises/toch/toch_mencanto.webp';
import tochMirentodos from '../assets/exercises/toch/toch_mirentodos.webp';
import tochWow from '../assets/exercises/toch/toch_wow.webp';

const regularImages = [tochCelebracion, tochMencanto, tochMirentodos, tochWow];

const props = defineProps({
    performance: { type: Number, required: true },
    lessonTime: { type: Number, required: true }
});

const image = computed(() =>
    props.performance === 1 && props.lessonTime < 30
        ? tochN1
        : regularImages[Math.floor(Math.random() * regularImages.length)]
);
</script>
