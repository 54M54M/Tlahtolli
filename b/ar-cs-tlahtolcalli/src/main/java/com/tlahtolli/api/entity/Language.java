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
@Table(name = "CT_LANGUAGES")
public class Language {
 
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
 
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

    /** 'draft' = en pruebas (solo el front de desarrollo con rol tester/admin) · 'published' = público */
    @Builder.Default
    @Column(name = "STATUS", nullable = false, length = 20)
    private String status = STATUS_PUBLISHED;

    public static final String STATUS_DRAFT = "draft";
    public static final String STATUS_PUBLISHED = "published";

    public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public boolean isDraft() {
		return STATUS_DRAFT.equalsIgnoreCase(status);
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
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