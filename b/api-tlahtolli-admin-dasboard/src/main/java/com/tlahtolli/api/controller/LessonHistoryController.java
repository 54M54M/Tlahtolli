package com.tlahtolli.api.controller;

import com.tlahtolli.api.entity.LessonHistory;
import com.tlahtolli.api.repository.LessonHistoryRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/lesson-history")
public class LessonHistoryController {

	private final LessonHistoryRepository repo;

	public LessonHistoryController(LessonHistoryRepository repo) {
		this.repo = repo;
	}

	/**
	 * GET /api/lesson-history → todo el historial (dashboard admin) GET
	 * /api/lesson-history?userId=1 → historial de un usuario GET
	 * /api/lesson-history?userId=1&unitId=3 → historial usuario+unidad Usado por
	 * ProgressService para verificar si ya completó una unidad.
	 */
	@GetMapping
	public List<LessonHistory> getAll(@RequestParam(required = false) Integer userId,
			@RequestParam(required = false) Integer unitId) {

		if (userId != null && unitId != null) {
			return repo.findByUserIdAndUnitId(userId, unitId);
		}
		if (userId != null) {
			return repo.findByUserIdOrderByCompletedAtDesc(userId);
		}
		return repo.findAllByOrderByCompletedAtDesc();
	}

	@GetMapping("/count")
	public Map<String, Long> count() {
		return Map.of("count", repo.count());
	}

	@GetMapping("/{id}")
	public ResponseEntity<LessonHistory> getById(@PathVariable Integer id) {
		return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	/**
	 * POST /api/lesson-history Permite registrar un intento directamente si el
	 * frontend lo necesita.
	 */
	@PostMapping
	public ResponseEntity<LessonHistory> create(@RequestBody LessonHistory h) {
		return ResponseEntity.status(HttpStatus.CREATED).body(repo.save(h));
	}
}