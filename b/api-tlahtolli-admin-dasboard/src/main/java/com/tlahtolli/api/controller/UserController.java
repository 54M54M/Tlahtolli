package com.tlahtolli.api.controller;

import com.tlahtolli.api.entity.User;
import com.tlahtolli.api.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
public class UserController {

	private final UserService userService;

	public UserController(UserService userService) {
		this.userService = userService;
	}

	@GetMapping
	public List<User> getAll() {
		return userService.getAll();
	}

	@GetMapping("/count")
	public Map<String, Long> count() {
		return Map.of("count", (long) userService.getAll().size());
	}

	@GetMapping("/{id}")
	public ResponseEntity<User> getById(@PathVariable Long id) {
		return userService.getById(id).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	@GetMapping("/by-username/{username}")
	public ResponseEntity<User> getByUsername(@PathVariable String username) {
		return userService.getByUsername(username).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	@PostMapping
	public ResponseEntity<?> create(@RequestBody User user) {
		try {
			return ResponseEntity.status(HttpStatus.CREATED).body(userService.create(user));
		} catch (IllegalArgumentException e) {
			return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
		}
	}

	@PutMapping("/{id}")
	public ResponseEntity<User> update(@PathVariable Long id, @RequestBody User body) {
		return userService.update(id, body).map(ResponseEntity::ok).orElse(ResponseEntity.notFound().build());
	}

	/**
	 * Cambia el idioma activo del usuario. PUT /api/users/{id}/language Body: {
	 * "languageId": 1 } Usado por authStore.setLanguage() del frontend.
	 */
	@PutMapping("/{id}/language")
	public ResponseEntity<User> switchLanguage(@PathVariable Long id, @RequestBody Map<String, Object> body) {
		Long languageId = Long.parseLong(body.get("languageId").toString());
		return userService.switchLanguage(id, languageId).map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}

	@DeleteMapping("/{id}")
	public ResponseEntity<Void> delete(@PathVariable Long id) {
		return userService.delete(id) ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
	}
}