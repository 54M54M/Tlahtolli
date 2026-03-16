package com.tlahtolli.api.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tlahtolli.api.entity.*;
import com.tlahtolli.api.repository.*;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class LearningService {

	private final LevelRepository levelRepo;
	private final UnitRepository unitRepo;
	private final ExerciseRepository exerciseRepo;
	private final UserProgressRepository progressRepo;
	private final UnitVocabRepository unitVocabRepo;
	private final ObjectMapper mapper;

	public LearningService(LevelRepository levelRepo, UnitRepository unitRepo, ExerciseRepository exerciseRepo,
			UserProgressRepository progressRepo, UnitVocabRepository unitVocabRepo) {
		this.levelRepo = levelRepo;
		this.unitRepo = unitRepo;
		this.exerciseRepo = exerciseRepo;
		this.progressRepo = progressRepo;
		this.unitVocabRepo = unitVocabRepo;
		this.mapper = new ObjectMapper();
	}

	// ── Niveles ───────────────────────────────────────────────────────────────

	public List<Map<String, Object>> getLevelsWithProgress(Long languageId, Long userId) {
		return levelRepo.findByLanguageId(languageId).stream().map(level -> {
			long completed = progressRepo.countCompletedByUserAndLevel(userId, level.getId());
			boolean locked = isLevelLocked(level, userId);

			Map<String, Object> m = new LinkedHashMap<>();
			m.put("id", level.getId());
			m.put("levelNum", level.getLevelNum());
			m.put("title", level.getTitle());
			m.put("titleNative", level.getTitleNative());
			m.put("color", level.getColor());
			m.put("totalUnits", level.getTotalUnits());
			m.put("completedUnits", completed);
			m.put("locked", locked);
			m.put("unlockReq", level.getUnlockReq());
			m.put("isFree", level.getIsFree() == 1);
			return m;
		}).toList();
	}

	// ── Unidades ──────────────────────────────────────────────────────────────

	public List<Map<String, Object>> getUnitsWithProgress(Long levelId, Long userId) {
		return unitRepo.findByLevelIdOrderByUnitNum(levelId).stream().map(unit -> {
			Optional<UserProgress> up = progressRepo.findByUserIdAndUnitId(userId, unit.getId());

			boolean locked = up.map(p -> p.getIsLocked() == 1).orElse(unit.getUnitNum() > 1);
			boolean completed = up.map(p -> p.getCompleted() == 1).orElse(false);
			boolean current = up.map(p -> p.getIsCurrent() == 1).orElse(false);

			Map<String, Object> m = new LinkedHashMap<>();
			m.put("id", unit.getId());
			m.put("levelId", unit.getLevelId());
			m.put("unitNum", unit.getUnitNum());
			m.put("title", unit.getTitle());
			m.put("color", unit.getColor());
			m.put("objective", unit.getObjective());
			m.put("grammar", unit.getGrammar());
			m.put("isFree", unit.getIsFree() == 1);
			m.put("locked", locked);
			m.put("completed", completed);
			m.put("current", current);
			return m;
		}).toList();
	}

	// ── Ejercicios ────────────────────────────────────────────────────────────

	public List<Map<String, Object>> getExercisesForUnit(Long unitId) {
		List<Exercise> exercises = exerciseRepo.findByUnitId(unitId);
		List<Vocabulary> vocab = unitVocabRepo.findVocabularyByUnitId(unitId);
		List<String> vocabWords = vocab.stream().map(Vocabulary::getWord).toList();

		return exercises.stream().map(ex -> buildExerciseMap(ex, vocabWords)).toList();
	}

	public List<Map<String, Object>> getRandomExercisesForLevel(Long levelId, int count) {
		List<Unit> units = unitRepo.findByLevelIdOrderByUnitNum(levelId);
		List<Map<String, Object>> all = new ArrayList<>();
		units.forEach(u -> all.addAll(getExercisesForUnit(u.getId())));
		Collections.shuffle(all);
		return all.subList(0, Math.min(count, all.size()));
	}

	// ── Vocabulario ───────────────────────────────────────────────────────────

	/**
	 * Devuelve vocabulario en el formato que espera ProcessedText /
	 * PronunciationTooltip: { "palabra": { "translation": "...", "pronunciation":
	 * "...", "example": "..." } }
	 */
	public Map<String, Object> getVocabularyForUnit(Long unitId) {
		List<Vocabulary> vocab = unitVocabRepo.findVocabularyByUnitId(unitId);
		Map<String, Object> result = new LinkedHashMap<>();
		for (Vocabulary v : vocab) {
			Map<String, String> entry = new LinkedHashMap<>();
			entry.put("translation", v.getTranslation());
			entry.put("pronunciation", v.getPronunciation());
			entry.put("example", v.getExample());
			result.put(v.getWord(), entry);
		}
		return result;
	}

	// ── helpers privados ──────────────────────────────────────────────────────

	private Map<String, Object> buildExerciseMap(Exercise ex, List<String> vocabPool) {
		Map<String, Object> m = new LinkedHashMap<>();
		m.put("id", ex.getId());
		m.put("type", ex.getExerciseType());
		m.put("question", ex.getQuestion());
		m.put("answer", ex.getAnswer());
		m.put("explanation", ex.getExplanation());
		m.put("points", ex.getPoints());
		m.put("difficulty", ex.getDifficulty());
		m.put("character", ex.getCharacterRef());

		if ("multiple-choice".equals(ex.getExerciseType())) {
			// Prioridad 1: opciones pregeneradas en la BD (campo OPTIONS)
			List<String> options = parseJsonList(ex.getOptions());

			// Prioridad 2: construir dinámicamente desde vocabulario
			if (options.isEmpty()) {
				String correct = resolveCorrectAnswer(ex);
				options = buildOptions(correct, vocabPool);
			}

			String correct = resolveCorrectAnswer(ex);
			m.put("options", options);
			m.put("correctAnswer", options.indexOf(correct));
		}

		if ("fill-blank".equals(ex.getExerciseType())) {
			// Puede ser string simple o array JSON de respuestas aceptadas
			List<String> accepted = parseJsonList(ex.getCorrectAns());
			if (accepted.isEmpty() && ex.getCorrectAns() != null) {
				accepted = List.of(ex.getCorrectAns()); // string simple
			}
			m.put("correctAnswer", accepted);
			m.put("placeholder", ex.getAnswer()); // el texto con el hueco
		}

		return m;
	}

	/**
	 * Resuelve la respuesta correcta de un ejercicio. Usa CORRECT_ANS si está
	 * disponible, sino usa ANSWER como fallback.
	 */
	private String resolveCorrectAnswer(Exercise ex) {
		if (ex.getCorrectAns() != null && !ex.getCorrectAns().isBlank()) {
			// Si es JSON array, tomar el primero
			List<String> list = parseJsonList(ex.getCorrectAns());
			if (!list.isEmpty())
				return list.get(0);
			return ex.getCorrectAns(); // string simple
		}
		return ex.getAnswer(); // fallback al campo answer
	}

	private List<String> parseJsonList(String json) {
		if (json == null || json.isBlank())
			return new ArrayList<>();
		try {
			return mapper.readValue(json, new TypeReference<List<String>>() {
			});
		} catch (Exception e) {
			return new ArrayList<>();
		}
	}

	private boolean isLevelLocked(Level level, Long userId) {
		if (level.getLevelNum() == 1)
			return false;
		List<Level> allLevels = levelRepo.findByLanguageId(level.getLanguageId());
		Optional<Level> prev = allLevels.stream().filter(l -> l.getLevelNum() == level.getLevelNum() - 1).findFirst();
		if (prev.isEmpty())
			return true;
		long completedInPrev = progressRepo.countCompletedByUserAndLevel(userId, prev.get().getId());
		return completedInPrev < prev.get().getTotalUnits();
	}

	private List<String> buildOptions(String correct, List<String> vocabPool) {
		if (correct == null)
			return new ArrayList<>();
		List<String> wrong = vocabPool.stream().filter(w -> !w.equals(correct))
				.collect(java.util.stream.Collectors.toList());
		Collections.shuffle(wrong);
		List<String> options = new ArrayList<>(wrong.subList(0, Math.min(3, wrong.size())));
		options.add(correct);
		Collections.shuffle(options);
		return options;
	}
}