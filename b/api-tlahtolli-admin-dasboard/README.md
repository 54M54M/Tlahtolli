# ar-cs-tlahtolcalli

API REST desarrollada con Spring Boot para la gestión de datos de la plataforma de aprendizaje de lenguas indígenas **Tlahtolcalli**. Expone servicios para administrar usuarios, lecciones, niveles, vocabulario, estadísticas y progreso de aprendizaje.

---

## Nomenclatura del Proyecto

El nombre del proyecto sigue la convención estándar del equipo:

```
{tipo}-{dominio}-{servicio}
```

| Segmento       | Valor           | Significado                                       |
|----------------|-----------------|---------------------------------------------------|
| `ar`           | tipo            | Nomenclatura interna para servicios REST API      |
| `cs`           | dominio         | Namespace del equipo / área de negocio            |
| `tlahtolcalli` | servicio        | Nombre del sistema (náhuatl: "casa de la lengua") |

### Convención de prefijos

| Prefijo | Cuándo usarlo                                                                    |
|---------|----------------------------------------------------------------------------------|
| `ar`    | Servicio que **expone endpoints REST** para ser consumido por clientes           |
| `ms`    | Microservicio con **lógica de negocio propia**, colas, workers, schedulers, etc. |

Este proyecto usa el prefijo `ar` porque su responsabilidad es exclusivamente exponer y gestionar datos vía HTTP.

---

## Tecnologías

| Tecnología        | Versión  |
|-------------------|----------|
| Java              | 21       |
| Spring Boot       | 3.5.11   |
| Spring Data JPA   | —        |
| PostgreSQL        | —        |
| Lombok            | —        |
| Maven             | 3.6+     |

---

## Requisitos Previos

- Java 21
- Maven 3.6+
- PostgreSQL corriendo en `localhost:5432`

---

## Configuración de Base de Datos

Las credenciales están centralizadas en `Constants.java` y son inyectadas programáticamente por `SQLConfig.java`. **No se configuran en `application.properties`**.

```
src/main/java/com/tlahtolli/api/config/
├── Constants.java   ← credenciales hardcodeadas aquí
└── SQLConfig.java   ← construye el DataSource usando Constants
```

Para cambiar la base de datos, edita únicamente `Constants.java`:

```java
public static final String DB_URL      = "jdbc:postgresql://localhost:5432/postgres";
public static final String DB_USERNAME = "postgres";
public static final String DB_PASSWORD = "12345";
public static final String DB_DRIVER   = "org.postgresql.Driver";
```

---

## Configuración Principal (`application.properties`)

```properties
spring.application.name=api-cs-tlahtolcalli

spring.jpa.hibernate.ddl-auto=validate
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true

server.port=7575
```

> `application.yml` existe en el proyecto pero **no se usa**. El archivo principal es `application.properties`.

> `ddl-auto=validate` significa que las tablas deben existir previamente en la base de datos. Hibernate no las crea ni modifica.

---

## Ejecución

```bash
mvn spring-boot:run
```

La aplicación estará disponible en `http://localhost:7575`

---

## Estructura del Proyecto

```
src/
├── main/
│   ├── java/com/tlahtolli/api/
│   │   ├── tlahtolli.java                 # Clase principal (@SpringBootApplication)
│   │   ├── config/
│   │   │   ├── Constants.java             # Credenciales de base de datos
│   │   │   ├── SQLConfig.java             # Configuración del DataSource
│   │   │   └── CorsConfig.java            # Configuración CORS
│   │   ├── controller/                    # Controladores REST
│   │   ├── dto/
│   │   │   ├── request/                   # DTOs de entrada
│   │   │   └── response/                  # DTOs de salida
│   │   ├── entity/                        # Entidades JPA
│   │   ├── repository/                    # Repositorios JPA
│   │   └── service/                       # Lógica de negocio
│   └── resources/
│       ├── application.properties         # Configuración principal ✅
│       ├── application.yml                # No se usa ❌
│       └── static/
│           └── Migracion/                 # Scripts SQL de base de datos
└── test/
    └── java/com/tlahtolli/api/
```

---

## Endpoints Disponibles

Todos los endpoints están bajo el prefijo `/api/`.

| Recurso              | Ruta                    |
|----------------------|-------------------------|
| Usuarios             | `/api/users`            |
| Niveles              | `/api/levels`           |
| Unidades             | `/api/units`            |
| Lecciones            | `/api/lessons`          |
| Ejercicios           | `/api/exercises`        |
| Vocabulario          | `/api/vocabularies`     |
| Idiomas              | `/api/languages`        |
| Logros               | `/api/achievements`     |
| Estadísticas         | `/api/user-stats`       |
| Historial lecciones  | `/api/lesson-histories` |

---

## Scripts de Base de Datos

Ubicados en `src/main/resources/static/Migracion/`, deben ejecutarse en orden:

```
1.-Tlahtolli_Database_Script.sql   ← estructura de tablas
2.-General_Seed_Data.sql           ← datos base generales
3.-Nahuatl_Seed_Data.sql           ← datos de náhuatl
4.-Teenek_Seed_Data.sql            ← datos de teenek
```

---

## Build y Despliegue

```bash
# Compilar y empaquetar
mvn clean package

# Ejecutar el JAR
java -jar target/ar-cs-tlahtolcalli-0.0.1-SNAPSHOT.jar
```

---

## Licencia

Este proyecto es parte de la plataforma **Tlahtolcalli** para el aprendizaje de lenguas indígenas.
