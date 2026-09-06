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
@Table(name = "LESSONS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Lesson {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "UNIT_ID", nullable = false)
	private Integer unitId;

	@Column(name = "LESSON_NUM", nullable = false)
	private Short lessonNum;

	@Column(name = "TITLE", nullable = false, length = 200)
	private String title;

	@Column(name = "DESCRIPTION", length = 1000)
	private String description;

	@Column(name = "IS_FREE")
	private Short isFree = 0;

	@Column(name = "XP_REWARD")
	private Integer xpReward = 10;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getUnitId() {
		return unitId;
	}

	public void setUnitId(Integer unitId) {
		this.unitId = unitId;
	}

	public Short getLessonNum() {
		return lessonNum;
	}

	public void setLessonNum(Short lessonNum) {
		this.lessonNum = lessonNum;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Short getIsFree() {
		return isFree;
	}

	public void setIsFree(Short isFree) {
		this.isFree = isFree;
	}

	public Integer getXpReward() {
		return xpReward;
	}

	public void setXpReward(Integer xpReward) {
		this.xpReward = xpReward;
	}

}