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
@Table(name = "WRITING_SYSTEMS")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WritingSystem {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "LANGUAGE_ID", nullable = false)
	private Integer languageId;

	// 'syllabary' | 'alphabet' | 'logogram' | 'abugida'
	@Column(name = "SYSTEM_TYPE", nullable = false, length = 30)
	private String systemType;

	@Column(name = "SYSTEM_NAME", length = 200)
	private String systemName;

	@Column(name = "DESCRIPTION", length = 1000)
	private String description;

	// JSON con el array de caracteres / sílabas
	@Column(name = "CHARACTERS", columnDefinition = "TEXT")
	private String characters;

	@Column(name = "RULES", columnDefinition = "TEXT")
	private String rules;

	@Column(name = "NOTES", columnDefinition = "TEXT")
	private String notes;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public Integer getLanguageId() {
		return languageId;
	}

	public void setLanguageId(Integer languageId) {
		this.languageId = languageId;
	}

	public String getSystemType() {
		return systemType;
	}

	public void setSystemType(String systemType) {
		this.systemType = systemType;
	}

	public String getSystemName() {
		return systemName;
	}

	public void setSystemName(String systemName) {
		this.systemName = systemName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getCharacters() {
		return characters;
	}

	public void setCharacters(String characters) {
		this.characters = characters;
	}

	public String getRules() {
		return rules;
	}

	public void setRules(String rules) {
		this.rules = rules;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}
}