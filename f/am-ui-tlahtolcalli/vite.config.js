import { fileURLToPath, URL } from 'node:url'

import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'
import { VitePWA } from 'vite-plugin-pwa'
import { readFileSync } from 'node:fs'

// Versión de la app (package.json) y commit (Netlify da COMMIT_REF): se muestran en Perfil → Ajustes
const APP_VERSION = JSON.parse(readFileSync(new URL('./package.json', import.meta.url), 'utf-8')).version

// ── PWA ─────────────────────────────────────────────────────────────────────
// Manifest (site.webmanifest) y service worker (sw.js) se generan al compilar.
// El sitio de desarrollo (VITE_APP_ENV=dev) se instala como "Tlahtolcalli Dev", con su propio ícono.
function pwa(isDev) {
  const icon = (name) => (isDev ? name.replace('android-chrome-', 'android-chrome-dev-').replace('maskable-', 'maskable-dev-') : name)
  return VitePWA({
    registerType: 'prompt',          // la versión nueva se aplica cuando el usuario toca "Actualizar" (UpdatePrompt.vue)
    injectRegister: false,           // se registra a mano en src/pwa.js
    manifestFilename: 'site.webmanifest',
    manifest: {
      id: '/app',
      name: isDev ? 'Tlahtolcalli Dev' : 'Tlahtolcalli',
      short_name: isDev ? 'Tlahtol Dev' : 'Tlahtolcalli',
      description: 'Aprende lenguas originarias de México con lecciones cortas.',
      lang: 'es-MX',
      dir: 'ltr',
      start_url: '/app',
      scope: '/',
      display: 'standalone',
      orientation: 'any',
      theme_color: '#0e1517',
      background_color: '#0e1517',
      categories: ['education'],
      icons: [
        { src: icon('/android-chrome-192x192.png'), sizes: '192x192', type: 'image/png', purpose: 'any' },
        { src: icon('/android-chrome-512x512.png'), sizes: '512x512', type: 'image/png', purpose: 'any' },
        { src: icon('/maskable-192x192.png'), sizes: '192x192', type: 'image/png', purpose: 'maskable' },
        { src: icon('/maskable-512x512.png'), sizes: '512x512', type: 'image/png', purpose: 'maskable' },
      ],
      shortcuts: [
        { name: 'Continuar aprendiendo', short_name: 'Continuar', url: '/app', icons: [{ src: icon('/android-chrome-192x192.png'), sizes: '192x192' }] },
        { name: 'Glosario', url: '/app/glosario', icons: [{ src: icon('/android-chrome-192x192.png'), sizes: '192x192' }] },
        { name: 'Estadísticas', url: '/app/estadisticas', icons: [{ src: icon('/android-chrome-192x192.png'), sizes: '192x192' }] },
      ],
      screenshots: [
        { src: '/screenshots/movil-nhn-inicio.webp', sizes: '432x935', type: 'image/webp', form_factor: 'narrow', label: 'Niveles del curso' },
        { src: '/screenshots/movil-nhn-leccion-correcta.webp', sizes: '432x935', type: 'image/webp', form_factor: 'narrow', label: 'Una lección' },
        { src: '/screenshots/movil-nhn-glosario.webp', sizes: '432x935', type: 'image/webp', form_factor: 'narrow', label: 'Glosario con el alfabeto' },
        { src: '/screenshots/escritorio-inicio.webp', sizes: '1280x720', type: 'image/webp', form_factor: 'wide', label: 'Inicio en computadora' },
        { src: '/screenshots/escritorio-nivel.webp', sizes: '1280x720', type: 'image/webp', form_factor: 'wide', label: 'Unidades de un nivel' },
      ],
    },
    workbox: {
      // Se guarda en el teléfono todo lo de la app (JS, CSS, imágenes, íconos) para abrir al instante.
      globPatterns: ['**/*.{js,css,ico,png,svg,webp,woff2}'],
      // Las páginas HTML se generan después (scripts/prerender.mjs): spa.html se agrega abajo.
      // La portada y lo que solo sirve para instalar/compartir no hace falta guardarlo.
      globIgnores: ['**/*.html', 'landing/**', 'screenshots/**', 'og-image.png', '**/android-chrome-dev-*', '**/maskable-dev-*'],
      additionalManifestEntries: [{ url: '/spa.html', revision: String(Date.now()) }],
      maximumFileSizeToCacheInBytes: 3 * 1024 * 1024,
      // Cualquier ruta de la app abre el shell guardado (también sin conexión).
      // Las páginas públicas prerenderizadas siguen viniendo de Netlify.
      navigateFallback: '/spa.html',
      navigateFallbackDenylist: [/^\/$/, /^\/como-se-usa\/?$/, /^\/novedades\/?$/, /^\/privacidad\/?$/, /^\/terminos\/?$/, /^\/sitemap\.xml$/, /^\/robots\.txt$/],
      cleanupOutdatedCaches: true,
      clientsClaim: true,
      // La API (Render) nunca se guarda: progreso, energía y sesión siempre vienen del servidor.
      runtimeCaching: [
        {
          urlPattern: ({ url }) => url.origin === 'https://fonts.googleapis.com',
          handler: 'StaleWhileRevalidate',
          options: { cacheName: 'google-fonts-css' },
        },
        {
          urlPattern: ({ url }) => url.origin === 'https://fonts.gstatic.com',
          handler: 'CacheFirst',
          options: {
            cacheName: 'google-fonts',
            expiration: { maxEntries: 30, maxAgeSeconds: 60 * 60 * 24 * 365 },
            cacheableResponse: { statuses: [0, 200] },
          },
        },
      ],
    },
  })
}

export default defineConfig(({ mode, isSsrBuild }) => {
  const env = { ...loadEnv(mode, process.cwd(), ''), ...process.env }
  const isDev = env.VITE_APP_ENV === 'dev'
  return {
    base: '/',
    // El build SSR solo prerenderiza las páginas públicas: no lleva service worker
    plugins: [vue(), !isSsrBuild && pwa(isDev)].filter(Boolean),
    define: {
      __APP_VERSION__: JSON.stringify(APP_VERSION),
      __APP_COMMIT__: JSON.stringify((env.COMMIT_REF || '').slice(0, 7)),
    },
    build: {
      outDir: 'dist'
    },
    server: {
      host: '0.0.0.0'
    },
    resolve: {
      alias: {
        '@': fileURLToPath(new URL('./src', import.meta.url))
      }
    }
  }
})
