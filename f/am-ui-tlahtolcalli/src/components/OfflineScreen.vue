<template>
    <!-- Sin conexión. En la app: pantalla completa (las lecciones y el avance necesitan el servidor).
         En las páginas públicas: solo un aviso arriba. Desaparece sola al volver la conexión. -->
    <Transition name="off">
        <div v-if="offline && isAppRoute" role="alertdialog" aria-labelledby="off-title"
            class="fixed inset-0 z-[150] bg-surface-0/95 backdrop-blur-sm flex items-center justify-center px-6">
            <div class="max-w-sm w-full text-center space-y-4">
                <img :src="image" alt="" class="mx-auto h-44 object-contain">
                <h2 id="off-title" class="text-2xl font-bold font-display text-white">Sin conexión</h2>
                <p class="text-gray-400">
                    Tlahtolcalli necesita internet para cargar tus lecciones y guardar tu avance.
                    Revisa tu conexión; esta pantalla se quita sola cuando vuelva.
                </p>
                <button @click="retry"
                    class="w-full bg-turquesa-deep hover:bg-turquesa-deeper text-white font-bold py-3 rounded-lg">
                    Reintentar
                </button>
            </div>
        </div>
        <div v-else-if="offline" role="status"
            class="fixed top-0 inset-x-0 z-[150] bg-amber-500 text-black text-sm font-semibold text-center py-2 px-4">
            Sin conexión: algunas partes no van a cargar.
        </div>
    </Transition>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { toch, TOCH_SIN_CONEXION } from '../data/toch.js'

// Sin conexión = el navegador dice que no hay red, o una petición a la API no obtuvo respuesta
const route = useRoute()
const browserOffline = ref(typeof navigator !== 'undefined' && navigator.onLine === false)
const apiUnreachable = ref(false)
const offline = computed(() => browserOffline.value || apiUnreachable.value)
const isAppRoute = computed(() => !route.meta.public)
const image = toch(TOCH_SIN_CONEXION)

const onBrowser = () => {
    browserOffline.value = navigator.onLine === false
    if (!browserOffline.value) apiUnreachable.value = false
}
const onApi = (e) => { apiUnreachable.value = e.detail === false }

const retry = async () => {
    try {
        await fetch(`${import.meta.env.VITE_API_URL}/health`, { cache: 'no-store' })
        browserOffline.value = false
        apiUnreachable.value = false
        window.location.reload()
    } catch {
        browserOffline.value = navigator.onLine === false
    }
}

onMounted(() => {
    window.addEventListener('online', onBrowser)
    window.addEventListener('offline', onBrowser)
    window.addEventListener('tl:connection', onApi)
})
onBeforeUnmount(() => {
    window.removeEventListener('online', onBrowser)
    window.removeEventListener('offline', onBrowser)
    window.removeEventListener('tl:connection', onApi)
})
</script>

<style scoped>
.off-enter-active, .off-leave-active { transition: opacity .2s; }
.off-enter-from, .off-leave-to { opacity: 0; }
</style>
