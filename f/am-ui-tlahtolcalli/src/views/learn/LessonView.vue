<template>
    <div class="text-white pt-[10%] flex flex-col -mx-2  md:mx-[-50%]" :class="containerClasses">
        <!-- Header con título dinámico - SOLO se muestra durante la lección -->
        <Header v-if="currentQuestion <= currentExercises.length" variant="lesson" :title="currentUnit.title || ''"
            :subtitle="`Nivel ${currentLevel.id}, Unidad ${currentUnit.id}`" :progressCurrent="currentQuestion - 1"
            :progressTotal="currentExercises.length" :backRoute="`/app/nivel/${currentLevel.id}`"
            @exit-lesson="showExitConfirmModal" @energy-click="handleEnergyClick"/>

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
                    <div class="hidden md:block ml-20">
                        <!-- Etiqueta del paso (src/data/lessonPlan.js): palabra nueva, repaso o error anterior -->
                        <p v-if="badgeInfo" class="text-xs font-bold tracking-widest uppercase mb-1 flex items-center gap-1"
                            :class="badgeInfo.cls">
                            <span aria-hidden="true">{{ badgeInfo.icon }}</span>{{ badgeInfo.label }}
                        </p>
                    </div>
                    <h1 class="hidden md:block text-3xl ml-20 font-bold mb-4">{{ currentExercise.question }}</h1>
                </div>

                <div class="w-full max-w-2xl md:max-w-4xl">
                    <!-- Mostrar ejercicio actual -->
                    <Card v-if="currentQuestion <= currentExercises.length">

                        <!-- QUESTION MOBILE -->
                        <div class="md:hidden">
                        <!-- Etiqueta del paso (src/data/lessonPlan.js): palabra nueva, repaso o error anterior -->
                        <p v-if="badgeInfo" class="text-xs font-bold tracking-widest uppercase mb-1 flex items-center gap-1"
                            :class="badgeInfo.cls">
                            <span aria-hidden="true">{{ badgeInfo.icon }}</span>{{ badgeInfo.label }}
                        </p>
                        </div>
                        <h2 class="md:hidden block text-xl font-semibold mb-4">{{ currentExercise.question }}</h2>

                        <!-- Tipo: Selecciona los pares (sin personaje ni Verificar: avanza solo al terminar) -->
                        <div v-if="currentExercise.type === 'match'" class="md:px-10 md:py-3 mt-6 md:mt-0">
                            <MatchPairs :key="`mp-${currentQuestion}`" :pairs="currentExercise.pairs"
                                :left="currentExercise.left" :right="currentExercise.right" @done="onMatchDone" />
                        </div>

                        <div v-else class="md:flex md:gap-2 md:px-10 md:py-3 md:scale-125">
                            <!-- Imagen placeholder -->
                            <div class="flex ml-2 md:justify-center mb-3 md:mb-0 md:w-1/3">

                                <ExerciseImage :characterName="currentExercise.character"
                                    :imageState="!showResult || isAnswerCorrect" :showAnswer="!!currentExercise.answer"
                                    :altText="`Personaje ${currentExercise.character}`" />

                                <!-- ANSWER MOBILE -->
                                <div v-if="currentExercise.answer" class="sm:hidden block mx-3 mt-10 flex-1 min-w-0">
                                    <div class="relative">
                                        <!-- Pico -->
                                        <div class="absolute top-1/2 -translate-y-1/2 -left-3 w-0 h-0 
                                            border-t-[15px] border-t-transparent
                                            border-r-[25px] bg-surface-0 border border-line
                                            border-b-[15px] border-b-transparent z-10"></div>
                                        <!-- Div principal -->
                                        <div
                                            class="relative text-white bg-surface-0 border border-line py-3 px-4 text-center rounded-lg shadow-lg z-20 inline-block max-w-full break-words">
                                            <p class="text-lg font-medium">
                                                <ProcessedText :text="currentExercise.answer"
                                                    :language="authStore.selectedLanguage"
                                                    :vocabulary="currentUnitVocabulary"
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
                                            border-r-[25px] bg-surface-0 border border-line
                                            border-b-[15px] border-b-transparent z-10"></div>
                                        <!-- Div principal -->
                                        <div
                                            class="relative text-white bg-surface-0 border border-line py-3 px-4 text-center rounded-lg shadow-lg z-20 inline-block max-w-full break-words">
                                            <p class="text-xl font-medium md:-ml-2">
                                                <ProcessedText :text="currentExercise.answer"
                                                    :language="authStore.selectedLanguage"
                                                    :vocabulary="currentUnitVocabulary"
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
                                        <button @click="selectAnswer(index)" :disabled="showResult" :class="choiceState(index)"
                                            class="tl-choice md:h-[58px] h-[65px] p-3 tracking-wider flex items-center justify-center text-center break-words w-full">
                                            <span class="text-sm md:text-base">{{ option }}</span>
                                        </button>
                                    </div>
                                </div>

                                <!-- Tipo: Armar la frase con fichas -->
                                <div v-else-if="currentExercise.type === 'word-bank'" class="md:-ml-7 mt-2">
                                    <WordBank :key="`wb-${currentQuestion}`" v-model="wordBankSel"
                                        :tiles="currentExercise.tiles || []" :disabled="showResult"
                                        :state="showResult ? (isAnswerCorrect ? 'correct' : 'wrong') : null" />
                                </div>

                                <!-- Tipo: Completar espacio -->
                                <div v-else-if="currentExercise.type === 'fill-blank'" class="md:-ml-7">
                                    <textarea v-model="textAnswer" spellcheck="false" ^autocorrect="off" autocapitalize="off" autocomplete="off" translate="no"
                                        :placeholder="currentExercise.translation || currentExercise.placeholder || 'Escribe tu respuesta...'"
                                        :readonly="showResult" :class="{
                                            'border-green-500 bg-green-900/20': showResult && isAnswerCorrect,
                                            'border-error bg-error-soft/20': showResult && !isAnswerCorrect,
                                            'border-gray-600': !showResult,
                                            'cursor-not-allowed': showResult,
                                            'cursor-text': !showResult
                                        }"
                                        class="w-full h-40 md:h-32 outline-none p-3 rounded-lg bg-gray-700 border-2 transition-colors lowercase resize-none"></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Botón de verificación -->
                        <div v-if="currentExercise.type !== 'match'" class="tl-kb fixed bottom-0 left-0 right-0 p-5 max-w-2xl mx-auto
                            md:float-right md:left-[38%] md:p-5 md:mt-8 md:max-w-[190px]"
                            :class="{ 'md:hidden': showFeedbackModal }">
                            <button @click="verifyAnswer" :disabled="isVerifying || (currentExercise.type === 'multiple-choice' && selectedAnswer === null) ||
                                (currentExercise.type === 'fill-blank' && !textAnswer) ||
                                (currentExercise.type === 'word-bank' && !wordBankSel.length)"
                                class="w-full bg-turquesa-deep hover:bg-turquesa-deeper text-white py-5 md:py-3 px-8 rounded-lg disabled:bg-line disabled:text-stone-500 text-lg font-medium">
                                {{ showResult ? 'Continuar' : 'Verificar' }}
                            </button>
                        </div>

                        <FeedbackModal :show="showFeedbackModal" :title="feedbackTitle" :message="feedbackMessage"
                            :is-correct="isAnswerCorrect" @continue="continueFromModal" />
                    </Card>
                </div>
            </div>
        </div>

      <!-- Mensaje de finalización -->
      <CompletionMessage v-if="!dataLoading && currentQuestion > currentExercises.length" title="¡Lección completada!"
             :back-route="`/app/nivel/${currentLevel.id}`"
             :performance="currentExercises.length > 0 ? correctAnswersCount / currentExercises.length : 1"
             :lesson-time="lessonTime" :earned-exp="earnedExp" :pending-sync="pendingSync" class="md:mt-[-10%]"/>

        <!-- MODALES COMPONENTES -->
        <WarningModal :show="showWarningModal" @close="closeWarningModal" @confirm="endSession" />
        <ExitConfirmModal :show="showExitConfirmModalFlag" @close="closeExitConfirmModal"
            @confirm="confirmExitLesson" />
        <NoEnergyModal :show="showNoEnergyModal" :modal-type="noEnergyModalType"
            :current-energy="energyStore.currentEnergy" :max-energy="energyStore.maxEnergy" :required-energy="10"
            :recovery-time="energyStore.getRecoveryTime(requiredEnergyForLesson)"
            :redirect-to="`/app/nivel/${currentLevel.id}`" @return="handleEnergyModalReturn"
            @practice="handlePracticeForEnergy" @close="closeNoEnergyModal" />
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
import PronunciationTooltip from '../../components/PronunciationTooltip.vue';
import ExerciseImage from '../../components/ExerciseImage.vue';
import CompletionMessage from '../../components/CompletionMessage.vue';
import { leaveTo } from '../../router/leave.js';
import WordBank from '../../components/WordBank.vue';
import MatchPairs from '../../components/MatchPairs.vue';
import { buildLessonPlan, mistakeRetry, checkWordBank, BADGE } from '../../data/lessonPlan.js';

import { useAuthStore } from '../../stores/auth';
import { useEnergyStore } from '../../stores/energy';
import { loadLessonData, completeLesson } from './lessonApi.js';

export default {
    name: "Lesson",
    components: {
        Card, Header, FeedbackModal, WarningModal, ExitConfirmModal,
        ProcessedText, PronunciationTooltip, ExerciseImage, CompletionMessage, NoEnergyModal, WordBank, MatchPairs
    },
    props: {
        unitId: {
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
            // Carga
            dataLoading: true,

            // Datos de la lección
            currentQuestion: 1,
            selectedAnswer: null,
            textAnswer: '',
            wordBankSel: [],
            matchMistakes: 0, // errores en "Selecciona los pares"
            showResult: false,
            isAnswerCorrect: false,
            currentExercises: [],
            currentLevel: {},
            currentUnit: {},
            unitVocabulary: {},

            authStore: useAuthStore(),
            lessonInProgress: false,

            // Modales
            showFeedbackModal: false,
            showWarningModal: false,
            showExitConfirmModalFlag: false,
            feedbackTitle: '',
            feedbackMessage: '',

            // Métricas
            isVerifying: false,
            correctAnswersCount: 0,
            screenHeight: 0,
            lessonStartTime: null,
            lessonTime: 0,
            earnedExp: 0,

            // Energía
            showNoEnergyModal: false,
            noEnergyModalType: 'depleted',
            requiredEnergyForLesson: 10,
            energyCheckInterval: null,
            pendingSync: false,

            // Secuencia (lessonPlan.js): cuántos pasos tenía el plan (sin repeticiones de errores),
            // aciertos al primer intento y XP de los ejercicios de la base
            plannedCount: 0,
            firstTryCorrect: 0,
            authoredPoints: 0,
        };
    },
    computed: {
        currentExercise() {
            return this.currentExercises[this.currentQuestion - 1] || {};
        },
        currentUnitVocabulary() {
            const vocab = this.unitVocabulary;
            if (!vocab) return [];
            if (Array.isArray(vocab)) return vocab;
            if (typeof vocab === 'object') {
                return Object.keys(vocab).map(key => ({
                    word: key,
                    pronunciation: vocab[key].pronunciation || '',
                    translation: vocab[key].translation || '',
                    example: vocab[key].example || '',
                    breakdown: vocab[key].breakdown || ''
                }));
            }
            return [];
        },
        badgeInfo() {
            switch (this.currentExercise.badge) {
                case BADGE.NEW: return { label: 'Palabra nueva', icon: '✦', cls: 'text-fuchsia-300' };
                case BADGE.REVIEW: return { label: 'Repaso', icon: '↻', cls: 'text-turquesa' };
                case BADGE.MISTAKE: return { label: 'Error anterior', icon: '⟲', cls: 'text-amber-400' };
                default: return null;
            }
        },
        containerClasses() {
            if (this.screenHeight <= 658) return 'md:pt-[1%] md:py-[10%]';
            return 'md:pt-[15%] md:pb-[20%]';
        },
    },

    async created() {
        await this.fetchLessonData();
        await this.energyStore.initializeEnergy(this.authStore.user?.id || 1);
        this.setupPageReloadPrevention();
        this.checkEnergyBeforeLesson();
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
        // Estado visual de una opción (estilos .tl-choice en src/style.css)
        choiceState(index) {
            const ex = this.currentExercise;
            if (this.showResult && index === ex.correctAnswer) return 'is-correct';
            if (this.showResult && index === this.selectedAnswer) return 'is-wrong';
            return this.selectedAnswer === index ? 'is-selected' : '';
        },
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

        async fetchLessonData() {
            this.dataLoading = true;
            try {
                const data = await loadLessonData(this.unitId);
                this.currentUnit = data.currentUnit || {};
                this.currentLevel = data.currentLevel || {};
                this.unitVocabulary = data.vocabulary || {};
                const authored = this.shuffleExerciseOptions(data.currentExercises || []);
                this.authoredPoints = authored.reduce((t, ex) => t + (ex.points || 15), 0);
                // Secuencia tipo Duolingo: palabra nueva → reconocerla → ejercicios + repaso → armar frases
                this.currentExercises = buildLessonPlan({
                    exercises: authored,
                    vocabulary: data.vocabulary,
                    review: data.reviewVocabulary || [],
                    extra: data.extraVocabulary || [],
                    languageName: this.authStore.selectedLangObj?.langName || 'la lengua',
                });
                this.plannedCount = this.currentExercises.length;
            } catch (err) {
                console.error('[LessonView] fetchLessonData:', err);
            } finally {
                this.dataLoading = false;
            }
        },

        startLesson() {
            this.lessonInProgress = true;
            this.lessonStartTime = Date.now();
            this.startEnergyMonitoring();
        },

        selectAnswer(index) {
            if (!this.showResult) {
                this.selectedAnswer = index;
            }
        },

        async verifyAnswer() {
            if (this.isVerifying) return;
            this.isVerifying = true;

            if (this.showResult) {
                this.continueFromModal();
                this.isVerifying = false;
                return;
            }

            this.showResult = true;

            if (this.currentExercise.type === 'multiple-choice') {
                this.isAnswerCorrect = this.selectedAnswer === this.currentExercise.correctAnswer;
            } else if (this.currentExercise.type === 'fill-blank') {
                const correct = this.currentExercise.correctAnswer;
                const clean = s => s?.toString().toLowerCase().trim();
                if (Array.isArray(correct)) {
                    this.isAnswerCorrect = correct.some(c => clean(c) === clean(this.textAnswer));
                } else {
                    this.isAnswerCorrect = clean(correct) === clean(this.textAnswer);
                }
            } else if (this.currentExercise.type === 'word-bank') {
                const tiles = this.currentExercise.tiles || [];
                this.isAnswerCorrect = checkWordBank(this.wordBankSel.map(i => tiles[i]), this.currentExercise.accepted);
            } else if (this.currentExercise.type === 'match') {
                this.isAnswerCorrect = this.matchMistakes === 0;
            }

            // Lo que se falla se repite al final de la lección, una vez ("Error anterior")
            if (!this.isAnswerCorrect && !this.currentExercise.isRetry) {
                this.currentExercises.push(mistakeRetry(this.currentExercise));
            }
            if (this.isAnswerCorrect && !this.currentExercise.isRetry) this.firstTryCorrect++;

            const energyResult = await this.energyStore.consumeForExercise(this.isAnswerCorrect);

            if (this.isAnswerCorrect) this.correctAnswersCount++;

            if (this.energyStore.currentEnergy <= 0 && this.lessonInProgress) {
                this.lessonInProgress = false;
                if (this.energyCheckInterval) {
                    clearInterval(this.energyCheckInterval);
                    this.energyCheckInterval = null;
                }
                this.showFeedback(
                    this.isAnswerCorrect ? '¡Buen trabajo!' : 'Inténtalo de nuevo',
                    this.currentExercise.explanation || ''
                );
                setTimeout(() => this.handleEnergyDepleted(), 100);
                this.isVerifying = false;
                return;
            }

            const streakBonus = energyResult.streak >= 3 ? '' : '';
            if (this.currentExercise.type === 'match') {
                // Sin cuadro de resultado: los pares ya se revisaron uno por uno
            } else if (this.isAnswerCorrect) {
                this.showFeedback('¡Buen trabajo!',
                    (this.currentExercise.explanation || 'Respuesta correcta.') + streakBonus);
            } else {
                const accepted = this.currentExercise.type === 'word-bank' ? this.currentExercise.accepted?.[0] : null;
                this.showFeedback('Inténtalo de nuevo',
                    accepted
                        ? `Respuesta correcta: ${accepted}`
                        : (this.currentExercise.explanation || 'La respuesta no es correcta.'));
            }

            this.isVerifying = false;
        },

        /** Terminó "Selecciona los pares": se califica (errores → se repite al final) y pasa al siguiente solo. */
        async onMatchDone(mistakes) {
            this.matchMistakes = mistakes;
            await this.verifyAnswer();
            if (this.lessonInProgress && !this.showFeedbackModal) this.continueFromModal();
        },
        continueFromModal() {
            if (!this.lessonInProgress) { this.closeFeedbackModal(); return; }
            this.closeFeedbackModal();
            this.currentQuestion++;
            this.selectedAnswer = null;
            this.textAnswer = '';
            this.wordBankSel = [];
            this.matchMistakes = 0;
            this.showResult = false;
            this.isAnswerCorrect = false;

            if (this.currentQuestion > this.currentExercises.length) {
                this.completeCurrentUnit();
                this.lessonInProgress = false;
            }
        },

        async completeCurrentUnit() {
            this.lessonTime = this.lessonStartTime
                ? Math.floor((Date.now() - this.lessonStartTime) / 1000)
                : 0;

            // Desempeño = aciertos al primer intento sobre los pasos del plan (las repeticiones de errores no cuentan)
            const performance = this.plannedCount > 0
                ? this.firstTryCorrect / this.plannedCount
                : 1.0;

            const earnedPoints = this.calculateEarnedPoints();

            try {
                const result = await completeLesson({
                    unitId: this.currentUnit.id,
                    levelId: this.currentLevel.id,
                    performance,
                    earnedExp: earnedPoints,
                    correctAns: this.firstTryCorrect,
                    totalExerc: this.plannedCount,
                    timeSeconds: this.lessonTime,
                });

                this.earnedExp = result.xpEarned ?? earnedPoints;
                this.pendingSync = result.offline === true;

                if (result.offline) {
                    this.showFeedback('¡Lección completada!', 'Sin conexión: tu avance se guardará cuando vuelva el internet.');
                } else if (result.wasAlreadyCompleted) {
                    this.showFeedback('¡Lección repasada!', 'Fresco como una lechuga!');
                } else {
                    this.showFeedback('¡Lección completada!', 'Has desbloqueado nuevas unidades.');
                }
            } catch (err) {
                console.error('[LessonView] completeCurrentUnit:', err);
                this.earnedExp = earnedPoints;
            }
        },

        // XP = puntos de los ejercicios de la base × desempeño. Los pasos generados (palabra nueva, repaso,
        // armar frase) no suman XP propia: así la XP por nivel sigue igual que antes (UserLevelService).
        calculateEarnedPoints() {
            const performance = this.plannedCount > 0 ? this.firstTryCorrect / this.plannedCount : 1;
            return Math.round(this.authoredPoints * performance);
        },

        checkEnergyBeforeLesson() {
            const current = this.energyStore.currentEnergy;
            if (current >= this.requiredEnergyForLesson) {
                this.startLesson();
                return true;
            }
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
            if (this.energyCheckInterval) {
                clearInterval(this.energyCheckInterval);
                this.energyCheckInterval = null;
            }
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
            leaveTo(this.$router, `/app/nivel/${this.currentLevel.id}`);
        },

        handlePracticeForEnergy() {
            this.showNoEnergyModal = false;
            leaveTo(this.$router, '/app');
        },

        closeNoEnergyModal() {
            this.showNoEnergyModal = false;
            if (this.noEnergyModalType === 'insufficient') {
                this.lessonInProgress = true;
                if (!this.lessonStartTime) this.lessonStartTime = Date.now();
                this.startEnergyMonitoring();
            }
            if (this.energyStore.currentEnergy <= 0) {
                leaveTo(this.$router, `/app/nivel/${this.currentLevel.id}`);
            }
        },

        showFeedback(title, message) {
            this.feedbackTitle = title;
            this.feedbackMessage = message;
            this.showFeedbackModal = true;
        },
        closeFeedbackModal() { this.showFeedbackModal = false; },
        closeWarningModal() { this.showWarningModal = false; },
        showExitConfirmModal() { this.showExitConfirmModalFlag = true; },
        closeExitConfirmModal() { this.showExitConfirmModalFlag = false; },
        confirmExitLesson() { this.closeExitConfirmModal(); leaveTo(this.$router, `/app/nivel/${this.currentLevel.id}`); },
        endSession() { this.closeWarningModal(); leaveTo(this.$router, `/app/nivel/${this.currentLevel.id}`); },

        setupPageReloadPrevention() {
            window.addEventListener('keydown', this.preventReloadKeys);
            window.addEventListener('beforeunload', this.preventUnload);
            window.addEventListener('resize', this.updateHeight);
        },
        cleanupPageReloadPrevention() {
            window.removeEventListener('keydown', this.preventReloadKeys);
            window.removeEventListener('beforeunload', this.preventUnload);
            window.removeEventListener('resize', this.updateHeight);
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