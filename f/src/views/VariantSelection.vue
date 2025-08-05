<template>
    <div class="flex flex-col items-center justify-center min-h-screen bg-[#0A2136] text-white p-4">
        <div class="w-full max-w-md bg-[#123456] rounded-lg p-8 shadow-lg">
            <h1 class="text-3xl font-bold mb-8 text-center">Selecciona tu variante</h1>

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
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { dialectVariants } from '../lib/data.js'

const router = useRouter()
const authStore = useAuthStore()
const selectedVariant = ref(null)

const selectVariant = (variantId) => {
    selectedVariant.value = variantId
}

const confirmSelection = async () => {
    try {
        if (selectedVariant.value) {
            await authStore.setVariant(selectedVariant.value)
            router.push('/')
        }
    } catch (error) {
        console.error('Error al confirmar selección:', error)
        // Puedes mostrar un mensaje al usuario aquí
    }
}
</script>