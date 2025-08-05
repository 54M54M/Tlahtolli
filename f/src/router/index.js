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
    },
    {
        path: '/select-variant',
        name: 'VariantSelection',
        component: () => import("../views/VariantSelection.vue"),
        meta: { requiresAuth: true }
    },
    {
        path: '/diccionario',
        name: 'Diccionario',
        component: () => import("../views/DictionaryView.vue"),
    },
    {
        path: '/mapa',
        name: 'Mapa',
        component: () => import("../views/MapView.vue"),
    },
    {
        path: '/perfil',
        name: 'Perfil',
        component: () => import("../views/ProfileView.vue"),
    },
    {
        path: '/nivel/:id',
        name: 'Nivel',
        component: () => import("../views/learn/LevelView.vue"),
        props: true
    },
    {
        path: '/leccion/:unitId',
        name: 'Leccion',
        component: () => import("../views/learn/LessonView.vue"),
        props: true,
        meta: { hideNav: true },
    },
]

const router = createRouter({
    history: createWebHistory(),
    routes
})

router.beforeEach(async (to, from, next) => {
    const authStore = useAuthStore()

    // Esperar a que el store esté hidratado si usa persistencia
    await authStore.$hydrate()

    if (to.meta.requiresAuth && !authStore.user) {
        return next('/login')
    }

    if (to.meta.requiresVariant && (!authStore.selectedVariant || authStore.isNewUser)) {
        return next('/select-variant')
    }

    next()
})

export default router