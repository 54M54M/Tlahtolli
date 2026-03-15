package com.tlahtolli.api.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;

@Data 
@NoArgsConstructor 
@AllArgsConstructor
@Builder
@Entity
@Table(name = "USERS")
public class User {
 
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
 
    @Column(name = "USERNAME", nullable = false, unique = true, length = 50)
    private String username;
 
    @Column(name = "FULL_NAME", nullable = false, length = 100)
    private String fullName;
 
    @Column(name = "EMAIL", nullable = false, unique = true, length = 150)
    private String email;
 
    @Column(name = "USER_LEVEL")
    private Integer userLevel = 1;
 
    @Column(name = "XP")
    private Long xp = 0L;
 
    @Column(name = "TOTAL_XP")
    private Long totalXp = 0L;
 
    @Column(name = "STREAK")
    private Integer streak = 0;
 
    @Column(name = "JOIN_DATE")
    private LocalDate joinDate;
 
    @Column(name = "CURRENT_LANG")
    private Long currentLang;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
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

	public Integer getUserLevel() {
		return userLevel;
	}

	public void setUserLevel(Integer userLevel) {
		this.userLevel = userLevel;
	}

	public Long getXp() {
		return xp;
	}

	public void setXp(Long xp) {
		this.xp = xp;
	}

	public Long getTotalXp() {
		return totalXp;
	}

	public void setTotalXp(Long totalXp) {
		this.totalXp = totalXp;
	}

	public Integer getStreak() {
		return streak;
	}

	public void setStreak(Integer streak) {
		this.streak = streak;
	}

	public LocalDate getJoinDate() {
		return joinDate;
	}

	public void setJoinDate(LocalDate joinDate) {
		this.joinDate = joinDate;
	}

	public Long getCurrentLang() {
		return currentLang;
	}

	public void setCurrentLang(Long currentLang) {
		this.currentLang = currentLang;
	}
        
}