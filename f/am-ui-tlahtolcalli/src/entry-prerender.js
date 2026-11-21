// Prerender de las páginas públicas (solo se usa al compilar; ver scripts/prerender.mjs).
// Renderiza cada página a HTML con el servidor de Vue para que Google y las vistas previas
// la lean sin ejecutar JavaScript. En el navegador, main.js monta la app encima normalmente.
import { createSSRApp, h } from 'vue'
import { renderToString } from 'vue/server-renderer'
import { createRouter, createMemoryHistory, RouterView } from 'vue-router'
import { createPinia } from 'pinia'
import { publicRoutes, SITE_URL } from './router/publicRoutes'

export { SITE_URL }
export const PAGES = publicRoutes.map((r) => ({ path: r.path, ...r.meta }))

export async function render(url) {
    const app = createSSRApp({ render: () => h(RouterView) })
    const router = createRouter({ history: createMemoryHistory(), routes: publicRoutes })
    app.use(createPinia()).use(router)
    await router.push(url)
    await router.isReady()
    return renderToString(app)
}
