package com.tlahtolli.api.dto.request;

import java.time.Instant;

import jakarta.validation.constraints.NotNull;

/**
 * clientId    → id generado en el teléfono; si la misma lección llega dos veces (reintento sin conexión), se ignora.
 * completedAt → cuándo la terminó de verdad (puede ser horas antes si estaba sin internet). Opcional.
 */
public record CompleteLessonRequest(
        @NotNull Integer userId,
        Integer unitId,
        Integer levelId,
        @NotNull Integer languageId,
        double performance,
        int earnedExp,
        int correctAns,
        int totalExerc,
        int timeSeconds,
        String clientId,
        Instant completedAt
) {}
