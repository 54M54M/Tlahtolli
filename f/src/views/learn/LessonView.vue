<template>
    <div class="text-white pt-[15%] flex flex-col ">
        <!-- Header con información dinámica -->
        <Header variant="progress" :subtitle="`Nivel ${currentLevel.id}, Unidad ${currentUnit.id}`"
            :progressCurrent="currentQuestion - 1" :progressTotal="currentExercises.length"
            :backRoute="`/nivel/${currentLevel.id}`" />

        <!-- Contenido centrado verticalmente SIN scroll -->
        <div class="flex-1 flex items-center justify-center px-4 overflow-hidden">
            <div class="w-full max-w-2xl">
                <!-- Mostrar ejercicio actual -->
                <Card v-if="currentQuestion <= currentExercises.length">
                    <!-- Imagen placeholder para todos los ejercicios -->
                    <div class="flex justify-center mb-6">
                        <img :src="placeholder" alt="Ejercicio" class="w-48 h-48 object-cover rounded-lg bg-gray-700">
                    </div>

                    <h2 class="text-xl font-semibold mb-4">{{ currentExercise.question }}</h2>

                    <!-- Tipo: Selección múltiple -->
                    <div v-if="currentExercise.type === 'multiple-choice'" class="space-y-2">
                        <button v-for="(option, index) in currentExercise.options" :key="index"
                            @click="selectAnswer(index)" :class="{
                                'bg-blue-600': selectedAnswer === index,
                                'bg-gray-700': selectedAnswer !== index,
                                'bg-green-600': showResult && index === currentExercise.correctAnswer,
                                'bg-red-600': showResult && selectedAnswer === index && selectedAnswer !== currentExercise.correctAnswer
                            }" class="w-full text-left p-3 rounded-lg hover:bg-gray-600 transition-colors">
                            {{ option }}
                        </button>
                    </div>

                    <!-- Tipo: Completar espacio -->
                    <div v-else-if="currentExercise.type === 'fill-blank'">
                        <input v-model="textAnswer" type="text" :placeholder="currentExercise.placeholder"
                            class="w-full p-3 rounded-lg bg-gray-700 border border-gray-600 mb-2">
                        <p v-if="showResult" class="text-sm mb-2">
                            Respuesta correcta: <span class="font-bold">{{ currentExercise.correctAnswer }}</span>
                        </p>
                    </div>

                    <!-- Botón de verificación -->
                    <button @click="verifyAnswer" :disabled="(currentExercise.type === 'multiple-choice' && selectedAnswer === null) ||
                        (currentExercise.type === 'fill-blank' && !textAnswer)"
                        class="mt-4 bg-[#31771c] hover:bg-[#58cc02] text-white py-2 px-6 rounded-lg disabled:opacity-50">
                        {{ showResult ? 'Continuar' : 'Verificar' }}
                    </button>
                </Card>

                <!-- Mensaje de finalización -->
                <Card v-if="currentQuestion > currentExercises.length" class="text-center">
                    <h2 class="text-xl font-semibold mb-4">¡Lección completada!</h2>
                    <p class="mb-4">Has terminado todas las preguntas de esta lección.</p>
                    <router-link :to="`/nivel/${currentLevel.id}`">
                        <button class="mt-4 bg-[#31771c] hover:bg-[#58cc02] text-white py-2 px-6 rounded-lg">
                            Volver al nivel
                        </button>
                    </router-link>
                </Card>
            </div>
        </div>
    </div>
</template>

<script>
import Card from '../../components/Card.vue';
import Header from '../../components/vHeader.vue';
import { levels, levelUnits } from '../../lib/data.js';
import placeholder from '../../assets/300x300.png';

export default {
    name: "Lesson",
    components: {
        Card,
        Header,
    },
    props: {
        unitId: {
            type: [String, Number],
            required: true
        }
    },
    data() {
        return {
            currentQuestion: 1,
            selectedAnswer: null,
            textAnswer: '',
            showResult: false,
            currentExercises: [],
            currentLevel: {},
            currentUnit: {},
            placeholder: placeholder
        };
    },
    computed: {
        currentExercise() {
            return this.currentExercises[this.currentQuestion - 1] || {};
        }
    },
    created() {
        this.loadLessonData();
    },
    methods: {
        loadLessonData() {
            // Buscar la unidad y nivel correspondiente
            for (const levelId in levelUnits) {
                const units = levelUnits[levelId];
                const unit = units.find(u => u.id === Number(this.unitId));

                if (unit) {
                    this.currentUnit = unit;
                    this.currentLevel = levels.find(l => l.id === Number(levelId)) || {};

                    // Generar ejercicios basados en el contenido de la unidad
                    this.generateExercises(unit);
                    break;
                }
            }
        },
        generateExercises(unit) {
            // Ejercicios de vocabulario
            const vocabExercises = unit.vocabulary?.slice(0, 3).map((word, index) => ({
                type: 'multiple-choice',
                question: `¿Qué significa '${word.nahuatl}'?`,
                options: this.generateOptions(
                    word.spanish,
                    unit.vocabulary.filter((_, i) => i !== index).map(w => w.spanish)
                ),
                correctAnswer: 0
            })) || [];

            // Ejercicios de gramática - CORREGIDOS
            const grammarExercises = unit.grammar ? [{
                type: 'fill-blank',
                question: this.generateGrammarQuestion(unit.grammar),
                placeholder: "Escribe tu respuesta",
                correctAnswer: this.generateGrammarAnswer(unit.grammar)
            }] : [];

            this.currentExercises = [...vocabExercises, ...grammarExercises];
        },
        generateGrammarQuestion(grammarText) {
            // Crear una pregunta más específica basada en la gramática
            const sentences = grammarText.split('.');
            const firstSentence = sentences[0].trim();

            // Extraer palabras clave para crear una pregunta
            if (firstSentence.includes("saludos")) {
                return "¿Con qué palabra suelen comenzar los saludos en náhuatl?";
            } else if (firstSentence.includes("presentarte")) {
                return "¿Qué palabra usas para presentarte en náhuatl?";
            } else if (firstSentence.includes("preguntas")) {
                return "¿Dónde suelen ir las palabras interrogativas en náhuatl?";
            } else if (firstSentence.includes("pronombres")) {
                return "¿Cómo se forman los pronombres posesivos en náhuatl?";
            } else if (firstSentence.includes("verbos")) {
                return "¿Qué se añade a los verbos en náhuatl para conjugarlos?";
            } else {
                // Pregunta genérica si no reconoce el patrón
                const words = firstSentence.split(' ');
                const keyWord = words.find(word => word.length > 5) || words[0];
                return `Completa: En náhuatl, ${keyWord}...`; // ARREGLAR ESTO NO ES CONGRUENTE
            }
        },
        generateGrammarAnswer(grammarText) {
            // Extraer la respuesta específica de la gramática
            const sentences = grammarText.split('.');
            const firstSentence = sentences[0].trim();

            // Respuestas específicas basadas en el contenido
            if (firstSentence.includes("'cualli'")) {
                return "cualli";
            } else if (firstSentence.includes("'Notoca'")) {
                return "Notoca";
            } else if (firstSentence.includes("al principio")) {
                return "al principio de la pregunta";
            } else if (firstSentence.includes("prefijos")) {
                return "prefijos (no-, mo-, i-)";
            } else if (firstSentence.includes("prefijos") && firstSentence.includes("verbos")) {
                return "prefijos (ni-, ti-, etc.)";
            } else {
                // Respuesta genérica
                const words = firstSentence.split(' ').slice(-3).join(' ');
                return words;
            }
        },
        generateOptions(correct, incorrect) {
            const options = [correct, ...incorrect.slice(0, 3)];
            return this.shuffleArray(options);
        },
        shuffleArray(array) {
            return [...array].sort(() => Math.random() - 0.5);
        },
        selectAnswer(index) {
            if (!this.showResult) {
                this.selectedAnswer = index;
            }
        },
        verifyAnswer() {
            if (this.showResult) {
                this.currentQuestion++;
                this.selectedAnswer = null;
                this.textAnswer = '';
                this.showResult = false;
            } else {
                this.showResult = true;
            }
        }
    }
};
</script>