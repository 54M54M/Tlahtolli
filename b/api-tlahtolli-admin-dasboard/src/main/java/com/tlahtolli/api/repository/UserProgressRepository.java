package com.tlahtolli.api.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.tlahtolli.api.entity.UserProgress;

public interface UserProgressRepository extends JpaRepository<UserProgress, Long> {

	// Progreso completo de un usuario
	List<UserProgress> findByUserId(Long userId);

	// Estado de una unidad específica para un usuario
	Optional<UserProgress> findByUserIdAndUnitId(Long userId, Long unitId);

	// Todas las unidades completadas de un usuario
	List<UserProgress> findByUserIdAndCompleted(Long userId, Integer completed);

	// Unidades desbloqueadas (no bloqueadas) de un usuario
	List<UserProgress> findByUserIdAndIsLocked(Long userId, Integer isLocked);

	// ¿Ya completó esta unidad?
	boolean existsByUserIdAndUnitIdAndCompleted(Long userId, Long unitId, Integer completed);

	// Contar unidades completadas por usuario (para calcular progreso de nivel)
	@Query("SELECT COUNT(up) FROM UserProgress up " + "JOIN Unit u ON u.id = up.unitId "
			+ "WHERE up.userId = :userId AND u.levelId = :levelId AND up.completed = 1")
	long countCompletedByUserAndLevel(@Param("userId") Long userId, @Param("levelId") Long levelId);
}
