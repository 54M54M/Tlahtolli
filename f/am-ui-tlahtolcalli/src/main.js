import { createApp } from 'vue'
import { createPinia } from 'pinia'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'
import './style.css'
import App from './App.vue'
import router from './router'
import { warmUpBackend, configureAuth } from './api/apiClient.js'
import { useAuthStore } from './stores/auth.js'
import { palettePlugin } from './utils/palette.js'
import { setupPWA } from './pwa.js'
import { setupOfflineSync } from './offline/sync.js'
import { setupUiPrefs } from './data/uiPrefs.js'

// Despertar el backend antes de que el usuario haga login
warmUpBackend()

const pinia = createPinia()
pinia.use(piniaPluginPersistedstate)

const app = createApp(App)

app
    .use(pinia)
    .use(palettePlugin)
    .use(router)

// Cada petición lleva el token; si el backend responde 401, se cierra la sesión
const authStore = useAuthStore()
configureAuth({
    token: () => authStore.token,
    unauthorized: () => {
        if (!authStore.user) return
        authStore.logout()
        router.push('/login')
    },
})

// Se monta cuando el router resolvió la primera ruta: así el HTML prerenderizado
// (portada, novedades, privacidad, términos) se reemplaza sin parpadeo en blanco
router.isReady().then(() => app.mount('#app'))

// Sin conexión: detecta cuándo se va y vuelve el internet y envía lo que se hizo mientras (src/offline)
setupOfflineSync()

// Preferencias de la interfaz (diseño de opciones y fichas)
setupUiPrefs()

// Service worker: la app abre al instante, funciona instalada y avisa cuando hay versión nueva
setupPWA()
