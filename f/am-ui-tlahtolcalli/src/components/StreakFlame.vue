<template>
    <!-- Fuego de racha: el color depende de los días (src/data/streak.js) -->
    <svg :width="size" :height="size" viewBox="0 0 24 24" role="img" :aria-label="label"
        class="inline-block shrink-0 align-[-0.15em]" :style="tier.glow ? { filter: `drop-shadow(0 0 3px ${tier.outer})` } : null">
        <title>{{ label }}</title>
        <path :fill="tier.outer"
            d="M12 1.5c.6 3.2-1.4 5-3 7C7.4 10.4 5.5 12.7 5.5 15.6a6.5 6.5 0 0 0 13 0c0-2.4-1.1-4.4-2.5-6.1-.4 1.4-1.3 2.5-2.6 3 .5-3.5-.4-7.1-1.4-11z" />
        <path :fill="tier.inner"
            d="M12 22a3.6 3.6 0 0 1-3.6-3.6c0-1.7 1-3 2.3-4.2.2 1.1.8 1.8 1.7 2.1.1-1.5.6-2.7 1.4-3.8.9 1.4 1.9 2.9 1.9 5.1A3.6 3.6 0 0 1 12 22z" />
    </svg>
</template>

<script setup>
import { computed } from 'vue'
import { streakTier } from '../data/streak.js'

const props = defineProps({
    /** Días de racha */
    days: { type: Number, default: 0 },
    /** Tamaño en px (o cualquier medida CSS, p. ej. '1em') */
    size: { type: [Number, String], default: 16 },
})

const tier = computed(() => streakTier(props.days))
const label = computed(() => props.days > 0
    ? `${tier.value.name}: ${props.days} ${props.days === 1 ? 'día' : 'días'}`
    : 'Sin racha')
</script>
