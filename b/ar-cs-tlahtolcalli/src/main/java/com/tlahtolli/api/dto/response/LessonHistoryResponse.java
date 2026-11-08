package com.tlahtolli.api.dto.response;

import com.tlahtolli.api.entity.LessonHistory;
import java.time.LocalDate;

public record LessonHistoryResponse(
        Integer id,
        Integer userId,
        Integer unitId,
        LocalDate completedAt,
        double performance,
        int earnedExp,
        int correctAns,
        int totalExerc,
        boolean wasPerfect
) {
    public static LessonHistoryResponse from(LessonHistory h) {
        return new LessonHistoryResponse(
                h.getId(),
                h.getUserId(),
                h.getUnitId(),
                h.getCompletedAt(),
                h.getPerformance() != null ? h.getPerformance().doubleValue() : 0.0,
                h.getEarnedExp() != null ? h.getEarnedExp() : 0,
                h.getCorrectAns() != null ? h.getCorrectAns() : 0,
                h.getTotalExerc() != null ? h.getTotalExerc() : 0,
                h.getWasPerfect() != null && h.getWasPerfect() == 1
        );
    }
}
