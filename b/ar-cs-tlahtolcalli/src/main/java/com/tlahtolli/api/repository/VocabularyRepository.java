package com.tlahtolli.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.Vocabulary;

public interface VocabularyRepository extends JpaRepository<Vocabulary, Long> {
	List<Vocabulary> findByLanguageId(Long languageId);
}
