// src/data/uiPrefs.js
// Preferencias de la interfaz guardadas en este dispositivo (Perfil → Ajustes → Preferencias de aprendizaje).
//   duoButtons: opciones y fichas de los ejercicios con diseño tipo Duolingo (true, por defecto) o plano.
//   Se aplica con la clase "tl-duo" en <html> (estilos en src/style.css, .tl-choice).

import { ref, watch } from 'vue'

const KEY_DUO = 'tl-pref-duo-buttons'

function read(key, fallback) {
    try {
        const v = localStorage.getItem(key)
        return v === null ? fallback : v === '1'
    } catch {
        return fallback
    }
}

export const duoButtons = ref(typeof window === 'undefined' ? true : read(KEY_DUO, true))

function apply(on) {
    if (typeof document !== 'undefined') document.documentElement.classList.toggle('tl-duo', !!on)
}

/** Llamar una vez al iniciar la app (main.js). */
export function setupUiPrefs() {
    apply(duoButtons.value)
    watch(duoButtons, on => {
        apply(on)
        try { localStorage.setItem(KEY_DUO, on ? '1' : '0') } catch { /* sin almacenamiento */ }
    })
}
