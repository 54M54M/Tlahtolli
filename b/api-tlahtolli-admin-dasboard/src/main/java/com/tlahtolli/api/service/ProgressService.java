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
	private final UnitVocabRepository unitVocabRepo;
	private final AchievementService achievementService;

	public ProgressService(UserProgressRepository progressRepo, UserStatsRepository statsRepo,
			LessonHistoryRepository historyRepo, UserRepository userRepo, UnitRepository unitRepo,
			UnitVocabRepository unitVocabRepo, AchievementService achievementService) {
		this.progressRepo = progressRepo;
		this.statsRepo = statsRepo;
		this.historyRepo = historyRepo;
		this.userRepo = userRepo;
		this.unitRepo = unitRepo;
		this.unitVocabRepo = unitVocabRepo;
		this.achievementService = achievementService;
	}

	@Transactional
	public Map<String, Object> completeLesson(Integer userId, Integer unitId, Integer languageId, double performance,
			int earnedExp, int correctAns, int totalExerc, int timeSeconds) {

		if (unitId == null || unitId == 0) {
			return completeQuickLevel(userId, languageId, performance, earnedExp, correctAns, totalExerc, timeSeconds);
		}

		boolean wasAlreadyCompleted = historyRepo.existsByUserIdAndUnitId(userId, unitId);

		LessonHistory history = new LessonHistory();
		history.setUserId(userId);
		history.setUnitId(unitId);
		history.setCompletedAt(LocalDate.now());
		history.setPerformance(BigDecimal.valueOf(performance));
		history.setEarnedExp(earnedExp);
		history.setCorrectAns((short) correctAns);
		history.setTotalExerc((short) totalExerc);
		history.setTimeSeconds(timeSeconds);
		history.setWasPerfect((short) (performance >= 0.9 ? 1 : 0));
		historyRepo.save(history);

		UserProgress up = progressRepo.findByUserIdAndUnitId(userId, unitId).orElseGet(() -> {
			UserProgress p = new UserProgress();
			p.setUserId(userId);
			p.setUnitId(unitId);
			p.setIsLocked((short) 0);
			return p;
		});
		up.setCompleted((short) 1);
		up.setIsCurrent((short) 0);
		up.setCompletedAt(LocalDate.now());
		progressRepo.save(up);

		Integer nextUnitId = unlockNextUnit(userId, unitId);

		User user = userRepo.findById(userId).orElseThrow();
		user.setXp(user.getXp() + earnedExp);
		user.setTotalXp(user.getTotalXp() + earnedExp);
		userRepo.save(user);

		if (!wasAlreadyCompleted) {
			UserStats stats = getOrCreateStats(userId, languageId);
			stats.setLessonsDone(stats.getLessonsDone() + 1);

			int vocabCount = unitVocabRepo.findByUnitId(unitId).size();
			if (vocabCount > 0) {
				stats.setWordsLearned(stats.getWordsLearned() + vocabCount);
			}

			if (performance >= 0.9) {
				stats.setPerfectLess(stats.getPerfectLess() + 1);
			}
			stats.setDaysStudied(stats.getDaysStudied() + 1);
			statsRepo.save(stats);
		}

		List<UserAchievement> newAchievements = achievementService.checkAndUnlock(userId, languageId);

		Map<String, Object> result = new HashMap<>();
		result.put("xpEarned", earnedExp);
		result.put("wasAlreadyCompleted", wasAlreadyCompleted);
		result.put("perfectLesson", !wasAlreadyCompleted && performance >= 0.9);
		result.put("nextUnitId", nextUnitId);
		result.put("newAchievements", newAchievements.size());
		result.put("userXp", user.getXp());
		return result;
	}

	private Map<String, Object> completeQuickLevel(Integer userId, Integer languageId, double performance,
			int earnedExp, int correctAns, int totalExerc, int timeSeconds) {

		User user = userRepo.findById(userId).orElseThrow();
		user.setXp(user.getXp() + earnedExp);
		user.setTotalXp(user.getTotalXp() + earnedExp);
		userRepo.save(user);

		List<UserAchievement> newAchievements = achievementService.checkAndUnlock(userId, languageId);

		Map<String, Object> result = new HashMap<>();
		result.put("xpEarned", earnedExp);
		result.put("wasAlreadyCompleted", false);
		result.put("perfectLesson", performance >= 0.9);
		result.put("nextUnitId", null);
		result.put("newAchievements", newAchievements.size());
		result.put("userXp", user.getXp());
		return result;
	}

	public Map<String, Object> getUserProgress(Integer userId, Integer languageId) {
		List<UserProgress> progressList = progressRepo.findByUserId(userId);
		UserStats stats = getOrCreateStats(userId, languageId);
		Map<String, Object> result = new HashMap<>();
		result.put("progress", progressList);
		result.put("stats", stats);
		return result;
	}

	@Transactional
	public void initializeProgress(Integer userId, Integer firstUnitId) {
		boolean exists = progressRepo.findByUserIdAndUnitId(userId, firstUnitId).isPresent();
		if (!exists) {
			UserProgress first = new UserProgress();
			first.setUserId(userId);
			first.setUnitId(firstUnitId);
			first.setIsLocked((short) 0);
			first.setIsCurrent((short) 1);
			first.setCompleted((short) 0);
			progressRepo.save(first);
		}
	}

	private Integer unlockNextUnit(Integer userId, Integer completedUnitId) {
		Unit completed = unitRepo.findById(completedUnitId).orElse(null);
		if (completed == null) return null;

		List<Unit> siblings = unitRepo.findByLevelIdOrderByUnitNum(completed.getLevelId());
		for (int i = 0; i < siblings.size() - 1; i++) {
			if (siblings.get(i).getId().equals(completedUnitId)) {
				Unit next = siblings.get(i + 1);
				UserProgress nextUp = progressRepo.findByUserIdAndUnitId(userId, next.getId()).orElseGet(() -> {
					UserProgress p = new UserProgress();
					p.setUserId(userId);
					p.setUnitId(next.getId());
					p.setCompleted((short) 0);
					return p;
				});
				nextUp.setIsLocked((short) 0);
				nextUp.setIsCurrent((short) 1);
				progressRepo.save(nextUp);
				return next.getId();
			}
		}
		return null;
	}

	private UserStats getOrCreateStats(Integer userId, Integer languageId) {
		return statsRepo.findByUserIdAndLanguageId(userId, languageId).orElseGet(() -> {
			UserStats s = new UserStats();
			s.setUserId(userId);
			s.setLanguageId(languageId);
			s.setWordsLearned(0);
			s.setLessonsDone(0);
			s.setPerfectLess(0);
			s.setDaysStudied(0);
			s.setBestStreak((short) 0);
			s.setTotalMins(0);
			return statsRepo.save(s);
		});
	}
}
