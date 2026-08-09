package com.tlahtolli.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.LessonHistory;

public interface LessonHistoryRepository extends JpaRepository<LessonHistory, Integer> {
	
    List<LessonHistory> findByUserIdOrderByCompletedAtDesc(Integer userId);
 
    List<LessonHistory> findAllByOrderByCompletedAtDesc();
 
    boolean existsByUserIdAndUnitId(Integer userId, Integer unitId);
 
    List<LessonHistory> findByUserIdAndUnitId(Integer userId, Integer unitId);
}
