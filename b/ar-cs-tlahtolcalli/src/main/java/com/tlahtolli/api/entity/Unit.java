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
@Table(name = "UNITS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Unit {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "LEVEL_ID", nullable = false)
	private Integer levelId;

	@Column(name = "UNIT_NUM", nullable = false)
	private Short unitNum;

	@Column(name = "TITLE", nullable = false, length = 200)
	private String title;

	@Column(name = "COLOR", length = 20)
	private String color;

	@Column(name = "OBJECTIVE", length = 500)
	private String objective;

	@Column(name = "GRAMMAR", length = 500)
	private String grammar;

	@Column(name = "IS_FREE")
	private Short isFree = 0;

	@Column(name = "UNLOCK_REQ", length = 500)
	private String unlockReq;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getLevelId() {
		return levelId;
	}

	public void setLevelId(Integer levelId) {
		this.levelId = levelId;
	}

	public Short getUnitNum() {
		return unitNum;
	}

	public void setUnitNum(Short unitNum) {
		this.unitNum = unitNum;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getObjective() {
		return objective;
	}

	public void setObjective(String objective) {
		this.objective = objective;
	}

	public String getGrammar() {
		return grammar;
	}

	public void setGrammar(String grammar) {
		this.grammar = grammar;
	}

	public Short getIsFree() {
		return isFree;
	}

	public void setIsFree(Short isFree) {
		this.isFree = isFree;
	}

	public String getUnlockReq() {
		return unlockReq;
	}

	public void setUnlockReq(String unlockReq) {
		this.unlockReq = unlockReq;
	}

}