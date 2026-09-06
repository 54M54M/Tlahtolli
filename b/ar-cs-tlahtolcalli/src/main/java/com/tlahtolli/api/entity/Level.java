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
@Table(name = "LEVELS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Level {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "LANGUAGE_ID", nullable = false)
	private Integer languageId;

	@Column(name = "LEVEL_NUM", nullable = false)
	private Short levelNum;

	@Column(name = "TITLE", nullable = false, length = 200)
	private String title;

	@Column(name = "TITLE_NATIVE", length = 200)
	private String titleNative;

	@Column(name = "COLOR", length = 20)
	private String color;

	@Column(name = "TOTAL_UNITS")
	private Short totalUnits = 0;

	@Column(name = "UNLOCK_REQ", length = 500)
	private String unlockReq;

	@Column(name = "IS_FREE")
	private Short isFree = 0;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getLanguageId() {
		return languageId;
	}

	public void setLanguageId(Integer languageId) {
		this.languageId = languageId;
	}

	public Short getLevelNum() {
		return levelNum;
	}

	public void setLevelNum(Short levelNum) {
		this.levelNum = levelNum;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getTitleNative() {
		return titleNative;
	}

	public void setTitleNative(String titleNative) {
		this.titleNative = titleNative;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public Short getTotalUnits() {
		return totalUnits;
	}

	public void setTotalUnits(Short totalUnits) {
		this.totalUnits = totalUnits;
	}

	public String getUnlockReq() {
		return unlockReq;
	}

	public void setUnlockReq(String unlockReq) {
		this.unlockReq = unlockReq;
	}

	public Short getIsFree() {
		return isFree;
	}

	public void setIsFree(Short isFree) {
		this.isFree = isFree;
	}

}