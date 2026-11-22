const files = import.meta.glob('../assets/exercises/toch/*.{webp,png}',
    { eager: true, import: 'default' })

const BY_NAME = Object.fromEntries(
    Object.entries(files)
        .map(([path, url]) => [
            path.split('/').pop().replace(/\.\w+$/, ''), url])
)

// Imágenes con un uso fijo (por nombre de archivo)
export const TOCH_PREMIO = '9'       // lección perfecta y rápida; no entra al azar
export const TOCH_BIENVENIDA = '5'   // inicio de la lección de bienvenida
export const TOCH_FINAL = '8'        // final de la lección de bienvenida

/** Una imagen por nombre; si no existe, cualquiera (el build nunca se rompe por un archivo renombrado). */
export function toch(name) {
    return BY_NAME[name] ?? Object.values(BY_NAME)[0] ?? ''
}

/** Una al azar, sin la de premio. */
export function tochRandom() {
    const pool = Object.entries(BY_NAME)
        .filter(([name]) => name !== TOCH_PREMIO).map(([, url]) => url)
    return pool.length ? pool[Math.floor(Math.random() * pool.length)] : toch(TOCH_PREMIO)
}
