Completar el manifest
En public/site.webmanifest, `name` y `short_name` están vacíos ("") — sin esto Chrome no considera la app instalable.
    Agregar también `start_url: "/"` y `scope: "/"`, que hoy no existen

Íconos maskable
Los íconos 192x192 y 512x512 no declaran `"purpose": "maskable"`. Sin eso, Android recorta el ícono raro dentro de la
    forma adaptativa. Puedes duplicar la entrada del ícono con purpose: "maskable" o generar una versión con más
    padding

Agregar un Service Worker
Realmente falta y la más importante: hoy no existe ningún SW en el proyecto. Sin él no hay funcionamiento offline ni
    instalación confiable en Chrome/Android. Lo más rápido dado que se usa Vite es meter
    `vite-plugin-pwa` (usa Workbox por debajo) en vez de escribirlo a mano

Definir estrategia de caché
Con vite-plugin-pwa se define qué se precachea (JS/CSS/assets estáticos del build) y qué se cachea en runtime. Como la
    webapp depende 100% del backend para todo (lecciones, diccionario, stats vía apiClient.js), se necesita una
    estrategia tipo network-first con fallback a caché para esas llamadas, o el modo offline no sirve de mucho

Manejar el estado offline en la UI
Ahora mismo la app no detecta si no hay conexión. Con `navigator.onLine` + un listener de eventos online/offline, se
    puede mostrar un aviso o degradar la UI (deshabilitar botones que dependen del backend) cuando no hay red

Lógica de actualización de versión
El front tiene auto-publish activo en Netlify (cada push a v3 se publica solo). Sin un Service Worker que detecte
    nuevas versiones y avise al usuario ("hay una actualización, recarga"), la gente puede quedarse atorada viendo
    una versión cacheada vieja. vite-plugin-pwa trae esto con el modo `registerType: 'prompt'` o `'autoUpdate'`.

Validar con Lighthouse
Una vez con manifest completo + SW + HTTPS (vía Netlify), ejecutar una auditoría PWA de Lighthouse en
    Chrome DevTools para confirmar que el navegador realmente ofrece "Instalar app" y que no falta ningún checkbox.