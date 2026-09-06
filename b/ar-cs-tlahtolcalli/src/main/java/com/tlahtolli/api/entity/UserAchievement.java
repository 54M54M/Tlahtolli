package com.tlahtolli.api.entity;

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
@Table(name = "USER_ACHIEVEMENTS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserAchievement {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "USER_ID", nullable = false)
	private Integer userId;

	@Column(name = "ACHIEVE_ID", nullable = false)
	private Integer achieveId;

	@Column(name = "EARNED_AT")
	private LocalDate earnedAt;

	// JSON almacenado como String; el frontend lo interpreta
	@Column(name = "PROGRESS", columnDefinition = "TEXT")
	private String progress;

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

	public Integer getAchieveId() {
		return achieveId;
	}

	public void setAchieveId(Integer achieveId) {
		this.achieveId = achieveId;
	}

	public LocalDate getEarnedAt() {
		return earnedAt;
	}

	public void setEarnedAt(LocalDate earnedAt) {
		this.earnedAt = earnedAt;
	}

	public String getProgress() {
		return progress;
	}

	public void setProgress(String progress) {
		this.progress = progress;
	}
}