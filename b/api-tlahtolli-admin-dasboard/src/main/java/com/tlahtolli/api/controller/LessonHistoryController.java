package com.tlahtolli.api.controller;

import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tlahtolli.api.entity.LessonHistory;
import com.tlahtolli.api.repository.LessonHistoryRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/lesson-history")
public class LessonHistoryController {

	private final LessonHistoryRepository repo;

	public LessonHistoryController(LessonHistoryRepository repo) {
		super();
		this.repo = repo;
	}

	@GetMapping
	public List<LessonHistory> getAll() {
		return repo.findAllByOrderByCompletedAtDesc();
	}

	@GetMapping("/count")
	public Map<String, Long> count() {
		return Map.of("count", repo.count());
	}
}
