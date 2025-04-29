import { createApp } from 'vue'
import './style.css'
import App from './App.vue'
import router from './router' // Importa el enrutador

createApp(App)
    .use(router) // Agrega el enrutador a la app
    .mount('#app')