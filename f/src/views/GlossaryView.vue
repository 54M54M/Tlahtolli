<template>
    <div class="min-h-screen bg-[#0A2136] text-white">
        <!-- Top header -->
        <Header variant="simple" :title="currentTabTitle" backRoute="/" class="pt-6 md:pt-5" />

        <main class="container mx-auto px-4 py-2 md:py-10">
            <div class="max-w-4xl mx-auto">
                <!-- Tabs principales usando el componente Tab -->
                <Tab :tabs="mainTabs" v-model="activeTab" class="mb-6" />

                <!-- Contenido del Diccionario -->
                <DictionaryContent v-if="activeTab === 'dictionary'" :searchTerm="searchTerm"
                    :selectedCategory="selectedCategory" :selectedVariant="selectedVariant"
                    :currentVariantName="currentVariantName" :currentVariantColor="currentVariantColor"
                    :categories="categories" :filteredEntries="filteredEntries" @update:searchTerm="searchTerm = $event"
                    @update:selectedCategory="selectedCategory = $event" @speak="speak" />

                <!-- Contenido del Silabario -->
                <SyllabaryContent v-if="activeTab === 'syllabary'" :syllabaryData="silabaryEntries" />
            </div>
        </main>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import { useAuthStore } from '../stores/auth.js';
import Header from '../components/vHeader.vue';
import Tab from '../components/Tab.vue';

import DictionaryContent from './glossary/DictionaryContent.vue';
import SyllabaryContent from './glossary/SyllabaryContent.vue';
import { dictionaryEntries, silabaryEntries, dialectVariants } from '../lib/data.js';

const authStore = useAuthStore();
const searchTerm = ref('');
const selectedCategory = ref('all');
const activeTab = ref('dictionary');

// Tabs principales usando el componente Tab
const mainTabs = [
    { value: 'dictionary', label: 'Diccionario' },
    { value: 'syllabary', label: 'Silabario' }
];

// Título dinámico para el header
const currentTabTitle = computed(() => {
    const currentTab = mainTabs.find(tab => tab.value === activeTab.value);
    return currentTab?.label || 'Glosario';
});

// Obtener la variante seleccionada del store
const selectedVariant = computed(() => {
    return authStore.selectedVariant || 'all';
});

// Información de la variante actual
const currentVariant = computed(() => {
    return dialectVariants.find(v => v.id === selectedVariant.value) || dialectVariants.find(v => v.id === 'all');
});

const currentVariantName = computed(() => currentVariant.value?.name || 'Todas');
const currentVariantColor = computed(() => currentVariant.value?.color || '#A560E8');

// Obtener categorías únicas
const categories = computed(() => {
    const cats = new Set();
    dictionaryEntries.forEach(entry => cats.add(entry.category));
    return Array.from(cats).sort();
});

// Filtrar entradas basadas en búsqueda, categoría y variante seleccionada
const filteredEntries = computed(() => {
    const term = searchTerm.value.toLowerCase();

    return dictionaryEntries
        .filter(entry => {
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
        })
        .map(entry => {
            if (selectedVariant.value === 'all') {
                // Si es "all", devolver la entrada completa para mostrar todas las variantes
                return entry;
            } else {
                // Para variantes específicas, mostrar solo esa variante
                let nahuatlWord = '';

                switch (selectedVariant.value) {
                    case 'central':
                        nahuatlWord = entry.central;
                        break;
                    case 'oriental':
                        nahuatlWord = entry.oriental;
                        break;
                    case 'occidental':
                        nahuatlWord = entry.occidental;
                        break;
                    default:
                        nahuatlWord = entry.central;
                }

                return {
                    ...entry,
                    nahuatl: nahuatlWord
                };
            }
        });
});

// Función para leer el texto (usando Web Speech API)
const speak = (text, dialect) => {
    if ('speechSynthesis' in window) {
        // Cancelar cualquier speech anterior
        speechSynthesis.cancel();

        const utterance = new SpeechSynthesisUtterance(text);

        // Configurar voz según dialecto
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
            case 'all':
            default:
                utterance.rate = 1.0;
                utterance.pitch = 1.0;
                break;
        }

        speechSynthesis.speak(utterance);
    } else {
        alert('Tu navegador no soporta la funcionalidad de texto a voz');
    }
};

// Verificar si hay una variante seleccionada al cargar el componente
onMounted(() => {
    if (!authStore.selectedVariant) {
        console.warn('No hay variante seleccionada, usando variante por defecto "all"');
    }
});
</script>