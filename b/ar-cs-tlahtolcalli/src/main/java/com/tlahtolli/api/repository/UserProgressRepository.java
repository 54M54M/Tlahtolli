package com.tlahtolli.api.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.tlahtolli.api.entity.UserProgress;

public interface UserProgressRepository extends JpaRepository<UserProgress, Integer> {

	List<UserProgress> findByUserId(Integer userId);

	Optional<UserProgress> findByUserIdAndUnitId(Integer userId, Integer unitId);

	List<UserProgress> findByUserIdAndCompleted(Integer userId, Integer completed);

	List<UserProgress> findByUserIdAndIsLocked(Integer userId, Integer isLocked);

	boolean existsByUserIdAndUnitIdAndCompleted(Integer userId, Integer unitId, Integer completed);

	@Query("SELECT COUNT(up) FROM UserProgress up " + "JOIN Unit u ON u.id = up.unitId "
			+ "WHERE up.userId = :userId AND u.levelId = :levelId AND up.completed = 1")
	long countCompletedByUserAndLevel(@Param("userId") Integer userId, @Param("levelId") Integer levelId);
}
