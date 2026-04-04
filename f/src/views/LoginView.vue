<template>
    <div class="flex flex-col items-center justify-center min-h-screen bg-[#0A2136] text-white p-4">
        <div class="w-full max-w-md bg-[#123456] rounded-lg p-8 shadow-lg">
            <h1 class="text-3xl font-bold mb-8 text-center">Iniciar sesión</h1>

            <!-- Formulario de login -->
            <div class="mb-6 space-y-4">
                <div>
                    <label class="block text-sm font-medium mb-1 text-gray-300">Usuario</label>
                    <input v-model="username" type="text" placeholder="tetecuhtli"
                        class="w-full bg-[#0A2136] border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-[#58CC02] transition-colors"
                        @keyup.enter="login" />
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1 text-gray-300">Contraseña</label>
                    <input v-model="password" type="password" placeholder="demo1234"
                        class="w-full bg-[#0A2136] border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-[#58CC02] transition-colors"
                        @keyup.enter="login" />
                </div>
            </div>

            <!-- Error -->
            <div v-if="errorMsg" class="mb-4 p-3 bg-red-900/40 border border-red-600 rounded-lg text-red-300 text-sm">
                {{ errorMsg }}
            </div>

            <button @click="login" :disabled="loading"
                class="w-full bg-[#58CC02] hover:bg-[#4BB302] disabled:opacity-50 text-white font-bold py-3 px-4 rounded-lg transition-colors">
                {{ loading ? 'Entrando...' : 'Iniciar sesión' }}
            </button>

            <!-- Credenciales de demo -->
            <div class="mt-6 p-4 bg-[#0A2136] rounded-lg border border-gray-700">
                <p class="text-xs text-gray-400 font-semibold mb-2 uppercase tracking-wide">Cuenta de demostración</p>
                <div class="flex items-center gap-3">
                    <img :src="placeholder" alt="Avatar" class="w-10 h-10 rounded-lg bg-gray-700 flex-shrink-0">
                    <div class="flex-1">
                        <p class="text-sm font-bold text-white">UserDemo</p>
                        <p class="text-xs text-gray-400">Usuario: <span class="text-gray-300">tetecuhtli</span></p>
                        <p class="text-xs text-gray-400">Contraseña: <span class="text-gray-300">demo1234</span></p>
                    </div>
                    <button @click="fillDemo"
                        class="text-xs bg-gray-700 hover:bg-gray-600 px-2 py-1 rounded transition-colors text-gray-300">
                        Usar
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import { useRouter } from 'vue-router'
import placeholder from '../assets/300x300.png'

const authStore = useAuthStore()
const router = useRouter()

const username = ref('')
const password = ref('')
const loading = ref(false)
const errorMsg = ref('')

// Credenciales demo hardcodeadas (solo hay un usuario en el backend)
const DEMO_USERNAME = 'tetecuhtli'
const DEMO_PASSWORD = 'demo1234'

const fillDemo = () => {
    username.value = DEMO_USERNAME
    password.value = DEMO_PASSWORD
    errorMsg.value = ''
}

const login = async () => {
    if (!username.value || !password.value) {
        errorMsg.value = 'Por favor ingresa usuario y contraseña.'
        return
    }
    loading.value = true
    errorMsg.value = ''
    try {
        await authStore.login(username.value, password.value)
        // Siempre ir a selección de idioma al entrar
        router.push('/select-language')
    } catch (err) {
        errorMsg.value = err.message || 'Usuario o contraseña incorrectos.'
    } finally {
        loading.value = false
    }
}

// Si ya está autenticado pero viene de logout, no redirigir automáticamente
// Solo redirigir si tiene sesión activa Y tiene idioma ya seleccionado
onMounted(() => {
    if (authStore.user && !authStore.isNewUser && authStore.selectedLanguage) {
        router.push('/')
    }
})
</script>