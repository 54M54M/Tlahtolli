// src/offline/copies.js
// Última respuesta buena de cada consulta (GET) a la API, guardada en el teléfono.
// Solo se usa cuando no hay conexión: así Home, Nivel o una lección ya abierta siguen
// mostrándose aunque se vaya el internet (o aunque se cierre y se vuelva a abrir la app).

const KEY = 'tl-offline-copies'
const MAX_ENTRIES = 150

// No se guardan: la energía la lleva su store; el resto no tiene sentido sin conexión
const SKIP = ['/energy/', '/auth/', '/health', '/account/username-available', '/admin/']

let memory = null

function load() {
    if (memory) return memory
    try {
        memory = JSON.parse(localStorage.getItem(KEY) || '{}') || {}
    } catch {
        memory = {}
    }
    return memory
}

function persist() {
    try {
        localStorage.setItem(KEY, JSON.stringify(memory))
    } catch {
        // Sin espacio: se queda con la mitad más reciente y lo intenta otra vez
        const keep = Object.entries(memory).sort((a, b) => b[1].t - a[1].t).slice(0, Math.floor(MAX_ENTRIES / 2))
        memory = Object.fromEntries(keep)
        try { localStorage.setItem(KEY, JSON.stringify(memory)) } catch { /* sin almacenamiento */ }
    }
}

export function canCopy(path) {
    return !SKIP.some(p => path.includes(p))
}

export function saveCopy(path, data) {
    if (!canCopy(path) || data === undefined) return
    const all = load()
    all[path] = { t: Date.now(), d: data }
    const keys = Object.keys(all)
    if (keys.length > MAX_ENTRIES) {
        keys.sort((a, b) => all[a].t - all[b].t)
            .slice(0, keys.length - MAX_ENTRIES)
            .forEach(k => delete all[k])
    }
    persist()
}

/** { data } si hay copia guardada de esa consulta; null si no. */
export function readCopy(path) {
    if (!canCopy(path)) return null
    const hit = load()[path]
    return hit ? { data: hit.d } : null
}

/** Al cerrar sesión: las copias son de esa cuenta. */
export function clearCopies() {
    memory = {}
    try { localStorage.removeItem(KEY) } catch { /* nada */ }
}
