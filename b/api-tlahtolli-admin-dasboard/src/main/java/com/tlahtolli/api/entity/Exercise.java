package com.tlahtolli.api.entity;

import jakarta.persistence.*;
import lombok.*;

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

	@Column(name = "UNIT_ID")
	private Long unitId;

	@Column(name = "LESSON_ID")
	private Long lessonId;

	@Column(name = "EXERCISE_TYPE", nullable = false, length = 50)
	private String exerciseType;

	@Column(name = "QUESTION", length = 2000)
	private String question;

	// Para fill-blank: texto con el hueco. Para multiple-choice: la respuesta
	// correcta en texto.
	@Column(name = "ANSWER", length = 2000)
	private String answer;

	// JSON almacenado como String.
	// fill-blank: ["respuesta1", "respuesta2"] (acepta varias)
	// multiple-choice: "Cualli tonalli" (string simple o array)
	@Column(name = "CORRECT_ANS", columnDefinition = "CLOB")
	private String correctAns;

	// JSON con las 4 opciones pregeneradas: ["op1","op2","op3","op4"]
	// Si está vacío, LearningService las construye dinámicamente desde vocabulario.
	@Column(name = "OPTIONS", columnDefinition = "CLOB")
	private String options;

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

	public Long getLessonId() {
		return lessonId;
	}

	public void setLessonId(Long lessonId) {
		this.lessonId = lessonId;
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

	public String getCorrectAns() {
		return correctAns;
	}

	public void setCorrectAns(String correctAns) {
		this.correctAns = correctAns;
	}

	public String getOptions() {
		return options;
	}

	public void setOptions(String options) {
		this.options = options;
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