package com.tlahtolli.api.service;

import com.tlahtolli.api.entity.*;
import com.tlahtolli.api.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class ProgressService {

	private static final Logger log = LoggerFactory.getLogger(ProgressService.class);

	private final UserProgressRepository progressRepo;
	private final UserStatsRepository statsRepo;
	private final LessonHistoryRepository historyRepo;
	private final UserRepository userRepo;
	private final UnitRepository unitRepo;
	private final UnitVocabRepository unitVocabRepo;
	private final LevelRepository levelRepo;
	private final AchievementService achievementService;

	public ProgressService(UserProgressRepository progressRepo, UserStatsRepository statsRepo,
			LessonHistoryRepository historyRepo, UserRepository userRepo, UnitRepository unitRepo,
			UnitVocabRepository unitVocabRepo, LevelRepository levelRepo, AchievementService achievementService) {
		this.progressRepo = progressRepo;
		this.statsRepo = statsRepo;
		this.historyRepo = historyRepo;
		this.userRepo = userRepo;
		this.unitRepo = unitRepo;
		this.unitVocabRepo = unitVocabRepo;
		this.levelRepo = levelRepo;
		this.achievementService = achievementService;
	}

	@Transactional
	public Map<String, Object> completeLesson(Integer userId, Integer unitId, Integer languageId, double performance,
			int earnedExp, int correctAns, int totalExerc, int timeSeconds) {
		log.info("Completing lesson for userId={}, unitId={}, languageId={}, performance={}", userId, unitId, languageId, performance);

		if (unitId == null || unitId == 0) {
			log.debug("unitId is null/0, routing to completeQuickLevel for userId={}", userId);
			return completeQuickLevel(userId, null, languageId, performance, earnedExp, correctAns, totalExerc, timeSeconds);
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
		log.info("Lesson completed for userId={}, unitId={}: xpEarned={}, newAchievements={}", userId, unitId, earnedExp, newAchievements.size());

		Map<String, Object> result = new HashMap<>();
		result.put("xpEarned", earnedExp);
		result.put("wasAlreadyCompleted", wasAlreadyCompleted);
		result.put("perfectLesson", !wasAlreadyCompleted && performance >= 0.9);
		result.put("nextUnitId", nextUnitId);
		result.put("newAchievements", newAchievements.size());
		result.put("userXp", user.getXp());
		return result;
	}

	private Map<String, Object> completeQuickLevel(Integer userId, Integer levelId, Integer languageId, double performance,
			int earnedExp, int correctAns, int totalExerc, int timeSeconds) {
		return completeQuickLevelPublic(userId, levelId, languageId, performance, earnedExp, correctAns, totalExerc, timeSeconds);
	}

	@Transactional
	public Map<String, Object> completeQuickLevelPublic(Integer userId, Integer levelId, Integer languageId, double performance,
			int earnedExp, int correctAns, int totalExerc, int timeSeconds) {
		log.info("Completing quick level for userId={}, levelId={}, performance={}", userId, levelId, performance);

		boolean nextLevelUnlocked = false;

		if (levelId != null && performance >= 0.8) {
			// Marcar todas las unidades del nivel actual como completadas y desbloqueadas
			List<Unit> currentUnits = unitRepo.findByLevelIdOrderByUnitNum(levelId);
			for (Unit unit : currentUnits) {
				UserProgress up = progressRepo.findByUserIdAndUnitId(userId, unit.getId()).orElseGet(() -> {
					UserProgress p = new UserProgress();
					p.setUserId(userId);
					p.setUnitId(unit.getId());
					return p;
				});
				up.setIsLocked((short) 0);
				up.setCompleted((short) 1);
				progressRepo.save(up);
			}

			// Desbloquear la primera unidad del siguiente nivel
			Level currentLevel = levelRepo.findById(levelId).orElse(null);
			if (currentLevel != null) {
				List<Level> levels = levelRepo.findByLanguageId(currentLevel.getLanguageId());
				Optional<Level> nextLevel = levels.stream()
						.filter(l -> l.getLevelNum() == currentLevel.getLevelNum() + 1)
						.findFirst();
				if (nextLevel.isPresent()) {
					List<Unit> nextUnits = unitRepo.findByLevelIdOrderByUnitNum(nextLevel.get().getId());
					if (!nextUnits.isEmpty()) {
						Unit firstUnit = nextUnits.get(0);
						UserProgress up = progressRepo.findByUserIdAndUnitId(userId, firstUnit.getId()).orElseGet(() -> {
							UserProgress p = new UserProgress();
							p.setUserId(userId);
							p.setUnitId(firstUnit.getId());
							p.setCompleted((short) 0);
							return p;
						});
						up.setIsLocked((short) 0);
						up.setIsCurrent((short) 1);
						progressRepo.save(up);
						nextLevelUnlocked = true;
					}
				}
			}
		}

		User user = userRepo.findById(userId).orElseThrow();
		user.setXp(user.getXp() + earnedExp);
		user.setTotalXp(user.getTotalXp() + earnedExp);
		userRepo.save(user);

		if (levelId != null && languageId != null) {
			List<Unit> units = unitRepo.findByLevelIdOrderByUnitNum(levelId);
			UserStats stats = getOrCreateStats(userId, languageId);
			stats.setLessonsDone(stats.getLessonsDone() + units.size());
			int totalVocab = units.stream().mapToInt(u -> unitVocabRepo.findByUnitId(u.getId()).size()).sum();
			if (totalVocab > 0) stats.setWordsLearned(stats.getWordsLearned() + totalVocab);
			if (performance >= 0.9) stats.setPerfectLess(stats.getPerfectLess() + 1);
			stats.setDaysStudied(stats.getDaysStudied() + 1);
			stats.setTotalMins(stats.getTotalMins() + (timeSeconds / 60));
			statsRepo.save(stats);
		}

		List<UserAchievement> newAchievements = achievementService.checkAndUnlock(userId, languageId);
		log.info("Quick level completed for userId={}: xpEarned={}, nextLevelUnlocked={}", userId, earnedExp, nextLevelUnlocked);

		Map<String, Object> result = new HashMap<>();
		result.put("xpEarned", earnedExp);
		result.put("wasAlreadyCompleted", false);
		result.put("perfectLesson", performance >= 0.9);
		result.put("nextUnitId", null);
		result.put("nextLevelUnlocked", nextLevelUnlocked);
		result.put("newAchievements", newAchievements.size());
		result.put("userXp", user.getXp());
		return result;
	}

	public Map<String, Object> getUserProgress(Integer userId, Integer languageId) {
		log.debug("Getting progress for userId={}, languageId={}", userId, languageId);
		List<UserProgress> progressList = progressRepo.findByUserId(userId);
		UserStats stats = getOrCreateStats(userId, languageId);
		Map<String, Object> result = new HashMap<>();
		result.put("progress", progressList);
		result.put("stats", stats);
		return result;
	}

	@Transactional
	public void initializeProgress(Integer userId, Integer firstUnitId) {
		log.info("Initializing progress for userId={}, firstUnitId={}", userId, firstUnitId);
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
		if (completed == null) {
			log.warn("Unit not found for unlock: unitId={}", completedUnitId);
			return null;
		}

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
