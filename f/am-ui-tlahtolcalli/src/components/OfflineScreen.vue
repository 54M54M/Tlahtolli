<template>
  <!-- Sin conexión (estado en src/offline/status.js, detección en src/offline/sync.js):
       · Menús principales (Inicio, Glosario, Estadísticas, Perfil) sin datos guardados: la pantalla tapa solo el
         contenido; el menú (abajo en móvil, a los lados en escritorio) sigue a la mano para ir a otra sección.
       · Las demás vistas sin datos guardados (nivel, lección…): pantalla completa con Reintentar / Volver.
       · Si la vista ya estaba cargada: solo el aviso pequeño de arriba; se puede seguir (lecciones incluidas).
       · Páginas públicas: barra arriba.
       Todo se quita solo cuando vuelve la conexión. -->
  <Transition name="off">
    <div v-if="showMenuScreen" role="alertdialog" aria-labelledby="off-title"
         class="fixed inset-0 md:left-60 lg:right-96 z-[25] bg-surface-0/95 backdrop-blur-sm flex items-center justify-center px-6 pb-16 md:pb-0">
      <div class="max-w-sm w-full text-center space-y-4">
        <img :src="image" alt="" class="mx-auto h-44 object-contain">
        <h2 id="off-title" class="text-2xl font-bold font-display text-white">
          Esta pantalla no esta disponible en este momento
        </h2>
        <p class="text-gray-400">
          Parece que estas offline. ¡Revisa tu conexión!
        </p>
        <p v-if="pendingCount > 0" class="text-sm text-amber-200">
          Tranquilo, tu avance está guardado, se enviará al recuperar la conexión.
        </p>
      </div>
    </div>
    <div v-else-if="showFullScreen" role="alertdialog" aria-labelledby="off-title"
         class="fixed inset-0 z-[150] bg-surface-0/95 backdrop-blur-sm flex items-center justify-center px-6">
      <div class="max-w-sm w-full text-center space-y-4">
        <img :src="image" alt="" class="mx-auto h-44 object-contain">
        <h2 id="off-title" class="text-2xl font-bold font-display text-white">
          Esta pantalla no esta disponible en este momento
        </h2>
        <p class="text-gray-400">
          Parece que estas offline. ¡Revisa tu conexión!
        </p>
        <p v-if="pendingCount > 0" class="text-sm text-amber-200">
          Tranquilo, tu avance está guardado, se enviará al recuperar la conexión.
        </p>
        <button @click="retry" :disabled="checking"
                class="w-full bg-turquesa-deep hover:bg-turquesa-deeper disabled:opacity-60 text-white font-bold py-3 rounded-lg">
          {{ checking ? 'Comprobando…' : 'Reintentar' }}
        </button>
        <button v-if="canGoBack" @click="goBack"
                class="w-full text-gray-300 hover:text-white font-semibold py-2">
          Volver
        </button>
      </div>
    </div>
  </Transition>
  <Transition name="off">
    <div v-if="offline && isAppRoute && !showFullScreen" role="status"
         class="fixed top-1 inset-x-0 z-[150] flex justify-center pointer-events-none">
            <span class="bg-amber-500 text-black text-xs font-semibold rounded-full px-3 py-1 shadow-lg">
                {{ isLessonRoute ? 'SIN CONEXIÓN' : 'SIN CONEXIÓN' }}
            </span>
    </div>
    <div v-else-if="offline && !isAppRoute" role="status"
         class="fixed top-0 inset-x-0 z-[150] bg-amber-500 text-black text-sm font-semibold text-center py-2 px-4">
      Sin conexión: algunas partes no van a cargar.
    </div>
  </Transition>
</template>

<script setup>
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { toch, TOCH_SIN_CONEXION } from '../data/toch.js'
import { offline, dataMissing, pendingCount } from '../offline/status.js'
import { retryConnection } from '../offline/sync.js'

const LESSON_ROUTES = ['Leccion', 'NivelRapido', 'Bienvenida']
// Secciones del menú: la pantalla de "Sin conexión" deja el menú visible
const MENU_ROUTES = ['Inicio', 'Glosario', 'Estadísticas', 'Perfil']

const route = useRoute()
const router = useRouter()
const isAppRoute = computed(() => !route.meta.public)
const isLessonRoute = computed(() => LESSON_ROUTES.includes(route.name))
const isMenuRoute = computed(() => MENU_ROUTES.includes(route.name))
const showMenuScreen = computed(() => dataMissing.value && isAppRoute.value && isMenuRoute.value)
const showFullScreen = computed(() => dataMissing.value && isAppRoute.value && !isMenuRoute.value)
const canGoBack = computed(() => typeof window !== 'undefined' && window.history.length > 1 && route.name !== 'Inicio')
const image = toch(TOCH_SIN_CONEXION)
const checking = ref(false)

const retry = async () => {
  checking.value = true
  try {
    await retryConnection()
  } finally {
    checking.value = false
  }
}

const goBack = () => router.back()
</script>

<style scoped>
.off-enter-active, .off-leave-active { transition: opacity .2s; }
.off-enter-from, .off-leave-to { opacity: 0; }
</style>