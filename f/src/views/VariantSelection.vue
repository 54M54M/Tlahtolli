<template>
    <div class="fixed inset-0 flex items-center justify-center bg-[#0A2136] text-white p-4 z-50">
        <div class="w-full max-w-md bg-[#123456] rounded-lg p-8 shadow-lg mx-auto">
            <!-- El resto del código permanece igual -->
            <div class="flex justify-between items-center mb-8">
                <h1 class="text-3xl font-bold text-center flex-1 mr-8">Selecciona tu variante</h1>
                <button @click="goBack"
                    class="text-white hover:text-[#58CC02] transition-colors flex items-center text-xl font-bold">
                    ×
                </button>
            </div>

            <div class="mb-6">
                <h2 class="text-xl font-semibold mb-2">Tu variante actual</h2>
                <div class="flex items-center space-x-4 p-4 rounded-lg transition-all duration-300"
                    :style="{ backgroundColor: currentDisplayVariantColor }">
                    <div class="w-12 h-12 rounded-full flex items-center justify-center border-2" :style="{
                        borderColor: currentDisplayVariant.color,
                        backgroundColor: currentDisplayVariant.color
                    }">
                        <span class="font-bold text-white">{{ currentDisplayVariantInitial }}</span>
                    </div>
                    <div>
                        <p class="font-bold" :style="{ color: currentDisplayVariantTextColor }">
                            {{ currentDisplayVariantName }}
                        </p>
                        <p class="text-sm opacity-80" :style="{ color: currentDisplayVariantTextColor }">
                            {{ selectionStatus }}
                        </p>
                    </div>
                </div>
            </div>

            <p class="text-center mb-6">Elige la variante de náhuatl que prefieres aprender</p>

            <div class="grid grid-cols-2 gap-4 mb-6">
                <button v-for="variant in dialectVariants" :key="variant.id" @click="selectVariant(variant.id)"
                    class="p-4 rounded-lg border-2 transition-all hover:scale-105" :style="{
                        borderColor: variant.color,
                        backgroundColor: selectedVariant === variant.id ? variant.color : 'transparent'
                    }">
                    <p class="font-semibold text-center"
                        :style="{ color: selectedVariant === variant.id ? 'white' : variant.color }">
                        {{ variant.name }}
                    </p>
                </button>
            </div>

            <button @click="confirmSelection" :disabled="!selectedVariant"
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
import { dialectVariants, userData } from '../lib/data.js'

const router = useRouter()
const authStore = useAuthStore()
const selectedVariant = ref(null)

// Computed para obtener información de la variante que se está mostrando actualmente
const currentDisplayVariant = computed(() => {
    if (selectedVariant.value) {
        return dialectVariants.find(v => v.id === selectedVariant.value)
    }
    if (authStore.selectedVariant) {
        return dialectVariants.find(v => v.id === authStore.selectedVariant)
    }
    return dialectVariants.find(v => v.id === userData.defaultVariant) || dialectVariants[0]
})

const currentDisplayVariantName = computed(() => currentDisplayVariant.value?.name || 'No seleccionada')
const currentDisplayVariantColor = computed(() => {
    const color = currentDisplayVariant.value?.color || '#666'
    return `${color}33`
})
const currentDisplayVariantTextColor = computed(() => currentDisplayVariant.value?.color || '#666')
const currentDisplayVariantInitial = computed(() => currentDisplayVariantName.value.charAt(0))

const selectionStatus = computed(() => {
    if (selectedVariant.value) {
        return 'Variante seleccionada'
    }
    if (authStore.selectedVariant) {
        return 'Variante actual'
    }
    return 'Variante por defecto'
})

const goBack = () => {
    authStore.logout()
    router.push('/login')
}

onMounted(() => {
    if (!authStore.user) {
        router.push('/login')
        return
    }

    if (authStore.selectedVariant && !authStore.isNewUser) {
        router.push('/')
        return
    }

    if (authStore.selectedVariant) {
        selectedVariant.value = authStore.selectedVariant
    } else {
        selectedVariant.value = userData.defaultVariant
    }
})

const selectVariant = (variantId) => {
    selectedVariant.value = variantId
}

const confirmSelection = async () => {
    try {
        if (selectedVariant.value) {
            authStore.setVariant(selectedVariant.value)
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