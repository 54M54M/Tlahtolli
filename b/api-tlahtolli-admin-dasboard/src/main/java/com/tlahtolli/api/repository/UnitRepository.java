package com.tlahtolli.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.Unit;

public interface UnitRepository extends JpaRepository<Unit, Long> {
	
	 // Todas las unidades de un nivel, ordenadas por número
    List<Unit> findByLevelIdOrderByUnitNum(Long levelId);
 
    // Contar unidades de un nivel (para validar completitud)
    long countByLevelId(Long levelId);
}
