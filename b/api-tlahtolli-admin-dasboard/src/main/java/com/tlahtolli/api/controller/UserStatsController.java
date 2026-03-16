package com.tlahtolli.api.controller;

import com.tlahtolli.api.entity.UserStats;
import com.tlahtolli.api.repository.UserStatsRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/user-stats")
public class UserStatsController {

	private final UserStatsRepository repo;

	public UserStatsController(UserStatsRepository repo) {
		this.repo = repo;
	}

	/**
	 * GET /api/user-stats → todos (dashboard admin) GET /api/user-stats?userId=1 →
	 * stats de un usuario (todos sus idiomas) GET
	 * /api/user-stats?userId=1&languageId=1 → stats de usuario + idioma específico
	 * Usado por StatsRepository.getUserStats() del frontend.
	 */
	@GetMapping
	public ResponseEntity<?> getAll(@RequestParam(required = false) Long userId,
			@RequestParam(required = false) Long languageId) {

		if (userId != null && languageId != null) {
			return repo.findByUserIdAndLanguageId(userId, languageId).map(ResponseEntity::ok)
					.orElse(ResponseEntity.notFound().build());
		}
		if (userId != null) {
			return ResponseEntity.ok(repo.findByUserId(userId));
		}
		return ResponseEntity.ok(repo.findAll());
	}

	@GetMapping("/{id}")
	public ResponseEntity<UserStats> getById(@PathVariable Long id) {
		return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	@PostMapping
	public ResponseEntity<UserStats> create(@RequestBody UserStats s) {
		return ResponseEntity.status(HttpStatus.CREATED).body(repo.save(s));
	}

	@PutMapping("/{id}")
	public ResponseEntity<UserStats> update(@PathVariable Long id, @RequestBody UserStats s) {
		return repo.findById(id).map(existing -> {
			s.setId(existing.getId());
			return ResponseEntity.ok(repo.save(s));
		}).orElse(ResponseEntity.notFound().build());
	}
}