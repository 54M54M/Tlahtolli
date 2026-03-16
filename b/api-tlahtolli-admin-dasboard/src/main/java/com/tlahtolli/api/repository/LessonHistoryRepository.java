package com.tlahtolli.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.LessonHistory;

public interface LessonHistoryRepository extends JpaRepository<LessonHistory, Long> {
	
	// Historial de UN usuario (el que faltaba antes)
    List<LessonHistory> findByUserIdOrderByCompletedAtDesc(Long userId);
 
    // Historial global ordenado por fecha (para el dashboard admin)
    List<LessonHistory> findAllByOrderByCompletedAtDesc();
 
    // ¿El usuario ya completó esta unidad alguna vez?
    boolean existsByUserIdAndUnitId(Long userId, Long unitId);
 
    // Historial de un usuario para una unidad específica
    List<LessonHistory> findByUserIdAndUnitId(Long userId, Long unitId);
}
