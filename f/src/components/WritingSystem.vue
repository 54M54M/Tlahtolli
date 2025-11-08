<template>
    <div>
        <!-- NAHUATL CENTRAL -->
        <div v-if="writingSystem === 'syllabary'" class="space-y-6">
            <!-- Sección de Vocales -->
            <div v-if="availableVowels.length > 0" class="rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6">
                <h3 class="text-lg font-semibold text-cyan-400 mb-4 text-center">Vocales</h3>

                <div class="grid grid-cols-4 gap-2 sm:gap-4 mb-2">
                    <div v-for="vowel in availableVowels" :key="vowel"
                        class="aspect-square rounded-lg border border-slate-600 bg-slate-800/80 hover:bg-slate-700 flex flex-col items-center justify-center p-1 transition-all cursor-pointer sm:rounded-xl"
                        @click="$emit('selectVowel', vowel)">
                        <span class="text-xs font-medium uppercase tracking-wide text-white sm:text-base">
                            {{ getVowelDisplay(vowel) }}
                        </span>
                    </div>
                </div>
            </div>

            <!-- Sección de Consonantes -->
            <div class="rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6">
                <h3 class="text-lg font-semibold text-cyan-400 mb-4 text-center">Consonantes</h3>

                <!-- Consonantes básicas -->
                <div class="grid grid-cols-5 gap-3">
                    <div v-for="entry in basicConsonants" :key="entry.letter"
                        class="aspect-square uppercase rounded-lg border border-slate-600 bg-slate-800/80 hover:bg-slate-700 flex items-center justify-center font-bold text-white text-sm sm:text-lg transition-all sm:rounded-xl relative"
                        @click="$emit('selectLetter', entry)">
                        {{ entry.letter }}
                    </div>
                </div>
            </div>

            <!-- Sección de Silabas (Consonante + Vocal) -->
            <div class="rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6">
                <h3 class="text-lg font-semibold text-cyan-400 mb-4 text-center">Silabas</h3>

                <!-- Consonantes básicas -->
                <div v-for="entry in basicConsonants" :key="entry.letter" class="grid grid-cols-4 gap-2 sm:gap-4 mb-2">
                    <!-- Sílabas para cada vocal -->
                    <div v-for="vowel in availableVowels" :key="vowel" :class="[
                        'aspect-square rounded-lg border flex flex-col items-center justify-center p-1 transition-all cursor-pointer sm:rounded-xl',
                        !entry.syllables[vowel]
                            ? 'bg-slate-700/50 border-slate-600 cursor-default'
                            : 'bg-slate-800/80 hover:bg-slate-700 border-slate-600'
                    ]" @click="entry.syllables[vowel] ? $emit('selectSyllable', entry, vowel) : $emit('selectEmpty')">
                        <template v-if="entry.syllables[vowel]">
                            <span class="text-xs font-medium uppercase tracking-wide text-white sm:text-base">
                                {{ getSyllableText(entry.syllables[vowel]) }}
                            </span>
                            <span class="text-[9px] text-slate-400 mt-0.5 sm:text-sm">
                                {{ getPronunciation(entry.syllables[vowel]) }}
                            </span>
                        </template>
                    </div>
                </div>
            </div>

            <!-- Sección de Dígrafos -->
            <div v-if="specialCombinations.length > 0" class="rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6">
                <h3 class="text-lg font-semibold text-cyan-400 mb-5 text-center">Dígrafos y fonemas unitarios</h3>

                <!-- Combinaciones -->
                <div v-for="entry in specialCombinations" :key="entry.letter"
                    class="grid grid-cols-6 gap-2 sm:gap-4 mb-2">
                    <!-- Columna de letra -->
                    <div class="aspect-square uppercase rounded-lg border border-slate-600 bg-slate-800/80 hover:bg-slate-700 flex items-center justify-center font-bold text-white text-sm sm:text-lg transition-all sm:rounded-xl relative"
                        @click="$emit('selectLetter', entry)">
                        {{ entry.letter }}
                    </div>

                    <!-- Sílabas para cada vocal - USAR TODAS LAS VOCALES PARA DÍGRAFOS -->
                    <div v-for="vowel in allVowels" :key="vowel" :class="[
                        'aspect-square rounded-lg border flex flex-col items-center justify-center p-1 transition-all cursor-pointer sm:rounded-xl',
                        !entry.syllables[vowel]
                            ? 'bg-slate-700/50 border-slate-600 cursor-default'
                            : 'bg-slate-800/80 hover:bg-slate-700 border-slate-600'
                    ]" @click="entry.syllables[vowel] ? $emit('selectSyllable', entry, vowel) : $emit('selectEmpty')">
                        <template v-if="entry.syllables[vowel]">
                            <span class="text-xs font-medium uppercase tracking-wide text-white sm:text-base">
                                {{ getSyllableText(entry.syllables[vowel]) }}
                            </span>
                            <span class="text-[9px] text-slate-400 mt-0.5 sm:text-sm">
                                {{ getPronunciation(entry.syllables[vowel]) }}
                            </span>
                        </template>
                    </div>
                </div>
            </div>

            <!-- Sección de Vocales Largas -->
            <div v-if="longVowels && Object.keys(filteredLongVowels).length > 0"
                class="rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6">
                <h3 class="text-lg font-semibold text-cyan-400 mb-4 text-center">Vocales Largas</h3>
                <p class="text-sm text-slate-400 mb-4 text-center">Vocales con duración extendida</p>

                <!-- Vocales largas -->
                <div class="grid grid-cols-4 gap-2 sm:gap-4 mb-2">
                    <div v-for="(longVowel, vowel) in filteredLongVowels" :key="'long-' + vowel"
                        class="aspect-square rounded-lg border border-slate-600 bg-slate-800/80 hover:bg-slate-700 flex flex-col items-center justify-center p-1 transition-all cursor-pointer sm:rounded-xl"
                        @click="$emit('selectLongVowel', vowel)">
                        <span class="text-xs font-medium uppercase tracking-wide text-white sm:text-base">
                            {{ longVowel }}
                        </span>
                        <span class="text-[9px] text-slate-400 mt-0.5 sm:text-sm">
                            {{ getLongVowelPronunciation(vowel) }}
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- TEENEK OCCIDENTAL -->
        <div v-else-if="writingSystem === 'alphabet'" class="space-y-6">
            <!-- Sección de Vocales -->
            <div class="rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6">
                <h3 class="text-lg font-semibold text-cyan-400 mb-4 text-center">Vocales</h3>

                <div class="grid grid-cols-5 gap-2 sm:gap-4 mb-2">
                    <div v-for="vowel in alphabetByType.vowels" :key="vowel.letter"
                        class="aspect-square rounded-lg border border-slate-600 bg-slate-800/80 hover:bg-slate-700 flex flex-col items-center justify-center p-1 transition-all cursor-pointer sm:rounded-xl"
                        @click="$emit('selectAlphabetLetter', vowel)">
                        <span class="text-xs font-medium uppercase tracking-wide text-white sm:text-base">
                            {{ vowel.letter }}
                        </span>
                    </div>
                </div>
            </div>

            <!-- Sección de Consonantes -->
            <div class="rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6">
                <h3 class="text-lg font-semibold text-cyan-400 mb-4 text-center">Consonantes</h3>

                <div class="grid grid-cols-4 gap-2 sm:gap-4 mb-2">
                    <div v-for="consonant in alphabetByType.consonants" :key="consonant.letter"
                        class="aspect-square rounded-lg border border-slate-600 bg-slate-800/80 hover:bg-slate-700 flex flex-col items-center justify-center p-1 transition-all cursor-pointer sm:rounded-xl"
                        @click="$emit('selectAlphabetLetter', consonant)">
                        <span class="text-xs font-medium uppercase tracking-wide text-white sm:text-base">
                            {{ consonant.letter }}
                        </span>
                    </div>
                </div>
            </div>

            <!-- Sección de Sonidos Eyectivos -->
            <div v-if="alphabetByType.ejectives.length > 0"
                class="rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6">
                <h3 class="text-lg font-semibold text-cyan-400 mb-4 text-center">Sonidos Eyectivos</h3>
                <p class="text-sm text-slate-400 mb-4 text-center">Sonidos glotalizados característicos</p>

                <div class="grid grid-cols-4 gap-2 sm:gap-4 mb-2">
                    <div v-for="ejective in alphabetByType.ejectives" :key="ejective.letter"
                        class="aspect-square rounded-lg border border-slate-600 bg-slate-800/80 hover:bg-slate-700 flex flex-col items-center justify-center p-1 transition-all cursor-pointer sm:rounded-xl"
                        @click="$emit('selectAlphabetLetter', ejective)">
                        <span class="text-xs font-medium uppercase tracking-wide text-white sm:text-base">
                            {{ ejective.letter }}
                        </span>
                        <span class="text-[9px] text-slate-400 sm:text-sm">
                            {{ ejective.pronunciation }}
                        </span>
                    </div>
                </div>
            </div>

            <!-- Sección de Vocales Largas -->
            <div v-if="writingSystem === 'alphabet' && alphabetByType.longVowels.length > 0"
                class="rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6">
                <h3 class="text-lg font-semibold text-cyan-400 mb-4 text-center">Vocales Largas</h3>
                <p class="text-sm text-slate-400 mb-4 text-center">Vocales con duración extendida</p>

                <div class="grid grid-cols-5 gap-2 sm:gap-4 mb-2">
                    <div v-for="longVowel in alphabetByType.longVowels" :key="longVowel.letter"
                        class="aspect-square rounded-lg border border-slate-600 bg-slate-800/80 hover:bg-slate-700 flex flex-col items-center justify-center p-1 transition-all cursor-pointer sm:rounded-xl"
                        @click="$emit('selectAlphabetLetter', longVowel)">
                        <span class="text-xs font-medium uppercase tracking-wide text-white sm:text-base">
                            {{ longVowel.letter }}
                        </span>
                        <span class="text-[9px] text-slate-400 mt-0.5 sm:text-sm">
                            {{ longVowel.pronunciation }}
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- HAY QUE VER LA MANERA DE HACERLOS MODULARES, DEPENDIENDO DEL SISTEMA DE ESCRITURA -->

    </div>
</template>

<script setup>
import { computed } from 'vue';

// Props
const props = defineProps({
    writingSystem: {
        type: String,
        required: true
    },
    syllabaryData: {
        type: Array,
        default: () => []
    },
    vowelsData: {
        type: Object,
        default: () => ({})
    },
    longVowels: {
        type: [Object, null],
        default: null
    },
    basicConsonants: {
        type: Array,
        default: () => []
    },
    specialCombinations: {
        type: Array,
        default: () => []
    },
    alphabetByType: {
        type: Object,
        default: () => ({ vowels: [], consonants: [], ejectives: [], longVowels: [] })
    },
    totalLetters: {
        type: Number,
        default: 0
    }
});

// Emits
const emit = defineEmits([
    'selectVowel',
    'selectSyllable',
    'selectLetter',
    'selectEmpty',
    'selectLongVowel',
    'selectAlphabetLetter'
]);

// Computed - Vocales disponibles para mostrar
const availableVowels = computed(() => {
    if (props.writingSystem !== 'syllabary') return ['a', 'e', 'i', 'o', 'u'];

    // Obtener las vocales disponibles del objeto vowelsData
    return Object.keys(props.vowelsData || {}).filter(vowel =>
        props.vowelsData[vowel] !== null && props.vowelsData[vowel] !== undefined
    );
});

// Computed - Todas las vocales posibles (para dígrafos)
const allVowels = computed(() => {
    return ['a', 'e', 'i', 'o', 'u'];
});

const filteredLongVowels = computed(() => {
    if (!props.longVowels) return {};
    return Object.entries(props.longVowels)
        .filter(([_, value]) => value)
        .reduce((acc, [key, value]) => {
            acc[key] = value;
            return acc;
        }, {});
});

// Funciones auxiliares
const getVowelDisplay = (vowel) => {
    if (props.writingSystem !== 'syllabary') return vowel;
    return props.vowelsData[vowel] || vowel;
};

const getSyllableText = (syllable) => {
    return syllable.split(' ')[0];
};

const getPronunciation = (syllable) => {
    const match = syllable.match(/\(([^)]+)\)/);
    return match ? match[1] : '';
};

const getLongVowelPronunciation = (vowel) => {
    const baseVowel = props.vowelsData[vowel] || vowel;
    return `${baseVowel}${baseVowel}`;
};
</script>