<template>
    <!-- Enlace del correo "Crea una contraseña nueva": /restablecer?token=… -->
    <div class="min-h-screen flex items-center justify-center px-4 bg-surface-0 text-white">
        <div class="w-full max-w-sm bg-surface-1 rounded-xl p-6 space-y-4">
            <p class="text-xs tracking-widest uppercase text-turquesa font-bold text-center">Tlahtolcalli</p>

            <template v-if="state === 'form'">
                <h1 class="text-xl font-bold text-center">Crea una contraseña nueva</h1>
                <p v-if="!token" class="text-sm text-error text-center">
                    El enlace está incompleto. Ábrelo de nuevo desde el correo o pide otro.
                </p>
                <template v-else>
                    <div>
                        <label class="block text-sm font-medium mb-1 text-gray-300">Contraseña nueva</label>
                        <input v-model="password" :type="show ? 'text' : 'password'" placeholder="••••••••"
                            autocomplete="new-password"
                            class="w-full bg-surface-0 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-turquesa transition-colors"
                            @keyup.enter="submit" />
                        <p v-if="password && password.length < 8" class="mt-1 text-xs text-error">Mínimo 8 caracteres</p>
                    </div>
                    <div>
                        <label class="block text-sm font-medium mb-1 text-gray-300">Confírmala</label>
                        <input v-model="confirm" :type="show ? 'text' : 'password'" placeholder="••••••••"
                            autocomplete="new-password"
                            :class="confirm ? (confirm === password ? 'border-turquesa' : 'border-error') : 'border-gray-600'"
                            class="w-full bg-surface-0 border rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none transition-colors"
                            @keyup.enter="submit" />
                        <p v-if="confirm && confirm !== password" class="mt-1 text-xs text-error">Las contraseñas no coinciden</p>
                    </div>
                    <label class="flex items-center gap-2 text-sm text-gray-400 select-none">
                        <input v-model="show" type="checkbox" class="accent-turquesa"> Mostrar contraseña
                    </label>
                    <p v-if="error" class="p-3 bg-error-soft/40 border border-error rounded-lg text-error text-sm">{{ error }}</p>
                    <button @click="submit" :disabled="loading || password.length < 8 || password !== confirm"
                        class="w-full bg-turquesa-deep hover:bg-turquesa-deeper disabled:opacity-50 text-white font-bold py-3 rounded-lg transition-colors">
                        {{ loading ? 'Guardando…' : 'Guardar contraseña' }}
                    </button>
                </template>
                <router-link :to="{ path: '/', query: { auth: 'login' } }"
                    class="block text-center text-sm text-gray-400 hover:text-white font-semibold">
                    Volver a iniciar sesión
                </router-link>
            </template>

            <template v-else>
                <h1 class="text-xl font-bold text-center">¡Listo!</h1>
                <p class="text-sm text-gray-300 text-center">
                    Tu contraseña se guardó. Ya puedes entrar con tu usuario
                    <strong class="text-turquesa">{{ username }}</strong> y tu contraseña nueva.
                </p>
                <router-link :to="{ path: '/', query: { auth: 'login' } }"
                    class="block w-full text-center bg-turquesa-deep hover:bg-turquesa-deeper text-white font-bold py-3 rounded-lg transition-colors">
                    Iniciar sesión
                </router-link>
            </template>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { authApi } from '../api/apiClient'

const route = useRoute()
const router = useRouter()

// El token se lee y se quita de la barra de direcciones (no queda en el historial)
const token = typeof route.query.token === 'string' ? route.query.token : ''
if (token) router.replace({ path: '/restablecer' })

const state = ref('form')   // form | ok
const password = ref('')
const confirm = ref('')
const show = ref(false)
const loading = ref(false)
const error = ref('')
const username = ref('')

const submit = async () => {
    if (password.value.length < 8 || password.value !== confirm.value || loading.value) return
    loading.value = true
    error.value = ''
    try {
        const res = await authApi.resetPassword(token, password.value)
        username.value = res?.username || ''
        state.value = 'ok'
    } catch (e) {
        error.value = e.message || 'No se pudo guardar la contraseña.'
    } finally {
        loading.value = false
    }
}
</script>
