package com.tlahtolli.api.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tlahtolli.api.entity.*;
import com.tlahtolli.api.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Objects;

@Service
public class AchievementService {

	private static final Logger log = LoggerFactory.getLogger(AchievementService.class);

	private final AchievementRepository achievementRepo;
	private final UserAchievementRepository userAchievementRepo;
	private final UserStatsRepository statsRepo;
	private final UserRepository userRepo;
	private final LanguageRepository languageRepo;
	private final ObjectMapper mapper = new ObjectMapper();

	public AchievementService(AchievementRepository achievementRepo, UserAchievementRepository userAchievementRepo,
	                          UserStatsRepository statsRepo, UserRepository userRepo, LanguageRepository languageRepo) {
		this.achievementRepo = achievementRepo;
		this.userAchievementRepo = userAchievementRepo;
		this.statsRepo = statsRepo;
		this.userRepo = userRepo;
		this.languageRepo = languageRepo;
	}

	/**
	 * Verifica todos los logros pendientes y desbloquea los que corresponda,
	 * para el idioma con el que el usuario está trabajando en este momento.
	 * Un mismo logro se puede ganar una vez por idioma.
	 * Devuelve la lista de logros recién desbloqueados en esta llamada.
	 */
	@Transactional
	public List<UserAchievement> checkAndUnlock(Integer userId, Integer languageId) {
		String languageTag = languageRepo.findById(Long.valueOf(languageId)).map(Language::getCode).orElse(null);
		log.debug("Checking achievements for userId={}, languageId={}, languageTag={}", userId, languageId, languageTag);

		List<Achievement> all = achievementRepo.findAll();
		List<UserAchievement> earned = userAchievementRepo.findByUserId(userId);
		UserStats stats = statsRepo.findByUserIdAndLanguageId(userId, languageId).orElse(null);
		User user = userRepo.findById(userId).orElse(null);

		List<UserAchievement> newlyUnlocked = new ArrayList<>();

		for (Achievement a : all) {
			boolean alreadyEarned = earned.stream()
					.anyMatch(ua -> ua.getAchieveId().equals(a.getId()) && Objects.equals(ua.getLanguageTag(), languageTag));
			if (alreadyEarned)
				continue;

			if (isMet(a, stats, user)) {
				UserAchievement ua = new UserAchievement();
				ua.setUserId(userId);
				ua.setAchieveId(a.getId());
				ua.setEarnedAt(LocalDate.now());
				ua.setLanguageTag(languageTag);
				userAchievementRepo.save(ua);
				newlyUnlocked.add(ua);
				log.info("Achievement unlocked for userId={}: achievementId={}, languageTag={}", userId, a.getId(), languageTag);

				if (user != null && a.getXpReward() != null && a.getXpReward() > 0) {
					user.setXp(user.getXp() + a.getXpReward());
					user.setTotalXp(user.getTotalXp() + a.getXpReward());
					userRepo.save(user);
					log.debug("XP reward granted for userId={}: +{} xp", userId, a.getXpReward());
				}
			}
		}
		log.debug("Achievement check done for userId={}: {} newly unlocked", userId, newlyUnlocked.size());
		return newlyUnlocked;
	}

	/** Devuelve los logros visibles para el idioma actual, con flag de si el usuario los tiene EN ESE IDIOMA. */
	public List<AchievementWithStatus> getAllWithStatus(Integer userId, String languageTag) {
		log.debug("Getting achievements for userId={}, languageTag={}", userId, languageTag);
		List<Achievement> all = achievementRepo.findAll();
		List<UserAchievement> earned = userAchievementRepo.findByUserId(userId);

		return all.stream()
				.filter(a -> isVisibleForLanguage(a, languageTag))
				.map(a -> {
					UserAchievement ua = earned.stream()
							.filter(x -> x.getAchieveId().equals(a.getId()) && Objects.equals(x.getLanguageTag(), languageTag))
							.findFirst()
							.orElse(null);
					return new AchievementWithStatus(a, ua != null, ua != null ? ua.getEarnedAt() : null);
				}).toList();
	}

	/** Visibilidad de CATÁLOGO: para qué idiomas existe/aplica este logro (independiente de si el usuario ya lo ganó). */
	private boolean isVisibleForLanguage(Achievement a, String languageTag) {
		String tagJson = a.getLanguageTag();
		if (tagJson == null || tagJson.isBlank() || languageTag == null) {
			return true; // logro global, o no se especificó idioma en la request
		}
		try {
			List<String> tags = mapper.readValue(tagJson, new TypeReference<List<String>>() {});
			return tags.isEmpty() || tags.contains(languageTag);
		} catch (com.fasterxml.jackson.core.JsonProcessingException e) {
			log.warn("LANGUAGE_TAG mal formado en achievement id={}: {}", a.getId(), e.getMessage());
			return true; // ante un dato corrupto, no ocultamos el logro
		}
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