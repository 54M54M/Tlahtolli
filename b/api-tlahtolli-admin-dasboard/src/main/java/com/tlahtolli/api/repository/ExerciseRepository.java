package com.tlahtolli.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.Exercise;

public interface ExerciseRepository extends JpaRepository<Exercise, Long> {
	List<Exercise> findByExerciseType(String type);
}
