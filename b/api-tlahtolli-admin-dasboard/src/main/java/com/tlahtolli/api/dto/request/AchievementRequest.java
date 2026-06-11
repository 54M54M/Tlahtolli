package com.tlahtolli.api.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record AchievementRequest(
        @NotBlank @Size(max = 200) String title,
        @Size(max = 1000) String description,
        @Size(max = 200) String icon,
        Integer xpReward,
        @Size(max = 500) String requirement,
        @Size(max = 100) String category,
        @Size(max = 50) String rarity
) {}
