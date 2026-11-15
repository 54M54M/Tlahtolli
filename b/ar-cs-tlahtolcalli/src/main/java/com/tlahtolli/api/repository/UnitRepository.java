package com.tlahtolli.api.repository;

import org.springframework.cache.annotation.Cacheable;
import com.tlahtolli.api.config.CacheConfig;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.Unit;

public interface UnitRepository extends JpaRepository<Unit, Integer> {
	
	 // Todas las unidades de un nivel, ordenadas por número
    @Cacheable(cacheNames = CacheConfig.CATALOGO, key = "'unidades:' + #p0")
    List<Unit> findByLevelIdOrderByUnitNum(Integer levelId);
 
    // Contar unidades de un nivel (para validar completitud)
    long countByLevelId(Integer levelId);
}
