<template>
    <!-- Lección de bienvenida: después de elegir idioma y antes de la primera lección.
         5 preguntas de opción múltiple de la unidad 1. No gasta energía ni guarda progreso. -->
    <div class="fixed inset-0 z-40 bg-surface-0 text-white flex flex-col overflow-y-auto overscroll-contain">

        <!-- Barra superior: solo el avance (la bienvenida no se puede saltar) -->
        <div class="shrink-0 sticky top-0 z-30 bg-surface-0 border-b border-line">
            <div class="max-w-3xl mx-auto flex items-center gap-4 px-4 py-4">
                <div class="flex-1 h-3 bg-surface-2 rounded-full overflow-hidden" role="progressbar"
                    :aria-valuenow="done" aria-valuemin="0" :aria-valuemax="exercises.length">
                    <div class="h-full bg-turquesa rounded-full transition-all duration-500"
                        :style="{ width: progress + '%' }"></div>
                </div>
                <span class="shrink-0 text-sm font-semibold text-gray-400 tabular-nums">{{ done }}/{{ exercises.length }}</span>
            </div>
        </div>

        <!-- Cargando -->
        <div v-if="stage === 'loading'" class="flex-1 flex items-center justify-center">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-white"></div>
        </div>

        <!-- Presentación -->
        <div v-else-if="stage === 'intro'" class="flex-1 flex items-center justify-center px-4 py-6">
            <div class="max-w-md w-full text-center space-y-4">
                <img :src="tochIntro" alt="Toch te da la bienvenida" class="mx-auto h-[26dvh] max-h-56 object-contain">
                <p class="text-xs tracking-widest uppercase text-turquesa font-bold">Lección de bienvenida</p>
                <h1 class="text-3xl font-bold font-display">Tus primeras palabras en {{ langName }}</h1>
                <p class="text-gray-400">
                    {{ exercises.length }} preguntas rápidas para que conozcas cómo funcionan las lecciones.
                    Esta no gasta energía y no cuenta para tu avance.
                </p>
                <button @click="stage = 'quiz'"
                    class="w-full bg-turquesa-deep hover:bg-turquesa-deeper text-white py-4 rounded-lg text-lg font-semibold">
                    Empezar
                </button>
            </div>
        </div>

        <!-- Preguntas -->
        <div v-else-if="stage === 'quiz'" class="flex-1 flex flex-col px-4 pt-6 pb-32">
            <div class="max-w-3xl w-full mx-auto">
                <h1 class="text-xl md:text-3xl font-bold mb-6">{{ current.question }}</h1>

                <div class="flex items-start gap-3 mb-8">
                    <ExerciseImage :characterName="current.character" :imageState="!checked || correct"
                        :showAnswer="!!current.answer" :altText="`Personaje ${current.character}`" />
                    <div v-if="current.answer" class="relative mt-6 md:mt-10 flex-1 min-w-0">
                        <div class="absolute top-1/2 -translate-y-1/2 -left-3 w-0 h-0 border-t-[12px] border-t-transparent
                            border-r-[18px] border-r-line border-b-[12px] border-b-transparent"></div>
                        <div class="bg-surface-0 border border-line py-3 px-4 rounded-lg shadow-lg inline-block max-w-full break-words">
                            <p class="text-lg md:text-xl font-medium">
                                <ProcessedText :text="current.answer" :language="authStore.selectedLanguage"
                                    :vocabulary="vocabulary" :exercise-type="current.type" />
                            </p>
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <button v-for="(option, i) in current.options" :key="option + i" @click="!checked && (selected = i)"
                        :disabled="checked"
                        class="min-h-[64px] p-3 rounded-lg font-semibold tracking-wide transition-colors break-words border-2"
                        :class="optionClass(i)">
                        {{ option }}
                    </button>
                </div>
            </div>

            <div class="fixed bottom-0 left-0 right-0 p-5 bg-surface-0/95 border-t border-line" v-if="!checked">
                <div class="max-w-3xl mx-auto flex justify-end">
                    <button @click="check" :disabled="selected === null"
                        class="w-full md:w-56 bg-turquesa-deep hover:bg-turquesa-deeper disabled:bg-line disabled:text-stone-500 text-white py-4 md:py-3 rounded-lg text-lg font-medium">
                        Verificar
                    </button>
                </div>
            </div>

            <FeedbackModal :show="checked" :title="correct ? '¡Muy bien!' : 'Casi'"
                :message="current.explanation || (correct ? 'Respuesta correcta.' : `La respuesta era: ${current.options[current.correctAnswer]}`)"
                :is-correct="correct" @continue="next" />
        </div>

        <!-- Final -->
        <div v-else class="flex-1 flex items-center justify-center px-4 py-6">
            <div class="max-w-md w-full text-center space-y-4">
                <img :src="tochEnd" alt="Toch celebra" class="mx-auto h-[26dvh] max-h-56 object-contain">
                <h1 class="text-3xl font-bold font-display">¡Ya diste tus primeros pasos!</h1>
                <p v-if="exercises.length" class="text-gray-300 text-lg">
                    Acertaste <strong class="text-turquesa">{{ score }} de {{ exercises.length }}</strong>.
                </p>
                <p class="text-gray-400">
                    Ahora sigue con la primera lección del curso. Ahí ganas experiencia y desbloqueas las siguientes unidades.
                </p>
                <button @click="startCourse"
                    class="w-full bg-turquesa-deep hover:bg-turquesa-deeper text-white py-4 rounded-lg text-lg font-semibold">
                    Empezar el curso
                </button>
                <button @click="finish('/app')" class="w-full text-gray-400 hover:text-white py-2 font-semibold">
                    Ir al inicio
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import { loadWelcome, markWelcomeDone } from '../../data/welcome.js'
import ExerciseImage from '../../components/ExerciseImage.vue'
import ProcessedText from '../../components/ProcessedText.vue'
import FeedbackModal from '../../components/FeedbackModal.vue'
import { toch, TOCH_BIENVENIDA, TOCH_FINAL } from '../../data/toch.js'

// Cada pregunta con un personaje al azar
const CHARACTERS = ['citlali', 'coltzin', 'neza', 'tonatiuh', 'xochitl']
const tochIntro = toch(TOCH_BIENVENIDA)   // Toch con megáfono
const tochEnd = toch(TOCH_FINAL)          // Toch celebrando
const randomCharacter = () => CHARACTERS[Math.floor(Math.random() * CHARACTERS.length)]

const router = useRouter()
const authStore = useAuthStore()

const stage = ref('loading')   // loading | intro | quiz | end
const exercises = ref([])
const vocabulary = ref([])
const level = ref(null)
const index = ref(0)
const selected = ref(null)
const checked = ref(false)
const correct = ref(false)
const score = ref(0)

const langName = computed(() => authStore.selectedLangObj?.langName || 'tu nuevo idioma')
const current = computed(() => exercises.value[index.value] || {})
const done = computed(() => stage.value === 'end' ? exercises.value.length : index.value + (checked.value ? 1 : 0))
const progress = computed(() => exercises.value.length ? Math.round(done.value / exercises.value.length * 100) : 0)

function optionClass(i) {
    if (checked.value) {
        if (i === current.value.correctAnswer) return 'border-green-500 text-green-400 bg-green-900/20'
        if (i === selected.value) return 'border-error text-error bg-error-soft/20'
        return 'border-transparent bg-gray-700 text-gray-400'
    }
    return selected.value === i
        ? 'border-azul-maya text-azul-maya bg-gray-800'
        : 'border-transparent bg-gray-700 text-white hover:bg-gray-600'
}

function check() {
    if (selected.value === null || checked.value) return
    correct.value = selected.value === current.value.correctAnswer
    if (correct.value) score.value++
    checked.value = true
}

function next() {
    checked.value = false
    selected.value = null
    if (index.value + 1 >= exercises.value.length) {
        markWelcomeDone()
        stage.value = 'end'
    } else {
        index.value++
    }
}

function finish(path) {
    markWelcomeDone()
    router.replace(path)
}

const startCourse = () => finish(level.value ? `/app/nivel/${level.value.id}` : '/app')

onMounted(async () => {
    try {
        const data = await loadWelcome()
        level.value = data.level
        exercises.value = data.exercises.map(e => ({ ...e, character: randomCharacter() }))
        vocabulary.value = Array.isArray(data.vocabulary) ? data.vocabulary
            : Object.entries(data.vocabulary || {}).map(([word, v]) => ({ word, ...v }))
    } catch (e) {
        console.warn('[bienvenida] no se pudo cargar:', e)
    }
    // Sin ejercicios no hay nada que mostrar: directo al curso
    if (!exercises.value.length) return finish('/app')
    stage.value = 'intro'
})
</script>
