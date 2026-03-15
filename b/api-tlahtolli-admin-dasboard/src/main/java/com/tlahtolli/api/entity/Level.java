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
	private Long id;

	@Column(name = "LANGUAGE_ID", nullable = false)
	private Long languageId;

	@Column(name = "LEVEL_NUM", nullable = false)
	private Integer levelNum;

	@Column(name = "TITLE", nullable = false, length = 200)
	private String title;

	@Column(name = "TITLE_NATIVE", length = 200)
	private String titleNative;

	@Column(name = "COLOR", length = 20)
	private String color;

	@Column(name = "TOTAL_UNITS")
	private Integer totalUnits = 0;

	@Column(name = "UNLOCK_REQ", length = 500)
	private String unlockReq;

	@Column(name = "IS_FREE")
	private Integer isFree = 0;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getLanguageId() {
		return languageId;
	}

	public void setLanguageId(Long languageId) {
		this.languageId = languageId;
	}

	public Integer getLevelNum() {
		return levelNum;
	}

	public void setLevelNum(Integer levelNum) {
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

	public Integer getTotalUnits() {
		return totalUnits;
	}

	public void setTotalUnits(Integer totalUnits) {
		this.totalUnits = totalUnits;
	}

	public String getUnlockReq() {
		return unlockReq;
	}

	public void setUnlockReq(String unlockReq) {
		this.unlockReq = unlockReq;
	}

	public Integer getIsFree() {
		return isFree;
	}

	public void setIsFree(Integer isFree) {
		this.isFree = isFree;
	}

}