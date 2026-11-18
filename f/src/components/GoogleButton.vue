<template>
    <div v-if="clientId" class="w-full">
        <div ref="slot" class="w-full flex justify-center min-h-[44px]"></div>
        <p v-if="loadError" class="mt-2 text-xs text-error text-center">No se pudo cargar el botón de Google. Revisa tu conexión o desactiva el bloqueador de anuncios.</p>
    </div>
</template>

<script setup>
// Botón oficial "Continuar con Google" (Google Identity Services).
// Emite 'credential' con el ID token; el backend lo valida en /api/auth/google.
import { ref, onMounted, onBeforeUnmount } from 'vue'

const props = defineProps({
    text: { type: String, default: 'continue_with' },   // signin_with | signup_with | continue_with
})
const emit = defineEmits(['credential'])

const clientId = import.meta.env.VITE_GOOGLE_CLIENT_ID
const slot = ref(null)
const loadError = ref(false)

// Un solo script y un solo initialize para toda la app; el callback activo es el del último botón montado
let scriptPromise = window.__gisScriptPromise
let activeHandler = null
function loadScript() {
    if (window.google?.accounts?.id) return Promise.resolve()
    if (!scriptPromise) {
        scriptPromise = window.__gisScriptPromise = new Promise((resolve, reject) => {
            const s = document.createElement('script')
            s.src = 'https://accounts.google.com/gsi/client'
            s.async = true
            s.defer = true
            s.onload = resolve
            s.onerror = () => { window.__gisScriptPromise = null; reject(new Error('gsi')) }
            document.head.appendChild(s)
        })
    }
    return scriptPromise
}

const onCredential = (resp) => { if (resp?.credential) emit('credential', resp.credential) }

onMounted(async () => {
    if (!clientId) return
    try {
        await loadScript()
        if (!slot.value) return
        window.__gisHandler = onCredential
        if (!window.__gisInitialized) {
            window.google.accounts.id.initialize({
                client_id: clientId,
                callback: (r) => window.__gisHandler?.(r),
                ux_mode: 'popup',
                auto_select: false,
                cancel_on_tap_outside: true,
                use_fedcm_for_button: true,
            })
            window.__gisInitialized = true
        }
        const width = Math.min(400, Math.max(200, slot.value.offsetWidth || 320))
        window.google.accounts.id.renderButton(slot.value, {
            type: 'standard',
            theme: 'filled_black',
            size: 'large',
            shape: 'rectangular',
            text: props.text,
            logo_alignment: 'center',
            locale: 'es-419',
            width,
        })
        activeHandler = onCredential
    } catch {
        loadError.value = true
    }
})

onBeforeUnmount(() => {
    if (window.__gisHandler === activeHandler) window.__gisHandler = null
})
</script>
