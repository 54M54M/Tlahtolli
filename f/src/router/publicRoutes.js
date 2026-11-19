// Páginas públicas (con o sin sesión). Se comparten con el prerender (src/entry-prerender.js),
// que genera su HTML al compilar para que Google las lea sin ejecutar JavaScript.
export const SITE_URL = 'https://tlahtolcalli.netlify.app'

export const publicRoutes = [
    {
        path: '/',
        name: 'Landing',
        component: () => import('../views/public/LandingView.vue'),
        meta: {
            public: true,
            title: 'Tlahtolcalli · Aprende lenguas originarias de México',
            description: 'Tlahtolcalli es una app web gratuita para aprender lenguas originarias de México, como el náhuatl y el tének, con lecciones cortas, vocabulario y guía de pronunciación.',
        },
    },
    {
        path: '/novedades',
        name: 'Novedades',
        component: () => import('../views/public/ChangelogView.vue'),
        meta: {
            public: true,
            title: 'Novedades · Tlahtolcalli',
            description: 'Lo nuevo en Tlahtolcalli: cursos, funciones y mejoras de la app para aprender lenguas originarias de México.',
        },
    },
    {
        path: '/privacidad',
        name: 'Privacidad',
        component: () => import('../views/public/PrivacyView.vue'),
        meta: {
            public: true,
            title: 'Aviso de privacidad · Tlahtolcalli',
            description: 'Qué datos personales guarda Tlahtolcalli, para qué los usa, con quién los comparte y cómo puedes borrarlos.',
        },
    },
    {
        path: '/terminos',
        name: 'Terminos',
        component: () => import('../views/public/TermsView.vue'),
        meta: {
            public: true,
            title: 'Términos del servicio · Tlahtolcalli',
            description: 'Condiciones para usar Tlahtolcalli, la app gratuita para aprender lenguas originarias de México.',
        },
    },
]
