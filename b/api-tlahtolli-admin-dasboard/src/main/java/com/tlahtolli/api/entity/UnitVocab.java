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
    private Integer id;
 
    @Column(name = "UNIT_ID", nullable = false)
    private Integer unitId;
 
    @Column(name = "VOCAB_ID", nullable = false)
    private Integer vocabId;
 
    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
 
    public Integer getUnitId() { return unitId; }
    public void setUnitId(Integer unitId) { this.unitId = unitId; }
 
    public Integer getVocabId() { return vocabId; }
    public void setVocabId(Integer vocabId) { this.vocabId = vocabId; }
}