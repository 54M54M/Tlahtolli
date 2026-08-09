package com.tlahtolli.api.service;

import com.tlahtolli.api.entity.*;
import com.tlahtolli.api.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Service
public class AchievementService {

	private final AchievementRepository achievementRepo;
	private final UserAchievementRepository userAchievementRepo;
	private final UserStatsRepository statsRepo;
	private final UserRepository userRepo;

	public AchievementService(AchievementRepository achievementRepo, UserAchievementRepository userAchievementRepo,
			UserStatsRepository statsRepo, UserRepository userRepo) {
		this.achievementRepo = achievementRepo;
		this.userAchievementRepo = userAchievementRepo;
		this.statsRepo = statsRepo;
		this.userRepo = userRepo;
	}

	/**
	 * Verifica todos los logros pendientes y desbloquea los que corresponda.
	 * Devuelve la lista de logros recién desbloqueados en esta llamada.
	 */
	@Transactional
	public List<UserAchievement> checkAndUnlock(Integer userId, Integer languageId) {
		List<Achievement> all = achievementRepo.findAll();
		List<UserAchievement> earned = userAchievementRepo.findByUserId(userId);
		UserStats stats = statsRepo.findByUserIdAndLanguageId(userId, languageId).orElse(null);
		User user = userRepo.findById(userId).orElse(null);

		List<UserAchievement> newlyUnlocked = new ArrayList<>();

		for (Achievement a : all) {
			boolean alreadyEarned = earned.stream().anyMatch(ua -> ua.getAchieveId().equals(a.getId()));
			if (alreadyEarned)
				continue;

			if (isMet(a, stats, user)) {
				// UserAchievement SÍ tiene @Builder funcional (no tiene getters manuales
				// duplicados)
				UserAchievement ua = new UserAchievement();
				ua.setUserId(userId);
				ua.setAchieveId(a.getId());
				ua.setEarnedAt(LocalDate.now());
				userAchievementRepo.save(ua);
				newlyUnlocked.add(ua);

				// Dar XP de recompensa
				if (user != null && a.getXpReward() != null && a.getXpReward() > 0) {
					user.setXp(user.getXp() + a.getXpReward());
					user.setTotalXp(user.getTotalXp() + a.getXpReward());
					userRepo.save(user);
				}
			}
		}
		return newlyUnlocked;
	}

	/** Devuelve todos los logros con flag de si el usuario los tiene. */
	public List<AchievementWithStatus> getAllWithStatus(Integer userId) {
		List<Achievement> all = achievementRepo.findAll();
		List<UserAchievement> earned = userAchievementRepo.findByUserId(userId);

		return all.stream().map(a -> {
			UserAchievement ua = earned.stream().filter(x -> x.getAchieveId().equals(a.getId())).findFirst()
					.orElse(null);
			return new AchievementWithStatus(a, ua != null, ua != null ? ua.getEarnedAt() : null);
		}).toList();
	}

	// ── privados ──────────────────────────────────────────────────────────────

	private boolean isMet(Achievement a, UserStats stats, User user) {
		if (a.getRequirement() == null || stats == null || user == null)
			return false;
		String req = a.getRequirement().toLowerCase(Locale.ROOT);
		return isLessonReq(req, stats) || isStreakReq(req, user) || isStatReq(req, stats);
	}

	private boolean isLessonReq(String req, UserStats stats) {
		if (req.contains("completar 1 lección") || req.contains("primera lección"))
			return stats.getLessonsDone() >= 1;
		if (req.contains("10 lecciones perfectas"))
			return stats.getPerfectLess() >= 10;
		return false;
	}

	private boolean isStreakReq(String req, User user) {
		if (req.contains("7 días"))
			return user.getStreak() >= 7;
		if (req.contains("30 días"))
			return user.getStreak() >= 30;
		return false;
	}

	private boolean isStatReq(String req, UserStats stats) {
		if (req.contains("50 palabras"))
			return stats.getWordsLearned() >= 50;
		if (req.contains("1000 minutos"))
			return stats.getTotalMins() >= 1000;
		return false;
	}

	// ── DTO interno ───────────────────────────────────────────────────────────
	public record AchievementWithStatus(Achievement achievement, boolean earned, LocalDate earnedAt) {
	}
}