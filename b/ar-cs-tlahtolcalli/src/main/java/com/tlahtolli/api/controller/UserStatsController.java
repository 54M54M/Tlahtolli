package com.tlahtolli.api.controller;

import com.tlahtolli.api.dto.request.UpdateUserStatsRequest;
import com.tlahtolli.api.dto.request.UserStatsRequest;
import com.tlahtolli.api.dto.response.UserStatsResponse;
import com.tlahtolli.api.entity.UserStats;
import com.tlahtolli.api.repository.UserStatsRepository;
import jakarta.validation.Valid;
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
    public ResponseEntity<UserStatsResponse> create(@Valid @RequestBody UserStatsRequest s) {
        UserStats entity = new UserStats();
        entity.setUserId(s.userId());
        entity.setLanguageId(s.languageId());
        entity.setWordsLearned(s.wordsLearned() != null ? s.wordsLearned() : 0);
        entity.setLessonsDone(s.lessonsDone() != null ? s.lessonsDone() : 0);
        entity.setPerfectLess(s.perfectLess() != null ? s.perfectLess() : 0);
        entity.setDaysStudied(s.daysStudied() != null ? s.daysStudied() : 0);
        entity.setBestStreak(s.bestStreak() != null ? s.bestStreak() : 0);
        entity.setTotalMins(s.totalMins() != null ? s.totalMins() : 0);
        return ResponseEntity.status(HttpStatus.CREATED).body(UserStatsResponse.from(repo.save(entity)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserStatsResponse> update(@PathVariable Integer id, @Valid @RequestBody UpdateUserStatsRequest s) {
        return repo.findById(id).map(existing -> {
            existing.setWordsLearned(s.wordsLearned() != null ? s.wordsLearned() : existing.getWordsLearned());
            existing.setLessonsDone(s.lessonsDone() != null ? s.lessonsDone() : existing.getLessonsDone());
            existing.setPerfectLess(s.perfectLess() != null ? s.perfectLess() : existing.getPerfectLess());
            existing.setDaysStudied(s.daysStudied() != null ? s.daysStudied() : existing.getDaysStudied());
            existing.setBestStreak(s.bestStreak() != null ? s.bestStreak() : existing.getBestStreak());
            existing.setTotalMins(s.totalMins() != null ? s.totalMins() : existing.getTotalMins());
            return ResponseEntity.ok(UserStatsResponse.from(repo.save(existing)));
        }).orElse(ResponseEntity.notFound().build());
    }
}
