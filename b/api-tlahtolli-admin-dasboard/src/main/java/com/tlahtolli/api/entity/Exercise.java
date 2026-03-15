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
@Table(name = "EXERCISES")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Exercise {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name = "UNIT_ID", nullable = false)
	private Long unitId;

	@Column(name = "EXERCISE_TYPE", nullable = false, length = 50)
	private String exerciseType;

	@Column(name = "QUESTION", length = 2000)
	private String question;

	@Column(name = "ANSWER", length = 2000)
	private String answer;

	@Column(name = "EXPLANATION", length = 2000)
	private String explanation;

	@Column(name = "POINTS")
	private Integer points = 10;

	@Column(name = "DIFFICULTY", length = 20)
	private String difficulty;

	@Column(name = "CHARACTER_REF", length = 100)
	private String characterRef;

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

	public String getExerciseType() {
		return exerciseType;
	}

	public void setExerciseType(String exerciseType) {
		this.exerciseType = exerciseType;
	}

	public String getQuestion() {
		return question;
	}

	public void setQuestion(String question) {
		this.question = question;
	}

	public String getAnswer() {
		return answer;
	}

	public void setAnswer(String answer) {
		this.answer = answer;
	}

	public String getExplanation() {
		return explanation;
	}

	public void setExplanation(String explanation) {
		this.explanation = explanation;
	}

	public Integer getPoints() {
		return points;
	}

	public void setPoints(Integer points) {
		this.points = points;
	}

	public String getDifficulty() {
		return difficulty;
	}

	public void setDifficulty(String difficulty) {
		this.difficulty = difficulty;
	}

	public String getCharacterRef() {
		return characterRef;
	}

	public void setCharacterRef(String characterRef) {
		this.characterRef = characterRef;
	}

}
