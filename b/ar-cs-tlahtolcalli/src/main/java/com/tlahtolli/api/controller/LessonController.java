package com.tlahtolli.api.controller;

import com.tlahtolli.api.dto.request.LessonRequest;
import com.tlahtolli.api.dto.response.LessonResponse;
import com.tlahtolli.api.entity.Lesson;
import com.tlahtolli.api.repository.LessonRepository;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/lessons")
public class LessonController {

    private final LessonRepository repo;

    public LessonController(LessonRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<LessonResponse> getAll(@RequestParam(required = false) Integer unitId) {
        List<Lesson> lessons = unitId != null ? repo.findByUnitId(unitId) : repo.findAll();
        return lessons.stream().map(LessonResponse::from).toList();
    }

    @GetMapping("/count")
    public Map<String, Long> count() {
        return Map.of("count", repo.count());
    }

    @GetMapping("/{id}")
    public ResponseEntity<LessonResponse> getById(@PathVariable Long id) {
        return repo.findById(id).map(LessonResponse::from).map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }

    @PostMapping
    public ResponseEntity<LessonResponse> create(@Valid @RequestBody LessonRequest dto) {
        Lesson lesson = Lesson.builder()
                .unitId(Math.toIntExact(dto.unitId()))
                .lessonNum(dto.lessonNum())
                .title(dto.title())
                .description(dto.description())
                .isFree(dto.isFree() != null ? dto.isFree() : 0)
                .xpReward(dto.xpReward() != null ? dto.xpReward() : 10)
                .build();
        return ResponseEntity.status(HttpStatus.CREATED).body(LessonResponse.from(repo.save(lesson)));
    }

    @PutMapping("/{id}")
    public ResponseEntity<LessonResponse> update(@PathVariable Long id, @Valid @RequestBody LessonRequest dto) {
        return repo.findById(id).map(existing -> {
            existing.setUnitId(Math.toIntExact(dto.unitId()));
            existing.setLessonNum(dto.lessonNum());
            existing.setTitle(dto.title());
            existing.setDescription(dto.description());
            existing.setIsFree(dto.isFree() != null ? dto.isFree() : existing.getIsFree());
            existing.setXpReward(dto.xpReward() != null ? dto.xpReward() : existing.getXpReward());
            return ResponseEntity.ok(LessonResponse.from(repo.save(existing)));
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
