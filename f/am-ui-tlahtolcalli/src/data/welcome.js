// src/data/welcome.js
// Lección de bienvenida: 5 ejercicios de opción múltiple de la primera unidad, justo después
// de elegir un idioma y antes de la primera lección. No gasta energía ni guarda progreso.
// Se muestra una sola vez por usuario e idioma (se recuerda en este navegador) y no se puede saltar:
// mientras está pendiente, el router regresa a /app/bienvenida.

import { useAuthStore } from '../stores/auth.js'
import { completeChoices, vocabList } from './lessonPlan.js'

const MAX_EXERCISES = 5

function key(kind = 'hecha') {
    const auth = useAuthStore()
    return `tl-bienvenida-${kind}:${auth.user?.id ?? 'x'}:${auth.selectedLanguage ?? 'x'}`
}

export function markWelcomeDone() {
    try {
        localStorage.setItem(key(), '1')
        localStorage.removeItem(key('pendiente'))
    } catch { /* almacenamiento no disponible */ }
}

/** Se marca al mandar al usuario a la bienvenida; el router no lo deja salir hasta terminarla. */
export function markWelcomePending() {
    try { localStorage.setItem(key('pendiente'), '1') } catch { /* almacenamiento no disponible */ }
}

export function isWelcomePending() {
    try { return localStorage.getItem(key('pendiente')) === '1' && localStorage.getItem(key()) !== '1' } catch { return false }
}

function welcomeDone() {
    try { return localStorage.getItem(key()) === '1' } catch { return false }
}

// learning.js se carga solo cuando hace falta (el router importa este archivo)
const learning = () => import('./learning.js')

async function firstLevel() {
    const { getLevels } = await learning()
    const levels = await getLevels()
    return [...levels].sort((a, b) => (a.levelNum ?? a.id) - (b.levelNum ?? b.id))[0] ?? null
}

/** Solo si nunca la vio y todavía no terminó ninguna unidad del idioma. */
export async function shouldShowWelcome() {
    if (welcomeDone()) return false
    try {
        const level = await firstLevel()
        const show = !!level && !level.locked && (level.completedUnits ?? 0) === 0
        if (show) markWelcomePending()
        return show
    } catch {
        return false
    }
}

/** Ejercicios de la bienvenida (opción múltiple, en orden aleatorio, máximo 5). */
export async function loadWelcome() {
    const level = await firstLevel()
    if (!level) return { level: null, exercises: [], vocabulary: [] }
    const { getUnits, getExercises, getVocabulary } = await learning()
    const units = [...await getUnits(level.id)].sort((a, b) => (a.unitNum ?? a.id) - (b.unitNum ?? b.id))
    const unit = units[0]
    if (!unit) return { level, exercises: [], vocabulary: [] }

    const [exercises, vocabulary] = await Promise.all([getExercises(unit.id), getVocabulary(unit.id)])
    const shuffle = (arr) => {
        const a = [...arr]
        for (let i = a.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [a[i], a[j]] = [a[j], a[i]]
        }
        return a
    }
    const mc = (exercises || [])
        .filter(e => e.type === 'multiple-choice' && Array.isArray(e.options) && e.correctAnswer >= 0)
        .map(e => {
            // 4 opciones y signos de pregunta uniformes, igual que en las lecciones
            const done = completeChoices(e, vocabList(vocabulary))
            const correct = done.options[done.correctAnswer]
            const options = shuffle(done.options)
            return { ...done, options, correctAnswer: options.indexOf(correct) }
        })
    return { level, exercises: shuffle(mc).slice(0, MAX_EXERCISES), vocabulary: vocabulary || [] }
}
