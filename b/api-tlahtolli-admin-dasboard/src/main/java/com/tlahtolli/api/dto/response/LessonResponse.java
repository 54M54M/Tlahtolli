package com.tlahtolli.api.dto.response;

import com.tlahtolli.api.entity.Lesson;

public record LessonResponse(
        Integer id,
        Integer unitId,
        Short lessonNum,
        String title,
        String description,
        Short isFree,
        Integer xpReward
) {
    public static LessonResponse from(Lesson l) {
        return new LessonResponse(
                l.getId(), l.getUnitId(), l.getLessonNum(),
                l.getTitle(), l.getDescription(), l.getIsFree(), l.getXpReward()
        );
    }
}
