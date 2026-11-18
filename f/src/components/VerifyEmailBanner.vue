<template>
    <div v-if="visible" class="mb-4 p-3 rounded-lg border border-yellow-600/60 bg-yellow-900/20 text-sm text-yellow-100 flex items-start gap-3">
        <span class="text-lg leading-none">✉️</span>
        <div class="flex-1">
            <p><b>Verifica tu correo.</b> Te enviamos un enlace a <span class="[overflow-wrap:anywhere]">{{ authStore.user.email }}</span>.</p>
            <div class="mt-2 flex flex-wrap gap-3 items-center">
                <button @click="resend" :disabled="sending" class="underline hover:text-white disabled:opacity-50">
                    {{ sending ? 'Enviando…' : 'Reenviar correo' }}
                </button>
                <router-link to="/perfil/editar" class="underline hover:text-white">Cambiar correo</router-link>
                <span v-if="msg" class="text-xs" :class="ok ? 'text-turquesa' : 'text-error'">{{ msg }}</span>
            </div>
        </div>
        <button @click="dismiss" aria-label="Ocultar" class="text-yellow-200/70 hover:text-white">✕</button>
    </div>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useAuthStore } from '../stores/auth'
import { accountApi } from '../api/apiClient'

const authStore = useAuthStore()
const sending = ref(false)
const msg = ref('')
const ok = ref(false)
const hidden = ref(sessionStorageGet())

function sessionStorageGet() {
    try { return sessionStorage.getItem('hideVerifyBanner') === '1' } catch { return false }
}

const visible = computed(() =>
    !hidden.value && authStore.user && authStore.user.emailVerified === false)

const resend = async () => {
    sending.value = true
    msg.value = ''
    try {
        await accountApi.resendVerification()
        ok.value = true
        msg.value = 'Listo, revisa tu bandeja (y spam).'
    } catch (e) {
        ok.value = false
        msg.value = e.message
    } finally {
        sending.value = false
    }
}

const dismiss = () => {
    hidden.value = true
    try { sessionStorage.setItem('hideVerifyBanner', '1') } catch { /* sin almacenamiento */ }
}
</script>
