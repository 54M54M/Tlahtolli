<template>
    <div class="min-h-screen bg-[#0A2136] text-white">
        <Header variant="simple" title="Mapa Dialectal" />

        <main class="container mx-auto px-4 py-6 md:py-10">
            <div class="max-w-md mx-auto">
                <!-- Map Container -->
                <div
                    class="relative w-full h-[250px] md:h-[300px] border border-gray-700 rounded-lg bg-gray-900 mb-4 md:mb-6">
                    <div class="absolute inset-0 flex items-center justify-center">
                        <img src="../assets/mx.svg" alt="Mapa de México"
                            class="w-full h-full object-contain opacity-30" />
                    </div>

                    <!-- Region Buttons -->
                    <button v-for="region in regions" :key="region.id"
                        class="absolute w-6 h-6 md:w-8 md:h-8 rounded-full flex items-center justify-center transition-all hover:scale-110 focus:outline-none focus:ring-2 focus:ring-white"
                        :class="{ 'transform scale-125 z-20': selectedRegion === region.id }" :style="{
                            top: region.position.top,
                            left: region.position.left,
                            backgroundColor: region.color,
                            zIndex: 10
                        }" @click="selectRegion(region.id)" :aria-label="`Seleccionar región ${region.name}`">
                        <span class="sr-only">{{ region.name }}</span>
                        <span aria-hidden="true">
                            <svg version="1.0" xmlns="http://www.w3.org/2000/svg" class="w-4 h-4 md:w-5 md:h-5"
                                viewBox="0 0 512.000000 512.000000" preserveAspectRatio="xMidYMid meet">
                                <g transform="translate(0.000000,512.000000) scale(0.100000,-0.100000)" fill="#000000"
                                    stroke="none">
                                    <path d="M2430 5114 c-229 -26 -360 -54 -508 -109 -392 -147 -720 -416 -943
                                        -775 -210 -339 -307 -778 -259 -1170 78 -631 528 -1501 1274 -2465 176 -228
                                        403 -501 455 -548 69 -62 153 -62 222 0 52 47 279 320 455 548 671 867 1102
                                        1655 1238 2267 35 157 46 259 46 423 -1 480 -193 939 -540 1285 -286 287 -623
                                        460 -1020 525 -94 15 -352 27 -420 19z m247 -925 c373 -50 682 -318 783 -679
                                        27 -95 37 -286 21 -390 -47 -296 -241 -556 -516 -690 -162 -79 -328 -109 -497
                                        -90 -132 15 -199 34 -313 90 -275 134 -469 394 -516 690 -16 104 -6 295 21
                                        390 125 446 566 741 1017 679z" />
                                </g>
                            </svg>
                        </span>
                    </button>
                </div>

                <!-- Region Details -->
                <div v-if="selectedRegion" class="mb-6 md:mb-8">
                    <Card class="border border-gray-700 p-3 md:p-4">
                        <div v-for="region in filteredRegions" :key="region.id">
                            <h3 class="text-base md:text-lg font-bold text-white mb-1 md:mb-2">{{ region.name }}</h3>
                            <p class="text-xs md:text-sm text-gray-300 mb-2 md:mb-3">{{ region.description }}</p>

                            <!-- Common Words -->
                            <div class="mb-2 md:mb-3">
                                <h4 class="font-medium text-[#58CC02] text-xs md:text-sm mb-1">Palabras comunes:</h4>
                                <div class="space-y-1">
                                    <div v-for="word in region.words" :key="word.spanish"
                                        class="flex items-center justify-between bg-gray-700 rounded p-1.5 md:p-2">
                                        <span class="text-xs md:text-sm truncate">{{ word.spanish }}:</span>
                                        <div class="flex items-center gap-1 md:gap-2">
                                            <span class="text-xs md:text-sm italic truncate">{{ word.nahuatl }}</span>
                                            <button class="text-[#58CC02] hover:text-[#4bb102] focus:outline-none"
                                                @click="speak(word.nahuatl, region.id)"
                                                :aria-label="`Pronunciar ${word.nahuatl}`">
                                                <Volume2 class="h-3 w-3 md:h-3.5 md:w-3.5" />
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Main Communities -->
                            <div>
                                <h4 class="font-medium text-[#58CC02] text-xs md:text-sm mb-1">Comunidades principales:
                                </h4>
                                <ul class="list-disc pl-4 md:pl-5 text-gray-300 text-xs md:text-sm space-y-0.5">
                                    <li v-for="community in region.communities" :key="community">
                                        {{ community }}
                                    </li>
                                </ul>
                            </div>

                            <!-- Close Button -->
                            <button
                                class="mt-3 md:mt-4 bg-gray-700 hover:bg-gray-600 text-xs md:text-sm w-full rounded p-1.5 md:p-2 transition-colors focus:outline-none focus:ring-1 focus:ring-gray-500"
                                @click="selectedRegion = null" aria-label="Cerrar detalles de región">
                                Cerrar
                            </button>
                        </div>
                    </Card>
                </div>

                <!-- Empty State -->
                <div v-else class="text-center text-gray-400 py-3 md:py-4">
                    <p class="text-xs md:text-sm">Selecciona una región en el mapa para ver más información</p>
                </div>
            </div>
        </main>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import Card from '../components/Card.vue';
import Header from '../components/vHeader.vue';
import { regions } from '../lib/data.js';

const selectedRegion = ref(null);

const filteredRegions = computed(() =>
    regions.filter(r => r.id === selectedRegion.value)
);

const selectRegion = (regionId) => {
    selectedRegion.value = regionId;
};

const speak = (text, dialect) => {
    if ('speechSynthesis' in window) {
        const utterance = new SpeechSynthesisUtterance(text);
        utterance.lang = 'es-MX';

        // Ajustar parámetros según dialecto
        switch (dialect) {
            case 'central':
                utterance.rate = 0.9;
                utterance.pitch = 1.0;
                break;
            case 'oriental':
                utterance.rate = 1.0;
                utterance.pitch = 1.1;
                break;
            case 'occidental':
                utterance.rate = 1.1;
                utterance.pitch = 0.9;
                break;
        }

        speechSynthesis.speak(utterance);
    } else {
        alert('Tu navegador no soporta la funcionalidad de texto a voz');
    }
};
</script>