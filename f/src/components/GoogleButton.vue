<template>
    <div v-if="clientId" class="w-full">
        <!-- Alto fijo: el botón de Google aparece encima del marcador sin mover lo demás -->
        <div class="relative w-full h-[44px]">
            <!-- Marcador con la misma forma del botón mientras carga el de Google -->
            <div v-show="!ready && !loadError" aria-hidden="true"
                class="absolute inset-0 flex justify-center items-center">
                <div class="h-10 w-full max-w-[400px] rounded bg-[#131314] border border-[#8e918f]/60 flex items-center justify-center gap-3 animate-pulse">
                    <span class="w-[18px] h-[18px] rounded-full bg-white/80"></span>
                    <span class="h-3 w-32 rounded bg-white/20"></span>
                </div>
            </div>

            <!-- color-scheme: light → el iframe de Google queda transparente (con "dark" el navegador le pinta fondo blanco) -->
            <div ref="slot" class="absolute inset-0 flex justify-center items-center transition-opacity duration-200"
                :class="ready ? 'opacity-100' : 'opacity-0 pointer-events-none'" style="color-scheme: light"></div>
        </div>
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
const ready = ref(false)
const loadError = ref(false)

let observer = null
let revealTimer = null
let activeHandler = null

// Un solo script para toda la app (se comparte entre pestañas Iniciar sesión / Registrarse)
function loadScript() {
    if (window.google?.accounts?.id) return Promise.resolve()
    if (!window.__gisScriptPromise) {
        window.__gisScriptPromise = new Promise((resolve, reject) => {
            const s = document.createElement('script')
            s.src = 'https://accounts.google.com/gsi/client'
            s.async = true
            s.onload = resolve
            s.onerror = () => { window.__gisScriptPromise = null; reject(new Error('gsi')) }
            document.head.appendChild(s)
        })
    }
    return window.__gisScriptPromise
}
// Empieza a descargar el script en cuanto se carga este componente, antes de montarlo
if (clientId) loadScript().catch(() => {})

const onCredential = (resp) => { if (resp?.credential) emit('credential', resp.credential) }

// Google pinta primero un botón genérico y luego, dentro del iframe, el definitivo
// (a veces personalizado: "Continuar como …"). Se muestra cuando el iframe terminó de cargar
// y dejó de cambiar de tamaño, para que no se vea el salto.
function revealWhenSettled() {
    const reveal = () => { clearTimeout(revealTimer); revealTimer = setTimeout(() => { ready.value = true }, 250) }
    const watchIframe = () => {
        const iframe = slot.value?.querySelector('iframe')
        if (!iframe) return false
        iframe.addEventListener('load', reveal, { once: true })
        if (typeof ResizeObserver !== 'undefined') {
            observer?.disconnect?.()
            observer = new ResizeObserver(() => { if (!ready.value) reveal() })
            observer.observe(iframe)
        }
        return true
    }
    if (!watchIframe()) {
        const mo = new MutationObserver(() => { if (watchIframe()) mo.disconnect() })
        mo.observe(slot.value, { childList: true, subtree: true })
        observer = { disconnect: () => mo.disconnect() }
    }
    // Respaldo: si el evento no llega, mostrarlo igual
    setTimeout(() => { ready.value = true }, 2500)
}

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
        // Ancho fijo calculado una sola vez (Google no acepta ancho relativo)
        const width = Math.round(Math.min(400, Math.max(200, slot.value.offsetWidth || 320)))
        revealWhenSettled()
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
    observer?.disconnect?.()
    clearTimeout(revealTimer)
    if (window.__gisHandler === activeHandler) window.__gisHandler = null
})
</script>
