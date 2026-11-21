<template>
    <div class="min-h-screen flex items-center justify-center px-4 bg-surface-0 text-white">
        <div class="w-full max-w-sm bg-surface-1 rounded-xl p-6 text-center space-y-4">
            <p class="text-xs tracking-widest uppercase text-turquesa font-bold">Tlahtolcalli</p>

            <template v-if="state === 'idle'">
                <h1 class="text-xl font-bold">Confirma tu correo</h1>
                <p class="text-sm text-gray-400">Presiona el botón para terminar.</p>
                <button @click="confirm" :disabled="!token"
                    class="w-full bg-turquesa-deep hover:bg-turquesa-deeper disabled:opacity-50 text-white font-bold py-3 rounded-lg transition-colors">
                    Confirmar mi correo
                </button>
                <p v-if="!token" class="text-sm text-error">El enlace está incompleto. Ábrelo de nuevo desde el correo.</p>
            </template>

            <template v-else-if="state === 'loading'">
                <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-white mx-auto"></div>
                <p class="text-sm text-gray-400">Confirmando…</p>
            </template>

            <template v-else-if="state === 'ok'">
                <h1 class="text-xl font-bold">¡Correo confirmado!</h1>
                <p class="text-sm text-gray-400 break-all">{{ email }}</p>
                <router-link :to="authStore.user ? '/app' : '/login'"
                    class="block w-full bg-turquesa-deep hover:bg-turquesa-deeper text-white font-bold py-3 rounded-lg transition-colors">
                    {{ authStore.user ? 'Ir a la app' : 'Iniciar sesión' }}
                </router-link>
            </template>

            <template v-else>
                <h1 class="text-xl font-bold">No se pudo confirmar</h1>
                <p class="text-sm text-error">{{ error }}</p>
                <p class="text-xs text-gray-400">Puedes pedir un enlace nuevo desde “Editar perfil”.</p>
                <router-link :to="authStore.user ? '/app/perfil/editar' : '/login'"
                    class="block w-full border border-gray-600 hover:border-turquesa text-white font-bold py-3 rounded-lg transition-colors">
                    {{ authStore.user ? 'Ir a editar perfil' : 'Iniciar sesión' }}
                </router-link>
            </template>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { emailApi } from '../api/apiClient'

const route = useRoute()
const router = useRouter()
const authStore = useAuthStore()

// El token se lee y se quita de la barra de direcciones (no queda en el historial)
const token = typeof route.query.token === 'string' ? route.query.token : ''
if (token) router.replace({ path: '/verificar' })

const state = ref('idle')   // idle | loading | ok | error
const email = ref('')
const error = ref('')

// Se confirma con un botón, no al cargar: los antivirus de correo abren los enlaces solos
const confirm = async () => {
    state.value = 'loading'
    try {
        const res = await emailApi.confirm(token)
        email.value = res.email
        if (authStore.user && authStore.user.id === res.userId) {
            authStore.user = { ...authStore.user, email: res.email, emailVerified: true, pendingEmail: null }
        }
        state.value = 'ok'
    } catch (e) {
        error.value = e.message
        state.value = 'error'
    }
}
</script>
