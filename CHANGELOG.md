# CHANGELOG

## [25/04/2025] - Componentes Base y Estructura Inicial

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

## [26/04/2025] - Sistema de Progreso y Perfil

### Componentes

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

## [27/04/2025] - Correcciones y Mejoras

### Mejoras Generales

- Optimización del rendimiento
- Corrección de bugs de interfaz
- Mejoras en el responsive design
- Validación adicional de props
- Refactorización de componentes

## [28/04/2025] - Sistema de Navegación Completo

### Componentes

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

## [29/04/2025] - Refactorización y Componentes de Perfil

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
