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

/*

[{"type":"vowel","letter":"a","pronunciation":"a"},{"type":"vowel","letter":"e","pronunciation":"e"},{"type":"vowel","letter":"i","pronunciation":"i"},{"type":"vowel","letter":"o","pronunciation":"o"},

{"type":"consonant","letter":"c","pronunciation":"k, s","syllables":{"a":"ca (ka)","e":"ce (se)","i":"ci (si)","o":"co (ko)","u":null}},
{"type":"consonant","letter":"h","pronunciation":"j","syllables":{"a":null,"e":null,"i":null,"o":null,"u":null}}, [ SI SE MANDAN EN NULL SE MUESTRA EL CONTAINER, SI SE ELMIMNA LA FILA/COLUMNA NO SE MUESTRA EL CONTAINER ]
{"type":"consonant","letter":"l","pronunciation":"l","syllables":{"a":"la","e":"le","i":"li","o":"lo","u":null}},
{"type":"consonant","letter":"m","pronunciation":"m","syllables":{"a":"ma","e":"me","i":"mi","o":"mo","u":null}},
{"type":"consonant","letter":"n","pronunciation":"n","syllables":{"a":"na","e":"ne","i":"ni","o":"no","u":null}},
{"type":"consonant","letter":"p","pronunciation":"p","syllables":{"a":"pa","e":"pe","i":"pi","o":"po","u":null}},
{"type":"consonant","letter":"t","pronunciation":"t","syllables":{"a":"ta","e":"te","i":"ti","o":"to","u":null}},

{"type":"consonant","letter":"tl","pronunciation":"tl","syllables":{"a":"za (sa)","e":null,"i":null,"o":"zo (so)","u":null}},

{"type":"consonant","letter":"x","pronunciation":"sh","syllables":{"a":"xa (sha)","e":"xe (she)","i":"xi (shi)","o":"xo (sho)","u":null}},
{"type":"consonant","letter":"y","pronunciation":"y","syllables":{"a":"ya","e":"ye","i":null,"o":"yo","u":null}},
{"type":"consonant","letter":"z","pronunciation":"s","syllables":{"a":"za (sa)","e":null,"i":null,"o":"zo (so)","u":null}},

{"type":"digraph","letter":"tl","pronunciation":"tl","syllables":{"a":"tla","e":"tle","i":"tli","o":"tlo","u":null}},
{"type":"digraph","letter":"tz","pronunciation":"ts","syllables":{"a":"tza (tsa)","e":"tze (tse)","i":"tzi (tsi)","o":"tzo (tso)","u":null}},
{"type":"digraph","letter":"ch","pronunciation":"ch","syllables":{"a":"cha","e":"che","i":"chi","o":"cho","u":null}},
{"type":"digraph","letter":"qu","pronunciation":"k","syllables":{"a":null,"e":"que (ke)","i":"qui (ki)","o":null,"u":null}},
{"type":"digraph","letter":"hu","pronunciation":"w","syllables":{"a":"hua (wa)","e":"hue (we)","i":"hui (wi)","o":null,"u":null}},

{"type":"longVowel","letter":"ā","pronunciation":"aa"},
{"type":"longVowel","letter":"ē","pronunciation":"ee"},
{"type":"longVowel","letter":"ī","pronunciation":"ii"},
{"type":"longVowel","letter":"ō","pronunciation":"oo"}]

*/