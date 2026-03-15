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
@Table(name = "USER_STATS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserStats {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name = "USER_ID", nullable = false)
	private Long userId;
	@Column(name = "LANGUAGE_ID", nullable = false)
	private Long languageId;
	@Column(name = "WORDS_LEARNED")
	private Integer wordsLearned = 0;
	@Column(name = "LESSONS_DONE")
	private Integer lessonsDone = 0;
	@Column(name = "PERFECT_LESS")
	private Integer perfectLess = 0;
	@Column(name = "DAYS_STUDIED")
	private Integer daysStudied = 0;
	@Column(name = "BEST_STREAK")
	private Integer bestStreak = 0;
	@Column(name = "TOTAL_MINS")
	private Integer totalMins = 0;

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

	public Long getLanguageId() {
		return languageId;
	}

	public void setLanguageId(Long languageId) {
		this.languageId = languageId;
	}

	public Integer getWordsLearned() {
		return wordsLearned;
	}

	public void setWordsLearned(Integer wordsLearned) {
		this.wordsLearned = wordsLearned;
	}

	public Integer getLessonsDone() {
		return lessonsDone;
	}

	public void setLessonsDone(Integer lessonsDone) {
		this.lessonsDone = lessonsDone;
	}

	public Integer getPerfectLess() {
		return perfectLess;
	}

	public void setPerfectLess(Integer perfectLess) {
		this.perfectLess = perfectLess;
	}

	public Integer getDaysStudied() {
		return daysStudied;
	}

	public void setDaysStudied(Integer daysStudied) {
		this.daysStudied = daysStudied;
	}

	public Integer getBestStreak() {
		return bestStreak;
	}

	public void setBestStreak(Integer bestStreak) {
		this.bestStreak = bestStreak;
	}

	public Integer getTotalMins() {
		return totalMins;
	}

	public void setTotalMins(Integer totalMins) {
		this.totalMins = totalMins;
	}

}