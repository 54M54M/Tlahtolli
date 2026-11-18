package com.tlahtolli.api.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data 
@NoArgsConstructor 
@AllArgsConstructor
@Builder
@Entity
@Table(name = "TA_USERS")
public class User {
 
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
 
    @Column(name = "USERNAME", nullable = false, unique = true, length = 50)
    private String username;
 
    @Column(name = "FULL_NAME", nullable = false, length = 100)
    private String fullName;
 
    @Column(name = "EMAIL", nullable = false, unique = true, length = 150)
    private String email;
 
    @Column(name = "USER_LEVEL")
    private Short userLevel = 1;
 
    @Column(name = "XP")
    private Integer xp = 0;
 
    @Column(name = "TOTAL_XP")
    private Integer totalXp = 0;
 
    @Column(name = "STREAK")
    private Short streak = 0;
 
    @Column(name = "JOIN_DATE")
    private LocalDate joinDate;
 
    @Column(name = "CURRENT_LANG")
    private Integer currentLang;

    /** null en cuentas creadas con Google que aún no tienen contraseña. */
    @Column(name = "PASSWORD_HASH", length = 255)
    private String passwordHash;

    /** 'user' o 'admin'. Solo se cambia desde la base de datos, nunca desde la API. */
    @Column(name = "ROLE", nullable = false, length = 20)
    private String role = "user";

    /** El correo actual está verificado. */
    @Column(name = "EMAIL_VERIFIED", nullable = false)
    private Boolean emailVerified = false;

    @Column(name = "EMAIL_VERIFIED_AT")
    private LocalDateTime emailVerifiedAt;

    /** Correo nuevo pedido en "editar perfil"; se vuelve el correo de la cuenta al verificarlo. */
    @Column(name = "PENDING_EMAIL", length = 150)
    private String pendingEmail;

    /** Último cambio de nombre de usuario (tiempo de espera entre cambios). */
    @Column(name = "USERNAME_CHANGED_AT")
    private LocalDateTime usernameChangedAt;

    /** Id estable de la cuenta de Google (claim "sub"); null si nunca entró con Google. */
    @Column(name = "GOOGLE_SUB", unique = true, length = 255)
    private String googleSub;

    /** Cuenta creada con Google: debe confirmar o cambiar su usuario generado (sin tiempo de espera). */
    @Column(name = "MUST_PICK_USERNAME", nullable = false)
    private Boolean mustPickUsername = false;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public Short getUserLevel() {
		return userLevel;
	}

	public void setUserLevel(Short userLevel) {
		this.userLevel = userLevel;
	}

	public Integer getXp() {
		return xp;
	}

	public void setXp(Integer xp) {
		this.xp = xp;
	}

	public Integer getTotalXp() {
		return totalXp;
	}

	public void setTotalXp(Integer totalXp) {
		this.totalXp = totalXp;
	}

	public Short getStreak() {
		return streak;
	}

	public void setStreak(Short streak) {
		this.streak = streak;
	}

	public LocalDate getJoinDate() {
		return joinDate;
	}

	public void setJoinDate(LocalDate joinDate) {
		this.joinDate = joinDate;
	}

	public Integer getCurrentLang() {
		return currentLang;
	}

	public void setCurrentLang(Integer currentLang) {
		this.currentLang = currentLang;
	}

	public String getPasswordHash() {
		return passwordHash;
	}

	public void setPasswordHash(String passwordHash) {
		this.passwordHash = passwordHash;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public boolean isAdmin() {
		return "admin".equalsIgnoreCase(role);
	}

	public Boolean getEmailVerified() { return emailVerified; }
	public void setEmailVerified(Boolean v) { this.emailVerified = v; }
	public LocalDateTime getEmailVerifiedAt() { return emailVerifiedAt; }
	public void setEmailVerifiedAt(LocalDateTime v) { this.emailVerifiedAt = v; }
	public String getPendingEmail() { return pendingEmail; }
	public void setPendingEmail(String v) { this.pendingEmail = v; }
	public LocalDateTime getUsernameChangedAt() { return usernameChangedAt; }
	public void setUsernameChangedAt(LocalDateTime v) { this.usernameChangedAt = v; }
	public boolean isEmailVerified() { return Boolean.TRUE.equals(emailVerified); }
	public String getGoogleSub() { return googleSub; }
	public void setGoogleSub(String v) { this.googleSub = v; }
	public Boolean getMustPickUsername() { return mustPickUsername; }
	public void setMustPickUsername(Boolean v) { this.mustPickUsername = v; }
	public boolean isMustPickUsername() { return Boolean.TRUE.equals(mustPickUsername); }
	public boolean hasPassword() { return passwordHash != null && !passwordHash.isBlank(); }
        
}