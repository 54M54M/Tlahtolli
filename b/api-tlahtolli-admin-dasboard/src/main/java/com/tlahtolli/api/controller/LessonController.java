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
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.tlahtolli.api.entity.Lesson;
import com.tlahtolli.api.repository.LessonRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/lessons")
public class LessonController {

	private final LessonRepository repo;

	public LessonController(LessonRepository repo) {
		super();
		this.repo = repo;
	}

	@GetMapping
	public List<Lesson> getAll(@RequestParam(required = false) Long unitId) {
		if (unitId != null)
			return repo.findByUnitId(unitId);
		return repo.findAll();
	}

	@GetMapping("/count")
	public Map<String, Long> count() {
		return Map.of("count", repo.count());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Lesson> getById(@PathVariable Long id) {
		return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	@PostMapping
	public ResponseEntity<Lesson> create(@RequestBody Lesson lesson) {
		return ResponseEntity.status(HttpStatus.CREATED).body(repo.save(lesson));
	}

	@PutMapping("/{id}")
	public ResponseEntity<Lesson> update(@PathVariable Long id, @RequestBody Lesson lesson) {
		return repo.findById(id).map(existing -> {
			lesson.setId(existing.getId());
			return ResponseEntity.ok(repo.save(lesson));
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