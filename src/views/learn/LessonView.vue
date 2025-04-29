<template>
    <div class="text-white">
        <!-- Header con información dinámica -->
        <Header variant="progress" :subtitle="`Nivel ${currentLevel.id}, Unidad ${currentUnit.id}`"
            :progressCurrent="currentQuestion - 1" :progressTotal="currentExercises.length"
            :backRoute="`/nivel/${currentLevel.id}`" />

        <div class="mt-12 px-4 pb-20">
            <!-- Mostrar ejercicio actual -->
            <Card v-if="currentQuestion <= currentExercises.length">
                <h2 class="text-xl font-semibold mb-4">{{ currentExercise.question }}</h2>

                <!-- Tipo: Selección múltiple -->
                <div v-if="currentExercise.type === 'multiple-choice'" class="space-y-2">
                    <button v-for="(option, index) in currentExercise.options" :key="index" @click="selectAnswer(index)"
                        :class="{
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
</template>

<script>
import Card from '../../components/Card.vue';
import Header from '../../components/vHeader.vue';
import { levels, levelUnits } from '../../lib/data.js';

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
            currentUnit: {}
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

            // Ejercicios de gramática
            const grammarExercises = unit.grammar ? [{
                type: 'fill-blank',
                question: `Completa: ${unit.grammar.split('.')[0]}...`,
                placeholder: "Escribe tu respuesta",
                correctAnswer: unit.grammar.split(' ').slice(0, 3).join(' ')
            }] : [];

            this.currentExercises = [...vocabExercises, ...grammarExercises];
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