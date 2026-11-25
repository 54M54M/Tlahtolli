<template>
    <!-- Los espacios entre palabras son segmentos normales (" "): ahí el texto puede saltar de línea dentro de
         la burbuja. Antes además se agregaba un &nbsp; por palabra: doble espacio y saltos raros. -->
    <span class="processed-text">
        <template v-for="(segment, index) in processedSegments" :key="index">
            <template v-if="segment.isWord && segment.hasPronunciation && exerciseType !== 'fill-blank'">
                <!-- DEBUG: Agrega un estilo temporal para ver quÃ© palabras tienen tooltip -->
                <!-- <span style="background-color: yellow; color: black">[TOOLTIP]</span> -->
                <PronunciationTooltip :word="segment.text" :pronunciation="segment.pronunciation"
                    :translation="segment.translation" :example="segment.example" :breakdown="segment.breakdown" :language="language"
                    :show-result="showResult" :is-correct="isCorrect">
                    {{ segment.text }}
                </PronunciationTooltip>
            </template>
            <template v-else>
                <!-- DEBUG: Palabras sin tooltip -->
                <!-- <span style="background-color: lightgray">[NO-TOOLTIP]</span> -->
                <span :class="{
                    'border-b-2 border-dotted border-gray-400': segment.isWord && exerciseType !== 'fill-blank'
                }">
                    {{ segment.text }}
                </span>
            </template>
        </template>
    </span>

    <!-- <span class="processed-text">
        <template v-for="(segment, index) in processedSegments" :key="index">
            <template v-if="segment.isWord && segment.hasPronunciation && exerciseType !== 'fill-blank'">
                <PronunciationTooltip :word="segment.text" :pronunciation="segment.pronunciation"
                    :translation="segment.translation" :example="segment.example" :breakdown="segment.breakdown" :language="language"
                    :show-result="showResult" :is-correct="isCorrect">
                    {{ segment.text }}
                </PronunciationTooltip>
            </template>
            <template v-else>
                <span :class="{
                    'border-b-2 border-dotted border-gray-400': segment.isWord && exerciseType !== 'fill-blank'
                }">
                    {{ segment.text }}
                </span>
            </template>
            <span v-if="segment.spaceAfter">&nbsp;</span>
        </template>
    </span> -->

</template>

<script>
import PronunciationTooltip from './PronunciationTooltip.vue';

export default {
    name: 'ProcessedText',
    components: {
        PronunciationTooltip
    },
    props: {
        text: {
            type: String,
            required: true
        },
        language: {
            type: String,
            required: true
        },
        vocabulary: {
            type: [Array, Object], // Acepta tanto array como objeto
            default: () => []
        },
        showResult: {
            type: Boolean,
            default: false
        },
        isCorrect: {
            type: Boolean,
            default: false
        },
        exerciseType: {
            type: String,
            default: 'multiple-choice' // Valor por defecto
        }
    },
    data() {
        return {
            processedSegments: []
        };
    },
    watch: {
        text: {
            immediate: true,
            handler(newText) {
                this.processText(newText);
            }
        },
        language: {
            handler() {
                this.processText(this.text);
            }
        },
        vocabulary: {
            handler() {
                this.processText(this.text);
            },
            deep: true
        }
    },
    methods: {
        processText(text) {
            if (!text) {
                this.processedSegments = [];
                return;
            }

            // console.log('🔍 Procesando texto:', text);
            // console.log('📚 Vocabulario disponible:', this.vocabulary);

            const segments = [];
            // Dividir por espacios y mantener la puntuación
            const words = text.split(/(\s+|[.,!?;:])/);

            for (let i = 0; i < words.length; i++) {
                const word = words[i];

                // Si es espacio o puntuación, agregar como texto normal
                if (word.trim() === '' || /^[.,!?;:]$/.test(word)) {
                    segments.push({
                        text: word,
                        isWord: false,
                        hasPronunciation: false,
                        spaceAfter: false
                    });
                    continue;
                }

                // Buscar en el vocabulario de la unidad
                const vocabularyItem = this.findInVocabulary(word);

                // console.log(`🔎 Buscando: "${word}" → Encontrado:`, vocabularyItem);

                segments.push({
                    text: word,
                    isWord: true,
                    hasPronunciation: !!vocabularyItem,
                    pronunciation: vocabularyItem?.pronunciation || '',
                    translation: vocabularyItem?.translation || '',
                    example: vocabularyItem?.example || '',
                    breakdown: vocabularyItem?.breakdown || '',
                    spaceAfter: i < words.length - 1 && words[i + 1]?.trim() === ''
                });
            }

            // console.log('📝 Segmentos procesados:', segments);
            this.processedSegments = segments;
        },
        findInVocabulary(word) {
            // Convertir vocabulario a array si es un objeto
            const vocabularyArray = Array.isArray(this.vocabulary)
                ? this.vocabulary
                : Object.keys(this.vocabulary || {}).map(key => ({
                    word: key,
                    ...this.vocabulary[key]
                }));

            if (!vocabularyArray || vocabularyArray.length === 0) {
                // console.log('❌ No hay vocabulario disponible');
                return null;
            }

            // Limpiar la palabra (quitar puntuación y convertir a minúsculas)
            const cleanWord = word.replace(/[.,!?;:"]/g, '').toLowerCase().trim();
            // console.log(`🔄 Buscando: "${word}" → Limpia: "${cleanWord}"`);

            // 1. Buscar coincidencia exacta en la palabra náhuatl
            const exactMatch = vocabularyArray.find(item =>
                item.word.toLowerCase() === cleanWord
            );

            if (exactMatch) {
                // console.log('✅ Coincidencia exacta en náhuatl:', exactMatch);
                return exactMatch;
            }

            // 2. Buscar en la traducción (español) - MEJORADO CON COMPARACIÓN CASE-INSENSITIVE
            const translationMatch = vocabularyArray.find(item => {
                if (!item.translation) return false;

                // Limpiar y normalizar la traducción
                const cleanTranslation = item.translation
                    .toLowerCase()
                    .replace(/[.,!?;:/]/g, '') // Remover puntuación y caracteres especiales
                    .trim();

                // Normalizar la palabra de entrada
                const normalizedWord = cleanWord.toLowerCase();

                // Buscar coincidencia exacta en traducción normalizada
                if (cleanTranslation === normalizedWord) {
                    return true;
                }

                // Buscar si la palabra está contenida en la traducción (mejorado)
                if (cleanTranslation.includes(normalizedWord)) {
                    return true;
                }

                // Buscar si la traducción está contenida en la palabra
                if (normalizedWord.includes(cleanTranslation)) {
                    return true;
                }

                // Para casos como "Buenos días" vs "Buen día" - dividir en palabras
                const translationWords = cleanTranslation.split(/\s+/);
                const inputWords = normalizedWord.split(/\s+/);

                // Buscar coincidencias de palabras individuales
                for (const inputWord of inputWords) {
                    for (const translationWord of translationWords) {
                        // Coincidencia exacta de palabra individual
                        if (inputWord === translationWord && inputWord.length > 2) {
                            return true;
                        }

                        // Coincidencia parcial para palabras similares
                        if (inputWord.includes(translationWord) && translationWord.length > 2) {
                            return true;
                        }

                        if (translationWord.includes(inputWord) && inputWord.length > 2) {
                            return true;
                        }
                    }
                }

                return false;
            });

            if (translationMatch) {
                // console.log('✅ Coincidencia en traducción:', translationMatch);
                return translationMatch;
            }

            // 3. Buscar coincidencia parcial en palabra náhuatl (solo si la palabra es suficientemente larga)
            if (cleanWord.length > 2) {
                const partialMatch = vocabularyArray.find(item =>
                    item.word.toLowerCase().includes(cleanWord) ||
                    cleanWord.includes(item.word.toLowerCase())
                );

                if (partialMatch) {
                    // console.log('⚠️ Coincidencia parcial:', partialMatch);
                    return partialMatch;
                }
            }

            // console.log('❌ No se encontró coincidencia para:', cleanWord);
            return null;
        }
    }
}
</script>

<style scoped>
.processed-text {
    word-wrap: break-word;
    line-height: 1.5;
}
</style>