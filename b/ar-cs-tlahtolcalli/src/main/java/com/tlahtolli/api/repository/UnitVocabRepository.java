package com.tlahtolli.api.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.tlahtolli.api.entity.UnitVocab;
import com.tlahtolli.api.entity.Vocabulary;

public interface UnitVocabRepository extends JpaRepository<UnitVocab, Integer> {
	 
    List<UnitVocab> findByUnitId(Integer unitId);
 
    List<UnitVocab> findByVocabId(Integer vocabId);
 
    boolean existsByUnitIdAndVocabId(Integer unitId, Integer vocabId);
 
    void deleteByUnitIdAndVocabId(Integer unitId, Integer vocabId);
 
    @Query("SELECT v FROM Vocabulary v " +
           "JOIN UnitVocab uv ON uv.vocabId = v.id " +
           "WHERE uv.unitId = :unitId")
    List<Vocabulary> findVocabularyByUnitId(@Param("unitId") Integer unitId);
}
 