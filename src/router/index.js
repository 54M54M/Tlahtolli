import { createRouter, createWebHistory } from 'vue-router'
import Inicio from '../views/HomeView.vue'

const routes = [
    {
        path: '/',
        name: 'Inicio',
        component: Inicio
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
});

export default router;