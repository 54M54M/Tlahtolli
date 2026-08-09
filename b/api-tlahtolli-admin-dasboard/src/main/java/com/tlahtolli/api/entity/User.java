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
        
}