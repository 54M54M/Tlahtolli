<template>
    <div class="text-white pt-[10%] flex flex-col -mx-2  md:mx-[-50%]" :class="containerClasses">
        <!-- Header con título dinámico -->
        <Header variant="progress" :title="`Nivel Rápido ${currentLevel.id}`"
            :subtitle="`${completedExercises} de ${totalExercises} ejercicios completados`"
            :progressCurrent="completedExercises" :progressTotal="totalExercises"
            :backRoute="`/nivel/${currentLevel.id}`" @exit-lesson="showExitConfirmModal" />

        <!-- Contenido -->
        <div class="flex-1 flex items-center justify-center md:mt-[9%] overflow-hidden">

            <!-- contenedor flex columna -->
            <div class="flex flex-col w-full items-center">
                <div class="w-full">
                    <!-- QUESTION DESKTOP -->
                    <h1 class="hidden md:block text-3xl ml-20 font-bold mb-4">{{ currentExercise.question }}</h1>
                </div>

                <div class="w-full max-w-2xl md:max-w-4xl">
                    <!-- Mostrar ejercicio actual -->
                    <Card v-if="currentQuestion <= quickExercises.length">
                        <!-- QUESTION MOBILE -->
                        <h2 class="md:hidden block text-xl font-semibold mb-4">{{ currentExercise.question }}</h2>

                        <div class="md:flex md:gap-2 md:px-10 md:py-3 md:scale-125">
                            <!-- Imagen placeholder -->
                            <div class="flex ml-2 md:justify-center mb-3 md:mb-0 md:w-1/3">

                                <!-- <img :src="placeholder" alt="Ejercicio"
                                    class="w-36 h-36 md:w-48 md:h-48 object-cover rounded-lg bg-gray-700"> -->
                                <ExerciseImage :characterName="currentExercise.character"
                                    :imageState="!showResult || isAnswerCorrect" :showAnswer="!!currentExercise.answer"
                                    :altText="`Personaje ${currentExercise.character}`" />

                                <!-- ANSWER MOBILE -->
                                <div v-if="currentExercise.answer" class="sm:hidden block mx-3 mt-10">
                                    <div class="relative">
                                        <!-- Pico -->
                                        <div class="absolute top-1/2 -translate-y-1/2 -left-3 w-0 h-0 
                                            border-t-[15px] border-t-transparent
                                            border-r-[25px] bg-[#0a2136] border border-[#37464f]
                                            border-b-[15px] border-b-transparent z-10"></div>

                                        <!-- Div principal -->
                                        <div
                                            class="relative text-white bg-[#0a2136] border border-[#37464f] py-3 px-6 text-center rounded-lg shadow-lg z-20 inline-block">
                                            <p class="text-lg font-medium">

                                                <ProcessedText :text="currentExercise.answer"
                                                    :language="authStore.selectedLanguage"
                                                    :vocabulary="currentLevelVocabulary"
                                                    :exercise-type="currentExercise.type" />

                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Contenido derecho en desktop -->
                            <div class="md:w-2/3 md:pr-2">
                                <!-- ANSWER DESKTOP -->
                                <div v-if="currentExercise.answer" class="hidden md:block w-full mb-2">
                                    <div class="relative md:-ml-7">
                                        <!-- Pico -->
                                        <div class="absolute top-1/2 -translate-y-1/4 -left-3 w-0 h-0 
                                            border-t-[15px] border-t-transparent
                                            border-r-[25px] bg-[#0a2136] border border-[#37464f]
                                            border-b-[15px] border-b-transparent z-10"></div>

                                        <!-- Div principal -->
                                        <div
                                            class="relative text-white bg-[#0a2136] border border-[#37464f] py-3 px-6 text-center rounded-lg shadow-lg z-20 inline-block">
                                            <p class="text-xl font-medium md:-ml-2">

                                                <ProcessedText :text="currentExercise.answer"
                                                    :language="authStore.selectedLanguage"
                                                    :vocabulary="currentLevelVocabulary"
                                                    :exercise-type="currentExercise.type" />

                                            </p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Tipo: Selección múltiple -->
                                <div v-if="currentExercise.type === 'multiple-choice'"
                                    class="grid grid-cols-2 gap-3 md:-ml-7">
                                    <div v-for="(option, index) in currentExercise.options" :key="index"
                                        class="relative">
                                        <button @click="selectAnswerWithSound(index, option)" :class="{
                                            'border border-[#3f85a7] text-[#3f85a7] bg-gray-800': selectedAnswer === index,
                                            'bg-gray-700 text-white': selectedAnswer !== index,
                                            'border border-green-600 text-green-600': showResult && index === currentExercise.correctAnswer,
                                            'border border-red-600 text-red-600': showResult && selectedAnswer === index && selectedAnswer !== currentExercise.correctAnswer,
                                            'border-2 border-green-500 text-green-500': showResult && index === currentExercise.correctAnswer,
                                            'border-2 border-red-500 text-red-500': showResult && selectedAnswer === index && selectedAnswer !== currentExercise.correctAnswer
                                        }"
                                            class="md:h-[58px] h-[65px] p-3 rounded-lg hover:bg-gray-600 font-semibold tracking-wider transition-colors flex items-center justify-center text-center break-words w-full">
                                            <span class="text-sm md:text-base">{{ option }}</span>
                                        </button>
                                    </div>
                                </div>

                                <!-- Tipo: Completar espacio -->
                                <div v-else-if="currentExercise.type === 'fill-blank'" class="md:-ml-7">
                                    <textarea v-model="textAnswer" :placeholder="currentExercise.placeholder"
                                        :readonly="showResult" :class="{
                                            'border-green-500 bg-green-900/20': showResult && isAnswerCorrect,
                                            'border-red-500 bg-red-900/20': showResult && !isAnswerCorrect,
                                            'border-gray-600': !showResult,
                                            'cursor-not-allowed': showResult,
                                            'cursor-text': !showResult
                                        }"
                                        class="w-full h-40 md:h-32 outline-none p-3 rounded-lg bg-gray-700 border-2 transition-colors lowercase resize-none"></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Botón de verificación -->
                        <div class="fixed bottom-0 left-0 right-0 p-5 max-w-2xl mx-auto
                            md:float-right md:left-[38%] md:p-5 md:mt-8 md:max-w-[190px]"
                            :class="{ 'md:hidden': showFeedbackModal }">
                            <button @click="verifyAnswer" :disabled="(currentExercise.type === 'multiple-choice' && selectedAnswer === null) ||
                                (currentExercise.type === 'fill-blank' && !textAnswer)"
                                class="w-full bg-[#31771c] hover:bg-[#58cc02] text-white py-5 md:py-3 px-8 rounded-lg disabled:bg-[#37464f] disabled:text-stone-500 text-lg font-medium">
                                {{ showResult ? 'Continuar' : 'Verificar' }}
                            </button>
                        </div>

                        <FeedbackModal :show="showFeedbackModal" :title="feedbackTitle" :message="feedbackMessage"
                            :is-correct="isAnswerCorrect" @continue="continueFromModal" />
                    </Card>

                    <!-- Mensaje de finalización -->
                    <Card v-if="currentQuestion > quickExercises.length"
                        class="text-center md:pt-[5%] md:pb-[6%] md:scale-125">
                        <h2 class="text-xl font-semibold mb-4">¡Nivel Rápido Completado!</h2>
                        <p class="mb-4">Has completado {{ correctAnswersCount }} de {{ totalExercises }} ejercicios
                            correctamente.</p>

                        <!-- Mostrar progreso de desbloqueo -->
                        <div v-if="unlockedNextLevelUnit" class="mb-4 p-4 bg-green-900/20 rounded-lg">
                            <h3 class="font-semibold text-green-400 mb-2">¡Nuevo Nivel Desbloqueado!</h3>
                            <p class="text-sm">¡Felicidades! Has desbloqueado la Unidad 1 del Nivel {{ nextLevelId }}
                            </p>
                            <div class="mt-2 flex items-center justify-center gap-2">
                                <span class="w-2 h-2 bg-green-400 rounded-full"></span>
                                <span class="text-sm">Nivel {{ nextLevelId }} - Unidad 1 disponible</span>
                            </div>
                        </div>

                        <div v-else-if="performance < 0.8" class="mb-4 p-4 bg-yellow-900/20 rounded-lg">
                            <h3 class="font-semibold text-yellow-400 mb-2">Sigue practicando</h3>
                            <p class="text-sm">Necesitas al menos 80% de aciertos para desbloquear el siguiente nivel.
                            </p>
                            <p class="text-sm mt-1">Obtuviste: {{ Math.round(performance * 100) }}%</p>
                        </div>

                        <div class="flex flex-col">
                            <router-link :to="`/nivel/${currentLevel.id}`">
                                <button
                                    class="bg-[#31771c] hover:bg-[#58cc02] text-white font-extrabold py-3 px-6 rounded-lg transition-colors w-full">
                                    RECIBIR EXP
                                </button>
                            </router-link>
                        </div>
                    </Card>

                </div>
            </div>
        </div>

        <!-- MODALES COMPONENTES -->
        <WarningModal :show="showWarningModal" @close="closeWarningModal" @confirm="endSession" />
        <ExitConfirmModal :show="showExitConfirmModalFlag" @close="closeExitConfirmModal"
            @confirm="confirmExitLesson" />
    </div>
</template>

<script>
import Card from '../../components/Card.vue';
import Header from '../../components/vHeader.vue';
import FeedbackModal from '../../components/FeedbackModal.vue';
import WarningModal from '../../components/WarningModal.vue';
import ExitConfirmModal from '../../components/ExitConfirmModal.vue';
import ProcessedText from '../../components/ProcessedText.vue';
import NextStage from '../../components/NextStage.vue';

import { useAuthStore } from '../../stores/auth';
import { getLearningRepository } from '../../data/repositories/RepositoryFactory.js';
import { ProgressService } from '../../data/services/ProgressService.js';
import { QuickLevelService } from '../../data/services/QuickLevelService.js';
import placeholder from '../../assets/300x300.png';

import ExerciseImage from '../../components/ExerciseImage.vue';

export default {
    name: "QuickLevel",
    components: {
        Card,
        Header,
        FeedbackModal,
        WarningModal,
        ExitConfirmModal,
        ProcessedText,
        NextStage,
        ExerciseImage
    },
    props: {
        levelId: {
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
            isAnswerCorrect: false,
            quickExercises: [],
            currentLevel: {},
            placeholder: placeholder,
            authStore: useAuthStore(),
            learningRepo: getLearningRepository(),
            progressService: new ProgressService(),
            quickLevelService: new QuickLevelService(),
            lessonInProgress: true,
            showFeedbackModal: false,
            showWarningModal: false,
            showExitConfirmModalFlag: false,
            feedbackTitle: '',
            feedbackMessage: '',
            correctAnswersCount: 0,
            completedExercises: 0,
            unlockedNextLevelUnit: false,
            nextLevelId: null,
            performance: 0,
            screenHeight: 0
        };
    },
    computed: {
        currentExercise() {
            return this.quickExercises[this.currentQuestion - 1] || {};
        },
        totalExercises() {
            return this.quickExercises.length;
        },
        // Obtener vocabulario combinado de todas las unidades del nivel
        currentLevelVocabulary() {
            const units = this.learningRepo.getUnits(this.authStore.selectedLanguage, Number(this.levelId));
            const vocabulary = [];

            units.forEach(unit => {
                if (unit.vocabulary) {
                    if (Array.isArray(unit.vocabulary)) {
                        vocabulary.push(...unit.vocabulary);
                    } else {
                        Object.keys(unit.vocabulary).forEach(key => {
                            vocabulary.push({
                                word: key,
                                ...unit.vocabulary[key]
                            });
                        });
                    }
                }
            });

            console.log('📚 VOCABULARIO COMBINADO DEL NIVEL:', vocabulary);
            return vocabulary;
        },
        containerClasses() {
            if (this.screenHeight <= 658) {
                return 'md:pt-[-5%] md:py-[-10%]';
            } else if (this.screenHeight >= 700) {
                return 'md:pt-[15%] md:pb-[20%]';
            }
        }
    },
    created() {
        this.loadQuickLevelData();
        this.setupPageReloadPrevention();
    },
    beforeUnmount() {
        this.cleanupPageReloadPrevention();
    },
    methods: {
        async loadQuickLevelData() {
            const language = this.authStore.selectedLanguage;
            const levelId = Number(this.levelId);

            // Obtener nivel actual
            this.currentLevel = this.learningRepo.getLevel(language, levelId);

            // Usar el servicio para obtener ejercicios aleatorios
            this.quickExercises = this.quickLevelService.getRandomExercisesForLevel(language, levelId, 6);
        },

        selectAnswer(index) {
            if (!this.showResult) {
                this.selectedAnswer = index;
            }
        },

        selectAnswerWithSound(index, option) {
            this.selectAnswer(index);
        },

        validateFillBlankAnswer(userAnswer, correctAnswer) {
            if (!userAnswer || !correctAnswer) return false;

            // Normalizar la respuesta del usuario
            const normalizedUser = userAnswer.trim().toLowerCase();

            // Manejar diferentes tipos de correctAnswer
            let normalizedCorrect;

            if (typeof correctAnswer === 'string') {
                // Si es string, usar directamente
                normalizedCorrect = correctAnswer.trim().toLowerCase();
            } else if (Array.isArray(correctAnswer)) {
                // Si es array, usar el primer elemento o convertir a string
                normalizedCorrect = correctAnswer[0] ? correctAnswer[0].toString().trim().toLowerCase() : '';
            } else if (typeof correctAnswer === 'object' && correctAnswer !== null) {
                // Si es objeto, intentar extraer la respuesta
                normalizedCorrect = correctAnswer.answer ? correctAnswer.answer.toString().trim().toLowerCase() : '';
            } else {
                // Para cualquier otro tipo, convertir a string
                normalizedCorrect = correctAnswer.toString().trim().toLowerCase();
            }

            console.log('🔍 Validando fill-blank:', {
                userAnswer: normalizedUser,
                correctAnswer: normalizedCorrect,
                originalCorrect: correctAnswer
            });

            // Comparación directa
            return normalizedUser === normalizedCorrect;
        },

        verifyAnswer() {
            if (this.showResult) {
                this.continueFromModal();
            } else {
                this.showResult = true;

                // DEBUG: Verificar la estructura del ejercicio actual
                console.log('🔍 Ejercicio actual:', this.currentExercise);
                console.log('🔍 Tipo:', this.currentExercise.type);
                console.log('🔍 Respuesta correcta:', this.currentExercise.correctAnswer);
                console.log('🔍 Tipo de correctAnswer:', typeof this.currentExercise.correctAnswer);

                if (this.currentExercise.type === 'multiple-choice') {
                    this.isAnswerCorrect = this.selectedAnswer === this.currentExercise.correctAnswer;
                } else if (this.currentExercise.type === 'fill-blank') {
                    this.isAnswerCorrect = this.validateFillBlankAnswer(
                        this.textAnswer,
                        this.currentExercise.correctAnswer
                    );
                }

                if (this.isAnswerCorrect) {
                    this.correctAnswersCount++;
                }

                if (this.isAnswerCorrect) {
                    this.showFeedback('¡Correcto!', this.currentExercise.explanation || 'Buen trabajo.');
                } else {
                    this.showFeedback('Incorrecto', this.currentExercise.explanation || 'Sigue practicando.');
                }
            }
        },

        continueFromModal() {
            this.closeFeedbackModal();
            this.completedExercises++;
            this.currentQuestion++;
            this.selectedAnswer = null;
            this.textAnswer = '';
            this.showResult = false;
            this.isAnswerCorrect = false;

            if (this.currentQuestion > this.quickExercises.length) {
                this.completeQuickLevel();
                this.lessonInProgress = false;
            }
        },

        async completeQuickLevel() {
            const language = this.authStore.selectedLanguage;
            const levelId = Number(this.levelId);

            console.log(`🚀 INICIANDO COMPLETADO DE QUICKLEVEL - Nivel ${levelId}`);

            // Verificar estado ANTES
            this.quickLevelService.checkSystemState(language, levelId);

            // CALCULAR PERFORMANCE
            this.performance = this.correctAnswersCount / this.totalExercises;
            console.log(`📊 Performance: ${this.performance} (${this.correctAnswersCount}/${this.totalExercises})`);

            // USAR EL NUEVO SERVICIO
            const result = await this.quickLevelService.completeQuickLevel(
                language,
                levelId,
                this.performance,
                this.correctAnswersCount,
                this.totalExercises
            );

            this.unlockedNextLevelUnit = result.nextLevelUnlocked;
            this.nextLevelId = result.nextLevelId;

            // VERIFICACIÓN EXTRA - Forzar actualización del repositorio
            console.log(`🔄 FORZANDO ACTUALIZACIÓN DEL REPOSITORIO...`);
            this.learningRepo.checkAndUpdateLevelLockStatus(language);

            // Verificar estado DESPUÉS con más detalle
            console.log(`🔍 VERIFICACIÓN FINAL DEL SISTEMA:`);
            this.quickLevelService.checkSystemState(language, levelId);

            if (result.nextLevelUnlocked && result.nextLevelId) {
                console.log(`🎉 NIVEL ${result.nextLevelId} DESBLOQUEADO - Verificando estado:`);
                this.quickLevelService.checkSystemState(language, result.nextLevelId);
            }

            if (result.progressRecorded.wasAlreadyCompleted) {
                this.showFeedback(
                    '¡Nivel Repasado!',
                    `Completaste ${this.correctAnswersCount} de ${this.totalExercises} ejercicios correctamente.`
                );
            } else {
                this.showFeedback(
                    '¡Nivel Rápido Completado!',
                    `Completaste ${this.correctAnswersCount} de ${this.totalExercises} ejercicios correctamente.${result.nextLevelUnlocked ? ' ¡Nuevo nivel desbloqueado!' : ''}`
                );
            }
        },

        // método para debugging
        checkCurrentState() {
            const language = this.authStore.selectedLanguage;
            const levelId = Number(this.levelId);

            console.log(`🔍 ESTADO ACTUAL DEL SISTEMA:`);

            // Verificar nivel actual
            const currentLevel = this.learningRepo.getLevel(language, levelId);
            console.log(`📊 Nivel actual ${levelId}:`, {
                locked: currentLevel.locked,
                completedUnits: currentLevel.completedUnits,
                totalUnits: currentLevel.units,
                progress: `${((currentLevel.completedUnits / currentLevel.units) * 100).toFixed(1)}%`
            });

            // Verificar unidades del nivel actual
            const currentUnits = this.learningRepo.getUnits(language, levelId);
            console.log(`📋 Unidades del nivel ${levelId}:`,
                currentUnits.map(u => ({
                    id: u.id,
                    completed: u.completed,
                    locked: u.locked,
                    current: u.current
                }))
            );

            // Verificar siguiente nivel si existe
            const levels = this.learningRepo.getLevels(language);
            const currentLevelIndex = levels.findIndex(level => level.id === levelId);
            if (currentLevelIndex < levels.length - 1) {
                const nextLevel = levels[currentLevelIndex + 1];
                const nextLevelUnits = this.learningRepo.getUnits(language, nextLevel.id);
                console.log(`🔮 Siguiente nivel ${nextLevel.id}:`, {
                    locked: nextLevel.locked,
                    units: nextLevel.units
                });
                console.log(`🔮 Unidades del siguiente nivel:`,
                    nextLevelUnits.map(u => ({
                        id: u.id,
                        completed: u.completed,
                        locked: u.locked,
                        current: u.current
                    }))
                );
            }
        },

        showFeedback(title, message) {
            this.feedbackTitle = title;
            this.feedbackMessage = message;
            this.showFeedbackModal = true;
        },

        closeFeedbackModal() {
            this.showFeedbackModal = false;
        },

        showWarning() {
            this.showWarningModal = true;
        },

        closeWarningModal() {
            this.showWarningModal = false;
        },

        showExitConfirmModal() {
            this.showExitConfirmModalFlag = true;
        },

        closeExitConfirmModal() {
            this.showExitConfirmModalFlag = false;
        },

        confirmExitLesson() {
            this.closeExitConfirmModal();
            this.$router.push(`/nivel/${this.currentLevel.id}`);
        },

        endSession() {
            this.closeWarningModal();
            this.$router.push(`/nivel/${this.currentLevel.id}`);
        },

        setupPageReloadPrevention() {
            window.addEventListener('keydown', this.preventReloadKeys);
            window.addEventListener('beforeunload', this.preventUnload);
        },

        cleanupPageReloadPrevention() {
            window.removeEventListener('keydown', this.preventReloadKeys);
            window.removeEventListener('beforeunload', this.preventUnload);
        },

        preventReloadKeys(e) {
            if ((e.key === 'F5' || (e.ctrlKey && e.key === 'r')) && this.lessonInProgress) {
                e.preventDefault();
                this.showWarning();
            }
        },

        preventUnload(e) {
            if (this.lessonInProgress) {
                e.preventDefault();
                e.returnValue = '¿Estás seguro de que quieres recargar? Perderás tu progreso en esta lección.';
                return e.returnValue;
            }
        },

        updateHeight() {
            this.screenHeight = window.innerHeight;
        },

        setupPageReloadPrevention() {
            window.addEventListener('keydown', this.preventReloadKeys);
            window.addEventListener('beforeunload', this.preventUnload);
            window.addEventListener('resize', this.updateHeight); // Agregar listener de resize
        },

        cleanupPageReloadPrevention() {
            window.removeEventListener('keydown', this.preventReloadKeys);
            window.removeEventListener('beforeunload', this.preventUnload);
            window.removeEventListener('resize', this.updateHeight); // Remover listener de resize
        },
    },
    mounted() {
        this.updateHeight(); // Inicializar la altura al montar
    }
};
</script>