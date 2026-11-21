# GUÍA DE INTEGRACIÓN FRONTEND ↔ BACKEND

# Qué archivo nuevo reemplaza a qué archivo existente

## 1. NUEVO ARCHIVO (no existía)

src/api/apiClient.js
  → Crear en: f/am-ui-tlahtolcalli/src/api/apiClient.js
  → Es el punto central de todas las llamadas HTTP

## 2. STORES (reemplazar completamente)

src/stores/auth.js      → reemplaza f/am-ui-tlahtolcalli/src/stores/auth.js
src/stores/energy.js    → reemplaza f/am-ui-tlahtolcalli/src/stores/energy.js

## 3. REPOSITORIES (reemplazar completamente)

src/repositories/LearningRepository.js → reemplaza f/am-ui-tlahtolcalli/src/data/repositories/LearningRepository.js
src/repositories/StatsRepository.js    → reemplaza f/am-ui-tlahtolcalli/src/data/repositories/StatsRepository.js
src/repositories/SyllabaryRepository.js→ reemplaza f/am-ui-tlahtolcalli/src/data/repositories/SyllabaryRepository.js
src/repositories/RepositoryFactory.js  → reemplaza f/am-ui-tlahtolcalli/src/data/repositories/RepositoryFactory.js

## 4. SERVICES (reemplazar completamente)

src/data/services/ProgressService.js   → reemplaza f/am-ui-tlahtolcalli/src/data/services/ProgressService.js

## 5. VISTAS (reemplazar completamente)

src/views/HomeView.vue              → reemplaza f/am-ui-tlahtolcalli/src/views/HomeView.vue
src/views/learn/LevelView.vue       → reemplaza f/am-ui-tlahtolcalli/src/views/learn/LevelView.vue
src/views/learn/lessonApi.js        → NUEVO en f/am-ui-tlahtolcalli/src/views/learn/lessonApi.js

## 6. COMPONENTES (reemplazar completamente)

src/ProgressAside.vue               → reemplaza f/am-ui-tlahtolcalli/src/components/ProgressAside.vue

## 7. CONFIGURACIÓN (crear si no existe)

.env                                → crear en f/.env

## 8. ARCHIVOS QUE NO CAMBIAN

f/am-ui-tlahtolcalli/src/views/learn/LessonView.vue    → solo cambiar loadLessonData() y completeCurrentUnit()
f/am-ui-tlahtolcalli/src/views/learn/QuickLevelView.vue→ solo cambiar loadQuickLevelData() y completeQuickLevel()
f/am-ui-tlahtolcalli/src/views/ProfileView.vue         → ya usa ProgressService.getAllAchievementsWithProgress()
f/am-ui-tlahtolcalli/src/views/GlossaryView.vue        → ya usa SyllabaryRepository
f/am-ui-tlahtolcalli/src/components/vHeader.vue        → sin cambios (lee energyStore que ya está adaptado)
f/am-ui-tlahtolcalli/src/main.js                       → sin cambios
f/am-ui-tlahtolcalli/src/router/index.js               → sin cambios

## 9. CAMBIOS PUNTUALES EN LessonView.vue

Buscar: this.loadLessonData()
Reemplazar con:
  import { loadLessonData, completeLesson, consumeEnergy } from './lessonApi.js'
  // En created():
  const data = await loadLessonData(this.unitId)
  this.currentUnit      = data.currentUnit
  this.currentLevel     = data.currentLevel
  this.currentExercises = data.currentExercises
  this.currentUnit.vocabulary = data.vocabulary

Buscar: this.completeCurrentUnit()
Reemplazar el contenido con:
  const result = await completeLesson({
    unitId:      this.currentUnit.id,
    performance: this.correctAnswersCount / this.currentExercises.length,
    earnedExp:   this.calculateEarnedPoints(),
    correctAns:  this.correctAnswersCount,
    totalExerc:  this.currentExercises.length,
    timeSeconds: this.lessonTime,
  })
  this.earnedExp = result.xpEarned

Buscar: await this.energyStore.consumeForExercise(this.isAnswerCorrect)
  → Sin cambios, el store ya está adaptado

## 10. ETAPA PENDIENTE — SEED DE BASE DE DATOS

Los 215 ejercicios y vocabulario de learningContent.js
deben insertarse en Oracle con un script SQL de seed.
Sin datos en la BD el backend devuelve arrays vacíos.
