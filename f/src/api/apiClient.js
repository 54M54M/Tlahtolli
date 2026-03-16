// src/api/apiClient.js
// Punto central de comunicación con el backend Spring Boot.
// Toda llamada HTTP de la app pasa por aquí.
// src/api/apiClient.js

const BASE_URL = import.meta.env.VITE_API_URL ?? 'http://localhost:7575/api'

// ── utilidad interna ────────────────────────────────────────────────────────

async function request(path, options = {}) {
    const url = `${BASE_URL}${path}`
    const config = {
        headers: { 'Content-Type': 'application/json', ...options.headers },
        ...options,
    }

    const res = await fetch(url, config)

    // Sin contenido
    if (res.status === 204) return null

    // Intentar parsear JSON solo si hay contenido
    const text = await res.text()
    const data = text ? JSON.parse(text) : null

    if (!res.ok) {
        const message = data?.error ?? data?.message ?? `HTTP ${res.status}`
        throw new Error(message)
    }

    return data
}

// ── métodos públicos ────────────────────────────────────────────────────────

export const api = {
    get: (path) => request(path),
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
    init: safe('progress.init', (userId, firstUnitId) => api.post('/user-progress/init', { userId, firstUnitId })),
}

export const energyApi = {
    get: safe('energy.get', (userId) => api.get(`/energy/user/${userId}`)),
    consume: safe('energy.consume', (userId, isCorrect) => api.post(`/energy/user/${userId}/consume`, { isCorrect })),
    set: safe('energy.set', (userId, value) => api.put(`/energy/user/${userId}/set`, { value })),
}

export const statsApi = {
    getByUser: safe('stats.getByUser', (userId) => api.get(`/user-stats?userId=${userId}`)),
    getByUserLang: safe('stats.getByUserLang', (userId, languageId) => api.get(`/user-stats?userId=${userId}&languageId=${languageId}`)),
}

export const achievementsApi = {
    getWithStatus: safe('achievements.getWithStatus', (userId) => api.get(`/user-achievements?userId=${userId}`)),
    getAll: safe('achievements.getAll', () => api.get('/achievements')),
}

export const historyApi = {
    getByUser: safe('history.getByUser', (userId) => api.get(`/lesson-history?userId=${userId}`)),
}

export const writingApi = {
    getByLanguage: safe('writing.getByLanguage', (languageId) => api.get(`/writing-systems?languageId=${languageId}`)),
    getByType: safe('writing.getByType', (languageId, type) => api.get(`/writing-systems?languageId=${languageId}&type=${type}`)),
}