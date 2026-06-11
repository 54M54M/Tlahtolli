package com.tlahtolli.api.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record LessonRequest(
        @NotNull Long unitId,
        @NotNull Integer lessonNum,
        @NotBlank @Size(max = 200) String title,
        @Size(max = 1000) String description,
        Integer isFree,
        Integer xpReward
) {}
