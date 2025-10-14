import { createRouter, createWebHistory } from 'vue-router'
import Inicio from '../views/HomeView.vue'
import { useAuthStore } from '../stores/auth'

const routes = [
    {
        path: '/',
        name: 'Inicio',
        component: Inicio,
        meta: { requiresAuth: true }
    },
    {
        path: '/login',
        name: 'Login',
        component: () => import("../views/LoginView.vue"),
        meta: { requiresGuest: true }
    },
    {
        path: '/select-variant',
        name: 'VariantSelection',
        component: () => import("../views/VariantSelection.vue"),
        meta: { requiresAuth: true, requiresVariant: false }
    },
    {
        path: '/diccionario',
        name: 'Diccionario',
        component: () => import("../views/DictionaryView.vue"),
        meta: { requiresAuth: true }
    },
    {
        path: '/mapa',
        name: 'Mapa',
        component: () => import("../views/MapView.vue"),
        meta: { requiresAuth: true }
    },
    {
        path: '/perfil',
        name: 'Perfil',
        component: () => import("../views/ProfileView.vue"),
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
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

router.beforeEach(async (to, from, next) => {
    const authStore = useAuthStore()

    // Esperar a que el store esté hidratado si usa persistencia
    if (authStore.$hydrate) {
        await authStore.$hydrate()
    }

    // Si la ruta requiere autenticación y no hay usuario
    if (to.meta.requiresAuth && !authStore.user) {
        return next('/login')
    }

    // Si la ruta requiere ser invitado (como login) y ya está autenticado
    if (to.meta.requiresGuest && authStore.user) {
        // Redirigir según si es nuevo usuario o no
        if (authStore.isNewUser) {
            return next('/select-variant')
        } else {
            return next('/')
        }
    }

    // Si está autenticado pero es nuevo usuario y no está en select-variant
    if (authStore.user && authStore.isNewUser && to.name !== 'VariantSelection') {
        return next('/select-variant')
    }

    // Si tiene variante seleccionada y trata de acceder a select-variant
    if (to.name === 'VariantSelection' && authStore.user && !authStore.isNewUser) {
        return next('/')
    }

    next()
})

export default router