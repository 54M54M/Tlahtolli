<template>
    <div class="min-h-screen bg-[#0A2136] text-white">
        <!-- Top header -->
        <Header variant="simple" title="Diccionario Náhuatl" backRoute="/" />

        <main class="container mx-auto px-4 py-6 md:py-10">
            <div class="max-w-md mx-auto">
                <div class="mb-4">
                    <!-- Search Input -->
                    <div class="relative mb-3 md:mb-4">
                        <Search class="absolute left-3 top-2.5 h-4 w-4 text-gray-400" />
                        <input type="text" placeholder="Buscar palabra..."
                            class="pl-9 text-xs md:text-sm bg-gray-800 border-gray-700 text-white w-full p-2 rounded border focus:outline-none focus:ring-1 focus:ring-blue-500"
                            v-model="searchTerm" />
                    </div>

                    <!-- Filters -->
                    <div class="flex flex-col gap-2 md:gap-4">
                        <!-- Tab -->
                        <Tab :tabs="tabs" v-model="dialect" class="text-xs md:text-sm" />

                        <!-- Category Select -->
                        <select v-model="selectedCategory"
                            class="text-xs md:text-sm bg-gray-800 border-gray-700 text-white w-full p-2 rounded border focus:outline-none focus:ring-1 focus:ring-blue-500">
                            <option value="all">Todas las categorías</option>
                            <option v-for="category in categories" :key="category" :value="category">{{ category }}
                            </option>
                        </select>
                    </div>
                </div>

                <!-- Dictionary Entries -->
                <div class="space-y-2 md:space-y-3 mb-8 md:mb-10">
                    <div v-if="filteredEntries.length > 0">
                        <Card v-for="(entry, index) in filteredEntries" :key="index"
                            class="border border-gray-700 bg-[#1f2937] mb-2 md:mb-4">
                            <div class="flex justify-between items-start p-3 md:p-4">
                                <div class="flex-1 min-w-0 mr-2">
                                    <h3 class="text-base md:text-lg font-bold text-white truncate">{{ entry.spanish }}
                                    </h3>
                                    <div class="mt-1 md:mt-2 space-y-1">
                                        <div v-if="dialect === 'all' || dialect === 'central'"
                                            class="flex items-center gap-1 md:gap-2">
                                            <span class="text-xs font-medium text-emerald-400">Central:</span>
                                            <span class="italic text-xs md:text-sm truncate">{{ entry.central }}</span>
                                            <button class="text-emerald-400 hover:text-emerald-300"
                                                @click="speak(entry.central, 'central')">
                                                <Volume2 class="h-3 w-3 md:h-4 md:w-4" />
                                            </button>
                                        </div>
                                        <div v-if="dialect === 'all' || dialect === 'oriental'"
                                            class="flex items-center gap-1 md:gap-2">
                                            <span class="text-xs font-medium text-amber-400">Oriental:</span>
                                            <span class="italic text-xs md:text-sm truncate">{{ entry.oriental }}</span>
                                            <button class="text-amber-400 hover:text-amber-300"
                                                @click="speak(entry.oriental, 'oriental')">
                                                <Volume2 class="h-3 w-3 md:h-4 md:w-4" />
                                            </button>
                                        </div>
                                        <div v-if="dialect === 'all' || dialect === 'occidental'"
                                            class="flex items-center gap-1 md:gap-2">
                                            <span class="text-xs font-medium text-rose-400">Occidental:</span>
                                            <span class="italic text-xs md:text-sm truncate">{{ entry.occidental
                                            }}</span>
                                            <button class="text-rose-400 hover:text-rose-300"
                                                @click="speak(entry.occidental, 'occidental')">
                                                <Volume2 class="h-3 w-3 md:h-4 md:w-4" />
                                            </button>
                                        </div>
                                    </div>
                                    <p class="mt-1 md:mt-2 text-xs text-gray-400">
                                        <span class="font-medium">Ejemplo:</span> {{ entry.example }}
                                    </p>
                                </div>
                                <Badge class="bg-[#2b4a2c] text-[#48cc11] flex-shrink-0 text-xs md:text-sm px-2 py-1">{{
                                    entry.category }}
                                </Badge>
                            </div>
                        </Card>
                    </div>
                    <div v-else class="text-center py-4 md:py-6">
                        <p class="text-gray-400 text-xs md:text-sm">No se encontraron resultados para "{{ searchTerm }}"
                        </p>
                    </div>
                </div>
            </div>
        </main>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue';
import Header from '../components/vHeader.vue';
import Badge from '../components/Badge.vue';
import Card from '../components/Card.vue';
import Tab from '../components/Tab.vue';
import { dictionaryEntries } from '../lib/data.js';

const searchTerm = ref('');
const dialect = ref('all');
const selectedCategory = ref('all');

// Obtener categorías únicas
const categories = computed(() => {
    const cats = new Set();
    dictionaryEntries.forEach(entry => cats.add(entry.category));
    return Array.from(cats).sort();
});

const tabs = [
    { value: 'all', label: 'Todas' },
    { value: 'central', label: 'Central' },
    { value: 'oriental', label: 'Oriental' },
    { value: 'occidental', label: 'Occidental' }
];

// Filtrar entradas basadas en búsqueda, dialecto y categoría
const filteredEntries = computed(() => {
    const term = searchTerm.value.toLowerCase();

    return dictionaryEntries.filter(entry => {
        // Filtro por término de búsqueda
        const matchesSearch =
            entry.spanish.toLowerCase().includes(term) ||
            entry.central.toLowerCase().includes(term) ||
            entry.oriental.toLowerCase().includes(term) ||
            entry.occidental.toLowerCase().includes(term) ||
            entry.example.toLowerCase().includes(term);

        // Filtro por categoría
        const matchesCategory =
            selectedCategory.value === 'all' ||
            entry.category === selectedCategory.value;

        return matchesSearch && matchesCategory;
    });
});

// Función para leer el texto (usando Web Speech API)
const speak = (text, dialect) => {
    if ('speechSynthesis' in window) {
        const utterance = new SpeechSynthesisUtterance(text);

        // Configurar voz según dialecto (esto es un ejemplo, en producción necesitarías voces específicas)
        utterance.lang = 'es-MX'; // Usamos español mexicano como base

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