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

import com.tlahtolli.api.entity.Unit;
import com.tlahtolli.api.repository.UnitRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/units")
public class UnitController {

	private final UnitRepository repo;

	public UnitController(UnitRepository repo) {
		super();
		this.repo = repo;
	}

	@GetMapping
	public List<Unit> getAll() {
		return repo.findAll();
	}

	@GetMapping("/count")
	public Map<String, Long> count() {
		return Map.of("count", repo.count());
	}

	@GetMapping("/{id}")
	public ResponseEntity<Unit> getById(@PathVariable Integer id) {
		return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	@PostMapping
	public ResponseEntity<Unit> create(@RequestBody Unit u) {
		return ResponseEntity.status(HttpStatus.CREATED).body(repo.save(u));
	}

	@PutMapping("/{id}")
	public ResponseEntity<Unit> update(@PathVariable Integer id, @RequestBody Unit u) {
		return repo.findById(id).map(ex -> {
			u.setId(ex.getId());
			return ResponseEntity.ok(repo.save(u));
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
