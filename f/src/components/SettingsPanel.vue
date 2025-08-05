<template>
    <Card class="bg-gray-800 rounded-lg p-4">
        <h3 class="font-bold mb-3">Preferencias de aprendizaje</h3>
        <div class="space-y-4">
            <div class="flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <span>🌐</span>
                    <label>Variante dialectal preferida</label>
                </div>
                <select :value="preferredDialect" @change="$emit('update:preferredDialect', $event.target.value)"
                    class="h-8 bg-gray-700 border-gray-600 rounded text-sm px-2">
                    <option value="all">Todas</option>
                    <option value="central">Central</option>
                    <option value="oriental">Oriental</option>
                    <option value="occidental">Occidental</option>
                </select>
            </div>

            <div class="flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <span>🔊</span>
                    <label>Efectos de sonido</label>
                </div>
                <input type="checkbox" :checked="soundEffects"
                    @change="$emit('update:soundEffects', $event.target.checked)"
                    class="h-5 w-5 rounded bg-gray-700 border-gray-600">
            </div>

            <div class="flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <span>🗣️</span>
                    <label>Pronunciación automática</label>
                </div>
                <input type="checkbox" :checked="autoPronunciation"
                    @change="$emit('update:autoPronunciation', $event.target.checked)"
                    class="h-5 w-5 rounded bg-gray-700 border-gray-600">
            </div>

            <div class="flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <span>🌙</span>
                    <label>Modo oscuro</label>
                </div>
                <input type="checkbox" :checked="darkMode" @change="$emit('update:darkMode', $event.target.checked)"
                    class="h-5 w-5 rounded bg-gray-700 border-gray-600">
            </div>
        </div>
    </Card>
</template>

<script setup>
import Card from './Card.vue';

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