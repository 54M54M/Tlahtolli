package com.tlahtolli.api.service;

import com.tlahtolli.api.dto.request.CompleteLessonRequest;
import com.tlahtolli.api.dto.response.LessonCompletionResponse;
import com.tlahtolli.api.entity.UserAchievement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Orquestador sin @Transactional propio.
 *
 * Flujo para completeLesson / completeQuickLevel:
 *   1. progressService.completeLesson() — transacción propia, guarda progreso + stats + XP.
 *   2. achievementService.checkAndUnlock() — transacción propia, separada.
 *      Si falla, la lección ya está guardada; solo se registra el error.
 *   3. Arma LessonCompletionResponse con el conteo de logros desbloqueados.
 */
@Service
public class LessonCompletionFacade {

    private static final Logger log = LoggerFactory.getLogger(LessonCompletionFacade.class);

    private final ProgressService progressService;
    private final AchievementService achievementService;

    public LessonCompletionFacade(ProgressService progressService, AchievementService achievementService) {
        this.progressService = progressService;
        this.achievementService = achievementService;
    }

    public LessonCompletionResponse completeLesson(CompleteLessonRequest req) {
        Map<String, Object> progress = progressService.completeLesson(
                req.userId(), req.unitId(), req.languageId(),
                req.performance(), req.earnedExp(),
                req.correctAns(), req.totalExerc(), req.timeSeconds()
        );
        int newAchievements = unlockAchievementsSafely(req.userId(), req.languageId());
        return buildResponse(progress, newAchievements);
    }

    public LessonCompletionResponse completeQuickLevel(CompleteLessonRequest req) {
        Map<String, Object> progress = progressService.completeQuickLevelPublic(
                req.userId(), req.levelId(), req.languageId(),
                req.performance(), req.earnedExp(),
                req.correctAns(), req.totalExerc(), req.timeSeconds()
        );
        int newAchievements = unlockAchievementsSafely(req.userId(), req.languageId());
        return buildResponse(progress, newAchievements);
    }

    public void initializeProgress(Integer userId, Integer firstUnitId) {
        progressService.initializeProgress(userId, firstUnitId);
    }

    // ── privados ──────────────────────────────────────────────────────────────

    private int unlockAchievementsSafely(Integer userId, Integer languageId) {
        try {
            List<UserAchievement> unlocked = achievementService.checkAndUnlock(userId, languageId);
            return unlocked.size();
        } catch (Exception e) {
            log.error("[LessonCompletionFacade] checkAndUnlock falló para userId={}, languageId={}",
                    userId, languageId, e);
            return 0;
        }
    }

    private LessonCompletionResponse buildResponse(Map<String, Object> progress, int newAchievements) {
        return new LessonCompletionResponse(
                toInt(progress.get("xpEarned")),
                toInt(progress.get("userXp")),
                Boolean.TRUE.equals(progress.get("wasAlreadyCompleted")),
                Boolean.TRUE.equals(progress.get("perfectLesson")),
                progress.get("nextUnitId") != null ? toInt(progress.get("nextUnitId")) : null,
                Boolean.TRUE.equals(progress.get("nextLevelUnlocked")),
                newAchievements
        );
    }

    private static int toInt(Object v) {
        return v == null ? 0 : Integer.parseInt(v.toString());
    }
}
