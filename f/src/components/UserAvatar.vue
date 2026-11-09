<template>
    <img v-if="src" :src="src" :alt="alt" :width="size" :height="size" draggable="false"
        class="shrink-0 rounded-full select-none" :style="{ width: `${size}px`, height: `${size}px` }" />
    <!-- Sin nombre todavía (registro vacío): círculo vacío del mismo tamaño -->
    <div v-else aria-hidden="true" class="shrink-0 rounded-full border-2 border-dashed border-line bg-surface-2"
        :style="{ width: `${size}px`, height: `${size}px` }"></div>
</template>

<script setup>
// Avatar del usuario generado con Blobatar (https://blobatar.dev).
// Es determinista: el mismo nombre de usuario siempre da el mismo avatar, así
// que no se guarda ninguna imagen ni se llama a ningún servidor.
import { computed } from 'vue'
import { blobatarUri } from 'blobatar/uri'

const props = defineProps({
    /** Nombre de usuario del que sale el avatar. */
    name: { type: String, default: '' },
    /** Tamaño en px. */
    size: { type: Number, default: 40 },
    /**
     * Fondo detrás del avatar: 'circle', 'squircle' o 'square'.
     * Por defecto es transparente. Acepta false, 'false' o 'none' como transparente
     * (background="false" sin dos puntos llega como texto, no como booleano).
     */
    background: { type: [String, Boolean], default: false },
})

const seed = computed(() => (props.name || '').trim())

const backdrop = computed(() =>
    ['circle', 'squircle', 'square'].includes(props.background) ? props.background : false)

const src = computed(() =>
    seed.value ? blobatarUri(seed.value, { background: backdrop.value }) : '')

const alt = computed(() => (seed.value ? `Avatar de ${seed.value}` : ''))
</script>
