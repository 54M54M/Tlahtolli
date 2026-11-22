<template>
    <!-- Versión nueva disponible (service worker). No interrumpe lecciones: espera a que termines. -->
    <Transition name="upd">
        <div v-if="visible" role="status"
            class="fixed z-[90] left-4 right-4 bottom-24 md:bottom-6 md:left-auto md:right-6 md:w-96
                   bg-surface-2 border border-turquesa/50 rounded-xl shadow-2xl p-4 flex items-center gap-3">
            <div class="flex-1 text-sm">
                <p class="font-bold text-white">Hay una versión nueva</p>
                <p class="text-gray-400">Actualiza para tener las últimas mejoras.</p>
            </div>
            <button @click="later" class="text-sm font-semibold text-gray-400 hover:text-white px-2 py-2">Después</button>
            <button @click="update" :disabled="updating"
                class="text-sm font-bold bg-turquesa-deep hover:bg-turquesa-deeper disabled:opacity-60 text-white px-4 py-2 rounded-lg">
                {{ updating ? 'Actualizando…' : 'Actualizar' }}
            </button>
        </div>
    </Transition>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { applyUpdate, updateReady } from '../pwa.js'

// Rutas donde no se interrumpe (se muestra al salir)
const QUIET = ['Leccion', 'NivelRapido', 'Bienvenida']

const route = useRoute()
const ready = ref(updateReady())
const dismissed = ref(false)
const updating = ref(false)

const visible = computed(() => ready.value && !dismissed.value && !QUIET.includes(route.name))

const onReady = () => { ready.value = true; dismissed.value = false }
const later = () => { dismissed.value = true }
const update = () => { updating.value = true; applyUpdate() }

onMounted(() => window.addEventListener('tl:update-ready', onReady))
onBeforeUnmount(() => window.removeEventListener('tl:update-ready', onReady))
</script>

<style scoped>
.upd-enter-active, .upd-leave-active { transition: opacity .25s, transform .25s; }
.upd-enter-from, .upd-leave-to { opacity: 0; transform: translateY(12px); }
</style>
