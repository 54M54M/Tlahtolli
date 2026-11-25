<template>
    <!-- Armar frase con fichas (estilo Duolingo): toca una ficha para subirla a la respuesta,
         tócala en la respuesta para regresarla. En el banco queda el hueco para no perder el lugar. -->
    <div class="w-full select-none">
        <!-- Respuesta -->
        <div class="min-h-[64px] border-b-2 border-line pb-2 mb-2 flex flex-wrap gap-2 content-start"
            :class="stateClass" aria-label="Tu respuesta" role="list">
            <button v-for="idx in modelValue" :key="`a-${idx}`" type="button" role="listitem"
                class="tile bg-surface-0" :class="answerTileClass" :disabled="disabled" @click="remove(idx)">
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
                <span v-if="modelValue.includes(idx)" class="tile tile-placeholder" aria-hidden="true">{{ tile }}</span>
                <button v-else type="button" role="listitem" class="tile bg-gray-700 border-gray-600 text-white hover:bg-gray-600"
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
    ? 'border-green-500 text-green-300'
    : props.state === 'wrong' ? 'border-error text-error' : 'border-line')

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
.tile {
    @apply px-3 py-2 rounded-xl border-2 border-b-4 text-base font-semibold transition-transform;
}
.tile:not(:disabled):active {
    transform: translateY(1px);
}
.tile:disabled {
    @apply cursor-default;
}
.tile-placeholder {
    @apply bg-gray-800 border-gray-800 text-transparent;
}
</style>
