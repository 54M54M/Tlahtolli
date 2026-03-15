package com.tlahtolli.api.controller;

import com.tlahtolli.api.entity.Vocabulary;
import com.tlahtolli.api.repository.VocabularyRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import java.util.*;

@RestController
@RequestMapping("/api/vocabulary")
public class VocabularyController {

	private final VocabularyRepository repo;

	public VocabularyController(VocabularyRepository repo) {
		super();
		this.repo = repo;
	}

	@GetMapping
	public List<Vocabulary> getAll(@RequestParam(required = false) Long languageId) {
		if (languageId != null)
			return repo.findByLanguageId(languageId);
		return repo.findAll();
	}

	@GetMapping("/count")
	public Map<String, Long> count() {
		return Map.of("count", repo.count());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Vocabulary> getById(@PathVariable Long id) {
		return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	@PostMapping
	public ResponseEntity<Vocabulary> create(@RequestBody Vocabulary v) {
		return ResponseEntity.status(HttpStatus.CREATED).body(repo.save(v));
	}

	@PutMapping("/{id}")
	public ResponseEntity<Vocabulary> update(@PathVariable Long id, @RequestBody Vocabulary v) {
		return repo.findById(id).map(ex -> {
			v.setId(ex.getId());
			return ResponseEntity.ok(repo.save(v));
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
