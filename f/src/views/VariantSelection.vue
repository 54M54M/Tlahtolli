<template>
    <div class="fixed inset-0 flex items-center justify-center bg-[#0A2136] text-white md:p-4 z-50">
        <!-- Loading inicial -->
        <div v-if="loadingLanguages" class="text-center">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-white mx-auto mb-4"></div>
            <p>Cargando idiomas...</p>
        </div>

        <!-- Auto-redirect cuando hay 1 solo idioma -->
        <div v-else-if="isAutoRedirecting" class="text-center">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-white mx-auto mb-4"></div>
            <p>Configurando tu idioma...</p>
        </div>

        <!-- Selector -->
        <div v-else
            class="w-full shadow-lg flex flex-col h-full md:max-w-md md:max-h-[90vh] md:rounded-lg md:mx-auto md:h-auto md:bg-[#123456]">

            <!-- Header -->
            <div class="flex-shrink-0 p-4 md:p-6 md:pb-1 border-b border-gray-700">
                <div class="flex items-center justify-between mb-4 md:mb-6">
                    <button @click="goBack"
                        class="transition-colors flex items-center text-xl font-bold text-gray-300 hover:text-[#cc0202] md:hidden">
                        <svg height="20px" width="20px" viewBox="0 0 460.775 460.775" fill="currentColor">
                            <path
                                d="M285.08,230.397L456.218,59.27c6.076-6.077,6.076-15.911,0-21.986L423.511,4.565c-2.913-2.911-6.866-4.55-10.992-4.55 c-4.127,0-8.08,1.639-10.993,4.55l-171.138,171.14L59.25,4.565c-2.913-2.911-6.866-4.55-10.993-4.55 c-4.126,0-8.08,1.639-10.992,4.55L4.558,37.284c-6.077,6.075-6.077,15.909,0,21.986l171.138,171.128L4.575,401.505 c-6.074,6.077-6.074,15.911,0,21.986l32.709,32.719c2.911,2.911,6.865,4.55,10.992,4.55c4.127,0,8.08-1.639,10.994-4.55 l171.117-171.12l171.118,171.12c2.913,2.911,6.866,4.55,10.993,4.55c4.128,0,8.081-1.639,10.992-4.55l32.709-32.719 c6.074-6.075,6.074-15.909,0-21.986L285.08,230.397z" />
                        </svg>
                    </button>

                    <h1 class="text-2xl font-bold flex-1 text-center md:text-left md:flex-none">
                        ¿Qué te gustaría aprender?
                    </h1>

                    <button @click="goBack"
                        class="transition-colors hidden md:flex items-center text-xl font-bold text-gray-300 hover:text-[#cc0202]">
                        <svg height="20px" width="20px" viewBox="0 0 460.775 460.775" fill="currentColor">
                            <path
                                d="M285.08,230.397L456.218,59.27c6.076-6.077,6.076-15.911,0-21.986L423.511,4.565c-2.913-2.911-6.866-4.55-10.992-4.55 c-4.127,0-8.08,1.639-10.993,4.55l-171.138,171.14L59.25,4.565c-2.913-2.911-6.866-4.55-10.993-4.55 c-4.126,0-8.08,1.639-10.992,4.55L4.558,37.284c-6.077,6.075-6.077,15.909,0,21.986l171.138,171.128L4.575,401.505 c-6.074,6.077-6.074,15.911,0,21.986l32.709,32.719c2.911,2.911,6.865,4.55,10.992,4.55c4.127,0,8.08-1.639,10.994-4.55 l171.117-171.12l171.118,171.12c2.913,2.911,6.866,4.55,10.993,4.55c4.128,0,8.081-1.639,10.992-4.55l32.709-32.719 c6.074-6.075,6.074-15.909,0-21.986L285.08,230.397z" />
                        </svg>
                    </button>
                </div>
            </div>

            <!-- Área con scroll selectores de idioma -->
            <div class="flex-1 overflow-y-auto px-4 pt-3 md:px-8">
                <LanguageGroupSelector :languages="apiLanguages" :initial-language="selectedLanguage"
                    @language-selected="handleLanguageSelected" class="mb-4" />
            </div>

            <!-- Botón continuar -->
            <div class="flex-shrink-0 px-4 md:px-8 py-4 border-t border-gray-700">
                <button @click="confirmSelection" :disabled="!selectedLanguage"
                    class="w-full bg-[#58CC02] hover:bg-[#4BB302] text-white font-bold py-3 px-4 rounded-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed">
                    CONTINUAR
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { languagesApi } from '../api/apiClient.js'
import LanguageGroupSelector from '../components/LanguageGroupSelector.vue'

// ── Props ──────────────────────────────────────────────────────────────────────
// isModal: true  → abierto desde vHeader como overlay; usa emit en vez de router.push
// isModal: false → ruta normal /select-language; comportamiento original
const props = defineProps({
    isModal: {
        type: Boolean,
        default: false
    }
})

const emit = defineEmits(['close', 'language-selected'])

const router = useRouter()
const authStore = useAuthStore()

const selectedLanguage = ref(null)
const isAutoRedirecting = ref(false)
const loadingLanguages = ref(true)
const apiLanguages = ref([])

// ── goBack: en modal solo cierra; en ruta hace logout → /login ─────────────────
const goBack = () => {
    if (props.isModal) {
        emit('close')
        return
    }
    authStore.logout()
    router.push('/login')
}

const handleLanguageSelected = (languageCode) => {
    selectedLanguage.value = languageCode
    console.log('[VariantSelection] Language selected:', languageCode)
}

const handleSingleLanguage = async () => {
    if (apiLanguages.value.length === 1) {
        isAutoRedirecting.value = true
        await new Promise(resolve => setTimeout(resolve, 100))

        const singleLanguage = apiLanguages.value[0]
        selectedLanguage.value = singleLanguage.code.toLowerCase()
        await authStore.setLanguage(singleLanguage.code.toLowerCase())

        await new Promise(resolve => setTimeout(resolve, 200))

        if (props.isModal) {
            emit('language-selected', singleLanguage)
            emit('close')
        } else {
            router.push('/')
        }
    }
}

onMounted(async () => {
    if (!authStore.user) {
        if (!props.isModal) router.push('/login')
        else emit('close')
        return
    }

    // En modo ruta normal: si ya tiene idioma y no es nuevo usuario, ir a home.
    // En modo modal: NUNCA redirigir — el usuario quiere cambiar de idioma explícitamente.
    if (!props.isModal && authStore.selectedLanguage && !authStore.isNewUser) {
        router.push('/')
        return
    }

    try {
        const langs = await languagesApi.getAll()
        apiLanguages.value = Array.isArray(langs) ? langs : []
    } catch (err) {
        console.error('[VariantSelection] error cargando idiomas:', err)
        apiLanguages.value = []
    } finally {
        loadingLanguages.value = false
    }

    if (apiLanguages.value.length === 1) {
        await handleSingleLanguage()
        return
    }

    // Pre-seleccionar el idioma actual si ya hay uno (útil en modo modal)
    if (authStore.selectedLanguage) {
        selectedLanguage.value = authStore.selectedLanguage
    }
})

const confirmSelection = async () => {
    if (!selectedLanguage.value) return

    try {
        // Obtener el objeto completo del idioma para pasarlo al padre (con icon/emoji de la BD)
        const langObj = apiLanguages.value.find(
            l => l.code.toLowerCase() === selectedLanguage.value.toLowerCase()
        )

        await authStore.setLanguage(selectedLanguage.value)

        if (props.isModal) {
            // Notifica al padre con el objeto completo; el padre actualiza la UI
            emit('language-selected', langObj ?? { code: selectedLanguage.value })
            emit('close')
        } else {
            router.push('/')
        }
    } catch (error) {
        console.error('[VariantSelection] Error al confirmar selección:', error)
    }
}
</script>

<style scoped>
body {
    overflow: hidden;
}

.overflow-y-auto {
    scrollbar-width: thin;
    scrollbar-color: rgba(255, 255, 255, 0.3) transparent;
}

.overflow-y-auto::-webkit-scrollbar {
    width: 6px;
}

.overflow-y-auto::-webkit-scrollbar-track {
    background: transparent;
}

.overflow-y-auto::-webkit-scrollbar-thumb {
    background-color: rgba(255, 255, 255, 0.3);
    border-radius: 3px;
}
</style>