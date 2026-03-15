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

@Data 
@NoArgsConstructor 
@AllArgsConstructor
@Builder
@Entity
@Table(name = "LANGUAGES")
public class Language {
 
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
 
    @Column(name = "CODE", nullable = false, unique = true, length = 10)
    private String code;
 
    @Column(name = "LANG_NAME", nullable = false, length = 100)
    private String langName;
 
    @Column(name = "NATIVE_NAME", length = 100)
    private String nativeName;
 
    @Column(name = "COLOR", length = 20)
    private String color;
 
    @Column(name = "FLAG", length = 10)
    private String flag;
 
    @Column(name = "FAMILY", length = 100)
    private String family;
 
    @Column(name = "WRITING_SYSTEM", length = 20)
    private String writingSystem;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getLangName() {
		return langName;
	}

	public void setLangName(String langName) {
		this.langName = langName;
	}

	public String getNativeName() {
		return nativeName;
	}

	public void setNativeName(String nativeName) {
		this.nativeName = nativeName;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public String getFlag() {
		return flag;
	}

	public void setFlag(String flag) {
		this.flag = flag;
	}

	public String getFamily() {
		return family;
	}

	public void setFamily(String family) {
		this.family = family;
	}

	public String getWritingSystem() {
		return writingSystem;
	}

	public void setWritingSystem(String writingSystem) {
		this.writingSystem = writingSystem;
	}

    
    
}