<template>
    <div class="mx-auto max-w-4xl">

        <!-- Componente de Sistema de Escritura -->
        <WritingSystem :writing-system="writingSystem" :syllabary-data="syllabaryData"
            :alphabet-by-type="alphabetByType" :vowels-data="vowelsData" :long-vowels="longVowels"
            :basic-consonants="basicConsonants" :special-combinations="specialCombinations" @select-vowel="selectVowel"
            @select-syllable="selectSyllable" @select-letter="selectLetter" @select-empty="selectEmpty"
            @select-long-vowel="selectLongVowel" @select-alphabet-letter="selectAlphabetLetter" class="mb-7" />

        <!-- ========== PANEL DE INFORMACIÓN DEL SISTEMA DE ESCRITURA ========== -->
        <div class="rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6 mb-6">
            <div class="text-slate-300">
                <!-- Encabezado -->
                <div class="text-center mb-6">
                    <h2 class="text-xl font-semibold text-cyan-400 mb-2">
                        Notas sobre el {{ writingSystemInfo.name }}
                    </h2>
                    <p class="text-slate-400 text-sm">
                        {{ writingSystemInfo.description }}
                    </p>
                </div>
                <!-- Características principales -->
                <div class="grid grid-cols-1 gap-6">
                    <!-- Notas importantes -->
                    <div class="bg-slate-700/50 rounded-lg p-4 border border-slate-600">
                        <ul class="space-y-2 text-sm">
                            <li v-for="(note, index) in writingSystemInfo.notes" :key="index" class="flex items-start">
                                <span class="text-cyan-400 mr-2 mt-1 flex-shrink-0">•</span>
                                <span class="text-slate-300">{{ note }}</span>
                            </li>
                        </ul>
                    </div>
                </div>

            </div>
        </div>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue';
import { useAuthStore } from '../../stores/auth';
import { LanguageService } from '../../data/services/LanguageService.js';
import { getSyllabaryRepository } from '../../data/repositories/RepositoryFactory.js';
import WritingSystem from '../../components/WritingSystem.vue';

const authStore = useAuthStore();
const languageService = new LanguageService();
const syllabaryRepo = getSyllabaryRepository();

const selectedSyllableInfo = ref(null);
const selectedAlphabetLetter = ref(null);

// Sistema de escritura
const writingSystem = computed(() => {
    if (!authStore.selectedLanguage) return 'alphabet';
    return syllabaryRepo.getWritingSystem(authStore.selectedLanguage);
});

// ========== DATOS PARA SILABARIOS ==========
const syllabaryData = computed(() => {
    if (!authStore.selectedLanguage || writingSystem.value !== 'syllabary') return [];
    return syllabaryRepo.getSyllabary(authStore.selectedLanguage);
});

const vowelsData = computed(() => {
    if (!authStore.selectedLanguage || writingSystem.value !== 'syllabary') return {};
    return syllabaryRepo.getVowels(authStore.selectedLanguage);
});

const longVowels = computed(() => {
    if (!authStore.selectedLanguage || writingSystem.value !== 'syllabary') return null;
    return syllabaryRepo.getLongVowels(authStore.selectedLanguage);
});

const basicConsonants = computed(() => {
    if (!authStore.selectedLanguage || writingSystem.value !== 'syllabary') return [];
    return syllabaryRepo.getConsonants(authStore.selectedLanguage).filter(entry =>
        !entry.notes || !entry.notes.includes('glotalizada')
    );
});

const specialCombinations = computed(() => {
    if (!authStore.selectedLanguage || writingSystem.value !== 'syllabary') return [];
    return syllabaryRepo.getSpecialCharacters(authStore.selectedLanguage);
});

// ========== DATOS PARA ALFABETOS ==========
const alphabetByType = computed(() => {
    if (!authStore.selectedLanguage || writingSystem.value !== 'alphabet') {
        return { vowels: [], consonants: [], ejectives: [], longVowels: [] };
    }
    return syllabaryRepo.getAlphabetByType(authStore.selectedLanguage);
});

const totalLetters = computed(() => {
    return alphabetByType.value.vowels.length +
        alphabetByType.value.consonants.length +
        alphabetByType.value.ejectives.length +
        alphabetByType.value.longVowels.length;
});

// ========== INFORMACIÓN DEL SISTEMA DE ESCRITURA ==========
const writingSystemInfo = computed(() => {
    if (!authStore.selectedLanguage) {
        return syllabaryRepo.getWritingSystemInfo('alphabet');
    }
    return syllabaryRepo.getCurrentWritingSystemInfo(authStore.selectedLanguage);
});

// ========== FUNCIONES AUXILIARES ==========
const getLongVowelPronunciation = (vowel) => {
    const baseVowel = vowelsData.value[vowel] || vowel;
    return `${baseVowel}${baseVowel}`;
};

// ========== FUNCIONES DE SELECCIÓN ==========
// Para silabarios
const selectVowel = (vowel) => {
    if (writingSystem.value !== 'syllabary') return;
    selectedSyllableInfo.value = {
        letter: null,
        pronunciation: null,
        syllables: {
            [vowel]: `${vowelsData.value[vowel] || vowel}`
        }
    };
    selectedAlphabetLetter.value = null;
};

const selectSyllable = (entry, vowel) => {
    if (writingSystem.value !== 'syllabary') return;
    selectedSyllableInfo.value = entry;
    selectedAlphabetLetter.value = null;
};

const selectLetter = (entry) => {
    if (writingSystem.value !== 'syllabary') return;
    selectedSyllableInfo.value = entry;
    selectedAlphabetLetter.value = null;
};

const selectEmpty = () => {
    // No hacer nada para celdas vacías
};

const selectLongVowel = (vowel) => {
    if (writingSystem.value !== 'syllabary' || !longVowels.value || !longVowels.value[vowel]) return;
    selectedSyllableInfo.value = {
        letter: null,
        pronunciation: `Vocal larga: ${getLongVowelPronunciation(vowel)}`,
        syllables: {
            [vowel]: longVowels.value[vowel]
        },
        isLongVowel: true
    };
    selectedAlphabetLetter.value = null;
};

// Para alfabetos
const selectAlphabetLetter = (letter) => {
    if (writingSystem.value !== 'alphabet') return;
    selectedAlphabetLetter.value = letter;
    selectedSyllableInfo.value = null;
};
</script>