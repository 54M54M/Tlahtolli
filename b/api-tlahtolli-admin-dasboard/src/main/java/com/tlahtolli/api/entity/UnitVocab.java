package com.tlahtolli.api.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "UNIT_VOCAB")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UnitVocab {
 
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
 
    @Column(name = "UNIT_ID", nullable = false)
    private Long unitId;
 
    @Column(name = "VOCAB_ID", nullable = false)
    private Long vocabId;
 
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
 
    public Long getUnitId() { return unitId; }
    public void setUnitId(Long unitId) { this.unitId = unitId; }
 
    public Long getVocabId() { return vocabId; }
    public void setVocabId(Long vocabId) { this.vocabId = vocabId; }
}