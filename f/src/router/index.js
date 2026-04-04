import { createRouter, createWebHistory } from 'vue-router'
import Inicio from '../views/HomeView.vue'
import { useAuthStore } from '../stores/auth'

const routes = [
    {
        path: '/login',
        name: 'Login',
        component: () => import("../views/LoginView.vue"),
        meta: { requiresGuest: true }
    },
    {
        path: '/select-language',
        name: 'LanguageSelection',
        component: () => import("../views/VariantSelection.vue"),
        meta: { requiresAuth: true }
    },
    {
        path: '/',
        name: 'Inicio',
        component: Inicio,
        meta: { requiresAuth: true }
    },
    {
        path: '/nivel/:id',
        name: 'Nivel',
        component: () => import("../views/learn/LevelView.vue"),
        props: true,
        meta: { requiresAuth: true }
    },
    {
        path: '/leccion/:unitId',
        name: 'Leccion',
        component: () => import("../views/learn/LessonView.vue"),
        props: true,
        meta: { hideNav: true, requiresAuth: true },
    },
    {
        path: '/nivel-rapido/:levelId',
        name: 'NivelRapido',
        component: () => import("../views/learn/QuickLevelView.vue"),
        props: true,
        meta: { hideNav: true, requiresAuth: true },
    },
    {
        path: '/glosario',
        name: 'Glosario',
        component: () => import("../views/GlossaryView.vue"),
        meta: { requiresAuth: true }
    },
    {
        path: '/estadisticas',
        name: 'Estadísticas',
        component: () => import("../views/StatsView.vue"),
        meta: { requiresAuth: true }
    },
    {
        path: '/perfil',
        name: 'Perfil',
        component: () => import("../views/ProfileView.vue"),
        meta: { requiresAuth: true }
    },
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

router.beforeEach(async (to, from, next) => {
    const authStore = useAuthStore()

    // 1. Sin usuario → solo puede ir a login
    if (to.meta.requiresAuth && !authStore.user) {
        return next('/login')
    }

    // 2. Ya autenticado intentando ir a login → redirigir según estado
    if (to.name === 'Login' && authStore.user) {
        return authStore.selectedLanguage ? next('/') : next('/select-language')
    }

    // 3. Autenticado pero sin idioma elegido → forzar selección
    //    Usamos selectedLanguage directamente, NO isNewUser (puede estar desincronizado)
    if (authStore.user && !authStore.selectedLanguage && to.name !== 'LanguageSelection') {
        return next('/select-language')
    }

    // 4. Ya tiene idioma y quiere ir a select-language → home
    //    Permite acceder si viene del header (el header lo maneja como modal, no como ruta)
    if (to.name === 'LanguageSelection' && authStore.user && authStore.selectedLanguage) {
        return next('/')
    }

    next()
})

export default router