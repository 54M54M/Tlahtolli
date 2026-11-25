<template>
    <!-- Armar frase con fichas: toca una ficha para subirla a la respuesta,
         tócala en la respuesta para regresarla. En el banco queda el hueco para no perder el lugar. -->
    <div class="w-full select-none">
        <!-- Respuesta -->
        <div class="min-h-[72px] md:min-h-[64px] border-b-2 border-line pb-2 mb-2 flex flex-wrap gap-2 content-start"
            :class="stateClass" aria-label="Tu respuesta" role="list">
            <button v-for="idx in modelValue" :key="`a-${idx}`" type="button" role="listitem"
                class="tl-choice tile" :class="answerTileClass" :disabled="disabled" @click="remove(idx)">
                {{ tiles[idx] }}
            </button>
            <span v-if="!modelValue.length" class="text-gray-500 text-sm self-center">
                Toca las palabras en orden
            </span>
        </div>
        <div class="border-b-2 border-line mb-5"></div>

        <!-- Banco -->
        <div class="flex flex-wrap gap-2 justify-center" aria-label="Palabras disponibles" role="list">
            <template v-for="(tile, idx) in tiles" :key="`b-${idx}`">
                <span v-if="modelValue.includes(idx)" class="tl-choice tile is-placeholder" aria-hidden="true">{{ tile }}</span>
                <button v-else type="button" role="listitem" class="tl-choice tile"
                    :disabled="disabled" @click="add(idx)">
                    {{ tile }}
                </button>
            </template>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
    /** Fichas (pueden repetirse; se identifican por posición) */
    tiles: { type: Array, required: true },
    /** Índices de las fichas elegidas, en orden */
    modelValue: { type: Array, default: () => [] },
    disabled: { type: Boolean, default: false },
    /** null | 'correct' | 'wrong' */
    state: { type: String, default: null },
})
const emit = defineEmits(['update:modelValue'])

const stateClass = computed(() => '')
// Al verificar, las fichas de la respuesta se pintan de verde o rojo
const answerTileClass = computed(() => props.state === 'correct'
    ? 'is-correct'
    : props.state === 'wrong' ? 'is-wrong' : '')

function add(idx) {
    if (props.disabled || props.modelValue.includes(idx)) return
    emit('update:modelValue', [...props.modelValue, idx])
}
function remove(idx) {
    if (props.disabled) return
    emit('update:modelValue', props.modelValue.filter(i => i !== idx))
}
</script>

<style scoped>
/* Colores y estados: .tl-choice (src/style.css), igual que las opciones de opción múltiple */
/* En teléfono más grandes (fáciles de tocar); en computadora como antes */
.tile {
    @apply px-4 py-3 text-lg min-h-[52px];
}
@media (min-width: 768px) {
    .tile {
        @apply px-3 py-2 text-base min-h-0;
    }
}
</style>
