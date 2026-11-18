import { createApp } from 'vue'
import { createPinia } from 'pinia'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'
import './style.css'
import App from './App.vue'
import router from './router'
import { warmUpBackend, configureAuth } from './api/apiClient.js'
import { useAuthStore } from './stores/auth.js'
import { palettePlugin } from './utils/palette.js'

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

app.mount('#app')
