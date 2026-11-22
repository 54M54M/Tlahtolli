<template>
    <img :src="image" class="mx-auto mb-4 h-64 object-contain" />
</template>

<script setup>
import { computed } from 'vue';
import toch1 from '../assets/exercises/toch/1.webp';
import toch2 from '../assets/exercises/toch/2.webp';
import toch3 from '../assets/exercises/toch/3.webp';
import toch4 from '../assets/exercises/toch/4.webp';
import toch5 from '../assets/exercises/toch/5.webp';
import toch6 from '../assets/exercises/toch/6.webp';
import toch7 from '../assets/exercises/toch/7.webp';
import toch8 from '../assets/exercises/toch/8.webp';
import toch9 from '../assets/exercises/toch/9.webp';

const regularImages = [toch1, toch2, toch3, toch4, toch5, toch6, toch7, toch8];

const props = defineProps({
    performance: { type: Number, required: true },
    lessonTime: { type: Number, required: true }
});

const image = computed(() =>
    props.performance === 1 && props.lessonTime < 30
        ? toch9
        : regularImages[Math.floor(Math.random() * regularImages.length)]
);
</script>
