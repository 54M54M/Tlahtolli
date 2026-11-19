import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { publicRoutes } from './publicRoutes'

// ── Mapa del sitio ──────────────────────────────────────────────────────────
//   /                     landing (con o sin sesión) · ?auth=login | ?auth=register abre el modal
//   /novedades /privacidad /terminos   páginas públicas (prerenderizadas)
//   /verificar            enlace del correo de verificación (con o sin sesión)
//   /app/...              la app (requiere sesión)
const appRoutes = [
    {
        path: '/verificar',
        name: 'VerificarCorreo',
        component: () => import('../views/VerifyEmailView.vue'),
        meta: { public: true, hideNav: true }
    },
    {
        path: '/app',
        name: 'Inicio',
        component: () => import('../views/HomeView.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: '/app/elegir-usuario',
        name: 'ElegirUsuario',
        component: () => import('../views/ChooseUsernameView.vue'),
        meta: { requiresAuth: true, standalone: true, hideNav: true }
    },
    {
        path: '/app/idioma',
        name: 'LanguageSelection',
        component: () => import('../views/VariantSelection.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: '/app/nivel/:id',
        name: 'Nivel',
        component: () => import('../views/learn/LevelView.vue'),
        props: true,
        meta: { requiresAuth: true }
    },
    {
        path: '/app/leccion/:unitId',
        name: 'Leccion',
        component: () => import('../views/learn/LessonView.vue'),
        props: true,
        meta: { hideNav: true, requiresAuth: true },
    },
    {
        path: '/app/nivel-rapido/:levelId',
        name: 'NivelRapido',
        component: () => import('../views/learn/QuickLevelView.vue'),
        props: true,
        meta: { hideNav: true, requiresAuth: true },
    },
    {
        path: '/app/glosario',
        name: 'Glosario',
        component: () => import('../views/GlossaryView.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: '/app/estadisticas',
        name: 'Estadísticas',
        component: () => import('../views/StatsView.vue'),
        meta: { requiresAuth: true }
    },
    {
        path: '/app/perfil/editar',
        name: 'EditarPerfil',
        component: () => import('../views/EditProfileView.vue'),
        meta: { hideNav: true, requiresAuth: true },
    },
    {
        path: '/app/perfil',
        name: 'Perfil',
        component: () => import('../views/ProfileView.vue'),
        meta: { requiresAuth: true }
    },
]

// Rutas anteriores → nuevas (marcadores, enlaces compartidos, apps instaladas)
const legacyRoutes = [
    { path: '/login', redirect: (to) => ({ path: '/', query: { ...to.query, auth: 'login' } }) },
    { path: '/registro', redirect: (to) => ({ path: '/', query: { ...to.query, auth: 'register' } }) },
    { path: '/select-language', redirect: '/app/idioma' },
    { path: '/elegir-usuario', redirect: '/app/elegir-usuario' },
    { path: '/nivel/:id', redirect: (to) => `/app/nivel/${to.params.id}` },
    { path: '/leccion/:unitId', redirect: (to) => `/app/leccion/${to.params.unitId}` },
    { path: '/nivel-rapido/:levelId', redirect: (to) => `/app/nivel-rapido/${to.params.levelId}` },
    { path: '/glosario', redirect: '/app/glosario' },
    { path: '/estadisticas', redirect: '/app/estadisticas' },
    { path: '/perfil/editar', redirect: '/app/perfil/editar' },
    { path: '/perfil', redirect: '/app/perfil' },
    { path: '/:pathMatch(.*)*', redirect: '/' },
]

const router = createRouter({
    history: createWebHistory(),
    routes: [...publicRoutes, ...appRoutes, ...legacyRoutes],
    // La página se desplaza dentro de #app (html y body no tienen scroll), así que se hace a mano
    scrollBehavior(to, from) {
        if (to.hash) {
            setTimeout(() => document.querySelector(to.hash)?.scrollIntoView({ behavior: 'smooth' }), 0)
        } else if (to.path !== from.path) {
            const scroller = document.getElementById('app')
            if (scroller) scroller.scrollTop = 0
        }
        return false
    },
})

// Título de la pestaña por ruta (lo leen Google y el historial del navegador)
const APP_NAME = 'Tlahtolcalli'
const ROUTE_TITLES = {
    LanguageSelection: 'Elige tu idioma',
    Inicio: 'Inicio',
    Nivel: 'Nivel',
    Leccion: 'Lección',
    NivelRapido: 'Nivel rápido',
    Glosario: 'Glosario',
    'Estadísticas': 'Estadísticas',
    EditarPerfil: 'Editar perfil',
    VerificarCorreo: 'Verificar correo',
    ElegirUsuario: 'Elige tu usuario',
    Perfil: 'Perfil',
}
router.afterEach((to) => {
    if (to.meta.title) {
        document.title = to.query.auth === 'login' ? `Iniciar sesión · ${APP_NAME}`
            : to.query.auth === 'register' ? `Crear cuenta · ${APP_NAME}`
            : to.meta.title
        return
    }
    const title = ROUTE_TITLES[to.name]
    document.title = title ? `${title} · ${APP_NAME}` : `${APP_NAME} · Aprende lenguas originarias de México`
})

const LOGIN = { path: '/', query: { auth: 'login' } }

router.beforeEach((to) => {
    const authStore = useAuthStore()

    // 0. Sesión guardada sin token o con token vencido → cerrarla
    if (authStore.user && !authStore.isAuthenticated) authStore.logout()

    const user = authStore.user
    const home = authStore.selectedLanguage ? '/app' : '/app/idioma'

    // Páginas públicas
    if (to.meta.public) {
        // Con sesión no tiene sentido abrir el login/registro: directo a la app
        if (user && to.query.auth) return user.mustPickUsername ? '/app/elegir-usuario' : home
        return true
    }

    // 1. Sin sesión → landing con el modal de inicio de sesión
    if (to.meta.requiresAuth && !user) return LOGIN

    // 2. Cuenta nueva de Google → primero confirma o cambia su usuario (antes que el idioma)
    if (user?.mustPickUsername) return to.name === 'ElegirUsuario' ? true : '/app/elegir-usuario'
    if (to.name === 'ElegirUsuario') return home

    // 3. Con sesión pero sin idioma → selector
    if (user && !authStore.selectedLanguage && to.name !== 'LanguageSelection') return '/app/idioma'

    // 4. Ya tiene idioma y quiere ir al selector como página → home (el header lo abre como modal)
    if (to.name === 'LanguageSelection' && user && authStore.selectedLanguage) return '/app'

    return true
})

export default router
