// src/version.js
// Versión de la app: la de package.json al compilar (vite.config.js → define).
// En Netlify se agrega el commit corto (COMMIT_REF), útil para saber qué deploy tiene alguien.
/* global __APP_VERSION__, __APP_COMMIT__ */

export const APP_VERSION = typeof __APP_VERSION__ !== 'undefined' ? __APP_VERSION__ : '0.0.0'
export const APP_COMMIT = typeof __APP_COMMIT__ !== 'undefined' ? __APP_COMMIT__ : ''
export const APP_ENV = import.meta.env.VITE_APP_ENV === 'dev' ? 'dev' : 'prod'

/** "4.5.0", "4.5.0 · a1b2c3d" o "4.5.0 · a1b2c3d · dev" */
export const VERSION_LABEL = [APP_VERSION, APP_COMMIT, APP_ENV === 'dev' ? 'dev' : ''].filter(Boolean).join(' · ')
