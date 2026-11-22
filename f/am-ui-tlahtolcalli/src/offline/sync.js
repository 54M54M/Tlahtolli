// src/offline/sync.js
// Detecta cuándo se va y cuándo vuelve la conexión, y al volver:
//   1. envía lo que se hizo sin conexión (outbox.js),
//   2. limpia la caché en memoria y refresca usuario y energía,
//   3. si la vista actual no tenía datos, la vuelve a montar (se quita la pantalla de "Sin conexión").

import { watch } from 'vue'
import { offline, dataMissing, viewEpoch } from './status.js'
import { flushOutbox, refreshPendingCount } from './outbox.js'
import { useAuthStore } from '../stores/auth.js'
import { useCacheStore } from '../stores/cache.js'
import { useEnergyStore } from '../stores/energy.js'

const HEALTH_URL = `${import.meta.env.VITE_API_URL}/health`
const PROBE_EVERY_MS = 15000

let probeTimer = null
let reconnecting = null

/** ¿Responde el servidor? (no basta con navigator.onLine: puede haber Wi-Fi sin internet) */
export async function probe() {
    const ctrl = typeof AbortController !== 'undefined' ? new AbortController() : null
    const timer = ctrl ? setTimeout(() => ctrl.abort(), 8000) : null
    try {
        await fetch(HEALTH_URL, { cache: 'no-store', signal: ctrl?.signal })
        return true
    } catch {
        return false
    } finally {
        if (timer) clearTimeout(timer)
    }
}

/** Envía la cola y deja los datos al día. Seguro de llamar varias veces. */
export async function syncNow() {
    const auth = useAuthStore()
    const userId = auth.user?.id
    if (!userId || !auth.isAuthenticated) return
    const { sent, energy } = await flushOutbox(userId)
    if (sent > 0) {
        useCacheStore().invalidatePrefix('')
        if (energy) useEnergyStore().applyServer(energy)
        await auth.refreshUser()
        window.dispatchEvent(new CustomEvent('tl:synced', { detail: { sent } }))
    }
}

function goOffline() {
    offline.value = true
    if (!probeTimer) {
        probeTimer = setInterval(async () => {
            if (await probe()) goOnline()
        }, PROBE_EVERY_MS)
    }
}

function goOnline() {
    if (reconnecting) return reconnecting
    reconnecting = (async () => {
        clearInterval(probeTimer)
        probeTimer = null
        offline.value = false
        try {
            await syncNow()
        } catch (err) {
            console.warn('[sync] no se pudo enviar lo pendiente:', err?.message)
        }
        if (dataMissing.value) {
            dataMissing.value = false
            viewEpoch.value++
        }
    })().finally(() => { reconnecting = null })
    return reconnecting
}

/** Botón "Reintentar": comprueba el servidor y, si responde, sincroniza. Devuelve si hay conexión. */
export async function retryConnection() {
    if (await probe()) {
        await goOnline()
        return true
    }
    goOffline()
    return false
}

export function setupOfflineSync() {
    if (typeof window === 'undefined') return

    window.addEventListener('offline', goOffline)
    window.addEventListener('online', () => { retryConnection() })
    // apiClient avisa si el servidor respondió o no
    window.addEventListener('tl:connection', (e) => (e.detail === false ? goOffline() : goOnline()))
    window.addEventListener('tl:data-missing', () => { dataMissing.value = true })
    // Al volver a la app (estaba en segundo plano), enviar pendientes
    document.addEventListener('visibilitychange', () => {
        if (document.visibilityState === 'visible') offline.value ? retryConnection() : syncNow().catch(() => {})
    })

    if (navigator.onLine === false) goOffline()

    // Al abrir la app con sesión: enviar lo que quedó pendiente de la vez anterior
    // y al iniciar sesión (si esa cuenta dejó algo pendiente en este dispositivo)
    const auth = useAuthStore()
    watch(() => auth.user?.id, (id) => {
        refreshPendingCount(id)
        if (id && !offline.value) syncNow().catch(() => {})
    }, { immediate: true })
}
