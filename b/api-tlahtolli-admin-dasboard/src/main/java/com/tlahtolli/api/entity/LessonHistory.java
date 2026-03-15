package com.tlahtolli.api.entity;

import java.math.BigDecimal;
import java.time.LocalDate;

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
@Table(name = "LESSON_HISTORY")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class LessonHistory {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name = "USER_ID", nullable = false)
	private Long userId;
	@Column(name = "UNIT_ID", nullable = false)
	private Long unitId;
	@Column(name = "COMPLETED_AT")
	private LocalDate completedAt;
	@Column(name = "PERFORMANCE", precision = 4, scale = 2)
	private BigDecimal performance;
	@Column(name = "TIME_SECONDS")
	private Long timeSeconds;
	@Column(name = "EARNED_EXP")
	private Integer earnedExp = 0;
	@Column(name = "CORRECT_ANS")
	private Integer correctAns = 0;
	@Column(name = "TOTAL_EXERC")
	private Integer totalExerc = 0;
	@Column(name = "WAS_PERFECT")
	private Integer wasPerfect = 0;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public Long getUnitId() {
		return unitId;
	}

	public void setUnitId(Long unitId) {
		this.unitId = unitId;
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

	public Long getTimeSeconds() {
		return timeSeconds;
	}

	public void setTimeSeconds(Long timeSeconds) {
		this.timeSeconds = timeSeconds;
	}

	public Integer getEarnedExp() {
		return earnedExp;
	}

	public void setEarnedExp(Integer earnedExp) {
		this.earnedExp = earnedExp;
	}

	public Integer getCorrectAns() {
		return correctAns;
	}

	public void setCorrectAns(Integer correctAns) {
		this.correctAns = correctAns;
	}

	public Integer getTotalExerc() {
		return totalExerc;
	}

	public void setTotalExerc(Integer totalExerc) {
		this.totalExerc = totalExerc;
	}

	public Integer getWasPerfect() {
		return wasPerfect;
	}

	public void setWasPerfect(Integer wasPerfect) {
		this.wasPerfect = wasPerfect;
	}

}