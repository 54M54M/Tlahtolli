<template>
    <div class="text-white pt-[10%] flex flex-col -mx-2  md:mx-[-50%]" :class="containerClasses">
        <!-- Header con título dinámico - SOLO se muestra durante la lección -->
        <Header v-if="currentQuestion <= quickExercises.length" variant="lesson" :title="`Nivel Rápido ${levelId}`"
            :subtitle="`${completedExercises} de ${totalExercises} ejercicios completados`"
            :progressCurrent="completedExercises" :progressTotal="totalExercises" :backRoute="`/nivel/${levelId}`"
            @exit-lesson="showExitConfirmModal" @energy-click="handleEnergyClick" />

        <!-- Loading inicial -->
        <div v-if="dataLoading" class="flex items-center justify-center h-64">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-white"></div>
        </div>

        <!-- Contenido -->
        <div v-else class="flex-1 flex items-center justify-center md:mt-[9%] overflow-hidden">

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
                                        <button @click="selectAnswer(index)" :class="{
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
                                    <textarea v-model="textAnswer"
                                        :placeholder="currentExercise.placeholder || 'Escribe tu respuesta...'"
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
                        :back-route="`/nivel/${levelId}`" :show-stats="true"
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
import NoEnergyModal from '../../components/NoEnergyModal.vue';
import ProcessedText from '../../components/ProcessedText.vue';
import ExerciseImage from '../../components/ExerciseImage.vue';
import CompletionMessage from '../../components/CompletionMessage.vue';

import { useAuthStore } from '../../stores/auth';
import { useEnergyStore } from '../../stores/energy';
import { learningApi, progressApi } from '../../api/apiClient.js';

export default {
    name: "QuickLevel",
    components: {
        Card, Header, FeedbackModal, WarningModal, ExitConfirmModal,
        NoEnergyModal, ProcessedText, ExerciseImage, CompletionMessage
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
            dataLoading: true,
            currentQuestion: 1,
            selectedAnswer: null,
            textAnswer: '',
            showResult: false,
            isAnswerCorrect: false,
            quickExercises: [],
            levelVocabulary: [],
            authStore: useAuthStore(),
            lessonInProgress: false,
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
            return this.levelVocabulary;
        },
        containerClasses() {
            if (this.screenHeight <= 658) return 'md:pt-[1%] md:py-[10%]';
            return 'md:pt-[15%] md:pb-[20%]';
        }
    },

    async created() {
        await this.loadQuickLevelData();
        await this.energyStore.initializeEnergy(this.authStore.user?.id || 1);
        if (!this.checkEnergyBeforeLesson()) return;
        this.setupPageReloadPrevention();
        this.lessonStartTime = Date.now();
        this.lessonInProgress = true;
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
        shuffleExerciseOptions(exercises) {
            return exercises.map(ex => {
                if (ex.type !== 'multiple-choice' || !Array.isArray(ex.options)) return ex;
                const correctOption = ex.options[ex.correctAnswer];
                const shuffled = [...ex.options].sort(() => Math.random() - 0.5);
                return {
                    ...ex,
                    options: shuffled,
                    correctAnswer: shuffled.indexOf(correctOption)
                };
            });
        },

        async loadQuickLevelData() {
            this.dataLoading = true;
            try {
                const levelId = Number(this.levelId);
                const exercises = await learningApi.getQuick(levelId, 6);
                this.quickExercises = this.shuffleExerciseOptions(exercises);
                const units = await learningApi.getUnits(levelId, this.authStore.user?.id || 1);
                const vocabRequests = units.map(u => learningApi.getVocabulary(u.id).catch(() => ({})));
                const vocabResults = await Promise.all(vocabRequests);
                const combined = {};
                vocabResults.forEach(obj => Object.assign(combined, obj));
                this.levelVocabulary = Object.keys(combined).map(key => ({
                    word: key,
                    translation: combined[key].translation || '',
                    pronunciation: combined[key].pronunciation || '',
                    example: combined[key].example || ''
                }));
            } catch (err) {
                console.error('[QuickLevelView] loadQuickLevelData:', err);
            } finally {
                this.dataLoading = false;
            }
        },

        selectAnswer(index) {
            if (!this.showResult) {
                this.selectedAnswer = index;
            }
        },

        async verifyAnswer() {
            if (this.showResult) {
                this.continueFromModal();
                return;
            }

            this.showResult = true;

            if (this.currentExercise.type === 'multiple-choice') {
                this.isAnswerCorrect = this.selectedAnswer === this.currentExercise.correctAnswer;
            } else if (this.currentExercise.type === 'fill-blank') {
                const correct = this.currentExercise.correctAnswer;
                const clean = s => s?.toString().toLowerCase().trim();
                this.isAnswerCorrect = Array.isArray(correct)
                    ? correct.some(c => clean(c) === clean(this.textAnswer))
                    : clean(correct) === clean(this.textAnswer);
            }

            const energyResult = await this.energyStore.consumeForExercise(this.isAnswerCorrect);
            if (this.isAnswerCorrect) this.correctAnswersCount++;

            if (this.energyStore.currentEnergy <= 0 && this.lessonInProgress) {
                this.lessonInProgress = false;
                if (this.energyCheckInterval) { clearInterval(this.energyCheckInterval); this.energyCheckInterval = null; }
                this.showFeedback(
                    this.isAnswerCorrect ? '¡Correcto!' : 'Incorrecto',
                    this.currentExercise.explanation || ''
                );
                setTimeout(() => this.handleEnergyDepleted(), 100);
                return;
            }

            const streakBonus = energyResult.streak >= 3 ? '' : '';
            if (this.isAnswerCorrect) {
                this.showFeedback('¡Correcto!', (this.currentExercise.explanation || 'Buen trabajo.') + streakBonus);
            } else {
                this.showFeedback('Incorrecto', this.currentExercise.explanation || 'Sigue practicando.');
            }
        },

        continueFromModal() {
            if (!this.lessonInProgress) { this.closeFeedbackModal(); return; }
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
            this.lessonTime = this.lessonStartTime
                ? Math.floor((Date.now() - this.lessonStartTime) / 1000)
                : 0;

            this.performance = this.totalExercises > 0
                ? this.correctAnswersCount / this.totalExercises
                : 0;

            const earnedPoints = this.quickExercises
                .slice(0, this.correctAnswersCount)
                .reduce((sum, ex) => sum + (ex.points || 15), 0);

            try {
                const result = await progressApi.complete({
                    userId: this.authStore.user?.id || 1,
                    unitId: this.quickExercises[0]?.unitId || null,
                    languageId: this.authStore.selectedLangId,
                    performance: this.performance,
                    earnedExp: earnedPoints,
                    correctAns: this.correctAnswersCount,
                    totalExerc: this.totalExercises,
                    timeSeconds: this.lessonTime,
                });

                this.unlockedNextLevelUnit = result.nextUnitId != null;
                this.nextLevelId = Number(this.levelId) + 1;
                await this.authStore.refreshUser();
            } catch (err) {
                console.error('[QuickLevelView] completeQuickLevel:', err);
            }
        },

        checkEnergyBeforeLesson() {
            const current = this.energyStore.currentEnergy;
            if (current >= this.requiredEnergyForLesson) return true;
            this.noEnergyModalType = current === 0 ? 'depleted' : 'insufficient';
            this.showNoEnergyModal = true;
            return false;
        },

        startEnergyMonitoring() {
            if (this.energyCheckInterval) clearInterval(this.energyCheckInterval);
            this.energyCheckInterval = setInterval(() => {
                if (this.energyStore.currentEnergy <= 0 && this.lessonInProgress && !this.showNoEnergyModal) {
                    this.handleEnergyDepleted();
                }
            }, 2000);
        },

        handleEnergyDepleted() {
            if (this.showNoEnergyModal) return;
            this.lessonInProgress = false;
            if (this.energyCheckInterval) { clearInterval(this.energyCheckInterval); this.energyCheckInterval = null; }
            this.closeFeedbackModal();
            this.noEnergyModalType = 'depleted';
            this.showNoEnergyModal = true;
        },

        handleEnergyClick() {
            const e = this.energyStore.energyForHeader;
            // alert(`Energía: ${e.current}/${e.max}⚡\nRacha: ${e.streak}`);
        },

        handleEnergyModalReturn() {
            this.showNoEnergyModal = false;
            this.lessonInProgress = false;
            if (this.energyCheckInterval) { clearInterval(this.energyCheckInterval); this.energyCheckInterval = null; }
            this.$router.push(`/nivel/${this.levelId}`);
        },

        handlePracticeForEnergy() {
            this.showNoEnergyModal = false;
            this.$router.push('/');
        },

        closeNoEnergyModal() {
            this.showNoEnergyModal = false;
            if (this.energyStore.currentEnergy <= 0) {
                this.$router.push(`/nivel/${this.levelId}`);
            }
        },

        showFeedback(title, message) { this.feedbackTitle = title; this.feedbackMessage = message; this.showFeedbackModal = true; },
        closeFeedbackModal() { this.showFeedbackModal = false; },
        closeWarningModal() { this.showWarningModal = false; },
        showExitConfirmModal() { this.showExitConfirmModalFlag = true; },
        closeExitConfirmModal() { this.showExitConfirmModalFlag = false; },
        confirmExitLesson() { this.closeExitConfirmModal(); this.$router.push(`/nivel/${this.levelId}`); },
        endSession() { this.closeWarningModal(); this.$router.push(`/nivel/${this.levelId}`); },

        setupPageReloadPrevention() {
            window.addEventListener('keydown', this.preventReloadKeys);
            window.addEventListener('beforeunload', this.preventUnload);
            window.addEventListener('resize', this.updateHeight);
        },
        cleanupPageReloadPrevention() {
            window.removeEventListener('keydown', this.preventReloadKeys);
            window.removeEventListener('beforeunload', this.preventUnload);
            window.removeEventListener('resize', this.updateHeight);
            if (this.energyCheckInterval) clearInterval(this.energyCheckInterval);
        },
        preventReloadKeys(e) {
            if ((e.key === 'F5' || (e.ctrlKey && e.key === 'r')) && this.lessonInProgress) {
                e.preventDefault();
                this.showWarningModal = true;
            }
        },
        preventUnload(e) {
            if (this.lessonInProgress) {
                e.preventDefault();
                e.returnValue = '¿Estás seguro de que quieres recargar? Perderás tu progreso.';
                return e.returnValue;
            }
        },
        updateHeight() { this.screenHeight = window.innerHeight; },
    },
    mounted() {
        this.updateHeight();
    }
};
</script>