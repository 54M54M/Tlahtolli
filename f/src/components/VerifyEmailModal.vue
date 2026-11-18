<template>
    <Teleport to="body">
        <transition name="vem">
            <div v-if="visible" class="fixed inset-0 z-[100] flex items-end md:items-center justify-center bg-black/50 md:bg-black/70 md:p-4"
                role="dialog" aria-modal="true" aria-labelledby="vem-title" @keydown.esc="later" tabindex="-1" ref="root">

                <!-- Mobile: hoja inferior como el modal de los ejercicios · Desktop: tarjeta centrada -->
                <div class="vem-panel w-full bg-gray-800 border-t border-gray-700 p-4 pb-6
                            md:max-w-md md:rounded-2xl md:border md:p-8 md:shadow-2xl">
                    <div class="max-w-2xl mx-auto">
                        <div class="hidden md:flex justify-center mb-5">
                            <div class="w-16 h-16 rounded-full flex items-center justify-center border-2 border-yellow-500 bg-yellow-900/30 text-3xl">✉️</div>
                        </div>

                        <h3 id="vem-title" class="text-lg md:text-2xl font-semibold text-yellow-400 md:text-center mb-2">
                            Verifica tu correo
                        </h3>
                        <p class="text-gray-300 mb-1 md:text-center">
                            {{ pending ? 'Confirma tu nuevo correo con el enlace que enviamos a' : 'Confirma tu cuenta con el enlace que enviamos a' }}
                        </p>
                        <p class="font-semibold text-white mb-4 md:text-center [overflow-wrap:anywhere]">{{ email }}</p>

                        <p v-if="msg" class="mb-4 text-sm md:text-center" :class="ok ? 'text-turquesa' : 'text-error'">{{ msg }}</p>

                        <div class="grid grid-cols-2 gap-3">
                            <button @click="resend" :disabled="sending || cooldown > 0"
                                class="bg-turquesa-deep hover:bg-turquesa-deeper disabled:opacity-60 text-white py-4 md:py-3 px-3 rounded-lg font-semibold transition-colors">
                                {{ sending ? 'Enviando…' : cooldown > 0 ? `Reenviar (${cooldown})` : 'Reenviar correo' }}
                            </button>
                            <button @click="changeEmail"
                                class="border border-turquesa-deep hover:border-turquesa text-turquesa py-4 md:py-3 px-3 rounded-lg font-semibold transition-colors">
                                Cambiar correo
                            </button>
                            <button @click="later"
                                class="col-span-2 bg-gray-700 hover:bg-gray-600 text-white py-4 md:py-3 px-4 rounded-lg font-semibold transition-colors">
                                Verificar más tarde
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </transition>
    </Teleport>
</template>

<script setup>
import { computed, ref, watch, nextTick, onBeforeUnmount } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { accountApi } from '../api/apiClient'

// Rutas donde no debe interrumpir
const HIDDEN_ON = ['LanguageSelection', 'Leccion', 'NivelRapido', 'EditarPerfil', 'VerificarCorreo']

const authStore = useAuthStore()
const route = useRoute()
const router = useRouter()

const root = ref(null)
const sending = ref(false)
const msg = ref('')
const ok = ref(false)
const cooldown = ref(0)
let timer = null

// "Más tarde" vale para esta sesión del navegador; vuelve a salir al abrir la app de nuevo
const key = computed(() => `verifyEmailLater:${authStore.user?.id}`)
const dismissed = ref(false)
watch(key, (k) => {
    try { dismissed.value = sessionStorage.getItem(k) === '1' } catch { dismissed.value = false }
}, { immediate: true })

const pending = computed(() => !!authStore.user?.pendingEmail)
const email = computed(() => authStore.user?.pendingEmail || authStore.user?.email)

const visible = computed(() =>
    !!authStore.user &&
    authStore.isLanguageReady &&
    (authStore.user.emailVerified === false || pending.value) &&
    !dismissed.value &&
    !HIDDEN_ON.includes(route.name))

watch(visible, async (v) => {
    document.body.style.overflow = v ? 'hidden' : ''
    if (v) { await nextTick(); root.value?.focus() }
}, { immediate: true })

function dismiss() {
    dismissed.value = true
    try { sessionStorage.setItem(key.value, '1') } catch { /* sin almacenamiento */ }
}

function startCooldown(s = 60) {
    cooldown.value = s
    clearInterval(timer)
    timer = setInterval(() => { if (--cooldown.value <= 0) clearInterval(timer) }, 1000)
}

async function resend() {
    sending.value = true
    msg.value = ''
    try {
        await accountApi.resendVerification()
        ok.value = true
        msg.value = 'Listo. Revisa tu bandeja de entrada y la carpeta de spam.'
        startCooldown()
    } catch (e) {
        ok.value = false
        msg.value = e.message || 'No se pudo enviar. Intenta de nuevo.'
        if (/minuto/i.test(msg.value)) startCooldown()
    } finally {
        sending.value = false
    }
}

function changeEmail() {
    dismiss()
    router.push({ path: '/perfil/editar', query: { correo: '1' } })
}

function later() { dismiss() }

onBeforeUnmount(() => {
    clearInterval(timer)
    document.body.style.overflow = ''
})
</script>

<style scoped>
.vem-enter-active, .vem-leave-active { transition: opacity .25s ease; }
.vem-enter-active .vem-panel, .vem-leave-active .vem-panel { transition: transform .25s ease; }
.vem-enter-from, .vem-leave-to { opacity: 0; }
.vem-enter-from .vem-panel, .vem-leave-to .vem-panel { transform: translateY(100%); }
@media (min-width: 768px) {
    .vem-enter-from .vem-panel, .vem-leave-to .vem-panel { transform: scale(.95); }
}
</style>
