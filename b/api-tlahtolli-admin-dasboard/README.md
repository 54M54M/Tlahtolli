# API Tlahtolli 

## Descripción

La API Tlahtolli es una aplicación backend desarrollada con Spring Boot que proporciona servicios REST para la gestión de datos relacionados con la plataforma de aprendizaje de lenguas indígenas Tlahtolli. Esta API permite la administración de usuarios, lecciones, niveles, vocabulario, estadísticas y otros elementos del sistema de aprendizaje.

## Tecnologías Utilizadas

- **Java**: Versión 21
- **Spring Boot**: 3.5.11
- **Spring Data JPA**: Para la persistencia de datos
- **Base de Datos**: SQL Oracle Database
- **Lombok**: Para reducir código boilerplate
- **Maven**: Gestión de dependencias y construcción

## Requisitos Previos

- Java 21 instalado
- Maven 3.6+
- SQL Oracle Database
- Conexión a base de datos configurada

## Instalación y Ejecución

1. **Clonar el repositorio** (si aplica) o navegar a la carpeta del proyecto.

2. **Configurar la base de datos**:
   - Asegúrate de tener Oracle Database corriendo en `localhost:1521:XE`
   - Usuario: `System`
   - Contraseña: `8520`
   - O modifica `application.yml` para tu configuración.

3. **Ejecutar la aplicación**:
   ```bash
   mvn spring-boot:run
   ```
   O usando el wrapper Maven:
   ```bash
   ./mvnw spring-boot:run
   ```

4. La aplicación estará disponible en `http://localhost:7575`

## Configuración

La configuración principal se encuentra en `src/main/resources/application.yml`:

- **Puerto del servidor**: 7575
- **Base de datos**: Oracle con Hibernate DDL auto en `validate`
- **CORS**: Habilitado para todos los orígenes, métodos y headers

Para entornos de desarrollo, puedes usar H2 cambiando la configuración de datasource.

## Estructura del Proyecto

```
src/
├── main/
│   ├── java/com/tlahtolli/api/
│   │   ├── ApiTlahtolliAdminDasboardApplication.java  # Clase principal
│   │   ├── config/
│   │   │   └── CorsConfig.java                        # Configuración CORS
│   │   ├── controller/                                # Controladores REST
│   │   │   ├── AchievementController.java
│   │   │   ├── ExerciseController.java
│   │   │   ├── LanguageController.java
│   │   │   ├── LessonController.java
│   │   │   ├── LessonHistoryController.java
│   │   │   ├── LevelController.java
│   │   │   ├── UnitController.java
│   │   │   ├── UserController.java
│   │   │   ├── UserStatsController.java
│   │   │   └── VocabularyController.java
│   │   ├── entity/                                    # Entidades JPA
│   │   │   ├── Achievement.java
│   │   │   ├── Exercise.java
│   │   │   ├── Language.java
│   │   │   ├── Lesson.java
│   │   │   ├── LessonHistory.java
│   │   │   ├── Level.java
│   │   │   ├── Unit.java
│   │   │   ├── User.java
│   │   │   ├── UserStats.java
│   │   │   └── Vocabulary.java
│   │   └── repository/                                # Repositorios JPA
│   │       ├── AchievementRepository.java
│   │       ├── ExerciseRepository.java
│   │       ├── LanguageRepository.java
│   │       ├── LessonHistoryRepository.java
│   │       ├── LessonRepository.java
│   │       ├── LevelRepository.java
│   │       ├── UnitRepository.java
│   │       ├── UserRepository.java
│   │       ├── UserStatsRepository.java
│   │       └── VocabularyRepository.java
│   └── resources/
│       ├── application.properties
│       ├── application.yml
│       ├── static/
│       │   └── Tlahtolli_Database_Script
│       └── templates/
│           └── tlahtolli-dashboard.html
└── test/
    └── java/com/tlahtolli/api/
        └── ApiTlahtolliAdminDasboardApplicationTests.java
```

## APIs Disponibles

La API expone endpoints REST bajo el prefijo `/api/`. A continuación, un resumen de los principales controladores:

### Usuarios (`/api/users`)
- `GET /api/users` - Obtener todos los usuarios
- `GET /api/users/count` - Contar usuarios
- `GET /api/users/{id}` - Obtener usuario por ID
- `POST /api/users` - Crear nuevo usuario
- `PUT /api/users/{id}` - Actualizar usuario
- `DELETE /api/users/{id}` - Eliminar usuario

### Lecciones (`/api/lessons`)
- Endpoints CRUD para gestión de lecciones

### Niveles (`/api/levels`)
- Gestión de niveles de aprendizaje

### Vocabulario (`/api/vocabularies`)
- Administración del vocabulario

### Estadísticas de Usuario (`/api/user-stats`)
- Estadísticas y métricas de usuarios

### Logros (`/api/achievements`)
- Sistema de logros

### Ejercicios (`/api/exercises`)
- Gestión de ejercicios

### Idiomas (`/api/languages`)
- Configuración de idiomas

### Unidades (`/api/units`)
- Estructura de unidades de aprendizaje

### Historial de Lecciones (`/api/lesson-histories`)
- Registro del progreso de lecciones

## Modelo de Datos

### Usuario (User)
- `id`: Identificador único
- `username`: Nombre de usuario (único)
- `fullName`: Nombre completo
- `email`: Correo electrónico (único)
- `userLevel`: Nivel actual del usuario
- `xp`: Experiencia actual
- `totalXp`: Experiencia total acumulada
- `streak`: Racha de días consecutivos
- `joinDate`: Fecha de registro
- `currentLang`: Idioma actual

Otras entidades incluyen Achievement, Exercise, Language, Lesson, Level, Unit, UserStats, Vocabulary, LessonHistory, cada una con sus campos específicos para el dominio de aprendizaje de lenguas.

## Base de Datos

- **Producción**: Oracle Database
- **Desarrollo**: H2 Database (incluido en dependencias para pruebas)
- **Script de base de datos**: Disponible en `src/main/resources/static/Tlahtolli_Database_Script`

La configuración JPA está en modo `validate`, lo que significa que las tablas deben existir previamente en la base de datos.

## Pruebas

Ejecutar pruebas con:
```bash
mvn test
```

## Despliegue

Para desplegar en producción:
1. Configurar variables de entorno para la base de datos Oracle
2. Construir el JAR: `mvn clean package`
3. Ejecutar: `java -jar target/api-tlahtolli-admin-dasboard-0.0.1-SNAPSHOT.jar`

## Contribución

Para contribuir al proyecto:
1. Realizar cambios en una rama separada
2. Ejecutar pruebas
3. Asegurar compatibilidad con la base de datos existente

## Licencia

Este proyecto es parte de la plataforma Tlahtolli para el aprendizaje de lenguas indígenas.