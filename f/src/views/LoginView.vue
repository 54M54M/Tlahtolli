<template>
    <div class="flex flex-col items-center justify-center min-h-screen bg-[#0A2136] text-white p-4">
        <div class="w-full max-w-md bg-[#123456] rounded-lg p-8 shadow-lg">
            <h1 class="text-3xl font-bold mb-8 text-center">Iniciar sesión</h1>

            <div class="mb-6">
                <h2 class="text-xl font-semibold mb-2">Usuario de demostración</h2>
                <div class="flex py-4 bg-[#234567] rounded-lg">
                    <div class="flex space-x-4">
                        <!-- Imagen placeholder -->
                        <div class="flex justify-center">
                            <img :src="placeholder" alt="Avatar" class="w-16 h-16 bg-gray-700 rounded-lg ml-4">
                        </div>

                        <div class="flex flex-col justify-center">
                            <p class="font-bold">{{ userData.name }}</p>
                            <p class="text-sm opacity-80">@{{ userData.username }}</p>
                        </div>
                    </div>
                </div>
            </div>

            <button @click="login"
                class="w-full bg-[#58CC02] hover:bg-[#4BB302] text-white font-bold py-3 px-4 rounded-lg transition-colors">
                Continuar como {{ userData.name }}
            </button>
        </div>
    </div>
</template>

<script setup>
import { userData } from '../lib/data.js'
import { useAuthStore } from '../stores/auth'
import { useRouter } from 'vue-router'
import { onMounted } from 'vue'
import placeholder from '../assets/300x300.png'

const authStore = useAuthStore()
const router = useRouter()

const login = () => {
    authStore.login()

    // Redirigir según si es nuevo usuario o no
    if (authStore.isNewUser) {
        router.push('/select-variant')
    } else {
        router.push('/')
    }
}

// Redirigir si ya está autenticado
onMounted(() => {
    // Usar authStore.user en lugar de authStore.isAuthenticated
    if (authStore.user) {
        if (authStore.isNewUser) {
            router.push('/select-variant')
        } else {
            router.push('/')
        }
    }
})
</script>