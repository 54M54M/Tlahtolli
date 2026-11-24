package com.tlahtolli.api.service;

import com.tlahtolli.api.entity.*;
import com.tlahtolli.api.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.tlahtolli.api.util.AppTime;

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
	private final StudyStreakService streaks;
	private final UserLevelService levels;

	public ProgressService(UserProgressRepository progressRepo, UserStatsRepository statsRepo,
			LessonHistoryRepository historyRepo, UserRepository userRepo, UnitRepository unitRepo,
			UnitVocabRepository unitVocabRepo, LevelRepository levelRepo, StudyStreakService streaks,
			UserLevelService levels) {
		this.progressRepo = progressRepo;
		this.statsRepo = statsRepo;
		this.historyRepo = historyRepo;
		this.userRepo = userRepo;
		this.unitRepo = unitRepo;
		this.unitVocabRepo = unitVocabRepo;
		this.levelRepo = levelRepo;
		this.streaks = streaks;
		this.levels = levels;
	}

	/**
	 * Marca el día como estudiado y recalcula: días estudiados y mejor racha del idioma (stats),
	 * racha actual y último día del usuario. Cuenta también al repetir una lección.
	 */
	private void applyStudyDay(User user, UserStats stats, Integer languageId, LocalDate day) {
		streaks.markDay(user.getId(), languageId, day);
		stats.setDaysStudied(streaks.daysStudied(user.getId(), languageId));
		short best = stats.getBestStreak() == null ? 0 : stats.getBestStreak();
		stats.setBestStreak((short) Math.min(Short.MAX_VALUE, Math.max(best, streaks.bestRun(user.getId(), languageId))));
		StudyStreakService.Run run = streaks.currentRun(user.getId());
		user.setStreak((short) Math.min(Short.MAX_VALUE, run.length()));
		user.setLastStudyDate(run.lastDay());
	}

	@Transactional
	public Map<String, Object> completeLesson(Integer userId, Integer unitId, Integer languageId, double performance,
			int earnedExp, int correctAns, int totalExerc, int timeSeconds, LocalDate day) {
		log.info("Completing lesson for userId={}, unitId={}, languageId={}, performance={}", userId, unitId, languageId, performance);

		if (unitId == null || unitId == 0) {
			log.debug("unitId is null/0, routing to completeQuickLevel for userId={}", userId);
			return completeQuickLevel(userId, null, languageId, performance, earnedExp, correctAns, totalExerc, timeSeconds, day);
		}
		if (day == null) day = AppTime.today();

		boolean wasAlreadyCompleted = historyRepo.existsByUserIdAndUnitId(userId, unitId);

		LessonHistory history = new LessonHistory();
		history.setUserId(userId);
		history.setUnitId(unitId);
		history.setCompletedAt(day);
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
		up.setCompletedAt(day);
		progressRepo.save(up);

		Integer nextUnitId = unlockNextUnit(userId, unitId);

		User user = userRepo.findById(userId).orElseThrow();
		user.setXp(user.getXp() + earnedExp);
		user.setTotalXp(user.getTotalXp() + earnedExp);
		levels.apply(user);

		UserStats stats = getOrCreateStats(userId, languageId);
		if (!wasAlreadyCompleted) {
			stats.setLessonsDone(stats.getLessonsDone() + 1);

			int vocabCount = unitVocabRepo.findByUnitId(unitId).size();
			if (vocabCount > 0) {
				stats.setWordsLearned(stats.getWordsLearned() + vocabCount);
			}

			if (performance >= 0.9) {
				stats.setPerfectLess(stats.getPerfectLess() + 1);
			}
		}
		applyStudyDay(user, stats, languageId, day);
		statsRepo.save(stats);
		userRepo.save(user);

		log.info("Lesson completed for userId={}, unitId={}: xpEarned={}", userId, unitId, earnedExp);

		Map<String, Object> result = new HashMap<>();
		result.put("xpEarned", earnedExp);
		result.put("wasAlreadyCompleted", wasAlreadyCompleted);
		result.put("perfectLesson", !wasAlreadyCompleted && performance >= 0.9);
		result.put("nextUnitId", nextUnitId);
		result.put("userXp", user.getXp());
		return result;
	}

	private Map<String, Object> completeQuickLevel(Integer userId, Integer levelId, Integer languageId, double performance,
			int earnedExp, int correctAns, int totalExerc, int timeSeconds, LocalDate day) {
		return completeQuickLevelPublic(userId, levelId, languageId, performance, earnedExp, correctAns, totalExerc, timeSeconds, day);
	}

	@Transactional
	public Map<String, Object> completeQuickLevelPublic(Integer userId, Integer levelId, Integer languageId, double performance,
			int earnedExp, int correctAns, int totalExerc, int timeSeconds, LocalDate day) {
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
		levels.apply(user);

		if (languageId != null) {
			UserStats stats = getOrCreateStats(userId, languageId);
			if (levelId != null) {
				List<Unit> units = unitRepo.findByLevelIdOrderByUnitNum(levelId);
				stats.setLessonsDone(stats.getLessonsDone() + units.size());
				int totalVocab = units.stream().mapToInt(u -> unitVocabRepo.findByUnitId(u.getId()).size()).sum();
				if (totalVocab > 0) stats.setWordsLearned(stats.getWordsLearned() + totalVocab);
				if (performance >= 0.9) stats.setPerfectLess(stats.getPerfectLess() + 1);
				stats.setTotalMins(stats.getTotalMins() + (timeSeconds / 60));
			}
			applyStudyDay(user, stats, languageId, day != null ? day : AppTime.today());
			statsRepo.save(stats);
		}
		userRepo.save(user);

		log.info("Quick level completed for userId={}: xpEarned={}, nextLevelUnlocked={}", userId, earnedExp, nextLevelUnlocked);

		Map<String, Object> result = new HashMap<>();
		result.put("xpEarned", earnedExp);
		result.put("wasAlreadyCompleted", false);
		result.put("perfectLesson", performance >= 0.9);
		result.put("nextUnitId", null);
		result.put("nextLevelUnlocked", nextLevelUnlocked);
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
