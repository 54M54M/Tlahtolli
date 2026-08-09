package com.tlahtolli.api.dto.response;

import com.tlahtolli.api.entity.User;
import java.time.LocalDate;

public record UserResponse(
        Integer id,
        String username,
        String fullName,
        String email,
        Short userLevel,
        Integer xp,
        Integer totalXp,
        Short streak,
        LocalDate joinDate,
        Integer currentLang
) {
    public static UserResponse from(User u) {
        return new UserResponse(
                u.getId(), u.getUsername(), u.getFullName(), u.getEmail(),
                u.getUserLevel(), u.getXp(), u.getTotalXp(),
                u.getStreak(), u.getJoinDate(), u.getCurrentLang()
        );
    }
}
