<template>
    <div class="mx-auto max-w-4xl">

        <!-- Componente de Sistema de Escritura -->
        <WritingSystem :writing-system="writingSystem" :syllabary-data="syllabaryData"
            :alphabet-by-type="alphabetByType" :vowels-data="vowelsData" :long-vowels="longVowels"
            :basic-consonants="basicConsonants" :special-combinations="specialCombinations" @select-vowel="selectVowel"
            @select-syllable="selectSyllable" @select-letter="selectLetter" @select-empty="selectEmpty"
            @select-long-vowel="selectLongVowel" @select-alphabet-letter="selectAlphabetLetter" class="mb-7" />

        <!-- ========== PANEL DE INFORMACIÓN DEL SISTEMA DE ESCRITURA ========== -->
        <div class="rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6 mb-14 md:mb-[-30px]">
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
import { ref, watch, onMounted } from 'vue';
import { useAuthStore } from '../../stores/auth';
import { getSyllabaryRepository } from '../../data/repositories/RepositoryFactory.js';
import WritingSystem from '../../components/WritingSystem.vue';

const authStore = useAuthStore();
const syllabaryRepo = getSyllabaryRepository();

const selectedSyllableInfo = ref(null);
const selectedAlphabetLetterData = ref(null);

// Datos reactivos inicializados con defaults
const writingSystem = ref('alphabet');
const syllabaryData = ref([]);
const vowelsData = ref({});
const longVowels = ref(null);
const basicConsonants = ref([]);
const specialCombinations = ref([]);
const alphabetByType = ref({ vowels: [], consonants: [], ejectives: [], longVowels: [] });
const writingSystemInfo = ref({ name: 'Sistema de Escritura', description: '', notes: [] });

// Carga async de todos los datos
async function loadData() {
    const langId = authStore.selectedLangId;
    if (!langId) return;

    try {
        writingSystem.value = await syllabaryRepo.getWritingSystem(langId);
    } catch (e) {
        writingSystem.value = 'alphabet';
    }

    try {
        syllabaryData.value = await syllabaryRepo.getSyllabary(langId);
    } catch (e) {
        syllabaryData.value = [];
    }

    try {
        vowelsData.value = await syllabaryRepo.getVowels(langId);
    } catch (e) {
        vowelsData.value = {};
    }

    try {
        longVowels.value = await syllabaryRepo.getLongVowels(langId);
    } catch (e) {
        longVowels.value = null;
    }

    try {
        const consonants = await syllabaryRepo.getConsonants(langId);
        basicConsonants.value = consonants.filter(
            entry => !entry.notes || !entry.notes.includes('glotalizada')
        );
    } catch (e) {
        basicConsonants.value = [];
    }

    try {
        specialCombinations.value = await syllabaryRepo.getSpecialCharacters(langId);
    } catch (e) {
        specialCombinations.value = [];
    }

    try {
        alphabetByType.value = await syllabaryRepo.getAlphabetByType(langId);
    } catch (e) {
        alphabetByType.value = { vowels: [], consonants: [], ejectives: [], longVowels: [] };
    }

    try {
        writingSystemInfo.value = await syllabaryRepo.getCurrentWritingSystemInfo(langId);
    } catch (e) {
        writingSystemInfo.value = { name: 'Sistema de Escritura', description: '', notes: [] };
    }
}

onMounted(loadData);
watch(() => authStore.selectedLangId, loadData);

// ========== FUNCIONES DE SELECCIÓN ==========
const selectVowel = (vowel) => {
    if (writingSystem.value !== 'syllabary') return;
    selectedSyllableInfo.value = {
        letter: null,
        pronunciation: null,
        syllables: {
            [vowel]: `${vowelsData.value[vowel] || vowel}`
        }
    };
    selectedAlphabetLetterData.value = null;
};

const selectSyllable = (entry, vowel) => {
    if (writingSystem.value !== 'syllabary') return;
    selectedSyllableInfo.value = entry;
    selectedAlphabetLetterData.value = null;
};

const selectLetter = (entry) => {
    if (writingSystem.value !== 'syllabary') return;
    selectedSyllableInfo.value = entry;
    selectedAlphabetLetterData.value = null;
};

const selectEmpty = () => { };

const selectLongVowel = (vowel) => {
    if (writingSystem.value !== 'syllabary' || !longVowels.value || !longVowels.value[vowel]) return;
    selectedSyllableInfo.value = {
        letter: null,
        pronunciation: `Vocal larga: ${vowelsData.value[vowel] || vowel}${vowelsData.value[vowel] || vowel}`,
        syllables: { [vowel]: longVowels.value[vowel] },
        isLongVowel: true
    };
    selectedAlphabetLetterData.value = null;
};

const selectAlphabetLetter = (letter) => {
    if (writingSystem.value !== 'alphabet') return;
    selectedAlphabetLetterData.value = letter;
    selectedSyllableInfo.value = null;
};
</script>