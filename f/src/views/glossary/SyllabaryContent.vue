<template>
    <div class="mx-auto max-w-4xl">

        <!-- Grid del silabario -->
        <div class="mb-6 rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6">

            <!-- Vocales -->
            <div class="grid grid-cols-6 gap-2 sm:gap-4 mb-2">
                <!-- Columna vacía para alineación -->
                <div></div>
                <!-- Sílabas vocales -->
                <div v-for="vowel in vowels" :key="vowel"
                    class="aspect-square rounded-lg border border-slate-600 bg-slate-800/80 hover:bg-slate-700 flex flex-col items-center justify-center p-1 transition-all cursor-pointer sm:rounded-xl"
                    @click="selectVowel(vowel)">
                    <span class="text-xs font-medium uppercase tracking-wide text-white sm:text-base">
                        {{ vowel }}
                    </span>
                </div>
            </div>

            <!-- Consonantes básicas -->
            <div v-for="entry in basicConsonants" :key="entry.letter" class="grid grid-cols-6 gap-2 sm:gap-4 mb-2">

                <!-- Columna de letra -->
                <div class="aspect-square uppercase rounded-lg border border-slate-600 bg-slate-800/80 hover:bg-slate-700 flex items-center justify-center font-bold text-white text-sm sm:text-lg transition-all sm:rounded-xl relative"
                    @click="selectLetter(entry)">
                    {{ entry.letter }}
                </div>

                <!-- Sílabas para cada vocal -->
                <div v-for="vowel in vowels" :key="vowel" :class="[
                    'aspect-square rounded-lg border flex flex-col items-center justify-center p-1 transition-all cursor-pointer sm:rounded-xl',
                    !entry.syllables[vowel]
                        ? 'bg-slate-700/50 border-slate-600 cursor-default'
                        : 'bg-slate-800/80 hover:bg-slate-700 border-slate-600'
                ]" @click="entry.syllables[vowel] ? selectSyllable(entry, vowel) : selectEmpty()">
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

            <!-- Separador para combinaciones especiales -->
            <div class="max-w-md w-full">
                <div class="col-span-6 my-6">
                    <div class="relative">
                        <!-- Línea completa detrás -->
                        <div class="absolute inset-0 flex items-center" aria-hidden="true">
                            <div class="w-full border-t border-slate-600"></div>
                        </div>

                        <!-- Contenedor del texto centrado -->
                        <div class="relative flex justify-center">
                            <div class="flex flex-col items-center bg-[#162639] px-4">
                                <span class="text-sm text-slate-500 -mb-1">Fonemas Unitarios</span>
                                <span class="text-xs text-slate-500">Dígrafos</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Combinaciones especiales -->
            <div v-for="entry in specialCombinations" :key="entry.letter" class="grid grid-cols-6 gap-2 sm:gap-4 mb-2">

                <!-- Columna de letra -->
                <div class="aspect-square uppercase rounded-lg border border-slate-600 bg-slate-800/80 hover:bg-slate-700 flex items-center justify-center font-bold text-white text-sm sm:text-lg transition-all sm:rounded-xl relative"
                    @click="selectLetter(entry)">
                    {{ entry.letter }}
                </div>

                <!-- Sílabas para cada vocal -->
                <div v-for="vowel in vowels" :key="vowel" :class="[
                    'aspect-square rounded-lg border flex flex-col items-center justify-center p-1 transition-all cursor-pointer sm:rounded-xl',
                    !entry.syllables[vowel]
                        ? 'bg-slate-700/50 border-slate-600 cursor-default'
                        : 'bg-slate-800/80 hover:bg-slate-700 border-slate-600'
                ]" @click="entry.syllables[vowel] ? selectSyllable(entry, vowel) : selectEmpty()">
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

            <!-- Separador para vocales largas -->
            <div class="max-w-md w-full">
                <div class="col-span-6 my-6">
                    <div class="relative">
                        <!-- Línea completa detrás -->
                        <div class="absolute inset-0 flex items-center" aria-hidden="true">
                            <div class="w-full border-t border-slate-600"></div>
                        </div>

                        <!-- Contenedor del texto centrado -->
                        <div class="relative flex justify-center">
                            <div class="flex flex-col items-center bg-[#162639] px-4">
                                <span class="text-sm text-slate-500 -mb-1">Vocales Largas</span>
                                <span class="text-xs text-slate-500">Duración extendida</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Vocales largas -->
            <div class="grid grid-cols-4 gap-2 sm:gap-4 mb-2">
                <!-- Sílabas vocales largas -->
                <div v-for="vowel in vowels.filter(v => getLongVowel(v))" :key="'long-' + vowel"
                    class="aspect-square rounded-lg border border-slate-600 bg-slate-800/80 hover:bg-slate-700 flex flex-col items-center justify-center p-1 transition-all cursor-pointer sm:rounded-xl"
                    @click="selectLongVowel(vowel)">
                    <span class="text-xs font-medium uppercase tracking-wide text-white sm:text-base">
                        {{ getLongVowel(vowel) }}
                    </span>
                    <span class="text-[9px] text-slate-400 mt-0.5 sm:text-sm">
                        {{ getLongVowelPronunciation(vowel) }}
                    </span>
                </div>
            </div>
        </div>

        <!-- Panel de información dinámica -->
        <div class="rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6 mb-6">
            <!-- Información de sílaba seleccionada -->
            <div v-if="selectedSyllableInfo" class="text-slate-300">
                <!-- Título dinámico para silabas / vocales -->
                <h2 v-if="!selectedSyllableInfo.letter" class="text-xl font-semibold text-cyan-400 mb-4 text-center">
                    {{ selectedSyllableInfo.isLongVowel ? 'Vocales Largas' : 'Vocales' }}
                </h2>
                <h2 v-else class="text-xl font-semibold text-cyan-400 mb-4 text-center">
                    Sílabas con "{{ selectedSyllableInfo.letter }}"
                </h2>

                <h4 class="text-slate-400 text-xs text-center"> POR AHORA SON SOLO EJEMPLOS DADOS POR LA I.A. </h4>
                <h4 class="text-slate-400 text-xs mb-3 text-center"> SE CORREGIRAN CONFORME AVANCE EL PROYECTO </h4>

                <!-- Descripción especial para la vocal U -->
                <div v-if="!selectedSyllableInfo.letter && selectedSyllableInfo.syllables['u']"
                    class="bg-slate-700/50 rounded-lg p-6 border border-slate-600 mb-4">
                    <h3 class="font-bold text-white text-lg mb-4 text-center">Uso de la "u" en Náhuatl</h3>

                    <div class="space-y-4 text-sm">
                        <p class="text-slate-300">
                            En el náhuatl, la letra "u" no existe como una vocal independiente. El sonido similar al de
                            la "u"
                            del español se representa de manera distinta según el contexto.
                        </p>

                        <div class="bg-slate-600/30 rounded-lg p-4">
                            <h4 class="font-semibold text-cyan-400 mb-3">Su uso más común es:</h4>

                            <div class="space-y-3">
                                <div>
                                    <p class="font-medium text-white">"hu":</p>
                                    <p class="text-slate-300 ml-2">
                                        Para representar el sonido de la "w" del inglés (como en <em>we</em>), o el
                                        sonido de la
                                        "u" en la palabra "huevo".
                                        Por ejemplo, en el nombre <span class="text-cyan-300">Huitzilopochtli</span>, la
                                        pronunciación es "Witsilopochtli".
                                    </p>
                                </div>

                                <div>
                                    <p class="font-medium text-white">"cu":</p>
                                    <p class="text-slate-300 ml-2">
                                        Esta combinación de letras representa un sonido especial que se parece a la "cu"
                                        de la
                                        palabra inglesa <em>queen</em>.
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="bg-slate-600/30 rounded-lg p-4">
                            <h4 class="font-semibold text-cyan-400 mb-2">Ejemplos:</h4>
                            <ul class="list-disc list-inside space-y-2 text-slate-300">
                                <li><span class="text-cyan-300">Huei</span> (grande) - se pronuncia "wei"</li>
                                <li><span class="text-cyan-300">Cua</span> (comer) - se pronuncia "kwa"</li>
                                <li><span class="text-cyan-300">Huehue</span> (anciano) - se pronuncia "wehwe"</li>
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Grid adaptable según la cantidad de elementos -->
                <div v-if="!(!selectedSyllableInfo.letter && selectedSyllableInfo.syllables['u'])" :class="[
                    'grid gap-4 mb-4',
                    getAvailableVowels(selectedSyllableInfo).length === 1 ? 'grid-cols-1 max-w-md mx-auto' : // 1 elemento
                        getAvailableVowels(selectedSyllableInfo).length === 2 ? 'grid-cols-1 sm:grid-cols-2 max-w-2xl mx-auto' : // mobil
                            getAvailableVowels(selectedSyllableInfo).length >= 4 ? 'grid-cols-1 sm:grid-cols-2 lg:grid-cols-2' : // desktop
                                'grid-cols-1 sm:grid-cols-2'
                ]">
                    <div v-for="vowel in getAvailableVowels(selectedSyllableInfo)" :key="vowel"
                        class="bg-slate-700/50 rounded-lg p-3 border border-slate-600">
                        <h3 class="font-bold text-white text-lg mb-2">
                            {{ getSyllableText(selectedSyllableInfo.syllables[vowel]) }}
                        </h3>
                        <p v-if="getPronunciation(selectedSyllableInfo.syllables[vowel])"
                            class="text-slate-400 text-sm mb-2">
                            Pronunciación: {{ getPronunciation(selectedSyllableInfo.syllables[vowel]) }}
                        </p>
                        <div v-if="getSyllableExamples(selectedSyllableInfo.letter, vowel).length > 0"
                            class="mt-2 text-xs text-slate-300">
                            <p class="font-semibold">Ejemplos ({{ getSyllableExamples(selectedSyllableInfo.letter,
                                vowel).length }}):</p>
                            <ul class="list-disc list-inside mt-1 space-y-1">
                                <li v-for="example in getSyllableExamples(selectedSyllableInfo.letter, vowel)"
                                    :key="example.spanish + example.central">
                                    <span class="font-medium">{{ example.spanish }}</span> -
                                    <span class="text-cyan-300">{{ example.central }}</span>
                                    <span class="text-slate-400 text-xs block ml-4">
                                        Ej: {{ example.example }}
                                    </span>
                                </li>
                            </ul>
                        </div>
                        <div v-else class="mt-2 text-xs text-slate-400 italic">
                            Aun no hay ejemplos disponibles para esta sílaba
                        </div>
                    </div>
                </div>

                <div v-if="selectedSyllableInfo.notes"
                    class="bg-slate-700/30 rounded-lg p-3 border border-slate-600 mt-4">
                    <h3 class="font-semibold text-cyan-400 mb-2">Notas importantes:</h3>
                    <p class="text-sm">{{ selectedSyllableInfo.notes }}</p>
                </div>
            </div>

            <!-- Notas generales -->
            <div v-if="!selectedSyllableInfo" class="text-slate-300">
                <h2 class="text-xl font-semibold text-cyan-400 mb-4 text-center">Notas sobre el Silabario</h2>
                <div class="space-y-4 text-sm sm:text-base">
                    <div>
                        <p class="font-semibold text-cyan-400 mb-2">Pronunciación de la "H"</p>
                        <p class="mb-2">La "H" es muda si existe diptongo (ua, ue, ui)</p>
                        <p class="text-center text-slate-400 text-sm italic">Ci hua tl = Mujer</p>
                    </div>

                    <div>
                        <p class="mb-2">La "H" es "J" si no existe diptongo</p>
                        <p class="text-center text-slate-400 text-sm italic">Tla zo h tla = Amar</p>
                    </div>

                    <div class="pt-4 border-t border-slate-600">
                        <p class="font-semibold text-cyan-400 mb-3">Sílabas omitidas</p>
                        <p class="mb-3">No son de uso común en el náhuatl moderno:</p>

                        <div class="grid grid-cols-2 sm:grid-cols-3 gap-2 text-center text-slate-400">
                            <span>hi (ji)</span>

                            <span>hu (ju)</span>
                            <span>lu</span>
                            <span>nu</span>
                            <span>zi</span>
                            <span>tlu</span>
                            <span>qua</span>
                            <span>quo</span>
                            <span>huo (wo)</span>
                        </div>

                        <p class="mt-4 text-slate-400 text-sm">
                            Si bien se pueden encontrar en algunas palabras de origen clásico o préstamos lingüísticos.
                            Estaremos trabajando para incluir estas sílabas en futuras actualizaciones.
                        </p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</template>

<script setup>
import { silabaryEntries, dictionaryEntries } from "../../lib/data.js";
import { ref, computed } from 'vue';

const vowels = ['a', 'e', 'i', 'o', 'u'];
const selectedSyllableInfo = ref(null);
const showNotes = ref(false);

// Separar las entradas en consonantes básicas y combinaciones especiales (usando minúsculas)
const basicConsonants = computed(() => {
    const basicLetters = ['c', 'h', 'l', 'm', 'n', 'p', 't', 'x', 'y', 'z'];
    return silabaryEntries.filter(entry => basicLetters.includes(entry.letter));
});

const specialCombinations = computed(() => {
    const specialLetters = ['tl', 'tz', 'ch', 'qu', 'hu'];
    return silabaryEntries.filter(entry => specialLetters.includes(entry.letter));
});

// Función para obtener solo las vocales que tienen sílabas disponibles
const getAvailableVowels = (syllableInfo) => {
    if (!syllableInfo || !syllableInfo.syllables) return [];
    return vowels.filter(vowel => syllableInfo.syllables[vowel]);
};

const selectVowel = (vowel) => {
    selectedSyllableInfo.value = {
        letter: null,
        pronunciation: getVowelPronunciation(vowel),
        syllables: {
            [vowel]: `${vowel} (${getVowelPronunciation(vowel)})`
        },
        isLongVowel: false
    };
    showNotes.value = false;
};

const selectSyllable = (entry, vowel) => {
    selectedSyllableInfo.value = {
        letter: entry.letter,
        pronunciation: entry.pronunciation,
        syllables: entry.syllables,
        isLongVowel: false
    };
    showNotes.value = false;
};

const selectLetter = (entry) => {
    selectedSyllableInfo.value = {
        letter: entry.letter,
        pronunciation: entry.pronunciation,
        syllables: entry.syllables,
        isLongVowel: false
    };
    showNotes.value = false;
};

const selectEmpty = () => {
    selectedSyllableInfo.value = null;
    showNotes.value = true;
};

const selectLongVowel = (vowel) => {
    selectedSyllableInfo.value = {
        letter: null,
        pronunciation: getLongVowelPronunciation(vowel),
        syllables: {
            [vowel]: `${getLongVowel(vowel)} (${getLongVowelPronunciation(vowel)})`
        },
        isLongVowel: true
    };
    showNotes.value = false;
};

const getSyllableText = (syllable) => {
    return syllable.split(' ')[0];
};

const getPronunciation = (syllable) => {
    const match = syllable.match(/\(([^)]+)\)/);
    return match ? match[1] : '';
};

const getVowelPronunciation = (vowel) => {
    const pronunciations = {
        'a': null,
        'e': null,
        'i': null,
        'o': null,
        'u': null
    };
    return pronunciations[vowel] || '';
};

// Obtener vocal larga
const getLongVowel = (vowel) => {
    const longVowelEntry = silabaryEntries.find(entry => entry.longVowel);
    return longVowelEntry ? longVowelEntry.longVowel[vowel] : null;
};

// Pronunciación de vocales largas
const getLongVowelPronunciation = (vowel) => {
    const pronunciations = {
        'a': 'aa',
        'e': 'ee',
        'i': 'ii',
        'o': 'oo'
    };
    return pronunciations[vowel] || '';
};

const getSyllableExamples = (letter, vowel) => {
    // Si es vocal larga (letter es undefined o vacío y vowel tiene macrón)
    if (!letter && vowel && (vowel.includes('ā') || vowel.includes('ē') || vowel.includes('ī') || vowel.includes('ō'))) {
        const targetSyllable = vowel;
        console.log(`Buscando vocal larga: ${targetSyllable}`);

        // Buscar palabras que contengan la vocal larga
        const examples = dictionaryEntries.filter(entry => {
            const central = entry.central;
            const oriental = entry.oriental;
            const occidental = entry.occidental;

            return central.includes(targetSyllable) ||
                oriental.includes(targetSyllable) ||
                occidental.includes(targetSyllable);
        });

        console.log(`Encontrados ${examples.length} ejemplos para vocal larga ${targetSyllable}`);
        return examples.slice(0, 5);
    }

    // Si es vocal (letter es undefined o vacío)
    if (!letter) {
        const targetSyllable = vowel; // Para vocales, la sílaba es solo la vocal
        console.log(`Buscando vocal: ${targetSyllable}`);

        // Buscar palabras que comiencen con la vocal
        const examples = dictionaryEntries.filter(entry => {
            const central = entry.central.toLowerCase();
            const oriental = entry.oriental.toLowerCase();
            const occidental = entry.occidental.toLowerCase();

            return central.startsWith(targetSyllable) ||
                oriental.startsWith(targetSyllable) ||
                occidental.startsWith(targetSyllable);
        });

        console.log(`Encontrados ${examples.length} ejemplos para vocal ${targetSyllable}`);
        return examples.slice(0, 5);
    }

    // Para consonantes (lógica original)
    const syllableEntry = silabaryEntries.find(entry => entry.letter === letter);
    if (!syllableEntry || !syllableEntry.syllables[vowel]) return [];

    const targetSyllable = getSyllableText(syllableEntry.syllables[vowel]).toLowerCase();

    console.log(`Buscando sílaba: ${targetSyllable}`);

    const examples = dictionaryEntries.filter(entry => {
        const central = entry.central.toLowerCase();
        const oriental = entry.oriental.toLowerCase();
        const occidental = entry.occidental.toLowerCase();

        return central.includes(targetSyllable) ||
            oriental.includes(targetSyllable) ||
            occidental.includes(targetSyllable);
    });

    console.log(`Encontrados ${examples.length} ejemplos para ${targetSyllable}`);
    return examples.slice(0, 5);
};
</script>