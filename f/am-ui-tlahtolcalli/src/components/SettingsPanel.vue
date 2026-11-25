<template>
    <Card class="bg-gray-800 rounded-lg p-4">
        <h3 class="font-bold mb-3">Preferencias de aprendizaje</h3>
        <div class="space-y-4">

            <!-- Diseño de las opciones y fichas de los ejercicios (src/data/uiPrefs.js, se guarda en este dispositivo) -->
            <div class="flex items-center justify-between gap-4">
                <div class="min-w-0">
                    <label for="pref-duo" class="block cursor-pointer">Botones con relieve</label>
                    <p class="text-xs text-gray-400">Opciones y fichas de las lecciones como teclas que se hunden al tocarlas.</p>
                </div>
                <label class="relative inline-flex items-center cursor-pointer shrink-0">
                    <input id="pref-duo" type="checkbox" v-model="duoButtons" class="sr-only peer">
                    <div class="w-11 h-6 bg-gray-700 peer-focus-visible:ring-2 peer-focus-visible:ring-turquesa rounded-full peer
                    peer-checked:after:translate-x-full peer-checked:after:border-white
                    after:content-[''] after:absolute after:top-[2px] after:left-[2px]
                    after:bg-white after:border-gray-300 after:border after:rounded-full
                    after:h-5 after:w-5 after:transition-all peer-checked:bg-turquesa-deep">
                    </div>
                </label>
            </div>

            <!-- Vista previa del diseño elegido -->
            <div class="flex gap-2" aria-hidden="true">
                <span class="tl-choice px-3 py-2 text-sm">Opción</span>
                <span class="tl-choice is-selected px-3 py-2 text-sm">Elegida</span>
                <span class="tl-choice is-correct px-3 py-2 text-sm">Correcta</span>
            </div>

            <!-- <div class="flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <span>🔊</span>
                    <label>Efectos de sonido</label>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                    <input type="checkbox" :checked="soundEffects"
                        @change="$emit('update:soundEffects', $event.target.checked)" class="sr-only peer">
                    <div class="w-11 h-6 bg-gray-700 peer-focus:outline-none rounded-full peer 
                    peer-checked:after:translate-x-full peer-checked:after:border-white 
                    after:content-[''] after:absolute after:top-[2px] after:left-[2px] 
                    after:bg-white after:border-gray-300 after:border after:rounded-full 
                    after:h-5 after:w-5 after:transition-all peer-checked:bg-green-500">
                    </div>
                </label>
            </div>

            <div class="flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <span>🗣️</span>
                    <label>Pronunciación automática</label>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                    <input type="checkbox" :checked="autoPronunciation"
                        @change="$emit('update:autoPronunciation', $event.target.checked)" class="sr-only peer">
                    <div class="w-11 h-6 bg-gray-700 peer-focus:outline-none rounded-full peer 
                    peer-checked:after:translate-x-full peer-checked:after:border-white 
                    after:content-[''] after:absolute after:top-[2px] after:left-[2px] 
                    after:bg-white after:border-gray-300 after:border after:rounded-full 
                    after:h-5 after:w-5 after:transition-all peer-checked:bg-green-500">
                    </div>
                </label>
            </div>

            <div class="flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <span>🌙</span>
                    <label>Modo oscuro</label>
                </div>
                <label class="relative inline-flex items-center cursor-pointer">
                    <input type="checkbox" :checked="darkMode" @change="$emit('update:darkMode', $event.target.checked)"
                        class="sr-only peer">
                    <div class="w-11 h-6 bg-gray-700 peer-focus:outline-none rounded-full peer 
                    peer-checked:after:translate-x-full peer-checked:after:border-white 
                    after:content-[''] after:absolute after:top-[2px] after:left-[2px] 
                    after:bg-white after:border-gray-300 after:border after:rounded-full 
                    after:h-5 after:w-5 after:transition-all peer-checked:bg-green-500">
                    </div>
                </label>
            </div> -->

        </div>
    </Card>
</template>

<script setup>
import Card from './Card.vue';
import { duoButtons } from '../data/uiPrefs.js';

defineProps({
    preferredDialect: {
        type: String,
        default: 'all'
    },
    soundEffects: {
        type: Boolean,
        default: true
    },
    autoPronunciation: {
        type: Boolean,
        default: true
    },
    darkMode: {
        type: Boolean,
        default: true
    }
});

defineEmits([
    'update:preferredDialect',
    'update:soundEffects',
    'update:autoPronunciation',
    'update:darkMode'
]);
</script>