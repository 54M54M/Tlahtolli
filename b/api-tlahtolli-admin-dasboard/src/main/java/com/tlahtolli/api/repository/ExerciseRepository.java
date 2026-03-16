package com.tlahtolli.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.Exercise;

public interface ExerciseRepository extends JpaRepository<Exercise, Long> {
	
	// Por tipo
    List<Exercise> findByExerciseType(String type);
 
    // Por unidad (para cargar ejercicios de una lección directamente)
    List<Exercise> findByUnitId(Long unitId);
 
    // Por lección
    List<Exercise> findByLessonId(Long lessonId);
 
    // Por lección ordenados
    List<Exercise> findByLessonIdOrderById(Long lessonId);
	
}
