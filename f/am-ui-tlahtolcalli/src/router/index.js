import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '../stores/auth'
import { publicRoutes } from './publicRoutes'
import { isWelcomePending } from '../data/welcome.js'
import { dataMissing } from '../offline/status.js'

// Niveles y lecciones bloqueados (o de otro idioma) no se abren escribiendo la URL: vuelven al inicio.
// Si la API falla, se deja pasar y la vista muestra su propio error; el backend valida al completar.
const allowIf = (check) => async (to) => {
    try {
        const { [check]: fn } = await import('../data/learning.js')
        const id = to.params.id ?? to.params.unitId ?? to.params.levelId
        return (await fn(id)) ? true : '/app'
    } catch (e) {
        console.warn('[router] no se pudo validar el acceso:', e)
        return true
    }
}

// ── URLs sin id: el usuario ve /app/nivel/nhn y la app usa /app/nivel/25 ─────
// Internamente las rutas siguen siendo por id (/app/nivel/25). Al terminar de navegar,
// la barra de direcciones se cambia a /app/nivel/<idioma> y el id se guarda en el estado
// del historial (history.state.tl). Al recargar o usar Atrás/Adelante, la ruta con idioma
// lee ese id y vuelve a la ruta interna. Sin id (enlace compartido o escrito a mano)
// abre el nivel / la lección en curso.
const PRETTY = {
    Nivel: { seg: 'nivel', param: 'id', kind: 'level' },
    Leccion: { seg: 'leccion', param: 'unitId', kind: 'unit' },
    NivelRapido: { seg: 'nivel-rapido', param: 'levelId', kind: 'level' },
}

const fromLanguage = (name) => async (to) => {
    const { seg, kind } = PRETTY[name]
    const authStore = useAuthStore()
    if (to.params.lang !== authStore.selectedLanguage) return '/app'
    try {
        const learning = await import('../data/learning.js')
        const saved = window.history.state?.tl
        let id = saved?.kind === kind && saved.seg === seg ? saved.id : null
        if (id == null) id = kind === 'unit' ? await learning.currentUnitId() : await learning.currentLevelId()
        return id == null ? '/app' : { path: `/app/${seg}/${id}`, replace: true }
    } catch (e) {
        console.warn('[router] no se pudo resolver la ruta:', e)
        return '/app'
    }
}

// ── Mapa del sitio ──────────────────────────────────────────────────────────
//   /                     landing (con o sin sesión) · ?auth=login | ?auth=register abre el modal
//   /como-se-usa /novedades /privacidad /terminos   páginas públicas (prerenderizadas)
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
        path: '/restablecer',
        name: 'RestablecerContrasena',
        component: () => import('../views/ResetPasswordView.vue'),
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
    // Rutas que ve el usuario (idioma en lugar del id)
    { path: '/app/nivel/:lang([a-z]+)', component: { render: () => null }, meta: { requiresAuth: true }, beforeEnter: fromLanguage('Nivel') },
    { path: '/app/leccion/:lang([a-z]+)', component: { render: () => null }, meta: { requiresAuth: true }, beforeEnter: fromLanguage('Leccion') },
    { path: '/app/nivel-rapido/:lang([a-z]+)', component: { render: () => null }, meta: { requiresAuth: true }, beforeEnter: fromLanguage('NivelRapido') },
    // Rutas internas (por id)
    {
        path: '/app/nivel/:id(\\d+)',
        name: 'Nivel',
        component: () => import('../views/learn/LevelView.vue'),
        props: true,
        meta: { requiresAuth: true },
        beforeEnter: allowIf('canOpenLevel')
    },
    {
        path: '/app/leccion/:unitId(\\d+)',
        name: 'Leccion',
        component: () => import('../views/learn/LessonView.vue'),
        props: true,
        meta: { hideNav: true, requiresAuth: true },
        beforeEnter: allowIf('canOpenUnit'),
    },
    {
        path: '/app/nivel-rapido/:levelId(\\d+)',
        name: 'NivelRapido',
        component: () => import('../views/learn/QuickLevelView.vue'),
        props: true,
        meta: { hideNav: true, requiresAuth: true },
        beforeEnter: allowIf('canOpenLevel'),
    },
    {
        path: '/app/bienvenida',
        name: 'Bienvenida',
        component: () => import('../views/learn/WelcomeLessonView.vue'),
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
    RestablecerContrasena: 'Nueva contraseña',
    Bienvenida: 'Bienvenida',
    ElegirUsuario: 'Elige tu usuario',
    Perfil: 'Perfil',
}
// Cada navegación empieza sin la pantalla de "Sin conexión": la vuelve a pedir
// la vista nueva si sus datos no están guardados (src/offline). Va antes que los demás guards.
router.beforeEach(() => {
    dataMissing.value = false
})

// Muestra el idioma en la barra de direcciones y guarda el id en el historial
router.afterEach((to, from, failure) => {
    const p = PRETTY[to.name]
    if (failure || !p) return
    const lang = useAuthStore().selectedLanguage
    if (!lang) return
    const pretty = `/app/${p.seg}/${lang}`
    const state = { ...window.history.state, current: pretty, tl: { kind: p.kind, seg: p.seg, id: Number(to.params[p.param]) } }
    window.history.replaceState(state, '', pretty)
})

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

    // 5. Lección de bienvenida pendiente: no se puede saltar
    if (to.meta.requiresAuth && to.name !== 'Bienvenida' && isWelcomePending()) return '/app/bienvenida'

    return true
})

export default router
