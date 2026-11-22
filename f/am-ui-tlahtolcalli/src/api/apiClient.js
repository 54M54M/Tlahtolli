// src/api/apiClient.js
// Punto central de comunicación con el backend Spring Boot.
// Toda llamada HTTP de la app pasa por aquí.
// src/api/apiClient.js

import { canCopy, readCopy, saveCopy } from '../offline/copies.js'

const BASE_URL = import.meta.env.VITE_API_URL

// Front de desarrollo (VITE_APP_ENV=dev): el backend le muestra también los cursos en pruebas
// a las cuentas con rol tester o admin. En producción no se manda.
export const IS_DEV_SITE = import.meta.env.VITE_APP_ENV === 'dev'
const ENV_HEADERS = IS_DEV_SITE ? { 'X-Tlahtolcalli-Env': 'dev' } : {}

// ── sesión ──────────────────────────────────────────────────────────────────
// main.js conecta estas funciones con el store de auth (evita importar el store aquí).
let getToken = () => null
let onUnauthorized = () => {}

export function configureAuth({ token, unauthorized } = {}) {
    if (token) getToken = token
    if (unauthorized) onUnauthorized = unauthorized
}

// ── utilidad interna ────────────────────────────────────────────────────────

// Avisa a la interfaz si el servidor respondió o no (evento 'tl:connection', detail: true | false)
let lastConnection = true
function connection(ok) {
    if (ok === lastConnection || typeof window === 'undefined') return
    lastConnection = ok
    window.dispatchEvent(new CustomEvent('tl:connection', { detail: ok }))
}

async function request(path, options = {}) {
    const url = `${BASE_URL}${path}`
    const token = getToken()
    const { optional, ...fetchOptions } = options // eslint-disable-line no-unused-vars
    const config = {
        ...fetchOptions,
        headers: {
            'Content-Type': 'application/json',
            ...ENV_HEADERS,
            ...(token ? { Authorization: `Bearer ${token}` } : {}),
            ...options.headers,
        },
    }

    const method = (options.method || 'GET').toUpperCase()

    let res
    try {
        res = await fetch(url, config)
    } catch (err) {
        // Sin respuesta del servidor (sin internet)
        connection(false)
        if (method === 'GET') {
            // Si esta consulta ya se había hecho, se usa la última respuesta guardada
            const copy = readCopy(path)
            if (copy) return copy.data
            // Si no, la vista no tiene con qué mostrarse: OfflineScreen.vue muestra la pantalla completa
            // (options.optional: datos secundarios, p. ej. el panel lateral; si faltan no tapan la vista)
            if (canCopy(path) && !options.optional && typeof window !== 'undefined') {
                window.dispatchEvent(new CustomEvent('tl:data-missing', { detail: path }))
            }
        }
        const offlineErr = new Error('Sin conexión')
        offlineErr.offline = true
        offlineErr.cause = err
        throw offlineErr
    }
    connection(true)

    // Token vencido o inválido en una ruta protegida → cerrar sesión (excepto el propio login)
    if (res.status === 401 && !path.startsWith('/auth/')) onUnauthorized()

    // Sin contenido
    if (res.status === 204) return null

    // Intentar parsear JSON solo si hay contenido
    const text = await res.text()
    const data = text ? JSON.parse(text) : null

    if (!res.ok) {
        const message = data?.error ?? data?.message ?? `HTTP ${res.status}`
        const httpErr = new Error(message)
        httpErr.status = res.status
        throw httpErr
    }

    if (method === 'GET') saveCopy(path, data)
    return data
}

/** El error fue por falta de conexión (no hubo respuesta del servidor). */
export function isOfflineError(err) {
    return err?.offline === true
}

// ── métodos públicos ────────────────────────────────────────────────────────

export const api = {
    get: (path, opts = {}) => request(path, opts),
    post: (path, body) => request(path, { method: 'POST', body: JSON.stringify(body) }),
    put: (path, body) => request(path, { method: 'PUT', body: JSON.stringify(body) }),
    delete: (path) => request(path, { method: 'DELETE' }),
}

function safe(label, fn) {
    return async (...args) => {
        try {
            return await fn(...args)
        } catch (err) {
            console.warn(`[API] ${label}:`, err.message)
            throw err
        }
    }
}

// ── endpoints por dominio ────────────────────────────────────────────────────

export const usersApi = {
    getById: safe('users.getById', (id) => api.get(`/users/${id}`)),
    getByUsername: safe('users.getByUsername', (username) => api.get(`/users/by-username/${username}`)),
    create: safe('users.create', (user) => api.post('/users', user)),
    update: safe('users.update', (id, user) => api.put(`/users/${id}`, user)),
    switchLanguage: safe('users.switchLanguage', (id, langId) => api.put(`/users/${id}/language`, { languageId: langId })),
}

export const authApi = {
    login: safe('auth.login', (username, password) => api.post('/auth/login', { username, password })),
    google: safe('auth.google', (credential) => api.post('/auth/google', { credential })),
    forgotPassword: safe('auth.forgotPassword', (identifier) => api.post('/auth/password/forgot', { identifier })),
    resetPassword: safe('auth.resetPassword', (token, password) => api.post('/auth/password/reset', { token, password })),
}

export const accountApi = {
    get: safe('account.get', () => api.get('/account')),
    usernameAvailable: safe('account.usernameAvailable', (u) => api.get(`/account/username-available?username=${encodeURIComponent(u)}`)),
    updateProfile: safe('account.updateProfile', (data) => api.put('/account/profile', data)),
    changePassword: safe('account.changePassword', (currentPassword, newPassword) => api.put('/account/password', { currentPassword, newPassword })),
    changeEmail: safe('account.changeEmail', (email, password) => api.post('/account/email', { email, password })),
    cancelEmailChange: safe('account.cancelEmailChange', () => api.delete('/account/email')),
    resendVerification: safe('account.resendVerification', () => api.post('/account/email/resend', {})),
    remove: safe('account.remove', (password) => api.post('/account/delete', { password })),
}

export const emailApi = {
    confirm: safe('email.confirm', (token) => api.post('/auth/email/confirm', { token })),
}

export const languagesApi = {
    getAll: safe('languages.getAll', () => api.get('/languages')),
    getById: safe('languages.getById', (id) => api.get(`/languages/${id}`)),
}

export const learningApi = {
    getLevels: safe('learning.getLevels', (languageId, userId) => api.get(`/learning/levels?languageId=${languageId}&userId=${userId}`)),
    getUnits: safe('learning.getUnits', (levelId, userId) => api.get(`/learning/levels/${levelId}/units?userId=${userId}`)),
    getExercises: safe('learning.getExercises', (unitId) => api.get(`/learning/units/${unitId}/exercises`)),
    getVocabulary: safe('learning.getVocabulary', (unitId) => api.get(`/learning/units/${unitId}/vocabulary`)),
    getQuick: safe('learning.getQuick', (levelId, count = 6) => api.get(`/learning/levels/${levelId}/quick?count=${count}`)),
}

export const progressApi = {
    getByUser: safe('progress.getByUser', (userId) => api.get(`/user-progress?userId=${userId}`)),
    getByUserUnit: safe('progress.getByUserUnit', (userId, unitId) => api.get(`/user-progress/user/${userId}/unit/${unitId}`)),
    complete: safe('progress.complete', (payload) => api.post('/user-progress/complete', payload)),
    completeLevel: safe('progress.completeLevel', (payload) => api.post('/user-progress/complete-level', payload)),
    init: safe('progress.init', (userId, firstUnitId) => api.post('/user-progress/init', { userId, firstUnitId })),
}

export const energyApi = {
    get: safe('energy.get', (userId) => api.get(`/energy/user/${userId}`)),
    consume: safe('energy.consume', (userId, isCorrect) => api.post(`/energy/user/${userId}/consume`, { isCorrect })),
    set: safe('energy.set', (userId, value) => api.put(`/energy/user/${userId}/set`, { value })),
    // Respuestas contestadas sin conexión, en orden (src/offline/outbox.js)
    sync: safe('energy.sync', (userId, clientId, answers) => api.post(`/energy/user/${userId}/sync`, { clientId, answers })),
}

export const statsApi = {
    getByUser: safe('stats.getByUser', (userId) => api.get(`/user-stats?userId=${userId}`)),
    getByUserLang: safe('stats.getByUserLang', (userId, languageId, opts) => api.get(`/user-stats?userId=${userId}&languageId=${languageId}`, opts)),
}

export const achievementsApi = {
    getWithStatus: safe('achievements.getWithStatus', (userId, languageTag) =>
        api.get(`/user-achievements?userId=${userId}${languageTag ? `&languageTag=${languageTag}` : ''}`)),
    getAll: safe('achievements.getAll', () => api.get('/achievements')),
}

export const historyApi = {
    getByUser: safe('history.getByUser', (userId) => api.get(`/lesson-history?userId=${userId}`)),
}

export const writingApi = {
    getByLanguage: safe('writing.getByLanguage', (languageId) => api.get(`/writing-systems?languageId=${languageId}`)),
    getByType: safe('writing.getByType', (languageId, type) => api.get(`/writing-systems?languageId=${languageId}&type=${type}`)),
}
// ── warm-up ─────────────────────────────────────────────────────────────────
// Despierta el backend (Render free) en cuanto carga la app.
// Fire-and-forget: no bloquea la UI ni muestra errores.
export function warmUpBackend() {
    fetch(`${BASE_URL}/health`, { method: 'GET', cache: 'no-store' })
        .catch(() => { /* backend despertando o caído: el monitor se encarga */ })
}
