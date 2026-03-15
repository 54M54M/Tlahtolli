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

import com.tlahtolli.api.entity.Level;
import com.tlahtolli.api.repository.LevelRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/levels")
public class LevelController {

	private final LevelRepository repo;

	public LevelController(LevelRepository repo) {
		super();
		this.repo = repo;
	}

	@GetMapping
	public List<Level> getAll(@RequestParam(required = false) Long languageId) {
		if (languageId != null)
			return repo.findByLanguageId(languageId);
		return repo.findAll();
	}

	@GetMapping("/count")
	public Map<String, Long> count() {
		return Map.of("count", repo.count());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Level> getById(@PathVariable Long id) {
		return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	@PostMapping
	public ResponseEntity<Level> create(@RequestBody Level l) {
		return ResponseEntity.status(HttpStatus.CREATED).body(repo.save(l));
	}

	@PutMapping("/{id}")
	public ResponseEntity<Level> update(@PathVariable Long id, @RequestBody Level l) {
		return repo.findById(id).map(ex -> {
			l.setId(ex.getId());
			return ResponseEntity.ok(repo.save(l));
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