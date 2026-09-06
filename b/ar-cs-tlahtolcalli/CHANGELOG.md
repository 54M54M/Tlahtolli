# CHANGELOG (Backend)

----- CTUALIXAR CHANGELOG -----

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