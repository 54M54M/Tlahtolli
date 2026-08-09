package com.tlahtolli.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.Level;

public interface LevelRepository extends JpaRepository<Level, Integer> {
	List<Level> findByLanguageId(Integer languageId);
}
