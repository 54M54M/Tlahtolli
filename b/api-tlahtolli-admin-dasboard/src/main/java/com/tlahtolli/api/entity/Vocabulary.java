package com.tlahtolli.api.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "VOCABULARY")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Vocabulary {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Long id;

	@Column(name = "LANGUAGE_ID", nullable = false)
	private Long languageId;

	@Column(name = "WORD", nullable = false, length = 500)
	private String word;

	@Column(name = "TRANSLATION", length = 500)
	private String translation;

	@Column(name = "PRONUNCIATION", length = 500)
	private String pronunciation;

	@Column(name = "EXAMPLE", length = 1000)
	private String example;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getLanguageId() {
		return languageId;
	}

	public void setLanguageId(Long languageId) {
		this.languageId = languageId;
	}

	public String getWord() {
		return word;
	}

	public void setWord(String word) {
		this.word = word;
	}

	public String getTranslation() {
		return translation;
	}

	public void setTranslation(String translation) {
		this.translation = translation;
	}

	public String getPronunciation() {
		return pronunciation;
	}

	public void setPronunciation(String pronunciation) {
		this.pronunciation = pronunciation;
	}

	public String getExample() {
		return example;
	}

	public void setExample(String example) {
		this.example = example;
	}

}