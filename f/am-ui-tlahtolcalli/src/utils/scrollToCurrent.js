// Al entrar a Inicio o a un nivel, baja sola hasta la card donde vas (marcada con data-current).
import { nextTick } from 'vue'

const NAV_MOVIL = 96 // barra inferior en el teléfono

/** No se mueve si se regresó con "atrás" (se queda donde estaba) ni si la card ya se ve completa. */
export async function scrollToCurrent(root = document) {
    if (typeof window === 'undefined') return
    if (window.history.state?.forward) return
    await nextTick()
    requestAnimationFrame(() => {
        const el = root.querySelector?.('[data-current]')
        if (!el) return
        const r = el.getBoundingClientRect()
        const bottom = window.innerHeight - (window.innerWidth < 768 ? NAV_MOVIL : 0)
        if (r.top >= 0 && r.bottom <= bottom) return
        const reduce = window.matchMedia?.('(prefers-reduced-motion: reduce)').matches
        el.scrollIntoView({ behavior: reduce ? 'auto' : 'smooth', block: 'center' })
    })
}
