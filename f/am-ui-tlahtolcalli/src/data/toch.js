// src/data/toch.js
// Imágenes de Toch. Se toman solas de src/assets/exercises/toch/: para agregar una nueva,
// solo sube el archivo (.webp o .png) a esa carpeta. El nombre del archivo, sin extensión, es su clave.
const files = import.meta.glob('../assets/exercises/toch/*.{webp,png}', { eager: true, import: 'default' })

const BY_NAME = Object.fromEntries(
    Object.entries(files).map(([path, url]) => [path.split('/').pop().replace(/\.\w+$/, ''), url])
)

// Imágenes con un uso fijo (por nombre de archivo)
export const TOCH_PREMIO = '9'       // lección perfecta y rápida; no entra al azar
export const TOCH_BIENVENIDA = '5'   // inicio de la lección de bienvenida
export const TOCH_FINAL = '8'        // final de la lección de bienvenida
export const TOCH_SIN_CONEXION = '10' // pantalla "Sin conexión"; no entra al azar

// Estas solo salen en su lugar, nunca al azar
const NO_RANDOM = [TOCH_PREMIO, TOCH_SIN_CONEXION]

/** Una imagen por nombre; si no existe, cualquiera (el build nunca se rompe por un archivo renombrado). */
export function toch(name) {
    return BY_NAME[name] ?? Object.values(BY_NAME)[0] ?? ''
}

/** Una al azar, sin las de uso exclusivo (premio y sin conexión). */
export function tochRandom() {
    const pool = Object.entries(BY_NAME).filter(([name]) => !NO_RANDOM.includes(name)).map(([, url]) => url)
    return pool.length ? pool[Math.floor(Math.random() * pool.length)] : toch(TOCH_PREMIO)
}
