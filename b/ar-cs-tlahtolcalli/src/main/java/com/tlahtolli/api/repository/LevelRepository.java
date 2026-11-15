package com.tlahtolli.api.repository;

import org.springframework.cache.annotation.Cacheable;
import com.tlahtolli.api.config.CacheConfig;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.Level;

public interface LevelRepository extends JpaRepository<Level, Integer> {
	@Cacheable(cacheNames = CacheConfig.CATALOGO, key = "'niveles:' + #p0")
	List<Level> findByLanguageId(Integer languageId);
}
