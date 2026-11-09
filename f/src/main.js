import { createApp } from 'vue'
import { createPinia } from 'pinia'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'
import './style.css'
import App from './App.vue'
import router from './router'
import { preventReload } from './utils/preventReload.js'
import { warmUpBackend } from './api/apiClient.js'
import { palettePlugin } from './utils/palette.js'

// Despertar el backend antes de que el usuario haga login
warmUpBackend()

const pinia = createPinia()
pinia.use(piniaPluginPersistedstate)

const app = createApp(App)

// Aplicar el mixin globalmente
app.mixin(preventReload)

app
    .use(pinia)
    .use(palettePlugin)
    .use(router)
    .mount('#app')
