package com.tlahtolli.api.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tlahtolli.api.entity.Achievement;
import com.tlahtolli.api.repository.AchievementRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/achievements")
public class AchievementController {

	private final AchievementRepository repo;

	public AchievementController(AchievementRepository repo) {
		super();
		this.repo = repo;
	}

	@GetMapping
	public List<Achievement> getAll() {
		return repo.findAll();
	}

	@GetMapping("/count")
	public Map<String, Long> count() {
		return Map.of("count", repo.count());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Achievement> getById(@PathVariable Long id) {
		return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	@PostMapping
	public ResponseEntity<Achievement> create(@RequestBody Achievement a) {
		return ResponseEntity.status(HttpStatus.CREATED).body(repo.save(a));
	}

	@PutMapping("/{id}")
	public ResponseEntity<Achievement> update(@PathVariable Long id, @RequestBody Achievement a) {
		return repo.findById(id).map(ex -> {
			a.setId(ex.getId());
			return ResponseEntity.ok(repo.save(a));
		}).orElse(ResponseEntity.notFound().build());
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> delete(@PathVariable Long id) {
		if (!repo.existsById(id))
			return ResponseEntity.notFound().build();
		repo.deleteById(id);
		return ResponseEntity.noContent().build();
	}
}