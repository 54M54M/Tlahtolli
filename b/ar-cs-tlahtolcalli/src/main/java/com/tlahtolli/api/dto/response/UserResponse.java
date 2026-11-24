package com.tlahtolli.api.dto.response;

import com.tlahtolli.api.entity.User;
import com.tlahtolli.api.service.UserLevelService;
import com.tlahtolli.api.util.AppTime;
import java.time.LocalDate;

public record UserResponse(
        Integer id,
        String username,
        String fullName,
        String email,
        Short userLevel,
        Integer xp,
        Integer totalXp,
        /** XP ganada dentro del nivel actual y la que cuesta el nivel (barra del perfil; ver UserLevelService). */
        Integer xpInLevel,
        Integer xpToNextLevel,
        Short streak,
        LocalDate lastStudyDate,
        boolean studiedToday,
        LocalDate joinDate,
        Integer currentLang,
        String role,
        boolean emailVerified,
        String pendingEmail,
        boolean mustPickUsername,
        boolean hasPassword,
        boolean googleLinked
) {
    public static UserResponse from(User u) {
        int perLevel = UserLevelService.currentXpPerLevel();
        return new UserResponse(
                u.getId(), u.getUsername(), u.getFullName(), u.getEmail(),
                u.getUserLevel(), u.getXp(), u.getTotalXp(),
                UserLevelService.xpInLevel(u.getTotalXp(), u.getUserLevel(), perLevel), perLevel,
                u.currentStreak(AppTime.today()), u.getLastStudyDate(),
                AppTime.today().equals(u.getLastStudyDate()), u.getJoinDate(), u.getCurrentLang(), u.getRole(),
                u.isEmailVerified(), u.getPendingEmail(),
                u.isMustPickUsername(), u.hasPassword(), u.getGoogleSub() != null
        );
    }
}
