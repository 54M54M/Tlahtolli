package com.tlahtolli.api.controller;

import com.tlahtolli.api.entity.UserProgress;
import com.tlahtolli.api.repository.UserProgressRepository;
import com.tlahtolli.api.service.ProgressService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/user-progress")
public class UserProgressController {

	private final UserProgressRepository repo;
	private final ProgressService progressService;

	public UserProgressController(UserProgressRepository repo, ProgressService progressService) {
		this.repo = repo;
		this.progressService = progressService;
	}

	/** Progreso completo de un usuario (todos los idiomas). */
	@GetMapping
	public List<UserProgress> getAll(@RequestParam(required = false) Integer userId) {
		if (userId != null)
			return repo.findByUserId(userId);
		return repo.findAll();
	}

	/** Progreso de un usuario para una unidad específica. */
	@GetMapping("/user/{userId}/unit/{unitId}")
	public ResponseEntity<UserProgress> getByUserAndUnit(@PathVariable Integer userId, @PathVariable Integer unitId) {
		return repo.findByUserIdAndUnitId(userId, unitId).map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}

	/**
	 * Endpoint principal: completar una lección. Body esperado: { "userId": 1,
	 * "unitId": 3, "languageId": 1, "performance": 0.85, "earnedExp": 90,
	 * "correctAns": 5, "totalExerc": 6, "timeSeconds": 180 }
	 */
	@PostMapping("/complete")
	public ResponseEntity<Map<String, Object>> completeLesson(@RequestBody Map<String, Object> body) {
		Integer userId = toInt(body.get("userId"));
		Integer unitId = toInt(body.get("unitId"));
		Integer languageId = toInt(body.get("languageId"));
		double performance = toDouble(body.get("performance"));
		int earnedExp = toInt(body.get("earnedExp"));
		int correctAns = toInt(body.get("correctAns"));
		int totalExerc = toInt(body.get("totalExerc"));
		int timeSecs = toInt(body.get("timeSeconds"));

		Map<String, Object> result = progressService.completeLesson(userId, unitId, languageId, performance, earnedExp,
				correctAns, totalExerc, timeSecs);

		return ResponseEntity.status(HttpStatus.CREATED).body(result);
	}

	@PostMapping("/init")
	public ResponseEntity<Void> init(@RequestBody Map<String, Object> body) {
		Integer userId = toInt(body.get("userId"));
		Integer firstUnitId = toInt(body.get("firstUnitId"));
		progressService.initializeProgress(userId, firstUnitId);
		return ResponseEntity.ok().build();
	}

	private Integer toInt(Object v) {
		return v == null ? 0 : Integer.parseInt(v.toString());
	}

	private double toDouble(Object v) {
		return v == null ? 0 : Double.parseDouble(v.toString());
	}
}