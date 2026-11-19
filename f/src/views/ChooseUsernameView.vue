<template>
    <div class="min-h-screen flex items-center justify-center px-4 py-8 bg-surface-0 text-white">
        <div class="w-full max-w-md bg-surface-6 rounded-xl p-6 md:p-8 shadow-lg space-y-5">
            <div class="text-center space-y-1">
                <p class="text-xs tracking-widest uppercase text-turquesa font-bold">Tlahtolcalli</p>
                <h1 class="text-2xl font-bold">¡Bienvenido, {{ firstName }}!</h1>
                <p class="text-sm text-gray-400">Este será tu nombre de usuario. Puedes dejarlo así o cambiarlo ahora.</p>
            </div>

            <div class="flex justify-center">
                <AvatarStage :name="username.trim() || current" :size="88" />
            </div>

            <div>
                <label class="block text-sm font-medium mb-1 text-gray-300">Usuario</label>
                <input v-model="username" @input="check" type="text" maxlength="30" autocomplete="username"
                    class="w-full bg-surface-0 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-turquesa transition-colors"
                    @keyup.enter="save" />
                <p v-if="state === 'checking'" class="mt-1 text-xs text-gray-400">Revisando…</p>
                <p v-else-if="state === 'ok'" class="mt-1 text-xs text-turquesa">Disponible</p>
                <p v-else-if="state === 'bad'" class="mt-1 text-xs text-error">{{ reason }}</p>
                <p class="mt-1 text-xs text-gray-400">
                    De 3 a 30 caracteres: letras, números, punto o guion bajo. Después podrás cambiarlo una vez cada {{ cooldown }} días.
                </p>
            </div>

            <div v-if="errorMsg" class="p-3 bg-error-soft/40 border border-error rounded-lg text-error text-sm">{{ errorMsg }}</div>

            <button @click="save" :disabled="saving || state === 'bad' || state === 'checking'"
                class="w-full bg-turquesa-deep hover:bg-turquesa-deeper disabled:opacity-50 text-white font-bold py-3 rounded-lg transition-colors">
                {{ saving ? 'Guardando…' : changed ? 'Usar este usuario' : 'Continuar' }}
            </button>

            <button @click="logout" class="w-full text-sm text-gray-400 hover:text-white">Salir</button>
        </div>
    </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { accountApi } from '../api/apiClient'
import AvatarStage from '../components/AvatarStage.vue'

const router = useRouter()
const authStore = useAuthStore()

const current = authStore.user?.username || ''
const username = ref(current)
const state = ref('')          // '' | checking | ok | bad
const reason = ref('')
const saving = ref(false)
const errorMsg = ref('')
const cooldown = ref(30)
let timer = null

const firstName = computed(() => (authStore.user?.fullName || '').trim().split(/\s+/)[0] || current)
const changed = computed(() => username.value.trim() !== current)

accountApi.get().then(i => { cooldown.value = i.usernameCooldownDays ?? 30 }).catch(() => {})

function check() {
    clearTimeout(timer)
    errorMsg.value = ''
    const u = username.value.trim()
    if (!changed.value) { state.value = ''; return }
    if (!/^[A-Za-z0-9_.]{3,30}$/.test(u)) {
        state.value = 'bad'
        reason.value = 'Usa de 3 a 30 caracteres: letras, números, punto o guion bajo'
        return
    }
    state.value = 'checking'
    timer = setTimeout(async () => {
        try {
            const r = await accountApi.usernameAvailable(u)
            if (username.value.trim() !== u) return
            state.value = r.available ? 'ok' : 'bad'
            reason.value = r.reason || ''
        } catch { state.value = '' }
    }, 400)
}

async function save() {
    if (saving.value || state.value === 'bad' || state.value === 'checking') return
    saving.value = true
    errorMsg.value = ''
    try {
        // Enviar el usuario (aunque no cambie) confirma la elección; no cuenta para el tiempo de espera
        const info = await accountApi.updateProfile({ username: username.value.trim() })
        authStore.user = { ...authStore.user, username: info.username, mustPickUsername: false }
        router.replace(authStore.selectedLanguage ? '/app' : '/app/idioma')
    } catch (e) {
        errorMsg.value = e.message || 'No se pudo guardar tu usuario.'
    } finally {
        saving.value = false
    }
}

function logout() {
    authStore.logout()
    router.replace('/login')
}
</script>
