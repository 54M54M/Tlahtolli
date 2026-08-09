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

import com.tlahtolli.api.entity.Exercise;
import com.tlahtolli.api.repository.ExerciseRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/exercises")
public class ExerciseController {

	private final ExerciseRepository repo;

	public ExerciseController(ExerciseRepository repo) {
		super();
		this.repo = repo;
	}

	@GetMapping
	public List<Exercise> getAll(@RequestParam(required = false) String type) {
		if (type != null && !type.isBlank())
			return repo.findByExerciseType(type);
		return repo.findAll();
	}

	@GetMapping("/count")
	public Map<String, Long> count() {
		return Map.of("count", repo.count());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Exercise> getById(@PathVariable Integer id) {
		return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	@PostMapping
	public ResponseEntity<Exercise> create(@RequestBody Exercise e) {
		return ResponseEntity.status(HttpStatus.CREATED).body(repo.save(e));
	}

	@PutMapping("/{id}")
	public ResponseEntity<Exercise> update(@PathVariable Integer id, @RequestBody Exercise exercise) {
	    return repo.findById(id).map(existing -> {
	        exercise.setId(existing.getId());
	        // Preservar unitId del registro existente si el nuevo no lo trae
	        if (exercise.getUnitId() == null) {
	            exercise.setUnitId(existing.getUnitId());
	        }
	        return ResponseEntity.ok(repo.save(exercise));
	    }).orElse(ResponseEntity.notFound().build());
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> delete(@PathVariable Integer id) {
		if (!repo.existsById(id))
			return ResponseEntity.notFound().build();
		repo.deleteById(id);
		return ResponseEntity.noContent().build();
	}
}
