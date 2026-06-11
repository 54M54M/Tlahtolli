package com.tlahtolli.api.controller;

import com.tlahtolli.api.dto.request.AchievementRequest;
import com.tlahtolli.api.dto.response.AchievementResponse;
import com.tlahtolli.api.entity.Achievement;
import com.tlahtolli.api.repository.AchievementRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/achievements")
public class AchievementController {

    private final AchievementRepository repo;

    public AchievementController(AchievementRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<AchievementResponse> getAll() {
        return repo.findAll().stream().map(AchievementResponse::from).toList();
    }

    @GetMapping("/count")
    public Map<String, Long> count() {
        return Map.of("count", repo.count());
    }

    @GetMapping("/{id}")
    public ResponseEntity<AchievementResponse> getById(@PathVariable Long id) {
        return repo.findById(id).map(AchievementResponse::from).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<AchievementResponse> create(@Valid @RequestBody AchievementRequest dto) {
        Achievement a = Achievement.builder()
                .title(dto.title())
                .description(dto.description())
                .icon(dto.icon())
                .xpReward(dto.xpReward() != null ? dto.xpReward() : 0)
                .requirement(dto.requirement())
                .category(dto.category())
                .rarity(dto.rarity())
                .build();
        return ResponseEntity.status(HttpStatus.CREATED).body(AchievementResponse.from(repo.save(a)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<AchievementResponse> update(@PathVariable Long id, @Valid @RequestBody AchievementRequest dto) {
        return repo.findById(id).map(existing -> {
            existing.setTitle(dto.title());
            existing.setDescription(dto.description());
            existing.setIcon(dto.icon());
            existing.setXpReward(dto.xpReward() != null ? dto.xpReward() : existing.getXpReward());
            existing.setRequirement(dto.requirement());
            existing.setCategory(dto.category());
            existing.setRarity(dto.rarity());
            return ResponseEntity.ok(AchievementResponse.from(repo.save(existing)));
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
