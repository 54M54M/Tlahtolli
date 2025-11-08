<template>
    <Card class="bg-gray-800 rounded-lg p-4">
        <h3 class="font-bold mb-3">Preferencias de aprendizaje</h3>
        <div class="space-y-4">

            <div class="flex items-center justify-between">
                <div class="flex items-center gap-2">
                    <span><svg width="23" height="23" fill="#ff0000" viewBox="0 0 24 24"
                            xmlns="http://www.w3.org/2000/svg">
                            <path
                                d="M12 2.625c-5.17 0-9.375 4.206-9.375 9.375 0 5.17 4.206 9.375 9.375 9.375 5.17 0 9.375-4.206 9.375-9.375 0-5.17-4.206-9.375-9.375-9.375Zm0 3.844a1.219 1.219 0 1 1 0 2.437 1.219 1.219 0 0 1 0-2.437Zm3 10.593H9.375v-1.5h2.063v-4.124h-1.5v-1.5h3v5.624H15v1.5Z">
                            </path>
                        </svg></span>
                    <label>Funciones en desarrollo...</label>
                </div>
                <!-- <label class="relative inline-flex items-center cursor-pointer">
                    <input type="checkbox" :checked="autoPronunciation"
                        @change="$emit('update:autoPronunciation', $event.target.checked)" class="sr-only peer">
                    <div class="w-11 h-6 bg-gray-700 peer-focus:outline-none rounded-full peer 
                    peer-checked:after:translate-x-full peer-checked:after:border-white 
                    after:content-[''] after:absolute after:top-[2px] after:left-[2px] 
                    after:bg-white after:border-gray-300 after:border after:rounded-full 
                    after:h-5 after:w-5 after:transition-all peer-checked:bg-green-500">
                    </div>
                </label> -->
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