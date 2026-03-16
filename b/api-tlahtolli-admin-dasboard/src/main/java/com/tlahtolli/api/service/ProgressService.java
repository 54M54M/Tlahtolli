package com.tlahtolli.api.service;

import com.tlahtolli.api.entity.*;
import com.tlahtolli.api.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ProgressService {

	private final UserProgressRepository progressRepo;
	private final UserStatsRepository statsRepo;
	private final LessonHistoryRepository historyRepo;
	private final UserRepository userRepo;
	private final UnitRepository unitRepo;
	private final AchievementService achievementService;

	public ProgressService(UserProgressRepository progressRepo, UserStatsRepository statsRepo,
			LessonHistoryRepository historyRepo, UserRepository userRepo, UnitRepository unitRepo,
			AchievementService achievementService) {
		this.progressRepo = progressRepo;
		this.statsRepo = statsRepo;
		this.historyRepo = historyRepo;
		this.userRepo = userRepo;
		this.unitRepo = unitRepo;
		this.achievementService = achievementService;
	}

	/**
	 * Punto de entrada principal cuando el usuario completa una lección. Actualiza
	 * en una sola transacción: LESSON_HISTORY, USER_PROGRESS, USERS (XP),
	 * USER_STATS, USER_ACHIEVEMENTS
	 */
	@Transactional
	public Map<String, Object> completeLesson(Long userId, Long unitId, Long languageId, double performance,
			int earnedExp, int correctAns, int totalExerc, long timeSeconds) {

		boolean wasAlreadyCompleted = historyRepo.existsByUserIdAndUnitId(userId, unitId);

		// 1. Guardar en historial (cada intento queda registrado)
		LessonHistory history = new LessonHistory();
		history.setUserId(userId);
		history.setUnitId(unitId);
		history.setCompletedAt(LocalDate.now());
		history.setPerformance(BigDecimal.valueOf(performance));
		history.setEarnedExp(earnedExp);
		history.setCorrectAns(correctAns);
		history.setTotalExerc(totalExerc);
		history.setTimeSeconds(timeSeconds);
		history.setWasPerfect(performance >= 0.9 ? 1 : 0);
		historyRepo.save(history);

		// 2. Actualizar USER_PROGRESS (locked / completed / current)
		UserProgress up = progressRepo.findByUserIdAndUnitId(userId, unitId).orElseGet(() -> {
			UserProgress p = new UserProgress();
			p.setUserId(userId);
			p.setUnitId(unitId);
			p.setIsLocked(0);
			return p;
		});
		up.setCompleted(1);
		up.setIsCurrent(0);
		up.setCompletedAt(LocalDate.now());
		progressRepo.save(up);

		// 3. Desbloquear la siguiente unidad del nivel
		Long nextUnitId = unlockNextUnit(userId, unitId);

		// 4. Dar XP al usuario (siempre, incluso si es repetición)
		User user = userRepo.findById(userId).orElseThrow();
		user.setXp(user.getXp() + earnedExp);
		user.setTotalXp(user.getTotalXp() + earnedExp);
		userRepo.save(user);

		// 5. Actualizar estadísticas SOLO si es la primera vez completando esta unidad
		if (!wasAlreadyCompleted) {
			UserStats stats = getOrCreateStats(userId, languageId);
			stats.setLessonsDone(stats.getLessonsDone() + 1);
			if (performance >= 0.9) {
				stats.setPerfectLess(stats.getPerfectLess() + 1);
			}
			stats.setDaysStudied(stats.getDaysStudied() + 1);
			statsRepo.save(stats);
		}

		// 6. Verificar y desbloquear logros
		List<UserAchievement> newAchievements = achievementService.checkAndUnlock(userId, languageId);

		// 7. Armar respuesta
		Map<String, Object> result = new HashMap<>();
		result.put("xpEarned", earnedExp);
		result.put("wasAlreadyCompleted", wasAlreadyCompleted);
		result.put("perfectLesson", !wasAlreadyCompleted && performance >= 0.9);
		result.put("nextUnitId", nextUnitId);
		result.put("newAchievements", newAchievements.size());
		result.put("userXp", user.getXp());
		return result;
	}

	/** Progreso completo de un usuario para un idioma. */
	public Map<String, Object> getUserProgress(Long userId, Long languageId) {
		List<UserProgress> progressList = progressRepo.findByUserId(userId);
		UserStats stats = getOrCreateStats(userId, languageId);
		Map<String, Object> result = new HashMap<>();
		result.put("progress", progressList);
		result.put("stats", stats);
		return result;
	}

	/** Inicializa el progreso: desbloquea la primera unidad de un idioma. */
	@Transactional
	public void initializeProgress(Long userId, Long firstUnitId) {
		boolean exists = progressRepo.findByUserIdAndUnitId(userId, firstUnitId).isPresent();
		if (!exists) {
			UserProgress first = new UserProgress();
			first.setUserId(userId);
			first.setUnitId(firstUnitId);
			first.setIsLocked(0);
			first.setIsCurrent(1);
			first.setCompleted(0);
			progressRepo.save(first);
		}
	}

	// ── helpers privados ──────────────────────────────────────────────────────

	private Long unlockNextUnit(Long userId, Long completedUnitId) {
		Unit completed = unitRepo.findById(completedUnitId).orElse(null);
		if (completed == null)
			return null;

		List<Unit> siblings = unitRepo.findByLevelIdOrderByUnitNum(completed.getLevelId());
		for (int i = 0; i < siblings.size() - 1; i++) {
			if (siblings.get(i).getId().equals(completedUnitId)) {
				Unit next = siblings.get(i + 1);
				UserProgress nextUp = progressRepo.findByUserIdAndUnitId(userId, next.getId()).orElseGet(() -> {
					UserProgress p = new UserProgress();
					p.setUserId(userId);
					p.setUnitId(next.getId());
					p.setCompleted(0);
					return p;
				});
				nextUp.setIsLocked(0);
				nextUp.setIsCurrent(1);
				progressRepo.save(nextUp);
				return next.getId();
			}
		}
		return null; // era la última unidad del nivel
	}

	private UserStats getOrCreateStats(Long userId, Long languageId) {
		return statsRepo.findByUserIdAndLanguageId(userId, languageId).orElseGet(() -> {
			UserStats s = new UserStats();
			s.setUserId(userId);
			s.setLanguageId(languageId);
			s.setWordsLearned(0);
			s.setLessonsDone(0);
			s.setPerfectLess(0);
			s.setDaysStudied(0);
			s.setBestStreak(0);
			s.setTotalMins(0);
			return statsRepo.save(s);
		});
	}
}