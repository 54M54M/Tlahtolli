# CHANGELOG (Backend)

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