// src/offline/outbox.js
// Cola de lo que el usuario hizo sin conexión: lecciones terminadas y respuestas (energía).
// Se guarda en el teléfono y se envía en orden cuando vuelve la conexión, al abrir la app
// o al regresar a ella. Cada envío lleva un id propio (clientId): si llega dos veces al
// servidor, el segundo se ignora (ver SyncOpService en el back).

import { progressApi, energyApi, isOfflineError } from '../api/apiClient.js'
import { pendingCount } from './status.js'

const PREFIX = 'tl-outbox:'

export function newClientId() {
    if (typeof crypto !== 'undefined' && crypto.randomUUID) return crypto.randomUUID()
    // Respaldo para navegadores viejos (formato UUID v4)
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, c => {
        const r = Math.random() * 16 | 0
        return (c === 'x' ? r : (r & 0x3) | 0x8).toString(16)
    })
}

function key(userId) {
    return `${PREFIX}${userId}`
}

function read(userId) {
    if (!userId) return []
    try {
        const list = JSON.parse(localStorage.getItem(key(userId)) || '[]')
        return Array.isArray(list) ? list : []
    } catch {
        return []
    }
}

function write(userId, list) {
    try {
        if (list.length) localStorage.setItem(key(userId), JSON.stringify(list))
        else localStorage.removeItem(key(userId))
    } catch { /* sin almacenamiento: se pierde, igual que antes */ }
    pendingCount.value = list.length
}

/** Lección (o nivel rápido) terminada sin conexión. payload = lo mismo que progressApi.complete. */
export function queueLesson(userId, payload) {
    const list = read(userId)
    list.push({ id: payload.clientId || newClientId(), kind: 'lesson', payload, at: Date.now() })
    write(userId, list)
}

/** Respuesta contestada sin conexión: se agrupan las seguidas en un solo envío. */
export function queueAnswer(userId, isCorrect) {
    const list = read(userId)
    const last = list[list.length - 1]
    // No se agrega a uno que ya se está enviando
    if (last?.kind === 'energy' && !last.sending && last.payload.answers.length < 300) {
        last.payload.answers.push(!!isCorrect)
    } else {
        const clientId = newClientId()
        list.push({ id: clientId, kind: 'energy', payload: { clientId, answers: [!!isCorrect] }, at: Date.now() })
    }
    write(userId, list)
}

export function hasPending(userId) {
    return read(userId).length > 0
}

export function refreshPendingCount(userId) {
    pendingCount.value = read(userId).length
}

let flushing = null

/**
 * Envía la cola en orden. Se detiene en el primer envío que no pudo salir (sin conexión, servidor caído
 * o sesión vencida) y lo reintenta la próxima vez. Un envío que el servidor rechaza (4xx) se descarta.
 * Devuelve { sent, energy } — energy es la energía final que respondió el servidor, si hubo.
 */
export function flushOutbox(userId) {
    if (!userId) return Promise.resolve({ sent: 0, energy: null })
    if (flushing) return flushing
    flushing = (async () => {
        let sent = 0
        let energy = null
        let list = read(userId)
        while (list.length) {
            const op = list[0]
            op.sending = true
            write(userId, list)
            try {
                if (op.kind === 'lesson') {
                    await progressApi.complete(op.payload)
                } else if (op.kind === 'energy') {
                    energy = await energyApi.sync(userId, op.payload.clientId, op.payload.answers)
                }
                sent++
            } catch (err) {
                const status = err?.status
                const retryLater = isOfflineError(err) || !status || status === 401 || status === 429 || status >= 500
                if (retryLater) {
                    write(userId, read(userId).map(o => o.id === op.id ? { ...o, sending: false } : o))
                    break
                }
                console.warn('[outbox] envío rechazado por el servidor, se descarta:', op.kind, err.message)
            }
            // Releer por si se agregó algo mientras se enviaba
            list = read(userId).filter(o => o.id !== op.id)
            write(userId, list)
        }
        return { sent, energy }
    })().finally(() => { flushing = null })
    return flushing
}
