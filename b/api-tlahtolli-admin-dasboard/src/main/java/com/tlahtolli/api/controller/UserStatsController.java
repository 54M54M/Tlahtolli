package com.tlahtolli.api.controller;

import com.tlahtolli.api.dto.response.UserStatsResponse;
import com.tlahtolli.api.entity.UserStats;
import com.tlahtolli.api.repository.UserStatsRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user-stats")
public class UserStatsController {

    private final UserStatsRepository repo;

    public UserStatsController(UserStatsRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public ResponseEntity<?> getAll(@RequestParam(required = false) Integer userId,
            @RequestParam(required = false) Integer languageId) {

        if (userId != null && languageId != null) {
            return repo.findByUserIdAndLanguageId(userId, languageId)
                    .map(UserStatsResponse::from)
                    .map(ResponseEntity::ok)
                    .orElse(ResponseEntity.notFound().build());
        }
        if (userId != null) {
            List<UserStatsResponse> result = repo.findByUserId(userId).stream()
                    .map(UserStatsResponse::from).toList();
            return ResponseEntity.ok(result);
        }
        List<UserStatsResponse> result = repo.findAll().stream()
                .map(UserStatsResponse::from).toList();
        return ResponseEntity.ok(result);
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserStatsResponse> getById(@PathVariable Integer id) {
        return repo.findById(id).map(UserStatsResponse::from).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<UserStatsResponse> create(@RequestBody UserStats s) {
        return ResponseEntity.status(HttpStatus.CREATED).body(UserStatsResponse.from(repo.save(s)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserStatsResponse> update(@PathVariable Integer id, @RequestBody UserStats s) {
        return repo.findById(id).map(existing -> {
            s.setId(existing.getId());
            return ResponseEntity.ok(UserStatsResponse.from(repo.save(s)));
        }).orElse(ResponseEntity.notFound().build());
    }
}
