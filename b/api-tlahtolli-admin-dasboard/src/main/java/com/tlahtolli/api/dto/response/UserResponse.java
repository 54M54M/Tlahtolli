package com.tlahtolli.api.dto.response;

import com.tlahtolli.api.entity.User;
import java.time.LocalDate;

public record UserResponse(
        Long id,
        String username,
        String fullName,
        String email,
        Integer userLevel,
        Long xp,
        Long totalXp,
        Integer streak,
        LocalDate joinDate,
        Long currentLang
) {
    public static UserResponse from(User u) {
        return new UserResponse(
                u.getId(), u.getUsername(), u.getFullName(), u.getEmail(),
                u.getUserLevel(), u.getXp(), u.getTotalXp(),
                u.getStreak(), u.getJoinDate(), u.getCurrentLang()
        );
    }
}
