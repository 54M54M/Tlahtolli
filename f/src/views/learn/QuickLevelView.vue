<template>
    <div class="text-white pt-[10%] flex flex-col -mx-2  md:mx-[-50%]" :class="containerClasses">
        <!-- Header con título dinámico - SOLO se muestra durante la lección -->
        <Header v-if="currentQuestion <= quickExercises.length" variant="lesson" :title="`Nivel Rápido ${levelId}`"
            :subtitle="`${completedExercises} de ${totalExercises} ejercicios completados`"
            :progressCurrent="completedExercises" :progressTotal="totalExercises" :backRoute="`/nivel/${levelId}`"
            :energyCurrent="energyStore.currentEnergy" :energyMax="energyStore.maxEnergy"
            :energyStreak="energyStore.streakCount" @exit-lesson="showExitConfirmModal"
            @energy-click="handleEnergyClick" />

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

                    <!-- Mensaje de finalización - DISEÑO QUICKLEVEL -->
                    <CompletionMessage v-if="currentQuestion > quickExercises.length" title="¡Nivel Rápido Completado!"
                        :back-route="`/nivel/${currentLevel.id}`" :show-stats="true"
                        :correct-answers-count="correctAnswersCount" :total-exercises="totalExercises"
                        :performance="performance" :lesson-time="lessonTime" :show-unlock-section="true"
                        :unlocked-next-level-unit="unlockedNextLevelUnit" :next-level-id="nextLevelId" />

                </div>
            </div>
        </div>

        <!-- MODALES COMPONENTES -->
        <WarningModal :show="showWarningModal" @close="closeWarningModal" @confirm="endSession" />
        <ExitConfirmModal :show="showExitConfirmModalFlag" @close="closeExitConfirmModal"
            @confirm="confirmExitLesson" />
        <NoEnergyModal :show="showNoEnergyModal" :modal-type="noEnergyModalType"
            :current-energy="energyStore.currentEnergy" :max-energy="energyStore.maxEnergy"
            :required-energy="requiredEnergyForLesson"
            :recovery-time="energyStore.getRecoveryTime(requiredEnergyForLesson)" :redirect-to="`/nivel/${levelId}`"
            @return="handleEnergyModalReturn" @practice="handlePracticeForEnergy" @close="closeNoEnergyModal" />
    </div>
</template>

<script>
import Card from '../../components/Card.vue';
import Header from '../../components/vHeader.vue';
import FeedbackModal from '../../components/FeedbackModal.vue';
import WarningModal from '../../components/WarningModal.vue';
import ExitConfirmModal from '../../components/ExitConfirmModal.vue';
import NoEnergyModal from '../../components/NoEnergyModal.vue'
import NextStage from '../../components/NextStage.vue';

import ProcessedText from '../../components/ProcessedText.vue';
import ExerciseImage from '../../components/ExerciseImage.vue';

import CompletionMessage from '../../components/CompletionMessage.vue';

import { useAuthStore } from '../../stores/auth';
import { useEnergyStore } from '../../stores/energy';
import { getLearningRepository } from '../../data/repositories/RepositoryFactory.js';
import { ProgressService } from '../../data/services/ProgressService.js';
import { QuickLevelService } from '../../data/services/QuickLevelService.js';
import placeholder from '../../assets/300x300.png';

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
        ExerciseImage,
        CompletionMessage,
        NoEnergyModal
    },
    props: {
        levelId: {
            type: [String, Number],
            required: true
        }
    },
    setup() {
        const energyStore = useEnergyStore();
        return { energyStore };
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
            screenHeight: 0,
            lessonStartTime: null,
            lessonTime: 0,
            earnedExp: 0,
            showNoEnergyModal: false,
            noEnergyModalType: 'depleted',
            requiredEnergyForLesson: 10,
            energyCheckInterval: null,
        };
    },
    computed: {
        currentExercise() {
            return this.quickExercises[this.currentQuestion - 1] || {};
        },

        totalExercises() {
            return this.quickExercises.length;
        },

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

            return vocabulary;
        },

        containerClasses() {
            if (this.screenHeight <= 658) {
                return 'md:pt-[1%] md:py-[10%]';
            } else if (this.screenHeight >= 700) {
                return 'md:pt-[15%] md:pb-[20%]';
            }
        }
    },

    async created() {
        // ✅ CORRECCIÓN: Cargar datos del nivel PRIMERO
        this.loadQuickLevelData();

        // Luego verificar energía
        await this.energyStore.initializeEnergy(this.authStore.user?.id || 1);

        if (!this.checkEnergyBeforeLesson()) {
            return;
        }

        this.setupPageReloadPrevention();
        this.lessonStartTime = Date.now();
        this.startEnergyMonitoring();
    },

    beforeUnmount() {
        this.cleanupPageReloadPrevention();

        if (this.energyCheckInterval) {
            clearInterval(this.energyCheckInterval);
            this.energyCheckInterval = null;
        }

        this.lessonInProgress = false;
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

            const normalizedUser = userAnswer.trim().toLowerCase();

            let normalizedCorrect;

            if (typeof correctAnswer === 'string') {
                normalizedCorrect = correctAnswer.trim().toLowerCase();
            } else if (Array.isArray(correctAnswer)) {
                normalizedCorrect = correctAnswer[0] ? correctAnswer[0].toString().trim().toLowerCase() : '';
            } else if (typeof correctAnswer === 'object' && correctAnswer !== null) {
                normalizedCorrect = correctAnswer.answer ? correctAnswer.answer.toString().trim().toLowerCase() : '';
            } else {
                normalizedCorrect = correctAnswer.toString().trim().toLowerCase();
            }

            return normalizedUser === normalizedCorrect;
        },


        async verifyAnswer() {
            if (this.showResult) {
                this.continueFromModal();
            } else {
                this.showResult = true;

                if (this.currentExercise.type === 'multiple-choice') {
                    this.isAnswerCorrect = this.selectedAnswer === this.currentExercise.correctAnswer;
                } else if (this.currentExercise.type === 'fill-blank') {
                    this.isAnswerCorrect = this.validateFillBlankAnswer(
                        this.textAnswer,
                        this.currentExercise.correctAnswer
                    );
                }

                const energyResult = await this.energyStore.consumeForExercise(this.isAnswerCorrect);

                console.log('⚡ Cambio de energía (QuickLevel):', energyResult);

                if (this.isAnswerCorrect) {
                    this.correctAnswersCount++;
                }

                // ⚡ VERIFICAR SI LA ENERGÍA LLEGÓ A 0 - INMEDIATAMENTE
                if (this.energyStore.currentEnergy <= 0 && this.lessonInProgress) {
                    // Detener la lección inmediatamente
                    this.lessonInProgress = false;

                    // Detener el monitoreo de energía
                    if (this.energyCheckInterval) {
                        clearInterval(this.energyCheckInterval);
                        this.energyCheckInterval = null;
                    }

                    // Mostrar feedback primero
                    const streakBonus = energyResult.streak >= 3 ? ' ¡Racha activa! 🔥' : '';
                    if (this.isAnswerCorrect) {
                        this.showFeedback(
                            '¡Correcto!',
                            (this.currentExercise.explanation || 'Buen trabajo.') + streakBonus
                        );
                    } else {
                        this.showFeedback(
                            'Incorrecto',
                            this.currentExercise.explanation || 'Sigue practicando.'
                        );
                    }

                    // Esperar a que cierre el feedback modal
                    setTimeout(() => {
                        this.handleEnergyDepleted();
                    }, 100);

                    return;
                }

                // Mostrar feedback normal si hay energía
                if (this.isAnswerCorrect) {
                    const streakBonus = energyResult.streak >= 3 ? ' ¡Racha activa! 🔥' : '';
                    this.showFeedback(
                        '¡Correcto!',
                        (this.currentExercise.explanation || 'Buen trabajo.') + streakBonus
                    );
                } else {
                    this.showFeedback(
                        'Incorrecto',
                        this.currentExercise.explanation || 'Sigue practicando.'
                    );
                }
            }
        },

        continueFromModal() {
            // ⚠️ NO CONTINUAR SI LA LECCIÓN NO ESTÁ EN PROGRESO
            if (!this.lessonInProgress) {
                this.closeFeedbackModal();
                return;
            }

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
            this.lessonTime = Math.floor((Date.now() - this.lessonStartTime) / 1000);

            const language = this.authStore.selectedLanguage;
            const levelId = Number(this.levelId);

            this.performance = this.correctAnswersCount / this.totalExercises;

            const earnedPoints = this.calculateEarnedPoints();

            console.log('📊 QuickLevel EXP:', {
                earnedPoints,
                correctAnswers: this.correctAnswersCount,
                totalExercises: this.totalExercises
            });

            const result = await this.quickLevelService.completeQuickLevel(
                language,
                levelId,
                this.performance,
                this.correctAnswersCount,
                this.totalExercises,
                earnedPoints
            );

            this.unlockedNextLevelUnit = result.nextLevelUnlocked;
            this.nextLevelId = result.nextLevelId;
            this.earnedExp = result.progressRecorded.xpEarned;
        },

        calculateEarnedPoints() {
            let earnedPoints = 0;

            this.quickExercises.forEach((exercise, index) => {
                if (index < this.correctAnswersCount) {
                    earnedPoints += (exercise.points || 15);
                }
            });

            return earnedPoints;
        },

        handleEnergyClick() {
            const energy = this.energyStore.energyForHeader;
            const tooltip = `Energía: ${energy.current}/${energy.max}⚡
                            Consumo: -1⚡ por ejercicio
                            Acierto: +1-2⚡ bonus
                            Racha (${energy.streak}): ${energy.streak >= 3 ? '+3-4⚡ bonus activo! 🔥' : 'Necesitas 3+ aciertos'}`;
            alert(tooltip);
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
            this.$router.push(`/nivel/${this.levelId}`);
        },

        endSession() {
            this.closeWarningModal();
            this.$router.push(`/nivel/${this.levelId}`);
        },

        setupPageReloadPrevention() {
            window.addEventListener('keydown', this.preventReloadKeys);
            window.addEventListener('beforeunload', this.preventUnload);
            window.addEventListener('resize', this.updateHeight);
        },

        cleanupPageReloadPrevention() {
            window.removeEventListener('keydown', this.preventReloadKeys);
            window.removeEventListener('beforeunload', this.preventUnload);
            window.removeEventListener('resize', this.updateHeight);

            if (this.energyCheckInterval) {
                clearInterval(this.energyCheckInterval);
            }
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

        checkEnergyBeforeLesson() {
            const currentEnergy = this.energyStore.currentEnergy;

            if (currentEnergy >= this.requiredEnergyForLesson) {
                return true;
            }

            // ⚡ CORRECCIÓN: Diferenciar entre 0 energía y energía insuficiente
            if (currentEnergy === 0) {
                console.log('⚡ Sin energía (0) para nivel rápido - Mostrando modal DEPLETED');
                this.noEnergyModalType = 'depleted';
            } else {
                console.log('⚠️ Energía insuficiente para nivel rápido:', currentEnergy);
                this.noEnergyModalType = 'insufficient';
            }

            this.showNoEnergyModal = true;
            return false;
        },

        startEnergyMonitoring() {
            if (this.energyCheckInterval) {
                clearInterval(this.energyCheckInterval);
            }

            this.energyCheckInterval = setInterval(() => {
                if (this.energyStore.currentEnergy <= 0 &&
                    this.lessonInProgress &&
                    !this.showNoEnergyModal) {
                    this.handleEnergyDepleted();
                }
            }, 2000);
        },

        handleEnergyDepleted() {
            // Prevenir llamadas múltiples
            if (this.showNoEnergyModal) {
                // console.log('⚡ Modal ya está mostrándose, ignorando...');
                return;
            }

            // console.log('⚡ Energía agotada durante nivel rápido');

            this.lessonInProgress = false;

            if (this.energyCheckInterval) {
                clearInterval(this.energyCheckInterval);
                this.energyCheckInterval = null;
            }

            this.closeFeedbackModal();

            this.noEnergyModalType = 'depleted';
            this.showNoEnergyModal = true;
        },

        handleEnergyModalReturn() {
            this.showNoEnergyModal = false;
            this.lessonInProgress = false;

            if (this.energyCheckInterval) {
                clearInterval(this.energyCheckInterval);
                this.energyCheckInterval = null;
            }

            this.$router.push(`/nivel/${this.levelId}`);
        },

        handlePracticeForEnergy() {
            this.showNoEnergyModal = false;
            this.$router.push('/practica');
        },

        closeNoEnergyModal() {
            // console.log('🟢 NoEnergyModal cerrado desde QuickLevelView');
            this.showNoEnergyModal = false;

            // ⚠️ IMPORTANTE: Si la energía está en 0, redirigir automáticamente
            if (this.energyStore.currentEnergy <= 0) {
                // console.log('⚡ Energía en 0, redirigiendo...');
                this.$router.push(`/nivel/${this.levelId}`);
            }
        },
    },
    mounted() {
        this.updateHeight();
    }
};
</script>