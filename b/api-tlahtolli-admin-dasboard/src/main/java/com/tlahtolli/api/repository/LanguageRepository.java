package com.tlahtolli.api.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.Language;

public interface LanguageRepository extends JpaRepository<Language, Long> {
	
}