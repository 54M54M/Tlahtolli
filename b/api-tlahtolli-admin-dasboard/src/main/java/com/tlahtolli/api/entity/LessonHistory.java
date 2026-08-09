package com.tlahtolli.api.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "LESSON_HISTORY")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LessonHistory {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "USER_ID", nullable = false)
	private Integer userId;

	@Column(name = "UNIT_ID", nullable = false)
	private Integer unitId;

	@Column(name = "LESSON_ID")
	private Integer lessonId;

	@Column(name = "COMPLETED_AT")
	private LocalDate completedAt;

	@Column(name = "PERFORMANCE", precision = 4, scale = 2)
	private BigDecimal performance;

	@Column(name = "TIME_SECONDS")
	private Integer timeSeconds;

	@Column(name = "EARNED_EXP")
	private Integer earnedExp = 0;

	@Column(name = "CORRECT_ANS")
	private Short correctAns = 0;

	@Column(name = "TOTAL_EXERC")
	private Short totalExerc = 0;

	@Column(name = "WAS_PERFECT")
	private Short wasPerfect = 0;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getUserId() {
		return userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public Integer getUnitId() {
		return unitId;
	}

	public void setUnitId(Integer unitId) {
		this.unitId = unitId;
	}

	public Integer getLessonId() {
		return lessonId;
	}

	public void setLessonId(Integer lessonId) {
		this.lessonId = lessonId;
	}

	public LocalDate getCompletedAt() {
		return completedAt;
	}

	public void setCompletedAt(LocalDate completedAt) {
		this.completedAt = completedAt;
	}

	public BigDecimal getPerformance() {
		return performance;
	}

	public void setPerformance(BigDecimal performance) {
		this.performance = performance;
	}

	public Integer getTimeSeconds() {
		return timeSeconds;
	}

	public void setTimeSeconds(Integer timeSeconds) {
		this.timeSeconds = timeSeconds;
	}

	public Integer getEarnedExp() {
		return earnedExp;
	}

	public void setEarnedExp(Integer earnedExp) {
		this.earnedExp = earnedExp;
	}

	public Short getCorrectAns() {
		return correctAns;
	}

	public void setCorrectAns(Short correctAns) {
		this.correctAns = correctAns;
	}

	public Short getTotalExerc() {
		return totalExerc;
	}

	public void setTotalExerc(Short totalExerc) {
		this.totalExerc = totalExerc;
	}

	public Short getWasPerfect() {
		return wasPerfect;
	}

	public void setWasPerfect(Short wasPerfect) {
		this.wasPerfect = wasPerfect;
	}
}