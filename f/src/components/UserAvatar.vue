<template>
    <img :src="src" :alt="alt" :width="size" :height="size" draggable="false"
        class="shrink-0 rounded-full select-none" :style="{ width: `${size}px`, height: `${size}px` }" />
</template>

<script setup>
// Avatar del usuario generado con Blobatar (https://blobatar.dev).
// Es determinista: el mismo nombre de usuario siempre da el mismo avatar, así
// que no se guarda ninguna imagen ni se llama a ningún servidor.
import { computed } from 'vue'
import { blobatarUri } from 'blobatar/uri'

/** Semilla del avatar por defecto, mientras todavía no hay usuario (registro vacío). */
const DEFAULT_SEED = 'tlahtolcalli'

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

const name = computed(() => (props.name || '').trim())
const seed = computed(() => name.value || DEFAULT_SEED)

const backdrop = computed(() =>
    ['circle', 'squircle', 'square'].includes(props.background) ? props.background : false)

const src = computed(() => blobatarUri(seed.value, { background: backdrop.value }))

const alt = computed(() => (name.value ? `Avatar de ${name.value}` : 'Avatar'))
</script>
