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
@Table(name = "ACHIEVEMENTS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Achievement {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "TITLE", nullable = false, length = 200)
	private String title;

	@Column(name = "DESCRIPTION", length = 1000)
	private String description;

	@Column(name = "ICON", length = 200)
	private String icon;

	@Column(name = "XP_REWARD")
	private Integer xpReward = 0;

	@Column(name = "REQUIREMENT", length = 500)
	private String requirement;

	@Column(name = "CATEGORY", length = 100)
	private String category;

	@Column(name = "RARITY", length = 50)
	private String rarity;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
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

	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}

	public Integer getXpReward() {
		return xpReward;
	}

	public void setXpReward(Integer xpReward) {
		this.xpReward = xpReward;
	}

	public String getRequirement() {
		return requirement;
	}

	public void setRequirement(String requirement) {
		this.requirement = requirement;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getRarity() {
		return rarity;
	}

	public void setRarity(String rarity) {
		this.rarity = rarity;
	}

}
