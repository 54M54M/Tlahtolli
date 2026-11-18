<template>
    <div class="bg-surface-0 text-white pt-4">
        <Header variant="simple" title="Editar perfil" show-back back-route="/perfil" class="pt-6 md:pt-5" />

        <main class="container mx-auto py-1 md:py-2 pb-16 md:pb-20">
            <div v-if="loadingInfo" class="flex justify-center py-16">
                <div class="animate-spin rounded-full h-10 w-10 border-b-2 border-white"></div>
            </div>

            <div v-else class="w-full max-w-md mx-auto space-y-6">
                <!-- Avatar -->
                <div class="flex flex-col items-center">
                    <UserAvatar :name="profile.username || info.username" :size="96" />
                    <p class="text-xs text-gray-400 mt-2">Tu avatar se genera a partir de tu usuario</p>
                </div>

                <!-- ── Perfil ─────────────────────────────────────────────── -->
                <section class="bg-surface-1 rounded-xl p-4 space-y-4">
                    <h2 class="font-bold">Perfil</h2>
                    <div>
                        <label class="lbl">Nombre completo</label>
                        <input v-model="profile.fullName" type="text" maxlength="100" class="inp" autocomplete="name" />
                    </div>
                    <div>
                        <label class="lbl">Usuario</label>
                        <input v-model="profile.username" type="text" maxlength="30" class="inp"
                            :disabled="!!info.usernameChangeAvailableAt" autocomplete="username" @input="checkUsername" />
                        <p v-if="info.usernameChangeAvailableAt" class="hint text-gray-400">
                            Podrás cambiarlo de nuevo el {{ fmtDate(info.usernameChangeAvailableAt) }}.
                        </p>
                        <template v-else>
                            <p v-if="usernameState === 'checking'" class="hint text-gray-400">Revisando…</p>
                            <p v-else-if="usernameState === 'ok'" class="hint text-turquesa">Disponible</p>
                            <p v-else-if="usernameState === 'bad'" class="hint text-error">{{ usernameReason }}</p>
                            <p v-if="usernameChanged" class="hint text-gray-400">
                                Después de cambiarlo tendrás que esperar {{ info.usernameCooldownDays }} días para volver a hacerlo.
                            </p>
                        </template>
                    </div>
                    <Msg :m="msgs.profile" />
                    <button @click="saveProfile" :disabled="busy.profile || !profileDirty || usernameState === 'bad' || usernameState === 'checking'" class="btn">
                        {{ busy.profile ? 'Guardando…' : 'Guardar perfil' }}
                    </button>
                </section>

                <!-- ── Correo ─────────────────────────────────────────────── -->
                <section class="bg-surface-1 rounded-xl p-4 space-y-4">
                    <h2 class="font-bold">Correo electrónico</h2>
                    <div class="flex items-center gap-2 flex-wrap">
                        <span class="break-all">{{ info.email }}</span>
                        <span v-if="info.emailVerified" class="chip bg-green-900/40 text-green-300 border-green-700">Verificado</span>
                        <span v-else class="chip bg-yellow-900/30 text-yellow-200 border-yellow-700">Sin verificar</span>
                    </div>

                    <div v-if="info.pendingEmail" class="p-3 rounded-lg border border-line text-sm space-y-2">
                        <p>Cambio pendiente a <b class="break-all">{{ info.pendingEmail }}</b>. Abre el enlace que enviamos a ese correo para terminar.</p>
                        <div class="flex gap-4">
                            <button @click="resend" :disabled="busy.email" class="underline hover:text-turquesa disabled:opacity-50">Reenviar enlace</button>
                            <button @click="cancelChange" :disabled="busy.email" class="underline hover:text-error disabled:opacity-50">Cancelar cambio</button>
                        </div>
                    </div>
                    <button v-else-if="!info.emailVerified" @click="resend" :disabled="busy.email" class="btn-outline">
                        Reenviar correo de verificación
                    </button>

                    <details class="group" :open="emailFormOpen" @toggle="emailFormOpen = $event.target.open">
                        <summary class="cursor-pointer text-sm text-gray-300 hover:text-white">Cambiar correo</summary>
                        <div class="space-y-3 mt-3">
                            <div>
                                <label class="lbl">Nuevo correo</label>
                                <input v-model="emailForm.email" type="email" maxlength="150" class="inp" autocomplete="email" />
                            </div>
                            <div>
                                <label class="lbl">Tu contraseña</label>
                                <input v-model="emailForm.password" type="password" class="inp" autocomplete="current-password" />
                            </div>
                            <p class="hint text-gray-400">Tu correo actual seguirá activo hasta que confirmes el nuevo.</p>
                            <button @click="changeEmail" :disabled="busy.email || !emailForm.email || !emailForm.password" class="btn">
                                {{ busy.email ? 'Enviando…' : 'Enviar enlace al nuevo correo' }}
                            </button>
                        </div>
                    </details>
                    <Msg :m="msgs.email" />
                </section>

                <!-- ── Contraseña ─────────────────────────────────────────── -->
                <section class="bg-surface-1 rounded-xl p-4 space-y-3">
                    <h2 class="font-bold">Contraseña</h2>
                    <div>
                        <label class="lbl">Contraseña actual</label>
                        <input v-model="pwd.current" type="password" class="inp" autocomplete="current-password" />
                    </div>
                    <div>
                        <label class="lbl">Nueva contraseña</label>
                        <input v-model="pwd.next" type="password" class="inp" autocomplete="new-password" />
                        <p v-if="pwd.next && pwd.next.length < 8" class="hint text-error">Mínimo 8 caracteres</p>
                    </div>
                    <div>
                        <label class="lbl">Confirmar nueva contraseña</label>
                        <input v-model="pwd.confirm" type="password" class="inp" autocomplete="new-password" />
                        <p v-if="pwd.confirm && pwd.confirm !== pwd.next" class="hint text-error">No coinciden</p>
                    </div>
                    <Msg :m="msgs.password" />
                    <button @click="changePassword"
                        :disabled="busy.password || !pwd.current || pwd.next.length < 8 || pwd.next !== pwd.confirm" class="btn">
                        {{ busy.password ? 'Guardando…' : 'Cambiar contraseña' }}
                    </button>
                </section>

                <!-- ── Eliminar cuenta ────────────────────────────────────── -->
                <section class="rounded-xl p-4 space-y-3 border border-error/50">
                    <h2 class="font-bold text-error">Eliminar cuenta</h2>
                    <p class="text-sm text-gray-400">Se borran tu progreso, logros, estadísticas e historial. No se puede deshacer.</p>
                    <template v-if="delOpen">
                        <div>
                            <label class="lbl">Escribe tu contraseña para confirmar</label>
                            <input v-model="delPassword" type="password" class="inp" autocomplete="current-password" />
                        </div>
                        <Msg :m="msgs.del" />
                        <div class="flex gap-3">
                            <button @click="delOpen = false; delPassword = ''" class="btn-outline flex-1">Cancelar</button>
                            <button @click="deleteAccount" :disabled="busy.del || !delPassword"
                                class="flex-1 bg-error/80 hover:bg-error disabled:opacity-50 text-white font-bold py-3 rounded-lg transition-colors">
                                {{ busy.del ? 'Eliminando…' : 'Eliminar para siempre' }}
                            </button>
                        </div>
                    </template>
                    <button v-else @click="delOpen = true" class="btn-outline !border-error/60 !text-error">Eliminar mi cuenta</button>
                </section>

                <Msg :m="msgs.load" />
            </div>
        </main>
    </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, h } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { accountApi } from '../api/apiClient'
import UserAvatar from '../components/UserAvatar.vue'
import Header from '../components/vHeader.vue'

// Mensaje de éxito o error por sección
const Msg = (props) => props.m?.text
    ? h('div', {
        class: ['p-3 rounded-lg text-sm border', props.m.ok
            ? 'bg-green-900/40 border-green-600 text-green-300'
            : 'bg-error-soft/40 border-error text-error'],
    }, props.m.text)
    : null
Msg.props = ['m']

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

const loadingInfo = ref(true)
const info = ref({})
const profile = reactive({ fullName: '', username: '' })
const emailForm = reactive({ email: '', password: '' })
const emailFormOpen = ref(route.query.correo === '1')   // viene del aviso "Cambiar correo"
const pwd = reactive({ current: '', next: '', confirm: '' })
const delOpen = ref(false)
const delPassword = ref('')
const busy = reactive({ profile: false, email: false, password: false, del: false })
const msgs = reactive({ profile: null, email: null, password: null, del: null, load: null })

const usernameState = ref('')      // '' | checking | ok | bad
const usernameReason = ref('')
let usernameTimer = null

const usernameChanged = computed(() => profile.username.trim() !== info.value.username)
const profileDirty = computed(() =>
    usernameChanged.value || profile.fullName.trim().replace(/\s+/g, ' ') !== info.value.fullName)

const fmtDate = (iso) => new Date(iso).toLocaleDateString('es-MX', { day: 'numeric', month: 'long', year: 'numeric' })

function applyInfo(data) {
    info.value = data
    profile.fullName = data.fullName || ''
    profile.username = data.username || ''
    usernameState.value = ''
    authStore.user = {
        ...authStore.user,
        username: data.username, fullName: data.fullName, email: data.email,
        emailVerified: data.emailVerified, pendingEmail: data.pendingEmail,
    }
}

onMounted(async () => {
    try {
        applyInfo(await accountApi.get())
    } catch (e) {
        msgs.load = { ok: false, text: e.message || 'No se pudo cargar tu cuenta.' }
    } finally {
        loadingInfo.value = false
    }
})

function checkUsername() {
    clearTimeout(usernameTimer)
    const u = profile.username.trim()
    if (!usernameChanged.value) { usernameState.value = ''; return }
    if (!/^[A-Za-z0-9_.]{3,30}$/.test(u)) {
        usernameState.value = 'bad'
        usernameReason.value = 'Usa de 3 a 30 caracteres: letras, números, punto o guion bajo'
        return
    }
    usernameState.value = 'checking'
    usernameTimer = setTimeout(async () => {
        try {
            const r = await accountApi.usernameAvailable(u)
            if (profile.username.trim() !== u) return
            usernameState.value = r.available ? 'ok' : 'bad'
            usernameReason.value = r.reason || ''
        } catch {
            usernameState.value = ''
        }
    }, 400)
}

async function run(key, fn, okText) {
    busy[key] = true
    msgs[key] = null
    try {
        await fn()
        if (okText) msgs[key] = { ok: true, text: okText }
    } catch (e) {
        msgs[key] = { ok: false, text: e.message || 'Algo salió mal. Intenta de nuevo.' }
    } finally {
        busy[key] = false
    }
}

const saveProfile = () => {
    if (!profile.fullName.trim()) { msgs.profile = { ok: false, text: 'Escribe tu nombre.' }; return }
    if (usernameChanged.value && !confirm(`¿Cambiar tu usuario a "${profile.username.trim()}"? No podrás volver a cambiarlo en ${info.value.usernameCooldownDays} días.`)) return
    return run('profile', async () => {
        applyInfo(await accountApi.updateProfile({
            fullName: profile.fullName.trim(),
            username: usernameChanged.value ? profile.username.trim() : null,
        }))
    }, 'Perfil actualizado.')
}

const resend = () => run('email', () => accountApi.resendVerification(),
    'Enlace enviado. Revisa tu bandeja de entrada y la de spam.')

const cancelChange = () => run('email', async () => applyInfo(await accountApi.cancelEmailChange()),
    'Cambio de correo cancelado.')

const changeEmail = () => run('email', async () => {
    applyInfo(await accountApi.changeEmail(emailForm.email.trim(), emailForm.password))
    emailForm.email = ''
    emailForm.password = ''
    emailFormOpen.value = false
}, 'Te enviamos un enlace al nuevo correo. El cambio se hace al confirmarlo.')

const changePassword = () => run('password', async () => {
    await accountApi.changePassword(pwd.current, pwd.next)
    pwd.current = pwd.next = pwd.confirm = ''
}, 'Contraseña actualizada.')

const deleteAccount = () => run('del', async () => {
    await accountApi.remove(delPassword.value)
    authStore.logout()
    router.replace('/login')
})
</script>

<style scoped>
.lbl { @apply block text-sm font-medium mb-1 text-gray-300; }
.inp { @apply w-full bg-surface-0 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-500 focus:outline-none focus:border-turquesa transition-colors disabled:opacity-50; }
.hint { @apply mt-1 text-xs; }
.btn { @apply w-full bg-turquesa-deep hover:bg-turquesa-deeper disabled:opacity-50 text-white font-bold py-3 rounded-lg transition-colors; }
.btn-outline { @apply w-full border border-gray-600 hover:border-turquesa text-white font-bold py-3 rounded-lg transition-colors disabled:opacity-50; }
.chip { @apply text-xs px-2 py-0.5 rounded-full border; }
</style>
