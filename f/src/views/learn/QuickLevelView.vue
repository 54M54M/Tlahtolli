<template>
    <div class="text-white pt-[10%] flex flex-col -mx-2 md:mx-[-50%]" :class="containerClasses">

        <Header v-if="currentQuestion <= quickExercises.length" variant="lesson" :title="`Nivel Rápido ${levelId}`"
            :progressCurrent="completedExercises" :progressTotal="quickExercises.length"
            :backRoute="`/nivel/${levelId}`" @exit-lesson="showExitConfirmModalFlag = true"
            @energy-click="handleEnergyClick" />

        <!-- Loading -->
        <div v-if="dataLoading" class="flex items-center justify-center h-64">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-white"></div>
        </div>

        <div v-else class="flex-1 flex items-center justify-center md:mt-[9%] overflow-hidden">
            <div class="flex flex-col w-full items-center">
                <div class="w-full">
                    <h1 class="hidden md:block text-3xl ml-20 font-bold mb-4">
                        {{ currentExercise.question }}
                    </h1>
                </div>

                <div class="w-full max-w-2xl md:max-w-4xl">
                    <Card v-if="currentQuestion <= quickExercises.length">
                        <h2 class="md:hidden block text-xl font-semibold mb-4">
                            {{ currentExercise.question }}
                        </h2>

                        <div class="md:flex md:gap-2 md:px-10 md:py-3 md:scale-125">
                            <div class="flex ml-2 md:justify-center mb-3 md:mb-0 md:w-1/3">
                                <ExerciseImage :characterName="currentExercise.character"
                                    :imageState="!showResult || isAnswerCorrect"
                                    :altText="`Personaje ${currentExercise.character}`" />

                                <!-- Respuesta MOBILE -->
                                <div v-if="currentExercise.answer" class="sm:hidden block mx-3 mt-10">
                                    <div class="relative">
                                        <div class="absolute top-1/2 -translate-y-1/2 -left-3 w-0 h-0
                      border-t-[15px] border-t-transparent border-r-[25px] bg-[#0a2136]
                      border border-[#37464f] border-b-[15px] border-b-transparent z-10"></div>
                                        <div class="relative text-white bg-[#0a2136] border border-[#37464f]
                      py-3 px-6 text-center rounded-lg shadow-lg z-20 inline-block">
                                            <p class="text-lg font-medium">{{ currentExercise.answer }}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="md:w-2/3 md:pr-2">
                                <!-- Respuesta DESKTOP -->
                                <div v-if="currentExercise.answer" class="hidden md:block w-full mb-2">
                                    <div class="relative md:-ml-7">
                                        <div class="absolute top-1/2 -translate-y-1/4 -left-3 w-0 h-0
                      border-t-[15px] border-t-transparent border-r-[25px] bg-[#0a2136]
                      border border-[#37464f] border-b-[15px] border-b-transparent z-10"></div>
                                        <div class="relative text-white bg-[#0a2136] border border-[#37464f]
                      py-3 px-6 text-center rounded-lg shadow-lg z-20 inline-block">
                                            <p class="text-xl font-medium md:-ml-2">{{ currentExercise.answer }}</p>
                                        </div>
                                    </div>
                                </div>

                                <!-- Opciones múltiple -->
                                <div v-if="currentExercise.type === 'multiple-choice'"
                                    class="grid grid-cols-2 gap-3 md:-ml-7">
                                    <button v-for="(option, index) in currentExercise.options" :key="index"
                                        @click="selectAnswer(index)" :class="{
                                            'border border-[#3f85a7] text-[#3f85a7] bg-gray-800': selectedAnswer === index && !showResult,
                                            'bg-gray-700 text-white': selectedAnswer !== index && !showResult,
                                            'border-2 border-green-500 text-green-500': showResult && index === currentExercise.correctAnswer,
                                            'border-2 border-red-500 text-red-500': showResult && selectedAnswer === index && selectedAnswer !== currentExercise.correctAnswer,
                                        }" class="md:h-[58px] h-[65px] p-3 rounded-lg hover:bg-gray-600 font-semibold
                      tracking-wider transition-colors flex items-center justify-center
                      text-center break-words w-full">
                                        <span class="text-sm md:text-base">{{ option }}</span>
                                    </button>
                                </div>

                                <!-- Fill blank -->
                                <div v-else-if="currentExercise.type === 'fill-blank'" class="md:-ml-7">
                                    <textarea v-model="textAnswer"
                                        :placeholder="currentExercise.placeholder || 'Escribe tu respuesta...'"
                                        :readonly="showResult" :class="{
                                            'border-green-500 bg-green-900/20': showResult && isAnswerCorrect,
                                            'border-red-500 bg-red-900/20': showResult && !isAnswerCorrect,
                                            'border-gray-600': !showResult,
                                        }" class="w-full h-40 md:h-32 outline-none p-3 rounded-lg bg-gray-700
                      border-2 transition-colors lowercase resize-none">
                  </textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Botón verificar -->
                        <div class="fixed bottom-0 left-0 right-0 p-5 max-w-2xl mx-auto
              md:float-right md:left-[38%] md:p-5 md:mt-8 md:max-w-[190px]"
                            :class="{ 'md:hidden': showFeedbackModal }">
                            <button @click="verifyAnswer" :disabled="(currentExercise.type === 'multiple-choice' && selectedAnswer === null) ||
                                (currentExercise.type === 'fill-blank' && !textAnswer)" class="w-full bg-[#31771c] hover:bg-[#58cc02] text-white py-5 md:py-3
                  px-8 rounded-lg disabled:bg-[#37464f] disabled:text-stone-500 text-lg font-medium">
                                {{ showResult ? 'Continuar' : 'Verificar' }}
                            </button>
                        </div>

                        <FeedbackModal :show="showFeedbackModal" :title="feedbackTitle" :message="feedbackMessage"
                            :is-correct="isAnswerCorrect" @continue="continueFromModal" />
                    </Card>

                    <!-- Pantalla de completado -->
                    <CompletionMessage v-if="currentQuestion > quickExercises.length" title="¡Nivel Rápido Completado!"
                        :back-route="`/nivel/${levelId}`" :show-stats="true"
                        :correct-answers-count="correctAnswersCount" :total-exercises="quickExercises.length"
                        :performance="performance" :lesson-time="lessonTime" :show-unlock-section="true"
                        :unlocked-next-level-unit="unlockedNextLevel" :next-level-id="nextLevelId" />
                </div>
            </div>
        </div>

        <ExitConfirmModal :show="showExitConfirmModalFlag" @close="showExitConfirmModalFlag = false"
            @confirm="$router.push(`/nivel/${levelId}`)" />

        <NoEnergyModal :show="showNoEnergyModal" :modal-type="noEnergyModalType"
            :current-energy="energyStore.currentEnergy" :max-energy="energyStore.maxEnergy" :required-energy="10"
            :redirect-to="`/nivel/${levelId}`" @return="$router.push(`/nivel/${levelId}`)"
            @close="closeNoEnergyModal" />
    </div>
</template>

<script>
import { useAuthStore } from '../../stores/auth.js'
import { useEnergyStore } from '../../stores/energy.js'
import { learningApi, progressApi } from '../../api/apiClient.js'

import Card from '../../components/Card.vue'
import Header from '../../components/vHeader.vue'
import FeedbackModal from '../../components/FeedbackModal.vue'
import ExitConfirmModal from '../../components/ExitConfirmModal.vue'
import NoEnergyModal from '../../components/NoEnergyModal.vue'
import CompletionMessage from '../../components/CompletionMessage.vue'
import ExerciseImage from '../../components/ExerciseImage.vue'

export default {
    name: 'QuickLevel',
    components: {
        Card, Header, FeedbackModal, ExitConfirmModal,
        NoEnergyModal, CompletionMessage, ExerciseImage,
    },
    props: {
        levelId: { type: [String, Number], required: true },
    },
    setup() {
        const authStore = useAuthStore()
        const energyStore = useEnergyStore()
        return { authStore, energyStore }
    },
    data() {
        return {
            dataLoading: true,
            quickExercises: [],
            currentQuestion: 1,
            completedExercises: 0,
            selectedAnswer: null,
            textAnswer: '',
            showResult: false,
            isAnswerCorrect: false,
            showFeedbackModal: false,
            feedbackTitle: '',
            feedbackMessage: '',
            showExitConfirmModalFlag: false,
            showNoEnergyModal: false,
            noEnergyModalType: 'depleted',
            correctAnswersCount: 0,
            lessonStartTime: null,
            lessonTime: 0,
            performance: 0,
            unlockedNextLevel: false,
            nextLevelId: null,
            lessonInProgress: false,
            screenHeight: window.innerHeight,
        }
    },
    computed: {
        currentExercise() {
            return this.quickExercises[this.currentQuestion - 1] || {}
        },
        containerClasses() {
            return this.screenHeight <= 658
                ? 'md:pt-[1%] md:py-[10%]'
                : 'md:pt-[15%] md:pb-[20%]'
        },
    },
    async created() {
        await this.init()
    },
    beforeUnmount() {
        this.lessonInProgress = false
        window.removeEventListener('resize', this.onResize)
    },
    methods: {
        async init() {
            this.dataLoading = true
            try {
                await this.energyStore.initializeEnergy(this.authStore.user?.id || 1)
                if (!this.checkEnergy()) return

                // Cargar 6 ejercicios aleatorios del nivel
                this.quickExercises = await learningApi.getQuick(Number(this.levelId), 6)

                this.lessonInProgress = true
                this.lessonStartTime = Date.now()
                window.addEventListener('resize', this.onResize)
            } catch (err) {
                console.error('[QuickLevelView] init:', err)
            } finally {
                this.dataLoading = false
            }
        },

        checkEnergy() {
            const e = this.energyStore.currentEnergy
            if (e >= 10) return true
            this.noEnergyModalType = e === 0 ? 'depleted' : 'insufficient'
            this.showNoEnergyModal = true
            return false
        },

        selectAnswer(index) {
            if (!this.showResult) this.selectedAnswer = index
        },

        async verifyAnswer() {
            if (this.showResult) { this.continueFromModal(); return }

            this.showResult = true

            if (this.currentExercise.type === 'multiple-choice') {
                this.isAnswerCorrect = this.selectedAnswer === this.currentExercise.correctAnswer
            } else if (this.currentExercise.type === 'fill-blank') {
                const correct = this.currentExercise.correctAnswer
                const clean = s => s?.toString().toLowerCase().trim()
                this.isAnswerCorrect = Array.isArray(correct)
                    ? correct.some(c => clean(c) === clean(this.textAnswer))
                    : clean(correct) === clean(this.textAnswer)
            }

            await this.energyStore.consumeForExercise(this.isAnswerCorrect)
            if (this.isAnswerCorrect) this.correctAnswersCount++

            if (this.energyStore.currentEnergy <= 0 && this.lessonInProgress) {
                this.lessonInProgress = false
                this.noEnergyModalType = 'depleted'
                this.showNoEnergyModal = true
                return
            }

            this.showFeedback(
                this.isAnswerCorrect ? '¡Correcto!' : 'Incorrecto',
                this.currentExercise.explanation || ''
            )
        },

        continueFromModal() {
            if (!this.lessonInProgress) { this.showFeedbackModal = false; return }
            this.showFeedbackModal = false
            this.completedExercises++
            this.currentQuestion++
            this.selectedAnswer = null
            this.textAnswer = ''
            this.showResult = false
            this.isAnswerCorrect = false

            if (this.currentQuestion > this.quickExercises.length) {
                this.finishQuickLevel()
                this.lessonInProgress = false
            }
        },

        async finishQuickLevel() {
            this.lessonTime = Math.floor((Date.now() - this.lessonStartTime) / 1000)
            this.performance = this.correctAnswersCount / this.quickExercises.length

            const earnedExp = this.quickExercises
                .slice(0, this.correctAnswersCount)
                .reduce((sum, ex) => sum + (ex.points || 15), 0)

            try {
                // El QuickLevel completa todas las unidades del nivel via endpoint
                const result = await progressApi.complete({
                    userId: this.authStore.user?.id || 1,
                    unitId: null,                     // QuickLevel no completa unidad específica
                    languageId: this.authStore.selectedLangId,
                    performance: this.performance,
                    earnedExp,
                    correctAns: this.correctAnswersCount,
                    totalExerc: this.quickExercises.length,
                    timeSeconds: this.lessonTime,
                })
                this.unlockedNextLevel = result.nextUnitId != null
                this.nextLevelId = Number(this.levelId) + 1
                await this.authStore.refreshUser()
            } catch (err) {
                console.error('[QuickLevelView] finishQuickLevel:', err)
            }
        },

        showFeedback(title, message) {
            this.feedbackTitle = title
            this.feedbackMessage = message
            this.showFeedbackModal = true
        },

        closeNoEnergyModal() {
            this.showNoEnergyModal = false
            if (this.energyStore.currentEnergy <= 0) {
                this.$router.push(`/nivel/${this.levelId}`)
            }
        },

        handleEnergyClick() {
            const e = this.energyStore.energyForHeader
            alert(`Energía: ${e.current}/${e.max}⚡`)
        },

        onResize() { this.screenHeight = window.innerHeight },
    },
}
</script>