package com.tlahtolli.api.entity;

import java.time.LocalDateTime;

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
@Table(name = "USER_ENERGY")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserEnergy {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name = "USER_ID", nullable = false, unique = true)
	private Long userId;

	@Column(name = "MAX_ENERGY")
	private Integer maxEnergy = 15;

	@Column(name = "CURRENT_ENRG")
	private Integer currentEnergy = 15;

	@Column(name = "STREAK_COUNT")
	private Integer streakCount = 0;

	@Column(name = "LAST_UPDATE")
	private LocalDateTime lastUpdate;

	@Column(name = "DAILY_USAGE")
	private Integer dailyUsage = 0;

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

	public Integer getMaxEnergy() {
		return maxEnergy;
	}

	public void setMaxEnergy(Integer maxEnergy) {
		this.maxEnergy = maxEnergy;
	}

	public Integer getCurrentEnergy() {
		return currentEnergy;
	}

	public void setCurrentEnergy(Integer currentEnergy) {
		this.currentEnergy = currentEnergy;
	}

	public Integer getStreakCount() {
		return streakCount;
	}

	public void setStreakCount(Integer streakCount) {
		this.streakCount = streakCount;
	}

	public LocalDateTime getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(LocalDateTime lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	public Integer getDailyUsage() {
		return dailyUsage;
	}

	public void setDailyUsage(Integer dailyUsage) {
		this.dailyUsage = dailyUsage;
	}
}