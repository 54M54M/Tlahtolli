// src/data/uiPrefs.js
// Preferencias de la interfaz guardadas en este dispositivo (Perfil → Ajustes → Preferencias de aprendizaje).
//   duoButtons: opciones, fichas y botones de acción con relieve tipo Duolingo (true, por defecto) o planos.
//   Se aplica con la clase "tl-duo" en <html> (estilos en src/style.css: .tl-choice y botones de acción).

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

/**
 * Teclado del teléfono: deja en --tl-kb (en <html>) cuánto tapa la pantalla, para subir la barra de
 * Verificar (.tl-kb en src/style.css). En Chrome Android con interactive-widget=resizes-content (index.html)
 * la pantalla ya se encoge y aquí da 0; sirve para iOS y Chrome viejos.
 */
export function setupKeyboardInset() {
    if (typeof window === 'undefined' || !window.visualViewport) return
    const vv = window.visualViewport
    const root = document.documentElement
    const update = () => {
        const covered = Math.round(window.innerHeight - vv.height - vv.offsetTop)
        root.style.setProperty('--tl-kb', covered > 80 ? `${covered}px` : '0px')
    }
    vv.addEventListener('resize', update)
    vv.addEventListener('scroll', update)
    update()
}
