package com.tlahtolli.api.dto.request;

import jakarta.validation.constraints.PositiveOrZero;

public record UpdateUserStatsRequest(
        @PositiveOrZero Integer wordsLearned,
        @PositiveOrZero Integer lessonsDone,
        @PositiveOrZero Integer perfectLess,
        @PositiveOrZero Integer daysStudied,
        @PositiveOrZero Short bestStreak,
        @PositiveOrZero Integer totalMins
) {}
