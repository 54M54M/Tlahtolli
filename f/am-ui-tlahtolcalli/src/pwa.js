// src/pwa.js
// Registro del service worker (solo en el navegador; lo llama main.js).
// Cuando hay una versión nueva, avisa con el evento 'tl:update-ready' y UpdatePrompt.vue
// le pregunta al usuario. applyUpdate() activa la versión nueva y recarga.
import { registerSW } from 'virtual:pwa-register'

let update = null
let ready = false

export function setupPWA() {
    if (typeof window === 'undefined' || !('serviceWorker' in navigator)) return
    update = registerSW({
        immediate: true,
        onNeedRefresh() {
            ready = true
            window.dispatchEvent(new CustomEvent('tl:update-ready'))
        },
        onRegisteredSW(_url, registration) {
            // Revisa si hay versión nueva cada hora (la app instalada puede quedarse abierta días)
            if (registration) setInterval(() => registration.update().catch(() => {}), 60 * 60 * 1000)
        },
        onRegisterError(err) {
            console.warn('[pwa] no se pudo registrar el service worker:', err)
        },
    })
}

export const updateReady = () => ready

export function applyUpdate() {
    if (update) update(true)
    else window.location.reload()
}
