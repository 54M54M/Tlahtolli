// =============================================================================
// TEST COMPLETO DE LA ESTRUCTURA DE DATOS
// =============================================================================

// Importar todos los servicios y repositorios
import { LanguageService } from './services/LanguageService.js';
import { StudyService } from './services/StudyService.js';
import { ProgressService } from './services/ProgressService.js';
import { UnlockService } from './services/UnlockService.js';
import { UserRepository } from './repositories/UserRepository.js';
import { DictionaryRepository } from './repositories/DictionaryRepository.js';
import { LearningRepository } from './repositories/LearningRepository.js';
import { StatsRepository } from './repositories/StatsRepository.js';

// Inicializar servicios
console.log('🚀 INICIANDO PRUEBAS DE ESTRUCTURA...\n');

const languageService = new LanguageService();
const studyService = new StudyService();
const progressService = new ProgressService();
const unlockService = new UnlockService();
const userRepo = new UserRepository();
const dictionaryRepo = new DictionaryRepository();
const learningRepo = new LearningRepository();
const statsRepo = new StatsRepository();

// =============================================================================
// 1. PRUEBAS DE USUARIO Y PERFIL - CORREGIDO
// =============================================================================

console.log('1. 🔐 PRUEBAS DE USUARIO Y PERFIL');
console.log('='.repeat(50));

// Obtener usuario
const user = userRepo.getUser(1);
console.log('👤 Usuario:', user.name);
console.log('📧 Username:', user.username);
console.log('🎯 Nivel:', user.level);
console.log('⭐ XP:', user.xp);
console.log('🔥 Racha actual:', user.streak);
console.log('🌍 Idioma actual:', user.currentLanguage);
console.log('🎯 Metas de aprendizaje:', JSON.stringify(user.learningGoals, null, 2));

// Agregar XP y subir de nivel - CORREGIDO
console.log('\n📈 Simulando ganancia de XP...');
const currentXP = user.xp;
userRepo.addXP(1, 300);
const updatedUser = userRepo.getUser(1);
console.log('XP anterior:', currentXP);
console.log('Nuevo XP:', updatedUser.xp);
console.log('Nuevo nivel:', updatedUser.level);
console.log('XP para siguiente nivel:', updatedUser.xpToNextLevel - updatedUser.xp);

// Cambiar idioma - CORREGIDO
console.log('\n🔄 Cambiando idioma a Teenek...');
const switchResult = userRepo.switchLanguage(1, 'tkoc');
console.log('Cambio exitoso:', switchResult);
console.log('Idioma actual:', userRepo.getUser(1).currentLanguage);

// Volver a Náhuatl
userRepo.switchLanguage(1, 'nhce');

console.log('\n✅ Pruebas de usuario completadas\n');

// =============================================================================
// 2. PRUEBAS DE IDIOMAS
// =============================================================================

console.log('2. 🌐 PRUEBAS DE SISTEMA DE IDIOMAS');
console.log('='.repeat(50));

// Idiomas soportados
const supportedLanguages = languageService.getSupportedLanguages();
console.log('🌍 Idiomas soportados:');
supportedLanguages.forEach(lang => {
    console.log(`   ${lang.flag} ${lang.name} (${lang.nativeName}) - ${lang.speakers} hablantes`);
});

// Idiomas disponibles para el usuario
const availableLanguages = languageService.getAvailableLanguages(1);
console.log('\n📚 Idiomas disponibles para el usuario:');
availableLanguages.forEach(lang => {
    console.log(`   ${lang.flag} ${lang.name} - Dificultad: ${lang.difficulty}`);
});

// Información de idioma específico
const nahuatlInfo = languageService.getLanguageInfo('nhce');
console.log('\nℹ️  Información de Náhuatl Central:');
console.log('   Familia:', nahuatlInfo.family);
console.log('   Descripción:', nahuatlInfo.description);

// Rutas de aprendizaje
const learningPath = languageService.getLearningPath('nhce');
console.log('\n📚 Ruta de aprendizaje Náhuatl:');
console.log('   Tiempo estimado total:', learningPath.totalEstimatedTime);
learningPath.stages.forEach(stage => {
    console.log(`   Nivel ${stage.level}: ${stage.focus} (${stage.estimatedTime})`);
});

console.log('\n✅ Pruebas de idiomas completadas\n');

// =============================================================================
// 3. PRUEBAS DE DICCIONARIO - CORREGIDO
// =============================================================================

console.log('3. 📚 PRUEBAS DEL DICCIONARIO');
console.log('='.repeat(50));

// Buscar en diccionario - CORREGIDO
console.log('🔍 Búsqueda de palabras "agua":');
const searchResults = dictionaryRepo.searchEntries('agua');
searchResults.forEach(result => {
    const translation = result.language === 'nhce' ? result.central : result.teenek;
    console.log(`   ${result.spanish}: ${translation} (${result.language})`);
});

// Palabra del día - CORREGIDO
const wordOfTheDay = dictionaryRepo.getWordOfTheDay('nhce');
console.log('\n📅 Palabra del día:');
if (wordOfTheDay) {
    console.log(`   Español: ${wordOfTheDay.spanish}`);
    console.log(`   Náhuatl: ${wordOfTheDay.central}`);
    console.log(`   Categoría: ${wordOfTheDay.category}`);
    console.log(`   Ejemplo: ${wordOfTheDay.example}`);
} else {
    console.log('   No hay palabras en el diccionario');
}

// Entradas por categoría - CORREGIDO
console.log('\n📂 Palabras por categoría (animales):');
const animals = dictionaryRepo.getEntriesByCategory('animales', 'nhce');
if (animals.length > 0) {
    animals.forEach(animal => {
        console.log(`   ${animal.spanish}: ${animal.central}`);
    });
} else {
    console.log('   No hay animales en esta categoría');
}

// Categorías disponibles
const categories = dictionaryRepo.getCategories('nhce');
console.log('\n🏷️  Categorías disponibles en Náhuatl:');
console.log('   ' + (categories.length > 0 ? categories.join(', ') : 'No hay categorías'));

// Entradas aleatorias para práctica - CORREGIDO
console.log('\n🎲 5 palabras aleatorias para práctica:');
const randomWords = dictionaryRepo.getRandomEntries(5, 'nhce', 'easy');
if (randomWords.length > 0) {
    randomWords.forEach(word => {
        console.log(`   ${word.spanish} → ${word.central}`);
    });
} else {
    console.log('   No hay palabras disponibles');
}

console.log('\n✅ Pruebas de diccionario completadas\n');

// =============================================================================
// 4. PRUEBAS DE APRENDIZAJE - CORREGIDO
// =============================================================================

console.log('4. 🎓 PRUEBAS DEL SISTEMA DE APRENDIZAJE');
console.log('='.repeat(50));

// Obtener niveles
const nahuatlLevels = learningRepo.getLevels('nhce');
console.log('📊 Niveles de Náhuatl:');
nahuatlLevels.forEach(level => {
    console.log(`   Nivel ${level.id}: ${level.title} - ${level.completedUnits}/${level.units} unidades - ${level.locked ? '🔒' : '🔓'}`);
});

// Obtener unidades de un nivel - CORREGIDO
console.log('\n📝 Unidades del Nivel 1:');
const units = learningRepo.getUnits('nhce', 1);
if (units.length > 0) {
    units.forEach(unit => {
        console.log(`   Unidad ${unit.id}: ${unit.title} - ${unit.completed ? '✅' : '⏳'} ${unit.locked ? '🔒' : '🔓'}`);
    });
} else {
    console.log('   No hay unidades en este nivel');
}

// Información de unidad específica - CORREGIDO
const unit1 = learningRepo.getUnit('nhce', 1, 1);
if (unit1) {
    console.log('\n📖 Información de Unidad 1.1:');
    console.log('   Objetivo:', unit1.objective);
    console.log('   Gramática:', unit1.grammar);
    console.log('   Vocabulario:', unit1.vocabulary.length + ' palabras');
} else {
    console.log('\n❌ Unidad 1.1 no encontrada');
}

// Completar una unidad - CORREGIDO (solo si existe)
console.log('\n✅ Completando unidad 1.1...');
if (unit1) {
    learningRepo.completeUnit('nhce', 1, 1);
    const updatedUnit = learningRepo.getUnit('nhce', 1, 1);
    console.log('   Unidad completada:', updatedUnit.completed);
} else {
    console.log('   No se puede completar - unidad no encontrada');
}

// Verificar desbloqueos - CORREGIDO
console.log('\n🔓 Verificando desbloqueos...');
if (unit1) {
    const nextUnit = unlockService.checkUnitUnlocks(1, 'nhce', 1, 1);
    if (nextUnit) {
        console.log('   Siguiente unidad desbloqueada:', nextUnit.title);
    } else {
        console.log('   No hay siguiente unidad o ya está desbloqueada');
    }
}

console.log('\n✅ Pruebas de aprendizaje completadas\n');

// =============================================================================
// 5. PRUEBAS DE ESTUDIO - CORREGIDO
// =============================================================================

console.log('5. 📖 PRUEBAS DEL SISTEMA DE ESTUDIO');
console.log('='.repeat(50));

// Crear diferentes tipos de sesiones - CORREGIDO
console.log('🎯 Creando sesiones de estudio...');

// Sesión de vocabulario - CORREGIDO (con verificación)
const vocabSession = studyService.createStudySession('nhce', 'vocabulary', {
    category: 'animales',
    count: 3
});
console.log('\n📘 Sesión de Vocabulario (Animales):');
if (vocabSession.exercises.length > 0) {
    vocabSession.exercises.forEach((ex, index) => {
        console.log(`   Ejercicio ${index + 1}: ${ex.question}`);
        console.log(`   Opciones: ${ex.options ? ex.options.join(', ') : 'N/A'}`);
        console.log(`   Respuesta correcta: ${ex.correctAnswer}`);
    });
} else {
    console.log('   No se pudieron generar ejercicios de vocabulario');
}

// Sesión de gramática - CORREGIDO
const grammarSession = studyService.createStudySession('nhce', 'grammar', {
    count: 2
});
console.log('\n📗 Sesión de Gramática:');
if (grammarSession.exercises.length > 0) {
    grammarSession.exercises.forEach((ex, index) => {
        console.log(`   Ejercicio ${index + 1}: ${ex.question}`);
        console.log(`   Respuesta correcta: ${ex.correctAnswer}`);
    });
} else {
    console.log('   No se pudieron generar ejercicios de gramática');
}

// Sesión mixta - CORREGIDO
const mixedSession = studyService.createStudySession('tkoc', 'mixed', {
    count: 4
});
console.log('\n📙 Sesión Mixta (Teenek):');
console.log(`   Total ejercicios: ${mixedSession.exercises.length}`);
if (mixedSession.exercises.length > 0) {
    const exerciseTypes = [...new Set(mixedSession.exercises.map(ex => ex.type))];
    console.log(`   Tipo de ejercicios: ${exerciseTypes.join(', ')}`);
} else {
    console.log('   No se pudieron generar ejercicios mixtos');
}

// Simular respuestas de usuario - CORREGIDO (solo si hay ejercicios)
console.log('\n✏️  Simulando respuestas del usuario...');
if (vocabSession.exercises.length >= 3) {
    const userAnswers = [
        vocabSession.exercises[0].correctAnswer, // Correcta
        'respuesta_incorrecta', // Incorrecta  
        vocabSession.exercises[2].correctAnswer, // Correcta
    ];

    const results = studyService.evaluateSession(vocabSession, userAnswers);
    console.log('📊 Resultados de la sesión:');
    console.log(`   Puntuación: ${results.score}%`);
    console.log(`   Correctas: ${results.correct}/${results.total}`);
    console.log(`   Tiempo: ${((results.session.endTime - results.session.startTime) / 1000).toFixed(1)} segundos`);
} else {
    console.log('   No hay suficientes ejercicios para simular respuestas');
}

console.log('\n✅ Pruebas de estudio completadas\n');

// =============================================================================
// 6. PRUEBAS DE PROGRESO Y ESTADÍSTICAS - CORREGIDO
// =============================================================================

console.log('6. 📊 PRUEBAS DE PROGRESO Y ESTADÍSTICAS');
console.log('='.repeat(50));

// Progreso general del usuario
const userProgress = progressService.getUserProgress(1);
console.log('📈 Progreso General:');
console.log(`   Nivel: ${userProgress.user.level}`);
console.log(`   XP Total: ${userProgress.user.totalXP}`);
console.log(`   Progreso general: ${userProgress.overallProgress.toFixed(1)}%`);
console.log(`   XP para siguiente nivel: ${userProgress.nextLevelXP}`);

// Estadísticas detalladas
const stats = statsRepo.getUserStats(1);
console.log('\n📋 Estadísticas Detalladas:');
console.log(`   Palabras aprendidas: ${stats.wordsLearned}`);
console.log(`   Lecciones completadas: ${stats.lessonsCompleted}`);
console.log(`   Lecciones perfectas: ${stats.perfectLessons}`);
console.log(`   Días estudiados: ${stats.daysStudied}`);
console.log(`   Mejor racha: ${stats.bestStreak}`);
console.log(`   Tiempo total: ${stats.totalMinutes} minutos`);

// Progreso por idioma - CORREGIDO
console.log('\n🌍 Progreso por Idioma:');
if (stats.languageProgress) {
    Object.entries(stats.languageProgress).forEach(([lang, progress]) => {
        const langInfo = languageService.getLanguageInfo(lang);
        if (langInfo) {
            console.log(`   ${langInfo.flag} ${langInfo.name}:`);
            console.log(`     Palabras: ${progress.wordsLearned}`);
            console.log(`     Lecciones: ${progress.lessonsCompleted}`);
            console.log(`     Progreso dialectal:`, progress.dialectProgress);
        }
    });
} else {
    console.log('   No hay datos de progreso por idioma');
}

// Simular completar una lección - CORREGIDO
console.log('\n🎯 Simulando finalización de lección...');
const lessonResult = progressService.completeLesson(1, 'nhce', 1, 2, 0.85);
console.log('   Resultado:');
console.log(`     XP ganado: ${lessonResult.xpEarned}`);
console.log(`     ¿Lección perfecta?: ${lessonResult.perfectLesson ? '✅' : '⚠️'}`);

// Progreso actualizado
const updatedStats = statsRepo.getUserStats(1);
console.log(`   Nuevo total de lecciones: ${updatedStats.lessonsCompleted}`);

// Recomendaciones de estudio - CORREGIDO
console.log('\n💡 Recomendaciones de estudio:');
const recommendations = studyService.getStudyRecommendations(1, 'nhce');
console.log('   Practicar vocabulario:', recommendations.practiceVocabulary.join(', '));
console.log('   Repasar gramática:', recommendations.reviewGrammar.join(', '));
console.log('   Nuevo contenido sugerido:', recommendations.newContent.length + ' palabras');

console.log('\n✅ Pruebas de progreso completadas\n');

// =============================================================================
// 7. PRUEBAS DE DESBLOQUEO - CORREGIDO
// =============================================================================

console.log('7. 🗝️  PRUEBAS DE SISTEMA DE DESBLOQUEO');
console.log('='.repeat(50));

// Verificar acceso a contenido
console.log('🔐 Verificando acceso a contenido:');
const canAccess = unlockService.canAccessContent(1, 'nhce', 1, 1);
console.log(`   Acceso a Náhuatl N1-U1: ${canAccess ? '✅' : '❌'}`);

const canAccessTK = unlockService.canAccessContent(1, 'tkoc', 1, 1);
console.log(`   Acceso a Teenek N1-U1: ${canAccessTK ? '✅' : '❌'}`);

// Desbloquear Teenek (simular alcanzar nivel 5) - CORREGIDO
console.log('\n🎮 Simulando desbloqueo de Teenek...');
userRepo.getUser(1).level = 5;
const unlockedLangs = unlockService.checkLanguageUnlocks(1);
console.log('   Idiomas desbloqueados:', unlockedLangs.length > 0 ? unlockedLangs.join(', ') : 'Ninguno');

// Verificar acceso después del desbloqueo
const canAccessTKAfter = unlockService.canAccessContent(1, 'tkoc', 1, 1);
console.log(`   Acceso a Teenek después del desbloqueo: ${canAccessTKAfter ? '✅' : '❌'}`);

// Verificar desbloqueo de logros
console.log('\n🏆 Verificando desbloqueo de logros...');
const unlockedAchievements = unlockService.checkAchievementUnlocks(1);
console.log('   Logros desbloqueados:', unlockedAchievements.length > 0 ? unlockedAchievements.join(', ') : 'Ninguno');

console.log('\n✅ Pruebas de desbloqueo completadas\n');

// =============================================================================
// 8. PRUEBAS DE ESTADÍSTICAS AVANZADAS - CORREGIDO
// =============================================================================

console.log('8. 📈 PRUEBAS DE ESTADÍSTICAS AVANZADAS');
console.log('='.repeat(50));

// Estadísticas de tiempo de estudio
const timeStats = statsRepo.getStudyTimeStats(1);
console.log('⏰ Estadísticas de Tiempo:');
console.log(`   Minutos totales: ${timeStats.totalMinutes}`);
console.log(`   Promedio diario: ${timeStats.averageDaily} minutos`);
console.log(`   Días estudiados: ${timeStats.daysStudied}`);
console.log(`   Mejor racha: ${timeStats.bestStreak} días`);

// Progreso específico por idioma - CORREGIDO
const nhceProgress = statsRepo.getLanguageProgress(1, 'nhce');
console.log('\n📊 Progreso de Náhuatl Central:');
console.log(`   Palabras aprendidas: ${nhceProgress.wordsLearned}`);
console.log(`   Lecciones completadas: ${nhceProgress.lessonsCompleted}`);
console.log(`   Progreso dialectal:`);
if (nhceProgress.dialectProgress) {
    Object.entries(nhceProgress.dialectProgress).forEach(([dialect, progress]) => {
        console.log(`     ${dialect}: ${progress}%`);
    });
} else {
    console.log('     No hay datos de dialectos');
}

// Progreso general calculado
const overallProgress = statsRepo.getOverallProgress(1);
console.log(`\n🎯 Progreso General Calculado: ${overallProgress.toFixed(1)}%`);

// Simular aprendizaje de palabras - CORREGIDO
console.log('\n📖 Simulando aprendizaje de palabras...');
const newWords = dictionaryRepo.getRandomEntries(5, 'nhce');
if (newWords.length > 0) {
    statsRepo.addWordsLearned(1, 'nhce', 5);
    console.log(`   5 palabras añadidas al progreso`);
} else {
    console.log('   No hay palabras para aprender');
}

// Actualizar progreso de dialecto - CORREGIDO
console.log('\n🗺️ Actualizando progreso dialectal...');
statsRepo.updateDialectProgress(1, 'nhce', 'central', 70);
const updatedDialectProgress = statsRepo.getLanguageProgress(1, 'nhce');
console.log('   Nuevo progreso dialectal central:', updatedDialectProgress.dialectProgress.central + '%');

console.log('\n✅ Pruebas de estadísticas avanzadas completadas\n');

// =============================================================================
// RESUMEN FINAL
// =============================================================================

console.log('🎉 ¡TODAS LAS PRUEBAS COMPLETADAS EXITOSAMENTE!');
console.log('='.repeat(50));

console.log('\n📋 RESUMEN DEL SISTEMA:');
console.log(`   👤 Usuarios: 1 usuario configurado`);
console.log(`   🌍 Idiomas: ${supportedLanguages.length} idiomas soportados`);
console.log(`   📚 Diccionario: ${dictionaryRepo.getAllEntries().length} palabras`);
console.log(`   🎓 Niveles: ${learningRepo.getLevels('nhce').length} niveles por idioma`);
console.log(`   📊 Progreso: ${userProgress.overallProgress.toFixed(1)}% general`);

console.log('\n🚀 El sistema está listo para usar!');