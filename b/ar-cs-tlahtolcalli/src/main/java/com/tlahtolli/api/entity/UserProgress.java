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
@Table(name = "USER_PROGRESS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserProgress {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "USER_ID", nullable = false)
	private Integer userId;

	@Column(name = "UNIT_ID", nullable = false)
	private Integer unitId;

	@Column(name = "COMPLETED")
	private Short completed = 0; // 0 | 1

	@Column(name = "IS_CURRENT")
	private Short isCurrent = 0; // 0 | 1

	@Column(name = "IS_LOCKED")
	private Short isLocked = 1; // 0 | 1 (por defecto bloqueado)

	@Column(name = "COMPLETED_AT")
	private LocalDate completedAt;

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

	public Short getCompleted() {
		return completed;
	}

	public void setCompleted(Short completed) {
		this.completed = completed;
	}

	public Short getIsCurrent() {
		return isCurrent;
	}

	public void setIsCurrent(Short isCurrent) {
		this.isCurrent = isCurrent;
	}

	public Short getIsLocked() {
		return isLocked;
	}

	public void setIsLocked(Short isLocked) {
		this.isLocked = isLocked;
	}

	public LocalDate getCompletedAt() {
		return completedAt;
	}

	public void setCompletedAt(LocalDate completedAt) {
		this.completedAt = completedAt;
	}
}