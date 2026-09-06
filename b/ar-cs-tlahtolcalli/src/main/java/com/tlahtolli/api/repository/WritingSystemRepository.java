package com.tlahtolli.api.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.tlahtolli.api.entity.WritingSystem;

public interface WritingSystemRepository extends JpaRepository<WritingSystem, Long> {
	 
    List<WritingSystem> findByLanguageId(Long languageId);
 
    // El frontend accede por código de idioma a través de languageId
    Optional<WritingSystem> findByLanguageIdAndSystemType(Long languageId, String systemType);
}
 