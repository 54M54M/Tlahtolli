# CHANGELOG

## [3/NOV/2025] - Restructuración Mayor y Sistema de Componentes

### Nuevos Componentes

- **Sistema de Modales**
  - ExitConfirmModal para confirmación de salida
  - FeedbackModal para retroalimentación
  - WarningModal para avisos importantes
  - Mejor manejo de estados modales

- **Sistema de Progreso**
  - ProgressBar con animaciones fluidas
  - DialectProgress para seguimiento por variante
  - Badge para indicadores visuales
  - LearningStats con métricas detalladas

  ### Mejoras en Arquitectura

  - **Sistema de Datos**
    - Nueva estructura de modelos
      - Achievement para sistema de logros
      - DictionaryEntry para entradas léxicas
      - Exercise para sistema de ejercicios
      - Level y Unit para estructura de contenido
    - Mejor organización de datos por módulos

  - **Sistema de Repositorios**
    - DictionaryRepository para gestión léxica
    - LearningRepository para contenido educativo
    - StatsRepository para métricas de usuario
    - UserRepository para gestión de perfiles
    - SyllabaryRepository para los sistemas de escritura

### Servicios y Lógica

- **Servicios Core**
  - AchievementService para sistema de logros
    - Gestión de logros y recompensas
    - Seguimiento de hitos y desbloqueos
    - Notificaciones de nuevos logros
    - Integración con StatsRepository
  - LanguageService para gestión lingüística
    - Procesamiento de texto y variantes
    - Validación gramatical y ortográfica
    - Análisis de pronunciación
    - Integración con diccionario
  - ProgressService para seguimiento
    - Control de avance por niveles
    - Métricas de aprendizaje
    - Sincronización con UnlockService
    - Persistencia de progreso
  - StudyService para lógica de aprendizaje
    - Generación de ejercicios
    - Evaluación de respuestas
    - Adaptación de dificultad
    - Retroalimentación personalizada
  - UnlockService para progresión de contenido
    - Gestión de requisitos y desbloqueo de niveles/unidades
    - Validación de progreso y sincronización con ProgressService
    - Soporte para reglas de desbloqueo por variante y logros
  - SpeechService/TTS para ejemplos de pronunciación y retroalimentación auditiva; integración con LanguageService

- **Sistema de Almacenamiento**
  - LocalStorageService optimizado
  - Mejor persistencia de datos
  - Sistema de caché mejorado
  - Manejo eficiente del estado

### Vistas y Navegación

- **Vistas Principales**
  - GlossaryView con tres subsecciones (silabario, banco de palabras, diccionario)
  - HomeView rediseñada
  - ProfileView con estadísticas detalladas
  - StatsView para métricas globales

- **Sistema de Layout**
  - DesktopAside mejorado
  - Layout.vue más flexible
  - MobileNav optimizado
  - vHeader con mejor adaptabilidad

### Configuración y Utilidades

- **Configuración**
  - Sistema de rutas optimizado
  - Store de autenticación mejorado
  - Configuración de Vite actualizada
  - Sistema de tipos TypeScript

- **Estilos**
  - Implementación completa de Tailwind
  - Sistema de colores para dialectos
  - Mejoras en responsividad
  - Optimización de interfaces

## [27/OCT/2025] - Mejoras en la Interfaz y Experiencia de Usuario

### Nuevos Componentes

- **LoadingStates**
  - Nuevo sistema de carga para VariantSelection
  - Indicadores de estado para inicialización
  - Animaciones de spinner optimizadas
  - Mensajes de carga contextuales

### Mejoras

- **Sistema de Autenticación**
  - Nuevo estado de inicialización
  - Mejor manejo de variantes dialectales
  - Sistema de redirección inteligente
  - Optimización de estados de carga

- **Interfaz de Usuario**
  - Mejoras en responsividad
  - Optimización de márgenes y padding
  - Mejor manejo de altura de pantalla
  - Ajustes en componentes móviles

- **ProgressAside**
  - Nuevo diseño de estados de carga
  - Mejor integración con variantes
  - Sistema de scroll optimizado
  - Ajustes dinámicos de altura

- **Layout System**
  - Mejoras en el sistema de grid
  - Optimización de espaciado
  - Mejor manejo de alturas dinámicas
  - Ajustes en breakpoints responsive

### Datos y Configuración

- **Estados de Aplicación**
  - Nuevo sistema de manejo de estados
  - Mejor control de inicialización
  - Optimización de persistencia
  - Mejora en transiciones de estado

- **Configuración de Componentes**
  - Actualización de props y eventos
  - Mejor manejo de valores por defecto
  - Optimización de renderizado
  - Sistema de fallbacks mejorado

## [17/OCT/2025] - Vista de Estadísticas y Mejoras de Componentes

### Nuevos Componentes

- **StatsView**
  - Nueva vista dedicada para estadísticas de aprendizaje
  - Integración completa con ProgressAside
  - Diseño responsive con header específico para móviles
  - Easter egg para usuarios de escritorio

### Mejoras en Componentes Existentes

- **LearningStats**
  - Sistema de colores dinámico basado en valores
  - Emojis de recompensa para rachas (🏆 para lecciones perfectas, 🔥 para días estudiados)
  - Lógica de visualización condicional para rachas >= 3
  - Mejor presentación de valores numéricos

- **MobileNav**
  - Nueva opción de navegación "Estadísticas"
  - Icono de gráficas integrado
  - Mantenimiento de estructura existente

- **ProgressAside**
  - Rediseño completo del layout
  - Sistema de scroll mejorado sin barras visibles
  - Mejor organización del espacio
  - Separación clara de secciones

### Mejoras Generales

- **Sistema de Navegación**
  - Nueva ruta `/estadisticas` añadida al router
  - Reorganización de rutas existentes
  - Mejor estructura de navegación móvil

- **Datos y Configuración**
  - Actualización de estadísticas en data.js
  - Incremento de lecciones completadas (12 → 15)
  - Mejor organización de datos estadísticos

- **Ajustes de UI/UX**
  - Corrección de márgenes y padding en múltiples vistas
  - Mejoras en el responsive design
  - Optimización del espacio en pantalla
  - Ajustes en la vista Home para mejor alineación

## [16/OCT/2025] - Sistema de Identidad Visual y Expansión del Glosario

### Nuevos Componentes

- **IdentitySystem**
  - Nuevo sistema de favicon y íconos
  - Soporte para PWA con manifest
  - Iconografía adaptativa para diferentes plataformas
  - Mejora en la identidad visual

- **GlossaryData**
  - Estructura completa de datos del glosario
  - Sistema de categorización detallado
  - Ejemplos y traducciones contextuales
  - Soporte para múltiples variantes dialectales

- **SyllabarySystem**
  - Implementación completa del silabario náhuatl
  - Sistema interactivo de visualización
  - Documentación detallada de pronunciación
  - Integración con ejemplos del diccionario

### Mejoras

- **Sistema de Navegación**
  - Simplificación de la estructura de rutas
  - Actualización de nombres y enlaces
  - Ocultamiento temporal de secciones en desarrollo
  - Mejora en la experiencia de usuario

- **Datos y Estructura**
  - Reorganización del sistema de archivos
  - Separación de datos en módulos específicos
  - Mejora en la estructura de datos dialectales
  - Sistema más mantenible y escalable

- **Interfaz de Usuario**
  - Nuevo diseño del silabario interactivo
  - Sistema de ejemplos contextual
  - Mejoras en la visualización de datos
  - Optimización de componentes visuales

- **Sistema de Colores**
  - Actualización de la paleta de colores dialectal
  - Mejora en el contraste y accesibilidad
  - Sistema de colores más consistente
  - Optimización de identificadores visuales

### Datos y Configuración

- **Manifest**
  - Configuración completa de PWA
  - Soporte para múltiples tamaños de íconos
  - Mejora en la experiencia de instalación
  - Sistema de caché optimizado

- **Assets**
  - Nuevos recursos gráficos e íconos
  - Sistema de favicon adaptativo
  - Imágenes optimizadas para web
  - Recursos para diferentes plataformas

## [15/OCT/2025] - Refactorización y Mejoras del Sistema de Glosario

### Nuevos Componentes

- **GlossaryView**
  - Nueva vista unificada para diccionario y silabario
  - Sistema de tabs para navegación entre secciones
  - Integración con variantes dialectales
  - Diseño responsive mejorado

- **DictionaryContent**
  - Componente modular para el diccionario
  - Búsqueda y filtrado mejorados
  - Soporte para múltiples variantes
  - Sistema de pronunciación integrado

- **SyllabaryContent**
  - Nuevo componente para el silabario náhuatl
  - Diseño de grid interactivo
  - Notas y explicaciones detalladas
  - Visualización clara de sílabas

### Mejoras

- **Sistema de Navegación**
  - Actualización de rutas y nombres
  - Simplificación de la estructura
  - Mejor integración con el sistema de variantes
  - Optimización de la experiencia móvil

- **Datos y Estructura**
  - Separación de datos en archivos modulares
  - Nueva estructura para entradas del diccionario
  - Implementación del silabario completo
  - Mejora en la organización del código

- **Interfaz de Usuario**
  - Diseño más limpio y moderno
  - Mejor uso del espacio en pantalla
  - Optimización de componentes visuales
  - Mejora en la accesibilidad

- **Sistema de Ejercicios**
  - Refactorización de la generación de ejercicios
  - Mejor manejo de datos de unidades
  - Optimización de la lógica de preguntas
  - Sistema más flexible y mantenible

### Datos y Configuración

- **Diccionario**
  - Nuevo sistema de organización de datos
  - Mejor estructura para variantes dialectales
  - Sistema de categorización mejorado
  - Soporte para ejemplos y pronunciación

- **Silabario**
  - Nueva estructura de datos completa
  - Sistema de notas y explicaciones
  - Mejor organización de sílabas
  - Documentación de casos especiales

## [14/OCT/2025] - Refactorización y Mejoras de Sistema

### Actualizacion de Componentes

- **VariantSelection**
  - Nueva interfaz para selección de variante
  - Visualización de variante actual
  - Mejor UX para cambio de variantes
  - Integración con sistema de autenticación

- **LessonView**
  - Rediseño completo de la interfaz
  - Mejor organización vertical del contenido
  - Soporte para imágenes placeholder
  - Mejoras en presentación de ejercicios

- **LevelView**
  - Sistema de bloqueo de niveles y unidades
  - Visualización de requisitos de desbloqueo
  - Mejoras visuales en la presentación
  - Integración con sistema de progreso

### Mejoras

- **Navegación y Layout**
  - Rediseño completo de DesktopAside
  - Nuevo diseño de información de usuario
  - Mejora en elementos de navegación
  - Optimización de botón de cerrar sesión

- **Sistema de Autenticación**
  - Implementación de guardias de ruta
  - Mejora en manejo de estados
  - Control de acceso por variante
  - Redirecciones inteligentes

- **ProgressAside**
  - Badge de variante activa
  - Integración con sistema dialectal
  - Mejoras visuales en estadísticas
  - Nuevo diseño de variante seleccionada

- **vHeader**
  - Tres variantes optimizadas
  - Mejor integración con variantes
  - Manejo mejorado de estados
  - Diseño más consistente

### Datos y Configuración

- **Data.js**
  - Expansión de variantes dialectales
  - Nuevos campos para niveles
  - Reorganización de ejercicios
  - Mejora en estructura de progreso

- **Estilos**
  - Actualización de paleta de colores
  - Mejoras en responsive design
  - Nuevos estados visuales
  - Optimización de transiciones

## [29/ABR/2025] - Refactorización y Componentes de Perfil

### Nuevos Componentes

- **SettingsPanel**
  - Panel de preferencias de usuario
  - Configuración de dialecto, sonido, etc.
  - Emisión de eventos para actualización

- **AchievementsList**
  - Listado de logros desbloqueados
  - Diseño con cards
  - Manejo de estado vacío

- **DialectProgress**
  - Progreso por variante dialectal
  - Barras de progreso coloreadas
  - Integración con datos globales

### Mejoras

- Refactorización completa de ProfileView
  - Mejor organización por componentes
  - Lógica de pestañas optimizada
  - Detección responsive mejorada

- Actualización de ProgressAside
  - Integración con nuevos componentes
  - Mejor estructura de datos

- Mejoras en Tab component
  - Mejor manejo de responsive
  - Estilos optimizados

## [28/ABR/2025] - Sistema de Navegación Completo

- **DesktopAside**
  - Barra lateral izquierda para desktop
  - Navegación con iconos SVG
  - Resaltado de ruta activa

- **MobileNav**
  - Barra inferior para móviles
  - Ocultamiento condicional
  - Efectos hover y estados activos

- **ProgressAside**
  - Barra lateral derecha para progreso
  - Integración de LearningStats y DialectProgress
  - Diseño fijo

## [27/ABR/2025] - Correcciones y Mejoras

### Mejoras Generales

- Optimización del rendimiento
- Corrección de bugs de interfaz
- Mejoras en el responsive design
- Validación adicional de props
- Refactorización de componentes

## [26/ABR/2025] - Sistema de Progreso y Perfil

- **ProgressBar**
  - Barra de progreso dinámica
  - Cálculo automático de porcentaje
  - Color personalizable

- **UserProfile**
  - Tarjeta de perfil de usuario
  - Muestra nivel y progreso (XP)
  - Badge de nivel
  - Diseño responsive

- **LearningStats**
  - Estadísticas de aprendizaje
  - Grid de 4 métricas clave
  - Diseño con cards

## [25/ABR/2025] - Componentes Base y Estructura Inicial

### Creación del Proyecto

- Inicializado con Vite + Vue.js (JavaScript)
- Configuración de Tailwind CSS v3.4.17
- Estructura base de archivos:
  - App.vue
  - Router/index.js
  - Layout.vue
  - Vistas principales: Home, Dictionary, Map

### Componentes Base

- **Badge**
  - Componente reutilizable para etiquetas
  - Estilo con Tailwind CSS
  - Soporta contenido dinámico via slots

- **Tab**
  - Sistema de pestañas navegables
  - Implementación con Composition API
  - Validación de props
  - Diseño responsive

- **vHeader**
  - Cabecera multipropósito con 3 variantes
  - Props personalizables (color, rutas, progreso)
  - Diseño fijo para scroll
