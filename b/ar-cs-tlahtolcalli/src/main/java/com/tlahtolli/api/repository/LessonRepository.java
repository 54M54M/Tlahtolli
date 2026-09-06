package com.tlahtolli.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.Lesson;

public interface LessonRepository extends JpaRepository<Lesson, Long> {
	List<Lesson> findByUnitId(Integer unitId);
}
