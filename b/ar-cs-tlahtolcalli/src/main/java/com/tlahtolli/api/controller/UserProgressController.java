package com.tlahtolli.api.controller;

import com.tlahtolli.api.dto.request.CompleteLessonRequest;
import com.tlahtolli.api.dto.request.InitProgressRequest;
import com.tlahtolli.api.dto.response.LessonCompletionResponse;
import com.tlahtolli.api.entity.UserProgress;
import com.tlahtolli.api.repository.UserProgressRepository;
import com.tlahtolli.api.service.LessonCompletionFacade;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user-progress")
public class UserProgressController {

	private final UserProgressRepository repo;
	private final LessonCompletionFacade facade;

	public UserProgressController(UserProgressRepository repo, LessonCompletionFacade facade) {
		this.repo = repo;
		this.facade = facade;
	}

	@GetMapping
	public List<UserProgress> getAll(@RequestParam(required = false) Integer userId) {
		if (userId != null)
			return repo.findByUserId(userId);
		return repo.findAll();
	}

	@GetMapping("/user/{userId}/unit/{unitId}")
	public ResponseEntity<UserProgress> getByUserAndUnit(@PathVariable Integer userId, @PathVariable Integer unitId) {
		return repo.findByUserIdAndUnitId(userId, unitId).map(ResponseEntity::ok)
				.orElse(ResponseEntity.notFound().build());
	}

	@PostMapping("/complete")
	public ResponseEntity<LessonCompletionResponse> completeLesson(@Valid @RequestBody CompleteLessonRequest req) {
		LessonCompletionResponse result = (req.unitId() == null || req.unitId() == 0) && req.levelId() != null
				? facade.completeQuickLevel(req)
				: facade.completeLesson(req);
		return ResponseEntity.status(HttpStatus.CREATED).body(result);
	}

	@PostMapping("/init")
	public ResponseEntity<Void> init(@Valid @RequestBody InitProgressRequest req) {
		facade.initializeProgress(req.userId(), req.firstUnitId());
		return ResponseEntity.ok().build();
	}
}