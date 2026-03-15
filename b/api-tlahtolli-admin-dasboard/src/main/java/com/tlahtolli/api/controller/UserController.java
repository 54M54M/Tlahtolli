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

import com.tlahtolli.api.entity.User;
import com.tlahtolli.api.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/users")
public class UserController {

	private final UserRepository repo;

	public UserController(UserRepository repo) {
		super();
		this.repo = repo;
	}

	@GetMapping
	public List<User> getAll() {
		return repo.findAll();
	}

	@GetMapping("/count")
	public Map<String, Long> count() {
		return Map.of("count", repo.count());
	}

	@GetMapping("/{id}")
	public ResponseEntity<User> getById(@PathVariable Long id) {
		return repo.findById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	@PostMapping
	public ResponseEntity<User> create(@RequestBody User u) {
		return ResponseEntity.status(HttpStatus.CREATED).body(repo.save(u));
	}

	@PutMapping("/{id}")
	public ResponseEntity<User> update(@PathVariable Long id, @RequestBody User u) {
		return repo.findById(id).map(ex -> {
			u.setId(ex.getId());
			return ResponseEntity.ok(repo.save(u));
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