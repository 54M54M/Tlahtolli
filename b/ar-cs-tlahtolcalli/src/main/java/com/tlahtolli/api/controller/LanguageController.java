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

import com.tlahtolli.api.entity.Language;
import com.tlahtolli.api.repository.LanguageRepository;

@RestController
@RequestMapping("/api/languages")
public class LanguageController {

	private final LanguageRepository repo;

	public LanguageController(LanguageRepository repo) {
		super();
		this.repo = repo;
	}

	@GetMapping
	public List<Language> getAll() {
		return repo.findAll();
	}

	@GetMapping("/count")
	public Map<String, Long> count() {
		return Map.of("count", repo.count());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Language> getById(@PathVariable Long id) {
		return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	@PostMapping
	public ResponseEntity<Language> create(@RequestBody Language body) {
		return ResponseEntity.status(HttpStatus.CREATED).body(repo.save(body));
	}

	@PutMapping("/{id}")
	public ResponseEntity<Language> update(@PathVariable Long id, @RequestBody Language body) {
		return repo.findById(id).map(existing -> {
			body.setId(existing.getId());
			return ResponseEntity.ok(repo.save(body));
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
