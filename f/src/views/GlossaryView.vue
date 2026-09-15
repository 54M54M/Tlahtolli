<template>
    <div class="min-h-screen bg-[#0A2136] text-white">
        <!-- Top header -->
        <Header variant="simple" :title="currentTabTitle" backRoute="/" class="pt-6 md:pt-5" />

        <main class="container mx-auto py-2 md:py-10">
            <div class="max-w-4xl mx-auto ">
                <!-- Mostrar tabs solo si hay más de uno disponible -->
                <Tab v-if="availableTabs.length > 1" :tabs="availableTabs" v-model="activeTab" class="mb-6" />

                <!-- Contenido del 'Sistema de Escritura' -->
                <WritingContent v-if="activeTab === 'writingSystem'" :syllabaryData="syllabaryEntries" />

                <!-- Contenido del Banco de Palabras - BUG: ARREGLAR -->
                <!-- <WordBankContent v-if="activeTab === 'wordBank'" :language="selectedLanguage"
                    :currentLanguageName="currentLanguageName" :currentLanguageColor="currentLanguageColor" /> -->

                <!-- Contenido del Diccionario - BUG: ARREGLAR -->
                <!-- <DictionaryContent v-if="activeTab === 'dictionary'" :searchTerm="searchTerm"
                    :selectedCategory="selectedCategory" :selectedLanguage="selectedLanguage"
                    :currentLanguageName="currentLanguageName" :currentLanguageColor="currentLanguageColor"
                    :categories="categories" :filteredEntries="filteredEntries" @update:searchTerm="searchTerm = $event"
                    @update:selectedCategory="selectedCategory = $event" @speak="speak" /> -->

            </div>
        </main>
    </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useAuthStore } from '../stores/auth.js';
import Header from '../components/vHeader.vue';
import Tab from '../components/Tab.vue';

import { Volume2 } from 'lucide-vue-next';

import WritingContent from './glossary/SyllabaryContent.vue';
import { LanguageService } from '../data/services/LanguageService.js';

const authStore = useAuthStore();
const languageService = new LanguageService();

const searchTerm = ref('');
const selectedCategory = ref('all');
const activeTab = ref('writingSystem');

// Determinar qué tabs disponibles
const availableTabs = computed(() => {
    const tabs = [];

    // Sistema de escritura siempre disponible
    tabs.push({ value: 'writingSystem', label: writingSystemInfo.value.name });

    // Banco de palabras disponible después de completar unidad 1
    // if (hasCompletedUnit1.value || hasCompletedLevel1.value) {
    //     tabs.push({ value: 'wordBank', label: 'Banco de Palabras' });
    // }

    // Diccionario disponible después de completar nivel 1
    // if (hasCompletedLevel1.value) {
    //     tabs.push({ value: 'dictionary', label: 'Diccionario' });
    // }

    return tabs;
});

// Ajustar activeTab si el tab actual no está disponible
const adjustActiveTab = () => {
    const availableTabValues = availableTabs.value.map(tab => tab.value);
    if (!availableTabValues.includes(activeTab.value)) {
        activeTab.value = availableTabValues[0] || 'writingSystem';
    }
};


const writingSystemInfo = computed(() => {
    const languageInfo = languageService.getLanguageInfo(selectedLanguage.value);
    const writingSystemNames = {
        'nhce': 'Alfabeto',
        'tkoc': 'Alfabeto',
    };
    return {
        name: writingSystemNames[selectedLanguage.value] || 'Sistema de Escritura',
        type: languageInfo?.writingSystem || 'syllabary'
    };
});

const currentTabTitle = computed(() => {
    const currentTab = availableTabs.value.find(tab => tab.value === activeTab.value);
    return currentTab?.label || 'Glosario';
});

const selectedLanguage = computed(() => {
    return authStore.selectedLanguage || 'nhce';
});

const currentLanguageInfo = computed(() => {
    return languageService.getLanguageInfo(selectedLanguage.value) || { name: 'Náhuatl Central', color: '#58CC02' };
});

const currentLanguageName = computed(() => currentLanguageInfo.value?.name || 'Náhuatl Central');
const currentLanguageColor = computed(() => currentLanguageInfo.value?.color || '#58CC02');

const speak = (text, language) => {
    if ('speechSynthesis' in window) {
        speechSynthesis.cancel();
        const utterance = new SpeechSynthesisUtterance(text);

        switch (language) {
            case 'nhce':
                utterance.lang = 'es-MX';
                utterance.rate = 0.9;
                utterance.pitch = 1.0;
                break;
            case 'tkoc':
                utterance.lang = 'es-MX';
                utterance.rate = 1.0;
                utterance.pitch = 1.1;
                break;
            default:
                utterance.lang = 'es-MX';
                utterance.rate = 1.0;
                utterance.pitch = 1.0;
                break;
        }

        speechSynthesis.speak(utterance);
    } else {
        alert('Tu navegador no soporta la funcionalidad de texto a voz');
    }
};

// Watchers
watch(availableTabs, adjustActiveTab);
watch(selectedLanguage, () => {
    adjustActiveTab();
});

onMounted(() => {
    if (!authStore.selectedLanguage) {
        console.warn('No hay idioma seleccionado, usando idioma por defecto "nhce"');
    }
    adjustActiveTab();
});
</script>