package com.tlahtolli.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.LessonHistory;

public interface LessonHistoryRepository extends JpaRepository<LessonHistory, Long> {
	List<LessonHistory> findAllByOrderByCompletedAtDesc();
}
