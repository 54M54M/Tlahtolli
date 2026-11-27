# CHANGELOG (Backend)

----- CTUALIXAR CHANGELOG -----

## [4.6.2] - 2026-11-26 - Desglose de palabras

### Changed
- Scripts SQL consolidados (`sql_postgres/`): `1.-esquema.sql` (estructura completa, re-ejecutable), `2.-datos_generales.sql`,
  `3.-curso_nhn.sql`, `4.-curso_hus.sql`, `pruebas/` y `mantenimiento/`. Sustituyen a los scripts numerados 1–16.
- `chk_users_role` acepta `tester` (antes la base solo aceptaba `user` y `admin`).
- Desglose en todas las palabras de nhn (195) y hus (175). Cursos yua (213 palabras) y zai (219) ampliados a 6 niveles,
  36 unidades y 216 ejercicios cada uno, con desglose; siguen en pruebas.

### Fixed
- Nivel del perfil calculado con la XP total al leer (antes la barra podía quedar llena, p. ej. 540/540, sin subir de nivel).
- XP por nivel se calcula al arrancar; antes el perfil usaba el respaldo (540) hasta que alguien terminaba una lección.

### Added
- `POST /api/reports`: «Reportar un problema» en un ejercicio. Se envía por correo a `REPORT_EMAIL`
  (por defecto contacto.tlahtolcalli@gmail.com), en segundo plano; 10 por hora por usuario.
- `ct_vocabulary.breakdown` (script `16.-Desglose_Palabras.sql`): desglose de la palabra para la pista
  (`"no- = mi; tōka = nombre"`). `GET /api/learning/units/{id}/vocabulary` lo incluye cuando existe.

### Fixed
- Al repasar una unidad, la siguiente ya completada volvía a marcarse como actual (`is_current`). `unlockNextUnit` y el
  desbloqueo de nivel solo la marcan si no está completada; el script 16 limpia los registros existentes.

## [4.6.0] - 2026-11-24 - Armar frases

### Added
- Tipo de ejercicio `word-bank` (armar la frase con fichas): `correct_ans` = respuestas aceptadas (JSON o texto),
  `options` = fichas (JSON, opcional: si no hay, se arman con la respuesta + 3 palabras del vocabulario).
  La API lo entrega como `accepted` y `tiles`. Disponible en el monitor (Ejercicios → Tipo).

## [4.5.0] - 2026-11-22 - Racha y cierre de sesiones

### Added
- Racha de días: `ta_study_days` (script `13.-Racha_Dias_Estudio.sql`) y `StudyStreakService`. Cada lección o nivel
  rápido marca el día (en `APP_TIMEZONE`) y recalcula `ta_users.streak` + `last_study_date` (días seguidos en cualquier
  idioma) y, por idioma, `days_studied` y `best_streak`. `UserResponse` trae `streak` vigente (0 si el último día no es
  hoy ni ayer), `lastStudyDate` y `studiedToday`. Los logros de racha de 7 y 30 días ya pueden desbloquearse.
- Cierre de sesiones al restablecer la contraseña: `ta_users.token_version` (script `14.-Cerrar_Sesiones.sql`), claim
  `tv` en el JWT y `SessionVersions` (caché de 10 min) en `JwtAuthFilter`. El correo de aviso lo menciona.
- Nivel del usuario: `UserLevelService` actualiza `ta_users.user_level` cada vez que se gana XP (lecciones, niveles
  rápidos, logros). XP por nivel = suma de los puntos de los ejercicios de un nivel del curso (promedio de los cursos
  publicados, hoy ≈ 36 × 15 = 540), con caché de 1 h; el nivel nunca baja. `UserResponse` y el login traen
  `xpInLevel` y `xpToNextLevel` para la barra del perfil. Script `15.-Nivel_Usuario.sql` recalcula los niveles.
- `util/AppTime`: zona horaria única de la app (día de lecciones, racha, fecha de alta y de logros).

### Fixed
- `days_studied` sumaba 1 por lección; ahora son días distintos.
- Repetir una lección ya completada también cuenta para la racha del día.

## [4.4.1] - 2026-11-22 - Neon puede dormir

### Changed
- Pool de conexiones (`SQLConfig`): `minimumIdle` 0 (antes 1), conexiones inactivas se cierran al minuto (antes 5),
  sin keepalive. Neon se apaga 5 min después de la última consulta aunque el back siga despierto (UptimeRobot).
  Configurable: `DB_MIN_IDLE`, `DB_IDLE_TIMEOUT_MS`. Antes la base estaba encendida 24/7 (~6 CU-h al día).
- Monitor: el health check (cada 60 s) solo corre con la pestaña/app a la vista.

### Added
- `GET /api/admin/neon-usage` (`NeonUsageService`): CU-h del mes, ritmo por día, proyección y fecha en que se acabarían,
  leído de la API de Neon (no despierta la base; caché de 5 min). Tarjeta "Consumo de Neon" en el Overview del monitor,
  en ámbar desde 70 % y rojo desde 90 %. Variables: `NEON_API_KEY`, `NEON_PROJECT_ID`, `NEON_CU_HOURS_LIMIT` (100).

## [4.4.0] - 2026-11-22 - Sin conexión

### Added
- `ta_sync_ops` (script `12.-Sincronizacion_Sin_Conexion.sql`) y `SyncOpService`: cada envío hecho sin conexión trae un
  `clientId` (UUID); si llega dos veces, el segundo se ignora. Si aplicarlo falla, se libera para el reintento.
- `POST /api/energy/user/{userId}/sync` (`{ clientId, answers: [bool…] }`): respuestas contestadas sin conexión,
  aplicadas en orden con las mismas reglas que `consume`. Solo el propio usuario o admin.
- `CompleteLessonRequest.clientId` y `completedAt` (opcionales; el front viejo sigue funcionando).

### Changed
- El día de una lección (`ta_lesson_history.completed_at`, `ta_user_progress.completed_at`) es el de `completedAt`
  en `APP_TIMEZONE` (por defecto `America/Mexico_City`), acotado a los últimos 7 días y nunca en el futuro.
  Antes era `LocalDate.now()` del servidor (UTC en Render: de 6 pm en adelante contaba como el día siguiente).
- Monitor: las URLs del ícono llevan `?v=<huella>`; al cambiar `icon.png` Chrome/Android ya no reutilizan el viejo.
  Ícono también `maskable`; manifest sin caché.

## [4.2.0] - 2026-11-21 - Olvidé mi contraseña

### Added
- `PasswordResetService`: `POST /api/auth/password/forgot` (usuario o correo; responde lo mismo exista o no la cuenta)
  y `POST /api/auth/password/reset` (token del correo + contraseña nueva). Token de 32 bytes, solo su hash SHA-256,
  un uso, 1 hora; 1 envío por minuto y 5 por hora por cuenta. Al restablecer, el correo queda verificado y se avisa por correo.
- `ta_email_tokens.purpose = 'reset'` — script `11.-Restablecer_Contrasena.sql`.

### Changed
- La verificación de correo ya no invalida los enlaces de restablecer (y al revés); un enlace de contraseña no verifica correos.
- Registro con usuario o correo existente: mensajes en español que sugieren recuperar la contraseña.

## [4.1.0] - 2026-11-19 - Cursos en pruebas

### Added
- `ct_languages.status` (`draft` | `published`) — script `8.-Estado_Cursos.sql`.
- `CourseAccess`: un curso `draft` solo es visible con el encabezado `X-Tlahtolcalli-Env: dev` y rol `tester`/`admin`.
  Filtra `/api/languages` y responde 404 en niveles, unidades, ejercicios, vocabulario, nivel rápido,
  completar lección, registro y cambio de idioma.

- Monitor → Idiomas: columnas Contenido y Estado, botón Publicar / A pruebas (`GET /api/admin/courses`, `PUT /api/admin/courses/{id}/status`).
  El monitor manda `X-Tlahtolcalli-Env: monitor` y, como admin, ve también los cursos en pruebas.

### Changed
- CORS: solo los orígenes de `CORS_ORIGINS` (por defecto prod y `dev-tlahtolcalli`) y localhost; antes `*`.
- Incluye la validación de niveles/lecciones bloqueados de 4.0.1 (`LearningService`, `LessonCompletionFacade`).

## [0.0.4] - 2026-03-15 - Correcciones de Compilación

### Fixed

- **Exercise.java**
  - Agregados campos `CORRECT_ANS` y `OPTIONS` faltantes en la entidad
  - Manejo de respuestas y opciones en formato JSON desde la base de datos

- **LessonHistory.java**
  - Agregado campo `LESSON_ID` que faltaba en la entidad

- **ProgressService.java, AchievementService.java, EnergyService.java**
  - Reemplazado `.builder()` por `new` + setters para compatibilidad con Lombok
  - Eliminada dependencia circular en `UserService`

### Changed

- **LearningService.java**
  - Lógica de prioridad para opciones y respuestas correctas
  - Deserialización de JSON con `ObjectMapper`

## [0.0.3] - 2026-03-15 - Capa de Servicios

### Added

- **Nuevas Entidades JPA**
  - `UserProgress.java`: estado de progreso (locked/completed/current) por usuario y unidad
  - `UserEnergy.java`: sistema de energía del usuario
  - `UserAchievement.java`: relación usuario-logro con fecha de desbloqueo
  - `WritingSystem.java`: sistemas de escritura para cada idioma
  - `UnitVocab.java`: relación de vocabulario por unidad

- **Repositories**
  - `UserProgressRepository`, `UserEnergyRepository`, `UserAchievementRepository`
  - `WritingSystemRepository`, `UnitVocabRepository`
  - Métodos extendidos en repositorios existentes para filtros y búsquedas

- **Services (Capa de Negocio)**
  - `EnergyService`: inicialización y consumo de energía
  - `ProgressService`: actualización de progreso con transacciones
  - `AchievementService`: verificación y desbloqueo de logros
  - `UserService`: CRUD de usuarios con validación
  - `LearningService`: datos enriquecidos para el frontend

- **Controllers**
  - `EnergyController`, `LearningController`, `UserProgressController`, `UserAchievementController`
  - Controllers actualizados con filtros y nuevos endpoints

### Changed

- Arquitectura refactorizada: controllers → services → repositories
- Operaciones transaccionales para múltiples tablas con `@Transactional`

## [0.0.2] - 2026-03-15 - Sistemas Completos de Ejercicios

### Added

- **ExerciseController.java**
  - Controlador REST que maneja todas las operaciones de ejercicios
  - Puedes obtener todos los ejercicios o buscar por tipo específico
  - Acceso rápido al conteo total de ejercicios disponibles
  - Creación, actualización y eliminación de ejercicios sin complicaciones
  - Protección de datos: al actualizar un ejercicio, preservamos la unidad a la que pertenece

- **Exercise.java**
  - Modelo que representa cada ejercicio en la plataforma
  - Almacena desde la pregunta hasta la explicación de la respuesta
  - Include información de dificultad y puntos para gamificación
  - Vinculación con lecciones y unidades para mejor organización

- **Tlahtolli_Database_Script**
  - Base de datos lista para gestionar todos los ejercicios
  - Tabla EXERCISES con toda la estructura necesaria
  - Vinculación segura con las unidades de aprendizaje

## [0.0.1] - 2026-01-31 - Componentes Base y Estructura Inicial

### Added

- **ApiTlahtolliAdminDasboardApplication.java**
  - Clase principal de Spring Boot para inicialización de la aplicación
  - Configuración básica de la aplicación

- **Configuración CORS**
  - CorsConfig.java para manejo de solicitudes cross-origin
  - Configuración de orígenes, métodos y headers permitidos

- **Controladores REST**
  - UserController.java: CRUD completo para gestión de usuarios
  - AchievementController.java: Endpoints para logros
  - ExerciseController.java: Gestión de ejercicios
  - LanguageController.java: Administración de idiomas
  - LessonController.java: Control de lecciones
  - LessonHistoryController.java: Historial de lecciones
  - LevelController.java: Niveles de aprendizaje
  - UnitController.java: Unidades de contenido
  - UserStatsController.java: Estadísticas de usuario
  - VocabularyController.java: Vocabulario

- **Entidades JPA**
  - User.java: Modelo de usuario con campos de perfil y progreso
  - Achievement.java: Logros del sistema
  - Exercise.java: Ejercicios de aprendizaje
  - Language.java: Idiomas disponibles
  - Lesson.java: Lecciones
  - LessonHistory.java: Registro histórico
  - Level.java: Niveles
  - Unit.java: Unidades
  - UserStats.java: Estadísticas
  - Vocabulary.java: Vocabulario

- **Repositorios JPA**
  - Interfaces de repositorio para todas las entidades
  - Métodos de consulta básicos y personalizados

- **Configuración de Base de Datos**
  - application.yml con configuración Oracle
  - application.properties para propiedades básicas
  - Script de base de datos en static/Tlahtolli_Database_Script

- **Template Thymeleaf**
  - tlahtolli-dashboard.html para interfaz administrativa

### Changed

- **Dependencias Maven**
  - Spring Boot 3.5.11 con Java 21
  - Oracle JDBC para conectividad de base de datos
  - Lombok para reducción de código boilerplate
  - H2 para pruebas

### Fixed

- Configuración inicial de JPA con dialecto Oracle
- Puerto del servidor configurado en 7575
- CORS habilitado para desarrollo

---

**Nota de versionado**:  
Se sigue el formato `MAYOR.MENOR.PARCHE` donde:

- **MAYOR**: Cambios incompatibles con versiones anteriores
- **MENOR**: Nuevas funcionalidades compatibles
- **PARCHE**: Correcciones de errores