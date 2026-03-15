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
	private Long id;

	@Column(name = "UNIT_ID", nullable = false)
	private Long unitId;

	@Column(name = "LESSON_NUM", nullable = false)
	private Integer lessonNum;

	@Column(name = "TITLE", nullable = false, length = 200)
	private String title;

	@Column(name = "DESCRIPTION", length = 1000)
	private String description;

	@Column(name = "IS_FREE")
	private Integer isFree = 0;

	@Column(name = "XP_REWARD")
	private Integer xpReward = 10;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getUnitId() {
		return unitId;
	}

	public void setUnitId(Long unitId) {
		this.unitId = unitId;
	}

	public Integer getLessonNum() {
		return lessonNum;
	}

	public void setLessonNum(Integer lessonNum) {
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

	public Integer getIsFree() {
		return isFree;
	}

	public void setIsFree(Integer isFree) {
		this.isFree = isFree;
	}

	public Integer getXpReward() {
		return xpReward;
	}

	public void setXpReward(Integer xpReward) {
		this.xpReward = xpReward;
	}

}