# Manual de despliegue — Tlahtolli (desde cero)

Asume que ya tienes el repo en GitHub con `/f` (front), `/b` (back) y `/db` (scripts SQL).

---

## 1. Base de datos — Neon (PostgreSQL)

1. Entra a [console.neon.tech](https://console.neon.tech) y crea un proyecto nuevo.
    - Región recomendada: **AWS US East 2 (Ohio)** — misma región que usarás en Render.
    - Servicios: deja solo **Postgres database** activado.
2. Una vez creado, ve a **Connect → Connection string**.
    - **Apaga el toggle "Connection pooling"** — para JPA/Hibernate necesitas la conexión directa, no la del pooler (evita conflictos con el pool de HikariCP del lado de la app).
    - Selecciona **Java** en el dropdown de formato para que te arme el JDBC URL completo.
    - Copia el string — lo necesitas para el paso 3.
3. Abre el **SQL Editor** del proyecto en Neon y corre los scripts en este orden exacto:
    1. `1_-Tlahtolli_Database_Script.sql` (esquema: tablas, vista)
    2. `2_-General_Seed_Data.sql` (usuario demo, logros, energía)
    3. `3_-Nahuatl_Seed_Data.sql`
    4. `4_-Teenek_Seed_Data.sql`

---

## 2. Backend — Render (Docker + Spring Boot)

1. En tu repo, agrega un `Dockerfile` en la **raíz de la carpeta del backend** (`/b/<nombre-proyecto>/Dockerfile`, junto al `pom.xml` — no en subcarpetas, o Render no lo encuentra):

```dockerfile
# ============ Build stage ============
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# ============ Runtime stage ============
FROM eclipse-temurin:21-jre-alpine
EXPOSE 8080
ENV JAVA_OPTS="-Djava.io.tmpdir=/tmp"
WORKDIR /opt
RUN mkdir -p /tmp && chmod -R 777 /tmp
COPY --from=build /app/target/<artifactId>-<version>.jar /opt/app.jar
ENTRYPOINT ["java", "-Djava.awt.headless=true", "-jar", "/opt/app.jar"]
```
Ajusta el nombre del jar al patrón real de tu `pom.xml` (`artifactId-version.jar`).

2. Configura tu backend para leer la conexión desde **variables de entorno** (no hardcodeado) — ejemplo con `application.properties`:
```properties
spring.datasource.url=${DB_URL}
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}
spring.datasource.driver-class-name=org.postgresql.Driver
```

3. En [dashboard.render.com](https://dashboard.render.com):
    - **New → Web Service** → conecta el repo de GitHub.
    - **Language**: `Docker` (Render no tiene runtime nativo para Java).
    - **Root Directory**: ruta a la carpeta del backend (ej. `b/ar-cs-tlahtolcalli`).
    - **Region**: Ohio (misma que Neon).
    - **Instance Type**: **Free**.
    - **Environment Variables**:
        - `DB_URL` = tu JDBC URL directo de Neon (con `sslmode=require&channelBinding=require`)
        - `DB_USERNAME` = tu usuario de Neon
        - `DB_PASSWORD` = tu password de Neon
    - **Create Web Service**.
4. Ve al log del deploy. Si todo sale bien, verás `Your service is live 🎉` con una URL tipo `https://<tu-servicio>.onrender.com`.
5. Configura CORS en el backend para aceptar tu dominio de Netlify (en tu `CorsConfig.java`, agrega el dominio real, no dejes solo wildcards mezclados con listas específicas).

**Nota sobre el free tier de Render:** el servicio se "duerme" tras 15 min sin tráfico; el primer request después de inactividad tarda ~30-60s (cold start). No requiere Docker Desktop local — Render construye la imagen en la nube a partir del `Dockerfile` en tu repo.

---

## 3. Frontend — Netlify

1. El front vive en `f/am-ui-tlahtolcalli` (como el back en `b/ar-cs-tlahtolcalli`). Su `netlify.toml`:
```toml
[build]
  command = "npm run build"
  publish = "dist"
  base = "f/am-ui-tlahtolcalli"

[[redirects]]
  from = "/*"
  to = "/spa.html"
  status = 200
```
   En Netlify (**Project configuration → Developer settings → Build settings**), en prod y en dev:
   **Base directory** = `f/am-ui-tlahtolcalli`, **Package directory** vacío, **Publish directory** vacío o
   `f/am-ui-tlahtolcalli/dist`. Netlify lee el `netlify.toml` de la Base directory: si la base apunta a otra
   carpeta, no lo encuentra.
2. En tu código, apunta las llamadas API a una variable de entorno con fallback:
```javascript
const BASE_URL = import.meta.env.VITE_API_URL ?? 'https://<tu-backend>.onrender.com/api'
```
3. En Netlify:
    - **New site from Git** → selecciona el repo.
    - **Site configuration → Environment variables** → agrega:
        - `VITE_API_URL` = `https://<tu-backend>.onrender.com/api` (**no olvides el `/api` al final**)
    - **Site configuration → Build & deploy → Continuous deployment → Branches and deploy contexts** → confirma que la **Production branch** sea la correcta (main, o la rama donde vive el código final).
    - Dale **Save**, y luego **Deploys → Trigger deploy → Deploy site** para forzar un build fresco (las env vars de Vite se inyectan en build time, no basta con redeploy sin rebuild).

---

## 4. Verificación end-to-end

1. Abre tu sitio de Netlify → deberías poder hacer login/consultar datos sin errores de red.
2. Si ves errores de **CORS** en consola: primero revisa el status code real en la pestaña Network — casi siempre es un 404 por una ruta mal armada (falta `/api`, endpoint no existe), no un bloqueo real de CORS. Spring solo agrega headers CORS a las rutas que coincidan con el mapping configurado (`/api/**`), así que una petición fuera de ese prefijo parece "bloqueada por CORS" aunque el problema real sea la URL.
3. Si quieres una vista rápida de diagnóstico sin el front, puedes tener un endpoint tipo `/db-check` (Thymeleaf o JSON) que haga un `SELECT` simple para confirmar Render↔Neon sin depender del frontend.

---

## 5. Front de desarrollo (cursos en pruebas)

```
                                         ┌──> front prod (tlahtolcalli.netlify.app)
                                         │      solo cursos published
neondb <──> render ──[filtro por curso]──┤
  ct_languages.status                    │
  ('draft' | 'published')                └──> front dev (dev-tlahtolcalli.netlify.app)
                                                manda X-Tlahtolcalli-Env: dev
                                                + cuenta con rol tester/admin
                                                → published + draft
```

Un curso con `status = 'draft'` solo existe para el front de desarrollo **y** una cuenta con rol `tester` o `admin`.
Para los demás no aparece en `/api/languages`, y sus niveles, unidades, ejercicios y vocabulario responden 404
(también al guardar progreso o al elegirlo como idioma).

**Una vez**
1. Neon: ejecutar `8.-Estado_Cursos.sql` (agrega `status`; los cursos actuales quedan `published`).
2. Neon: `update ta_users set role = 'tester' where username = 'tu_usuario';` (o usar tu cuenta `admin`).
   El rol va dentro del token: cierra sesión y vuelve a entrar.
3. Netlify → **Add new site → Import from Git** → mismo repo, nombre `dev-tlahtolcalli`:
   - Branch to deploy: `dev` (base `f/am-ui-tlahtolcalli`, build y publish los toma de `netlify.toml`).
   - Variables: `VITE_API_URL` (la misma de prod), `VITE_GOOGLE_CLIENT_ID` (la misma), `VITE_APP_ENV=dev`.
   - Con `VITE_APP_ENV=dev` el build sale con `noindex`, `robots.txt` sin acceso y la etiqueta **Desarrollo** en pantalla.
4. Render: si el sitio de desarrollo no se llama `dev-tlahtolcalli`, agregar `CORS_ORIGINS`
   (`https://tlahtolcalli.netlify.app,https://<tu-sitio-dev>.netlify.app`).
5. Google Cloud → credencial OAuth → **Orígenes de JavaScript autorizados**: agregar el dominio de desarrollo.

**Día a día**
- Curso nuevo: insertarlo con `status = 'draft'` (ejemplos en `8.-Estado_Cursos.sql`) y probarlo en el front de desarrollo.
- Publicarlo: **Monitor → Idiomas → Publicar** (o **A pruebas** para regresarlo). Se ve al instante en los fronts.
  Por SQL también funciona (`update ct_languages set status = 'published' where code = 'xxx';`), pero la API guarda
  el catálogo en caché: aparece en máximo 30 min, o al instante reiniciando el servicio en Render.

---

## 6. Olvidé mi contraseña

- Neon: ejecutar `11.-Restablecer_Contrasena.sql` (acepta `purpose = 'reset'` en `ta_email_tokens`). Se puede ejecutar más de una vez.
- Usa el mismo correo que la verificación (`EMAIL_PROVIDER=brevo`, `BREVO_API_KEY`, `EMAIL_FROM`) y `APP_URL` para armar el enlace
  `APP_URL/restablecer?token=…`. Sin Brevo el enlace solo sale en los logs de Render.
- Al restablecer se cierran **todas** las sesiones de la cuenta (script `14.-Cerrar_Sesiones.sql`, ver sección 10).

---

## 7. PWA (app instalable)

- `vite-plugin-pwa` genera al compilar `site.webmanifest` y `sw.js` (configuración en `vite.config.js`).
  Ya no existe `public/site.webmanifest`: no lo vuelvas a crear, el plugin lo escribe.
- Con `VITE_APP_ENV=dev` el manifest sale como **Tlahtolcalli Dev** con íconos `*-dev-*` (para no confundirlas en el teléfono).
- El service worker guarda JS, CSS e imágenes y `spa.html`; la API no pasa por él (ver sección 8).
- Versión nueva: `UpdatePrompt.vue` avisa y el usuario decide (no aparece en lecciones ni en la bienvenida).
- Sin conexión: ver sección 8.
- `netlify.toml` manda `Cache-Control: no-cache` para `sw.js` y `site.webmanifest`.
- Probar: Chrome → DevTools → Application → Manifest / Service workers. Si algo queda "pegado", **Unregister** y recarga.

---

## 8. Sin conexión (lecciones y avance)

- Neon: ejecutar `12.-Sincronizacion_Sin_Conexion.sql` (tabla `ta_sync_ops`). Se puede ejecutar más de una vez.
  **Antes** de publicar el back: sin la tabla, completar lección falla.
- Render (opcional): `APP_TIMEZONE` (por defecto `America/Mexico_City`) — zona con la que se decide el día de una lección.
- Front (`src/offline/`):
  - `copies.js`: guarda en el teléfono la última respuesta de cada consulta GET; solo se usa sin conexión
    (la energía no: la lleva su store). Se borra al cerrar sesión.
  - `outbox.js`: cola de lo hecho sin conexión (respuestas → `POST /api/energy/user/{id}/sync`,
    lecciones → `POST /api/user-progress/complete` con `clientId` y `completedAt`). Se envía en orden al reconectar,
    al abrir la app, al volver a ella y al iniciar sesión. Si el servidor rechaza un envío (4xx), se descarta.
  - `sync.js`: detecta la conexión (eventos del navegador + `/api/health` cada 15 s mientras no hay).
  - `OfflineScreen.vue`: pantalla completa **solo** si la vista abierta no tiene datos guardados;
    si no, un aviso pequeño. Al volver la conexión se envía lo pendiente y la vista se vuelve a montar.
- Back: `clientId` repetido → se ignora (`SyncOpService`); `completedAt` se acepta hasta 7 días atrás y no en el futuro.
- Limitación: sin conexión no se actualizan experiencia, logros ni desbloqueos (se ven al sincronizar);
  la siguiente lección se abre hasta entonces.

---

## 9. Consumo de Neon (plan gratis: 100 CU-h al mes)

- La base se apaga sola tras 5 min sin conexiones y solo cuenta el tiempo encendida. El pool del back no deja conexiones
  abiertas (`DB_MIN_IDLE=0`, `DB_IDLE_TIMEOUT_MS=60000`), así que el back puede seguir despierto (UptimeRobot) sin gastar.
  **No** subas `DB_MIN_IDLE`: con una sola conexión abierta la base no se apaga nunca (~6 CU-h al día, se acaba el mes).
- Neon → Branch → Compute → Edit: autoscaling **0.25 ↔ 0.5** como tope (con 2 CU un pico gasta 8 veces más rápido).
- Monitor → Overview → "Consumo de Neon": en Render agrega
  - `NEON_API_KEY` — Neon → Account settings → API keys
  - `NEON_PROJECT_ID` — Neon → Settings → General (Project ID)
  - `NEON_CU_HOURS_LIMIT` — opcional, 100 por defecto
- Comprobar: Neon → Monitoring → *Last day*: deben aparecer tramos rayados "endpoint inactive" cuando nadie usa la app.

---

## 10. Racha, sesiones y versión (4.5.0)

- Neon: ejecutar **antes** de publicar el back (el back lee columnas nuevas de `ta_users`; sin ellas falla todo lo de usuarios):
  - `13.-Racha_Dias_Estudio.sql` — tabla `ta_study_days`, `ta_users.last_study_date`; rellena con el historial y
    recalcula racha, días estudiados (antes sumaba 1 por lección) y mejor racha.
  - `14.-Cerrar_Sesiones.sql` — `ta_users.token_version`.
  - `15.-Nivel_Usuario.sql` — recalcula `user_level` con la XP total (antes siempre 1). Puede correrse en cualquier momento.
- Racha: días seguidos con al menos una lección o nivel rápido, en cualquier idioma, en `APP_TIMEZONE`.
  Si el último día estudiado no es hoy ni ayer, vale 0. Las lecciones hechas sin conexión cuentan en su día real.
- Sesiones: cada token lleva `tv` (versión); restablecer la contraseña la sube y los tokens anteriores dejan de
  valer en todos los dispositivos (el front recibe 401 y cierra la sesión). La versión se guarda 10 min en memoria
  (`SessionVersions`) para no consultar la base en cada petición; `/api/health` no la revisa.
- Nivel: XP por nivel = puntos de los ejercicios de un nivel del curso (`UserLevelService`); el perfil muestra
  `xpInLevel / xpToNextLevel` tal como los manda el back.
- Versión: `package.json` → visible en Perfil → Ajustes y en el menú lateral (con el commit corto en Netlify).

## 11. App de Android (TWA)

Ver `f/am-ui-tlahtolcalli/twa/README.md`. Resumen:
- `npm run twa:version` copia la versión de `package.json` a `twa/twa-manifest.json` (4.5.0 → versionCode 40500).
- `cd twa && bubblewrap update && bubblewrap build` → `app-release-signed.apk`.
- Netlify (solo prod): `TWA_SHA256_FINGERPRINTS` = huella de la llave (`bubblewrap fingerprint list`); el build publica
  `/.well-known/assetlinks.json` y la app abre sin barra de dirección.
- La llave (`android.keystore`) y los APK no van al repo (`.gitignore`).

---

## Orden resumido

```
Neon (crear proyecto → correr scripts SQL)
   ↓
Render (Dockerfile → variables de entorno con datos de Neon → deploy)
   ↓
Netlify (VITE_API_URL apuntando a Render/api → production branch correcta → deploy)
```