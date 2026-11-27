// Datos al día entre dispositivos: al volver a la app (pestaña o PWA) se vuelven a pedir
// el usuario (nivel, XP, racha), las estadísticas y los logros. Como mucho una vez por minuto.
import { useAuthStore } from '../stores/auth.js'
import { useCacheStore } from '../stores/cache.js'

const MIN_GAP = 60 * 1000
let last = Date.now()

export const REFRESH_EVENT = 'tl:refresh'

export async function refreshAccountData({ force = false } = {}) {
    if (!force && Date.now() - last < MIN_GAP) return
    const auth = useAuthStore()
    if (!auth.user?.id || !auth.token) return
    last = Date.now()
    const cache = useCacheStore()
    cache.invalidatePrefix('stats:')
    cache.invalidatePrefix('achievements:')
    await auth.refreshUser()
    window.dispatchEvent(new CustomEvent(REFRESH_EVENT))
}

/** Llamar una vez al arrancar (App.vue). */
export function setupRefreshOnReturn() {
    if (typeof window === 'undefined') return
    const onReturn = () => { if (document.visibilityState === 'visible' && navigator.onLine !== false) refreshAccountData() }
    document.addEventListener('visibilitychange', onReturn)
    window.addEventListener('focus', onReturn)
}

/** Para componentes: vuelve a cargar sus datos cuando se refresca la cuenta. Devuelve la función para quitarlo. */
export function onAccountRefresh(fn) {
    if (typeof window === 'undefined') return () => {}
    window.addEventListener(REFRESH_EVENT, fn)
    return () => window.removeEventListener(REFRESH_EVENT, fn)
}
