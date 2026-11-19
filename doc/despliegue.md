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

1. Tu `netlify.toml` en `/f`:
```toml
[build]
  command = "npm run build"
  publish = "dist"
  base = "f"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```
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

## Orden resumido

```
Neon (crear proyecto → correr scripts SQL)
   ↓
Render (Dockerfile → variables de entorno con datos de Neon → deploy)
   ↓
Netlify (VITE_API_URL apuntando a Render/api → production branch correcta → deploy)
```