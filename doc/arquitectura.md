# Arquitectura de Tlahtolcalli

Diagramas hechos a mano a partir del código (versión 4.1). GitHub los dibuja directo (Mermaid).
**Actualízalos cuando cambie la estructura** (servicios nuevos, rutas, tablas, despliegue).

1. [Despliegue](#1-despliegue)
2. [Frontend](#2-frontend)
3. [Backend](#3-backend)
4. [Flujo de una lección](#4-flujo-de-una-lección)
5. [Inicio de sesión](#5-inicio-de-sesión)
6. [Reglas de acceso](#6-reglas-de-acceso)
7. [Modelo de datos](#7-modelo-de-datos)

---

## 1. Despliegue

```mermaid
flowchart LR
    U([Usuario])
    T([Tester / admin])

    subgraph Netlify
        P["tlahtolcalli.netlify.app<br/>front prod · rama v4<br/>publicación bloqueada"]
        D["dev-tlahtolcalli.netlify.app<br/>front dev · rama dev<br/>VITE_APP_ENV=dev · noindex"]
        O["totlahtol.netlify.app<br/>301 → tlahtolcalli"]
    end

    subgraph Render
        A["ar-cs-tlahtolcalli<br/>Spring Boot 3.5 · Java 21 · Docker<br/>despliegue manual"]
        M["/monitor<br/>panel de administración"]
    end

    N[("Neon<br/>PostgreSQL")]
    B["Brevo<br/>correos"]
    G["Google<br/>Identity Services"]
    UR["UptimeRobot"]

    U --> P
    T --> D
    U -. enlaces viejos .-> O --> P
    P -- "/api (JWT)" --> A
    D -- "/api (JWT) + X-Tlahtolcalli-Env: dev" --> A
    A --- M
    A --> N
    A -- "verificación de correo" --> B
    P & D -- "botón de Google" --> G
    A -- "valida el ID token (JWKS)" --> G
    UR -- "/api/health" --> A
```

| Pieza | Dónde | Variables clave |
|---|---|---|
| Front prod | Netlify `tlahtolcalli` | `VITE_API_URL`, `VITE_GOOGLE_CLIENT_ID` |
| Front dev | Netlify `dev-tlahtolcalli` | las mismas + `VITE_APP_ENV=dev` |
| API | Render `ar-cs-tlahtolcalli` | `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`, `JWT_SECRET`, `GOOGLE_CLIENT_ID`, `BREVO_API_KEY`, `EMAIL_FROM`, `APP_URL`, `CORS_ORIGINS` |
| Monitor | Render (mismo servicio) | `NEON_API_KEY`, `RENDER_API_KEY`, `UPTIMEROBOT_API_KEY` |
| Base de datos | Neon | scripts en `b/.../static/sql_postgres` |

---

## 2. Frontend

Vue 3 + Pinia + Tailwind, en `f/`. Las páginas públicas se prerenderizan a HTML (SEO); el resto usa `spa.html`.

```mermaid
flowchart TB
    subgraph Publicas["Páginas públicas (prerenderizadas)"]
        L["/ · LandingView"]
        NV["/novedades · ChangelogView"]
        PR["/privacidad · /terminos"]
        AM["AuthModal<br/>?auth=login | register<br/>(LoginView embebido)"]
        L --- AM
    end

    subgraph App["/app (requiere sesión)"]
        H["/app · HomeView<br/>mapa de niveles"]
        LV["/app/nivel/:idioma · LevelView"]
        LS["/app/leccion/:idioma · LessonView"]
        QL["/app/nivel-rapido/:idioma · QuickLevelView"]
        GL["/app/glosario · GlossaryView"]
        ST["/app/estadisticas · StatsView"]
        PF["/app/perfil · /app/perfil/editar"]
        LG["/app/idioma · VariantSelection"]
        CU["/app/elegir-usuario · ChooseUsernameView"]
        VE["/verificar · VerifyEmailView"]
    end

    R{{"router/index.js<br/>beforeEach: sesión, usuario, idioma<br/>beforeEnter: nivel/lección desbloqueados<br/>URL muestra el idioma, no el id"}}

    subgraph Estado["Pinia"]
        SA["auth<br/>usuario · token · idioma"]
        SE["energy"]
        SC["cache"]
    end

    subgraph Datos["Capa de datos"]
        DL["data/learning.js<br/>niveles · unidades · acceso"]
        DS["data/stats.js · achievements.js"]
        PS["services/ProgressService.js"]
        LA["learn/lessonApi.js"]
        AC["api/apiClient.js<br/>fetch + JWT + X-Tlahtolcalli-Env"]
    end

    API[(API Render)]

    R --> App
    R --> Publicas
    H & LV --> DL
    LS & QL --> LA
    ST & PF --> DS
    LA --> PS
    DL & DS & PS --> AC
    SA & SE --> AC
    DL --> SC
    AC --> API
```

---

## 3. Backend

Spring Boot en `b/ar-cs-tlahtolcalli`. Capas: filtro de seguridad → controlador → servicio → repositorio (JPA) → Neon.

```mermaid
flowchart TB
    REQ([Petición HTTP])

    subgraph Seguridad
        CORS["CorsConfig<br/>prod · dev · localhost"]
        JWT["JwtAuthFilter + TokenService<br/>Claims: id, rol"]
        OWN["OwnershipInterceptor<br/>solo tus propios datos"]
        ADM["/api/admin/** · /monitor<br/>rol admin"]
    end

    subgraph Controladores
        CAuth["AuthController<br/>login · google"]
        CAcc["AccountController<br/>perfil · contraseña · correo · borrar"]
        CMail["EmailVerificationController"]
        CLearn["LearningController<br/>niveles · unidades · ejercicios · vocabulario · rápido"]
        CProg["UserProgressController<br/>complete · complete-level · init"]
        CEn["EnergyController"]
        CLang["LanguageController"]
        CStats["UserStats · UserAchievement · LessonHistory"]
        CAdmin["AdminCourseController · AdminMetricsController"]
        CCat["Catálogo CRUD<br/>Level · Unit · Exercise · Vocabulary · WritingSystem"]
    end

    subgraph Servicios
        SAuth["GoogleAuthService · UserService · AccountService"]
        SMail["EmailVerificationService → Brevo"]
        SLearn["LearningService<br/>progreso por unidad · bloqueos"]
        SFac["LessonCompletionFacade"]
        SProg["ProgressService<br/>progreso · stats · XP"]
        SAch["AchievementService"]
        SEn["EnergyService"]
        SCourse["CourseAccess<br/>cursos draft / published"]
    end

    REPO[("Repositorios JPA → Neon")]
    CACHE[["Caché CATALOGO<br/>se vacía cada 30 min"]]

    REQ --> CORS --> JWT --> OWN --> Controladores
    JWT --> ADM --> CAdmin
    CAuth --> SAuth
    CAcc --> SAuth & SMail
    CMail --> SMail
    CLearn --> SCourse & SLearn
    CProg --> SFac
    SFac --> SCourse & SLearn & SProg & SAch
    CEn --> SEn
    CLang --> SCourse
    CAdmin --> SCourse
    SLearn & SCourse --> CACHE
    Servicios --> REPO
    CStats & CCat --> REPO
```

---

## 4. Flujo de una lección

```mermaid
sequenceDiagram
    autonumber
    actor U as Usuario
    participant R as Router
    participant LV as LessonView
    participant API as API (Render)
    participant CA as CourseAccess
    participant LS as LearningService
    participant F as LessonCompletionFacade
    participant DB as Neon

    U->>R: abre /app/leccion/nhn
    R->>R: lee el id del historial (o la lección en curso)
    R->>API: GET /learning/levels/{nivel}/units
    API->>CA: ¿curso visible?
    API->>LS: unidades con progreso y bloqueos
    LS->>DB: niveles · unidades · progreso
    R-->>U: bloqueada → /app

    R->>LV: unidad permitida
    LV->>API: GET /learning/units/{id}/exercises
    API-->>LV: ejercicios (en caché)

    loop cada respuesta
        LV->>API: POST /energy/user/{id}/consume
        API-->>LV: energía restante
    end

    LV->>API: POST /user-progress/complete
    API->>F: completeLesson
    F->>CA: requireUnit (curso visible)
    F->>LS: isUnitAccessible (no bloqueada)
    F->>DB: progreso · stats · XP · desbloquea la siguiente
    F->>DB: logros nuevos (transacción aparte)
    API-->>LV: XP · logros · siguiente unidad
    LV-->>U: pantalla de resultado
```

---

## 5. Inicio de sesión

```mermaid
sequenceDiagram
    autonumber
    actor U as Usuario
    participant F as Front
    participant G as Google
    participant API as API
    participant DB as Neon
    participant B as Brevo

    alt usuario y contraseña
        U->>F: usuario + contraseña
        F->>API: POST /auth/login
        API->>DB: valida hash BCrypt
    else Google
        U->>G: elige cuenta
        G-->>F: ID token
        F->>API: POST /auth/google
        API->>G: llaves públicas (JWKS)
        API->>API: valida firma, emisor, aud, vencimiento
        API->>DB: busca o crea usuario<br/>(vincula solo si el correo ya está verificado)
    end
    API-->>F: JWT + usuario (rol, mustPickUsername)
    F->>F: guarda la sesión (Pinia)

    opt cuenta nueva de Google
        F-->>U: /app/elegir-usuario
    end
    opt correo sin verificar
        API->>B: correo con enlace (token SHA-256, 24 h, un uso)
        U->>F: /verificar?token=…
        F->>API: POST /auth/email/confirm
    end
```

---

## 6. Reglas de acceso

```mermaid
flowchart TD
    A[Petición a contenido de un curso] --> B{¿Curso published?}
    B -- sí --> E
    B -- no, draft --> C{"X-Tlahtolcalli-Env"}
    C -- "dev" --> C1{"¿rol tester o admin?"}
    C -- "monitor" --> C2{"¿rol admin?"}
    C -- ninguno --> X["404 · el curso no existe para ti"]
    C1 -- sí --> E
    C1 -- no --> X
    C2 -- sí --> E
    C2 -- no --> X

    E{¿Nivel desbloqueado?} -- no --> Y["front: vuelve a /app<br/>API: 400 al completar"]
    E -- sí --> F{¿Unidad desbloqueada?}
    F -- no --> Y
    F -- sí --> OK[Se puede abrir y completar]
```

- **Nivel 1** siempre abierto; el nivel N se abre al terminar el N-1 (o con el nivel rápido).
- **Unidad 1** abierta por defecto; las demás según `ta_user_progress.is_locked`.
- Un nivel bloqueado bloquea todas sus unidades.
- Publicar / regresar a pruebas: **Monitor → Idiomas**.

---

## 7. Modelo de datos

Tablas principales (prefijo `ct_` = catálogo, `ta_` = datos del usuario, `rl_` = relación).

```mermaid
erDiagram
    ct_languages ||--o{ ct_levels : tiene
    ct_levels ||--o{ ct_units : tiene
    ct_units ||--o{ ct_exercises : tiene
    ct_units ||--o{ rl_unit_vocab : usa
    ct_vocabulary ||--o{ rl_unit_vocab : aparece_en
    ct_languages ||--o{ ct_vocabulary : tiene
    ct_languages ||--o{ ct_writing_systems : tiene

    ta_users ||--o{ ta_user_progress : avanza
    ct_units ||--o{ ta_user_progress : registra
    ta_users ||--o{ ta_user_stats : "por idioma"
    ta_users ||--o{ ta_user_achievements : desbloquea
    ta_users ||--o| ta_user_energy : tiene
    ta_users ||--o{ ta_lesson_history : completa
    ta_users }o--o| ct_languages : current_lang

    ct_languages {
        int id PK
        varchar code "nhn, hus, yua, zai"
        varchar status "draft | published"
    }
    ct_levels {
        int id PK
        int language_id FK
        int level_num
        int is_free
    }
    ct_units {
        int id PK
        int level_id FK
        int unit_num
    }
    ct_exercises {
        int id PK
        int unit_id FK
        varchar exercise_type "multiple-choice | fill-blank"
        json correct_ans
        json options
    }
    ta_users {
        int id PK
        varchar username
        varchar role "user | tester | admin"
        boolean email_verified
        boolean must_pick_username
    }
    ta_user_progress {
        int user_id FK
        int unit_id FK
        int completed
        int is_locked
        int is_current
    }
```
