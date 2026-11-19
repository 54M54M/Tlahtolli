<template>
    <!-- Marco de las páginas públicas: encabezado, pie, navegación móvil y modal de cuenta -->
    <div class="min-h-screen bg-surface-3 text-gray-100 font-sans select-text overflow-x-hidden pb-16 md:pb-0">
        <header class="sticky top-0 z-50 bg-surface-3/90 backdrop-blur-sm border-b border-line">
            <div class="container mx-auto px-4 py-4 flex justify-between items-center gap-4">
                <router-link to="/" class="flex items-center gap-2 shrink-0">
                    <img src="/android-chrome-192x192.png" alt="" class="w-9 h-9">
                    <span class="text-xl font-bold font-display">Tlahtolcalli</span>
                </router-link>

                <nav class="hidden md:flex items-center gap-8 text-gray-400">
                    <a v-for="s in SECTIONS" :key="s.id" :href="`/#${s.id}`" @click="goSection($event, s.id)"
                        class="nav-item hover:text-gray-100">{{ s.label }}</a>
                    <AccountButtons />
                </nav>

                <div class="md:hidden">
                    <AccountButtons compact />
                </div>
            </div>
        </header>

        <slot />

        <footer class="border-t border-line py-10 px-4">
            <div class="container mx-auto flex flex-col md:flex-row gap-6 justify-between items-start md:items-center">
                <router-link to="/" class="flex items-center gap-2">
                    <img src="/android-chrome-192x192.png" alt="" class="w-8 h-8">
                    <span class="text-lg font-bold font-display">Tlahtolcalli</span>
                </router-link>
                <ul class="flex flex-wrap gap-x-6 gap-y-2 text-gray-400">
                    <li v-for="s in SECTIONS" :key="s.id">
                        <a :href="`/#${s.id}`" @click="goSection($event, s.id)" class="hover:text-gray-100">{{ s.label }}</a>
                    </li>
                    <li><router-link to="/novedades" class="hover:text-gray-100">Novedades</router-link></li>
                    <li><router-link to="/privacidad" class="hover:text-gray-100">Privacidad</router-link></li>
                    <li><router-link to="/terminos" class="hover:text-gray-100">Términos</router-link></li>
                    <li><a href="https://stats.uptimerobot.com/iG8x8aeb43" target="_blank" rel="noopener" class="hover:text-gray-100">Estado del servicio</a></li>
                </ul>
            </div>
            <p class="container mx-auto mt-8 text-sm text-gray-400">© {{ year }} Tlahtolcalli · Contacto:
                <a href="mailto:contacto.tlahtolcalli@gmail.com" class="hover:text-gray-100 break-all">contacto.tlahtolcalli@gmail.com</a></p>
        </footer>

        <!-- Navegación inferior (móvil) -->
        <nav class="md:hidden fixed bottom-0 inset-x-0 z-20 bg-surface-3 border-t border-line">
            <div class="flex justify-between py-2 px-2">
                <a v-for="s in SECTIONS.slice(0, 3)" :key="s.id" :href="`/#${s.id}`" @click="goSection($event, s.id)"
                    class="flex-1 text-center text-gray-400 hover:text-gray-100 text-xs py-2">{{ s.label }}</a>
                <router-link :to="authStore.user ? '/app' : { query: { auth: 'register' } }"
                    class="flex-1 text-center text-turquesa font-semibold text-xs py-2">
                    {{ authStore.user ? 'Continuar' : 'Empezar' }}
                </router-link>
            </div>
        </nav>

        <AuthModal />
    </div>
</template>

<script setup>
import { h } from 'vue'
import { RouterLink, useRoute, useRouter } from 'vue-router'
import { useAuthStore } from '../../stores/auth'
import AuthModal from './AuthModal.vue'
import UserAvatar from '../UserAvatar.vue'

const SECTIONS = [
    { id: 'caracteristicas', label: 'Características' },
    { id: 'metodo', label: 'Método' },
    { id: 'idiomas', label: 'Idiomas' },
    { id: 'colabora', label: 'Colabora' },
]

const authStore = useAuthStore()
const route = useRoute()
const router = useRouter()
const year = new Date().getFullYear()

// En la portada se desplaza a la sección; desde otra página, va a la portada y luego a la sección
function goSection(e, id) {
    e.preventDefault()
    if (route.name === 'Landing') document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' })
    else router.push({ path: '/', hash: `#${id}` })
}

// Botones de cuenta: sin sesión abren el modal; con sesión llevan a la app
const btn = 'bg-turquesa-deep hover:bg-turquesa-deeper text-white font-semibold rounded-lg transition-colors'
const AccountButtons = (props) => {
    const compact = props.compact
    if (authStore.user) {
        return h(RouterLink, { to: '/app', class: `${btn} flex items-center gap-2 ${compact ? 'py-1.5 pl-1.5 pr-3 text-sm' : 'py-2 pl-2 pr-4'}` },
            () => [h(UserAvatar, { name: authStore.user.username, size: compact ? 28 : 32 }),
                compact ? 'Continuar' : 'Continuar aprendiendo'])
    }
    return h('div', { class: `flex items-center ${compact ? 'gap-3' : 'gap-6'}` }, [
        h(RouterLink, { to: { query: { auth: 'login' } }, class: `text-gray-100 hover:text-turquesa font-semibold ${compact ? 'text-sm' : ''}` },
            () => (compact ? 'Entrar' : 'Iniciar sesión')),
        h(RouterLink, { to: { query: { auth: 'register' } }, class: `${btn} ${compact ? 'py-2 px-3 text-sm' : 'py-2 px-4'}` },
            () => (compact ? 'Empezar' : 'Empezar gratis')),
    ])
}
AccountButtons.props = { compact: Boolean }
</script>

<style scoped>
.nav-item { position: relative; }
.nav-item::after {
    content: ''; position: absolute; bottom: -6px; left: 0; width: 0; height: 2px;
    background: rgb(var(--turquesa)); transition: width .3s;
}
.nav-item:hover::after { width: 100%; }
@media (prefers-reduced-motion: reduce) { .nav-item::after { transition: none; } }
</style>
