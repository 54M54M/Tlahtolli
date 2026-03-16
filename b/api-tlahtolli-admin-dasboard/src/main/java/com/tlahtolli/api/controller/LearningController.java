package com.tlahtolli.api.controller;

import com.tlahtolli.api.service.LearningService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/learning")
public class LearningController {

	private final LearningService learningService;

	public LearningController(LearningService learningService) {
		this.learningService = learningService;
	}

	/**
	 * Niveles de un idioma con progreso del usuario. GET
	 * /api/learning/levels?languageId=1&userId=1 Reemplaza
	 * getLevelsWithUnlockCheck() del frontend.
	 */
	@GetMapping("/levels")
	public ResponseEntity<List<Map<String, Object>>> getLevels(@RequestParam Long languageId,
			@RequestParam Long userId) {
		return ResponseEntity.ok(learningService.getLevelsWithProgress(languageId, userId));
	}

	/**
	 * Unidades de un nivel con estado locked/completed/current por usuario. GET
	 * /api/learning/levels/{levelId}/units?userId=1 Reemplaza getUnits() + lógica
	 * de estado del frontend.
	 */
	@GetMapping("/levels/{levelId}/units")
	public ResponseEntity<List<Map<String, Object>>> getUnits(@PathVariable Long levelId, @RequestParam Long userId) {
		return ResponseEntity.ok(learningService.getUnitsWithProgress(levelId, userId));
	}

	/**
	 * Ejercicios de una unidad con opciones mezcladas listas para mostrar. GET
	 * /api/learning/units/{unitId}/exercises Reemplaza getExercisesForUnit() del
	 * LearningRepository del frontend.
	 */
	@GetMapping("/units/{unitId}/exercises")
	public ResponseEntity<List<Map<String, Object>>> getExercises(@PathVariable Long unitId) {
		return ResponseEntity.ok(learningService.getExercisesForUnit(unitId));
	}

	/**
	 * Vocabulario de una unidad con pronunciación y traducción. GET
	 * /api/learning/units/{unitId}/vocabulary Usado por ProcessedText y
	 * PronunciationTooltip del frontend.
	 */
	@GetMapping("/units/{unitId}/vocabulary")
	public ResponseEntity<Object> getVocabulary(@PathVariable Long unitId) {
		return ResponseEntity.ok(learningService.getVocabularyForUnit(unitId));
	}

	/**
	 * Ejercicios aleatorios de un nivel completo (para QuickLevel). GET
	 * /api/learning/levels/{levelId}/quick?count=6
	 */
	@GetMapping("/levels/{levelId}/quick")
	public ResponseEntity<List<Map<String, Object>>> getQuickExercises(@PathVariable Long levelId,
			@RequestParam(defaultValue = "6") int count) {
		return ResponseEntity.ok(learningService.getRandomExercisesForLevel(levelId, count));
	}
}