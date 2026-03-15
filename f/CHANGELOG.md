# CHANGELOG (Frontend)

## [3.5.2] - 2026-01-31 - Ajustes de UI y mejoras en el flujo de energía

### Added

- **NoEnergyModal.vue**
  - Modal adaptativo rediseñado con conteo dinámico de botones (ref + setup)
  - Clases de grid condicionales
  - Nuevos emits para flujo fino (proceed-without-energy)
  - Mejora de experiencia en desktop (iconos redimensionados y estilos responsive)

- **vHeader.vue**
  - Badge de energía para escritorio (SVG)
  - Render distinto para desktop/mobile
  - Mejora visual y datos reactivos desde el store de energía

- **HomeView.vue**
  - Integración de useEnergyStore
  - Inicialización de energía al montar la vista antes de cargar niveles

### Changed

- **NextStage.vue**
  - Ajustes de espaciado/padding
  - Mejoras en clases para responsividad

- **NoEnergyModal.vue**
  - Correcciones de copy (acentos)
  - Reorganización del layout (botón principal arriba; botones inferiores en grid condicional)
  - Microajustes de textos y mensajes informativos

- **vHeader.vue**
  - Reordenamiento y ajustes de tamaños
  - Truncamientos y layout mejorados
  - Separación clara de comportamiento desktop/mobile

- **Layout.vue**
  - Pequeño ajuste de spacing en el main (se añadió mb-2)

- **HomeView.vue**
  - Ajustes de márgenes/espaciado
  - Retorno de energyStore en setup

- **SyllabaryContent.vue**
  - Ajuste de margen inferior del panel informativo

- **LessonView.vue**
  - Ajustes de mensajes/console logs
  - Simplificación de streakBonus para evitar texto duplicado en feedback

- **LevelView.vue**
  - Correcciones de márgenes
  - Formateo del componente NextStage

- **QuickLevelView.vue**
  - Sincronización con la lógica de energía (igual que LessonView)
  - Simplificación de streakBonus
  - Reordenamiento de inicialización

### Fixed

- **NoEnergyModal.vue**
  - Corrección en la lógica de conteo y visibilidad de botones
  - Manejo de Escape y limpieza de listeners
  - Corrección de textos ("energía")

- **HomeView.vue**
  - Asegurada inicialización de energía antes de cargar niveles para evitar condiciones de carrera

- **LessonView.vue y QuickLevelView.vue**
  - Ajustes en flujo de energía y mensajes de feedback para evitar inconsistencias visuales
  - Limpieza de logs innecesarios

## [3.5.1] - 2025-12-18 - Mejoras en Sistema de Energía

### Added

- **Sistema de verificación de energía en lecciones**
  - Actualización de `NoEnergyModal.vue` para manejar dos tipos de modal:
    - 'insufficient': cuando el usuario tiene < 10⚡ antes de iniciar
    - 'depleted': cuando la energía llega a 0⚡ durante la lección
  - Verificación de energía mínima (10⚡) antes de cargar lección
  - Monitoreo de energía en tiempo real cada 2 segundos durante la lección
  - Modal automático cuando la energía llega a 0
  - Limpieza de intervals al salir de la lección

### Changed

- **LecciónView.vue**
  - Definición correcta del método `startLesson()` en el objeto methods
  - Centralización de la lógica de inicio de lección en un solo método
  - Agregado campo `lessonEndTime` para capturar tiempo exacto de finalización
  - Agregado método `completePartialLesson()` para manejar progreso parcial
  - Mejorado `handleEnergyDepleted()` con prevención de llamadas múltiples
  - Simplificado `closeNoEnergyModal()` para usar `startLesson()`
  - Agregado `watch` para `lessonStartTime` para depuración
  - Reemplazo de `this.$once` por `beforeUnmount()` para compatibilidad con Vue 3
  - Uso de `data()` para almacenar referencias de event listeners

- **QuickLevelView.vue**
  - Adaptación de la misma lógica de verificación de energía
  - Prevención de inicio de nivel rápido sin energía suficiente
  - Detección de agotamiento durante ejercicios
  - Corrección de tipo de modal cuando usuario inicia con 0 energía

- **NoEnergyModal.vue**
  - Modal adaptativo con colores e íconos según contexto
  - Mensajes personalizados por situación
  - Opciones para volver o practicar para recuperar energía
  - Delay de 1.5s antes de mostrar modal para ver resultado
  - Agregado `watcher` para monitorear cambios de tipo de modal

### Fixed

- **Corrección del timer de lección**
  - Timer ahora funciona tanto con energía suficiente como después del modal
  - Timer se congela correctamente cuando:
    - La energía llega a 0 durante la lección
    - Se completa la lección normalmente
    - Se presiona 'Seguir adelante' con 0 de energía

- **Corrección de bugs de energía**
  - Modal de energía ahora se muestra correctamente al llegar a 0
  - Timer ya no se buguea cuando se agota la energía
  - Botón 'Seguir adelante' ahora redirige correctamente

- **Corrección de tipo de modal de energía**
  - Diferenciación entre energía insuficiente (>0 pero <10) y energía agotada (0)
  - ModalType='depleted' cuando `currentEnergy === 0`
  - ModalType='insufficient' cuando `0 < currentEnergy < requiredEnergy`
  - Usuario con 0 energía ahora ve modal 'depleted' (antes veía 'insufficient')

- **Mejoras en UX y depuración**
  - Mejor logging para depuración del flujo del timer
  - Verificación inmediata de energía después de consumirla en `verifyAnswer()`
  - Prevención de que `continueFromModal()` avance si `lessonInProgress` es false
  - Redirección automática en `closeNoEnergyModal()` si energía está en 0
  - Limpieza correcta de intervals en `handleEnergyModalReturn()`
  - Asegurada limpieza completa en `beforeUnmount()`

## [3.5.0] - 2025-12-17 - Sistema de Energía Globalmente Sincronizado

### Added

- **Store Centralizado de Energía (Pinia)**
  - Nuevo store `stores/energy.js` para manejo centralizado de energía
  - Sistema de persistencia automática en localStorage
  - Getters reactivos para acceso a datos de energía
  - Métodos para consumir, recuperar y sincronizar energía
  - Sistema de rachas para bonificaciones por aciertos consecutivos
  - Recuperación pasiva de energía basada en tiempo transcurrido

- **Arquitectura**
  - Pinia store con persistencia plugin para gestión de estado
  - Clase `Energy` como modelo de datos centralizado
  - Actualizaciones event-driven entre componentes
  - Computed properties en componentes + getters en store

### Changed

- **App.vue**
  - Inicialización del store de energía al cargar la aplicación
  - Sincronización de energía desde localStorage al inicio

- **LessonView.vue - QuickLevelView.vue**
  - Eliminado EnergyService local y reemplazado con store global
  - Actualizada función `verifyAnswer()` para usar `energyStore.consumeForExercise()`
  - Datos de energía pasados al vHeader desde el store global
  - Simplificado manejo de cambios de energía
  - Actualizado Header con datos del store

- **vHeader.vue**
  - Importación y uso del store de energía para datos reactivos
  - Eliminada energía local y uso de computed properties del store
  - Template preparado para animaciones de cambios de energía

### Removed

- Instancias locales de EnergyService en componentes
- Lógica duplicada de inicialización de energía
- Variables de estado de energía redundantes

### Fixed

- **Sincronización Global de Estado**
  - Un solo punto para el estado de energía
  - Cambios en energía se propagan automáticamente a todos los componentes
  - Eliminadas inconsistencias entre diferentes vistas

- **Persistencia de Datos**
  - Energía se mantiene entre recargas de página
  - Estado conservado después de cerrar/reabrir navegador
  - Serialización JSON robusta en localStorage

## [3.4.0] - 2025-12-11 - Rediseño Responsivo de VariantSelection

### Added

- **Diseño Mobile Mejorado para VariantSelection**
  - Reorganización completa del layout para dispositivos móviles
  - Implementación de diseño full-screen en mobile con `h-full` y `w-full`
  - Mantenimiento de diseño original centrado y con dimensiones fijas para desktop
  - Padding y márgenes ajustados específicamente para cada tipo de dispositivo

### Changed

- **VariantSelection.vue**
  - Reestructuración del contenedor principal
  - Reorganización del header
  - Añadido separador visual (`border-t border-gray-700`) entre header y contenido
  - Ajustes de padding

- **Mejoras en la Experiencia de Usuario Mobile**
  - Área de contenido central con scroll independiente

### Fixed

- **Problemas de Layout en Dispositivos Móviles**
  - Solucionado problema de contenido que no ocupaba toda la altura disponible
  - Corregido espaciado excesivo que reducía el área visible
  - Mejorada la accesibilidad del botón de retroceso en pantallas pequeñas

- **Consistencia Visual entre Dispositivos**
  - Mantenida la identidad visual del diseño desktop original
  - Asegurada coherencia en colores, tipografía y elementos interactivos
  - Preservada la funcionalidad completa en ambos tipos de dispositivos

## [3.3.2] - 2025-12-06 - Reorganización de Familias Lingüísticas y Mejoras de Selección

### Added

- **Sistema de Grupos de Idiomas Desplegables**
  - Reorganizar estructura jerárquica de idiomas en LanguageConfig.js
  - Se creo el componente `LanguageGroupSelector.vue` con menús desplegables
  - Añadir información educativa sobre familias lingüísticas

- **Nuevas Funcionalidades de UI**
  - Expandir grupos por defecto y mantener estado de selección
  - Optimizar responsive design y scroll para móviles

### Changed

- **VariantSelection.vue**
  - Integración del componente `LanguageGroupSelector` como sistema principal
  - Deshabilitar botón CONTINUAR hasta selección explícita de idioma
  - Mejorar UX forzando selección explícita del usuario

- **LanguageGroupSelector.vue**
  - Simplifico a diseño dinámico con `v-for` para grupos lingüísticos
  - Se creo propiedad computada `languageGroups` que obtiene datos desde `LanguageService`
  - Implemento función `getGroupFlag` para emoji dinámico en encabezados
  - Reemplazo bloques HTML estáticos con renderizado dinámico
  - Redujo código duplicado y mejorar mantenibilidad

### Fixed

- **Corrección de Bugs en VariantSelection**
- Corregio bug que permitía continuar sin selección de idioma
- Mejoro validación de selección con mensaje informativo
- Mantuvo compatibilidad con selecciones previas en `authStore`

- **Mejoras de Mantenibilidad**
- Elimino necesidad de modificar componente al agregar nuevas familias
- Centralizo configuración de grupos en `LanguageService`
- Facilitar escalabilidad para futuras familias lingüísticas

## [3.3.1] - 2025-11-30 - Mejoras en Sistema de Finalización y Desbloqueo

### Added

- **"Mensaje de finalizacion" Mejorado**
  - Layout responsive
  - Sistema de mensajes basado en rendimiento
  - Sistema de mensajes basado en tiempo
  - Cálculo dinámico de EXP con bonos por rendimiento y tiempo
  - Integración de temporizador de lección en LessonView y QuickLevelView
  - Jerarquía visual mejorada con codificación de colores consistente

### Changed

- **Sistema de Desbloqueo de Niveles**
  - QuickLevelService.js modificado para requerir >=80% de rendimiento
  - Solo completar unidades y desbloquear siguiente nivel cuando performance >= 0.8
  - Mantener entrega de XP pero evitar completar unidades si rendimiento es bajo
  - Log de rendimiento insuficiente cuando no se cumple el 80%

- **Ocultamiento de Header**
  - Header se oculta completamente durante pantalla de finalización
  - Condiciones v-if agregadas en QuickLevelView.vue y LessonView.vue
  - Header visible solo durante la lección, oculto en CompletionMessage

### Fixed

- Prevención de desbloqueo automático de siguiente nivel con rendimiento bajo
- Mejora de experiencia visual en pantallas de finalización
- Compatibilidad hacia atrás con secciones existentes de desbloqueo

## [3.3.0] - 2025-11-25 - Sistema de Imágenes de Personajes y Mejoras Visuales

### Added

- **Componente ExerciseImage**
  - Sistema dinámico de imágenes de personajes basado en estado de respuesta
  - Dos modos emocionales: correcto/feliz-neutro vs incorrecto/triste-enojado
  - Mapeo de nombres de personajes para consistencia
  - Sistema de fallbacks con placeholder para imágenes faltantes
  - Normalización de nombres de personajes con CHARACTER_MAP

- **Asignación de Personajes a Ejercicios**
  - Propiedad `character` agregada a ejercicios para asignación específica

- **Expansión de Vocabulario**
  - Nuevas palabras agregadas al sistema léxico
  - Correcciones y mejoras en definiciones existentes

### Changed

- **LessonView y QuickLevelView**
  - Integración del componente ExerciseImage para mostrar personajes
  - Reemplazo de imágenes placeholder estáticas por sistema dinámico
  - Mejora en la experiencia visual durante ejercicios

- **Estructura de Ejercicios**
  - Propiedad `character` añadida para personalización visual
  - Default value para ejercicios sin asignación específica

### Fixed

- **Correcciones de Bugs Visuales**
  - Problemas de layout en interfaces de lección
  - Mejora en la responsividad de componentes
  - Optimización del espaciado y alineación

- **Manejo de Errores**
  - Sistema robusto de fallbacks para imágenes faltantes
  - Logging de errores para debugging de asignación de personajes
  - Normalización de nombres para prevenir errores de carga

## [3.2.1] - 2025-11-20 - Actualización de Vocabulario y Corrección de Ejercicios

### Added

- **Vocabulario Expandido**
  - Agregadas palabras faltantes: "Cencalli", "Notahtli", "Motahtli", "Nonantli", "Monantli"
  - Nuevas formas verbales: "Nicochiz", "Xicochih", "Mitz"
  - Mejora en la cobertura léxica del náhuatl

### Changed

- **Ejercicios de Nivel 6**
  - Actualizados ejercicios de peticiones y órdenes para mayor consistencia
  - Mejoradas explicaciones y placeholders en ejercicios
  - Mantenida funcionalidad de herencia de vocabulario entre niveles

### Fixed

- **Corrección de Bugs**
  - Solucionado bug en ejercicios fill-blanks que causaba errores en la UI (EN PROCESO)
  - Corregidos errores en ejercicios problemáticos
  - Mejorada consistencia en traducciones y pronunciaciones
  - Optimizado el procesamiento de vocabulario contextual

- **Mejoras de Calidad**
  - Validación mejorada de respuestas en ejercicios
  - Consistencia en el formato de vocabulario entre niveles
  - Corrección de discrepancias en datos de ejercicios

## [3.2.0] - 2025-11-15 - Sistema Completo de Lecciones Mejoradas

### Added

- **Componentes de Procesamiento de Texto y Tooltips**
  - `ProcessedText.vue`: Componente para procesar texto con vocabulario contextual
    - Segmentación inteligente de texto con detección de palabras
    - Manejo de coincidencias exactas, parciales y por palabras individuales
    - Comparación de palabras individuales para frases compuestas
    - Búsqueda en traducción con normalización avanzada

  - `PronunciationTooltip.vue`: Tooltips interactivos con información de vocabulario
    - Posicionamiento dinámico (top/bottom) según espacio disponible
    - Muestra pronunciación con formato especial
    - Estilos adaptativos según estado del ejercicio (correcto/incorrecto)
    - Sistema de highlight con bordes punteados para palabras con tooltip
    - Animaciones suaves con transiciones CSS
    - Backdrop blur para efecto glassmorphism
    - Flecha dinámica del tooltip según posición
    - Prevención de desbordamiento de pantalla
    - Detección automática de espacio vertical disponible

- **Componente de Navegación entre Niveles**
  - `NextStage.vue`: Componente para mostrar siguiente nivel
    - Información del próximo nivel con estado de bloqueo
    - Integración con LearningRepository para validación

- **Sistema de Prevención de Recarga**
  - `preventReload.js`: Mixin global para prevenir pérdida de progreso
    - Prevención de teclas F5, Ctrl+R, Cmd+R
    - Prevención de pull-to-refresh en móviles
    - Prevención de gestos de navegación (swipe)

- **Componentes de Progreso Mejorados**
  - `ProgressAside.vue`: Sidebar de progreso optimizado
    - Loading state mientras carga idioma
    - Progreso de idioma con porcentaje calculado

  - `DialectProgress.vue`: Componente de progreso de idioma
    - Formateo de porcentaje a 2 decimales

- **Validación de Respuestas Mejorada**
  - `Exercise.js`: Modelo con validación avanzada
    - Campo answer agregado para respuestas
    - validateAnswer con soporte para arrays en correctAnswer
    - Comparación case-insensitive para fill-blank
    - Soporte para múltiples respuestas correctas
    - Manejo de respuestas parciales

  - `StudyService.js`: Servicio mejorado de estudio
    - evaluateSession delegando a validateAnswer del Exercise
    - Soporte para arrays de respuestas correctas
    - Validación mejorada de ejercicios fill-blank
    - Manejo de diferentes tipos de ejercicios

### Changed

- **Layout y Navegación**
  - `Layout.vue`: Layout principal con preventReload
    - Mixin preventReload aplicado
    - Loading state mientras inicializa idioma

  - `router/index.js`: Rutas con meta hideNav
    - Meta hideNav para Leccion y NivelRapido
    - Guards de autenticación mejorados

- **Estilos y UX**
  - `style.css`: Estilos mejorados para lecciones
    - Prevención de overscroll behavior en móviles
    - Scrollbars ocultos en toda la aplicación
    - Tap highlight desactivado para mejor UX móvil
    - Height 100vh para evitar problemas de scroll

- **Características de ProcessedText**
  - Procesamiento inteligente de vocabulario
    - Segmentación por espacios y puntuación
    - Mantiene estructura original del texto
    - Detecta palabras vs espacios/puntuación
    - Asigna información de vocabulario a cada palabra
    - Maneja arrays y objetos de vocabulario
  - Búsqueda avanzada en vocabulario
    - Búsqueda parcial para palabras similares
    - Comparación case-insensitive
    - Normalización de acentos y caracteres especiales
    - División de frases para buscar palabras individuales
    - Filtro de palabras cortas (> 2 caracteres)

- **Características de PronunciationTooltip**
  - Sistema de tooltip avanzado
    - Cálculo dinámico de posición según viewport
    - Ancho mínimo y máximo configurables
  - Estados visuales
    - Transiciones suaves entre estados
  - Animaciones
    - Fade in/out con opacity
    - Scale 95-100% para efecto de zoom
    - Translate-y para movimiento suave
    - Duración 300ms con cubic-bezier
  - Contenido del tooltip
    - Pronunciación en formato destacado

- **Características de NextStage**
  - Integración con repositorios
    - Obtiene datos del siguiente nivel
    - Valida estados de bloqueo

- **Características del Sistema de Prevención**
  - Prevención en múltiples niveles
    - Eventos de teclado (keydown)
    - Eventos de navegador (beforeunload)
    - Eventos táctiles en móviles
    - Gestos de navegación
  - Estado de lección activa
    - Flag lessonInProgress
    - Control de flujo de navegación
    - Cleanup al desmontar componente

### Fixed

- **Mejoras de Accesibilidad**
  - Tooltips con información contextual
  - Overscroll behavior controlado
  - Scrollbars consistentes en toda la app
  - Responsive design en todos los componentes
  - Border dotted visible para palabras con información
  - Contraste adecuado en todos los estados

- **Integración con Servicios**
  - LocalStorageService para progreso real
  - LanguageService para información de idiomas
  - StatsRepository para estadísticas
  - LearningRepository para datos de niveles y unidades
  - Cálculo dinámico de porcentajes

- **Flujos de Usuario Mejorados**
  - Flujo de procesamiento de texto
  - Flujo de tooltip interactivo
  - Flujo de navegación entre niveles
  - Flujo de prevención de recarga

### Future Improvements Suggested

- Agregar audio al hacer clic en palabras con tooltip
- Web Speech API para futura implementación de audio
- Sistema de favoritos para vocabulario
- Historial de palabras consultadas
- Quiz de vocabulario basado en palabras con tooltip
- Exportar vocabulario consultado
- Modo de práctica de pronunciación
- Sistema de guardado automático periódico

## [3.1.0] - 2025-11-08 - Implementación de RepositoryFactory con Patrón Singleton

### Added

- **RepositoryFactory**
  - Sistema centralizado de gestión de repositorios
  - Patrón Singleton para instancias únicas
  - Métodos convenientes para acceso directo a repositorios
  - Función reset() para testing y cleanup

### Changed

- **Optimización de Memoria**
  - Reducción de instancias duplicadas en componentes
  - Mejor gestión del estado de repositorios
- **Arquitectura de Datos**
  - Centralización de creación de repositorios
  - Mejor mantenibilidad y escalabilidad

### Fixed

- Mejor performance al reutilizar instancias de repositorios
- Consistencia en el estado de datos entre componentes

## [3.0.0] - 2025-11-08 - Restructuración Mayor y Sistema de Componentes

### Added

- **Sistema de Modales**
  - ExitConfirmModal para confirmación de salida
  - FeedbackModal para retroalimentación
  - WarningModal para avisos importantes
- **Sistema de Progreso**
  - ProgressBar con animaciones fluidas
  - DialectProgress para seguimiento por variante
  - Badge para indicadores visuales
  - LearningStats con métricas detalladas
- **Nueva estructura de modelos de datos**
  - Achievement para sistema de logros
  - DictionaryEntry para entradas léxicas
  - Exercise para sistema de ejercicios
  - Level y Unit para estructura de contenido
- **Sistema de Repositorios**
  - DictionaryRepository para gestión léxica
  - LearningRepository para contenido educativo
  - StatsRepository para métricas de usuario
  - UserRepository para gestión de perfiles
  - SyllabaryRepository para sistemas de escritura
- **Servicios Core**
  - AchievementService para sistema de logros
  - LanguageService para gestión lingüística
  - ProgressService para seguimiento
  - StudyService para lógica de aprendizaje
  - UnlockService para progresión de contenido
  - SpeechService/TTS para pronunciación

### Changed

- **Arquitectura de datos**
  - Mejor organización de datos por módulos
  - Sistema de almacenamiento optimizado
- **Sistema de Layout**
  - DesktopAside mejorado
  - Layout.vue más flexible
  - MobileNav optimizado
  - vHeader con mejor adaptabilidad
- **Configuración**
  - Sistema de rutas optimizado
  - Store de autenticación mejorado
  - Configuración de Vite actualizada

### Fixed

- Mejor persistencia de datos
- Sistema de caché mejorado
- Manejo eficiente del estado

## [2.1.0] - 2025-10-27 - Mejoras en Interfaz y Experiencia de Usuario

### Added

- **LoadingStates**
  - Nuevo sistema de carga para VariantSelection
  - Indicadores de estado para inicialización
  - Animaciones de spinner optimizadas
  - Mensajes de carga contextuales

### Changed

- **Sistema de Autenticación**
  - Nuevo estado de inicialización
  - Mejor manejo de variantes dialectales
  - Sistema de redirección inteligente
- **Interfaz de Usuario**
  - Mejoras en responsividad
  - Optimización de márgenes y padding
  - Mejor manejo de altura de pantalla
- **ProgressAside**
  - Nuevo diseño de estados de carga
  - Mejor integración con variantes
  - Sistema de scroll optimizado

### Fixed

- Ajustes en componentes móviles
- Mejor control de inicialización
- Optimización de transiciones de estado

## [2.0.0] - 2025-10-17 - Vista de Estadísticas y Mejoras de Componentes

### Added

- **StatsView**
  - Nueva vista dedicada para estadísticas de aprendizaje
  - Integración completa con ProgressAside
  - Diseño responsive con header específico para móviles
  - Easter egg para usuarios de escritorio
- **MobileNav**
  - Nueva opción de navegación "Estadísticas"
  - Icono de gráficas integrado

### Changed

- **LearningStats**
  - Sistema de colores dinámico basado en valores
  - Emojis de recompensa para rachas
  - Lógica de visualización condicional para rachas >= 3
- **ProgressAside**
  - Rediseño completo del layout
  - Sistema de scroll mejorado sin barras visibles
  - Mejor organización del espacio
- **Sistema de Navegación**
  - Nueva ruta `/estadisticas` añadida al router
  - Reorganización de rutas existentes

### Fixed

- Corrección de márgenes y padding en múltiples vistas
- Mejoras en el responsive design
- Optimización del espacio en pantalla

## [1.3.0] - 2025-10-16 - Sistema de Identidad Visual y Expansión del Glosario

### Added

- **IdentitySystem**
  - Nuevo sistema de favicon y íconos
  - Soporte para PWA con manifest
  - Iconografía adaptativa para diferentes plataformas
- **GlossaryData**
  - Estructura completa de datos del glosario
  - Sistema de categorización detallado
  - Ejemplos y traducciones contextuales
- **SyllabarySystem**
  - Implementación completa del silabario náhuatl
  - Sistema interactivo de visualización
  - Documentación detallada de pronunciación

### Changed

- **Sistema de Navegación**
  - Simplificación de la estructura de rutas
  - Actualización de nombres y enlaces
, **Sistema de Colores**
  - Actualización de la paleta de colores dialectal
  - Mejora en el contraste y accesibilidad

### Fixed

- Ocultamiento temporal de secciones en desarrollo
- Mejora en la experiencia de instalación PWA

## [1.2.0] - 2025-10-15 - Refactorización y Mejoras del Sistema de Glosario

### Added

- **GlossaryView**
  - Nueva vista unificada para diccionario y silabario
  - Sistema de tabs para navegación entre secciones
- **DictionaryContent**
  - Componente modular para el diccionario
  - Búsqueda y filtrado mejorados
- **SyllabaryContent**
  - Nuevo componente para el silabario náhuatl
  - Diseño de grid interactivo

### Changed

- **Sistema de Navegación**
  - Actualización de rutas y nombres
  - Simplificación de la estructura
- **Datos y Estructura**
  - Separación de datos en archivos modulares
  - Nueva estructura para entradas del diccionario
- **Interfaz de Usuario**
  - Diseño más limpio y moderno
  - Mejor uso del espacio en pantalla

### Fixed

- Refactorización de la generación de ejercicios
- Mejor manejo de datos de unidades

## [1.1.0] - 2025-10-14 - Refactorización y Mejoras de Sistema

### Added

- **VariantSelection**
  - Nueva interfaz para selección de variante
  - Visualización de variante actual
- **LessonView**
  - Soporte para imágenes placeholder
- **LevelView**
  - Sistema de bloqueo de niveles y unidades
  - Visualización de requisitos de desbloqueo

### Changed

- **Navegación y Layout**
  - Rediseño completo de DesktopAside
  - Nuevo diseño de información de usuario
- **Sistema de Autenticación**
  - Implementación de guardias de ruta
  - Mejora en manejo de estados
- **ProgressAside**
  - Badge de variante activa
  - Integración con sistema dialectal

### Fixed

- Control de acceso por variante
- Redirecciones inteligentes
- Mejor manejo de estados en vHeader

## [1.0.1] - 2025-04-29 - Refactorización y Componentes de Perfil

### Added

- **SettingsPanel**
  - Panel de preferencias de usuario
  - Configuración de dialecto, sonido, etc.
- **AchievementsList**
  - Listado de logros desbloqueados
  - Diseño con cards
- **DialectProgress**
  - Progreso por variante dialectal
  - Barras de progreso coloreadas

### Changed

- Refactorización completa de ProfileView
  - Mejor organización por componentes
  - Lógica de pestañas optimizada
- Actualización de ProgressAside
  - Integración con nuevos componentes

### Fixed

- Detección responsive mejorada
- Mejor manejo de estados vacíos

## [1.0.0] - 2025-04-28 - Sistema de Navegación Completo

### Added

- **DesktopAside**
  - Barra lateral izquierda para desktop
  - Navegación con iconos SVG
  - Resaltado de ruta activa
- **MobileNav**
  - Barra inferior para móviles
  - Ocultamiento condicional
- **ProgressAside**
  - Barra lateral derecha para progreso
  - Integración de LearningStats y DialectProgress

## [0.2.0] - 2025-04-27 - Correcciones y Mejoras

### Changed

- Optimización del rendimiento
- Mejoras en el responsive design

### Fixed

- Corrección de bugs de interfaz
- Validación adicional de props
- Refactorización de componentes

## [0.1.0] - 2025-04-26 - Sistema de Progreso y Perfil

### Added

- **ProgressBar**
  - Barra de progreso dinámica
  - Cálculo automático de porcentaje
- **UserProfile**
  - Tarjeta de perfil de usuario
  - Muestra nivel y progreso (XP)
- **LearningStats**
  - Estadísticas de aprendizaje
  - Grid de 4 métricas clave

## [0.0.1] - 2025-04-25 - Componentes Base y Estructura Inicial

### Added

- **Inicialización del Proyecto**
  - Vite + Vue.js (JavaScript)
  - Tailwind CSS v3.4.17
  - Estructura base de archivos
- **Componentes Base**
  - Badge para etiquetas
  - Tab para sistema de pestañas
  - vHeader multipropósito

### Changed

- Configuración inicial de rutas
- Establecimiento de estructura de vistas

---

**Nota de versionado**:  
Se sigue el formato `MAYOR.MENOR.PARCHE` donde:

- **MAYOR**: Cambios incompatibles con versiones anteriores
- **MENOR**: Nuevas funcionalidades compatibles
- **PARCHE**: Correcciones de errores
