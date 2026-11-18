package com.tlahtolli.api.entity;

import java.time.LocalDateTime;

import jakarta.persistence.*;

/** Token de verificación de correo. Solo se guarda el hash SHA-256, nunca el token. */
@Entity
@Table(name = "TA_EMAIL_TOKENS")
public class EmailToken {

    public static final String VERIFY = "verify";   // verificar el correo de la cuenta
    public static final String CHANGE = "change";   // verificar un correo nuevo (cambio de correo)

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "USER_ID", nullable = false)
    private Integer userId;

    @Column(name = "EMAIL", nullable = false, length = 150)
    private String email;

    @Column(name = "TOKEN_HASH", nullable = false, length = 64, unique = true)
    private String tokenHash;

    @Column(name = "PURPOSE", nullable = false, length = 20)
    private String purpose;

    @Column(name = "EXPIRES_AT", nullable = false)
    private LocalDateTime expiresAt;

    @Column(name = "USED_AT")
    private LocalDateTime usedAt;

    @Column(name = "CREATED_AT", nullable = false)
    private LocalDateTime createdAt = LocalDateTime.now();

    public Integer getId() { return id; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer v) { this.userId = v; }
    public String getEmail() { return email; }
    public void setEmail(String v) { this.email = v; }
    public String getTokenHash() { return tokenHash; }
    public void setTokenHash(String v) { this.tokenHash = v; }
    public String getPurpose() { return purpose; }
    public void setPurpose(String v) { this.purpose = v; }
    public LocalDateTime getExpiresAt() { return expiresAt; }
    public void setExpiresAt(LocalDateTime v) { this.expiresAt = v; }
    public LocalDateTime getUsedAt() { return usedAt; }
    public void setUsedAt(LocalDateTime v) { this.usedAt = v; }
    public LocalDateTime getCreatedAt() { return createdAt; }
}
