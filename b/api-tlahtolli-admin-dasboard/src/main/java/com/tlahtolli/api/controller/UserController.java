package com.tlahtolli.api.controller;

import com.tlahtolli.api.dto.request.UserRequest;
import com.tlahtolli.api.dto.response.UserResponse;
import com.tlahtolli.api.entity.User;
import com.tlahtolli.api.service.UserService;
import jakarta.validation.Valid;
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
    public List<UserResponse> getAll() {
        return userService.getAll().stream().map(UserResponse::from).toList();
    }

    @GetMapping("/count")
    public Map<String, Long> count() {
        return Map.of("count", (long) userService.getAll().size());
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserResponse> getById(@PathVariable Integer id) {
        return userService.getById(id).map(UserResponse::from).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/by-username/{username}")
    public ResponseEntity<UserResponse> getByUsername(@PathVariable String username) {
        return userService.getByUsername(username).map(UserResponse::from).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<?> create(@Valid @RequestBody UserRequest dto) {
        try {
            User user = new User();
            user.setUsername(dto.username());
            user.setFullName(dto.fullName());
            user.setEmail(dto.email());
            user.setCurrentLang(Math.toIntExact(dto.currentLang()));
            return ResponseEntity.status(HttpStatus.CREATED).body(UserResponse.from(userService.create(user)));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("error", e.getMessage()));
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserResponse> update(@PathVariable Integer id, @Valid @RequestBody UserRequest dto) {
        User body = new User();
        body.setUsername(dto.username());
        body.setFullName(dto.fullName());
        body.setEmail(dto.email());
        body.setCurrentLang(Math.toIntExact(dto.currentLang()));
        return userService.update(id, body).map(UserResponse::from).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PutMapping("/{id}/language")
    public ResponseEntity<?> switchLanguage(@PathVariable Integer id, @RequestBody Map<String, Object> body) {
        Object raw = body.get("languageId");
        if (raw == null)
            return ResponseEntity.badRequest().body(Map.of("error", "languageId es requerido"));
        Integer languageId = Integer.parseInt(raw.toString());
        return userService.switchLanguage(id, languageId).map(UserResponse::from).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Integer id) {
        return userService.delete(id) ? ResponseEntity.noContent().build() : ResponseEntity.notFound().build();
    }
}
