package com.tlahtolli.api.controller;

import com.tlahtolli.api.dto.response.LessonHistoryResponse;
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

	@GetMapping
	public List<LessonHistoryResponse> getAll(@RequestParam(required = false) Integer userId,
			@RequestParam(required = false) Integer unitId) {
		List<LessonHistory> results;
		if (userId != null && unitId != null) {
			results = repo.findByUserIdAndUnitId(userId, unitId);
		} else if (userId != null) {
			results = repo.findByUserIdOrderByCompletedAtDesc(userId);
		} else {
			results = repo.findAllByOrderByCompletedAtDesc();
		}
		return results.stream().map(LessonHistoryResponse::from).toList();
	}

	@GetMapping("/count")
	public Map<String, Long> count() {
		return Map.of("count", repo.count());
	}

	@GetMapping("/{id}")
	public ResponseEntity<LessonHistoryResponse> getById(@PathVariable Integer id) {
		return repo.findById(id).map(LessonHistoryResponse::from).map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}

	@PostMapping
	public ResponseEntity<LessonHistoryResponse> create(@RequestBody LessonHistory h) {
		return ResponseEntity.status(HttpStatus.CREATED).body(LessonHistoryResponse.from(repo.save(h)));
	}
}