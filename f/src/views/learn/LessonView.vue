<template>
    <div class="text-white pt-[10%] flex flex-col -mx-2  md:mx-[-50%]" :class="containerClasses">
        <!-- Header con título dinámico - SOLO se muestra durante la lección -->
        <Header v-if="currentQuestion <= currentExercises.length" variant="progress" :title="currentUnit.title"
            :subtitle="`Nivel ${currentLevel.id}, Unidad ${currentUnit.id}`" :progressCurrent="currentQuestion - 1"
            :progressTotal="currentExercises.length" :backRoute="`/nivel/${currentLevel.id}`"
            @exit-lesson="showExitConfirmModal" />

        <!-- Contenido -->
        <div class="flex-1 flex items-center justify-center md:mt-[9%] overflow-hidden">

            <!-- contenedor flex columna -->
            <div class="flex flex-col w-full items-center">
                <div class="w-full">
                    <!-- QUESTION DESKTOP -->
                    <h1 class="hidden md:block text-3xl ml-20 font-bold mb-4">{{
                        currentExercise.question }}
                    </h1>
                </div>

                <div class="w-full max-w-2xl md:max-w-4xl">
                    <!-- Mostrar ejercicio actual -->
                    <Card v-if="currentQuestion <= currentExercises.length">

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
                                            border-r-[25px] bg-[#0a2136] border border-[#37464f]
                                            border-b-[15px] border-b-transparent z-10"></div>

                                        <!-- Div principal -->
                                        <div
                                            class="relative text-white bg-[#0a2136] border border-[#37464f] py-3 px-6 text-center rounded-lg shadow-lg z-20 inline-block">
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
                                        <button @click="selectAnswerWithSound(index, option)" :class="{
                                            'border border-[#3f85a7] text-[#3f85a7] bg-gray-800': selectedAnswer === index,
                                            'bg-gray-700 text-white': selectedAnswer !== index,
                                            'border border-green-600 text-green-600': showResult && index === currentExercise.correctAnswer,
                                            'border border-red-600 text-red-600': showResult && selectedAnswer === index && selectedAnswer !== currentExercise.correctAnswer,
                                            'border-2 border-green-500 text-green-500': showResult && index === currentExercise.correctAnswer,
                                            'border-2 border-red-500 text-red-500': showResult && selectedAnswer === index && selectedAnswer !== currentExercise.correctAnswer
                                        }"
                                            class="md:h-[58px] h-[65px] p-3 rounded-lg hover:bg-gray-600 font-semibold tracking-wider transition-colors flex items-center justify-center text-center break-words w-full">
                                            <span class="text-sm md:text-base">
                                                {{ option }}
                                            </span>
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

                    <!-- Mensaje de finalización - DISEÑO LESSONVIEW -->
                    <CompletionMessage v-if="currentQuestion > this.currentExercises.length"
                        title="¡Lección completada!" :back-route="`/nivel/${currentLevel.id}`"
                        :performance="correctAnswersCount / currentExercises.length" :lesson-time="lessonTime" />
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
import PronunciationTooltip from '../../components/PronunciationTooltip.vue';
import ExerciseImage from '../../components/ExerciseImage.vue';

import CompletionMessage from '../../components/CompletionMessage.vue';

import { useAuthStore } from '../../stores/auth';
import { getLearningRepository } from '../../data/repositories/RepositoryFactory.js';
import { ProgressService } from '../../data/services/ProgressService.js';
import { SpeechService } from '../../data/services/SpeechService.js';
import placeholder from '../../assets/300x300.png';


export default {
    name: "Lesson",
    components: {
        Card,
        Header,
        FeedbackModal,
        WarningModal,
        ExitConfirmModal,
        ProcessedText,
        PronunciationTooltip,
        ExerciseImage,
        CompletionMessage
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
            isAnswerCorrect: false,
            currentExercises: [],
            currentLevel: {},
            currentUnit: {},
            placeholder: placeholder,
            authStore: useAuthStore(),
            learningRepo: getLearningRepository(),
            progressService: new ProgressService(),
            lessonInProgress: true,
            showFeedbackModal: false,
            showWarningModal: false,
            showExitConfirmModalFlag: false,
            feedbackTitle: '',
            feedbackMessage: '',
            correctAnswersCount: 0,
            screenHeight: 0,
            lessonStartTime: null,
            lessonTime: 0
        };
    },
    computed: {
        currentExercise() {
            return this.currentExercises[this.currentQuestion - 1] || {};
        },
        // Obtener vocabulario de la unidad actual - CONVERTIDO A ARRAY
        // En LessonView.vue - computed property
        currentUnitVocabulary() {
            if (!this.currentUnit.vocabulary) return [];

            // console.log('📚 Vocabulario de unidad:', this.currentUnit.vocabulary);

            // Si es un array, devolverlo tal cual
            if (Array.isArray(this.currentUnit.vocabulary)) {
                return this.currentUnit.vocabulary;
            }

            // Si es un objeto, convertirlo a array
            if (typeof this.currentUnit.vocabulary === 'object') {
                const vocabularyArray = Object.keys(this.currentUnit.vocabulary).map(key => {
                    const item = this.currentUnit.vocabulary[key];
                    return {
                        word: key,
                        pronunciation: item.pronunciation || '',
                        translation: item.translation || '',
                        example: item.example || ''
                    };
                });
                // console.log('🔄 Vocabulario convertido a array:', vocabularyArray);
                return vocabularyArray;
            }

            return [];
        },
        // Verificar si se desbloqueó siguiente unidad
        hasUnlockedNextUnit() {
            const language = this.authStore.selectedLanguage;
            const nextUnit = this.learningRepo.getNextUnit(language, this.currentLevel.id, this.currentUnit.id);
            return nextUnit && !nextUnit.locked;
        },
        containerClasses() {
            if (this.screenHeight <= 658) {
                return 'md:pt-[1%] md:py-[10%]'; // md:bg-cyan-700
            } else if (this.screenHeight >= 700) {
                return 'md:pt-[15%] md:pb-[20%]'; // md:bg-red-700
            }
        }
    },
    created() {
        this.loadLessonData();
        this.setupPageReloadPrevention();
        this.lessonStartTime = Date.now(); // Iniciar timer
    },
    beforeUnmount() {
        this.cleanupPageReloadPrevention();
    },

    methods: {
        // En el método loadLessonData()
        async loadLessonData() {
            const language = this.authStore.selectedLanguage;
            const levels = this.learningRepo.getLevels(language);

            // console.log('🔍 BUSCANDO UNIDAD:', this.unitId);
            // console.log('📊 NIVELES DISPONIBLES:', levels);

            for (const level of levels) {
                const units = this.learningRepo.getUnits(language, level.id);
                // console.log(`📋 UNIDADES DEL NIVEL ${level.id}:`, units);

                const unit = units.find(u => u.id === Number(this.unitId));

                if (unit) {
                    // console.log('✅ UNIDAD ENCONTRADA:', unit);
                    // console.log('📚 VOCABULARIO DE LA UNIDAD:', unit.vocabulary);

                    this.currentUnit = unit;
                    this.currentLevel = level;
                    this.currentExercises = this.learningRepo.getExercisesForUnit(language, level.id, unit.id);
                    break;
                }
            }

            // console.log('🏁 FINAL - currentUnit:', this.currentUnit);
            // console.log('🏁 FINAL - currentUnitVocabulary:', this.currentUnitVocabulary);
        },

        // Usar pronunciación específica cuando esté disponible
        selectAnswerWithSound(index, option) {
            // 1. Primero selecciona la respuesta
            this.selectAnswer(index);

            // 2. Luego reproduce el sonido con pronunciación específica si está disponible
            // this.speakOption(option); // DESHABILITADO POR BUGS
        },

        selectAnswer(index) {
            if (!this.showResult) {
                this.selectedAnswer = index;
            }
        },

        // Buscar pronunciación específica en el vocabulario
        speakOption(optionText) {
            // Buscar si la opción coincide con alguna palabra del vocabulario de la unidad
            const matchingVocabulary = this.currentUnitVocabulary.find(item =>
                item.word === optionText || item.translation === optionText
            );

            if (matchingVocabulary) {
                // Si encontramos vocabulario coincidente, usar SpeechService mejorado
                SpeechService.speakVocabularyItem(matchingVocabulary);
            } else {
                // Si no, usar la opción tal cual
                SpeechService.speakWord(optionText);
            }
        },

        // Método para hablar la pregunta principal [DEMO]
        speakQuestion() {
            const question = this.currentExercise.question;

            // Buscar si la pregunta contiene palabras del vocabulario
            const wordsInQuestion = question.split(' ');
            let foundPronunciation = false;

            for (const word of wordsInQuestion) {
                const matchingVocabulary = this.currentUnitVocabulary.find(item =>
                    item.word === word || item.translation.includes(word)
                );

                if (matchingVocabulary && matchingVocabulary.pronunciation) {
                    SpeechService.speakVocabularyItem(matchingVocabulary);
                    foundPronunciation = true;
                    break;
                }
            }

            // Si no se encontró pronunciación específica, hablar la pregunta completa
            if (!foundPronunciation) {
                SpeechService.speakWord(question);
            }
        },

        verifyAnswer() {
            if (this.showResult) {
                this.continueFromModal();
            } else {
                this.showResult = true;

                if (this.currentExercise.type === 'multiple-choice') {
                    this.isAnswerCorrect = this.selectedAnswer === this.currentExercise.correctAnswer;
                } else if (this.currentExercise.type === 'fill-blank') {
                    this.isAnswerCorrect = this.currentExercise.validateAnswer(this.textAnswer);
                }

                // CONTAR RESPUESTAS CORRECTAS
                if (this.isAnswerCorrect) {
                    this.correctAnswersCount++;
                }

                if (this.isAnswerCorrect) {
                    this.showFeedback('¡Buen trabajo!', this.currentExercise.explanation || 'Respuesta correcta.');
                } else {
                    this.showFeedback('Inténtalo de nuevo', this.currentExercise.explanation || 'La respuesta no es correcta.');
                }
            }
        },
        continueFromModal() {
            this.closeFeedbackModal();
            this.currentQuestion++;
            this.selectedAnswer = null;
            this.textAnswer = '';
            this.showResult = false;
            this.isAnswerCorrect = false;

            if (this.currentQuestion > this.currentExercises.length) {
                this.completeCurrentUnit();
                this.lessonInProgress = false;
            }
        },
        // manejar el caso de repetición
        completeCurrentUnit() {
            // Calcular tiempo de lección
            this.lessonTime = Math.floor((Date.now() - this.lessonStartTime) / 1000);

            const language = this.authStore.selectedLanguage;

            // CALCULAR PERFORMANCE
            const performance = this.currentExercises.length > 0 ?
                this.correctAnswersCount / this.currentExercises.length : 1.0;

            // OBTENER PALABRAS APRENDIDAS DEL VOCABULARIO DE LA UNIDAD (corregido)
            const wordsLearned = this.currentUnit.vocabulary && typeof this.currentUnit.vocabulary === 'object' ?
                Object.keys(this.currentUnit.vocabulary).map(wordKey => ({
                    word: wordKey,
                    translation: this.currentUnit.vocabulary[wordKey].translation,
                    dialect: language
                })) : [];

            // console.log('📝 Palabras aprendidas:', wordsLearned);

            // COMPLETAR LECCIÓN CON PROGRESSSERVICE
            const result = this.progressService.completeLesson(
                1, // userId
                language,
                this.currentLevel.id,
                this.currentUnit.id,
                performance,
                wordsLearned
            );

            // MOSTRAR MENSAJE DIFERENTE SI ES REPETICIÓN
            if (result.wasAlreadyCompleted) {
                this.showFeedback(
                    '¡Lección repasada!',
                    'Fresco como una lechuga!'
                );
            } else {
                // COMPLETAR UNIDAD EN LEARNINGREPOSITORY (solo si no estaba completada)
                this.learningRepo.completeUnit(language, this.currentLevel.id, this.currentUnit.id);

                // DESBLOQUEAR SIGUIENTE UNIDAD
                this.unlockNextUnit(language, this.currentLevel.id, this.currentUnit.id);

                this.showFeedback(
                    '¡Lección completada!',
                    'Has desbloqueado nuevas unidades.'
                );
            }
        },

        // NUEVO MÉTODO PARA DESBLOQUEAR SIGUIENTE UNIDAD
        unlockNextUnit(language, levelId, unitId) {
            const units = this.learningRepo.getUnits(language, levelId);
            const currentUnitIndex = units.findIndex(unit => unit.id === unitId);

            // Desbloquear siguiente unidad si existe
            if (currentUnitIndex !== -1 && currentUnitIndex < units.length - 1) {
                const nextUnit = units[currentUnitIndex + 1];
                if (nextUnit && nextUnit.locked) {
                    this.learningRepo.unlockUnit(language, levelId, nextUnit.id);
                    // console.log(`🔓 Unidad ${nextUnit.id} desbloqueada`);
                }
            }

            // Verificar si se debe desbloquear el siguiente nivel
            this.checkLevelUnlock(language, levelId);
        },

        // VERIFICAR DESBLOQUEO DE NIVEL
        checkLevelUnlock(language, levelId) {
            const currentLevel = this.learningRepo.getLevel(language, levelId);
            const units = this.learningRepo.getUnits(language, levelId);

            // Contar unidades completadas
            const completedUnits = units.filter(unit => unit.completed).length;

            // Verificar requisitos para desbloquear siguiente nivel
            const levels = this.learningRepo.getLevels(language);
            const currentLevelIndex = levels.findIndex(level => level.id === levelId);

            if (currentLevelIndex !== -1 && currentLevelIndex < levels.length - 1) {
                const nextLevel = levels[currentLevelIndex + 1];

                if (nextLevel && nextLevel.locked) {
                    // Verificar requisitos específicos del nivel
                    const unlockRequirement = nextLevel.unlockRequirement;

                    if (unlockRequirement.includes('Completar Nivel')) {
                        // Requiere completar el nivel actual
                        const allUnitsCompleted = units.every(unit => unit.completed);
                        if (allUnitsCompleted) {
                            this.learningRepo.unlockLevel(language, nextLevel.id);
                            // console.log(`🎉 Nivel ${nextLevel.id} desbloqueado!`);
                        }
                    } else if (unlockRequirement.includes('unidades')) {
                        // Requiere completar X unidades
                        const match = unlockRequirement.match(/(\d+)\s*unidades/);
                        if (match && completedUnits >= parseInt(match[1])) {
                            this.learningRepo.unlockLevel(language, nextLevel.id);
                            // console.log(`🎉 Nivel ${nextLevel.id} desbloqueado!`);
                        }
                    }
                }
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
    watch: {
        currentUnitVocabulary: {
            handler(newVocab) {
                // console.log('🔍 VOCABULARIO ACTUAL DE LA UNIDAD:', newVocab);
                // console.log('📝 Ejercicio actual:', this.currentExercise);
            },
            immediate: true,
            deep: true
        },
        currentExercise: {
            handler(newExercise) {
                // console.log('🔄 Ejercicio cambiado:', newExercise);
                if (newExercise && newExercise.answer) {
                    // console.log('📋 Texto a procesar:', newExercise.answer);
                }
            },
            immediate: true
        }
    },
    mounted() {
        this.updateHeight(); // Inicializar la altura al montar
    }
};
</script>

<!-- <Card v-if="currentQuestion > this.currentExercises.length"
                        class="text-center md:pt-[5%] md:pb-[6%] md:scale-125">
                        <h2 class="text-xl font-semibold mb-4">¡Lección completada!</h2>

                        <div class="flex flex-col">
                            <router-link :to="`/nivel/${currentLevel.id}`">
                                <button
                                    class="bg-[#31771c] hover:bg-[#58cc02] text-white font-extrabold py-3 px-6 rounded-lg transition-colors w-full">
                                    RECIBIR EXP
                                </button>
                            </router-link>
                        </div>
                    </Card> -->