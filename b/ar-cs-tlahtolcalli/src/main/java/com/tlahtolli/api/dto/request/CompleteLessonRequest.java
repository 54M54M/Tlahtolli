package com.tlahtolli.api.dto.request;

import jakarta.validation.constraints.NotNull;

public record CompleteLessonRequest(
        @NotNull Integer userId,
        Integer unitId,
        Integer levelId,
        @NotNull Integer languageId,
        double performance,
        int earnedExp,
        int correctAns,
        int totalExerc,
        int timeSeconds
) {}
