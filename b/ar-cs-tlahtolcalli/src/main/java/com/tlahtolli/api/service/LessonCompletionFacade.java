package com.tlahtolli.api.service;

import com.tlahtolli.api.dto.request.CompleteLessonRequest;
import com.tlahtolli.api.dto.response.LessonCompletionResponse;
import com.tlahtolli.api.entity.UserAchievement;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;
import java.util.Map;
import java.util.function.Supplier;

import org.springframework.beans.factory.annotation.Value;

/**
 * Orquestador sin @Transactional propio.
 *
 * Flujo para completeLesson / completeQuickLevel:
 *   1. progressService.completeLesson() — transacción propia, guarda progreso + stats + XP.
 *   2. achievementService.checkAndUnlock() — transacción propia, separada.
 *      Si falla, la lección ya está guardada; solo se registra el error.
 *   3. Arma LessonCompletionResponse con el conteo de logros desbloqueados.
 *
 * Sin conexión: el teléfono guarda la lección y la envía al reconectar, con un clientId (si llega dos veces se
 * ignora, ver SyncOpService) y con completedAt (el día que cuenta es el día en que la terminó, en APP_TIMEZONE).
 */
@Service
public class LessonCompletionFacade {

    private static final Logger log = LoggerFactory.getLogger(LessonCompletionFacade.class);

    private final ProgressService progressService;
    private final AchievementService achievementService;
    private final LearningService learningService;
    private final CourseAccess courses;
    private final SyncOpService syncOps;
    private final ZoneId zone;

    /** Una lección hecha sin conexión cuenta en su día real, pero no se aceptan fechas futuras ni muy viejas. */
    private static final Duration MAX_OFFLINE_AGE = Duration.ofDays(7);
    private static final Duration CLOCK_SKEW = Duration.ofMinutes(5);

    public LessonCompletionFacade(ProgressService progressService, AchievementService achievementService,
                                  LearningService learningService, CourseAccess courses, SyncOpService syncOps,
                                  @Value("${APP_TIMEZONE:America/Mexico_City}") String timezone) {
        this.progressService = progressService;
        this.achievementService = achievementService;
        this.learningService = learningService;
        this.courses = courses;
        this.syncOps = syncOps;
        this.zone = ZoneId.of(timezone);
    }

    public LessonCompletionResponse completeLesson(CompleteLessonRequest req) {
        return once(req, SyncOpService.LESSON, () -> doCompleteLesson(req));
    }

    public LessonCompletionResponse completeQuickLevel(CompleteLessonRequest req) {
        return once(req, SyncOpService.QUICK, () -> doCompleteQuickLevel(req));
    }

    /** Aplica el envío una sola vez por clientId; si falla, lo libera para que el reintento pase. */
    private LessonCompletionResponse once(CompleteLessonRequest req, String kind, Supplier<LessonCompletionResponse> work) {
        if (!syncOps.claim(req.clientId(), req.userId(), kind)) {
            return new LessonCompletionResponse(0, 0, true, false, null, false, 0);
        }
        try {
            return work.get();
        } catch (RuntimeException e) {
            syncOps.release(req.clientId());
            throw e;
        }
    }

    /** Día en que cuenta la lección: el de completedAt (acotado a los últimos 7 días), o hoy. */
    LocalDate lessonDay(Instant completedAt) {
        Instant now = Instant.now();
        Instant at = completedAt == null ? now : completedAt;
        if (at.isAfter(now.plus(CLOCK_SKEW))) at = now;
        if (at.isBefore(now.minus(MAX_OFFLINE_AGE))) at = now.minus(MAX_OFFLINE_AGE);
        return LocalDate.ofInstant(at, zone);
    }

    private LessonCompletionResponse doCompleteLesson(CompleteLessonRequest req) {
        courses.requireUnit(req.unitId());   // curso en pruebas fuera del front de desarrollo
        // No se puede completar (ni ganar XP en) una lección bloqueada, aunque se llame a la API directo
        if (!learningService.isUnitAccessible(req.userId(), req.unitId())) {
            log.warn("[progreso] userId={} intentó completar la unidad bloqueada {}", req.userId(), req.unitId());
            throw new IllegalArgumentException("Esta lección todavía está bloqueada");
        }
        Map<String, Object> progress = progressService.completeLesson(
                req.userId(), req.unitId(), req.languageId(),
                req.performance(), req.earnedExp(),
                req.correctAns(), req.totalExerc(), req.timeSeconds(), lessonDay(req.completedAt())
        );
        int newAchievements = unlockAchievementsSafely(req.userId(), req.languageId());
        return buildResponse(progress, newAchievements);
    }

    private LessonCompletionResponse doCompleteQuickLevel(CompleteLessonRequest req) {
        courses.requireLevel(req.levelId());
        if (!learningService.isLevelAccessible(req.userId(), req.levelId())) {
            log.warn("[progreso] userId={} intentó el nivel rápido bloqueado {}", req.userId(), req.levelId());
            throw new IllegalArgumentException("Este nivel todavía está bloqueado");
        }
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
