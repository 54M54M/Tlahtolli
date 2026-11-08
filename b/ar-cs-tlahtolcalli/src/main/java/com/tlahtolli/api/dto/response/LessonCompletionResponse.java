package com.tlahtolli.api.dto.response;

/**
 * Respuesta de POST /api/user-progress/complete.
 * nextUnitId       → solo lección normal (null en QuickLevel).
 * nextLevelUnlocked → solo QuickLevel (false en lección normal).
 */
public record LessonCompletionResponse(
        int xpEarned,
        int userXp,
        boolean wasAlreadyCompleted,
        boolean perfectLesson,
        Integer nextUnitId,
        boolean nextLevelUnlocked,
        int newAchievements
) {}
