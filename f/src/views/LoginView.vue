<template>
    <div class="flex flex-col items-center justify-center min-h-screen bg-[#0A2136] text-white p-4">
        <div class="w-full max-w-md bg-[#123456] rounded-lg p-8 shadow-lg">

            <!-- Tabs -->
            <div class="flex mb-6 bg-[#0A2136] rounded-lg p-1">
                <button @click="activeTab = 'login'"
                    :class="activeTab === 'login' ? 'bg-[#58CC02] text-white' : 'text-gray-400 hover:text-white'"
                    class="flex-1 py-2 rounded-md text-sm font-semibold transition-colors">
                    Iniciar sesión
                </button>
                <button @click="activeTab = 'register'"
                    :class="activeTab === 'register' ? 'bg-[#58CC02] text-white' : 'text-gray-400 hover:text-white'"
                    class="flex-1 py-2 rounded-md text-sm font-semibold transition-colors">
                    Registrarse
                </button>
            </div>

            <!-- Login -->
            <div v-if="activeTab === 'login'" class="space-y-4">
                <div>
                    <label class="block text-sm font-medium mb-1 text-gray-300">Usuario</label>
                    <input v-model="username" type="text" placeholder="mi_usuario"
                        class="w-full bg-[#0A2136] border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-[#58CC02] transition-colors"
                        @keyup.enter="login" />
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1 text-gray-300">Contraseña</label>
                    <div class="relative">
                        <input v-model="password" :type="showPassword ? 'text' : 'password'" placeholder="••••••••"
                            class="w-full bg-[#0A2136] border border-gray-600 rounded-lg px-4 py-3 pr-11 text-white placeholder-gray-500 focus:outline-none focus:border-[#58CC02] transition-colors"
                            @keyup.enter="login" />
                        <button type="button" @click="showPassword = !showPassword"
                            class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white transition-colors">
                            <svg v-if="!showPassword" xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" /></svg>
                            <svg v-else xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.477 0-8.268-2.943-9.542-7a9.97 9.97 0 012.163-3.592M6.53 6.533A9.956 9.956 0 0112 5c4.477 0 8.268 2.943 9.542 7a9.97 9.97 0 01-1.357 2.56M6.53 6.533L3 3m3.53 3.533l11.94 11.934M15.47 15.47A3 3 0 019.17 9.17" /></svg>
                        </button>
                    </div>
                </div>

                <div v-if="errorMsg" class="p-3 bg-red-900/40 border border-red-600 rounded-lg text-red-300 text-sm">
                    {{ errorMsg }}
                </div>

                <button @click="login" :disabled="loading"
                    class="w-full bg-[#58CC02] hover:bg-[#4BB302] disabled:opacity-50 text-white font-bold py-3 px-4 rounded-lg transition-colors">
                    {{ loading ? 'Entrando...' : 'Iniciar sesión' }}
                </button>

                <!-- Credenciales demo -->
                <div class="p-4 bg-[#0A2136] rounded-lg border border-gray-700">
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

            <!-- Register -->
            <div v-else class="space-y-4">
                <div>
                    <label class="block text-sm font-medium mb-1 text-gray-300">Usuario <span class="text-red-400">*</span></label>
                    <input v-model="newUsername" type="text" placeholder="mi_usuario"
                        class="w-full bg-[#0A2136] border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-[#58CC02] transition-colors"
                        @keyup.enter="register" />
                </div>
                <div class="flex gap-3">
                    <div class="flex-1">
                        <label class="block text-sm font-medium mb-1 text-gray-300">Nombre(s) <span class="text-red-400">*</span></label>
                        <input v-model="newFirstName" type="text" placeholder="Jose"
                            class="w-full bg-[#0A2136] border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-[#58CC02] transition-colors"
                            @keyup.enter="register" />
                    </div>
                    <div class="flex-1">
                        <label class="block text-sm font-medium mb-1 text-gray-300">Apellido(s) <span class="text-red-400">*</span></label>
                        <input v-model="newLastName" type="text" placeholder="Pérez"
                            class="w-full bg-[#0A2136] border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-[#58CC02] transition-colors"
                            @keyup.enter="register" />
                    </div>
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1 text-gray-300">Correo electrónico <span class="text-red-400">*</span></label>
                    <input v-model="newEmail" type="email" placeholder="correo@ejemplo.com"
                        class="w-full bg-[#0A2136] border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-[#58CC02] transition-colors"
                        @keyup.enter="register" />
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1 text-gray-300">Contraseña <span class="text-red-400">*</span></label>
                    <div class="relative">
                        <input v-model="newPassword" :type="showNewPassword ? 'text' : 'password'" placeholder="••••••••"
                            class="w-full bg-[#0A2136] border border-gray-600 rounded-lg px-4 py-3 pr-11 text-white placeholder-gray-500 focus:outline-none focus:border-[#58CC02] transition-colors"
                            @keyup.enter="register" />
                        <button type="button" @click="showNewPassword = !showNewPassword"
                            class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white transition-colors">
                            <svg v-if="!showNewPassword" xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" /></svg>
                            <svg v-else xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.477 0-8.268-2.943-9.542-7a9.97 9.97 0 012.163-3.592M6.53 6.533A9.956 9.956 0 0112 5c4.477 0 8.268 2.943 9.542 7a9.97 9.97 0 01-1.357 2.56M6.53 6.533L3 3m3.53 3.533l11.94 11.934M15.47 15.47A3 3 0 019.17 9.17" /></svg>
                        </button>
                    </div>
                    <p v-if="newPassword && newPassword.length < 6" class="mt-1 text-xs text-red-400">Mínimo 6 caracteres</p>
                </div>
                <div>
                    <label class="block text-sm font-medium mb-1 text-gray-300">Confirmar contraseña <span class="text-red-400">*</span></label>
                    <div class="relative">
                        <input v-model="confirmPassword" :type="showConfirmPassword ? 'text' : 'password'" placeholder="••••••••"
                            :class="confirmPassword ? (passwordMatch ? 'border-[#58CC02]' : 'border-red-500') : 'border-gray-600'"
                            class="w-full bg-[#0A2136] border rounded-lg px-4 py-3 pr-11 text-white placeholder-gray-500 focus:outline-none transition-colors"
                            @keyup.enter="register" />
                        <button type="button" @click="showConfirmPassword = !showConfirmPassword"
                            class="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white transition-colors">
                            <svg v-if="!showConfirmPassword" xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.477 0 8.268 2.943 9.542 7-1.274 4.057-5.065 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" /></svg>
                            <svg v-else xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.477 0-8.268-2.943-9.542-7a9.97 9.97 0 012.163-3.592M6.53 6.533A9.956 9.956 0 0112 5c4.477 0 8.268 2.943 9.542 7a9.97 9.97 0 01-1.357 2.56M6.53 6.533L3 3m3.53 3.533l11.94 11.934M15.47 15.47A3 3 0 019.17 9.17" /></svg>
                        </button>
                    </div>
                    <p v-if="confirmPassword && !passwordMatch" class="mt-1 text-xs text-red-400">Las contraseñas no coinciden</p>
                    <p v-if="confirmPassword && passwordMatch" class="mt-1 text-xs text-[#58CC02]">Las contraseñas coinciden</p>
                </div>

                <div v-if="errorMsg" class="p-3 bg-red-900/40 border border-red-600 rounded-lg text-red-300 text-sm">
                    {{ errorMsg }}
                </div>

                <button @click="register" :disabled="loading"
                    class="w-full bg-[#58CC02] hover:bg-[#4BB302] disabled:opacity-50 text-white font-bold py-3 px-4 rounded-lg transition-colors">
                    {{ loading ? 'Creando cuenta...' : 'Crear cuenta' }}
                </button>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useAuthStore } from '../stores/auth'
import { usersApi } from '../api/apiClient'
import { useRouter } from 'vue-router'
import placeholder from '../assets/300x300.png'

const authStore = useAuthStore()
const router = useRouter()

const activeTab = ref('login')
const loading = ref(false)
const errorMsg = ref('')

// Login
const username = ref('')
const password = ref('')

// Register
const newUsername = ref('')
const newFirstName = ref('')
const newLastName = ref('')
const newEmail = ref('')
const newPassword = ref('')
const confirmPassword = ref('')

const showPassword = ref(false)
const showNewPassword = ref(false)
const showConfirmPassword = ref(false)

const passwordMatch = computed(() => newPassword.value === confirmPassword.value)

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
        router.push('/select-language')
    } catch (err) {
        errorMsg.value = err.message || 'Usuario o contraseña incorrectos.'
    } finally {
        loading.value = false
    }
}

const register = async () => {
    if (!newUsername.value || !newFirstName.value || !newLastName.value || !newEmail.value || !newPassword.value || !confirmPassword.value) {
        errorMsg.value = 'Por favor completa todos los campos.'
        return
    }
    if (newPassword.value.length < 6) {
        errorMsg.value = 'La contraseña debe tener al menos 6 caracteres.'
        return
    }
    if (newPassword.value !== confirmPassword.value) {
        errorMsg.value = 'Las contraseñas no coinciden.'
        return
    }
    loading.value = true
    errorMsg.value = ''
    try {
        await usersApi.create({ username: newUsername.value, fullName: `${newFirstName.value} ${newLastName.value}`, email: newEmail.value, password: newPassword.value, currentLang: null })
        await authStore.login(newUsername.value, newPassword.value)
        router.push('/select-language')
    } catch (err) {
        errorMsg.value = err.message || 'No se pudo crear la cuenta.'
    } finally {
        loading.value = false
    }
}

// Limpiar error al cambiar de tab
const switchTab = (tab) => {
    activeTab.value = tab
    errorMsg.value = ''
}

onMounted(() => {
    if (authStore.user && !authStore.isNewUser && authStore.selectedLanguage) {
        router.push('/')
    }
})
</script>
