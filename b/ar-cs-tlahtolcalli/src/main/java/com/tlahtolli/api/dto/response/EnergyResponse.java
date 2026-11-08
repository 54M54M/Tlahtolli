package com.tlahtolli.api.dto.response;

import com.tlahtolli.api.entity.UserEnergy;

public record EnergyResponse(
        Integer userId,
        int currentEnergy,
        int maxEnergy,
        int streakCount
) {
    public static EnergyResponse from(UserEnergy e) {
        return new EnergyResponse(
                e.getUserId(),
                e.getCurrentEnergy(),
                e.getMaxEnergy(),
                e.getStreakCount()
        );
    }
}
