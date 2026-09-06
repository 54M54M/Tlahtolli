package com.tlahtolli.api.dto.response;

import com.tlahtolli.api.entity.UserStats;

public record UserStatsResponse(
        Integer id,
        Integer userId,
        Integer languageId,
        Integer wordsLearned,
        Integer lessonsDone,
        Integer perfectLess,
        Integer daysStudied,
        Short bestStreak,
        Integer totalMins
) {
    public static UserStatsResponse from(UserStats s) {
        return new UserStatsResponse(
                s.getId(), s.getUserId(), s.getLanguageId(),
                s.getWordsLearned(), s.getLessonsDone(), s.getPerfectLess(),
                s.getDaysStudied(), s.getBestStreak(), s.getTotalMins()
        );
    }
}
