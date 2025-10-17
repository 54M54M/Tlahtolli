<template>
    <div class="mx-auto max-w-4xl">
        <h1 class="mb-6 text-center text-2xl font-bold text-white sm:text-4xl">Silabario Náhuatl</h1>

        <!-- Grid del silabario -->
        <div class="mb-6 rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6">

            <!-- Filas de consonantes y sílabas -->
            <div v-for="entry in silabaryEntries" :key="entry.letter || 'vowels'"
                class="grid grid-cols-6 gap-2 sm:gap-4 mb-2">

                <!-- Columna de letra -->
                <div v-if="entry.letter"
                    class="aspect-square uppercase rounded-lg border border-slate-600 bg-slate-800/80 hover:bg-slate-700 flex items-center justify-center font-bold text-white text-sm sm:text-lg transition-all sm:rounded-xl relative"
                    @click="selectLetter(entry)">
                    {{ entry.letter }}
                </div>
                <div v-else @click="selectEmpty()">
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
        </div>

        <!-- Panel de información dinámica -->
        <div class="rounded-2xl bg-slate-800/60 p-4 backdrop-blur-sm sm:p-6 mb-6">
            <!-- Información de sílaba seleccionada -->
            <div v-if="selectedSyllableInfo" class="text-slate-300">
                <!-- Título dinámico para silabas / vocales -->
                <h2 v-if="!selectedSyllableInfo.letter" class="text-xl font-semibold text-cyan-400 mb-4 text-center">
                    Vocales
                </h2>
                <h2 v-else class="text-xl font-semibold text-cyan-400 mb-4 text-center">
                    Sílabas con "{{ selectedSyllableInfo.letter }}"
                </h2>

                <h4 class="text-slate-400 text-xs text-center"> POR AHORA SON SOLO EJEMPLOS DADOS POR LA I.A. </h4>
                <h4 class="text-slate-400 text-xs mb-3 text-center"> SE CORREGIRAN CONFORME AVANCE EL PROYECTO </h4>

                <!-- Grid corregido - solo muestra vocales con sílabas -->
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-4">
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
                            <span>ho (jo)</span>
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

// Función para obtener solo las vocales que tienen sílabas disponibles
const getAvailableVowels = (syllableInfo) => {
    if (!syllableInfo || !syllableInfo.syllables) return [];
    return vowels.filter(vowel => syllableInfo.syllables[vowel]);
};

const selectSyllable = (entry, vowel) => {
    selectedSyllableInfo.value = {
        letter: entry.letter,
        pronunciation: entry.pronunciation,
        syllables: entry.syllables
    };
    showNotes.value = false;
};

const selectLetter = (entry) => {
    selectedSyllableInfo.value = {
        letter: entry.letter,
        pronunciation: entry.pronunciation,
        syllables: entry.syllables
    };
    showNotes.value = false;
};

const selectEmpty = () => {
    selectedSyllableInfo.value = null;
    showNotes.value = true;
};

const getSyllableText = (syllable) => {
    return syllable.split(' ')[0];
};

const getPronunciation = (syllable) => {
    const match = syllable.match(/\(([^)]+)\)/);
    return match ? match[1] : '';
};

const getSyllableExamples = (letter, vowel) => {
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