package com.tlahtolli.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.tlahtolli.api.entity.UnitVocab;
import com.tlahtolli.api.entity.Vocabulary;

public interface UnitVocabRepository extends JpaRepository<UnitVocab, Long> {
	 
    List<UnitVocab> findByUnitId(Long unitId);
 
    List<UnitVocab> findByVocabId(Long vocabId);
 
    boolean existsByUnitIdAndVocabId(Long unitId, Long vocabId);
 
    void deleteByUnitIdAndVocabId(Long unitId, Long vocabId);
 
    // Obtener el vocabulario completo de una unidad con JOIN
    @Query("SELECT v FROM Vocabulary v " +
           "JOIN UnitVocab uv ON uv.vocabId = v.id " +
           "WHERE uv.unitId = :unitId")
    List<Vocabulary> findVocabularyByUnitId(@Param("unitId") Long unitId);
}
 