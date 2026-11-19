# Documentación de Tlahtolcalli

Archivos de apoyo que no son código de la app. Nada de esta carpeta se publica ni se compila.

| Carpeta / archivo | Contenido |
|---|---|
| `changelog/frontend.md` | Changelog técnico del frontend (hasta la v3.5.2, enero 2026) |
| `changelog/backend.md` | Changelog técnico del backend (hasta la v0.0.4) |
| `changelog/anotaciones.txt` | Notas y changelogs sueltos de abril 2026 (migración a la API) |
| `despliegue.md` | Manual de despliegue desde cero (Netlify, Render, Neon) |
| `frontend/integracion.md` | Guía de integración frontend ↔ backend |
| `frontend/de-spa-a-pwa.md` | Pendientes para convertir la app en PWA instalable |
| `frontend/pendientes.md` | Ideas y bugs pendientes |
| `referencia/json-sistema-de-escritura.txt` | Formato JSON de los sistemas de escritura |
| `pruebas/estres_tlahtolcalli.js` | Prueba de estrés con k6 (ver instrucciones dentro del archivo) |
| `recursos/marca/` | Logos, favicons e imagen original de la portada |
| `recursos/en-construccion.html` | Página "En construcción" anterior |
| `recursos/dialectos_learning.rar` | Material de referencia (90 MB) |

## Novedades para usuarios

Lo que ven los usuarios en `/novedades` está en `f/src/data/changelog.js`.
Al publicar una versión, agrega una entrada al inicio de ese arreglo (en lenguaje para usuarios)
y, si quieres el detalle técnico, súmalo a `changelog/`.
