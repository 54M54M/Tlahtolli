package com.tlahtolli.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.Exercise;

public interface ExerciseRepository extends JpaRepository<Exercise, Integer> {
	
	List<Exercise> findByExerciseType(String type);
 
    List<Exercise> findByUnitId(Integer unitId);
 
    List<Exercise> findByLessonId(Integer lessonId);
 
    List<Exercise> findByLessonIdOrderById(Integer lessonId);
	
}
