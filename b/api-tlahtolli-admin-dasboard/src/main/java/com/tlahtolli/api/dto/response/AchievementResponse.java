package com.tlahtolli.api.dto.response;

import com.tlahtolli.api.entity.Achievement;

public record AchievementResponse(
        Long id,
        String title,
        String description,
        String icon,
        Integer xpReward,
        String requirement,
        String category,
        String rarity
) {
    public static AchievementResponse from(Achievement a) {
        return new AchievementResponse(
                a.getId(), a.getTitle(), a.getDescription(), a.getIcon(),
                a.getXpReward(), a.getRequirement(), a.getCategory(), a.getRarity()
        );
    }
}
