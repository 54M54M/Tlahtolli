// Al entrar a Inicio o a un nivel, baja sola hasta la card donde vas (marcada con data-current).
//
// Solo mueve el contenedor que de verdad hace scroll (#app; html y body tienen overflow: hidden).
// scrollIntoView movía también html/body, que no se pueden regresar con el dedo: el encabezado
// (energía e idioma) quedaba oculto arriba sin poder subir.
import { nextTick } from 'vue'

const NAV_MOVIL = 96 // barra inferior en el teléfono

function scrollerOf(el) {
    for (let p = el.parentElement; p && p !== document.body; p = p.parentElement) {
        const oy = getComputedStyle(p).overflowY
        if ((oy === 'auto' || oy === 'scroll') && p.scrollHeight > p.clientHeight) return p
    }
    return document.getElementById('app') || document.scrollingElement
}

/** No se mueve si se regresó con "atrás" (se queda donde estaba) ni si la card ya se ve completa. */
export async function scrollToCurrent(root = document) {
    if (typeof window === 'undefined') return
    if (window.history.state?.forward) return
    await nextTick()
    requestAnimationFrame(() => {
        const el = root.querySelector?.('[data-current]')
        if (!el) return
        const r = el.getBoundingClientRect()
        const nav = window.innerWidth < 768 ? NAV_MOVIL : 0
        if (r.top >= 0 && r.bottom <= window.innerHeight - nav) return

        const scroller = scrollerOf(el)
        if (!scroller) return
        const box = scroller.getBoundingClientRect()
        const visible = Math.min(scroller.clientHeight, window.innerHeight - nav)
        const top = scroller.scrollTop + (r.top - box.top) - Math.max(0, (visible - r.height) / 2)
        const reduce = window.matchMedia?.('(prefers-reduced-motion: reduce)').matches
        scroller.scrollTo({ top: Math.max(0, top), behavior: reduce ? 'auto' : 'smooth' })
    })
}
