<template>
    <div class="fixed inset-0 flex items-center justify-center bg-[#0A2136] text-white md:p-4 z-50">
        <!-- Loading state durante el auto-redirect -->
        <div v-if="isAutoRedirecting" class="text-center">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-white mx-auto mb-4"></div>
            <p>Configurando tu idioma...</p>
        </div>

        <div v-else-if="!hasSingleLanguage"
            class="w-full shadow-lg flex flex-col h-full md:max-w-md md:max-h-[90vh] md:rounded-lg md:mx-auto md:h-auto md:bg-[#123456]">
            <!-- Header -->
            <div class="flex-shrink-0 p-4 md:p-6 md:pb-1 border-b border-gray-700">
                <div class="flex items-center justify-between mb-4 md:mb-6">
                    <button @click="goBack"
                        class="transition-colors flex items-center text-xl font-bold text-gray-300 hover:text-[#cc0202] md:hidden">
                        <svg height="20px" width="20px" version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg"
                            xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 460.775 460.775"
                            xml:space="preserve">
                            <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
                            <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g>
                            <g id="SVGRepo_iconCarrier">
                                <path
                                    d="M285.08,230.397L456.218,59.27c6.076-6.077,6.076-15.911,0-21.986L423.511,4.565c-2.913-2.911-6.866-4.55-10.992-4.55 c-4.127,0-8.08,1.639-10.993,4.55l-171.138,171.14L59.25,4.565c-2.913-2.911-6.866-4.55-10.993-4.55 c-4.126,0-8.08,1.639-10.992,4.55L4.558,37.284c-6.077,6.075-6.077,15.909,0,21.986l171.138,171.128L4.575,401.505 c-6.074,6.077-6.074,15.911,0,21.986l32.709,32.719c2.911,2.911,6.865,4.55,10.992,4.55c4.127,0,8.08-1.639,10.994-4.55 l171.117-171.12l171.118,171.12c2.913,2.911,6.866,4.55,10.993,4.55c4.128,0,8.081-1.639,10.992-4.55l32.709-32.719 c6.074-6.075,6.074-15.909,0-21.986L285.08,230.397z"
                                    fill="currentColor">
                                </path>
                            </g>
                        </svg>
                    </button>

                    <!-- Título -->
                    <h1 class="text-2xl font-bold flex-1 text-center md:text-left md:flex-none">
                        ¿Qué te gustaría aprender?
                    </h1>

                    <!-- goBack solo visible en desktop -->
                    <button @click="goBack"
                        class="transition-colors hidden md:flex items-center text-xl font-bold text-gray-300 hover:text-[#cc0202]">
                        <svg height="20px" width="20px" version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg"
                            xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 460.775 460.775"
                            xml:space="preserve">
                            <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
                            <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g>
                            <g id="SVGRepo_iconCarrier">
                                <path
                                    d="M285.08,230.397L456.218,59.27c6.076-6.077,6.076-15.911,0-21.986L423.511,4.565c-2.913-2.911-6.866-4.55-10.992-4.55 c-4.127,0-8.08,1.639-10.993,4.55l-171.138,171.14L59.25,4.565c-2.913-2.911-6.866-4.55-10.993-4.55 c-4.126,0-8.08,1.639-10.992,4.55L4.558,37.284c-6.077,6.075-6.077,15.909,0,21.986l171.138,171.128L4.575,401.505 c-6.074,6.077-6.074,15.911,0,21.986l32.709,32.719c2.911,2.911,6.865,4.55,10.992,4.55c4.127,0,8.08-1.639,10.994-4.55 l171.117-171.12l171.118,171.12c2.913,2.911,6.866,4.55,10.993,4.55c4.128,0,8.081-1.639,10.992-4.55l32.709-32.719 c6.074-6.075,6.074-15.909,0-21.986L285.08,230.397z"
                                    fill="currentColor">
                                </path>
                            </g>
                        </svg>
                    </button>
                </div>
            </div>

            <!-- Área con scroll selectores de idioma -->
            <div class="flex-1 overflow-y-auto px-4 pt-3 md:px-8">
                <LanguageGroupSelector :initial-language="selectedLanguage" @language-selected="handleLanguageSelected"
                    @confirm="handleConfirm" class="mb-4" />
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
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { LanguageService } from '../data/services/LanguageService.js'
import LanguageGroupSelector from '../components/LanguageGroupSelector.vue'

const router = useRouter()
const authStore = useAuthStore()
const languageService = new LanguageService()
const selectedLanguage = ref(null) // Mantener como null inicialmente
const isAutoRedirecting = ref(false)

// Obtener idiomas disponibles
const availableLanguages = computed(() => {
    return languageService.getSupportedLanguages()
})

// Computed para verificar si hay solo 1 idioma
const hasSingleLanguage = computed(() => {
    return availableLanguages.value && availableLanguages.value.length === 1
})

const goBack = () => {
    authStore.logout()
    router.push('/login')
}

// Manejar selección de idioma desde LanguageGroupSelector
const handleLanguageSelected = (languageCode) => {
    selectedLanguage.value = languageCode
    console.log('Language selected:', languageCode)
}

// Manejar confirmación desde LanguageGroupSelector
const handleConfirm = (languageCode) => {
    selectedLanguage.value = languageCode
    confirmSelection()
}

// Función para manejar la selección automática cuando hay solo 1 idioma
const handleSingleLanguage = async () => {
    if (hasSingleLanguage.value && availableLanguages.value[0]) {
        isAutoRedirecting.value = true

        await new Promise(resolve => setTimeout(resolve, 100))

        const singleLanguage = availableLanguages.value[0]
        selectedLanguage.value = singleLanguage.code

        await authStore.setLanguage(singleLanguage.code)

        await new Promise(resolve => setTimeout(resolve, 200))

        router.push('/')
    }
}

onMounted(async () => {
    console.log('VariantSelection mounted - User:', authStore.user, 'Selected Language:', authStore.selectedLanguage, 'isNewUser:', authStore.isNewUser)

    if (!authStore.user) {
        console.log('No user, redirecting to login')
        router.push('/login')
        return
    }

    // Si ya tiene idioma seleccionado y no es nuevo usuario, redirigir
    if (authStore.selectedLanguage && !authStore.isNewUser) {
        console.log('Language already selected, redirecting to home')
        return
    }

    // Verificar si hay solo 1 idioma y manejar automáticamente
    if (hasSingleLanguage.value) {
        console.log('Single language detected, auto-selecting')
        await handleSingleLanguage()
        return
    }

    // Para múltiples idiomas: NO establecer un valor por defecto
    // Solo usar el idioma previamente seleccionado si existe
    if (authStore.selectedLanguage) {
        selectedLanguage.value = authStore.selectedLanguage
    }
    // NO establecer un valor por defecto cuando hay múltiples opciones
    // El usuario debe hacer una selección explícita

    console.log('Selection initialized to:', selectedLanguage.value)
})

const confirmSelection = async () => {
    try {
        if (selectedLanguage.value) {
            await authStore.setLanguage(selectedLanguage.value)
            router.push('/')
        } else {
            console.error('No language selected')
            // Opcional: mostrar un mensaje al usuario
        }
    } catch (error) {
        console.error('Error al confirmar selección:', error)
    }
}
</script>

<style scoped>
/* Prevenir scroll en el body cuando este componente está activo */
body {
    overflow: hidden;
}

/* Estilos para el scroll */
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