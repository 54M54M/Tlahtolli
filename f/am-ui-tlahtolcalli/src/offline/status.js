// src/offline/status.js
// Estado compartido de la conexión para la interfaz.

import { ref } from 'vue'

/** true mientras no hay conexión (el navegador lo dice o la API no responde). */
export const offline = ref(typeof navigator !== 'undefined' && navigator.onLine === false)

/** La vista actual necesitaba datos que no estaban guardados: se muestra la pantalla de "Sin conexión". */
export const dataMissing = ref(false)

/** Cambia para volver a montar la vista actual (al regresar la conexión, si le faltaban datos). */
export const viewEpoch = ref(0)

/** Pendientes por enviar (lecciones y energía hechas sin conexión). */
export const pendingCount = ref(0)
