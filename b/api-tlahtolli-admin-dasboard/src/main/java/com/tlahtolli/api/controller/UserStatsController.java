package com.tlahtolli.api.controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.tlahtolli.api.entity.UserStats;
import com.tlahtolli.api.repository.UserStatsRepository;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/user-stats")
public class UserStatsController {

	private final UserStatsRepository repo;

	public UserStatsController(UserStatsRepository repo) {
		super();
		this.repo = repo;
	}

	@GetMapping
	public List<UserStats> getAll() {
		return repo.findAll();
	}
}