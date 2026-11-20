package com.tlahtolli.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import com.tlahtolli.api.entity.Exercise;

public interface ExerciseRepository extends JpaRepository<Exercise, Integer> {

	/** [unitId, total de ejercicios] — para el resumen de cursos del monitor */
	@Query("select e.unitId, count(e) from Exercise e where e.unitId is not null group by e.unitId")
	List<Object[]> countGroupedByUnit();
	
	List<Exercise> findByExerciseType(String type);
 
    List<Exercise> findByUnitId(Integer unitId);
 
    List<Exercise> findByLessonId(Integer lessonId);
 
    List<Exercise> findByLessonIdOrderById(Integer lessonId);
	
}
