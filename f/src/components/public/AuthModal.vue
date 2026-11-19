<template>
    <!-- Iniciar sesión / Registrarse sobre las páginas públicas: ?auth=login | ?auth=register.
         Fondo opaco (el de la app) por encima de todo; ✕, Esc o "atrás" lo cierran. -->
    <Teleport to="body">
        <!-- Cortina: sube al abrir y baja al cerrar -->
        <Transition name="cortina" appear>
        <div v-if="open" ref="root" tabindex="-1" role="dialog" aria-modal="true"
            :aria-label="tab === 'register' ? 'Crear cuenta' : 'Iniciar sesión'"
            class="fixed inset-0 z-[100] bg-surface-0 overflow-y-auto outline-none flex flex-col" @keydown.esc="close">

            <!-- Móvil: barra fija arriba. Escritorio: logo y ✕ flotan en las esquinas y el formulario usa toda la altura,
                 así el login cabe sin scroll (el registro, más alto, sí lo tiene) -->
            <div class="sticky top-0 md:absolute md:inset-x-0 z-10 shrink-0 flex items-center justify-between px-4 py-3 bg-surface-0 md:bg-transparent">
                <router-link to="/" @click.prevent="close" class="flex items-center gap-2 text-gray-100">
                    <img src="/android-chrome-192x192.png" alt="" class="w-8 h-8">
                    <span class="text-lg font-bold font-display">Tlahtolcalli</span>
                </router-link>
                <button @click="close" aria-label="Cerrar"
                    class="w-11 h-11 rounded-full border border-line bg-surface-3 text-gray-100 text-xl leading-none hover:border-turquesa transition-colors">
                    ✕
                </button>
            </div>

            <LoginView embedded :tab="tab" @tab-change="setTab" class="flex-1" />
        </div>
        </Transition>
    </Teleport>
</template>

<script setup>
import { computed, watch, nextTick, ref, onBeforeUnmount, defineAsyncComponent } from 'vue'
import { useRoute, useRouter } from 'vue-router'

// Se descarga solo cuando se abre el modal (la portada carga más ligera)
const LoginView = defineAsyncComponent(() => import('../../views/LoginView.vue'))

const route = useRoute()
const router = useRouter()
const root = ref(null)

const tab = computed(() => (route.query.auth === 'register' ? 'register' : 'login'))
const open = computed(() => route.query.auth === 'login' || route.query.auth === 'register')

function withoutAuth() {
    const { auth, ...query } = route.query
    return { path: route.path, query, hash: route.hash }
}

// Cambiar de pestaña cambia la URL sin agregar otra entrada al historial
const setTab = (t) => router.replace({ ...withoutAuth(), query: { ...withoutAuth().query, auth: t } })

// Si se abrió desde la página (push), "atrás" la cierra y deja el historial limpio;
// si se llegó directo por la URL, se quita el parámetro.
function close() {
    const back = String(window.history.state?.back || '')
    // Solo si atrás está esta misma página sin el modal (si fuera /app/… el guard volvería a abrir el login)
    if (back.split(/[?#]/)[0] === route.path && !back.includes('auth=')) router.back()
    else router.replace(withoutAuth())
}

// #app es el que tiene el scroll: se congela mientras el modal está abierto
function lockScroll(locked) {
    if (typeof document === 'undefined') return
    const scroller = document.getElementById('app')
    if (scroller) scroller.style.overflow = locked ? 'hidden' : ''
}

watch(open, async (v) => {
    lockScroll(v)
    if (v) { await nextTick(); root.value?.focus() }
}, { immediate: true, flush: 'post' })

onBeforeUnmount(() => lockScroll(false))
</script>

<style scoped>
.cortina-enter-active,
.cortina-leave-active { transition: transform .45s cubic-bezier(.22, .8, .2, 1); }
.cortina-leave-active { transition-timing-function: cubic-bezier(.6, 0, .8, .3); transition-duration: .35s; }
.cortina-enter-from,
.cortina-leave-to { transform: translateY(100%); }

@media (prefers-reduced-motion: reduce) {
    .cortina-enter-active, .cortina-leave-active { transition: opacity .2s; }
    .cortina-enter-from, .cortina-leave-to { transform: none; opacity: 0; }
}
</style>
