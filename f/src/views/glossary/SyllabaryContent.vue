<template>
    <div class="min-h-screen bg-[#1f2937] rounded-lg text-gray-100 p-6">
        <h1 class="text-2xl font-semibold mb-6 text-center">Silabario Náhuatl</h1>

        <!-- Filas para cada letra -->
        <div v-for="entry in silabaryEntries" :key="entry.letter" class="grid grid-cols-6 gap-4 max-w-4xl mx-auto mb-4">
            <!-- Columna de letra -->
            <div v-if="entry.letter"
                class="border-[#37464f] border-[2px] hover:bg-[#445666] uppercase rounded-lg flex items-center justify-center py-4 font-bold text-lg">
                {{ entry.letter }}
            </div>
            <div v-else></div>

            <!-- Sílabas para cada vocal -->
            <div v-for="vowel in vowels" :key="vowel" :class="[
                'border-[#37464f] border-[2px] transition-all rounded-lg flex flex-col items-center justify-center py-4 shadow-md',
                !entry.syllables[vowel] ? 'bg-[#37464f]' : 'hover:bg-[#445666]',
            ]">
                <template v-if="entry.syllables[vowel]">
                    <span class="text-lg font-medium uppercase tracking-wide">
                        {{ entry.syllables[vowel].split(' ')[0] }}
                    </span>
                    <span class="text-sm text-gray-400">
                        {{ entry.syllables[vowel].split('(')[1]?.replace(')', '') || '' }}
                    </span>
                </template>
                <div v-else>
                </div>
            </div>
        </div>
    </div>

    <div class="bg-[#1f2937] rounded-lg text-gray-100 mt-8 p-6">
        <h1 class="text-2xl font-semibold mb-6 text-center">Notas sobre el Silabario</h1>

        <p class="max-w-4xl mx-auto text-gray-400">
            La "H" es muda si existe diptongo (ua, ue, ui) <br>
            <span class="text-center block">Ci hua tl = Mujer</span> <br>
            
            La "H" es "J" si no existe diptongo <br>
            <span class="text-center block">Tla zo h tla = Amar</span> <br>
        </p>

        <p class="max-w-4xl mx-auto text-gray-400">
            En este silabario se han omitido las siguientes sílabas por no ser de uso común en el náhuatl: <br>
            
            <span class="text-center block">hi (ji), ho (jo), hu (ju)</span>
            <span class="text-center block">lu, nu, zi, tlu, qua, quo</span>
            <span class="text-center block">huo (wo)</span><br>

            Si bien se pueden encontrar en algunas palabras de origen clásico o préstamos lingüísticos.
            Estaremos trabajando para incluir estas sílabas en futuras actualizaciones.
        </p>

    </div>

</template>

<script setup>
import { silabaryEntries } from "../../lib/data.js";

const vowels = ['a', 'e', 'i', 'o', 'u'];
</script>