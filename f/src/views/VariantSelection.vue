<template>
    <div class="fixed inset-0 flex items-center justify-center bg-[#0A2136] text-white p-4 z-50">
        <!-- Loading state durante el auto-redirect -->
        <div v-if="isAutoRedirecting" class="text-center">
            <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-white mx-auto mb-4"></div>
            <p>Configurando tu idioma...</p>
        </div>

        <div v-else-if="!hasSingleLanguage" class="w-full max-w-md bg-[#123456] rounded-lg p-8 shadow-lg mx-auto">
            <!-- Contenido normal para múltiples idiomas -->
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-3xl font-bold text-center flex-1">Quiero aprender...</h1>
                <button @click="goBack"
                    class="transition-colors flex items-center text-xl font-bold text-gray-300 hover:text-[#cc0202]">

                    <svg height="20px" width="20px" version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg"
                        xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 460.775 460.775" xml:space="preserve">
                        <g id="SVGRepo_bgCarrier" stroke-width="0"></g>
                        <g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g>
                        <g id="SVGRepo_iconCarrier">
                            <path
                                d="M285.08,230.397L456.218,59.27c6.076-6.077,6.076-15.911,0-21.986L423.511,4.565c-2.913-2.911-6.866-4.55-10.992-4.55 c-4.127,0-8.08,1.639-10.993,4.55l-171.138,171.14L59.25,4.565c-2.913-2.911-6.866-4.55-10.993-4.55 c-4.126,0-8.08,1.639-10.992,4.55L4.558,37.284c-6.077,6.075-6.077,15.909,0,21.986l171.138,171.128L4.575,401.505 c-6.074,6.077-6.074,15.911,0,21.986l32.709,32.719c2.911,2.911,6.865,4.55,10.992,4.55c4.127,0,8.08-1.639,10.994-4.55 l171.117-171.12l171.118,171.12c2.913,2.911,6.866,4.55,10.993,4.55c4.128,0,8.081-1.639,10.992-4.55l32.709-32.719 c6.074-6.075,6.074-15.909,0-21.986L285.08,230.397z"
                                fill="currentColor"> <!-- Cambiado a currentColor -->
                            </path>
                        </g>
                    </svg>
                </button>
            </div>

            <!-- <div class="mb-6">
                <h2 class="text-xl font-semibold mb-2">Tu idioma actual</h2>
                <div class="flex items-center space-x-4 p-4 rounded-lg transition-all duration-300"
                    :style="{ backgroundColor: currentDisplayLanguageColor }">
                    <div class="w-12 h-12 rounded-full flex items-center justify-center border-2" :style="{
                        borderColor: currentDisplayLanguage?.color || '#666',
                        backgroundColor: currentDisplayLanguage?.color || '#666'
                    }">
                        <span class="font-bold text-white">{{ currentDisplayLanguageInitial }}</span>
                    </div>
                    <div>
                        <p class="font-bold" :style="{ color: currentDisplayLanguageTextColor }">
                            {{ currentDisplayLanguageName }}
                        </p>
                        <p class="text-sm opacity-80" :style="{ color: currentDisplayLanguageTextColor }">
                            {{ selectionStatus }}
                        </p>
                    </div>
                </div>
            </div> -->

            <!-- <p class="text-center mb-6">Elige el idioma que prefieres aprender</p> -->

            <div class="grid grid-cols-1 gap-4 mb-6">
                <button v-for="language in availableLanguages" :key="language.code"
                    @click="selectLanguage(language.code)"
                    class="p-4 rounded-lg border-2 transition-all hover:scale-105" :style="{
                        borderColor: language.color,
                        backgroundColor: selectedLanguage === language.code ? language.color : 'transparent'
                    }">
                    <div class="flex items-center space-x-3">
                        <div class="w-8 h-8 rounded-full flex items-center justify-center text-white font-bold"
                            :style="{ backgroundColor: language.color }">
                            {{ language.flag }}
                        </div>
                        <div class="text-left">
                            <p class="font-semibold text-lg"
                                :style="{ color: selectedLanguage === language.code ? 'white' : language.color }">
                                {{ language.name }}
                            </p>
                            <p class="text-sm opacity-80"
                                :style="{ color: selectedLanguage === language.code ? 'white' : language.color }">
                                {{ language.nativeName }}
                            </p>
                        </div>
                    </div>
                </button>
            </div>

            <button @click="confirmSelection" :disabled="!selectedLanguage"
                class="w-full bg-[#58CC02] hover:bg-[#4BB302] text-white font-bold py-3 px-4 rounded-lg transition-colors disabled:opacity-50">
                Confirmar selección
            </button>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { LanguageService } from '../data/services/LanguageService.js'

const router = useRouter()
const authStore = useAuthStore()
const languageService = new LanguageService()
const selectedLanguage = ref(null)
const isAutoRedirecting = ref(false)

// Obtener idiomas disponibles
const availableLanguages = computed(() => {
    return languageService.getSupportedLanguages()
})

// Computed para verificar si hay solo 1 idioma
const hasSingleLanguage = computed(() => {
    return availableLanguages.value && availableLanguages.value.length === 1
})

// Computed para obtener información del idioma que se está mostrando actualmente
const currentDisplayLanguage = computed(() => {
    if (selectedLanguage.value) {
        return availableLanguages.value.find(l => l.code === selectedLanguage.value)
    }
    if (authStore.selectedLanguage) {
        return availableLanguages.value.find(l => l.code === authStore.selectedLanguage)
    }
    return availableLanguages.value[0] // Primer idioma por defecto
})

const currentDisplayLanguageName = computed(() => currentDisplayLanguage.value?.name || 'No seleccionado')
const currentDisplayLanguageColor = computed(() => {
    const color = currentDisplayLanguage.value?.color || '#666'
    return `${color}33`
})
const currentDisplayLanguageTextColor = computed(() => currentDisplayLanguage.value?.color || '#666')
const currentDisplayLanguageInitial = computed(() => currentDisplayLanguageName.value.charAt(0))

const selectionStatus = computed(() => {
    if (selectedLanguage.value) {
        return 'Idioma seleccionado'
    }
    if (authStore.selectedLanguage) {
        return 'Idioma actual'
    }
    return 'Idioma por defecto'
})

const goBack = () => {
    authStore.logout()
    router.push('/login')
}

// Función para manejar la selección automática cuando hay solo 1 idioma
const handleSingleLanguage = async () => {
    if (hasSingleLanguage.value && availableLanguages.value[0]) {
        isAutoRedirecting.value = true

        // Delay más largo para asegurar que todo esté cargado
        await new Promise(resolve => setTimeout(resolve, 100))

        const singleLanguage = availableLanguages.value[0]
        selectedLanguage.value = singleLanguage.code

        // Asegurarnos de que el idioma se guarde completamente
        await authStore.setLanguage(singleLanguage.code)

        // Delay adicional antes del redirect
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

    // Para múltiples idiomas, establecer la selección inicial
    if (authStore.selectedLanguage) {
        selectedLanguage.value = authStore.selectedLanguage
    } else if (availableLanguages.value.length > 0) {
        selectedLanguage.value = availableLanguages.value[0].code
    }
    console.log('Selection initialized to:', selectedLanguage.value)
})

const selectLanguage = (languageCode) => {
    selectedLanguage.value = languageCode
}

const confirmSelection = async () => {
    try {
        if (selectedLanguage.value) {
            await authStore.setLanguage(selectedLanguage.value)
            router.push('/')
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
</style>

<!-- ✓ ✗ -->