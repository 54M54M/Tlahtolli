<template>
    <!-- Sin conexión (estado en src/offline/status.js, detección en src/offline/sync.js):
         · Pantalla completa solo si la vista que abriste no tiene datos guardados (nunca se había cargado).
         · Dentro de la app, si la vista ya estaba cargada: un aviso pequeño arriba; puedes seguir (lecciones incluidas).
         · En las páginas públicas: barra arriba.
         Todo se quita solo cuando vuelve la conexión. -->
    <Transition name="off">
        <div v-if="dataMissing && isAppRoute" role="alertdialog" aria-labelledby="off-title"
            class="fixed inset-0 z-[150] bg-surface-0/95 backdrop-blur-sm flex items-center justify-center px-6">
            <div class="max-w-sm w-full text-center space-y-4">
                <img :src="image" alt="" class="mx-auto h-44 object-contain">
                <h2 id="off-title" class="text-2xl font-bold font-display text-white">Sin conexión</h2>
                <p class="text-gray-400">
                    Esta sección todavía no se había cargado y necesita internet.
                    Revisa tu conexión; esta pantalla se quita sola cuando vuelva.
                </p>
                <p v-if="pendingCount > 0" class="text-sm text-amber-200">
                    Tu avance está guardado en este dispositivo y se enviará al reconectar.
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
        <div v-else-if="offline && isAppRoute" role="status"
            class="fixed top-1 inset-x-0 z-[150] flex justify-center pointer-events-none">
            <span class="bg-amber-500 text-black text-xs font-semibold rounded-full px-3 py-1 shadow-lg">
                {{ isLessonRoute ? 'Sin conexión · tu avance se guarda al reconectar' : 'Sin conexión · mostrando lo último que cargaste' }}
            </span>
        </div>
        <div v-else-if="offline" role="status"
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

const route = useRoute()
const router = useRouter()
const isAppRoute = computed(() => !route.meta.public)
const isLessonRoute = computed(() => LESSON_ROUTES.includes(route.name))
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
