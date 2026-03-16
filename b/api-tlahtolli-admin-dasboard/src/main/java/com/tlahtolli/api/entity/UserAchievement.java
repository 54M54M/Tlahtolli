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
	private Long id;

	@Column(name = "USER_ID", nullable = false)
	private Long userId;

	@Column(name = "ACHIEVE_ID", nullable = false)
	private Long achieveId;

	@Column(name = "EARNED_AT")
	private LocalDate earnedAt;

	// JSON almacenado como String; el frontend lo interpreta
	@Column(name = "PROGRESS", columnDefinition = "CLOB")
	private String progress;

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

	public Long getAchieveId() {
		return achieveId;
	}

	public void setAchieveId(Long achieveId) {
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