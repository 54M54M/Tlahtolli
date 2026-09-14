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

    @Query(value = "SELECT v.* FROM ct_vocabulary v " +
            "JOIN rl_unit_vocab uv ON uv.vocab_id = v.id " +
            "WHERE uv.unit_id = :unitId",
            nativeQuery = true)
    List<Vocabulary> findVocabularyByUnitId(@Param("unitId") Integer unitId);
}
 