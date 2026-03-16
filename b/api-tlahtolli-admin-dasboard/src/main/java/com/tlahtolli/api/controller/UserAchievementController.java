package com.tlahtolli.api.controller;

import com.tlahtolli.api.service.AchievementService;
import com.tlahtolli.api.service.AchievementService.AchievementWithStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user-achievements")
public class UserAchievementController {

	private final AchievementService achievementService;

	public UserAchievementController(AchievementService achievementService) {
		this.achievementService = achievementService;
	}

	/**
	 * Todos los logros con estado earned/pending para un usuario. GET
	 * /api/user-achievements?userId=1 Reemplaza getAllAchievementsWithProgress()
	 * del frontend.
	 */
	@GetMapping
	public ResponseEntity<List<AchievementWithStatus>> getAll(@RequestParam Long userId) {
		return ResponseEntity.ok(achievementService.getAllWithStatus(userId));
	}
}