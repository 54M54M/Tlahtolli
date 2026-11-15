package com.tlahtolli.api.controller;

import org.springframework.cache.annotation.CacheEvict;
import com.tlahtolli.api.config.CacheConfig;
import org.springframework.cache.annotation.Cacheable;
import com.tlahtolli.api.entity.WritingSystem;
import com.tlahtolli.api.repository.WritingSystemRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/writing-systems")
public class WritingSystemController {

	private final WritingSystemRepository repo;

	public WritingSystemController(WritingSystemRepository repo) {
		this.repo = repo;
	}

	/**
	 * GET /api/writing-systems → todos GET /api/writing-systems?languageId=1 → por
	 * idioma GET /api/writing-systems?languageId=1&type=syllabary → específico
	 * Usado por SyllabaryRepository del frontend (GlossaryView / SyllabaryContent).
	 */
	@GetMapping
	@Cacheable(cacheNames = CacheConfig.CATALOGO, key = "'escritura:' + #p0 + ':' + #p1")
	public ResponseEntity<?> getAll(@RequestParam(required = false) Long languageId,
			@RequestParam(required = false) String type) {

		if (languageId != null && type != null) {
			return repo.findByLanguageIdAndSystemType(languageId, type).map(ResponseEntity::ok)
					.orElse(ResponseEntity.notFound().build());
		}
		if (languageId != null) {
			return ResponseEntity.ok(repo.findByLanguageId(languageId));
		}
		return ResponseEntity.ok(repo.findAll());
	}

	@GetMapping("/{id}")
	public ResponseEntity<WritingSystem> getById(@PathVariable Long id) {
		return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	@CacheEvict(cacheNames = CacheConfig.CATALOGO, allEntries = true)
	@PostMapping
	public ResponseEntity<WritingSystem> create(@RequestBody WritingSystem ws) {
		return ResponseEntity.status(HttpStatus.CREATED).body(repo.save(ws));
	}

	@CacheEvict(cacheNames = CacheConfig.CATALOGO, allEntries = true)
	@PutMapping("/{id}")
	public ResponseEntity<WritingSystem> update(@PathVariable Long id, @RequestBody WritingSystem ws) {
		return repo.findById(id).map(existing -> {
			ws.setId(existing.getId());
			return ResponseEntity.ok(repo.save(ws));
		}).orElse(ResponseEntity.notFound().build());
	}

	@CacheEvict(cacheNames = CacheConfig.CATALOGO, allEntries = true)
	@DeleteMapping("/{id}")
	public ResponseEntity<Void> delete(@PathVariable Long id) {
		if (!repo.existsById(id))
			return ResponseEntity.notFound().build();
		repo.deleteById(id);
		return ResponseEntity.noContent().build();
	}
}