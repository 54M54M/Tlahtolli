// main.js
import { createApp } from 'vue'
import { createPinia } from 'pinia'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'
import './style.css'
import App from './App.vue'
import router from './router'
import { preventReload } from './utils/preventReload.js'

const pinia = createPinia()
pinia.use(piniaPluginPersistedstate)

const app = createApp(App)

// Aplicar el mixin globalmente
app.mixin(preventReload)

app
    .use(pinia)
    .use(router)
    .mount('#app')