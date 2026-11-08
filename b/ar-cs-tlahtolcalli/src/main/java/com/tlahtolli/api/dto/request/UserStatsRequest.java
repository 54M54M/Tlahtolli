package com.tlahtolli.api.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;

public record UserStatsRequest(
        @NotNull Integer userId,
        @NotNull Integer languageId,
        @PositiveOrZero Integer wordsLearned,
        @PositiveOrZero Integer lessonsDone,
        @PositiveOrZero Integer perfectLess,
        @PositiveOrZero Integer daysStudied,
        @PositiveOrZero Short bestStreak,
        @PositiveOrZero Integer totalMins
) {}
