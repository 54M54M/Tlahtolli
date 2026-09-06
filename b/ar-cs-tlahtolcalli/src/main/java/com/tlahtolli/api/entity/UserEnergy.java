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
	private Integer id;

	@Column(name = "USER_ID", nullable = false, unique = true)
	private Integer userId;

	@Column(name = "MAX_ENERGY")
	private Short maxEnergy = 15;

	@Column(name = "CURRENT_ENRG")
	private Short currentEnergy = 15;

	@Column(name = "STREAK_COUNT")
	private Short streakCount = 0;

	@Column(name = "LAST_UPDATE")
	private LocalDateTime lastUpdate;

	@Column(name = "DAILY_USAGE")
	private Short dailyUsage = 0;

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

	public Short getMaxEnergy() {
		return maxEnergy;
	}

	public void setMaxEnergy(Short maxEnergy) {
		this.maxEnergy = maxEnergy;
	}

	public Short getCurrentEnergy() {
		return currentEnergy;
	}

	public void setCurrentEnergy(Short currentEnergy) {
		this.currentEnergy = currentEnergy;
	}

	public Short getStreakCount() {
		return streakCount;
	}

	public void setStreakCount(Short streakCount) {
		this.streakCount = streakCount;
	}

	public LocalDateTime getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(LocalDateTime lastUpdate) {
		this.lastUpdate = lastUpdate;
	}

	public Short getDailyUsage() {
		return dailyUsage;
	}

	public void setDailyUsage(Short dailyUsage) {
		this.dailyUsage = dailyUsage;
	}
}