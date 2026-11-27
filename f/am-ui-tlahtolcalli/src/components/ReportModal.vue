<template>
    <div v-if="show" class="fixed inset-0 z-[60] flex items-end md:items-center justify-center bg-black/60 p-0 md:p-4"
        @click.self="close">
        <div role="dialog" aria-modal="true" aria-labelledby="tl-report-title"
            class="w-full md:max-w-md bg-gray-800 border border-gray-700 rounded-t-2xl md:rounded-2xl p-5 md:p-6 max-h-[92dvh] overflow-y-auto">

            <!-- Enviado -->
            <div v-if="sent" class="text-center py-6 space-y-2">
                <p class="text-4xl" aria-hidden="true">🙏</p>
                <h3 class="text-xl font-semibold">¡Gracias por avisar!</h3>
                <p class="text-gray-300">Revisaremos el ejercicio.</p>
            </div>

            <template v-else>
                <h3 id="tl-report-title" class="text-xl font-semibold mb-4">Reportar un problema</h3>

                <ul class="space-y-2 mb-4">
                    <li v-for="r in reasons" :key="r.id">
                        <label class="flex items-start gap-3 rounded-lg border px-3 py-3 cursor-pointer select-none tl-flat"
                            :class="picked.includes(r.id) ? 'border-turquesa bg-turquesa/10' : 'border-gray-700 hover:bg-gray-700/40'">
                            <input type="checkbox" class="mt-0.5 h-5 w-5 shrink-0 accent-turquesa" :value="r.id"
                                v-model="picked">
                            <span class="text-gray-200">{{ r.label }}</span>
                        </label>
                    </li>
                </ul>

                <textarea v-model="comment" rows="3" maxlength="1000"
                    placeholder="Ej.: Hay un error en la traducción…"
                    class="w-full rounded-lg bg-gray-900 border border-gray-700 p-3 text-gray-100 placeholder-gray-500 focus:outline-none focus:border-turquesa resize-none"></textarea>

                <p v-if="error" class="text-error text-sm mt-2" role="alert">{{ error }}</p>

                <div class="flex gap-3 mt-4">
                    <button type="button" @click="close" :disabled="sending"
                        class="flex-1 py-3 rounded-lg bg-gray-600 hover:bg-gray-700 font-medium">
                        Cancelar
                    </button>
                    <button type="button" @click="send" :disabled="!canSend || sending"
                        class="flex-1 py-3 rounded-lg bg-turquesa-deep hover:bg-turquesa-deeper font-medium disabled:bg-line disabled:text-stone-500">
                        {{ sending ? 'Enviando…' : 'Enviar' }}
                    </button>
                </div>
            </template>
        </div>
    </div>
</template>

<script setup>
import { computed, onBeforeUnmount, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { reportsApi, isOfflineError } from '../api/apiClient'
import { useAuthStore } from '../stores/auth'
import { reportReasons } from '../data/report.js'
import { APP_VERSION } from '../version.js'

const props = defineProps({
    show: { type: Boolean, default: false },
    isCorrect: { type: Boolean, default: false },
    /** Datos del ejercicio (exerciseReport en src/data/report.js) */
    context: { type: Object, default: () => ({}) },
})
const emit = defineEmits(['close'])

const route = useRoute()
const authStore = useAuthStore()

const picked = ref([])
const comment = ref('')
const sending = ref(false)
const sent = ref(false)
const error = ref('')
let timer = null

const reasons = computed(() => reportReasons(props.isCorrect))
const canSend = computed(() => picked.value.length > 0 || comment.value.trim().length > 0)

watch(() => props.show, open => {
    if (!open) return
    picked.value = []
    comment.value = ''
    sent.value = false
    error.value = ''
})

function onKey(e) { if (e.key === 'Escape') close() }
watch(() => props.show, open => {
    if (typeof window === 'undefined') return
    if (open) window.addEventListener('keydown', onKey)
    else window.removeEventListener('keydown', onKey)
})

function close() {
    if (sending.value) return
    clearTimeout(timer)
    emit('close')
}

async function send() {
    if (!canSend.value || sending.value) return
    sending.value = true
    error.value = ''
    const labels = Object.fromEntries(reasons.value.map(r => [r.id, r.label]))
    try {
        await reportsApi.send({
            ...props.context,
            reasons: picked.value.map(id => labels[id] || id),
            comment: comment.value.trim(),
            wasCorrect: props.isCorrect,
            screen: String(route.name || route.path),
            unitId: route.params.unitId ? Number(route.params.unitId) || null : null,
            levelId: route.params.levelId ? Number(route.params.levelId) || null : null,
            language: authStore.currentLanguage?.code || '',
            appVersion: APP_VERSION,
        })
        sent.value = true
        timer = setTimeout(() => emit('close'), 1600)
    } catch (err) {
        error.value = isOfflineError(err)
            ? 'Sin conexión. Inténtalo cuando tengas internet.'
            : err.status === 429
                ? 'Enviaste muchos reportes seguidos. Inténtalo más tarde.'
                : 'No se pudo enviar. Inténtalo de nuevo.'
    } finally {
        sending.value = false
    }
}

onBeforeUnmount(() => {
    clearTimeout(timer)
    if (typeof window !== 'undefined') window.removeEventListener('keydown', onKey)
})
</script>
